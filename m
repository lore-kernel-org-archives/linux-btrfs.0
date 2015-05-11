Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34384 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbbEKH6c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 03:58:32 -0400
Received: by pacyx8 with SMTP id yx8so103894825pac.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 00:58:32 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaoxie@huawei.com>, Philip <bugzilla@philip-seeger.de>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
Date: Mon, 11 May 2015 00:58:11 -0700
Message-Id: <cover.1431330020.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported on Bugzilla that they were seeing kernel BUGs when
attempting to replace a missing device on a RAID 6 array. After
identifying the apparent cause of the BUG, I reached the conclusion that
there wasn't a quick fix. Maybe Miao Xie can point something out that I
missed, as he originally implemented device replace on RAID 5/6 :)

Patch 4 has the details, but the main problem is that we can't create
bios for a missing device, so the main scrub code path isn't very
useful. On RAID 5/6, since we only have one mirror for any piece of
data, the missing device is the only mirror we can use. Clearly, (unless
I missed something), this case needs to be handled differently.

These patches are on top of v4.1-rc2. I ran the scrub and replace
xfstests and the script below, which also reproduces the original BUG.

Thanks!

Omar Sandoval (4):
  Btrfs: remove misleading handling of missing device scrub
  Btrfs: count devices correctly in readahead during RAID 5/6 replace
  Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation
  Btrfs: fix device replace of a missing RAID 5/6 device

 fs/btrfs/raid56.c |  87 +++++++++++++++++++++++++----
 fs/btrfs/raid56.h |  10 +++-
 fs/btrfs/reada.c  |   4 +-
 fs/btrfs/scrub.c  | 164 +++++++++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 225 insertions(+), 40 deletions(-)

Testing script:

----
#!/bin/bash

USAGE="Usage: $0 [eio|missing] [raid0|raid1|raid5|raid6]" 

if [ "$1" = "-h" ]; then
	echo "$USAGE"
	exit
fi

MODE="${1:-missing}"
RAID="${2:-raid5}"

case "$MODE" in
	eio|missing)
		;;
	*)
		echo "$USAGE" >&2
		exit 1
		;;
esac

case "$RAID" in
	raid[0156])
		;;
	*)
		echo "$USAGE" >&2
		exit 1
		;;
esac

NUM_DISKS=4
NUM_RAID_DISKS=3
SRC_DISK=1
TARGET_DISK=3
NUM_SECTORS=$((1024 * 1024))
LOOP_DEVICES=()
DM_DEVICES=()

cleanup () {
	echo "Done. Press enter to cleanup..."
	read
	if findmnt /mnt; then
		umount /mnt
	fi
	for DM in "${DM_DEVICES[@]}"; do
		dmsetup remove "$DM"
	done
	for LOOP in "${LOOP_DEVICES[@]}"; do
		losetup --detach "$LOOP"
	done
	for ((i = 0; i < NUM_DISKS; i++)); do
		rm -f disk${i}.img
	done
}
trap 'cleanup; exit 1' ERR

echo "Creating disk images..."
for ((i = 0; i < NUM_DISKS; i++)); do
	rm -f disk${i}.img
	dd if=/dev/zero of=disk${i}.img bs=512 seek=$NUM_SECTORS count=0
	LOOP_DEVICES+=("$(losetup --find --show disk${i}.img)")
done

echo "Creating loopback devices..."
for LOOP in "${LOOP_DEVICES[@]}"; do
	DM="${LOOP/\/dev\/loop/dm}"
	dmsetup create "$DM" --table "0 $NUM_SECTORS linear $LOOP 0"
	DM_DEVICES+=("$DM")
done

echo "Creating filesystem..."
FS_DEVICES=("${DM_DEVICES[@]:0:$NUM_RAID_DISKS}")
FS_DEVICES=("${FS_DEVICES[@]/#/\/dev\/mapper\/}")
MOUNT_DEVICE="${FS_DEVICES[$(((SRC_DISK + 1) % NUM_RAID_DISKS))]}"
mkfs.btrfs -d "$RAID" -m "$RAID" "${FS_DEVICES[@]}"
mount "$MOUNT_DEVICE" /mnt
cp -r ~/xfstests /mnt
sync

case "$MODE" in
	eio)
		echo "Killing disk..."
		dmsetup suspend "${DM_DEVICES[$SRC_DISK]}"
		dmsetup reload "${DM_DEVICES[$SRC_DISK]}" --table "0 $NUM_SECTORS error"
		dmsetup resume "${DM_DEVICES[$SRC_DISK]}"
		;;
	missing)
		echo "Removing disk and remounting degraded..."
		umount /mnt
		dmsetup remove "${DM_DEVICES[$SRC_DISK]}"
		unset DM_DEVICES[$SRC_DISK]
		mount -o degraded "$MOUNT_DEVICE" /mnt
		;;
esac

echo "Replacing disk..."
btrfs replace start -B $((SRC_DISK + 1)) /dev/mapper/"${DM_DEVICES[$TARGET_DISK]}" /mnt

echo "Scrubbing to double-check..."
btrfs scrub start -Br /mnt

cleanup
----

-- 
2.4.0

