From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: panic after remove of device during rebalance
Date: Wed, 03 Feb 2010 15:33:51 +0100
Message-ID: <20100203143351.34560@gmx.net>
References: <20100202112058.193030@gmx.net> <20100202144714.193050@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100202144714.193050@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Another reboot - another try - only this time I ran "btrfsctl -a" first.
Now the first process to stay in uninterruptable sleep was the umount after theses tests.


modprobe btrfs

./btrfsctl -a
Scanning for Btrfs filesystems

./btrfs-show
Label: none  uuid: ca5e7037-a65c-45d8-b954-f64ab0799964
        Total devices 2 FS bytes used 6.01GB
        devid    5 size 623.25GB used 7.32GB path /dev/md15
        devid    1 size 9.31GB used 7.32GB path /dev/md11

./btrfsck /dev/md11
fs tree 256 refs 1 not found
        unresolved ref root 257 dir 256 index 8 namelen 8 name subvol00 error 600
found 6449324032 bytes used err is 1
total csum bytes: 6291456
total tree bytes: 6873088
total fs tree bytes: 36864
btree space waste bytes: 159776
file data blocks allocated: 10737418240
 referenced 10737418240

ls -la /mnt/btrfs-tests/
insgesamt 6291468
dr-xr-xr-x 1 root  root         240  2. Feb 09:46 .
drwxr-xr-x 9 root  root        4096  3. Feb 15:07 ..
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 17:53 large-file-test-000
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 18:05 large-file-test-001
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 18:12 large-file-test-002
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 18:17 large-file-test-003
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 18:24 large-file-test-004
-rwxrwxr-x 1 samba samba 1073741824 31. Jan 18:13 large-file-test-100
drwxrwxr-x 1 samba samba        168  1. Feb 16:52 snap00

./btrfs-vol -b /mnt/btrfs-tests/
Speicherzugriffsfehler

