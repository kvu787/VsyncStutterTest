I’ll inspect both capture directories to identify the PresentMon files and their formats, then compare frame pacing, latency, dropped/late frames, and any monitor-placement-related differences.

The supplied folders aren’t resolving through the workspace-relative path, so I’ll check the project root and locate the exact directory names before reading the captures.

`MyLogOutput` appears empty through the file index, which can happen for ignored/generated captures. I’ll inspect it directly from the shell and enumerate the files without modifying anything.

Both captures are present but ignored by the editor index. I’ll now inspect their schemas, row counts, processes, display modes, and capture durations so the statistical comparison uses the right frame stream.

The schema is standard PresentMon 2.x and both files contain the game process. I’ll compute distribution statistics and event counts with the same thresholds for both sessions, including present cadence, display cadence, Present API blocking, render latency, CPU/GPU timing, and presentation-mode changes.

The first pass already shows the dominant difference: the overlay capture is mostly `Composed: Flip`, while the separate-window capture is almost entirely `Hardware: Independent Flip`. I’ll break the data down by mode and timeline to distinguish that sustained behavior from startup/shutdown outliers and quantify the resulting 8.33/16.67 ms cadence.

The sustained sections confirm a 100 FPS app cadence. With the overlay, displayed frames are quantized mainly to 8.33/16.67 ms; with the monitor in another window, displayed frames track the app near 10 ms. I’ll check the project notes for the intended refresh/VRR setup, then calculate a final apples-to-apples sustained-period table.

## Conclusion

**Running Intel PresentMon as an in-game overlay substantially degrades displayed frame pacing and latency.** Running it in a separate window on the secondary monitor preserves smooth, low-latency presentation.

The game itself maintains essentially identical **100 FPS simulation and present pacing** in both sessions. The difference occurs **after the game submits each frame**:

- **Overlay:** forces the game into `Composed: Flip`, apparently preventing the normal independent-flip/VRR path.
- **Separate window:** preserves `Hardware: Independent Flip`, with displayed frames following the game’s 10 ms cadence.

This points to a **Windows composition/display scheduling effect**, not meaningful CPU or GPU contention from PresentMon.

## Sustained-period comparison

I excluded startup, shutdown, and presentation-mode transitions:

- Overlay: 4.0–27.5 seconds, sustained `Composed: Flip`
- Separate window: 4.5–43.0 seconds, sustained `Hardware: Independent Flip`

| Metric | Overlay on game | Separate window |
|---|---:|---:|
| Effective frame rate | 100.000 FPS | 99.999 FPS |
| Presentation mode | Composed Flip | Independent Flip |
| Tearing/VRR-capable path | No | Yes |
| App present interval, median | 9.9998 ms | 9.9994 ms |
| App present interval, p95 | 10.1659 ms | 10.1267 ms |
| Display interval, median | **8.3381 ms** | **10.0000 ms** |
| Display interval, p95 | **16.6784 ms** | **10.1356 ms** |
| Absolute animation error, median | **1.6723 ms** | **0.0537 ms** |
| Absolute animation error, p95 | **6.6794 ms** | **0.1881 ms** |
| Time until displayed, median | **23.6853 ms** | **9.9277 ms** |
| Time until displayed, p95 | **30.3395 ms** | **10.0657 ms** |
| Input-to-photon, median | **25.7874 ms** | **11.7760 ms** |
| Input-to-photon, p95 | **32.5104 ms** | **17.7826 ms** |
| CPU busy, mean | 0.2816 ms | 0.2776 ms |
| GPU busy, mean | 0.6464 ms | 0.5333 ms |

The input-to-photon values are sampled less frequently—875 overlay samples and 617 separate-window samples—but they support the same latency difference.

## What the overlay does to frame delivery

During the sustained overlay section, displayed intervals were:

- **77.9%:** between 7 and 9 ms, centered near 8.33 ms
- **19.5%:** between 15 and 18 ms, centered near 16.67 ms
- Only **0.68%:** between 9 and 11 ms

