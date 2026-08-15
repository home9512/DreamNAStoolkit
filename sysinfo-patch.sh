#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 網頁後台功率顯示補丁 (Network修正版)"
echo "=========================================="

# 1. 建立核心網頁注入與動態更新腳本
cat << 'EOF' > /jffs/scripts/sysinfo-patch.sh
#!/bin/sh

# 確保開機時等待系統無線晶片和網頁服務初始化完成
sleep 25

# 1) 動態讀取當前晶片的真實最大發射功率 (dBm)
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | awk '{print $1}')
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | awk '{print $1}')

# 如果讀取失敗，則給予安全預設值
[ -z "$PWR_2G" ] && PWR_2G="26.00"
[ -z "$PWR_5G" ] && PWR_5G="26.00"

# 2) 將 dBm 自動換算為直觀的 mW 數值 (公式: 10^((dBm)/10))
mW_2G=$(awk -v dbm="$PWR_2G" 'BEGIN {print int(10^(dbm/10))}')
mW_5G=$(awk -v dbm="$PWR_5G" 'BEGIN {print int(10^(dbm/10))}')

# 3) 建立網頁影子快取，避免直接改動唯讀系統
cp /www/Tools_Sysinfo.asp /tmp/Tools_Sysinfo_custom.asp

# 4) 核心定位：精確瞄準你畫面最下方的「Wireless Clients (5 GHz)」這一行，在它的下方直接插入兩行全新數據
sed -i "/Wireless Clients (5 GHz)/{n;a \\
<tr><th>2.4GHz 無線發射功率<\/th><td><span style='color:#00ffcc;font-weight:bold;'>$PWR_2G dBm<\/span> ($mW_2G mW) <span style='color:#ffcc00;font-size:11px;margin-left:8px;'>[ 滿血解鎖 🚀 ]<\/span><\/td><\/tr>\\
<tr><th>5GHz 無線發射功率<\/th><td><span style='color:#ff00ff;font-weight:bold;'>$PWR_5G dBm<\/span> ($mW_5G mW) <span style='color:#ffcc00;font-size:11px;margin-left:8px;'>[ 滿血解鎖 🚀 ]<\/span><\/td><\/tr>
}" /tmp/Tools_Sysinfo_custom.asp

# 5) 用修改後的影子網頁動態綁定覆蓋原廠網頁
mount --bind /tmp/Tools_Sysinfo_custom.asp /www/Tools_Sysinfo.asp
EOF

# 2. 賦予補丁最高執行權限
chmod +x /jffs/scripts/sysinfo-patch.sh

# 3. 檢查並自動掛載至梅林的開機啟動清單 (services-start)
if [ ! -f /jffs/scripts/services-start ]; then
    echo "#!/bin/sh" > /jffs/scripts/services-start
fi

if ! grep -q "sysinfo-patch.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/sysinfo-patch.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 4. 當下立刻在背景跑一次，免重開機即時在網頁上生效
/bin/sh /jffs/scripts/sysinfo-patch.sh

echo "------------------------------------------"
echo " 🎉 網頁補丁更新部署完畢！"
echo "=========================================="
