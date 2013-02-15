Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:41740 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3BOTDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 14:03:19 -0500
Received: from sim by peace.netnation.com with local (Exim 4.80)
	(envelope-from <sim@netnation.com>)
	id 1U6QZ4-0004Wg-04
	for linux-btrfs@vger.kernel.org; Fri, 15 Feb 2013 11:03:18 -0800
Date: Fri, 15 Feb 2013 11:03:17 -0800
From: Simon Kirby <sim@hostway.ca>
To: linux-btrfs@vger.kernel.org
Subject: [3.8-rc7] Locking issues on snapshot cleanup?
Message-ID: <20130215190317.GB3962@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were having a problem with I/O to one btrfs volume on a 3.8-rc6 box
hanging completely with no CPU usage or I/O (according to iostat, iotop).
Here is after a reboot to 3.8-rc7 with lockdep enabled:

[  317.024264] btrfs: disk space caching is enabled
[  526.036161] INFO: task btrfs-cleaner:5281 blocked for more than 120 seconds.
[  526.036256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  526.036354] btrfs-cleaner   D ffff8804224d44c0     0  5281      2 0x00000000
[  526.036543]  ffff88040be83498 0000000000000046 ffff8804224d44c0 ffff88040be83fd8
[  526.036841]  ffff88040be83fd8 ffff88040be83fd8 ffffffff81ad2440 ffff8804224d44c0
[  526.037138]  0000000000000006 ffff8804224d44c0 ffff88040be83418 ffffffff810a4471
[  526.037434] Call Trace:
[  526.037519]  [<ffffffff810a4471>] ? mark_held_locks+0x91/0x120
[  526.037605]  [<ffffffff817b93ba>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[  526.037689]  [<ffffffff810a46fd>] ? trace_hardirqs_on+0xd/0x10
[  526.037771]  [<ffffffff817b7b44>] schedule+0x24/0x70
[  526.037855]  [<ffffffff8136ec45>] btrfs_tree_lock+0xc5/0x260
[  526.037938]  [<ffffffff81074d00>] ? __init_waitqueue_head+0x60/0x60
[  526.038020]  [<ffffffff8132b3b4>] btrfs_init_new_buffer+0x84/0x160
[  526.038101]  [<ffffffff8132b566>] btrfs_alloc_free_block+0xd6/0x370
[  526.038184]  [<ffffffff81317c13>] __btrfs_cow_block+0x123/0x510
[  526.038266]  [<ffffffff8108757f>] ? local_clock+0x6f/0x80
[  526.038346]  [<ffffffff813181cf>] btrfs_cow_block+0x11f/0x1d0
[  526.038427]  [<ffffffff8131c30f>] btrfs_search_slot+0x1af/0x780
[  526.038507]  [<ffffffff81087498>] ? sched_clock_cpu+0xa8/0x120
[  526.038589]  [<ffffffff81321f1f>] lookup_inline_extent_backref+0x9f/0x4c0
[  526.038672]  [<ffffffff810872f5>] ? sched_clock_local+0x25/0xa0
[  526.038753]  [<ffffffff81324daa>] __btrfs_free_extent+0xca/0x8c0
[  526.038834]  [<ffffffff813291fd>] run_clustered_refs+0x4ad/0xbc0
[  526.038915]  [<ffffffff8132d260>] btrfs_run_delayed_refs+0xc0/0x2f0
[  526.038997]  [<ffffffff8132d540>] btrfs_write_dirty_block_groups+0xb0/0x640
[  526.039079]  [<ffffffff8132d449>] ? btrfs_run_delayed_refs+0x2a9/0x2f0
[  526.039161]  [<ffffffff817b1dd8>] commit_cowonly_roots+0x155/0x227
[  526.039244]  [<ffffffff8133d23d>] ? btrfs_commit_transaction+0x5ad/0xb00
[  526.039326]  [<ffffffff8133d273>] btrfs_commit_transaction+0x5e3/0xb00
[  526.039408]  [<ffffffff81074d00>] ? __init_waitqueue_head+0x60/0x60
[  526.039490]  [<ffffffff817b9246>] ? _raw_spin_unlock+0x26/0x30
[  526.039570]  [<ffffffff8133dbc2>] __btrfs_end_transaction+0x3a2/0x3f0
[  526.039653]  [<ffffffff8133dc2e>] btrfs_end_transaction_throttle+0xe/0x10
[  526.039735]  [<ffffffff8132bbe4>] btrfs_drop_snapshot+0x3e4/0x5d0
[  526.039816]  [<ffffffff8133e58f>] btrfs_clean_old_snapshots+0x9f/0x140
[  526.039898]  [<ffffffff81335078>] ? cleaner_kthread+0x88/0x110
[  526.039979]  [<ffffffff8133508c>] cleaner_kthread+0x9c/0x110
[  526.040107]  [<ffffffff81334ff0>] ? transaction_kthread+0x230/0x230
[  526.040203]  [<ffffffff81074226>] kthread+0xd6/0xe0
[  526.040286]  [<ffffffff81074150>] ? __init_kthread_worker+0x70/0x70
[  526.040373]  [<ffffffff817c14fc>] ret_from_fork+0x7c/0xb0
[  526.040455]  [<ffffffff81074150>] ? __init_kthread_worker+0x70/0x70
[  526.040537] 5 locks held by btrfs-cleaner/5281:
[  526.040612]  #0:  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffff81335078>] cleaner_kthread+0x88/0x110
[  526.040971]  #1:  (sb_internal#2){.+.+..}, at: [<ffffffff8133deee>] start_transaction+0x2ae/0x470
[  526.041389]  #2:  (&fs_info->reloc_mutex){+.+...}, at: [<ffffffff8133d1bf>] btrfs_commit_transaction+0x52f/0xb00
[  526.041746]  #3:  (&fs_info->tree_log_mutex){+.+...}, at: [<ffffffff8133d23d>] btrfs_commit_transaction+0x5ad/0xb00
[  526.042116]  #4:  (&head_ref->mutex){+.+...}, at: [<ffffffff8137e9e7>] btrfs_delayed_ref_lock+0x37/0x130
[  526.042473] INFO: task btrfs-transacti:5282 blocked for more than 120 seconds.
[  526.042568] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  526.042665] btrfs-transacti D ffff880410d0e098     0  5282      2 0x00000000
[  526.042861]  ffff88040bdf9d08 0000000000000046 ffff8804224d2260 ffff88040bdf9fd8
[  526.043163]  ffff88040bdf9fd8 ffff88040bdf9fd8 ffffffff81ad2440 ffff8804224d2260
[  526.043459]  0000000000000006 ffff8804224d2260 ffff88040bdf9c88 ffffffff810a4471
[  526.043756] Call Trace:
[  526.043846]  [<ffffffff810a4471>] ? mark_held_locks+0x91/0x120
[  526.043928]  [<ffffffff817b93ba>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[  526.044043]  [<ffffffff810a46fd>] ? trace_hardirqs_on+0xd/0x10
[  526.044129]  [<ffffffff817b7b44>] schedule+0x24/0x70
[  526.044209]  [<ffffffff8133c635>] wait_current_trans.isra.28+0xa5/0xf0
[  526.044300]  [<ffffffff81074d00>] ? __init_waitqueue_head+0x60/0x60
[  526.044382]  [<ffffffff8133dd98>] start_transaction+0x158/0x470
[  526.044464]  [<ffffffff8133e0c2>] btrfs_attach_transaction+0x12/0x20
[  526.044546]  [<ffffffff81334efe>] transaction_kthread+0x13e/0x230
[  526.044628]  [<ffffffff81334dc0>] ? btrfs_alloc_root+0x50/0x50
[  526.044709]  [<ffffffff81074226>] kthread+0xd6/0xe0
[  526.044807]  [<ffffffff81074150>] ? __init_kthread_worker+0x70/0x70
[  526.044891]  [<ffffffff817c14fc>] ret_from_fork+0x7c/0xb0
[  526.044976]  [<ffffffff81074150>] ? __init_kthread_worker+0x70/0x70
[  526.045059] 1 lock held by btrfs-transacti/5282:
[  526.045135]  #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at: [<ffffffff81334ea7>] transaction_kthread+0xe7/0x230

...These hung task warnings repeat with no change. A "du" on the mount
point hangs.

Incidentally, a btrfsck without --repair prints a big number of errors.
btrfsck with --repair just prints:

checking extents
leaf parent key incorrect 9308887371776
bad block 9308887371776
btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
Abort

Full non-repair output here: http://0x.ca/sim/ref/3.8-rc7/btrfsck_sdf.log

Simon-
