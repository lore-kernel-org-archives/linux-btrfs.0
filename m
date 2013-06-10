Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41082 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3FJEDc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 00:03:32 -0400
Received: by mail-ob0-f179.google.com with SMTP id xk17so9352383obc.38
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Jun 2013 21:03:32 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 9 Jun 2013 23:03:31 -0500
Message-ID: <CAKcLGm-+19LiOaMzQ5b6dCboB_wGJNM_R=TP1ORVcJOgmj8s8A@mail.gmail.com>
Subject: btrfs-cleaner Blocked on xfstests 068
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running into a problem with the btrfs-cleaner thread becoming
blocked on xfstests 068.

The test locks up indefinitely without completing (normally it
finished in about 45 seconds on my test box).

I've replicated the issue on 3.10.0_rc5 and the for-linus branch of 3.9.0.

I ran a git bisect on the 3.9.0 for-linus branch, and tracked my issue
to the following commit:

commit 9d1a2a3ad59f7ae810bf04a5a05995bf2d79300c
btrfs: clean snapshots one by one

The 068 test uses the scratch drive, so I believe xfs-test is using
the defaults for formatting the device, which is a physical partition
on my SATA drive.

My mount settings for xfstests is:
export MOUNT_OPTIONS="-o compress-force=lzo,autodefrag"

There are no errors shown in dmesg.  Here is the result of Alt-SysRq-W
to show the blocked states:

