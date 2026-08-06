#!/usr/bin/env pwsh
# Sync bucket/background-studio.json to the latest host GitHub release.
param(
    [string]$Version
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $repoRoot "bucket/background-studio.json"

if (-not $Version) {
    $release = gh release view --repo background-studio/background-studio --json tagName,assets | ConvertFrom-Json
    $Version = $release.tagName.TrimStart("v")
} else {
    $Version = $Version.TrimStart("v")
    $release = gh release view "v$Version" --repo background-studio/background-studio --json tagName,assets | ConvertFrom-Json
}

$asset = $release.assets | Where-Object { $_.name -eq "Background.Studio_${Version}_x64-setup.exe" } | Select-Object -First 1
if (-not $asset) {
    throw "Release v$Version 没有 Background.Studio_${Version}_x64-setup.exe"
}

$digest = $asset.digest
if (-not $digest) {
    # fallback: ask API
    $api = gh api "repos/background-studio/background-studio/releases/tags/v$Version" | ConvertFrom-Json
    $digest = ($api.assets | Where-Object { $_.name -eq "Background.Studio_${Version}_x64-setup.exe" }).digest
}
if (-not $digest) {
    throw "找不到 asset digest"
}
$hash = ($digest -replace '^sha256:', '').ToLowerInvariant()

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$manifest.version = $Version
$manifest.architecture.'64bit'.url = "https://github.com/background-studio/background-studio/releases/download/v$Version/Background.Studio_${Version}_x64-setup.exe#/dl.7z"
$manifest.architecture.'64bit'.hash = $hash

$json = $manifest | ConvertTo-Json -Depth 20
# ConvertTo-Json may reorder; write with stable UTF-8
[System.IO.File]::WriteAllText($manifestPath, ($json + "`n"))
Write-Host "Updated background-studio.json -> $Version ($hash)"
