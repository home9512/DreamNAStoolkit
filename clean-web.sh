#!/bin/sh

echo "=========================================="
echo "    開始執行華碩梅林全機腳本一鍵徹底清理"
echo "        (包含網頁專業設置選單還原)"
echo "=========================================="

echo "⏳ 正在解除所有網頁與隨身碟掛載，恢復系統純淨度..."

# 1. 徹底解除網頁專業設置（Advanced_WAdvanced_Content.asp）的強制綁定
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
rm -f /tmp/Advanced_WAdvanced_Content_custom.asp 2>/dev/null

# 2. 解除隨身碟（Silicon-Power32G）與核心 /jffs 的虛擬綁定
umount -l /jffs 2>/dev/null
rm -rf /tmp/mnt/sda1/.jffs 2>/dev/null

# 3. 徹底刪除路由器內部快閃記憶體中建立的所有自訂腳本
rm -f /jffs/scripts/wireless-unlock.sh 2>/dev/null
rm -f /jffs/scripts/wireless-unlock.sh.bak 2>/dev/null
rm -f /jffs/scripts/sysinfo-patch.sh 2>/dev/null
rm -f /jffs/scripts/web-region-patch.sh 2>/dev/null
rm -f /jffs/scripts/wpwr.sh 2>/dev/null

# 4. 徹底清空並刪除核心開機啟動清單與隨身碟掛載核心腳本
rm -f /jffs/scripts/services-start 2>/dev/null
rm -f /jffs/scripts/post-mount 2>/dev/null

# 5. 強制將所有地區法規碼復原回最原始的台版初始預設值
nvram set territory_code=TW 2>/dev/null
nvram set location_code=TW 2>/dev/null
nvram set wl_country_code=TW 2>/dev/null
nvram set wl0_country_code=TW 2>/dev/null
nvram set wl1_country_code=TW 2>/dev/null
nvram set wl_reg_mode=0 2>/dev/null
nvram set wl0_reg_mode=0 2>/dev/null
nvram set wl1_reg_mode=0 2>/dev/null
nvram commit 2>/dev/null

# 6. 清理環境變數設定檔中的所有自訂快捷鍵 (pwr / wpwr)
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile 2>/dev/null
    sed -i '/alias wpwr=/d' ~/.profile 2>/dev/null
fi

# 7. 強制刷新當前視窗環境變數，讓快捷鍵立刻失效
source ~/.profile 2>/dev/null

echo "------------------------------------------"
echo " 🎉 清理完成！所有網頁補丁、自訂腳本與快捷鍵已徹底拔除。"
echo " 系統即將在 3 秒後全自動重新開機，重回官方初始狀態..."
echo "------------------------------------------"

# 8. 自動觸發安全重啟
sleep 3
reboot
