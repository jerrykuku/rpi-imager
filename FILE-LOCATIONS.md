# 文件位置指南 / File Locations Guide

## 📁 仓库位置 / Repository Location

```
/home/runner/work/rpi-imager/rpi-imager
```

## 🎯 重要文件和目录 / Important Files and Directories

### 源代码 / Source Code
```
src/                    - 主要源代码目录
├── CMakeLists.txt      - CMake 构建配置
├── main.cpp            - 主程序入口
├── main.qml            - 主界面文件
├── imagewriter.cpp     - 核心镜像写入逻辑
├── wizard/             - 向导界面 QML 文件
├── linux/              - Linux 特定代码
├── windows/            - Windows 特定代码
└── mac/                - macOS 特定代码
```

### 文档 / Documentation
```
README.md               - 原始 README (Raspberry Pi Imager)
README-ZIMAOS.md        - ZimaOS Imager 配置指南
QUICK-START.md          - 快速入门指南
BUILD-SUCCESS.md        - 构建成功文档
DEPLOYMENT.md           - 部署指南
CONVERSION-SUMMARY.md   - 转换总结
GITHUB-ACTIONS-SETUP.md - GitHub Actions 配置
```

### 构建脚本 / Build Scripts
```
create-appimage.sh      - 创建 Linux AppImage 的脚本
create-appimage-cli.sh  - 创建 CLI AppImage 的脚本
create-embedded.sh      - 创建嵌入式版本的脚本
```

### 配置文件 / Configuration Files
```
.github/workflows/      - GitHub Actions 工作流
├── build.yml           - 主构建工作流
├── quick-build.yml     - 快速构建工作流
└── build-linux.yml     - Linux 高级构建工作流
```

## 🔨 构建输出 / Build Output

### 如何构建 / How to Build

#### 方法 1: 快速构建 (使用系统 Qt6)
```bash
# 安装依赖
sudo apt-get install -y \
  build-essential cmake git \
  libgnutls28-dev libarchive-dev \
  libcurl4-openssl-dev liblzma-dev \
  qt6-base-dev qt6-declarative-dev \
  qt6-svg-dev qt6-tools-dev

# 配置
mkdir build && cd build
cmake ../src -DCMAKE_BUILD_TYPE=Release

# 编译
make -j$(nproc)
```

**构建后文件位置:**
```
build/rpi-imager        - 可执行二进制文件 (3.4 MB)
```

#### 方法 2: 创建 AppImage (需要从源码构建 Qt)
```bash
# 构建 Qt (需要 sudo)
sudo ./qt/build-qt.sh

# 创建 AppImage
./create-appimage.sh
```

**构建后文件位置:**
```
ZimaOS_Imager-*.AppImage  - 完整的 AppImage 包 (~100-150 MB)
```

## 📝 配置文件 / Configuration Files

### OS 清单文件 / OS Manifest
```
配置的 URL:
https://raw.githubusercontent.com/IceWhaleTech/ZimaOS/main/zimaos-imager-manifest.json

本地示例:
doc/zimaos-manifest-example.json
```

### 核心配置 / Core Configuration
```
src/config.h            - 主配置文件
src/CMakeLists.txt      - 构建配置
```

## 🔍 如何找到文件 / How to Find Files

### 查找所有源文件
```bash
cd /home/runner/work/rpi-imager/rpi-imager
find src/ -name "*.cpp" -o -name "*.h" -o -name "*.qml"
```

### 查找构建输出
```bash
cd /home/runner/work/rpi-imager/rpi-imager
ls -lh build/rpi-imager 2>/dev/null || echo "还没有构建"
```

### 查找文档
```bash
cd /home/runner/work/rpi-imager/rpi-imager
ls -1 *.md
```

## 📦 关键文件说明 / Key File Descriptions

### 1. 可执行文件 / Executable
- **位置**: `build/rpi-imager` (构建后)
- **大小**: 3.4 MB
- **类型**: ELF 64-bit 可执行文件
- **用途**: ZimaOS 镜像写入器

### 2. 源代码入口 / Source Entry Points
- **main.cpp**: C++ 主程序入口
- **main.qml**: QML UI 主界面
- **imagewriter.cpp**: 核心功能实现

### 3. 配置文件 / Configuration
- **config.h**: 包含 OS 清单 URL 和其他配置
- **CMakeLists.txt**: 构建系统配置

### 4. 向导界面 / Wizard Interface
- **src/wizard/WizardContainer.qml**: 向导容器
- **src/wizard/OSSelectionStep.qml**: OS 选择步骤
- **src/wizard/StorageSelectionStep.qml**: 存储选择步骤

## 🚀 快速访问 / Quick Access

### 查看仓库结构
```bash
cd /home/runner/work/rpi-imager/rpi-imager
tree -L 2 -I '.git'  # 如果安装了 tree
# 或
ls -R | head -100
```

### 检查 Git 状态
```bash
cd /home/runner/work/rpi-imager/rpi-imager
git status
git log --oneline -10
```

### 查看最近的更改
```bash
cd /home/runner/work/rpi-imager/rpi-imager
git diff HEAD~1..HEAD --stat
```

## 📊 目录结构树 / Directory Tree

```
/home/runner/work/rpi-imager/rpi-imager/
├── .github/
│   └── workflows/          # GitHub Actions 工作流
├── src/                    # 源代码
│   ├── wizard/             # UI 向导
│   ├── linux/              # Linux 特定代码
│   ├── windows/            # Windows 特定代码
│   ├── mac/                # macOS 特定代码
│   ├── qmlcomponents/      # QML 组件
│   ├── icons/              # 图标资源
│   └── dependencies/       # 第三方依赖
├── doc/                    # 文档和示例
├── qt/                     # Qt 构建脚本
├── debian/                 # Debian 打包
├── build/                  # 构建输出 (运行 cmake 后创建)
└── [各种 .md 文档]         # 项目文档

```

## 💡 常见问题 / FAQ

### Q: 构建的二进制文件在哪？
A: 在 `build/rpi-imager` (需要先运行构建)

### Q: 如何查看所有文档？
A: `ls -1 /home/runner/work/rpi-imager/rpi-imager/*.md`

### Q: 源代码主入口在哪？
A: `src/main.cpp` 和 `src/main.qml`

### Q: 如何找到 OS 清单配置？
A: `src/config.h` 中的 `OSLIST_URL`

### Q: GitHub Actions 工作流在哪？
A: `.github/workflows/` 目录

---

**仓库根目录**: `/home/runner/work/rpi-imager/rpi-imager`
**当前分支**: `copilot/add-zimaos-image-writer`
**最后更新**: 2026-02-09
