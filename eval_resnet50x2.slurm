#!/bin/bash
#SBATCH --job-name=eval_r50x2
#SBATCH --output=/scratch/sm12377/eval/resnet50x2/slurm.out
#SBATCH --error=/scratch/sm12377/eval/resnet50x2/slurm.err
#SBATCH --partition=rtx8000
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --account=csci_ga_2572-2025fa

# -------------------------------
# Load correct Miniconda
# -------------------------------
echo "Sourcing conda..."
source /scratch/sm12377/miniconda3/etc/profile.d/conda.sh

# -------------------------------
# Activate environment
# -------------------------------
echo "Activating conda env py310..."
conda activate py310

# Debug print
echo "Python path = $(which python)"
echo "Python version = $(python --version)"

# -------------------------------
# Move to project folder
# -------------------------------
cd /scratch/sm12377/sm12377_dev/sm12377_dev

mkdir -p /scratch/sm12377/eval/resnet50x2

# -------------------------------
# Run evaluation
# -------------------------------
python evaluate.py \
  --data-dir /scratch/sm12377/testset1_imagenet \
  --pretrained /scratch/sm12377/checkpoints/resnet50x2.pth \
  --arch resnet50 \
  --weights freeze \
  --batch-size 128 \
  --epochs 30 \
  --eval-types linear,knn \
  --exp-dir /scratch/sm12377/eval/resnet50x2