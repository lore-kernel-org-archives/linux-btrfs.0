From: Mark Bergsma <mark@nedworks.org>
Subject: btrfs device delete not working after failed/missing device
Date: Mon, 21 Mar 2011 18:31:28 +0100
Message-ID: <566AF058-F016-4D40-8C6C-6B5DBA20F941@nedworks.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I decided to try btrfs for a few file systems on my not-too-critical home server, including my root fs. Most file systems are on a RAID5 MD software array, but my rootfs is btrfs "striped" as RAID1 over 3 partitions.

I got hit by the Intel Sandy Bridge SATA chipset bug, so eventually the 3rd SATA drive (/dev/sdc) failed with all kinds of bus errors. My btrfs rootfs stayed up and working, but "btrfs device delete /dev/sdc3 /" did not work, and gave a vague "Error removing device" (iirc). After rebooting with the drive on the bad SATA bus removed, the file system didn't come up, but passing a "-o degraded" fixed that. However, I was still not able to remove the missing device from the rootfs. Neither "btrfs device delete missing /" nor "btrfs device delete /dev/sdc3 /" succeeded. "btrfs fi balance /" succeeded without errors however.

I'll paste the relevant bits of dmesg below. My btrfs rootfs is now mountable and working in degraded mode, and I have a (daily rsynced) backup on another filesystem anyway. I decided to report it anyway, as it would be good to get things stable and this bug fixed. ;)

The running kernel is 2.6.38.4, and btrfs utils are version v0.19 (Ubuntu Maverick).

dmesg:

[  197.810007] device label root devid 1 transid 65058 /dev/sda3
[  197.811844] btrfs: failed to read the system array on sda3
[  197.876797] btrfs: open_ctree failed
[  207.743237] device label root devid 1 transid 65058 /dev/sda3
[  207.745460] btrfs: failed to read the system array on sda3
[  207.793912] btrfs: open_ctree failed
[  249.999918] device label backups devid 1 transid 7325 /dev/dm-4
[  250.002555] device label root devid 2 transid 65058 /dev/sdb3
[  250.003545] device label root devid 1 transid 65058 /dev/sda3
[  488.217867] device label root devid 1 transid 65058 /dev/sda3
[  488.218325] btrfs: allowing degraded mounts
[  509.983121] btrfs: relocating block group 12108955648 flags 17
[  513.096861] btrfs: found 695 extents
[  520.176191] btrfs: found 695 extents
[  520.888601] btrfs: relocating block group 11035213824 flags 17
[  537.663032] btrfs: found 4836 extents
[  550.237641] btrfs: found 4836 extents
[  551.527503] btrfs: relocating block group 9961472000 flags 17
[  556.314350] btrfs: found 1602 extents
[  564.737818] btrfs: found 1602 extents
[  565.358244] btrfs: relocating block group 9693036544 flags 20
[  586.400905] btrfs: found 5548 extents
[  586.773695] btrfs: relocating block group 8619294720 flags 17
[  593.677386] btrfs: found 3839 extents
[  599.059888] btrfs: found 3839 extents
[  600.155579] btrfs: relocating block group 7545552896 flags 17
[  612.330001] btrfs: found 3139 extents
[  621.223148] btrfs: found 3139 extents
[  622.054094] btrfs: relocating block group 6471811072 flags 17
[  634.848723] btrfs: found 5541 extents
[  649.045142] btrfs: found 5541 extents
[  649.685956] btrfs: relocating block group 5398069248 flags 17
[  663.123926] btrfs: found 12743 extents
[  683.670746] btrfs: found 12743 extents
[  684.595137] btrfs: relocating block group 4324327424 flags 17
[  717.828652] btrfs: found 13762 extents
[  740.723221] btrfs: found 13762 extents
[  742.037898] btrfs: relocating block group 29360128 flags 20
[  826.976047] btrfs: found 34862 extents
[  827.084723] btrfs: relocating block group 20971520 flags 18
[  827.126034] btrfs allocation failed flags 18, wanted 4096
[  827.127621] space_info has 0 free, is not full
[  827.127623] space_info total=12582912, used=4096, pinned=0, reserved=0, may_use=0, readonly=12578816
[  827.127626] block group 20971520 has 8388608 bytes, 4096 used 0 pinned 0 reserved
[  827.127629] entry offset 20971520, bytes 4096, bitmap no
[  827.129215] entry offset 20979712, bytes 8380416, bitmap no
[  827.130778] block group has cluster?: no
[  827.130780] 2 blocks of free space at or bigger than bytes is
[  827.130782] block group 0 has 4194304 bytes, 0 used 0 pinned 0 reserved
[  827.130784] entry offset 131072, bytes 4063232, bitmap no
[  827.132340] block group has cluster?: no
[  827.132342] 1 blocks of free space at or bigger than bytes is
[  827.174753] btrfs: relocating block group 20971520 flags 18
[  827.213303] btrfs allocation failed flags 18, wanted 4096
[  827.214347] space_info has 0 free, is not full
[  827.214348] space_info total=12582912, used=4096, pinned=0, reserved=0, may_use=0, readonly=12578816
[  827.214350] block group 20971520 has 8388608 bytes, 4096 used 0 pinned 0 reserved
[  827.214352] entry offset 20971520, bytes 4096, bitmap no
[  827.215367] entry offset 20979712, bytes 8380416, bitmap no
[  827.216261] block group has cluster?: no
[  827.216262] 2 blocks of free space at or bigger than bytes is
[  827.216263] block group 0 has 4194304 bytes, 0 used 0 pinned 0 reserved
[  827.216265] entry offset 131072, bytes 4063232, bitmap no
[  827.217144] block group has cluster?: no
[  827.217145] 1 blocks of free space at or bigger than bytes is

btrfs filesystem show:

Label: 'root'  uuid: 9ff80426-d625-4601-b5db-28be1b556551
	Total devices 3 FS bytes used 2.95GB
	devid    2 size 18.63GB used 5.01GB path /dev/sdb3
	devid    1 size 18.63GB used 5.00GB path /dev/sda3
	*** Some devices missing

Please let me know if I can help by testing any commands / patches or by providing additional details.

-- 
Mark