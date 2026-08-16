#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 左側選單最下方新增自訂欄位腳本"
echo "        (ASUSWRT 4.0 全網域通用版)"
echo "=========================================="

# 核心安全步驟：先徹底解除並清理舊的網頁掛載快取
umount -l /www/state.js 2>/dev/null
rm -f /tmp/state_custom.js

# 1. 建立開機自啟選單注入腳本
cat << 'EOF' > /jffs/scripts/menu-patch.sh
#!/bin/sh
# 確保開機時安全等待系統初始化完成
sleep 25

umount -l /www/state.js 2>/dev/null
cp /www/state.js /tmp/state_custom.js

# 1) 動態讀取當前晶片的真實最大發射功率與即時溫度
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | awk '{print $NF}' | sed 's/[a-zA-Z]//g')
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | awk '{print $NF}' | sed 's/[a-zA-Z]//g')

# 安全防護
[ -z "$PWR_2G" ] && PWR_2G="26.00"
[ -z "$PWR_5G" ] && PWR_5G="26.00"

mW_2G=$(awk -v dbm="$PWR_2G" 'BEGIN {print int(10^(dbm/10))}')
mW_5G=$(awk -v dbm="$PWR_5G" 'BEGIN {print int(10^(dbm/10))}')
TEMP_2G=$(wl -i eth6 phy_tempsense 2>/dev/null | awk '{print $1/2+20}')
TEMP_5G=$(wl -i eth7 phy_tempsense 2>/dev/null | awk '{print $1/2+20}')

# 2) 🌟 終極函數攔截技術：瞄準華碩 4.0 渲染左側選單按鈕的 show_menu() 函數結尾
# 直接在選單最末端動態追加一塊高度、字體與背景完美適配的金色火箭欄位，並內嵌即時狀態動態彈窗
sed -i "/setTimeout(\"show_menu();\", 100);/i \
\tvar menuTree = document.getElementById('menuTree');\
\tif(menuTree){\
\t\tvar newDiv = document.createElement('div');\
\t\tnewDiv.className = 'menu';\
\t\tnewDiv.style.background = 'linear-gradient(to right, #1f2d3d, #2a3c54)';\
\t\tnewDiv.style.borderLeft = '3px solid #ffcc00';\
\t\tnewDiv.style.marginTop = '2px';\
\t\tnewDiv.innerHTML = '<a href=\"javascript:void(0);\" onclick=\"alert(\x27⚡ RT-AX86U 即時狀態監控 ⚡\\\\n\\\\n🟢 2.4GHz 發射功率：$PWR_2G dBm ($mW_2G mW)\\\\n🔥 2.4GHz 晶片溫度：$TEMP_2G °C\\\\n\\\\n🔮 5GHz   發射功率：$PWR_5G dBm ($mW_5G mW)\\\\n🔥 5GHz   晶片溫度：$TEMP_5G °C\x27);\"><div class=\"menuIco\"><img src=\"/images/New_ui/network_card.png\" width=\"20\" height=\"20\" style=\"margin-top:7px;\"><\/div><div class=\"menuName\" style=\"color:#ffcc00;font-weight:bold;\">無線功率狀態 🚀<\/div><\/a>';\
\t\tmenuTree.appendChild(newDiv);\
\t}" /tmp/state_custom.js

# 3) 用修改後的影子核心腳本強制覆蓋原廠網頁組件
mount --bind /tmp/state_custom.js /www/state.js
EOF

# 2. 賦予補丁最高執行權限
chmod +x /jffs/scripts/menu-patch.sh

# 3. 檢查並自動掛載至梅林的開機啟動清單 (services-start)
if [ ! -f /jffs/scripts/services-start ]; then
    echo "#!/bin/sh" > /jffs/scripts/services-start
fi
if ! grep -q "menu-patch.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/menu-patch.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 4. 當下立刻在背景跑一次，免重開機即時在網頁上生效
/bin/sh /jffs/scripts/menu-patch.sh

echo "------------------------------------------"
echo " 🎉 全網域選單新增欄位補丁已更新部署完畢！"
echo "=========================================="
