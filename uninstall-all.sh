#!/bin/sh

echo "=========================================="
echo "    開始執行華碩梅林全機腳本一鍵徹底清理"
echo "=========================================="

echo "⏳ 正在解除隨身碟掛載與清理快取..."

# 1. 解除 sda1 隨身碟與核心 /jffs 的強制虛擬綁定
umount -l /jffs 2>/dev/null

# 2. 徹底刪除隨身碟上的隱藏 JFFS 實體資料夾
rm -rf /tmp/mnt/sda1/.jffs 2>/dev/null

# 3. 徹底刪除路由器內部快閃記憶體中建立的所有自訂腳本
rm -f /jffs/scripts/wireless-unlock.sh 2>/dev/null
rm -f /jffs/scripts/wireless-unlock.sh.bak 2>/dev/null
rm -f /jffs/scripts/sysinfo-patch.sh 2>/dev/null
rm -f /jffs/scripts/wpwr.sh 2>/dev/null

# 4. 徹底清空並刪除核心開機啟動清單與隨身碟掛載腳本
rm -f /jffs/scripts/services-start 2>/dev/null
rm -f /jffs/scripts/post-mount 2>/dev/null

# 5. 清理環境變數設定檔中的所有自訂快捷鍵 (pwr / wpwr)
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile 2>/dev/null
    sed -i '/alias wpwr=/d' ~/.profile 2>/dev/null
fi

# 6. 強制刷新當前視窗環境變數，讓快捷鍵立刻失效
source ~/.profile 2>/dev/null

echo "------------------------------------------"
echo " 🎉 清理完成！所有自訂腳本與快捷鍵已徹底拔除。"
echo " 系統即將在 3 秒後全自動重新開機，恢復純淨原廠狀態..."
echo "------------------------------------------"

# 7. 自動觸發安全重啟
sleep 3
reboot
