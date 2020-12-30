#!bin/bash

# Go to the working directory
cd ~/kernel
# Clone the kernel source
mkdir build && cd build
git clone --depth=1 https://github.com/LinkBoi00/twrp_kernel_xiaomi_daisy .
# Execute compile script
bash compile.sh
# Save files
date_time=$(date +"%d%m%Y%H%M")
cd out/arch/arm64/boot
mkdir ~/final
cp Image.gz-dtb ~/final/Image.gz-dtb-"$date_time"
# Upload to oshi.at
curl -T ~/final/Image.gz-dtb-* https://oshi.at 
