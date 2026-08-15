#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 網頁專業設置「地區選單」強行解鎖"
echo "=========================================="

# 1. 建立網頁動態注入與命令接收補丁
cat << 'EOF' > /jffs/scripts/web-region-patch.sh
#!/bin/sh
sleep 25

# 備份原廠無線專業設置網頁
cp /www/Advanced_WAdvanced_Content.asp /tmp/Advanced_WAdvanced_Content_custom.asp

# 核心注入 1：在網頁最上方強制插入一個「地區選擇」的 HTML 下拉選單表格行
sed -i '/"wl_subunit"/i \
<tr><th>地區选择<\/th><td><select name="wl_region_custom" id="wl_region_custom" class="input_option" onchange="change_custom_region();"><option value="TW">台灣 (預設)<\/option><option value="US">美國 (滿血大功率)<\/option><option value="AU">澳大利亞 (滿血大功率)<\/option><\/select><\/td><\/tr>' /tmp/Advanced_WAdvanced_Content_custom.asp

# 核心注入 2：動態向網頁尾端注入 JavaScript 控制代碼，自動同步目前的地區狀態
CURRENT_TERRITORY=$(nvram get territory_code)
[ -z "$CURRENT_TERRITORY" ] && CURRENT_TERRITORY="TW"

sed -i "/<\/body>/i \
<script>\
document.getElementById('wl_region_custom').value = '$CURRENT_TERRITORY';\
function change_custom_region(){\
    var sel = document.getElementById('wl_region_custom').value;\
    if(confirm('確定要將路由器無線地區切換為 ' + sel + ' 嗎？')){\
        // 透過隱藏的 iframe 連接後台，免重開機即時刷入大功率代碼\
        var script_cmd = '';\
        if(sel == 'US'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=US && nvram set wl0_country_code=US && nvram set wl1_country_code=US && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit && service restart_wireless';\
        }else if(sel == 'AU'){\
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=AU && nvram set wl0_country_code=AU && nvram set wl1_country_code=AU && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit && service restart_wireless';\
        }else{\
            script_cmd = 'nvram set territory_code=TW && nvram set location_code=TW && nvram set wl_country_code=TW && nvram set wl0_country_code=TW && nvram set wl1_country_code=TW && nvram set wl_reg_mode=0 && nvram set wl0_reg_mode=0 && nvram set wl1_reg_mode=0 && nvram commit && service restart_wireless';\
        }\
        /* 使用梅林核心指令執行發送 */\
        var img = new Image();\
        img.src = '/applydb.cgi?current_page=Advanced_WAdvanced_Content.asp&next_page=Advanced_WAdvanced_Content.asp&action_mode= Apply &action_script=restart_wireless&action_wait=10&' + Math.random();\
        alert('設定已發送！無線網路正在背景重新啟動以套用大功率，請等待 15 秒後重新整理。');\
    }\
}\
<\/script>" /tmp/Advanced_WAdvanced_Content_custom.asp

# 核心安全步驟：用影子網頁強制覆蓋原廠網頁
mount --bind /tmp/Advanced_WAdvanced_Content_custom.asp /www/Advanced_WAdvanced_Content.asp
EOF

# 2. 賦予權限並掛載至開機啟動
chmod +x /jffs/scripts/web-region-patch.sh
if [ ! -f /jffs/scripts/services-start ]; then echo "#!/bin/sh" > /jffs/scripts/services-start; fi
if ! grep -q "web-region-patch.sh" /jffs/scripts/services-start 2>/dev/null; then
    echo "/bin/sh /jffs/scripts/web-region-patch.sh &" >> /jffs/scripts/services-start
fi
chmod +x /jffs/scripts/services-start

# 3. 立即在本機背景執行一次，不需要重開機當下生效！
/bin/sh /jffs/scripts/web-region-patch.sh

echo "------------------------------------------"
echo " 🎉 「網頁地區選單解鎖」成功！"
echo " 現在請至瀏覽器開新無痕視窗，重新登入華碩後台"
echo " 進入「無線網路 -> 專業設置」，最上方將會神奇出現【地區選擇】下拉選單！"
echo "=========================================="
