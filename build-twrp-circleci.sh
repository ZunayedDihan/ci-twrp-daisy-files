#!bin/bash

# Go to the working directory
cd ~/SHRP-9
# Configure git
git config --global user.email "50962670+LinkBoi00@users.noreply.github.com"
git config --global user.name "LinkBoi00"
git config --global color.ui false
# Sync the source
repo init --depth=1 -u git://github.com/SHRP/platform_manifest_twrp_omni.git -b v3_9.0
repo sync -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
# Clone device tree tree
git clone --depth=1 https://github.com/LinkBoi00/shrp_device_xiaomi_daisy device/xiaomi/daisy
# Clone qcom common repo
git clone --depth=1 https://github.com/TeamWin/android_device_qcom_common device/qcom/common
# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch omni_daisy-eng; mka recoveryimage
# Make the recovery installer
cp -fr device/xiaomi/daisy/installer out/target/product/daisy
cd out/target/product/daisy
cp -f ramdisk-recovery.cpio installer
cd installer
zip -qr recovery-installer ./
cd .. &&  cp -f installer/recovery-installer.zip .
# Rename and copy the files
twrp_version=$(cat ~/SHRP-9/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
device_version=$(cat ~/SHRP-9/device/xiaomi/daisy/BoardConfig.mk | grep "TW_DEVICE_VERSION :=" | sed 's/ //g' | cut -f2 -d'=' -s)
mkdir ~/final
cp recovery.img ~/final/SHRP_v3.1-$twrp_version-"$device_version"-daisy-"$date_time"-unofficial.img
cp recovery-installer.zip ~/final/SHRP_v3.1-$twrp_version-"$device_version"-daisy-"$date_time"-unofficial.zip
# Upload to oshi.at
curl -T ~/final/*.img https://oshi.at 
curl -T ~/final/*.zip https://oshi.at
