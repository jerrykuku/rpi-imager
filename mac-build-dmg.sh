#!/bin/bash
# macOS DMG build script - supports signing and notarization
# Usage: ./mac-build-dmg.sh [options]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
QT_ROOT="${Qt6_ROOT:-/opt/Qt/6.9.3/macos}"

# Default parameters
CLEAN_BUILD=0
SIGNING_IDENTITY=""
NOTARIZE_PROFILE=""
SKIP_BUILD=0

usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --clean                        Clean and rebuild"
    echo "  --qt-root=PATH                 Specify Qt installation path"
    echo "  --signing-identity=CN          Developer certificate name (for code signing)"
    echo "  --notarize-profile=PROFILE     Keychain profile name (for notarization)"
    echo "  --skip-build                   Skip build, only create DMG"
    echo "  --help, -h                     Show this help message"
    echo ""
    echo "Examples:"
    echo "  # Build unsigned DMG"
    echo "  $0"
    echo ""
    echo "  # Build signed DMG"
    echo "  $0 --signing-identity=\"Developer ID Application: Your Name (TEAMID)\""
    echo ""
    echo "  # Build signed and notarized DMG"
    echo "  $0 --signing-identity=\"Developer ID Application: Your Name (TEAMID)\" \\"
    echo "     --notarize-profile=notarytool-password"
    echo ""
    echo "  # Clean rebuild"
    echo "  $0 --clean --signing-identity=\"Developer ID\""
    echo ""
    echo "Prerequisites:"
    echo "  1. Get developer certificate:"
    echo "     - Apply for Developer ID Application certificate at Apple Developer"
    echo "     - Download and install to keychain"
    echo "     - Use 'security find-identity -v -p codesigning' to view certificate names"
    echo ""
    echo "  2. Configure notarization credentials (optional):"
    echo "     xcrun notarytool store-credentials notarytool-password \\"
    echo "       --apple-id your@email.com \\"
    echo "       --team-id TEAMID \\"
    echo "       --password app-specific-password"
    exit 0
}

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --clean)
            CLEAN_BUILD=1
            shift
            ;;
        --qt-root=*)
            QT_ROOT="${arg#*=}"
            shift
            ;;
        --signing-identity=*)
            SIGNING_IDENTITY="${arg#*=}"
            shift
            ;;
        --notarize-profile=*)
            NOTARIZE_PROFILE="${arg#*=}"
            shift
            ;;
        --skip-build)
            SKIP_BUILD=1
            shift
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "❌ Unknown option: $arg"
            usage
            ;;
    esac
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🍎 ZimaOS USB Creator - macOS DMG Build"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check required tools
if ! command -v ninja >/dev/null 2>&1; then
    echo "❌ Error: Ninja build system not found"
    echo "Please install: brew install ninja"
    exit 1
fi

if ! command -v hdiutil >/dev/null 2>&1; then
    echo "❌ Error: hdiutil not found"
    exit 1
fi

# Display configuration
echo "📋 Build Configuration:"
echo "  Qt Path: $QT_ROOT"
echo "  Build Directory: $BUILD_DIR"
if [ -n "$SIGNING_IDENTITY" ]; then
    echo "  Code Signing: ✅ Enabled"
    echo "  Signing Identity: $SIGNING_IDENTITY"
else
    echo "  Code Signing: ❌ Disabled"
fi
if [ -n "$NOTARIZE_PROFILE" ]; then
    echo "  Notarization: ✅ Enabled"
    echo "  Keychain Profile: $NOTARIZE_PROFILE"
else
    echo "  Notarization: ❌ Disabled"
fi
echo ""

# Verify signing identity (if enabled)
if [ -n "$SIGNING_IDENTITY" ]; then
    echo "🔍 Verifying signing identity..."
    if ! security find-identity -v -p codesigning | grep -q "$SIGNING_IDENTITY"; then
        echo "❌ Error: Signing identity not found: $SIGNING_IDENTITY"
        echo ""
        echo "Available signing identities:"
        security find-identity -v -p codesigning
        exit 1
    fi
    echo "✅ Signing identity verified"
    echo ""
