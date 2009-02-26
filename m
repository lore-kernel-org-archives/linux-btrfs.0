From: Marc Schoechlin <linux-btrfs@vger.kernel.org>
Subject: BUG: Bonnie++ stresstest with parallel balanceing chunks across all devices
Date: Thu, 26 Feb 2009 21:36:08 +0100
Message-ID: <20090226203608.GB4024@256bit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Developers,

it seems that i discovered another bug in btrfs while testing it on a zSeries
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
mkfs.btrfs -m raid10 -d raid10 /dev/disk/by-path/ccw-0.0.{3320..3327}
sleep 1
mount -t btrfs /dev/disk/by-path/ccw-0.0.3321 ${TESTMNT}
sleep 5
mkdir -p ${TESTMNT}/{1..5}
for i in {1..5};do
 bonnie++ -x 10 -u root -d ${TESTMNT}/$i &>${TESTMNT}/$i.log &
done
for i in {1..2000}; do
   btrfs-vol -b ${TESTMNT}
   btrfs-show
done

killall -KILL bonnie++
umount ${TESTMNT}

vmcp "sp cons stop close"

=> Crashes after a few minutes
=> System ist still usable

## Console Output:
----
ioctl returns 0                                                                                                                     
Label: none  uuid: bc58bd1b-eec1-468b-9049-04da702d5f92                                                                             
        Total devices 8 FS bytes used 350.37MB                                                                                      
        devid    7 size 2.29GB used 1.09GB path /dev/dasdinfo0000
        devid    5 size 1.40GB used 897.00MB path /dev/dasdinfo0001
        devid    4 size 2.29GB used 1.09GB path /dev/dasdinfo0002
        devid    6 size 2.29GB used 1.09GB path /dev/dasdinfo0003
        devid    2 size 2.29GB used 1.09GB path /dev/dasdinfo0006
        devid    1 size 2.29GB used 1.11GB path /dev/dasdinfo0007
        devid    3 size 2.29GB used 1.09GB path /dev/dasdinfo0008
        devid    8 size 2.29GB used 897.00MB path /dev/dasdinfo0009

Btrfs Btrfs v0.18
ioctl returns 0
Label: none  uuid: bc58bd1b-eec1-468b-9049-04da702d5f92
        Total devices 8 FS bytes used 770.31MB
        devid    7 size 2.29GB used 1.53GB path /dev/dasdinfo0000
        devid    5 size 1.40GB used 1.09GB path /dev/dasdinfo0001
        devid    4 size 2.29GB used 1.53GB path /dev/dasdinfo0002
        devid    6 size 2.29GB used 1.53GB path /dev/dasdinfo0003
        devid    2 size 2.29GB used 1.53GB path /dev/dasdinfo0006
        devid    1 size 2.29GB used 1.53GB path /dev/dasdinfo0007
        devid    3 size 2.29GB used 1.53GB path /dev/dasdinfo0008
        devid    8 size 2.29GB used 1.09GB path /dev/dasdinfo0009

Btrfs Btrfs v0.18
ioctl returns 0
Label: none  uuid: bc58bd1b-eec1-468b-9049-04da702d5f92
        Total devices 8 FS bytes used 1.82GB
        devid    7 size 2.29GB used 1.53GB path /dev/dasdinfo0000
        devid    5 size 1.40GB used 899.00MB path /dev/dasdinfo0001
        devid    4 size 2.29GB used 1.53GB path /dev/dasdinfo0002
        devid    6 size 2.29GB used 1.53GB path /dev/dasdinfo0003
        devid    2 size 2.29GB used 1.53GB path /dev/dasdinfo0006
        devid    1 size 2.29GB used 1.54GB path /dev/dasdinfo0007
        devid    3 size 2.29GB used 1.53GB path /dev/dasdinfo0008
        devid    8 size 2.29GB used 899.00MB path /dev/dasdinfo0009

Btrfs Btrfs v0.18

Message from syslogd@virtual-206 at Thu Feb 26 21:25:52 2009 ...
virtual-206 kernel: [  359.660226] ------------[ cut here ]------------

Message from syslogd@virtual-206 at Thu Feb 26 21:25:56 2009 ...
virtual-206 kernel: [  363.469831] ------------[ cut here ]------------

