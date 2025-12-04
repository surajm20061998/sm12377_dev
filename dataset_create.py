import zipfile
from pathlib import Path
import shutil
import random
from tqdm import tqdm

# -----------------------------
# Paths
# -----------------------------
base_dir = Path("/home/sd6701/datasets/dl_vicreg_final_exp_dataset_v2")
train_dir = base_dir / "train" / "class1"
val_dir = base_dir / "val" / "class1"

train_dir.mkdir(parents=True, exist_ok=True)
val_dir.mkdir(parents=True, exist_ok=True)

combined_dir = base_dir / "all_images"
combined_dir.mkdir(parents=True, exist_ok=True)

image_exts = (".jpg", ".jpeg", ".png", ".bmp", ".gif", ".tif", ".tiff")

# -----------------------------
# Function to unzip
# -----------------------------
def unzip(zip_path, dest_dir, rename_prefix=None):
    print(f"🔹 Extracting {zip_path} -> {dest_dir}")
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        for member in zip_ref.infolist():
            target_path = dest_dir / member.filename
            target_path.parent.mkdir(parents=True, exist_ok=True)

            if rename_prefix and not member.is_dir():
                target_path = target_path.parent / f"{rename_prefix}_{target_path.name}"

            if member.is_dir():
                continue

            with zip_ref.open(member) as source, open(target_path, "wb") as target:
                shutil.copyfileobj(source, target)
    print(f"✅ Finished extracting {zip_path}")


ys2krqw_zip = "/home/sd6701/datasets/fall2025_deeplearning/trImgs/ys2krqw.zip"


print("🔹 Extracting ys2krqw.zip with xyz_ prefix...")
unzip(ys2krqw_zip, combined_dir, rename_prefix="xyz")

# -----------------------------
# Step 2: Move images directly while splitting
# -----------------------------
print("🔹 Step 2: Moving images directly to train/val...")

train_ratio = 0.9

image_count = 0
for img_path in tqdm(combined_dir.rglob("*"), desc="Processing images"):
    if img_path.suffix.lower() not in image_exts:
        continue

    # Decide train or val
    if random.random() < train_ratio:
        dst_dir = train_dir
    else:
        dst_dir = val_dir

    dst_file = dst_dir / img_path.name
    if dst_file.exists():
        dst_file = dst_dir / f"xyz-{img_path.name}"

    shutil.move(str(img_path), str(dst_file))
    image_count += 1

print(f"✅ Finished moving {image_count} images to train/val sets!")
