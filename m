Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61981 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752373AbbFWDHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 23:07:24 -0400
Message-ID: <5588CD54.9050405@cn.fujitsu.com>
Date: Tue, 23 Jun 2015 11:07:00 +0800
From: wangyf <wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@fb.com>, <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
References: <cover.1434739053.git.osandov@fb.com>
In-Reply-To: <cover.1434739053.git.osandov@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have tested your PATCH v2 , but something wrong happened.

kernel: 4.1.0-rc7+ with your five patches
vitrualBox ubuntu14.10-server + LVM

I make a new btrfs.ko with your patches,
rmmod original module and insmod the new.

When I use the profile RAID1/10, mkfs successfully
But when mount the fs, dmesg dumped:
     trans: 18446612133975020584 running 5
     btrfs transid mismatch buffer 29507584, found 18446612133975020584 
running 5
     btrfs transid mismatch buffer 29507584, found 18446612133975020584 
running 5
     btrfs transid mismatch buffer 29507584, found 18446612133975020584 
running 5
... ...

When use the RAID5/6, mkfs and mount
system stoped at the 'mount -t btrfs /dev/mapper/server-dev1 /mnt' cmd.

That's all.





在 2015年06月20日 02:52, Omar Sandoval 写道:
> Hi,
>
> Here's version 2 of the missing device RAID 5/6 fixes. The original
> problem was reported by a user on Bugzilla: the kernel crashed when
> attempting to replace a missing device in a RAID 6 filesystem. This is
> detailed and fixed in patch 4. After the initial posting, Zhao Lei
> reported a similar issue when doing a scrub on a RAID 5 filesystem with
> a missing device. This is fixed in the added patch 5.
>
> My new-and-improved-and-overengineered reproducer as well as Zhao Lei's
> reproducer can be found below.
>
> Thanks!
>
> v1: http://article.gmane.org/gmane.comp.file-systems.btrfs/45045
> v1->v2:
> - Add missing scrub_wr_submit() in scrub_missing_raid56_worker()
> - Add clarifying comment in dev->missing case of scrub_stripe()
>    (Zhaolei)
> - Add fix for scrub with missing device (patch 5)
>
> Omar Sandoval (5):
>    Btrfs: remove misleading handling of missing device scrub
>    Btrfs: count devices correctly in readahead during RAID 5/6 replace
>    Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation
>    Btrfs: fix device replace of a missing RAID 5/6 device
>    Btrfs: fix parity scrub of RAID 5/6 with missing device
>
>   fs/btrfs/raid56.c |  87 ++++++++++++++++++++---
>   fs/btrfs/raid56.h |  10 ++-
>   fs/btrfs/reada.c  |   4 +-
>   fs/btrfs/scrub.c  | 202 +++++++++++++++++++++++++++++++++++++++++++++---------
>   4 files changed, 259 insertions(+), 44 deletions(-)
>
> Reproducer 1:
>
> ----
> #!/bin/bash
>
> usage () {
> 	USAGE_STRING="Usage: $0 [OPTION]...
> Options:
>    -m    failure mode; MODE is 'eio', 'missing', or 'corrupt' (defaults to
>          'missing')
>    -n    number of files to write, each twice as big as the last, the first
>          being 1M in size (defaults to 4)
>    -o    operation to perform; OP is 'replace' or 'scrub' (defaults to
>          'replace')
>    -r    RAID profile; RAID is 'raid0', 'raid1', 'raid10', 'raid5', or 'raid6'
>          (defaults to 'raid5')
>
> Miscellaneous:
>    -h    display this help message and exit"
>
> 	case "$1" in
> 		out)
> 			echo "$USAGE_STRING"
> 			exit 0
> 			;;
> 		err)
> 			echo "$USAGE_STRING" >&2
> 			exit 1
> 			;;
> 	esac
> }
>
> MODE=missing
> RAID=raid5
> OP=replace
> NUM_FILES=4
>
> while getopts "m:n:o:r:h" OPT; do
> 	case "$OPT" in
> 		m)
> 			MODE="$OPTARG"
> 			;;
> 		r)
> 			RAID="$OPTARG"
> 			;;
> 		o)
> 			OP="$OPTARG"
> 			;;
> 		n)
> 			NUM_FILES="$OPTARG"
> 			if [[ ! "$NUM_FILES" =~ ^[0-9]+$ ]]; then
> 				usage "err"
> 			fi
> 			;;
> 		h)
> 			usage "out"
> 			;;
> 		*)
> 			usage "err"
> 			;;
> 	esac
> done
>
> case "$MODE" in
> 	eio|missing|corrupt)
> 		;;
> 	*)
> 		usage err
> 		;;
> esac
>
> case "$RAID" in
> 	raid[01])
> 		NUM_RAID_DISKS=2
> 		;;
> 	raid10)
> 		NUM_RAID_DISKS=4
> 		;;
> 	raid5)
> 		NUM_RAID_DISKS=3
> 		;;
> 	raid6)
> 		NUM_RAID_DISKS=4
> 		;;
> 	*)
> 		usage err
> 		;;
> esac
>
> case "$OP" in
> 	replace)
> 		NUM_DISKS=$((NUM_RAID_DISKS + 1))
> 		;;
> 	scrub)
> 		NUM_DISKS=$NUM_RAID_DISKS
> 		;;
> 	*)
> 		usage err
> 		;;
> esac
>
> echo "Running $OP on $RAID with $MODE"
>
> SRC_DISK=$((NUM_RAID_DISKS - 1))
> TARGET_DISK=$((NUM_DISKS - 1))
> NUM_SECTORS=$((1024 * 1024))
> LOOP_DEVICES=()
> DM_DEVICES=()
>
> cleanup () {
> 	echo "Done. Press enter to cleanup..."
> 	read
> 	if findmnt /mnt; then
> 		umount /mnt
> 	fi
> 	for DM in "${DM_DEVICES[@]}"; do
> 		dmsetup remove "$DM"
> 	done
> 	for LOOP in "${LOOP_DEVICES[@]}"; do
> 		losetup --detach "$LOOP"
> 	done
> 	for ((i = 0; i < NUM_DISKS; i++)); do
> 		rm -f disk${i}.img
> 	done
> }
> trap 'cleanup; exit 1' ERR
>
> echo "Creating disk images..."
> for ((i = 0; i < NUM_DISKS; i++)); do
> 	rm -f disk${i}.img
> 	dd if=/dev/zero of=disk${i}.img bs=512 seek=$NUM_SECTORS count=0
> 	LOOP_DEVICES+=("$(losetup --find --show disk${i}.img)")
> done
>
> echo "Creating loopback devices..."
> for LOOP in "${LOOP_DEVICES[@]}"; do
> 	DM="${LOOP/\/dev\/loop/dm}"
> 	dmsetup create "$DM" --table "0 $NUM_SECTORS linear $LOOP 0"
> 	DM_DEVICES+=("$DM")
> done
>
> echo "Creating filesystem..."
> FS_DEVICES=("${DM_DEVICES[@]:0:$NUM_RAID_DISKS}")
> FS_DEVICES=("${FS_DEVICES[@]/#//dev/mapper/}")
> echo "${FS_DEVICES[@]}"
> MOUNT_DEVICE="${FS_DEVICES[$(((SRC_DISK + 1) % NUM_RAID_DISKS))]}"
> mkfs.btrfs -d "$RAID" -m "$RAID" "${FS_DEVICES[@]}"
> mount "$MOUNT_DEVICE" /mnt
> for ((i = 0; i < NUM_FILES; i++)); do
> 	dd if=/dev/urandom of=/mnt/file$i bs=1M count=$((1 << $i))
> done
> sync
>
> case "$MODE" in
> 	eio)
> 		echo "Killing disk..."
> 		dmsetup suspend "${DM_DEVICES[$SRC_DISK]}"
> 		dmsetup reload "${DM_DEVICES[$SRC_DISK]}" --table "0 $NUM_SECTORS error"
> 		dmsetup resume "${DM_DEVICES[$SRC_DISK]}"
> 		;;
> 	missing)
> 		echo "Removing disk and remounting degraded..."
> 		umount /mnt
> 		dmsetup remove "${DM_DEVICES[$SRC_DISK]}"
> 		unset DM_DEVICES[$SRC_DISK]
> 		mount -o degraded "$MOUNT_DEVICE" /mnt
> 		;;
> 	corrupt)
> 		echo "Corrupting disk and remounting degraded..."
> 		umount /mnt
> 		dd if=/dev/zero of=/dev/mapper/"${DM_DEVICES[$SRC_DISK]}" bs=1M count=1
> 		mount -o degraded "$MOUNT_DEVICE" /mnt
> 		;;
> esac
>
> case "$OP" in
> 	replace)
> 		echo "Replacing disk..."
> 		btrfs replace start -B $((SRC_DISK + 1)) /dev/mapper/"${DM_DEVICES[$TARGET_DISK]}" /mnt
> 		;;
> 	scrub)
> 		echo "Scrubbing filesystem..."
> 		btrfs scrub start -B /mnt
> 		;;
> esac
>
> echo "Scrubbing to double-check..."
> btrfs scrub start -Br /mnt
>
> cleanup
> ----
>
> Reproducer 2:
>
> ----
> #!/bin/bash
>
> FS_DEVS=(/dev/vdb /dev/vdc /dev/vdd)
> PRUNE_DEV=/dev/vdc
> MNT=/mnt
>
> do_cmd()
> {
> 	echo "   $*"
> 	local output
> 	local ret
> 	output=$("$@" 2>&1)
> 	ret="$?"
> 	[[ "$ret" != 0 ]] && {
> 		echo "$output"
> 	}
> 	return "$ret"
> }
>
> mkdir -p "$MNT"
> for ((i = 0; i < 10; i++)); do
> 	umount "$MNT" &>/dev/null
> done
> dmesg -c >/dev/null
>
> echo "1: Creating filesystem"
> do_cmd mkfs.btrfs -f -d raid5 -m raid5 "${FS_DEVS[@]}" || exit 1
> do_cmd mount "$FS_DEVS" "$MNT" || exit 1
>
> echo "2: Write some data"
> DATA_CNT=4
> for ((i = 0; i < DATA_CNT; i++)); do
> 	size_m="$((1<<i))"
> 	do_cmd dd bs=1M if=/dev/urandom of="$MNT"/file_"$i" count="$size_m" || exit 1
> done
>
> echo "3: Prune a disk in fs"
> do_cmd umount "$MNT" || exit 1
> do_cmd dd bs=1M if=/dev/zero of="$PRUNE_DEV" count=1
> do_cmd mount -o "degraded" "$FS_DEVS" "$MNT" || exit 1
>
> echo "4: Do scrub"
> do_cmd btrfs scrub start -B "$MNT"
>
> echo "5: Checking result"
> dmesg --color
>
> exit 0
> ----
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
