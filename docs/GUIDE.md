# CHGame libretro core: RetroArch guide

The CHGame libretro core plays CHGame `.CHG` games in RetroArch on Android (arm64) and on
Windows. It is a thin libretro front end around joyrider3774's CHGame Emulator, which models the
whole board at the cycle level, so games play as they do on the real handheld. This guide covers
installing it in RetroArch on Android and on Windows, and starting it from ES-DE.

The same emulator as an Android app with its own game list, save states and ES-DE media maker:
[CHGamePlayer](https://github.com/jadflat/CHGamePlayer). The core's saves and the app's are kept apart, but a game's own save
(`<game>.sav`) is the same format in both.

Release files: `chgame_libretro_android.so` (Android), `chgame_libretro.dll` (Windows),
`chgame_libretro.info` (the core's name and details in RetroArch) and `frontends/es_systems.xml`
(ES-DE).

Your games:
- **`.CHG`**: a game, for example `Starlift.CHG` or `CHix.CHG`.
- **`.DAT`**: data a game reads from the SD card, for example `STARLIFT.DAT`. Only some games
  have one, and a game that needs one won't start properly without it. STARLIFT shows
  *NEED STARLIFT.DAT*.

No games are included.

---

## RetroArch on Android

### 1. Install RetroArch from the website
RetroArch's own site marks the Google Play versions as out of date and recommends its website
APK. ES-DE also warns against the Play version.

1. If *RetroArch* or *RetroArch Plus* from the Play Store is installed, uninstall it.
   *RetroArch Plus* has the same package name as the 64-bit website build, so the two clash.
2. Download **`RetroArch_aarch64.apk`** (the 64-bit build, package `com.retroarch.aarch64`)
   from <https://www.retroarch.com/?page=platforms>, Android section. 1.22.2 was current on
   28 Oct 2026. Install it like any APK.
3. Start RetroArch once, allow its storage access, and let it finish setting up. Its folders
   are then at `/storage/emulated/0/RetroArch/`.

### 2. The info file
RetroArch keeps core info files inside the app, where you can't copy to without root, so give
it a folder you can write to:

1. Make the folder `/storage/emulated/0/RetroArch/info`.
2. In RetroArch: **Settings → Directory → Core Info**, browse to that folder, and choose
   **<Use This Directory>**.
3. Copy `chgame_libretro.info` into it.
4. **Main Menu → Online Updater → Update Core Info Files**. The other cores' info files are
   downloaded into the new folder, so they keep their names too.

### 3. The core
1. Copy `chgame_libretro_android.so` into `/storage/emulated/0/RetroArch/downloads/`. Keep the
   name exactly as it is.
2. In RetroArch: **Main Menu → Load Core → Install or Restore a Core**, then pick
   `chgame_libretro_android.so`. RetroArch copies it into its own cores folder.
3. **Load Core** now lists **CHGame (CHGame Retro)**.

### 4. The SD card folder
Copy the `.DAT` files into:

    /storage/emulated/0/RetroArch/system/chgame/sdcard/

If the folder isn't there, make it (the core also makes it the first time a game starts). Every
game shares this one folder, as games share one card on a CHGame. A file a game writes to the
card is written back here every few seconds and when you close the game.

### 5. Play
**Load Core → CHGame**, then **Load Content**, and pick a `.CHG`. Or load the `.CHG` first and
pick CHGame when RetroArch asks which core to use.

| CHGame button | RetroPad (RetroArch's controller) |
|---|---|
| D-pad | d-pad or left stick |
| A | A, the **right** face button |
| B | B, the **bottom** face button |
| START / SELECT | Start / Select |

To change it: **Quick Menu → Controls → Port 1 Controls**.

**Core options** (Quick Menu → Core Options):

| Option | Choices | |
|---|---|---|
| Sound | bare pin / piezo | *bare pin* is the buzzer pin's signal (the emulator's default); *piezo* imitates the small speaker |
| Volume | 10% to 150% | default 50% |
| microSD card | folder / off | *off* runs with no card |
| Internal upscale (nearest) | 1x to 6x | sends a bigger picture with sharp pixels, for shaders that need it. Otherwise leave it at 1x and turn on **Settings → Video → Scaling → Integer Scale** |

**Saves:** a game's own saves go to `/storage/emulated/0/RetroArch/saves/` (RetroArch may sort
them into a `CHGame` subfolder) as `<game>.sav`. **Save states** work as usual (Quick Menu →
Save State), at about 1 MB each. A state holds the whole machine but not the files on the SD card.

---

## RetroArch on Windows

1. Copy `chgame_libretro.dll` into RetroArch's `cores` folder and `chgame_libretro.info` into
   its `info` folder (for example `C:\RetroArch-Win64\cores` and `...\info`).
2. Put `.DAT` files in `<RetroArch>\system\chgame\sdcard\`.
3. **Load Core → CHGame**, then **Load Content**. The buttons and options are as in *RetroArch on Android* above.

It runs at about 6-7x real time on one core of a mid-range laptop CPU, so any PC that runs
RetroArch is fast enough.

---

## ES-DE

ES-DE shows your games in one menu and starts RetroArch with this core.

1. Copy `frontends/es_systems.xml` to `ES-DE/custom_systems/` (if you already have an
   `es_systems.xml` there, paste its `<system>` block inside your `<systemList>` instead).
2. Put the games in `ROMs/chgame`, and the `.DAT` files in RetroArch's
   `system/chgame/sdcard/` folder, as above.
3. Restart ES-DE.

The command starts RetroArch with the installed core,
`/data/user/0/com.retroarch.aarch64/cores/chgame_libretro_android.so`, so install the core in
RetroArch first. Quit through RetroArch's menu (**Quick Menu -> Close Content**, then **Quit
RetroArch**, or your exit hotkey).

---

## Speed

Measured on a Retroid Pocket Nova (CHGame Player's speed line, at 60 frames a second, which is
full speed): STARLIFT takes about 2.5 ms a frame, CHix 2.1 ms and Another World 1.4 ms, out of the
16.7 ms a frame has. The sound on the Nova has been listened to and is good. *Options → Speed
overlay* shows the figures in a game. On a PC the core runs 6-7 times faster than real time on one core.

## Credits

CHGame Emulator by **joyrider3774** (MIT): all of the emulation.
CHGame by **Kevin Bates** (bateske, https://chgame.website; Apache-2.0); the bootloader embedded in
the emulator is MIT. RetroArch and libretro by the libretro team. ES-DE by Leon Styhre. The libretro core
and this guide: jadflat.
