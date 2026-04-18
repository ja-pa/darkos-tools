#!/bin/bash

# --- NASTAVENÍ ---
IMG="dArkOS_RG353m_trixie_01312026.img"
ROOT="/tmp/darkos-root"
OFFSET=121634816

# 1. Kontrola mountu
if ! mountpoint -q "$ROOT"; then
    echo "[*] Mountuji dArkOS image..."
    sudo mkdir -p "$ROOT"
    sudo mount -o loop,offset=$OFFSET "$IMG" "$ROOT"
fi

# 2. Kontrola QEMU a systémových cest
[ -f "$ROOT/usr/bin/qemu-aarch64-static" ] || sudo cp /usr/bin/qemu-aarch64-static "$ROOT/usr/bin/"

for d in dev dev/pts proc sys run; do
    mountpoint -q "$ROOT/$d" || sudo mount --bind "/$d" "$ROOT/$d"
done

# 3. Síť a Identifikace chrootu
sudo cp /etc/resolv.conf "$ROOT/etc/resolv.conf"
# Tady vytvoříme nápis, který se objeví v závorkách před jménem
echo "dArkOS-ARM" | sudo tee "$ROOT/etc/debian_chroot" > /dev/null


if [ "$1" == "-r" ]; then
    echo "[*] Vstupuji jako ROOT pro údržbu systému..."
    sudo chroot "$ROOT" /usr/bin/qemu-aarch64-static /bin/bash
elif [ $# -eq 0 ]; then
    echo "[*] Vstupuji jako ark (kompilace)..."
    sudo chroot "$ROOT" /usr/bin/qemu-aarch64-static /bin/su - ark
else
    sudo chroot "$ROOT" /usr/bin/qemu-aarch64-static /bin/su - ark -c "$*"
fi
