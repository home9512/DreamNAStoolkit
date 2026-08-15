#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 網頁專業設置「地區選單」函數內嵌"
echo "=========================================="

# 核心安全步驟：先徹底解除並清空壞掉的快取，保證乾淨環境
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
rm -f /tmp/Advanced_WAdvanced_Content_custom.asp

# 1. 建立開機自啟網頁注入腳本
cat << 'EOF' > /jffs/scripts/web-region-patch.sh
#!/bin/sh
sleep 25
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
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

# 🌟 核心攔截技術：瞄準原廠必執行的 function initial()，在它的括號後方直接注入選單生成與連動代碼
sed -i "/function initial(){/a \\
\tsetTimeout(function(){\
\t\tvar tables = document.getElementsByTagName('table');\
\t\tfor(var i=0; i<tables.length; i++){\
\t\t\tif(tables[i].className === 'FormTable'){\
\t\t\t\tvar newRow = tables[i].insertRow(0);\
\t\t\t\tvar th = document.createElement('th');\
\t\t\t\tth.style.color = '#ffcc00';\
\t\t\t\tth.style.fontWeight = 'bold';\
\t\t\t\tth.innerText = '無線地區選擇';\
\t\t\t\tvar td = document.createElement('td');\
\t\t\t\ttd.innerHTML = '<select name=\"wl_region_custom\" id=\"wl_region_custom\" class=\"input_option\" onchange=\"change_custom_region();\" style=\"background-color:#1f2d3d;color:#fff;font-weight:bold;border:1px solid #567394;\"><option value=\"TW\">台灣 (原廠預設)<\/option><option value=\"US\">美國 (滿血大功率 🚀)<\/option><option value=\"AU\">澳大利亞 (滿血大功率 🚀)<\/option><\/select>';\
\t\t\t\tnewRow.appendChild(th);\
\t\t\t\tnewRow.appendChild(td);\
\t\t\t\tdocument.getElementById('wl_region_custom').value = '$CURRENT_TERRITORY';\
\t\t\t\tbreak;\
\t\t\t}\
\t\t}\
\t}, 200);\
" /tmp/Advanced_WAdvanced_Content_custom.asp

# 🌟 核心注入 2：在網頁尾端補上網頁點選的事件接收器
sed -i "/<\/body>/i \
<script>\
function change_custom_region(){\
    var sel = document.getElementById('wl_region_custom').value;\
    if(confirm('確定要將路由器無線地區切換為 ' + sel + ' 嗎？\\\\n\\\\n無線網路將在背景自動重新啟動以解鎖發射功率！')){\
        var script_cmd = '';\
        if(sel == 'US'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=US && nvram set wl0_country_code=US && nvram set wl1_country_code=US && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';\
        }\
        else if(sel == 'AU'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=AU && nvram set wl0_country_code=AU && nvram set wl1_country_code=AU && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';\
        }\
        else{\
            script_cmd = 'nvram set territory_code=TW && nvram set location_code=TW && nvram set wl_country_code=TW && nvram set wl0_country_code=TW && nvram set wl1_country_code=TW && nvram set wl0_reg_mode=0 && nvram set wl1_reg_mode=0 && nvram commit';\
        }\
        var xhr = new XMLHttpRequest();\
        xhr.open('GET', '/applydb.cgi?current_page=Advanced_WAdvanced_Content.asp&next_page=Advanced_WAdvanced_Content.asp&action_mode= Apply &action_script=restart_wireless&action_wait=15&' + Math.random(), true);\
        xhr.send();\
        alert('指令已送出！無線網路正在背景重新加載，請等待 15 秒後重新整理網頁。');\
    }\
}\
<\/script>" /tmp/Advanced_WAdvanced_Content_custom.asp

# 完美覆蓋原廠網頁
mount --bind /tmp/Advanced_WAdvanced_Content_custom.asp /www/Advanced_WAdvanced_Content.asp
EOF

# 2. 權限與掛載
chmod +x /jffs/scripts/web-region-patch.sh
if [ ! -f /jffs/scripts/services-start ]; then echo "#!/bin/sh" > /jffs/scripts/services-start; fi
if ! grep -q "web-region-patch.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/web-region-patch.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 3. 當下立刻在本機跑一次
/bin/sh /jffs/scripts/web-region-patch.sh

echo "------------------------------------------"
echo " 🎉 網頁地區選單函數內嵌版安裝成功！"
echo "=========================================="
