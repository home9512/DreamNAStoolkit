# Check if running as administrator
if (! ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	# 取得目前腳本的完整路徑
	$scriptPath = $MyInvocation.MyCommand.Definition

	# 重新以管理員權限執行自身腳本
	Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs

	# 結束目前腳本
	exit
}

$SourceHost = "https://dreamnas.familyds.com/"
$SourceBody = "wp-content/uploads/2024/10/"
$TargetRoot = Join-Path -Path $Env:PUBLIC -ChildPath "Desktop"
$Systemdisk = Get-PSDrive -Name C

# 設定下載 URL 和儲存路徑
$FilePack = @(
	"Software_Toolkit_Windows_10_11_v2025.exe",
	"Software_Toolkit.zip",
	"7z.zip"
)
$FileHash = @(
	"B1C72F669E2E6E8DEFDFC6A22604C2718AE2095EB2C21C10748DC7BA06F31DD0",
	"4d13d3c58846ebbbfc37c11e9459bbb5af4921907368f21d647f74ab2a89e7e9",
	"CE5875A8AB8937C0102F2AF79E644E320E56D1C46C7332FD6C8A0B68B25B72F9"
)

function Download_And_Verify {
	param (
		[string]$SourceHost,
		[string]$SourceBody,
		[string]$File,
		[string]$Hash
	)
	$Source = $SourceHost += $SourceBody += $File
	$Target = Join-Path -Path $TargetRoot -ChildPath $File
	If (! (Test-Path $Target)) {
		Start-Process -FilePath "curl.exe" -ArgumentList "-C - -# -L -o `"$Target`" --url `"$Source`"" -NoNewWindow -Wait
	} else {
		Write-Host "於 $Env:PUBLIC 找到 $File。忽略下載！"
	}
	If (Test-Path $Target) {
		Write-Host "正在校驗 $File..."
		$Check_Hash = Get-FileHash -Path $Target -Algorithm SHA256
		If ($Check_Hash.hash -eq $Hash) {
			Write-Host "檔案 $File 校驗成功"
		} Else {
			Write-Host "檔案 $File 校驗失敗，請刪除 $File 檔案之後重新再下載一次！"
			exit
		}
	} else {
		Write-Host "下載檔案 $File 失敗，請再重新下載一次！"
		exit
	}
}

# 磁碟磁碟空間檢查
if (!($Systemdisk.Free -gt 12GB)) {
	Write-Host "系統磁碟空間不足，請至少空出 12 GB 以上的空間！"
	exit
}

# 輪巡下載檔案
For ($i = 0; $i -lt $FilePack.Length; $i++) {
	$Num = $i + 1
	Write-Host "正在下載 $($FilePack[$i]) ($Num/$($FilePack.Length))..."
	Download_And_Verify $SourceHost $SourceBody $FilePack[$i] $FileHash[$i]
}

# Execute the .exe file
$RunPath = Join-Path $TargetRoot -ChildPath $FilePack[0]
Start-Process -FilePath $RunPath
