Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:44475 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbcLNOIW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 09:08:22 -0500
Date: Wed, 14 Dec 2016 15:08:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: [RFC] btrfs: lockdep says "possible recursive locking detected" in
 btrfs_clear_lock_blocking_rw()
Message-ID: <20161214140816.nxbl24r6upswyouh@linutronix.de>
References: <20161214140530.6534-1-bigeasy@linutronix.de>
 <20161214140530.6534-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161214140530.6534-2-bigeasy@linutronix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With lockdep enabled I managed to trigger the following lockdep splat:
| =============================================
| [ INFO: possible recursive locking detected ]
| 4.9.0-rt0 #804 Tainted: G        W      
| ---------------------------------------------
| kworker/u16:4/154 is trying to acquire lock:
|  (btrfs-fs-00){+.+...}, at: [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
| 
| but task is already holding lock:
|  (btrfs-fs-00){+.+...}, at: [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
| 
| other info that might help us debug this:
|  Possible unsafe locking scenario:
|
|        CPU0
|        ----
|   lock(btrfs-fs-00);
|   lock(btrfs-fs-00);
| 
|  *** DEADLOCK ***
|
|  May be due to missing lock nesting notation
|
| 6 locks held by kworker/u16:4/154:
|  #0:  ("%s-%s""btrfs", name){.+.+.+}, at: [<ffffffff8108af13>] process_one_work+0x1f3/0x7b0
|  #1:  ((&work->normal_work)){+.+.+.}, at: [<ffffffff8108af13>] process_one_work+0x1f3/0x7b0
|  #2:  (sb_internal){.+.+..}, at: [<ffffffff8132f7a1>] start_transaction+0x2f1/0x590
|  #3:  (btrfs-fs-02){+.+...}, at: [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
|  #4:  (btrfs-fs-01){+.+...}, at: [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
|  #5:  (btrfs-fs-00){+.+...}, at: [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
| 
| stack backtrace:
| CPU: 1 PID: 154 Comm: kworker/u16:4 Tainted: G        W       4.9.0-rt1+ #804
| Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
| Workqueue: btrfs-delalloc btrfs_delalloc_helper
|  ffffc9000123b7d0 ffffffff8141a2a5 ffffffff829d6db0 ffffffff829d6db0
|  ffffc9000123b890 ffffffff810c19dd 00000000000002fe 0000000000000006
|  000000003c272f80 ffffffff82308200 ce68145f590e60eb ffff880039c108c0
| Call Trace:
|  [<ffffffff8141a2a5>] dump_stack+0x86/0xc1
|  [<ffffffff810c19dd>] __lock_acquire+0x6dd/0x11d0
|  [<ffffffff810c2956>] lock_acquire+0x116/0x240
|  [<ffffffff818e0ed5>] rt_read_lock+0x45/0x60
|  [<ffffffff8136f0e1>] btrfs_clear_lock_blocking_rw+0x71/0x120
|  [<ffffffff812fec14>] btrfs_clear_path_blocking+0x94/0xb0
|  [<ffffffff8130706f>] btrfs_next_old_leaf+0x3df/0x420
|  [<ffffffff813070bb>] btrfs_next_leaf+0xb/0x10
|  [<ffffffff81344eeb>] __btrfs_drop_extents+0x1cb/0xd50
|  [<ffffffff81336161>] cow_file_range_inline+0x191/0x6c0
|  [<ffffffff81338364>] compress_file_range.constprop.68+0x314/0x710
|  [<ffffffff81338790>] async_cow_start+0x30/0x50
|  [<ffffffff813644dd>] btrfs_scrubparity_helper+0xfd/0x620
|  [<ffffffff81364b39>] btrfs_delalloc_helper+0x9/0x10
|  [<ffffffff8108af8e>] process_one_work+0x26e/0x7b0
|  [<ffffffff8108b516>] worker_thread+0x46/0x560
|  [<ffffffff81091c4e>] kthread+0xee/0x110
|  [<ffffffff818e166a>] ret_from_fork+0x2a/0x40

I can trigger it on -RT but it won't show up on a vanilla kernel. I
don't see obvious difference here (between RT and !RT). We do have more
preemption points and a spin_lock() does not disable preemption (so any
assumption on spin_lock() disabling preemption will fail).
With all btrfs events enabled, this did not trigger. With the following
patch

--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -41,6 +41,7 @@ void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
 	 */
 	if (eb->lock_nested && current->pid == eb->lock_owner)
 		return;
+	trace_printk("eb %p rw %d\n", eb, rw);
 	if (rw == BTRFS_WRITE_LOCK) {
 		if (atomic_read(&eb->blocking_writers) == 0) {
 			WARN_ON(atomic_read(&eb->spinning_writers) != 1);
@@ -73,6 +74,7 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 	if (eb->lock_nested && current->pid == eb->lock_owner)
 		return;
 
+	trace_printk("eb %p rw %d\n", eb, rw);
 	if (rw == BTRFS_WRITE_LOCK_BLOCKING) {
 		BUG_ON(atomic_read(&eb->blocking_writers) != 1);
 		write_lock(&eb->lock);

I manage to collect this (the last few lines from the kworker):

#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            |/  _-----=> need-resched_lazy
#                            || / _---=> hardirq/softirq
#                            ||| / _--=> preempt-depth
#                            |||| / _-=> preempt-lazy-depth
#                            ||||| / _-=> migrate-disable   
#                            |||||| /    delay
#           TASK-PID   CPU#  |||||||   TIMESTAMP  FUNCTION
#              | |       |   |||||||      |         |
   kworker/u16:4-154   [001] .....11    60.632361: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 1
   kworker/u16:4-154   [001] .......    60.632362: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 3
   kworker/u16:4-154   [001] .....11    60.632366: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 1
   kworker/u16:4-154   [001] .......    60.632367: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 3
   kworker/u16:4-154   [001] .....11    60.632367: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 1
   kworker/u16:4-154   [001] .......    60.632368: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 3
   kworker/u16:4-154   [001] .......    60.632369: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 3
   kworker/u16:4-154   [001] .....12    60.632371: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 1
   kworker/u16:4-154   [001] .....11    60.632372: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 1
   kworker/u16:4-154   [001] .......    60.632372: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 3
   kworker/u16:4-154   [001] .....11    60.632373: btrfs_clear_lock_blocking_rw: eb ffff880039ebb000 rw 3
   kworker/u16:4-154   [001] .....12    60.632376: btrfs_set_lock_blocking_rw: eb ffff880039104000 rw 1
   kworker/u16:4-154   [001] .....11    60.632377: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 1
   kworker/u16:4-154   [001] .......    60.632377: btrfs_clear_lock_blocking_rw: eb ffff880039ebb000 rw 3
   kworker/u16:4-154   [001] .....11    60.632378: btrfs_clear_lock_blocking_rw: eb ffff880039104000 rw 3
   kworker/u16:4-154   [001] .....12    60.632379: btrfs_set_lock_blocking_rw: eb ffff880039104000 rw 1
   kworker/u16:4-154   [001] .....11    60.632380: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 1
   kworker/u16:4-154   [001] .....11    60.632384: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 2
   kworker/u16:4-154   [001] .......    60.632384: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 4
   kworker/u16:4-154   [001] .....12    60.632386: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 2
   kworker/u16:4-154   [001] .....11    60.632387: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 2
   kworker/u16:4-154   [001] .......    60.632392: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 4
   kworker/u16:4-154   [001] .....11    60.632392: btrfs_clear_lock_blocking_rw: eb ffff880039ebb000 rw 4
   kworker/u16:4-154   [001] .....13    60.632395: btrfs_set_lock_blocking_rw: eb ffff880039104000 rw 2
   kworker/u16:4-154   [001] .....12    60.632395: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 2
   kworker/u16:4-154   [001] .....11    60.632396: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 2
   kworker/u16:4-154   [001] .......    60.632399: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 4
   kworker/u16:4-154   [001] .....11    60.632404: btrfs_clear_lock_blocking_rw: eb ffff880039ebb000 rw 4
   kworker/u16:4-154   [001] .....12    60.632404: btrfs_clear_lock_blocking_rw: eb ffff880039104000 rw 4
   kworker/u16:4-154   [001] .....13    60.632406: btrfs_set_lock_blocking_rw: eb ffff880039104000 rw 2
   kworker/u16:4-154   [001] .....12    60.632407: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 2
   kworker/u16:4-154   [001] .....11    60.632407: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 2
   kworker/u16:4-154   [001] .....11    60.632601: btrfs_set_lock_blocking_rw: eb ffff880039763c00 rw 2
   kworker/u16:4-154   [001] .......    60.632601: btrfs_set_lock_blocking_rw: eb ffff880039104000 rw 4
   kworker/u16:4-154   [001] .......    60.632602: btrfs_set_lock_blocking_rw: eb ffff880039ebb000 rw 4
   kworker/u16:4-154   [001] .......    60.632602: btrfs_set_lock_blocking_rw: eb ffff880039ebac00 rw 4
   kworker/u16:4-154   [001] .......    60.632602: btrfs_clear_lock_blocking_rw: eb ffff880039ebac00 rw 4
   kworker/u16:4-154   [001] .....11    60.632610: btrfs_clear_lock_blocking_rw: eb ffff880039ebb000 rw 4
   kworker/u16:4-154   [001] .....12    60.632611: btrfs_clear_lock_blocking_rw: eb ffff880039104000 rw 4
   kworker/u16:4-154   [001] .....13    60.632612: btrfs_clear_lock_blocking_rw: eb ffff880039763c00 rw 4

Could this be a wrong / missing lockdep annotation?

Sebastian
