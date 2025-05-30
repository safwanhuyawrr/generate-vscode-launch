# generate-vscode-launch

A handy Bash script to **auto-generate VS Code `launch.json`** debug configurations for popular programming languages, including Go, Node.js, C#, and Python.

It automatically:

- Parses environment variables from your `.env` file  
- Detects the main entry point file for your project based on the selected language  
- Creates a properly formatted `.vscode/launch.json` with your environment and program settings  
- Installs `jq` if it's missing (supports macOS, Debian/Ubuntu Linux, and warns on Windows)  

---

## Supported Languages

- Go  
- Node.js  
- C# (.NET Core)  
- Python  

---

## Features

- Auto-detects main entry file (e.g., `cmd/main.go` for Go, `index.js` for Node.js, `.dll` for C#, `main.py` for Python)  
- Reads environment variables from `.env` file and injects them into the debug configuration  
- Generates language-specific debug configurations compatible with VS Code  
- Handles OS-specific automatic installation of `jq` if needed  

---

## Requirements

- Bash shell (Linux/macOS/WSL)  
- `jq` (JSON processor) — the script tries to install it if missing on supported OSes  
- Git (optional, if you want to clone this repo)  

---

## Usage

1. Place your `.env` file in the root directory of your project.

2. Make the script executable (if not already):

   ```bash
   chmod +x generate-vscode-launch.sh