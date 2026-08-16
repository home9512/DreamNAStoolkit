#!/bin/sh

echo "=========================================="
echo "    開始安裝 RT-AX86U 梅林大功率解鎖腳本"
echo "=========================================="

# 1. 建立核心解鎖腳本 (修正 rc_service 錯誤)
cat << 'EOF' > /jffs/scripts/wireless-unlock.sh
#!/bin/sh
# 確保系統開機無線晶片初始化完成
sleep 20

# 寫入全球滿血大功率區域代碼
nvram set territory_code=AA
nvram set wl_country_code=US
nvram set wl0_country_code=US
nvram set wl1_country_code=US
nvram set location_code=#a
nvram set wl0_reg_mode=h
nvram set wl1_reg_mode=h
nvram commit

# 修正：使用標準命令重新載入無線服務
service restart_wireless
EOF

# 2. 賦予解鎖腳本執行權限
chmod +x /jffs/scripts/wireless-unlock.sh

# 3. 將腳本寫入梅林的開機啟動清單 (services-start)
if [ ! -f /jffs/scripts/services-start ]; then
    # 如果原本沒有開機啟動檔，就建一個新的並加上開機宣告
    echo "#!/bin/sh" > /jffs/scripts/services-start
fi

if ! grep -q "wireless-unlock.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/wireless-unlock.sh &" >> /jffs/scripts/services-start
    echo "已成功將解鎖腳本掛載至開機啟動項！"
fi

# 4. 賦予開機啟動檔執行權限
chmod +x /jffs/scripts/services-start

# 5. 當下立刻執行一次，讓功率不用重開機就生效
echo "正在動態重新載入無線服務，請稍候 15 秒..."
/bin/sh /jffs/scripts/wireless-unlock.sh

echo "------------------------------------------"
echo " 安裝完成！請輸入以下指令驗證功率是否變大："
echo " wl -i eth6 txpwr_target_max"
echo " wl -i eth7 txpwr_target_max"
echo "=========================================="
