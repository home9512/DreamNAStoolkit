#!/bin/sh

echo "=========================================="
echo "    開始安裝 RT-AX86U 專屬功率查詢快捷鍵"
echo "             (wpwr 修正版)"
echo "=========================================="

# 1. 核心安全檢查：清理舊的衝突設定
if [ -f ~/.profile ]; then
    sed -i '/alias pwr=/d' ~/.profile
    sed -i '/alias wpwr=/d' ~/.profile
fi

# 2. 將全新命名的 wpwr 快捷鍵寫入系統設定檔 (.profile)
cat << 'EOF' >> ~/.profile
alias wpwr='echo -e "\033[1;33m==========================================\033[0m"; \
echo -e "\033[1;36m  ⚡ RT-AX86U 目前實時無線發射功率與狀態 ⚡\033[0m"; \
echo -e "\033[1;33m==========================================\033[0m"; \
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | awk "{print \$1}"); \
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | awk "{print \$1}"); \
mW_2G=$(awk -v dbm="$PWR_2G" "BEGIN {print int(10^(dbm/10))}"); \
mW_5G=$(awk -v dbm="$PWR_5G" "BEGIN {print int(10^(dbm/10))}"); \
TEMP_2G=$(wl -i eth6 phy_tempsense | awk "{print \$1/2+20}"); \
TEMP_5G=$(wl -i eth7 phy_tempsense | awk "{print \$1/2+20}"); \
echo -e "🟢 \033[1;32m2.4GHz 功率：\033[0m \033[1;37m$PWR_2G dBm\033[0m ($mW_2G mW)  | \033[1;36m晶片溫度：\033[0m $TEMP_2G°C"; \
echo -e "🔮 \033[1;35m5GHz   功率：\033[0m \033[1;37m$PWR_5G dBm\033[0m ($mW_5G mW)  | \033[1;36m晶片溫度：\033[0m $TEMP_5G°C"; \
echo -e "\033[1;33m==========================================\033[0m"'
EOF

# 3. 強制刷新，讓當前視窗立刻載入新設定
source ~/.profile

echo "------------------------------------------"
echo " 🎉 快捷鍵更新安裝完成！"
echo "------------------------------------------"
echo " 現在請直接在黑色視窗中輸入四個字母： wpwr"
echo " 按下 Enter 即可看到您專屬的彩色大功率面板！"
echo "=========================================="
