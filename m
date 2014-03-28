Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55012 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaC1MZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 08:25:16 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id CB4D0427E17
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 13:25:13 +0100 (CET)
Received: from localhost (ip-95-223-253-98.unitymediagroup.de [95.223.253.98])
	by mail.virtall.com (Postfix) with ESMTPSA id A4BA1427DFE
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 13:25:13 +0100 (CET)
Date: Fri, 28 Mar 2014 13:25:11 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: making snapshot kills RAID-1 rebuild?
Message-ID: <20140328132511.20d91db0@virtall.com>
In-Reply-To: <20140328040849.5c454118@virtall.com>
References: <20140328040849.5c454118@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Mar 2014 04:08:49 +0100
Tomasz Chmielewski <tch@virtall.com> wrote:

> One of drives died in my server and was replaced.
> 
> Some time after running "btrfs device delete missing ...", a read only
> snapshot was made. Since then, "btrfs subvolume snapshot -r ..."
> process still didn't return, and there are no more reads or writes to
> any of drives in this RAID-1 filesystem.
> 
> Kernel is 3.14.0-rc8.

I had to reboot with echo b > /proc/sysrq-trigger, since it wasn't doing anything.

After it booted again, I started "btrfs device delete missing ...", but it hanged again.

There were a few of these in dmesg, but it's silent from now on.
No more read or write to any of the drives in btrfs filesystem (as seen with iostat -m).

I'm pasting echo w > /proc/sysrq-trigger output below.

