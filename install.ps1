# harness-kit 安装脚本（Windows，兼容 Windows PowerShell 5.1 与 pwsh 7+）。幂等：重复运行结果一致。
# 用法：powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = "Stop"
$Kit = Split-Path -Parent $MyInvocation.MyCommand.Path
$Begin = "<!-- harness-kit:BEGIN -->"
$End = "<!-- harness-kit:END -->"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# 1. Claude skills（覆盖式，跟随仓库为准）
$skillsDst = Join-Path $env:USERPROFILE ".claude\skills"
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
foreach ($s in "harness-init", "harness-task", "harness-maintain") {
    $dst = Join-Path $skillsDst $s
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse (Join-Path $Kit "claude-skills\$s") $dst
    Write-Output "skill: $s"
}

# 2. Codex prompts（覆盖式）
$promptsDst = Join-Path $env:USERPROFILE ".codex\prompts"
New-Item -ItemType Directory -Force -Path $promptsDst | Out-Null
Copy-Item (Join-Path $Kit "codex-prompts\harness-*.md") $promptsDst -Force
Write-Output "codex prompts: harness-init / harness-task / harness-maintain"

# 3. 全局文件的 marker 块 upsert：删除已有块，追加仓库最新片段；块外内容原样保留。
function Update-KitBlock([string]$File, [string]$Snippet) {
    $dir = Split-Path -Parent $File
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $local = @()
    if (Test-Path $File) {
        $skip = $false
        foreach ($l in @(Get-Content $File -Encoding UTF8)) {
            if ($l -eq $Begin) { $skip = $true; continue }
            if ($l -eq $End) { $skip = $false; continue }
            if (-not $skip) { $local += $l }
        }
    }
    # 去掉末尾空行，防止重复运行时空行累积
    while ($local.Count -gt 0 -and $local[$local.Count - 1] -eq "") {
        if ($local.Count -eq 1) { $local = @() }
        else { $local = $local[0..($local.Count - 2)] }
    }
    $out = @()
    if ($local.Count -gt 0) { $out += $local; $out += "" }
    $out += $Begin
    $out += @(Get-Content $Snippet -Encoding UTF8)
    $out += $End
    # PS5.1 的 Set-Content -Encoding UTF8 会带 BOM，这里强制无 BOM UTF-8
    [System.IO.File]::WriteAllLines($File, [string[]]$out, $Utf8NoBom)
    Write-Output "block: $File"
}

Update-KitBlock (Join-Path $env:USERPROFILE ".claude\CLAUDE.md") (Join-Path $Kit "global\claude-global.md")
Update-KitBlock (Join-Path $env:USERPROFILE ".codex\AGENTS.md") (Join-Path $Kit "global\codex-global.md")

Write-Output "harness-kit installed."
