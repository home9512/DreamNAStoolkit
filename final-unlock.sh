#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 大功率解鎖 + USB-JFFS 終極安裝包"
echo "        (ASUSWRT 4.0 韌體 100% 正確版)"
echo "=========================================="

USB_TARGET="/tmp/mnt/sda1"

# 1. 核心安全檢查：確認隨身碟是否在線上
if [ ! -d "$USB_TARGET" ]; then
    echo "❌ 錯誤：找不到隨身碟儲存路徑 /tmp/mnt/sda1！"
    exit 1
fi

echo "✅ 偵測到隨身碟，開始安全搬移與解鎖部署..."

# 2. 寫入隨身碟自動掛載腳本 (post-mount)
printf '%s\n' '#!/bin/sh' \
'USB_PATH="/tmp/mnt/sda1"' \
'if [ -d "$USB_PATH" ]; then' \
'    mkdir -p "$USB_PATH/.jffs"' \
'    if [ ! -f "$USB_PATH/.jffs/scripts/wireless-unlock.sh" ] && [ -f /jffs/scripts/wireless-unlock.sh ]; then' \
'        cp -a /jffs/. "$USB_PATH/.jffs/"' \
'    fi' \
'    mount --bind "$USB_PATH/.jffs" /jffs' \
'fi' > /jffs/scripts/post-mount

# 3. 寫入新版 4.0 韌體核心大功率解鎖腳本 (修正底層 rc_service 錯誤)
printf '%s\n' '#!/bin/sh' \
'sleep 30' \
'nvram set territory_code=AA' \
'nvram set location_code=#a' \
'nvram set wl_country_code=AU' \
'nvram set wl0_country_code=AU' \
'nvram set wl1_country_code=AU' \
'nvram set wl0_reg_mode=h' \
'nvram set wl1_reg_mode=h' \
'nvram commit' \
'service restart_wireless' > /jffs/scripts/wireless-unlock.sh

# 4. 寫入一鍵彩色查詢指令檔 (wpwr.sh)
printf '%s\n' '#!/bin/sh' \
'RAW_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null)' \
'RAW_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null)' \
'PWR_2G=$(echo "$RAW_2G" | awk "{print \$NF}")' \
'PWR_5G=$(echo "$RAW_5G" | awk "{print \$NF}")' \
'VAL_2G=$(echo "$PWR_2G" | sed "s/[a-zA-Z]//g")' \
'VAL_5G=$(echo "$PWR_5G" | sed "s/[a-zA-Z]//g")' \
'[ -z "$VAL_2G" ] && VAL_2G="26.00"' \
'[ -z "$VAL_5G" ] && VAL_5G="26.00"' \
'mW_2G=$(awk -v dbm="$VAL_2G" "BEGIN {print int(10^(dbm/10))}")' \
'mW_5G=$(awk -v dbm="$VAL_5G" "BEGIN {print int(10^(dbm/10))}")' \
'TEMP_2G=$(wl -i eth6 phy_tempsense | awk "{print \$1/2+20}")' \
'TEMP_5G=$(wl -i eth7 phy_tempsense | awk "{print \$1/2+20}")' \
'echo -e "\033[1;33m==========================================\033[0m"' \
'echo -e "\033[1;36m  ⚡ RT-AX86U 目前實時無線發射功率與狀態 ⚡\033[0m"' \
'echo -e "\033[1;33m==========================================\033[0m"' \
'echo -e "🟢 \033[1;32m2.4GHz 狀態：\033[0m \033[1;37m$RAW_2G\033[0m ($mW_2G mW) | \033[1;36m溫度：\033[0m $TEMP_2G°C"' \
'echo -e "🔮 \033[1;35m5GHz   狀態：\033[0m \033[1;37m$RAW_5G\033[0m ($mW_5G mW) | \033[1;36m溫度：\033[0m $TEMP_5G°C"' \
'echo -e "\033[1;33m==========================================\033[0m"' > /jffs/scripts/wpwr.sh

# 5. 賦予最高權限
chmod +x /jffs/scripts/post-mount
chmod +x /jffs/scripts/wireless-unlock.sh
chmod +x /jffs/scripts/wpwr.sh

# 6. 將解鎖腳本掛載至開機啟動清單 (services-start)
if [ ! -f /jffs/scripts/services-start ]; then
    echo "#!/bin/sh" > /jffs/scripts/services-start
fi
if ! grep -q "wireless-unlock.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/wireless-unlock.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 7. 註冊系統別名 wpwr
if [ -f ~/.profile ]; then
    sed -i '/alias wpwr=/d' ~/.profile 2>/dev/null
fi
echo "alias wpwr='/bin/sh /jffs/scripts/wpwr.sh'" >> ~/.profile
source ~/.profile 2>/dev/null

echo "------------------------------------------"
echo " 🎉 終極整合安裝包本地部署完畢！"
echo " 【核心最後一步】：請立刻前往路由器後方按下「實體按鈕關機」"
echo " 等待 10 秒鐘後重新按鈕開機，大功率解鎖與隨身碟防護將全自動鎖定！"
echo "=========================================="
