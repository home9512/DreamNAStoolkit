#!/bin/sh

echo "=========================================="
echo "  RT-AX86U 網頁專業設置「地區選單」實體直出版"
echo "=========================================="

# 核心安全步驟：先徹底拔除可能壞掉的舊快取，保證重新整理
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
rm -f /tmp/Advanced_WAdvanced_Content_custom.asp

# 1. 建立開機自啟網頁注入腳本 (請將下方網址換成你自己的 GitHub 帳號與專案名)
cat << 'EOF' > /jffs/scripts/web-region-patch.sh
#!/bin/sh
sleep 25
umount -l /www/Advanced_WAdvanced_Content.asp 2>/dev/null
cp /www/Advanced_WAdvanced_Content.asp /tmp/Advanced_WAdvanced_Content_custom.asp

# 直接從你的 GitHub 下載寫好的完整網頁補丁附加檔，強行追加到原廠網頁最尾端
curl -kLs https://raw.githubusercontent.com/home9512/DreamNAStoolkit/refs/heads/main/Advanced_Content.asp >> /tmp/Advanced_WAdvanced_Content_custom.asp

# 完美覆蓋
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
echo " 🎉 網頁地區選單最終直連版安裝成功！"
echo "=========================================="
