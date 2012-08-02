Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56140 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab2HBWQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 18:16:47 -0400
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id q72MGih7012248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 00:16:45 +0200
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id q72MGi4h012247
	for linux-btrfs@vger.kernel.org; Fri, 3 Aug 2012 00:16:44 +0200
Date: Fri, 3 Aug 2012 00:16:44 +0200
From: David Sterba <dave@jikos.cz>
To: linux-btrfs@vger.kernel.org
Subject: [current linus/master] deadlock during snapshot, sb_writers
Message-ID: <20120802221644.GS17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

top commit (v3.5-9237) fc6bdb59a501740b28ed3b616641a22c8dc5dd31, observed with
btrfs-next/master as well.

mount:
/dev/sdb on /mnt/sdb type btrfs (rw,relatime,space_cache)

fresh mkfs, snapshot stresstest, stuck on first snapshot call afaics

[  113.751610] =============================================
[  113.752178] [ INFO: possible recursive locking detected ]
[  113.752178] 3.5.0linus-default+ #174 Not tainted
[  113.752178] ---------------------------------------------
[  113.752178] btrfs/3125 is trying to acquire lock:
[  113.752178]  (sb_writers#10){.+.+.+}, at: [<ffffffff81175ac4>] mnt_want_write+0x24/0x50
[  113.752178]
[  113.752178] but task is already holding lock:
[  113.752178]  (sb_writers#10){.+.+.+}, at: [<ffffffff81175b78>] mnt_want_write_file+0x28/0x60
[  113.752178]
[  113.752178] other info that might help us debug this:
[  113.752178]  Possible unsafe locking scenario:
[  113.752178]
[  113.752178]        CPU0
[  113.752178]        ----
[  113.752178]   lock(sb_writers#10);
[  113.752178]   lock(sb_writers#10);
[  113.752178]
[  113.752178]  *** DEADLOCK ***
[  113.752178]
[  113.856366]  May be due to missing lock nesting notation
[  113.856366]
[  113.856366] 1 lock held by btrfs/3125:
[  113.856366]  #0:  (sb_writers#10){.+.+.+}, at: [<ffffffff81175b78>] mnt_want_write_file+0x28/0x60
[  113.856366]
[  113.856366] stack backtrace:
[  113.856366] Pid: 3125, comm: btrfs Not tainted 3.5.0linus-default+ #174
[  113.856366] Call Trace:
[  113.856366]  [<ffffffff810a7733>] __lock_acquire+0x1663/0x1e90
[  113.856366]  [<ffffffff810a2799>] ? trace_hardirqs_off_caller+0x29/0xc0
[  113.856366]  [<ffffffff81009f55>] ? native_sched_clock+0x15/0x80
[  113.856366]  [<ffffffff8108473f>] ? local_clock+0x6f/0x80
[  113.856366]  [<ffffffff810a2799>] ? trace_hardirqs_off_caller+0x29/0xc0
[  113.856366]  [<ffffffff81175ac4>] ? mnt_want_write+0x24/0x50
[  113.856366]  [<ffffffff810a85f4>] lock_acquire+0x94/0x130
[  113.856366]  [<ffffffff81175ac4>] ? mnt_want_write+0x24/0x50
[  113.856366]  [<ffffffff8115819c>] __sb_start_write+0x9c/0x1b0
[  113.856366]  [<ffffffff81175ac4>] ? mnt_want_write+0x24/0x50
[  113.856366]  [<ffffffff81009f55>] ? native_sched_clock+0x15/0x80
[  113.856366]  [<ffffffff81175ac4>] ? mnt_want_write+0x24/0x50
[  113.856366]  [<ffffffff810a2799>] ? trace_hardirqs_off_caller+0x29/0xc0
[  113.856366]  [<ffffffff81175ac4>] mnt_want_write+0x24/0x50
[  113.856366]  [<ffffffff811575a4>] ? fget+0x84/0x100
[  113.856366]  [<ffffffffa005f447>] btrfs_mksubvol+0x47/0x370 [btrfs]
[  113.856366]  [<ffffffffa005f86a>] btrfs_ioctl_snap_create_transid+0xfa/0x190 [btrfs]
[  113.856366]  [<ffffffff8112cf9c>] ? might_fault+0x9c/0xb0
[  113.856366]  [<ffffffff8112cf53>] ? might_fault+0x53/0xb0
[  113.856366]  [<ffffffffa005fa86>] btrfs_ioctl_snap_create_v2+0x106/0x140 [btrfs]
[  113.856366]  [<ffffffff810a2b5d>] ? lock_release_holdtime+0x3d/0x1c0
[  113.856366]  [<ffffffff81908850>] ? do_page_fault+0x2d0/0x580
[  113.856366]  [<ffffffffa00617a8>] btrfs_ioctl+0x558/0x19c0 [btrfs]
[  113.856366]  [<ffffffff81076353>] ? up_read+0x23/0x40
[  113.856366]  [<ffffffff81908850>] ? do_page_fault+0x2d0/0x580
[  113.856366]  [<ffffffff819043b0>] ? _raw_spin_unlock_irq+0x30/0x50
[  113.856366]  [<ffffffff8107c433>] ? finish_task_switch+0x83/0xf0
[  113.856366]  [<ffffffff81168e58>] do_vfs_ioctl+0x98/0x560
[  113.856366]  [<ffffffff81904b55>] ? retint_swapgs+0x13/0x1b
[  113.856366]  [<ffffffff8116936f>] sys_ioctl+0x4f/0x80
[  113.856366]  [<ffffffff8190d029>] system_call_fastpath+0x16/0x1b


tasks in D-state:

 3030 ?        D      0:00 [btrfs-endio-wri]
[<ffffffffa001fdb2>] btrfs_run_delayed_refs+0x402/0x560 [btrfs]
[<ffffffffa003315f>] __btrfs_end_transaction+0xcf/0x320 [btrfs]
[<ffffffffa0033425>] btrfs_end_transaction+0x15/0x20 [btrfs]
[<ffffffffa0039b6b>] btrfs_finish_ordered_io+0x19b/0x410 [btrfs]
[<ffffffffa0039df5>] finish_ordered_fn+0x15/0x20 [btrfs]
[<ffffffffa005bd44>] worker_loop+0xc4/0x5a0 [btrfs]
[<ffffffff810705ee>] kthread+0xae/0xc0
[<ffffffff8190e184>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3036 ?        D      0:00 [btrfs-transacti]
[<ffffffffa001fdb2>] btrfs_run_delayed_refs+0x402/0x560 [btrfs]
[<ffffffffa00325ad>] btrfs_commit_transaction+0x9d/0xb50 [btrfs]
[<ffffffffa002b8ce>] transaction_kthread+0x1ae/0x240 [btrfs]
[<ffffffff810705ee>] kthread+0xae/0xc0
[<ffffffff8190e184>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3104 pts/3    D+     0:06 tar x
[<ffffffffa0031e35>] wait_current_trans+0xc5/0x120 [btrfs]
[<ffffffffa003357e>] start_transaction+0x14e/0x400 [btrfs]
[<ffffffffa0033b13>] btrfs_start_transaction+0x13/0x20 [btrfs]
[<ffffffffa0040ec6>] btrfs_create+0x46/0x220 [btrfs]
[<ffffffff81165539>] vfs_create+0x89/0xc0
[<ffffffff81165dc3>] do_last+0x853/0xd10
[<ffffffff81166336>] path_openat+0xb6/0x4a0
[<ffffffff81166ae9>] do_filp_open+0x49/0xa0
[<ffffffff81155572>] do_sys_open+0x102/0x1e0
[<ffffffff81155694>] sys_openat+0x14/0x20
[<ffffffff8190d029>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3115 ?        D      0:00 [btrfs-endio-wri]
[<ffffffffa001fdb2>] btrfs_run_delayed_refs+0x402/0x560 [btrfs]
[<ffffffffa003315f>] __btrfs_end_transaction+0xcf/0x320 [btrfs]
[<ffffffffa0033425>] btrfs_end_transaction+0x15/0x20 [btrfs]
[<ffffffffa0039b6b>] btrfs_finish_ordered_io+0x19b/0x410 [btrfs]
[<ffffffffa0039df5>] finish_ordered_fn+0x15/0x20 [btrfs]
[<ffffffffa005bd44>] worker_loop+0xc4/0x5a0 [btrfs]
[<ffffffff810705ee>] kthread+0xae/0xc0
[<ffffffff8190e184>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3116 ?        D      0:00 [btrfs-endio-wri]
[<ffffffffa001fdb2>] btrfs_run_delayed_refs+0x402/0x560 [btrfs]
[<ffffffffa003315f>] __btrfs_end_transaction+0xcf/0x320 [btrfs]
[<ffffffffa0033425>] btrfs_end_transaction+0x15/0x20 [btrfs]
[<ffffffffa0039b6b>] btrfs_finish_ordered_io+0x19b/0x410 [btrfs]
[<ffffffffa0039df5>] finish_ordered_fn+0x15/0x20 [btrfs]
[<ffffffffa005bd44>] worker_loop+0xc4/0x5a0 [btrfs]
[<ffffffff810705ee>] kthread+0xae/0xc0
[<ffffffff8190e184>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3117 ?        D      0:00 [btrfs-endio-wri]
[<ffffffffa001fdb2>] btrfs_run_delayed_refs+0x402/0x560 [btrfs]
[<ffffffffa003315f>] __btrfs_end_transaction+0xcf/0x320 [btrfs]
[<ffffffffa0033425>] btrfs_end_transaction+0x15/0x20 [btrfs]
[<ffffffffa0039b6b>] btrfs_finish_ordered_io+0x19b/0x410 [btrfs]
[<ffffffffa0039df5>] finish_ordered_fn+0x15/0x20 [btrfs]
[<ffffffffa005bd44>] worker_loop+0xc4/0x5a0 [btrfs]
[<ffffffff810705ee>] kthread+0xae/0xc0
[<ffffffff8190e184>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3125 pts/4    D+     0:00 btrfs subvol snap /mnt/sdb snap3013332226
[<ffffffffa0048165>] btrfs_start_ordered_extent+0x85/0x140 [btrfs]
[<ffffffffa0048364>] btrfs_wait_ordered_extents+0x144/0x230 [btrfs]
[<ffffffffa00329cc>] btrfs_commit_transaction+0x4bc/0xb50 [btrfs]
[<ffffffffa005f764>] btrfs_mksubvol+0x364/0x370 [btrfs]
[<ffffffffa005f86a>] btrfs_ioctl_snap_create_transid+0xfa/0x190 [btrfs]
[<ffffffffa005fa86>] btrfs_ioctl_snap_create_v2+0x106/0x140 [btrfs]
[<ffffffffa00617a8>] btrfs_ioctl+0x558/0x19c0 [btrfs]
[<ffffffff81168e58>] do_vfs_ioctl+0x98/0x560
[<ffffffff8116936f>] sys_ioctl+0x4f/0x80
[<ffffffff8190d029>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3130 pts/5    D+     0:00 /test-subvol/t3-snap-del-random /mnt/sdb
[<ffffffff811696c8>] vfs_readdir+0x78/0xd0
[<ffffffff81169939>] sys_getdents64+0x89/0x110
[<ffffffff8190d029>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 3286 pts/0    D+     0:00 rm -rf /mnt/sdb/en
[<ffffffffa0031e35>] wait_current_trans+0xc5/0x120 [btrfs]
[<ffffffffa003357e>] start_transaction+0x14e/0x400 [btrfs]
[<ffffffffa0033b13>] btrfs_start_transaction+0x13/0x20 [btrfs]
[<ffffffffa0035e95>] __unlink_start_trans+0x85/0x480 [btrfs]
[<ffffffffa003c407>] btrfs_unlink+0x37/0xd0 [btrfs]
[<ffffffff81164740>] vfs_unlink+0x90/0x100
[<ffffffff81164905>] do_unlinkat+0x155/0x1c0
[<ffffffff81166ee2>] sys_unlinkat+0x22/0x40
[<ffffffff8190d029>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
