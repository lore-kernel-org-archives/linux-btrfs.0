Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:54124 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbcAODHk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 22:07:40 -0500
Date: Thu, 14 Jan 2016 22:07:31 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: use-after-free in perf_trace_btrfs__work
Message-ID: <20160115030731.GA24109@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just hit a bunch of instances of this spew..
This is on Linus' tree from a few hours ago

==================================================================
BUG: KASAN: use-after-free in perf_trace_btrfs__work+0x1b1/0x2a0 [btrfs] at addr ffff8800b7ea2e60
Read of size 8 by task trinity-c14/6745
=============================================================================
BUG kmalloc-256 (Not tainted): kasan: bad access detected
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Allocated in btrfs_wq_submit_bio+0xd1/0x300 [btrfs] age=63 cpu=1 pid=6745
	___slab_alloc.constprop.70+0x4de/0x580
	__slab_alloc.isra.67.constprop.69+0x48/0x80
	kmem_cache_alloc_trace+0x24c/0x2e0
	btrfs_wq_submit_bio+0xd1/0x300 [btrfs]
	btrfs_submit_bio_hook+0x118/0x260 [btrfs]
	neigh_sysctl_register+0x201/0x360
	devinet_sysctl_register+0x73/0xe0
	inetdev_init+0x119/0x1f0
	inetdev_event+0x5b3/0x7e0
	notifier_call_chain+0x4e/0xd0
	raw_notifier_call_chain+0x16/0x20
	call_netdevice_notifiers_info+0x3d/0x70
	register_netdevice+0x62d/0x730
	register_netdev+0x1a/0x30
	loopback_net_init+0x5d/0xd0
	ops_init+0x5b/0x1e0
INFO: Freed in run_one_async_free+0x12/0x20 [btrfs] age=177 cpu=1 pid=8018
	__slab_free+0x19e/0x2d0
	kfree+0x24e/0x270
	run_one_async_free+0x12/0x20 [btrfs]
	btrfs_scrubparity_helper+0x38d/0x740 [btrfs]
	btrfs_worker_helper+0xe/0x10 [btrfs]
	process_one_work+0x417/0xa40
	worker_thread+0x8b/0x730
	kthread+0x199/0x1c0
	ret_from_fork+0x3f/0x70
INFO: Slab 0xffffea0002dfa800 objects=28 used=28 fp=0x          (null) flags=0x4000000000004080
INFO: Object 0xffff8800b7ea2da0 @offset=11680 fp=0xffff8800b7ea2480

Bytes b4 ffff8800b7ea2d90: 99 59 4f 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  .YO.....ZZZZZZZZ
Object ffff8800b7ea2da0: 10 2e ea b7 00 88 ff ff 00 00 00 00 01 00 00 00  ................
Object ffff8800b7ea2db0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2dc0: 10 2e ea b7 00 88 ff ff a0 29 a6 bd ff ff ff ff  .........)......
Object ffff8800b7ea2dd0: f0 a3 ab 68 03 88 ff ff a8 1d b0 b0 03 88 ff ff  ...h............
Object ffff8800b7ea2de0: f0 2d ea b7 00 88 ff ff 80 32 ea b7 00 88 ff ff  .-.......2......
Object ffff8800b7ea2df0: 08 01 20 1c 04 88 ff ff 00 00 00 00 00 00 00 00  .. .............
Object ffff8800b7ea2e00: 00 00 00 00 00 00 00 00 a0 2d ea b7 00 88 ff ff  .........-......
Object ffff8800b7ea2e10: 90 2e ea b7 00 88 ff ff 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e20: 00 00 00 00 6d 41 00 00 00 00 00 00 00 00 00 00  ....mA..........
Object ffff8800b7ea2e30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Object ffff8800b7ea2e90: 6e 65 69 67 68 00 00 00 00 00 00 00 00 00 00 00  neigh...........
Redzone ffff8800b7ea2ea0: cc cc cc cc cc cc cc cc                          ........
Padding ffff8800b7ea2fe0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
CPU: 1 PID: 6745 Comm: trinity-c14 Tainted: G    B           4.4.0-think+ #13
 ffffea0002dfa800 00000000f6ec2ab4 ffff88009636f0f8 ffffffffbc552ce1
 ffff8804654073c0 ffff88009636f128 ffffffffbc2e01d9 ffff8804654073c0
 ffffea0002dfa800 ffff8800b7ea2da0 ffffe8ffff805f30 ffff88009636f150
