# ZimaOS Imager Deployment Guide

## Overview
This is a complete conversion of Raspberry Pi Imager to ZimaOS Imager, ready for deployment.

## What Was Changed

### 1. User Interface
- **Branding**: All "Raspberry Pi Imager" text changed to "ZimaOS Imager"
- **Workflow**: Device selection step removed - starts directly with OS selection
- **Storage**: Automatically selects first available USB drive

### 2. Configuration
- **OS List URL**: Points to `https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/zimaos-imager-manifest.json`
- Application expects a JSON manifest file at this location

## Before You Deploy

### CRITICAL: Create the Manifest File

You must create `zimaos-imager-manifest.json` in the ZimaOS repository root. Without this file, the application will not show any OS options.

**Quick Start:**
1. Copy `doc/zimaos-manifest-example.json` to your ZimaOS repo
2. Rename it to `zimaos-imager-manifest.json`
3. Update the URLs to point to actual ZimaOS release files
4. Commit and push to the main branch

**Example with real data:**
```json
{
  "os_list": [
    {
      "name": "ZimaOS 1.2.4",
      "description": "Latest stable release of ZimaOS",
      "url": "https://github.com/IceWhaleTech/ZimaOS/releases/download/v1.2.4/zimaos_zimacube-1.2.4_installer.img",
      "icon": "https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/logo.png",
      "website": "https://github.com/IceWhaleTech/ZimaOS",
      "release_date": "2024-12-20",
      "image_download_size": 2147483648
    }
  ]
}
```

### Automated Manifest Generation

You can generate the manifest automatically from GitHub releases:

```bash
#!/bin/bash
# Generate ZimaOS manifest from GitHub releases

echo '{"os_list":[' > zimaos-imager-manifest.json

# Fetch releases and format as manifest entries
gh api repos/IceWhaleTech/ZimaOS/releases | \
  jq -r '.[] | 
    select(.assets | length > 0) | 
    {
      name: ("ZimaOS " + .tag_name),
      description: (.body // "ZimaOS Release"),
      url: .assets[0].browser_download_url,
      icon: "https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/logo.png",
      website: .html_url,
      release_date: (.published_at | split("T")[0]),
      image_download_size: .assets[0].size
    }' | \
  jq -s '.' >> zimaos-imager-manifest.json

echo ']}' >> zimaos-imager-manifest.json

# Format nicely
jq '.' zimaos-imager-manifest.json > temp.json && mv temp.json zimaos-imager-manifest.json
```

## Building

Build the application following the standard Raspberry Pi Imager build process:

### Linux
```bash
# Install dependencies
sudo apt install --no-install-recommends build-essential cmake git libgnutls28-dev

# Build Qt (if needed)
sudo ./qt/build-qt.sh

# Build AppImage
./create-appimage.sh
```

### Windows
See README.md for Windows build instructions with Qt and Visual Studio.

### macOS
See README.md for macOS build instructions.

## Testing Checklist

Before releasing to users, test:

1. **Launch**: Application starts with "ZimaOS Imager" title
2. **OS List**: OS selection screen appears first (no device selection)
3. **OS Loading**: ZimaOS versions load from manifest
4. **USB Detection**: USB drive is automatically selected when plugged in
5. **Writing**: Image writes successfully to USB drive
6. **Auto-reselection**: Different USB drive is selected when current one is removed

## User Experience

Users will experience:
1. **Start application** → Immediately see OS selection (ZimaOS versions)
2. **Select OS version** → Choose which ZimaOS version to install
3. **Auto-selected storage** → First USB drive automatically selected
4. **Click Write** → Image writes to USB drive
5. **Done** → USB drive is ready for ZimaOS installation

## Troubleshooting

### No OS options appear
- **Cause**: Manifest file missing or URL incorrect
- **Fix**: Ensure `zimaos-imager-manifest.json` exists at configured URL
- **Test**: Visit `https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/zimaos-imager-manifest.json` in browser

### USB drive not auto-selected
- **Cause**: No USB drives connected, or all are system drives
- **Fix**: Connect a USB drive; if needed, uncheck "Exclude system drives"
- **Note**: Read-only drives cannot be selected

### Wrong URL for OS list
- **Temporary fix**: Start with `--repo` parameter:
  ```bash
  ./zimaos-imager --repo https://your-url.com/manifest.json
  ```
- **Permanent fix**: Update `src/config.h` and rebuild

## Distribution

After building and testing:

1. **Create release** on GitHub with built binaries
2. **Update documentation** with download links
3. **Announce** to ZimaOS community
4. **Provide support** for manifest updates

## Maintaining the Manifest

To add new ZimaOS versions:
1. Edit `zimaos-imager-manifest.json` in ZimaOS repo
2. Add new entry to `os_list` array
3. Commit and push
4. Users will see new version on next launch (manifest is cached for 24h)

## Support

For issues with:
- **Imager code**: Create issue in this repository (rpi-imager fork)
- **Manifest file**: Create issue in ZimaOS repository
- **ZimaOS images**: Create issue in ZimaOS repository

## License

This is a fork of Raspberry Pi Imager. Original license and copyrights apply.
See `license.txt` for details.
