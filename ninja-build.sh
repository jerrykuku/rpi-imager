#!/bin/bash
# 快速 Ninja 构建命令
# 用法: ./ninja-build.sh [目标]

exec "$(dirname "$0")/build-ninja.sh" "$@"