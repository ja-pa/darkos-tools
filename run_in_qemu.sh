#!/bin/bash

qemu-system-aarch64   -M virt   -cpu cortex-a53   -m 1024   -device virtio-gpu-gl-pci,hostmem=512M   -display gtk,gl=on   -serial mon:stdio   -kernel /home/paja/data/src/kernel/kernel_darkos_virt/kernel_5_10_226/arch/arm64/boot/Image   -drive file=/home/paja/Downloads/darkos/dArkOS_RG353m_trixie_01312026.img,format=raw,if=none,id=hd0   -netdev user,id=net0,hostfwd=tcp::2222-:22   -device virtio-net-pci,netdev=net0   -device virtio-blk-pci,drive=hd0   -append "console=ttyAMA0 root=/dev/vda4 rw rootwait"