Call Trace:
 [<ffffffffbc552ce1>] dump_stack+0x4e/0x7d
 [<ffffffffbc2e01d9>] print_trailer+0xf9/0x150
 [<ffffffffbc2e6814>] object_err+0x34/0x40
 [<ffffffffbc2e849c>] kasan_report_error+0x20c/0x530
 [<ffffffffbc2e8d58>] kasan_report+0x58/0x60
 [<ffffffffc0450fd1>] ? perf_trace_btrfs__work+0x1b1/0x2a0 [btrfs]
 [<ffffffffbc2e76ad>] __asan_load8+0x5d/0x70
 [<ffffffffc0450fd1>] perf_trace_btrfs__work+0x1b1/0x2a0 [btrfs]
 [<ffffffffbcd01f73>] ? retint_kernel+0x2d/0x2d
 [<ffffffffc0450e20>] ? trace_event_raw_event_btrfs_sync_file+0x210/0x210 [btrfs]
 [<ffffffffbc1337d2>] ? __lock_is_held+0x92/0xd0
 [<ffffffffc0450e20>] ? trace_event_raw_event_btrfs_sync_file+0x210/0x210 [btrfs]
 [<ffffffffc04f5fb7>] btrfs_queue_work+0x167/0x220 [btrfs]
 [<ffffffffc04965a3>] btrfs_wq_submit_bio+0x1e3/0x300 [btrfs]
 [<ffffffffc04a6b80>] ? btrfs_submit_bio_hook+0x260/0x260 [btrfs]
 [<ffffffffc04a81a0>] ? add_pending_csums.isra.30+0xd0/0xd0 [btrfs]
 [<ffffffffc04963c0>] ? btrfs_async_submit_limit+0x60/0x60 [btrfs]
 [<ffffffffbc158e0a>] ? rcu_read_lock_sched_held+0x8a/0xa0
 [<ffffffffc04a6a38>] btrfs_submit_bio_hook+0x118/0x260 [btrfs]
 [<ffffffffc04a81a0>] ? add_pending_csums.isra.30+0xd0/0xd0 [btrfs]
 [<ffffffffc04a6b80>] ? btrfs_submit_bio_hook+0x260/0x260 [btrfs]
 [<ffffffffc04a6920>] ? btrfs_writepage_end_io_hook+0x410/0x410 [btrfs]
 [<ffffffffc04d1743>] submit_one_bio+0xf3/0x120 [btrfs]
 [<ffffffffc04d9803>] submit_extent_page+0x113/0x270 [btrfs]
 [<ffffffffc04da1dc>] __extent_writepage_io+0x5dc/0x650 [btrfs]
 [<ffffffffc04d93e0>] ? end_extent_writepage+0xe0/0xe0 [btrfs]
 [<ffffffffc04da67d>] __extent_writepage+0x42d/0x570 [btrfs]
 [<ffffffffc04da250>] ? __extent_writepage_io+0x650/0x650 [btrfs]
 [<ffffffffbc138886>] ? mark_held_locks+0x96/0xc0
 [<ffffffffbc276594>] ? clear_page_dirty_for_io+0x174/0x1d0
 [<ffffffffbc138a36>] ? trace_hardirqs_on_caller+0x186/0x280
 [<ffffffffbc138b3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffc04dabd2>] extent_write_cache_pages.isra.37.constprop.54+0x412/0x540 [btrfs]
 [<ffffffffc04da7c0>] ? __extent_writepage+0x570/0x570 [btrfs]
 [<ffffffffbc138a36>] ? trace_hardirqs_on_caller+0x186/0x280
 [<ffffffffbc0f2891>] ? preempt_count_sub+0xc1/0x120
 [<ffffffffbcd00a72>] ? _raw_spin_unlock_irqrestore+0x42/0x70
 [<ffffffffbc2e4dd1>] ? kfree+0xc1/0x270
 [<ffffffffc04c32a2>] ? __btrfs_buffered_write+0x702/0x8a0 [btrfs]
 [<ffffffffc04dc6ce>] extent_writepages+0xbe/0x100 [btrfs]
 [<ffffffffc04dc610>] ? extent_write_locked_range+0x270/0x270 [btrfs]
 [<ffffffffc04c32a2>] ? __btrfs_buffered_write+0x702/0x8a0 [btrfs]
 [<ffffffffc04ab410>] ? btrfs_real_readdir+0x8d0/0x8d0 [btrfs]
 [<ffffffffc04a7883>] btrfs_writepages+0x33/0x40 [btrfs]
 [<ffffffffbc27a2a1>] do_writepages+0x51/0x70
 [<ffffffffbc2671d8>] __filemap_fdatawrite_range+0x108/0x160
 [<ffffffffbc2670d0>] ? replace_page_cache_page+0x240/0x240
 [<ffffffffbc267dd0>] ? generic_file_read_iter+0xa00/0xa00
 [<ffffffffbc267333>] filemap_fdatawrite_range+0x13/0x20
 [<ffffffffc04c7968>] btrfs_fdatawrite_range+0x38/0x90 [btrfs]
 [<ffffffffc04c87b2>] btrfs_file_write_iter+0x712/0x800 [btrfs]
 [<ffffffffc04c80a0>] ? btrfs_sync_file+0x6b0/0x6b0 [btrfs]
 [<ffffffffbc2fd528>] do_iter_readv_writev+0xe8/0x140
 [<ffffffffbc2fd440>] ? no_seek_end_llseek_size+0x20/0x20
 [<ffffffffbc1317b7>] ? percpu_down_read+0x57/0xa0
 [<ffffffffbc303364>] ? __sb_start_write+0xb4/0xf0
 [<ffffffffbc2fea67>] do_readv_writev+0x297/0x3c0
 [<ffffffffbc133765>] ? __lock_is_held+0x25/0xd0
 [<ffffffffc04c80a0>] ? btrfs_sync_file+0x6b0/0x6b0 [btrfs]
 [<ffffffffbc2fe7d0>] ? vfs_write+0x260/0x260
 [<ffffffffbc138886>] ? mark_held_locks+0x96/0xc0
 [<ffffffffbc138a36>] ? trace_hardirqs_on_caller+0x186/0x280
 [<ffffffffbc0f2891>] ? preempt_count_sub+0xc1/0x120
 [<ffffffffbccfb637>] ? mutex_lock_nested+0x3a7/0x590
 [<ffffffffbc330a01>] ? __fdget_pos+0x61/0x70
 [<ffffffffbc330a01>] ? __fdget_pos+0x61/0x70
 [<ffffffffbc26176a>] ? context_tracking_exit.part.5+0x2a/0x50
 [<ffffffffbccfb290>] ? mutex_lock_interruptible_nested+0x640/0x640
 [<ffffffffbc138a36>] ? trace_hardirqs_on_caller+0x186/0x280
 [<ffffffffbc138b3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffbc158d2a>] ? debug_lockdep_rcu_enabled.part.18+0x1a/0x30
 [<ffffffffbc2fec59>] vfs_writev+0x59/0x70
 [<ffffffffbc3006df>] SyS_writev+0xbf/0x1a0
 [<ffffffffbc300620>] ? SyS_readv+0x1a0/0x1a0
 [<ffffffffbc002017>] ? trace_hardirqs_on_thunk+0x17/0x19
 [<ffffffffbcd01457>] entry_SYSCALL_64_fastpath+0x12/0x6b
Memory state around the buggy address:
 ffff8800b7ea2d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800b7ea2d80: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8800b7ea2e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                                       ^
 ffff8800b7ea2e80: 00 00 06 fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800b7ea2f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

