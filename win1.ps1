# ==============================================================================
# ☆Dream-NAS☆ 可愛版 Windows Toolkit 自動下載與校驗腳本 (修復網址斜線版)
# ==============================================================================

# 1. 自動檢查並主動提升為系統管理員（Admin）權限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    $scriptPath = $MyInvocation.MyCommand.Definition
    if ($scriptPath) {
        # 如果是跑實體檔案，直接重啟實體檔案
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    } else {
        # 如果使用者是用 irm | iex 在記憶體中執行，此時沒有檔案路徑 ($scriptPath 為空)
        # 重新向您的 TinyURL 短網址抓取最新的程式碼，並在新的 Admin 視窗中執行
        $remoteCmd = 'irm "https://tinyurl.com/4fjtv5tu" | iex'
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$remoteCmd`"" -Verb RunAs
    }
    exit
}

# 2. 設定基礎變數
$SourceHost = "https://dreamnas.familyds.com"
$SourceBody = "wp-content/uploads/2024/10/"
$TargetRoot = Join-Path -Path $Env:PUBLIC -ChildPath "Desktop"
$Systemdisk = Get-PSDrive -Name C

# 設定下載檔案清單與對應的 SHA256 雜湊值
$FilePack = @(
    "Software_Toolkit_Windows_10_11_v2025.1.exe",
    "Software_Toolkit.zip",
    "7z.zip"
)
$FileHash = @(
    "1A71D9220EBE2A8A38B0B3C79AE776F151F4556EFBF1F324865461C658AD87DA",
    "4d13d3c58846ebbbfc37c11e9459bbb5af4921907368f21d647f74ab2a89e7e9",
    "CE5875A8AB8937C0102F2AF79E644E320E56D1C46C7332FD6C8A0B68B25B72F9"
)

# 3. 下載與驗證函式
function Download_And_Verify {
    param (
        [string]$UrlHost,
        [string]$UrlBody,
        [string]$File,
        [string]$Hash
    )
    # 【已修復】在 UrlHost 和 UrlBody 之間加上正確的斜線 /，確保網址完全正確
    $Source = "${UrlHost}/${UrlBody}${File}"
    $Target = Join-Path -Path $TargetRoot -ChildPath $File

    if (!(Test-Path $Target)) {
        # 呼叫系統內建 curl.exe 進行斷點續傳與標準下載
        Start-Process -FilePath "curl.exe" -ArgumentList "-C - -# -L -o `"$Target`" --url `"$Source`"" -NoNewWindow -Wait
    } else {
        Write-Host "於桌面公開目錄找到 $File，跳過下載！" -ForegroundColor Green
    }

    if (Test-Path $Target) {
        Write-Host "正在校驗 $File 的 SHA256 雜湊值..." -ForegroundColor Cyan
        $Check_Hash = Get-FileHash -Path $Target -Algorithm SHA256
        if ($Check_Hash.Hash -eq $Hash) {
            Write-Host "檔案 $File 校驗成功！" -ForegroundColor Green
        } else {
            Write-Host "檔案 $File 校驗失敗！損壞或非官方發布版本。" -ForegroundColor Red
            Write-Host "請手動刪除桌面的 $File 後，重新執行此工具。" -ForegroundColor Yellow
            Read-Host "請按 Enter 鍵結束..."
            exit
        }
    } else {
        Write-Host "下載檔案 $File 失敗，請確認網路連線是否正常。" -ForegroundColor Red
        Read-Host "請按 Enter 鍵結束..."
        exit
    }
}

# 4. 磁碟剩餘空間檢查
if (!($Systemdisk.Free -gt 12GB)) {
    Write-Host "錯誤：系統磁碟空間不足！請至少保留 12 GB 以上的可用空間。" -ForegroundColor Red
    Read-Host "請按 Enter 鍵結束..."
    exit
}

# 5. 迴圈執行多檔案下載
for ($i = 0; $i -lt $FilePack.Length; $i++) {
    $Num = $i + 1
    Write-Host "==================================================" -ForegroundColor Yellow
    Write-Host "正在處理 ($Num/$($FilePack.Length)): $($FilePack[$i])" -ForegroundColor Yellow
    Download_And_Verify -UrlHost $SourceHost -UrlBody $SourceBody -File $FilePack[$i] -Hash $FileHash[$i]
}

# 6. 執行主要安裝程式
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host "所有必要組件下載完成！正在啟動 Dream-NAS 軟體整合包..." -ForegroundColor Green
$RunPath = Join-Path $TargetRoot -ChildPath $FilePack[0]
Start-Process -FilePath $RunPath
