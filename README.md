<div align="center">

# im2ansi

**Convert images into beautiful ANSI/ASCII art**

[ring]: https://img.shields.io/badge/Made_with-Ring-2D54CB?style=for-the-badge&logo=ring&logoColor=C0CAF5&labelColor=414868&color=8c73cc
[license]: https://img.shields.io/github/license/ysdragon/im2ansi?style=for-the-badge&logo=opensourcehardware&label=License&logoColor=C0CAF5&labelColor=414868&color=8c73cc

[release]: https://img.shields.io/github/v/release/ysdragon/im2ansi?style=for-the-badge&logo=github&logoColor=C0CAF5&labelColor=414868&color=8c73cc

[![][ring]](https://ring-lang.net/)
[![][license]](https://github.com/ysdragon/im2ansi/blob/master/LICENSE)

[![][release]](https://github.com/ysdragon/im2ansi/releases/latest)

</div>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎨 **Multiple Formats** | Export to ANSI, ASCII, SVG, or HTML |
| 🖼️ **Flexible Sizing** | Control width and/or height independently |
| 🔄 **Color Inversion** | Invert brightness for different backgrounds |
| 📝 **Custom Characters** | Use your own character sets for unique art |
| 🎯 **ASCII Ramps** | 12 built-in grayscale character ramps |
| 🎲 **Reproducible Output** | Set a seed for consistent results |
| 🖥️ **Cross-Platform** | Works on Linux, macOS, and Windows |

## 📦 Installation

### Quick Start (Recommended)

Download a pre-built executable from the [**latest releases**](https://github.com/ysdragon/im2ansi/releases/latest) — no dependencies required!

### Build from Source

<details>
<summary>Click to expand</summary>

```bash
# Clone the repository
git clone https://github.com/ysdragon/im2ansi.git
cd im2ansi

# Run directly
ring im2ansi.ring -p image.jpg

# Or build an executable
ring2exe im2ansi.ring
./im2ansi -p image.jpg
```

</details>

## 🚀 Usage

```bash
im2ansi -p <image> [options]
```

### Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--path` | `-p` | Path to the image to convert | *required* |
| `--output` | `-o` | Output file path | *stdout* |
| `--format` | `-f` | Output format: `ansi`, `svg`, `ascii`, `html` | `ansi` |
| `--size` | `-s` | Output height in characters | `30` |
| `--width` | `-w` | Output width in characters | *auto* |
| `--character_set` | `-c` | Characters for ansi/svg mode | `01` |
| `--ramp` | `-r` | ASCII ramp 1-12 for ascii mode | `1` |
| `--seed` | | Random seed for reproducible output | *random* |
| `--invert` | `-i` | Invert brightness | `false` |
| `--no-color` | | Output without colors (plain ASCII) | `false` |
| `--html` | | Output as HTML | `false` |
| `--quiet` | `-q` | Suppress info messages | `false` |
| `--version` | `-v` | Show version information | |
| `--help` | `-h` | Show help message | |

### Output Formats

| Format | Description | Best For |
|--------|-------------|----------|
| `ansi` | Colored terminal output with random characters | Terminal display |
| `ascii` | Colored output using grayscale ramp characters | Terminal display |
| `svg` | Scalable Vector Graphics | Web, print, scaling |
| `html` | HTML document with inline styles | Web embedding |

## 📖 Examples

<table>
<tr>
<td>

**Basic conversion**
```bash
im2ansi -p image.jpg
```

</td>
<td>

**Custom size**
```bash
im2ansi -p image.jpg -s 50 -w 100
```

</td>
</tr>
<tr>
<td>

**ASCII art with detailed ramp**
```bash
im2ansi -p image.jpg -f ascii -r 2
```

</td>
<td>

**Inverted colors**
```bash
im2ansi -p image.jpg -i
```

</td>
</tr>
<tr>
<td>

**Save as SVG**
```bash
im2ansi -p image.jpg -f svg -o art.svg
```

</td>
<td>

**Save as HTML**
```bash
im2ansi -p image.jpg --html -o art.html
```

</td>
</tr>
<tr>
<td>

**Custom characters**
```bash
im2ansi -p image.jpg -c "█▓▒░"
```

</td>
<td>

**Plain ASCII (no colors)**
```bash
im2ansi -p image.jpg -f ascii --no-color
```

</td>
</tr>
</table>

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs by [opening an issue](https://github.com/ysdragon/im2ansi/issues/new)
- 💡 Suggest features or improvements
- 🔧 Submit pull requests

## 📄 License

This project is licensed under the **MIT License**. See the [`LICENSE`](LICENSE) file for details.