#!/usr/bin/env bash
# set -e

# Usage: ./make_gallery.sh
#
# Run in a directory with a "papes/" subdirectory, and it will create a
# "thumbnails/" subdirectory.
#
# Uses imagemagick's `convert`, so make sure that's installed.
# On Nix, nix-shell -p imagemagick --run ./make_gallery.sh

# rm -rf thumbnails
mkdir -p thumbnails papes mobile

url_root="https://raw.githubusercontent.com/ropapermaker/Wallpapers/master"

echo "## My Wallpaper Collection" >README.md
echo "### Desktop Wallpapers" >>README.md
echo "" >>README.md

total=$(ls papes/ | wc -l)
i=0

for src in papes/*; do
  ((i++))
  filename="$(basename "$src")"
  printf '%4d/%d: %s\n' "$i" "$total" "$filename"

  test -e "${src/papes/thumbnails}" || convert -resize 200x100^ -gravity center -extent 200x100 "$src" "${src/papes/thumbnails}"

  filename_escaped="${filename// /%20}"
  thumb_url="$url_root/thumbnails/$filename_escaped"
  pape_url="$url_root/papes/$filename_escaped"

  echo "[![$filename]($thumb_url)]($pape_url)" >>README.md
done

# Mobile wallpapers section
echo "" >>README.md
echo "### Mobile Wallpapers" >>README.md
echo "" >>README.md

# for mobile wallpapers to be appended at the bottom of the thumbnails
total=$(ls mobile/ | wc -l)
i=0

for src in mobile/*; do
  ((i++))
  filename="$(basename "$src")"
  printf '%4d/%d: %s\n' "$i" "$total" "$filename"

  test -e "${src/mobile/thumbnails}" || convert -resize 200x400^ -gravity center -extent 200x400 "$src" "${src/mobile/thumbnails}"

  filename_escaped="${filename// /%20}"
  thumb_url="$url_root/thumbnails/$filename_escaped"
  pape_url="$url_root/mobile/$filename_escaped"

  echo "[![$filename]($thumb_url)]($pape_url)" >>README.md
done
