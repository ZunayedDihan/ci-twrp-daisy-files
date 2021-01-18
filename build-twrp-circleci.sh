#!bin/bash

# Go to the working directory
cd ~/TWRP-9
# Configure git
git config --global user.email "50962670+LinkBoi00@users.noreply.github.com"
git config --global user.name "LinkBoi00"
git config --global color.ui false
# Sync the source
repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
# Fix logcat in the source
cd bootable/recovery
git fetch https://gerrit.twrp.me/android_bootable_recovery refs/changes/98/3298/2 && git cherry-pick FETCH_HEAD
cd ~/TWRP-9
# Clone device tree and common tree
git clone --depth=1 https://github.com/LinkBoi00/twrp_device_motorola_deen -b android-9.0 device/motorola/deen
git clone --depth=1 https://github.com/TeamWin/android_device_qcom_common -b android-9.0 device/qcom/common
# Build recovery image
cd ~/TWRP-9
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch omni_deen-eng; make -j$(nproc --all) recoveryimage
# Make the recovery installer
cp -fr device/motorola/deen/installer out/target/product/deen
cd out/target/product/deen
cp -f ramdisk-recovery.cpio installer
cd installer
zip -qr recovery-installer ./
cd .. &&  cp -f installer/recovery-installer.zip .
# Rename and copy the files
twrp_version=$(cat ~/TWRP-9/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
device_version=$(cat ~/TWRP-9/device/motorola/deen/BoardConfig.mk | grep "TW_DEVICE_VERSION :=" | sed 's/ //g' | cut -f2 -d'=' -s)
mkdir ~/final
cp recovery.img ~/final/twrp-$twrp_version-"$device_version"-deen-"$date_time"-unofficial.img
cp recovery-installer.zip ~/final/twrp-$twrp_version-"$device_version"-deen-"$date_time"-unofficial.zip
# Upload to oshi.at
curl -T ~/final/*.img https://oshi.at 
curl -T ~/final/*.zip https://oshi.at