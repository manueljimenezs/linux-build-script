# linux-build-script


This script aims at making it easier to compile your own kernel with custom modifications.

Running the `build.sh` script will take care of patching, building and installing the linux kernel.

In the script modify the `KERNELVER` variable to the linux version you want to install.

In the patches folder, diff files are located to patch certain files on this kernel

In this case, the `0001-amdgpu-clock.patch` patches the pixel clock on DVI AMD GPUs so the can output bigger resolutions and refresh rates under this port.

The config file included was modified to integrate the EXT4 and BTRFS filesystems in the kernel so linux can boot those FS.

Note:


This script and config were made to work in Archlinux, but there should be no problems in other distros.