That is approximately a repeating pattern of four short display intervals followed by one long interval:

```text
8.33, 8.33, 8.33, 8.33, 16.67 ms
```

The mean still works out to 10 ms, so an average FPS counter continues to report 100 FPS. However, the individual frames are not displayed every 10 ms. Roughly every fifth frame is held for an extra refresh interval, producing a regular **20 Hz cadence disturbance**.

The 8.33/16.67 ms quantization is consistent with the 100 FPS stream being mapped to an effective fixed **120 Hz composition cadence**. That refresh rate is inferred from the intervals, not directly reported by the CSV.

With PresentMon in a separate window:

- **100%** of sustained display intervals were between 9 and 11 ms.
- Display p95 was 10.136 ms.
- The worst sustained display interval was only 10.543 ms.
- No sustained frame had more than 1 ms of animation error.

That is excellent VRR-style conformance to the game’s 100 FPS output.

## Presentation-mode timeline

### Overlay session

- At 0.676–2.334 seconds: `Hardware: Independent Flip`, tearing allowed
- At 2.343–3.624 seconds: independent flip with `SyncInterval=1`
- At **3.634 seconds:** changed to `Composed: Flip`
- Remained composed until the capture ended at 28.072 seconds

Overall:

- `Composed: Flip`: **89.24%**
- `Hardware: Independent Flip`: **10.76%**, almost entirely during startup

### Separate-window session

- At **4.224 seconds:** entered `Hardware: Independent Flip`, tearing allowed
- Remained there continuously until 43.681 seconds
- Returned to composed mode only near shutdown

Overall:

- `Hardware: Independent Flip`: **96.94%**
- Independent flip with tearing allowed: **93.47%**
- `Composed: Flip`: only **3.06%**, primarily startup/shutdown

This timing strongly associates the overlay with losing independent flip.

## Latency interpretation

Rendering and Present API timing are almost unchanged:

- Present API median: 9.749 ms overlay versus 9.738 ms separate
- Render-present latency median: 9.852 ms versus 9.877 ms
- CPU busy time is effectively identical
- Overlay GPU overhead is only about 0.11 ms of additional busy time

The major increase is in `MsUntilDisplayed`:

- Overlay median: **23.69 ms**
- Separate window median: **9.93 ms**
- Difference: approximately **+13.76 ms**

Therefore, the additional latency accumulates **after rendering/present submission**, while the frame waits for compositor/display scheduling.

## Actual stutters and outliers

Both full captures contain similar startup outliers around 30–52 ms. Those should not be used to judge steady-state smoothness.

In the sustained periods:

- **Overlay app pacing:** one present exceeded 12.5 ms, with a 13.459 ms maximum.
- **Separate-window app pacing:** no presents exceeded 12.5 ms, with a 10.543 ms maximum.
- **Overlay display pacing:** 470 display intervals exceeded 12.5 ms in 23.49 seconds—about 20 per second, mostly the regular 16.67 ms cadence.
- The overlay also had one isolated **20.165 ms** display gap at 26.802 seconds.
- **Separate-window display pacing:** no display intervals exceeded 12.5 ms.

So there is little evidence of sustained **game-side frame generation stutter** in either run. The overlay’s visible issue is overwhelmingly regular compositor cadence/judder, plus one isolated larger display gap.

## Recommendation

Use Intel PresentMon in a separate window on the secondary monitor for visual evaluation. The in-game overlay changes the presentation path enough that it is **not observationally neutral**: it can introduce judder and roughly 14 ms of additional display/input latency even while reporting a stable 100 FPS.

For stronger causal confirmation, toggle the overlay on and off during one continuous capture. If `PresentMode` immediately alternates between `Hardware: Independent Flip` and `Composed: Flip`, with display cadence changing between 10 ms and 8.33/16.67 ms, that would isolate the overlay as the direct trigger.