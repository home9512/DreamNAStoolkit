@echo off
pushd %~dp0
set "BasePath=%~dp0"

:CheckUAC
:: 清除回傳代碼
cmd /c "exit /b 0"
:: 檢測 Admin 權限的存取
reg.exe query HKU\S-1-5-19 >nul 2>nul
if %errorlevel% == 0 (
	goto app1
)

:GetUAC
:: 如果沒有用 Admin 權限執行，則嘗試用 Admin 權限以 PowerShell 重新執行批次檔
SET "ThisBatch=%~fp0"
powershell -NoProfile -Command Start-Process '"%ThisBatch%"' -Verb RunAs
exit /b 0
:app1
mode con cols=106 lines=45
set zipFile=7z.zip
set destinationFolder=7z

if exist "%destinationFolder%" (
    echo 資料夾 %destinationFolder% 已存在，將略過解壓縮。
) else (
    if exist "%zipFile%" (
        echo 解壓縮 %zipFile% 到 %destinationFolder%...
        powershell -command "Expand-Archive -Path '%zipFile%' -DestinationPath '%destinationFolder%'"
        echo 解壓縮完成！
    ) else (
        echo 找不到 %zipFile%。
    )
)
set "BasePath=%~dp0"
set "sevenZipPath=%BasePath%7z\7z.exe"
set "zipFilePath=%BasePath%Software_Toolkit.zip"
set "destinationPath1=%BasePath%"
cd /d "%BasePath%"
set password="☆Dream-NAS☆ 個人網站 Dream"
echo 解壓縮 %zipFilePath% ...
%sevenZipPath% x %zipFilePath% -o%destinationPath1% -p%password% -aos
echo 解壓縮完成！
echo.
echo 刪除壓縮檔以及下載檔案
del %zipFilePath%
del %zipFile%
del "%BasePath%win.ps1"
rmdir /s /q "%BasePath%7z"
if exist "C:\Windows\Setup\Scripts" (
    echo 找到資料夾，正在刪除...
    rd /s /q "C:\Windows\Setup\Scripts"
    echo 已刪除完成
) else (
    echo 資料夾不存在，無需刪除
)
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
goto home
:home
title Windows 10/11_(線上/離線軟體工具包)_v2025
echo ========================================================================================================
echo                                              --- 內含軟體 --- 
echo.
echo WinRAR、DirectX、Java、Office 365、Adobe Acrobat Pro、Notepad++、VC++2005~2022、Google Chrome
echo.    
echo KMS-Cangshui.net(滄水的)、PotPlayer、顯示卡與主機板驅動(需連網)、OfficeToolPlus、NET 8.0 Desktop Runtime
echo.
echo Microsoft-Activation-Scripts、LTSC加回微軟商店、Office 365 啟用工具、隱藏部份功能、遊戲平台
echo.
echo 華碩輸入法、NanaZip(win11)、YouTube Music
echo ========================================================================================================
echo                   --- 本次採用PowerShell指令下載此軟體工具包，ISO檔容量會大幅減少 ---
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
echo.
set /p choose1=是否開始使用? 請輸入(Y/y｜N/n)：
if /i "%choose1%"=="y" goto Install
if /i "%choose1%"=="n" exit
                     ___                                          _   _  _____  ___   
                    (  _`\                                       ( ) ( )(  _  )(  _`\ 
                    | | ) | _ __   __     _ _   ___ ___   ______ | `\| || (_) || (_(_)
                    | | | )( '__)/'__`\ /'_` )/' _ ` _ `\(______)| , ` ||  _  |`\__ \ 
                    | |_) || |  (  ___/( (_| || ( ) ( ) |        | |`\ || | | |( )_) |
                    (____/'(_)  `\____)`\__,_)(_) (_) (_)        (_) (_)(_) (_)`\____)
                                                                  

:Install
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo                  請輸入數字選擇您的系統，之後就會執行安裝程序，也可以按數字"9"離開
echo =========================================================================================================
echo.
echo 【1】Windows 10 安裝軟體工具包 x64 (半自動/需連網)     【6】遊戲平台
echo.
echo 【2】Windows 11 安裝軟體工具包 x64 (半自動/需連網)     【7】☆Dream-NAS☆ 個人網站、贊助
echo.
echo 【3】Windows.Office 啟用金鑰程式                       【8】軟體工具包內容說明  
echo.
echo 【4】修改 Windows 10/11 部分功能                       【9】離開
echo.
echo 【5】顯示卡、主機板驅動(需連網)
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c2=請選擇選項：
if "%c2%"=="1" goto win10x64
if "%c2%"=="2" goto win11x64
if "%c2%"=="3" goto win
if "%c2%"=="4" goto Widgets
if "%c2%"=="5" goto exe
if "%c2%"=="6" goto Game
if "%c2%"=="7" goto Dream
if "%c2%"=="8" goto Dream1
if "%c2%"=="9" exit
                     ___                                          _   _  _____  ___   
                    (  _`\                                       ( ) ( )(  _  )(  _`\ 
                    | | ) | _ __   __     _ _   ___ ___   ______ | `\| || (_) || (_(_)
                    | | | )( '__)/'__`\ /'_` )/' _ ` _ `\(______)| , ` ||  _  |`\__ \ 
                    | |_) || |  (  ___/( (_| || ( ) ( ) |        | |`\ || | | |( )_) |
                    (____/'(_)  `\____)`\__,_)(_) (_) (_)        (_) (_)(_) (_)`\____)
                                                                                                                                 


:Widgets
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】關閉 UserChoice Protection Driver 「UCPD服務」    【9】隱藏/停用 Windows 11 部分功能   
echo.
echo 【2】開啟 UserChoice Protection Driver 「UCPD服務」    【10】隱藏/停用 Windows 10 部分功能
echo.
echo 【3】隱藏 Windows 11 工作列的小工具(關閉UCPD服務)      【11】新增/移除 右鍵管理員取得所有權
echo.
echo 【4】顯示 Windows 11 工作列的小工具(關閉UCPD服務)      【12】使用者帳戶控制設定調整(UAC調整)
echo.
echo 【5】隱藏 Windows 10 工作列的小工具(關閉UCPD服務)      【13】啟用 NET Framework 3.5
echo.
echo 【6】顯示 Windows 10 工作列的小工具(關閉UCPD服務)      【14】公用網路切換私人網路
echo.
echo 【7】停用 Windows 11 OverlayMinFPS                     【15】私人網路切換公用網路       
echo.
echo 【8】移除 Windows 11 OverlayMinFPS                     【16】 回上一頁   
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c15=請選擇選項：
if "%c15%"=="1" goto Widgets1
if "%c15%"=="2" goto Widgets2
if "%c15%"=="3" goto Widgets3
if "%c15%"=="4" goto Widgets4
if "%c15%"=="5" goto Widgets6
if "%c15%"=="6" goto Widgets7
if "%c15%"=="7" goto Widgets9
if "%c15%"=="8" goto Widgets10
if "%c15%"=="9" goto Widgets5
if "%c15%"=="10" goto Widgets8
if "%c15%"=="11" goto win10
if "%c15%"=="12" goto uac
if "%c15%"=="13" goto Widgets13
if "%c15%"=="14" goto Widgets14
if "%c15%"=="15" goto Widgets15
if "%c15%"=="16" goto Install

:Widgets13
cls
echo 啟用 NET Framework 3.5
powershell -ExecutionPolicy Bypass -File "%BasePath%軟體工具包\reg\net35.ps1"
goto Widgets

:Widgets14
cls
echo 公用網路切換私人網路
powershell -ExecutionPolicy Bypass -Command "Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq 'Public'} | Set-NetConnectionProfile -NetworkCategory Private"
goto Widgets

:Widgets15
cls
echo 私人網路切換公用網路
powershell -ExecutionPolicy Bypass -Command "Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq 'Private'} | Set-NetConnectionProfile -NetworkCategory Public"
goto Widgets

:Widgets1
cls
echo 關閉 UserChoice Protection Driver 「UCPD服務」
echo.
sc config UCPD start=disabled
schtasks /change /Disable /TN "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity"
echo.
echo 請重新啟動電腦，才能關閉UCPD服務，按下任意鍵將在5秒後重新啟動
echo.
pause
shutdown /r /t 5 /c "系統將在 5 秒後重新啟動！"

:Widgets2
cls
echo 開啟 UserChoice Protection Driver 「UCPD服務」
echo.
sc config UCPD start=auto
schtasks /change /Enable /TN "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity"
echo.
echo 請重新啟動電腦，才能開啟UCPD服務，按下任意鍵將在5秒後重新啟動
echo.
pause
shutdown /r /t 5 /c "系統將在 5 秒後重新啟動！"

:Widgets3
cls
echo 隱藏 Windows 11 工作列的小工具
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Remove_Widgets_button_on_taskbar_in_Windows_11.reg
echo 已隱藏完成
goto Widgets

:Widgets4
cls
echo 顯示 Windows 11 工作列的小工具
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Add_Widgets_button_on_taskbar_in_Windows_11.reg
echo 已顯示完成
goto Widgets

:Widgets5
cls
echo ========================================================================================================
echo                                         --- 隱藏/停用說明 ---
echo 縮小搜尋圖示/登入介面停用透明效果/Windows安全性通知圖示/開始功能表"最常用的軟體列表"/深入了解此圖片圖示
echo 右鍵以管理員身份開啟終端/捷徑小箭頭/執行檔案小盾牌/開啟程式安全警告/Smartscreen 應用篩選器
echo 快速存取最近使用的檔案/快速存取常用資料夾/桌布更換 JPEG 壓縮/建立捷徑時不加「快捷方式」文字
echo ========================================================================================================
set /p choose8=是否可以接受? 請輸入(Y/y｜N/n)：
if /i "%choose8%"=="y" goto Widgets51
if /i "%choose8%"=="n" goto Widgets

:Widgets51
cls
cd /d "%BasePath%"軟體工具包\reg
echo 縮小搜尋圖示
regedit.exe/s SearchBoxOn.reg
echo 已切換完成
echo.
echo 切換 Windows 11 登入介面停用透明效果
regedit.exe/s Disable_acrylic_blur_effect_on_Sign-in_sceen_background_for_all_users.reg
echo 已切換完成
echo.
echo 隱藏 Windows 安全性 通知圖示
regedit.exe/s Disable_Windows_Security_notification_icon_for_all_users.reg
echo 已隱藏完成
echo.
echo 隱藏 開始功能表"最常用的軟體列表"
regedit.exe/s Always_hide_Most_Used_list_in_Start_menu_for_all_users.reg
echo 已隱藏完成
echo.
echo 隱藏 深入了解此圖片圖示
regedit.exe/s Remove_Learn_about_this_picture_desktop_icon.reg
echo 已隱藏完成
echo.
echo 停用 桌布更換 JPEG 壓縮
regedit.exe/s Disable_JPEG_Desktop_wallpaper_import_quality.reg
echo 已停用完成
echo.
echo 新增 右鍵以管理員身份開啟終端
regedit.exe/s Add_Open_in_Windows_Terminal_as_administrator.reg
echo 已新增完成
echo.
echo 隱藏 捷徑小箭頭/執行檔案小盾牌/開啟程式安全警告/Smartscreen 應用篩選器/建立捷徑時不加「快捷方式」文字/最近使用的檔案/常用資料夾
set "BlankIcon=C:\Windows\Blank.ico"
copy /y "%BasePath%軟體工具包\reg\Blank.ico" "%BlankIcon%" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_EXPAND_SZ /d "%BlankIcon%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 77 /t REG_EXPAND_SZ /d "%BlankIcon%" /f
ie4uinit.exe -show >nul 2>&1
set "REGDATA=.bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "off" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v Link /t REG_BINARY /d 00000000 /f
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer" /v Link /t REG_BINARY /d 00000000 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
echo 已隱藏完成
echo.
echo 正在重新啟動 檔案總管
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
goto Widgets

:Widgets6
cls
echo 隱藏 Windows 10 工作列的小工具
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Disable_News_and_Interests_on_taskbar_feature_for_all_users.reg
echo 已隱藏完成
goto Widgets

:Widgets7
cls
echo 顯示 Windows 10 工作列的小工具
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Add_News_and_Interests_on_taskbar_feature_for_all_users.reg
echo 已顯示完成
goto Widgets

:Widgets8
cls
echo ========================================================================================================
echo                                            --- 隱藏/停用說明 ---
echo 立即開會圖示/登入介面停用透明效果/Windows安全性通知圖示/開啟功能表"最近新增"/桌布更換 JPEG 壓縮
echo 開啟程式安全警告/Smartscreen 應用篩選器/建立捷徑時不加「快捷方式」文字/快速存取最近使用的檔案
echo 快速存取常用資料夾/捷徑小箭頭/執行檔案小盾牌
echo ========================================================================================================
set /p choose7=是否可以接受? 請輸入(Y/y｜N/n)：
if /i "%choose7%"=="y" goto Widgets81
if /i "%choose7%"=="n" goto Widgets

:Widgets81
cls
cd /d "%BasePath%"軟體工具包\reg
echo 停用 Windows 10 登入介面透明效果
regedit.exe/s reg_import_DisableAcrylic.reg
echo 已停用完成
echo.
echo 隱藏 立即開會 圖示
regedit.exe/s Disable_Meet_Now_icon_for_all_users.reg
echo 已隱藏完成
echo.
echo 隱藏 Windows 安全性 通知圖示
regedit.exe/s Disable_Windows_Security_notification_icon_for_all_users.reg
echo 已隱藏完成
echo.
echo 隱藏 開啟功能表"最近新增"
regedit.exe/s Disable_Recently_added_apps_list_on_Start_Menu.reg
echo 已隱藏完成
echo.
echo 停用 桌布更換 JPEG 壓縮
regedit.exe/s Disable_JPEG_Desktop_wallpaper_import_quality.reg
echo 已停用完成
echo.
echo 隱藏 捷徑小箭頭/執行檔案小盾牌/開啟程式安全警告/Smartscreen 應用篩選器/建立捷徑時不加「快捷方式」文字/最近使用的檔案/常用資料夾
set "BlankIcon=C:\Windows\Blank.ico"
copy /y "%BasePath%軟體工具包\reg\Blank.ico" "%BlankIcon%" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /t REG_EXPAND_SZ /d "%BlankIcon%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 77 /t REG_EXPAND_SZ /d "%BlankIcon%" /f
ie4uinit.exe -show >nul 2>&1
set "REGDATA=.bat;.exe;.reg;.vbs;.chm;.msi;.js;.cmd"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v ModRiskFileTypes /t REG_SZ /d "%REGDATA%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "off" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v Link /t REG_BINARY /d 00000000 /f
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer" /v Link /t REG_BINARY /d 00000000 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowFrequent /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
reg add "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /t REG_DWORD /d 0 /f
echo 已隱藏完成
echo.
echo 正在重新啟動 檔案總管
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
goto Widgets

:Widgets9
cls
echo 停用 OverlayMinFPS
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayMinFPS /t REG_DWORD /d 0 /f
echo 已停用完成
goto Widgets

:Widgets10
cls
echo 移除 OverlayMinFPS
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayMinFPS /f
echo 已移除完成
goto Widgets

:Game
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】安裝 Steam
echo.
echo 【2】安裝 Epic Games
echo.
echo 【3】安裝 Ubisoft Connect
echo.
echo 【4】安裝 EA
echo.
echo 【5】安裝 Battle.net
echo.
echo 【6】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c14=請選擇選項：
if "%c14%"=="1" goto Steam
if "%c14%"=="2" goto Epic
if "%c14%"=="3" goto Ubisoft
if "%c14%"=="4" goto EA
if "%c14%"=="5" goto Battle
if "%c14%"=="6" goto Install

:Steam
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
cd /d "%BasePath%"軟體工具包\遊戲
echo 安裝 Steam
start /wait SteamSetup.exe
echo 已安裝完成
goto Game
:Epic
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
cd /d "%BasePath%"軟體工具包\遊戲
echo 安裝 Epic Games
start /wait EpicInstaller.msi
echo 已安裝完成
goto Game
:Ubisoft
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
cd /d "%BasePath%"軟體工具包\遊戲
echo 安裝 Ubisoft Connect
start /wait UbisoftConnectInstaller.exe
echo 已安裝完成
goto Game
:EA
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
cd /d "%BasePath%"軟體工具包\遊戲
echo 安裝 EA
start /wait EAappInstaller.exe
echo 已安裝完成
goto Game
:Battle
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
cd /d "%BasePath%"軟體工具包\遊戲
echo 安裝 Battle.net
start /wait Battle.net_Setup.exe
echo 已安裝完成
goto Game

:Dream
cls
start https://portaly.cc/dreamnas
goto Install
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:Dream1
cls
start https://dreamnas.familyds.com/3509.html
goto Install
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:exe
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo ==========================================================================================================
echo.
echo 【1】NVIDIA 顯示驅動下載   
echo.
echo 【2】AMD 顯示驅動下載      
echo.
echo 【3】Intel 顯示驅動下載      
echo.
echo 【4】主機板驅動網址
echo.
echo 【5】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c10=請選擇選項：
if "%c10%"=="1" goto NVIDIA
if "%c10%"=="2" goto AMD
if "%c10%"=="3" goto Intel
if "%c10%"=="4" goto MB
if "%c10%"=="5" goto Install

:Intel
cls
start https://www.intel.com.tw/content/www/tw/zh/download-center/home.html
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:NVIDIA
cls
start https://www.nvidia.com.tw/Download/index.aspx?lang=tw
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:AMD
cls
start https://www.amd.com/zh-hant/support
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:MB
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo ==========================================================================================================
echo.
echo 【1】華碩   【2】技嘉   【3】微星   【4】華擎  【5】EVGA 【6】NZXT 
echo.
echo 【7】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c11=請選擇選項：
if "%c11%"=="1" goto MB1
if "%c11%"=="2" goto MB2
if "%c11%"=="3" goto MB3
if "%c11%"=="4" goto MB4
if "%c11%"=="5" goto MB5
if "%c11%"=="6" goto MB6
if "%c11%"=="7" goto exe

:MB1
cls
start https://www.asus.com/tw/support/Download-Center/
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:MB2
cls
start https://www.gigabyte.com/tw/Support
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:MB3
cls
start https://tw.msi.com/support/
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:MB4
cls
start https://www.asrock.com/support/index.tw.asp
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:MB5
cls
start https://tw.evga.com/support/download/
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
:MB6
cls
start https://nzxt-app.nzxt.com/NZXT-CAM-Setup.exe
cls
goto exe
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:uac
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】使用者帳戶控制設定調整(UAC調整)(高)  【4】使用者帳戶控制設定調整(UAC調整)(開但最低)
echo.
echo 【2】使用者帳戶控制設定調整(UAC調整)(預設)【5】使用者帳戶控制設定調整(UAC調整)(關)
echo.
echo 【3】使用者帳戶控制設定調整(UAC調整)(低)  【6】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c6=請選擇選項：
if "%c6%"=="1" goto uac1
if "%c6%"=="2" goto uac2
if "%c6%"=="3" goto uac3
if "%c6%"=="4" goto uac4
if "%c6%"=="5" goto uac5
if "%c6%"=="6" goto Install

:uac1
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s UAC高.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:uac2
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s UAC預設.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:uac3
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s UAC低.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:uac4
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s UAC開但最低.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:uac5
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s UAC關.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:win10
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo ==========================================================================================================
echo.
echo 【1】新增 右鍵管理員取得所有權
echo.
echo 【2】移除 右鍵管理員取得所有權 
echo.
echo 【3】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c5=請選擇選項：
if "%c5%"=="1" goto win101
if "%c5%"=="2" goto win102
if "%c5%"=="3" goto Install

:win101
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Add_Take_Ownership_to_context_menu.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:win102
cd /d "%BasePath%"軟體工具包\reg
regedit.exe/s Remove_Take_Ownership_from_context_menu.reg
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
cls
goto Install

:win10x64
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】安裝 AMD 顯示卡驅動
echo.
echo 【2】安裝 NVIDIA 桌機顯示卡驅動 (支援RTX 5090 D~GTX 745)
echo.
echo 【3】安裝 NVIDIA 筆電顯示卡驅動 (支援RTX 5090 Laptop~830M)
echo.
echo 【4】安裝 Intel 顯示卡驅動 (支援Arc A、B系列、Iris Xe、Ultra)
echo.
echo 【5】不安裝顯示卡驅動
echo.
echo  PS:若無法安裝顯示卡驅動請回主頁按下"5"到官網下載
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c12=請選擇選項：
if "%c12%"=="1" goto amda
if "%c12%"=="2" goto nvidiag
if "%c12%"=="3" goto nvidiag1
if "%c12%"=="4" goto Intelg
if "%c12%"=="5" goto win101x64

:Intelg
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 Intel 顯示卡驅動
start /wait gfx_win.exe /s
echo 已安裝完成
goto win101x64

:amda
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 AMD 顯示卡驅動
start /wait amd-software-adrenalin-edition_web.exe
echo 已安裝完成
goto win101x64

:nvidiag
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 NVIDIA 顯示卡驅動
start /wait desktop-win10-win11-64bit-international-dch-whql.exe /s
echo 已安裝完成
goto win101x64

:nvidiag1
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 NVIDIA 顯示卡驅動
start /wait notebook-win10-win11-64bit-international-dch-whql.exe /s
echo 已安裝完成
goto win101x64

:win101x64
cls
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 VC++ 2005~2022
start /wait VisualCppRedist_AIO_x86_x64 /ai58X239
echo 已安裝完成
echo.
echo 安裝 PotPlayer
start /wait PotPlayerSetup64.exe /S
echo.
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\reg
echo 啟用 PotPlayer 軟體解碼補幀
regedit.exe/s PotPlayerMini64.reg
echo 已啟用完成
echo.
echo 安裝 裝置製造商的 HEVC 視訊延伸模組
PowerShell -Command "Add-AppxPackage -Path '%BasePath%軟體工具包\軟體\Microsoft.HEVCVideoExtension.AppxBundle'"
echo 已安裝完成
echo.
echo 安裝 華碩智慧輸入法
PowerShell -Command "Add-AppxPackage -Path '%BasePath%軟體工具包\軟體\ASUSInputMethodEditors.AppxBundle'"
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 DirectX 
start /wait directx_Jun2010_redist.exe /Q /T:%BasePath%軟體工具包\軟體\DirectX
start /wait %BasePath%軟體工具包\軟體\DirectX\DXSETUP.exe /silent
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 Google Chrome
start /wait ChromeSetup.exe
echo 已安裝完成
echo.
echo 安裝 NET 8.0 Desktop Runtime
start /wait windowsdesktop-runtime-8.0.20-win-x64.exe /quiet /norestart
echo 已安裝完成
echo.
echo 安裝 Java
start /wait jre-windows-x64.exe /s
echo 已安裝完成
echo.
echo 安裝 Notepad++
start /wait npp.Installer.exe /S
echo 已安裝完成
echo.
echo 安裝 WinRAR
start /wait winrar-x64.exe /S
copy /Y rarreg.key "C:\Program Files\WinRAR\"
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 YouTube Music
start /wait YouTube-Music-Web-Setup.exe
echo 已安裝完成
echo.
echo 安裝 office 365
start /wait OfficeSetup.exe
echo 已安裝完成
echo.
echo 安裝 Adobe Acrobat Pro
cd /d "%BasePath%"軟體工具包\軟體\Adobe-Acrobat-Pro-DC
start /wait autoplay.exe
echo 已安裝完成
echo.
echo 在右鍵新增命令提示字元開啟
set /p choose2=是否要安裝？ 請輸入(Y/y｜N/n)：
if /i "%choose2%"=="y" goto reg
if /i "%choose2%"=="n" goto LTSC
:reg
echo.
cd /d "%BasePath%"軟體工具包\reg
echo 安裝 右鍵新增命令提示字元開啟
regedit.exe/s OpenCmdHere.reg
echo 已安裝完成
echo.
:LTSC
echo.
echo 是否需要幫 Windows 10 企業版LTSC加回Microsoft Store套件
echo.
set /p choose3=是否要加回？ 請輸入(Y/y｜N/n)：
if /i "%choose3%"=="y" goto LTSC2
if /i "%choose3%"=="n" goto ac
:LTSC2
echo.
cd /d "%BasePath%"軟體工具包\軟體\LTSC-Add-MicrosoftStore
start /wait Add-Store.cmd
echo 已安裝完成
:ac
echo.
echo 是否需要啟用 Windows.Office 金鑰？
echo.
set /p choose4=是否要啟用？ 請輸入(Y/y｜N/n)：
if /i "%choose4%"=="y" goto win
if /i "%choose4%"=="n" goto Install
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================


:win11x64
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】安裝 AMD 顯示卡驅動
echo.
echo 【2】安裝 NVIDIA 桌機顯示卡驅動 (支援RTX 5090 D~GTX 745)
echo.
echo 【3】安裝 NVIDIA 筆電顯示卡驅動 (支援RTX 5090 Laptop~830M)
echo.
echo 【4】安裝 Intel 顯示卡驅動 (支援Arc A、B系列與Iris Xe)
echo.
echo 【5】不安裝顯示卡驅動
echo.
echo  PS:若無法安裝顯示卡驅動請回主頁按下"5"到官網下載
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c13=請選擇選項：
if "%c13%"=="1" goto amd2
if "%c13%"=="2" goto nvidia4
if "%c13%"=="3" goto nvidia5
if "%c13%"=="4" goto Intel5
if "%c13%"=="5" goto win111x64

:Intel5
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 Intel 顯示卡驅動
start /wait gfx_win.exe /s
echo 已安裝完成
goto win111x64

:amd2
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 AMD 顯示卡驅動
start /wait amd-software-adrenalin-edition_web.exe
echo 已安裝完成
goto win111x64

:nvidia4
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 NVIDIA 顯示卡驅動
start /wait desktop-win10-win11-64bit-international-dch-whql.exe /s
echo 已安裝完成
goto win111x64

:nvidia5
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 NVIDIA 顯示卡驅動
start /wait notebook-win10-win11-64bit-international-dch-whql.exe /s
echo 已安裝完成
goto win111x64

:win111x64
cls
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 VC++ 2005~2022
start /wait VisualCppRedist_AIO_x86_x64 /ai58X239
echo 已安裝完成
echo.
echo 安裝 PotPlayer
start /wait PotPlayerSetup64.exe /S
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\reg
echo 啟用 PotPlayer 軟體解碼補幀
regedit.exe/s PotPlayerMini64.reg
echo 已啟用完成
echo.
echo 安裝 裝置製造商的 HEVC 視訊延伸模組
PowerShell -Command "Add-AppxPackage -Path '%BasePath%軟體工具包\軟體\Microsoft.HEVCVideoExtension.AppxBundle'"
echo 已安裝完成
echo.
echo 安裝 華碩智慧輸入法
PowerShell -Command "Add-AppxPackage -Path '%BasePath%軟體工具包\軟體\ASUSInputMethodEditors.AppxBundle'"
echo 已安裝完成
echo.
echo 安裝 NanaZip
PowerShell -Command "Add-AppxPackage -Path '%BasePath%軟體工具包\軟體\NanaZip.msixbundle'"
echo 已安裝完成
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 DirectX 
start /wait directx_Jun2010_redist.exe /Q /T:%BasePath%軟體工具包\軟體\DirectX
start /wait %BasePath%軟體工具包\軟體\DirectX\DXSETUP.exe /silent
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 Google Chrome
start /wait ChromeSetup.exe
echo 已安裝完成
echo.
echo 安裝 NET 8.0 Desktop Runtime
start /wait windowsdesktop-runtime-8.0.20-win-x64.exe /quiet /norestart
echo 已安裝完成
echo.
echo 安裝 Java
start /wait jre-windows-x64.exe /s
echo 已安裝完成
echo.
echo 安裝 Notepad++
start /wait npp.Installer.exe /S
echo 已安裝完成
echo.
echo 安裝 WinRAR
start /wait winrar-x64.exe /S
copy /Y rarreg.key "C:\Program Files\WinRAR\"
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體
echo 安裝 YouTube Music
start /wait YouTube-Music-Web-Setup.exe
echo 已安裝完成
echo.
echo 安裝 office 365
start /wait OfficeSetup.exe
echo 已安裝完成
echo.
cd /d "%BasePath%"軟體工具包\軟體\Adobe-Acrobat-Pro-DC
echo 安裝 Adobe Acrobat Pro
start /wait autoplay.exe
echo 已安裝完成
echo.
echo 是否需要幫 Windows 11 企業版LTSC、IoT企業版 LTSC加回Microsoft Store套件？
echo.
set /p choose6=是否要加回？ 請輸入(Y/y｜N/n)：
if /i "%choose6%"=="y" goto LTSC4
if /i "%choose6%"=="n" goto ac1
:LTSC4
echo.
cd /d "%BasePath%"軟體工具包\軟體\LTSC-Add-MicrosoftStore-24H2
start /wait Add-Store.cmd
echo 已安裝完成
:ac1
echo.
echo 是否需要啟用Windows.Office金鑰？
echo.
set /p choose5=是否要啟用？ 請輸入(Y/y｜N/n)：
if /i "%choose5%"=="y" goto win
if /i "%choose5%"=="n" goto Install
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================

:win
cls
cd /d "%BasePath%"軟體工具包
type Dream-NAS.txt
echo =========================================================================================================
echo.
echo 【1】Windows/Office 手動啟用金鑰(KMS-Cangshui.net.bat 作者:滄水的)
echo.
echo 【2】Windows/Office 手動啟用金鑰(Microsoft-Activation-Scripts)
echo.
echo 【3】Office 手動啟用金鑰(Office Tool Plus)
echo.
echo 【4】回上一頁
echo.
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
set /p c9=請選擇選項：
if "%c9%"=="1" goto winw1
if "%c9%"=="2" goto winw2
if "%c9%"=="3" goto winw3
if "%c9%"=="4" goto Install


:winw1
cls
cd /d "%BasePath%"軟體工具包\KMS
start /wait KMS-Cangshui.net.bat
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
goto Install

:winw2
cls
cd /d "%BasePath%"軟體工具包\KMS
start /wait MAS_AIO.cmd
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
goto Install

:winw3
cls
cd /d "%BasePath%"軟體工具包\KMS
start /wait Office_Tool_Plus.lnk
echo ========================================================================================================
echo             --- ☆Dream-NAS☆ 個人網站 Dream 整合製作 ( https://dreamnas.familyds.com ) ---
echo.
echo              --- 感謝一位朋友協助我完成PowerShell腳本撰寫、Bat腳本撰寫、提供我許多建議 ---
echo ========================================================================================================
goto Install
                
				___                                          _   _  _____  ___   
                    (  _`\                                       ( ) ( )(  _  )(  _`\ 
                    | | ) | _ __   __     _ _   ___ ___   ______ | `\| || (_) || (_(_)
                    | | | )( '__)/'__`\ /'_` )/' _ ` _ `\(______)| , ` ||  _  |`\__ \ 
                    | |_) || |  (  ___/( (_| || ( ) ( ) |        | |`\ || | | |( )_) |
                    (____/'(_)  `\____)`\__,_)(_) (_) (_)        (_) (_)(_) (_)`\____)
                                                                  
                                                                  
