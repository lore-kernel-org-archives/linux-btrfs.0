From: Gerhard Kulzer <gerhard@kulzer.net>
Subject: system crash at mounting of btrfs
Date: Thu, 7 Oct 2010 14:12:33 +0000 (UTC)
Message-ID: <loom.20101007T155351-932@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a weird problem concerning 5 btrfs partitions on 3 different disks:
My system became slow and started to hang and go, so I shut it down and it 
hang totally whilst shutting down. With the sysrq shortcut I could kill it 
and restart.

Booting didn't work any more throwing me into a shell at initramfs.

I booted from a CD and tried to mount the first btrfs partition, the system hung
up after about 1 sec, just throwing "killed" to the shell.
I tried (after reboot) to mount the 4 other partitions which are on different
disks: the failure is always the same. I also tried mount options as "degraded",
"read-only" w/o success. But btrfsck works flawless, also btrfsctl -A, no
crashes. Any other partition on the same disk like ext4 mount perfectly.
I tried it with 3 kernels from the 2.5.35 series.
My system is a AMD64, so I put one SSD disk as an external drive (USB) to a
laptop running a 32bit system, it crashed the same at my wanting to mount the
partition.

This is my config:
$uname -a
Linux ubuntu 2.6.35-22-generic #33-Ubuntu SMP Sun Sep 19 20:34:50 UTC 2010 i686
GNU/Linux

Here is a dmesg trace during booting from the CD, it not the crash yet.

[    7.782823] Btrfs loaded
[    7.786081] xor: automatically using best checksumming function: pIII_sse
[    7.804000]    pIII_sse  : 11626.000 MB/sec
[    7.804001] xor: using function: pIII_sse (11626.000 MB/sec)
[    7.805746] device-mapper: dm-raid45: initialized v0.2594b
[    7.851186] device fsid 3a4b4bc6c07de70b-2b32b3df70d2459f devid 1 transid
407064 /dev/sda2
[    7.881078] Btrfs detected SSD devices, enabling SSD mode
[    7.923553] ------------[ cut here ]------------
[    7.923556] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/tree-log.c:813!
[    7.923558] invalid opcode: 0000 [#1] SMP 
[    7.923561] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[    7.923562] Modules linked in: dm_raid45 xor btrfs zlib_deflate crc32c
libcrc32c nouveau ttm drm_kms_helper usbhid hid usb_storage drm sky2
firewire_ohci firewire_core intel_agp crc_itu_t ahci pata_jmicron libahci
agpgart i2c_algo_bit
[    7.923577] 
[    7.923579] Pid: 453, comm: exe Not tainted 2.6.35-22-generic #33-Ubuntu
P5K-E/P5K-E
[    7.923582] EIP: 0060:[<f9c44024>] EFLAGS: 00010246 CPU: 0
[    7.923590] EIP is at add_inode_ref+0x3f4/0x410 [btrfs]
[    7.923592] EAX: 00000000 EBX: 00000097 ECX: 00000000 EDX: 00000274
[    7.923594] ESI: 00000002 EDI: f6fe8af0 EBP: c1257c30 ESP: c1257bd4
[    7.923596]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    7.923598] Process exe (pid: 453, ti=c1256000 task=f6a30000 task.ti=c1256000)
[    7.923599] Stack:
[    7.923600]  c1257be8 c1257be8 c0132ba6 f6fe8af0 00000011 c1257bf0 f9c2d2c1
c1257c30
[    7.923605] <0> f9c21d37 c1257c20 00000000 f6f9b000 f643887c 00000004
00000000 f6fe8af0
[    7.923610] <0> f68e6000 f7156000 fffb6000 fffb6000 00000097 00000002
f6fe8af0 c1257c94
[    7.923615] Call Trace:
[    7.923620]  [<c0132ba6>] ? kunmap_atomic+0x66/0x80
[    7.923628]  [<f9c2d2c1>] ? unmap_extent_buffer+0x11/0x20 [btrfs]
[    7.923637]  [<f9c21d37>] ? btrfs_item_size+0xc7/0xd0 [btrfs]
[    7.923644]  [<f9c45a46>] ? replay_one_buffer+0x246/0x320 [btrfs]
[    7.923651]  [<f9c423a9>] ? walk_down_log_tree+0x219/0x3b0 [btrfs]
[    7.923658]  [<f9c425e9>] ? walk_log_tree+0xa9/0x1d0 [btrfs]
[    7.923665]  [<f9c44d94>] ? btrfs_recover_log_trees+0x1d4/0x2b0 [btrfs]
[    7.923672]  [<f9c45800>] ? replay_one_buffer+0x0/0x320 [btrfs]
[    7.923680]  [<f9c0d07c>] ? open_ctree+0x101c/0x14c0 [btrfs]
[    7.923686]  [<f9bee672>] ? btrfs_fill_super+0x52/0x110 [btrfs]
[    7.923690]  [<c0356069>] ? strlcpy+0x39/0x50
[    7.923695]  [<f9beebbd>] ? btrfs_get_sb+0x24d/0x2d0 [btrfs]
[    7.923699]  [<c020f66f>] ? __alloc_percpu+0xf/0x20
[    7.923701]  [<c0231109>] ? alloc_vfsmnt+0xf9/0x130
[    7.923704]  [<c021aee4>] ? vfs_kern_mount+0x74/0x1c0
[    7.923707]  [<c022f493>] ? get_fs_type+0x33/0xb0
[    7.923709]  [<c021b08e>] ? do_kern_mount+0x3e/0xe0
[    7.923711]  [<c023260c>] ? do_mount+0x1dc/0x220
[    7.923714]  [<c02326bb>] ? sys_mount+0x6b/0xa0
[    7.923717]  [<c05c90a4>] ? syscall_call+0x7/0xb
[    7.923718] Code: e8 42 b3 fa ff 8b 45 d4 e8 5a 87 5e c6 8b 45 cc e8 52 87 5e
c6 31 c0 83 c4 50 5b 5e 5f 5d c3 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb
fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 8d b6 00 00 00 
[    7.923746] EIP: [<f9c44024>] add_inode_ref+0x3f4/0x410 [btrfs] SS:ESP
0068:c1257bd4
[    7.923755] ---[ end trace 2b634c981d89a441 ]---

Any help how to get my data off those disk is seriously appreciated.

