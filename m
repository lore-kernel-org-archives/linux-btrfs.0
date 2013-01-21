Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:43376 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3AURFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 12:05:41 -0500
Received: from [192.168.2.123] (unknown [149.241.149.45])
	by smtp.webfaction.com (Postfix) with ESMTP id 0259620878F3
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 11:05:39 -0600 (CST)
From: Richard Cooper <richard@richardcooper.net>
Content-Type: text/plain; charset=us-ascii
Subject: kernel BUG at fs/btrfs/extent-tree.c:5151
Date: Mon, 21 Jan 2013 17:05:38 +0000
Message-Id: <84D737DF-717D-4ACE-B739-612B5209C1FD@richardcooper.net>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1085)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I have has a machine doesn't get on with btrfs at all. I've been using it as a testbed for several months and it never seems to last more than a couple of weeks before FS corruption.

My versions are:
- OS - CentOS 6.3
- Kernel - 3.7.1-2 from http://elrepo.org/tiki/kernel-ml 
- btrfs-progs - v0.20-rc1-37-g91d9eec. Built from git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

The /var/log/messages log for the latest failure is given below.

Two things of note:
1. The btrfs device is sitting on top of a 16.3 TB, 7 partition software RAID 5 array. The bug seems to have occurred during a md data-check on that device. By default CentOS 6 does these checks every week.
2. After I rebooted the server the first thing I did was try to unmount the btrfs device. However the umount command hangs in an uninterruptible sleep in btrfs_error_commit_super.

Thoughts?

- Richard

