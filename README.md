# Audio Processing Makefile

## What it does

This Makefile defines a simple pipeline for preparing audio files for MP3 players:

1. Convert `.m4a` → `.mp3` (via ffmpeg)
2. Split audio into chunks:
   - either by silence
   - or into ~1-minute segments adjusted to nearby silence
3. Optionally upload the result to a mounted Xtrainerz device

## Requirements

- `ffmpeg`
- `mp3splt`
- `fatsort`
- macOS utilities: `mount`, `awk`, `diskutil`

## Why `fatsort`

Many simple MP3 players do **not sort files by filename**. Instead, they play files in the **physical order stored in the FAT filesystem**.

Tools like `fatsort` reorder directory entries directly on the filesystem so playback follows a predictable (e.g. alphabetical or natural) order :contentReference[oaicite:0]{index=0}.

Without this step, numbered files may still play in a seemingly random order.
