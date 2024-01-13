SOURCE_URL=https://github.com/coolsnowwolf/lede
SOURCE_BRANCH=master
COMMIT_ID=b65b15a30e3fe59dd9ecf0009afd9b938624c485
CONFIG_FILE=configs/rpi4.config
EXTRA_CONFIG=configs/extra.config
DIY_SCRIPT=diy-rpi4.sh
TOOLCHAIN_TAG=Toolchain
CLASH_KERNEL=arm64
UPLOAD_BIN_DIR=false
FIRMWARE_RELEASE=false
FIRMWARE_TAG=RaspberryPi4

# 切换工作目录到脚本所在的目录
GITHUB_WORKSPACE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$GITHUB_WORKSPACE"

OPENWRT_PATH=$(pwd)/openwrt

if [ -d "$OPENWRT_PATH" ]; then
    cd $OPENWRT_PATH
    git pull
else
    # 如果文件夹不存在，使用git clone来创建仓库
    git clone $SOURCE_URL -b $SOURCE_BRANCH $OPENWRT_PATH
    # cd $OPENWRT_PATH
    # git reset --hard $COMMIT_ID
fi

# cd "$GITHUB_WORKSPACE"
# [ -e $CONFIG_FILE ] && cp $CONFIG_FILE $OPENWRT_PATH/.config
# echo "CONFIG_ALL=y" >> $OPENWRT_PATH/.config
# echo "CONFIG_ALL_NONSHARED=y" >> $OPENWRT_PATH/.config
# cd $OPENWRT_PATH
# make defconfig > /dev/null 2>&1

echo "Updating Feeds"
cd $OPENWRT_PATH
./scripts/feeds update -a
./scripts/feeds install -a

echo "Copying Directory [files]"
cd "$GITHUB_WORKSPACE"
[ -e files ] && cp -r files $OPENWRT_PATH/files
echo "Copying Config"
[ -e $CONFIG_FILE ] && cp $CONFIG_FILE $OPENWRT_PATH/.config
cat $EXTRA_CONFIG >> $OPENWRT_PATH/.config
chmod +x $GITHUB_WORKSPACE/scripts/*.sh
chmod +x $DIY_SCRIPT

echo "Run DIY Scripts"
cd $OPENWRT_PATH
$GITHUB_WORKSPACE/$DIY_SCRIPT
$GITHUB_WORKSPACE/scripts/preset-clash-core.sh $CLASH_KERNEL
$GITHUB_WORKSPACE/scripts/preset-terminal-tools.sh