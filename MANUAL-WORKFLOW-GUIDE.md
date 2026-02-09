# 手动触发工作流指南 / Manual Workflow Trigger Guide

## 概述 / Overview

ZimaOS Imager 现在支持通过 GitHub Actions 手动触发构建，允许您完全控制构建过程。

ZimaOS Imager now supports manually triggered builds via GitHub Actions, giving you full control over the build process.

## 可用的工作流 / Available Workflows

### 1. 单平台手动构建 / Single Platform Manual Builds

#### Linux 构建 (build.yml)
- **位置**: `.github/workflows/build.yml`
- **用途**: 构建 Linux AppImage
- **时间**: ~60 分钟

#### Windows 构建 (build-windows.yml)
- **位置**: `.github/workflows/build-windows.yml`
- **用途**: 构建 Windows ZIP 包
- **时间**: ~15 分钟

#### macOS 构建 (build-macos.yml)
- **位置**: `.github/workflows/build-macos.yml`
- **用途**: 构建 macOS DMG
- **时间**: ~15 分钟

### 2. 全平台手动构建 / All Platforms Manual Build

#### 手动构建所有平台 (manual-build-all.yml)
- **位置**: `.github/workflows/manual-build-all.yml`
- **用途**: 一次性构建所有平台或选定平台
- **时间**: ~60 分钟（并行构建）

## 输入参数 / Input Parameters

所有手动触发工作流支持以下参数：

All manual trigger workflows support these parameters:

### 通用参数 / Common Parameters

| 参数 / Parameter | 类型 / Type | 必需 / Required | 默认值 / Default | 说明 / Description |
|------------------|-------------|-----------------|------------------|-------------------|
| `version` | string | No | auto | 版本号（如 v1.0.0 或自定义名称）/ Version number |
| `build_type` | choice | No | Release/MinSizeRel | 构建类型 / Build type |
| `create_release` | boolean | No | false | 是否创建 GitHub Release / Create release |
| `qt_version` | string | No | varies | Qt 版本 / Qt version |

### manual-build-all.yml 特有参数 / Specific to manual-build-all.yml

| 参数 / Parameter | 类型 / Type | 必需 / Required | 默认值 / Default | 说明 / Description |
|------------------|-------------|-----------------|------------------|-------------------|
| `platforms` | choice | Yes | All platforms | 要构建的平台 / Platforms to build |
| `release_draft` | boolean | No | false | 创建草稿 Release / Create draft release |

### 构建类型选项 / Build Type Options

- **Release**: 优化的发布版本 / Optimized release build
- **MinSizeRel**: 最小大小的发布版本 / Minimum size release
- **Debug**: 调试版本（包含调试符号）/ Debug build with symbols

## 使用方法 / How to Use

### 方法 1: GitHub Web 界面 / Method 1: GitHub Web Interface

#### 单平台构建 / Single Platform Build

1. **前往 Actions 标签页** / Go to Actions tab
   ```
   https://github.com/jerrykuku/rpi-imager/actions
   ```

2. **选择工作流** / Select workflow
   - Build ZimaOS Imager (Linux)
   - Build Windows
   - Build macOS

3. **点击 "Run workflow"** / Click "Run workflow"

4. **填写参数** / Fill in parameters:
   - **Branch**: 选择分支（通常是 main）/ Select branch (usually main)
   - **version**: 输入版本号，如 `v1.0.0-test` 或留空使用自动版本
   - **build_type**: 选择构建类型
   - **create_release**: 勾选以创建 Release
   - **qt_version**: 通常保持默认值

5. **点击绿色 "Run workflow" 按钮** / Click green "Run workflow" button

#### 全平台构建 / All Platforms Build

1. **前往 Actions → Manual Build All Platforms**

2. **点击 "Run workflow"**

3. **填写参数** / Fill parameters:
   - **version**: `v1.0.0` 或 `v1.0.0-rc1`（必需）/ Required
   - **platforms**: 选择要构建的平台 / Choose platforms
     - All (Linux + Windows + macOS) - 推荐 / Recommended
     - Linux only
     - Windows only
     - macOS only
     - Linux + Windows
     - Linux + macOS
     - Windows + macOS
   - **build_type**: Release（推荐）/ Recommended
   - **create_release**: 勾选以自动创建 Release
   - **release_draft**: 勾选以创建草稿 Release

