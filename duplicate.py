#!/usr/bin/env python
import argparse
import os
import shutil


def duplicate_and_rename_images(src_dir, dst_dir):
    # Check if source directory exists
    if not os.path.exists(src_dir):
        print(f"Source directory {src_dir} does not exist.")
        return

    # Create destination directory if it does not exist
    if not os.path.exists(dst_dir):
        os.makedirs(dst_dir)
        print(f"Created directory {dst_dir}")
    else:
        print(f"Destination directory {dst_dir} already exists.")

    # Determine the maximum length of file names for padding
    max_length = max(
        len(filename)
        for filename in os.listdir(src_dir)
        if filename.endswith(".png")
    )

    # Copy and rename files

    for filename in os.listdir(src_dir):
        if filename.endswith(".png"):
            old_path = os.path.join(src_dir, filename)
            # Remove '.png' to calculate padding, then add it back
            base_name = filename[:-4]
            new_name = base_name.zfill(max_length - 4) + ".png"
            new_path = os.path.join(dst_dir, new_name)

            # Copy file to new destination with new name
            shutil.copy2(old_path, new_path)
    print(f"Copied and renamed {old_path} to {new_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process some arguments.")

    parser.add_argument("src_directory", type=str, help="src_directory")
    parser.add_argument("dst_directory", type=str, help="dst_directory")

    args = parser.parse_args()

    duplicate_and_rename_images(args.src_directory, args.dst_directory)