[  413.408168] SysRq : Show Blocked State
[  413.409157]   task                        PC stack   pid father
[  413.409157] btrfs-cleaner   D ffff88007827c308     0  4516      2 0x00000000
[  413.409157]  ffff8800785d5d18 0000000000000046 ffff8800785d5c58
ffff8800785d5fd8
[  413.409157]  0000000000004000 0000000000012c80 ffff88007ca7a210
ffff88007cbd4af0
[  413.409157]  ffff88007cbd4b60 ffff88007cbd4b38 ffff88007f312cf0
0000000000000001
[  413.409157] Call Trace:
[  413.409157]  [<ffffffff8105e30f>] ? dequeue_entity+0x34e/0x370
[  413.409157]  [<ffffffff81118593>] ? find_inode+0x93/0xbe
[  413.409157]  [<ffffffff8161e3e4>] schedule+0x64/0x66
[  413.409157]  [<ffffffff8110525c>] __sb_start_write+0x9a/0xf0
[  413.409157]  [<ffffffff8104e2d7>] ? remove_wait_queue+0x3a/0x3a
[  413.409157]  [<ffffffffa019018e>] btrfs_run_defrag_inodes+0x20a/0x327 [btrfs]
[  413.409157]  [<ffffffffa017a6c1>] cleaner_kthread+0x95/0x122 [btrfs]
[  413.409157]  [<ffffffffa017a62c>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[  413.409157]  [<ffffffff8104da7c>] kthread+0xba/0xc2
[  413.409157]  [<ffffffff8104d9c2>] ? kthread_freezable_should_stop+0x52/0x52
[  413.409157]  [<ffffffff8161fd1c>] ret_from_fork+0x7c/0xb0
[  413.409157]  [<ffffffff8104d9c2>] ? kthread_freezable_should_stop+0x52/0x52
[  413.409157] fsstress        D ffff88007827c308     0  4730   4729 0x00000000
[  413.409157]  ffff88007717fd58 0000000000000082 ffff88007717fe18
ffff88007717ffd8
[  413.409157]  0000000000004000 0000000000012c80 ffffffff81c11410
ffff88007caf2fb0
[  413.409157]  ffff88007717fca8 ffffffff8111bb58 0000000000000000
ffff88007717fe58
[  413.409157] Call Trace:
[  413.409157]  [<ffffffff8111bb58>] ? mntput_no_expire+0x40/0x11b
[  413.409157]  [<ffffffff8110bca6>] ? complete_walk+0x92/0xda
[  413.409157]  [<ffffffff8161e3e4>] schedule+0x64/0x66
[  413.409157]  [<ffffffff8110525c>] __sb_start_write+0x9a/0xf0
[  413.409157]  [<ffffffff8104e2d7>] ? remove_wait_queue+0x3a/0x3a
[  413.409157]  [<ffffffff8111bf5d>] mnt_want_write+0x24/0x4b
[  413.409157]  [<ffffffff8110e5dd>] kern_path_create+0x6d/0x13f
[  413.409157]  [<ffffffff810f7fdc>] ? kmem_cache_alloc+0x31/0xf8
[  413.409157]  [<ffffffff8110cb01>] ? getname_flags+0x74/0x158
[  413.409157]  [<ffffffff8110e6ee>] user_path_create+0x3f/0x57
[  413.409157]  [<ffffffff81110a38>] SyS_symlinkat+0x4a/0xc0
[  413.409157]  [<ffffffff81001f1b>] ? do_notify_resume+0x5a/0x61
[  413.409157]  [<ffffffff81110ac4>] SyS_symlink+0x16/0x18
[  413.409157]  [<ffffffff8161fdc6>] system_call_fastpath+0x1a/0x1f
[  413.409157] fsstress        D ffff88007827c308     0  4731   4729 0x00000000
[  413.409157]  ffff880077181e68 0000000000000082 ffff8800785c2000
ffff880077181fd8
[  413.409157]  0000000000004000 0000000000012c80 ffff88007caf1470
ffff88007caf0da0
[  413.409157]  0000000000000001 0000000000000001 ffff880077181da8
ffffffff8110cc21
[  413.409157] Call Trace:
[  413.409157]  [<ffffffff8110cc21>] ? putname+0x28/0x31
[  413.409157]  [<ffffffff81110553>] ? user_path_at_empty+0x61/0x92
[  413.409157]  [<ffffffff811075b4>] ? inode_get_bytes+0x1a/0x3a
[  413.409157]  [<ffffffff811075b4>] ? inode_get_bytes+0x1a/0x3a
[  413.409157]  [<ffffffff8161e3e4>] schedule+0x64/0x66
[  413.409157]  [<ffffffff8110525c>] __sb_start_write+0x9a/0xf0
[  413.409157]  [<ffffffff8104e2d7>] ? remove_wait_queue+0x3a/0x3a
[  413.409157]  [<ffffffff8110386f>] vfs_write+0xc2/0x18f
[  413.409157]  [<ffffffff81103c5b>] SyS_write+0x50/0x78
[  413.409157]  [<ffffffff8161fdc6>] system_call_fastpath+0x1a/0x1f
[  413.409157] xfs_io          D ffffffff00000001     0  4750   4746 0x00000000
[  413.409157]  ffff88007726fd68 0000000000000086 ffff88007c5a00b0
ffff88007726ffd8
[  413.409157]  0000000000004000 0000000000012c80 ffffffff81c11410
ffff88007caf6d00
[  413.409157]  ffff88007726fca8 ffffffff810c072e ffff8800767396c0
ffff88007722ca50
[  413.409157] Call Trace:
[  413.409157]  [<ffffffff810c072e>] ? unlock_page+0x24/0x28
[  413.409157]  [<ffffffff810dbd38>] ? __do_fault+0x398/0x3cd
[  413.409157]  [<ffffffff8161e3e4>] schedule+0x64/0x66
[  413.409157]  [<ffffffff8161ee9c>] rwsem_down_write_failed+0xf7/0x14a
[  413.409157]  [<ffffffff8120d7f3>] call_rwsem_down_write_failed+0x13/0x20
[  413.409157]  [<ffffffff8161d555>] ? down_write+0x2e/0x32
[  413.409157]  [<ffffffff81105701>] thaw_super+0x1f/0xa7
[  413.409157]  [<ffffffff8111217b>] do_vfs_ioctl+0x202/0x486
[  413.409157]  [<ffffffff81129733>] ? SyS_fstatfs+0x33/0x3f
[  413.409157]  [<ffffffff8111245d>] SyS_ioctl+0x5e/0x85
[  413.409157]  [<ffffffff8161fdc6>] system_call_fastpath+0x1a/0x1f
[  413.409157] Sched Debug Version: v0.10, 3.10.0-rc5 #1
[  413.409157] ktime                                   : 413409.686757
[  413.409157] sched_clk                               : 413319.289340
[  413.409157] cpu_clk                                 : 413409.157122
[  413.409157] jiffies                                 : 4295080704
[  413.409157] sched_clock_stable                      : 0

[  413.409157] sysctl_sched
[  413.409157]   .sysctl_sched_latency                    : 12.000000
[  413.409157]   .sysctl_sched_min_granularity            : 1.500000
[  413.409157]   .sysctl_sched_wakeup_granularity         : 2.000000
[  413.409157]   .sysctl_sched_child_runs_first           : 0
[  413.409157]   .sysctl_sched_features                   : 11899
[  413.409157]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

[  413.409157] cpu#0, 3389.233 MHz
[  413.409157]   .nr_running                    : 0
[  413.409157]   .load                          : 0
[  413.409157]   .nr_switches                   : 56682
[  413.409157]   .nr_load_updates               : 19627
[  413.409157]   .nr_uninterruptible            : -100
[  413.409157]   .next_balance                  : 4295.080712
[  413.409157]   .curr->pid                     : 0
[  413.409157]   .clock                         : 413408.021911
[  413.409157]   .cpu_load[0]                   : 0
[  413.409157]   .cpu_load[1]                   : 0
[  413.409157]   .cpu_load[2]                   : 0
[  413.409157]   .cpu_load[3]                   : 0
[  413.409157]   .cpu_load[4]                   : 0
[  413.409157]
cfs_rq[0]:/
[  413.409157]   .exec_clock                    : 0.000000
[  413.409157]   .MIN_vruntime                  : 0.000001
[  413.409157]   .min_vruntime                  : 13010.537663
[  413.409157]   .max_vruntime                  : 0.000001
[  413.409157]   .spread                        : 0.000000
[  413.409157]   .spread0                       : 0.000000
[  413.409157]   .nr_spread_over                : 0
[  413.409157]   .nr_running                    : 0
[  413.409157]   .load                          : 0
[  413.409157]   .runnable_load_avg             : 0
[  413.409157]   .blocked_load_avg              : 0
[  413.409157]   .tg_load_avg                   : 0
[  413.409157]   .tg_load_contrib               : 0
[  413.409157]   .tg_runnable_contrib           : 0
[  413.409157]   .tg->runnable_avg              : 0
[  413.409157]   .avg->runnable_avg_sum         : 29
[  413.409157]   .avg->runnable_avg_period      : 47760
[  413.409157]
rt_rq[0]:
[  413.409157]   .rt_nr_running                 : 0
[  413.409157]   .rt_throttled                  : 0
[  413.409157]   .rt_time                       : 0.000000
[  413.409157]   .rt_runtime                    : 950.000000
[  413.409157]
runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

[  413.409157] cpu#1, 3389.233 MHz
[  413.409157]   .nr_running                    : 0
[  413.409157]   .load                          : 0
[  413.409157]   .nr_switches                   : 46707
[  413.409157]   .nr_load_updates               : 17279
[  413.409157]   .nr_uninterruptible            : 104
[  413.409157]   .next_balance                  : 4295.080641
[  413.409157]   .curr->pid                     : 0
[  413.409157]   .clock                         : 413352.013330
[  413.409157]   .cpu_load[0]                   : 0
[  413.409157]   .cpu_load[1]                   : 0
[  413.409157]   .cpu_load[2]                   : 0
[  413.409157]   .cpu_load[3]                   : 0
[  413.409157]   .cpu_load[4]                   : 0
[  413.409157]
cfs_rq[1]:/
[  413.409157]   .exec_clock                    : 0.000000
[  413.409157]   .MIN_vruntime                  : 0.000001
[  413.409157]   .min_vruntime                  : 15468.050935
[  413.409157]   .max_vruntime                  : 0.000001
[  413.409157]   .spread                        : 0.000000
[  413.409157]   .spread0                       : 2457.513272
[  413.409157]   .nr_spread_over                : 0
[  413.409157]   .nr_running                    : 0
[  413.409157]   .load                          : 0
[  413.409157]   .runnable_load_avg             : 0
[  413.409157]   .blocked_load_avg              : 0
[  413.409157]   .tg_load_avg                   : 0
[  413.409157]   .tg_load_contrib               : 0
[  413.409157]   .tg_runnable_contrib           : 0
[  413.409157]   .tg->runnable_avg              : 0
[  413.409157]   .avg->runnable_avg_sum         : 12
[  413.409157]   .avg->runnable_avg_period      : 46642
[  413.409157]
rt_rq[1]:
[  413.409157]   .rt_nr_running                 : 0
[  413.409157]   .rt_throttled                  : 0
[  413.409157]   .rt_time                       : 0.000000
[  413.409157]   .rt_runtime                    : 950.000000
[  413.409157]
runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
