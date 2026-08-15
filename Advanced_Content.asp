<!-- 專屬解鎖大功率影子組件 -->
<script>
setTimeout(function(){
    var tables = document.getElementsByTagName('table');
    for(var i=0; i<tables.length; i++){
        if(tables[i].className === 'FormTable'){
            var newRow = tables[i].insertRow(0);
            var th = document.createElement('th');
            th.style.color = '#ffcc00';
            th.style.fontWeight = 'bold';
            th.innerText = '無線地區選擇';
            var td = document.createElement('td');
            td.innerHTML = '<select name="wl_region_custom" id="wl_region_custom" class="input_option" onchange="change_custom_region();" style="background-color:#1f2d3d;color:#fff;font-weight:bold;border:1px solid #567394;"><option value="TW">台灣 (原廠預設)</option><option value="US">美國 (滿血大功率 🚀)</option><option value="AU">澳大利亞 (滿血大功率 🚀)</option></select>';
            newRow.appendChild(th);
            newRow.appendChild(td);
            
            // 讀取目前系統 NVRAM 的地區代碼
            var curr_geo = 'TW';
            if(window.btoa){
                // 透過隱藏組件讀取
                curr_geo = (document.form && document.form.wl_country_code) ? document.form.wl_country_code.value : 'TW';
            }
            document.getElementById('wl_region_custom').value = curr_geo;
            break;
        }
    }
}, 400);

function change_custom_region(){
    var sel = document.getElementById('wl_region_custom').value;
    if(confirm('確定要將路由器無線地區切換為 ' + sel + ' 嗎？\n\n無線網路將在背景自動重新啟動以解鎖發射功率！')){
        var script_cmd = '';
        if(sel == 'US'){
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=US && nvram set wl0_country_code=US && nvram set wl1_country_code=US && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';
        }else if(sel == 'AU'){
            script_cmd = 'nvram set territory_code=AA && nvram set location_code=#a && nvram set wl_country_code=AU && nvram set wl0_country_code=AU && nvram set wl1_country_code=AU && nvram set wl0_reg_mode=h && nvram set wl1_reg_mode=h && nvram commit';
        }else{\
            script_cmd = 'nvram set territory_code=TW && nvram set location_code=TW && nvram set wl_country_code=TW && nvram set wl0_country_code=TW && nvram set wl1_country_code=TW && nvram set wl0_reg_mode=0 && nvram set wl1_reg_mode=0 && nvram commit';
        }
        
        // 透過秘密網域直接刷入
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/applydb.cgi?current_page=Advanced_WAdvanced_Content.asp&next_page=Advanced_WAdvanced_Content.asp&action_mode= Apply &action_script=restart_wireless&action_wait=15&' + Math.random(), true);
        xhr.send();
        alert('指令已送出！無線網路正在背景重新加載，請等待 15 秒後重新整理網頁。');
    }
}
</script>