[ 1679.588232] INFO: task btrfs:4421 blocked for more than 120 seconds.
[ 1679.588330]       Not tainted 3.14.0-rc8 #1
[ 1679.588405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1679.588523] btrfs           D 0000000000000002     0  4421   4347 0x00000000
[ 1679.588665]  ffff8807d7ce17d8 0000000000000082 ffffffffffffffe5 ffff8807f27de000
[ 1679.590016]  00000000000116c0 0000000000004000 ffffffff81610450 ffff8807f27de000
[ 1679.590258]  00000000ffffff01 ffff8807d7ce17b8 ffffffff811aefcd ffff8807d7ce174e
[ 1679.590501] Call Trace:
[ 1679.590578]  [<ffffffff811aefcd>] ? number.isra.1+0x128/0x238
[ 1679.590657]  [<ffffffff81079f6b>] ? ktime_get_ts+0x50/0xb7
[ 1679.590735]  [<ffffffff810a301f>] ? delayacct_end+0x77/0x82
[ 1679.590814]  [<ffffffff810b1c94>] ? __lock_page+0x63/0x63
[ 1679.590893]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[ 1679.590969]  [<ffffffff8139711a>] io_schedule+0x8a/0xc8
[ 1679.591047]  [<ffffffff810b1c9d>] sleep_on_page+0x9/0xd
[ 1679.591124]  [<ffffffff8139767b>] __wait_on_bit+0x45/0x7e
[ 1679.591201]  [<ffffffff810b1a1d>] ? find_get_pages_tag+0xe9/0x123
[ 1679.591280]  [<ffffffff810b1ea5>] wait_on_page_bit+0x71/0x73
[ 1679.591358]  [<ffffffff81067f46>] ? wake_atomic_t_function+0x28/0x28
[ 1679.591447]  [<ffffffffa02d056e>] extent_write_cache_pages.isra.30.constprop.46+0x181/0x2f6 [btrfs]
[ 1679.591573]  [<ffffffffa02d0971>] extent_writepages+0x46/0x57 [btrfs]
[ 1679.591657]  [<ffffffffa02b9c56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[ 1679.591736]  [<ffffffff81392976>] ? printk+0x48/0x4a
[ 1679.591816]  [<ffffffffa02b8dbd>] btrfs_writepages+0x23/0x25 [btrfs]
[ 1679.591896]  [<ffffffff810badc0>] do_writepages+0x19/0x27
[ 1679.591973]  [<ffffffff810b27c3>] __filemap_fdatawrite_range+0x4e/0x50
[ 1679.592052]  [<ffffffff810b2d67>] filemap_fdatawrite_range+0xe/0x10
[ 1679.592136]  [<ffffffffa02cbc5f>] btrfs_wait_ordered_range+0x49/0x120 [btrfs]
[ 1679.592221]  [<ffffffffa02f7691>] btrfs_relocate_block_group+0x1a9/0x275 [btrfs]
[ 1679.592344]  [<ffffffffa02d4e0a>] btrfs_relocate_chunk.isra.65+0x58/0x60e [btrfs]
[ 1679.592468]  [<ffffffffa02e37c3>] ? btrfs_set_lock_blocking_rw+0x89/0xb2 [btrfs]
[ 1679.592588]  [<ffffffffa0296a2a>] ? btrfs_set_path_blocking+0x23/0x54 [btrfs]
[ 1679.592670]  [<ffffffffa029b477>] ? btrfs_search_slot+0x783/0x7dd [btrfs]
[ 1679.592754]  [<ffffffffa02d1103>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[ 1679.592837]  [<ffffffffa02d70f9>] btrfs_shrink_device+0x23c/0x3a5 [btrfs]
[ 1679.592921]  [<ffffffffa02d9673>] btrfs_rm_device+0x29e/0x6a7 [btrfs]
[ 1679.593004]  [<ffffffffa02e15f9>] btrfs_ioctl+0xa48/0x25d3 [btrfs]
[ 1679.593084]  [<ffffffff810ce1df>] ? handle_mm_fault+0x24f/0x965
[ 1679.593162]  [<ffffffff8116e386>] ? avc_has_perm+0x2e/0xf2
[ 1679.593241]  [<ffffffff811071a9>] do_vfs_ioctl+0x3f2/0x43c
[ 1679.593318]  [<ffffffff81107241>] SyS_ioctl+0x4e/0x7d
[ 1679.593396]  [<ffffffff8102f7fd>] ? do_page_fault+0xc/0xf
[ 1679.593474]  [<ffffffff8139a0e2>] system_call_fastpath+0x16/0x1b



[32283.486714] SysRq : Show Blocked State
[32283.486762]   task                        PC stack   pid father
[32283.486815] kworker/2:1     D 0000000000000002     0   616      2 0x00000000
[32283.486869] Workqueue: events do_sync_work
[32283.486914]  ffff8807f19f7b08 0000000000000046 0000000000000000 ffff8807f3f99800
[32283.487003]  00000000000116c0 0000000000004000 ffff8807f4031800 ffff8807f3f99800
[32283.487092]  ffff8807f19f7a78 ffffffff8106138a ffff8807f19f7a68 ffff88081fa916c0
[32283.487181] Call Trace:
[32283.487228]  [<ffffffff8106138a>] ? put_prev_task_fair+0x60/0x28e
[32283.487277]  [<ffffffff81396e8f>] ? __schedule+0x74f/0x8ae
[32283.487324]  [<ffffffff81058603>] ? ttwu_do_wakeup+0x12/0x7f
[32283.487372]  [<ffffffff810b1c94>] ? __lock_page+0x63/0x63
[32283.487419]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[32283.487466]  [<ffffffff8139711a>] io_schedule+0x8a/0xc8
[32283.487512]  [<ffffffff810b1c9d>] sleep_on_page+0x9/0xd
[32283.487559]  [<ffffffff8139767b>] __wait_on_bit+0x45/0x7e
[32283.487606]  [<ffffffff810b1a1d>] ? find_get_pages_tag+0xe9/0x123
[32283.487654]  [<ffffffff810b1ea5>] wait_on_page_bit+0x71/0x73
[32283.487701]  [<ffffffff81067f46>] ? wake_atomic_t_function+0x28/0x28
[32283.487749]  [<ffffffff810b1f5f>] filemap_fdatawait_range+0x79/0x118
[32283.487798]  [<ffffffff810b201a>] filemap_fdatawait+0x1c/0x1e
[32283.487845]  [<ffffffff81117124>] sync_inodes_sb+0x148/0x191
[32283.487893]  [<ffffffff8111abb0>] ? fdatawrite_one_bdev+0x13/0x13
[32283.487940]  [<ffffffff8111abbf>] sync_inodes_one_sb+0xf/0x11
[32283.487989]  [<ffffffff810fb1ce>] iterate_supers+0x66/0xb6
[32283.488036]  [<ffffffff8111ab34>] do_sync_work+0x23/0x8c
[32283.488083]  [<ffffffff8104b991>] process_one_work+0x1be/0x2f4
[32283.488130]  [<ffffffff8104bf2a>] worker_thread+0x1cd/0x2c4
[32283.488177]  [<ffffffff8104bd5d>] ? rescuer_thread+0x26c/0x26c
[32283.488225]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[32283.488271]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[32283.488320]  [<ffffffff8139a03c>] ret_from_fork+0x7c/0xb0
[32283.488367]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[32283.488426] btrfs           D 0000000000000002     0  4421   4347 0x00000000
[32283.488475]  ffff8807d7ce17d8 0000000000000082 ffffffffffffffe5 ffff8807f27de000
[32283.488564]  00000000000116c0 0000000000004000 ffffffff81610450 ffff8807f27de000
[32283.488653]  00000000ffffff01 ffff8807d7ce17b8 ffffffff811aefcd ffff8807d7ce174e
[32283.488742] Call Trace:
[32283.488786]  [<ffffffff811aefcd>] ? number.isra.1+0x128/0x238
[32283.488834]  [<ffffffff81079f6b>] ? ktime_get_ts+0x50/0xb7
[32283.488882]  [<ffffffff810a301f>] ? delayacct_end+0x77/0x82
[32283.488929]  [<ffffffff810b1c94>] ? __lock_page+0x63/0x63
[32283.488976]  [<ffffffff8139708e>] schedule+0x6a/0x6c
[32283.489022]  [<ffffffff8139711a>] io_schedule+0x8a/0xc8
[32283.489069]  [<ffffffff810b1c9d>] sleep_on_page+0x9/0xd
[32283.489115]  [<ffffffff8139767b>] __wait_on_bit+0x45/0x7e
[32283.489162]  [<ffffffff810b1a1d>] ? find_get_pages_tag+0xe9/0x123
[32283.489210]  [<ffffffff810b1ea5>] wait_on_page_bit+0x71/0x73
[32283.489257]  [<ffffffff81067f46>] ? wake_atomic_t_function+0x28/0x28
[32283.489316]  [<ffffffffa02d056e>] extent_write_cache_pages.isra.30.constprop.46+0x181/0x2f6 [btrfs]
[32283.489413]  [<ffffffffa02d0971>] extent_writepages+0x46/0x57 [btrfs]
[32283.489466]  [<ffffffffa02b9c56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[32283.489515]  [<ffffffff81392976>] ? printk+0x48/0x4a
[32283.489565]  [<ffffffffa02b8dbd>] btrfs_writepages+0x23/0x25 [btrfs]
[32283.489614]  [<ffffffff810badc0>] do_writepages+0x19/0x27
[32283.489661]  [<ffffffff810b27c3>] __filemap_fdatawrite_range+0x4e/0x50
[32283.489710]  [<ffffffff810b2d67>] filemap_fdatawrite_range+0xe/0x10
[32283.489763]  [<ffffffffa02cbc5f>] btrfs_wait_ordered_range+0x49/0x120 [btrfs]
[32283.489818]  [<ffffffffa02f7691>] btrfs_relocate_block_group+0x1a9/0x275 [btrfs]
[32283.489910]  [<ffffffffa02d4e0a>] btrfs_relocate_chunk.isra.65+0x58/0x60e [btrfs]
[32283.490003]  [<ffffffffa02e37c3>] ? btrfs_set_lock_blocking_rw+0x89/0xb2 [btrfs]
[32283.490094]  [<ffffffffa0296a2a>] ? btrfs_set_path_blocking+0x23/0x54 [btrfs]
[32283.490145]  [<ffffffffa029b477>] ? btrfs_search_slot+0x783/0x7dd [btrfs]
[32283.490198]  [<ffffffffa02d1103>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[32283.490251]  [<ffffffffa02d70f9>] btrfs_shrink_device+0x23c/0x3a5 [btrfs]
[32283.490305]  [<ffffffffa02d9673>] btrfs_rm_device+0x29e/0x6a7 [btrfs]
[32283.490357]  [<ffffffffa02e15f9>] btrfs_ioctl+0xa48/0x25d3 [btrfs]
[32283.490406]  [<ffffffff810ce1df>] ? handle_mm_fault+0x24f/0x965
[32283.490454]  [<ffffffff8116e386>] ? avc_has_perm+0x2e/0xf2
[32283.490502]  [<ffffffff811071a9>] do_vfs_ioctl+0x3f2/0x43c
[32283.490549]  [<ffffffff81107241>] SyS_ioctl+0x4e/0x7d
[32283.490595]  [<ffffffff8102f7fd>] ? do_page_fault+0xc/0xf
[32283.490642]  [<ffffffff8139a0e2>] system_call_fastpath+0x16/0x1b
[32283.490690] Sched Debug Version: v0.11, 3.14.0-rc8 #1
[32283.490736] ktime                                   : 32302517.957122
[32283.490783] sched_clk                               : 32283490.689767
[32283.490831] cpu_clk                                 : 32283490.689784
[32283.490878] jiffies                                 : 4298167548
[32283.490925] sched_clock_stable()                    : 1
[32283.490970] 
[32283.491011] sysctl_sched
[32283.491054]   .sysctl_sched_latency                    : 24.000000
[32283.491101]   .sysctl_sched_min_granularity            : 3.000000
[32283.491148]   .sysctl_sched_wakeup_granularity         : 4.000000
[32283.491195]   .sysctl_sched_child_runs_first           : 0
[32283.491241]   .sysctl_sched_features                   : 11899
[32283.491288]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[32283.491335] 
[32283.491376] cpu#0, 3400.125 MHz
[32283.491420]   .nr_running                    : 0
[32283.491465]   .load                          : 0
[32283.491511]   .nr_switches                   : 2351792
[32283.491557]   .nr_load_updates               : 499416
[32283.491602]   .nr_uninterruptible            : -19842
[32283.491648]   .next_balance                  : 4298.167549
[32283.491694]   .curr->pid                     : 0
[32283.491739]   .clock                         : 32283486.618013
[32283.491785]   .cpu_load[0]                   : 0
[32283.491830]   .cpu_load[1]                   : 0
[32283.491875]   .cpu_load[2]                   : 0
[32283.491920]   .cpu_load[3]                   : 0
[32283.491965]   .cpu_load[4]                   : 0
[32283.492010]   .yld_count                     : 0
[32283.492055]   .sched_count                   : 2444199
[32283.492101]   .sched_goidle                  : 988849
[32283.492146]   .avg_idle                      : 1000000
[32283.492192]   .ttwu_count                    : 1749279
[32283.492238]   .ttwu_local                    : 1230883
[32283.492284] 
[32283.492284] cfs_rq[0]:/autogroup-67
[32283.492368]   .exec_clock                    : 591.332769
[32283.492414]   .MIN_vruntime                  : 0.000001
[32283.492460]   .min_vruntime                  : 589.924691
[32283.492506]   .max_vruntime                  : 0.000001
[32283.492552]   .spread                        : 0.000000
[32283.492598]   .spread0                       : -142986.269264
[32283.492644]   .nr_spread_over                : 0
[32283.492689]   .nr_running                    : 0
[32283.492734]   .load                          : 0
[32283.492779]   .runnable_load_avg             : 0
[32283.492824]   .blocked_load_avg              : 0
[32283.492869]   .tg_load_contrib               : 0
[32283.492914]   .tg_runnable_contrib           : 0
[32283.492959]   .tg_load_avg                   : 0
[32283.493003]   .tg->runnable_avg              : 0
[32283.494151]   .tg->cfs_bandwidth.timer_active: 0
[32283.494196]   .throttled                     : 0
[32283.494241]   .throttle_count                : 0
[32283.494286]   .se->exec_start                : 32283486.602908
[32283.494333]   .se->vruntime                  : 143564.997569
[32283.494379]   .se->sum_exec_runtime          : 591.332769
[32283.494425]   .se->statistics.wait_start     : 0.000000
[32283.494471]   .se->statistics.sleep_start    : 0.000000
[32283.494516]   .se->statistics.block_start    : 0.000000
[32283.494562]   .se->statistics.sleep_max      : 0.000000
[32283.494608]   .se->statistics.block_max      : 0.000000
[32283.494653]   .se->statistics.exec_max       : 3.460545
[32283.494699]   .se->statistics.slice_max      : 0.085291
[32283.494745]   .se->statistics.wait_max       : 0.065607
[32283.494791]   .se->statistics.wait_sum       : 0.916045
[32283.494836]   .se->statistics.wait_count     : 6915
[32283.494881]   .se->load.weight               : 2
[32283.494926]   .se->avg.runnable_avg_sum      : 47
[32283.494971]   .se->avg.runnable_avg_period   : 47872
[32283.495017]   .se->avg.load_avg_contrib      : 0
[32283.495061]   .se->avg.decay_count           : 30787933
[32283.495107] 
[32283.495107] cfs_rq[0]:/
[32283.495190]   .exec_clock                    : 142312.443335
[32283.495236]   .MIN_vruntime                  : 0.000001
[32283.495282]   .min_vruntime                  : 143576.193955
[32283.495328]   .max_vruntime                  : 0.000001
[32283.495374]   .spread                        : 0.000000
[32283.495419]   .spread0                       : 0.000000
[32283.495465]   .nr_spread_over                : 811
[32283.495510]   .nr_running                    : 0
[32283.495555]   .load                          : 0
[32283.495600]   .runnable_load_avg             : 0
[32283.495645]   .blocked_load_avg              : 0
[32283.495690]   .tg_load_contrib               : 0
[32283.495735]   .tg_runnable_contrib           : 1
[32283.495779]   .tg_load_avg                   : 0
[32283.495824]   .tg->runnable_avg              : 2
[32283.495869]   .tg->cfs_bandwidth.timer_active: 0
[32283.495914]   .throttled                     : 0
[32283.495959]   .throttle_count                : 0
[32283.496004]   .avg->runnable_avg_sum         : 73
[32283.496049]   .avg->runnable_avg_period      : 47226
[32283.496096] 
[32283.496096] rt_rq[0]:/
[32283.496178]   .rt_nr_running                 : 0
[32283.496223]   .rt_throttled                  : 0
[32283.496268]   .rt_time                       : 0.000000
[32283.496314]   .rt_runtime                    : 950.000000
[32283.496360] 
[32283.496360] runnable tasks:
[32283.496360]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.496360] ----------------------------------------------------------------------------------------------------------
[32283.496624]             init     1        40.682537      7373   120        40.682537       576.650618  32277970.085462 /autogroup-2
[32283.496720]         kthreadd     2    143541.151353       182   120    143541.151353         3.448481  32164963.455002 /
[32283.496814]      ksoftirqd/0     3    143564.028158     22734   120    143564.028158       355.083774  32281642.744247 /
[32283.496907]     kworker/0:0H     5       884.259352         5   100       884.259352         0.040041      1079.407522 /
[32283.497002]      migration/0     9         0.000000       171     0         0.000000       409.770651         0.000816 /
[32283.497095]       watchdog/0    10       -11.811848      8085     0       -11.811848        94.032248        95.061989 /
[32283.497193]      kworker/0:1   472    143567.427579    318731   120    143567.427579      3712.284468  32276788.436246 /
[32283.497287]      kworker/0:2   700      3224.909050         7   120      3224.909050         0.026753     45933.935909 /
[32283.497382]        scsi_eh_1   883       879.817283         3   120       879.817283         0.070697         1.699335 /
[32283.497476]        scsi_eh_4   889       884.583224        18   120       884.583224         4.780367       350.894229 /
[32283.497570]    kworker/u16:3   894    138632.780043       227   120    138632.780043        23.058594  30238432.309806 /
[32283.497664]     kworker/0:1H   904    143564.016992    429911   100    143564.016992      4194.301245  32276349.829423 /
[32283.497759]        md2_raid1   964    143564.229422    245280   120    143564.229422     10318.033482  32268489.872800 /
[32283.497853]       jbd2/md2-8   980    143564.298666     20498   120    143564.298666      1119.724277  32278521.110560 /
[32283.497948]  btrfs-endio-rai  2290    143543.620210       324   120    143543.620210         3.905287  32141051.607006 /
[32283.498042]  btrfs-endio-wri  2292    143543.547257       305   120    143543.547257         4.229202  32141071.333501 /
[32283.498137]  btrfs-readahead  2296    143543.547503       309   120    143543.547503         7.399807  32141038.478482 /
[32283.498231]  btrfs-transacti  2330    143558.828362     28858   120    143558.828362      2673.622812  32206631.221262 /
[32283.498325]             sshd  2779         0.478108         5   120         0.478108         0.931674    113390.095510 /autogroup-6
[32283.498420]    rs:main Q:Reg  3148       537.928333     16152   120       537.928333      1775.128528  32227290.619330 /autogroup-8
[32283.498515]          apache2  3379       100.068386     32221   120       100.068386       558.803231  32232555.121792 /autogroup-24
[32283.498611]            rsync  4165        80.310540        13   139        80.310540         1.438598        52.067742 /autogroup-58
[32283.498707]            getty  4198         0.823437       104   120         0.823437         4.053598       177.159436 /autogroup-61
[32283.498802]             sshd  4204       589.924691      7366   120       589.924691       649.155810  32230483.926040 /autogroup-67
[32283.498897]   btrfs-worker-1  4280    143543.416180       288   120    143543.416180         5.475678  32021147.594450 /
[32283.498992]  btrfs-endio-met  4289    143543.373343       313   120    143543.373343         7.774000  32021123.936752 /
[32283.499086]    btrfs-cache-1  4293    143540.929978       587   120    143540.929978        33.686287  32008617.769624 /
[32283.499179]  btrfs-flush_del  4295    143543.345209       305   120    143543.345209         6.617744  32021145.415637 /
[32283.499274]             tmux  4346      1162.913967     96969   120      1162.913967      6221.681365  32111899.717013 /autogroup-73
[32283.499369]            btrfs  4421       973.871415     63843   120       973.871415      7302.768461    468569.854836 /autogroup-74
[32283.499464]           pickup  7050        44.126339        40   120        44.126339         7.302359   2280927.079801 /autogroup-51
[32283.499560] 
[32283.499601] cpu#1, 3400.125 MHz
[32283.499644]   .nr_running                    : 0
[32283.499689]   .load                          : 0
[32283.499734]   .nr_switches                   : 1188730
[32283.499779]   .nr_load_updates               : 415952
[32283.499825]   .nr_uninterruptible            : -209
[32283.499870]   .next_balance                  : 4298.167507
[32283.499916]   .curr->pid                     : 0
[32283.499961]   .clock                         : 32283063.014670
[32283.500007]   .cpu_load[0]                   : 0
[32283.500052]   .cpu_load[1]                   : 0
[32283.500097]   .cpu_load[2]                   : 0
[32283.500142]   .cpu_load[3]                   : 0
[32283.500187]   .cpu_load[4]                   : 0
[32283.500232]   .yld_count                     : 0
[32283.500277]   .sched_count                   : 1206276
[32283.500322]   .sched_goidle                  : 556410
[32283.500367]   .avg_idle                      : 1000000
[32283.500413]   .ttwu_count                    : 504935
[32283.500458]   .ttwu_local                    : 366928
[32283.500504] 
[32283.500504] cfs_rq[1]:/
[32283.500587]   .exec_clock                    : 146910.069109
[32283.500633]   .MIN_vruntime                  : 0.000001
[32283.500679]   .min_vruntime                  : 151914.079490
[32283.500725]   .max_vruntime                  : 0.000001
[32283.500771]   .spread                        : 0.000000
[32283.500816]   .spread0                       : 8337.885535
[32283.500863]   .nr_spread_over                : 938
[32283.500908]   .nr_running                    : 0
[32283.500953]   .load                          : 0
[32283.500998]   .runnable_load_avg             : 0
[32283.501042]   .blocked_load_avg              : 0
[32283.501087]   .tg_load_contrib               : 0
[32283.501132]   .tg_runnable_contrib           : 1
[32283.501177]   .tg_load_avg                   : 0
[32283.501222]   .tg->runnable_avg              : 2
[32283.501267]   .tg->cfs_bandwidth.timer_active: 0
[32283.501312]   .throttled                     : 0
[32283.501357]   .throttle_count                : 0
[32283.501402]   .avg->runnable_avg_sum         : 79
[32283.501447]   .avg->runnable_avg_period      : 48047
[32283.501493] 
[32283.501493] rt_rq[1]:/
[32283.501575]   .rt_nr_running                 : 0
[32283.501620]   .rt_throttled                  : 0
[32283.501665]   .rt_time                       : 0.000000
[32283.501711]   .rt_runtime                    : 950.000000
[32283.501758] 
[32283.501758] runnable tasks:
[32283.501758]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.501758] ----------------------------------------------------------------------------------------------------------
[32283.502022]           rcu_bh     8      3899.164533         5   120      3899.164533         0.100037    309315.903332 /
[32283.502116]       watchdog/1    11        -2.981589      8079     0        -2.981589        88.260190        87.221202 /
[32283.502210]      migration/1    12         0.000000       122     0         0.000000         5.980029         0.000823 /
[32283.502303]      ksoftirqd/1    13    151901.505416     15381   120    151901.505416       207.640238  32277430.690243 /
[32283.503501]      kworker/1:0    14        -7.015236        13   120        -7.015236         0.034237       521.509860 /
[32283.503594]     kworker/1:0H    15       415.341186         6   100       415.341186         0.018546      1103.934040 /
[32283.503691]      kworker/1:1   614    151902.093052    235361   120    151902.093052      2878.237707  32277331.627567 /
[32283.503786]     kworker/1:1H   920    151857.212767     41668   100    151857.212767       327.102124  32252855.378010 /
[32283.503880]        md1_raid1   955    151342.671848        68   120    151342.671848         1.602410  31832720.667613 /
[32283.503975]   btrfs-worker-1  2282    151803.563595       272   120    151803.563595        10.988558  32141026.909135 /
[32283.504069]   btrfs-submit-1  2284    151803.546606       294   120    151803.546606         6.576644  32141039.557915 /
[32283.504162]  btrfs-delalloc-  2285    151803.480152       293   120    151803.480152         4.557906  32141071.731177 /
[32283.504256]    btrfs-fixup-1  2286    151803.480910       317   120    151803.480910         4.003860  32141061.267993 /
[32283.504350]  btrfs-endio-met  2288    151853.530618     32969   120    151853.530618       919.414972  32192044.398512 /
[32283.504444]  btrfs-freespace  2293    151808.295609       309   120    151808.295609        12.869967  32171546.336579 /
[32283.504538]    btrfs-cache-1  2295    151803.481096       325   120    151803.481096         3.426302  32141061.389559 /
[32283.504632]          vnstatd  3051       251.694558      6669   120       251.694558       915.920274  32229295.679743 /autogroup-9
[32283.504728]          apache2  3419        64.701658       651   120        64.701658         9.789388  30529347.032959 /autogroup-24
[32283.504823]          apache2  3420        64.706192       118   120        64.706192         2.332971  30898346.965010 /autogroup-24
[32283.504918]          apache2  3421        65.584472       138   120        65.584472         2.291807  32228874.553685 /autogroup-24
[32283.505013]          apache2  3422        28.546967       735   120        28.546967        10.280688  14533508.017732 /autogroup-24
[32283.505108]          apache2  3423        24.238810       152   120        24.238810         2.436517  16013597.986806 /autogroup-24
[32283.505203]          proftpd  4002        23.257416      2312   120        23.257416       129.145742  32204818.937717 /autogroup-50
[32283.505298]           master  4004        32.236058      1701   120        32.236058        87.929293  32228928.112103 /autogroup-51
[32283.505394]            getty  4200         0.374777        94   120         0.374777         1.788001       179.155154 /autogroup-63
[32283.505490]  btrfs-delalloc-  4283    151803.349716       300   120    151803.349716         7.134004  32021115.333485 /
[32283.505584]  btrfs-endio-rai  4288    151803.372809       309   120    151803.372809         5.802438  32021126.105720 /
[32283.505678]  btrfs-freespace  4291    151858.166454       612   120    151858.166454        35.290287  32104009.751491 /
[32283.505772]             sshd  4297        19.511357      6626   120        19.511357       591.679085  32117289.554915 /autogroup-71
[32283.505867]    btrfs-endio-2  5123    151860.344716      2482   120    151860.344716       784.337874  31730623.080403 /
[32283.505961]  btrfs-endio-wri  5766    151855.218546      3028   120    151855.218546        84.694781  31641739.697827 /
[32283.506055]          apache2 18600        64.716270      1454   120        64.716270        20.319748  24078956.018902 /autogroup-24
[32283.506150] 
[32283.506191] cpu#2, 3400.125 MHz
[32283.506234]   .nr_running                    : 2
[32283.506279]   .load                          : 2048
[32283.506325]   .nr_switches                   : 980389
[32283.506370]   .nr_load_updates               : 372164
[32283.506416]   .nr_uninterruptible            : -8155
[32283.506461]   .next_balance                  : 4298.167508
[32283.506507]   .curr->pid                     : 4206
[32283.506552]   .clock                         : 32283486.645370
[32283.506599]   .cpu_load[0]                   : 0
[32283.506644]   .cpu_load[1]                   : 0
[32283.506689]   .cpu_load[2]                   : 0
[32283.506734]   .cpu_load[3]                   : 0
[32283.506779]   .cpu_load[4]                   : 0
[32283.506824]   .yld_count                     : 0
[32283.506869]   .sched_count                   : 995718
[32283.506914]   .sched_goidle                  : 466130
[32283.506960]   .avg_idle                      : 1000000
[32283.507006]   .ttwu_count                    : 444530
[32283.507051]   .ttwu_local                    : 310478
[32283.507097] 
[32283.507097] cfs_rq[2]:/autogroup-68
[32283.507181]   .exec_clock                    : 213.346048
[32283.507226]   .MIN_vruntime                  : 0.000001
[32283.507272]   .min_vruntime                  : 193.085270
[32283.507318]   .max_vruntime                  : 0.000001
[32283.507364]   .spread                        : 0.000000
[32283.507410]   .spread0                       : -143383.108685
[32283.507456]   .nr_spread_over                : 3
[32283.507501]   .nr_running                    : 1
[32283.507546]   .load                          : 1024
[32283.507591]   .runnable_load_avg             : 0
[32283.507636]   .blocked_load_avg              : 0
[32283.507681]   .tg_load_contrib               : 0
[32283.507726]   .tg_runnable_contrib           : 0
[32283.507771]   .tg_load_avg                   : 0
[32283.507816]   .tg->runnable_avg              : 0
[32283.507861]   .tg->cfs_bandwidth.timer_active: 0
[32283.507906]   .throttled                     : 0
[32283.507951]   .throttle_count                : 0
[32283.507996]   .se->exec_start                : 32283486.645370
[32283.508042]   .se->vruntime                  : 113093.038229
[32283.508089]   .se->sum_exec_runtime          : 213.374611
[32283.508135]   .se->statistics.wait_start     : 0.000000
[32283.508180]   .se->statistics.sleep_start    : 0.000000
[32283.508226]   .se->statistics.block_start    : 0.000000
[32283.508272]   .se->statistics.sleep_max      : 0.000000
[32283.508318]   .se->statistics.block_max      : 0.000000
[32283.508364]   .se->statistics.exec_max       : 6.131485
[32283.508409]   .se->statistics.slice_max      : 0.000000
[32283.508455]   .se->statistics.wait_max       : 0.032102
[32283.508501]   .se->statistics.wait_sum       : 0.393546
[32283.508547]   .se->statistics.wait_count     : 2060
[32283.508592]   .se->load.weight               : 1024
[32283.508637]   .se->avg.runnable_avg_sum      : 2
[32283.508682]   .se->avg.runnable_avg_period   : 47524
[32283.508727]   .se->avg.load_avg_contrib      : 0
[32283.508773]   .se->avg.decay_count           : 30787693
[32283.508818] 
[32283.508818] cfs_rq[2]:/
[32283.508901]   .exec_clock                    : 110600.507307
[32283.508948]   .MIN_vruntime                  : 113091.481479
[32283.508995]   .min_vruntime                  : 113103.464545
[32283.509041]   .max_vruntime                  : 113091.481479
[32283.509088]   .spread                        : 0.000000
[32283.509133]   .spread0                       : -30472.729410
[32283.509180]   .nr_spread_over                : 640
[32283.509225]   .nr_running                    : 2
[32283.509269]   .load                          : 2048
[32283.509315]   .runnable_load_avg             : 0
[32283.509360]   .blocked_load_avg              : 0
[32283.509405]   .tg_load_contrib               : 0
[32283.509450]   .tg_runnable_contrib           : 0
[32283.509494]   .tg_load_avg                   : 0
[32283.509539]   .tg->runnable_avg              : 2
[32283.509584]   .tg->cfs_bandwidth.timer_active: 0
[32283.509629]   .throttled                     : 0
[32283.509674]   .throttle_count                : 0
[32283.509719]   .avg->runnable_avg_sum         : 29
[32283.509764]   .avg->runnable_avg_period      : 47748
[32283.509810] 
[32283.509810] rt_rq[2]:/
[32283.509893]   .rt_nr_running                 : 0
[32283.509937]   .rt_throttled                  : 0
[32283.509982]   .rt_time                       : 0.000000
[32283.510028]   .rt_runtime                    : 950.000000
[32283.510074] 
[32283.510074] runnable tasks:
[32283.510074]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.510074] ----------------------------------------------------------------------------------------------------------
[32283.510339]       watchdog/2    16        -5.976134      8079     0        -5.976134        83.678348        73.609886 /
[32283.510432]      migration/2    17         0.000000       129     0         0.000000         5.986655         0.000870 /
[32283.510526]      ksoftirqd/2    18    113090.349583     14762   120    113090.349583       222.303526  32277411.965385 /
[32283.510620]      kworker/2:0    19    113069.842366        15   120    113069.842366         0.066584  32164851.663225 /
[32283.510714]     kworker/2:0H    20       437.029079         6   100       437.029079         0.020636      1386.407928 /
[32283.510810]    fsnotify_mark   585       909.588176        12   120       909.588176         0.210283     33514.966304 /
[32283.510904]      kworker/2:1   616    113072.368183    207681   120    113072.368183      2536.222737  32159783.267151 /
[32283.510999]        scsi_eh_5   891       398.450061        18   120       398.450061         4.592000       351.095693 /
[32283.511094]     kworker/2:1H   958    113048.777920     23909   100    113048.777920       176.595381  32045441.541633 /
[32283.511189]    btrfs-endio-1  2287    113072.127209       303   120    113072.127209         3.421534  32141062.412231 /
[32283.511284]         rsyslogd  3150       614.993634        50   120       614.993634         4.193894  32116274.387088 /autogroup-8
[32283.511379]             cron  3553       657.199838      1364   120       657.199838       154.174852  32227711.805108 /autogroup-30
[32283.511475]             qmgr  4126        13.703100       220   120        13.703100        27.939923  32083889.654561 /autogroup-51
[32283.511570]            getty  4203         0.685349       100   120         0.685349         2.048516       178.600809 /autogroup-66
[32283.511666] R           bash  4206       193.085270       515   120       193.085270       234.908746  32230422.081261 /autogroup-68
[32283.511761]    btrfs-fixup-1  4284    113071.976753       311   120    113071.976753         8.474176  32021134.121645 /
[32283.512959]  btrfs-readahead  4294    113072.044986       320   120    113072.044986         9.286937  32021111.925717 /
[32283.513053]  btrfs-qgroup-re  4296    113072.004585       296   120    113072.004585         4.992782  32021136.912318 /
[32283.513148]      kworker/2:2 11777    113091.481479       311   120    113091.481479         3.596261    118498.234539 /
[32283.513241] 
[32283.513283] cpu#3, 3400.125 MHz
[32283.513326]   .nr_running                    : 0
[32283.513370]   .load                          : 0
[32283.513415]   .nr_switches                   : 961397
[32283.513461]   .nr_load_updates               : 372289
[32283.513506]   .nr_uninterruptible            : -7751
[32283.513552]   .next_balance                  : 4298.167457
[32283.513598]   .curr->pid                     : 0
[32283.513643]   .clock                         : 32283226.903242
[32283.513689]   .cpu_load[0]                   : 0
[32283.513734]   .cpu_load[1]                   : 0
[32283.513779]   .cpu_load[2]                   : 0
[32283.513824]   .cpu_load[3]                   : 0
[32283.513869]   .cpu_load[4]                   : 0
[32283.513914]   .yld_count                     : 0
[32283.513959]   .sched_count                   : 975384
[32283.514004]   .sched_goidle                  : 459589
[32283.514050]   .avg_idle                      : 1000000
[32283.514095]   .ttwu_count                    : 436893
[32283.514140]   .ttwu_local                    : 306163
[32283.514186] 
[32283.514186] cfs_rq[3]:/autogroup-34
[32283.514270]   .exec_clock                    : 263.555831
[32283.514316]   .MIN_vruntime                  : 0.000001
[32283.514361]   .min_vruntime                  : 262.507255
[32283.514407]   .max_vruntime                  : 0.000001
[32283.514453]   .spread                        : 0.000000
[32283.514499]   .spread0                       : -143313.686700
[32283.514545]   .nr_spread_over                : 0
[32283.514590]   .nr_running                    : 0
[32283.514635]   .load                          : 0
[32283.514680]   .runnable_load_avg             : 0
[32283.514725]   .blocked_load_avg              : 0
[32283.514769]   .tg_load_contrib               : 0
[32283.514814]   .tg_runnable_contrib           : 0
[32283.514859]   .tg_load_avg                   : 0
[32283.514904]   .tg->runnable_avg              : 0
[32283.514949]   .tg->cfs_bandwidth.timer_active: 0
[32283.514994]   .throttled                     : 0
[32283.515039]   .throttle_count                : 0
[32283.515084]   .se->exec_start                : 32283226.901241
[32283.515130]   .se->vruntime                  : 112741.576667
[32283.515176]   .se->sum_exec_runtime          : 263.564303
[32283.515222]   .se->statistics.wait_start     : 0.000000
[32283.515268]   .se->statistics.sleep_start    : 0.000000
[32283.515314]   .se->statistics.block_start    : 0.000000
[32283.515359]   .se->statistics.sleep_max      : 0.000000
[32283.515405]   .se->statistics.block_max      : 0.000000
[32283.515451]   .se->statistics.exec_max       : 0.183945
[32283.515497]   .se->statistics.slice_max      : 0.154764
[32283.515542]   .se->statistics.wait_max       : 0.025195
[32283.515588]   .se->statistics.wait_sum       : 0.076536
[32283.515634]   .se->statistics.wait_count     : 8044
[32283.515679]   .se->load.weight               : 2
[32283.515724]   .se->avg.runnable_avg_sum      : 26
[32283.515769]   .se->avg.runnable_avg_period   : 47838
[32283.515815]   .se->avg.load_avg_contrib      : 0
[32283.515860]   .se->avg.decay_count           : 30787685
[32283.515905] 
[32283.515905] cfs_rq[3]:/
[32283.515988]   .exec_clock                    : 108595.295168
[32283.516034]   .MIN_vruntime                  : 0.000001
[32283.516080]   .min_vruntime                  : 112753.549612
[32283.516126]   .max_vruntime                  : 0.000001
[32283.516172]   .spread                        : 0.000000
[32283.516217]   .spread0                       : -30822.644343
[32283.516264]   .nr_spread_over                : 869
[32283.516309]   .nr_running                    : 0
[32283.516354]   .load                          : 0
[32283.516399]   .runnable_load_avg             : 0
[32283.516444]   .blocked_load_avg              : 0
[32283.516488]   .tg_load_contrib               : 0
[32283.516533]   .tg_runnable_contrib           : 0
[32283.516578]   .tg_load_avg                   : 0
[32283.516623]   .tg->runnable_avg              : 2
[32283.516668]   .tg->cfs_bandwidth.timer_active: 0
[32283.516713]   .throttled                     : 0
[32283.516758]   .throttle_count                : 0
[32283.516803]   .avg->runnable_avg_sum         : 29
[32283.516848]   .avg->runnable_avg_period      : 47652
[32283.516893] 
[32283.516893] rt_rq[3]:/
[32283.516976]   .rt_nr_running                 : 0
[32283.517021]   .rt_throttled                  : 0
[32283.517066]   .rt_time                       : 0.000000
[32283.517111]   .rt_runtime                    : 950.000000
[32283.517157] 
[32283.517157] runnable tasks:
[32283.517157]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.517157] ----------------------------------------------------------------------------------------------------------
[32283.517421]    kworker/u16:0     6    112741.857252     22476   120    112741.857252      2662.879663  32279383.634974 /
[32283.517515]        rcu_sched     7    112753.549612    401388   120    112753.549612     16138.442385  32266207.495256 /
[32283.517610]       watchdog/3    21        -5.984023      8079     0        -5.984023        83.314463        60.007439 /
[32283.517703]      migration/3    22         0.000000       129     0         0.000000         6.005818         0.000772 /
[32283.517797]      ksoftirqd/3    23    112740.610553     14042   120    112740.610553       215.876830  32277407.054210 /
[32283.517891]      kworker/3:0    24       -10.012254        13   120       -10.012254         0.037350       494.644960 /
[32283.517985]     kworker/3:0H    25       408.677454         6   100       408.677454         0.018433      1081.429789 /
[32283.518080]            khubd   361       958.759023        62   120       958.759023         3.234725     34462.120827 /
[32283.518175]       khungtaskd   507    112737.981745       271   120    112737.981745        57.065705  32260917.298827 /
[32283.518269]      kworker/3:1   618    112741.477495    211230   120    112741.477495      2636.920463  32277272.532502 /
[32283.518364]     kworker/3:1H   929    112540.462721     18243   100    112540.462721       136.018491  32041958.809618 /
[32283.518459]  btrfs-genwork-1  2283    112729.685423       280   120    112729.685423         9.370836  32181134.340928 /
[32283.518553]  btrfs-delayed-m  2294    112722.240962       297   120    112722.240962         4.242313  32141061.461401 /
[32283.518647]  btrfs-qgroup-re  2298    112722.238647       314   120    112722.238647         3.253944  32141051.877656 /
[32283.518742]         rsyslogd  3149       666.642109     15446   120       666.642109       676.097200  32228396.525211 /autogroup-8
[32283.518837]       munin-node  3195       932.443614     16411   120       932.443614      1011.380419  32232801.342877 /autogroup-11
[32283.518933]            mdadm  3660         0.324629        33   120         0.324629         6.062281  31784203.184274 /autogroup-32
[32283.519028]             ntpd  3774       262.507255     33985   120       262.507255      1094.185886  32231899.345399 /autogroup-34
[32283.519124]            getty  4202         0.603945       103   120         0.603945         1.702846       178.985929 /autogroup-65
[32283.519219]  btrfs-genwork-1  4281    112740.490691       289   120    112740.490691        11.974548  32121203.738013 /
[32283.519313]  btrfs-endio-met  4286    112737.805418     81828   120    112737.805418      2474.842227  32100882.267865 /
[32283.519407]      btrfs-rmw-1  4287    112722.098007       308   120    112722.098007         6.621868  32021125.219619 /
[32283.519501]  btrfs-delayed-m  4292    112722.117885       308   120    112722.117885         5.587984  32021136.787979 /
[32283.519595]             bash  4299        30.763546        49   120        30.763546        42.164339      3188.802764 /autogroup-72
[32283.519690]             tmux  4344        30.801147        10   120        30.801147         1.505874        27.671527 /autogroup-72
[32283.519785]             bash  4347        13.476300       101   120        13.476300        38.006035     59155.131455 /autogroup-74
[32283.519880]  btrfs-transacti  4415    112738.649793     13902   120    112738.649793      1461.598972  32054465.350542 /
[32283.519975] 
[32283.520016] cpu#4, 3400.125 MHz
[32283.520060]   .nr_running                    : 0
[32283.520105]   .load                          : 0
[32283.520150]   .nr_switches                   : 796578
[32283.520195]   .nr_load_updates               : 144766
[32283.520241]   .nr_uninterruptible            : 8489
[32283.520286]   .next_balance                  : 4298.167305
[32283.520333]   .curr->pid                     : 0
[32283.520378]   .clock                         : 32282463.708491
[32283.520424]   .cpu_load[0]                   : 0
[32283.520469]   .cpu_load[1]                   : 0
[32283.520514]   .cpu_load[2]                   : 0
[32283.520559]   .cpu_load[3]                   : 0
[32283.520604]   .cpu_load[4]                   : 0
[32283.520649]   .yld_count                     : 0
[32283.520694]   .sched_count                   : 811213
[32283.520739]   .sched_goidle                  : 335831
[32283.520785]   .avg_idle                      : 886040
[32283.520831]   .ttwu_count                    : 294799
[32283.520876]   .ttwu_local                    : 236938
[32283.520922] 
[32283.520922] cfs_rq[4]:/
[32283.521004]   .exec_clock                    : 80164.617933
[32283.521051]   .MIN_vruntime                  : 0.000001
[32283.521096]   .min_vruntime                  : 113473.305415
[32283.522248]   .max_vruntime                  : 0.000001
[32283.522293]   .spread                        : 0.000000
[32283.522339]   .spread0                       : -30102.888540
[32283.522385]   .nr_spread_over                : 639
[32283.522430]   .nr_running                    : 0
[32283.522475]   .load                          : 0
[32283.522520]   .runnable_load_avg             : 0
[32283.522565]   .blocked_load_avg              : 0
[32283.522610]   .tg_load_contrib               : 0
[32283.522654]   .tg_runnable_contrib           : 0
[32283.522699]   .tg_load_avg                   : 0
[32283.522744]   .tg->runnable_avg              : 1
[32283.522789]   .tg->cfs_bandwidth.timer_active: 0
[32283.522834]   .throttled                     : 0
[32283.522879]   .throttle_count                : 0
[32283.522923]   .avg->runnable_avg_sum         : 41
[32283.522968]   .avg->runnable_avg_period      : 47607
[32283.523014] 
[32283.523014] rt_rq[4]:/
[32283.523096]   .rt_nr_running                 : 0
[32283.523141]   .rt_throttled                  : 0
[32283.523186]   .rt_time                       : 0.000000
[32283.523232]   .rt_runtime                    : 950.000000
[32283.523278] 
[32283.523278] runnable tasks:
[32283.523278]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.523278] ----------------------------------------------------------------------------------------------------------
[32283.523546]       watchdog/4    26        -8.981900      8079     0        -8.981900        95.206040        46.507094 /
[32283.523640]      migration/4    27         0.000000      8432     0         0.000000        66.567115         0.000781 /
[32283.523734]      ksoftirqd/4    28    113461.143700      5381   120    113461.143700        55.866242  32277379.941730 /
[32283.523827]      kworker/4:0    29      5624.395428        19   120      5624.395428         0.049729    302229.257972 /
[32283.523921]     kworker/4:0H    30       845.888661         6   100       845.888661         0.026450      1035.111079 /
[32283.524017]          deferwq   742        34.988067         2   100        34.988067         0.006138         0.003138 /
[32283.524111]        scsi_eh_0   881       845.828887         3   120       845.828887         0.099703         1.933529 /
[32283.524204]        scsi_eh_2   885       850.308540        18   120       850.308540         4.506782       351.764753 /
[32283.524299]        scsi_eh_3   887       850.617992        18   120       850.617992         4.764073       351.578304 /
[32283.524393]     kworker/4:1H   909    113461.307677    107004   100    113461.307677      1087.970430  32280053.666149 /
[32283.524487]           bioset   954       984.872025         2   100       984.872025         0.008022         0.002768 /
[32283.524581]      kworker/4:2   966    113463.116982     65115   120    113463.116982       786.417842  32277753.440264 /
[32283.524675]            udevd  1334       216.142475         6   120       216.142475         0.848997    121725.576908 /autogroup-4
[32283.524772]         rsyslogd  3069      1493.821246        17   120      1493.821246         2.120170  10703328.387513 /autogroup-8
[32283.524867]            acpid  3177         0.723133        12   120         0.723133         0.585163   8861946.286186 /autogroup-10
[32283.524964]   btrfs-submit-1  4282    113461.126557       301   120    113461.126557         5.452759  32021137.033922 /
[32283.525059] 
[32283.525100] cpu#5, 3400.125 MHz
[32283.525143]   .nr_running                    : 0
[32283.525188]   .load                          : 0
[32283.525233]   .nr_switches                   : 371913
[32283.525278]   .nr_load_updates               : 116195
[32283.525324]   .nr_uninterruptible            : 9119
[32283.525369]   .next_balance                  : 4298.167355
[32283.525415]   .curr->pid                     : 0
[32283.525460]   .clock                         : 32281543.929250
[32283.525507]   .cpu_load[0]                   : 0
[32283.525551]   .cpu_load[1]                   : 0
[32283.525596]   .cpu_load[2]                   : 0
[32283.525641]   .cpu_load[3]                   : 0
[32283.525686]   .cpu_load[4]                   : 0
[32283.525731]   .yld_count                     : 0
[32283.525776]   .sched_count                   : 381980
[32283.525821]   .sched_goidle                  : 168909
[32283.525867]   .avg_idle                      : 1000000
[32283.525912]   .ttwu_count                    : 180902
[32283.525958]   .ttwu_local                    : 136240
[32283.526003] 
[32283.526003] cfs_rq[5]:/
[32283.526086]   .exec_clock                    : 86484.457943
[32283.526132]   .MIN_vruntime                  : 0.000001
[32283.526178]   .min_vruntime                  : 123224.597554
[32283.526224]   .max_vruntime                  : 0.000001
[32283.526270]   .spread                        : 0.000000
[32283.526316]   .spread0                       : -20351.596401
[32283.526362]   .nr_spread_over                : 902
[32283.526407]   .nr_running                    : 0
[32283.526452]   .load                          : 0
[32283.526497]   .runnable_load_avg             : 0
[32283.526542]   .blocked_load_avg              : 0
[32283.526587]   .tg_load_contrib               : 0
[32283.526632]   .tg_runnable_contrib           : 0
[32283.526677]   .tg_load_avg                   : 0
[32283.526722]   .tg->runnable_avg              : 1
[32283.526767]   .tg->cfs_bandwidth.timer_active: 0
[32283.526812]   .throttled                     : 0
[32283.526856]   .throttle_count                : 0
[32283.526901]   .avg->runnable_avg_sum         : 25
[32283.526946]   .avg->runnable_avg_period      : 46792
[32283.526992] 
[32283.526992] rt_rq[5]:/
[32283.527075]   .rt_nr_running                 : 0
[32283.527119]   .rt_throttled                  : 0
[32283.527165]   .rt_time                       : 0.000000
[32283.527210]   .rt_runtime                    : 950.000000
[32283.527257] 
[32283.527257] runnable tasks:
[32283.527257]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.527257] ----------------------------------------------------------------------------------------------------------
[32283.527522]       watchdog/5    31        -8.983613      8079     0        -8.983613        95.673587        32.996614 /
[32283.527615]      migration/5    32         0.000000      9145     0         0.000000        74.036671         0.000833 /
[32283.527709]      ksoftirqd/5    33    123200.560000      6327   120    123200.560000        63.225330  32041944.161169 /
[32283.527803]      kworker/5:0    34      1978.177009        17   120      1978.177009         0.055700    335485.719700 /
[32283.527897]     kworker/5:0H    35       454.347326         6   100       454.347326         0.025860      1053.906833 /
[32283.527993]     kworker/5:1H   927    123212.598482     21548   100    123212.598482       181.058362  32252994.301326 /
[32283.528087]        md0_raid1   946    123164.175974        68   120    123164.175974         1.552548  31832925.034896 /
[32283.528181]            udevd  1167       581.159448       282   120       581.159448        41.532151    122076.122937 /autogroup-4
[32283.528276]      kworker/5:2  1550    123213.041597     74113   120    123213.041597       891.377376  32245200.998054 /
[32283.528371]      btrfs-rmw-1  2289    123212.609832       344   120    123212.609832         3.535259  32141051.616685 /
[32283.528465]    btrfs-cleaner  2329    123212.708238      1437   120    123212.708238        58.310167  32209255.604976 /
[32283.528559]      dbus-daemon  3571         0.977291         1   120         0.977291         0.156215         0.000000 /autogroup-31
[32283.528655]            getty  4201         0.059634       104   120         0.059634         1.878105       179.087701 /autogroup-64
[32283.528751]    btrfs-cleaner  4414    123212.750982      1060   120    123212.750982        33.849439  32055902.765421 /
[32283.528846]          apache2  8396       139.401924         1   120       139.401924         0.345190         0.000000 /autogroup-24
[32283.528941] 
[32283.528982] cpu#6, 3400.125 MHz
[32283.529025]   .nr_running                    : 0
[32283.529070]   .load                          : 0
[32283.529115]   .nr_switches                   : 324724
[32283.529160]   .nr_load_updates               : 104201
[32283.529206]   .nr_uninterruptible            : 8851
[32283.529251]   .next_balance                  : 4298.167405
[32283.529297]   .curr->pid                     : 0
[32283.529343]   .clock                         : 32282043.635017
[32283.529389]   .cpu_load[0]                   : 0
[32283.529434]   .cpu_load[1]                   : 0
[32283.529479]   .cpu_load[2]                   : 0
[32283.529524]   .cpu_load[3]                   : 0
[32283.529569]   .cpu_load[4]                   : 0
[32283.529614]   .yld_count                     : 0
[32283.529659]   .sched_count                   : 333991
[32283.529704]   .sched_goidle                  : 147586
[32283.529750]   .avg_idle                      : 1000000
[32283.529795]   .ttwu_count                    : 158527
[32283.529841]   .ttwu_local                    : 118934
[32283.529886] 
[32283.529886] cfs_rq[6]:/
[32283.529969]   .exec_clock                    : 77778.824548
[32283.530015]   .MIN_vruntime                  : 0.000001
[32283.530061]   .min_vruntime                  : 124784.650522
[32283.530107]   .max_vruntime                  : 0.000001
[32283.530153]   .spread                        : 0.000000
[32283.530199]   .spread0                       : -18791.543433
[32283.530245]   .nr_spread_over                : 1477
[32283.530290]   .nr_running                    : 0
[32283.530335]   .load                          : 0
[32283.530380]   .runnable_load_avg             : 0
[32283.530425]   .blocked_load_avg              : 0
[32283.531574]   .tg_load_contrib               : 0
[32283.531618]   .tg_runnable_contrib           : 0
[32283.531664]   .tg_load_avg                   : 0
[32283.531709]   .tg->runnable_avg              : 1
[32283.531754]   .tg->cfs_bandwidth.timer_active: 0
[32283.531798]   .throttled                     : 0
[32283.531843]   .throttle_count                : 0
[32283.531888]   .avg->runnable_avg_sum         : 20
[32283.531933]   .avg->runnable_avg_period      : 48411
[32283.531979] 
[32283.531979] rt_rq[6]:/
[32283.532061]   .rt_nr_running                 : 0
[32283.532106]   .rt_throttled                  : 0
[32283.532151]   .rt_time                       : 0.000000
[32283.532197]   .rt_runtime                    : 950.000000
[32283.532243] 
[32283.532243] runnable tasks:
[32283.532243]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.532243] ----------------------------------------------------------------------------------------------------------
[32283.532508]       watchdog/6    36        -8.978765      8079     0        -8.978765        72.822265        19.378491 /
[32283.532601]      migration/6    37         0.000000      8881     0         0.000000        71.142707         0.000779 /
[32283.532695]      ksoftirqd/6    38    124772.355785      5604   120    124772.355785        57.415779  32046936.617701 /
[32283.532789]      kworker/6:0    39      6626.693362        13   120      6626.693362         0.028516       454.512566 /
[32283.532882]     kworker/6:0H    40      8261.664557         6   100      8261.664557         0.029355      1040.620134 /
[32283.532977]      kworker/6:1   624    124773.501683     66127   120    124773.501683       785.484986  32279768.003101 /
[32283.533071]    irq/41-mei_me   684         0.000000        17    49         0.000000         0.322865         0.000000 /
[32283.533167]     kworker/6:1H   928    123857.683366     15152   100    123857.683366       133.110757  32044853.607961 /
[32283.533261]           bioset   963      8333.921569         2   100      8333.921569         0.030540         0.015219 /
[32283.533356]  btrfs-endio-met  2291    124772.607721       312   120    124772.607721         4.378317  32141051.350244 /
[32283.533450]  btrfs-flush_del  2297    124772.604081       309   120    124772.604081         3.702297  32141061.761262 /
[32283.533544]            udevd  2638       397.417571         1   120       397.417571         0.178130         0.000000 /autogroup-4
[32283.533642] 
[32283.533683] cpu#7, 3400.125 MHz
[32283.533726]   .nr_running                    : 0
[32283.533771]   .load                          : 0
[32283.533816]   .nr_switches                   : 322365
[32283.533861]   .nr_load_updates               : 104913
[32283.533907]   .nr_uninterruptible            : 9500
[32283.533952]   .next_balance                  : 4298.167455
[32283.533998]   .curr->pid                     : 0
[32283.534043]   .clock                         : 32282543.340939
[32283.534090]   .cpu_load[0]                   : 0
[32283.534135]   .cpu_load[1]                   : 0
[32283.534180]   .cpu_load[2]                   : 0
[32283.534225]   .cpu_load[3]                   : 0
[32283.534270]   .cpu_load[4]                   : 0
[32283.534315]   .yld_count                     : 0
[32283.534359]   .sched_count                   : 331851
[32283.534405]   .sched_goidle                  : 148490
[32283.534450]   .avg_idle                      : 1000000
[32283.534496]   .ttwu_count                    : 156339
[32283.534541]   .ttwu_local                    : 116278
[32283.534587] 
[32283.534587] cfs_rq[7]:/
[32283.534670]   .exec_clock                    : 63829.596590
[32283.534716]   .MIN_vruntime                  : 0.000001
[32283.534761]   .min_vruntime                  : 104829.817308
[32283.534808]   .max_vruntime                  : 0.000001
[32283.534853]   .spread                        : 0.000000
[32283.534899]   .spread0                       : -38746.376647
[32283.534945]   .nr_spread_over                : 958
[32283.534990]   .nr_running                    : 0
[32283.535035]   .load                          : 0
[32283.535080]   .runnable_load_avg             : 0
[32283.535125]   .blocked_load_avg              : 0
[32283.535170]   .tg_load_contrib               : 0
[32283.535215]   .tg_runnable_contrib           : 0
[32283.535260]   .tg_load_avg                   : 0
[32283.535305]   .tg->runnable_avg              : 1
[32283.535350]   .tg->cfs_bandwidth.timer_active: 0
[32283.535395]   .throttled                     : 0
[32283.535440]   .throttle_count                : 0
[32283.535485]   .avg->runnable_avg_sum         : 22
[32283.535530]   .avg->runnable_avg_period      : 47853
[32283.535576]
[32283.535576] rt_rq[7]:/
[32283.535659]   .rt_nr_running                 : 0
[32283.535704]   .rt_throttled                  : 0
[32283.535749]   .rt_time                       : 0.000000
[32283.535794]   .rt_runtime                    : 950.000000
[32283.535841]
[32283.535841] runnable tasks:
[32283.535841]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[32283.535841] ----------------------------------------------------------------------------------------------------------
[32283.536106]       watchdog/7    41        -8.980460      8079     0        -8.980460        61.102193         5.774683 /
[32283.536199]      migration/7    42         0.000000      9550     0         0.000000        75.429195         0.000766 /
[32283.536293]      ksoftirqd/7    43    104817.846671      4873   120    104817.846671        49.802593  32277564.697166 /
[32283.536387]      kworker/7:0    44       215.098470        13   120       215.098470         0.035739       441.053790 /
[32283.536480]     kworker/7:0H    45       594.137656         6   100       594.137656         0.024059      1001.557112 /
[32283.536574]          khelper    46        10.956353         2   100        10.956353         0.005489         0.002367 /
[32283.536668]            netns    47        22.959676         2   100        22.959676         0.003625         0.001963 /
[32283.536762]        writeback   196        46.966466         2   100        46.966466         0.003836         0.001415 /
[32283.536856]           bioset   198        58.969736         2   100        58.969736         0.003569         0.001472 /
[32283.536949]          kblockd   199        70.972900         2   100        70.972900         0.003443         0.001370 /
[32283.537043]               md   368        94.980182         2   100        94.980182         0.003410         0.001489 /
[32283.537137]          kswapd0   517       215.099636         3   120       215.099636         0.020930        96.830888 /
[32283.537231]           crypto   590       155.027174         2   100       155.027174         0.007760         0.002566 /
[32283.537325]      kworker/7:1   626    104819.600303     65860   120    104819.600303       796.672835  32280293.735473 /
[32283.537419]        kpsmoused   697       239.100497         2   100       239.100497         0.009007         0.006247 /
[32283.537513]          ata_sff   878       437.761925         2   100       437.761925         0.009202         0.068803 /
[32283.537607]       scsi_tmf_0   882       449.793617         2   100       449.793617         0.033058         0.022789 /
[32283.537701]       scsi_tmf_1   884       473.885027         2   100       473.885027         0.031235         0.025914 /
[32283.537795]       scsi_tmf_2   886       497.990516         2   100       497.990516         0.033468         0.023583 /
[32283.537889]       scsi_tmf_3   888       522.051821         2   100       522.051821         0.038183         0.004172 /
[32283.537983]       scsi_tmf_4   890       546.064187         2   100       546.064187         0.005894         0.004740 /
[32283.538077]       scsi_tmf_5   892       570.075913         2   100       570.075913         0.006126         0.004100 /
[32283.538170]     kworker/7:1H   919    104817.675019     12387   100    104817.675019       109.019366  32042117.133959 /
[32283.538265]           bioset   945       641.086597         2   100       641.086597         0.005865         0.003763 /
[32283.538359]  ext4-rsv-conver   981       678.326386         2   100       678.326386         0.012128         0.005728 /
[32283.538453]       jbd2/md1-8  2274      1217.197271         2   120      1217.197271         0.028998         0.003545 /
[32283.538547]  ext4-rsv-conver  2275      1229.234322         2   100      1229.234322         0.037719         0.015602 /
[32283.538640]           bioset  2281      1253.276231         2   100      1253.276231         0.009828         0.022100 /
[32283.538736]            getty  4199         0.389559       103   120         0.389559         1.955323       179.288425 /autogroup-62
[32283.538833]


-- 
Tomasz Chmielewski
http://wpkg.org
