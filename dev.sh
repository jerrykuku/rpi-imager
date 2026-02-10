#!/bin/bash
# 快速开发脚本：增量编译 + 立即运行
# 用法: ./dev.sh

set -e

BUILD_DIR="$(dirname "$0")/build"
QT_ROOT="/opt/Qt/6.9.3/macos"
APP="$BUILD_DIR/rpi-imager.app/Contents/MacOS/rpi-imager"

# 增量编译（只重新编译改动的文件）
echo "⏳ 编译中..."
START=$(date +%s)
ninja -C "$BUILD_DIR" rpi-imager 2>&1 | tail -5
END=$(date +%s)
echo "✅ 编译完成 ($(($END - $START))s)"

# 直接运行（用 Qt 库路径，不依赖 macdeployqt）
export DYLD_FRAMEWORK_PATH="$QT_ROOT/lib"
export QML2_IMPORT_PATH="$QT_ROOT/qml"
export QT_PLUGIN_PATH="$QT_ROOT/plugins"

echo "🚀 启动应用..."
exec "$APP" "$@"
