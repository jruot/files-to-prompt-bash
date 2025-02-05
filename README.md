# files-to-prompt-bash 🚀

Bash script to output directory structure and file contents for LLM prompts. Share your codebase
with AI tools like ChatGPT, Claude or Github Copilot.
It requires only minimal dependencies and uses basic tools. By default gitignored files are not outputted.

## 📋 Requirements

- Bash
- git
- tree
- file
- find
- grep

## 🔧 Installation

```bash
git clone git@github.com:Kuraturpa/files-to-prompt-bash.git
cd repo-name
chmod u+x files-to-prompt-bash.sh
```

## 💻 Usage

```bash
Usage: files-to-prompt-bash.sh [OPTIONS] <directory>

Display directory structure and contents of text files, excluding git-ignored files.

Options:
  -h, --help     Show this help message and exit
  -v, --version  Show version information and exit

Examples:
  files-to-prompt-bash.sh /path/to/directory
```

Note: It's not recommended to use this tool for large codebases as it may exceed LLM context limits.
Be careful when outputting sensitive code or configuration files. The tool does not exclude secrets or config files.

## 💡 Tips

The script outputs the file contents to terminal. You can pipe the output to your clipboard. For 
example following command pipes the output to wayland cliboard.

`files-to-prompt-bash.sh /path/to/directory | wl-copy`

You can also pipe the output into a file:

`files-to-prompt-bash.sh /path/to/directory > output.txt`

If you are using X11 you can copy to clipboard using following command:

`files-to-prompt-bash.sh /path/to/directory | xclip -selection clipboard`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request or create an Issue.
