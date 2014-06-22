Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41150 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaFVJcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 05:32:53 -0400
Received: from mfilter13-d.gandi.net (mfilter13-d.gandi.net [217.70.178.141])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 5C41141C061
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Jun 2014 11:32:51 +0200 (CEST)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter13-d.gandi.net (mfilter13-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id fHDUK3wxSB7P for <linux-btrfs@vger.kernel.org>;
	Sun, 22 Jun 2014 11:32:48 +0200 (CEST)
Received: from zafu.localnet (AMontpellier-256-1-58-48.w90-28.abo.wanadoo.fr [90.28.25.48])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 2684241C054
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Jun 2014 11:32:47 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: New BTRFS kernel issues in 3.15.1-1-ARCH
Date: Sun, 22 Jun 2014 11:32:42 +0200
Message-ID: <1551998.5rGUV05DNv@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Got this kernel issue today while rsyncing (backup) 2 BTRFS filesystems. I had 
never seen this on those disks before upgrading to kernel 3.15.1-1-ARCH a 
couple days ago...

Both disks seem to be physically healthy AFAIK.


juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:1:37 blocked for more than 
120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:1    D 0000000000000000     0    37      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: btrfs-delalloc normal_work_helper 
[btrfs]
juin 22 10:56:10 zafu kernel:  ffff88011843f828 0000000000000046 ffff8800d87832f0 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff88011843ffd8 0000000000014700 ffff8800d87832f0 
ffff88011843f7b0
juin 22 10:56:10 zafu kernel:  ffffffffa0101ade 0000000000000000 0000000000000000 
0000000000000000
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa0101ade>] ? scsi_request_fn+0x3e/0x4b0 
[scsi_mod]
juin 22 10:56:10 zafu kernel:  [<ffffffff8101ce09>] ? read_tsc+0x9/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff810d4868>] ? ktime_get_ts+0x48/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff810fec35>] ? delayacct_end+0x95/0xc0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8126ab44>] ? blk_finish_plug+0x14/0x50
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffff8113fadc>] find_lock_entry+0x4c/0x80
juin 22 10:56:10 zafu kernel:  [<ffffffff81140714>] find_or_create_page+0x34/0xa0
juin 22 10:56:10 zafu kernel:  [<ffffffffa0359cf6>] 
io_ctl_prepare_pages+0x56/0x170 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa035c8d5>] 
__load_free_space_cache+0x1e5/0x660 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa035ce4c>] 
load_free_space_cache+0xfc/0x1c0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa02fbd22>] cache_block_group+0x1a2/0x3c0 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1bd0>] ? __wake_up_sync+0x20/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa030417a>] find_free_extent+0x61a/0xc70 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0304982>] 
btrfs_reserve_extent+0x62/0x140 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031e653>] cow_file_range+0x133/0x420 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031f9ed>] 
submit_compressed_extents+0x20d/0x490 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031d394>] ? async_cow_free+0x24/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031fc70>] ? 
submit_compressed_extents+0x490/0x490 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031fcf6>] async_cow_submit+0x86/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0347b55>] normal_work_helper+0x205/0x350 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086ccc>] worker_thread+0x22c/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:6:723 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:6    D 0000000000000000     0   723      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juin 22 10:56:10 zafu kernel:  ffff8800b7b6bb08 0000000000000046 ffff880116f65180 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff8800b7b6bfd8 0000000000014700 ffff880116f65180 
ffff8800b7b6bad0
juin 22 10:56:10 zafu kernel:  ffffffffa031f622 0000000000000000 ffffffff00000050 
ffff8800b7b6bb8c
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa031f622>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffffa033371e>] ? flush_write_bio+0xe/0x10 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff8114120d>] 
__filemap_fdatawrite_range+0x5d/0x80
juin 22 10:56:10 zafu kernel:  [<ffffffff811412f3>] 
filemap_fdatawrite_range+0x13/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa03326d9>] 
btrfs_wait_ordered_range+0x49/0x150 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031d3cb>] 
btrfs_run_delalloc_work+0x2b/0xa0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03479c7>] normal_work_helper+0x77/0x350 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task btrfs-transacti:1600 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: btrfs-transacti D 0000000000000001     0  1600      
2 0x00000000
juin 22 10:56:10 zafu kernel:  ffff88000864bc20 0000000000000046 ffff8800a3fc5bb0 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff88000864bfd8 0000000000014700 ffff8800a3fc5bb0 
0000000000000000
juin 22 10:56:10 zafu kernel:  ffff88000864bb98 ffffffff8118cd91 ffff8800a3fc5bb0 
0000000000000000
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffff8118cd91>] ? 
alloc_pages_current+0xb1/0x160
juin 22 10:56:10 zafu kernel:  [<ffffffff81195c80>] ? new_slab+0x220/0x330
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81508c09>] schedule_timeout+0x1b9/0x240
juin 22 10:56:10 zafu kernel:  [<ffffffff81083414>] ? wake_up_worker+0x24/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a4df>] wait_for_common+0xcf/0x190
juin 22 10:56:10 zafu kernel:  [<ffffffff8109e0f0>] ? wake_up_process+0x50/0x50
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a5bd>] wait_for_completion+0x1d/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa0327d86>] 
btrfs_wait_and_free_delalloc_work+0x16/0x30 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03320c8>] 
btrfs_run_ordered_operations+0x1f8/0x2e0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0316720>] 
btrfs_flush_all_pending_stuffs+0x50/0x70 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03176ce>] 
btrfs_commit_transaction+0x22e/0xa20 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0313415>] 
transaction_kthread+0x1e5/0x250 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0313230>] ? 
btrfs_cleanup_transaction+0x5a0/0x5a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task rsync:1642 blocked for more than 120 
seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: rsync           D 0000000000000000     0  1642      
1 0x00000004
juin 22 10:56:10 zafu kernel:  ffff880008747ba8 0000000000000086 ffff8800a3fc5180 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff880008747fd8 0000000000014700 ffff8800a3fc5180 
00000000002c0000
juin 22 10:56:10 zafu kernel:  0000000001e94000 ffff8800a3fc5180 ffff880008747ba0 
ffff880112163800
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa02ff91d>] ? 
reserve_metadata_bytes+0x28d/0x970 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa032f669>] ? 
btrfs_get_token_16+0x119/0x140 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffffa0316a6f>] 
wait_current_trans.isra.18+0xcf/0x120 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1bd0>] ? __wake_up_sync+0x20/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa03182d9>] start_transaction+0x419/0x5c0 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031849b>] 
btrfs_start_transaction+0x1b/0x20 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03253b9>] btrfs_rename+0x199/0x7d0 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8119b562>] ? 
__kmalloc_track_caller+0x32/0x1b0
juin 22 10:56:10 zafu kernel:  [<ffffffff811c483f>] vfs_rename+0x58f/0x710
juin 22 10:56:10 zafu kernel:  [<ffffffff811bea80>] ? lookup_dcache+0x30/0xc0
juin 22 10:56:10 zafu kernel:  [<ffffffff811c5b2b>] SyS_renameat2+0x4cb/0x540
juin 22 10:56:10 zafu kernel:  [<ffffffff81212f07>] ? get_acl+0x17/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff811b6b21>] ? __sb_end_write+0x31/0x60
juin 22 10:56:10 zafu kernel:  [<ffffffff811d2d71>] ? mnt_drop_write+0x31/0x50
juin 22 10:56:10 zafu kernel:  [<ffffffff811b1db3>] ? chmod_common+0xe3/0x160
juin 22 10:56:10 zafu kernel:  [<ffffffff811d3ff4>] ? mntput+0x24/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffff811bdeee>] ? path_put+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff811b32a2>] ? SyS_fchmodat+0x62/0xc0
juin 22 10:56:10 zafu kernel:  [<ffffffff811c5bde>] SyS_rename+0x1e/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff815159a9>] system_call_fastpath+0x16/0x1b
juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:8:1648 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:8    D 0000000000000000     0  1648      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juin 22 10:56:10 zafu kernel:  ffff880100d57b08 0000000000000046 ffff88004e8d5bb0 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff880100d57fd8 0000000000014700 ffff88004e8d5bb0 
ffff880100d57ad0
juin 22 10:56:10 zafu kernel:  ffffffffa031f622 0000000000000000 ffffffff00000050 
ffff880100d57b8c
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa031f622>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffffa033371e>] ? flush_write_bio+0xe/0x10 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff810a1585>] ? sched_clock_cpu+0xb5/0xe0
juin 22 10:56:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff8114120d>] 
__filemap_fdatawrite_range+0x5d/0x80
juin 22 10:56:10 zafu kernel:  [<ffffffff811412f3>] 
filemap_fdatawrite_range+0x13/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa03326d9>] 
btrfs_wait_ordered_range+0x49/0x150 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031d3cb>] 
btrfs_run_delalloc_work+0x2b/0xa0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03479c7>] normal_work_helper+0x77/0x350 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:9:1649 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:9    D 0000000000000000     0  1649      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: writeback bdi_writeback_workfn (flush-
btrfs-5)
juin 22 10:56:10 zafu kernel:  ffff8801043039b8 0000000000000046 ffff88004e8d1e90 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff880104303fd8 0000000000014700 ffff88004e8d1e90 
0000000100000000
juin 22 10:56:10 zafu kernel:  0000000100000000 0000000000000000 
0000000089c75617 ffff880118fda800
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffff810ab01d>] ? load_balance+0x19d/0x8e0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff811def80>] 
__writeback_single_inode+0x40/0x2b0
juin 22 10:56:10 zafu kernel:  [<ffffffff811e048a>] 
writeback_sb_inodes+0x26a/0x430
juin 22 10:56:10 zafu kernel:  [<ffffffff811e06ef>] 
__writeback_inodes_wb+0x9f/0xd0
juin 22 10:56:10 zafu kernel:  [<ffffffff811e094b>] wb_writeback+0x22b/0x360
juin 22 10:56:10 zafu kernel:  [<ffffffff811ce031>] ? get_nr_inodes+0x51/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff811e0f1f>] 
bdi_writeback_workfn+0x33f/0x4c0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:10:1651 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:10   D 0000000000000000     0  1651      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juin 22 10:56:10 zafu kernel:  ffff88000495fb08 0000000000000046 ffff88004e8d0000 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff88000495ffd8 0000000000014700 ffff88004e8d0000 
ffff88000495fad0
juin 22 10:56:10 zafu kernel:  ffffffffa031f622 0000000000000000 ffffffff00000050 
ffff88000495fb8c
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa031f622>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8101ce09>] ? read_tsc+0x9/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff810d4868>] ? ktime_get_ts+0x48/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff810fec35>] ? delayacct_end+0x95/0xc0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffffa033371e>] ? flush_write_bio+0xe/0x10 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff8114120d>] 
__filemap_fdatawrite_range+0x5d/0x80
juin 22 10:56:10 zafu kernel:  [<ffffffff811412f3>] 
filemap_fdatawrite_range+0x13/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa03326d9>] 
btrfs_wait_ordered_range+0x49/0x150 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031d3cb>] 
btrfs_run_delalloc_work+0x2b/0xa0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03479c7>] normal_work_helper+0x77/0x350 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel: INFO: task kworker/u4:12:1653 blocked for more 
than 120 seconds.
juin 22 10:56:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:56:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:56:10 zafu kernel: kworker/u4:12   D 0000000000000000     0  1653      
2 0x00000000
juin 22 10:56:10 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juin 22 10:56:10 zafu kernel:  ffff880004d83b08 0000000000000046 ffff88004e8d32f0 
0000000000014700
juin 22 10:56:10 zafu kernel:  ffff880004d83fd8 0000000000014700 ffff88004e8d32f0 
ffff880004d83ad0
juin 22 10:56:10 zafu kernel:  ffffffffa031f622 0000000000000000 ffffffff00000050 
ffff880004d83b8c
juin 22 10:56:10 zafu kernel: Call Trace:
juin 22 10:56:10 zafu kernel:  [<ffffffffa031f622>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:56:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:56:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:56:10 zafu kernel:  [<ffffffffa033371e>] ? flush_write_bio+0xe/0x10 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:56:10 zafu kernel:  [<ffffffff8114120d>] 
__filemap_fdatawrite_range+0x5d/0x80
juin 22 10:56:10 zafu kernel:  [<ffffffff811412f3>] 
filemap_fdatawrite_range+0x13/0x20
juin 22 10:56:10 zafu kernel:  [<ffffffffa03326d9>] 
btrfs_wait_ordered_range+0x49/0x150 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa031d3cb>] 
btrfs_run_delalloc_work+0x2b/0xa0 [btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffffa03479c7>] normal_work_helper+0x77/0x350 
[btrfs]
juin 22 10:56:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:56:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:56:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:56:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:56:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:58:10 zafu kernel: INFO: task kworker/u4:1:37 blocked for more than 
120 seconds.
juin 22 10:58:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:58:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:58:10 zafu kernel: kworker/u4:1    D 0000000000000000     0    37      
2 0x00000000
juin 22 10:58:10 zafu kernel: Workqueue: btrfs-delalloc normal_work_helper 
[btrfs]
juin 22 10:58:10 zafu kernel:  ffff88011843f828 0000000000000046 ffff8800d87832f0 
0000000000014700
juin 22 10:58:10 zafu kernel:  ffff88011843ffd8 0000000000014700 ffff8800d87832f0 
ffff88011843f7b0
juin 22 10:58:10 zafu kernel:  ffffffffa0101ade 0000000000000000 0000000000000000 
0000000000000000
juin 22 10:58:10 zafu kernel: Call Trace:
juin 22 10:58:10 zafu kernel:  [<ffffffffa0101ade>] ? scsi_request_fn+0x3e/0x4b0 
[scsi_mod]
juin 22 10:58:10 zafu kernel:  [<ffffffff8101ce09>] ? read_tsc+0x9/0x20
juin 22 10:58:10 zafu kernel:  [<ffffffff810d4868>] ? ktime_get_ts+0x48/0xf0
juin 22 10:58:10 zafu kernel:  [<ffffffff810fec35>] ? delayacct_end+0x95/0xc0
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:58:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:58:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:58:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:58:10 zafu kernel:  [<ffffffff8126ab44>] ? blk_finish_plug+0x14/0x50
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:58:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:58:10 zafu kernel:  [<ffffffff8113fadc>] find_lock_entry+0x4c/0x80
juin 22 10:58:10 zafu kernel:  [<ffffffff81140714>] find_or_create_page+0x34/0xa0
juin 22 10:58:10 zafu kernel:  [<ffffffffa0359cf6>] 
io_ctl_prepare_pages+0x56/0x170 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa035c8d5>] 
__load_free_space_cache+0x1e5/0x660 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa035ce4c>] 
load_free_space_cache+0xfc/0x1c0 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa02fbd22>] cache_block_group+0x1a2/0x3c0 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffff810b1bd0>] ? __wake_up_sync+0x20/0x20
juin 22 10:58:10 zafu kernel:  [<ffffffffa030417a>] find_free_extent+0x61a/0xc70 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa0304982>] 
btrfs_reserve_extent+0x62/0x140 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031e653>] cow_file_range+0x133/0x420 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031f9ed>] 
submit_compressed_extents+0x20d/0x490 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031d394>] ? async_cow_free+0x24/0x30 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031fc70>] ? 
submit_compressed_extents+0x490/0x490 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031fcf6>] async_cow_submit+0x86/0x90 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa0347b55>] normal_work_helper+0x205/0x350 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:58:10 zafu kernel:  [<ffffffff81086ccc>] worker_thread+0x22c/0x3e0
juin 22 10:58:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:58:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:58:10 zafu kernel: INFO: task kworker/u4:6:723 blocked for more 
than 120 seconds.
juin 22 10:58:10 zafu kernel:       Tainted: G           O  3.15.1-1-ARCH #1
juin 22 10:58:10 zafu kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
juin 22 10:58:10 zafu kernel: kworker/u4:6    D 0000000000000000     0   723      
2 0x00000000
juin 22 10:58:10 zafu kernel: Workqueue: btrfs-flush_delalloc 
normal_work_helper [btrfs]
juin 22 10:58:10 zafu kernel:  ffff8800b7b6bb08 0000000000000046 ffff880116f65180 
0000000000014700
juin 22 10:58:10 zafu kernel:  ffff8800b7b6bfd8 0000000000014700 ffff880116f65180 
ffff8800b7b6bad0
juin 22 10:58:10 zafu kernel:  ffffffffa031f622 0000000000000000 ffffffff00000050 
ffff8800b7b6bb8c
juin 22 10:58:10 zafu kernel: Call Trace:
juin 22 10:58:10 zafu kernel:  [<ffffffffa031f622>] ? 
run_delalloc_range+0x192/0x350 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f6f0>] ? filemap_fdatawait+0x30/0x30
juin 22 10:58:10 zafu kernel:  [<ffffffff81509a19>] schedule+0x29/0x70
juin 22 10:58:10 zafu kernel:  [<ffffffff81509d04>] io_schedule+0x94/0xf0
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f6fe>] sleep_on_page+0xe/0x20
juin 22 10:58:10 zafu kernel:  [<ffffffff8150a1f8>] __wait_on_bit_lock+0x48/0xb0
juin 22 10:58:10 zafu kernel:  [<ffffffff8113f858>] __lock_page+0x78/0x90
juin 22 10:58:10 zafu kernel:  [<ffffffff810b1c10>] ? 
autoremove_wake_function+0x40/0x40
juin 22 10:58:10 zafu kernel:  [<ffffffffa033371e>] ? flush_write_bio+0xe/0x10 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa0337c08>] 
extent_write_cache_pages.isra.28.constprop.46+0x258/0x3a0 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa033917c>] extent_writepages+0x5c/0x90 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031b960>] ? 
__btrfs_submit_bio_start_direct_io+0x40/0x40 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031a678>] btrfs_writepages+0x28/0x30 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffff8114cf2e>] do_writepages+0x1e/0x30
juin 22 10:58:10 zafu kernel:  [<ffffffff8114120d>] 
__filemap_fdatawrite_range+0x5d/0x80
juin 22 10:58:10 zafu kernel:  [<ffffffff811412f3>] 
filemap_fdatawrite_range+0x13/0x20
juin 22 10:58:10 zafu kernel:  [<ffffffffa03326d9>] 
btrfs_wait_ordered_range+0x49/0x150 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa031d3cb>] 
btrfs_run_delalloc_work+0x2b/0xa0 [btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffffa03479c7>] normal_work_helper+0x77/0x350 
[btrfs]
juin 22 10:58:10 zafu kernel:  [<ffffffff81086178>] process_one_work+0x168/0x450
juin 22 10:58:10 zafu kernel:  [<ffffffff81086bd2>] worker_thread+0x132/0x3e0
juin 22 10:58:10 zafu kernel:  [<ffffffff81086aa0>] ? 
manage_workers.isra.23+0x2d0/0x2d0
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d3ca>] kthread+0xea/0x100
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0
juin 22 10:58:10 zafu kernel:  [<ffffffff815158fc>] ret_from_fork+0x7c/0xb0
juin 22 10:58:10 zafu kernel:  [<ffffffff8108d2e0>] ? 
kthread_create_on_node+0x1a0/0x1a0

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

