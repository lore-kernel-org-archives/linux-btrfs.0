From: Marc Schoechlin <linux-btrfs@vger.kernel.org>
Subject: BUG: Mount/Unmount Loop
Date: Thu, 26 Feb 2009 21:58:47 +0100
Message-ID: <20090226205847.GA9075@256bit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Developers,

it seems that i discovered a bug in btrfs while testing it on a zSeries
mainframe :-)

## Test environment:

- IBM System z900 Mainframe
- Debian SID with 64 Bit Kernel
- GIT Sources from
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
- System runs as z/VM guest
- 3 Virtual CPUs
- 1 GB RAM Storage

## Initial Test Setup

- Setup a Debian SID System with a 64bit Kernel
  (i.e. aptitude install linux-image-2.6.26-1-s390x)
- Restart System and build a kernel with btrfs support from the development sources
   cd /usr/src
   git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
   cd btrfs-unstable
   cp /boot/config-`uname -r`* .config
   make oldconfig
   make-kpkg clean
   make menuconfig # acticate filesystems/btrfs
   make-kpkg kernel_image --initrd --revision=marc.1
   dpkg -i ../*marc.1*.deb
   reboot
- Restart System

## Initial Test Setup

 * setup environment variables
   DEVICES="$(echo /dev/disk/by-path/ccw-0.0.{3320..3327})" # adapt for other platforms
   TESTMNT="/mnt"
   DEVNOS="$(echo {3320..3327})" # only needed on system z
 * Sysrq
   sysctl -w kernel.sysrq=1
   In case of a crash do:
   echo u >/proc/sysrq-trigger
   echo b >/proc/sysrq-trigger

 * z/VM test setup (only needed on system z)
   modprobe vmur
   chccwdev -e c
   vmcp "SPOOL C CLASS *"
   vmur purge

 * take disks online (only needed on system z)
   for i in $DEVNOS; do chccwdev -e $i; done
   for i in $DEVNOS; do lsdasd $i; done

 * format the disks (only needed on system z)
   for i in $DEVNOS; do
    dasdfmt --blocksize=4096 --disk_layout=cdl --label=0x$i -p --device /dev/disk/by-path/ccw-0.0.$i

## How to reproduce the problem

vmcp "sp cons start to *"
modprobe btrfs
for j in {1..10000};do
   mkfs.btrfs -m raid1 -d raid1 $DEVICES
   for i in $DEVICES;do
      set -x
      mount -t btrfs $i ${TESTMNT}
      umount ${TESTMNT}
      set +x
   done
done
modprobe -r btrfs
vmcp "sp cons stop close"

=> Crashes after a few minutes
=> System ist still usable

## Console Output:
----
WARNING! - Btrfs Btrfs v0.18 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/disk/by-path/ccw-0.0.3321 id 2
adding device /dev/disk/by-path/ccw-0.0.3322 id 3
adding device /dev/disk/by-path/ccw-0.0.3323 id 4
adding device /dev/disk/by-path/ccw-0.0.3324 id 5
adding device /dev/disk/by-path/ccw-0.0.3325 id 6
adding device /dev/disk/by-path/ccw-0.0.3326 id 7
adding device /dev/disk/by-path/ccw-0.0.3327 id 8
fs created label (null) on /dev/disk/by-path/ccw-0.0.3320
        nodesize 4096 leafsize 4096 sectorsize 4096 size 17.45GB
Btrfs Btrfs v0.18
+ mount -t btrfs /dev/disk/by-path/ccw-0.0.3320 /mnt

Message from syslogd@virtual-206 at Thu Feb 26 20:59:23 2009 ...
virtual-206 kernel: [  121.409129] ------------[ cut here ]------------
+ umount /mnt
Segmentation fault
+ set +x
+ mount -t btrfs /dev/disk/by-path/ccw-0.0.3321 /mnt
----

## DMESG Output:
----
[   32.240137] eth0: no IPv6 routers present
[  115.488507] Btrfs loaded
[  115.866519] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 1 transid 5 /dev/disk/by-path/ccw-0.0.3320
[  115.915710] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 2 transid 5 /dev/disk/by-path/ccw-0.0.3321
[  115.946999] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 3 transid 5 /dev/disk/by-path/ccw-0.0.3322
[  115.980178] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 4 transid 5 /dev/disk/by-path/ccw-0.0.3323
[  116.010257] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 5 transid 5 /dev/disk/by-path/ccw-0.0.3324
[  116.040025] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 6 transid 5 /dev/disk/by-path/ccw-0.0.3325
[  116.087553] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 7 transid 5 /dev/disk/by-path/ccw-0.0.3326
[  116.165206] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 8 transid 5 /dev/disk/by-path/ccw-0.0.3327
[  116.192679] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 1 transid 9 /dev/dasdc
[  116.837284] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 2 transid 13 /dev/dasdd
[  116.937046] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 3 transid 17 /dev/dasde
[  117.049434] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 4 transid 21 /dev/dasdf
[  117.160114] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 5 transid 25 /dev/dasdg
[  117.253106] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 6 transid 29 /dev/dasdh
[  117.406531] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 7 transid 33 /dev/dasdi
[  117.758589] device fsid 29b83b8d393a4dc1-8cb6f13d4c8056c9 devid 8 transid 37 /dev/dasdj
[  117.968097] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 1 transid 5 /dev/disk/by-path/ccw-0.0.3320
[  117.989932] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 2 transid 5 /dev/disk/by-path/ccw-0.0.3321
[  118.012034] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 3 transid 5 /dev/disk/by-path/ccw-0.0.3322
[  118.034295] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 4 transid 5 /dev/disk/by-path/ccw-0.0.3323
[  118.056272] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 5 transid 5 /dev/disk/by-path/ccw-0.0.3324
[  118.078121] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 6 transid 5 /dev/disk/by-path/ccw-0.0.3325
[  118.099741] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 7 transid 5 /dev/disk/by-path/ccw-0.0.3326
[  118.122498] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 8 transid 5 /dev/disk/by-path/ccw-0.0.3327
[  118.143336] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 1 transid 9 /dev/dasdc
[  118.994406] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 2 transid 13 /dev/dasdd
[  119.300427] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 3 transid 17 /dev/dasde
[  119.500473] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 4 transid 21 /dev/dasdf
[  119.663706] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 5 transid 25 /dev/dasdg
[  119.798536] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 6 transid 29 /dev/dasdh
[  120.027853] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 7 transid 33 /dev/dasdi
[  120.243321] device fsid 454e58b0e5104735-8ff7df6e6d6df02f devid 8 transid 37 /dev/dasdj
[  120.496215] device fsid dc29925c1c64a29-a7b79331712e87ee devid 1 transid 5 /dev/disk/by-path/ccw-0.0.3320
[  120.535382] device fsid dc29925c1c64a29-a7b79331712e87ee devid 2 transid 5 /dev/disk/by-path/ccw-0.0.3321
[  120.596624] device fsid dc29925c1c64a29-a7b79331712e87ee devid 3 transid 5 /dev/disk/by-path/ccw-0.0.3322
[  120.618358] device fsid dc29925c1c64a29-a7b79331712e87ee devid 4 transid 5 /dev/disk/by-path/ccw-0.0.3323
[  120.650429] device fsid dc29925c1c64a29-a7b79331712e87ee devid 5 transid 5 /dev/disk/by-path/ccw-0.0.3324
[  120.678140] device fsid dc29925c1c64a29-a7b79331712e87ee devid 6 transid 5 /dev/disk/by-path/ccw-0.0.3325
[  120.700876] device fsid dc29925c1c64a29-a7b79331712e87ee devid 7 transid 5 /dev/disk/by-path/ccw-0.0.3326
[  120.743745] device fsid dc29925c1c64a29-a7b79331712e87ee devid 8 transid 5 /dev/disk/by-path/ccw-0.0.3327
[  120.767434] device fsid dc29925c1c64a29-a7b79331712e87ee devid 1 transid 9 /dev/dasdc
[  121.339701] btrfs bad tree block start 0 29380608
[  121.401478] btrfs bad tree block start 0 29384704
[  121.406788] btrfs bad fsid on block 29384704
[  121.408995] btrfs bad tree block start 0 29384704
[  121.409129] ------------[ cut here ]------------
[  121.409158] Badness at fs/btrfs/disk-io.c:849
[  121.409188] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c dm_snapshot dm_mirror dm_region_hash dm_log dm_mod ocfs2 jbd2 ocfs2_nodemanager con+figfs ocfs2_stackglue quota_tree vmcp loop qeth_l3 vmur qeth ccwgroup ext3 jbd mbcache dasd_eckd_mod dasd_mod+
[  121.409691] CPU: 1 Not tainted 2.6.29-rc3 #1
[  121.409742] Process mount (pid: 2245, task: 000000001fb693c0, ksp: 0000000016e2b740)
[  121.409802] Krnl PSW : 0704100180000000 000003e00072306a (read_tree_block+0x6a/0x7c [btrfs])
[  121.410021]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
[  121.410092] Krnl GPRS: 00000000000001c3 0000000000000001 fffffffffffffffb 0000000017c0d0e0
[  121.410194]            000003e000723040 00000000002bc950 000000001efb7000 0000000000001000
[  121.415338]            000000001e507b2b 0000000000000009 000000001efb7000 0000000017c1f5b0
[  121.415360]            000003e000701000 000003e00075c2c8 000003e000723040 0000000016e2ba70
[  121.415429] Krnl Code: 000003e00072305e: a744fff9            brc     4,3e000723050
[  121.415460]            000003e000723062: a7f40004            brc     15,3e00072306a
[  121.415487]            000003e000723066: a7f40001            brc     15,3e000723068
[  121.415518]           >000003e00072306a: e340f0c80004        lg      %r4,200(%r15)
[  121.415544]            000003e000723070: b904002b            lgr     %r2,%r11
[  121.415574]            000003e000723074: eb9ff0a00004        lmg     %r9,%r15,160(%r15)
[  121.415600]            000003e00072307a: 07f4                bcr     15,%r4
[  121.415630]            000003e00072307c: eb6ff0480024        stmg    %r6,%r15,72(%r15)
[  121.415651] Call Trace:
[  121.415661] ([<000003e000723040>] read_tree_block+0x40/0x7c [btrfs])
[  121.415763]  [<000003e000723868>] find_and_setup_root+0xa8/0xd0 [btrfs]
[  121.415856]  [<000003e000726172>] open_ctree+0xb86/0xfe0 [btrfs]
[  121.421161]  [<000003e000704734>] btrfs_get_sb+0x2bc/0x508 [btrfs]
[  121.421258]  [<00000000000d2c92>] vfs_kern_mount+0xb2/0x168
[  121.421289]  [<00000000000d2dae>] do_kern_mount+0x52/0x108
[  121.421309]  [<00000000000edcf8>] do_mount+0x7d8/0x824
[  121.421331]  [<0000000000110d38>] compat_sys_mount+0x280/0x2d8
[  121.421356]  [<00000000000266e2>] sysc_noemu+0x10/0x16
[  121.421379]  [<0000000077f23a5a>] 0x77f23a5a
[  121.421404] Last Breaking-Event-Address:
[  121.421415]  [<0000000000000000>] 0x0
[  121.435245] btrfs bad fsid on block 29376512
[  121.449967] Unable to handle kernel pointer dereference at virtual kernel address (null)
[  121.450001] Oops: 0004 [#1] SMP
[  121.450032] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c dm_snapshot dm_mirror dm_region_hash dm_log dm_mod ocfs2 jbd2 ocfs2_nodemanager con+figfs ocfs2_stackglue quota_tree vmcp loop qeth_l3 vmur qeth ccwgroup ext3 jbd mbcache dasd_eckd_mod dasd_mod
[  121.450431] CPU: 2 Tainted: G        W  2.6.29-rc3 #1
[  121.450475] Process umount (pid: 2273, task: 0000000016f6a6c0, ksp: 0000000016e33a70)
[  121.450527] Krnl PSW : 0704200180000000 00000000002af5b6 (down_read+0xe/0x28)
[  121.450617]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
[  121.450680] Krnl GPRS: 0000000000000003 0000000000000000 0000000000000060 0000000000000001
[  121.450768]            0000000017705da8 0000000000000000 0000000000000000 0000000017c13370
[  121.450840]            0000000000000000 0000000000000000 0000000000010000 0000000000000000
[  121.450983]            000003e000701000 000003e00075be40 000003e000715ec6 0000000016e33798
[  121.451044] Krnl Code: 00000000002af5a8: e31020000004        lg      %r1,0(%r2)
[  121.451068]            00000000002af5ae: b9040031            lgr     %r3,%r1
[  121.451093]            00000000002af5b2: a73b0001            aghi    %r3,1
[  121.451124]           >00000000002af5b6: eb1320000030        csg     %r1,%r3,0(%r2)
[  121.451150]            00000000002af5bc: a744fff9            brc     4,2af5ae
[  121.451175]            00000000002af5c0: b9020011            ltgr    %r1,%r1
[  121.451199]            00000000002af5c4: a7a40005            brc     10,2af5ce
[  121.451226]            00000000002af5c8: c0f400000790        brcl    15,2b04e8
[  121.451245] Call Trace:
[  121.451255] ([<000003e000715e3e>] find_free_extent+0x236/0x784 [btrfs])
[  121.451396]  [<000003e0007164f0>] __btrfs_reserve_extent+0x164/0x314 [btrfs]
[  121.451489]  [<000003e0007184e2>] btrfs_alloc_extent+0x4e/0xc8 [btrfs]
[  121.451583]  [<000003e0007185c8>] btrfs_alloc_free_block+0x6c/0xb0 [btrfs]
[  121.451676]  [<000003e00070841a>] __btrfs_cow_block+0x242/0xa08 [btrfs]
[  121.451766]  [<000003e0007093e4>] btrfs_cow_block+0x220/0x234 [btrfs]
[  121.451857]  [<000003e00072761a>] btrfs_commit_tree_roots+0x6e/0x21c [btrfs]
[  121.452077]  [<000003e000728c56>] btrfs_commit_transaction+0x33a/0x7ac [btrfs]
[  121.452175]  [<000003e000704bec>] btrfs_sync_fs+0x88/0xa0 [btrfs]
[  121.452264]  [<0000000000121d88>] quota_sync_sb+0x50/0x118
[  121.452287]  [<00000000000d23e8>] __fsync_super+0x30/0xfc
[  121.452309]  [<00000000000d24d2>] fsync_super+0x1e/0x30
[  121.452330]  [<00000000000d28c6>] generic_shutdown_super+0x3e/0x1a4
[  121.452352]  [<00000000000d2a96>] kill_anon_super+0x1e/0x60
[  121.452373]  [<00000000000d2bb6>] deactivate_super+0x9a/0xc4
[  121.452394]  [<00000000000ec3a0>] SyS_umount+0x35c/0x38c
[  121.452415]  [<00000000000266e2>] sysc_noemu+0x10/0x16
[  121.452438]  [<0000000077f403ea>] 0x77f403ea
[  121.452459] Last Breaking-Event-Address:
[  121.452470]  [<0000000000000000>] 0x0
[  121.452486]  <4>---[ end trace f340bd908bfc75e9 ]---
[  121.487837] device fsid dc29925c1c64a29-a7b79331712e87ee devid 2 transid 9 /dev/dasdd

