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
  -i, --ignore-files PATTERN Ignore specified files or patterns

Examples:
  $(basename "$0") /path/to/directory
  $(basename "$0") -i "*.md" -i "*.txt" /path/to/directory

EOF
}

IGNORED_FILES=()

is_git_repository() {
	git rev-parse --git-dir > /dev/null 2>&1
	return $?
}

is_git_ignored() {
	local file="$1"
	git check-ignore -q "$file"
	return $?
}

is_text() {
	local file="$1"
	file -b --mime-type "$file" | grep -q '^text/'
	return $?
}

should_ignore() {
	local file="$1"
	local clean_file="${file#./}"

	if is_git_ignored "$file"; then
		return 0
	fi

	for pattern in "${IGNORED_FILES[@]}"; do
		if [[ "$clean_file" == $pattern ]]; then
			return 0
		fi
	done
	return 1
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
		-i|--ignore-files)
			if [[ $# -lt 2 ]]; then
				echo "Error: --ignore-files requires an argument" >&2
				exit 1
			fi
			IGNORED_FILES+=("$2")
			shift 2
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

if ! is_git_repository; then
	echo "Error: '$DIRECTORY' is not a Git repository" >&2
	exit 1
fi

# output directory structure first
tree --gitignore
echo

# output file contents
while IFS= read -r -d '' file; do

	if should_ignore "$file"; then
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
