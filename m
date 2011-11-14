From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: BUG at fs/btrfs/file.c:1656 [for-linus]
Date: Mon, 14 Nov 2011 12:16:28 +0900
Message-ID: <4EC0880C.1000904@jp.fujitsu.com>
References: <20111108171347.GS12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108171347.GS12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/11/09 2:13), David Sterba wrote:
> Hi,
> 
> a new BUG_ON on for-linus branch with

In current for-linus branch (8965593e41dd2d0e2a2f1e6f245336005ea94a2c),
I encountered following warning message and same BUG_ON() by running
xfstests/269.

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 luna 3.1.0btrfs+
MKFS_OPTIONS  -- /dev/sdd5
MOUNT_OPTIONS -- -o compress=lzo /dev/sdd5 /test9

 -Tsutomu

=========================================================================

[ 2028.064760] device fsid 53b21281-ea7a-4a7b-97f4-fe60f491e678 devid 1 transid 4 /dev/sdd5
[ 2028.064920] btrfs: use lzo compression
[ 2028.064923] btrfs: disk space caching is enabled
[ 2030.986937] btrfs: block rsv returned -28
[ 2030.986940] ------------[ cut here ]------------
[ 2030.986968] WARNING: at fs/btrfs/extent-tree.c:5918 btrfs_alloc_free_block+0x100/0x2aa [btrfs]()
[ 2030.986971] Hardware name: PRIMERGY
[ 2030.986973] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
[ 2030.987068] Pid: 21544, comm: btrfs-endio-wri Not tainted 3.1.0btrfs+ #1
[ 2030.987072] Call Trace:
[ 2030.987083]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
[ 2030.987090]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
[ 2030.987106]  [<ffffffffa043f48a>] btrfs_alloc_free_block+0x100/0x2aa [btrfs]
[ 2030.987127]  [<ffffffffa0461a63>] ? merge_state+0xa6/0x11d [btrfs]
[ 2030.987141]  [<ffffffffa04313aa>] __btrfs_cow_block+0x11d/0x3ba [btrfs]
[ 2030.987156]  [<ffffffffa0431b2e>] btrfs_cow_block+0x108/0x152 [btrfs]
[ 2030.987169]  [<ffffffffa042e548>] ? unlock_up+0xbd/0xee [btrfs]
[ 2030.987184]  [<ffffffffa043384d>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 2030.987201]  [<ffffffffa044137d>] btrfs_lookup_file_extent+0x3d/0x3f [btrfs]
[ 2030.987215]  [<ffffffffa0430f26>] ? btrfs_alloc_path+0x1a/0x1c [btrfs]
[ 2030.987235]  [<ffffffffa045744c>] btrfs_drop_extents+0x11a/0x762 [btrfs]
[ 2030.987243]  [<ffffffff811caa20>] ? radix_tree_tag_clear+0xa6/0x109
[ 2030.987264]  [<ffffffffa0460636>] ? free_extent_state+0x48/0x4c [btrfs]
[ 2030.987271]  [<ffffffff8110b3c9>] ? kmem_cache_alloc+0x31/0xec
[ 2030.987291]  [<ffffffffa0453174>] insert_reserved_file_extent.clone.0+0x79/0x232 [btrfs]
[ 2030.987310]  [<ffffffffa044af4c>] ? start_transaction+0x200/0x24d [btrfs]
[ 2030.987330]  [<ffffffffa04537a9>] btrfs_finish_ordered_io+0x1db/0x2cf [btrfs]
[ 2030.987336]  [<ffffffff8110adf5>] ? __slab_free+0xde/0x1ac
[ 2030.987356]  [<ffffffffa04538fc>] btrfs_writepage_end_io_hook+0x5f/0x79 [btrfs]
[ 2030.987375]  [<ffffffffa047b0ce>] end_compressed_bio_write+0x6e/0xcd [btrfs]
[ 2030.987382]  [<ffffffff81141943>] bio_endio+0x2d/0x2f
[ 2030.987400]  [<ffffffffa0445a52>] end_workqueue_fn+0x111/0x120 [btrfs]
[ 2030.987420]  [<ffffffffa046ba8b>] worker_loop+0x18a/0x4bb [btrfs]
[ 2030.987440]  [<ffffffffa046b901>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
[ 2030.987460]  [<ffffffffa046b901>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
[ 2030.987466]  [<ffffffff81067114>] kthread+0x82/0x8a
[ 2030.987474]  [<ffffffff813b1634>] kernel_thread_helper+0x4/0x10
[ 2030.987480]  [<ffffffff81067092>] ? kthread_worker_fn+0x14a/0x14a
[ 2030.987486]  [<ffffffff813b1630>] ? gs_change+0x13/0x13
[ 2030.987490] ---[ end trace 9ce03434806c2b10 ]---
[ 2030.987543] btrfs: block rsv returned -28
[ 2030.987547] ------------[ cut here ]------------
[ 2030.987562] WARNING: at fs/btrfs/extent-tree.c:5918 btrfs_alloc_free_block+0x100/0x2aa [btrfs]()
[ 2030.987566] Hardware name: PRIMERGY
[ 2030.987569] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
[ 2030.987693] Pid: 21544, comm: btrfs-endio-wri Tainted: G        W   3.1.0btrfs+ #1
[ 2030.987696] Call Trace:
[ 2030.987703]  [<ffffffff8104b6fe>] warn_slowpath_common+0x85/0x9d
[ 2030.987709]  [<ffffffff8104b730>] warn_slowpath_null+0x1a/0x1c
[ 2030.987725]  [<ffffffffa043f48a>] btrfs_alloc_free_block+0x100/0x2aa [btrfs]
[ 2030.987731]  [<ffffffff811c9dc4>] ? __prop_inc_single+0x37/0x3c
[ 2030.987745]  [<ffffffffa04313aa>] __btrfs_cow_block+0x11d/0x3ba [btrfs]
[ 2030.987760]  [<ffffffffa0431b2e>] btrfs_cow_block+0x108/0x152 [btrfs]
[ 2030.987773]  [<ffffffffa042e548>] ? unlock_up+0xbd/0xee [btrfs]
[ 2030.987788]  [<ffffffffa043384d>] btrfs_search_slot+0x24e/0x6a9 [btrfs]
[ 2030.987808]  [<ffffffffa046034f>] ? map_private_extent_buffer+0xa8/0xe8 [btrfs]
[ 2030.987825]  [<ffffffffa044137d>] btrfs_lookup_file_extent+0x3d/0x3f [btrfs]
[ 2030.987839]  [<ffffffffa0430f26>] ? btrfs_alloc_path+0x1a/0x1c [btrfs]
[ 2030.987859]  [<ffffffffa045744c>] btrfs_drop_extents+0x11a/0x762 [btrfs]
[ 2030.987880]  [<ffffffffa0460636>] ? free_extent_state+0x48/0x4c [btrfs]
[ 2030.987886]  [<ffffffff8110b3c9>] ? kmem_cache_alloc+0x31/0xec
[ 2030.987906]  [<ffffffffa0453174>] insert_reserved_file_extent.clone.0+0x79/0x232 [btrfs]
[ 2030.987925]  [<ffffffffa044af4c>] ? start_transaction+0x200/0x24d [btrfs]
[ 2030.987945]  [<ffffffffa04537a9>] btrfs_finish_ordered_io+0x1db/0x2cf [btrfs]
[ 2030.987965]  [<ffffffffa04538fc>] btrfs_writepage_end_io_hook+0x5f/0x79 [btrfs]
[ 2030.987986]  [<ffffffffa04629f6>] end_bio_extent_writepage+0xae/0x159 [btrfs]
[ 2030.987992]  [<ffffffff81142808>] ? bio_free+0x64/0x69
[ 2030.987998]  [<ffffffff81141943>] bio_endio+0x2d/0x2f
[ 2030.988024]  [<ffffffffa0445a52>] end_workqueue_fn+0x111/0x120 [btrfs]
[ 2030.988044]  [<ffffffffa046ba8b>] worker_loop+0x18a/0x4bb [btrfs]
[ 2030.988064]  [<ffffffffa046b901>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
[ 2030.988084]  [<ffffffffa046b901>] ? btrfs_queue_worker+0x224/0x224 [btrfs]
[ 2030.988090]  [<ffffffff81067114>] kthread+0x82/0x8a
[ 2030.988096]  [<ffffffff813b1634>] kernel_thread_helper+0x4/0x10
[ 2030.988103]  [<ffffffff81067092>] ? kthread_worker_fn+0x14a/0x14a
[ 2030.988108]  [<ffffffff813b1630>] ? gs_change+0x13/0x13
[ 2030.988112] ---[ end trace 9ce03434806c2b11 ]---
[ 2031.073867] ------------[ cut here ]------------
[ 2031.074005] kernel BUG at fs/btrfs/file.c:1656!
[ 2031.074285] invalid opcode: 0000 [#1] SMP
[ 2031.074481] CPU 0
[ 2031.074481] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
[ 2031.074481]
[ 2031.074481] Pid: 21437, comm: fsstress Tainted: G        W   3.1.0btrfs+ #1 FUJITSU-SV      PRIMERGY            /D2399
[ 2031.074481] RIP: 0010:[<ffffffffa0455ff8>]  [<ffffffffa0455ff8>] btrfs_fallocate+0x1ac/0x325 [btrfs]
[ 2031.074481] RSP: 0018:ffff88014b7a7d58  EFLAGS: 00010202
[ 2031.074481] RAX: ffffffffffffffef RBX: ffff880177cdb6f0 RCX: 00000000004ce9ae
[ 2031.074481] RDX: ffff88014b7a7c68 RSI: 000060fe600045c0 RDI: 0000000000000000
[ 2031.074481] RBP: ffff88014b7a7e08 R08: ffffffffa0430eac R09: ffff88014b7a7c30
[ 2031.074481] R10: 0000000000000000 R11: ffff88017e384160 R12: ffffffffffffffef
[ 2031.074481] R13: 000000000015b000 R14: 0000000000134000 R15: 0000000000172000
[ 2031.074481] FS:  00007f1600479700(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
[ 2031.074481] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2031.074481] CR2: 00007f15fc0aa1a8 CR3: 000000017dd4e000 CR4: 00000000000006f0
[ 2031.074481] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2031.074481] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2031.074481] Process fsstress (pid: 21437, threadinfo ffff88014b7a6000, task ffff88015e825ac0)
[ 2031.074481] Stack:
[ 2031.074481]  ffff88014b726000 00000000ffffff9c ffff88014b7a7d78 ffffffff8110946c
[ 2031.074481]  000000014b7a7da8 ffff880177cdb798 000000015e825ac0 fffffffffffff000
[ 2031.074481]  ffff880177cdb590 00000000ffffff9c 0000000000000fff 0000000000171726
[ 2031.074481] Call Trace:
[ 2031.074481]  [<ffffffff8110946c>] ? virt_to_head_page+0xe/0x31
[ 2031.074481]  [<ffffffff81119506>] do_fallocate+0xf2/0x110
[ 2031.074481]  [<ffffffff81127ad9>] ioctl_preallocate+0x73/0x7c
[ 2031.074481]  [<ffffffff811282d5>] do_vfs_ioctl+0x414/0x4b8
[ 2031.074481]  [<ffffffff811283cf>] sys_ioctl+0x56/0x7b
[ 2031.074481]  [<ffffffff813af4c2>] system_call_fastpath+0x16/0x1b
[ 2031.074481] Code: 89 f8 45 31 c9 31 d2 4d 29 e8 31 f6 4c 89 e9 48 89 df e8 49 7b ff ff 48 85 c0 49 89 c4 74 0c 48 3d 00 f0 ff ff 0f 86 30 01 00 00 <0f> 0b eb fe 48 8b 53 50 49 39 d5 0f 82 80 00 00 00 49 8b 4c 24
[ 2031.074481] RIP  [<ffffffffa0455ff8>] btrfs_fallocate+0x1ac/0x325 [btrfs]
[ 2031.074481]  RSP <ffff88014b7a7d58>

  
> 
> commit 45ea6095c8f0d6caad5658306416a5d254f1205e
> Author: slyich@gmail.com <slyich@gmail.com>
> Date:   Mon Nov 7 16:08:01 2011 -0500
> 
>     btrfs: fix double-free 'tree_root' in 'btrfs_mount()'
> 
> on top. Freshly created fs,
> 
> === DF for /dev/sda5
> Data, RAID0: total=4.00GB, used=0.00
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
> === DF for /dev/sda9
> Data: total=8.00MB, used=0.00
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
> 
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 3.1.0-rc10-default+
> MKFS_OPTIONS  -- /dev/sda9
> MOUNT_OPTIONS -- -o compress=lzo,discard,space_cache,autodefrag
> /dev/sda9 /mnt/a2
> 
> xfstests/013 (tests running from 001 up to it)
> 
> [  267.150042] ------------[ cut here ]------------
> [  267.152882] kernel BUG at fs/btrfs/file.c:1656!
> [  267.152882] invalid opcode: 0000 [#1] SMP
> [  267.152882] CPU 1
> [  267.152882] Modules linked in: loop btrfs aoe
> [  267.152882]
> [  267.152882] Pid: 8324, comm: fsstress Not tainted 3.1.0-rc10-default+ #59
> [  267.152882] RIP: 0010:[<ffffffffa0047d70>]  [<ffffffffa0047d70>] btrfs_fallocate+0x380/0x3d0 [btrfs]
> [  267.152882] RSP: 0018:ffff8800732b7e88  EFLAGS: 00010202
> [  267.152882] RAX: ffffffffffffffef RBX: 0000000000112000 RCX: 0000000000000006
> [  267.152882] RDX: 0000000000000001 RSI: ffff880077c6d078 RDI: 0000000000000000
> [  267.220213] RBP: ffff8800732b7f38 R08: 0000000000000001 R09: 0000000000000001
> [  267.220213] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffffffffef
> [  267.220213] R13: 0000000000112000 R14: ffff88006f961be8 R15: 0000000000158000
> [  267.220213] FS:  00007fd4d475e700(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
> [  267.220213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  267.220213] CR2: 00007fa5545d9000 CR3: 0000000077731000 CR4: 00000000000006e0
> [  267.220213] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  267.220213] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  267.220213] Process fsstress (pid: 8324, threadinfo ffff8800732b6000, task ffff880077c6ca00)
> [  267.220213] Stack:
> [  267.220213]  ffff880077c6ca00 ffff880077c6d078 ffff8800732b7ec8 ffff88006f9617f8
> [  267.220213]  00000000000e3000 ffff88006f9618b0 0000000000157fff 0000000181143ef4
> [  267.220213]  ffff88006f961cc8 fffffffffffff000 0000000000000fff 0000000100000001
> [  267.220213] Call Trace:
> [  267.220213]  [<ffffffff81141330>] do_fallocate+0xe0/0xf0
> [  267.220213]  [<ffffffff8114138e>] sys_fallocate+0x4e/0x80
> [  267.220213]  [<ffffffff81a1d742>] system_call_fastpath+0x16/0x1b
> [  267.220213] Code: 8b 7d 90 e8 e3 b5 9c e1 e9 f2 fc ff ff 66 0f 1f 44 00 00 49 39 c7 48 89 c3 49 0f 46 df e9 12 ff ff ff 66 0f 1f 84 00 00 00 00 00 <0f> 0b 66 0f 1f 44 00 00 48 89 c7 4c 89 e3 4d 89 fd e8 8a b4 00
> [  267.220213] RIP  [<ffffffffa0047d70>] btrfs_fallocate+0x380/0x3d0 [btrfs]
> [  267.220213]  RSP <ffff8800732b7e88>
> [  267.393603] ---[ end trace d0abb6e726d09321 ]---
> 
> btrfs_fallocate():
> 1651         while (1) {
> 1652                 u64 actual_end;
> 1653
> 1654                 em = btrfs_get_extent(inode, NULL, 0, cur_offset,
> 1655                                       alloc_end - cur_offset, 0);
> 1656                 BUG_ON(IS_ERR_OR_NULL(em));
> 
> RAX says its -17 EEXIST. We saw this with raid10 + inode_cache, but this is not
> the case.
> 
> the process that triggered it:
> 
> D+   17:52   0:00 rm -rf /mnt/a1/fsstress.8088.1 /mnt/a1/fsstress.8088.2
> 
> $ cat /proc/8458/stack
> [<ffffffff81152205>] vfs_unlink+0x65/0x100
> [<ffffffff8115243b>] do_unlinkat+0x19b/0x1d0
> [<ffffffff811532b2>] sys_unlinkat+0x22/0x40
> [<ffffffff81a1d742>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> looks very similar to the "BUG at fs/btrfs/tree-log.c:3106" reported against
> integration-danger, though this branch does not contain the sub-trans logging
> patch.
> 
> 
> david

