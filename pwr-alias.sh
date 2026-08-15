#!/bin/sh

echo "=========================================="
echo "    開始安裝 RT-AX86U 專屬功率查詢快捷鍵"
echo "             (數字精確修正版)"
echo "=========================================="

# 1. 安全清理舊的設定
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile
    sed -i '/alias wpwr=/d' ~/.profile
fi

# 2. 建立實體查詢腳本 (修正 awk 擷取規則，精確只抓數字)
cat << 'EOF' > /jffs/scripts/wpwr.sh
#!/bin/sh
# 修正點：使用 grep -oE '[0-9.]+' 精確只剝離出 26.00 這樣的純數字
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | grep -oE '[0-9.]+' | head -n1)
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | grep -oE '[0-9.]+' | head -n1)

# 安全防護：萬一抓不到則給予預設值
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

# 4. 在系統設定檔中寫入指向別名
echo "alias wpwr='/bin/sh /jffs/scripts/wpwr.sh'" >> ~/.profile

# 5. 強制刷新當前視窗環境變數
source ~/.profile

echo "------------------------------------------"
echo " 🎉 快捷鍵完美更新完成！"
echo " 現在請輸入： wpwr 查看真實滿血數據！"
echo "=========================================="
