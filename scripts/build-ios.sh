#!/bin/bash
set -e

echo "=== Step 1: Build web assets ==="
npm run build

echo "=== Step 2: Generate fresh iOS project from Capacitor templates ==="
rm -rf ios
npx cap add ios

echo "=== Step 3: Sync web assets into iOS project ==="
npx cap sync ios

echo "=== Step 4: Customize Info.plist ==="
PLIST="ios/App/App/Info.plist"
if [ -f "$PLIST" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName FocusQuest" "$PLIST" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :NSCameraUsageDescription string FocusQuest needs camera access for task verification photos" "$PLIST" 2>/dev/null || true
  /usr/libexec/PlistBuddy -c "Add :NSPhotoLibraryUsageDescription string FocusQuest needs photo library access" "$PLIST" 2>/dev/null || true
  echo "Info.plist customized"
fi

echo "=== Build complete ==="
