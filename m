Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:50257 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaEVCXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 22:23:07 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id A8C8935167D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 04:23:03 +0200 (CEST)
Received: from s9 (7.Red-88-15-60.dynamicIP.rima-tde.net [88.15.60.7])
	by mail.virtall.com (Postfix) with ESMTPSA id 787293514B8
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 04:23:02 +0200 (CEST)
Date: Thu, 22 May 2014 03:22:58 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: mount hangs after disk crash (RAID-1)
Message-ID: <20140522032258.234aaab7@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One disk in RAID-1 crashed, so powered off, changed disk, powered
on, trying to mount degraded. 

Unfortunately it hangs (running 3.14.4).

# mount -o degraded,compress=lzo,noatime /dev/sdb4 /home
(...never returns...)

iostat shows no disk activity.

Any ideas how to recover?


dmesg shows:

[  115.521656] Btrfs loaded
[  115.522530] BTRFS: device label home devid 2 transid 53234 /dev/sdb4
[  115.523217] BTRFS info (device sdb4): allowing degraded mounts
[  115.523282] BTRFS info (device sdb4): disk space caching is enabled
[  115.624905] BTRFS: bdev (null) errs: wr 0, rd 58, flush 0, corrupt 0, gen 0
[  144.538692] BTRFS error (device sdb4): free space inode generation (0) did not match free space cache generation (53233)
[  360.512573] INFO: task mount:4469 blocked for more than 120 seconds.
[  360.512632]       Not tainted 3.14.4 #1
[  360.512685] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.512734] mount           D 0000000000000002     0  4469   4424 0x00000000
[  360.512855]  ffff880812ed9628 0000000000000082 0000041100000000 ffff880811009800
[  360.513092]  00000000000116c0 0000000000004000 ffff880813e0b000 ffff880811009800
[  360.513372]  0000000000000000 ffff8807c33db468 0000000000000000 000000000000b000
[  360.513652] Call Trace:
[  360.513746]  [<ffffffffa0359dd8>] ? submit_stripe_bio+0x5b/0x5d [btrfs]
[  360.513841]  [<ffffffffa035dd83>] ? btrfs_map_bio+0x377/0x3fc [btrfs]
[  360.513933]  [<ffffffff810b1ae5>] ? find_get_pages_tag+0xe9/0x123
[  360.514022]  [<ffffffff810b1d5c>] ? __lock_page+0x63/0x63
[  360.514112]  [<ffffffff8139756e>] schedule+0x6a/0x6c
[  360.514215]  [<ffffffff813975fa>] io_schedule+0x8a/0xc8
[  360.514302]  [<ffffffff810b1d65>] sleep_on_page+0x9/0xd
[  360.514391]  [<ffffffff81397b5b>] __wait_on_bit+0x45/0x7e
[  360.514479]  [<ffffffff810b1ae5>] ? find_get_pages_tag+0xe9/0x123
[  360.514568]  [<ffffffff810b1f6d>] wait_on_page_bit+0x71/0x73
[  360.514657]  [<ffffffff81067ff2>] ? wake_atomic_t_function+0x28/0x28
[  360.514747]  [<ffffffff810b2027>] filemap_fdatawait_range+0x79/0x118
[  360.514841]  [<ffffffffa0350cac>] btrfs_wait_ordered_range+0x6e/0x120 [btrfs]
[  360.514937]  [<ffffffffa0370f8b>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  360.515030]  [<ffffffffa031d921>] ? comp_keys+0x26/0x28 [btrfs]
[  360.515123]  [<ffffffffa0371485>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  360.515218]  [<ffffffffa035612b>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  360.515312]  [<ffffffffa032e9a0>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  360.515450]  [<ffffffffa033a0fd>] commit_cowonly_roots+0x13f/0x21a [btrfs]
[  360.515544]  [<ffffffffa033bbf8>] btrfs_commit_transaction+0x410/0x7ff [btrfs]
[  360.515683]  [<ffffffffa037ca26>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  360.515820]  [<ffffffffa0339aa9>] open_ctree+0x182c/0x1b5c [btrfs]
[  360.515910]  [<ffffffff811a988e>] ? ida_get_new_above+0x178/0x192
[  360.516001]  [<ffffffffa0318059>] btrfs_mount+0x40b/0x718 [btrfs]
[  360.516090]  [<ffffffff810b8dc6>] ? __free_pages+0x1c/0x48
[  360.516179]  [<ffffffff81172056>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  360.516269]  [<ffffffff810fb7fd>] mount_fs+0x64/0x14f
[  360.516356]  [<ffffffff810c839d>] ? __alloc_percpu+0xb/0xd
[  360.516445]  [<ffffffff8111076e>] vfs_kern_mount+0x61/0xec
[  360.516533]  [<ffffffff811127aa>] do_mount+0x70b/0x8af
[  360.516621]  [<ffffffff81112b88>] SyS_mount+0x80/0xb9
[  360.516709]  [<ffffffff8139a5a2>] system_call_fastpath+0x16/0x1b
[  360.516800] INFO: task btrfs-transacti:4680 blocked for more than 120 seconds.
[  360.516933]       Not tainted 3.14.4 #1
[  360.517018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.517151] btrfs-transacti D ffff8807f0da5000     0  4680      2 0x00000000
[  360.517314]  ffff8808118cfd78 0000000000000046 ffff8808118cfd00 ffff880811844800
[  360.517594]  00000000000116c0 0000000000004000 ffff880813df9800 ffff880811844800
[  360.517873]  ffff8808118cfdb8 0000000000000292 0000000000000000 0000000000000000
[  360.518153] Call Trace:
[  360.518241]  [<ffffffffa033c477>] ? start_transaction+0x16f/0x459 [btrfs]
[  360.518332]  [<ffffffff8139756e>] schedule+0x6a/0x6c
[  360.518422]  [<ffffffffa033b299>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  360.518556]  [<ffffffff81067f98>] ? __wake_up_sync+0xd/0xd
[  360.518648]  [<ffffffffa033c503>] start_transaction+0x1fb/0x459 [btrfs]
[  360.518741]  [<ffffffffa033c7ae>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  360.518834]  [<ffffffffa0339ea6>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  360.518927]  [<ffffffffa0339dd9>] ? open_ctree+0x1b5c/0x1b5c [btrfs]
[  360.519018]  [<ffffffff81050d3e>] kthread+0xcd/0xd5
[  360.519105]  [<ffffffff81030000>] ? unmap_pte_range+0x51/0x96
[  360.519194]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43
[  360.519284]  [<ffffffff8139a4fc>] ret_from_fork+0x7c/0xb0
[  360.519372]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43



