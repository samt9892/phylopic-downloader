# phylopic-downloader

A simple Dockerized tool to download silhouette animal icons from [PhyloPic](https://www.phylopic.org/), a database of freely reusable phylogenetic silhouettes. This script lets you fetch and store organism images by scientific name for use in figures, presentations, or data visualizations.

## Features

- Download silhouettes from PhyloPic by scientific name
- Saves images in `.svg` format to a local `downloads/` folder
- Dockerized for easy execution across platforms (Linux, macOS (ARM), Windows)

---

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/) installed on your system
- Internet connection to pull the images and access the PhyloPic API

### 1. Clone the Repository

```bash
git clone https://github.com/samt9892/phylopic-downloader.git
cd phylopic-downloader
```
### 2. Make scripts executable (if needed)
```bash
chmod +x docker-downloader.sh docker-converter.sh
```
### 3. Download images
```bash
./docker-downloader.sh
```

### 4. Convert .SVG images into .PNG
```bash
./docker-converter.sh
```

<blockquote>
  <p>
  This project uses resources provided by <a href="https://www.phylopic.org/" target="_blank">PhyloPic.org</a> — a wonderful database of reusable silhouette illustrations for phylogenetic and taxonomic figures. <br><br>
  We gratefully acknowledge their team and contributing artists for making biodiversity more visual and accessible.
  </p>
</blockquote>

