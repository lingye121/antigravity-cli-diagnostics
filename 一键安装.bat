@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title Antigravity CLI 1.5.16 Eligibility Patcher (One-Click Install)
color 0B
pushd "%~dp0" >nul 2>&1

set "TARGET=%USERPROFILE%\.gemini\bin\agy.exe"

echo ===================================================
echo   Antigravity CLI 1.5.16 一键安装工具 (Windows x64)
echo ===================================================
echo.

if not exist "%TARGET%" (
    echo [ERROR] 找不到 agy.exe，请确保已安装 Antigravity CLI。
    pause
    exit /b 1
)

echo [提示] 正在检查文件状态并安装补丁，请不要关闭窗口...
echo.

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -NonInteractive -Command ^
    "$ErrorActionPreference = 'Stop';" ^
    "$src = [System.Environment]::ExpandEnvironmentVariables('%TARGET%');" ^
    "$bak = $src + '.bak';" ^
    "$expectedHash = 'EAEC8E3FC809DF032DD8C496A86F6D53351942EC6C5CB7215D04F2C72A85BFF8';" ^
    "$expectedOutHash = '77AB35FCF086044BE910696F1B60AC7BEC43F474D571CB5D5DCDF01B02B27B13';" ^
    "$offset = 0x02BEAA32;" ^
    "$srcStream = $null; $outStream = $null; $sha = $null; $tmp = $null; $ownTemp = $false; $result = 1;" ^
    "try {" ^
    "    $sha = [System.Security.Cryptography.SHA256]::Create();" ^
    "    $srcStream = [System.IO.File]::Open($src, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read);" ^
    "    $actualHash = [BitConverter]::ToString($sha.ComputeHash($srcStream)).Replace('-', '');" ^
    "    if ($actualHash -eq $expectedOutHash) {" ^
    "        Write-Host '[INFO] 您的 agy.exe 已经是修补版，无需重复安装！' -ForegroundColor Green;" ^
    "        $result = 0; exit $result;" ^
    "    };" ^
    "    if ($actualHash -ne $expectedHash) { throw '文件哈希不匹配，这不是官方 1.5.16 原版，无法安装。' };" ^
    "    Write-Host '[1/4] 原版校验通过。正在关闭后台进程...';" ^
    "    Stop-Process -Name agy -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 500;" ^
    "    if (-not (Test-Path -LiteralPath $bak)) {" ^
    "        Write-Host '[2/4] 备份原版至 agy.exe.bak...';" ^
    "        Copy-Item -LiteralPath $src -Destination $bak -Force;" ^
    "    } else {" ^
    "        Write-Host '[2/4] 发现旧备份，跳过备份。';" ^
    "    };" ^
    "    Write-Host '[3/4] 正在生成补丁并校验完整性...';" ^
    "    $tmp = Join-Path (Split-Path $src) ('.agy-patched-' + [Guid]::NewGuid().ToString('N') + '.tmp');" ^
    "    $outStream = [System.IO.File]::Open($tmp, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None);" ^
    "    $ownTemp = $true;" ^
    "    $srcStream.Position = 0; $srcStream.CopyTo($outStream);" ^
    "    $outStream.Position = $offset;" ^
    "    [byte[]]$replacement = 0x31,0xC0,0x90;" ^
    "    $outStream.Write($replacement, 0, $replacement.Length);" ^
    "    $outStream.Flush($true); $outStream.Position = 0;" ^
    "    $outHash = [BitConverter]::ToString($sha.ComputeHash($outStream)).Replace('-', '');" ^
    "    if ($outStream.Length -ne $srcStream.Length -or $outHash -ne $expectedOutHash) { throw '补丁校验失败。' };" ^
    "    $outStream.Dispose(); $outStream = $null; $srcStream.Dispose(); $srcStream = $null;" ^
    "    Write-Host '[4/4] 正在覆盖原文件...';" ^
    "    $rollback = $src + '.rollback-' + [Guid]::NewGuid().ToString('N') + '.bak';" ^
    "    [System.IO.File]::Replace($tmp, $src, $rollback);" ^
    "    $ownTemp = $false;" ^
    "    Write-Host '✅ 安装成功！现在您可以直接使用 agy 命令了。' -ForegroundColor Green;" ^
    "    $result = 0;" ^
    "} catch {" ^
    "    Write-Host ('[错误] ' + $_.Exception.Message) -ForegroundColor Red;" ^
    "} finally {" ^
    "    if ($null -ne $outStream) { $outStream.Dispose() };" ^
    "    if ($null -ne $srcStream) { $srcStream.Dispose() };" ^
    "    if ($null -ne $sha) { $sha.Dispose() };" ^
    "    if ($ownTemp -and $null -ne $tmp) { try { Remove-Item -LiteralPath $tmp -Force -ErrorAction Stop } catch {} };" ^
    "};" ^
    "exit $result"

set "RESULT=%ERRORLEVEL%"
popd
echo.
if not "%RESULT%"=="0" ( echo [失败] 安装未完成，请检查原文件及备份状态。 ) else ( echo [完成] 你现在可以在命令行输入 agy 来测试效果了。 )
pause
exit /b %RESULT%
