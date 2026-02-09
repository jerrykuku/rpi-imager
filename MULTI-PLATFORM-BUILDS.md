# Multi-Platform Build Workflows / 多平台构建工作流

## Overview / 概述

ZimaOS Imager now supports automated builds for three platforms:
- **Linux**: AppImage format
- **Windows**: Portable executable + installer
- **macOS**: DMG package

ZimaOS Imager 现在支持三个平台的自动化构建：
- **Linux**: AppImage 格式
- **Windows**: 便携可执行文件 + 安装程序
- **macOS**: DMG 包

## Build Workflows / 构建工作流

### 1. Linux Build (build.yml)

**Triggers / 触发条件:**
- Push to main, develop, or copilot branches
- Pull requests to main
- Tags matching `v*`
- Manual dispatch

**Output / 输出:**
- `ZimaOS-Imager-{version}-x86_64.AppImage`

**Build time / 构建时间:** ~60 minutes (includes Qt build from source)

### 2. Windows Build (build-windows.yml)

**Triggers / 触发条件:**
- Push to main, develop, or copilot branches
- Pull requests to main
- Tags matching `v*`
- Manual dispatch

**Output / 输出:**
- `ZimaOS-Imager-{version}-Windows-x64.zip`

**Build time / 构建时间:** ~15-20 minutes

**Features / 特性:**
- Uses Qt 6.7.2 with MinGW
- Creates portable Windows executable
- Bundles all dependencies
- Universal binary compatible with Windows 10+

### 3. macOS Build (build-macos.yml)

**Triggers / 触发条件:**
- Push to main, develop, or copilot branches
- Pull requests to main
- Tags matching `v*`
- Manual dispatch

**Output / 输出:**
- `ZimaOS-Imager-{version}-macOS.dmg`

**Build time / 构建时间:** ~15-20 minutes

**Features / 特性:**
- Uses Qt 6.7.2
- Universal binary (x86_64 + ARM64/Apple Silicon)
- Compatible with macOS 11.0+
- DMG package for easy installation

## Automatic Release Publishing / 自动发布到 Release

All three workflows automatically publish to GitHub Releases when a tag is pushed:

所有三个工作流在推送 tag 时自动发布到 GitHub Release：

```bash
# Create and push a tag
git tag v1.0.0
git push origin v1.0.0
```

This will:
1. Trigger all three build workflows
2. Build for Linux, Windows, and macOS
3. Upload artifacts to the same GitHub Release
4. Generate release notes automatically

这将会：
1. 触发所有三个构建工作流
2. 为 Linux、Windows 和 macOS 构建
3. 将所有产物上传到同一个 GitHub Release
4. 自动生成发布说明

## Manual Builds / 手动构建

You can manually trigger any workflow from the GitHub Actions tab:

你可以从 GitHub Actions 标签页手动触发任何工作流：

1. Go to **Actions** tab
2. Select the workflow (Build Linux/Windows/macOS)
3. Click **Run workflow**
4. Select the branch
5. Click **Run workflow** button

## Build Artifacts / 构建产物

All builds upload artifacts that are available for 30 days:

所有构建都会上传产物，保留 30 天：

- **Linux**: `ZimaOS-Imager-Linux-x86_64`
- **Windows**: `ZimaOS-Imager-Windows-x64`
- **macOS**: `ZimaOS-Imager-macOS`

## Platform-Specific Notes / 平台特定说明

### Linux
- Built on Ubuntu 20.04 for maximum compatibility
- Uses custom Qt build optimized for size
- AppImage is portable and works on most distributions

### Windows
- Built with MinGW for better compatibility
- No installer required - portable executable
- All Qt dependencies bundled
- Tested on Windows 10 and 11

### macOS
- Universal binary supports both Intel and Apple Silicon
- DMG provides easy drag-and-drop installation
- Requires macOS 11.0 (Big Sur) or later

## Troubleshooting / 故障排除

### Build Fails / 构建失败

1. Check the Actions tab for detailed logs
2. Common issues:
   - Qt installation failures (usually network-related)
   - CMake configuration errors (check dependencies)
   - Packaging errors (check disk space)

### Release Not Created / Release 未创建

Make sure:
1. You pushed a tag (not just committed)
2. Tag format is `v*` (e.g., `v1.0.0`)
3. GITHUB_TOKEN has write permissions

### Artifact Not Found / 找不到产物

If the artifact is not found:
1. Check if the build completed successfully
2. Look in the Actions tab → Workflow run → Artifacts section
3. Artifacts expire after 30 days

## Version Tagging / 版本标记

Use semantic versioning for releases:

使用语义化版本进行发布：

```bash
# Release version
git tag v1.0.0

# Release candidate
git tag v1.0.0-rc1

# Beta version
git tag v1.0.0-beta1

# Alpha version
git tag v1.0.0-alpha1
```

Pre-release versions (rc, beta, alpha) are marked as "pre-release" on GitHub.

预发布版本 (rc, beta, alpha) 会在 GitHub 上标记为"预发布"。

## Development Builds / 开发构建

Builds from branches (non-tag commits) will:
- Generate artifacts but NOT create releases
- Use git describe for version naming
- Be available for 30 days

来自分支的构建（非 tag 提交）将会：
- 生成产物但不创建 release
- 使用 git describe 命名版本
- 保留 30 天

## CI/CD Pipeline Summary / CI/CD 流程概述

```
Push/PR → Three Parallel Workflows
            ├── Linux (60 min)
            ├── Windows (15 min)  
            └── macOS (15 min)
                    ↓
            Upload Artifacts (30 days)
                    ↓
        [If Tagged] Create GitHub Release
                    ↓
            Publish all platform builds
```

## FAQ

**Q: Why are there separate workflow files?**
A: Each platform has different requirements and build times. Separate workflows allow them to run in parallel and fail independently.

**Q: Can I download builds without creating a release?**
A: Yes! All builds are available as artifacts in the Actions tab for 30 days.

**Q: How do I create a release with all three platforms?**
A: Just push a tag. All three workflows will automatically publish to the same release.

**Q: What if one platform fails?**
A: Other platforms will continue building and publishing. You can re-run failed workflows individually.

**Q: 为什么有独立的工作流文件？**
A: 每个平台有不同的需求和构建时间。独立的工作流允许并行运行和独立失败。

**Q: 可以不创建 release 就下载构建吗？**
A: 可以！所有构建在 Actions 标签页中作为产物保留 30 天。

**Q: 如何创建包含所有三个平台的 release？**
A: 只需推送一个 tag。所有三个工作流会自动发布到同一个 release。

**Q: 如果某个平台失败了怎么办？**
A: 其他平台会继续构建和发布。你可以单独重新运行失败的工作流。

---

**Last Updated:** 2026-02-09
**Maintained by:** GitHub Actions
