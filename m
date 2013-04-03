Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:36835 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762021Ab3DCNr5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 09:47:57 -0400
Received: from [192.168.1.23] (unknown [192.168.1.23])
	by server.lolwut.org (Postfix) with ESMTPSA id 34F75512F3
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2013 09:47:54 -0400 (EDT)
Message-ID: <515C330B.3050005@lolwut.org>
Date: Wed, 03 Apr 2013 09:47:55 -0400
From: Kyle <lists@lolwut.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs-endio-wri periodically blocking
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On a server running Linux kernel 3.8.4-1-ARCH I'm periodically getting 
the following warnings (see below) while copying data onto the 
filesystem. The setup is btrfs -> LUKS -> md raid5 -> several regular 
HDDs. Interested to know if anyone has any info on what might cause this 
and whether it's harmful or not.

Thanks,

Kyle

00:00:33 kernel: INFO: task btrfs-endio-wri:1371 blocked for more than 
120 seconds.
00:00:33 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
00:00:33 kernel: btrfs-endio-wri D ffff8801cb4ae2f8     0  1371      2 
0x00000000
00:00:33 kernel:  ffff88013b76dc98 0000000000000046 ffff8801d5ed0000 
ffff88013b76dfd8
00:00:33 kernel:  ffff88013b76dfd8 ffff88013b76dfd8 ffff8801d5cc0860 
ffff8801d5ed0000
00:00:33 kernel:  ffff88013b76dc18 ffffffff81014570 ffff8801dfdd3f80 
0000000000000001
00:00:33 kernel: Call Trace:
00:00:33 kernel:  [<ffffffff81014570>] ? __switch_to+0x120/0x4e0
00:00:33 kernel:  [<ffffffff81088659>] ? finish_task_switch+0x49/0xe0
00:00:33 kernel:  [<ffffffffa03f1888>] ? tree_insert+0x58/0x70 [btrfs]
00:00:33 kernel:  [<ffffffffa03f11fb>] ? set_state_bits+0x4b/0x90 [btrfs]
00:00:33 kernel:  [<ffffffff814d1d59>] schedule+0x29/0x70
00:00:33 kernel:  [<ffffffffa03d8c25>] 
wait_current_trans.isra.28+0xa5/0xf0 [btrfs]
00:00:33 kernel:  [<ffffffff8107bff0>] ? abort_exclusive_wait+0xb0/0xb0
00:00:33 kernel:  [<ffffffffa03da418>] start_transaction+0x158/0x4a0 [btrfs]
00:00:33 kernel:  [<ffffffffa03f3824>] ? lock_extent_bits+0x74/0xa0 [btrfs]
00:00:33 kernel:  [<ffffffffa03da7d7>] btrfs_join_transaction+0x17/0x20 
[btrfs]
00:00:33 kernel:  [<ffffffffa03e2cca>] 
btrfs_finish_ordered_io+0x1aa/0x3f0 [btrfs]
00:00:33 kernel:  [<ffffffffa03e2f25>] finish_ordered_fn+0x15/0x20 [btrfs]
00:00:33 kernel:  [<ffffffffa040460d>] worker_loop+0x13d/0x570 [btrfs]
00:00:33 kernel:  [<ffffffff814d1d09>] ? preempt_schedule+0x49/0x70
00:00:33 kernel:  [<ffffffffa04044d0>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
00:00:33 kernel:  [<ffffffff8107b300>] kthread+0xc0/0xd0
00:00:33 kernel:  [<ffffffff81010000>] ? 
perf_trace_xen_mmu_set_pte_at+0x10/0x100
00:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
00:00:33 kernel:  [<ffffffff814da76c>] ret_from_fork+0x7c/0xb0
00:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
00:00:33 kernel: INFO: task btrfs-endio-wri:1380 blocked for more than 
120 seconds.
00:00:33 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
00:00:33 kernel: btrfs-endio-wri D ffff880193381850     0  1380      2 
0x00000000
00:00:33 kernel:  ffff88010cb5dc98 0000000000000046 ffff8801d5c87540 
ffff88010cb5dfd8
00:00:33 kernel:  ffff88010cb5dfd8 ffff88010cb5dfd8 ffff8801c4b629e0 
ffff8801d5c87540
00:00:33 kernel:  ffff88010cb5dc18 ffffffff81014570 ffff8801dfc93f80 
0000000000000001
00:00:33 kernel: Call Trace:
00:00:33 kernel:  [<ffffffff81014570>] ? __switch_to+0x120/0x4e0
00:00:33 kernel:  [<ffffffff81088659>] ? finish_task_switch+0x49/0xe0
00:00:33 kernel:  [<ffffffff81174758>] ? kmem_cache_free+0x38/0x1d0
00:00:33 kernel:  [<ffffffffa03f22fe>] ? free_extent_state+0x1e/0x30 [btrfs]
00:00:33 kernel:  [<ffffffffa03f1d24>] ? 
free_extent_state.part.33+0x34/0xb0 [btrfs]
00:00:33 kernel:  [<ffffffff814d1d59>] schedule+0x29/0x70
00:00:33 kernel:  [<ffffffffa03d8c25>] 
wait_current_trans.isra.28+0xa5/0xf0 [btrfs]
00:00:33 kernel:  [<ffffffff8107bff0>] ? abort_exclusive_wait+0xb0/0xb0
00:00:33 kernel:  [<ffffffffa03da418>] start_transaction+0x158/0x4a0 [btrfs]
00:00:33 kernel:  [<ffffffffa03f3824>] ? lock_extent_bits+0x74/0xa0 [btrfs]
00:00:33 kernel:  [<ffffffffa03da7d7>] btrfs_join_transaction+0x17/0x20 
[btrfs]
00:00:33 kernel:  [<ffffffffa03e2cca>] 
btrfs_finish_ordered_io+0x1aa/0x3f0 [btrfs]
00:00:33 kernel:  [<ffffffffa03e2f25>] finish_ordered_fn+0x15/0x20 [btrfs]
00:00:33 kernel:  [<ffffffffa040460d>] worker_loop+0x13d/0x570 [btrfs]
00:00:33 kernel:  [<ffffffff814d1d09>] ? preempt_schedule+0x49/0x70
00:00:33 kernel:  [<ffffffffa04044d0>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
00:00:33 kernel:  [<ffffffff8107b300>] kthread+0xc0/0xd0
00:00:33 kernel:  [<ffffffff81010000>] ? 
perf_trace_xen_mmu_set_pte_at+0x10/0x100
00:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
00:00:33 kernel:  [<ffffffff814da76c>] ret_from_fork+0x7c/0xb0
00:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
06:00:32 kernel: INFO: task btrfs-endio-wri:4162 blocked for more than 
120 seconds.
06:00:32 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
06:00:32 kernel: btrfs-endio-wri D ffff8801501e1940     0  4162      2 
0x00000000
06:00:32 kernel:  ffff8801501e1898 0000000000000046 ffff8801c9f410c0 
ffff8801501e1fd8
06:00:32 kernel:  ffff8801501e1fd8 ffff8801501e1fd8 ffffffff81815440 
ffff8801c9f410c0
06:00:32 kernel:  ffff8801501e1808 ffffffffa02b6783 ffff8801501e1808 
0000000053135079
06:00:32 kernel: Call Trace:
06:00:32 kernel:  [<ffffffffa02b6783>] ? dm_merge_bvec+0xb3/0x110 [dm_mod]
06:00:32 kernel:  [<ffffffffa03fbfd8>] ? submit_stripe_bio+0x58/0x80 [btrfs]
06:00:32 kernel:  [<ffffffffa0400b7f>] ? btrfs_map_bio+0x24f/0x400 [btrfs]
06:00:32 kernel:  [<ffffffff8101c9e9>] ? read_tsc+0x9/0x20
06:00:32 kernel:  [<ffffffff81123fd0>] ? __lock_page+0x70/0x70
06:00:32 kernel:  [<ffffffff814d1d59>] schedule+0x29/0x70
06:00:32 kernel:  [<ffffffff814d1e2f>] io_schedule+0x8f/0xd0
06:00:32 kernel:  [<ffffffff81123fde>] sleep_on_page+0xe/0x20
06:00:32 kernel:  [<ffffffff814cf870>] __wait_on_bit+0x60/0x90
06:00:32 kernel:  [<ffffffff81124270>] wait_on_page_bit+0x80/0x90
06:00:32 kernel:  [<ffffffff8107c030>] ? autoremove_wake_function+0x40/0x40
06:00:32 kernel:  [<ffffffffa03f86c5>] 
read_extent_buffer_pages+0x335/0x370 [btrfs]
06:00:32 kernel:  [<ffffffffa03d0c80>] ? 
verify_parent_transid+0x170/0x170 [btrfs]
06:00:32 kernel:  [<ffffffffa03d29d1>] 
btree_read_extent_buffer_pages.constprop.117+0xb1/0x110 [btrfs]
06:00:32 kernel:  [<ffffffffa03d324a>] read_tree_block+0x3a/0x50 [btrfs]
06:00:32 kernel:  [<ffffffffa03b61b4>] 
read_block_for_search.isra.47+0x134/0x410 [btrfs]
06:00:32 kernel:  [<ffffffffa03b593b>] ? 
generic_bin_search.constprop.49+0x6b/0x180 [btrfs]
06:00:32 kernel:  [<ffffffffa03b86a4>] btrfs_search_slot+0x2b4/0x780 [btrfs]
06:00:32 kernel:  [<ffffffffa041af8b>] ? tree_insert+0x7b/0xa0 [btrfs]
06:00:32 kernel:  [<ffffffffa03cd436>] btrfs_lookup_csum+0x76/0x180 [btrfs]
06:00:32 kernel:  [<ffffffffa03ce720>] btrfs_csum_file_blocks+0xd0/0x6c0 
[btrfs]
06:00:32 kernel:  [<ffffffffa03b332a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
06:00:32 kernel:  [<ffffffffa03dec2d>] ? 
insert_reserved_file_extent.constprop.58+0x8d/0x2c0 [btrfs]
06:00:32 kernel:  [<ffffffffa03ede09>] ? try_merge_map+0x49/0x200 [btrfs]
06:00:32 kernel:  [<ffffffffa03dd445>] 
add_pending_csums.isra.43+0x45/0x60 [btrfs]
06:00:32 kernel:  [<ffffffffa03e2d5b>] 
btrfs_finish_ordered_io+0x23b/0x3f0 [btrfs]
06:00:32 kernel:  [<ffffffffa03e2f25>] finish_ordered_fn+0x15/0x20 [btrfs]
06:00:32 kernel:  [<ffffffffa040460d>] worker_loop+0x13d/0x570 [btrfs]
06:00:32 kernel:  [<ffffffffa04044d0>] ? btrfs_queue_worker+0x320/0x320 
[btrfs]
06:00:32 kernel:  [<ffffffff8107b300>] kthread+0xc0/0xd0
06:00:33 kernel:  [<ffffffff81010000>] ? 
perf_trace_xen_mmu_set_pte_at+0x10/0x100
06:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
06:00:33 kernel:  [<ffffffff814da76c>] ret_from_fork+0x7c/0xb0
06:00:33 kernel:  [<ffffffff8107b240>] ? 
kthread_freezable_should_stop+0x70/0x70
