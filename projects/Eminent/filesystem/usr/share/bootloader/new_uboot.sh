#!/bin/sh

cmdline=$(cat /proc/cmdline | grep new_uboot )
if [ ! "$cmdline" ]; then
  mkdir -p /tmp/cache
  mount -t ext4 /dev/cache /tmp/cache

  rm -f /tmp/cache/*.zip
  cp -f /usr/share/bootloader/uboot.zip /tmp/cache/update.zip
  sync

  mkdir -p /tmp/cache/recovery
  echo -e "--update_package=/cache/update.zip\n--wipe_cache" > /tmp/cache/recovery/command || exit 1

  dd if=/usr/share/bootloader/dtb_orig.img of=/dev/dtb bs=262144 count=1
  sync
  umount /tmp/cache

  echo "Update firmware"
  reboot recovery
fi