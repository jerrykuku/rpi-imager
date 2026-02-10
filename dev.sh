#!/bin/bash
# 快速开发脚本：增量编译 + 立即运行
# 用法: ./dev.sh

set -e

BUILD_DIR="$(dirname "$0")/build"
QT_ROOT="/opt/Qt/6.9.3/macos"
APP="$BUILD_DIR/rpi-imager.app/Contents/MacOS/rpi-imager"

# 检查是否需要重新配置 CMake（使用 Ninja）
if [[ ! -f "$BUILD_DIR/build.ninja" ]]; then
    echo "🔧 检测到需要配置 Ninja 构建系统..."
    $(dirname "$0")/build-ninja.sh --reconfigure rpi-imager
else
    # 增量编译（只重新编译改动的文件）
    echo "⏳ 编译中..."
    START=$(date +%s)
    ninja -C "$BUILD_DIR" rpi-imager 2>&1 | tail -5
    END=$(date +%s)
    echo "✅ 编译完成 ($(($END - $START))s)"
fi

echo "🚀 启动应用..."
exec "$APP" "$@"
