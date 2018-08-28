Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:47914 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbeH2BTz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 21:19:55 -0400
Received: from [192.168.1.50] ([92.15.161.148]) by mrelayeu.kundenserver.de
 (mreue002 [212.227.15.167]) with ESMTPSA (Nemesis) id
 0Lst7y-1fobZf0zf8-012UsV for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018
 23:26:21 +0200
From: Sam Tygier <sam@tygier.co.uk>
Subject: WARNING in clone_finish_inode_update while de-duplicating with bedup
To: linux-btrfs@vger.kernel.org
Message-ID: <82aace9f-a1e3-1f0b-055f-3ea75f7a41a0@tygier.co.uk>
Date: Tue, 28 Aug 2018 22:26:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I get the following WARNING while de-duplicating with bedup 0.10.1. I am 
running Debian with backports kernel:
Linux lithium 4.17.0-0.bpo.1-amd64 #1 SMP Debian 4.17.8-1~bpo9+1 
(2018-07-23) x86_64 GNU/Linux

I ran:
sudo bedup scan /media/btrfs/
sudo bedup dedupe /media/btrfs/

/media/btrfs has 4 drives in btrfs raid1

Aug 19 03:32:39 lithium kernel: BTRFS: Transaction aborted (error -28)
Aug 19 03:32:39 lithium kernel: WARNING: CPU: 2 PID: 4204 at 
/build/linux-hvYKKE/linux-4.17.8/fs/btrfs/ioctl.c:3249 
clone_finish_inode_update+0xf3/0x140 [btrfs]
Aug 19 03:32:39 lithium kernel: Modules linked in: fuse ufs qnx4 hfsplus 
hfs minix ntfs vfat msdos fat jfs xfs dm_mod xt_multiport iptable_filter 
iTCO_wdt iTCO_vendor_support ppdev evdev intel_powerclamp squashfs 
ir_rc6_decoder pcspkr serio_raw sg rc_rc6_mce lpc_ich shpchp fintek_cir 
parport_pc rc_core parport video button f71882fg lm78 hwmon_vid coretemp 
nfsd auth_rpcgss nfs_acl loop lockd grace sunrpc ip_tables x_tables 
autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb crypto_simd cryptd 
glue_helper aes_x86_64 btrfs xor zstd_decompress zstd_compress xxhash 
raid6_pq libcrc32c crc32c_generic sd_mod ahci libahci libata i2c_i801 
psmouse scsi_mod uhci_hcd ehci_pci ehci_hcd e1000e usbcore usb_common 
thermal
Aug 19 03:32:39 lithium kernel: CPU: 2 PID: 4204 Comm: bedup Not tainted 
4.17.0-0.bpo.1-amd64 #1 Debian 4.17.8-1~bpo9+1
Aug 19 03:32:39 lithium kernel: Hardware name:  /, BIOS 4.6.5 12/11/2012
Aug 19 03:32:39 lithium kernel: RIP: 
0010:clone_finish_inode_update+0xf3/0x140 [btrfs]
Aug 19 03:32:39 lithium kernel: RSP: 0018:ffffa2e44931fc38 EFLAGS: 00010282
Aug 19 03:32:39 lithium kernel: RAX: 0000000000000000 RBX: 
00000000ffffffe4 RCX: 0000000000000006
Aug 19 03:32:39 lithium kernel: RDX: 0000000000000007 RSI: 
0000000000000086 RDI: ffff93571fd16730
Aug 19 03:32:39 lithium kernel: RBP: ffffa2e44931fc68 R08: 
0000000000000001 R09: 0000000000000492
Aug 19 03:32:39 lithium kernel: R10: ffff935687ff6ea8 R11: 
0000000000000492 R12: ffff93561add38f0
Aug 19 03:32:39 lithium kernel: R13: 0000000004380000 R14: 
ffff93552159d288 R15: ffff935603ef4a10
Aug 19 03:32:39 lithium kernel: FS:  00007fb3dffe6700(0000) 
GS:ffff93571fd00000(0000) knlGS:0000000000000000
Aug 19 03:32:39 lithium kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Aug 19 03:32:39 lithium kernel: CR2: 00007fb3d87d5024 CR3: 
0000000170bcc000 CR4: 00000000000006e0
Aug 19 03:32:39 lithium kernel: Call Trace:
Aug 19 03:32:39 lithium kernel:  btrfs_clone+0x938/0x10e0 [btrfs]
Aug 19 03:32:39 lithium kernel:  btrfs_clone_files+0x16f/0x370 [btrfs]
Aug 19 03:32:39 lithium kernel:  vfs_clone_file_range+0x120/0x200
Aug 19 03:32:39 lithium kernel:  ioctl_file_clone+0x9f/0x100
Aug 19 03:32:39 lithium kernel:  ? __vma_rb_erase+0x11a/0x230
Aug 19 03:32:39 lithium kernel:  do_vfs_ioctl+0x341/0x620
Aug 19 03:32:39 lithium kernel:  ? do_munmap+0x34a/0x460
Aug 19 03:32:39 lithium kernel:  ksys_ioctl+0x70/0x80
Aug 19 03:32:39 lithium kernel:  __x64_sys_ioctl+0x16/0x20
Aug 19 03:32:39 lithium kernel:  do_syscall_64+0x55/0x110
Aug 19 03:32:39 lithium kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
Aug 19 03:32:39 lithium kernel: RIP: 0033:0x7fb3deda9dd7
Aug 19 03:32:39 lithium kernel: RSP: 002b:00007fffd9e39e48 EFLAGS: 
00000246 ORIG_RAX: 0000000000000010
Aug 19 03:32:39 lithium kernel: RAX: ffffffffffffffda RBX: 
0000000040049409 RCX: 00007fb3deda9dd7
Aug 19 03:32:39 lithium kernel: RDX: 0000000000000014 RSI: 
0000000040049409 RDI: 0000000000000016
Aug 19 03:32:39 lithium kernel: RBP: 0000557b716730e0 R08: 
0000000000000000 R09: 00007fffd9e39c20
Aug 19 03:32:39 lithium kernel: R10: 0000000000000100 R11: 
0000000000000246 R12: 00007fffd9e39e70
Aug 19 03:32:39 lithium kernel: R13: 0000557b7189f4c0 R14: 
0000000000000016 R15: 0000000000000001
Aug 19 03:32:39 lithium kernel: Code: 89 c7 e9 67 ff ff ff 49 8b 44 24 
50 f0 48 0f ba a8 30 17 00 00 02 72 15 83 fb fb 74 3b 89 de 48 c7 c7 78 
1f 70 c0 e8 3d a5 5d f9 <0f> 0b 89 d9 4c 89 e7 ba b1 0c 00 00 48 c7 c6 
50 62 6f c0 e8 cf
Aug 19 03:32:39 lithium kernel: ---[ end trace d8e04102b2b7c95a ]---
Aug 19 03:32:39 lithium kernel: BTRFS: error (device sda2) in 
clone_finish_inode_update:3249: errno=-28 No space left
Aug 19 03:32:39 lithium kernel: BTRFS info (device sda2): forced readonly
Aug 19 03:32:39 lithium kernel: BTRFS error (device sda2): pending csums 
is 275275776

