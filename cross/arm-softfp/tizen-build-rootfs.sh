#!/usr/bin/env bash
set -e

__ARM_SOFTFP_CrossDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
__TIZEN_CROSSDIR="$__ARM_SOFTFP_CrossDir/tizen"

if [[ -z "$ROOTFS_DIR" ]]; then
    echo "ROOTFS_DIR is not defined."
    exit 1;
fi

# Clean-up (TODO-Cleanup: We may already delete  $ROOTFS_DIR at ./cross/build-rootfs.sh.)
# hk0110
if [ -d "$ROOTFS_DIR" ]; then
    umount $ROOTFS_DIR/*
    rm -rf $ROOTFS_DIR
fi

TIZEN_TMP_DIR=$ROOTFS_DIR/tizen_tmp
TIZEN_TMP_DOWNLOAD_DIR=$TIZEN_TMP_DIR/download
TIZEN_TMP_UNZIP_DIR=$TIZEN_TMP_DIR/unzip
mkdir -p $TIZEN_TMP_DOWNLOAD_DIR
mkdir -p $TIZEN_TMP_UNZIP_DIR

download_files()
{
    # TODO: There will be a stable Tizen rootfs available later.
    # Now we temporarily use live repo for developing dotnet for Tizen

    TIZEN_DOWNLOAD_OPTIONS="-P $TIZEN_TMP_DOWNLOAD_DIR"
    TIZEN_DOWNLOAD_CMD="wget $TIZEN_DOWNLOAD_OPTIONS"

    # 1. basse packages
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/gcc-4.9.2-2.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/glibc-2.20-2.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/glibc-devel-2.20-2.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/libicu-devel-57.1-1.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/noarch/linux-glibc-devel-3.10-1.1.noarch.rpm

    # 2. download rpms
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/lldb-3.8.1-2.3.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/lldb-devel-3.8.1-2.3.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libuuid-2.28-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libuuid-devel-2.28-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/gcc-4.9.2-2.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libgcc-4.9.2-2.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libstdc++-4.9.2-2.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libstdc++-devel-4.9.2-2.2.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/libunwind-1.1-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/libunwind-devel-1.1-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/tizen-release-3.0.0-1.7.armv7l.rpm
    # 3. for corefx
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libcom_err-1.42.13-2.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-base/tizen-3.0-base_20161223.2/repos/arm/packages/armv7l/libcom_err-devel-1.42.13-2.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/gssdp-0.14.4-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/gssdp-devel-0.14.4-1.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/krb5-devel-1.10.2-3.1.armv7l.rpm
    $TIZEN_DOWNLOAD_CMD http://download.tizen.org/releases/weekly/tizen/3.0-mobile/tizen-3.0-mobile_20161223.1/repos/arm-wayland/packages/armv7l/krb5-1.10.2-3.1.armv7l.rpm

}

# Download files
echo ">>Start downloading files"
download_files
echo "<<Finish downloading files"

echo ">>Start constructing Tizen rootfs"
TIZEN_RPM_FILES=`ls $TIZEN_TMP_DOWNLOAD_DIR/*.rpm`
cd $ROOTFS_DIR
for f in $TIZEN_RPM_FILES; do
    rpm2cpio $f  | cpio -idm --quiet
done
echo "<<Finish constructing Tizen rootfs"

# Cleanup tmp
rm -rf $TIZEN_TMP_DIR

# Configure Tizen rootfs
echo ">>Start configuring Tizen rootfs"
rm ./usr/lib/libunwind.so
ln -s libunwind.so.8 ./usr/lib/libunwind.so
ln -sfn asm-arm ./usr/include/asm
patch -p1 < $__TIZEN_CROSSDIR/tizen.patch
echo "<<Finish configuring Tizen rootfs"
