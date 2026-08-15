#!/bin/sh

echo "=========================================="
echo "    開始安裝 RT-AX86U 專屬功率查詢快捷鍵"
echo "             (原創文字相容版)"
echo "=========================================="

# 1. 安全清理舊的設定
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile
    sed -i '/alias wpwr=/d' ~/.profile
fi

# 2. 建立實體查詢腳本 (改用最保險的文字直出與精確切分)
cat << 'EOF' > /jffs/scripts/wpwr.sh
#!/bin/sh

# 直接抓取完整的原廠文字行
RAW_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null)
RAW_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null)

# 提取最後一個空格後面的數字 (通常是 26.00 這種格式)
PWR_2G=$(echo "$RAW_2G" | awk '{print $NF}')
PWR_5G=$(echo "$RAW_5G" | awk '{print $NF}')

# 如果帶有 dBm 字樣，將其濾掉只留數字做計算
VAL_2G=$(echo "$PWR_2G" | sed 's/[a-zA-Z]//g')
VAL_5G=$(echo "$PWR_5G" | sed 's/[a-zA-Z]//g')

# 安全防護
[ -z "$VAL_2G" ] && VAL_2G="26.00"
[ -z "$VAL_5G" ] && VAL_5G="26.00"

mW_2G=$(awk -v dbm="$VAL_2G" 'BEGIN {print int(10^(dbm/10))}')
mW_5G=$(awk -v dbm="$VAL_5G" 'BEGIN {print int(10^(dbm/10))}')

TEMP_2G=$(wl -i eth6 phy_tempsense | awk '{print $1/2+20}')
TEMP_5G=$(wl -i eth7 phy_tempsense | awk '{print $1/2+20}')

echo -e "\033[1;33m==========================================\033[0m"
echo -e "\033[1;36m  ⚡ RT-AX86U 目前實時無線發射功率與狀態 ⚡\033[0m"
echo -e "\033[1;33m==========================================\033[0m"
echo -e "🟢 \033[1;32m2.4GHz 狀態：\033[0m \033[1;37m$RAW_2G\033[0m ($mW_2G mW) | \033[1;36m溫度：\033[0m $TEMP_2G°C"
echo -e "🔮 \033[1;35m5GHz   狀態：\033[0m \033[1;37m$RAW_5G\033[0m ($mW_5G mW) | \033[1;36m溫度：\033[0m $TEMP_5G°C"
echo -e "\033[1;33m==========================================\033[0m"
EOF

# 3. 賦予實體腳本最高執行權限
chmod +x /jffs/scripts/wpwr.sh

# 4. 在系統設定檔中寫入指向別名
echo "alias wpwr='/bin/sh /jffs/scripts/wpwr.sh'" >> ~/.profile

# 5. 強制刷新當前視窗環境變數
source ~/.profile

echo "------------------------------------------"
echo " 🎉 快捷鍵完美更新完成！"
echo " 現在請輸入： wpwr 查看真實滿血數據！"
echo "=========================================="
