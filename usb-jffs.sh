#!/bin/sh

echo "=========================================="
echo "   RT-AX86U USB-JFFS 記憶體轉移安裝腳本"
echo "             (安全資料同步版)"
echo "=========================================="

USB_TARGET="/tmp/mnt/sda1"

# 1. 核心安全檢查：確認隨身碟是否在線上
if [ ! -d "$USB_TARGET" ]; then
    echo "❌ 錯誤：找不到隨身碟儲存路徑 /tmp/mnt/sda1！"
    echo "請確認隨身碟是否正確插在路由器上。"
    exit 1
fi

echo "✅ 偵測到隨身碟路徑 sda1，開始部署..."

# 🌟 安全修正：在安裝當下，立刻將現在路由器內的所有 JFFS 設定與腳本（含無線解鎖）同步到隨身碟
echo "📦 正在備份並同步現有 JFFS 資料至隨身碟..."
mkdir -p "$USB_TARGET/.jffs"
cp -a /jffs/. "$USB_TARGET/.jffs/"

# 2. 建立隨身碟專屬 post-mount 自動綁定腳本（開機只需單純綁定，最穩定）
cat << 'EOF' > /jffs/scripts/post-mount
#!/bin/sh
# 鎖定 sda1 隨身碟實體路徑
USB_PATH="/tmp/mnt/sda1"

if [ -d "$USB_PATH/.jffs" ]; then
    # 將系統核心 /jffs 徹底綁定到隨身碟上，保護原廠 Flash
    mount --bind "$USB_PATH/.jffs" /jffs
fi
EOF

# 3. 系統安全同步：確保把剛剛複製的檔案跟 post-mount 腳本寫入 Flash 晶片
chmod +x /jffs/scripts/post-mount
sync

echo "------------------------------------------"
echo " 🎉 安裝成功！"
echo "【重要步驟】：請立刻按下路由器後方的「實體按鈕關機」"
echo " 等待 10 秒鐘後重新開機，轉移才會正式生效！"
echo "------------------------------------------"
echo " 重新開機後，請輸入以下指令驗證容量是否暴增："
echo " df -h | grep jffs"
echo "=========================================="
