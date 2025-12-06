import os
import shutil
from tqdm import tqdm

ORIG_ROOT = "/scratch/sm12377/fall2025_finalproject/testset_1/testD1/data"
OUT_ROOT = "/scratch/sm12377/testset1_imagenet"

def extract_class(filename: str) -> str:
    # Example: 00063_Laysan_Albatross_0082_524.jpg
    parts = filename.split("_")
    # parts[0] = "00063"
    # parts[1:-2] = ["Laysan", "Albatross"]
    # parts[-2:] = ["0082","524.jpg"]
    return "_".join(parts[1:-2])

def convert_split(split: str):
    src_dir = os.path.join(ORIG_ROOT, split)
    dst_root = os.path.join(OUT_ROOT, split)
    os.makedirs(dst_root, exist_ok=True)

    files = [f for f in os.listdir(src_dir)
             if f.lower().endswith((".jpg", ".jpeg", ".png"))]

    print(f"Converting {split}: {len(files)} images")
    for fname in tqdm(files):
        cls = extract_class(fname)
        cls_dir = os.path.join(dst_root, cls)
        os.makedirs(cls_dir, exist_ok=True)

        src = os.path.join(src_dir, fname)
        dst = os.path.join(cls_dir, fname)
        # copy; for faster / smaller, you could use os.symlink if allowed
        shutil.copy(src, dst)

if __name__ == "__main__":
    for split in ["train", "val"]:
        convert_split(split)
    print("Done. New ImageNet-style dataset at", OUT_ROOT)