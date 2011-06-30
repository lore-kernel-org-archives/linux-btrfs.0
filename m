From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Thu, 30 Jun 2011 14:32:12 +0800
Message-ID: <4E0C186C.8060101@cn.fujitsu.com>
References: <1308345034-sup-1969@shiny> <4DFD7C63.6040902@jp.fujitsu.com> <4DFE8933.7040101@jp.fujitsu.com> <20110621002435.GK12709@twin.jikos.cz> <1308616798-sup-2605@shiny> <4DFFF0B2.1070403@jp.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, David Sterba <dave@jikos.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFFF0B2.1070403@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Itoh-san

Could you test the following patch to check whether it can fix the bug or not?
I have tested it on my x86_64 machine by your test script for two days, it worked well.

Thanks
Miao

Subject: [PATCH] btrfs: fix oops when doing space balance

When doing space balance, the following oops happened.

------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:4303!
[SNIP]
Call Trace:
 [<ffffffffa03143fd>] ? update_ref_for_cow+0x22d/0x330 [btrfs]
 [<ffffffffa0314951>] __btrfs_cow_block+0x451/0x5e0 [btrfs]
 [<ffffffffa031355d>] ? read_block_for_search+0x14d/0x4d0 [btrfs]
 [<ffffffffa0314beb>] btrfs_cow_block+0x10b/0x240 [btrfs]
 [<ffffffffa031acae>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
 [<ffffffffa032d8af>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
 [<ffffffff8147bf0e>] ? mutex_lock+0x1e/0x50
 [<ffffffffa0380cf1>] btrfs_update_delayed_inode+0x71/0x160 [btrfs]
 [<ffffffffa037ff27>] ? __btrfs_release_delayed_node+0x67/0x190 [btrfs]
 [<ffffffffa0381cf8>] btrfs_run_delayed_items+0xe8/0x120 [btrfs]
 [<ffffffffa03365e0>] btrfs_commit_transaction+0x250/0x850 [btrfs]
 [<ffffffff810f91d9>] ? find_get_pages+0x39/0x130
 [<ffffffffa0336cd5>] ? join_transaction+0x25/0x250 [btrfs]
 [<ffffffff81081de0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa03785fa>] prepare_to_relocate+0xda/0xf0 [btrfs]
 [<ffffffffa037f2bb>] relocate_block_group+0x4b/0x620 [btrfs]
 [<ffffffffa0334cf5>] ? btrfs_clean_old_snapshots+0x35/0x150 [btrfs]
 [<ffffffffa037fa43>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
 [<ffffffffa0368ec0>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
 [<ffffffffa035e39b>] btrfs_relocate_chunk+0x8b/0x670 [btrfs]
 [<ffffffffa031303d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
 [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa031bea1>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
 [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa035f5aa>] btrfs_balance+0x21a/0x2b0 [btrfs]
 [<ffffffffa0368898>] btrfs_ioctl+0x798/0xd20 [btrfs]
 [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
 [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
 [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
 [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
 [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
[SNIP]
RIP  [<ffffffffa037c1cc>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]

It is because the data relocation inode delayed to be updated, and it triggered
BUG_ON() when doing space balance. So we fix it by doing real-time update.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 447612d..13b2c04 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2678,12 +2678,15 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	int ret;
 
 	/*
-	 * If root is tree root, it means this inode is used to
-	 * store free space information. And these inodes are updated
-	 * when committing the transaction, so they needn't delaye to
-	 * be updated, or deadlock will occured.
+	 * If the inode is a free space inode. they needn't delayed to be
+	 * updated, because these inodes are updated when committing the
+	 * transaction, or deadlock will occured.
+	 *
+	 * Besides that, the data relocation inode is also needn't delayed
+	 * to be updated.
 	 */
-	if (!is_free_space_inode(root, inode)) {
+	if (!is_free_space_inode(root, inode)
+	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
 		ret = btrfs_delayed_update_inode(trans, root, inode);
 		if (!ret)
 			btrfs_set_inode_last_trans(trans, inode);
-- 
1.7.4


On Tue, 21 Jun 2011 10:15:30 +0900, Tsutomu Itoh wrote:
> I changed my test environment to 'btrfs-unstable + for-linus', I encountered
> following panic without inode_cache. (in about 4 hours after test begins)
> 
> btrfs: relocating block group 49161437184 flags 9
> btrfs: found 57523 extents
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/relocation.c:4303!
> invalid opcode: 0000 [#1] SMP
> last sysfs file: /sys/kernel/mm/ksm/run
> CPU 0
> Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
> 
> Pid: 1329, comm: btrfs Not tainted 2.6.39btrfs-test2+ #1 FUJITSU-SV      PRIMERGY            /D2399
> RIP: 0010:[<ffffffffa037c1cc>]  [<ffffffffa037c1cc>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]
> RSP: 0018:ffff880009665738  EFLAGS: 00010246
> RAX: ffff8801925a4000 RBX: ffff88011ee9e000 RCX: ffff8801566889a8
> RDX: ffff8800a3601728 RSI: ffff880143fa3000 RDI: ffff88014124d4b0
> RBP: ffff880009665798 R08: 6db6db6db6db6db7 R09: 0000160000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff880143fa3000
> R13: ffff8800a3601728 R14: ffff88014124d4b0 R15: ffff880194a87ba8
> FS:  00007f7f5fb40740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000033cfea6d80 CR3: 000000003fd47000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs (pid: 1329, threadinfo ffff880009664000, task ffff880011c73520)
> Stack:
>  ffff8800a3601728 ffff88014124d4b0 ffff880009665798 ffffffffa03143fd
>  0000000000000000 0000000000000001 ffff880009665798 ffff880143fa3000
>  ffff8801566889a8 ffff8800a3601728 ffff88014124d4b0 ffff880194a87ba8
> Call Trace:
>  [<ffffffffa03143fd>] ? update_ref_for_cow+0x22d/0x330 [btrfs]
>  [<ffffffffa0314951>] __btrfs_cow_block+0x451/0x5e0 [btrfs]
>  [<ffffffffa031355d>] ? read_block_for_search+0x14d/0x4d0 [btrfs]
>  [<ffffffffa0314beb>] btrfs_cow_block+0x10b/0x240 [btrfs]
>  [<ffffffffa031acae>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
>  [<ffffffffa032d8af>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
>  [<ffffffff8147bf0e>] ? mutex_lock+0x1e/0x50
>  [<ffffffffa0380cf1>] btrfs_update_delayed_inode+0x71/0x160 [btrfs]
>  [<ffffffffa037ff27>] ? __btrfs_release_delayed_node+0x67/0x190 [btrfs]
>  [<ffffffffa0381cf8>] btrfs_run_delayed_items+0xe8/0x120 [btrfs]
>  [<ffffffffa03365e0>] btrfs_commit_transaction+0x250/0x850 [btrfs]
>  [<ffffffff810f91d9>] ? find_get_pages+0x39/0x130
>  [<ffffffffa0336cd5>] ? join_transaction+0x25/0x250 [btrfs]
>  [<ffffffff81081de0>] ? wake_up_bit+0x40/0x40
>  [<ffffffffa03785fa>] prepare_to_relocate+0xda/0xf0 [btrfs]
>  [<ffffffffa037f2bb>] relocate_block_group+0x4b/0x620 [btrfs]
>  [<ffffffffa0334cf5>] ? btrfs_clean_old_snapshots+0x35/0x150 [btrfs]
>  [<ffffffffa037fa43>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
>  [<ffffffffa0368ec0>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
>  [<ffffffffa035e39b>] btrfs_relocate_chunk+0x8b/0x670 [btrfs]
>  [<ffffffffa031303d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
>  [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>  [<ffffffffa031bea1>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
>  [<ffffffffa03577d8>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>  [<ffffffffa035f5aa>] btrfs_balance+0x21a/0x2b0 [btrfs]
>  [<ffffffffa0368898>] btrfs_ioctl+0x798/0xd20 [btrfs]
>  [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
>  [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
>  [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
>  [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
>  [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
> Code: 8b 76 10 e8 c7 65 eb e0 4c 8b 45 b0 41 80 48 71 20 48 8b 4d b8 8b 45 c0 e9 52 ff ff ff 48 83 be 0f 01 00 00 f7 0f 85 22 fe ff ff <0f> 0b eb fe 49 3b 50 20 0f 84 02 ff ff ff 0f 0b 0f 1f 40 00 eb
> RIP  [<ffffffffa037c1cc>] btrfs_reloc_cow_block+0x22c/0x270 [btrfs]
>  RSP <ffff880009665738>
> 
> (gdb) l *btrfs_reloc_cow_block+0x22c
> 0x6f1fc is in btrfs_reloc_cow_block (fs/btrfs/relocation.c:4302).
> 4297
> 4298            rc = root->fs_info->reloc_ctl;
> 4299            if (!rc)
> 4300                    return;
> 4301
> 4302            BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
> 4303                   root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
> 4304
> 4305            level = btrfs_header_level(buf);
> 4306            if (btrfs_header_generation(buf) <=



>>>>
>>>> But, following panics still occur if inode_cache is specified.
>>>>
>>>> [75164.963860] btrfs: relocating block group 18551406592 flags 18
>>>> [75165.565282] btrfs: relocating block group 18282971136 flags 20
>>>> [75165.883577] ------------[ cut here ]------------
>>>> [75165.883779] kernel BUG at fs/btrfs/relocation.c:2502!
>>>> [75165.883992] invalid opcode: 0000 [#1] SMP
>>>> [75165.884002] CPU 0
>>>> [75165.884002] Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
>>>> [75165.884002]
>>>> [75165.884002] Pid: 18615, comm: btrfs Not tainted 3.0.0-rc3test #1 FUJITSU-SV      PRIMERGY            /D2399
>>>> [75165.884002] RIP: 0010:[<ffffffffa02dede3>]  [<ffffffffa02dede3>] do_relocation+0x163/0x44b [btrfs]
>>>> [75165.884002] RSP: 0018:ffff8801026f7a08  EFLAGS: 00010202
>>>> [75165.884002] RAX: 0000000000000001 RBX: ffff8801949e7c00 RCX: 0000000000000002
>>>> [75165.884002] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
>>>> [75165.884002] RBP: ffff8801026f7ad8 R08: 00000000000006c7 R09: ffff8801026f78f0
>>>> [75165.884002] R10: ffff88009f9d7800 R11: 0000000442149000 R12: ffff880037c99180
>>>> [75165.884002] R13: ffff880152695f30 R14: ffff88009f9d4800 R15: ffff88013cfdbf78
>>>> [75165.884002] FS:  00007f490c045740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
>>>> [75165.884002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [75165.884002] CR2: 00000033cfea6a60 CR3: 0000000100d47000 CR4: 00000000000006f0
>>>> [75165.884002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [75165.884002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> [75165.884002] Process btrfs (pid: 18615, threadinfo ffff8801026f6000, task ffff880102060000)
>>>> [75165.884002] Stack:
>>>> [75165.884002]  ffff88000516d000 ffff88009f9d7d80 00000001026f7a98 ffff880037c99180
>>>> [75165.884002]  ffff880037c991c0 000000019f9d7820 ffff88011bf09ba0 ffff88009f9d7800
>>>> [75165.884002]  ffff8801026f7ad8 ffff88011bf094c0 ffff88013cfdbf78 00ff88009f9d7800
>>>> [75165.884002] Call Trace:
>>>> [75165.884002]  [<ffffffffa02926ec>] ? block_rsv_add_bytes+0x24/0x4d [btrfs]
>>>> [75165.884002]  [<ffffffffa02e137a>] relocate_tree_blocks+0x2fb/0x4a9 [btrfs]
>>>> [75165.884002]  [<ffffffffa02de227>] ? add_tree_block+0xff/0x121 [btrfs]
>>>> [75165.884002]  [<ffffffffa02e1b13>] relocate_block_group+0x214/0x4dc [btrfs]
>>>> [75165.884002]  [<ffffffffa02e1f26>] btrfs_relocate_block_group+0x14b/0x285 [btrfs]
>>>> [75165.884002]  [<ffffffffa02c7183>] ? btrfs_relocate_chunk+0x4a4/0x50d [btrfs]
>>>> [75165.884002]  [<ffffffffa02c6d48>] btrfs_relocate_chunk+0x69/0x50d [btrfs]
>>>> [75165.884002]  [<ffffffffa028b3f5>] ? btrfs_item_key_to_cpu+0x1a/0x36 [btrfs]
>>>> [75165.884002]  [<ffffffffa02c0d0f>] ? read_extent_buffer+0xba/0xf6 [btrfs]
>>>> [75165.884002]  [<ffffffffa02c561a>] ? btrfs_item_key_to_cpu+0x2a/0x46 [btrfs]
>>>> [75165.884002]  [<ffffffffa02c77be>] btrfs_balance+0x1ca/0x219 [btrfs]
>>>> [75165.884002]  [<ffffffffa02cfcbd>] btrfs_ioctl+0x922/0xc19 [btrfs]
>>>> [75165.884002]  [<ffffffff810e88e4>] ? handle_mm_fault+0x233/0x24a
>>>> [75165.884002]  [<ffffffff813a6be5>] ? do_page_fault+0x340/0x3b2
>>>> [75165.884002]  [<ffffffff8111d828>] do_vfs_ioctl+0x474/0x4c3
>>>> [75165.884002]  [<ffffffff810ffe41>] ? virt_to_head_page+0xe/0x31
>>>> [75165.884002]  [<ffffffff811010e8>] ? kmem_cache_free+0x20/0xae
>>>> [75165.884002]  [<ffffffff8111d8cd>] sys_ioctl+0x56/0x79
>>>> [75165.884002]  [<ffffffff813aa302>] system_call_fastpath+0x16/0x1b
>>>> [75165.884002] Code: 00 00 48 8b 95 60 ff ff ff 45 31 c0 41 b9 01 00 00 00 4c 89 e9 4c 89 f6 4c 89 ff e8 52 15 fb ff 83 f8 00 0f 8c e6 02 00 00 74 04 <0f> 0b eb fe 48 8b 53 68 0f b6 43 70 48 85 d2 75 14 49 8b 54 c5
>>>> [75165.884002] RIP  [<ffffffffa02dede3>] do_relocation+0x163/0x44b [btrfs]
>>>> [75165.884002]  RSP <ffff8801026f7a08>
>>>>
>>>> (gdb) l *do_relocation+0x163
>>>> 0x58e07 is in do_relocation (fs/btrfs/relocation.c:2502).
>>>> 2497                            ret = btrfs_search_slot(trans, root, key, path, 0, 1);
>>>> 2498                            if (ret < 0) {
>>>> 2499                                    err = ret;
>>>> 2500                                    break;
>>>> 2501                            }
>>>> 2502                            BUG_ON(ret > 0);
>>>
>>> this translates btrfs_search_slot() result to
>>>
>>> 1600  * If the key isn't found, the path points to the slot where it should
>>> 1601  * be inserted, and 1 is returned.  If there are other errors during the
>>> 1602  * search a negative error number is returned.
>>>
>>> ie. the key is not in the tree. If you can reproduce it reliably, add
>>> some printks about the key and path's ->search_commit_root,
>>> ->skip_locking, and ->leave_spinning which are accessed within
>>> btrfs_search_slot().
>>
>> With the inode cache on, this is the expected result right now.  It is
>> changing the tree after the snapshot is taken, which isn't allowed.  I'm
>> hoping to nail it down this week.
>>
>> -chris
>>
> 
> 

