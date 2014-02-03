Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:48126 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbaBCWxj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 17:53:39 -0500
Date: Mon, 3 Feb 2014 23:53:34 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140203235334.791312d1@datenkhaos.de>
In-Reply-To: <52F00538.3010505@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<20140203192811.72866921@datenkhaos.de>
	<52F00538.3010505@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 3 Feb 2014 16:08:08 -0500
Josef Bacik <jbacik@fb.com> wrote:

> 
> On 02/03/2014 01:28 PM, Johannes Hirte wrote:
> > On Thu, 23 Jan 2014 13:07:52 -0500
> > Josef Bacik <jbacik@fb.com> wrote:
> >
> >> On one of our gluster clusters we noticed some pretty big lag
> >> spikes.  This turned out to be because our transaction commit was
> >> taking like 3 minutes to complete.  This is because we have like 30
> >> gigs of metadata, so our global reserve would end up being the max
> >> which is like 512 mb.  So our throttling code would allow a
> >> ridiculous amount of delayed refs to build up and then they'd all
> >> get run at transaction commit time, and for a cold mounted file
> >> system that could take up to 3 minutes to run.  So fix the
> >> throttling to be based on both the size of the global reserve and
> >> how long it takes us to run delayed refs. This patch tracks the
> >> time it takes to run delayed refs and then only allows 1 seconds
> >> worth of outstanding delayed refs at a time.  This way it will
> >> auto-tune itself from cold cache up to when everything is in
> >> memory and it no longer has to go to disk.  This makes our
> >> transaction commits take much less time to run. Thanks,
> >>
> >> Signed-off-by: Josef Bacik <jbacik@fb.com>
> > This one breaks my system. Shortly after boot the btrfs-freespace
> > thread goes up to 100% CPU usage and the system is nearly
> > unresponsive. I've seen it first with the full pull request for
> > 3.14-rc1 and was able to track it down to this patch.
> Could you turn on the softlockup timer and see if you can get a 
> backtrace of where it is stuck?  In the meantime I will go through
> and see if I can pinpoint where it may be happening.  Thanks,
> 
> Josef

This is what I've got with

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_PREEMPT=y