Feb  3 15:04:04 server kernel: [  402.415500] Btrfs loaded
Feb  3 15:04:11 server kernel: [  410.152115] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md11
Feb  3 15:04:11 server kernel: [  410.154554] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md15
Feb  3 15:04:11 server kernel: [  410.157135] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md/11
Feb  3 15:04:11 server kernel: [  410.160300] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md/15
Feb  3 15:05:37 server kernel: [  495.302414] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md11
Feb  3 15:05:37 server kernel: [  495.304530] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md15
Feb  3 15:05:37 server kernel: [  495.306343] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md/11
Feb  3 15:05:37 server kernel: [  495.309194] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md/15
Feb  3 15:06:08 server kernel: [  526.808238] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md11
Feb  3 15:06:08 server kernel: [  526.811494] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md15
Feb  3 15:06:08 server kernel: [  526.832216] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md/11
Feb  3 15:06:08 server kernel: [  526.837340] device fsid d8455ca637705eca-649979b04af654b9 devid 5 transid 681 /dev/md/15
Feb  3 15:07:36 server kernel: [  614.725114] device fsid d8455ca637705eca-649979b04af654b9 devid 1 transid 681 /dev/md11
Feb  3 15:07:36 server kernel: [  614.757610] btrfs: unlinked 1 orphans
Feb  3 15:07:36 server kernel: [  614.757610] btrfs: unlinked 1 orphans
Feb  3 15:14:26 server kernel: [ 1024.486214] btrfs: relocating block group 73774923776 flags 17
Feb  3 15:14:27 server kernel: [ 1026.148298] btrfs allocation failed flags 17, wanted 4096
Feb  3 15:14:27 server kernel: [ 1026.148302] space_info has 260046848 free, is full
Feb  3 15:14:27 server kernel: [ 1026.148306] space_info total=6774456320, pinned=0, delalloc=81199104, may_use=0, used=6442450944, root=0, super=65536, reserved=71892992
Feb  3 15:14:27 server kernel: [ 1026.148309] block group 61291364352 has 1073741824 bytes, 1058013184 used 0 pinned 15663104 reserved
Feb  3 15:14:27 server kernel: [ 1026.148311] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148312] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148315] block group 62365106176 has 1073741824 bytes, 1069547520 used 0 pinned 4194304 reserved
Feb  3 15:14:27 server kernel: [ 1026.148317] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148318] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148320] block group 69139562496 has 1073741824 bytes, 1063256064 used 0 pinned 10485760 reserved
Feb  3 15:14:27 server kernel: [ 1026.148321] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148323] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148325] block group 70213304320 has 1073741824 bytes, 1062207488 used 0 pinned 11534336 reserved
Feb  3 15:14:27 server kernel: [ 1026.148326] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148327] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148330] block group 71287046144 has 332005376 bytes, 312475648 used 0 pinned 19529728 reserved
Feb  3 15:14:27 server kernel: [ 1026.148331] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148332] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148334] block group 72701181952 has 1073741824 bytes, 1063256064 used 0 pinned 10485760 reserved
Feb  3 15:14:27 server kernel: [ 1026.148336] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148337] 0 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148339] block group 73774923776 has 1073741824 bytes, 813694976 used 0 pinned 0 reserved
Feb  3 15:14:27 server kernel: [ 1026.148341] entry offset 74588618752, bytes 260046848, bitmap no
Feb  3 15:14:27 server kernel: [ 1026.148343] block group has cluster?: no
Feb  3 15:14:27 server kernel: [ 1026.148344] 1 blocks of free space at or bigger than bytes is
Feb  3 15:14:27 server kernel: [ 1026.148371] ------------[ cut here ]------------
Feb  3 15:14:27 server kernel: [ 1026.148464] kernel BUG at fs/btrfs/inode.c:788!
Feb  3 15:14:27 server kernel: [ 1026.148505] invalid opcode: 0000 [#1] SMP
Feb  3 15:14:27 server kernel: [ 1026.148505] last sysfs file: /sys/block/md5/size
Feb  3 15:14:27 server kernel: [ 1026.148505] Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 cpufreq_powersave cpufreq_ondemand cpufreq_stats ipt_REJECT ipt_MASQUERADE xt_TCPMSS xt_
Feb  3 15:14:27 server kernel: [ 1026.148505]
Feb  3 15:14:27 server kernel: [ 1026.148505] Pid: 5669, comm: btrfs-vol Not tainted (2.6.32 #1) System Product Name
Feb  3 15:14:27 server kernel: [ 1026.148505] EIP: 0060:[<fed21948>] EFLAGS: 00010286 CPU: 1
Feb  3 15:14:27 server kernel: [ 1026.148505] EIP is at cow_file_range+0x5f8/0x610 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505] EAX: ffffffe4 EBX: ffffffff ECX: 00007e7e EDX: 00000001
Feb  3 15:14:27 server kernel: [ 1026.148505] ESI: 0000000e EDI: 00001000 EBP: 00000000 ESP: e4cb38e4
Feb  3 15:14:27 server kernel: [ 1026.148505]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb  3 15:14:27 server kernel: [ 1026.148505] Process btrfs-vol (pid: 5669, ti=e4cb2000 task=f70f8070 task.ti=e4cb2000)
Feb  3 15:14:27 server kernel: [ 1026.148505] Stack:
Feb  3 15:14:27 server kernel: [ 1026.148505]  00970000 00000000 00001000 00000000 00000000 00000000 58c10000 0000000e
Feb  3 15:14:27 server kernel: [ 1026.148505] <0> ffffffff ffffffff e4cb3957 00000001 00000000 e244d050 c278cd60 e244d16c
Feb  3 15:14:27 server kernel: [ 1026.148505] <0> 00001000 e244d054 e9274800 e24a5724 00970000 00000000 00001000 00000000
Feb  3 15:14:27 server kernel: [ 1026.148505] Call Trace:
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed22696>] ? run_delalloc_range+0x3d6/0x440 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed40cb8>] ? __extent_writepage+0x938/0xae0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c113ee3e>] ? generic_make_request+0x32e/0x4b0
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c115234f>] ? radix_tree_gang_lookup_tag_slot+0x9f/0xd0
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c1094b3b>] ? find_get_pages_tag+0x3b/0x130
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed3cad0>] ? extent_write_cache_pages+0x170/0x270 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed3cc28>] ? extent_writepages+0x58/0x80 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed40380>] ? __extent_writepage+0x0/0xae0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed3a510>] ? flush_write_bio+0x0/0x10 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed1fa00>] ? btrfs_get_extent+0x0/0xbc0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed1f88c>] ? btrfs_writepages+0x1c/0x30 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed1f870>] ? btrfs_writepages+0x0/0x30 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c109bdfa>] ? do_writepages+0x1a/0x40
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10e20de>] ? writeback_single_inode+0xbe/0x310
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10e2e40>] ? writeback_inodes_wb+0x380/0x530
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c109c583>] ? balance_dirty_pages_ratelimited_nr+0x223/0x330
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed3d4b4>] ? clear_extent_bit+0xe4/0x520 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed5db80>] ? relocate_file_extent_cluster+0x480/0x540 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed5e112>] ? relocate_block_group+0x3e2/0x4c0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed1b1ca>] ? btrfs_clean_old_snapshots+0x5a/0xe0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed5e5ec>] ? btrfs_relocate_block_group+0x1cc/0x370 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed450b9>] ? btrfs_relocate_chunk+0x89/0x5f0 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<f8258d88>] ? ahci_qc_prep+0xc8/0x180 [ahci]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed39bfb>] ? map_private_extent_buffer+0x8b/0x130 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed45e3d>] ? btrfs_balance+0x2ad/0x310 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed4b022>] ? btrfs_ioctl+0x392/0xa80 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c1095824>] ? filemap_fault+0x74/0x390
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10ac541>] ? __do_fault+0x361/0x450
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<fed4ac90>] ? btrfs_ioctl+0x0/0xa80 [btrfs]
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10d36db>] ? vfs_ioctl+0x2b/0x90
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10d3beb>] ? do_vfs_ioctl+0x3cb/0x600
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c101ee52>] ? do_page_fault+0x122/0x300
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c10d3e86>] ? sys_ioctl+0x66/0x70
Feb  3 15:14:27 server kernel: [ 1026.148505]  [<c1002db5>] ? syscall_call+0x7/0xb
Feb  3 15:14:27 server kernel: [ 1026.148505] Code: 00 81 c3 00 10 00 00 83 d6 00 0f ac f3 0c 01 1a 8b 84 24 a8 00 00 00 c7 00 01 00 00 00 e9 46 fe ff ff 0f 0b eb fe 90 8d 74 26 00 <0f> 0b eb fe 8d
Feb  3 15:14:27 server kernel: [ 1026.148505] EIP: [<fed21948>] cow_file_range+0x5f8/0x610 [btrfs] SS:ESP 0068:e4cb38e4
Feb  3 15:14:27 server kernel: [ 1026.165124] ---[ end trace bf1dc2859b76e8be ]---
