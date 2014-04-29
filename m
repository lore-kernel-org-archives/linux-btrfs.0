Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55589 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933575AbaD2Kca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 06:32:30 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id D527E423F2A
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 12:32:27 +0200 (CEST)
Received: from s9 (127.253.37.188.rev.vodafone.pt [188.37.253.127])
	by mail.virtall.com (Postfix) with ESMTPSA id 37444423E55
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 12:32:27 +0200 (CEST)
Date: Tue, 29 Apr 2014 11:32:24 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem hang with 3.15-rc3 when doing rsync
Message-ID: <20140429113224.56f12b49@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just had 3.15-rc3 filesystem hanging when doing rsync.

There is no IO activity, about 80 MB in dirty buffers which won't sync, and system won't
reboot.


[87267.762556] SysRq : Show Blocked State
[87267.762634]   task                        PC stack   pid father
[87267.762707] kworker/u16:13  D ffff88081fad16c0     0 20309      2 0x00000000
[87267.762777] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[87267.762841]  ffff88070cca5968 0000000000000046 ffff88070cca5888 ffff8800b2c09830
[87267.762955]  00000000000116c0 0000000000004000 ffff8807f412b060 ffff8800b2c09830
[87267.763069]  ffff88070cca5938 ffffffffa02bc23f 0000000000000000 0000000000000050
[87267.763188] Call Trace:
[87267.763264]  [<ffffffffa02bc23f>] ? run_delalloc_range+0x1b1/0x2d7 [btrfs]
[87267.763329]  [<ffffffff8107a93b>] ? ktime_get_ts+0x50/0xb7
[87267.763391]  [<ffffffff810a3377>] ? delayacct_end+0x77/0x82
[87267.763453]  [<ffffffff810b1e0a>] ? __lock_page+0x63/0x63
[87267.763515]  [<ffffffff8139dbf4>] schedule+0x6a/0x6c
[87267.763575]  [<ffffffff8139dc80>] io_schedule+0x8a/0xc8
[87267.763636]  [<ffffffff810b1e13>] sleep_on_page+0x9/0xd
[87267.763697]  [<ffffffff8139e053>] __wait_on_bit_lock+0x43/0x8a
[87267.763759]  [<ffffffff810b1af5>] ? find_get_pages_tag+0xe9/0x123
[87267.763822]  [<ffffffff810b1e08>] __lock_page+0x61/0x63
[87267.763883]  [<ffffffff81068552>] ? wake_atomic_t_function+0x28/0x28
[87267.763963]  [<ffffffffa02cf871>] extent_write_cache_pages.isra.28.constprop.45+0x120/0x2f6 [btrfs]
[87267.764091]  [<ffffffffa02cfcd5>] extent_writepages+0x46/0x57 [btrfs]
[87267.764165]  [<ffffffffa02b8d62>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[87267.764227]  [<ffffffff81063290>] ? load_balance+0x23c/0x79a
[87267.764299]  [<ffffffffa02b7edf>] btrfs_writepages+0x23/0x25 [btrfs]
[87267.764362]  [<ffffffff810bb2ba>] do_writepages+0x19/0x27
[87267.764424]  [<ffffffff81118134>] __writeback_single_inode+0x3a/0xe4
[87267.764487]  [<ffffffff81118fc1>] writeback_sb_inodes+0x1b2/0x2cc
[87267.764550]  [<ffffffff8111914a>] __writeback_inodes_wb+0x6f/0xb4
[87267.764611]  [<ffffffff81119290>] wb_writeback+0x101/0x190
[87267.764673]  [<ffffffff8110e0ac>] ? get_nr_inodes+0x3a/0x50
[87267.764734]  [<ffffffff8111952a>] bdi_writeback_workfn+0x152/0x29f
[87267.764797]  [<ffffffff8104bbc1>] process_one_work+0x1be/0x2f4
[87267.764858]  [<ffffffff8104c15a>] worker_thread+0x1cd/0x2c4
[87267.764919]  [<ffffffff8104bf8d>] ? rescuer_thread+0x26c/0x26c
[87267.764981]  [<ffffffff81050ec2>] kthread+0xcd/0xd5
[87267.765043]  [<ffffffff81050df5>] ? kthread_freezable_should_stop+0x43/0x43
[87267.765106]  [<ffffffff813a0c3c>] ret_from_fork+0x7c/0xb0
[87267.765167]  [<ffffffff81050df5>] ? kthread_freezable_should_stop+0x43/0x43
[87267.765230] kworker/u16:0   D ffff88081fa916c0     0 24591      2 0x00000000
[87267.765311] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[87267.765371]  ffff880496a9b758 0000000000000046 ffff8807f41b3400 ffff8800c7cd8000
[87267.765485]  00000000000116c0 0000000000004000 ffff8807f4129830 ffff8800c7cd8000
[87267.765599]  ffff8807f41b3400 ffff8807f3845b40 ffff880496a9b6e8 ffff8807f0b98000
[87267.765713] Call Trace:
[87267.765771]  [<ffffffff81193cd9>] ? blk_peek_request+0x17e/0x19a
[87267.765846]  [<ffffffffa002085a>] ? scsi_request_fn+0x31/0x4dc [scsi_mod]
[87267.765910]  [<ffffffff8107a93b>] ? ktime_get_ts+0x50/0xb7
[87267.765971]  [<ffffffff810a3377>] ? delayacct_end+0x77/0x82
[87267.766032]  [<ffffffff810b1e0a>] ? __lock_page+0x63/0x63
[87267.766093]  [<ffffffff8139dbf4>] schedule+0x6a/0x6c
[87267.766153]  [<ffffffff8139dc80>] io_schedule+0x8a/0xc8
[87267.766215]  [<ffffffff810b1e13>] sleep_on_page+0x9/0xd
[87267.766276]  [<ffffffff8139e053>] __wait_on_bit_lock+0x43/0x8a
[87267.766338]  [<ffffffff810b1e08>] __lock_page+0x61/0x63
[87267.766399]  [<ffffffff81068552>] ? wake_atomic_t_function+0x28/0x28
[87267.766461]  [<ffffffff810b2100>] find_lock_entry+0x39/0x5d
[87267.766523]  [<ffffffff810b212d>] find_lock_page+0x9/0x16
[87267.766585]  [<ffffffff810b28b9>] find_or_create_page+0x2f/0x86
[87267.766659]  [<ffffffffa02e9d3a>] io_ctl_prepare_pages+0x47/0x110 [btrfs]
[87267.766734]  [<ffffffffa02ec0ce>] __load_free_space_cache+0x1cc/0x547 [btrfs]
[87267.766808]  [<ffffffffa02ea7ea>] ? __lookup_free_space_inode+0xde/0x112 [btrfs]
[87267.766931]  [<ffffffffa02ec51c>] load_free_space_cache+0xd3/0x174 [btrfs]
[87267.767001]  [<ffffffffa029fd24>] cache_block_group+0x1b5/0x326 [btrfs]
[87267.767065]  [<ffffffff810684f8>] ? __wake_up_sync+0xd/0xd
[87267.767134]  [<ffffffffa02a536f>] find_free_extent.isra.81+0x31e/0x7bc [btrfs]
[87267.767259]  [<ffffffffa02cbda2>] ? free_extent_state.part.32+0x30/0x35 [btrfs]
[87267.767379]  [<ffffffffa02a587b>] btrfs_reserve_extent+0x6e/0x10f [btrfs]
[87267.767453]  [<ffffffffa02bb5b4>] cow_file_range+0x1af/0x3e4 [btrfs]
[87267.767525]  [<ffffffffa02bc46b>] submit_compressed_extents+0x106/0x421 [btrfs]
[87267.767647]  [<ffffffffa02bc809>] async_cow_submit+0x83/0x88 [btrfs]
[87267.767722]  [<ffffffffa02db6ba>] normal_work_helper+0x10e/0x16f [btrfs]
[87267.767785]  [<ffffffff8104bbc1>] process_one_work+0x1be/0x2f4
[87267.767847]  [<ffffffff8104c15a>] worker_thread+0x1cd/0x2c4
[87267.767907]  [<ffffffff8104bf8d>] ? rescuer_thread+0x26c/0x26c
[87267.767970]  [<ffffffff81050ec2>] kthread+0xcd/0xd5
[87267.768031]  [<ffffffff81050df5>] ? kthread_freezable_should_stop+0x43/0x43
[87267.768093]  [<ffffffff813a0c3c>] ret_from_fork+0x7c/0xb0
[87267.768155]  [<ffffffff81050df5>] ? kthread_freezable_should_stop+0x43/0x43
[87267.768218] rsync           D ffff88081fa116c0     0 25401  25399 0x00000004
[87267.768282]  ffff880461c5ba88 0000000000000082 ffff880461c5b9a8 ffff8807f08d1830
[87267.768396]  00000000000116c0 0000000000004000 ffffffff81613450 ffff8807f08d1830
[87267.769896]  ffff880461c5ba58 ffffffffa02bc23f 0000000000000000 0000000000000050
[87267.770010] Call Trace:
[87267.770076]  [<ffffffffa02bc23f>] ? run_delalloc_range+0x1b1/0x2d7 [btrfs]
[87267.770140]  [<ffffffff810bc447>] ? release_pages+0x1bc/0x1db
[87267.770202]  [<ffffffff810b1e0a>] ? __lock_page+0x63/0x63
[87267.770264]  [<ffffffff8139dbf4>] schedule+0x6a/0x6c
[87267.770324]  [<ffffffff8139dc80>] io_schedule+0x8a/0xc8
[87267.770385]  [<ffffffff810b1e13>] sleep_on_page+0x9/0xd
[87267.770446]  [<ffffffff8139e053>] __wait_on_bit_lock+0x43/0x8a
[87267.770508]  [<ffffffff810b1af5>] ? find_get_pages_tag+0xe9/0x123
[87267.770570]  [<ffffffff810b1e08>] __lock_page+0x61/0x63
[87267.770631]  [<ffffffff81068552>] ? wake_atomic_t_function+0x28/0x28
[87267.770705]  [<ffffffffa02cf871>] extent_write_cache_pages.isra.28.constprop.45+0x120/0x2f6 [btrfs]
[87267.770821]  [<ffffffff810bccc0>] ? pagevec_lookup_entries+0x1a/0x23
[87267.770885]  [<ffffffff810bd4b3>] ? truncate_inode_pages_range+0x34c/0x488
[87267.770959]  [<ffffffffa02cfcd5>] extent_writepages+0x46/0x57 [btrfs]
[87267.771031]  [<ffffffffa02b8d62>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[87267.771103]  [<ffffffffa02b7edf>] btrfs_writepages+0x23/0x25 [btrfs]
[87267.771165]  [<ffffffff810bb2ba>] do_writepages+0x19/0x27
[87267.771227]  [<ffffffff810b2cd2>] __filemap_fdatawrite_range+0x4e/0x50
[87267.771290]  [<ffffffff810b382c>] filemap_fdatawrite_range+0xe/0x10
[87267.771365]  [<ffffffffa02cb16c>] btrfs_wait_ordered_range+0x89/0x11d [btrfs]
[87267.771430]  [<ffffffff810fb0ce>] ? __sb_end_write+0x29/0x58
[87267.771501]  [<ffffffffa02be063>] btrfs_truncate+0x43/0x22b [btrfs]
[87267.771573]  [<ffffffffa02beb18>] btrfs_setattr+0x1b6/0x2a4 [btrfs]
[87267.771636]  [<ffffffff8110f741>] notify_change+0x1ed/0x2d6
[87267.771697]  [<ffffffff810f7f46>] do_truncate+0x62/0x87
[87267.771758]  [<ffffffff810f8263>] do_sys_ftruncate.constprop.13+0x114/0x128
[87267.771822]  [<ffffffff810f8299>] SyS_ftruncate+0x9/0xb
[87267.771882]  [<ffffffff813a0ce2>] system_call_fastpath+0x16/0x1b
[87267.771943] shutdown        D ffff88081fa116c0     0  6492   6446 0x00000000
[87267.772008]  ffff8803fa50fd28 0000000000000082 ffff880430aa8000 ffff8807af109830
[87267.772121]  00000000000116c0 0000000000004000 ffffffff81613450 ffff8807af109830
[87267.772235]  ffff8803fa50fc68 ffffffff810587ea ffff880430aa8000 ffff88081fb116c0
[87267.772349] Call Trace:
[87267.772405]  [<ffffffff810587ea>] ? ttwu_do_wakeup+0x12/0x7f
[87267.772466]  [<ffffffff810588f8>] ? ttwu_do_activate.constprop.73+0x57/0x5c
[87267.772530]  [<ffffffff8105af73>] ? try_to_wake_up+0x211/0x222
[87267.772591]  [<ffffffff8105afc3>] ? wake_up_process+0x30/0x34
[87267.772653]  [<ffffffff8139dbf4>] schedule+0x6a/0x6c
[87267.772713]  [<ffffffff8139cec6>] schedule_timeout+0x26/0x198
[87267.772775]  [<ffffffff8104b07a>] ? __queue_work+0x1d2/0x204
[87267.772836]  [<ffffffff8139e3d5>] wait_for_common+0x10d/0x13e
[87267.772898]  [<ffffffff8105af84>] ? try_to_wake_up+0x222/0x222
[87267.772960]  [<ffffffff8111c210>] ? fdatawrite_one_bdev+0x13/0x13
[87267.773022]  [<ffffffff8139e41e>] wait_for_completion+0x18/0x1a
[87267.773084]  [<ffffffff8111868c>] sync_inodes_sb+0xb7/0x191
[87267.773145]  [<ffffffff8111c210>] ? fdatawrite_one_bdev+0x13/0x13
[87267.773207]  [<ffffffff8111c21f>] sync_inodes_one_sb+0xf/0x11
[87267.773268]  [<ffffffff810fc382>] iterate_supers+0x66/0xb6
[87267.773329]  [<ffffffff8111c313>] sys_sync+0x30/0x7e
[87267.773389]  [<ffffffff813a0ce2>] system_call_fastpath+0x16/0x1b
[87267.773451] Sched Debug Version: v0.11, 3.15.0-rc3 #1
[87267.773511] ktime                                   : 87319233.423731
[87267.773572] sched_clk                               : 87267773.449874
[87267.773633] cpu_clk                                 : 87267773.449904
[87267.773694] jiffies                                 : 4303669220
[87267.773754] sched_clock_stable()                    : 1
[87267.773813] 
[87267.773865] sysctl_sched
[87267.773920]   .sysctl_sched_latency                    : 24.000000
[87267.773981]   .sysctl_sched_min_granularity            : 3.000000
[87267.774041]   .sysctl_sched_wakeup_granularity         : 4.000000
[87267.774102]   .sysctl_sched_child_runs_first           : 0
[87267.774160]   .sysctl_sched_features                   : 11899
[87267.774221]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[87267.774282] 
[87267.774335] cpu#0, 3399.965 MHz
[87267.774390]   .nr_running                    : 0
[87267.774448]   .load                          : 0
[87267.774506]   .nr_switches                   : 3418317
[87267.774564]   .nr_load_updates               : 775402
[87267.774622]   .nr_uninterruptible            : -33596
[87267.774681]   .next_balance                  : 4303.669221
[87267.774740]   .curr->pid                     : 0
[87267.774798]   .clock                         : 87267770.061131
[87267.774858]   .cpu_load[0]                   : 0
[87267.774915]   .cpu_load[1]                   : 0
[87267.774973]   .cpu_load[2]                   : 0
[87267.775030]   .cpu_load[3]                   : 0
[87267.775088]   .cpu_load[4]                   : 0
[87267.775145]   .yld_count                     : 0
[87267.775203]   .sched_count                   : 3439441
[87267.775262]   .sched_goidle                  : 1547474
[87267.775320]   .avg_idle                      : 1000000
[87267.775379]   .max_idle_balance_cost         : 500000
[87267.775437]   .ttwu_count                    : 2191612
[87267.775496]   .ttwu_local                    : 1413243
[87267.775555] 
[87267.775555] cfs_rq[0]:/autogroup-11
[87267.775662]   .exec_clock                    : 2223.814715
[87267.775722]   .MIN_vruntime                  : 0.000001
[87267.775781]   .min_vruntime                  : 1976.000599
[87267.775840]   .max_vruntime                  : 0.000001
[87267.775899]   .spread                        : 0.000000
[87267.775958]   .spread0                       : -486710.914793
[87267.776018]   .nr_spread_over                : 38
[87267.776075]   .nr_running                    : 0
[87267.776133]   .load                          : 0
[87267.776191]   .runnable_load_avg             : 0
[87267.776249]   .blocked_load_avg              : 0
[87267.776306]   .tg_load_contrib               : 0
[87267.776364]   .tg_runnable_contrib           : 0
[87267.776422]   .tg_load_avg                   : 0
[87267.776479]   .tg->runnable_avg              : 0
[87267.776537]   .tg->cfs_bandwidth.timer_active: 0
[87267.776595]   .throttled                     : 0
[87267.776652]   .throttle_count                : 0
[87267.776711]   .se->exec_start                : 87267676.633256
[87267.776770]   .se->vruntime                  : 488675.189126
[87267.776830]   .se->sum_exec_runtime          : 2223.814715
[87267.776889]   .se->statistics.wait_start     : 0.000000
[87267.776948]   .se->statistics.sleep_start    : 0.000000
[87267.777006]   .se->statistics.block_start    : 0.000000
[87267.777065]   .se->statistics.sleep_max      : 0.000000
[87267.777124]   .se->statistics.block_max      : 0.000000
[87267.777183]   .se->statistics.exec_max       : 6.775289
[87267.777242]   .se->statistics.slice_max      : 0.598308
[87267.777301]   .se->statistics.wait_max       : 0.055768
[87267.777359]   .se->statistics.wait_sum       : 0.702348
[87267.777419]   .se->statistics.wait_count     : 17841
[87267.777476]   .se->load.weight               : 2
[87267.777534]   .se->avg.runnable_avg_sum      : 6
[87267.777592]   .se->avg.runnable_avg_period   : 47788
[87267.777650]   .se->avg.load_avg_contrib      : 0
[87267.777708]   .se->avg.decay_count           : 83224942
[87267.777767] 
[87267.777767] cfs_rq[0]:/autogroup-25568
[87267.777875]   .exec_clock                    : 17.292271
[87267.777933]   .MIN_vruntime                  : 0.000001
[87267.777993]   .min_vruntime                  : 16.243695
[87267.778051]   .max_vruntime                  : 0.000001
[87267.778110]   .spread                        : 0.000000
[87267.778169]   .spread0                       : -488670.671697
[87267.778228]   .nr_spread_over                : 0
[87267.778286]   .nr_running                    : 0
[87267.778343]   .load                          : 0
[87267.778401]   .runnable_load_avg             : 0
[87267.778459]   .blocked_load_avg              : 0
[87267.778517]   .tg_load_contrib               : 0
[87267.778574]   .tg_runnable_contrib           : 2
[87267.778632]   .tg_load_avg                   : 0
[87267.778689]   .tg->runnable_avg              : 2
[87267.778747]   .tg->cfs_bandwidth.timer_active: 0
[87267.778805]   .throttled                     : 0
[87267.778863]   .throttle_count                : 0
[87267.778920]   .se->exec_start                : 87267762.545655
[87267.778980]   .se->vruntime                  : 488680.645203
[87267.779040]   .se->sum_exec_runtime          : 17.292271
[87267.779099]   .se->statistics.wait_start     : 0.000000
[87267.779158]   .se->statistics.sleep_start    : 0.000000
[87267.779216]   .se->statistics.block_start    : 0.000000
[87267.779275]   .se->statistics.sleep_max      : 0.000000
[87267.779334]   .se->statistics.block_max      : 0.000000
[87267.779393]   .se->statistics.exec_max       : 0.718502
[87267.779452]   .se->statistics.slice_max      : 0.000000
[87267.779510]   .se->statistics.wait_max       : 0.028410
[87267.779569]   .se->statistics.wait_sum       : 0.715705
[87267.779628]   .se->statistics.wait_count     : 268
[87267.779686]   .se->load.weight               : 2
[87267.779744]   .se->avg.runnable_avg_sum      : 121
[87267.779801]   .se->avg.runnable_avg_period   : 47920
[87267.779860]   .se->avg.load_avg_contrib      : 0
[87267.779918]   .se->avg.decay_count           : 83225024
[87267.779978] 
[87267.779978] cfs_rq[0]:/
[87267.780082]   .exec_clock                    : 472968.797681
[87267.780142]   .MIN_vruntime                  : 0.000001
[87267.780201]   .min_vruntime                  : 488686.915392
[87267.780261]   .max_vruntime                  : 0.000001
[87267.780319]   .spread                        : 0.000000
[87267.780378]   .spread0                       : 0.000000
[87267.780437]   .nr_spread_over                : 2443
[87267.780495]   .nr_running                    : 0
[87267.780552]   .load                          : 0
[87267.781994]   .runnable_load_avg             : 0
[87267.782051]   .blocked_load_avg              : 0
[87267.782109]   .tg_load_contrib               : 0
[87267.782166]   .tg_runnable_contrib           : 3
[87267.782224]   .tg_load_avg                   : 0
[87267.782281]   .tg->runnable_avg              : 897
[87267.782339]   .tg->cfs_bandwidth.timer_active: 0
[87267.782397]   .throttled                     : 0
[87267.782454]   .throttle_count                : 0
[87267.782512]   .avg->runnable_avg_sum         : 156
[87267.782570]   .avg->runnable_avg_period      : 47733
[87267.782630] 
[87267.782630] rt_rq[0]:/
[87267.782734]   .rt_nr_running                 : 0
[87267.782791]   .rt_throttled                  : 0
[87267.782849]   .rt_time                       : 0.000000
[87267.782908]   .rt_runtime                    : 950.000000
[87267.782967] 
[87267.782967] runnable tasks:
[87267.782967]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.782967] ----------------------------------------------------------------------------------------------------------
[87267.783301]      ksoftirqd/0     3    488674.571483     35750   120    488674.571483       835.033733  87251242.046179 /
[87267.783424]     kworker/0:0H     5       855.728853         5   100       855.728853         0.022610      1081.696557 /
[87267.783547]      migration/0     9         0.000000       346     0         0.000000       956.371294         0.000900 /
[87267.783668]       watchdog/0    10       -11.813299     21839     0       -11.813299       230.603516        95.078410 /
[87267.783793]            khubd   363      1883.910078        62   120      1883.910078         3.366940     33702.303311 /
[87267.783916]      kworker/0:1   610    488676.757182    450132   120    488676.757182      8817.537343  87252578.438108 /
[87267.784037]      kworker/0:2   738      1803.377832         4   120      1803.377832         0.013013     33156.837764 /
[87267.784160]     kworker/0:1H   912    488674.918485    316938   100    488674.918485      5916.625308  87253259.790293 /
[87267.784282]        md2_raid1   964    488675.215146     43423   120    488675.215146      1321.641892  87259316.377419 /
[87267.784404]       jbd2/md2-8   978    488675.202918     20060   120    488675.202918      1121.448630  87259278.339103 /
[87267.784528]             sshd  2892         1.256014        18   120         1.256014         2.704654  87146773.430072 /autogroup-6
[87267.784652]         rsyslogd  3273       283.030294        18   120       283.030294         1.784000  72604159.566897 /autogroup-8
[87267.784776]       munin-node  3333      1976.000599     44094   120      1976.000599      2737.809612  87185494.515191 /autogroup-11
[87267.784901]          apache2  3600       259.919156      1486   120       259.919156        25.828198  72501490.499176 /autogroup-29
[87267.785025]          apache2  3602       315.037323      3193   120       315.037323        48.693093  87178339.302065 /autogroup-29
[87267.785148]            rsync  4078        57.125884        13   139        57.125884         1.347705       214.833250 /autogroup-49
[87267.785272]             qmgr  4293        59.303819       544   120        59.303819        66.892796  86958876.632108 /autogroup-59
[87267.785396]            getty  4336         0.233340       101   120         0.233340         3.731552        51.656517 /autogroup-61
[87267.785520]            getty  4339         0.832317        35   120         0.832317         1.458265        51.585535 /autogroup-65
[87267.785644]  snapbackup-run- 18851     30762.289052        13   120     30762.289052         3.274068   2780634.727403 /autogroup-14609
[87267.785769]            rsync 25401     34135.593578     28459   120     34135.593578      6335.571388    378259.676098 /autogroup-14609
[87267.785894]             sshd  6359        60.396940      1090   120        60.396940        93.017476    156600.090335 /autogroup-25562
[87267.786018]             sshd  6444         9.307345        82   120         9.307345        13.374636     55670.393333 /autogroup-25566
[87267.786142]         shutdown  6492         3.885122         9   120         3.885122         2.652016        65.319370 /autogroup-25567
[87267.786267]             sshd  6495        16.243695       267   120        16.243695        24.679611     43172.733478 /autogroup-25568
[87267.786391] 
[87267.786443] cpu#1, 3399.965 MHz
[87267.786498]   .nr_running                    : 1
[87267.786556]   .load                          : 1024
[87267.786614]   .nr_switches                   : 1863279
[87267.786672]   .nr_load_updates               : 559306
[87267.786730]   .nr_uninterruptible            : -13982
[87267.786789]   .next_balance                  : 4303.669198
[87267.786848]   .curr->pid                     : 6497
[87267.786907]   .clock                         : 87267762.451585
[87267.786967]   .cpu_load[0]                   : 0
[87267.787024]   .cpu_load[1]                   : 0
[87267.787081]   .cpu_load[2]                   : 0
[87267.787139]   .cpu_load[3]                   : 0
[87267.787196]   .cpu_load[4]                   : 0
[87267.787254]   .yld_count                     : 0
[87267.787312]   .sched_count                   : 1884453
[87267.787370]   .sched_goidle                  : 867876
[87267.787429]   .avg_idle                      : 1000000
[87267.787487]   .max_idle_balance_cost         : 500000
[87267.787546]   .ttwu_count                    : 806881
[87267.787604]   .ttwu_local                    : 483429
[87267.787663] 
[87267.787663] cfs_rq[1]:/autogroup-8
[87267.787769]   .exec_clock                    : 382.605174
[87267.787828]   .MIN_vruntime                  : 0.000001
[87267.787886]   .min_vruntime                  : 389.320473
[87267.787946]   .max_vruntime                  : 0.000001
[87267.788004]   .spread                        : 0.000000
[87267.788063]   .spread0                       : -488297.594919
[87267.788123]   .nr_spread_over                : 14
[87267.788181]   .nr_running                    : 0
[87267.788239]   .load                          : 0
[87267.788296]   .runnable_load_avg             : 0
[87267.788354]   .blocked_load_avg              : 0
[87267.788411]   .tg_load_contrib               : 0
[87267.788468]   .tg_runnable_contrib           : 0
[87267.788526]   .tg_load_avg                   : 0
[87267.788584]   .tg->runnable_avg              : 0
[87267.788642]   .tg->cfs_bandwidth.timer_active: 0
[87267.788700]   .throttled                     : 0
[87267.788757]   .throttle_count                : 0
[87267.788815]   .se->exec_start                : 87267502.341138
[87267.788874]   .se->vruntime                  : 441725.210103
[87267.788933]   .se->sum_exec_runtime          : 383.350987
[87267.788992]   .se->statistics.wait_start     : 0.000000
[87267.789051]   .se->statistics.sleep_start    : 0.000000
[87267.789110]   .se->statistics.block_start    : 0.000000
[87267.789169]   .se->statistics.sleep_max      : 0.000000
[87267.789227]   .se->statistics.block_max      : 0.000000
[87267.789287]   .se->statistics.exec_max       : 2.097554
[87267.789345]   .se->statistics.slice_max      : 0.036973
[87267.789405]   .se->statistics.wait_max       : 0.633798
[87267.789463]   .se->statistics.wait_sum       : 1.562689
[87267.789522]   .se->statistics.wait_count     : 3425
[87267.789580]   .se->load.weight               : 2
[87267.789638]   .se->avg.runnable_avg_sum      : 18
[87267.789696]   .se->avg.runnable_avg_period   : 48513
[87267.789754]   .se->avg.load_avg_contrib      : 0
[87267.789812]   .se->avg.decay_count           : 83224776
[87267.789871] 
[87267.789871] cfs_rq[1]:/autogroup-25569
[87267.789978]   .exec_clock                    : 39.705026
[87267.790037]   .MIN_vruntime                  : 0.000001
[87267.790096]   .min_vruntime                  : 38.923532
[87267.790155]   .max_vruntime                  : 0.000001
[87267.790214]   .spread                        : 0.000000
[87267.790273]   .spread0                       : -488647.991860
[87267.790332]   .nr_spread_over                : 0
[87267.790390]   .nr_running                    : 1
[87267.790448]   .load                          : 1024
[87267.790506]   .runnable_load_avg             : 0
[87267.790563]   .blocked_load_avg              : 0
[87267.790621]   .tg_load_contrib               : 0
[87267.790679]   .tg_runnable_contrib           : 0
[87267.790736]   .tg_load_avg                   : 0
[87267.790794]   .tg->runnable_avg              : 0
[87267.790852]   .tg->cfs_bandwidth.timer_active: 0
[87267.790909]   .throttled                     : 0
[87267.790967]   .throttle_count                : 0
[87267.791025]   .se->exec_start                : 87267762.451585
[87267.791085]   .se->vruntime                  : 441737.216123
[87267.791144]   .se->sum_exec_runtime          : 39.705026
[87267.791203]   .se->statistics.wait_start     : 0.000000
[87267.791262]   .se->statistics.sleep_start    : 0.000000
[87267.791321]   .se->statistics.block_start    : 0.000000
[87267.791380]   .se->statistics.sleep_max      : 0.000000
[87267.791439]   .se->statistics.block_max      : 0.000000
[87267.791497]   .se->statistics.exec_max       : 7.378639
[87267.791556]   .se->statistics.slice_max      : 0.000000
[87267.791615]   .se->statistics.wait_max       : 0.019703
[87267.791673]   .se->statistics.wait_sum       : 1.122353
[87267.791732]   .se->statistics.wait_count     : 225
[87267.791790]   .se->load.weight               : 1024
[87267.791849]   .se->avg.runnable_avg_sum      : 41
[87267.791907]   .se->avg.runnable_avg_period   : 47756
[87267.791965]   .se->avg.load_avg_contrib      : 0
[87267.792022]   .se->avg.decay_count           : 0
[87267.792080] 
[87267.792080] cfs_rq[1]:/
[87267.792185]   .exec_clock                    : 422767.415699
[87267.792244]   .MIN_vruntime                  : 0.000001
[87267.792303]   .min_vruntime                  : 441737.244246
[87267.792362]   .max_vruntime                  : 0.000001
[87267.792422]   .spread                        : 0.000000
[87267.792480]   .spread0                       : -46949.671146
[87267.792540]   .nr_spread_over                : 2391
[87267.793983]   .nr_running                    : 1
[87267.794041]   .load                          : 1024
[87267.794099]   .runnable_load_avg             : 0
[87267.794157]   .blocked_load_avg              : 0
[87267.794215]   .tg_load_contrib               : 0
[87267.794272]   .tg_runnable_contrib           : 1
[87267.794329]   .tg_load_avg                   : 0
[87267.794387]   .tg->runnable_avg              : 897
[87267.794445]   .tg->cfs_bandwidth.timer_active: 0
[87267.794503]   .throttled                     : 0
[87267.794560]   .throttle_count                : 0
[87267.794618]   .avg->runnable_avg_sum         : 51
[87267.794676]   .avg->runnable_avg_period      : 47793
[87267.794734] 
[87267.794734] rt_rq[1]:/
[87267.794838]   .rt_nr_running                 : 0
[87267.794896]   .rt_throttled                  : 0
[87267.794953]   .rt_time                       : 0.000000
[87267.795012]   .rt_runtime                    : 950.000000
[87267.795072] 
[87267.795072] runnable tasks:
[87267.795072]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.795072] ----------------------------------------------------------------------------------------------------------
[87267.795406]       watchdog/1    11        -4.043621         3   120        -4.043621         0.005775         0.000951 /
[87267.795528]      migration/1    12         0.000000       287     0         0.000000       241.960279         0.000816 /
[87267.795650]      ksoftirqd/1    13    441718.846315     37765   120    441718.846315       883.305453  87252205.577851 /
[87267.795772]      kworker/1:0    14        -7.019265        12   120        -7.019265         0.030222       294.718010 /
[87267.795893]     kworker/1:0H    15       479.354962         6   100       479.354962         0.054589      1109.192258 /
[87267.796016]       khungtaskd   133    441641.994906       732   120    441641.994906        61.692686  87188526.250241 /
[87267.796138]      kworker/1:1   474    441725.269936    327433   120    441725.269936      6835.173574  87254733.042408 /
[87267.796261]        scsi_eh_5   892       463.629080        18   120       463.629080         5.515136       350.865144 /
[87267.796383]     kworker/1:1H   925    441720.941449     28191   100    441720.941449       424.471564  87257424.624972 /
[87267.796505]            udevd  1165        95.065630       261   120        95.065630        41.030314     50134.250586 /autogroup-4
[87267.796630]          vnstatd  3238       678.772308     17977   120       678.772308      2330.817275  87182224.738956 /autogroup-9
[87267.796753]         rsyslogd  3287       389.320473      7770   120       389.320473       378.535397  87188092.013422 /autogroup-8
[87267.796877]         rsyslogd  3288       377.172019        11   120       377.172019         1.942053  87176460.857559 /autogroup-8
[87267.797000]          apache2  3601       367.452411      1936   120       367.452411        31.008747  84094052.468269 /autogroup-29
[87267.797124]          apache2  3603       368.358797        37   120       368.358797         3.983765  84100046.546026 /autogroup-29
[87267.797247]            mdadm  3943         4.882602        88   120         4.882602        14.020893  86956852.794600 /autogroup-46
[87267.797370]           master  4274       106.241642      4660   120       106.241642       219.711484  87144830.399780 /autogroup-59
[87267.797494]            getty  4340         0.470290        96   120         0.470290         2.172636        51.474224 /autogroup-66
[87267.797618]          apache2 21823       367.888480       306   120       367.888480         7.838677  62010695.123736 /autogroup-29
[87267.797742]             cron 18845       929.973847         1   120       929.973847         1.595045         0.000000 /autogroup-30
[87267.797867]            rsync 25399     29627.918485     73641   120     29627.918485     10937.678004  34768924.631710 /autogroup-14609
[87267.797991]              ssh 25400     29625.499081     47210   120     29625.499081      4973.302685    381210.840876 /autogroup-14609
[87267.798115]    kworker/u17:3 25403    268435.345710        83   100    268435.345710         4.713600    351977.562776 /
[87267.798237]           strace  6432       111.773971         8   120       111.773971         0.787157     26855.572186 /autogroup-25563
[87267.798361]             bash  6446        16.574035        71   120        16.574035        35.237053      3365.563290 /autogroup-25567
[87267.798486] R           bash  6497        38.923532       255   120        38.923532        59.731769     42395.384353 /autogroup-25569
[87267.798609] 
[87267.798661] cpu#2, 3399.965 MHz
[87267.798716]   .nr_running                    : 0
[87267.798774]   .load                          : 0
[87267.798832]   .nr_switches                   : 1856940
[87267.798890]   .nr_load_updates               : 569550
[87267.798948]   .nr_uninterruptible            : -20426
[87267.799007]   .next_balance                  : 4303.669217
[87267.799066]   .curr->pid                     : 0
[87267.799124]   .clock                         : 87267730.082422
[87267.799183]   .cpu_load[0]                   : 0
[87267.799241]   .cpu_load[1]                   : 0
[87267.799299]   .cpu_load[2]                   : 0
[87267.799356]   .cpu_load[3]                   : 0
[87267.799414]   .cpu_load[4]                   : 0
[87267.799472]   .yld_count                     : 0
[87267.799530]   .sched_count                   : 1878299
[87267.799588]   .sched_goidle                  : 868059
[87267.799647]   .avg_idle                      : 1000000
[87267.799705]   .max_idle_balance_cost         : 500000
[87267.799763]   .ttwu_count                    : 804581
[87267.799822]   .ttwu_local                    : 496790
[87267.799880] 
[87267.799880] cfs_rq[2]:/
[87267.799985]   .exec_clock                    : 424685.513594
[87267.800044]   .MIN_vruntime                  : 0.000001
[87267.800103]   .min_vruntime                  : 442622.650936
[87267.800163]   .max_vruntime                  : 0.000001
[87267.800222]   .spread                        : 0.000000
[87267.800281]   .spread0                       : -46064.264456
[87267.800340]   .nr_spread_over                : 1800
[87267.800398]   .nr_running                    : 0
[87267.800455]   .load                          : 0
[87267.800514]   .runnable_load_avg             : 0
[87267.800571]   .blocked_load_avg              : 0
[87267.800628]   .tg_load_contrib               : 0
[87267.800686]   .tg_runnable_contrib           : 0
[87267.800744]   .tg_load_avg                   : 0
[87267.800801]   .tg->runnable_avg              : 896
[87267.800859]   .tg->cfs_bandwidth.timer_active: 0
[87267.800916]   .throttled                     : 0
[87267.800974]   .throttle_count                : 0
[87267.801032]   .avg->runnable_avg_sum         : 19
[87267.801089]   .avg->runnable_avg_period      : 47347
[87267.801148] 
[87267.801148] rt_rq[2]:/
[87267.801252]   .rt_nr_running                 : 0
[87267.801310]   .rt_throttled                  : 0
[87267.801368]   .rt_time                       : 0.000000
[87267.801427]   .rt_runtime                    : 950.000000
[87267.801486] 
[87267.801486] runnable tasks:
[87267.801486]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.801486] ----------------------------------------------------------------------------------------------------------
[87267.801821]        rcu_sched     7    442622.650936    489082   120    442622.650936     15942.958880  87249676.692973 /
[87267.801943]       watchdog/2    16        -5.973122     21833     0        -5.973122       231.840527        73.564450 /
[87267.802065]      migration/2    17         0.000000       256     0         0.000000         6.736264         0.000822 /
[87267.802186]      ksoftirqd/2    18    442610.006780     35825   120    442610.006780       831.940921  87252117.853583 /
[87267.802307]      kworker/2:0    19        -7.023439        13   120        -7.023439         0.026101       517.720571 /
[87267.802429]     kworker/2:0H    20       296.731622         6   100       296.731622         0.038696      1123.490222 /
[87267.802553]      kworker/2:1   613    442610.686173    323092   120    442610.686173      6640.389569  87256310.860735 /
[87267.802676]        scsi_eh_4   890       270.614465        18   120       270.614465         5.294905       351.003478 /
[87267.802798]     kworker/2:1H   935    442553.222210     24633   100    442553.222210       377.631762  87195786.701298 /
[87267.802919]        md1_raid1   954    441297.882894       119   120    441297.882894         3.669372  87035559.080924 /
[87267.803043]          apache2  3567       389.666107     87154   120       389.666107      1556.607735  87185315.403331 /autogroup-29
[87267.803167]          apache2  3599       349.383733      1957   120       349.383733        32.275610  72501484.216648 /autogroup-29
[87267.803291]             ntpd  4179       753.553362     91407   120       753.553362      2864.217732  87183716.406164 /autogroup-56
[87267.803415]            getty  4338         0.835961       100   120         0.835961         1.693648        53.074444 /autogroup-64
[87267.803539]    kworker/u16:0 24591    283420.583317      9755   120    283420.583317      1223.638274    521592.828240 /
[87267.803661]   kworker/u16:15 25228    442573.046250     12771   120    442573.046250      1597.301348  34878028.663863 /
[87267.803783]    snapbackup.sh 25383     28539.835888        37   120     28539.835888         6.946176        64.196083 /autogroup-14609
[87267.803909] 
[87267.803961] cpu#3, 3399.965 MHz
[87267.804016]   .nr_running                    : 0
[87267.804073]   .load                          : 0
[87267.804131]   .nr_switches                   : 1777195
[87267.804189]   .nr_load_updates               : 535707
[87267.804247]   .nr_uninterruptible            : -25763
[87267.804306]   .next_balance                  : 4303.669196
[87267.804366]   .curr->pid                     : 0
[87267.804423]   .clock                         : 87267620.202688
[87267.804483]   .cpu_load[0]                   : 0
[87267.804541]   .cpu_load[1]                   : 0
[87267.804598]   .cpu_load[2]                   : 0
[87267.806040]   .cpu_load[3]                   : 0
[87267.806098]   .cpu_load[4]                   : 0
[87267.806155]   .yld_count                     : 0
[87267.806213]   .sched_count                   : 1798875
[87267.806272]   .sched_goidle                  : 836885
[87267.806329]   .avg_idle                      : 1000000
[87267.806388]   .max_idle_balance_cost         : 500000
[87267.806446]   .ttwu_count                    : 775900
[87267.806505]   .ttwu_local                    : 459417
[87267.806564] 
[87267.806564] cfs_rq[3]:/autogroup-8
[87267.806670]   .exec_clock                    : 432.377128
[87267.806729]   .MIN_vruntime                  : 0.000001
[87267.806787]   .min_vruntime                  : 431.112540
[87267.806846]   .max_vruntime                  : 0.000001
[87267.806905]   .spread                        : 0.000000
[87267.806964]   .spread0                       : -488255.802852
[87267.807023]   .nr_spread_over                : 47
[87267.807081]   .nr_running                    : 0
[87267.807139]   .load                          : 0
[87267.807196]   .runnable_load_avg             : 0
[87267.807254]   .blocked_load_avg              : 0
[87267.807312]   .tg_load_contrib               : 0
[87267.807370]   .tg_runnable_contrib           : 0
[87267.807427]   .tg_load_avg                   : 0
[87267.807484]   .tg->runnable_avg              : 0
[87267.807543]   .tg->cfs_bandwidth.timer_active: 0
[87267.807600]   .throttled                     : 0
[87267.807658]   .throttle_count                : 0
[87267.807715]   .se->exec_start                : 87267502.401507
[87267.807775]   .se->vruntime                  : 388073.435328
[87267.807835]   .se->sum_exec_runtime          : 432.991548
[87267.807894]   .se->statistics.wait_start     : 0.000000
[87267.807953]   .se->statistics.sleep_start    : 0.000000
[87267.808012]   .se->statistics.block_start    : 0.000000
[87267.808070]   .se->statistics.sleep_max      : 0.000000
[87267.808129]   .se->statistics.block_max      : 0.000000
[87267.808189]   .se->statistics.exec_max       : 2.987106
[87267.808247]   .se->statistics.slice_max      : 0.453588
[87267.808306]   .se->statistics.wait_max       : 0.307439
[87267.808365]   .se->statistics.wait_sum       : 1.833147
[87267.808423]   .se->statistics.wait_count     : 3580
[87267.808482]   .se->load.weight               : 2
[87267.808539]   .se->avg.runnable_avg_sum      : 4
[87267.808597]   .se->avg.runnable_avg_period   : 47055
[87267.808655]   .se->avg.load_avg_contrib      : 0
[87267.808713]   .se->avg.decay_count           : 83224776
[87267.808771] 
[87267.808771] cfs_rq[3]:/
[87267.808876]   .exec_clock                    : 382295.604231
[87267.808936]   .MIN_vruntime                  : 0.000001
[87267.808995]   .min_vruntime                  : 388085.256932
[87267.809054]   .max_vruntime                  : 0.000001
[87267.809113]   .spread                        : 0.000000
[87267.809171]   .spread0                       : -100601.658460
[87267.809231]   .nr_spread_over                : 2171
[87267.809289]   .nr_running                    : 0
[87267.809346]   .load                          : 0
[87267.809404]   .runnable_load_avg             : 0
[87267.809461]   .blocked_load_avg              : 0
[87267.809519]   .tg_load_contrib               : 0
[87267.809577]   .tg_runnable_contrib           : 893
[87267.809635]   .tg_load_avg                   : 0
[87267.809692]   .tg->runnable_avg              : 896
[87267.809750]   .tg->cfs_bandwidth.timer_active: 0
[87267.809808]   .throttled                     : 0
[87267.809866]   .throttle_count                : 0
[87267.809924]   .avg->runnable_avg_sum         : 40937
[87267.809982]   .avg->runnable_avg_period      : 46908
[87267.810040] 
[87267.810040] rt_rq[3]:/
[87267.810144]   .rt_nr_running                 : 0
[87267.810202]   .rt_throttled                  : 0
[87267.810259]   .rt_time                       : 0.000000
[87267.810318]   .rt_runtime                    : 950.000000
[87267.810378] 
[87267.810378] runnable tasks:
[87267.810378]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.810378] ----------------------------------------------------------------------------------------------------------
[87267.810711]           rcu_bh     8      2025.370962         5   120      2025.370962         0.086751    340650.560970 /
[87267.810833]       watchdog/3    21        -7.046216         3   120        -7.046216         0.003443         0.001330 /
[87267.810955]      migration/3    22         0.000000       304     0         0.000000       165.045429         0.000771 /
[87267.811076]      ksoftirqd/3    23    388070.776446     36087   120    388070.776446       915.237104  87231439.084067 /
[87267.811198]      kworker/3:0    24       446.795238        14   120       446.795238         0.036049      1182.610433 /
[87267.811319]     kworker/3:0H    25       449.198271         6   100       449.198271         0.030779      1578.343545 /
[87267.811442]      kworker/3:1   615    388073.518777    320108   120    388073.518777      6546.606557  87255345.318835 /
[87267.811566]     kworker/3:1H   958    388058.904986     18213   100    388058.904986       439.765787  87157480.594231 /
[87267.811688]  btrfs-transacti  2437    388071.643160     54297   120    388071.643160      8153.236510  87162454.965695 /
[87267.811810]    rs:main Q:Reg  3286       431.112540      6180   120       431.112540      1496.687022  87186970.955195 /autogroup-8
[87267.811934]          proftpd  4294        58.566271      6594   120        58.566271       399.147883  87166778.628663 /autogroup-60
[87267.812059]            getty  4341         0.500956       101   120         0.500956         1.801237        53.188688 /autogroup-63
[87267.812183]               sh 18849         0.421833         2   120         0.421833         1.011988         0.005453 /autogroup-14609
[87267.812307]   kworker/u16:13 20309    285841.576753     43221   120    285841.576753      5302.083310   2538348.355264 /
[87267.812429]    kworker/u17:0 26088    291055.846031        32   100    291055.846031         1.188362    302170.433631 /
[87267.812551]           pickup 32008       108.549586        54   120       108.549586         6.677967   3120273.943947 /autogroup-59
[87267.812675]             bash  6361        -1.732693       299   120        -1.732693        40.336739     73094.827332 /autogroup-25563
[87267.812800] 
[87267.812851] cpu#4, 3399.965 MHz
[87267.812906]   .nr_running                    : 0
[87267.812963]   .load                          : 0
[87267.813021]   .nr_switches                   : 1146662
[87267.813080]   .nr_load_updates               : 284577
[87267.813138]   .nr_uninterruptible            : 23690
[87267.813196]   .next_balance                  : 4303.668906
[87267.813256]   .curr->pid                     : 0
[87267.813313]   .clock                         : 87264621.918482
[87267.813373]   .cpu_load[0]                   : 0
[87267.813431]   .cpu_load[1]                   : 0
[87267.813488]   .cpu_load[2]                   : 0
[87267.813546]   .cpu_load[3]                   : 0
[87267.813604]   .cpu_load[4]                   : 0
[87267.813661]   .yld_count                     : 0
[87267.813719]   .sched_count                   : 1168499
[87267.813778]   .sched_goidle                  : 538054
[87267.813836]   .avg_idle                      : 1000000
[87267.813894]   .max_idle_balance_cost         : 500000
[87267.813953]   .ttwu_count                    : 612418
[87267.814011]   .ttwu_local                    : 411620
[87267.814070] 
[87267.814070] cfs_rq[4]:/
[87267.814174]   .exec_clock                    : 169534.129953
[87267.814234]   .MIN_vruntime                  : 0.000001
[87267.814292]   .min_vruntime                  : 259622.553947
[87267.814352]   .max_vruntime                  : 0.000001
[87267.814411]   .spread                        : 0.000000
[87267.814470]   .spread0                       : -229064.361445
[87267.814530]   .nr_spread_over                : 1776
[87267.814588]   .nr_running                    : 0
[87267.814646]   .load                          : 0
[87267.814703]   .runnable_load_avg             : 0
[87267.814761]   .blocked_load_avg              : 0
[87267.814819]   .tg_load_contrib               : 0
[87267.814876]   .tg_runnable_contrib           : 0
[87267.814934]   .tg_load_avg                   : 0
[87267.814991]   .tg->runnable_avg              : 896
[87267.815049]   .tg->cfs_bandwidth.timer_active: 0
[87267.815106]   .throttled                     : 0
[87267.815164]   .throttle_count                : 0
[87267.815222]   .avg->runnable_avg_sum         : 23
[87267.815279]   .avg->runnable_avg_period      : 46829
[87267.815338] 
[87267.815338] rt_rq[4]:/
[87267.815442]   .rt_nr_running                 : 0
[87267.815500]   .rt_throttled                  : 0
[87267.815558]   .rt_time                       : 0.000000
[87267.815616]   .rt_runtime                    : 950.000000
[87267.815676] 
[87267.815676] runnable tasks:
[87267.815676]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.815676] ----------------------------------------------------------------------------------------------------------
[87267.816012]       watchdog/4    26       -10.044690         3   120       -10.044690         0.004927         0.001419 /
[87267.816134]      migration/4    27         0.000000     23830     0         0.000000       196.285647         0.000780 /
[87267.816256]      ksoftirqd/4    28    259610.671735     28861   120    259610.671735       527.447917  87262673.371052 /
[87267.816377]      kworker/4:0    29      4192.210855        17   120      4192.210855         0.065075    379696.592990 /
[87267.816498]     kworker/4:0H    30      1523.645610         6   100      1523.645610         0.031338      1029.397364 /
[87267.818006]        writeback   136        22.960481         2   100        22.960481         0.004223         0.003254 /
[87267.818128]           bioset   141        34.964477         2   100        34.964477         0.004505         0.003030 /
[87267.818249]          kblockd   145        46.967655         2   100        46.967655         0.003619         0.001358 /
[87267.818371]               md   368        58.972088         2   100        58.972088         0.007387         0.003668 /
[87267.818493]    fsnotify_mark   582      2185.586299        13   120      2185.586299         0.192703     32702.241129 /
[87267.818614]  acpi_thermal_pm   624       407.244379         2   100       407.244379         0.007738         0.008529 /
[87267.818736]    irq/41-mei_me   681         0.000000        17    49         0.000000         0.441160         0.000000 /
[87267.818857]        kpsmoused   693       431.260485         2   100       431.260485         0.007581         0.006449 /
[87267.818979]          deferwq   737       443.279025         2   100       443.279025         0.019332         0.004360 /
[87267.819101]        scsi_eh_0   882      1499.231159         3   120      1499.231159         0.089973         1.862072 /
[87267.819223]       scsi_tmf_0   883      1391.164627         2   100      1391.164627         0.049795         0.020592 /
[87267.819344]        scsi_eh_1   884      1499.229405         3   120      1499.229405         0.011514         1.603008 /
[87267.819466]       scsi_tmf_1   885      1415.178084         2   100      1415.178084         0.006754         0.028791 /
[87267.819587]        scsi_eh_2   886      1528.443311        18   120      1528.443311         5.211646       351.379493 /
[87267.819709]       scsi_tmf_2   887      1439.190265         2   100      1439.190265         0.006517         0.003752 /
[87267.819831]        scsi_eh_3   888      1528.519606        18   120      1528.519606         5.284053       351.522073 /
[87267.819952]       scsi_tmf_3   889      1463.202312         2   100      1463.202312         0.006019         0.003076 /
[87267.820073]       scsi_tmf_4   891      1487.213663         2   100      1487.213663         0.005891         0.002989 /
[87267.820195]       scsi_tmf_5   893      1511.224987         2   100      1511.224987         0.005902         0.003628 /
[87267.820316]     kworker/4:1H   911    259610.554576     72919   100    259610.554576       914.128539  87260324.211942 /
[87267.820438]           bioset   945      1605.583682         2   100      1605.583682         0.007440         0.004887 /
[87267.820561]           bioset  2294      2386.589214         2   100      2386.589214         0.024319         0.059852 /
[87267.820684]      kworker/4:2  2455    259611.253593    177772   120    259611.253593      4524.649288  87180777.783136 /
[87267.820806]            getty  4337         0.393671        99   120         0.393671         1.566937        53.568269 /autogroup-62
[87267.820931]    kworker/u16:4 26086    259611.150584     13651   120    259611.150584      1784.345961  34484578.935604 /
[87267.821054] 
[87267.821105] cpu#5, 3399.965 MHz
[87267.821160]   .nr_running                    : 0
[87267.821217]   .load                          : 0
[87267.821275]   .nr_switches                   : 778238
[87267.821334]   .nr_load_updates               : 220494
[87267.821392]   .nr_uninterruptible            : 21743
[87267.821451]   .next_balance                  : 4303.668962
[87267.821510]   .curr->pid                     : 0
[87267.821567]   .clock                         : 87265121.624457
[87267.821627]   .cpu_load[0]                   : 0
[87267.821684]   .cpu_load[1]                   : 0
[87267.821742]   .cpu_load[2]                   : 0
[87267.821800]   .cpu_load[3]                   : 0
[87267.821858]   .cpu_load[4]                   : 0
[87267.821915]   .yld_count                     : 0
[87267.821973]   .sched_count                   : 799832
[87267.822032]   .sched_goidle                  : 368841
[87267.822090]   .avg_idle                      : 1000000
[87267.822148]   .max_idle_balance_cost         : 500000
[87267.822207]   .ttwu_count                    : 394175
[87267.822265]   .ttwu_local                    : 247774
[87267.822324] 
[87267.822324] cfs_rq[5]:/
[87267.822428]   .exec_clock                    : 148149.143060
[87267.822488]   .MIN_vruntime                  : 0.000001
[87267.822546]   .min_vruntime                  : 245380.602523
[87267.822606]   .max_vruntime                  : 0.000001
[87267.822665]   .spread                        : 0.000000
[87267.822724]   .spread0                       : -243306.312869
[87267.822783]   .nr_spread_over                : 2240
[87267.822841]   .nr_running                    : 0
[87267.822899]   .load                          : 0
[87267.822956]   .runnable_load_avg             : 0
[87267.823014]   .blocked_load_avg              : 0
[87267.823071]   .tg_load_contrib               : 0
[87267.823129]   .tg_runnable_contrib           : 0
[87267.823187]   .tg_load_avg                   : 0
[87267.823244]   .tg->runnable_avg              : 896
[87267.823302]   .tg->cfs_bandwidth.timer_active: 0
[87267.823359]   .throttled                     : 0
[87267.823417]   .throttle_count                : 0
[87267.823475]   .avg->runnable_avg_sum         : 22
[87267.823532]   .avg->runnable_avg_period      : 48623
[87267.823591] 
[87267.823591] rt_rq[5]:/
[87267.823695]   .rt_nr_running                 : 0
[87267.823753]   .rt_throttled                  : 0
[87267.823810]   .rt_time                       : 0.000000
[87267.823869]   .rt_runtime                    : 950.000000
[87267.823928] 
[87267.823928] runnable tasks:
[87267.823928]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.823928] ----------------------------------------------------------------------------------------------------------
[87267.824265]       watchdog/5    31       -10.045188         3   120       -10.045188         0.004714         0.001506 /
[87267.824386]      migration/5    32         0.000000     21702     0         0.000000       179.689781         0.000842 /
[87267.824508]      ksoftirqd/5    33    245368.619029     13837   120    245368.619029       281.091931  87252760.696497 /
[87267.824630]      kworker/5:0    34       454.811485        14   120       454.811485         0.211779      1568.860178 /
[87267.824751]     kworker/5:0H    35       442.370868         6   100       442.370868         0.034114      1059.607306 /
[87267.824874]      kworker/5:1   475    245368.843379    151508   120    245368.843379      4054.176287  87258183.320170 /
[87267.824996]     kworker/5:1H   926    245368.602690     29133   100    245368.602690       249.822533  87257619.086295 /
[87267.825118]            udevd  1329       284.676600         4   120       284.676600         0.668455     44717.961520 /autogroup-4
[87267.825244]             cron  3691     14883.717943      3672   120     14883.717943       413.330236  87172798.347378 /autogroup-30
[87267.825369] 
[87267.825421] cpu#6, 3399.965 MHz
[87267.825476]   .nr_running                    : 0
[87267.825534]   .load                          : 0
[87267.825592]   .nr_switches                   : 819513
[87267.825650]   .nr_load_updates               : 243140
[87267.825708]   .nr_uninterruptible            : 26304
[87267.825767]   .next_balance                  : 4303.669006
[87267.825826]   .curr->pid                     : 0
[87267.825883]   .clock                         : 87265621.327316
[87267.825943]   .cpu_load[0]                   : 0
[87267.826001]   .cpu_load[1]                   : 0
[87267.826059]   .cpu_load[2]                   : 0
[87267.826116]   .cpu_load[3]                   : 0
[87267.826174]   .cpu_load[4]                   : 0
[87267.826232]   .yld_count                     : 0
[87267.826289]   .sched_count                   : 840912
[87267.826348]   .sched_goidle                  : 388939
[87267.826406]   .avg_idle                      : 1000000
[87267.826465]   .max_idle_balance_cost         : 500000
[87267.826523]   .ttwu_count                    : 405358
[87267.826581]   .ttwu_local                    : 266002
[87267.826640] 
[87267.826640] cfs_rq[6]:/
[87267.826744]   .exec_clock                    : 137484.084102
[87267.826804]   .MIN_vruntime                  : 0.000001
[87267.826863]   .min_vruntime                  : 249353.446860
[87267.826922]   .max_vruntime                  : 0.000001
[87267.826981]   .spread                        : 0.000000
[87267.827040]   .spread0                       : -239333.468532
[87267.827099]   .nr_spread_over                : 2640
[87267.827157]   .nr_running                    : 0
[87267.827215]   .load                          : 0
[87267.827272]   .runnable_load_avg             : 0
[87267.827330]   .blocked_load_avg              : 0
[87267.827387]   .tg_load_contrib               : 0
[87267.827445]   .tg_runnable_contrib           : 0
[87267.827503]   .tg_load_avg                   : 0
[87267.827560]   .tg->runnable_avg              : 896
[87267.827618]   .tg->cfs_bandwidth.timer_active: 0
[87267.827676]   .throttled                     : 0
[87267.827733]   .throttle_count                : 0
[87267.827791]   .avg->runnable_avg_sum         : 21
[87267.827849]   .avg->runnable_avg_period      : 48485
[87267.827908] 
[87267.827908] rt_rq[6]:/
[87267.828013]   .rt_nr_running                 : 0
[87267.828075]   .rt_throttled                  : 0
[87267.828134]   .rt_time                       : 0.000000
[87267.828193]   .rt_runtime                    : 950.000000
[87267.828253] 
[87267.828253] runnable tasks:
[87267.828253]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.828253] ----------------------------------------------------------------------------------------------------------
[87267.829972]         kthreadd     2    249323.455151       238   120    249323.455151        11.448541  87215934.481100 /
[87267.830095]       watchdog/6    36        -8.976424     21833     0        -8.976424       235.061251        19.314532 /
[87267.830217]      migration/6    37         0.000000     26320     0         0.000000       217.153967         0.000798 /
[87267.830339]      ksoftirqd/6    38    249341.156464     12317   120    249341.156464       257.159117  87252853.044653 /
[87267.830460]      kworker/6:0    39      3951.025187        16   120      3951.025187         0.043594    336694.944578 /
[87267.830582]     kworker/6:0H    40      2662.999625         6   100      2662.999625         0.026328      1046.121476 /
[87267.830705]          ata_sff   847      2586.713734         2   100      2586.713734         0.009308         0.005743 /
[87267.830826]     kworker/6:1H   927    247835.234523     23919   100    247835.234523       206.050493  87073542.420833 /
[87267.830948]        md0_raid1   946    247337.606387       117   120    247337.606387         3.022457  87035764.705532 /
[87267.831070]           bioset   953      2735.385485         2   100      2735.385485         0.008099         0.020410 /
[87267.831192]           bioset   963      2771.485863         2   100      2771.485863         0.007789         0.025904 /
[87267.831313]  ext4-rsv-conver   979      2831.815867         2   100      2831.815867         0.034319         0.022279 /
[87267.831435]      kworker/6:2  1559    249341.715805    147543   120    249341.715805      3771.476984  87225846.291012 /
[87267.831558]    btrfs-cleaner  2436    249337.604382     20502   120    249337.604382     11467.613580  87159197.645138 /
[87267.831680]            acpid  3315         0.043255        12   120         0.043255         1.153129  66873801.228581 /autogroup-10
[87267.831804]      dbus-daemon  3728         0.990857         1   120         0.990857         0.123294         0.000000 /autogroup-37
[87267.831930]    kworker/u16:1  6494    249347.453590         2   120    249347.453590         0.013475         0.004581 /
[87267.832052] 
[87267.832104] cpu#7, 3399.965 MHz
[87267.832159]   .nr_running                    : 0
[87267.832217]   .load                          : 0
[87267.832274]   .nr_switches                   : 798045
[87267.832333]   .nr_load_updates               : 233753
[87267.832392]   .nr_uninterruptible            : 22034
[87267.832450]   .next_balance                  : 4303.669056
[87267.832510]   .curr->pid                     : 0
[87267.832567]   .clock                         : 87266121.031453
[87267.832627]   .cpu_load[0]                   : 0
[87267.832684]   .cpu_load[1]                   : 0
[87267.832742]   .cpu_load[2]                   : 0
[87267.832800]   .cpu_load[3]                   : 0
[87267.832857]   .cpu_load[4]                   : 0
[87267.832915]   .yld_count                     : 0
[87267.832972]   .sched_count                   : 819484
[87267.833030]   .sched_goidle                  : 382373
[87267.833089]   .avg_idle                      : 1000000
[87267.833147]   .max_idle_balance_cost         : 500000
[87267.833205]   .ttwu_count                    : 383175
[87267.833264]   .ttwu_local                    : 244516
[87267.833322] 
[87267.833322] cfs_rq[7]:/
[87267.833426]   .exec_clock                    : 122816.211407
[87267.833486]   .MIN_vruntime                  : 0.000001
[87267.833545]   .min_vruntime                  : 238008.292355
[87267.833604]   .max_vruntime                  : 0.000001
[87267.833663]   .spread                        : 0.000000
[87267.833722]   .spread0                       : -250678.623037
[87267.833782]   .nr_spread_over                : 2872
[87267.833840]   .nr_running                    : 0
[87267.833898]   .load                          : 0
[87267.833956]   .runnable_load_avg             : 0
[87267.834013]   .blocked_load_avg              : 0
[87267.834071]   .tg_load_contrib               : 0
[87267.834128]   .tg_runnable_contrib           : 0
[87267.834185]   .tg_load_avg                   : 0
[87267.834243]   .tg->runnable_avg              : 896
[87267.834301]   .tg->cfs_bandwidth.timer_active: 0
[87267.834359]   .throttled                     : 0
[87267.834416]   .throttle_count                : 0
[87267.834474]   .avg->runnable_avg_sum         : 21
[87267.834532]   .avg->runnable_avg_period      : 48444
[87267.834590] 
[87267.834590] rt_rq[7]:/
[87267.834695]   .rt_nr_running                 : 0
[87267.834752]   .rt_throttled                  : 0
[87267.834810]   .rt_time                       : 0.000000
[87267.834869]   .rt_runtime                    : 950.000000
[87267.834929]
[87267.834929] runnable tasks:
[87267.834929]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[87267.834929] ----------------------------------------------------------------------------------------------------------
[87267.835263]             init     1        43.286684     17771   120        43.286684       869.906988  87262599.834105 /autogroup-2
[87267.835388]       watchdog/7    41        -8.979028     21833     0        -8.979028       216.465737         5.707540 /
[87267.835510]      migration/7    42         0.000000     22040     0         0.000000       184.328529         0.000916 /
[87267.835631]      ksoftirqd/7    43    237996.300378     11410   120    237996.300378       241.973448  87252627.933106 /
[87267.835752]      kworker/7:0    44    134214.978603        18   120    134214.978603         0.089056  51097629.915436 /
[87267.835874]     kworker/7:0H    45      5869.021873         6   100      5869.021873         0.123861     32818.205469 /
[87267.835997]          khelper    46        10.956527         2   100        10.956527         0.005862         0.003354 /
[87267.836119]            netns    47        22.959846         2   100        22.959846         0.003607         0.002265 /
[87267.836241]           crypto   143       107.180122         2   100       107.180122         0.004408         0.001428 /
[87267.836363]          kswapd0   514      5374.182685         3   120      5374.182685         0.012187        90.352928 /
[87267.836486]     kworker/7:1H  1235    237990.878644     17692   100    237990.878644       158.605713  87182695.092505 /
[87267.836608]       jbd2/md1-8  2287      6328.602132         2   120      6328.602132         0.027970         0.018151 /
[87267.836730]  ext4-rsv-conver  2288      6340.607217         2   100      6340.607217         0.005733         0.002394 /
[87267.836851]     btrfs-worker  2295      6352.628396         2   100      6352.628396         0.021802         0.004109 /
[87267.836972]  btrfs-worker-hi  2297      6376.682731         2   100      6376.682731         0.035374         0.017456 /
[87267.837094]   btrfs-delalloc  2298      6388.721769         2   100      6388.721769         0.039636         0.017114 /
[87267.837216]  btrfs-flush_del  2299      6400.747537         2   100      6400.747537         0.026344         0.004018 /
[87267.837337]      btrfs-cache  2300      6412.751434         2   100      6412.751434         0.004199         0.002292 /
[87267.837459]     btrfs-submit  2301      6424.756204         2   100      6424.756204         0.005087         0.001367 /
[87267.837581]      btrfs-fixup  2302      6436.780986         2   100      6436.780986         0.025346         0.014768 /
[87267.837702]      btrfs-endio  2303      6448.784516         2   100      6448.784516         0.003824         0.001421 /
[87267.837824]  btrfs-endio-met  2304      6460.787502         2   100      6460.787502         0.003293         0.001490 /
[87267.837946]  btrfs-endio-met  2305      6472.792163         2   100      6472.792163         0.004959         0.026636 /
[87267.838067]  btrfs-endio-rai  2306      6484.795416         2   100      6484.795416         0.003525         0.019310 /
[87267.838189]        btrfs-rmw  2307      6496.798345         2   100      6496.798345         0.003217         0.001403 /
[87267.838310]  btrfs-endio-wri  2308      6508.801140         2   100      6508.801140         0.003079         0.001467 /
[87267.838432]  btrfs-freespace  2309      6520.804016         2   100      6520.804016         0.003129         0.001513 /
[87267.838553]  btrfs-delayed-m  2310      6532.806861         2   100      6532.806861         0.003111         0.001441 /
[87267.838675]  btrfs-readahead  2311      6544.809670         2   100      6544.809670         0.003085         0.001391 /
[87267.838796]  btrfs-qgroup-re  2312      6556.812547         2   100      6556.812547         0.003116         0.001418 /
[87267.838917]            udevd  2748       849.732269         1   120       849.732269         0.134706         0.000000 /autogroup-4
[87267.839041]    ipv6_addrconf  2749      6820.437154         2   100      6820.437154         0.023515         0.024245 /
[87267.839164]      kworker/7:1 22165    237996.846231     57984   120    237996.846231      1807.100236  36165491.065710 /


-- 
Tomasz Chmielewski
http://wpkg.org
