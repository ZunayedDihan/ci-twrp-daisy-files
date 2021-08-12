#!bin/bash

# Go to the working directory
mkdir -p /tmp/PBRP-9
cd /tmp/PBRP-9

# Configure git
git config --global user.email "zunayeddihan@gmail.com"
git config --global user.name "ZunayedDihan"
git config --global color.ui false
# Sync the source
repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-9.0
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
# Use https://github.com/LinkBoi00/pbrp_bootable_recovery
mkdir empty_dir

# Clone device tree and common tree
git clone --depth=1 https://github.com/ZunayedDihan/twrp_device_xiaomi_daisy-1 device/xiaomi/daisy
rm -rf vendor/qcom/opensource/commonsys/cryptfs_hw
git clone --depth=1 https://github.com/TeamWin/android_device_qcom_common -b android-9.0 device/qcom/common
# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; export LC_ALL=C; . build/envsetup.sh; lunch omni_daisy-eng; mka recoveryimage
# Rename and copy the files
cd out/target/product/daisy
date_time=$(date +"%d%m%Y%H%M")
mkdir ~/final
cp recovery.img ~/final/pbrp-"$date_time"-recovery.img
cp PBRP-*.zip ~/final
# Upload to oshi.at
curl -T ~/final/*.img https://oshi.at 
curl -T ~/final/*.zip https://oshi.at
