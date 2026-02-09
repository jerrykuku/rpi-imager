# 快速构建指南 / Quick Build Guide

## 🚀 快速开始 / Quick Start

### 创建 Release (所有平台) / Create Release (All Platforms)

```bash
# 1. 创建 tag
git tag v1.0.0

# 2. 推送 tag
git push origin v1.0.0

# 3. 等待构建完成 (~60 分钟)
# 4. 检查 GitHub Releases 页面
```

✅ **自动完成的事情:**
- Linux AppImage 构建
- Windows ZIP 包构建
- macOS DMG 包构建
- 创建 GitHub Release
- 上传所有三个平台的产物
- 生成 Release 说明

## 📦 构建产物 / Build Outputs

| 平台 | 文件名 | 格式 |
|------|--------|------|
| Linux | `ZimaOS-Imager-v1.0.0-x86_64.AppImage` | AppImage |
| Windows | `ZimaOS-Imager-v1.0.0-Windows-x64.zip` | ZIP |
| macOS | `ZimaOS-Imager-v1.0.0-macOS.dmg` | DMG |

## 🎯 常见操作 / Common Operations

### 正式版本 / Stable Release
```bash
git tag v1.0.0
git push origin v1.0.0
```

### 候选版本 / Release Candidate
```bash
git tag v1.0.0-rc1
git push origin v1.0.0-rc1
```

### Beta 版本 / Beta Version
```bash
git tag v1.0.0-beta1
git push origin v1.0.0-beta1
```

### 开发构建 / Development Build
```bash
# 只需 push 到分支
git push origin develop

# 不会创建 Release，但会生成 Artifacts
```

## 🔍 检查构建状态 / Check Build Status

1. 前往 **Actions** 标签页
2. 查看最近的工作流运行
3. 三个工作流应该都在运行:
   - ✅ Build ZimaOS Imager (Linux)
   - ✅ Build Windows
   - ✅ Build macOS

## 📥 下载构建产物 / Download Artifacts

### 从 Releases (已发布版本)
1. 前往 **Releases** 页面
2. 选择版本
3. 下载对应平台的文件

### 从 Actions (开发构建)
1. 前往 **Actions** 标签页
2. 选择工作流运行
3. 滚动到 **Artifacts** 区域
4. 下载需要的平台产物

## 🛠️ 手动触发构建 / Manual Build Trigger

### 方法 1: GitHub Web UI
1. Actions → 选择工作流
2. Run workflow → 选择分支
3. Run workflow 按钮

### 方法 2: GitHub CLI
```bash
# Linux 构建
gh workflow run build.yml --ref main

# Windows 构建
gh workflow run build-windows.yml --ref main

# macOS 构建
gh workflow run build-macos.yml --ref main
```

## ⏱️ 构建时间 / Build Times

| 平台 | 时间 | 并行 |
|------|------|------|
| Linux | ~60 min | ✅ |
| Windows | ~15 min | ✅ |
| macOS | ~15 min | ✅ |
| **总计** | **~60 min** | ✅ |

## 🐛 故障排除 / Troubleshooting

### 构建失败 / Build Failed

**检查日志:**
1. Actions → 失败的工作流
2. 点击失败的作业
3. 查看详细日志

**常见问题:**
- Qt 安装失败 → 网络问题，重试
- CMake 配置失败 → 检查依赖
- 打包失败 → 检查磁盘空间

### Release 未创建 / Release Not Created

**确认:**
- ✅ 推送了 tag (不是 commit)
- ✅ Tag 格式是 `v*`
- ✅ 构建成功完成

### 产物未找到 / Artifact Not Found

**位置:**
- Actions → 工作流运行 → Artifacts
- 保留 30 天后自动删除

## 📚 详细文档 / Detailed Documentation

- **完整指南:** `MULTI-PLATFORM-BUILDS.md`
- **工作流图:** `BUILD-WORKFLOWS-DIAGRAM.txt`
- **文件位置:** `FILE-LOCATIONS.md`

## 💡 提示 / Tips

1. **并行构建:** 所有平台同时构建，节省时间
2. **自动发布:** Tag 推送自动触发 Release
3. **Artifacts:** 开发构建的产物保留 30 天
4. **预发布:** 使用 `-rc`, `-beta`, `-alpha` 标记预发布版本
5. **独立失败:** 一个平台失败不影响其他平台

## 🔗 相关链接 / Related Links

- GitHub Actions: https://github.com/features/actions
- Qt Installation: https://doc.qt.io/qt-6/get-and-install-qt.html
- Semantic Versioning: https://semver.org/

---

**快速参考 / Quick Reference:**
- 创建 Release: `git tag v1.0.0 && git push origin v1.0.0`
- 手动构建: Actions → Run workflow
- 下载产物: Actions → Artifacts 或 Releases
- 构建时间: ~60 分钟 (并行)

Last Updated: 2026-02-09
