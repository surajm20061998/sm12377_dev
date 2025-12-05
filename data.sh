#!/bin/bash

# ----- CONFIG -----
ZIP_URLS=(
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part03.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part04.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part05.zip"
    "https://huggingface.co/datasets/sm12377/tr_imgs/resolve/main/tr_imgs_part06.zip"
)


TARGET_DIR="/home/sd6701/datasets/dl_vicreg_final_exp_dataset_v2/all_images/train"
TMP_DIR="/tmp/zip_extract"

mkdir -p "$TARGET_DIR"

# Global counter so all images are unique
COUNTER=1

for ZIP_URL in "${ZIP_URLS[@]}"; do
    echo "==> Processing $ZIP_URL ..."

    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"

    ZIP_FILE="/tmp/temp.zip"
    echo "Downloading $ZIP_URL..."
    wget -O "$ZIP_FILE" "$ZIP_URL"

    echo "Unzipping..."
    unzip -q "$ZIP_FILE" -d "$TMP_DIR"

    echo "Copying and renaming images to $TARGET_DIR..."
    find "$TMP_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
        
        EXT="${img##*.}"  # jpg, png, jpeg
        NEW_NAME="_xyz_$(printf "%06d" $COUNTER).$EXT"

        echo "Copying → $NEW_NAME"

        cp "$img" "$TARGET_DIR/$NEW_NAME"

        ((COUNTER++))
    done

    rm "$ZIP_FILE"
    echo "Finished processing $ZIP_URL"
done

echo "==> DONE! All images stored in: $TARGET_DIR"

