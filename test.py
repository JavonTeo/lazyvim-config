#!/usr/bin/env python3

from pathlib import Path


def count_lines(file_path: str) -> int:
    """Count the number of lines in a file.

    Args:
        file_path: Path to the file to read.

    Returns:
        Number of lines in the file.
    """
    with open(file_path, "r", encoding="utf-8") as f:
        return sum(1 for _ in f)


def main() -> None:
    filename = "example.txt"

    if not Path(filename).exists():
        print(f"File not found: {filename}")
        return

    num_lines = count_lines(filename)
    print(f"{filename} contains {num_lines} lines")


if __name__ == "__main__":
    main()
