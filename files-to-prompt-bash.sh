#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

readonly VERSION="0.0.1"

show_help() {
    cat << EOF
files-to-prompt-bash.sh $VERSION

Usage: $(basename "$0") [OPTIONS] <directory>

Display directory structure and contents of text files, excluding git-ignored files.

Options:
  -h, --help     Show this help message and exit
  -v, --version  Show version information and exit

Examples:
  $(basename "$0") /path/to/directory

EOF
}

is_ignored() {
	local file="$1"
	git check-ignore -q "$file"
	return $?
}

is_text() {
	local file="$1"
	file -b --mime-type "$file" | grep -q '^text/'
	return $?
}

while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
			show_help
			exit 0
			;;
		-v|--version)
			echo "$VERSION"
			exit 0
			;;
		*)
			DIRECTORY="$1"
			shift
			;;
	esac
done

if [ -z "${DIRECTORY:-}" ]; then
	echo "Error: Directory argument is required" >&2
	show_help
	exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
	echo "Error: Directory '$DIRECTORY' does not exist"
	exit 1
fi

if ! cd "$DIRECTORY"; then
	echo "Error: Cannot change to directory '$DIRECTORY'" >&2
	exit 1
fi

# output directory structure first
tree --gitignore
echo

# output file contents
while IFS= read -r -d '' file; do

	if is_ignored "$file"; then
		continue
	fi

	if ! is_text "$file"; then
		continue
	fi

	# empty files
	if [ ! -s "$file" ]; then
		continue
	fi

	echo "$file"
	echo
	echo '---'
	cat "$file"
	echo '---'
	echo

done < <(find . -type f -not -path '*/\.*' -print0)

exit 0
