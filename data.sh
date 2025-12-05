


#!/bin/bash

# ----- CONFIG -----
ZIP_URLS=(
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part01.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part02.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part03.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part04.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part05.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part06.zip"
)

TARGET_DIR="/home/sd6701/datasets/dl_vicreg_final_exp_dataset_v2/all_images/train"
TMP_DIR="/tmp/zip_extract"

mkdir -p "$TARGET_DIR"

# Counter for sequential renaming if needed
COUNTER=1

for ZIP_URL in "${ZIP_URLS[@]}"; do
    echo "==> Processing $ZIP_URL ..."

    # Remove previous temp folder
    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    # Download ZIP
    ZIP_FILE="/tmp/temp.zip"
    echo "Downloading $ZIP_URL..."
    wget -O "$ZIP_FILE" "$ZIP_URL"

    # Unzip
    echo "Unzipping..."
    unzip -q "$ZIP_FILE" -d "$TMP_DIR"

    # Copy images one by one
    echo "Copying images to $TARGET_DIR..."
    find "$TMP_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
        echo "Copying $img"
        cp "$img" "$TARGET_DIR/"
        # Optional sequential renaming:
        # EXT="${img##*.}"
        # cp "$img" "$TARGET_DIR/xyz_$(printf "%05d" $COUNTER).$EXT"
        # ((COUNTER++))
    done

    # Clean up ZIP file
    rm "$ZIP_FILE"
    echo "Finished processing $ZIP_URL"
done

echo "==> ALL DONE! Images are in $TARGET_DIR"

