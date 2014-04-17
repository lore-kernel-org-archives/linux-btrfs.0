Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18143 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751249AbaDQCXa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 22:23:30 -0400
Message-ID: <534F3B60.3090109@cn.fujitsu.com>
Date: Thu, 17 Apr 2014 10:24:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem hang when doing snapshot (3.15-rc1)
References: <20140416230511.1cbceb2c@virtall.com>
In-Reply-To: <20140416230511.1cbceb2c@virtall.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Apr 2014 23:05:11 +0100, Tomasz Chmielewski wrote:
> [120462.556106] kworker/u16:12  D ffff88081fa116c0     0  9916      2 0x00000000
> [120462.556160] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
> [120462.556208]  ffff88019e157ae8 0000000000000046 ffff88019e157a08 ffff8807e4d01830
> [120462.556296]  00000000000116c0 0000000000004000 ffffffff81613450 ffff8807e4d01830
> [120462.556386]  ffff88019e157ab8 ffffffffa02dc1f3 0000000000000000 0000000000000050
> [120462.556474] Call Trace:
> [120462.556521]  [<ffffffffa02dc1f3>] ? run_delalloc_range+0x1b1/0x2d7 [btrfs]
> [120462.556570]  [<ffffffff810b1d6e>] ? __lock_page+0x63/0x63
> [120462.556618]  [<ffffffff8139d724>] schedule+0x6a/0x6c
> [120462.556664]  [<ffffffff8139d7b0>] io_schedule+0x8a/0xc8
> [120462.556711]  [<ffffffff810b1d77>] sleep_on_page+0x9/0xd
> [120462.556758]  [<ffffffff8139db83>] __wait_on_bit_lock+0x43/0x8a
> [120462.556805]  [<ffffffff810b1a59>] ? find_get_pages_tag+0xe9/0x123
> [120462.556853]  [<ffffffff810b1d6c>] __lock_page+0x61/0x63
> [120462.556900]  [<ffffffff810684de>] ? wake_atomic_t_function+0x28/0x28
> [120462.556953]  [<ffffffffa02ef815>] extent_write_cache_pages.isra.28.constprop.45+0x120/0x2f6 [btrfs]
> [120462.557043]  [<ffffffff8105af63>] ? try_to_wake_up+0x211/0x222
> [120462.557095]  [<ffffffffa02efc79>] extent_writepages+0x46/0x57 [btrfs]
> [120462.557147]  [<ffffffffa02d8d16>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
> [120462.557198]  [<ffffffffa02d7e93>] btrfs_writepages+0x23/0x25 [btrfs]
> [120462.557246]  [<ffffffff810bb21e>] do_writepages+0x19/0x27
> [120462.557293]  [<ffffffff810b2c36>] __filemap_fdatawrite_range+0x4e/0x50
> [120462.557341]  [<ffffffff810b2ca6>] filemap_flush+0x17/0x19
> [120462.557391]  [<ffffffffa02da367>] btrfs_run_delalloc_work+0x2d/0x64 [btrfs]
> [120462.557445]  [<ffffffffa02fb60a>] normal_work_helper+0xba/0x16f [btrfs]
> [120462.557493]  [<ffffffff8104bbb1>] process_one_work+0x1be/0x2f4
> [120462.557540]  [<ffffffff8104c14a>] worker_thread+0x1cd/0x2c4
> [120462.557588]  [<ffffffff8139fbf9>] ? _raw_spin_unlock_irqrestore+0x9/0xb
> [120462.557636]  [<ffffffff8104bf7d>] ? rescuer_thread+0x26c/0x26c
> [120462.557683]  [<ffffffff81050eb2>] kthread+0xcd/0xd5
> [120462.557730]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.557778]  [<ffffffff813a077c>] ret_from_fork+0x7c/0xb0
> [120462.557826]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.557874] kworker/u16:13  D ffff88081fa516c0     0  9917      2 0x00000000
> [120462.557928] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
> [120462.557975]  ffff8804c6aed758 0000000000000046 ffff8804c6aed728 ffff8807e4d04890
> [120462.558064]  00000000000116c0 0000000000004000 ffff8807f4128000 ffff8807e4d04890
> [120462.558153]  00000002c6aed698 0000000a007aeba8 0000000000000000 ffff8807f11fa9f8
> [120462.558242] Call Trace:
> [120462.559395]  [<ffffffff811a6156>] ? cfq_prio_tree_add+0xa1/0xa6
> [120462.559443]  [<ffffffff811a86f0>] ? cfq_add_rq_rb+0xaa/0xbc
> [120462.559497]  [<ffffffffa0020798>] ? scsi_request_fn+0x31/0x4dc [scsi_mod]
> [120462.559546]  [<ffffffff8107a8af>] ? ktime_get_ts+0x50/0xb7
> [120462.559594]  [<ffffffff810a32db>] ? delayacct_end+0x77/0x82
> [120462.559641]  [<ffffffff810b1d6e>] ? __lock_page+0x63/0x63
> [120462.559688]  [<ffffffff8139d724>] schedule+0x6a/0x6c
> [120462.559734]  [<ffffffff8139d7b0>] io_schedule+0x8a/0xc8
> [120462.559780]  [<ffffffff810b1d77>] sleep_on_page+0x9/0xd
> [120462.559827]  [<ffffffff8139db83>] __wait_on_bit_lock+0x43/0x8a
> [120462.559874]  [<ffffffff810b1d6c>] __lock_page+0x61/0x63
> [120462.559921]  [<ffffffff810684de>] ? wake_atomic_t_function+0x28/0x28
> [120462.559969]  [<ffffffff810b2064>] find_lock_entry+0x39/0x5d
> [120462.560016]  [<ffffffff810b2091>] find_lock_page+0x9/0x16

It is very strange that we should be blocked here. Could you tell me how to reproduce
this problem?

Thanks
Miao