[  203.610758] perf samples too long (2513 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  360.625822] INFO: task btrfs-endio-wri:1075 blocked for more than 120 seconds.
[  360.625826]       Not tainted 3.14.0-rc1 #19
[  360.625828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.625829] btrfs-endio-wri D ffff880137c12d00     0  1075      2 0x00000000
[  360.625833]  ffff8800b6b10950 0000000000000002 0000000000012d00 ffff8800b6b10950
[  360.625837]  ffff8801325b3fd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  360.625840]  0000000000000000 ffff880132571800 ffff8800b635ba00 ffffffff81256192
[  360.625844] Call Trace:
[  360.625854]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  360.625858]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.625860]  [<ffffffff8125740a>] ? start_transaction+0x2f1/0x4e3
[  360.625864]  [<ffffffff81260b8a>] ? btrfs_finish_ordered_io+0x44c/0x7b2
[  360.625869]  [<ffffffff81062dab>] ? try_to_del_timer_sync+0x53/0x5e
[  360.625871]  [<ffffffff81062ddc>] ? del_timer_sync+0x26/0x43
[  360.625875]  [<ffffffff815a9a7b>] ? schedule_timeout+0xeb/0x104
[  360.625877]  [<ffffffff81061f10>] ? rcu_read_unlock_sched_notrace+0x11/0x11
[  360.625882]  [<ffffffff8127bd1c>] ? worker_loop+0x162/0x4c3
[  360.625884]  [<ffffffff8127bbba>] ? btrfs_queue_worker+0x275/0x275
[  360.625888]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  360.625893]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.625895]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  360.625897]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.625901]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  360.625903]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.625906] INFO: task btrfs-transacti:1084 blocked for more than 120 seconds.
[  360.625908]       Not tainted 3.14.0-rc1 #19
[  360.625909] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.625910] btrfs-transacti D ffff880137c52d00     0  1084      2 0x00000000
[  360.625912]  ffff880132428950 0000000000000002 0000000000012d00 ffff880132428950
[  360.625915]  ffff8800b5a35fd8 ffff8801331a5a70 ffff8801331a5ae8 0000000000000000
[  360.625918]  ffff8800aba981b8 0000000000015000 0000000000000001 ffffffff8126b986
[  360.625921] Call Trace:
[  360.625925]  [<ffffffff8126b986>] ? btrfs_start_ordered_extent+0x91/0xdf
[  360.625928]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.625931]  [<ffffffff8126bbff>] ? btrfs_wait_ordered_range+0xab/0x10a
[  360.625934]  [<ffffffff8128ac45>] ? __btrfs_write_out_cache+0x43c/0x67f
[  360.625939]  [<ffffffff8112d81b>] ? kmem_cache_free+0x66/0x10d
[  360.625942]  [<ffffffff8125970a>] ? btrfs_update_inode_item+0xb9/0xcd
[  360.625944]  [<ffffffff8125dd01>] ? __btrfs_prealloc_file_range+0x276/0x2db
[  360.625947]  [<ffffffff8128cbcd>] ? btrfs_write_out_ino_cache+0x3f/0x5e
[  360.625950]  [<ffffffff8124f22d>] ? btrfs_save_ino_cache+0x269/0x2ea
[  360.625952]  [<ffffffff8125582e>] ? commit_fs_roots.isra.17+0xa6/0x148
[  360.625954]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.625958]  [<ffffffff8107d3bc>] ? preempt_count_sub+0xbd/0xc9
[  360.625960]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.625962]  [<ffffffff8107d3bc>] ? preempt_count_sub+0xbd/0xc9
[  360.625964]  [<ffffffff81256ccf>] ? btrfs_commit_transaction+0x3e1/0x82b
[  360.625966]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.625968]  [<ffffffff81253414>] ? transaction_kthread+0xef/0x19f
[  360.625971]  [<ffffffff81253325>] ? btrfs_cleanup_transaction+0x411/0x411
[  360.625973]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  360.625975]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.625977]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  360.625979]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.625981]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  360.625983]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.625989] INFO: task console-kit-dae:2176 blocked for more than 120 seconds.
[  360.625990]       Not tainted 3.14.0-rc1 #19
[  360.625991] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.625992] console-kit-dae D ffff880137c92d00     0  2176      1 0x00000000
[  360.625995]  ffff880132a2a540 0000000000000002 0000000000012d00 ffff880132a2a540
[  360.625998]  ffff8800b0469fd8 ffff8800b0469c78 ffff8800b1c0b69c 0000000000053000
[  360.626000]  0000000000053fff ffff8800b0469c90 ffff8800b1c0b680 ffffffff8126df4b
[  360.626003] Call Trace:
[  360.626006]  [<ffffffff8126df4b>] ? lock_extent_bits+0x123/0x19b
[  360.626009]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.626012]  [<ffffffff81264587>] ? lock_and_cleanup_extent_if_need+0x6b/0x196
[  360.626014]  [<ffffffff812659a8>] ? __btrfs_buffered_write+0x222/0x445
[  360.626017]  [<ffffffff81265f7a>] ? btrfs_file_aio_write+0x3af/0x46f
[  360.626021]  [<ffffffff810bae0c>] ? from_kgid_munged+0xe/0x19
[  360.626025]  [<ffffffff81135d8f>] ? do_sync_write+0x5b/0x7b
[  360.626028]  [<ffffffff811360bf>] ? vfs_write+0xa6/0x101
[  360.626030]  [<ffffffff811367b2>] ? SyS_write+0x46/0x7a
[  360.626033]  [<ffffffff815adb9f>] ? tracesys+0xdd/0xe2
[  360.626044] INFO: task btrfs-endio-wri:2433 blocked for more than 120 seconds.
[  360.626046]       Not tainted 3.14.0-rc1 #19
[  360.626046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.626047] btrfs-endio-wri D ffff880137c92d00     0  2433      2 0x00000000
[  360.626050]  ffff880132a78950 0000000000000002 0000000000012d00 ffff880132a78950
[  360.626053]  ffff8800ab559fd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  360.626055]  0000000000000000 ffff880132571800 ffff8800b46eb8c0 ffffffff81256192
[  360.626058] Call Trace:
[  360.626061]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  360.626063]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.626066]  [<ffffffff8125740a>] ? start_transaction+0x2f1/0x4e3
[  360.626068]  [<ffffffff81260b8a>] ? btrfs_finish_ordered_io+0x44c/0x7b2
[  360.626070]  [<ffffffff81062dab>] ? try_to_del_timer_sync+0x53/0x5e
[  360.626072]  [<ffffffff81062ddc>] ? del_timer_sync+0x26/0x43
[  360.626074]  [<ffffffff815a9a7b>] ? schedule_timeout+0xeb/0x104
[  360.626076]  [<ffffffff81061f10>] ? rcu_read_unlock_sched_notrace+0x11/0x11
[  360.626079]  [<ffffffff8127bd1c>] ? worker_loop+0x162/0x4c3
[  360.626081]  [<ffffffff8127bbba>] ? btrfs_queue_worker+0x275/0x275
[  360.626083]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  360.626085]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.626087]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  360.626089]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.626091]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  360.626093]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.626096] INFO: task rm:2638 blocked for more than 120 seconds.
[  360.626098]       Not tainted 3.14.0-rc1 #19
[  360.626099] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.626100] rm              D ffff880137c12d00     0  2638   2634 0x00000000
[  360.626102]  ffff8800b6b7ae90 0000000000000002 0000000000012d00 ffff8800b6b7ae90
[  360.626105]  ffff8800a603ffd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  360.626108]  0000000000000000 ffff880132571800 ffff8800b635be60 ffffffff81256192
[  360.626111] Call Trace:
[  360.626114]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  360.626116]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.626118]  [<ffffffff81257532>] ? start_transaction+0x419/0x4e3
[  360.626120]  [<ffffffff8105fa46>] ? inode_capable+0x3a/0x49
[  360.626122]  [<ffffffff8125846b>] ? __unlink_start_trans+0x1f/0xa6
[  360.626124]  [<ffffffff8125ddf6>] ? btrfs_unlink+0x23/0x92
[  360.626127]  [<ffffffff81141a6f>] ? vfs_unlink+0x87/0xcd
[  360.626129]  [<ffffffff81141ba7>] ? do_unlinkat+0xf2/0x1c0
[  360.626131]  [<ffffffff810da97b>] ? trace_hardirqs_on+0xe/0x1e
[  360.626135]  [<ffffffff8100d2f2>] ? syscall_trace_enter+0xdf/0x1c9
[  360.626138]  [<ffffffff815adb9f>] ? tracesys+0xdd/0xe2
[  360.626140] INFO: task btrfs-endio-wri:2666 blocked for more than 120 seconds.
[  360.626141]       Not tainted 3.14.0-rc1 #19
[  360.626142] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.626143] btrfs-endio-wri D ffff880137c92d00     0  2666      2 0x00000000
[  360.626145]  ffff8800b6955d20 0000000000000002 0000000000012d00 ffff8800b6955d20
[  360.626148]  ffff88009c797fd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  360.626151]  0000000000000000 ffff880132571800 ffff8800b46eb280 ffffffff81256192
[  360.626154] Call Trace:
[  360.626157]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  360.626159]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.626161]  [<ffffffff8125740a>] ? start_transaction+0x2f1/0x4e3
[  360.626163]  [<ffffffff81260b8a>] ? btrfs_finish_ordered_io+0x44c/0x7b2
[  360.626165]  [<ffffffff81062dab>] ? try_to_del_timer_sync+0x53/0x5e
[  360.626167]  [<ffffffff81062ddc>] ? del_timer_sync+0x26/0x43
[  360.626169]  [<ffffffff815a9a7b>] ? schedule_timeout+0xeb/0x104
[  360.626171]  [<ffffffff81061f10>] ? rcu_read_unlock_sched_notrace+0x11/0x11
[  360.626173]  [<ffffffff8127bd1c>] ? worker_loop+0x162/0x4c3
[  360.626176]  [<ffffffff8127bbba>] ? btrfs_queue_worker+0x275/0x275
[  360.626178]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  360.626180]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  360.626181]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  360.626184]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.626186]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  360.626188]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  360.626190] INFO: task touch:2720 blocked for more than 120 seconds.
[  360.626191]       Not tainted 3.14.0-rc1 #19
[  360.626192] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.626193] touch           D ffff880137c92d00     0  2720   2710 0x00000000
[  360.626196]  ffff8800ab7712a0 0000000000000002 0000000000012d00 ffff8800ab7712a0
[  360.626199]  ffff8800731abfd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  360.626201]  0000000000000000 ffff880132571800 ffff8800b46eba00 ffffffff81256192
[  360.626204] Call Trace:
[  360.626207]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  360.626209]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  360.626211]  [<ffffffff8125740a>] ? start_transaction+0x2f1/0x4e3
[  360.626214]  [<ffffffff8125bdc1>] ? btrfs_dirty_inode+0x2a/0xa6
[  360.626215]  [<ffffffff8125f353>] ? btrfs_setattr+0x248/0x284
[  360.626219]  [<ffffffff8114aeaa>] ? notify_change+0x1e4/0x2c8
[  360.626222]  [<ffffffff81159b1a>] ? utimes_common+0x11e/0x179
[  360.626224]  [<ffffffff81159c5f>] ? do_utimes+0xea/0x121
[  360.626226]  [<ffffffff81159e0c>] ? SyS_utimensat+0x67/0x7d
[  360.626228]  [<ffffffff815adb40>] ? tracesys+0x7e/0xe2
[  360.626230]  [<ffffffff815adb9f>] ? tracesys+0xdd/0xe2
[  419.061067] SysRq : Emergency Sync
[  419.254103] Emergency Sync complete
[  422.325119] SysRq : Changing Loglevel
[  422.326837] Loglevel set to 4
[  425.201634] SysRq : Changing Loglevel
[  425.202804] Loglevel set to 6
[  426.534675] SysRq : Changing Loglevel
[  426.535816] Loglevel set to 7
[  427.609799] SysRq : Changing Loglevel
[  427.610894] Loglevel set to 8
[  480.520747] INFO: task btrfs-endio-wri:1075 blocked for more than 120 seconds.
[  480.521740]       Not tainted 3.14.0-rc1 #19
[  480.522701] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.523651] btrfs-endio-wri D ffff880137c12d00     0  1075      2 0x00000000
[  480.524611]  ffff8800b6b10950 0000000000000002 0000000000012d00 ffff8800b6b10950
[  480.525589]  ffff8801325b3fd8 ffff8800a2dcc000 ffff8801325719e8 0000000000000000
[  480.526594]  0000000000000000 ffff880132571800 ffff8800b635ba00 ffffffff81256192
[  480.527595] Call Trace:
[  480.528552]  [<ffffffff81256192>] ? wait_current_trans.isra.19+0xbb/0xdf
[  480.529514]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  480.530430]  [<ffffffff8125740a>] ? start_transaction+0x2f1/0x4e3
[  480.531315]  [<ffffffff81260b8a>] ? btrfs_finish_ordered_io+0x44c/0x7b2
[  480.532191]  [<ffffffff81062dab>] ? try_to_del_timer_sync+0x53/0x5e
[  480.533030]  [<ffffffff81062ddc>] ? del_timer_sync+0x26/0x43
[  480.533871]  [<ffffffff815a9a7b>] ? schedule_timeout+0xeb/0x104
[  480.534713]  [<ffffffff81061f10>] ? rcu_read_unlock_sched_notrace+0x11/0x11
[  480.535562]  [<ffffffff8127bd1c>] ? worker_loop+0x162/0x4c3
[  480.536408]  [<ffffffff8127bbba>] ? btrfs_queue_worker+0x275/0x275
[  480.537252]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  480.538108]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  480.538964]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  480.539831]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  480.540706]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  480.541583]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  480.542488] INFO: task btrfs-transacti:1084 blocked for more than 120 seconds.
[  480.543401]       Not tainted 3.14.0-rc1 #19
[  480.544304] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.545251] btrfs-transacti D ffff880137c52d00     0  1084      2 0x00000000
[  480.546207]  ffff880132428950 0000000000000002 0000000000012d00 ffff880132428950
[  480.547176]  ffff8800b5a35fd8 ffff8801331a5a70 ffff8801331a5ae8 0000000000000000
[  480.548147]  ffff8800aba981b8 0000000000015000 0000000000000001 ffffffff8126b986
[  480.549138] Call Trace:
[  480.550123]  [<ffffffff8126b986>] ? btrfs_start_ordered_extent+0x91/0xdf
[  480.551133]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  480.552135]  [<ffffffff8126bbff>] ? btrfs_wait_ordered_range+0xab/0x10a
[  480.553150]  [<ffffffff8128ac45>] ? __btrfs_write_out_cache+0x43c/0x67f
[  480.554163]  [<ffffffff8112d81b>] ? kmem_cache_free+0x66/0x10d
[  480.555174]  [<ffffffff8125970a>] ? btrfs_update_inode_item+0xb9/0xcd
[  480.556194]  [<ffffffff8125dd01>] ? __btrfs_prealloc_file_range+0x276/0x2db
[  480.557233]  [<ffffffff8128cbcd>] ? btrfs_write_out_ino_cache+0x3f/0x5e
[  480.558284]  [<ffffffff8124f22d>] ? btrfs_save_ino_cache+0x269/0x2ea
[  480.559329]  [<ffffffff8125582e>] ? commit_fs_roots.isra.17+0xa6/0x148
[  480.560382]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  480.561442]  [<ffffffff8107d3bc>] ? preempt_count_sub+0xbd/0xc9
[  480.562492]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  480.563544]  [<ffffffff8107d3bc>] ? preempt_count_sub+0xbd/0xc9
[  480.564588]  [<ffffffff81256ccf>] ? btrfs_commit_transaction+0x3e1/0x82b
[  480.565641]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  480.566679]  [<ffffffff81253414>] ? transaction_kthread+0xef/0x19f
[  480.567700]  [<ffffffff81253325>] ? btrfs_cleanup_transaction+0x411/0x411
[  480.568722]  [<ffffffff81072f8b>] ? kthread+0xa3/0xab
[  480.569728]  [<ffffffff810da9c1>] ? trace_preempt_on+0xd/0x2a
[  480.570721]  [<ffffffff81070000>] ? freeze_workqueues_begin+0x8/0x11e
[  480.571703]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  480.572679]  [<ffffffff815ad8ec>] ? ret_from_fork+0x7c/0xb0
[  480.573648]  [<ffffffff81072ee8>] ? __kthread_parkme+0x5a/0x5a
[  480.574625] INFO: task console-kit-dae:2176 blocked for more than 120 seconds.
[  480.575615]       Not tainted 3.14.0-rc1 #19
[  480.576596] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.577601] console-kit-dae D ffff880137c92d00     0  2176      1 0x00000000
[  480.578611]  ffff880132a2a540 0000000000000002 0000000000012d00 ffff880132a2a540
[  480.579629]  ffff8800b0469fd8 ffff8800b0469c78 ffff8800b1c0b69c 0000000000053000
[  480.580664]  0000000000053fff ffff8800b0469c90 ffff8800b1c0b680 ffffffff8126df4b
[  480.581699] Call Trace:
[  480.582719]  [<ffffffff8126df4b>] ? lock_extent_bits+0x123/0x19b
[  480.583752]  [<ffffffff81089730>] ? finish_wait+0x65/0x65
[  480.584784]  [<ffffffff81264587>] ? lock_and_cleanup_extent_if_need+0x6b/0x196
[  480.585829]  [<ffffffff812659a8>] ? __btrfs_buffered_write+0x222/0x445
[  480.586872]  [<ffffffff81265f7a>] ? btrfs_file_aio_write+0x3af/0x46f
[  480.587914]  [<ffffffff810bae0c>] ? from_kgid_munged+0xe/0x19
[  480.588955]  [<ffffffff81135d8f>] ? do_sync_write+0x5b/0x7b
[  480.589984]  [<ffffffff811360bf>] ? vfs_write+0xa6/0x101
[  480.591007]  [<ffffffff811367b2>] ? SyS_write+0x46/0x7a
[  480.592016]  [<ffffffff815adb9f>] ? tracesys+0xdd/0xe2

I've triggerd this by removing the directory of an unpacked chromium-tar under linux-3.14-rc1.
First the btrfs-transacti and 4 btrfs-endio-wri tasks came up in top with 100% for some time,
then btrfs-freespace was stuck with 100% CPU until resetting the system with SysRq.

With 0a2b2a844af616addc87cac3cc18dcaba2a9d0fb reverted on top of 3.14-rc1, btrfs-transacti
came also up with 100% CPU, but calmed down some time later and the system stayed responsive.
