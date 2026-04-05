#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "🚀 Starting System Tweaks inside folder x..."

# التأكد من وجود المجلد x قبل البدء
if [ ! -d "x" ]; then
  echo "❌ Directory x not found in $(pwd)!"
  exit 1
fi

# 1. إنشاء المسارات الضرورية داخل x (قلب الـ ISO)
mkdir -p x/etc/default/
mkdir -p x/usr/share/applications/
mkdir -p x/etc/skel/Desktop/
mkdir -p x/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/

# 2. إعدادات الـ Double Click (APK, EXE, MSI) - حقن مباشر في ملفات النسخة
cat <<EOF > x/usr/share/applications/waydroid-install.desktop
[Desktop Entry]
Type=Application
Name=Install APK
Exec=waydroid app install %f
Icon=android-sdk
MimeType=application/vnd.android.package-archive;
EOF

# ربط الصيغ أوتوماتيكياً
echo "application/vnd.android.package-archive=waydroid-install.desktop" >> x/usr/share/applications/defaults.list
echo "application/x-ms-dos-executable=bottles.desktop" >> x/usr/share/applications/defaults.list
echo "application/x-msi=bottles.desktop" >> x/usr/share/applications/defaults.list

# 3. تعديلات الأداء والسرعة للـ HP G62 (حقن مباشر)
echo "ALGO=lz4" >> x/etc/default/zramswap
echo "PERCENT=60" >> x/etc/default/zramswap
echo "vm.swappiness=150" >> x/etc/sysctl.conf

# 4. تظبيط شكل XFCE (الثيم واللوجو)
cat <<EOF > x/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Yaru-dark"/>
    <property name="IconThemeName" type="string" value="Yaru"/>
  </property>
</channel>
EOF

# 5. هدية لك: سكريبت "اللمسة الأخيرة" على سطح المكتب
cat <<EOF > x/etc/skel/Desktop/Final_Install.sh
#!/bin/bash
echo "Installing Wine, Waydroid, and MX Tools..."
sudo apt update
sudo apt install -y waydroid wine xubuntu-desktop mx-tools synaptic
sudo waydroid init
echo "✅ Everything is ready!"
EOF
chmod +x x/etc/skel/Desktop/Final_Install.sh

echo "✅ All modifications completed inside folder x without errors!"
