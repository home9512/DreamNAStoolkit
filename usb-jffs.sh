#!/bin/sh

echo "=========================================="
echo "   RT-AX86U USB-JFFS 記憶體轉移安裝腳本"
echo "             (sda1 修正版)"
echo "=========================================="

USB_TARGET="/tmp/mnt/sda1"

# 1. 核心安全檢查：確認隨身碟是否在線上
if [ ! -d "$USB_TARGET" ]; then
    echo "❌ 錯誤：找不到隨身碟儲存路徑 /tmp/mnt/sda1！"
    echo "請確認隨身碟是否正確插在路由器上。"
    exit 1
fi

echo "✅ 偵測到隨身碟路徑 sda1，開始部署..."

# 2. 建立隨身碟專屬 post-mount 自動綁定腳本
cat << 'EOF' > /jffs/scripts/post-mount
#!/bin/sh
# 鎖定 sda1 隨身碟實體路徑
USB_PATH="/tmp/mnt/sda1"

if [ -d "$USB_PATH" ]; then
    # 建立隨身碟上的隱藏快閃資料夾
    mkdir -p "$USB_PATH/.jffs"
    
    # 🌟 防遺失機制：若隨身碟上沒有大功率解鎖腳本，自動從路由器內部快閃記憶體中複製過去
    if [ ! -f "$USB_PATH/.jffs/scripts/wireless-unlock.sh" ] && [ -f /jffs/scripts/wireless-unlock.sh ]; then
        cp -a /jffs/. "$USB_PATH/.jffs/"
    fi
    
    # 將系統核心 /jffs 徹底綁定到隨身碟上，保護原廠 Flash
    mount --bind "$USB_PATH/.jffs" /jffs
fi
EOF

# 3. 賦予腳本最高執行權限
chmod +x /jffs/scripts/post-mount

echo "------------------------------------------"
echo " 🎉 安裝成功！"
echo "【重要步驟】：請立刻按下路由器後方的「實體按鈕關機」"
echo " 等待 10 秒鐘後重新開機，轉移才會正式生效！"
echo "------------------------------------------"
echo " 重新開機後，請輸入以下指令驗證容量是否暴增："
echo " df -h | grep jffs"
echo "=========================================="
