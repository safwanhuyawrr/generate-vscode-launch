#!/usr/bin/env bash
set -euo pipefail

# Auto install jq if missing
install_jq() {
  if command -v jq &>/dev/null; then
    return
  fi
  echo "🔧 jq not found. Installing..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &>/dev/null; then
      sudo apt-get update && sudo apt-get install -y jq
    elif command -v yum &>/dev/null; then
      sudo yum install -y jq
    else
      echo "❌ Unsupported Linux package manager. Install jq manually."
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &>/dev/null; then
      brew install jq
    else
      echo "❌ Homebrew not found on macOS. Install jq manually."
      exit 1
    fi
  elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
    echo "❌ Please install jq manually on Windows (e.g. via Chocolatey: choco install jq)."
    exit 1
  else
    echo "❌ Unsupported OS. Please install jq manually."
    exit 1
  fi
}

install_jq

# Read .env file into jq-ready JSON object with trimming spaces
parse_env() {
  local env_file=$1
  jq -Rn --rawfile env "$env_file" '
    ($env | split("\n") 
    | map(select(length > 0 and (test("^[^#]")))) 
    | map(
        split("=") 
        | {(.[0] | gsub("^\\s+|\\s+$";"")): (.[1] // "" | gsub("^\\s+|\\s+$";"") | gsub("^\"|\"$";""))}
      )
    ) | add
  '
}

# Detect main file based on language
detect_main_file() {
  local lang=$1
  case "$lang" in
    go)
      if [[ -f "cmd/main.go" ]]; then
        echo "cmd/main.go"
      else
        local file
        file=$(find . -type f -name main.go | head -n1 || true)
        echo "$file"
      fi
      ;;
    node)
      for f in index.js app.js server.js; do
        if [[ -f "$f" ]]; then
          echo "$f"
          return
        fi
      done
      read -rp "Enter Node.js main file path (default: index.js): " input
      echo "${input:-index.js}"
      ;;
    csharp)
      local dll
      dll=$(find ./bin/Debug/net*/*.dll 2>/dev/null | head -n1 || true)
      if [[ -n "$dll" ]]; then
        echo "$dll"
      else
        read -rp "Enter path to your compiled DLL (e.g. bin/Debug/net6.0/MyApp.dll): " input
        echo "$input"
      fi
      ;;
    python)
      if [[ -f "main.py" ]]; then
        echo "main.py"
      else
        read -rp "Enter Python main file path (default: main.py): " input
        echo "${input:-main.py}"
      fi
      ;;
    *)
      echo "Unsupported language: $lang" >&2
      exit 1
      ;;
  esac
}

# Generate launch.json content
generate_launch_json() {
  local lang=$1
  local main_file=$2
  local env_json=$3

  case "$lang" in
    go)
      jq -n --arg prog "$main_file" --argjson env "$env_json" '
      {
        version: "0.2.0",
        configurations: [
          {
            name: "Launch Go App",
            type: "go",
            request: "launch",
            mode: "auto",
            program: $prog,
            env: $env,
            args: []
          }
        ]
      }
      '
      ;;
    node)
      jq -n --arg prog "$main_file" --argjson env "$env_json" '
      {
        version: "0.2.0",
        configurations: [
          {
            name: "Launch Node App",
            type: "node",
            request: "launch",
            program: $prog,
            env: $env,
            console: "integratedTerminal"
          }
        ]
      }
      '
      ;;
    csharp)
      jq -n --arg prog "$main_file" --argjson env "$env_json" '
      {
        version: "0.2.0",
        configurations: [
          {
            name: ".NET Core Launch",
            type: "coreclr",
            request: "launch",
            program: $prog,
            args: [],
            env: $env,
            console: "internalConsole"
          }
        ]
      }
      '
      ;;
    python)
      jq -n --arg prog "$main_file" --argjson env "$env_json" '
      {
        version: "0.2.0",
        configurations: [
          {
            name: "Python: Current File",
            type: "python",
            request: "launch",
            program: $prog,
            console: "integratedTerminal",
            env: $env
          }
        ]
      }
      '
      ;;
  esac
}

# === Main script ===

if [[ ! -f ".env" ]]; then
  echo "❌ .env file not found in current directory."
  exit 1
fi

echo "Supported languages: go, node, csharp, python"
read -rp "Enter your project language: " language
language=$(echo "$language" | tr '[:upper:]' '[:lower:]')
if [[ ! "$language" =~ ^(go|node|csharp|python)$ ]]; then
  echo "❌ Unsupported language: $language"
  exit 1
fi

main_file=$(detect_main_file "$language")

if [[ -z "$main_file" ]]; then
  echo "❌ Could not detect main file. Please specify manually."
  exit 1
fi

if [[ ! -f "$main_file" ]]; then
  echo "❌ Main file '$main_file' does not exist."
  exit 1
fi

echo "Using main file: $main_file"

env_json=$(parse_env .env)

launch_json=$(generate_launch_json "$language" "$main_file" "$env_json")

mkdir -p .vscode
echo "$launch_json" > .vscode/launch.json

echo "✅ VS Code launch.json generated successfully at .vscode/launch.json"