4. **点击 "Run workflow"**

### 方法 2: GitHub CLI / Method 2: GitHub CLI

#### 安装 GitHub CLI / Install GitHub CLI

```bash
# macOS
brew install gh

# Linux
# See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Windows
# See: https://github.com/cli/cli#windows
```

#### 登录 / Login

```bash
gh auth login
```

#### 触发单平台构建 / Trigger Single Platform Build

```bash
# Linux
gh workflow run build.yml \
  --ref main \
  -f version=v1.0.0-test \
  -f build_type=Release \
  -f create_release=false

# Windows
gh workflow run build-windows.yml \
  --ref main \
  -f version=v1.0.0-test \
  -f build_type=MinSizeRel \
  -f create_release=false

# macOS
gh workflow run build-macos.yml \
  --ref main \
  -f version=v1.0.0-test \
  -f build_type=MinSizeRel \
  -f create_release=false
```

#### 触发全平台构建 / Trigger All Platforms Build

```bash
# 构建所有平台
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true \
  -f release_draft=false

# 仅构建 Linux 和 Windows
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0-rc1 \
  -f platforms="Linux + Windows" \
  -f build_type=Release \
  -f create_release=true

# 创建草稿 Release
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0-beta1 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true \
  -f release_draft=true
```

### 方法 3: API 调用 / Method 3: API Call

```bash
# 使用 curl 触发工作流
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/jerrykuku/rpi-imager/actions/workflows/manual-build-all.yml/dispatches \
  -d '{
    "ref": "main",
    "inputs": {
      "version": "v1.0.0",
      "platforms": "All (Linux + Windows + macOS)",
      "build_type": "Release",
      "create_release": "true",
      "release_draft": "false"
    }
  }'
```

## 使用场景 / Use Cases

### 场景 1: 快速测试构建 / Quick Test Build

**目的**: 测试代码更改是否能成功构建

```bash
gh workflow run build.yml \
  --ref my-feature-branch \
  -f version=dev-test \
  -f build_type=Debug \
  -f create_release=false
```

**结果**: 
- 构建 Linux AppImage
- 不创建 Release
- Artifact 保留 30 天

### 场景 2: 创建候选版本 / Create Release Candidate

**目的**: 创建预发布版本供测试

```bash
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0-rc1 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true \
  -f release_draft=false
```

**结果**:
- 构建所有三个平台
- 自动创建 GitHub Release
- 标记为 Pre-release（因为包含 -rc）
- 所有产物上传到 Release

### 场景 3: 创建正式发布 / Create Official Release

**目的**: 发布正式版本

```bash
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true \
  -f release_draft=true
```

**结果**:
- 构建所有平台
- 创建草稿 Release
- 可以在发布前编辑 Release 说明
- 确认无误后发布

### 场景 4: 仅构建特定平台 / Build Specific Platform Only

**目的**: 快速构建单个平台用于测试

```bash
# 仅 Windows
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0-windows-test \
  -f platforms="Windows only" \
  -f build_type=MinSizeRel \
  -f create_release=false
```

**结果**:
- 仅构建 Windows 版本
- 节省时间（~15 分钟 vs ~60 分钟）
- Artifact 保留 30 天

### 场景 5: 创建自定义版本 / Create Custom Version

**目的**: 为特定客户或测试创建自定义版本

```bash
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0-customer-ABC \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true
```

## 监控构建 / Monitor Builds

### 查看构建状态 / Check Build Status

1. **Web 界面** / Web Interface:
   ```
   https://github.com/jerrykuku/rpi-imager/actions
   ```

2. **GitHub CLI**:
   ```bash
   # 查看所有运行
   gh run list
   
   # 查看特定运行的详细信息
   gh run view RUN_ID
   
   # 实时查看日志
   gh run watch RUN_ID
   ```

### 下载产物 / Download Artifacts

1. **从 Actions 页面** / From Actions Page:
   - 前往 Actions → 选择运行
   - 滚动到底部 Artifacts 区域
   - 点击下载

2. **使用 GitHub CLI** / Using GitHub CLI:
   ```bash
   # 列出产物
   gh run view RUN_ID
   
   # 下载所有产物
   gh run download RUN_ID
   
   # 下载特定产物
   gh run download RUN_ID -n artifact-name
   ```

