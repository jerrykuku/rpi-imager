# Qt Modules Fix for Qt 6.7.2

## Issue

The Windows and macOS build workflows were failing with the following error:

```
ERROR: The packages ['qtsvg'] were not found while parsing XML of package information!
```

## Root Cause

The workflow files were specifying `modules: 'qtsvg qt5compat'` when installing Qt 6.7.2 using the `jurplel/install-qt-action@v3`.

In Qt 6.x, when using the `aqt` tool (which is what the action uses internally), the module naming convention changed:
- `qtsvg` is **not** a valid module name for Qt 6.7.2
- Qt SVG functionality is included in the base Qt installation by default in Qt 6

## Solution

Removed `qtsvg` from the modules list, keeping only `qt5compat`:

**Before:**
```yaml
modules: 'qtsvg qt5compat'
```

**After:**
```yaml
modules: 'qt5compat'
```

## Why This Works

1. **Qt SVG is included by default**: In Qt 6.x, the QtSvg module is part of the standard Qt installation and doesn't need to be specified separately when using aqt.

2. **qt5compat is still needed**: The Qt 5 Compatibility module (`qt5compat`) is required for projects that use deprecated Qt 5 APIs and must be explicitly installed.

3. **CMakeLists.txt compatibility**: The project's `CMakeLists.txt` uses `find_package(Qt6 ... COMPONENTS ... Svg ...)`, which will find the Svg component from the base Qt installation.

## Files Modified

- `.github/workflows/build-windows.yml`
- `.github/workflows/build-macos.yml`
- `.github/workflows/manual-build-all.yml` (2 locations: Windows and macOS sections)

## Verification

To verify which modules are available for a specific Qt version:

```bash
# List available modules for Qt 6.7.2 on Windows
aqt list-qt windows desktop --modules 6.7.2 win64_mingw

# List available modules for Qt 6.7.2 on macOS
aqt list-qt mac desktop --modules 6.7.2 clang_64
```

## References

- Qt 6 Documentation: https://doc.qt.io/qt-6/
- aqt Documentation: https://github.com/miurahr/aqtinstall
- jurplel/install-qt-action: https://github.com/jurplel/install-qt-action

---

**Date**: 2026-02-09
**Fixed by**: GitHub Actions Workflow Update
