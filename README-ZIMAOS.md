# ZimaOS Imager Configuration

[![Build Status](https://github.com/jerrykuku/rpi-imager/workflows/Build%20ZimaOS%20Imager/badge.svg)](https://github.com/jerrykuku/rpi-imager/actions)

This is a fork of Raspberry Pi Imager that has been adapted for ZimaOS. It provides a simple interface to write ZimaOS images to USB drives.

## Key Changes

1. **Removed Device Selection**: The device selection step has been removed since ZimaOS doesn't require device-specific images.

2. **Auto-select USB Drives**: The application automatically detects and selects the first available USB drive, making the process simpler.

3. **Updated Branding**: All references to "Raspberry Pi Imager" have been updated to "ZimaOS Imager".

4. **Custom OS List**: The application now points to a ZimaOS-specific manifest file.

## Setting Up the OS Manifest

The application is configured to fetch the OS list from:
```
https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/zimaos-imager-manifest.json
```

### Creating the Manifest File

You need to create a `zimaos-imager-manifest.json` file in the ZimaOS repository following this format:

```json
{
  "os_list": [
    {
      "name": "ZimaOS 1.2.4",
      "description": "ZimaOS is a fork of CasaOS, a simple home cloud system",
      "url": "https://github.com/IceWhaleTech/ZimaOS/releases/download/v1.2.4/zimaos_zimacube-1.2.4_installer.img",
      "icon": "https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/icon.svg",
      "website": "https://github.com/IceWhaleTech/ZimaOS",
      "release_date": "2024-12-20",
      "extract_size": 8589934592,
      "image_download_size": 2147483648
    }
  ]
}
```

### Required Fields

- `name`: Display name for the OS version
- `description`: Brief description of the OS
- `url`: Direct download link to the image file
- `icon`: URL to the icon (SVG or PNG, 40x40 recommended)
- `website`: Link to the OS website or documentation

### Optional Fields

- `release_date`: Release date in YYYY-MM-DD format
- `extract_size`: Uncompressed image size in bytes
- `extract_sha256`: SHA256 checksum of the uncompressed image
- `image_download_size`: Compressed download size in bytes
- `image_download_sha256`: SHA256 checksum of the download file

### Supported Image Formats

The imager supports:
- `.img` - Raw disk images
- `.img.gz` - Gzip compressed images
- `.img.xz` - XZ compressed images
- `.img.zip` - ZIP compressed images
- `.iso` - ISO disk images

### Fetching from GitHub Releases

To automatically populate the manifest from GitHub releases, you can use the GitHub API:

```bash
curl -s "https://api.github.com/repos/IceWhaleTech/ZimaOS/releases" | \
  jq '[.[] | {
    name: ("ZimaOS " + .tag_name),
    description: .body,
    url: .assets[0].browser_download_url,
    release_date: (.published_at | split("T")[0]),
    image_download_size: .assets[0].size
  }]' > zimaos-imager-manifest.json
```

Then add the wrapper object and commit to the repository:
```json
{
  "os_list": [ /* paste the array here */ ]
}
```

## Building

### Automated Builds (GitHub Actions)

The project includes GitHub Actions workflows that automatically build ZimaOS Imager:

- **Linux AppImage**: Built automatically on every push and pull request
- **Releases**: When you create a tag (e.g., `v1.0.0`), a GitHub Release is automatically created with the AppImage

#### Download Pre-built Binaries

Check the [Releases page](../../releases) for pre-built AppImages.

### Manual Build

See the main README.md for manual build instructions. The build process remains the same as the original Raspberry Pi Imager.

#### Linux

```bash
# Install dependencies
sudo apt install --no-install-recommends build-essential cmake git libgnutls28-dev

# Build Qt (one-time)
sudo ./qt/build-qt.sh

# Build AppImage
./create-appimage.sh

# Run it
./ZimaOS_Imager-*.AppImage
```

## Alternative: Using Custom Repository URL

If you don't want to modify the default URL in the code, you can start the application with a custom repository:

```bash
./zimaos-imager --repo https://your-custom-url.com/manifest.json
```

## Example Manifest

See `doc/zimaos-manifest-example.json` for a complete example with multiple OS versions.