Bedup crashed, I guess because the warning forced the filesystem readonly

Deduplicated:
- '/media/btrfs/foo1/a/b/c/bar.mkv'
- '/media/btrfs/foo2/a/b/c/d/e/bar.mkv'
03:27:43 Size group 64/17378 (1344397706) sampled 158 hashed 150 freed 
355814871095
Traceback (most recent call last):
   File "/usr/local/lib/python3.5/dist-packages/bedup/tracking.py", line 
609, in dedup_tracked1
     dedup_fileset(ds, fileset, fd_names, fd_inodes, size)
   File "/usr/local/lib/python3.5/dist-packages/bedup/tracking.py", line 
632, in dedup_fileset
     deduped = clone_data(dest=dfd, src=sfd, check_first=True)
   File 
"/usr/local/lib/python3.5/dist-packages/bedup/platform/btrfs.py", line 
602, in clone_data
     ioctl_pybug(dest, lib.BTRFS_IOC_CLONE, src)
   File 
"/usr/local/lib/python3.5/dist-packages/bedup/platform/btrfs.py", line 
361, in ioctl_pybug
     return fcntl.ioctl(fd, ioc, arg)
OSError: [Errno 28] No space left on device

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
   File "/usr/local/bin/bedup", line 11, in <module>
     sys.exit(script_main())
   File "/usr/local/lib/python3.5/dist-packages/bedup/__main__.py", line 
497, in script_main
     sys.exit(main(sys.argv))
   File "/usr/local/lib/python3.5/dist-packages/bedup/__main__.py", line 
486, in main
     return args.action(args)
   File "/usr/local/lib/python3.5/dist-packages/bedup/__main__.py", line 
196, in vol_cmd
     dedup_tracked(sess, volset, tt, defrag=args.defrag)
   File "/usr/local/lib/python3.5/dist-packages/bedup/tracking.py", line 
405, in dedup_tracked
     dedup_tracked1(ds, comm1)
   File "/usr/local/lib/python3.5/dist-packages/bedup/tracking.py", line 
609, in dedup_tracked1
     dedup_fileset(ds, fileset, fd_names, fd_inodes, size)
   File "/usr/lib/python3.5/contextlib.py", line 360, in __exit__
     raise exc_details[1]
   File "/usr/lib/python3.5/contextlib.py", line 345, in __exit__
     if cb(*exc_details):
   File "/usr/lib/python3.5/contextlib.py", line 261, in _exit_wrapper
     return cm_exit(cm, *exc_details)
   File "/usr/local/lib/python3.5/dist-packages/bedup/dedup.py", line 
231, in __exit__
     editflags(fd, remove_flags=FS_IMMUTABLE_FL)
   File 
"/usr/local/lib/python3.5/dist-packages/bedup/platform/chattr.py", line 
106, in editflags
     fcntl.ioctl(fd, lib.FS_IOC_SETFLAGS, flags_buf)
OSError: [Errno 30] Read-only file system
Command exited with non-zero status 1

There shouldn't be any issue with running out of space

$ sudo btrfs fi usage /media/btrfs/
Overall:
     Device size:                  14.55TiB
     Device allocated:             12.50TiB
     Device unallocated:            2.05TiB
     Device missing:                  0.00B
     Used:                         11.83TiB
     Free (estimated):              1.36TiB      (min: 1.36TiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 3.12MiB)

Data,RAID1: Size:6.24TiB, Used:5.90TiB
    /dev/sda2       2.22TiB
    /dev/sdb1       2.22TiB
    /dev/sdc1       3.13TiB
    /dev/sdd1       4.90TiB

Metadata,RAID1: Size:15.00GiB, Used:12.82GiB
    /dev/sda2       7.00GiB
    /dev/sdb1       5.00GiB
    /dev/sdc1       7.00GiB
    /dev/sdd1      11.00GiB

System,RAID1: Size:32.00MiB, Used:924.00KiB
    /dev/sdc1      32.00MiB
    /dev/sdd1      32.00MiB

Unallocated:
    /dev/sda2     508.57GiB
    /dev/sdb1     520.52GiB
    /dev/sdc1     513.99GiB
    /dev/sdd1     559.00GiB

Do you need any more information? Should I report this anywhere else?

Thanks,
Sam
