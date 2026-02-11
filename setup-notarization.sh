#!/bin/bash
# Configure Apple notarization credentials
# This script securely stores your Apple ID credentials in the keychain
#
# Usage:
#   1. Interactive input: ./setup-notarization.sh
#   2. Environment variables: APPLE_ID=xxx APPLE_TEAM_ID=xxx APPLE_APP_SPECIFIC_PASSWORD=xxx ./setup-notarization.sh

set -e

KEYCHAIN_PROFILE="zimaos-notarytool"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 Configure Apple Notarization Credentials"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get from environment variables or interactive input
if [ -z "$APPLE_ID" ]; then
    read -r -p "Apple ID (email): " APPLE_ID
fi

if [ -z "$APPLE_TEAM_ID" ]; then
    read -r -p "Team ID: " APPLE_TEAM_ID
fi

if [ -z "$APPLE_APP_SPECIFIC_PASSWORD" ]; then
    echo "App-Specific Password (generate at appleid.apple.com):"
    read -r -s -p "Password: " APPLE_APP_SPECIFIC_PASSWORD
    echo ""
fi

# Validate input
if [ -z "$APPLE_ID" ] || [ -z "$APPLE_TEAM_ID" ] || [ -z "$APPLE_APP_SPECIFIC_PASSWORD" ]; then
    echo "❌ Error: All fields are required"
    exit 1
fi

echo ""
echo "Apple ID: $APPLE_ID"
echo "Team ID: $APPLE_TEAM_ID"
echo "Keychain Profile: $KEYCHAIN_PROFILE"
echo ""

# Check if already configured
if xcrun notarytool history --keychain-profile "$KEYCHAIN_PROFILE" >/dev/null 2>&1; then
    echo "⚠️  Existing configuration detected: $KEYCHAIN_PROFILE"
    read -r -p "Overwrite existing configuration? (y/N) " -n 1 REPLY
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Cancelled"
        exit 0
    fi
fi

echo "🔧 Configuring notarization credentials..."
echo ""

# Store credentials using notarytool
xcrun notarytool store-credentials "$KEYCHAIN_PROFILE" \
    --apple-id "$APPLE_ID" \
    --team-id "$APPLE_TEAM_ID" \
    --password "$APPLE_APP_SPECIFIC_PASSWORD"

echo ""
echo "✅ Notarization credentials configured successfully!"
echo ""
echo "You can now build a signed and notarized DMG with:"
echo "  ./mac-build-dmg.sh --signing-identity=\"Developer ID Application\" --notarize-profile=$KEYCHAIN_PROFILE"
echo ""
echo "To view available signing identities:"
echo "  security find-identity -v -p codesigning"
