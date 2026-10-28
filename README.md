# CHGame libretro core

A RetroArch (libretro) core for CHGame handheld games (`.CHG` files), for Android (arm64) and
Windows. It is a thin libretro front end, `libretro/libretro.c`, around joyrider3774's
[CHGame Emulator](https://github.com/joyrider3774/chgame_emulator), which models the whole
board at the cycle level: the CH32X035 RISC-V CPU, interrupts, timers, SPI and DMA, the ST7735
screen, the buzzer, the microSD card and the real bootloader.

| | |
|---|---|
| Content | `.chg` (also `.bin`, `.hex`, `.elf`) |
| Video | 128 x 128, 60 frames a second, aspect 1:1; an option sends it at 2x-6x, nearest neighbour |
| Audio | the buzzer at 48 kHz: the bare pin signal or a piezo-like filter, volume |
| Saves | the flash pages a game writes, as `<game>.sav` in RetroArch's save folder |
| Save states | yes |
| SD card | the folder `<system>/chgame/sdcard/`: put `.DAT` files there |
| Buttons | d-pad or left stick, A (right face button), B (bottom), Start, Select |

**Download:** `chgame_libretro_android.so`, `chgame_libretro.dll` and `chgame_libretro.info`
are on the [releases page](../../releases). Installing them (RetroArch on Android and Windows,
ES-DE, Daijisho): [docs/GUIDE.md](docs/GUIDE.md).

The same emulator as an Android app with its own game list: [CHGamePlayer](https://github.com/jadflat/CHGamePlayer).

## Building

On Windows with `zig` on the PATH (no make needed; `Makefile` holds the same Windows recipe):

    ./build.sh windows    # build/chgame_libretro.dll
    ./build.sh android    # build/chgame_libretro_android.so (Android arm64)
    ./build.sh harness    # build/harness.exe, a test front end

zig has no Android C library, so the Android build compiles against zig's musl headers, links
no C library of its own and names `libc.so`, `libm.so` and `libdl.so` through empty stubs;
`libretro/android_shim.c` maps musl's `__errno_location` to bionic's `__errno`.
`tools/elfcheck.py` checks the result. Android 6 or newer.

    build/harness.exe build/chgame_libretro.dll game.CHG 10 outdir --sys sysdir --save savedir

runs a game headless, writes a frame a second and the sound, and prints the speed. On a PC the
core runs 6-7 times faster than real time on one core.

## Credits and licences

- **CHGame Emulator** by joyrider3774, MIT licence (`emu/LICENSE`): all of the emulation, unchanged
  at the commit in `EMULATOR_VERSION.txt`.
- **CHGame** by Kevin Bates (bateske), https://chgame.website, Apache-2.0. The bootloader embedded
  in the emulator is MIT.
- `libretro/libretro.h` from libretro-common, by the RetroArch team (MIT-style licence in the file).
- The libretro wrapper and tools: jadflat, MIT licence (`LICENSE`). See `NOTICE`.
