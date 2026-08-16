#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 左側選單最下方新增自訂欄位腳本"
echo "=========================================="

# 1. 建立核心網頁注入與動態更新腳本
cat << 'EOF' > /jffs/scripts/menu-patch.sh
#!/bin/sh

# 確保開機時安全等待系統晶片和網頁服務初始化完成
sleep 25

# 徹底解除舊的綁定，確保環境乾淨
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
rm -f /tmp/Advanced_WAdvanced_Content_custom.asp 2>/dev/null

# 1) 動態讀取當前晶片的真實最大發射功率與即時溫度
PWR_2G=$(wl -i eth6 txpwr_target_max 2>/dev/null | awk '{print $NF}' | sed 's/[a-zA-Z]//g')
PWR_5G=$(wl -i eth7 txpwr_target_max 2>/dev/null | awk '{print $NF}' | sed 's/[a-zA-Z]//g')

# 安全防護：萬一抓不到則給予預設值
[ -z "$PWR_2G" ] && PWR_2G="26.00"
[ -z "$PWR_5G" ] && PWR_5G="26.00"

# 將 dBm 自動換算為 mW 數值
mW_2G=$(awk -v dbm="$PWR_2G" 'BEGIN {print int(10^(dbm/10))}')
mW_5G=$(awk -v dbm="$PWR_5G" 'BEGIN {print int(10^(dbm/10))}')

# 抓取晶片溫度
TEMP_2G=$(wl -i eth6 phy_tempsense 2>/dev/null | awk '{print $1/2+20}')
TEMP_5G=$(wl -i eth7 phy_tempsense 2>/dev/null | awk '{print $1/2+20}')

# 2) 建立網頁影子快取
cp /www/Advanced_WAdvanced_Content.asp /tmp/Advanced_WAdvanced_Content_custom.asp

# 3) 核心注入：在網頁結尾 </body> 前方注入 JavaScript 導覽列追加與動態視窗展示代碼
sed -i "/<\/body>/i \
<script>\
setTimeout(function(){\
    var menuTree = document.getElementById('mainmenu');\
    if(menuTree){\
        /* 建立自訂欄位的 HTML 結構 */\
        var newMenu = document.createElement('div');\
        newMenu.className = 'menu';\
        newMenu.style.background = 'linear-gradient(to right, #1f2d3d, #2a3c54)';\
        newMenu.style.borderLeft = '3px solid #ffcc00';\
        newMenu.style.marginTop = '2px';\
        newMenu.innerHTML = '<a href=\"javascript:void(0);\" onclick=\"show_pwr_status();\"><div class=\"menuIco\"><img src=\"/images/New_ui/network_card.png\" width=\"20\" height=\"20\" style=\"margin-top:7px;\"><\/div><div class=\"menuName\" style=\"color:#ffcc00;font-weight:bold;\">無線功率狀態 🚀<\/div><\/a>';\
        menuTree.appendChild(newMenu);\
    }\
}, 350);\
\
function show_pwr_status(){\
    var msg = '⚡ RT-AX86U 即時狀態監控 ⚡\\\\n\\\\n' +\
              '🟢 2.4GHz 發射功率：$PWR_2G dBm ($mW_2G mW)\\\\n' +\
              '🔥 2.4GHz 晶片溫度：$TEMP_2G °C\\\\n\\\\n' +\
              '🔮 5GHz   發射功率：$PWR_5G dBm ($mW_5G mW)\\\\n' +\
              '🔥 5GHz   晶片溫度：$TEMP_5G °C';\
    alert(msg);\
}\
<\/script>" /tmp/Advanced_WAdvanced_Content_custom.asp

# 4) 用修改後的影子網頁強制覆蓋原廠網頁
mount --bind /tmp/Advanced_WAdvanced_Content_custom.asp /www/Advanced_WAdvanced_Content.asp
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
echo " 🎉 選單新增欄位補丁部署完畢！"
echo "=========================================="
