From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 09:00:47 +0200
Message-ID: <4A7A7F9F.1080809@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I just had my Fedora 11 workstation (kernel version
2.6.29.4-167.fc11.i686.PAE) crash hard.  The following was printed to a
logged-in SSH session:

------------[ cut here ]------------
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.1/1-2.1.1/devnum
Process pdflush (pid: 11675, ti=d4944000 task=ee516500 task.ti=d4944000)
Stack:
 c2920960 00000024 00000000 00000000 00001000 00000000 00000000 f6d72660
 f5c8a150 00001000 00000000 a55cf000 d4945ccb d4945c50 d4945c48 f8a0d70e
Call Trace:
 [<f8a0d70e>] ? btrfs_reserve_extent+0x40/0x64 [btrfs]
 [<f8a1e0fe>] ? cow_file_range+0x258/0x41b [btrfs]
 [<f8a1ea16>] ? run_delalloc_range+0xb0/0x31f [btrfs]
 [<f8a32c19>] ? __extent_writepage+0x1f6/0x7bd [btrfs]
 [<c0565323>] ? __lookup_tag+0x89/0xe3
 [<c05653ec>] ? radix_tree_gang_lookup_tag_slot+0x6f/0x8e
 [<f8a3352a>] ? extent_write_cache_pages.clone.0+0x10c/0x1ec [btrfs]
 [<f8a33714>] ? extent_writepages+0x3f/0x53 [btrfs]
 [<f8a1c869>] ? btrfs_get_extent+0x0/0x927 [btrfs]
 [<f8a1c735>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<c04852bc>] ? do_writepages+0x25/0x39
 [<c04bea15>] ? __writeback_single_inode+0x15c/0x27a
 [<c0667d88>] ? dm_any_congested+0x32/0x3d
 [<f8a15c3b>] ? btrfs_congested_fn+0x38/0x66 [btrfs]
 [<c04bee90>] ? generic_sync_sb_inodes+0x1d9/0x2f6
 [<c04bf156>] ? writeback_inodes+0x82/0xca
 [<c048598c>] ? background_writeout+0x7b/0xa7
 [<c04860c2>] ? pdflush+0x130/0x1dc
 [<c0485911>] ? background_writeout+0x0/0xa7
 [<c0485f92>] ? pdflush+0x0/0x1dc
 [<c0446fc8>] ? kthread+0x41/0x65
 [<c0446f87>] ? kthread+0x0/0x65
 [<c0409dbf>] ? kernel_thread_helper+0x7/0x10
