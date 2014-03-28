Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56023 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbaC1DIx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 23:08:53 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 664EA427296
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 04:08:50 +0100 (CET)
Received: from localhost (ip-95-223-253-98.unitymediagroup.de [95.223.253.98])
	by mail.virtall.com (Postfix) with ESMTPSA id 3BA07427207
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 04:08:50 +0100 (CET)
Date: Fri, 28 Mar 2014 04:08:49 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: making snapshot kills RAID-1 rebuild?
Message-ID: <20140328040849.5c454118@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of drives died in my server and was replaced.

Some time after running "btrfs device delete missing ...", a read only
snapshot was made. Since then, "btrfs subvolume snapshot -r ..."
process still didn't return, and there are no more reads or writes to
any of drives in this RAID-1 filesystem.

Kernel is 3.14.0-rc8.

[22530.276924] SysRq : Show Blocked State
[22530.276987]   task                        PC stack   pid father
[22530.277074] btrfs-flush_del D ffff8807de54f000     0  5615      2 0x00000000
[22530.277141]  ffff8807dec51d88 0000000000000046 00000000000116c0 ffff8807f1d8e000
[22530.277256]  00000000000116c0 0000000000004000 ffff8807f4031800 ffff8807f1d8e000
[22530.277371]  ffff8807dec51cc8 ffff880786aed490 0000000000000001 ffff8807f1d8e000
[22530.277487] Call Trace:
[22530.277570]  [<ffffffffa02df97d>] ? extent_writepages+0x52/0x57 [btrfs]
[22530.277648]  [<ffffffffa02c8c56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[22530.277721]  [<ffffffffa02c7dbd>] ? btrfs_writepages+0x23/0x25 [btrfs]
[22530.277787]  [<ffffffff810badc0>] ? do_writepages+0x19/0x27
[22530.277850]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[22530.277924]  [<ffffffffa02da936>] btrfs_start_ordered_extent+0x77/0x8f [btrfs]
[22530.278037]  [<ffffffff81067eec>] ? __wake_up_sync+0xd/0xd
[22530.278110]  [<ffffffffa02da970>] btrfs_run_ordered_extent_work+0x22/0x32 [btrfs]
[22530.278236]  [<ffffffffa02eb649>] worker_loop+0x15e/0x495 [btrfs]
[22530.278310]  [<ffffffffa02eb4eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[22530.278374]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[22530.278436]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[22530.278499]  [<ffffffff8139a03c>] ret_from_fork+0x7c/0xb0
[22530.278561]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[22530.278626] btrfs           D ffff8807c4600000     0  7182   5619 0x00000000
[22530.278691]  ffff8807c613d8b8 0000000000000082 ffff88081fa40000 ffff8807c4600000
[22530.278805]  00000000000116c0 0000000000004000 ffff8807f4030000 ffff8807c4600000
[22530.278920]  ffff8807c613d888 00000000ffffffff ffff88009e886068 ffff88009e886068
[22530.279035] Call Trace:
[22530.279092]  [<ffffffff8105ec0b>] ? __enqueue_entity+0x64/0x66
[22530.279155]  [<ffffffff81061bc9>] ? enqueue_entity+0x611/0x73f
[22530.279218]  [<ffffffff811af13b>] ? string.isra.4+0x3d/0xa4
[22530.279281]  [<ffffffff810620b8>] ? enqueue_task_fair+0x3c1/0x42b
[22530.279344]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[22530.279404]  [<ffffffff813961ec>] schedule_timeout+0x24/0x1b9
[22530.279466]  [<ffffffff81058711>] ? ttwu_do_activate.constprop.75+0x57/0x5c
[22530.279530]  [<ffffffff8105acf6>] ? try_to_wake_up+0x211/0x222
[22530.279592]  [<ffffffff81397839>] wait_for_common+0x10d/0x13e
[22530.279653]  [<ffffffff8105ad07>] ? try_to_wake_up+0x222/0x222
[22530.279715]  [<ffffffff81397882>] wait_for_completion+0x18/0x1a
[22530.279789]  [<ffffffffa02da472>] btrfs_wait_ordered_extents+0x1a2/0x215 [btrfs]
[22530.279912]  [<ffffffffa02da5c1>] btrfs_wait_ordered_roots+0xdc/0x16c [btrfs]
[22530.279989]  [<ffffffffa030662d>] btrfs_relocate_block_group+0x145/0x275 [btrfs]
[22530.280114]  [<ffffffffa02e3e0a>] btrfs_relocate_chunk.isra.65+0x58/0x60e [btrfs]
[22530.280237]  [<ffffffffa02f27c3>] ? btrfs_set_lock_blocking_rw+0x89/0xb2 [btrfs]
[22530.280356]  [<ffffffffa02a5a2a>] ? btrfs_set_path_blocking+0x23/0x54 [btrfs]
[22530.280427]  [<ffffffffa02aa477>] ? btrfs_search_slot+0x783/0x7dd [btrfs]
[22530.280502]  [<ffffffffa02e0103>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[22530.280576]  [<ffffffffa02e60f9>] btrfs_shrink_device+0x23c/0x3a5 [btrfs]
[22530.280651]  [<ffffffffa02e8673>] btrfs_rm_device+0x29e/0x6a7 [btrfs]
[22530.280724]  [<ffffffffa02f05f9>] btrfs_ioctl+0xa48/0x25d3 [btrfs]
[22530.280789]  [<ffffffff810ce1df>] ? handle_mm_fault+0x24f/0x965
[22530.280852]  [<ffffffff8116e386>] ? avc_has_perm+0x2e/0xf2
[22530.280914]  [<ffffffff811071a9>] do_vfs_ioctl+0x3f2/0x43c
[22530.280976]  [<ffffffff81107241>] SyS_ioctl+0x4e/0x7d
[22530.281036]  [<ffffffff8102f7fd>] ? do_page_fault+0xc/0xf
[22530.281098]  [<ffffffff8139a0e2>] system_call_fastpath+0x16/0x1b
[22530.281158] rsync           D 0000000000000002     0  7233   7217 0x00000000
[22530.281224]  ffff8807bb69fb78 0000000000000086 ffff8807bb69fa88 ffff8807c4ce1800
[22530.281338]  00000000000116c0 0000000000004000 ffff8807f4031800 ffff8807c4ce1800
[22530.281453]  ffff88081fdd9d00 0000000000000046 0000000000000000 ffff8807f2071efa
[22530.281568] Call Trace:
[22530.281624]  [<ffffffff8105ad46>] ? wake_up_process+0x30/0x34
[22530.281695]  [<ffffffffa02eb4df>] ? btrfs_queue_worker+0x25d/0x269 [btrfs]
[22530.281760]  [<ffffffff810b1c94>] ? __lock_page+0x63/0x63
[22530.281822]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[22530.281882]  [<ffffffff8139711a>] io_schedule+0x8a/0xc8
[22530.281944]  [<ffffffff810b1c9d>] sleep_on_page+0x9/0xd
[22530.282005]  [<ffffffff8139767b>] __wait_on_bit+0x45/0x7e
[22530.282066]  [<ffffffff810b1a1d>] ? find_get_pages_tag+0xe9/0x123
[22530.282129]  [<ffffffff810b1ea5>] wait_on_page_bit+0x71/0x73
[22530.282191]  [<ffffffff81067f46>] ? wake_atomic_t_function+0x28/0x28
[22530.282254]  [<ffffffff810b1f5f>] filemap_fdatawait_range+0x79/0x118
[22530.282328]  [<ffffffffa02c8c56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[22530.282400]  [<ffffffffa02c7dbd>] ? btrfs_writepages+0x23/0x25 [btrfs]
[22530.282464]  [<ffffffff810badc0>] ? do_writepages+0x19/0x27
[22530.282526]  [<ffffffff810b27c3>] ? __filemap_fdatawrite_range+0x4e/0x50
[22530.282602]  [<ffffffffa02dac84>] btrfs_wait_ordered_range+0x6e/0x120 [btrfs]
[22530.282667]  [<ffffffff810e8c8e>] ? kmem_cache_free+0x178/0x18e
[22530.282740]  [<ffffffffa02cdeac>] btrfs_truncate+0x43/0x231 [btrfs]
[22530.282812]  [<ffffffffa02ce972>] btrfs_setattr+0x1bf/0x2ad [btrfs]
[22530.282875]  [<ffffffff8110e239>] notify_change+0x1ed/0x2d6
[22530.282937]  [<ffffffff810f6d5c>] do_truncate+0x62/0x87
[22530.282998]  [<ffffffff810f7076>] do_sys_ftruncate.constprop.15+0x114/0x128
[22530.283061]  [<ffffffff810f70ac>] SyS_ftruncate+0x9/0xb
[22530.283122]  [<ffffffff8139a0e2>] system_call_fastpath+0x16/0x1b
[22530.283184] btrfs-flush_del D ffff88068a9b4180     0 30924      2 0x00000000
[22530.283248]  ffff8806729e7d88 0000000000000046 000000010011a3e7 ffff88009e886000
[22530.283363]  00000000000116c0 0000000000004000 ffff8807f4036000 ffff88009e886000
[22530.283478]  0000000000000000 ffff880735d5eeb0 0000000000000001 ffff88009e886000
[22530.283593] Call Trace:
[22530.283660]  [<ffffffffa02df97d>] ? extent_writepages+0x52/0x57 [btrfs]
[22530.283734]  [<ffffffffa02c8c56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[22530.283805]  [<ffffffffa02c7dbd>] ? btrfs_writepages+0x23/0x25 [btrfs]
[22530.283868]  [<ffffffff810badc0>] ? do_writepages+0x19/0x27
[22530.283930]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[22530.284001]  [<ffffffffa02da936>] btrfs_start_ordered_extent+0x77/0x8f [btrfs]
[22530.284114]  [<ffffffff81067eec>] ? __wake_up_sync+0xd/0xd
[22530.284185]  [<ffffffffa02da970>] btrfs_run_ordered_extent_work+0x22/0x32 [btrfs]
[22530.284309]  [<ffffffffa02eb649>] worker_loop+0x15e/0x495 [btrfs]
[22530.284381]  [<ffffffffa02eb4eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[22530.284445]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[22530.284506]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[22530.284570]  [<ffffffff8139a03c>] ret_from_fork+0x7c/0xb0
[22530.284631]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[22530.284695] btrfs           D ffff8807f2034800     0 32297  30191 0x00000000
[22530.284759]  ffff88009c3d99e8 0000000000000082 ffff88009c3d98e8 ffff8807f2034800
[22530.286266]  00000000000116c0 0000000000004000 ffff8807f4031800 ffff8807f2034800
[22530.286381]  ffff88009c3d9948 ffffffff81056718 000000000000000a 0000000000000000
[22530.286495] Call Trace:
[22530.286552]  [<ffffffff81056718>] ? task_rq_lock+0x48/0x7e
[22530.286614]  [<ffffffff8105ec0b>] ? __enqueue_entity+0x64/0x66
[22530.286676]  [<ffffffff81061bc9>] ? enqueue_entity+0x611/0x73f
[22530.286738]  [<ffffffff811af13b>] ? string.isra.4+0x3d/0xa4
[22530.286800]  [<ffffffff810620b8>] ? enqueue_task_fair+0x3c1/0x42b
[22530.286863]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[22530.286923]  [<ffffffff813961ec>] schedule_timeout+0x24/0x1b9
[22530.286985]  [<ffffffff81058603>] ? ttwu_do_wakeup+0x12/0x7f
[22530.287046]  [<ffffffff81058711>] ? ttwu_do_activate.constprop.75+0x57/0x5c
[22530.287109]  [<ffffffff8105acf6>] ? try_to_wake_up+0x211/0x222
[22530.287171]  [<ffffffff81397839>] wait_for_common+0x10d/0x13e
[22530.287233]  [<ffffffff8105ad07>] ? try_to_wake_up+0x222/0x222
[22530.287294]  [<ffffffff81397882>] wait_for_completion+0x18/0x1a
[22530.287369]  [<ffffffffa02d2853>] btrfs_wait_and_free_delalloc_work+0x13/0x26 [btrfs]
[22530.287492]  [<ffffffffa02d2a08>] __start_delalloc_inodes+0x1a2/0x24f [btrfs]
[22530.287566]  [<ffffffffa02d2ade>] btrfs_start_delalloc_inodes+0x29/0xf3 [btrfs]
[22530.287688]  [<ffffffffa02ed84e>] btrfs_mksubvol.isra.63+0x119/0x372 [btrfs]
[22530.287762]  [<ffffffffa02edbf6>] btrfs_ioctl_snap_create_transid+0x14f/0x180 [btrfs]
[22530.287875]  [<ffffffff810eab00>] ? __kmalloc_track_caller+0x45/0x158
[22530.287946]  [<ffffffffa02edd55>] btrfs_ioctl_snap_create_v2+0xc2/0x115 [btrfs]
[22530.288059]  [<ffffffff810cabaf>] ? __do_fault+0x3ce/0x408
[22530.288130]  [<ffffffffa02f025b>] btrfs_ioctl+0x6aa/0x25d3 [btrfs]
[22530.288194]  [<ffffffff810ce1df>] ? handle_mm_fault+0x24f/0x965
[22530.288256]  [<ffffffff8116e386>] ? avc_has_perm+0x2e/0xf2
[22530.288318]  [<ffffffff811071a9>] do_vfs_ioctl+0x3f2/0x43c
[22530.288380]  [<ffffffff81107241>] SyS_ioctl+0x4e/0x7d
[22530.288440]  [<ffffffff8102f7fd>] ? do_page_fault+0xc/0xf
[22530.288501]  [<ffffffff8139a0e2>] system_call_fastpath+0x16/0x1b
[22530.288564] Sched Debug Version: v0.11, 3.14.0-rc8 #1
[22530.288623] ktime                                   : 22543566.176065
[22530.288684] sched_clk                               : 22530288.562574
[22530.288746] cpu_clk                                 : 22530288.562607
[22530.288807] jiffies                                 : 4297191652
[22530.288867] sched_clock_stable()                    : 1
[22530.288926] 
[22530.288978] sysctl_sched
[22530.289033]   .sysctl_sched_latency                    : 24.000000
[22530.289094]   .sysctl_sched_min_granularity            : 3.000000
[22530.289154]   .sysctl_sched_wakeup_granularity         : 4.000000
[22530.289215]   .sysctl_sched_child_runs_first           : 0
[22530.289274]   .sysctl_sched_features                   : 11899
[22530.289335]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[22530.289396] 
[22530.289448] cpu#0, 3400.082 MHz
[22530.289503]   .nr_running                    : 0
[22530.289561]   .load                          : 0
[22530.289619]   .nr_switches                   : 3507722
[22530.289678]   .nr_load_updates               : 805575
[22530.289736]   .nr_uninterruptible            : -11017
[22530.289795]   .next_balance                  : 4297.191615
[22530.289854]   .curr->pid                     : 0
[22530.289912]   .clock                         : 22530276.914581
[22530.289972]   .cpu_load[0]                   : 0
[22530.290030]   .cpu_load[1]                   : 0
[22530.290087]   .cpu_load[2]                   : 0
[22530.290145]   .cpu_load[3]                   : 0
[22530.290204]   .cpu_load[4]                   : 0
[22530.290261]   .yld_count                     : 0
[22530.290319]   .sched_count                   : 3973365
[22530.290378]   .sched_goidle                  : 1572201
[22530.290436]   .avg_idle                      : 921830
[22530.290495]   .ttwu_count                    : 2358296
[22530.290554]   .ttwu_local                    : 1598952
[22530.290613] 
[22530.290613] cfs_rq[0]:/autogroup-157
[22530.290721]   .exec_clock                    : 809.182104
[22530.290780]   .MIN_vruntime                  : 0.000001
[22530.290840]   .min_vruntime                  : 807.046150
[22530.290898]   .max_vruntime                  : 0.000001
[22530.290957]   .spread                        : 0.000000
[22530.291016]   .spread0                       : -248107.038102
[22530.291076]   .nr_spread_over                : 0
[22530.291134]   .nr_running                    : 0
[22530.291191]   .load                          : 0
[22530.291249]   .runnable_load_avg             : 0
[22530.291307]   .blocked_load_avg              : 0
[22530.291365]   .tg_load_contrib               : 0
[22530.291422]   .tg_runnable_contrib           : 0
[22530.291480]   .tg_load_avg                   : 0
[22530.291538]   .tg->runnable_avg              : 0
[22530.291595]   .tg->cfs_bandwidth.timer_active: 0
[22530.291654]   .throttled                     : 0
[22530.291711]   .throttle_count                : 0
[22530.291770]   .se->exec_start                : 22530276.912362
[22530.291830]   .se->vruntime                  : 248902.998339
[22530.291890]   .se->sum_exec_runtime          : 809.199506
[22530.291949]   .se->statistics.wait_start     : 0.000000
[22530.292008]   .se->statistics.sleep_start    : 0.000000
[22530.292067]   .se->statistics.block_start    : 0.000000
[22530.292126]   .se->statistics.sleep_max      : 0.000000
[22530.292185]   .se->statistics.block_max      : 0.000000
[22530.292244]   .se->statistics.exec_max       : 7.542286
[22530.292303]   .se->statistics.slice_max      : 0.134499
[22530.292362]   .se->statistics.wait_max       : 2.275916
[22530.292422]   .se->statistics.wait_sum       : 4.847488
[22530.292481]   .se->statistics.wait_count     : 8362
[22530.292539]   .se->load.weight               : 2
[22530.292597]   .se->avg.runnable_avg_sum      : 131
[22530.292655]   .se->avg.runnable_avg_period   : 47335
[22530.292713]   .se->avg.load_avg_contrib      : 0
[22530.292771]   .se->avg.decay_count           : 21486547
[22530.292830] 
[22530.292830] cfs_rq[0]:/
[22530.292935]   .exec_clock                    : 258014.906633
[22530.292995]   .MIN_vruntime                  : 0.000001
[22530.293053]   .min_vruntime                  : 248914.084252
[22530.293113]   .max_vruntime                  : 0.000001
[22530.293171]   .spread                        : 0.000000
[22530.293230]   .spread0                       : 0.000000
[22530.293289]   .nr_spread_over                : 655
[22530.293347]   .nr_running                    : 0
[22530.293404]   .load                          : 0
[22530.293462]   .runnable_load_avg             : 0
[22530.293520]   .blocked_load_avg              : 0
[22530.293577]   .tg_load_contrib               : 0
[22530.293635]   .tg_runnable_contrib           : 2
[22530.293693]   .tg_load_avg                   : 0
[22530.293750]   .tg->runnable_avg              : 12
[22530.293808]   .tg->cfs_bandwidth.timer_active: 0
[22530.293866]   .throttled                     : 0
[22530.293924]   .throttle_count                : 0
[22530.293981]   .avg->runnable_avg_sum         : 137
[22530.294039]   .avg->runnable_avg_period      : 47365
[22530.294100] 
[22530.294100] rt_rq[0]:/
[22530.294204]   .rt_nr_running                 : 0
[22530.294262]   .rt_throttled                  : 0
[22530.294320]   .rt_time                       : 0.000000
[22530.294379]   .rt_runtime                    : 950.000000
[22530.294439] 
[22530.294439] runnable tasks:
[22530.294439]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.294439] ----------------------------------------------------------------------------------------------------------
[22530.294775]      ksoftirqd/0     3    248892.504894     20815   120    248892.504894       667.383969  22497309.102745 /
[22530.294898]     kworker/0:0H     5       864.972294         5   100       864.972294         0.025760      1076.756375 /
[22530.295021]      migration/0     9         0.000000       170     0         0.000000       456.738855         0.000863 /
[22530.295143]       watchdog/0    10       -11.811076      5645     0       -11.811076        63.673987        95.067330 /
[22530.295269]      kworker/0:2   700     23319.696806        18   120     23319.696806         0.066300   1208699.947715 /
[22530.295391]        scsi_eh_2   878       861.043683        18   120       861.043683         2.567128       361.349574 /
[22530.295513]     kworker/0:1H   900    248901.202086    339756   100    248901.202086      3451.660543  22521748.843741 /
[22530.295636]        md2_raid1   953    248901.239713     23372   120    248901.239713       720.917596  22524405.501598 /
[22530.295758]       jbd2/md2-8   967    248900.964661     14480   120    248900.964661       711.234331  22522749.431203 /
[22530.295881]      btrfs-rmw-1  2281    248847.482316       228   120    248847.482316         4.048357  22426773.396194 /
[22530.296003]  btrfs-freespace  2285    248857.343412       223   120    248857.343412         9.639232  22461638.651443 /
[22530.296126]  btrfs-readahead  2288    248847.485369       215   120    248847.485369         3.141312  22426784.100990 /
[22530.296249]             sshd  2754         0.380031         5   120         0.380031         0.996694    593475.387857 /autogroup-6
[22530.296374]            rsync  3750        22.677844        12   139        22.677844         1.578214       291.920835 /autogroup-33
[22530.296505]            getty  4177         0.464289        95   120         0.464289         1.899354        52.176395 /autogroup-65
[22530.296630]             sshd  4874       807.046150     11493   120       807.046150      1084.400149  22062813.800188 /autogroup-157
[22530.296754]  btrfs-endio-met  5609    248846.872432       229   120    248846.872432         3.033588  21827114.799170 /
[22530.296876]    btrfs-cache-1  5613    248797.550230      7194   120    248797.550230       558.578685  21802633.979139 /
[22530.298387]             sshd  5617       486.720744      4793   120       486.720744       531.200521  21887185.058173 /autogroup-246
[22530.298512]      kworker/0:1  6394    248902.102587    368771   120    248902.102587      4552.184312  21613790.232133 /
[22530.298634]             bash  7123         5.892870       115   120         5.892870        44.700616       992.878781 /autogroup-429
[22530.298759]  snapbackup-run- 30189         0.270167         2   120         0.270167         0.874786         0.006102 /autogroup-3415
[22530.298883]    snapbackup.sh 30191      1412.240353        41   120      1412.240353         5.733957   1039790.246669 /autogroup-3415
[22530.299008]  btrfs-endio-met 31577    248899.815837     74281   120    248899.815837      1531.255384  10478537.720783 /
[22530.299130]    btrfs-endio-4 32272    248844.719242       598   120    248844.719242       239.272278  10111112.622058 /
[22530.299251]           pickup 12729        30.098547        76   120        30.098547         8.044460   4441773.013360 /autogroup-58
[22530.299375]             bash 13443        22.321558       143   120        22.321558        48.000218   4327022.584033 /autogroup-5431
[22530.299500] 
[22530.299552] cpu#1, 3400.082 MHz
[22530.299607]   .nr_running                    : 1
[22530.299665]   .load                          : 1024
[22530.299723]   .nr_switches                   : 2074053
[22530.299782]   .nr_load_updates               : 520113
[22530.299841]   .nr_uninterruptible            : -3039
[22530.299900]   .next_balance                  : 4297.191616
[22530.299960]   .curr->pid                     : 4876
[22530.300018]   .clock                         : 22530276.841766
[22530.300078]   .cpu_load[0]                   : 0
[22530.300136]   .cpu_load[1]                   : 0
[22530.300193]   .cpu_load[2]                   : 0
[22530.300251]   .cpu_load[3]                   : 0
[22530.300308]   .cpu_load[4]                   : 0
[22530.300367]   .yld_count                     : 0
[22530.300424]   .sched_count                   : 2138399
[22530.300483]   .sched_goidle                  : 974120
[22530.300542]   .avg_idle                      : 1000000
[22530.300601]   .ttwu_count                    : 931846
[22530.300659]   .ttwu_local                    : 526811
[22530.300717] 
[22530.300717] cfs_rq[1]:/autogroup-158
[22530.300824]   .exec_clock                    : 667.073283
[22530.300883]   .MIN_vruntime                  : 0.000001
[22530.300943]   .min_vruntime                  : 632.314349
[22530.301002]   .max_vruntime                  : 0.000001
[22530.301061]   .spread                        : 0.000000
[22530.301120]   .spread0                       : -248281.769903
[22530.301179]   .nr_spread_over                : 75
[22530.301238]   .nr_running                    : 1
[22530.301295]   .load                          : 1024
[22530.301353]   .runnable_load_avg             : 7
[22530.301412]   .blocked_load_avg              : 0
[22530.301469]   .tg_load_contrib               : 0
[22530.301527]   .tg_runnable_contrib           : 0
[22530.301584]   .tg_load_avg                   : 0
[22530.301642]   .tg->runnable_avg              : 0
[22530.301700]   .tg->cfs_bandwidth.timer_active: 0
[22530.301757]   .throttled                     : 0
[22530.301815]   .throttle_count                : 0
[22530.301873]   .se->exec_start                : 22530276.841766
[22530.301933]   .se->vruntime                  : 142845.101369
[22530.301993]   .se->sum_exec_runtime          : 667.073283
[22530.302053]   .se->statistics.wait_start     : 0.000000
[22530.302112]   .se->statistics.sleep_start    : 0.000000
[22530.302171]   .se->statistics.block_start    : 0.000000
[22530.302231]   .se->statistics.sleep_max      : 0.000000
[22530.302290]   .se->statistics.block_max      : 0.000000
[22530.302349]   .se->statistics.exec_max       : 74.440664
[22530.302408]   .se->statistics.slice_max      : 0.028242
[22530.302466]   .se->statistics.wait_max       : 0.064807
[22530.302526]   .se->statistics.wait_sum       : 7.245129
[22530.302585]   .se->statistics.wait_count     : 5828
[22530.302643]   .se->load.weight               : 1024
[22530.302701]   .se->avg.runnable_avg_sum      : 382
[22530.302759]   .se->avg.runnable_avg_period   : 49064
[22530.302817]   .se->avg.load_avg_contrib      : 0
[22530.302875]   .se->avg.decay_count           : 0
[22530.302933] 
[22530.302933] cfs_rq[1]:/autogroup-34
[22530.303039]   .exec_clock                    : 227.081107
[22530.303099]   .MIN_vruntime                  : 0.000001
[22530.303158]   .min_vruntime                  : 226.032531
[22530.303217]   .max_vruntime                  : 0.000001
[22530.303276]   .spread                        : 0.000000
[22530.303334]   .spread0                       : -248688.051721
[22530.303394]   .nr_spread_over                : 0
[22530.303452]   .nr_running                    : 0
[22530.303509]   .load                          : 0
[22530.303568]   .runnable_load_avg             : 0
[22530.303625]   .blocked_load_avg              : 0
[22530.303683]   .tg_load_contrib               : 0
[22530.303740]   .tg_runnable_contrib           : 0
[22530.303798]   .tg_load_avg                   : 0
[22530.303856]   .tg->runnable_avg              : 0
[22530.303913]   .tg->cfs_bandwidth.timer_active: 0
[22530.303971]   .throttled                     : 0
[22530.304029]   .throttle_count                : 0
[22530.304087]   .se->exec_start                : 22530121.083904
[22530.304147]   .se->vruntime                  : 142840.707424
[22530.304206]   .se->sum_exec_runtime          : 227.090067
[22530.304266]   .se->statistics.wait_start     : 0.000000
[22530.304325]   .se->statistics.sleep_start    : 0.000000
[22530.304384]   .se->statistics.block_start    : 0.000000
[22530.304443]   .se->statistics.sleep_max      : 0.000000
[22530.304502]   .se->statistics.block_max      : 0.000000
[22530.304561]   .se->statistics.exec_max       : 0.226787
[22530.304620]   .se->statistics.slice_max      : 0.039417
[22530.304679]   .se->statistics.wait_max       : 0.010746
[22530.304738]   .se->statistics.wait_sum       : 0.063309
[22530.304797]   .se->statistics.wait_count     : 6988
[22530.304855]   .se->load.weight               : 2
[22530.304913]   .se->avg.runnable_avg_sum      : 26
[22530.304970]   .se->avg.runnable_avg_period   : 48661
[22530.305030]   .se->avg.load_avg_contrib      : 0
[22530.305087]   .se->avg.decay_count           : 21486398
[22530.305146] 
[22530.305146] cfs_rq[1]:/
[22530.305250]   .exec_clock                    : 150878.668869
[22530.305309]   .MIN_vruntime                  : 0.000001
[22530.305368]   .min_vruntime                  : 142852.680775
[22530.305428]   .max_vruntime                  : 0.000001
[22530.305486]   .spread                        : 0.000000
[22530.305546]   .spread0                       : -106061.403477
[22530.305605]   .nr_spread_over                : 547
[22530.305663]   .nr_running                    : 1
[22530.305721]   .load                          : 1024
[22530.305779]   .runnable_load_avg             : 0
[22530.305837]   .blocked_load_avg              : 0
[22530.305895]   .tg_load_contrib               : 0
[22530.305953]   .tg_runnable_contrib           : 8
[22530.306011]   .tg_load_avg                   : 0
[22530.306068]   .tg->runnable_avg              : 12
[22530.306127]   .tg->cfs_bandwidth.timer_active: 0
[22530.306184]   .throttled                     : 0
[22530.306242]   .throttle_count                : 0
[22530.306300]   .avg->runnable_avg_sum         : 384
[22530.306358]   .avg->runnable_avg_period      : 47988
[22530.306417] 
[22530.306417] rt_rq[1]:/
[22530.306521]   .rt_nr_running                 : 0
[22530.306579]   .rt_throttled                  : 0
[22530.306637]   .rt_time                       : 0.000000
[22530.306696]   .rt_runtime                    : 950.000000
[22530.306756] 
[22530.306756] runnable tasks:
[22530.306756]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.306756] ----------------------------------------------------------------------------------------------------------
[22530.307091]       watchdog/1    11        -2.981856      5639     0        -2.981856        62.498815        87.222280 /
[22530.307213]      migration/1    12         0.000000       121     0         0.000000         5.988127         0.000785 /
[22530.307335]      ksoftirqd/1    13    142839.223283     27668   120    142839.223283       668.479767  22523927.005548 /
[22530.307456]      kworker/1:0    14        -7.015031        13   120        -7.015031         0.034470       491.515728 /
[22530.307578]     kworker/1:0H    15       345.641656         6   100       345.641656         0.018471      1079.161334 /
[22530.307701]            khubd   361      1283.666783        62   120      1283.666783         3.049676     34042.847451 /
[22530.307823]       khungtaskd   507    142808.352161       189   120    142808.352161        35.908898  22426745.793827 /
[22530.307946]      kworker/1:1   614    142840.704806    366779   120    142840.704806      4491.144543  22522298.864669 /
[22530.308069]        scsi_eh_5   884       331.894030        18   120       331.894030         2.630248       350.867278 /
[22530.308191]     kworker/1:1H   913    142625.552716     42328   100    142625.552716       276.438462  22382513.092065 /
[22530.308315]  btrfs-endio-wri  2284    142819.804790       237   120    142819.804790         4.290606  22426772.955294 /
[22530.308437]          vnstatd  3028       229.218992      4640   120       229.218992       640.155000  22477878.279644 /autogroup-9
[22530.308561]         rsyslogd  3124       567.970367     11069   120       567.970367       599.293460  22479710.563717 /autogroup-8
[22530.308685]       munin-node  3170       644.834766     11484   120       644.834766       861.122874  22480166.953224 /autogroup-11
[22530.308810]          apache2  3354       104.205511     22473   120       104.205511       452.575770  22480263.182606 /autogroup-24
[22530.308933]          apache2  3397        15.008506       495   120        15.008506         8.273786   5744379.429239 /autogroup-24
[22530.310446]          apache2  3398        21.269230       140   120        21.269230         2.618367   7109168.015486 /autogroup-24
[22530.310570]          apache2  3399        19.891432         4   120        19.891432         0.387395   7109698.568698 /autogroup-24
[22530.310693]          apache2  3400        19.890045         4   120        19.890045         0.416336   7110378.554222 /autogroup-24
[22530.310817]             ntpd  3758       226.032531     23826   120       226.032531       827.040618  22479914.778204 /autogroup-34
[22530.310941]            getty  4174         0.839315       102   120         0.839315         2.094155        53.704563 /autogroup-62
[22530.311065] R           bash  4876       632.314349      1890   120       632.314349       392.261830  22063145.517377 /autogroup-158
[22530.311189]    btrfs-fixup-1  5604    142819.200286       211   120    142819.200286         4.891033  21827123.714318 /
[22530.311311]  btrfs-qgroup-re  5616    142819.228435       218   120    142819.228435         3.132755  21827124.482051 /
[22530.311433]          apache2  6387        31.587596         4   120        31.587596         0.570381   6281498.461094 /autogroup-24
[22530.311557]            btrfs  7182     47316.399566    921574   120     47316.399566    232067.852203  10498065.741354 /autogroup-247
[22530.311682]            rsync  7217      3510.806718     62358   120      3510.806718      3073.485160  21219003.983830 /autogroup-429
[22530.311806]  btrfs-delayed-m  7241    142817.056230     50436   120    142817.056230      2779.348392  21162744.974431 /
[22530.311928]  btrfs-endio-wri 31606    142830.526736       181   120    142830.526736        12.730314  10333643.192282 /
[22530.312051]    kworker/u16:2 12808    142839.826554      2449   120    142839.826554       273.465604   4404294.347679 /
[22530.312173] 
[22530.312225] cpu#2, 3400.082 MHz
[22530.312281]   .nr_running                    : 0
[22530.312338]   .load                          : 0
[22530.312396]   .nr_switches                   : 2166478
[22530.312455]   .nr_load_updates               : 529639
[22530.312513]   .nr_uninterruptible            : -6330
[22530.312572]   .next_balance                  : 4297.191617
[22530.312631]   .curr->pid                     : 0
[22530.312689]   .clock                         : 22529912.634257
[22530.312748]   .cpu_load[0]                   : 0
[22530.312807]   .cpu_load[1]                   : 0
[22530.312864]   .cpu_load[2]                   : 0
[22530.312922]   .cpu_load[3]                   : 0
[22530.312980]   .cpu_load[4]                   : 0
[22530.313037]   .yld_count                     : 0
[22530.313095]   .sched_count                   : 2254291
[22530.313154]   .sched_goidle                  : 1006282
[22530.313213]   .avg_idle                      : 1000000
[22530.313272]   .ttwu_count                    : 1044976
[22530.313330]   .ttwu_local                    : 609429
[22530.313389] 
[22530.313389] cfs_rq[2]:/autogroup-428
[22530.313496]   .exec_clock                    : 1730.310039
[22530.313556]   .MIN_vruntime                  : 0.000001
[22530.313614]   .min_vruntime                  : 1729.261463
[22530.313674]   .max_vruntime                  : 0.000001
[22530.313733]   .spread                        : 0.000000
[22530.313791]   .spread0                       : -247184.822789
[22530.313851]   .nr_spread_over                : 0
[22530.313909]   .nr_running                    : 0
[22530.313966]   .load                          : 0
[22530.314024]   .runnable_load_avg             : 0
[22530.314082]   .blocked_load_avg              : 0
[22530.314140]   .tg_load_contrib               : 0
[22530.314198]   .tg_runnable_contrib           : 1
[22530.314256]   .tg_load_avg                   : 0
[22530.314313]   .tg->runnable_avg              : 1
[22530.314371]   .tg->cfs_bandwidth.timer_active: 0
[22530.314429]   .throttled                     : 0
[22530.314486]   .throttle_count                : 0
[22530.314545]   .se->exec_start                : 22529878.504574
[22530.314605]   .se->vruntime                  : 120575.111665
[22530.314664]   .se->sum_exec_runtime          : 1730.321837
[22530.314725]   .se->statistics.wait_start     : 0.000000
[22530.314783]   .se->statistics.sleep_start    : 0.000000
[22530.314843]   .se->statistics.block_start    : 0.000000
[22530.314902]   .se->statistics.sleep_max      : 0.000000
[22530.314960]   .se->statistics.block_max      : 0.000000
[22530.315020]   .se->statistics.exec_max       : 7.676439
[22530.315078]   .se->statistics.slice_max      : 0.120501
[22530.315137]   .se->statistics.wait_max       : 0.039686
[22530.315196]   .se->statistics.wait_sum       : 2.301828
[22530.315255]   .se->statistics.wait_count     : 25524
[22530.315314]   .se->load.weight               : 2
[22530.315371]   .se->avg.runnable_avg_sum      : 49
[22530.315429]   .se->avg.runnable_avg_period   : 46613
[22530.315487]   .se->avg.load_avg_contrib      : 0
[22530.315545]   .se->avg.decay_count           : 21486167
[22530.315605] 
[22530.315605] cfs_rq[2]:/
[22530.315710]   .exec_clock                    : 125325.860514
[22530.315769]   .MIN_vruntime                  : 0.000001
[22530.315828]   .min_vruntime                  : 120575.111665
[22530.315888]   .max_vruntime                  : 0.000001
[22530.315947]   .spread                        : 0.000000
[22530.316006]   .spread0                       : -128338.972587
[22530.316065]   .nr_spread_over                : 555
[22530.316123]   .nr_running                    : 0
[22530.316181]   .load                          : 0
[22530.316238]   .runnable_load_avg             : 0
[22530.316297]   .blocked_load_avg              : 0
[22530.316354]   .tg_load_contrib               : 0
[22530.316412]   .tg_runnable_contrib           : 2
[22530.316470]   .tg_load_avg                   : 0
[22530.316527]   .tg->runnable_avg              : 11
[22530.316586]   .tg->cfs_bandwidth.timer_active: 0
[22530.316643]   .throttled                     : 0
[22530.316701]   .throttle_count                : 0
[22530.316759]   .avg->runnable_avg_sum         : 106
[22530.316817]   .avg->runnable_avg_period      : 46717
[22530.316876] 
[22530.316876] rt_rq[2]:/
[22530.316980]   .rt_nr_running                 : 0
[22530.317039]   .rt_throttled                  : 0
[22530.317096]   .rt_time                       : 0.000000
[22530.317155]   .rt_runtime                    : 950.000000
[22530.317214] 
[22530.317214] runnable tasks:
[22530.317214]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.317214] ----------------------------------------------------------------------------------------------------------
[22530.317549]             init     1        34.237478      5429   120        34.237478       536.506774  22528629.359900 /autogroup-2
[22530.317673]           rcu_bh     8      3988.124030         5   120      3988.124030         0.068102    309972.486503 /
[22530.317796]       watchdog/2    16        -5.977800      5639     0        -5.977800        59.835958        73.610920 /
[22530.317919]      migration/2    17         0.000000       101     0         0.000000         5.849580         0.001040 /
[22530.318041]      ksoftirqd/2    18    120549.467864     25959   120    120549.467864       480.198915  22497498.713614 /
[22530.318163]      kworker/2:0    19      5305.173951        16   120      5305.173951         0.050614   1105947.617632 /
[22530.318284]     kworker/2:0H    20       337.907610         6   100       337.907610         0.046118      1086.075641 /
[22530.318408]    fsnotify_mark   585      4667.309172        26   120      4667.309172         0.688965    908665.309575 /
[22530.318532]     kworker/2:1H   919    120074.406304     72690   100    120074.406304       369.889288  22378951.531283 /
[22530.318654]        md1_raid1   945    119752.731680       102   120    119752.731680         2.490640  22036918.363093 /
[22530.318776]  btrfs-genwork-1  2275    120551.049828       203   120    120551.049828         6.264482  22466969.166099 /
[22530.318898]    btrfs-fixup-1  2278    120536.016930       216   120    120536.016930         2.858137  22426805.064861 /
[22530.319020]    btrfs-endio-1  2279    120536.035313       221   120    120536.035313         6.143953  22426761.562380 /
[22530.319142]  btrfs-endio-rai  2282    120536.036506       232   120    120536.036506         3.889816  22426772.944779 /
[22530.319264]  btrfs-endio-met  2283    120536.009812       218   120    120536.009812         5.803848  22426761.911583 /
[22530.319386]  btrfs-delayed-m  2286    120536.017145       202   120    120536.017145         3.258624  22426794.598019 /
[22530.319508]  btrfs-transacti  2322    120557.306471     27242   120    120557.306471      2611.705508  22466979.009431 /
[22530.319630]    rs:main Q:Reg  3123       526.436176     11582   120       526.436176      1376.828510  22478929.226354 /autogroup-8
[22530.319754]         rsyslogd  3125       441.204205        52   120       441.204205         4.037016  17973802.534553 /autogroup-8
[22530.319878]          apache2  3396        69.461288      1622   120        69.461288        24.001873  22476889.066979 /autogroup-24
[22530.320003]          proftpd  4129        37.816560      1661   120        37.816560       103.209346  22455891.824322 /autogroup-60
[22530.320127]            getty  4173         2.702581       100   120         2.702581         4.247579        51.857295 /autogroup-61
[22530.320251]   btrfs-submit-1  5602    120545.766203     14061   120    120545.766203       303.818058  21854275.486264 /
[22530.320374]  btrfs-endio-rai  5608    120535.321126       227   120    120535.321126         3.615731  21827114.615043 /
[22530.320496]  btrfs-freespace  5611    120534.481049      8846   120    120534.481049       507.894424  21824057.505415 /
[22530.320618]  btrfs-readahead  5614    120535.340917       212   120    120535.340917         4.378350  21827123.829935 /
[22530.320740]  btrfs-flush_del  5615     69196.236094       112   120     69196.236094         3.632515  11219175.607685 /
[22530.320861]             bash  5619       497.310559       196   120       497.310559        61.584625    480244.525172 /autogroup-247
[22530.320986]      kworker/2:2  6368    120563.162736    370073   120    120563.162736      4337.359140  21719278.468694 /
[22530.322493]             tmux  7122      1729.261463     76946   120      1729.261463      5588.366093  21417091.462972 /autogroup-428
[22530.322618]              ssh  7218      3902.067624     39107   120      3902.067624      5071.252249   1409659.629578 /autogroup-429
[22530.322742]            rsync  7233      3906.907543    134807   120      3906.907543     12511.401135   1393899.260464 /autogroup-429
[22530.322866]   btrfs-worker-2  9957    120545.791230      3529   120    120545.791230       171.649767  20183115.892225 /
[22530.322988]               sh 30188         0.685951         2   120         0.685951         0.901134         0.006914 /autogroup-3415
[22530.323113]            btrfs 32297      1967.734855         3   120      1967.734855         0.723562         0.069948 /autogroup-3415
[22530.323238] 
[22530.323290] cpu#3, 3400.082 MHz
[22530.323345]   .nr_running                    : 0
[22530.323402]   .load                          : 0
[22530.323460]   .nr_switches                   : 2198261
[22530.323518]   .nr_load_updates               : 520761
[22530.323577]   .nr_uninterruptible            : -6008
[22530.323636]   .next_balance                  : 4297.191655
[22530.323695]   .curr->pid                     : 0
[22530.323753]   .clock                         : 22530292.421592
[22530.323824]   .cpu_load[0]                   : 0
[22530.323882]   .cpu_load[1]                   : 0
[22530.323940]   .cpu_load[2]                   : 0
[22530.323997]   .cpu_load[3]                   : 0
[22530.324055]   .cpu_load[4]                   : 0
[22530.324113]   .yld_count                     : 0
[22530.324171]   .sched_count                   : 2243914
[22530.324229]   .sched_goidle                  : 1033185
[22530.324288]   .avg_idle                      : 1000000
[22530.324347]   .ttwu_count                    : 933876
[22530.324405]   .ttwu_local                    : 524476
[22530.324464] 
[22530.324464] cfs_rq[3]:/
[22530.324568]   .exec_clock                    : 143341.067012
[22530.324628]   .MIN_vruntime                  : 0.000001
[22530.324687]   .min_vruntime                  : 136633.722718
[22530.324747]   .max_vruntime                  : 0.000001
[22530.324805]   .spread                        : 0.000000
[22530.324865]   .spread0                       : -112280.361534
[22530.324924]   .nr_spread_over                : 612
[22530.324982]   .nr_running                    : 0
[22530.325040]   .load                          : 0
[22530.325097]   .runnable_load_avg             : 0
[22530.325155]   .blocked_load_avg              : 0
[22530.325213]   .tg_load_contrib               : 0
[22530.325271]   .tg_runnable_contrib           : 0
[22530.325329]   .tg_load_avg                   : 0
[22530.325386]   .tg->runnable_avg              : 10
[22530.325444]   .tg->cfs_bandwidth.timer_active: 0
[22530.325502]   .throttled                     : 0
[22530.325559]   .throttle_count                : 0
[22530.325617]   .avg->runnable_avg_sum         : 15
[22530.325674]   .avg->runnable_avg_period      : 48630
[22530.325733] 
[22530.325733] rt_rq[3]:/
[22530.325837]   .rt_nr_running                 : 0
[22530.325895]   .rt_throttled                  : 0
[22530.325953]   .rt_time                       : 0.000000
[22530.326012]   .rt_runtime                    : 950.000000
[22530.326072] 
[22530.326072] runnable tasks:
[22530.326072]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.326072] ----------------------------------------------------------------------------------------------------------
[22530.326408]        rcu_sched     7    136633.722718    558259   120    136633.722718     23574.833814  22505282.071390 /
[22530.326531]       watchdog/3    21        -5.983471      5639     0        -5.983471        58.162928        60.002758 /
[22530.326653]      migration/3    22         0.000000       111     0         0.000000         5.940465         0.000776 /
[22530.326774]      ksoftirqd/3    23    136620.302472     28018   120    136620.302472       599.994556  22523974.798399 /
[22530.326895]      kworker/3:0    24      3861.435559        17   120      3861.435559         0.048979    335090.635899 /
[22530.327017]     kworker/3:0H    25       353.943497         6   100       353.943497         0.018093      1042.114442 /
[22530.327140]        kpsmoused   697        11.104349         2   100        11.104349         0.006361         0.011634 /
[22530.327263]     kworker/3:1H   905    136590.411032     31449   100    136590.411032       224.880863  22451347.174667 /
[22530.327386]        md0_raid1   937    131267.895657        94   120    131267.895657         2.197444  22037123.463863 /
[22530.327508]      kworker/3:2  1539    136621.734608    384567   120    136621.734608      4665.780706  22488882.816093 /
[22530.327629]   btrfs-worker-1  2274    136601.460396       210   120    136601.460396         3.313660  22426805.267226 /
[22530.327751]   btrfs-submit-1  2276    136601.413588       216   120    136601.413588         2.942803  22426785.493436 /
[22530.327873]  btrfs-endio-met  2280    136618.934809     32323   120    136618.934809       924.387644  22483022.539249 /
[22530.327996]  btrfs-qgroup-re  2290    136601.391933       213   120    136601.391933         3.907423  22426793.545283 /
[22530.328118]            acpid  3152         0.951311         4   120         0.951311         0.391560        13.197935 /autogroup-10
[22530.328243]           master  4110        13.291707      1121   120        13.291707        62.893352  22443719.990334 /autogroup-58
[22530.328367]            getty  4176         0.828660       101   120         0.828660         2.103876        53.283951 /autogroup-64
[22530.328491]  btrfs-genwork-1  5601    136601.604300       317   120    136601.604300         8.769193  21829539.500055 /
[22530.328613]  btrfs-delalloc-  5603    136600.775528       227   120    136600.775528         3.582197  21827115.345843 /
[22530.328735]      btrfs-rmw-1  5607    136600.774237       211   120    136600.774237         5.557399  21827133.450132 /
[22530.328857]  btrfs-transacti  5688    136619.720388    409241   120    136619.720388     44090.424547  21806613.820149 /
[22530.328980]    snapbackup.sh  7168       160.007081        28   120       160.007081         5.274723    155447.886152 /autogroup-429
[22530.329105]    kworker/u16:1 29506    115523.145051      3172   120    115523.145051       415.106587   7127902.742599 /
[22530.329228] 
[22530.329280] cpu#4, 3400.082 MHz
[22530.329336]   .nr_running                    : 0
[22530.329392]   .load                          : 0
[22530.329450]   .nr_switches                   : 525526
[22530.329509]   .nr_load_updates               : 151911
[22530.329567]   .nr_uninterruptible            : 6760
[22530.329626]   .next_balance                  : 4297.191324
[22530.329685]   .curr->pid                     : 0
[22530.329743]   .clock                         : 22530292.431696
[22530.329802]   .cpu_load[0]                   : 0
[22530.329860]   .cpu_load[1]                   : 0
[22530.329918]   .cpu_load[2]                   : 0
[22530.329975]   .cpu_load[3]                   : 0
[22530.330033]   .cpu_load[4]                   : 0
[22530.330091]   .yld_count                     : 0
[22530.330149]   .sched_count                   : 547366
[22530.330208]   .sched_goidle                  : 242892
[22530.330266]   .avg_idle                      : 790364
[22530.330325]   .ttwu_count                    : 272667
[22530.330383]   .ttwu_local                    : 187575
[22530.330442] 
[22530.330442] cfs_rq[4]:/
[22530.330546]   .exec_clock                    : 85501.442258
[22530.330606]   .MIN_vruntime                  : 0.000001
[22530.330665]   .min_vruntime                  : 106496.936449
[22530.330724]   .max_vruntime                  : 0.000001
[22530.330784]   .spread                        : 0.000000
[22530.330842]   .spread0                       : -142417.147803
[22530.330902]   .nr_spread_over                : 542
[22530.330960]   .nr_running                    : 0
[22530.331018]   .load                          : 0
[22530.331075]   .runnable_load_avg             : 0
[22530.331133]   .blocked_load_avg              : 0
[22530.331191]   .tg_load_contrib               : 0
[22530.331248]   .tg_runnable_contrib           : 0
[22530.331306]   .tg_load_avg                   : 0
[22530.331364]   .tg->runnable_avg              : 10
[22530.331421]   .tg->cfs_bandwidth.timer_active: 0
[22530.331479]   .throttled                     : 0
[22530.331537]   .throttle_count                : 0
[22530.331595]   .avg->runnable_avg_sum         : 0
[22530.331653]   .avg->runnable_avg_period      : 48073
[22530.331711] 
[22530.331711] rt_rq[4]:/
[22530.331816]   .rt_nr_running                 : 0
[22530.331874]   .rt_throttled                  : 0
[22530.331931]   .rt_time                       : 0.000000
[22530.331990]   .rt_runtime                    : 950.000000
[22530.332050] 
[22530.332050] runnable tasks:
[22530.332050]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.332050] ----------------------------------------------------------------------------------------------------------
[22530.332387]       watchdog/4    26        -8.982866      5639     0        -8.982866        64.971744        46.504233 /
[22530.332520]      migration/4    27         0.000000      6621     0         0.000000        52.733681         0.000795 /
[22530.332642]      ksoftirqd/4    28    106484.923125      5127   120    106484.923125       139.227938  22387369.791882 /
[22530.332764]      kworker/4:0    29      5580.634468        23   120      5580.634468         0.108432   1094087.316362 /
[22530.332886]     kworker/4:0H    30       834.814843         6   100       834.814843         0.021660      1038.532072 /
[22530.333010]          deferwq   742        46.995491         2   100        46.995491         0.007740         0.003205 /
[22530.334522]        scsi_eh_0   874       774.779565         3   120       774.779565         0.060958         1.843085 /
[22530.334645]       scsi_tmf_0   875       666.600701         2   100       666.600701         0.067913         0.034645 /
[22530.334767]        scsi_eh_1   876       774.778668         3   120       774.778668         0.062528         1.559232 /
[22530.334889]       scsi_tmf_1   877       690.724569         2   100       690.724569         0.068288         0.033577 /
[22530.335010]       scsi_tmf_2   879       714.738150         2   100       714.738150         0.006443         0.023105 /
[22530.335132]        scsi_eh_3   880       801.449170        18   120       801.449170         2.667117       361.131087 /
[22530.335254]       scsi_tmf_3   881       738.751023         2   100       738.751023         0.006412         0.018547 /
[22530.335374]       scsi_tmf_4   883       762.761788         2   100       762.761788         0.005613         0.003612 /
[22530.335496]       scsi_tmf_5   885       786.773061         2   100       786.773061         0.005778         0.004149 /
[22530.335618]     kworker/4:1H   914    106484.944641     38243   100    106484.944641       471.666864  22525255.256452 /
[22530.335740]           bioset   936       922.349057         2   100       922.349057         0.008381         0.003991 /
[22530.335862]           bioset   944       946.476113         2   100       946.476113         0.006653         0.004733 /
[22530.335983]           bioset   952       982.623904         2   100       982.623904         0.006756         0.004473 /
[22530.336106]  ext4-rsv-conver   968      1025.295960         2   100      1025.295960         0.026530         0.006667 /
[22530.336228]            udevd  1156       516.641658       346   120       516.641658        44.914580    876083.215828 /autogroup-4
[22530.336351]  btrfs-delalloc-  2277    106484.947468       226   120    106484.947468         3.169508  22426784.731754 /
[22530.336473]    btrfs-cache-1  2287    106484.946181       218   120    106484.946181         3.569869  22426794.643863 /
[22530.336596]         rsyslogd  3050       147.469561        16   120       147.469561         2.382207       130.506899 /autogroup-8
[22530.336721]            getty  4175         0.110367        93   120         0.110367         2.029572        53.375444 /autogroup-63
[22530.336845]      kworker/4:2  6032    106485.763504     75411   120    106485.763504       939.712241  21732007.281605 /
[22530.336968]             cron 30183      1625.469001         1   120      1625.469001         1.311734         0.000000 /autogroup-27
[22530.337092] 
[22530.337145] cpu#5, 3400.082 MHz
[22530.337199]   .nr_running                    : 0
[22530.337257]   .load                          : 0
[22530.337315]   .nr_switches                   : 397804
[22530.337373]   .nr_load_updates               : 109834
[22530.337432]   .nr_uninterruptible            : 6455
[22530.337490]   .next_balance                  : 4297.191355
[22530.337550]   .curr->pid                     : 0
[22530.337608]   .clock                         : 22527294.192330
[22530.337668]   .cpu_load[0]                   : 0
[22530.337725]   .cpu_load[1]                   : 0
[22530.337783]   .cpu_load[2]                   : 0
[22530.337840]   .cpu_load[3]                   : 0
[22530.337899]   .cpu_load[4]                   : 0
[22530.337956]   .yld_count                     : 0
[22530.338014]   .sched_count                   : 413463
[22530.338073]   .sched_goidle                  : 186876
[22530.338131]   .avg_idle                      : 1000000
[22530.338190]   .ttwu_count                    : 198515
[22530.338248]   .ttwu_local                    : 114781
[22530.338307] 
[22530.338307] cfs_rq[5]:/
[22530.338413]   .exec_clock                    : 53206.511827
[22530.338472]   .MIN_vruntime                  : 0.000001
[22530.338531]   .min_vruntime                  : 77129.534916
[22530.338591]   .max_vruntime                  : 0.000001
[22530.338649]   .spread                        : 0.000000
[22530.338709]   .spread0                       : -171784.549336
[22530.338768]   .nr_spread_over                : 634
[22530.338826]   .nr_running                    : 0
[22530.338884]   .load                          : 0
[22530.338942]   .runnable_load_avg             : 0
[22530.338999]   .blocked_load_avg              : 0
[22530.339057]   .tg_load_contrib               : 0
[22530.339114]   .tg_runnable_contrib           : 0
[22530.339172]   .tg_load_avg                   : 0
[22530.339229]   .tg->runnable_avg              : 11
[22530.339288]   .tg->cfs_bandwidth.timer_active: 0
[22530.339345]   .throttled                     : 0
[22530.339403]   .throttle_count                : 0
[22530.339461]   .avg->runnable_avg_sum         : 20
[22530.339518]   .avg->runnable_avg_period      : 47195
[22530.339577] 
[22530.339577] rt_rq[5]:/
[22530.339681]   .rt_nr_running                 : 0
[22530.339740]   .rt_throttled                  : 0
[22530.339797]   .rt_time                       : 0.000000
[22530.339857]   .rt_runtime                    : 950.000000
[22530.339916] 
[22530.339916] runnable tasks:
[22530.339916]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.339916] ----------------------------------------------------------------------------------------------------------
[22530.340253]       watchdog/5    31        -8.984038      5639     0        -8.984038        68.771450        32.993025 /
[22530.340374]      migration/5    32         0.000000      6362     0         0.000000        50.937131         0.000878 /
[22530.340496]      ksoftirqd/5    33     77117.545395      4450   120     77117.545395        83.577565  22497932.592565 /
[22530.340618]      kworker/5:0    34      4234.045902        18   120      4234.045902         0.067026   1003827.021883 /
[22530.340740]     kworker/5:0H    35       413.646668         6   100       413.646668         0.023930      2681.599906 /
[22530.340864]        scsi_eh_4   882       258.541557        18   120       258.541557         2.743332       350.975744 /
[22530.340987]     kworker/5:1H   994     77117.492193      9004   100     77117.492193        77.541909  22448691.875804 /
[22530.341110]  btrfs-flush_del  2289     77117.514861       219   120     77117.514861         2.993641  22426794.380162 /
[22530.341232]    btrfs-cleaner  2321     77117.598249      1112   120     77117.598249        44.314008  22469553.164811 /
[22530.341354]            udevd  2613       374.649613        16   120       374.649613         3.226625    862493.064659 /autogroup-4
[22530.341478]             cron  3427      2199.374500       954   120      2199.374500       108.230518  22448993.764789 /autogroup-27
[22530.341602]      dbus-daemon  3498         0.978914         1   120         0.978914         0.141902         0.000000 /autogroup-29
[22530.341726]            mdadm  3655         3.182464        23   120         3.182464         4.294591  21989232.539056 /autogroup-32
[22530.341851]      kworker/5:2  5705     77118.374143     68658   120     77118.374143       831.022717  21824263.004596 /
[22530.341975]  btrfs-flush_del 30924     48607.753771         2   120     48607.753771         0.026860         0.004432 /
[22530.342097] 
[22530.342150] cpu#6, 3400.082 MHz
[22530.342205]   .nr_running                    : 0
[22530.342263]   .load                          : 0
[22530.342320]   .nr_switches                   : 451998
[22530.342379]   .nr_load_updates               : 130538
[22530.342446]   .nr_uninterruptible            : 6316
[22530.342507]   .next_balance                  : 4297.191405
[22530.342567]   .curr->pid                     : 0
[22530.342624]   .clock                         : 22527793.894898
[22530.342684]   .cpu_load[0]                   : 0
[22530.342743]   .cpu_load[1]                   : 0
[22530.342800]   .cpu_load[2]                   : 0
[22530.342858]   .cpu_load[3]                   : 0
[22530.342915]   .cpu_load[4]                   : 0
[22530.342973]   .yld_count                     : 0
[22530.343031]   .sched_count                   : 465739
[22530.343090]   .sched_goidle                  : 212427
[22530.343148]   .avg_idle                      : 1000000
[22530.343207]   .ttwu_count                    : 223131
[22530.343265]   .ttwu_local                    : 137451
[22530.343323] 
[22530.343323] cfs_rq[6]:/
[22530.343429]   .exec_clock                    : 52045.486977
[22530.343488]   .MIN_vruntime                  : 0.000001
[22530.343547]   .min_vruntime                  : 87712.801268
[22530.343607]   .max_vruntime                  : 0.000001
[22530.343666]   .spread                        : 0.000000
[22530.343725]   .spread0                       : -161201.369733
[22530.343784]   .nr_spread_over                : 1304
[22530.343842]   .nr_running                    : 0
[22530.343900]   .load                          : 0
[22530.343958]   .runnable_load_avg             : 0
[22530.344016]   .blocked_load_avg              : 0
[22530.344073]   .tg_load_contrib               : 0
[22530.344131]   .tg_runnable_contrib           : 0
[22530.344189]   .tg_load_avg                   : 1
[22530.344246]   .tg->runnable_avg              : 12
[22530.344305]   .tg->cfs_bandwidth.timer_active: 0
[22530.344362]   .throttled                     : 0
[22530.344420]   .throttle_count                : 0
[22530.344478]   .avg->runnable_avg_sum         : 16
[22530.344536]   .avg->runnable_avg_period      : 48042
[22530.344595] 
[22530.344595] rt_rq[6]:/
[22530.344699]   .rt_nr_running                 : 0
[22530.344756]   .rt_throttled                  : 0
[22530.344815]   .rt_time                       : 0.000000
[22530.344874]   .rt_runtime                    : 950.000000
[22530.344933] 
[22530.344933] runnable tasks:
[22530.344933]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.344933] ----------------------------------------------------------------------------------------------------------
[22530.346657]       watchdog/6    36        -8.979519      5639     0        -8.979519        51.042327        19.375885 /
[22530.346779]      migration/6    37         0.000000      6278     0         0.000000        48.805490         0.000779 /
[22530.346901]      ksoftirqd/6    38     87701.000541      8090   120     87701.000541        80.922139  22524301.674997 /
[22530.347023]      kworker/6:0    39     14238.774211        16   120     14238.774211         0.053544   1105053.883586 /
[22530.347144]     kworker/6:0H    40      8366.913807         6   100      8366.913807         0.086353      2062.303268 /
[22530.347267]    irq/41-mei_me   684         0.000000        17    49         0.000000         0.319436         0.000000 /
[22530.347388]          ata_sff   871      8330.570706         2   100      8330.570706         0.035098         0.006128 /
[22530.347511]     kworker/6:1H   972     87700.771842      8055   100     87700.771842        59.741155  22407960.884540 /
[22530.347636]             qmgr  4133         1.183635       170   120         1.183635        20.886187  22191616.793959 /autogroup-58
[22530.347760]      kworker/6:2  6370     87702.251718     84127   120     87702.251718      1009.772712  21721970.548519 /
[22530.347884] 
[22530.347936] cpu#7, 3400.082 MHz
[22530.347991]   .nr_running                    : 0
[22530.348049]   .load                          : 0
[22530.348107]   .nr_switches                   : 428809
[22530.348165]   .nr_load_updates               : 109047
[22530.348224]   .nr_uninterruptible            : 6868
[22530.348282]   .next_balance                  : 4297.191455
[22530.348341]   .curr->pid                     : 0
[22530.348400]   .clock                         : 22528293.606579
[22530.348459]   .cpu_load[0]                   : 0
[22530.348517]   .cpu_load[1]                   : 0
[22530.348575]   .cpu_load[2]                   : 0
[22530.348632]   .cpu_load[3]                   : 0
[22530.348690]   .cpu_load[4]                   : 0
[22530.348748]   .yld_count                     : 0
[22530.348806]   .sched_count                   : 441811
[22530.348864]   .sched_goidle                  : 203344
[22530.348923]   .avg_idle                      : 1000000
[22530.348981]   .ttwu_count                    : 206180
[22530.349039]   .ttwu_local                    : 110169
[22530.349099] 
[22530.349099] cfs_rq[7]:/
[22530.349203]   .exec_clock                    : 47934.948538
[22530.349263]   .MIN_vruntime                  : 0.000001
[22530.349322]   .min_vruntime                  : 74031.661277
[22530.349381]   .max_vruntime                  : 0.000001
[22530.349440]   .spread                        : 0.000000
[22530.349499]   .spread0                       : -174882.509724
[22530.349559]   .nr_spread_over                : 538
[22530.349616]   .nr_running                    : 0
[22530.349674]   .load                          : 0
[22530.349731]   .runnable_load_avg             : 0
[22530.349789]   .blocked_load_avg              : 0
[22530.349847]   .tg_load_contrib               : 0
[22530.349904]   .tg_runnable_contrib           : 0
[22530.349962]   .tg_load_avg                   : 1
[22530.350020]   .tg->runnable_avg              : 12
[22530.350077]   .tg->cfs_bandwidth.timer_active: 0
[22530.350135]   .throttled                     : 0
[22530.350193]   .throttle_count                : 0
[22530.350250]   .avg->runnable_avg_sum         : 20
[22530.350308]   .avg->runnable_avg_period      : 48445
[22530.350368]
[22530.350368] rt_rq[7]:/
[22530.350472]   .rt_nr_running                 : 0
[22530.350530]   .rt_throttled                  : 0
[22530.350587]   .rt_time                       : 0.000000
[22530.350646]   .rt_runtime                    : 950.000000
[22530.350706]
[22530.350706] runnable tasks:
[22530.350706]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[22530.350706] ----------------------------------------------------------------------------------------------------------
[22530.351040]         kthreadd     2     57305.658158       255   120     57305.658158         5.101684  18122186.129762 /
[22530.351163]       watchdog/7    41        -8.987511      5639     0        -8.987511        44.385994         5.780484 /
[22530.351284]      migration/7    42         0.000000      6739     0         0.000000        53.655370         0.000762 /
[22530.351406]      ksoftirqd/7    43     74019.493271      4729   120     74019.493271        70.464090  22497714.668876 /
[22530.351528]      kworker/7:0    44      2364.871277        14   120      2364.871277         0.038779    700944.961679 /
[22530.351649]     kworker/7:0H    45       742.905544         6   100       742.905544         0.029399       983.929453 /
[22530.351771]          khelper    46        10.956024         2   100        10.956024         0.005379         0.002394 /
[22530.351893]            netns    47        22.959366         2   100        22.959366         0.003651         0.001915 /
[22530.352015]        writeback   196        46.966222         2   100        46.966222         0.003949         0.001397 /
[22530.352137]           bioset   198        58.969483         2   100        58.969483         0.003554         0.001482 /
[22530.352259]          kblockd   199        70.972663         2   100        70.972663         0.003473         0.001477 /
[22530.352380]               md   368        94.979536         2   100        94.979536         0.003469         0.001485 /
[22530.352514]          kswapd0   517       215.094515         3   120       215.094515         0.016066        96.853648 /
[22530.352636]           crypto   590       155.024795         2   100       155.024795         0.007868         0.002543 /
[22530.352758]      kworker/7:1   626     74020.559054     71410   120     74020.559054       875.435981  22526134.757772 /
[22530.352881]     kworker/7:1H   901     73942.944698      6029   100     73942.944698        50.935561  22381894.309503 /
[22530.353004]       jbd2/md1-8  2266      1463.973239         2   120      1463.973239         0.074372         0.045978 /
[22530.353126]  ext4-rsv-conver  2267      1476.021115         2   100      1476.021115         0.049257         0.024787 /
[22530.353248]           bioset  2273      1500.080675         2   100      1500.080675         0.025348         0.027003 /
[22530.353372]            getty  4178         0.790927       100   120         0.790927         2.124261        52.920618 /autogroup-66
[22530.353496]    btrfs-cleaner  5687     74019.671496       621   120     74019.671496        17.130059  21850927.888824 /
[22530.353618]            udevd  6366       506.784114         5   120       506.784114         1.277593         3.684182 /autogroup-4
[22530.353744]


-- 
Tomasz Chmielewski
http://wpkg.org
