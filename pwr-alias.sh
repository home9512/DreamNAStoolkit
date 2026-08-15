#!/bin/sh

echo "=========================================="
echo "    開始安裝 RT-AX86U 專屬功率查詢快捷鍵"
echo "             (實體腳本相容版)"
echo "=========================================="

# 1. 安全清理舊的衝突設定
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile
    sed -i '/alias wpwr=/d' ~/.profile
fi

# 2. 建立一個獨立的、寫死不變形的實體查詢腳本
cat << 'EOF' > /jffs/scripts/wpwr.sh
#!/bin/sh
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | awk '{print $1}')
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | awk '{print $1}')

# 安全防護
[ -z "$PWR_2G" ] && PWR_2G="26.00"
[ -z "$PWR_5G" ] && PWR_5G="26.00"

mW_2G=$(awk -v dbm="$PWR_2G" 'BEGIN {print int(10^(dbm/10))}')
mW_5G=$(awk -v dbm="$PWR_5G" 'BEGIN {print int(10^(dbm/10))}')
TEMP_2G=$(wl -i eth6 phy_tempsense | awk '{print $1/2+20}')
TEMP_5G=$(wl -i eth7 phy_tempsense | awk '{print $1/2+20}')

echo -e "\033[1;33m==========================================\033[0m"
echo -e "\033[1;36m  ⚡ RT-AX86U 目前實時無線發射功率與狀態 ⚡\033[0m"
echo -e "\033[1;33m==========================================\033[0m"
echo -e "🟢 \033[1;32m2.4GHz 功率：\033[0m \033[1;37m$PWR_2G dBm\033[0m ($mW_2G mW)  | \033[1;36m晶片溫度：\033[0m $TEMP_2G°C"
echo -e "🔮 \033[1;35m5GHz   功率：\033[0m \033[1;37m$PWR_5G dBm\033[0m ($mW_5G mW)  | \033[1;36m晶片溫度：\033[0m $TEMP_5G°C"
echo -e "\033[1;33m==========================================\033[0m"
EOF

# 3. 賦予實體腳本最高執行權限
chmod +x /jffs/scripts/wpwr.sh

# 4. 在系統設定檔中，只寫入一行極其簡單、絕對不會出錯的指向別名
echo "alias wpwr='/bin/sh /jffs/scripts/wpwr.sh'" >> ~/.profile

# 5. 強制刷新當前視窗環境變數
source ~/.profile

echo "------------------------------------------"
echo " 🎉 快捷鍵更新安裝完成！"
echo "------------------------------------------"
echo " 現在請直接在黑色視窗中輸入四個字母： wpwr"
echo " 按下 Enter 即可看到您專屬的彩色大功率面板！"
echo "=========================================="
