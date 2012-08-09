Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:17478 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031087Ab2HIPgS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2012 11:36:18 -0400
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (josoe mo54) (RZmta 30.7 AUTH)
	with ESMTPA id N04d84o79ENmBg for <linux-btrfs@vger.kernel.org>;
	Thu, 9 Aug 2012 17:36:16 +0200 (CEST)
Message-ID: <5023D8F0.8080505@giantdisaster.de>
Date: Thu, 09 Aug 2012 17:36:16 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] kernel stack overflow on mount
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This issue happens every time I want to mount one particular filesystem.

To create the filesystem, I was using 'mkfs.btrfs -d raid1 -m raid1', mounted it and copied the kernel sources into the filesystem, then ran 'btrfs balance', 'btrfs dev add' and 'btrfs dev del'. The last step was the dev del. The result were thousands of "btrfs: found 1 extents" lines over more than two hours from the shrinking, until I ran a 'shutdown -r'. This way I got a filesystem that makes the kernel crash on every attempt to mount it.

We allocate about 6KB of stack memory when I compare the stack pointers in btrfs_mount and btrfs_map_bio. The call trace in the kernel log shows that afterwards we enter the block layer with this almost fully occupied stack, and that's too much and crashes the system.

Here's the output of {int i; printk("%s, stack@ 0x%p\n", __FUNCTION__, &i);} added to the beginning of some functions:
btrfs_mount, stack@ 0xffff880232d95d74   -> stack used = 0x0
open_ctree, stack@ 0xffff880232d95c9c    -> stack used = 0xd8
btrfs_recover_relocation, stack@ 0xffff880232d95b44    -> stack used = 0x230
btrfs_evict_inode, stack@ 0xffff880232d95974    -> stack used = 0x400
btrfs_truncate_inode_items, stack@ 0xffff880232d95904    -> stack used = 0x470
btrfs_alloc_free_block, stack@ 0xffff880232d95634    -> stack used = 0x740
btrfs_alloc_chunk, stack@ 0xffff880232d954a4    -> stack used = 0x8d0
btrfs_make_block_group, stack@ 0xffff880232d95334    -> stack used = 0xa40
btrfs_alloc_free_block, stack@ 0xffff880232d95044    -> stack used = 0xd30
cache_block_group, stack@ 0xffff880232d94e24    -> stack used = 0xf50
load_free_space_cache, stack@ 0xffff880232d94d94    -> stack used = 0xfe0
__load_free_space_cache, stack@ 0xffff880232d94d24    -> stack used = 0x1050
extent_readpages, stack@ 0xffff880232d94aa4    -> stack used = 0x12d0
submit_one_bio, stack@ 0xffff880232d947f4    -> stack used = 0x1580
btrfs_map_bio, stack@ 0xffff880232d94724    -> stack used = 0x1650


