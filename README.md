# files-to-prompt-bash
Bash script to output directory structure and file contents for AI prompts.

## Requirements

- Bash
- git
- tree
- file
- find
- grep

## Installation

```bash
git clone git@github.com:Kuraturpa/files-to-prompt-bash.git
cd repo-name
chmod u+x files-to-prompt-bash.sh
```

## Usage

```bash
Usage: files-to-prompt-bash.sh [OPTIONS] <directory>

Display directory structure and contents of text files, excluding git-ignored files.

Options:
  -h, --help     Show this help message and exit
  -v, --version  Show version information and exit

Examples:
  files-to-prompt-bash.sh /path/to/directory
```
