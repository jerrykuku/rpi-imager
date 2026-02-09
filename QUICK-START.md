# ZimaOS Imager - Quick Start Guide

## 🎯 What This Is
A simplified image writer for ZimaOS that automatically detects USB drives and skips unnecessary device selection.

## 🚀 For End Users

### Using the Application
1. **Launch** ZimaOS Imager
2. **Select** your desired ZimaOS version
3. **Plug in** a USB drive (it will be auto-selected)
4. **Click** "Write" to create installation media
5. **Wait** for completion
6. **Done!** USB is ready for ZimaOS installation

### Requirements
- USB drive (8GB or larger recommended)
- Internet connection (for downloading OS images)
- Administrator/root privileges (for writing to drives)

### Safety Features
- ✅ Automatically excludes system drives
- ✅ Won't select read-only drives
- ✅ Warns before writing to any drive
- ✅ Verifies write completion

## 🔧 For Developers/Maintainers

### Critical Setup: Create the Manifest File

**You MUST create this file before the app will work:**

Location: `https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/zimaos-imager-manifest.json`

Minimum content:
```json
{
  "os_list": [
    {
      "name": "ZimaOS 1.2.4",
      "description": "Latest stable release of ZimaOS",
      "url": "https://github.com/IceWhaleTech/ZimaOS/releases/download/v1.2.4/zimaos_zimacube-1.2.4_installer.img",
      "icon": "https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/logo.png",
      "website": "https://github.com/IceWhaleTech/ZimaOS"
    }
  ]
}
```

### Quick Build
```bash
# Linux
sudo apt install build-essential cmake git libgnutls28-dev
sudo ./qt/build-qt.sh  # One-time Qt build
./create-appimage.sh   # Creates ZimaOS-Imager.AppImage

# Run it
./ZimaOS_Imager-*.AppImage
```

### Testing Checklist
- [ ] App shows "ZimaOS Imager" title
- [ ] OS list loads (shows ZimaOS versions)
- [ ] USB drive auto-selects when plugged in
- [ ] Image writes successfully
- [ ] USB is bootable after write

## 📁 Project Structure

```
rpi-imager/
├── src/
│   ├── main.qml                    # ✏️ Updated: ZimaOS branding
│   ├── config.h                    # ✏️ Updated: Manifest URL
│   └── wizard/
│       ├── WizardContainer.qml     # ✏️ Updated: Skip device step
│       └── StorageSelectionStep.qml # ✏️ Updated: Auto USB selection
├── doc/
│   └── zimaos-manifest-example.json # ✨ New: Example manifest
├── README-ZIMAOS.md                 # ✨ New: Setup guide
├── DEPLOYMENT.md                    # ✨ New: Deploy guide
├── CONVERSION-SUMMARY.md            # ✨ New: Tech summary
└── QUICK-START.md                   # ✨ New: This file
```

## 🔗 Important Links

- **Setup Guide**: `README-ZIMAOS.md`
- **Deployment**: `DEPLOYMENT.md`
- **Technical Details**: `CONVERSION-SUMMARY.md`
- **Example Manifest**: `doc/zimaos-manifest-example.json`

## 🐛 Troubleshooting

### "No OS options available"
→ Manifest file is missing. Create it at the configured URL.

### "No USB drive selected"
→ Plug in a USB drive, or uncheck "Exclude system drives" if needed.

### "Cannot write to drive"
→ Run with administrator/sudo privileges.

### Different manifest URL needed?
```bash
./zimaos-imager --repo https://your-custom-url.com/manifest.json
```

## 💡 Tips

- **First USB is auto-selected**: The app picks the first available USB drive automatically
- **System drives protected**: Your computer's main drive is hidden by default
- **Updates automatic**: Manifest is checked each time app launches (cached 24h)
- **Offline support**: Can use local .img files via "Use custom" option

## 📞 Support

- **Code issues**: Create issue in this repository
- **Manifest questions**: See `README-ZIMAOS.md`
- **ZimaOS images**: Check ZimaOS repository

---

**Quick Reference Card**

| Action | What Happens |
|--------|--------------|
| Launch app | Shows OS selection immediately |
| Plug USB | Auto-selects for writing |
| Select OS | Downloads from manifest URL |
| Click Write | Writes to auto-selected USB |
| Unplug USB | Selects next available USB |
