#!/bin/bash
# zcat /proc/config.gz > .config
KERNELVER=linux-5.16.4
BOOT_FROM_BTRFS=1

get_and_prepare() {
    if [ ! -f $KERNELVER.tar.xz ]; then
        wget https://cdn.kernel.org/pub/linux/kernel/v5.x/$KERNELVER.tar.xz
    fi
    
    if [ ! -d $KERNELVER/ ]; then
        tar -xf $KERNELVER.tar.xz
    fi
    
    if [ $BOOT_FROM_BTRFS -eq 1 ]; then
        sed -i "s/^CONFIG_BTRFS_FS=.*/CONFIG_BTRFS_FS=y/g" config
        sed -i "s/^#CONFIG_BTRFS_FS=.*/CONFIG_BTRFS_FS=y/g" config
    fi

    cp -r config $KERNELVER/.config
}

patch_kernel() {	
  for i in $(ls patches); do
     patch -Np1 -d $KERNELVER < patches/0001-amdgpu-clock.patch
  done
}

build() {
    export KBUILD_BUILD_HOST=archlinux
    export KBUILD_BUILD_USER=linux-amdclock
    cd $KERNELVER
    make -j10
    make modules -j10
    sudo cp -v arch/x86/boot/bzImage /boot/vmlinuz-linux-amdclock
    sudo make modules_install
}

if ! command -v wget &> /dev/null; then
    echo "Please install wget"
    exit 1
fi

case "$1" in
 -b|--build-only)
    build
    exit 0
    ;;
 -p|--patch-only)
    patch_kernel
    exit 0
    ;;
esac

get_and_prepare
patch_kernel
build
