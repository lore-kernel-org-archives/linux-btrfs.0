Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:58458 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423052Ab3FUPEO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 11:04:14 -0400
Received: from localhost (erft-5d80eb16.pool.mediaWays.net [93.128.235.22])
	(using SSLv3 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.fem.tu-ilmenau.de (Postfix) with ESMTPSA id 70EA36683
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 16:54:22 +0200 (CEST)
Date: Fri, 21 Jun 2013 16:54:54 +0200
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: hang on 3.9, 3.10-rc5
Message-ID: <20130621165454.5a87e2cb@fem.tu-ilmenau.de>
In-Reply-To: <loom.20130618T190955-784@post.gmane.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
	<20130618163706.GC19183@localhost.localdomain>
	<loom.20130618T190955-784@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Jun 2013 17:19:04 +0000 (UTC)
Jon Nelson <jnelson+btrfs@jamponi.net> wrote:

> Josef Bacik <jbacik <at> fusionio.com> writes:
> 
> > 
> > On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
> > > I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.
> > > Is this is a known problem?  In this case there is no
> > > powercycling; just a regular ceph-osd workload.
> 
> ..
> 
> 
> I'm able to cause a complete kernel hang by defrag'ing even one 
> file on 3.9.X (3.9.0 through 3.9.4, so far).

I see similar behavior with autodefrag enabled. When fetching mails
with claws (piped through bogofilter) the whole system got stuck more
or less. I can switch between the tasks but everything involving I/O is
hanging. Most time I was able to solve this with the sync command in a
shell. I got only one time a backtrace from hung task checker:

Jun 20 12:37:47 localhost kernel: INFO: task btrfs-cleaner:771 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: btrfs-cleaner   D ffff88011fc91740     0   771      2 0x00000000
Jun 20 12:37:47 localhost kernel: ffff88011aaff530 0000000000000002 ffff880119929fd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff880119929fd8 ffff88011aabddc0 ffff880119928000 ffff880119929cb8
Jun 20 12:37:47 localhost kernel: ffff8800aaac22b4 ffff8800aaac22b0 0000000000000000 ffff8800aaac22b8
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff8109856d>] ? ondemand_readahead+0x15d/0x200
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff81171579>] ? btrfs_defrag_file+0x41a/0xa4e
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff81159eb9>] ? btrfs_run_defrag_inodes+0x1f7/0x2d3
Jun 20 12:37:47 localhost kernel: [<ffffffff8115100e>] ? btrfs_run_delayed_iputs+0x44/0xbe
Jun 20 12:37:47 localhost kernel: [<ffffffff811459d5>] ? cleaner_kthread+0x89/0xf3
Jun 20 12:37:47 localhost kernel: [<ffffffff8114594c>] ? transaction_kthread+0x17a/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff81042c00>] ? kthread+0x7d/0x85
Jun 20 12:37:47 localhost kernel: [<ffffffff81040000>] ? thaw_workqueues+0xd3/0xff
Jun 20 12:37:47 localhost kernel: [<ffffffff81042b83>] ? __kthread_parkme+0x59/0x59
Jun 20 12:37:47 localhost kernel: [<ffffffff8148942c>] ? ret_from_fork+0x7c/0xb0
Jun 20 12:37:47 localhost kernel: [<ffffffff81042b83>] ? __kthread_parkme+0x59/0x59
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:2384 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc11740     0  2384   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8800c82dce20 0000000000000002 ffff8800c0c55fd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800c0c55fd8 ffffffff81a10400 ffff8800c0c54000 ffff8800c0c55e90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:2385 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc91740     0  2385   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8800c82dd5f0 0000000000000002 ffff8800c0d1dfd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800c0d1dfd8 ffff88011aabddc0 ffff8800c0d1c000 ffff8800c0d1de90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:2393 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc91740     0  2393   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8800c82df530 0000000000000002 ffff8800c0daffd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800c0daffd8 ffff88011aabddc0 ffff8800ddd9ade0 ffff88011816e1e8
Jun 20 12:37:47 localhost kernel: 0000000000000000 0000000000000000 00000000003c0000 0000000000000000
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff8114aa11>] ? wait_current_trans.isra.19+0xaa/0xdc
Jun 20 12:37:47 localhost kernel: [<ffffffff81043492>] ? finish_wait+0x60/0x60
Jun 20 12:37:47 localhost kernel: [<ffffffff8114c663>] ? start_transaction+0x3b9/0x3e9
Jun 20 12:37:47 localhost kernel: [<ffffffff8114d71b>] ? __unlink_start_trans+0x46/0x37f
Jun 20 12:37:47 localhost kernel: [<ffffffff810d9b18>] ? __d_lookup+0xdb/0xed
Jun 20 12:37:47 localhost kernel: [<ffffffff810d242d>] ? path_lookupat+0x6d/0x2a7
Jun 20 12:37:47 localhost kernel: [<ffffffff811537be>] ? btrfs_unlink+0x1f/0x91
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3ee2>] ? vfs_unlink+0x61/0xa8
Jun 20 12:37:47 localhost kernel: [<ffffffff810d4000>] ? do_unlinkat+0xd7/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:2398 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff880106fc0000     0  2398   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff880106fc0000 0000000000000002 ffff8800c0fa3fd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800c0fa3fd8 ffff8800c82dd5f0 ffff8800c0fa2000 ffff8800c0fa3e90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:2400 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc91740     0  2400   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8800d8ebc650 0000000000000002 ffff8800bece9fd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800bece9fd8 ffff88011aabddc0 ffff8800bece8000 ffff8800bece9e90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:12930 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc91740     0 12930   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8800acf22710 0000000000000002 ffff8801018a1fd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8801018a1fd8 ffff88011aabddc0 ffff8801018a0000 ffff8801018a1e90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:18283 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc11740     0 18283   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff8801030f8000 0000000000000002 ffff8800a8a9dfd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff8800a8a9dfd8 ffffffff81a10400 ffff8800a8a9c000 ffff8800a8a9de90
Jun 20 12:37:47 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:47 localhost kernel: Call Trace:
Jun 20 12:37:47 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:47 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:47 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:47 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:47 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:47 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:47 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:47 localhost kernel: INFO: task konqueror:21478 blocked for more than 120 seconds.
Jun 20 12:37:47 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:47 localhost kernel: konqueror       D ffff88011fc11740     0 21478   2133 0x00000000
Jun 20 12:37:47 localhost kernel: ffff88011aafc650 0000000000000002 ffff88010852bfd8 0000000000011740
Jun 20 12:37:47 localhost kernel: ffff88010852bfd8 ffffffff81a10400 ffff88010852a000 ffff88010852be90
Jun 20 12:37:49 localhost kernel: ffff8800c40aeb44 ffff8800c40aeb40 0000000000000000 ffff8800c40aeb48
Jun 20 12:37:49 localhost kernel: Call Trace:
Jun 20 12:37:49 localhost kernel: [<ffffffff81487fd4>] ? schedule_preempt_disabled+0x19/0x1e
Jun 20 12:37:49 localhost kernel: [<ffffffff81486fa1>] ? __mutex_lock_common.isra.9+0x19d/0x283
Jun 20 12:37:49 localhost kernel: [<ffffffff81486dbf>] ? mutex_lock+0xe/0x1d
Jun 20 12:37:49 localhost kernel: [<ffffffff810d3fb1>] ? do_unlinkat+0x88/0x17a
Jun 20 12:37:49 localhost kernel: [<ffffffff814889b0>] ? _raw_spin_unlock+0x27/0x31
Jun 20 12:37:49 localhost kernel: [<ffffffff8100ae75>] ? syscall_trace_enter+0xcf/0x145
Jun 20 12:37:49 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2
Jun 20 12:37:49 localhost kernel: INFO: task bogofilter:21625 blocked for more than 120 seconds.
Jun 20 12:37:49 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 20 12:37:49 localhost kernel: bogofilter      D ffff88011fc91740     0 21625      1 0x00000000
Jun 20 12:37:49 localhost kernel: ffff88009f116d60 0000000000000002 ffff8800296e7fd8 0000000000011740
Jun 20 12:37:49 localhost kernel: ffff8800296e7fd8 ffff88011aabddc0 ffff88004b568da8 ffff88002970a800
Jun 20 12:37:49 localhost kernel: 0000000000000000 ffff8800aaa2a2e0 ffff8800aaa2a350 ffff88002970ac60
Jun 20 12:37:49 localhost kernel: Call Trace:
Jun 20 12:37:49 localhost kernel: [<ffffffff811763fd>] ? log_one_extent.isra.24+0x441/0x58b
Jun 20 12:37:49 localhost kernel: [<ffffffff81043492>] ? finish_wait+0x60/0x60
Jun 20 12:37:49 localhost kernel: [<ffffffff81177ee9>] ? btrfs_log_inode+0x5d0/0x71e
Jun 20 12:37:49 localhost kernel: [<ffffffff811791f5>] ? btrfs_log_inode_parent+0x1f1/0x2dd
Jun 20 12:37:49 localhost kernel: [<ffffffff81179c34>] ? btrfs_log_dentry_safe+0x31/0x45
Jun 20 12:37:49 localhost kernel: [<ffffffff81158e69>] ? btrfs_sync_file+0x11a/0x1e2
Jun 20 12:37:49 localhost kernel: [<ffffffff810e8211>] ? do_fsync+0x2b/0x50
Jun 20 12:37:49 localhost kernel: [<ffffffff8148966c>] ? tracesys+0x7e/0xe2
Jun 20 12:37:49 localhost kernel: [<ffffffff810e8402>] ? SyS_fdatasync+0xa/0xd
Jun 20 12:37:49 localhost kernel: [<ffffffff814896cb>] ? tracesys+0xdd/0xe2

After disabling autodefrag it didn't happen again. The kernel is the latest git.