## 故障排除 / Troubleshooting

### 问题 1: 工作流未出现在列表中 / Workflow Not Listed

**原因**: 工作流文件可能有语法错误

**解决**:
1. 检查 YAML 语法
2. 确保文件在 `.github/workflows/` 目录
3. 推送后等待几分钟

### 问题 2: 输入参数未显示 / Input Parameters Not Shown

**原因**: 需要 `workflow_dispatch` 事件

**解决**:
- 确保工作流包含 `workflow_dispatch:` 配置
- 刷新页面

### 问题 3: 构建失败 / Build Failed

**检查**:
1. 查看构建日志
2. 检查依赖是否可用
3. 验证参数值

**常见问题**:
- Qt 版本不存在
- 构建类型拼写错误
- 磁盘空间不足

### 问题 4: Release 未创建 / Release Not Created

**原因**:
- `create_release` 设置为 false
- 版本标签已存在
- 权限不足

**解决**:
1. 确认 `create_release=true`
2. 使用唯一的版本号
3. 检查仓库设置中的 Actions 权限

### 问题 5: 产物未上传 / Artifacts Not Uploaded

**原因**:
- 构建失败
- 文件未生成
- 路径配置错误

**解决**:
1. 检查构建日志
2. 验证产物路径
3. 确认构建成功

## 最佳实践 / Best Practices

### 1. 版本命名 / Version Naming

```
正式版本:    v1.0.0, v1.1.0, v2.0.0
候选版本:    v1.0.0-rc1, v1.0.0-rc2
Beta 版本:   v1.0.0-beta1, v1.0.0-beta2
测试版本:    v1.0.0-test, dev-test-feature-x
自定义版本:  v1.0.0-customer-ABC
```

### 2. 构建类型选择 / Build Type Selection

- **发布给用户**: Release 或 MinSizeRel
- **内部测试**: Release
- **调试问题**: Debug

### 3. Release 创建 / Release Creation

- **首次发布**: 使用 `release_draft=true`，检查后发布
- **自动发布**: 仅用于已验证的版本
- **测试构建**: 不创建 Release，使用 Artifacts

### 4. 平台选择 / Platform Selection

- **完整发布**: 所有平台
- **快速测试**: 单个平台
- **特定需求**: 按需选择

### 5. 构建频率 / Build Frequency

- 避免频繁触发（消耗资源）
- 使用测试分支进行实验
- 正式版本使用主分支

## 高级用法 / Advanced Usage

### 脚本自动化 / Script Automation

创建脚本自动触发构建：

```bash
#!/bin/bash
# build-release.sh

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

echo "Building ZimaOS Imager $VERSION..."

# 触发构建
gh workflow run manual-build-all.yml \
  --ref main \
  -f version="$VERSION" \
  -f platforms="All (Linux + Windows + macOS)" \
  -f build_type=Release \
  -f create_release=true \
  -f release_draft=true

echo "Build triggered! Check: https://github.com/jerrykuku/rpi-imager/actions"
```

使用:
```bash
chmod +x build-release.sh
./build-release.sh v1.0.0
```

### CI/CD 集成 / CI/CD Integration

在其他 CI/CD 系统中触发构建：

```yaml
# 例如: GitLab CI
trigger_github_build:
  script:
    - |
      curl -X POST \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github+json" \
        https://api.github.com/repos/jerrykuku/rpi-imager/actions/workflows/manual-build-all.yml/dispatches \
        -d "{\"ref\":\"main\",\"inputs\":{\"version\":\"v1.0.0\",\"platforms\":\"All (Linux + Windows + macOS)\"}}"
```

## 相关文档 / Related Documentation

- **多平台构建**: `MULTI-PLATFORM-BUILDS.md`
- **快速构建指南**: `QUICK-BUILD-GUIDE.md`
- **工作流图表**: `BUILD-WORKFLOWS-DIAGRAM.txt`
- **GitHub Actions 文档**: https://docs.github.com/en/actions

## 支持 / Support

如有问题，请:
1. 查看构建日志
2. 检查本文档
3. 提交 Issue: https://github.com/jerrykuku/rpi-imager/issues

---

**最后更新 / Last Updated**: 2026-02-09
**维护者 / Maintainer**: GitHub Actions Workflow Team
