# Background Studio Scoop bucket

Scoop 安装 / 更新 [Background Studio](https://github.com/background-studio/background-studio) 壳。

## 安装

```powershell
scoop bucket add background-studio https://github.com/background-studio/scoop-bucket
scoop install background-studio
```

## 更新

```powershell
scoop update background-studio
```

## 说明

- 从 GitHub Release 的 NSIS 安装包用 `#/dl.7z` 解压（便携安装到 Scoop 目录）。
- 插件与配置仍在 `%LOCALAPPDATA%\BackgroundStudio`（或壳内设置的数据目录），与 NSIS 安装版共用。
- 维护者可用 bucket 内 `bin/sync-host.ps1` 或 Actions「Sync from host release」同步最新版本。