fi

# Verify notarization configuration (if enabled)
if [ -n "$NOTARIZE_PROFILE" ]; then
    echo "🔍 Verifying notarization configuration..."
    if ! xcrun notarytool history --keychain-profile "$NOTARIZE_PROFILE" >/dev/null 2>&1; then
        echo "❌ Error: Keychain profile not found: $NOTARIZE_PROFILE"
        echo ""
        echo "Please configure notarization credentials first:"
        echo "  xcrun notarytool store-credentials $NOTARIZE_PROFILE \\"
        echo "    --apple-id your@email.com \\"
        echo "    --team-id TEAMID \\"
        echo "    --password app-specific-password"
        exit 1
    fi
    echo "✅ Notarization configuration verified"
    echo ""
fi

# Build application
if [ $SKIP_BUILD -eq 0 ]; then
    echo "🔨 Building application..."

    # Build command array to properly handle arguments with spaces and special characters
    BUILD_CMD=("$SCRIPT_DIR/mac-build-ninja.sh")
    BUILD_CMD+=("--qt-root=$QT_ROOT")

    if [ $CLEAN_BUILD -eq 1 ]; then
        BUILD_CMD+=("--clean")
    fi

    if [ -n "$SIGNING_IDENTITY" ]; then
        BUILD_CMD+=("--signing-identity=$SIGNING_IDENTITY")
    fi

    if [ -n "$NOTARIZE_PROFILE" ]; then
        BUILD_CMD+=("--notarize-profile=$NOTARIZE_PROFILE")
    fi

    # Execute build command
    "${BUILD_CMD[@]}"

    echo ""
    echo "✅ Application build completed"
    echo ""
else
    echo "⏭️  Skipping build step"
    echo ""
fi

# Check if application exists
APP_BUNDLE="$BUILD_DIR/zimaos-usb-creator.app"
if [ ! -d "$APP_BUNDLE" ]; then
    echo "❌ Error: Application bundle not found: $APP_BUNDLE"
    exit 1
fi

# Create DMG
echo "📦 Creating DMG installer..."
cd "$BUILD_DIR"

# Use CMake's dmg target
if ninja dmg; then
    echo ""
    echo "✅ DMG created successfully!"
    echo ""

    # Find generated DMG files
    DMG_FILES=$(find "$BUILD_DIR" -maxdepth 1 -name "*.dmg" -type f)

    if [ -n "$DMG_FILES" ]; then
        echo "📦 Generated DMG files:"
        for dmg in $DMG_FILES; do
            SIZE=$(du -h "$dmg" | cut -f1)
            echo "  • $(basename "$dmg") ($SIZE)"
        done
        echo ""

        # Display signing status
        LATEST_DMG=$(ls -t "$BUILD_DIR"/*.dmg 2>/dev/null | head -1)
        if [ -n "$LATEST_DMG" ]; then
            echo "🔍 Verifying DMG signature:"
            if codesign -dv "$LATEST_DMG" 2>&1 | grep -q "Signature"; then
                echo "  ✅ DMG is signed"
                codesign -dv "$LATEST_DMG" 2>&1 | grep "Authority"
            else
                echo "  ℹ️  DMG is not signed"
            fi
            echo ""

            # If notarization is enabled, display notarization status
            if [ -n "$NOTARIZE_PROFILE" ]; then
                echo "🔍 Checking notarization status:"
                if spctl -a -vv -t install "$LATEST_DMG" 2>&1 | grep -q "accepted"; then
                    echo "  ✅ DMG is notarized"
                else
                    echo "  ⏳ DMG may be pending notarization, or not notarized"
                    echo "  Check notarization status with:"
                    echo "  xcrun notarytool history --keychain-profile $NOTARIZE_PROFILE"
                fi
                echo ""
            fi
        fi
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ Build completed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "❌ DMG creation failed"
    exit 1
fi