The crash happens whenever I run mount on that filesystem (with chris' for-linus of today.):
btrfs fi show
Label: none  uuid: fcfc60c4-d94f-443d-8a7a-ce50c0b8d5e7
        Total devices 3 FS bytes used 1.17GB
        devid    2 size 1.56GB used 1.56GB path /dev/sdu
        devid    1 size 1.56GB used 1.56GB path /dev/sdt
        devid    3 size 931.51GB used 360.00MB path /dev/sdm
mount /dev/sdu /mnt2

The kernel log:
[  319.854542] BUG: sleeping function called from invalid context at block/cfq-iosched.c:3806
[  319.953493] BUG: unable to handle kernel paging request at 000000010504d780
[  320.036989] IP: [<ffffffff810b5d0c>] cpuacct_charge+0x7c/0x110
[  320.106878] PGD 22a9fd067 PUD 0
[  320.145669] Thread overran stack, or stack corrupted
[  320.205054] Oops: 0000 [#1] SMP
[  320.243848] CPU 2
[  320.265790] Modules linked in:[  320.302399]  btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class [last unloaded: scsi_wait_scan]
[  320.506031] Pid: 3669, comm: mount Not tainted 3.5.0+ #84 Supermicro X8SIL/X8SIL
[  320.594846] RIP: 0010:[<ffffffff810b5d0c>]  [<ffffffff810b5d0c>] cpuacct_charge+0x7c/0x110
[  320.693854] RSP: 0018:ffff880236a03c28  EFLAGS: 00010082
[  320.757398] RAX: 00000000001d5b28 RBX: 0000000005f06218 RCX: 000000000001a000
[  320.842783] RDX: ffffffff821cbe40 RSI: 0000000000000018 RDI: ffff880234c6a3a0
[  320.928166] RBP: ffff880236a03c58 R08: 0000000000000004 R09: 0000000000000001
[  321.013550] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880234c6a3a0
[  321.098935] R13: 000000003062a048 R14: ffff880234c6a3a0 R15: ffff880234c6a3a0
[  321.184319] FS:  00007ffb7f96e7e0(0000) GS:ffff880236a00000(0000) knlGS:0000000000000000
[  321.281144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  321.349887] CR2: 000000010504d780 CR3: 000000022c71c000 CR4: 00000000000007e0
[  321.435270] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  321.520655] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  321.606038] Process mount (pid: 3669, threadinfo ffff88023062a000, task ffff880234c6a3a0)
[  321.703903] Stack:
[  321.727926]  ffffffff810b5cb3 ffffffff810b25de ffff880234c6aae8 ffff880234c6a3e8
[  321.816845]  0000000005f06218 ffff880236bd2e38 ffff880236a03ca8 ffffffff810b7dc9
[  321.905765]  0000000000000000 00000000fd211531 ffffffff81e26ee0 ffff880234c6a3e8
[  321.994685] Call Trace:
[  322.023910]  <IRQ>
[  322.046895]  [<ffffffff810b5cb3>] ? cpuacct_charge+0x23/0x110
[  322.117929]  [<ffffffff810b25de>] ? scheduler_tick+0x4e/0x140
[  322.186673]  [<ffffffff810b7dc9>] update_curr+0x109/0x1c0
[  322.251255]  [<ffffffff810b872b>] task_tick_fair+0xab/0x130
[  322.317919]  [<ffffffff810b2662>] scheduler_tick+0xd2/0x140
[  322.384584]  [<ffffffff8108fbe9>] update_process_times+0x69/0x80
[  322.456449]  [<ffffffff810d26df>] tick_sched_timer+0x5f/0xc0
[  322.524151]  [<ffffffff810a674c>] __run_hrtimer+0x7c/0x210
[  322.589776]  [<ffffffff810d2680>] ? tick_nohz_handler+0xf0/0xf0
[  322.660600]  [<ffffffff810a7047>] hrtimer_interrupt+0xf7/0x240
[  322.730386]  [<ffffffff81065731>] hpet_interrupt_handler+0x11/0x30
[  322.804329]  [<ffffffff8110fb06>] handle_irq_event_percpu+0x76/0x270
[  322.880353]  [<ffffffff8110fd43>] handle_irq_event+0x43/0x70
[  322.948056]  [<ffffffff8111246f>] handle_edge_irq+0x6f/0x110
[  323.015761]  [<ffffffff81041018>] handle_irq+0x58/0x140
[  323.078265]  [<ffffffff810871e6>] ? irq_enter+0x16/0x90
[  323.140768]  [<ffffffff81040c85>] do_IRQ+0x55/0xd0
[  323.198074]  [<ffffffff819297ac>] common_interrupt+0x6c/0x6c
[  323.265774]  <EOI>
[  323.288758]  [<ffffffff810da8fe>] ? mark_held_locks+0x7e/0x140
[  323.360831]  [<ffffffff81080686>] ? vprintk_emit+0x1a6/0x4a0
[  323.428536]  [<ffffffff8191c127>] printk+0x5c/0x5e
[  323.485841]  [<ffffffff814165d0>] ? check_blkcg_changed+0x130/0x130
[  323.560823]  [<ffffffff810ae2ec>] __might_sleep+0x8c/0x110
[  323.626447]  [<ffffffff81416903>] cfq_set_request+0x333/0x460
[  323.695194]  [<ffffffff8118446b>] ? kmem_cache_alloc+0xeb/0x170
[  323.766017]  [<ffffffff81143460>] ? mempool_alloc_slab+0x10/0x20
[  323.837879]  [<ffffffff81143756>] ? mempool_alloc+0x56/0x160
[  323.905585]  [<ffffffff813ffcee>] ? get_request+0x25e/0x670
[  323.972249]  [<ffffffff810daabd>] ? trace_hardirqs_on_caller+0xfd/0x190
[  324.051391]  [<ffffffff813f9d39>] elv_set_request+0x19/0x20
[  324.118055]  [<ffffffff813ffd53>] get_request+0x2c3/0x670
[  324.182639]  [<ffffffff81404001>] ? disk_stack_limits+0x31/0x70
[  324.253464]  [<ffffffff8140012c>] get_request_wait+0x2c/0x250
[  324.322209]  [<ffffffff81404081>] ? ioc_lookup_icq+0x21/0x100
[  324.390952]  [<ffffffff81412f0f>] ? cfq_merge+0x7f/0xc0
[  324.453455]  [<ffffffff813f9759>] ? elv_merge+0xd9/0xe0
[  324.515960]  [<ffffffff8140126f>] blk_queue_bio+0x6f/0x400
[  324.581584]  [<ffffffff810d5195>] ? lock_release_holdtime.part.25+0x15/0x190
[  324.665927]  [<ffffffff813fd9a2>] generic_make_request+0xc2/0x100
[  324.738830]  [<ffffffff813fda53>] submit_bio+0x73/0xf0
[  324.800308]  [<ffffffffa0104ab6>] ? __btrfs_map_block+0x236/0x6a0 [btrfs]
[  324.881528]  [<ffffffffa0141f3d>] btrfsic_submit_bio+0x1bd/0x320 [btrfs]
[  324.961711]  [<ffffffffa01048cc>] ? __btrfs_map_block+0x4c/0x6a0 [btrfs]
[  325.041896]  [<ffffffffa0105158>] btrfs_map_bio+0x178/0x210 [btrfs]
[  325.116880]  [<ffffffffa00e2e6f>] btrfs_submit_bio_hook+0x7f/0x180 [btrfs]
[  325.199145]  [<ffffffffa00f6e97>] submit_one_bio+0x67/0xa0 [btrfs]
[  325.273088]  [<ffffffffa00f6f9f>] submit_extent_page+0xcf/0x1c0 [btrfs]
[  325.352232]  [<ffffffffa00fd77d>] __extent_read_full_page+0x4dd/0x690 [btrfs]
[  325.437616]  [<ffffffffa00fc7c0>] ? extent_writepages+0x60/0x60 [btrfs]
[  325.516759]  [<ffffffffa00e9940>] ? btrfs_lookup+0x60/0x60 [btrfs]
[  325.590704]  [<ffffffffa00e9940>] ? btrfs_lookup+0x60/0x60 [btrfs]
[  325.664648]  [<ffffffffa00fdd0f>] extent_readpages+0xff/0x1c0 [btrfs]
[  325.741711]  [<ffffffffa00e393a>] btrfs_readpages+0x1a/0x20 [btrfs]
[  325.816688]  [<ffffffff8114c6c2>] __do_page_cache_readahead+0x232/0x2f0
[  325.895832]  [<ffffffff8114c561>] ? __do_page_cache_readahead+0xd1/0x2f0
[  325.976016]  [<ffffffff810dab5d>] ? trace_hardirqs_on+0xd/0x10
[  326.045800]  [<ffffffff8114c8fc>] ra_submit+0x1c/0x20
[  326.106223]  [<ffffffff8114ca06>] ondemand_readahead+0x106/0x2d0
[  326.178087]  [<ffffffff81183dc8>] ? __kmalloc+0xf8/0x1b0
[  326.241641]  [<ffffffffa00f7c8a>] ? free_extent_buffer+0x1a/0x90 [btrfs]
[  326.321815]  [<ffffffff8114cc9f>] page_cache_sync_readahead+0x2f/0x50
[  326.398887]  [<ffffffffa011aa0f>] __load_free_space_cache+0x1cf/0x680 [btrfs]
[  326.484272]  [<ffffffffa011b0b9>] load_free_space_cache+0x109/0x1c0 [btrfs]
[  326.567574]  [<ffffffffa00cd22c>] cache_block_group+0x19c/0x3a0 [btrfs]
[  326.646718]  [<ffffffffa00d0271>] ? find_free_extent+0x871/0xc80 [btrfs]
[  326.726895]  [<ffffffff810a2c50>] ? __init_waitqueue_head+0x60/0x60
[  326.801885]  [<ffffffffa00cfd8d>] find_free_extent+0x38d/0xc80 [btrfs]
[  326.879988]  [<ffffffffa00c39cf>] ? btrfs_reduce_alloc_profile+0x7f/0x120 [btrfs]
[  326.969534]  [<ffffffffa00d0727>] btrfs_reserve_extent+0xa7/0x250 [btrfs]
[  327.050756]  [<ffffffffa00d098d>] btrfs_alloc_free_block+0xbd/0x390 [btrfs]
[  327.134061]  [<ffffffffa00bc3bf>] __btrfs_cow_block+0x11f/0x500 [btrfs]
[  327.213199]  [<ffffffff810d5195>] ? lock_release_holdtime.part.25+0x15/0x190
[  327.297547]  [<ffffffffa00bcd9f>] btrfs_cow_block+0xef/0x220 [btrfs]
[  327.373572]  [<ffffffffa00bfcc8>] btrfs_search_slot+0x3e8/0x8c0 [btrfs]
[  327.452716]  [<ffffffffa00c0bb4>] btrfs_insert_empty_items+0x84/0xe0 [btrfs]
[  327.537061]  [<ffffffffa00c0c73>] btrfs_insert_item+0x63/0xe0 [btrfs]
[  327.614125]  [<ffffffffa00d10d4>] btrfs_make_block_group+0x254/0x330 [btrfs]
[  327.698472]  [<ffffffffa01056b0>] __btrfs_alloc_chunk+0x4c0/0x780 [btrfs]
[  327.779687]  [<ffffffff81184640>] ? kmem_cache_free+0x150/0x160
[  327.850520]  [<ffffffffa01059d7>] btrfs_alloc_chunk+0x67/0xa0 [btrfs]
[  327.927582]  [<ffffffffa00c70fc>] do_chunk_alloc+0x2bc/0x4a0 [btrfs]
[  328.003605]  [<ffffffffa00d06f1>] btrfs_reserve_extent+0x71/0x250 [btrfs]
[  328.084830]  [<ffffffffa00d098d>] btrfs_alloc_free_block+0xbd/0x390 [btrfs]
[  328.168136]  [<ffffffffa00f68b3>] ? read_extent_buffer+0xb3/0x110 [btrfs]
[  328.249351]  [<ffffffff810b5f75>] ? sched_clock_cpu+0xc5/0x120
[  328.319141]  [<ffffffffa00bc3bf>] __btrfs_cow_block+0x11f/0x500 [btrfs]
[  328.398279]  [<ffffffff810d5195>] ? lock_release_holdtime.part.25+0x15/0x190
[  328.482628]  [<ffffffffa00bcd9f>] btrfs_cow_block+0xef/0x220 [btrfs]
[  328.558653]  [<ffffffffa00bfcc8>] btrfs_search_slot+0x3e8/0x8c0 [btrfs]
[  328.637800]  [<ffffffffa00e4d6f>] btrfs_truncate_inode_items+0x15f/0x7c0 [btrfs]
[  328.726295]  [<ffffffff810daabd>] ? trace_hardirqs_on_caller+0xfd/0x190
[  328.805447]  [<ffffffffa00e0baa>] ? start_transaction+0x8a/0x3b0 [btrfs]
[  328.885631]  [<ffffffffa00e557c>] btrfs_evict_inode+0x1ac/0x320 [btrfs]
[  328.964768]  [<ffffffff81929446>] ? _raw_spin_unlock+0x26/0x40
[  329.034552]  [<ffffffff811a517f>] evict+0xaf/0x1b0
[  329.091856]  [<ffffffff811a5385>] iput+0x105/0x210
[  329.149167]  [<ffffffffa00e911f>] btrfs_orphan_cleanup+0x1df/0x450 [btrfs]
[  329.231431]  [<ffffffffa00dc540>] ? btrfs_read_fs_root_no_name+0x2d0/0x2f0 [btrfs]
[  329.322016]  [<ffffffffa0124bdc>] btrfs_recover_relocation+0x3ac/0x460 [btrfs]
[  329.408438]  [<ffffffffa00d789e>] ? btrfs_cleanup_fs_roots+0x2e/0xa0 [btrfs]
[  329.492784]  [<ffffffffa00de06d>] open_ctree+0x1b0d/0x1db0 [btrfs]
[  329.566723]  [<ffffffffa00b5e35>] btrfs_mount+0x415/0x500 [btrfs]
[  329.639624]  [<ffffffff811604b3>] ? pcpu_alloc+0x8e3/0x9e0
[  329.705247]  [<ffffffff811a861a>] ? alloc_vfsmnt+0x9a/0x1b0
[  329.771912]  [<ffffffff8118e95e>] mount_fs+0x3e/0x1b0
[  329.832335]  [<ffffffff811a8636>] ? alloc_vfsmnt+0xb6/0x1b0
[  329.898999]  [<ffffffff811a87d3>] vfs_kern_mount+0x63/0x100
[  329.965662]  [<ffffffff811a8f8f>] do_kern_mount+0x4f/0x100
[  330.031289]  [<ffffffff811aa79c>] do_mount+0x19c/0x870
[  330.092751]  [<ffffffff8115ac46>] ? memdup_user+0x46/0x90
[  330.157336]  [<ffffffff8115ace3>] ? strndup_user+0x53/0x70
[  330.222960]  [<ffffffff811aafab>] sys_mount+0x8b/0xe0
[  330.283384]  [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
[  330.355247] Code: e2 81 48 c7 04 24 b3 5c 0b 81 e8 80 42 02 00 49 8b 84 24 d0 11 00 00 48 8b 50 48 48 85 d2 74 2f 4d 63 ed 0f 1f 40 00 48 8b 42 70 <4a> 03 04 ed 40 d5 ef 81 48 01 18 48 8b 02 48 8b 40 40 48 85 c0
[  330.587789] RIP  [<ffffffff810b5d0c>] cpuacct_charge+0x7c/0x110
[  330.658719]  RSP <ffff880236a03c28>
[  330.700421] CR2: 000000010504d780
[  330.740049] ---[ end trace 4d49e8d087691a79 ]---
[  330.795270] Kernel panic - not syncing: Fatal exception in interrupt
[  331.904101] Shutting down cpus with NMI
