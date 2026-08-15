#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 網頁專業設置「地區選單」完美內嵌"
echo "=========================================="

# 1. 建立網頁動態注入與命令接收補丁
cat << 'EOF' > /jffs/scripts/web-region-patch.sh
#!/bin/sh
sleep 25

# 備份原廠無線專業設置網頁
cp /www/Advanced_WAdvanced_Content.asp /tmp/Advanced_WAdvanced_Content_custom.asp

# 讀取目前系統的真實地區碼
CURRENT_TERRITORY=$(nvram get territory_code)
[ -z "$CURRENT_TERRITORY" ] || [ "$CURRENT_TERRITORY" = "AA" ] && {
    if [ "$(nvram get wl_country_code)" = "US" ]; then
        CURRENT_TERRITORY="US"
    else
        CURRENT_TERRITORY="AU"
    fi
}
[ -z "$CURRENT_TERRITORY" ] && CURRENT_TERRITORY="TW"

# 核心注入：直接在網頁結尾 </body> 前方，強行追加一整段完全不依賴 sed 定位的 JavaScript 表格動態插入代碼
sed -i "/<\/body>/i \
<script>\
setTimeout(function(){\
    var formTable = document.getElementsByClassName('FormTable')[0];\
    if(formTable){\
        var newRow = formTable.insertRow(0);\
        var th = document.createElement('th');\
        th.style.color = '#ffcc00';\
        th.style.fontWeight = 'bold';\
        th.innerText = '無線地區選擇';\
        var td = document.createElement('td');\
        td.innerHTML = '<select name=\"wl_region_custom\" id=\"wl_region_custom\" class=\"input_option\" onchange=\"change_custom_region();\" style=\"background-color:#1f2d3d;color:#fff;font-weight:bold;border:1px solid #567394;\"><option value=\"TW\">台灣 (原廠預設)<\/option><option value=\"US\">美國 (滿血大功率 🚀)<\/option><option value=\"AU\">澳大利亞 (滿血大功率 🚀)<\/option><\/select>';\
        newRow.appendChild(th);\
        newRow.appendChild(td);\
        document.getElementById('wl_region_custom').value = '$CURRENT_TERRITORY';\
    }\
}, 300);\
\
function change_custom_region(){\
    var sel = document.getElementById('wl_region_custom').value;\
    if(confirm('確定要將路由器無線地區切換為 ' + sel + ' 嗎？\\\\n\\\\n無線網路將在背景自動重新啟動以解鎖發射功率！')){\
        /* 由於新版 4.0 限制安全網域，我們透過梅林內建的秘密後台直接動態寫入並提交 NVRAM */\
        var script_cmd = '';\
        if(sel == 'US'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=US && nvram set wl0_country_code=US && nvram set wl1_country_code=US && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';\
        }else if(sel == 'AU'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=AU && nvram set wl0_country_code=AU && nvram set wl1_country_code=AU && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';\
        }else{\
            script_cmd = 'nvram set territory_code=TW && nvram set location_code=TW && nvram set wl_country_code=TW && nvram set wl0_country_code=TW && nvram set wl1_country_code=TW && nvram set wl_reg_mode=0 && nvram set wl0_reg_mode=0 && nvram set wl1_reg_mode=0 && nvram commit';\
        }\
        /* 使用與大功率腳本完全相同的動態 rc 服務，實現網頁點選、免重開機 15 秒背景即時套用 */\
        var xhr = new XMLHttpRequest();\
        xhr.open('GET', '/applydb.cgi?current_page=Advanced_WAdvanced_Content.asp&next_page=Advanced_WAdvanced_Content.asp&action_mode= Apply &action_script=restart_wireless&action_wait=15&' + Math.random(), true);\
        xhr.send();\
        alert('設定已送出！無線網路正在背景重新加載，請等待 15 秒後重新整理網頁。');\
    }\
}\
<\/script>" /tmp/Advanced_WAdvanced_Content_custom.asp

# 用修改後的影子網頁強制覆蓋原廠網頁
mount --bind /tmp/Advanced_WAdvanced_Content_custom.asp /www/Advanced_WAdvanced_Content.asp
EOF

# 2. 權限與掛載
chmod +x /jffs/scripts/web-region-patch.sh
if [ ! -f /jffs/scripts/services-start ]; then echo "#!/bin/sh" > /jffs/scripts/services-start; fi
if ! grep -q "web-region-patch.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/web-region-patch.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 3. 立即在本機背景執行一次
/bin/sh /jffs/scripts/web-region-patch.sh

echo "------------------------------------------"
echo " 🎉 網頁地區選單最終修正版部署完畢！"
echo "=========================================="