----

## DMESG Output:
----


[   53.069782] Btrfs loaded                                                                                                                                           
[   53.213829] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 1 transid 5 /dev/disk/by-path/ccw-0.0.3320                                                         
[   53.260832] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 2 transid 5 /dev/disk/by-path/ccw-0.0.3321                                                         
[   53.296270] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 3 transid 5 /dev/disk/by-path/ccw-0.0.3322                                                         
[   53.334252] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 4 transid 5 /dev/disk/by-path/ccw-0.0.3323                                                         
[   53.391716] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 5 transid 5 /dev/disk/by-path/ccw-0.0.3324                                                         
[   53.424834] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 6 transid 5 /dev/disk/by-path/ccw-0.0.3325                                                         
[   53.457949] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 7 transid 5 /dev/disk/by-path/ccw-0.0.3326                                                         
[   53.498292] device fsid 32bbc958ce94417a-b4a274f96684ba51 devid 8 transid 5 /dev/disk/by-path/ccw-0.0.3327                                                         
[   82.871301] device fsid bc58bd1beec1468b-904904da702d5f92 devid 1 transid 5 /dev/disk/by-path/ccw-0.0.3320                                                         
[   82.903317] device fsid bc58bd1beec1468b-904904da702d5f92 devid 2 transid 5 /dev/disk/by-path/ccw-0.0.3321                                                         
[   82.940807] device fsid bc58bd1beec1468b-904904da702d5f92 devid 3 transid 5 /dev/disk/by-path/ccw-0.0.3322                                                         
[   82.973923] device fsid bc58bd1beec1468b-904904da702d5f92 devid 4 transid 5 /dev/disk/by-path/ccw-0.0.3323                                                         
[   82.995348] device fsid bc58bd1beec1468b-904904da702d5f92 devid 5 transid 5 /dev/disk/by-path/ccw-0.0.3324                                                         
[   83.017108] device fsid bc58bd1beec1468b-904904da702d5f92 devid 6 transid 5 /dev/disk/by-path/ccw-0.0.3325                                                         
[   83.043754] device fsid bc58bd1beec1468b-904904da702d5f92 devid 7 transid 5 /dev/disk/by-path/ccw-0.0.3326                                                         
[   83.086491] device fsid bc58bd1beec1468b-904904da702d5f92 devid 8 transid 5 /dev/disk/by-path/ccw-0.0.3327                                                         
[   84.120060] device fsid bc58bd1beec1468b-904904da702d5f92 devid 2 transid 9 /dev/dasdd                                                                             
[  118.619900] btrfs relocating chunk 965738496                                                                                                                       
[  118.619937] btrfs relocating block group 965738496 flags 65                                                                                                        
[  139.000278] btrfs found 43 extents in pass 0                                                                                                                       
[  139.416544] btrfs found 43 extents in pass 1                                                                                                                       
[  139.659585] btrfs found 43 extents in pass 2                                                                                                                       
[  140.245022] btrfs found 11 extents in pass 3                                                                                                                       
[  140.544328] btrfs found 1 extents in pass 4                                                                                                                        
[  141.588530] btrfs found 1 extents in pass 5                                                                                                                        
[  141.720213] btrfs found 1 extents in pass 6                                                                                                                        
[  142.017749] btrfs relocating chunk 29360128                                                                                                                        
[  142.017776] btrfs relocating block group 29360128 flags 68                                                                                                         
[  143.741564] btrfs found 102 extents in pass 0                                                                                                                      
[  143.934231] btrfs relocating chunk 20971520                                                                                                                        
[  143.934264] btrfs relocating block group 20971520 flags 66                                                                                                         
[  144.400321] btrfs found 1 extents in pass 0                                                                                                                        
[  144.763732] btrfs relocating chunk 12582912                                                                                                                        
[  144.763761] btrfs relocating block group 12582912 flags 1                                                                                                          
[  145.343867] btrfs relocating chunk 4194304                                                                                                                         
[  145.343908] btrfs relocating block group 4194304 flags 4                                                                                                           
[  146.322339] btrfs relocating chunk 6358302720                                                                                                                      
[  146.322370] btrfs relocating block group 6358302720 flags 66                                                                                                       
[  147.272337] btrfs relocating chunk 6349914112                                                                                                                      
[  147.272366] btrfs relocating block group 6349914112 flags 66                                                                                                       
[  147.500374] btrfs found 1 extents in pass 0                                                                                                                        
[  147.758909] btrfs relocating chunk 5647630336                                                                                                                      
[  147.758938] btrfs relocating block group 5647630336 flags 68                                                                                                       
[  148.210632] btrfs relocating chunk 4711251968                                                                                                                      
[  148.210660] btrfs relocating block group 4711251968 flags 68                                                                                                       
[  148.687160] btrfs found 126 extents in pass 0                                                                                                                      
[  149.021782] btrfs relocating chunk 3774873600                                                                                                                      
[  149.021810] btrfs relocating block group 3774873600 flags 65                                                                                                       
[  149.781615] btrfs relocating chunk 2838495232
[  149.781645] btrfs relocating block group 2838495232 flags 65
[  150.540691] btrfs relocating chunk 1902116864
[  150.540720] btrfs relocating block group 1902116864 flags 65
[  206.451286] btrfs found 396 extents in pass 0
[  207.953457] btrfs found 396 extents in pass 1
[  208.549774] btrfs found 98 extents in pass 2
[  208.907137] btrfs found 8 extents in pass 3
[  209.588814] btrfs found 8 extents in pass 4
[  209.773634] btrfs found 6 extents in pass 5
[  210.564362] btrfs relocating chunk 10822877184
[  210.564396] btrfs relocating block group 10822877184 flags 65
[  212.243715] btrfs relocating chunk 9886498816
[  212.243743] btrfs relocating block group 9886498816 flags 65
[  212.995054] btrfs relocating chunk 8950120448
[  212.995082] btrfs relocating block group 8950120448 flags 65
[  213.438304] btrfs relocating chunk 8013742080
[  213.438332] btrfs relocating block group 8013742080 flags 65
[  314.303946] ioctl32(btrfsctl:1845): Unknown cmd fd(3) cmd(50009401){t:94;sz:4096} arg(7fb999b8) on /home/mschoechlin
[  341.213654] btrfs found 1082 extents in pass 0
[  344.069185] btrfs found 1082 extents in pass 1
[  347.430837] btrfs found 98 extents in pass 2
[  348.116550] btrfs found 31 extents in pass 3
[  348.455565] btrfs found 16 extents in pass 4
[  348.603883] btrfs found 16 extents in pass 5
[  348.777141] btrfs found 4 extents in pass 6
[  349.844488] btrfs relocating chunk 7311458304
[  349.844517] btrfs relocating block group 7311458304 flags 68
[  351.621378] btrfs relocating chunk 6375079936
[  351.621407] btrfs relocating block group 6375079936 flags 68
[  354.068177] btrfs found 667 extents in pass 0
[  354.855161] btrfs relocating chunk 6366691328
[  354.855188] btrfs relocating block group 6366691328 flags 66
[  356.699006] btrfs relocating chunk 6358302720
[  356.699036] btrfs relocating block group 6358302720 flags 66
[  357.133819] btrfs found 1 extents in pass 0
[  357.689341] btrfs relocating chunk 15747252224
[  357.689372] btrfs relocating block group 15747252224 flags 66
[  358.786261] btrfs relocating chunk 15738863616
[  358.786290] btrfs relocating block group 15738863616 flags 66
[  359.415243] btrfs found 1 extents in pass 0
[  359.653452] btrfs relocating chunk 14802485248
[  359.653480] btrfs relocating block group 14802485248 flags 68
[  359.658755] btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 1
[  359.658789] btrfs allocation failed flags 68, wanted 4096
[  359.659966] space_info has 932491264 free, is full
[  359.660007] block group 14802485248 has 936378368 bytes, 3522560 used 364544 pinned 0 reserved
[  359.660076] 87 blocks of free space at or bigger than bytes is
[  359.660226] ------------[ cut here ]------------
[  359.660273] kernel BUG at fs/btrfs/extent-tree.c:3190!
[  359.660329] illegal operation: 0001 [#1] SMP
[  359.660403] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c dm_snapshot dm_mirror dm_region_hash dm_log dm_mod ocfs2 jbd2 ocfs2_nodemanager con+figfs ocfs2_stackglue quota_tree vmcp loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dasd_eckd_mod dasd_mod+
[  359.661261] CPU: 0 Not tainted 2.6.29-rc3 #1
[  359.661331] Process bonnie++ (pid: 1823, task: 000000001eb16140, ksp: 0000000018f1b538)
[  359.666651] Krnl PSW : 0704000180000000 000003e000716688 (__btrfs_reserve_extent+0x2fc/0x314 [btrfs])
[  359.666829]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[  359.666852] Krnl GPRS: 000000000116d318 0000000000000000 000000001f0364e0 0000000000000001
[  359.666875]            00000000002ad696 000000000000478f 0000000000059000 000000001f0364c8
[  359.666896]            0000000000001000 000000001f0364e0 000000001915682c 000000001f036410
[  359.666918]            000000001f2b4c88 000003e00075be58 000003e000716684 0000000018f1b710
[  359.666987] Krnl Code: 000003e00071667a: b9040029            lgr     %r2,%r9
[  359.667014]            000003e00071667e: c0e5ffff5cf9        brasl   %r14,3e000702070
[  359.667041]            000003e000716684: a7f40001            brc     15,3e000716686
[  359.667067]           >000003e000716688: a7f40000            brc     15,3e000716688
[  359.667097]            000003e00071668c: e340f1200004        lg      %r4,288(%r15)
[  359.667123]            000003e000716692: a7290000            lghi    %r2,0
[  359.667153]            000003e000716696: eb6ff0e00004        lmg     %r6,%r15,224(%r15)
[  359.667178]            000003e00071669c: 07f4                bcr     15,%r4
[  359.667197] Call Trace:
[  359.667207] ([<000003e000716658>] __btrfs_reserve_extent+0x2cc/0x314 [btrfs])
[  359.667298]  [<000003e0007184e2>] btrfs_alloc_extent+0x4e/0xc8 [btrfs]
[  359.667389]  [<000003e0007185c8>] btrfs_alloc_free_block+0x6c/0xb0 [btrfs]
[  359.667483]  [<000003e00070841a>] __btrfs_cow_block+0x242/0xa08 [btrfs]
[  359.667576]  [<000003e0007093e4>] btrfs_cow_block+0x220/0x234 [btrfs]
[  359.667669]  [<000003e00070e8ce>] btrfs_search_slot+0x3ce/0xadc [btrfs]
[  359.667777]  [<000003e000721a38>] btrfs_lookup_inode+0x48/0xe4 [btrfs]
[  359.667875]  [<000003e00072ccf8>] btrfs_update_inode+0x54/0xf4 [btrfs]
[  359.667978]  [<000003e000730034>] btrfs_dirty_inode+0x4c/0x60 [btrfs]
[  359.668080]  [<00000000000f289a>] __mark_inode_dirty+0x46/0x1cc
[  359.668112]  [<00000000000e6336>] file_update_time+0xd6/0x120
[  359.668138]  [<000003e000732d96>] btrfs_file_write+0x1a2/0x750 [btrfs]
[  359.668301]  [<00000000000d0774>] vfs_write+0xa0/0x178
[  359.668327]  [<00000000000d093a>] SyS_write+0x52/0x80
[  359.668348]  [<00000000000266e2>] sysc_noemu+0x10/0x16
[  359.668374]  [<0000000077d8660a>] 0x77d8660a
[  359.668398] Last Breaking-Event-Address:
[  359.668410]  [<0000000000000000>] 0x0
[  359.668428]  <4>---[ end trace cff1a51b3218779a ]---
[  363.469543] btrfs searching for 4096 bytes, num_bytes 4096, loop 2, allowed_alloc 0
[  363.469579] btrfs allocation failed flags 68, wanted 4096
[  363.469604] space_info has 932491264 free, is full
[  363.469635] block group 14802485248 has 936378368 bytes, 3522560 used 364544 pinned 0 reserved
[  363.469705] 87 blocks of free space at or bigger than bytes is
[  363.469831] ------------[ cut here ]------------
[  363.469870] kernel BUG at fs/btrfs/extent-tree.c:3190!
[  363.469925] illegal operation: 0001 [#2] SMP
[  363.469987] Modules linked in: btrfs zlib_deflate zlib_inflate crc32c libcrc32c dm_snapshot dm_mirror dm_region_hash dm_log dm_mod ocfs2 jbd2 ocfs2_nodemanager con+figfs ocfs2_stackglue quota_tree vmcp loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dasd_eckd_mod dasd_mod
[  363.470703] CPU: 1 Tainted: G      D    2.6.29-rc3 #1
[  363.470768] Process btrfs-cleaner (pid: 1815, task: 000000001fb8ae40, ksp: 0000000018febd10)
[  363.470842] Krnl PSW : 0704000180000000 000003e000716688 (__btrfs_reserve_extent+0x2fc/0x314 [btrfs])
[  363.471259]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[  363.471281] Krnl GPRS: 000000000116d318 0000000000000000 000000001f0364e0 0000000000000001
[  363.471304]            00000000002ad696 0000000000005529 0000000000059000 000000001f0364c8
[  363.471325]            0000000000001000 000000001f0364e0 000000001915682c 000000001f036410
[  363.471347]            000003e000701000 000003e00075be58 000003e000716684 0000000018feb570
[  363.471414] Krnl Code: 000003e00071667a: b9040029            lgr     %r2,%r9
[  363.471443]            000003e00071667e: c0e5ffff5cf9        brasl   %r14,3e000702070
[  363.471471]            000003e000716684: a7f40001            brc     15,3e000716686
[  363.471498]           >000003e000716688: a7f40000            brc     15,3e000716688
[  363.471530]            000003e00071668c: e340f1200004        lg      %r4,288(%r15)
[  363.471557]            000003e000716692: a7290000            lghi    %r2,0
[  363.471589]            000003e000716696: eb6ff0e00004        lmg     %r6,%r15,224(%r15)
[  363.471615]            000003e00071669c: 07f4                bcr     15,%r4
[  363.471635] Call Trace:
[  363.471646] ([<000003e000716658>] __btrfs_reserve_extent+0x2cc/0x314 [btrfs])
[  363.471741]  [<000003e0007184e2>] btrfs_alloc_extent+0x4e/0xc8 [btrfs]
[  363.471841]  [<000003e0007185c8>] btrfs_alloc_free_block+0x6c/0xb0 [btrfs]
[  363.471933]  [<000003e00070841a>] __btrfs_cow_block+0x242/0xa08 [btrfs]
[  363.472022]  [<000003e0007093e4>] btrfs_cow_block+0x220/0x234 [btrfs]
[  363.472113]  [<000003e00070e8ce>] btrfs_search_slot+0x3ce/0xadc [btrfs]
[  363.472250]  [<000003e00071159c>] lookup_extent_backref+0x50/0x104 [btrfs]
[  363.472355]  [<000003e0007195e2>] __btrfs_free_extent+0x33a/0x868 [btrfs]
[  363.472448]  [<000003e000719bf4>] cache_drop_leaf_ref+0xe4/0x178 [btrfs]
[  363.472663]  [<000003e00071a51c>] drop_level_one_refs+0x4a0/0x4ac [btrfs]
[  363.472758]  [<000003e00071a6e2>] walk_down_tree+0x1ba/0x69c [btrfs]
[  363.472850]  [<000003e00071d62c>] btrfs_drop_snapshot+0x220/0x314 [btrfs]
[  363.472943]  [<000003e0007285f0>] drop_dirty_roots+0xbc/0x31c [btrfs]
[  363.473039]  [<000003e000728904>] btrfs_clean_old_snapshots+0xb4/0xcc [btrfs]
[  363.473136]  [<000003e000723b74>] cleaner_kthread+0xd8/0x140 [btrfs]
[  363.473239]  [<000000000005fa0e>] kthread+0x62/0x98
[  363.473267]  [<000000000001c55e>] kernel_thread_starter+0x6/0xc
[  363.473292]  [<000000000001c558>] kernel_thread_starter+0x0/0xc
[  363.473327]  [<0000000000000000>] 0x0
[  363.473349]  <4>---[ end trace cff1a51b3218779b ]---