Jan 20 11:30:04 backup3 kernel: leaf 556658688 total ptrs 102 free space 851
Jan 20 11:30:04 backup3 kernel: 	item 0 key (5846384640 b8 282234880) itemoff 3991 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
Jan 20 11:30:04 backup3 kernel: 	item 1 key (5846384640 b8 369684480) itemoff 3987 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
[snip a bunch of similar lines]
Jan 20 11:30:04 backup3 kernel: 	item 32 key (5846384640 b8 225396207616) itemoff 3863 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
Jan 20 11:30:04 backup3 kernel: 	item 33 key (5846429696 a8 65536) itemoff 3797 itemsize 66
Jan 20 11:30:04 backup3 kernel: 		extent refs 35 gen 40 flags 1
Jan 20 11:30:04 backup3 kernel: 		extent data backref root 257 objectid 172094 offset 0 count 1
Jan 20 11:30:04 backup3 kernel: 		shared data backref parent 73255260160 count 1
Jan 20 11:30:04 backup3 kernel: 	item 34 key (5846429696 b8 282234880) itemoff 3793 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
[snip a bunch of similar lines]
Jan 20 11:30:04 backup3 kernel: 	item 67 key (5846495232 a8 77824) itemoff 3599 itemsize 66
Jan 20 11:30:04 backup3 kernel: 		extent refs 35 gen 40 flags 1
Jan 20 11:30:04 backup3 kernel: 		extent data backref root 257 objectid 172091 offset 0 count 1
Jan 20 11:30:04 backup3 kernel: 		shared data backref parent 73255256064 count 1
Jan 20 11:30:04 backup3 kernel: 	item 68 key (5846495232 b8 282222592) itemoff 3595 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
[snip a bunch of similar lines]
Jan 20 11:30:04 backup3 kernel: 	item 100 key (5846495232 b8 225396203520) itemoff 3467 itemsize 4
Jan 20 11:30:04 backup3 kernel: 		shared data backref count 1
Jan 20 11:30:04 backup3 kernel: 	item 101 key (5846573056 a8 90112) itemoff 3401 itemsize 66
Jan 20 11:30:04 backup3 kernel: 		extent refs 36 gen 40 flags 1
Jan 20 11:30:04 backup3 kernel: 		extent data backref root 257 objectid 172096 offset 0 count 1
Jan 20 11:30:04 backup3 kernel: 		shared data backref parent 73255260160 count 1
Jan 20 11:30:04 backup3 kernel: ------------[ cut here ]------------
Jan 20 11:30:04 backup3 kernel: WARNING: at fs/btrfs/extent-tree.c:5134 __btrfs_free_extent+0x714/0x860 [btrfs]()
Jan 20 11:30:04 backup3 kernel: Hardware name: MS-7522
Jan 20 11:30:04 backup3 kernel: Modules linked in: btrfs libcrc32c ipv6 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables gpio_ich iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 lpc_ich r8169 mii sg i7core_edac edac_core ext4 mbcache jbd2 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 sd_mod crc_t10dif pata_acpi ata_generic pata_jmicron ahci libahci nouveau ttm drm_kms_helper hwmon mxm_wmi video wmi dm_mirror dm_region_hash dm_log dm_mod
Jan 20 11:30:04 backup3 kernel: Pid: 25973, comm: btrfs-cleaner Not tainted 3.7.1-2.el6.elrepo.x86_64 #1
Jan 20 11:30:04 backup3 kernel: Call Trace:
Jan 20 11:30:04 backup3 kernel: [<ffffffff8105715f>] warn_slowpath_common+0x7f/0xc0
Jan 20 11:30:04 backup3 kernel: [<ffffffff810571ba>] warn_slowpath_null+0x1a/0x20
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477384>] __btrfs_free_extent+0x714/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477799>] run_delayed_data_ref+0x159/0x160 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa047785a>] run_one_delayed_ref+0xba/0xc0 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477976>] run_clustered_refs+0x116/0x370 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477ca0>] btrfs_run_delayed_refs+0xd0/0x300 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0488894>] btrfs_should_end_transaction+0x44/0x90 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0478c84>] btrfs_drop_snapshot+0x3b4/0x610 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff815aee05>] ? __schedule+0x3f5/0x710
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0487121>] btrfs_clean_old_snapshots+0xb1/0x180 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483dad>] cleaner_kthread+0xad/0x130 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483d00>] ? btree_readpage_end_io_hook+0x290/0x290 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b27e>] kthread+0xce/0xe0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b8aec>] ret_from_fork+0x7c/0xb0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: ---[ end trace 76460cc5695320a8 ]---
Jan 20 11:30:04 backup3 kernel: btrfs unable to find ref byte nr 5846573056 parent 224853127168 root 0  owner 172096 offset 0
Jan 20 11:30:04 backup3 kernel: ------------[ cut here ]------------
Jan 20 11:30:04 backup3 kernel: kernel BUG at fs/btrfs/extent-tree.c:5151!
Jan 20 11:30:04 backup3 kernel: invalid opcode: 0000 [#1] SMP 
Jan 20 11:30:04 backup3 kernel: Modules linked in: btrfs libcrc32c ipv6 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables gpio_ich iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 lpc_ich r8169 mii sg i7core_edac edac_core ext4 mbcache jbd2 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 sd_mod crc_t10dif pata_acpi ata_generic pata_jmicron ahci libahci nouveau ttm drm_kms_helper hwmon mxm_wmi video wmi dm_mirror dm_region_hash dm_log dm_mod
Jan 20 11:30:04 backup3 kernel: CPU 3 
Jan 20 11:30:04 backup3 kernel: Pid: 25973, comm: btrfs-cleaner Tainted: G        W    3.7.1-2.el6.elrepo.x86_64 #1 MSI MS-7522/MSI X58 Pro-E (MS-7522)
Jan 20 11:30:04 backup3 kernel: RIP: 0010:[<ffffffffa04773f6>]  [<ffffffffa04773f6>] __btrfs_free_extent+0x786/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: RSP: 0018:ffff88031eb7faa8  EFLAGS: 00010297
Jan 20 11:30:04 backup3 kernel: RAX: 0000000000000004 RBX: ffff88025ddd2910 RCX: 0000000000000000
Jan 20 11:30:04 backup3 kernel: RDX: ffff880301f2a000 RSI: 000000000000007a RDI: ffff880194cf5b60
Jan 20 11:30:04 backup3 kernel: RBP: ffff88031eb7fb88 R08: 0000000000000004 R09: ffff88031eb7fa48
Jan 20 11:30:04 backup3 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
Jan 20 11:30:04 backup3 kernel: R13: 00000000fffffffe R14: 000000015c7ba000 R15: ffff880194cf5b60
Jan 20 11:30:04 backup3 kernel: FS:  0000000000000000(0000) GS:ffff88033fc60000(0000) knlGS:0000000000000000
Jan 20 11:30:04 backup3 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 20 11:30:04 backup3 kernel: CR2: 00007f98baba10a0 CR3: 0000000001a0b000 CR4: 00000000000007e0
Jan 20 11:30:04 backup3 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 20 11:30:04 backup3 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 20 11:30:04 backup3 kernel: Process btrfs-cleaner (pid: 25973, threadinfo ffff88031eb7e000, task ffff880330126100)
Jan 20 11:30:04 backup3 kernel: Stack:
Jan 20 11:30:04 backup3 kernel: 000000000002a040 0000000000000000 000000000002a040 0000000000000000
Jan 20 11:30:04 backup3 kernel: ffff880300000000 000000012d7c1ed8 ffff88032dacf800 ffff880200000042
Jan 20 11:30:04 backup3 kernel: 0000000100000000 ffff88032dacf800 0000000000016000 ffff88032fd22800
Jan 20 11:30:04 backup3 kernel: Call Trace:
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477799>] run_delayed_data_ref+0x159/0x160 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa047785a>] run_one_delayed_ref+0xba/0xc0 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477976>] run_clustered_refs+0x116/0x370 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477ca0>] btrfs_run_delayed_refs+0xd0/0x300 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0488894>] btrfs_should_end_transaction+0x44/0x90 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0478c84>] btrfs_drop_snapshot+0x3b4/0x610 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff815aee05>] ? __schedule+0x3f5/0x710
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0487121>] btrfs_clean_old_snapshots+0xb1/0x180 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483dad>] cleaner_kthread+0xad/0x130 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483d00>] ? btree_readpage_end_io_hook+0x290/0x290 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b27e>] kthread+0xce/0xe0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b8aec>] ret_from_fork+0x7c/0xb0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: Code: e8 10 8f ff ff 39 45 20 0f 84 77 fd ff ff 0f 0b eb fe 0f 0b 90 eb fd 0f 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 0f 0b eb fe <0f> 0b 0f 1f 84 00 00 00 00 00 eb f6 89 c6 4c 89 f2 31 c0 48 c7 
Jan 20 11:30:04 backup3 kernel: RIP  [<ffffffffa04773f6>] __btrfs_free_extent+0x786/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: RSP <ffff88031eb7faa8>
Jan 20 11:30:04 backup3 kernel: ---[ end trace 76460cc5695320a9 ]---
Jan 20 11:30:04 backup3 kernel: BUG: unable to handle kernel paging request at 000000000000264b
Jan 20 11:30:04 backup3 kernel: IP: [<ffffffffa01f448a>] jbd2__journal_start+0x4a/0x100 [jbd2]
Jan 20 11:30:04 backup3 kernel: PGD 0 
Jan 20 11:30:04 backup3 kernel: Oops: 0000 [#2] SMP 
Jan 20 11:30:04 backup3 kernel: Modules linked in: btrfs libcrc32c ipv6 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables gpio_ich iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode pcspkr i2c_i801 lpc_ich r8169 mii sg i7core_edac edac_core ext4 mbcache jbd2 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 sd_mod crc_t10dif pata_acpi ata_generic pata_jmicron ahci libahci nouveau ttm drm_kms_helper hwmon mxm_wmi video wmi dm_mirror dm_region_hash dm_log dm_mod
Jan 20 11:30:04 backup3 kernel: CPU 3 
Jan 20 11:30:04 backup3 kernel: Pid: 25973, comm: btrfs-cleaner Tainted: G      D W    3.7.1-2.el6.elrepo.x86_64 #1 MSI MS-7522/MSI X58 Pro-E (MS-7522)
Jan 20 11:30:04 backup3 kernel: RIP: 0010:[<ffffffffa01f448a>]  [<ffffffffa01f448a>] jbd2__journal_start+0x4a/0x100 [jbd2]
Jan 20 11:30:04 backup3 kernel: RSP: 0018:ffff88031eb7f3d8  EFLAGS: 00010286
Jan 20 11:30:04 backup3 kernel: RAX: 000000000000264b RBX: ffff88012d7c1ed8 RCX: 0000000000000018
Jan 20 11:30:04 backup3 kernel: RDX: 0000000000000050 RSI: 0000000000000002 RDI: ffff88032dab6800
Jan 20 11:30:04 backup3 kernel: RBP: ffff88031eb7f408 R08: 0000000000000040 R09: 0000000000000001
Jan 20 11:30:04 backup3 kernel: R10: ffff88031eb7ffd8 R11: 0000000000000000 R12: ffff88032dab6800
Jan 20 11:30:04 backup3 kernel: R13: ffff880330126100 R14: 0000000000000002 R15: 0000000000161900
Jan 20 11:30:04 backup3 kernel: FS:  0000000000000000(0000) GS:ffff88033fc60000(0000) knlGS:0000000000000000
Jan 20 11:30:04 backup3 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 20 11:30:04 backup3 kernel: CR2: 000000000000264b CR3: 0000000001a0b000 CR4: 00000000000007e0
Jan 20 11:30:04 backup3 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 20 11:30:04 backup3 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 20 11:30:04 backup3 kernel: Process btrfs-cleaner (pid: 25973, threadinfo ffff88031eb7e000, task ffff880330126100)
Jan 20 11:30:04 backup3 kernel: Stack:
Jan 20 11:30:04 backup3 kernel: 0000000000000018 ffff88033f032000 ffff880308d87850 ffff88032e7e3c00
Jan 20 11:30:04 backup3 kernel: 0000000000000002 ffffffffa0223da7 ffff88031eb7f418 ffffffffa01f4553
Jan 20 11:30:04 backup3 kernel: ffff88031eb7f448 ffffffffa0240307 ffff880308d87850 ffff880308d87850
Jan 20 11:30:04 backup3 kernel: Call Trace:
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0223da7>] ? ext4_dirty_inode+0x27/0x60 [ext4]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa01f4553>] jbd2_journal_start+0x13/0x20 [jbd2]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0240307>] ext4_journal_start_sb+0x77/0x140 [ext4]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0223da7>] ext4_dirty_inode+0x27/0x60 [ext4]
Jan 20 11:30:04 backup3 kernel: [<ffffffff811a5dbf>] __mark_inode_dirty+0x3f/0x230
Jan 20 11:30:04 backup3 kernel: [<ffffffff81196491>] update_time+0x81/0xc0
Jan 20 11:30:04 backup3 kernel: [<ffffffff81196568>] file_update_time+0x98/0xe0
Jan 20 11:30:04 backup3 kernel: [<ffffffff810bdbb9>] ? kallsyms_lookup+0x69/0xf0
Jan 20 11:30:04 backup3 kernel: [<ffffffff81123a38>] __generic_file_aio_write+0x188/0x3b0
Jan 20 11:30:04 backup3 kernel: [<ffffffff81123cdf>] generic_file_aio_write+0x7f/0x100
Jan 20 11:30:04 backup3 kernel: [<ffffffffa021cd69>] ext4_file_write+0x49/0xe0 [ext4]
Jan 20 11:30:04 backup3 kernel: [<ffffffff812d0136>] ? vgacon_scroll+0x136/0x350
Jan 20 11:30:04 backup3 kernel: [<ffffffff8117d4ca>] do_sync_write+0xaa/0xf0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8101b949>] ? read_tsc+0x9/0x20
Jan 20 11:30:04 backup3 kernel: [<ffffffff810be608>] do_acct_process+0x458/0x560
Jan 20 11:30:04 backup3 kernel: [<ffffffff810be785>] acct_process+0x75/0xa0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8105d4cd>] do_exit+0x31d/0x470
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b134c>] oops_end+0xac/0xf0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8101784b>] die+0x5b/0x90
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b0ea3>] do_trap+0xc3/0x170
Jan 20 11:30:04 backup3 kernel: [<ffffffff81015705>] do_invalid_op+0x95/0xb0
Jan 20 11:30:04 backup3 kernel: [<ffffffffa04773f6>] ? __btrfs_free_extent+0x786/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff81059239>] ? console_unlock+0x169/0x290
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b9b9e>] invalid_op+0x1e/0x30
Jan 20 11:30:04 backup3 kernel: [<ffffffffa04773f6>] ? __btrfs_free_extent+0x786/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0476f28>] ? __btrfs_free_extent+0x2b8/0x860 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477799>] run_delayed_data_ref+0x159/0x160 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa047785a>] run_one_delayed_ref+0xba/0xc0 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477976>] run_clustered_refs+0x116/0x370 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0477ca0>] btrfs_run_delayed_refs+0xd0/0x300 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0488894>] btrfs_should_end_transaction+0x44/0x90 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0478c84>] btrfs_drop_snapshot+0x3b4/0x610 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff815aee05>] ? __schedule+0x3f5/0x710
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0487121>] btrfs_clean_old_snapshots+0xb1/0x180 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483dad>] cleaner_kthread+0xad/0x130 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffffa0483d00>] ? btree_readpage_end_io_hook+0x290/0x290 [btrfs]
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b27e>] kthread+0xce/0xe0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: [<ffffffff815b8aec>] ret_from_fork+0x7c/0xb0
Jan 20 11:30:04 backup3 kernel: [<ffffffff8107b1b0>] ? kthread_freezable_should_stop+0x70/0x70
Jan 20 11:30:04 backup3 kernel: Code: 8b 2c 25 40 c6 00 00 48 85 ff 49 89 fc 41 89 f6 49 8b 85 f0 07 00 00 48 c7 c3 e2 ff ff ff 74 18 48 85 c0 48 89 c3 74 29 48 8b 00 <48> 3b 38 0f 85 a9 00 00 00 83 43 0c 01 48 89 d8 4c 8b 65 e8 48 
Jan 20 11:30:04 backup3 kernel: RIP  [<ffffffffa01f448a>] jbd2__journal_start+0x4a/0x100 [jbd2]
Jan 20 11:30:04 backup3 kernel: RSP <ffff88031eb7f3d8>
Jan 20 11:30:04 backup3 kernel: CR2: 000000000000264b
Jan 20 11:30:04 backup3 kernel: ---[ end trace 76460cc5695320aa ]---
Jan 20 11:30:04 backup3 kernel: Fixing recursive fault but reboot is needed!
Jan 20 11:45:12 backup3 kernel: md: md4: data-check done.