[  442.318694] SysRq : Show Blocked State
[  442.318842]   task                        PC stack   pid father
[  442.318982] mount           D 0000000000000002     0  4469   4424 0x00000000
[  442.319171]  ffff880812ed9628 0000000000000082 0000041100000000 ffff880811009800
[  442.319494]  00000000000116c0 0000000000004000 ffff880813e0b000 ffff880811009800
[  442.319815]  0000000000000000 ffff8807c33db468 0000000000000000 000000000000b000
[  442.320136] Call Trace:
[  442.320257]  [<ffffffffa0359dd8>] ? submit_stripe_bio+0x5b/0x5d [btrfs]
[  442.320382]  [<ffffffffa035dd83>] ? btrfs_map_bio+0x377/0x3fc [btrfs]
[  442.320494]  [<ffffffff810b1ae5>] ? find_get_pages_tag+0xe9/0x123
[  442.320607]  [<ffffffff810b1d5c>] ? __lock_page+0x63/0x63
[  442.320715]  [<ffffffff8139756e>] schedule+0x6a/0x6c
[  442.320820]  [<ffffffff813975fa>] io_schedule+0x8a/0xc8
[  442.320925]  [<ffffffff810b1d65>] sleep_on_page+0x9/0xd
[  442.321031]  [<ffffffff81397b5b>] __wait_on_bit+0x45/0x7e
[  442.321138]  [<ffffffff810b1ae5>] ? find_get_pages_tag+0xe9/0x123
[  442.321244]  [<ffffffff810b1f6d>] wait_on_page_bit+0x71/0x73
[  442.321352]  [<ffffffff81067ff2>] ? wake_atomic_t_function+0x28/0x28
[  442.321460]  [<ffffffff810b2027>] filemap_fdatawait_range+0x79/0x118
[  442.321580]  [<ffffffffa0350cac>] btrfs_wait_ordered_range+0x6e/0x120 [btrfs]
[  442.321701]  [<ffffffffa0370f8b>] __btrfs_write_out_cache+0x47a/0x6ef [btrfs]
[  442.321815]  [<ffffffffa031d921>] ? comp_keys+0x26/0x28 [btrfs]
[  442.321932]  [<ffffffffa0371485>] btrfs_write_out_cache+0x8c/0xc1 [btrfs]
[  442.322051]  [<ffffffffa035612b>] ? free_extent_buffer+0x6f/0x7c [btrfs]
[  442.322167]  [<ffffffffa032e9a0>] btrfs_write_dirty_block_groups+0x54b/0x56f [btrfs]
[  442.322340]  [<ffffffffa033a0fd>] commit_cowonly_roots+0x13f/0x21a [btrfs]
[  442.322458]  [<ffffffffa033bbf8>] btrfs_commit_transaction+0x410/0x7ff [btrfs]
[  442.322631]  [<ffffffffa037ca26>] btrfs_recover_relocation+0x2a1/0x353 [btrfs]
[  442.322802]  [<ffffffffa0339aa9>] open_ctree+0x182c/0x1b5c [btrfs]
[  442.322910]  [<ffffffff811a988e>] ? ida_get_new_above+0x178/0x192
[  442.323023]  [<ffffffffa0318059>] btrfs_mount+0x40b/0x718 [btrfs]
[  442.323131]  [<ffffffff810b8dc6>] ? __free_pages+0x1c/0x48
[  442.323238]  [<ffffffff81172056>] ? selinux_sb_copy_data+0x1a0/0x1d1
[  442.323346]  [<ffffffff810fb7fd>] mount_fs+0x64/0x14f
[  442.323451]  [<ffffffff810c839d>] ? __alloc_percpu+0xb/0xd
[  442.323558]  [<ffffffff8111076e>] vfs_kern_mount+0x61/0xec
[  442.323663]  [<ffffffff811127aa>] do_mount+0x70b/0x8af
[  442.325267]  [<ffffffff81112b88>] SyS_mount+0x80/0xb9
[  442.325372]  [<ffffffff8139a5a2>] system_call_fastpath+0x16/0x1b
[  442.325482] btrfs-transacti D ffff8807f0da5000     0  4680      2 0x00000000
[  442.325671]  ffff8808118cfd78 0000000000000046 ffff8808118cfd00 ffff880811844800
[  442.325992]  00000000000116c0 0000000000004000 ffff880813df9800 ffff880811844800
[  442.326312]  ffff8808118cfdb8 0000000000000292 0000000000000000 0000000000000000
[  442.326633] Call Trace:
[  442.326743]  [<ffffffffa033c477>] ? start_transaction+0x16f/0x459 [btrfs]
[  442.326851]  [<ffffffff8139756e>] schedule+0x6a/0x6c
[  442.326964]  [<ffffffffa033b299>] wait_current_trans.isra.36+0x94/0xe2 [btrfs]
[  442.327126]  [<ffffffff81067f98>] ? __wake_up_sync+0xd/0xd
[  442.327239]  [<ffffffffa033c503>] start_transaction+0x1fb/0x459 [btrfs]
[  442.327355]  [<ffffffffa033c7ae>] btrfs_attach_transaction+0x12/0x14 [btrfs]
[  442.327471]  [<ffffffffa0339ea6>] transaction_kthread+0xcd/0x1c3 [btrfs]
[  442.327587]  [<ffffffffa0339dd9>] ? open_ctree+0x1b5c/0x1b5c [btrfs]
[  442.327696]  [<ffffffff81050d3e>] kthread+0xcd/0xd5
[  442.327801]  [<ffffffff81030000>] ? unmap_pte_range+0x51/0x96
[  442.327908]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43
[  442.328017]  [<ffffffff8139a4fc>] ret_from_fork+0x7c/0xb0
[  442.328123]  [<ffffffff81050c71>] ? kthread_freezable_should_stop+0x43/0x43
[  442.328232] Sched Debug Version: v0.11, 3.14.4 #1
[  442.328336] ktime                                   : 442568.889963
[  442.328442] sched_clk                               : 442328.231419
[  442.328547] cpu_clk                                 : 442328.231449
[  442.328653] jiffies                                 : 4294981553
[  442.328758] sched_clock_stable()                    : 1
[  442.328861] 
[  442.328957] sysctl_sched
[  442.329055]   .sysctl_sched_latency                    : 24.000000
[  442.329161]   .sysctl_sched_min_granularity            : 3.000000
[  442.329266]   .sysctl_sched_wakeup_granularity         : 4.000000
[  442.329372]   .sysctl_sched_child_runs_first           : 0
[  442.329477]   .sysctl_sched_features                   : 11899
[  442.329581]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  442.329687] 
[  442.329782] cpu#0, 3411.486 MHz
[  442.329882]   .nr_running                    : 0
[  442.329984]   .load                          : 0
[  442.330086]   .nr_switches                   : 193135
[  442.330189]   .nr_load_updates               : 18917
[  442.330292]   .nr_uninterruptible            : -977
[  442.330395]   .next_balance                  : 4294.981554
[  442.330499]   .curr->pid                     : 0
[  442.330601]   .clock                         : 442320.413954
[  442.330705]   .cpu_load[0]                   : 0
[  442.330807]   .cpu_load[1]                   : 0
[  442.330909]   .cpu_load[2]                   : 0
[  442.331011]   .cpu_load[3]                   : 0
[  442.331113]   .cpu_load[4]                   : 0
[  442.331216]   .yld_count                     : 13
[  442.331318]   .sched_count                   : 200232
[  442.331421]   .sched_goidle                  : 73213
[  442.331523]   .avg_idle                      : 864796
[  442.331627]   .ttwu_count                    : 130526
[  442.331730]   .ttwu_local                    : 109416
[  442.331834] 
[  442.331834] cfs_rq[0]:/autogroup-26
[  442.331989]   .exec_clock                    : 120.820030
[  442.332092]   .MIN_vruntime                  : 0.000001
[  442.332195]   .min_vruntime                  : 119.519138
[  442.332299]   .max_vruntime                  : 0.000001
[  442.332403]   .spread                        : 0.000000
[  442.332507]   .spread0                       : -9825.001370
[  442.332611]   .nr_spread_over                : 0
[  442.332713]   .nr_running                    : 0
[  442.332814]   .load                          : 0
[  442.332916]   .runnable_load_avg             : 0
[  442.333018]   .blocked_load_avg              : 0
[  442.333120]   .tg_load_contrib               : 0
[  442.333222]   .tg_runnable_contrib           : 2
[  442.333324]   .tg_load_avg                   : 0
[  442.333426]   .tg->runnable_avg              : 2
[  442.333528]   .tg->cfs_bandwidth.timer_active: 0
[  442.333630]   .throttled                     : 0
[  442.333732]   .throttle_count                : 0
[  442.333834]   .se->exec_start                : 442318.673917
[  442.333938]   .se->vruntime                  : 9932.611723
[  442.334042]   .se->sum_exec_runtime          : 120.820030
[  442.334146]   .se->statistics.wait_start     : 0.000000
[  442.334250]   .se->statistics.sleep_start    : 0.000000
[  442.334353]   .se->statistics.block_start    : 0.000000
[  442.334457]   .se->statistics.sleep_max      : 0.000000
[  442.334561]   .se->statistics.block_max      : 0.000000
[  442.334665]   .se->statistics.exec_max       : 9.854141
[  442.334769]   .se->statistics.slice_max      : 0.162777
[  442.334872]   .se->statistics.wait_max       : 0.035742
[  442.334976]   .se->statistics.wait_sum       : 0.358340
[  442.335079]   .se->statistics.wait_count     : 5282
[  442.335182]   .se->load.weight               : 2
[  442.335284]   .se->avg.runnable_avg_sum      : 133
[  442.335386]   .se->avg.runnable_avg_period   : 47866
[  442.335489]   .se->avg.load_avg_contrib      : 0
[  442.335591]   .se->avg.decay_count           : 421828
[  442.335695] 
[  442.335695] cfs_rq[0]:/autogroup-6
[  442.335850]   .exec_clock                    : 6051.469384
[  442.335953]   .MIN_vruntime                  : 0.000001
[  442.336057]   .min_vruntime                  : 5861.283469
[  442.336160]   .max_vruntime                  : 0.000001
[  442.336263]   .spread                        : 0.000000
[  442.336366]   .spread0                       : -4083.237039
[  442.336470]   .nr_spread_over                : 55
[  442.336573]   .nr_running                    : 0
[  442.336675]   .load                          : 0
[  442.336777]   .runnable_load_avg             : 0
[  442.336879]   .blocked_load_avg              : 0
[  442.336981]   .tg_load_contrib               : 0
[  442.337083]   .tg_runnable_contrib           : 0
[  442.337185]   .tg_load_avg                   : 6
[  442.337287]   .tg->runnable_avg              : 0
[  442.337388]   .tg->cfs_bandwidth.timer_active: 0
[  442.337490]   .throttled                     : 0
[  442.337593]   .throttle_count                : 0
[  442.337695]   .se->exec_start                : 442320.411912
[  442.337799]   .se->vruntime                  : 9944.520508
[  442.337903]   .se->sum_exec_runtime          : 6051.472003
[  442.338008]   .se->statistics.wait_start     : 0.000000
[  442.338111]   .se->statistics.sleep_start    : 0.000000
[  442.338215]   .se->statistics.block_start    : 0.000000
[  442.338318]   .se->statistics.sleep_max      : 0.000000
[  442.338421]   .se->statistics.block_max      : 0.000000
[  442.338525]   .se->statistics.exec_max       : 9.993329
[  442.338629]   .se->statistics.slice_max      : 0.140059
[  442.338732]   .se->statistics.wait_max       : 0.077045
[  442.338837]   .se->statistics.wait_sum       : 493.196736
[  442.338940]   .se->statistics.wait_count     : 41001
[  442.339043]   .se->load.weight               : 2
[  442.339145]   .se->avg.runnable_avg_sum      : 121
[  442.339247]   .se->avg.runnable_avg_period   : 47929
[  442.339350]   .se->avg.load_avg_contrib      : 0
[  442.339460]   .se->avg.decay_count           : 421830
[  442.339572] 
[  442.339572] cfs_rq[0]:/
[  442.339724]   .exec_clock                    : 7755.380964
[  442.339828]   .MIN_vruntime                  : 0.000001
[  442.339931]   .min_vruntime                  : 9944.628775
[  442.340035]   .max_vruntime                  : 0.000001
[  442.340138]   .spread                        : 0.000000
[  442.340242]   .spread0                       : 0.000000
[  442.340346]   .nr_spread_over                : 15
[  442.340448]   .nr_running                    : 0
[  442.340550]   .load                          : 0
[  442.340653]   .runnable_load_avg             : 0
[  442.340754]   .blocked_load_avg              : 2
[  442.340856]   .tg_load_contrib               : 2
[  442.340958]   .tg_runnable_contrib           : 7
[  442.341060]   .tg_load_avg                   : 2
[  442.341163]   .tg->runnable_avg              : 18
[  442.341265]   .tg->cfs_bandwidth.timer_active: 0
[  442.341367]   .throttled                     : 0
[  442.341469]   .throttle_count                : 0
[  442.341571]   .avg->runnable_avg_sum         : 348
[  442.341674]   .avg->runnable_avg_period      : 48024
[  442.341779] 
[  442.341779] rt_rq[0]:/
[  442.341932]   .rt_nr_running                 : 0
[  442.342035]   .rt_throttled                  : 0
[  442.342137]   .rt_time                       : 0.000000
[  442.342241]   .rt_runtime                    : 950.000000
[  442.342346] 
[  442.342346] runnable tasks:
[  442.342346]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.342346] ----------------------------------------------------------------------------------------------------------
[  442.342750]      ksoftirqd/0     3      9931.873286       940   120      9931.873286         9.380748    441453.948404 /
[  442.343080]     kworker/0:0H     5       892.634890         5   100       892.634890         0.037675      1145.285746 /
[  442.343410]        rcu_sched     7      9944.628775      9813   120      9944.628775       667.260040    441532.117991 /
[  442.343739]           rcu_bh     8       117.315808         2   120       117.315808         0.000860         0.000728 /
[  442.344068]      migration/0     9         0.000000        38     0         0.000000       602.383800         0.000876 /
[  442.344396]       watchdog/0    10       -11.785717       120     0       -11.785717         1.486157        93.388826 /
[  442.346229]            khubd   339      1893.145244        62   120      1893.145244         4.145054     34134.084693 /
[  442.346558]    fsnotify_mark   560      1789.847970        14   120      1789.847970         0.345820     32904.674520 /
[  442.346887]      kworker/0:1   587      9932.487695     10283   120      9932.487695       107.618280    440853.949530 /
[  442.347215]      kworker/0:2   675      9216.825160         8   120      9216.825160         0.076248    113974.508948 /
[  442.347544]        scsi_eh_1   843       889.953484        18   120       889.953484         0.984397       350.351017 /
[  442.347872]        scsi_eh_3   847       889.050938         3   120       889.050938         0.061990         1.339428 /
[  442.348201]    kworker/u16:5   856       904.634567        45   120       904.634567         1.639225       388.329788 /
[  442.348530]     kworker/0:1H   864      9932.102629     48754   100      9932.102629       405.424799    439787.020895 /
[  442.348857]        md2_raid1   908      9932.173256       583   120      9932.173256        19.913980    440121.454369 /
[  442.349185]       jbd2/md2-8   923      9929.333300       385   120      9929.333300        20.817376    436476.026189 /
[  442.349516]    rs:main Q:Reg  3024      5781.492937        56   120      5781.492937         6.858607    323799.016826 /autogroup-6
[  442.349847]            acpid  3157         0.892033         4   120         0.892033         0.529410       325.839215 /autogroup-10
[  442.350178]    ipv6_addrconf  3283      2816.279997         2   100      2816.279997         0.009845         0.005355 /
[  442.350506]             sshd  3359         0.532207         4   120         0.532207         0.652976     14440.055877 /autogroup-14
[  442.350838]           mysqld  4030      5848.675013       810   120      5848.675013        10.758223    402840.310308 /autogroup-6
[  442.351169]           mysqld  4051      1770.272079        27   120      1770.272079         1.613443     13749.994153 /autogroup-6
[  442.351500]           mysqld  4078      5861.283469      4400   120      5861.283469      1709.429214    398008.571608 /autogroup-6
[  442.351830]           pickup  4287        -1.064741        12   120        -1.064741         2.742415    360245.220393 /autogroup-18
[  442.352160]             sshd  4317       119.519138      5333   120       119.519138       137.837336    390966.825167 /autogroup-26
[  442.352491]  btrfs-genwork-1  4477      9886.892976        10   120      9886.892976         0.330109    273933.538729 /
[  442.352819]    btrfs-fixup-1  4480      9855.758107         5   120      9855.758107         0.075281    239871.393770 /
[  442.353149] 
[  442.353245] cpu#1, 3411.486 MHz
[  442.353345]   .nr_running                    : 1
[  442.353447]   .load                          : 1024
[  442.353550]   .nr_switches                   : 62292
[  442.353653]   .nr_load_updates               : 9496
[  442.353756]   .nr_uninterruptible            : -364
[  442.353859]   .next_balance                  : 4294.981507
[  442.353963]   .curr->pid                     : 4319
[  442.354066]   .clock                         : 442318.588923
[  442.354170]   .cpu_load[0]                   : 0
[  442.354272]   .cpu_load[1]                   : 0
[  442.354374]   .cpu_load[2]                   : 0
[  442.354476]   .cpu_load[3]                   : 0
[  442.354578]   .cpu_load[4]                   : 0
[  442.354680]   .yld_count                     : 76
[  442.354783]   .sched_count                   : 63100
[  442.354885]   .sched_goidle                  : 18234
[  442.354988]   .avg_idle                      : 1000000
[  442.355091]   .ttwu_count                    : 29773
[  442.355193]   .ttwu_local                    : 19829
[  442.355297] 
[  442.355297] cfs_rq[1]:/autogroup-27
[  442.355453]   .exec_clock                    : 81.696104
[  442.355556]   .MIN_vruntime                  : 0.000001
[  442.355660]   .min_vruntime                  : 92.535898
[  442.355762]   .max_vruntime                  : 0.000001
[  442.355866]   .spread                        : 0.000000
[  442.355969]   .spread0                       : -9852.092877
[  442.356072]   .nr_spread_over                : 5
[  442.356174]   .nr_running                    : 1
[  442.356276]   .load                          : 1024
[  442.356380]   .runnable_load_avg             : 0
[  442.356482]   .blocked_load_avg              : 0
[  442.356583]   .tg_load_contrib               : 0
[  442.356685]   .tg_runnable_contrib           : 0
[  442.356788]   .tg_load_avg                   : 0
[  442.356891]   .tg->runnable_avg              : 0
[  442.356993]   .tg->cfs_bandwidth.timer_active: 0
[  442.357095]   .throttled                     : 0
[  442.357197]   .throttle_count                : 0
[  442.357299]   .se->exec_start                : 442318.588923
[  442.357404]   .se->vruntime                  : 3313.056370
[  442.357507]   .se->sum_exec_runtime          : 81.696104
[  442.357610]   .se->statistics.wait_start     : 0.000000
[  442.357714]   .se->statistics.sleep_start    : 0.000000
[  442.357817]   .se->statistics.block_start    : 0.000000
[  442.357921]   .se->statistics.sleep_max      : 0.000000
[  442.358024]   .se->statistics.block_max      : 0.000000
[  442.358127]   .se->statistics.exec_max       : 4.151935
[  442.358231]   .se->statistics.slice_max      : 0.000000
[  442.358334]   .se->statistics.wait_max       : 0.017807
[  442.358438]   .se->statistics.wait_sum       : 17.760581
[  442.358542]   .se->statistics.wait_count     : 12191
[  442.358645]   .se->load.weight               : 1024
[  442.358748]   .se->avg.runnable_avg_sum      : 43
[  442.358850]   .se->avg.runnable_avg_period   : 47852
[  442.358953]   .se->avg.load_avg_contrib      : 0
[  442.359054]   .se->avg.decay_count           : 0
[  442.359158] 
[  442.359158] cfs_rq[1]:/autogroup-11
[  442.359312]   .exec_clock                    : 13.586455
[  442.359418]   .MIN_vruntime                  : 0.000001
[  442.359538]   .min_vruntime                  : 12.495082
[  442.359642]   .max_vruntime                  : 0.000001
[  442.359746]   .spread                        : 0.000000
[  442.359849]   .spread0                       : -9932.133693
[  442.359954]   .nr_spread_over                : 0
[  442.360056]   .nr_running                    : 0
[  442.360158]   .load                          : 0
[  442.360261]   .runnable_load_avg             : 0
[  442.360362]   .blocked_load_avg              : 0
[  442.360465]   .tg_load_contrib               : 0
[  442.360566]   .tg_runnable_contrib           : 0
[  442.360668]   .tg_load_avg                   : 11
[  442.360770]   .tg->runnable_avg              : 0
[  442.360872]   .tg->cfs_bandwidth.timer_active: 0
[  442.360974]   .throttled                     : 0
[  442.361075]   .throttle_count                : 0
[  442.361178]   .se->exec_start                : 442305.421941
[  442.361282]   .se->vruntime                  : 3301.750096
[  442.361386]   .se->sum_exec_runtime          : 13.596082
[  442.361489]   .se->statistics.wait_start     : 0.000000
[  442.361592]   .se->statistics.sleep_start    : 0.000000
[  442.361696]   .se->statistics.block_start    : 0.000000
[  442.361799]   .se->statistics.sleep_max      : 0.000000
[  442.361902]   .se->statistics.block_max      : 0.000000
[  442.362005]   .se->statistics.exec_max       : 0.046339
[  442.362108]   .se->statistics.slice_max      : 0.023465
[  442.362212]   .se->statistics.wait_max       : 0.009714
[  442.362315]   .se->statistics.wait_sum       : 0.080283
[  442.362418]   .se->statistics.wait_count     : 791
[  442.362520]   .se->load.weight               : 2
[  442.362621]   .se->avg.runnable_avg_sum      : 13
[  442.362723]   .se->avg.runnable_avg_period   : 46991
[  442.362826]   .se->avg.load_avg_contrib      : 0
[  442.362928]   .se->avg.decay_count           : 421816
[  442.363032] 
[  442.363032] cfs_rq[1]:/
[  442.363185]   .exec_clock                    : 1792.699568
[  442.363288]   .MIN_vruntime                  : 0.000001
[  442.363391]   .min_vruntime                  : 3313.735798
[  442.363495]   .max_vruntime                  : 0.000001
[  442.363599]   .spread                        : 0.000000
[  442.363702]   .spread0                       : -6631.009680
[  442.363806]   .nr_spread_over                : 7
[  442.363908]   .nr_running                    : 1
[  442.364010]   .load                          : 1024
[  442.364112]   .runnable_load_avg             : 0
[  442.364214]   .blocked_load_avg              : 0
[  442.364315]   .tg_load_contrib               : 0
[  442.364418]   .tg_runnable_contrib           : 1
[  442.364519]   .tg_load_avg                   : 3
[  442.364621]   .tg->runnable_avg              : 18
[  442.364723]   .tg->cfs_bandwidth.timer_active: 0
[  442.364826]   .throttled                     : 0
[  442.364928]   .throttle_count                : 0
[  442.365031]   .avg->runnable_avg_sum         : 62
[  442.365132]   .avg->runnable_avg_period      : 47701
[  442.365235] 
[  442.365235] rt_rq[1]:/
[  442.365387]   .rt_nr_running                 : 0
[  442.365496]   .rt_throttled                  : 0
[  442.365602]   .rt_time                       : 0.000000
[  442.365705]   .rt_runtime                    : 950.000000
[  442.365810] 
[  442.365810] runnable tasks:
[  442.365810]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.365810] ----------------------------------------------------------------------------------------------------------
[  442.366221]       watchdog/1    11        -2.973630       114     0        -2.973630         1.329926        85.682243 /
[  442.366549]      migration/1    12         0.000000        41     0         0.000000         5.557719         0.000783 /
[  442.366878]      ksoftirqd/1    13      3301.496380       298   120      3301.496380         3.900868    440809.956960 /
[  442.368705]      kworker/1:0    14        -3.023870        13   120        -3.023870         0.025837       593.148821 /
[  442.369034]     kworker/1:0H    15       359.229340         6   100       359.229340         0.038046      1799.175182 /
[  442.369366]      kworker/1:1   589      3301.756800     16791   120      3301.756800        69.619205    441509.002041 /
[  442.369696]        scsi_eh_0   841       335.205607        18   120       335.205607         1.084244       350.637393 /
[  442.370025]        scsi_eh_2   845       334.171524         3   120       334.171524         0.014411         1.510574 /
[  442.370354]    kworker/u16:4   855      3301.842442       383   120      3301.842442        23.225454    440937.637564 /
[  442.370684]     kworker/1:1H   910      3201.954035        58   100      3201.954035         0.621261    147406.687293 /
[  442.371014]          vnstatd  3005         1.558586        85   120         1.558586        11.078703    404868.419760 /autogroup-7
[  442.371345]            nginx  3194        12.495082       811   120        12.495082        14.451161    405204.017547 /autogroup-11
[  442.371676]      mysqld_safe  3394       101.727991       434   120       101.727991        30.541534       458.372200 /autogroup-6
[  442.372006]           mysqld  4027       883.843182       809   120       883.843182        12.109428    402840.869767 /autogroup-6
[  442.372337]           mysqld  4083       875.137553     39714   120       875.137553      5376.267729     71672.847772 /autogroup-6
[  442.372668]           config  4233         3.076594         6   120         3.076594         3.271436        50.123413 /autogroup-16
[  442.373000]            getty  4303         0.441506       106   120         0.441506         1.670013        61.972680 /autogroup-22
[  442.373333] R           bash  4319        92.535898       359   120        92.535898        77.934814    389828.504167 /autogroup-27
[  442.373662]             bash  4424        38.770826        73   120        38.770826        44.222275      7183.090698 /autogroup-29
[  442.373994]            udevd  4475        70.155343         1   120        70.155343         0.224711         0.000000 /autogroup-4
[  442.374325] 
[  442.374421] cpu#2, 3411.486 MHz
[  442.374520]   .nr_running                    : 0
[  442.374623]   .load                          : 0
[  442.374725]   .nr_switches                   : 29565
[  442.374826]   .nr_load_updates               : 9147
[  442.374929]   .nr_uninterruptible            : -620
[  442.375032]   .next_balance                  : 4294.981559
[  442.375136]   .curr->pid                     : 0
[  442.375239]   .clock                         : 442369.344644
[  442.375343]   .cpu_load[0]                   : 0
[  442.375444]   .cpu_load[1]                   : 0
[  442.375545]   .cpu_load[2]                   : 0
[  442.375647]   .cpu_load[3]                   : 0
[  442.375748]   .cpu_load[4]                   : 0
[  442.375850]   .yld_count                     : 0
[  442.375952]   .sched_count                   : 29689
[  442.376055]   .sched_goidle                  : 14224
[  442.376158]   .avg_idle                      : 1000000
[  442.376261]   .ttwu_count                    : 11458
[  442.376363]   .ttwu_local                    : 7275
[  442.376466] 
[  442.376466] cfs_rq[2]:/autogroup-6
[  442.376620]   .exec_clock                    : 560.201135
[  442.376724]   .MIN_vruntime                  : 0.000001
[  442.376827]   .min_vruntime                  : 592.353230
[  442.376931]   .max_vruntime                  : 0.000001
[  442.377035]   .spread                        : 0.000000
[  442.377138]   .spread0                       : -9352.392248
[  442.377243]   .nr_spread_over                : 294
[  442.377345]   .nr_running                    : 0
[  442.377448]   .load                          : 0
[  442.377550]   .runnable_load_avg             : 0
[  442.377652]   .blocked_load_avg              : 0
[  442.377753]   .tg_load_contrib               : 0
[  442.377855]   .tg_runnable_contrib           : 0
[  442.377958]   .tg_load_avg                   : 0
[  442.378059]   .tg->runnable_avg              : 4
[  442.378161]   .tg->cfs_bandwidth.timer_active: 0
[  442.378263]   .throttled                     : 0
[  442.378365]   .throttle_count                : 0
[  442.378468]   .se->exec_start                : 442365.468242
[  442.378572]   .se->vruntime                  : 2918.689109
[  442.378676]   .se->sum_exec_runtime          : 560.201135
[  442.378780]   .se->statistics.wait_start     : 0.000000
[  442.378884]   .se->statistics.sleep_start    : 0.000000
[  442.378988]   .se->statistics.block_start    : 0.000000
[  442.379091]   .se->statistics.sleep_max      : 0.000000
[  442.379194]   .se->statistics.block_max      : 0.000000
[  442.379298]   .se->statistics.exec_max       : 2.417453
[  442.379404]   .se->statistics.slice_max      : 0.015061
[  442.379523]   .se->statistics.wait_max       : 0.104347
[  442.379627]   .se->statistics.wait_sum       : 1.758039
[  442.379731]   .se->statistics.wait_count     : 4709
[  442.379834]   .se->load.weight               : 2
[  442.379935]   .se->avg.runnable_avg_sum      : 17
[  442.380038]   .se->avg.runnable_avg_period   : 47961
[  442.380141]   .se->avg.load_avg_contrib      : 0
[  442.380243]   .se->avg.decay_count           : 421873
[  442.380346] 
[  442.380346] cfs_rq[2]:/autogroup-28
[  442.380500]   .exec_clock                    : 17.883599
[  442.380603]   .MIN_vruntime                  : 0.000001
[  442.380706]   .min_vruntime                  : 16.835023
[  442.380810]   .max_vruntime                  : 0.000001
[  442.380912]   .spread                        : 0.000000
[  442.381015]   .spread0                       : -9928.026107
[  442.381119]   .nr_spread_over                : 0
[  442.381222]   .nr_running                    : 0
[  442.381324]   .load                          : 0
[  442.381426]   .runnable_load_avg             : 0
[  442.381528]   .blocked_load_avg              : 0
[  442.381630]   .tg_load_contrib               : 0
[  442.381732]   .tg_runnable_contrib           : 0
[  442.381835]   .tg_load_avg                   : 0
[  442.381936]   .tg->runnable_avg              : 0
[  442.382039]   .tg->cfs_bandwidth.timer_active: 0
[  442.382140]   .throttled                     : 0
[  442.382242]   .throttle_count                : 0
[  442.382345]   .se->exec_start                : 442311.004309
[  442.382450]   .se->vruntime                  : 2930.662936
[  442.382554]   .se->sum_exec_runtime          : 17.883599
[  442.382657]   .se->statistics.wait_start     : 0.000000
[  442.382760]   .se->statistics.sleep_start    : 0.000000
[  442.382863]   .se->statistics.block_start    : 0.000000
[  442.382967]   .se->statistics.sleep_max      : 0.000000
[  442.383071]   .se->statistics.block_max      : 0.000000
[  442.383175]   .se->statistics.exec_max       : 1.510103
[  442.383278]   .se->statistics.slice_max      : 0.000000
[  442.383381]   .se->statistics.wait_max       : 0.022256
[  442.383484]   .se->statistics.wait_sum       : 0.056724
[  442.383588]   .se->statistics.wait_count     : 216
[  442.383691]   .se->load.weight               : 2
[  442.383792]   .se->avg.runnable_avg_sum      : 28
[  442.383894]   .se->avg.runnable_avg_period   : 46643
[  442.383997]   .se->avg.load_avg_contrib      : 0
[  442.384099]   .se->avg.decay_count           : 421821
[  442.384202] 
[  442.384202] cfs_rq[2]:/
[  442.384356]   .exec_clock                    : 1286.749804
[  442.384460]   .MIN_vruntime                  : 0.000001
[  442.384563]   .min_vruntime                  : 2930.662936
[  442.384666]   .max_vruntime                  : 0.000001
[  442.384770]   .spread                        : 0.000000
[  442.384874]   .spread0                       : -7014.198194
[  442.384977]   .nr_spread_over                : 5
[  442.385079]   .nr_running                    : 0
[  442.385182]   .load                          : 0
[  442.385283]   .runnable_load_avg             : 0
[  442.385385]   .blocked_load_avg              : 0
[  442.385487]   .tg_load_contrib               : 0
[  442.385589]   .tg_runnable_contrib           : 2
[  442.385692]   .tg_load_avg                   : 4
[  442.385793]   .tg->runnable_avg              : 15
[  442.385895]   .tg->cfs_bandwidth.timer_active: 0
[  442.385997]   .throttled                     : 0
[  442.386100]   .throttle_count                : 0
[  442.386202]   .avg->runnable_avg_sum         : 107
[  442.386304]   .avg->runnable_avg_period      : 47792
[  442.386407] 
[  442.386407] rt_rq[2]:/
[  442.386559]   .rt_nr_running                 : 0
[  442.386660]   .rt_throttled                  : 0
[  442.386763]   .rt_time                       : 0.000000
[  442.386867]   .rt_runtime                    : 950.000000
[  442.386972] 
[  442.386972] runnable tasks:
[  442.386972]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.386972] ----------------------------------------------------------------------------------------------------------
[  442.387378]       watchdog/2    16        -5.975999       114     0        -5.975999         1.355055        72.367749 /
[  442.387707]      migration/2    17         0.000000        55     0         0.000000         5.626778         0.000808 /
[  442.388036]      ksoftirqd/2    18      2909.170278       211   120      2909.170278         2.994556    344089.003920 /
[  442.388365]      kworker/2:0    19       844.755664        14   120       844.755664         0.030489     34070.779463 /
[  442.388693]     kworker/2:0H    20       356.125675         6   100       356.125675         0.046098      1284.771571 /
[  442.389024]      kworker/2:1   591      2922.180383      3727   120      2922.180383        41.063105    441594.680493 /
[  442.389355]     kworker/2:1H   880      2855.340623        30   100      2855.340623         0.320676    147866.271845 /
[  442.389685]        md1_raid1   900      1637.880055        29   120      1637.880055         0.701836     35157.770638 /
[  442.391507]             ntpd  3222         8.940448       464   120         8.940448        27.499788    404759.032658 /autogroup-12
[  442.391838]           mysqld  4023       588.529990       816   120       588.529990        10.940580    403005.434973 /autogroup-6
[  442.392169]           mysqld  4026       585.286659       808   120       585.286659        11.844814    403340.591507 /autogroup-6
[  442.392500]           mysqld  4028       588.622413       809   120       588.622413        10.635569    403337.996701 /autogroup-6
[  442.392830]           mysqld  4050       580.800595        81   120       580.800595         1.201381    399985.008906 /autogroup-6
[  442.393159]            anvil  4211         0.149152         6   120         0.149152         1.028354       116.206947 /autogroup-16
[  442.393491]              log  4212         0.404382         6   120         0.404382         1.050234      1064.170662 /autogroup-16
[  442.393822]             qmgr  4288         1.741219        28   120         1.741219         3.370244    300265.911080 /autogroup-18
[  442.394153]            getty  4302         0.600840       111   120         0.600840         1.745011        61.804844 /autogroup-21
[  442.394484]             tmux  4423        16.835023      1985   120        16.835023       152.878474    334675.889548 /autogroup-28
[  442.394815]    btrfs-cache-1  4489      2914.065739       135   120      2914.065739        14.036423    274618.575204 /
[  442.395144]             bash  4493         1.078777       102   120         1.078777        37.488082    209025.250330 /autogroup-30
[  442.395475]    btrfs-cleaner  4679      2795.939502         3   120      2795.939502         0.200852         0.122357 /
[  442.395804] 
[  442.395901] cpu#3, 3411.486 MHz
[  442.396000]   .nr_running                    : 0
[  442.396102]   .load                          : 0
[  442.396204]   .nr_switches                   : 32256
[  442.396306]   .nr_load_updates               : 10284
[  442.396410]   .nr_uninterruptible            : -496
[  442.396513]   .next_balance                  : 4294.981560
[  442.396617]   .curr->pid                     : 0
[  442.396719]   .clock                         : 442389.359621
[  442.396822]   .cpu_load[0]                   : 0
[  442.396924]   .cpu_load[1]                   : 0
[  442.397025]   .cpu_load[2]                   : 0
[  442.397127]   .cpu_load[3]                   : 0
[  442.397228]   .cpu_load[4]                   : 0
[  442.397330]   .yld_count                     : 50
[  442.397433]   .sched_count                   : 32402
[  442.397536]   .sched_goidle                  : 15346
[  442.397639]   .avg_idle                      : 1000000
[  442.397742]   .ttwu_count                    : 12834
[  442.397845]   .ttwu_local                    : 8789
[  442.397948] 
[  442.397948] cfs_rq[3]:/autogroup-6
[  442.398104]   .exec_clock                    : 1044.684548
[  442.398208]   .MIN_vruntime                  : 0.000001
[  442.398310]   .min_vruntime                  : 1048.363630
[  442.398414]   .max_vruntime                  : 0.000001
[  442.398518]   .spread                        : 0.000000
[  442.398622]   .spread0                       : -8896.497500
[  442.398725]   .nr_spread_over                : 65
[  442.398827]   .nr_running                    : 0
[  442.398929]   .load                          : 0
[  442.399031]   .runnable_load_avg             : 0
[  442.399133]   .blocked_load_avg              : 0
[  442.399235]   .tg_load_contrib               : 0
[  442.399337]   .tg_runnable_contrib           : 0
[  442.399452]   .tg_load_avg                   : 0
[  442.399555]   .tg->runnable_avg              : 2
[  442.399657]   .tg->cfs_bandwidth.timer_active: 0
[  442.399760]   .throttled                     : 0
[  442.399861]   .throttle_count                : 0
[  442.399964]   .se->exec_start                : 442365.470865
[  442.400067]   .se->vruntime                  : 4527.780959
[  442.400171]   .se->sum_exec_runtime          : 1044.684548
[  442.400275]   .se->statistics.wait_start     : 0.000000
[  442.400378]   .se->statistics.sleep_start    : 0.000000
[  442.400481]   .se->statistics.block_start    : 0.000000
[  442.400584]   .se->statistics.sleep_max      : 0.000000
[  442.400687]   .se->statistics.block_max      : 0.000000
[  442.400791]   .se->statistics.exec_max       : 9.994245
[  442.400894]   .se->statistics.slice_max      : 0.015489
[  442.400998]   .se->statistics.wait_max       : 0.112907
[  442.401101]   .se->statistics.wait_sum       : 1.549505
[  442.401205]   .se->statistics.wait_count     : 2365
[  442.401307]   .se->load.weight               : 2
[  442.401410]   .se->avg.runnable_avg_sum      : 5
[  442.401511]   .se->avg.runnable_avg_period   : 46249
[  442.401614]   .se->avg.load_avg_contrib      : 0
[  442.401716]   .se->avg.decay_count           : 421873
[  442.401819] 
[  442.401819] cfs_rq[3]:/
[  442.401972]   .exec_clock                    : 1864.927134
[  442.402075]   .MIN_vruntime                  : 0.000001
[  442.402178]   .min_vruntime                  : 4529.306663
[  442.402282]   .max_vruntime                  : 0.000001
[  442.402386]   .spread                        : 0.000000
[  442.402489]   .spread0                       : -5415.661005
[  442.402592]   .nr_spread_over                : 8
[  442.402695]   .nr_running                    : 0
[  442.402797]   .load                          : 0
[  442.402899]   .runnable_load_avg             : 0
[  442.403001]   .blocked_load_avg              : 0
[  442.403103]   .tg_load_contrib               : 0
[  442.403206]   .tg_runnable_contrib           : 2
[  442.403308]   .tg_load_avg                   : 8
[  442.403410]   .tg->runnable_avg              : 14
[  442.403511]   .tg->cfs_bandwidth.timer_active: 0
[  442.403613]   .throttled                     : 0
[  442.403716]   .throttle_count                : 0
[  442.403818]   .avg->runnable_avg_sum         : 120
[  442.403920]   .avg->runnable_avg_period      : 46697
[  442.404024] 
[  442.404024] rt_rq[3]:/
[  442.404177]   .rt_nr_running                 : 0
[  442.404278]   .rt_throttled                  : 0
[  442.404380]   .rt_time                       : 0.000000
[  442.404484]   .rt_runtime                    : 950.000000
[  442.404587] 
[  442.404587] runnable tasks:
[  442.404587]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.404587] ----------------------------------------------------------------------------------------------------------
[  442.404990]             init     1         0.224680       961   120         0.224680       513.148123    440106.934569 /autogroup-2
[  442.405322]       watchdog/3    21        -5.983216       114     0        -5.983216         1.202804        59.050855 /
[  442.405649]      migration/3    22         0.000000        38     0         0.000000         5.548407         0.000826 /
[  442.405978]      ksoftirqd/3    23      4509.315859       174   120      4509.315859         2.372825    344266.315958 /
[  442.406307]      kworker/3:0    24       892.732418        14   120       892.732418         0.038906     34057.207679 /
[  442.406635]     kworker/3:0H    25       816.234012         6   100       816.234012         0.026753     33340.454999 /
[  442.406966]       khungtaskd   482      4517.782282         5   120      4517.782282         7.084177    359803.162597 /
[  442.407295]      kworker/3:1   593      4517.316835      5510   120      4517.316835        65.055740    441595.938635 /
[  442.407624]     kworker/3:1H  1276      4264.632251        20   100      4264.632251         0.241366     85294.834423 /
[  442.407953]         rsyslogd  3026      1025.592392        16   120      1025.592392         1.437104    323803.262530 /autogroup-6
[  442.408285]            nginx  3193         9.535098       811   120         9.535098        14.637308    405204.174095 /autogroup-11
[  442.408616]           mysqld  4008      1016.506348       867   120      1016.506348       458.157069     81608.046707 /autogroup-6
[  442.408947]           mysqld  4031      1036.378910       808   120      1036.378910        11.855400    403340.264930 /autogroup-6
[  442.409278]           mysqld  4047      1048.363630       407   120      1048.363630        61.940396    401218.233637 /autogroup-6
[  442.409609]           mysqld  4049      1036.085686        81   120      1036.085686         1.474302    400195.430799 /autogroup-6
[  442.409940]           mysqld  4052      1014.859507       237   120      1014.859507        20.513955    129497.328142 /autogroup-6
[  442.410272]           master  4274         3.133218        25   120         3.133218         6.292730    360247.346775 /autogroup-18
[  442.410604]            getty  4305         0.540277       109   120         0.540277         1.685413        61.753648 /autogroup-24
[  442.410935]            mount  4469       217.192752      6526   120       217.192752       495.247509     34975.660230 /autogroup-29
[  442.411267]   btrfs-worker-1  4476      4510.314174         5   120      4510.314174         0.103229    239871.731614 /
[  442.411597]  btrfs-endio-met  4684      4513.105868        33   120      4513.105868         1.432365    240570.439858 /
[  442.411927] 
[  442.412023] cpu#4, 3411.486 MHz
[  442.412122]   .nr_running                    : 0
[  442.412224]   .load                          : 0
[  442.412327]   .nr_switches                   : 6803
[  442.412429]   .nr_load_updates               : 1787
[  442.412531]   .nr_uninterruptible            : 518
[  442.412634]   .next_balance                  : 4294.981319
[  442.412737]   .curr->pid                     : 0
[  442.412840]   .clock                         : 442365.452320
[  442.412944]   .cpu_load[0]                   : 0
[  442.413046]   .cpu_load[1]                   : 0
[  442.413148]   .cpu_load[2]                   : 0
[  442.413250]   .cpu_load[3]                   : 0
[  442.413351]   .cpu_load[4]                   : 0
[  442.413453]   .yld_count                     : 0
[  442.413555]   .sched_count                   : 6945
[  442.413658]   .sched_goidle                  : 3094
[  442.415261]   .avg_idle                      : 1000000
[  442.415365]   .ttwu_count                    : 2957
[  442.415467]   .ttwu_local                    : 1904
[  442.415570] 
[  442.415570] cfs_rq[4]:/autogroup-6
[  442.415724]   .exec_clock                    : 88.195352
[  442.415828]   .MIN_vruntime                  : 0.000001
[  442.415932]   .min_vruntime                  : 3926.498079
[  442.416035]   .max_vruntime                  : 0.000001
[  442.416139]   .spread                        : 0.000000
[  442.416242]   .spread0                       : -6018.469589
[  442.416347]   .nr_spread_over                : 159
[  442.416449]   .nr_running                    : 0
[  442.416551]   .load                          : 0
[  442.416652]   .runnable_load_avg             : 0
[  442.416754]   .blocked_load_avg              : 0
[  442.416857]   .tg_load_contrib               : 0
[  442.416960]   .tg_runnable_contrib           : 0
[  442.417062]   .tg_load_avg                   : 0
[  442.417163]   .tg->runnable_avg              : 1
[  442.417265]   .tg->cfs_bandwidth.timer_active: 0
[  442.417368]   .throttled                     : 0
[  442.417470]   .throttle_count                : 0
[  442.417572]   .se->exec_start                : 442365.450096
[  442.417676]   .se->vruntime                  : 1643.779582
[  442.417780]   .se->sum_exec_runtime          : 88.195352
[  442.417884]   .se->statistics.wait_start     : 0.000000
[  442.417987]   .se->statistics.sleep_start    : 0.000000
[  442.418090]   .se->statistics.block_start    : 0.000000
[  442.418194]   .se->statistics.sleep_max      : 0.000000
[  442.418297]   .se->statistics.block_max      : 0.000000
[  442.418400]   .se->statistics.exec_max       : 1.445210
[  442.418503]   .se->statistics.slice_max      : 0.000000
[  442.418606]   .se->statistics.wait_max       : 0.065583
[  442.418709]   .se->statistics.wait_sum       : 0.194520
[  442.418812]   .se->statistics.wait_count     : 1256
[  442.418915]   .se->load.weight               : 2
[  442.419016]   .se->avg.runnable_avg_sum      : 15
[  442.419119]   .se->avg.runnable_avg_period   : 48646
[  442.419221]   .se->avg.load_avg_contrib      : 0
[  442.419323]   .se->avg.decay_count           : 421873
[  442.419439] 
[  442.419439] cfs_rq[4]:/
[  442.419592]   .exec_clock                    : 219.636837
[  442.419696]   .MIN_vruntime                  : 0.000001
[  442.419800]   .min_vruntime                  : 1646.629753
[  442.419903]   .max_vruntime                  : 0.000001
[  442.420006]   .spread                        : 0.000000
[  442.420110]   .spread0                       : -8298.449587
[  442.420214]   .nr_spread_over                : 7
[  442.420316]   .nr_running                    : 0
[  442.420417]   .load                          : 0
[  442.420519]   .runnable_load_avg             : 0
[  442.420621]   .blocked_load_avg              : 0
[  442.420723]   .tg_load_contrib               : 0
[  442.420824]   .tg_runnable_contrib           : 0
[  442.420926]   .tg_load_avg                   : 6
[  442.421027]   .tg->runnable_avg              : 12
[  442.421130]   .tg->cfs_bandwidth.timer_active: 0
[  442.421232]   .throttled                     : 0
[  442.421334]   .throttle_count                : 0
[  442.421436]   .avg->runnable_avg_sum         : 15
[  442.421539]   .avg->runnable_avg_period      : 48084
[  442.421642] 
[  442.421642] rt_rq[4]:/
[  442.421796]   .rt_nr_running                 : 0
[  442.421898]   .rt_throttled                  : 0
[  442.422000]   .rt_time                       : 0.000000
[  442.422104]   .rt_runtime                    : 950.000000
[  442.422208] 
[  442.422208] runnable tasks:
[  442.422208]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.422208] ----------------------------------------------------------------------------------------------------------
[  442.422613]       watchdog/4    26        -8.977227       114     0        -8.977227         1.407421        45.715910 /
[  442.422941]      migration/4    27         0.000000       534     0         0.000000         7.892668         0.000800 /
[  442.423269]      ksoftirqd/4    28      1634.639030        34   120      1634.639030         0.399234    301078.201192 /
[  442.423599]      kworker/4:0    29        11.099434        13   120        11.099434         0.035937       553.787808 /
[  442.423927]     kworker/4:0H    30       636.666622         6   100       636.666622         0.054768      2808.593904 /
[  442.424258]      kworker/4:1   595      1636.091646       409   120      1636.091646         4.523121    439247.259259 /
[  442.424589]           bioset   891       531.533240         2   100       531.533240         0.050708         0.027751 /
[  442.424918]           bioset   899       563.633977         2   100       563.633977         0.037556         0.017608 /
[  442.425247]           bioset   907       599.923653         2   100       599.923653         0.041427         0.036999 /
[  442.425577]     kworker/4:1H  1001      1378.730082        10   100      1378.730082         0.145252     41358.051444 /
[  442.425906]         rsyslogd  3025      3480.977057        29   120      3480.977057         1.328252     15467.321960 /autogroup-6
[  442.426237]            mdadm  3101         0.269176         1   120         0.269176         0.841264         0.000000 /autogroup-8
[  442.426569]              atd  3136         0.954776         2   120         0.954776         0.143712         0.285125 /autogroup-9
[  442.426899]           mysqld  4024      3924.483419       808   120      3924.483419        12.204679    403340.533797 /autogroup-6
[  442.427232]           bioset  4473      1429.506934         2   100      1429.506934         0.006509         0.002747 /
[  442.427560]    btrfs-endio-1  4481      1634.643810         6   120      1634.643810         0.061059    239871.284049 /
[  442.427888]      btrfs-rmw-1  4483      1634.635497         6   120      1634.635497         0.014114    239871.181403 /
[  442.428217]  btrfs-endio-rai  4484      1634.635307         6   120      1634.635307         0.012364    239871.162940 /
[  442.428546]  btrfs-endio-met  4485      1634.636449         6   120      1634.636449         0.013526    239871.147901 /
[  442.428874]  btrfs-endio-wri  4486      1634.635915         6   120      1634.635915         0.013623    239871.120772 /
[  442.429203]  btrfs-freespace  4487      1634.636106         6   120      1634.636106         0.014809    239871.054138 /
[  442.429535]  btrfs-delayed-m  4488      1634.635624         6   120      1634.635624         0.013350    239871.005792 /
[  442.429863]  btrfs-readahead  4490      1634.636001         6   120      1634.636001         0.013185    239870.915119 /
[  442.430191]  btrfs-flush_del  4491      1634.635878         6   120      1634.635878         0.013309    239870.867378 /
[  442.430520]  btrfs-qgroup-re  4492      1634.643347         5   120      1634.643347         0.021430    239870.850039 /
[  442.430848] 
[  442.430944] cpu#5, 3411.486 MHz
[  442.431043]   .nr_running                    : 0
[  442.431146]   .load                          : 0
[  442.431248]   .nr_switches                   : 7645
[  442.431350]   .nr_load_updates               : 2102
[  442.431453]   .nr_uninterruptible            : 775
[  442.431556]   .next_balance                  : 4294.981369
[  442.431659]   .curr->pid                     : 0
[  442.431762]   .clock                         : 442365.450422
[  442.431866]   .cpu_load[0]                   : 0
[  442.431968]   .cpu_load[1]                   : 0
[  442.432071]   .cpu_load[2]                   : 0
[  442.432172]   .cpu_load[3]                   : 0
[  442.432274]   .cpu_load[4]                   : 0
[  442.432376]   .yld_count                     : 1
[  442.432478]   .sched_count                   : 7765
[  442.432580]   .sched_goidle                  : 3383
[  442.432682]   .avg_idle                      : 1000000
[  442.432785]   .ttwu_count                    : 3795
[  442.432887]   .ttwu_local                    : 2451
[  442.432990] 
[  442.432990] cfs_rq[5]:/autogroup-6
[  442.433144]   .exec_clock                    : 136.183864
[  442.433247]   .MIN_vruntime                  : 0.000001
[  442.433351]   .min_vruntime                  : 4828.707667
[  442.433454]   .max_vruntime                  : 0.000001
[  442.433558]   .spread                        : 0.000000
[  442.433661]   .spread0                       : -5116.371673
[  442.433764]   .nr_spread_over                : 88
[  442.433866]   .nr_running                    : 0
[  442.433968]   .load                          : 0
[  442.434070]   .runnable_load_avg             : 0
[  442.434172]   .blocked_load_avg              : 0
[  442.434274]   .tg_load_contrib               : 0
[  442.434377]   .tg_runnable_contrib           : 0
[  442.434479]   .tg_load_avg                   : 0
[  442.434581]   .tg->runnable_avg              : 1
[  442.434682]   .tg->cfs_bandwidth.timer_active: 0
[  442.434784]   .throttled                     : 0
[  442.434887]   .throttle_count                : 0
[  442.434988]   .se->exec_start                : 442365.448483
[  442.435093]   .se->vruntime                  : 1125.533446
[  442.435197]   .se->sum_exec_runtime          : 136.183864
[  442.435301]   .se->statistics.wait_start     : 0.000000
[  442.435405]   .se->statistics.sleep_start    : 0.000000
[  442.435508]   .se->statistics.block_start    : 0.000000
[  442.435612]   .se->statistics.sleep_max      : 0.000000
[  442.435715]   .se->statistics.block_max      : 0.000000
[  442.435820]   .se->statistics.exec_max       : 9.986728
[  442.435923]   .se->statistics.slice_max      : 0.000000
[  442.436026]   .se->statistics.wait_max       : 0.033855
[  442.436130]   .se->statistics.wait_sum       : 0.257970
[  442.436234]   .se->statistics.wait_count     : 1474
[  442.436336]   .se->load.weight               : 2
[  442.437935]   .se->avg.runnable_avg_sum      : 13
[  442.438038]   .se->avg.runnable_avg_period   : 48411
[  442.438141]   .se->avg.load_avg_contrib      : 0
[  442.438243]   .se->avg.decay_count           : 421873
[  442.438346] 
[  442.438346] cfs_rq[5]:/
[  442.438499]   .exec_clock                    : 264.365610
[  442.438603]   .MIN_vruntime                  : 0.000001
[  442.438706]   .min_vruntime                  : 1128.410826
[  442.438810]   .max_vruntime                  : 0.000001
[  442.438913]   .spread                        : 0.000000
[  442.439016]   .spread0                       : -8816.668514
[  442.439121]   .nr_spread_over                : 2
[  442.439222]   .nr_running                    : 0
[  442.439325]   .load                          : 0
[  442.439438]   .runnable_load_avg             : 0
[  442.439540]   .blocked_load_avg              : 0
[  442.439642]   .tg_load_contrib               : 0
[  442.439744]   .tg_runnable_contrib           : 0
[  442.439846]   .tg_load_avg                   : 6
[  442.439948]   .tg->runnable_avg              : 12
[  442.440050]   .tg->cfs_bandwidth.timer_active: 0
[  442.440152]   .throttled                     : 0
[  442.440254]   .throttle_count                : 0
[  442.440357]   .avg->runnable_avg_sum         : 13
[  442.440459]   .avg->runnable_avg_period      : 48288
[  442.440562] 
[  442.440562] rt_rq[5]:/
[  442.440715]   .rt_nr_running                 : 0
[  442.440817]   .rt_throttled                  : 0
[  442.440918]   .rt_time                       : 0.000000
[  442.441022]   .rt_runtime                    : 950.000000
[  442.441126] 
[  442.441126] runnable tasks:
[  442.441126]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.441126] ----------------------------------------------------------------------------------------------------------
[  442.441532]       watchdog/5    31        -8.984532       114     0        -8.984532         1.456254        32.394764 /
[  442.441859]      migration/5    32         0.000000       791     0         0.000000         9.046774         0.000891 /
[  442.442187]      ksoftirqd/5    33      1116.421318        42   120      1116.421318         0.373424    440091.578934 /
[  442.442516]      kworker/5:0    34        35.093325        13   120        35.093325         0.030320       540.690549 /
[  442.442845]     kworker/5:0H    35       786.861732         6   100       786.861732         0.027966     36536.941769 /
[  442.443175]      kworker/5:1   597      1117.539428       611   120      1117.539428         6.369344    439744.435645 /
[  442.443506]         rsyslogd  2993       460.368547        14   120       460.368547         2.476828       173.617609 /autogroup-6
[  442.443836]     kworker/5:1H  3039       831.850576         5   100       831.850576         0.113352       689.516336 /
[  442.444165]            nginx  3190         0.692395         1   120         0.692395         0.435221         0.000000 /autogroup-11
[  442.444497]           mysqld  4022      4826.939530       809   120      4826.939530        12.700739    403340.413374 /autogroup-6
[  442.444828]            getty  4301         0.685356       108   120         0.685356         1.944498        61.892219 /autogroup-20
[  442.445159]            udevd  4474       264.416172         1   120       264.416172         0.159301         0.000000 /autogroup-4
[  442.445491]  btrfs-transacti  4680      1116.182456         3   120      1116.182456         0.043403     29977.514675 /
[  442.445820] 
[  442.445917] cpu#6, 3411.486 MHz
[  442.446016]   .nr_running                    : 0
[  442.446117]   .load                          : 0
[  442.446220]   .nr_switches                   : 12232
[  442.446322]   .nr_load_updates               : 3551
[  442.446426]   .nr_uninterruptible            : 562
[  442.446529]   .next_balance                  : 4294.981423
[  442.446632]   .curr->pid                     : 0
[  442.446734]   .clock                         : 442365.470347
[  442.446838]   .cpu_load[0]                   : 0
[  442.446939]   .cpu_load[1]                   : 0
[  442.447041]   .cpu_load[2]                   : 0
[  442.447143]   .cpu_load[3]                   : 0
[  442.447245]   .cpu_load[4]                   : 0
[  442.447346]   .yld_count                     : 1
[  442.447448]   .sched_count                   : 12342
[  442.447551]   .sched_goidle                  : 5688
[  442.447653]   .avg_idle                      : 1000000
[  442.447756]   .ttwu_count                    : 5917
[  442.447858]   .ttwu_local                    : 3916
[  442.447960] 
[  442.447960] cfs_rq[6]:/autogroup-6
[  442.448114]   .exec_clock                    : 135.681684
[  442.448218]   .MIN_vruntime                  : 0.000001
[  442.448321]   .min_vruntime                  : 3581.900533
[  442.448425]   .max_vruntime                  : 0.000001
[  442.448528]   .spread                        : 0.000000
[  442.448631]   .spread0                       : -6363.285095
[  442.448735]   .nr_spread_over                : 125
[  442.448836]   .nr_running                    : 0
[  442.448939]   .load                          : 0
[  442.449041]   .runnable_load_avg             : 0
[  442.449143]   .blocked_load_avg              : 0
[  442.449244]   .tg_load_contrib               : 0
[  442.449348]   .tg_runnable_contrib           : 0
[  442.449450]   .tg_load_avg                   : 0
[  442.449552]   .tg->runnable_avg              : 0
[  442.449655]   .tg->cfs_bandwidth.timer_active: 0
[  442.449757]   .throttled                     : 0
[  442.449858]   .throttle_count                : 0
[  442.449960]   .se->exec_start                : 442365.468019
[  442.450065]   .se->vruntime                  : 9033.807752
[  442.450168]   .se->sum_exec_runtime          : 135.681684
[  442.450272]   .se->statistics.wait_start     : 0.000000
[  442.450375]   .se->statistics.sleep_start    : 0.000000
[  442.450479]   .se->statistics.block_start    : 0.000000
[  442.450582]   .se->statistics.sleep_max      : 0.000000
[  442.450685]   .se->statistics.block_max      : 0.000000
[  442.450788]   .se->statistics.exec_max       : 1.924687
[  442.450892]   .se->statistics.slice_max      : 0.000000
[  442.450996]   .se->statistics.wait_max       : 0.057361
[  442.451098]   .se->statistics.wait_sum       : 1.004778
[  442.451202]   .se->statistics.wait_count     : 1948
[  442.451305]   .se->load.weight               : 2
[  442.451406]   .se->avg.runnable_avg_sum      : 13
[  442.451509]   .se->avg.runnable_avg_period   : 46919
[  442.451611]   .se->avg.load_avg_contrib      : 0
[  442.451713]   .se->avg.decay_count           : 421873
[  442.451817] 
[  442.451817] cfs_rq[6]:/autogroup-11
[  442.451972]   .exec_clock                    : 15.359290
[  442.452076]   .MIN_vruntime                  : 0.000001
[  442.452179]   .min_vruntime                  : 25.073202
[  442.452282]   .max_vruntime                  : 0.000001
[  442.452386]   .spread                        : 0.000000
[  442.452489]   .spread0                       : -9920.112426
[  442.452593]   .nr_spread_over                : 0
[  442.452695]   .nr_running                    : 0
[  442.452796]   .load                          : 0
[  442.452898]   .runnable_load_avg             : 0
[  442.452999]   .blocked_load_avg              : 0
[  442.453101]   .tg_load_contrib               : 0
[  442.453203]   .tg_runnable_contrib           : 0
[  442.453306]   .tg_load_avg                   : 11
[  442.453408]   .tg->runnable_avg              : 0
[  442.453510]   .tg->cfs_bandwidth.timer_active: 0
[  442.453612]   .throttled                     : 0
[  442.453713]   .throttle_count                : 0
[  442.453815]   .se->exec_start                : 442305.525383
[  442.453919]   .se->vruntime                  : 9021.807106
[  442.454022]   .se->sum_exec_runtime          : 15.359290
[  442.454126]   .se->statistics.wait_start     : 0.000000
[  442.454229]   .se->statistics.sleep_start    : 0.000000
[  442.454332]   .se->statistics.block_start    : 0.000000
[  442.454434]   .se->statistics.sleep_max      : 0.000000
[  442.454538]   .se->statistics.block_max      : 0.000000
[  442.454641]   .se->statistics.exec_max       : 0.339242
[  442.454745]   .se->statistics.slice_max      : 0.009873
[  442.454849]   .se->statistics.wait_max       : 0.002005
[  442.454952]   .se->statistics.wait_sum       : 0.002005
[  442.455056]   .se->statistics.wait_count     : 826
[  442.455158]   .se->load.weight               : 2
[  442.455261]   .se->avg.runnable_avg_sum      : 1
[  442.455363]   .se->avg.runnable_avg_period   : 47720
[  442.455466]   .se->avg.load_avg_contrib      : 0
[  442.455567]   .se->avg.decay_count           : 421816
[  442.455670] 
[  442.455670] cfs_rq[6]:/
[  442.455822]   .exec_clock                    : 308.223493
[  442.455925]   .MIN_vruntime                  : 0.000001
[  442.456029]   .min_vruntime                  : 9033.807752
[  442.456133]   .max_vruntime                  : 0.000001
[  442.456236]   .spread                        : 0.000000
[  442.456340]   .spread0                       : -911.377876
[  442.456443]   .nr_spread_over                : 646
[  442.456546]   .nr_running                    : 0
[  442.456648]   .load                          : 0
[  442.456750]   .runnable_load_avg             : 0
[  442.456852]   .blocked_load_avg              : 0
[  442.456954]   .tg_load_contrib               : 0
[  442.457056]   .tg_runnable_contrib           : 0
[  442.457158]   .tg_load_avg                   : 7
[  442.457260]   .tg->runnable_avg              : 11
[  442.457362]   .tg->cfs_bandwidth.timer_active: 0
[  442.457464]   .throttled                     : 0
[  442.459064]   .throttle_count                : 0
[  442.459166]   .avg->runnable_avg_sum         : 14
[  442.459268]   .avg->runnable_avg_period      : 47717
[  442.459373] 
[  442.459373] rt_rq[6]:/
[  442.459525]   .rt_nr_running                 : 0
[  442.459627]   .rt_throttled                  : 0
[  442.459729]   .rt_time                       : 0.000000
[  442.459833]   .rt_runtime                    : 950.000000
[  442.459937] 
[  442.459937] runnable tasks:
[  442.459937]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.459937] ----------------------------------------------------------------------------------------------------------
[  442.460341]         kthreadd     2      9004.629168       133   120      9004.629168         2.459339    149562.611708 /
[  442.460670]       watchdog/6    36        -8.979708       114     0        -8.979708         1.419955        19.064518 /
[  442.460999]      migration/6    37         0.000000       583     0         0.000000         7.676005         0.000798 /
[  442.461327]      ksoftirqd/6    38      9021.787457        60   120      9021.787457         1.056975    440747.209845 /
[  442.461655]      kworker/6:0    39      6290.796774        13   120      6290.796774         0.029128       527.622768 /
[  442.461983]     kworker/6:0H    40      8681.586920         6   100      8681.586920         0.058235     34644.619169 /
[  442.462313]      kworker/6:1   599      9021.926574      1003   120      9021.926574        11.641626    440278.129570 /
[  442.462641]    irq/44-mei_me   656         0.000000        14    49         0.000000         0.619723         0.000000 /
[  442.462972]  ext4-rsv-conver   924      8240.946018         2   100      8240.946018         0.031035         0.023098 /
[  442.463302]     kworker/6:1H  2121      8779.635829         4   100      8779.635829         0.026744      2201.095775 /
[  442.463631]            nginx  3191        11.366022         1   120        11.366022         0.414607         0.000000 /autogroup-11
[  442.463962]            nginx  3192        25.073202       811   120        25.073202        14.078193    405205.240817 /autogroup-11
[  442.464292]           mysqld  4025      3574.295754       808   120      3574.295754        11.740556    403340.542940 /autogroup-6
[  442.464624]          dovecot  4159        22.944448        18   120        22.944448         1.777530      1336.638285 /autogroup-16
[  442.464955]            getty  4304         0.971652       109   120         0.971652         2.023715        61.258946 /autogroup-23
[  442.465286]   btrfs-submit-1  4478      9019.125219         4   120      9019.125219         0.066240    239871.556343 /
[  442.465615] 
[  442.465711] cpu#7, 3411.486 MHz
[  442.465810]   .nr_running                    : 0
[  442.465913]   .load                          : 0
[  442.466014]   .nr_switches                   : 13958
[  442.466117]   .nr_load_updates               : 3860
[  442.466220]   .nr_uninterruptible            : 604
[  442.466323]   .next_balance                  : 4294.981469
[  442.466427]   .curr->pid                     : 0
[  442.466529]   .clock                         : 442365.472874
[  442.466633]   .cpu_load[0]                   : 0
[  442.466735]   .cpu_load[1]                   : 0
[  442.466837]   .cpu_load[2]                   : 0
[  442.466938]   .cpu_load[3]                   : 0
[  442.467040]   .cpu_load[4]                   : 0
[  442.467142]   .yld_count                     : 0
[  442.467244]   .sched_count                   : 14074
[  442.467346]   .sched_goidle                  : 6630
[  442.467449]   .avg_idle                      : 1000000
[  442.467552]   .ttwu_count                    : 4187
[  442.467654]   .ttwu_local                    : 2674
[  442.467757] 
[  442.467757] cfs_rq[7]:/autogroup-6
[  442.467912]   .exec_clock                    : 235.824574
[  442.468016]   .MIN_vruntime                  : 0.000001
[  442.468119]   .min_vruntime                  : 5537.389504
[  442.468222]   .max_vruntime                  : 0.000001
[  442.468325]   .spread                        : 0.000000
[  442.468429]   .spread0                       : -4407.796124
[  442.468533]   .nr_spread_over                : 213
[  442.468635]   .nr_running                    : 0
[  442.468737]   .load                          : 0
[  442.468839]   .runnable_load_avg             : 0
[  442.468941]   .blocked_load_avg              : 0
[  442.469043]   .tg_load_contrib               : 0
[  442.469145]   .tg_runnable_contrib           : 0
[  442.469247]   .tg_load_avg                   : 0
[  442.469351]   .tg->runnable_avg              : 0
[  442.469466]   .tg->cfs_bandwidth.timer_active: 0
[  442.469568]   .throttled                     : 0
[  442.469670]   .throttle_count                : 0
[  442.469772]   .se->exec_start                : 442365.470857
[  442.469876]   .se->vruntime                  : 2130.271480
[  442.469980]   .se->sum_exec_runtime          : 235.824574
[  442.470083]   .se->statistics.wait_start     : 0.000000
[  442.470186]   .se->statistics.sleep_start    : 0.000000
[  442.470289]   .se->statistics.block_start    : 0.000000
[  442.470392]   .se->statistics.sleep_max      : 0.000000
[  442.470496]   .se->statistics.block_max      : 0.000000
[  442.470598]   .se->statistics.exec_max       : 0.773748
[  442.470702]   .se->statistics.slice_max      : 0.000000
[  442.470805]   .se->statistics.wait_max       : 0.030005
[  442.470909]   .se->statistics.wait_sum       : 0.323873
[  442.471012]   .se->statistics.wait_count     : 2061
[  442.471115]   .se->load.weight               : 2
[  442.471218]   .se->avg.runnable_avg_sum      : 33
[  442.471319]   .se->avg.runnable_avg_period   : 47528
[  442.471422]   .se->avg.load_avg_contrib      : 0
[  442.471524]   .se->avg.decay_count           : 421873
[  442.471627] 
[  442.471627] cfs_rq[7]:/
[  442.471780]   .exec_clock                    : 906.945228
[  442.471883]   .MIN_vruntime                  : 0.000001
[  442.471986]   .min_vruntime                  : 2130.271480
[  442.472090]   .max_vruntime                  : 0.000001
[  442.472193]   .spread                        : 0.000000
[  442.472297]   .spread0                       : -7815.020936
[  442.472400]   .nr_spread_over                : 11
[  442.472503]   .nr_running                    : 0
[  442.472604]   .load                          : 0
[  442.472706]   .runnable_load_avg             : 0
[  442.472807]   .blocked_load_avg              : 0
[  442.472909]   .tg_load_contrib               : 0
[  442.473011]   .tg_runnable_contrib           : 0
[  442.473113]   .tg_load_avg                   : 6
[  442.473215]   .tg->runnable_avg              : 10
[  442.473317]   .tg->cfs_bandwidth.timer_active: 0
[  442.473419]   .throttled                     : 0
[  442.473521]   .throttle_count                : 0
[  442.473623]   .avg->runnable_avg_sum         : 33
[  442.473725]   .avg->runnable_avg_period      : 47552
[  442.473828] 
[  442.473828] rt_rq[7]:/
[  442.473980]   .rt_nr_running                 : 0
[  442.474083]   .rt_throttled                  : 0
[  442.474185]   .rt_time                       : 0.000000
[  442.474289]   .rt_runtime                    : 950.000000
[  442.474393]
[  442.474393] runnable tasks:
[  442.474393]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  442.474393] ----------------------------------------------------------------------------------------------------------
[  442.474799]       watchdog/7    41        -8.980665       114     0        -8.980665         1.327735         5.747945 /
[  442.475127]      migration/7    42         0.000000       619     0         0.000000         7.851498         0.000808 /
[  442.475456]      ksoftirqd/7    43      2069.587300        43   120      2069.587300         0.746714    301037.486356 /
[  442.475784]      kworker/7:0    44       206.657650        12   120       206.657650       114.455462       112.014440 /
[  442.476112]     kworker/7:0H    45      1420.076915         6   100      1420.076915         0.022407     34313.173210 /
[  442.476440]          khelper    46        10.955792         2   100        10.955792         0.004906         0.002354 /
[  442.476769]            netns    47        22.959000         2   100        22.959000         0.003532         0.001919 /
[  442.477096]        writeback   196        46.965406         2   100        46.965406         0.003584         0.001369 /
[  442.477423]           bioset   198        58.968447         2   100        58.968447         0.003349         0.001513 /
[  442.477752]          kblockd   199        70.971483         2   100        70.971483         0.003351         0.001372 /
[  442.478081]               md   346        94.978435         2   100        94.978435         0.003471         0.001431 /
[  442.478410]      kworker/7:1   447      2117.921864       628   120      2117.921864         8.406463    441029.676636 /
[  442.478738]          kswapd0   492       586.012693         3   120       586.012693         0.018964        93.205724 /
[  442.479068]           crypto   565       501.932788         2   100       501.932788         0.006100         0.003441 /
[  442.479398]        kpsmoused   672       610.094848         2   100       610.094848         0.094154         0.030677 /
[  442.479728]          deferwq   717       634.179797         2   100       634.179797         0.034165         0.003368 /
[  442.480058]          ata_sff   839       819.025334         2   100       819.025334         0.017476         0.005194 /
[  442.480387]       scsi_tmf_0   842       843.078836         2   100       843.078836         0.024724         0.003422 /
[  442.480715]       scsi_tmf_1   844       867.114334         2   100       867.114334         0.009475         0.005052 /
[  442.481044]       scsi_tmf_2   846       891.129761         2   100       891.129761         0.008669         0.004939 /
[  442.482873]       scsi_tmf_3   848       915.166073         2   100       915.166073         0.010415         0.003941 /
[  442.483201]        scsi_eh_4   849       975.323872         3   120       975.323872         0.034251         1.170933 /
[  442.483530]       scsi_tmf_4   850       939.222591         2   100       939.222591         0.031535         0.004287 /
[  442.483858]        scsi_eh_5   851       975.326229         3   120       975.326229         0.035801         0.973535 /
[  442.484186]       scsi_tmf_5   852       963.283758         2   100       963.283758         0.032461         0.003257 /
[  442.484514]        md0_raid1   892      1638.637146        29   120      1638.637146         0.585038     35377.924283 /
[  442.484844]            udevd  1111       405.605404       262   120       405.605404        42.578740     85268.067369 /autogroup-4
[  442.485174]     kworker/7:1H  1537      1667.977458         4   100      1667.977458         0.030612      3127.813179 /
[  442.485503]        kjournald  2212      1548.457495         2   120      1548.457495         0.354049         0.040124 /
[  442.485833]           mysqld  4029      5525.404781       808   120      5525.404781        12.467328    403340.541563 /autogroup-6
[  442.486163]           mysqld  4048      5537.389504       416   120      5537.389504       134.349184    401216.810737 /autogroup-6
[  442.486493]           mysqld  4077      4399.635961         2   120      4399.635961         0.159445       415.716870 /autogroup-6
[  442.486825]            getty  4300         2.870085       105   120         2.870085         4.228305        59.767820 /autogroup-19
[  442.487157]  btrfs-delalloc-  4479      2088.040334         4   120      2088.040334         0.080839    239871.453410 /
[  442.487487]


-- 
Tomasz Chmielewski
http://wpkg.org
