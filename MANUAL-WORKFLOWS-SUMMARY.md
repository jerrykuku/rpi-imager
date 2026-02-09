# 手动触发工作流总结 / Manual Workflows Summary

## 🎯 快速参考 / Quick Reference

### 立即开始 / Get Started Now

**Web 界面 (推荐) / Web Interface (Recommended)**
```
1. https://github.com/jerrykuku/rpi-imager/actions
2. "Manual Build All Platforms" → "Run workflow"
3. 填写参数 → "Run workflow"
```

**命令行 / Command Line**
```bash
gh workflow run manual-build-all.yml \
  --ref main \
  -f version=v1.0.0 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f create_release=true
```

## 📊 可用工作流 / Available Workflows

| 工作流名称 | 平台 | 用途 | 时间 |
|-----------|------|------|------|
| **Manual Build All Platforms** ⭐ | 可选 | 批量构建所有或选定平台 | ~60 min |
| Build ZimaOS Imager | Linux | 单独构建 Linux AppImage | ~60 min |
| Build Windows | Windows | 单独构建 Windows 包 | ~15 min |
| Build macOS | macOS | 单独构建 macOS DMG | ~15 min |

## 🎯 常见操作 / Common Operations

### 1️⃣ 快速测试构建
```bash
gh workflow run build.yml \
  -f version=dev-test \
  -f build_type=Debug \
  -f create_release=false
```
**结果**: 测试构建，不创建 Release

### 2️⃣ 创建候选版本
```bash
gh workflow run manual-build-all.yml \
  -f version=v1.0.0-rc1 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f create_release=true
```
**结果**: 所有平台 + Pre-release

### 3️⃣ 创建正式发布
```bash
gh workflow run manual-build-all.yml \
  -f version=v1.0.0 \
  -f platforms="All (Linux + Windows + macOS)" \
  -f create_release=true \
  -f release_draft=true
```
**结果**: 所有平台 + 草稿 Release

### 4️⃣ 仅构建特定平台
```bash
gh workflow run manual-build-all.yml \
  -f version=v1.0.0-test \
  -f platforms="Windows only" \
  -f create_release=false
```
**结果**: 仅 Windows，节省时间

## 📝 输入参数 / Input Parameters

### 必需参数 (manual-build-all.yml)
- `version`: 版本号，如 `v1.0.0`

### 可选参数 (所有工作流)
- `platforms`: 平台选择（仅 manual-build-all）
- `build_type`: Release/MinSizeRel/Debug
- `create_release`: 是否创建 Release
- `release_draft`: 是否为草稿（仅 manual-build-all）
- `qt_version`: Qt 版本

## 🎨 平台选择 / Platform Selection

manual-build-all.yml 支持以下选项：
- ⭐ **All (Linux + Windows + macOS)** - 推荐
- Linux only
- Windows only
- macOS only
- Linux + Windows
- Linux + macOS
- Windows + macOS

## ✅ 验证清单 / Verification Checklist

构建完成后检查：
- [ ] 所有选定平台构建成功
- [ ] Artifacts 已上传
- [ ] Release 创建成功（如果启用）
- [ ] 版本号正确
- [ ] 产物可下载

## 📚 完整文档 / Full Documentation

- **详细指南**: `MANUAL-WORKFLOW-GUIDE.md`
- **构建文档**: `MULTI-PLATFORM-BUILDS.md`
- **快速指南**: `QUICK-BUILD-GUIDE.md`

## 🆘 获取帮助 / Get Help

1. 查看构建日志
2. 阅读 MANUAL-WORKFLOW-GUIDE.md
3. 提交 Issue

---

**最快方式 / Fastest Way:**
```
Actions → Manual Build All Platforms → Run workflow
```

Last Updated: 2026-02-09