Code: e8 17 46 a1 c7 90 8b 9b 80 00 00 00 83 c3 80 8b 83 80 00 00 00 0f 18 00 90 8d 83 80 00 00 00 39 45 e8 75 99 89 f0 e8 18 d0 a3 c7 <0f> 0b eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83
EIP: [<f8a0d543>] __btrfs_reserve_extent+0x339/0x347 [btrfs] SS:ESP 0068:d4945ba4
------------[ cut here ]------------
invalid opcode: 0000 [#2] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.1/1-2.1.1/devnum
Process qemu-kvm (pid: 11670, ti=f0c6a000 task=d9c89940 task.ti=f0c6a000)
Stack:
 00000000 00000024 00000000 00000000 00001000 00000000 00000000 f4d04630
 f5c8a150 00001000 00000000 05f82000 f0c6bc67 f0c6bbec f0c6bbe4 f8a0d70e
Call Trace:
 [<f8a0d70e>] ? btrfs_reserve_extent+0x40/0x64 [btrfs]
 [<f8a1e0fe>] ? cow_file_range+0x258/0x41b [btrfs]
 [<f8a1ea16>] ? run_delalloc_range+0xb0/0x31f [btrfs]
 [<f8a32c19>] ? __extent_writepage+0x1f6/0x7bd [btrfs]
 [<c0565323>] ? __lookup_tag+0x89/0xe3
 [<c05653ec>] ? radix_tree_gang_lookup_tag_slot+0x6f/0x8e
 [<f8a3352a>] ? extent_write_cache_pages.clone.0+0x10c/0x1ec [btrfs]
 [<f8a33714>] ? extent_writepages+0x3f/0x53 [btrfs]
 [<f8a1c869>] ? btrfs_get_extent+0x0/0x927 [btrfs]
 [<f8a1c735>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<f8a2d0be>] ? btrfs_fdatawrite_range+0x67/0x6f [btrfs]
 [<f8a23245>] ? btrfs_file_write+0x440/0x627 [btrfs]
 [<c05365ef>] ? security_file_permission+0x14/0x16
 [<c04a8b59>] ? rw_verify_area+0x9a/0xbb
 [<f8a22e05>] ? btrfs_file_write+0x0/0x627 [btrfs]
 [<c04a9229>] ? vfs_write+0x95/0xf4
 [<c04a92e0>] ? sys_pwrite64+0x58/0x70
 [<c040945f>] ? sysenter_do_call+0x12/0x34
Code: e8 17 46 a1 c7 90 8b 9b 80 00 00 00 83 c3 80 8b 83 80 00 00 00 0f 18 00 90 8d 83 80 00 00 00 39 45 e8 75 99 89 f0 e8 18 d0 a3 c7 <0f> 0b eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83
EIP: [<f8a0d543>] __btrfs_reserve_extent+0x339/0x347 [btrfs] SS:ESP 0068:f0c6bb40
------------[ cut here ]------------
invalid opcode: 0000 [#3] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2.1/1-2.1.1/devnum
Process qemu-kvm (pid: 11674, ti=c583c000 task=d9c8f1a0 task.ti=c583c000)
Stack:
 00000000 00000024 00000000 00000000 00001000 00000000 00000000 f4d04ed0
 f5c8a150 00001000 00000000 03fbd000 c583dc67 c583dbec c583dbe4 f8a0d70e
Call Trace:
 [<f8a0d70e>] ? btrfs_reserve_extent+0x40/0x64 [btrfs]
 [<f8a1e0fe>] ? cow_file_range+0x258/0x41b [btrfs]
 [<f8a1ea16>] ? run_delalloc_range+0xb0/0x31f [btrfs]
 [<f8a32c19>] ? __extent_writepage+0x1f6/0x7bd [btrfs]
 [<c0565323>] ? __lookup_tag+0x89/0xe3
 [<c05653ec>] ? radix_tree_gang_lookup_tag_slot+0x6f/0x8e
 [<f8a3352a>] ? extent_write_cache_pages.clone.0+0x10c/0x1ec [btrfs]
 [<f8a33714>] ? extent_writepages+0x3f/0x53 [btrfs]
 [<f8a1c869>] ? btrfs_get_extent+0x0/0x927 [btrfs]
 [<f8a1c735>] ? btrfs_writepages+0x20/0x25 [btrfs]
 [<f8a2d0be>] ? btrfs_fdatawrite_range+0x67/0x6f [btrfs]
 [<f8a23245>] ? btrfs_file_write+0x440/0x627 [btrfs]
 [<c05365ef>] ? security_file_permission+0x14/0x16
 [<c04a8b59>] ? rw_verify_area+0x9a/0xbb
 [<f8a22e05>] ? btrfs_file_write+0x0/0x627 [btrfs]
 [<c04a9229>] ? vfs_write+0x95/0xf4
 [<c04a92e0>] ? sys_pwrite64+0x58/0x70
 [<c040945f>] ? sysenter_do_call+0x12/0x34
Code: e8 17 46 a1 c7 90 8b 9b 80 00 00 00 83 c3 80 8b 83 80 00 00 00 0f 18 00 90 8d 83 80 00 00 00 39 45 e8 75 99 89 f0 e8 18 d0 a3 c7 <0f> 0b eb fe 8d 65 f4 31 c0 5b 5e 5f 5d c3 55 89 e5 57 56 53 83
EIP: [<f8a0d543>] __btrfs_reserve_extent+0x339/0x347 [btrfs] SS:ESP 0068:c583db40

I have btrfs on my root filesystem and at the time of the crash I taring
together some files from a NFS filesystem onto it.  There was plenty of
free space on the btrfs filesystem.

I wasn't able to Google up another report with a similar-looking crash,
so I thought you might be interested.

Best regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
