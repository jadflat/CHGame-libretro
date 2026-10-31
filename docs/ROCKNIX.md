# CHGame on ROCKNIX (Anbernic RG handhelds)

How to add the CHGame RetroArch core to a ROCKNIX handheld (here the H700
board, on the network as `\\H700`), give it a "CHGame" system in
EmulationStation and set up box art and videos.

## 0. The core file

ROCKNIX is aarch64 Linux with glibc. The `chgame_libretro_android.so` in
`build/` is linked for Android (musl stubs) and will most likely not load.
Build a Linux one:

```bash
./build.sh linux-arm64
```

The result is `build/chgame_libretro.so`; the release has it ready built.

## 1. Copy the core

ROCKNIX's system cores live in a read-only folder. User cores go in the
`config` share:

| What | Where (from the PC) | Path on the device |
|---|---|---|
| core | `\\H700\config\retroarch\cores\chgame_libretro.so` | `/storage/.config/retroarch/cores/` |
| core info | `\\H700\config\retroarch\cores\chgame_libretro.info` | same folder |

If RetroArch doesn't see it: Main Menu → Settings → Directory → Cores,
and check which folder it points at; put the two files there.

## 2. Copy the games

Make `\\H700\games-roms\chgame\` and copy every `.CHG` into it. Games that
use an SD data file need their `.DAT` next to the `.CHG`, with the same
name.

## 3. Add the system to EmulationStation

The ROCKNIX way (see the [ROCKNIX FAQ](https://rocknix.org/faqs/)):
`config\emulationstation\es_systems.cfg` is a symlink to the built-in list.
Copy it to the PC, delete the symlink, and put back the full copy with this
block added just before `</systemList>` (LF line endings):

```xml
	<system>
		<name>chgame</name>
		<fullname>CHGame</fullname>
		<manufacturer>Kevin Bates</manufacturer>
		<release>2024</release>
		<hardware>portable</hardware>
		<path>/storage/roms/chgame</path>
		<extension>.chg .CHG</extension>
		<command>/bin/bash /storage/.config/retroarch/cores/chgame.sh %ROM%</command>
		<platform>chgame</platform>
		<theme>chgame</theme>
		<emulators>
			<emulator name="retroarch">
				<cores>
					<core default="true">chgame</core>
				</cores>
			</emulator>
		</emulators>
	</system>
```

and `config
etroarch\cores\chgame.sh` (LF line endings). ES adds its own
options (`-autosave 1 ...`) after the game, which RetroArch rejects, so the
script passes on only the game:

```bash
#!/bin/bash
# Launches a CHGame game in RetroArch; ES passes the game path as $1
exec /usr/bin/retroarch --fullscreen -L /storage/.config/retroarch/cores/chgame_libretro.so "$1"
```

Restart EmulationStation (Start → Quit → Restart EmulationStation).

Do **not** use an `es_systems_custom.cfg`: ROCKNIX's ES treats it as the
whole system list, so every other system disappears. A ROCKNIX update
replaces `es_systems.cfg` and keeps yours as `last_es_systems.cfg`; copy
that back to get CHGame again.

SD data files: the core copies each game's `.DAT` from the game folder to
`roms/bios/chgame/sdcard` on first load. The `.CHG` and `.DAT` must be the
same release.

## 4. Box art and videos

ES on ROCKNIX reads media from the system folder:

```
games-roms\chgame\
  STARLIFT.CHG
  images\STARLIFT-image.png    (cover / screenshot)
  videos\STARLIFT-video.mp4    (preview clip)
  gamelist.xml
```

`gamelist.xml`:

```xml
<?xml version="1.0"?>
<gameList>
  <game>
    <path>./STARLIFT.CHG</path>
    <name>STARLIFT</name>
    <desc>Lander rescue game.</desc>
    <image>./images/STARLIFT-image.png</image>
    <video>./videos/STARLIFT-video.mp4</video>
  </game>
</gameList>
```

Where to get the media:

- **Cover**: every jadflat `.CHG` carries a 128x128 cart picture. The CHGame
  Player app exports them (Options → Screenshots, clips and pictures → cart
  pictures), or ask Claude to extract them on the PC
  (`test/chg_header.py` reads the record). Scale up 4x, nearest-neighbour,
  to 512x512 so it stays sharp.
- **Videos**: the Nova already has 43 made by the app (ES-DE `videos`
  folder on its SD card). Copy them over and rename to `<name>-video.mp4`.
  Keep them small: 720x480 or less, H.264.

**Gotcha:** ES holds the gamelist in memory and writes it back when a game
is played. Close ES (or edit, then Start → Game settings → Update
Gamelists) before editing `gamelist.xml`, or the edits are lost.

## Checklist

- [ ] Linux aarch64 core built and copied with its `.info`
- [ ] `.CHG` (and `.DAT`) files in `games-roms/chgame`
- [ ] `es_systems.cfg` copy + `chgame.sh`, ES restarted, a game runs
- [ ] images, videos, `gamelist.xml` (ES closed while editing)