> [120462.560063]  [<ffffffff810b281d>] find_or_create_page+0x2f/0x86
> [120462.560115]  [<ffffffffa0309cde>] io_ctl_prepare_pages+0x47/0x110 [btrfs]
> [120462.560168]  [<ffffffffa030c072>] __load_free_space_cache+0x1cc/0x547 [btrfs]
> [120462.560260]  [<ffffffffa030a78e>] ? __lookup_free_space_inode+0xde/0x112 [btrfs]
> [120462.560352]  [<ffffffffa030c4c0>] load_free_space_cache+0xd3/0x174 [btrfs]
> [120462.560404]  [<ffffffffa02bfcf2>] cache_block_group+0x1b5/0x326 [btrfs]
> [120462.560452]  [<ffffffff81068484>] ? __wake_up_sync+0xd/0xd
> [120462.560503]  [<ffffffffa02c5335>] find_free_extent.isra.81+0x31e/0x7bc [btrfs]
> [120462.560595]  [<ffffffffa02ebd46>] ? free_extent_state.part.32+0x30/0x35 [btrfs]
> [120462.560687]  [<ffffffffa02c5841>] btrfs_reserve_extent+0x6e/0x10f [btrfs]
> [120462.560740]  [<ffffffffa02db568>] cow_file_range+0x1af/0x3e4 [btrfs]
> [120462.560791]  [<ffffffffa02dc41f>] submit_compressed_extents+0x106/0x421 [btrfs]
> [120462.560882]  [<ffffffffa02dc7bd>] async_cow_submit+0x83/0x88 [btrfs]
> [120462.560935]  [<ffffffffa02fb65e>] normal_work_helper+0x10e/0x16f [btrfs]
> [120462.560983]  [<ffffffff8104bbb1>] process_one_work+0x1be/0x2f4
> [120462.561030]  [<ffffffff8104c14a>] worker_thread+0x1cd/0x2c4
> [120462.561077]  [<ffffffff8104bf7d>] ? rescuer_thread+0x26c/0x26c
> [120462.561125]  [<ffffffff81050eb2>] kthread+0xcd/0xd5
> [120462.561171]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.561219]  [<ffffffff813a077c>] ret_from_fork+0x7c/0xb0
> [120462.561267]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.561315] btrfs           D ffff88081fbd16c0     0  9979   9946 0x00000000
> [120462.561364]  ffff88063660d9a8 0000000000000082 ffff88063660d8e8 ffff8807eab30000
> [120462.561453]  00000000000116c0 0000000000004000 ffff8807f4141830 ffff8807eab30000
> [120462.561542]  000080501fa916c0 0000000000281250 0000000000000000 ffffffff817e0d00
> [120462.561631] Call Trace:
> [120462.561674]  [<ffffffff810e4bde>] ? alloc_pages_current+0xc1/0xde
> [120462.561722]  [<ffffffff810e870a>] ? new_slab+0x238/0x268
> [120462.561769]  [<ffffffff8139d724>] schedule+0x6a/0x6c
> [120462.561815]  [<ffffffff8139c9f6>] schedule_timeout+0x26/0x198
> [120462.561862]  [<ffffffff8105afb3>] ? wake_up_process+0x30/0x34
> [120462.561909]  [<ffffffff8104ab3a>] ? wake_up_worker+0x1f/0x21
> [120462.561956]  [<ffffffff8139df05>] wait_for_common+0x10d/0x13e
> [120462.562003]  [<ffffffff8105af74>] ? try_to_wake_up+0x222/0x222
> [120462.562051]  [<ffffffff8139df4e>] wait_for_completion+0x18/0x1a
> [120462.562102]  [<ffffffffa02e2a19>] btrfs_wait_and_free_delalloc_work+0x13/0x26 [btrfs]
> [120462.562195]  [<ffffffffa02e2be9>] __start_delalloc_inodes+0x1bd/0x237 [btrfs]
> [120462.562286]  [<ffffffffa02e2c92>] btrfs_start_delalloc_inodes+0x2f/0xfc [btrfs]
> [120462.562374]  [<ffffffff8106809f>] ? finish_wait+0x5b/0x64
> [120462.562425]  [<ffffffffa02fd978>] btrfs_mksubvol.isra.64+0x197/0x400 [btrfs]
> [120462.562474]  [<ffffffff81068484>] ? __wake_up_sync+0xd/0xd
> [120462.562525]  [<ffffffffa02fdd30>] btrfs_ioctl_snap_create_transid+0x14f/0x180 [btrfs]
> [120462.562613]  [<ffffffff810ebeaa>] ? __kmalloc_track_caller+0x45/0x158
> [120462.562665]  [<ffffffffa02fde8f>] btrfs_ioctl_snap_create_v2+0xc2/0x115 [btrfs]
> [120462.562753]  [<ffffffff810f1c41>] ? __mem_cgroup_commit_charge.constprop.56+0x20e/0x224
> [120462.562846]  [<ffffffffa0300705>] btrfs_ioctl+0x6a3/0x222e [btrfs]
> [120462.562894]  [<ffffffff810cf415>] ? handle_mm_fault+0x430/0x9d7
> [120462.562942]  [<ffffffff8102f720>] ? __do_page_fault+0x36c/0x41e
> [120462.562990]  [<ffffffff81108465>] do_vfs_ioctl+0x3f2/0x43c
> [120462.563037]  [<ffffffff811084fd>] SyS_ioctl+0x4e/0x7d
> [120462.563083]  [<ffffffff8102f7fd>] ? do_page_fault+0xc/0xf
> [120462.563130]  [<ffffffff813a0822>] system_call_fastpath+0x16/0x1b
> [120462.563177] kworker/u16:16  D ffff88081fbd16c0     0  9981      2 0x00000000
> [120462.563230] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
> [120462.563278]  ffff8806c869dae8 0000000000000046 ffff8806c869da08 ffff8804deec4890
> [120462.563366]  00000000000116c0 0000000000004000 ffff8807f4141830 ffff8804deec4890
> [120462.563455]  ffff8806c869dab8 ffffffffa02dc1f3 0000000000000000 0000000000000050
> [120462.563544] Call Trace:
> [120462.563591]  [<ffffffffa02dc1f3>] ? run_delalloc_range+0x1b1/0x2d7 [btrfs]
> [120462.563640]  [<ffffffff810b1d6e>] ? __lock_page+0x63/0x63
> [120462.563687]  [<ffffffff8139d724>] schedule+0x6a/0x6c
> [120462.563733]  [<ffffffff8139d7b0>] io_schedule+0x8a/0xc8
> [120462.563780]  [<ffffffff810b1d77>] sleep_on_page+0x9/0xd
> [120462.563827]  [<ffffffff8139db83>] __wait_on_bit_lock+0x43/0x8a
> [120462.563874]  [<ffffffff810b1a59>] ? find_get_pages_tag+0xe9/0x123
> [120462.563922]  [<ffffffff810b1d6c>] __lock_page+0x61/0x63
> [120462.563969]  [<ffffffff810684de>] ? wake_atomic_t_function+0x28/0x28
> [120462.564021]  [<ffffffffa02ef815>] extent_write_cache_pages.isra.28.constprop.45+0x120/0x2f6 [btrfs]
> [120462.564112]  [<ffffffff81194175>] ? blk_finish_plug+0x11/0x32
> [120462.564164]  [<ffffffffa02efc79>] extent_writepages+0x46/0x57 [btrfs]
> [120462.564217]  [<ffffffffa02d8d16>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
> [120462.564268]  [<ffffffffa02d7e93>] btrfs_writepages+0x23/0x25 [btrfs]
> [120462.564317]  [<ffffffff810bb21e>] do_writepages+0x19/0x27
> [120462.564364]  [<ffffffff810b2c36>] __filemap_fdatawrite_range+0x4e/0x50
> [120462.564412]  [<ffffffff810b2ca6>] filemap_flush+0x17/0x19
> [120462.564480]  [<ffffffffa02da378>] btrfs_run_delalloc_work+0x3e/0x64 [btrfs]
> [120462.564533]  [<ffffffffa02fb60a>] normal_work_helper+0xba/0x16f [btrfs]
> [120462.564581]  [<ffffffff8104bbb1>] process_one_work+0x1be/0x2f4
> [120462.564628]  [<ffffffff8104c14a>] worker_thread+0x1cd/0x2c4
> [120462.564675]  [<ffffffff8104bf7d>] ? rescuer_thread+0x26c/0x26c
> [120462.564723]  [<ffffffff81050eb2>] kthread+0xcd/0xd5
> [120462.564770]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.564818]  [<ffffffff813a077c>] ret_from_fork+0x7c/0xb0
> [120462.564865]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.564913] kworker/u16:20  D ffff88081fad16c0     0  9984      2 0x00000000
> [120462.564968] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
> [120462.565016]  ffff8807aebb1ae8 0000000000000046 ffff8807aebb1a08 ffff88000d520000
> [120462.565105]  00000000000116c0 0000000000004000 ffff8807f412b060 ffff88000d520000
> [120462.565194]  ffff8807aebb1ab8 ffffffffa02dc1f3 0000000000000000 0000000000000050
> [120462.565283] Call Trace:
> [120462.565330]  [<ffffffffa02dc1f3>] ? run_delalloc_range+0x1b1/0x2d7 [btrfs]
> [120462.565379]  [<ffffffff810b1d6e>] ? __lock_page+0x63/0x63
> [120462.565426]  [<ffffffff8139d724>] schedule+0x6a/0x6c
> [120462.565472]  [<ffffffff8139d7b0>] io_schedule+0x8a/0xc8
> [120462.565518]  [<ffffffff810b1d77>] sleep_on_page+0x9/0xd
> [120462.565565]  [<ffffffff8139db83>] __wait_on_bit_lock+0x43/0x8a
> [120462.565612]  [<ffffffff810b1a59>] ? find_get_pages_tag+0xe9/0x123
> [120462.565660]  [<ffffffff810b1d6c>] __lock_page+0x61/0x63
> [120462.565707]  [<ffffffff810684de>] ? wake_atomic_t_function+0x28/0x28
> [120462.565760]  [<ffffffffa02ef815>] extent_write_cache_pages.isra.28.constprop.45+0x120/0x2f6 [btrfs]
> [120462.565850]  [<ffffffff81194175>] ? blk_finish_plug+0x11/0x32
> [120462.565901]  [<ffffffffa02efc79>] extent_writepages+0x46/0x57 [btrfs]
> [120462.565953]  [<ffffffffa02d8d16>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
> [120462.566004]  [<ffffffffa02d7e93>] btrfs_writepages+0x23/0x25 [btrfs]
> [120462.566053]  [<ffffffff810bb21e>] do_writepages+0x19/0x27
> [120462.566100]  [<ffffffff810b2c36>] __filemap_fdatawrite_range+0x4e/0x50
> [120462.566148]  [<ffffffff810b2ca6>] filemap_flush+0x17/0x19
> [120462.566198]  [<ffffffffa02da378>] btrfs_run_delalloc_work+0x3e/0x64 [btrfs]
> [120462.566251]  [<ffffffffa02fb60a>] normal_work_helper+0xba/0x16f [btrfs]
> [120462.566299]  [<ffffffff8104bbb1>] process_one_work+0x1be/0x2f4
> [120462.566347]  [<ffffffff8104c14a>] worker_thread+0x1cd/0x2c4
> [120462.566394]  [<ffffffff8104bf7d>] ? rescuer_thread+0x26c/0x26c
> [120462.566441]  [<ffffffff81050eb2>] kthread+0xcd/0xd5
> [120462.566487]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.566536]  [<ffffffff813a077c>] ret_from_fork+0x7c/0xb0
> [120462.566583]  [<ffffffff81050de5>] ? kthread_freezable_should_stop+0x43/0x43
> [120462.566632] Sched Debug Version: v0.11, 3.15.0-rc1 #1
> [120462.566678] ktime                                   : 120533602.221923
> [120462.566726] sched_clk                               : 120462566.632152
> [120462.566773] cpu_clk                                 : 120462566.632175
> [120462.566821] jiffies                                 : 4306990657
> [120462.566867] sched_clock_stable()                    : 1
> [120462.566913] 
> [120462.566954] sysctl_sched
> [120462.566997]   .sysctl_sched_latency                    : 24.000000
> [120462.567044]   .sysctl_sched_min_granularity            : 3.000000
> [120462.567091]   .sysctl_sched_wakeup_granularity         : 4.000000
> [120462.567137]   .sysctl_sched_child_runs_first           : 0
> [120462.567184]   .sysctl_sched_features                   : 11899
> [120462.567230]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [120462.567277] 
> [120462.567319] cpu#0, 3399.717 MHz
> [120462.567362]   .nr_running                    : 0
> [120462.567407]   .load                          : 0
> [120462.567452]   .nr_switches                   : 11012437
> [120462.567498]   .nr_load_updates               : 1767123
> [120462.567544]   .nr_uninterruptible            : -53616
> [120462.567589]   .next_balance                  : 4306.990622
> [120462.567635]   .curr->pid                     : 0
> [120462.567680]   .clock                         : 120462564.437764
> [120462.567727]   .cpu_load[0]                   : 0
> [120462.567772]   .cpu_load[1]                   : 0
> [120462.567817]   .cpu_load[2]                   : 0
> [120462.567862]   .cpu_load[3]                   : 0
> [120462.569016]   .cpu_load[4]                   : 0
> [120462.569061]   .yld_count                     : 0
> [120462.569106]   .sched_count                   : 11041407
> [120462.569151]   .sched_goidle                  : 4957096
> [120462.569197]   .avg_idle                      : 878784
> [120462.569242]   .max_idle_balance_cost         : 500000
> [120462.569288]   .ttwu_count                    : 7666920
> [120462.569334]   .ttwu_local                    : 4334817
> [120462.569380] 
> [120462.569380] cfs_rq[0]:/autogroup-37365
> [120462.569465]   .exec_clock                    : 17.691047
> [120462.569512]   .MIN_vruntime                  : 0.000001
> [120462.569557]   .min_vruntime                  : 16.642471
> [120462.569603]   .max_vruntime                  : 0.000001
> [120462.569649]   .spread                        : 0.000000
> [120462.569695]   .spread0                       : -1351590.323931
> [120462.569742]   .nr_spread_over                : 0
> [120462.569787]   .nr_running                    : 0
> [120462.569832]   .load                          : 0
> [120462.569878]   .runnable_load_avg             : 0
> [120462.569923]   .blocked_load_avg              : 1
> [120462.569968]   .tg_load_contrib               : 1
> [120462.570012]   .tg_runnable_contrib           : 1
> [120462.570057]   .tg_load_avg                   : 1
> [120462.570102]   .tg->runnable_avg              : 1
> [120462.570147]   .tg->cfs_bandwidth.timer_active: 0
> [120462.570192]   .throttled                     : 0
> [120462.570237]   .throttle_count                : 0
> [120462.570283]   .se->exec_start                : 120462542.607867
> [120462.570329]   .se->vruntime                  : 1351595.069864
> [120462.570376]   .se->sum_exec_runtime          : 17.691047
> [120462.570422]   .se->statistics.wait_start     : 0.000000
> [120462.570468]   .se->statistics.sleep_start    : 0.000000
> [120462.570513]   .se->statistics.block_start    : 0.000000
> [120462.570559]   .se->statistics.sleep_max      : 0.000000
> [120462.570605]   .se->statistics.block_max      : 0.000000
> [120462.570651]   .se->statistics.exec_max       : 0.741716
> [120462.570697]   .se->statistics.slice_max      : 0.000000
> [120462.570743]   .se->statistics.wait_max       : 0.027798
> [120462.570788]   .se->statistics.wait_sum       : 0.027798
> [120462.570834]   .se->statistics.wait_count     : 279
> [120462.570880]   .se->load.weight               : 2
> [120462.570925]   .se->avg.runnable_avg_sum      : 63
> [120462.570970]   .se->avg.runnable_avg_period   : 48078
> [120462.571015]   .se->avg.load_avg_contrib      : 0
> [120462.571060]   .se->avg.decay_count           : 114882033
> [120462.571107] 
> [120462.571107] cfs_rq[0]:/
> [120462.571190]   .exec_clock                    : 1305812.087217
> [120462.571236]   .MIN_vruntime                  : 0.000001
> [120462.571282]   .min_vruntime                  : 1351606.966402
> [120462.571329]   .max_vruntime                  : 0.000001
> [120462.571374]   .spread                        : 0.000000
> [120462.571420]   .spread0                       : 0.000000
> [120462.571466]   .nr_spread_over                : 3757
> [120462.571511]   .nr_running                    : 0
> [120462.571556]   .load                          : 0
> [120462.571601]   .runnable_load_avg             : 0
> [120462.571646]   .blocked_load_avg              : 0
> [120462.571691]   .tg_load_contrib               : 0
> [120462.571736]   .tg_runnable_contrib           : 371
> [120462.571781]   .tg_load_avg                   : 867
> [120462.571826]   .tg->runnable_avg              : 392
> [120462.571872]   .tg->cfs_bandwidth.timer_active: 0
> [120462.571917]   .throttled                     : 0
> [120462.571962]   .throttle_count                : 0
> [120462.572007]   .avg->runnable_avg_sum         : 17045
> [120462.572052]   .avg->runnable_avg_period      : 47019
> [120462.572099] 
> [120462.572099] rt_rq[0]:/
> [120462.572182]   .rt_nr_running                 : 0
> [120462.572227]   .rt_throttled                  : 0
> [120462.572272]   .rt_time                       : 0.000000
> [120462.572318]   .rt_runtime                    : 950.000000
> [120462.572364] 
> [120462.572364] runnable tasks:
> [120462.572364]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.572364] ----------------------------------------------------------------------------------------------------------
> [120462.572628]             init     1        93.433675     25896   120        93.433675      1229.350610 120458806.664929 /autogroup-2
> [120462.572724]         kthreadd     2   1272995.464611       387   120   1272995.464611        43.520300 100201585.089764 /
> [120462.572818]      ksoftirqd/0     3   1351595.011558     98750   120   1351595.011558      3492.340151 120446280.862349 /
> [120462.572912]     kworker/0:0H     5       852.034279         5   100       852.034279         0.034465      1124.300055 /
> [120462.573006]      migration/0     9         0.000000       531     0         0.000000      1304.942300         0.000831 /
> [120462.573100]       watchdog/0    10       -11.813802     30143     0       -11.813802       439.212883        95.065178 /
> [120462.573194]            khubd   363      1780.671708        62   120      1780.671708         3.170152     34053.299892 /
> [120462.573289]    fsnotify_mark   582      1569.312659        15   120      1569.312659         0.207655     33056.934548 /
> [120462.573382]      kworker/0:1   610   1351595.092200    980390   120   1351595.092200     37673.142334 120387515.196997 /
> [120462.573476]      kworker/0:2   696      2175.221584         5   120      2175.221584         0.039476     70531.059055 /
> [120462.573570]        scsi_eh_5   901       851.644868        18   120       851.644868         5.007677       350.567745 /
> [120462.573664]     kworker/0:1H   917   1351594.966981    845136   100   1351594.966981     35634.479552 120416254.780135 /
> [120462.573759]        md2_raid1   976   1351595.050928     74214   120   1351595.050928      2373.890406 120457446.616287 /
> [120462.573852]       jbd2/md2-8   992   1351592.044364     37202   120   1351592.044364      2007.652169 120457472.231339 /
> [120462.573947]             sshd  2885       668.008849      4349   120       668.008849       684.247236 120318799.949983 /autogroup-6
> [120462.574042]         rsyslogd  3250       601.871635        22   120       601.871635         2.443461  64451038.144941 /autogroup-8
> [120462.574137]          apache2  3560       494.628186    120344   120       494.628186      2331.530350 120385427.175166 /autogroup-29
> [120462.574232]            mdadm  4007         0.344821       121   120         0.344821        20.434944 119940847.229429 /autogroup-47
> [120462.574328]            getty  4332         0.021717        88   120         0.021717         2.220599        61.971334 /autogroup-64
> [120462.574423]          apache2 24650       482.484885      3185   120       482.484885        46.334739 111964610.164022 /autogroup-29
> [120462.574518]  snapbackup-run- 24057    449854.355519        17   120    449854.355519         4.023521   7643083.045382 /autogroup-14319
> [120462.574614]    kworker/u16:8   982   1067683.049558     25219   120   1067683.049558      8249.805152   3879409.996652 /
> [120462.574708]    kworker/u17:3  5192   1067840.769563       576   100   1067840.769563       340.644750   2320496.499492 /
> [120462.574802]   kworker/u16:12  9916   1067695.029241       208   120   1067695.029241        47.349037     70587.410364 /
> [120462.574896]             sshd 23545        16.642471       354   120        16.642471        39.957828     70946.764104 /autogroup-37365
> [120462.574992] 
> [120462.575033] cpu#1, 3399.717 MHz
> [120462.575076]   .nr_running                    : 1
> [120462.575121]   .load                          : 1024
> [120462.575166]   .nr_switches                   : 6281843
> [120462.575212]   .nr_load_updates               : 1194415
> [120462.575258]   .nr_uninterruptible            : -16335
> [120462.575303]   .next_balance                  : 4306.990632
> [120462.575350]   .curr->pid                     : 23547
> [120462.575395]   .clock                         : 120462542.564300
> [120462.575442]   .cpu_load[0]                   : 0
> [120462.575487]   .cpu_load[1]                   : 0
> [120462.575532]   .cpu_load[2]                   : 0
> [120462.575577]   .cpu_load[3]                   : 0
> [120462.575622]   .cpu_load[4]                   : 0
> [120462.575667]   .yld_count                     : 0
> [120462.575712]   .sched_count                   : 6311392
> [120462.575758]   .sched_goidle                  : 2902393
> [120462.575803]   .avg_idle                      : 1000000
> [120462.575849]   .max_idle_balance_cost         : 500000
> [120462.575894]   .ttwu_count                    : 2600843
> [120462.575940]   .ttwu_local                    : 1232756
> [120462.575986] 
> [120462.575986] cfs_rq[1]:/autogroup-37366
> [120462.576070]   .exec_clock                    : 3.840899
> [120462.576116]   .MIN_vruntime                  : 0.000001
> [120462.576162]   .min_vruntime                  : 3.445772
> [120462.576207]   .max_vruntime                  : 0.000001
> [120462.576253]   .spread                        : 0.000000
> [120462.576299]   .spread0                       : -1351603.520630
> [120462.576346]   .nr_spread_over                : 0
> [120462.576391]   .nr_running                    : 1
> [120462.576436]   .load                          : 1024
> [120462.576481]   .runnable_load_avg             : 0
> [120462.576526]   .blocked_load_avg              : 0
> [120462.576571]   .tg_load_contrib               : 0
> [120462.576616]   .tg_runnable_contrib           : 0
> [120462.576661]   .tg_load_avg                   : 0
> [120462.576706]   .tg->runnable_avg              : 12
> [120462.576751]   .tg->cfs_bandwidth.timer_active: 0
> [120462.576796]   .throttled                     : 0
> [120462.576841]   .throttle_count                : 0
> [120462.576886]   .se->exec_start                : 120462542.564300
> [120462.576933]   .se->vruntime                  : 1085295.212661
> [120462.576980]   .se->sum_exec_runtime          : 3.840899
> [120462.577026]   .se->statistics.wait_start     : 0.000000
> [120462.577072]   .se->statistics.sleep_start    : 0.000000
> [120462.577118]   .se->statistics.block_start    : 0.000000
> [120462.577163]   .se->statistics.sleep_max      : 0.000000
> [120462.577209]   .se->statistics.block_max      : 0.000000
> [120462.578363]   .se->statistics.exec_max       : 0.436919
> [120462.578409]   .se->statistics.slice_max      : 0.000000
> [120462.578455]   .se->statistics.wait_max       : 0.004213
> [120462.578501]   .se->statistics.wait_sum       : 0.004213
> [120462.578547]   .se->statistics.wait_count     : 17
> [120462.578591]   .se->load.weight               : 1024
> [120462.578637]   .se->avg.runnable_avg_sum      : 27
> [120462.578682]   .se->avg.runnable_avg_period   : 48591
> [120462.578728]   .se->avg.load_avg_contrib      : 0
> [120462.578772]   .se->avg.decay_count           : 0
> [120462.578817] 
> [120462.578817] cfs_rq[1]:/
> [120462.578900]   .exec_clock                    : 1046908.585529
> [120462.578947]   .MIN_vruntime                  : 0.000001
> [120462.578992]   .min_vruntime                  : 1085300.452573
> [120462.579039]   .max_vruntime                  : 0.000001
> [120462.579084]   .spread                        : 0.000000
> [120462.579130]   .spread0                       : -266306.513829
> [120462.579176]   .nr_spread_over                : 2647
> [120462.579222]   .nr_running                    : 1
> [120462.579266]   .load                          : 1024
> [120462.579312]   .runnable_load_avg             : 0
> [120462.579357]   .blocked_load_avg              : 0
> [120462.579402]   .tg_load_contrib               : 0
> [120462.579447]   .tg_runnable_contrib           : 0
> [120462.579492]   .tg_load_avg                   : 867
> [120462.579537]   .tg->runnable_avg              : 322
> [120462.579582]   .tg->cfs_bandwidth.timer_active: 0
> [120462.579627]   .throttled                     : 0
> [120462.579672]   .throttle_count                : 0
> [120462.579717]   .avg->runnable_avg_sum         : 31
> [120462.579762]   .avg->runnable_avg_period      : 46840
> [120462.579808] 
> [120462.579808] rt_rq[1]:/
> [120462.579891]   .rt_nr_running                 : 0
> [120462.579936]   .rt_throttled                  : 0
> [120462.579981]   .rt_time                       : 0.000000
> [120462.580027]   .rt_runtime                    : 950.000000
> [120462.580073] 
> [120462.580073] runnable tasks:
> [120462.580073]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.580073] ----------------------------------------------------------------------------------------------------------
> [120462.580337]        rcu_sched     7   1085294.279880    964050   120   1085294.279880     31999.052410 120413526.372342 /
> [120462.580431]       watchdog/1    11        -4.045684         3   120        -4.045684         0.003957         0.000899 /
> [120462.580525]      migration/1    12         0.000000       385     0         0.000000      2542.571455         0.000803 /
> [120462.580619]      ksoftirqd/1    13   1085283.163926     74461   120   1085283.163926      1940.970001 120388375.186108 /
> [120462.580712]      kworker/1:0    14    980307.127203        17   120    980307.127203         0.047908 100501884.584953 /
> [120462.580806]     kworker/1:0H    15       485.456282         6   100       485.456282         0.022536      1124.338950 /
> [120462.580901]        scsi_eh_4   899       473.534241        18   120       473.534241         5.233796       350.802157 /
> [120462.580995]     kworker/1:1H   934   1085284.351810    145829   100   1085284.351810      2614.952621 120419476.978303 /
> [120462.581089]  btrfs-transacti  2435    815505.332078    119971   120    815505.332078     20590.737648  57073909.008778 /
> [120462.581183]    rs:main Q:Reg  3279       726.027817     78885   120       726.027817      6091.248117 120377430.751584 /autogroup-8
> [120462.581278]          apache2  3598       497.036079      2187   120       497.036079        33.742432 112853837.820134 /autogroup-29
> [120462.581373]          apache2  3599       493.510849       266   120       493.510849         5.650547 112853889.886336 /autogroup-29
> [120462.581468]          apache2  3600       494.300256       675   120       494.300256        11.581375 113635990.513482 /autogroup-29
> [120462.581563]          apache2  3601       493.513407      2125   120       493.513407        53.711047 113635940.144786 /autogroup-29
> [120462.581658]          apache2  3602       509.720222      1041   120       509.720222        28.244873 119902256.975704 /autogroup-29
> [120462.581753]            rsync  4152        -7.957385        14   139        -7.957385         1.530729  75699489.677837 /autogroup-54
> [120462.581848]           master  4267       135.036409      5904   120       135.036409       302.881879 120331721.656908 /autogroup-59
> [120462.581944]            getty  4329         0.805418       101   120         0.805418         4.298412        60.869536 /autogroup-61
> [120462.582039]          apache2 24646       509.722560      1615   120       509.722560        31.439296 111479519.718142 /autogroup-29
> [120462.582134]          apache2 24651       436.888569      1047   120       436.888569        16.263185  92875906.464523 /autogroup-29
> [120462.582228]               sh  5282    178944.548571         3   120    178944.548571         1.224847   7955463.908273 /autogroup-14319
> [120462.582324]   kworker/u16:24 23162    815511.631769     71415   120    815511.631769     25750.576180   8066941.663245 /
> [120462.582418]    kworker/u16:7  9271    828053.651156       421   120    828053.651156       102.306479   3629567.810733 /
> [120462.582512]   kworker/u16:13  9917    815516.395298       206   120    815516.395298        42.032801     70675.695114 /
> [120462.582606]      kworker/1:2  9933   1085288.554144     56199   120   1085288.554144       773.102983  20259772.807477 /
> [120462.582699] R           bash 23547         3.445772       224   120         3.445772        37.954238     70186.866043 /autogroup-37366
> [120462.582795] 
> [120462.582836] cpu#2, 3399.717 MHz
> [120462.582879]   .nr_running                    : 0
> [120462.582924]   .load                          : 0
> [120462.582969]   .nr_switches                   : 6779158
> [120462.583015]   .nr_load_updates               : 1253733
> [120462.583060]   .nr_uninterruptible            : -29107
> [120462.583106]   .next_balance                  : 4306.990608
> [120462.583152]   .curr->pid                     : 0
> [120462.583198]   .clock                         : 120462064.740197
> [120462.583244]   .cpu_load[0]                   : 0
> [120462.583289]   .cpu_load[1]                   : 0
> [120462.583334]   .cpu_load[2]                   : 0
> [120462.583379]   .cpu_load[3]                   : 0
> [120462.583424]   .cpu_load[4]                   : 0
> [120462.583469]   .yld_count                     : 0
> [120462.583514]   .sched_count                   : 6809115
> [120462.583560]   .sched_goidle                  : 3165039
> [120462.583606]   .avg_idle                      : 1000000
> [120462.583651]   .max_idle_balance_cost         : 500000
> [120462.583697]   .ttwu_count                    : 2487655
> [120462.583742]   .ttwu_local                    : 1196815
> [120462.583788] 
> [120462.583788] cfs_rq[2]:/autogroup-37366
> [120462.583872]   .exec_clock                    : 32.746783
> [120462.583918]   .MIN_vruntime                  : 0.000001
> [120462.583964]   .min_vruntime                  : 31.698207
> [120462.584010]   .max_vruntime                  : 0.000001
> [120462.584056]   .spread                        : 0.000000
> [120462.584102]   .spread0                       : -1351575.268195
> [120462.584148]   .nr_spread_over                : 0
> [120462.584193]   .nr_running                    : 0
> [120462.584238]   .load                          : 0
> [120462.584283]   .runnable_load_avg             : 0
> [120462.584328]   .blocked_load_avg              : 0
> [120462.584373]   .tg_load_contrib               : 0
> [120462.584418]   .tg_runnable_contrib           : 0
> [120462.584464]   .tg_load_avg                   : 0
> [120462.584509]   .tg->runnable_avg              : 12
> [120462.584554]   .tg->cfs_bandwidth.timer_active: 0
> [120462.584599]   .throttled                     : 0
> [120462.584644]   .throttle_count                : 0
> [120462.584689]   .se->exec_start                : 120462001.720806
> [120462.584736]   .se->vruntime                  : 1166816.506193
> [120462.584782]   .se->sum_exec_runtime          : 32.746783
> [120462.584828]   .se->statistics.wait_start     : 0.000000
> [120462.584874]   .se->statistics.sleep_start    : 0.000000
> [120462.584920]   .se->statistics.block_start    : 0.000000
> [120462.584966]   .se->statistics.sleep_max      : 0.000000
> [120462.585012]   .se->statistics.block_max      : 0.000000
> [120462.585057]   .se->statistics.exec_max       : 5.797270
> [120462.585103]   .se->statistics.slice_max      : 0.000000
> [120462.585149]   .se->statistics.wait_max       : 0.025292
> [120462.585195]   .se->statistics.wait_sum       : 0.252287
> [120462.585241]   .se->statistics.wait_count     : 198
> [120462.585286]   .se->load.weight               : 2
> [120462.585331]   .se->avg.runnable_avg_sum      : 45
> [120462.585376]   .se->avg.runnable_avg_period   : 47088
> [120462.585421]   .se->avg.load_avg_contrib      : 0
> [120462.585466]   .se->avg.decay_count           : 114881518
> [120462.585512] 
> [120462.585512] cfs_rq[2]:/
> [120462.585595]   .exec_clock                    : 1076826.701563
> [120462.585641]   .MIN_vruntime                  : 0.000001
> [120462.585687]   .min_vruntime                  : 1166821.415136
> [120462.585734]   .max_vruntime                  : 0.000001
> [120462.585779]   .spread                        : 0.000000
> [120462.585825]   .spread0                       : -184785.551266
> [120462.585872]   .nr_spread_over                : 2787
> [120462.585917]   .nr_running                    : 0
> [120462.585962]   .load                          : 0
> [120462.586007]   .runnable_load_avg             : 0
> [120462.586052]   .blocked_load_avg              : 0
> [120462.586097]   .tg_load_contrib               : 0
> [120462.586142]   .tg_runnable_contrib           : 3
> [120462.586187]   .tg_load_avg                   : 867
> [120462.586232]   .tg->runnable_avg              : 322
> [120462.586278]   .tg->cfs_bandwidth.timer_active: 0
> [120462.586323]   .throttled                     : 0
> [120462.586368]   .throttle_count                : 0
> [120462.586413]   .avg->runnable_avg_sum         : 161
> [120462.586459]   .avg->runnable_avg_period      : 47075
> [120462.586504] 
> [120462.586504] rt_rq[2]:/
> [120462.587695]   .rt_nr_running                 : 0
> [120462.587740]   .rt_throttled                  : 0
> [120462.587785]   .rt_time                       : 0.000000
> [120462.587831]   .rt_runtime                    : 950.000000
> [120462.587877] 
> [120462.587877] runnable tasks:
> [120462.587877]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.587877] ----------------------------------------------------------------------------------------------------------
> [120462.588141]       watchdog/2    16        -5.972755     30137     0        -5.972755       393.674184        73.544283 /
> [120462.588235]      migration/2    17         0.000000       354     0         0.000000      1648.226883         0.000850 /
> [120462.588328]      ksoftirqd/2    18   1166809.538516     61927   120   1166809.538516      1814.732825 120453868.483715 /
> [120462.588422]      kworker/2:0    19        -7.023268        13   120        -7.023268         0.026260       538.732921 /
> [120462.588515]     kworker/2:0H    20       489.416303         6   100       489.416303         0.026575      1111.070909 /
> [120462.588610]       khungtaskd   134   1166792.507801      1006   120   1166792.507801        70.115138 120408937.230833 /
> [120462.588704]          kswapd0   514   1159226.917658     32954   120   1159226.917658     41177.307289 119353869.782515 /
> [120462.588798]      kworker/2:1   614   1166811.775121    674866   120   1166811.775121     36904.063232 120402491.381145 /
> [120462.588892]     kworker/2:1H   935   1166806.051026    133602   100   1166806.051026      2370.278330 120405494.948597 /
> [120462.588986]            udevd  1344       105.540983         5   120       105.540983         0.675985     38668.699564 /autogroup-4
> [120462.589082]             qmgr  4286       106.512009       749   120       106.512009        85.224670 120244885.119971 /autogroup-59
> [120462.589178]          proftpd  4287       674.184115     16862   120       674.184115      1396.192409 120364022.549617 /autogroup-60
> [120462.589273]            getty  4333         0.837212        15   120         0.837212         1.361737        59.227254 /autogroup-65
> [120462.589369]    kworker/u16:4 30515   1166809.482042     41329   120   1166809.482042     12990.591731  68429224.011305 /
> [120462.589463]    kworker/u16:1  5845    958004.481239      1947   120    958004.481239       835.260955   1892732.475073 /
> [120462.589556]    kworker/u16:3  5892    958008.609048      6946   120    958008.609048      1050.578695   1662125.758913 /
> [120462.589651] 
> [120462.589692] cpu#3, 3399.717 MHz
> [120462.589735]   .nr_running                    : 0
> [120462.589780]   .load                          : 0
> [120462.589826]   .nr_switches                   : 6302421
> [120462.589871]   .nr_load_updates               : 1140402
> [120462.589917]   .nr_uninterruptible            : -33674
> [120462.589962]   .next_balance                  : 4306.990610
> [120462.590008]   .curr->pid                     : 0
> [120462.590053]   .clock                         : 120462084.722986
> [120462.590100]   .cpu_load[0]                   : 0
> [120462.590145]   .cpu_load[1]                   : 0
> [120462.590190]   .cpu_load[2]                   : 0
> [120462.590235]   .cpu_load[3]                   : 0
> [120462.590280]   .cpu_load[4]                   : 0
> [120462.590324]   .yld_count                     : 0
> [120462.590370]   .sched_count                   : 6332622
> [120462.590415]   .sched_goidle                  : 2941058
> [120462.590461]   .avg_idle                      : 1000000
> [120462.590506]   .max_idle_balance_cost         : 500000
> [120462.590552]   .ttwu_count                    : 2436759
> [120462.590597]   .ttwu_local                    : 1119584
> [120462.590643] 
> [120462.590643] cfs_rq[3]:/
> [120462.590726]   .exec_clock                    : 956008.917634
> [120462.590773]   .MIN_vruntime                  : 0.000001
> [120462.590819]   .min_vruntime                  : 1007217.563344
> [120462.590865]   .max_vruntime                  : 0.000001
> [120462.590911]   .spread                        : 0.000000
> [120462.590957]   .spread0                       : -344389.403058
> [120462.591003]   .nr_spread_over                : 2970
> [120462.591049]   .nr_running                    : 0
> [120462.591093]   .load                          : 0
> [120462.591139]   .runnable_load_avg             : 0
> [120462.591183]   .blocked_load_avg              : 0
> [120462.591228]   .tg_load_contrib               : 0
> [120462.591274]   .tg_runnable_contrib           : 3
> [120462.591319]   .tg_load_avg                   : 867
> [120462.591364]   .tg->runnable_avg              : 322
> [120462.591409]   .tg->cfs_bandwidth.timer_active: 0
> [120462.591454]   .throttled                     : 0
> [120462.591499]   .throttle_count                : 0
> [120462.591544]   .avg->runnable_avg_sum         : 153
> [120462.591589]   .avg->runnable_avg_period      : 46342
> [120462.591635] 
> [120462.591635] rt_rq[3]:/
> [120462.591717]   .rt_nr_running                 : 0
> [120462.591762]   .rt_throttled                  : 0
> [120462.591807]   .rt_time                       : 0.000000
> [120462.591853]   .rt_runtime                    : 950.000000
> [120462.591899] 
> [120462.591899] runnable tasks:
> [120462.591899]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.591899] ----------------------------------------------------------------------------------------------------------
> [120462.592163]           rcu_bh     8      1974.891318         5   120      1974.891318         0.087151    335524.186282 /
> [120462.592257]       watchdog/3    21        -7.045561         3   120        -7.045561         0.004108         0.001496 /
> [120462.592351]      migration/3    22         0.000000       382     0         0.000000       356.234478         0.000833 /
> [120462.592445]      ksoftirqd/3    23   1007205.593864     61599   120   1007205.593864      1576.057022 120438111.793910 /
> [120462.592539]      kworker/3:0    24       -10.016257        13   120       -10.016257         0.033271       525.259972 /
> [120462.592633]     kworker/3:0H    25       411.345586         6   100       411.345586         0.024210      1096.987089 /
> [120462.592728]      kworker/3:1   616   1007209.411476    657661   120   1007209.411476     36231.933030 120405504.107912 /
> [120462.592822]  acpi_thermal_pm   625         0.000007         2   100         0.000007         0.007534         0.005048 /
> [120462.592916]     kworker/3:1H   932   1007064.734706    114764   100   1007064.734706      2030.235901 120291040.821446 /
> [120462.593010]    btrfs-cleaner  2434    736524.023605     49504   120    736524.023605     27828.508803  57036903.823157 /
> [120462.593104]          vnstatd  3179      1032.633809     24757   120      1032.633809      3111.567542 120384388.002113 /autogroup-9
> [120462.593199]         rsyslogd  3280      4208.667652    117615   120      4208.667652      4245.532570 120379274.546373 /autogroup-8
> [120462.593295]             ntpd  4168      1120.306959    126031   120      1120.306959      4026.011708 120382920.824275 /autogroup-57
> [120462.593390]            getty  4330         0.792928       100   120         0.792928         2.165359        62.668984 /autogroup-62
> [120462.593485]             cron  5278      1010.649778         1   120      1010.649778         1.929429         0.000000 /autogroup-31
> [120462.593581]    snapbackup.sh  9946    295962.923390        41   120    295962.923390         8.426742     65151.829486 /autogroup-14319
> [120462.593677]   kworker/u16:20  9984    737411.641888        69   120    737411.641888         0.957907        95.371393 /
> [120462.593770]   kworker/u16:21  9985    737426.303821       225   120    737426.303821        43.858476       143.024486 /
> [120462.593864]           pickup 22871       118.822076         7   120       118.822076         1.983452    300123.217580 /autogroup-59
> [120462.593960] 
> [120462.594001] cpu#4, 3399.717 MHz
> [120462.594044]   .nr_running                    : 0
> [120462.594089]   .load                          : 0
> [120462.594134]   .nr_switches                   : 4112439
> [120462.594180]   .nr_load_updates               : 581273
> [120462.594225]   .nr_uninterruptible            : 32473
> [120462.594271]   .next_balance                  : 4306.990508
> [120462.594317]   .curr->pid                     : 0
> [120462.594362]   .clock                         : 120462430.900594
> [120462.594409]   .cpu_load[0]                   : 0
> [120462.594454]   .cpu_load[1]                   : 0
> [120462.594499]   .cpu_load[2]                   : 0
> [120462.594544]   .cpu_load[3]                   : 0
> [120462.594589]   .cpu_load[4]                   : 0
> [120462.594634]   .yld_count                     : 0
> [120462.594679]   .sched_count                   : 4142985
> [120462.594725]   .sched_goidle                  : 1898144
> [120462.594770]   .avg_idle                      : 1000000
> [120462.594816]   .max_idle_balance_cost         : 500000
> [120462.594862]   .ttwu_count                    : 2735557
> [120462.594907]   .ttwu_local                    : 1472586
> [120462.594953] 
> [120462.594953] cfs_rq[4]:/autogroup-11
> [120462.595037]   .exec_clock                    : 6181.332901
> [120462.595083]   .MIN_vruntime                  : 0.000001
> [120462.595129]   .min_vruntime                  : 100261.564976
> [120462.595175]   .max_vruntime                  : 0.000001
> [120462.595221]   .spread                        : 0.000000
> [120462.595267]   .spread0                       : -1251345.401426
> [120462.595313]   .nr_spread_over                : 7786
> [120462.595359]   .nr_running                    : 0
> [120462.595404]   .load                          : 0
> [120462.595449]   .runnable_load_avg             : 0
> [120462.595494]   .blocked_load_avg              : 0
> [120462.595539]   .tg_load_contrib               : 0
> [120462.595584]   .tg_runnable_contrib           : 0
> [120462.595628]   .tg_load_avg                   : 0
> [120462.595674]   .tg->runnable_avg              : 0
> [120462.595718]   .tg->cfs_bandwidth.timer_active: 0
> [120462.595763]   .throttled                     : 0
> [120462.595808]   .throttle_count                : 0
> [120462.595853]   .se->exec_start                : 120462430.894380
> [120462.595900]   .se->vruntime                  : 807399.352011
> [120462.597052]   .se->sum_exec_runtime          : 6181.360556
> [120462.597098]   .se->statistics.wait_start     : 0.000000
> [120462.597144]   .se->statistics.sleep_start    : 0.000000
> [120462.597190]   .se->statistics.block_start    : 0.000000
> [120462.597236]   .se->statistics.sleep_max      : 0.000000
> [120462.597281]   .se->statistics.block_max      : 0.000000
> [120462.597327]   .se->statistics.exec_max       : 4.450929
> [120462.597373]   .se->statistics.slice_max      : 0.195698
> [120462.597419]   .se->statistics.wait_max       : 0.464975
> [120462.597465]   .se->statistics.wait_sum       : 5.092765
> [120462.597510]   .se->statistics.wait_count     : 27883
> [120462.597556]   .se->load.weight               : 2
> [120462.597601]   .se->avg.runnable_avg_sum      : 52
> [120462.597646]   .se->avg.runnable_avg_period   : 48416
> [120462.597691]   .se->avg.load_avg_contrib      : 0
> [120462.597736]   .se->avg.decay_count           : 114881927
> [120462.597782] 
> [120462.597782] cfs_rq[4]:/
> [120462.597865]   .exec_clock                    : 627501.551035
> [120462.597911]   .MIN_vruntime                  : 0.000001
> [120462.597957]   .min_vruntime                  : 807406.923116
> [120462.598003]   .max_vruntime                  : 0.000001
> [120462.598049]   .spread                        : 0.000000
> [120462.598095]   .spread0                       : -544200.043286
> [120462.598141]   .nr_spread_over                : 3124
> [120462.598186]   .nr_running                    : 0
> [120462.598231]   .load                          : 0
> [120462.598276]   .runnable_load_avg             : 0
> [120462.598322]   .blocked_load_avg              : 0
> [120462.598367]   .tg_load_contrib               : 0
> [120462.598411]   .tg_runnable_contrib           : 1
> [120462.598457]   .tg_load_avg                   : 867
> [120462.598502]   .tg->runnable_avg              : 322
> [120462.598547]   .tg->cfs_bandwidth.timer_active: 0
> [120462.598592]   .throttled                     : 0
> [120462.598637]   .throttle_count                : 0
> [120462.598682]   .avg->runnable_avg_sum         : 52
> [120462.598727]   .avg->runnable_avg_period      : 47751
> [120462.598773] 
> [120462.598773] rt_rq[4]:/
> [120462.598856]   .rt_nr_running                 : 0
> [120462.598901]   .rt_throttled                  : 0
> [120462.598946]   .rt_time                       : 0.000000
> [120462.598992]   .rt_runtime                    : 950.000000
> [120462.599038] 
> [120462.599038] runnable tasks:
> [120462.599038]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.599038] ----------------------------------------------------------------------------------------------------------
> [120462.599303]       watchdog/4    26       -10.045353         3   120       -10.045353         0.004653         0.001386 /
> [120462.599396]      migration/4    27         0.000000     32104     0         0.000000       640.634740         0.000771 /
> [120462.599490]      ksoftirqd/4    28    807395.010387     24919   120    807395.010387       576.064939 120408851.048388 /
> [120462.599584]      kworker/4:0    29      5333.530837        18   120      5333.530837         0.078133    302902.518725 /
> [120462.599678]     kworker/4:0H    30      3384.678067         6   100      3384.678067         0.028215      1082.687901 /
> [120462.599772]        writeback   137        22.960556         2   100        22.960556         0.004719         0.003372 /
> [120462.599866]           bioset   143        34.964435         2   100        34.964435         0.007005         0.003412 /
> [120462.599959]           crypto   145        46.967546         2   100        46.967546         0.003524         0.001595 /
> [120462.600053]          deferwq   739      2832.769267         2   100      2832.769267         0.009468         0.024231 /
> [120462.600148]        scsi_eh_2   895      3389.552917        18   120      3389.552917         4.947753       351.222923 /
> [120462.600242]     kworker/4:1H   929    807394.928621    174714   100    807394.928621      2358.746675 120457535.243080 /
> [120462.600336]           bioset   958      3494.745244         2   100      3494.745244         0.033457         0.022726 /
> [120462.600431]      kworker/4:2   978    807396.640905    309839   120    807396.640905     32260.122181 120413378.038266 /
> [120462.600525]  ext4-rsv-conver  2304      4472.108374         2   100      4472.108374         0.008532         0.004718 /
> [120462.600619]           bioset  2310      4496.378319         2   100      4496.378319         0.043434         0.024503 /
> [120462.600712]     btrfs-worker  2311      4508.383958         2   100      4508.383958         0.006371         0.003720 /
> [120462.600806]  btrfs-worker-hi  2313      4532.389181         2   100      4532.389181         0.003806         0.003130 /
> [120462.600900]   btrfs-delalloc  2314      4544.392376         2   100      4544.392376         0.003661         0.002984 /
> [120462.600993]  btrfs-flush_del  2315      4556.395571         2   100      4556.395571         0.003586         0.002936 /
> [120462.601087]      btrfs-cache  2316      4568.398694         2   100      4568.398694         0.003503         0.002990 /
> [120462.601181]     btrfs-submit  2317      4580.401690         2   100      4580.401690         0.003458         0.001310 /
> [120462.601274]      btrfs-fixup  2318      4592.404492         2   100      4592.404492         0.003241         0.001225 /
> [120462.601369]      btrfs-endio  2319      4604.407432         2   100      4604.407432         0.003447         0.001271 /
> [120462.601462]  btrfs-endio-met  2320      4616.410167         2   100      4616.410167         0.003203         0.001462 /
> [120462.601556]  btrfs-endio-met  2321      4628.413085         2   100      4628.413085         0.003398         0.001298 /
> [120462.601650]  btrfs-endio-rai  2322      4640.416005         2   100      4640.416005         0.003379         0.001250 /
> [120462.601744]        btrfs-rmw  2323      4652.419141         2   100      4652.419141         0.003594         0.001625 /
> [120462.601838]  btrfs-endio-wri  2324    448417.939935         5   100    448417.939935         0.140578  49412152.166282 /
> [120462.601931]  btrfs-freespace  2325      4676.424819         2   100      4676.424819         0.003182         0.001295 /
> [120462.602025]  btrfs-delayed-m  2326      4688.427757         2   100      4688.427757         0.003401         0.001261 /
> [120462.602119]  btrfs-readahead  2327      4700.430565         2   100      4700.430565         0.003212         0.001236 /
> [120462.602212]  btrfs-qgroup-re  2328      4712.433365         2   100      4712.433365         0.003135         0.001240 /
> [120462.602306]    ipv6_addrconf  2744      4968.243451         2   100      4968.243451         0.030733         0.005280 /
> [120462.602400]            acpid  3308         0.805096        13   120         0.805096         0.717275  58794971.811320 /autogroup-10
> [120462.602495]       munin-node  3326    100254.322949     60804   120    100254.322949      3918.665331 120384741.343696 /autogroup-11
> [120462.602592] 
> [120462.602633] cpu#5, 3399.717 MHz
> [120462.602676]   .nr_running                    : 0
> [120462.602721]   .load                          : 0
> [120462.602766]   .nr_switches                   : 2361080
> [120462.602812]   .nr_load_updates               : 488034
> [120462.602857]   .nr_uninterruptible            : 33475
> [120462.602903]   .next_balance                  : 4306.990609
> [120462.602949]   .curr->pid                     : 0
> [120462.602994]   .clock                         : 120462074.732873
> [120462.603041]   .cpu_load[0]                   : 0
> [120462.603086]   .cpu_load[1]                   : 0
> [120462.603131]   .cpu_load[2]                   : 0
> [120462.603176]   .cpu_load[3]                   : 0
> [120462.603221]   .cpu_load[4]                   : 0
> [120462.603266]   .yld_count                     : 0
> [120462.603311]   .sched_count                   : 2391476
> [120462.603356]   .sched_goidle                  : 1060567
> [120462.603402]   .avg_idle                      : 1000000
> [120462.603448]   .max_idle_balance_cost         : 500000
> [120462.603493]   .ttwu_count                    : 1235973
> [120462.603539]   .ttwu_local                    : 632083
> [120462.603585] 
> [120462.603585] cfs_rq[5]:/autogroup-37366
> [120462.603669]   .exec_clock                    : 6.204375
> [120462.603715]   .MIN_vruntime                  : 0.000001
> [120462.603761]   .min_vruntime                  : 137.155716
> [120462.603807]   .max_vruntime                  : 0.000001
> [120462.603853]   .spread                        : 0.000000
> [120462.603899]   .spread0                       : -1351469.810686
> [120462.603945]   .nr_spread_over                : 5
> [120462.603990]   .nr_running                    : 0
> [120462.604035]   .load                          : 0
> [120462.604080]   .runnable_load_avg             : 0
> [120462.604125]   .blocked_load_avg              : 0
> [120462.604170]   .tg_load_contrib               : 0
> [120462.604215]   .tg_runnable_contrib           : 12
> [120462.604260]   .tg_load_avg                   : 0
> [120462.604305]   .tg->runnable_avg              : 12
> [120462.604350]   .tg->cfs_bandwidth.timer_active: 0
> [120462.604395]   .throttled                     : 0
> [120462.604440]   .throttle_count                : 0
> [120462.604485]   .se->exec_start                : 120462033.664993
> [120462.604532]   .se->vruntime                  : 604121.569138
> [120462.604579]   .se->sum_exec_runtime          : 6.204375
> [120462.604624]   .se->statistics.wait_start     : 0.000000
> [120462.604670]   .se->statistics.sleep_start    : 0.000000
> [120462.604716]   .se->statistics.block_start    : 0.000000
> [120462.604763]   .se->statistics.sleep_max      : 0.000000
> [120462.604809]   .se->statistics.block_max      : 0.000000
> [120462.604854]   .se->statistics.exec_max       : 0.729549
> [120462.604900]   .se->statistics.slice_max      : 0.000000
> [120462.604946]   .se->statistics.wait_max       : 0.013354
> [120462.604992]   .se->statistics.wait_sum       : 0.013354
> [120462.605039]   .se->statistics.wait_count     : 18
> [120462.605084]   .se->load.weight               : 2
> [120462.605129]   .se->avg.runnable_avg_sum      : 598
> [120462.605174]   .se->avg.runnable_avg_period   : 47355
> [120462.605219]   .se->avg.load_avg_contrib      : 0
> [120462.605265]   .se->avg.decay_count           : 114881548
> [120462.606418] 
> [120462.606418] cfs_rq[5]:/
> [120462.606501]   .exec_clock                    : 508282.960361
> [120462.606547]   .MIN_vruntime                  : 0.000001
> [120462.606593]   .min_vruntime                  : 604121.769710
> [120462.606639]   .max_vruntime                  : 0.000001
> [120462.606685]   .spread                        : 0.000000
> [120462.606731]   .spread0                       : -747485.196692
> [120462.606777]   .nr_spread_over                : 3207
> [120462.606822]   .nr_running                    : 0
> [120462.606867]   .load                          : 0
> [120462.606913]   .runnable_load_avg             : 0
> [120462.606958]   .blocked_load_avg              : 867
> [120462.607003]   .tg_load_contrib               : 867
> [120462.607049]   .tg_runnable_contrib           : 14
> [120462.607094]   .tg_load_avg                   : 867
> [120462.607139]   .tg->runnable_avg              : 322
> [120462.607184]   .tg->cfs_bandwidth.timer_active: 0
> [120462.607229]   .throttled                     : 0
> [120462.607274]   .throttle_count                : 0
> [120462.607319]   .avg->runnable_avg_sum         : 656
> [120462.607364]   .avg->runnable_avg_period      : 47824
> [120462.607410] 
> [120462.607410] rt_rq[5]:/
> [120462.607492]   .rt_nr_running                 : 0
> [120462.607537]   .rt_throttled                  : 0
> [120462.607582]   .rt_time                       : 0.000000
> [120462.607628]   .rt_runtime                    : 950.000000
> [120462.607674] 
> [120462.607674] runnable tasks:
> [120462.607674]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.607674] ----------------------------------------------------------------------------------------------------------
> [120462.607939]       watchdog/5    31       -10.045361         3   120       -10.045361         0.004572         0.001567 /
> [120462.608033]      migration/5    32         0.000000     32955     0         0.000000       270.893946         0.001082 /
> [120462.608126]      ksoftirqd/5    33    604109.797662     22514   120    604109.797662       475.987048 120461195.188404 /
> [120462.608220]      kworker/5:0    34    466886.026867        18   120    466886.026867         0.056347  69919162.295665 /
> [120462.608314]     kworker/5:0H    35      3254.385894         6   100      3254.385894         0.036554      1070.054807 /
> [120462.608408]          kblockd   148        18.960461         2   100        18.960461         0.005349         0.002341 /
> [120462.608502]               md   368      2644.311176         2   100      2644.311176         0.004007         0.002520 /
> [120462.608596]          ata_sff   830      2955.118399         2   100      2955.118399         0.013080         0.043536 /
> [120462.608690]        scsi_eh_0   891      3242.115045         3   120      3242.115045         0.039301         1.960625 /
> [120462.608784]       scsi_tmf_0   892      3254.106241         2   100      3254.106241         0.022235         0.002708 /
> [120462.608878]        scsi_eh_3   897      3246.981923        18   120      3246.981923         4.919054       351.375320 /
> [120462.608972]     kworker/5:1H   933    604109.629601     70672   100    604109.629601       758.386211 120292060.828831 /
> [120462.609067]         rsyslogd  3281      2646.145210         7   120      2646.145210         1.922451  57253066.305708 /autogroup-8
> [120462.609163]      kworker/5:1  6058    604111.991063     75564   120    604111.991063      1118.308982  50541020.618900 /
> [120462.609256] 
> [120462.609298] cpu#6, 3399.717 MHz
> [120462.609341]   .nr_running                    : 0
> [120462.609386]   .load                          : 0
> [120462.609431]   .nr_switches                   : 2406020
> [120462.609477]   .nr_load_updates               : 532402
> [120462.609523]   .nr_uninterruptible            : 34239
> [120462.609568]   .next_balance                  : 4306.990608
> [120462.609614]   .curr->pid                     : 0
> [120462.609659]   .clock                         : 120462064.740221
> [120462.609705]   .cpu_load[0]                   : 0
> [120462.609750]   .cpu_load[1]                   : 0
> [120462.609795]   .cpu_load[2]                   : 0
> [120462.609840]   .cpu_load[3]                   : 0
> [120462.609885]   .cpu_load[4]                   : 0
> [120462.609930]   .yld_count                     : 0
> [120462.609975]   .sched_count                   : 2436052
> [120462.610021]   .sched_goidle                  : 1083813
> [120462.610066]   .avg_idle                      : 1000000
> [120462.610112]   .max_idle_balance_cost         : 500000
> [120462.610157]   .ttwu_count                    : 1237560
> [120462.610203]   .ttwu_local                    : 649773
> [120462.610248] 
> [120462.610248] cfs_rq[6]:/
> [120462.610331]   .exec_clock                    : 515431.611646
> [120462.610377]   .MIN_vruntime                  : 0.000001
> [120462.610423]   .min_vruntime                  : 646454.640877
> [120462.610469]   .max_vruntime                  : 0.000001
> [120462.610515]   .spread                        : 0.000000
> [120462.610561]   .spread0                       : -705152.325525
> [120462.610607]   .nr_spread_over                : 4031
> [120462.610652]   .nr_running                    : 0
> [120462.610697]   .load                          : 0
> [120462.610742]   .runnable_load_avg             : 0
> [120462.610787]   .blocked_load_avg              : 0
> [120462.610832]   .tg_load_contrib               : 0
> [120462.610877]   .tg_runnable_contrib           : 0
> [120462.610922]   .tg_load_avg                   : 867
> [120462.610967]   .tg->runnable_avg              : 322
> [120462.611013]   .tg->cfs_bandwidth.timer_active: 0
> [120462.611058]   .throttled                     : 0
> [120462.611103]   .throttle_count                : 0
> [120462.611148]   .avg->runnable_avg_sum         : 23
> [120462.611193]   .avg->runnable_avg_period      : 48021
> [120462.611239] 
> [120462.611239] rt_rq[6]:/
> [120462.611322]   .rt_nr_running                 : 0
> [120462.611367]   .rt_throttled                  : 0
> [120462.611412]   .rt_time                       : 0.000000
> [120462.611457]   .rt_runtime                    : 950.000000
> [120462.611504] 
> [120462.611504] runnable tasks:
> [120462.611504]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.611504] ----------------------------------------------------------------------------------------------------------
> [120462.611771]       watchdog/6    36        -8.976676     30137     0        -8.976676       421.530103        19.302631 /
> [120462.611865]      migration/6    37         0.000000     33902     0         0.000000       225.014911         0.000821 /
> [120462.611959]      ksoftirqd/6    38    646442.829116     23046   120    646442.829116       515.528163 120391517.781831 /
> [120462.612053]      kworker/6:0    39    165830.862118        16   120    165830.862118         0.059183  44791604.986230 /
> [120462.612148]     kworker/6:0H    40      2510.885399         6   100      2510.885399         0.021618      1173.734427 /
> [120462.612242]    irq/41-mei_me   682         0.000000        17    49         0.000000         0.349066         0.000000 /
> [120462.612336]        scsi_eh_1   893      2424.131754         3   120      2424.131754         0.032863         1.688217 /
> [120462.612430]       scsi_tmf_1   894      2339.944197         2   100      2339.944197         0.026073         0.004028 /
> [120462.612524]       scsi_tmf_2   896      2363.996948         2   100      2363.996948         0.026178         0.003925 /
> [120462.612617]       scsi_tmf_3   898      2388.056333         2   100      2388.056333         0.025718         0.003878 /
> [120462.612711]       scsi_tmf_4   900      2412.092111         2   100      2412.092111         0.008418         0.002927 /
> [120462.612805]       scsi_tmf_5   902      2436.126025         2   100      2436.126025         0.007891         0.003176 /
> [120462.612899]     kworker/6:1H   957    646442.641056     54689   100    646442.641056       614.895484 120407402.626110 /
> [120462.612993]        md0_raid1   959    646080.816306       181   120    646080.816306        11.396930 120014044.435411 /
> [120462.613087]           bioset   966      2546.940432         2   100      2546.940432         0.007331         0.002731 /
> [120462.613181]           bioset   975      2582.967906         2   100      2582.967906         0.007195         0.003267 /
> [120462.613275]  ext4-rsv-conver   993      2655.342740         2   100      2655.342740         0.070301         0.034603 /
> [120462.613370]            udevd  2743       202.133786         1   120       202.133786         0.149356         0.000000 /autogroup-4
> [120462.613465]      dbus-daemon  3760         0.989799         1   120         0.989799         0.146103         0.000000 /autogroup-41
> [120462.613560]            getty  4334         0.771401       101   120         0.771401         2.013675        62.047255 /autogroup-66
> [120462.613656]      kworker/6:2 12652    646444.485708    186015   120    646444.485708     26121.190942  75933494.876229 /
> [120462.613750]   kworker/u16:10 24026    452170.250226     64919   120    452170.250226     27313.974961   7671248.619801 /
> [120462.613844] 
> [120462.613886] cpu#7, 3399.717 MHz
> [120462.613929]   .nr_running                    : 0
> [120462.613974]   .load                          : 0
> [120462.614019]   .nr_switches                   : 2234652
> [120462.614065]   .nr_load_updates               : 480945
> [120462.614111]   .nr_uninterruptible            : 32557
> [120462.614157]   .next_balance                  : 4306.990658
> [120462.614203]   .curr->pid                     : 0
> [120462.614248]   .clock                         : 120462564.434478
> [120462.614295]   .cpu_load[0]                   : 0
> [120462.614340]   .cpu_load[1]                   : 0
> [120462.614385]   .cpu_load[2]                   : 0
> [120462.614430]   .cpu_load[3]                   : 0
> [120462.614475]   .cpu_load[4]                   : 0
> [120462.614520]   .yld_count                     : 0
> [120462.614565]   .sched_count                   : 2264438
> [120462.614610]   .sched_goidle                  : 1007847
> [120462.615764]   .avg_idle                      : 1000000
> [120462.615810]   .max_idle_balance_cost         : 500000
> [120462.615856]   .ttwu_count                    : 1113501
> [120462.615902]   .ttwu_local                    : 568573
> [120462.615947] 
> [120462.615947] cfs_rq[7]:/
> [120462.616030]   .exec_clock                    : 436985.698288
> [120462.616076]   .MIN_vruntime                  : 0.000001
> [120462.616122]   .min_vruntime                  : 553926.348218
> [120462.616168]   .max_vruntime                  : 0.000001
> [120462.616214]   .spread                        : 0.000000
> [120462.616260]   .spread0                       : -797680.618184
> [120462.616306]   .nr_spread_over                : 2556
> [120462.616352]   .nr_running                    : 0
> [120462.616397]   .load                          : 0
> [120462.616442]   .runnable_load_avg             : 0
> [120462.616487]   .blocked_load_avg              : 0
> [120462.616532]   .tg_load_contrib               : 0
> [120462.616577]   .tg_runnable_contrib           : 0
> [120462.616622]   .tg_load_avg                   : 867
> [120462.616667]   .tg->runnable_avg              : 322
> [120462.616712]   .tg->cfs_bandwidth.timer_active: 0
> [120462.616757]   .throttled                     : 0
> [120462.616802]   .throttle_count                : 0
> [120462.616847]   .avg->runnable_avg_sum         : 18
> [120462.616892]   .avg->runnable_avg_period      : 47851
> [120462.616938]
> [120462.616938] rt_rq[7]:/
> [120462.617020]   .rt_nr_running                 : 0
> [120462.617065]   .rt_throttled                  : 0
> [120462.617110]   .rt_time                       : 0.000000
> [120462.617156]   .rt_runtime                    : 950.000000
> [120462.617202]
> [120462.617202] runnable tasks:
> [120462.617202]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [120462.617202] ----------------------------------------------------------------------------------------------------------
> [120462.617467]       watchdog/7    41        -8.978196     30137     0        -8.978196       355.916635         5.696797 /
> [120462.617561]      migration/7    42         0.000000     32203     0         0.000000       221.822304         0.000846 /
> [120462.617654]      ksoftirqd/7    43    553914.435400     19312   120    553914.435400       459.571968 120409037.593472 /
> [120462.617748]     kworker/7:0H    45      1494.775108         6   100      1494.775108         0.016120      1042.181237 /
> [120462.617842]          khelper    46        10.956718         2   100        10.956718         0.005858         0.003343 /
> [120462.617936]            netns    47        22.960081         2   100        22.960081         0.003688         0.002327 /
> [120462.618029]      kworker/7:1   474     57314.165436        28   120     57314.165436         3.339657  21048751.183322 /
> [120462.618123]        kpsmoused   693       257.164191         2   100       257.164191         0.008092         0.008068 /
> [120462.618217]     kworker/7:1H   930    553914.296827     42958   100    553914.296827       529.929524 120318643.215516 /
> [120462.618311]        md1_raid1   967    552715.237106       152   120    552715.237106         4.661542 120013841.668607 /
> [120462.618405]            udevd  1179       359.051100       295   120       359.051100        41.704358     44021.109679 /autogroup-4
> [120462.618500]       jbd2/md1-8  2303      2137.772254         2   120      2137.772254         0.050318         0.034699 /
> [120462.618595]             cron  3680     14660.543335      5061   120     14660.543335       537.683233 120334964.261247 /autogroup-31
> [120462.618690]            getty  4331         0.242502       103   120         0.242502         1.935179        62.699954 /autogroup-63
> [120462.618785]      kworker/7:0 21393    553916.760350    230551   120    553916.760350     28943.793897  99672247.903133 /
> [120462.618879]   kworker/u16:18 30518    412306.212454     43825   120    412306.212454     13932.951642   5128293.090520 /
> [120462.618973]    kworker/u17:6  6569    412294.212704      1318   100    412294.212704       198.235712   1357797.903578 /
> [120462.619067]   kworker/u16:11  9898    412301.933971       444   120    412301.933971        49.744247    119931.390727 /
> [120462.619161]            btrfs  9979     99055.212025       308   120     99055.212025        11.641810        87.495445 /autogroup-14319
> [120462.619256]   kworker/u16:16  9981    412294.220175        73   120    412294.220175         5.921766        93.221546 /
> [120462.619350]
> 
> 

