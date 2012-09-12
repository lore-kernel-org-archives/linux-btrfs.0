Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48759 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2ILJqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 05:46:22 -0400
Message-ID: <505059E4.1080903@oracle.com>
Date: Wed, 12 Sep 2012 17:46:12 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deadlock in btrfs-cleaner, related to snapshot deletion
References: <20120912135315.32d670c2@natsu>
In-Reply-To: <20120912135315.32d670c2@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2012 03:53 PM, Roman Mamedov wrote:
> Hello,
> 
> (this is a recap of yesterday's discussion on BTRFS IRC, also to save relevant pastes before pastebins expire)
> 
> I have my /home on btrfs; a cronjob makes one snapshot every 30 minutes; these
> snapshots are kept for 24-48 hours, then deleted in batches.
> 
> This is a 16K Leaf/Node BTRFS on top of mdadm RAID1.
> 
> As system uptime approached 2 weeks, I started noticing that the free space on
> that partition does not free up as it should assuming continuous clean-up of older snapshots.
> 
> I have tried a reboot, and it locked up unmounting the FS. After a hard
> reset, soon after mounting the FS processes start to lock-up in D state, with
> messages that a task is blocked for more than 120 seconds in dmesg.
> 
> I have upgraded to 3.6.0-rc5, and this is what I got via Alt-SysRq-W in this locked up state:
> 

I try to figure out where goes wrong, but the listed stacks seems to be not enough for solving the deadlock,
so could you please use a lockdep debug kernel and post the result here? 

thanks,
liubo


> [  386.318062] SysRq : Show Blocked State
> [  386.318141]   task                        PC stack   pid father
> [  386.318188] btrfs-cleaner   D ffffffff8180d440     0  3506      2 0x00000000
> [  386.318197]  ffff88040c34b6a0 0000000000000046 ffff88040c34b650 ffffffff81139f03
> [  386.318205]  ffff88040c34bfd8 ffff88040c34bfd8 ffff88040c34bfd8 0000000000013dc0
> [  386.318213]  ffffffff81c14440 ffff88040b3496d0 ffff88040c34b6b0 ffff880405a04408
> [  386.318220] Call Trace:
> [  386.318236]  [<ffffffff81139f03>] ? activate_page+0x83/0xa0
> [  386.318245]  [<ffffffff8169d0e9>] schedule+0x29/0x70
> [  386.318305]  [<ffffffffa011b29d>] btrfs_tree_lock+0xcd/0x250 [btrfs]
> [  386.318314]  [<ffffffff8107ccd0>] ? add_wait_queue+0x60/0x60
> [  386.318348]  [<ffffffffa00dc4f8>] btrfs_init_new_buffer+0x68/0x140 [btrfs]
> [  386.318379]  [<ffffffffa00dc66f>] btrfs_alloc_free_block+0x9f/0x220 [btrfs]
> [  386.318408]  [<ffffffffa00c83b2>] __btrfs_cow_block+0x122/0x4f0 [btrfs]
> [  386.318415]  [<ffffffff8169e00e>] ? _raw_spin_lock+0xe/0x20
> [  386.318443]  [<ffffffffa00c887c>] btrfs_cow_block+0xfc/0x220 [btrfs]
> [  386.318472]  [<ffffffffa00cc9f8>] btrfs_search_slot+0x368/0x740 [btrfs]
> [  386.318502]  [<ffffffffa00d32de>] lookup_inline_extent_backref+0x8e/0x4c0 [btrfs]
> [  386.318532]  [<ffffffffa00d3770>] lookup_extent_backref+0x60/0xf0 [btrfs]
> [  386.318561]  [<ffffffffa00d5c55>] __btrfs_free_extent+0xb5/0x670 [btrfs]
> [  386.318592]  [<ffffffffa00d6324>] run_delayed_tree_ref+0x114/0x190 [btrfs]
> [  386.318623]  [<ffffffffa00dac2e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
> [  386.318654]  [<ffffffffa00dad76>] run_clustered_refs+0x136/0x3d0 [btrfs]
> [  386.318685]  [<ffffffffa00db100>] btrfs_run_delayed_refs+0xf0/0x2d0 [btrfs]
> [  386.318721]  [<ffffffffa00ecf99>] __btrfs_end_transaction+0xf9/0x3c0 [btrfs]
> [  386.318753]  [<ffffffffa00dcd35>] ? btrfs_drop_snapshot+0x545/0x600 [btrfs]
> [  386.318789]  [<ffffffffa00ed2b8>] btrfs_end_transaction_throttle+0x18/0x20 [btrfs]
> [  386.318820]  [<ffffffffa00dca03>] btrfs_drop_snapshot+0x213/0x600 [btrfs]
> [  386.318857]  [<ffffffffa00edae7>] btrfs_clean_old_snapshots+0xa7/0x150 [btrfs]
> [  386.318890]  [<ffffffffa00e57d9>] cleaner_kthread+0xa9/0x120 [btrfs]
> [  386.318924]  [<ffffffffa00e5730>] ? btree_invalidatepage+0x80/0x80 [btrfs]
> [  386.318931]  [<ffffffff8107c3f3>] kthread+0x93/0xa0
> [  386.318939]  [<ffffffff816a7a84>] kernel_thread_helper+0x4/0x10
> [  386.318946]  [<ffffffff8107c360>] ? flush_kthread_worker+0xb0/0xb0
> [  386.318952]  [<ffffffff816a7a80>] ? gs_change+0x13/0x13
> [  386.318956] btrfs-transacti D 0000000000000000     0  3507      2 0x00000000
> [  386.318963]  ffff88040aa15920 0000000000000046 0000000000000003 0000000000025250
> [  386.318971]  ffff88040aa15fd8 ffff88040aa15fd8 ffff88040aa15fd8 0000000000013dc0
> [  386.318977]  ffff88040a7fada0 ffff88040b34c470 ffff88040aa15930 ffff8803c7798ac0
> [  386.318984] Call Trace:
> [  386.318991]  [<ffffffff8169d0e9>] schedule+0x29/0x70
> [  386.319031]  [<ffffffffa011b29d>] btrfs_tree_lock+0xcd/0x250 [btrfs]
> [  386.319039]  [<ffffffff8107ccd0>] ? add_wait_queue+0x60/0x60
> [  386.319068]  [<ffffffffa00ccc81>] btrfs_search_slot+0x5f1/0x740 [btrfs]
> [  386.319098]  [<ffffffffa00d32de>] lookup_inline_extent_backref+0x8e/0x4c0 [btrfs]
> [  386.319128]  [<ffffffffa00d3770>] lookup_extent_backref+0x60/0xf0 [btrfs]
> [  386.319157]  [<ffffffffa00d5c55>] __btrfs_free_extent+0xb5/0x670 [btrfs]
> [  386.319188]  [<ffffffffa00d6324>] run_delayed_tree_ref+0x114/0x190 [btrfs]
> [  386.319219]  [<ffffffffa00dac2e>] run_one_delayed_ref+0xde/0xf0 [btrfs]
> [  386.319250]  [<ffffffffa00dad76>] run_clustered_refs+0x136/0x3d0 [btrfs]
> [  386.319281]  [<ffffffffa00db100>] btrfs_run_delayed_refs+0xf0/0x2d0 [btrfs]
> [  386.319317]  [<ffffffffa00ec555>] btrfs_commit_transaction+0xa5/0x9c0 [btrfs]
> [  386.319325]  [<ffffffff8107ccd0>] ? add_wait_queue+0x60/0x60
> [  386.319359]  [<ffffffffa00e6a65>] transaction_kthread+0x1b5/0x230 [btrfs]
> [  386.319393]  [<ffffffffa00e68b0>] ? btrfs_destroy_delayed_refs.isra.103+0x210/0x210 [btrfs]
> [  386.319400]  [<ffffffff8107c3f3>] kthread+0x93/0xa0
> [  386.319407]  [<ffffffff816a7a84>] kernel_thread_helper+0x4/0x10
> [  386.319414]  [<ffffffff8107c360>] ? flush_kthread_worker+0xb0/0xb0
> [  386.319421]  [<ffffffff816a7a80>] ? gs_change+0x13/0x13
> [  386.319424] flush-btrfs-3   D 0000000000000000     0  3520      2 0x00000000
> [  386.319431]  ffff8803c181b9d0 0000000000000046 ffff8803c181b970 ffff880405ab2d98
> [  386.319437]  ffff8803c181bfd8 ffff8803c181bfd8 ffff8803c181bfd8 0000000000013dc0
> [  386.319444]  ffff88040a7fada0 ffff8804014316d0 ffff8803c181b9e0 ffff8803d870e2b0
> [  386.319450] Call Trace:
> [  386.319457]  [<ffffffff8169d0e9>] schedule+0x29/0x70
> [  386.319496]  [<ffffffffa011b29d>] btrfs_tree_lock+0xcd/0x250 [btrfs]
> [  386.319503]  [<ffffffff8107ccd0>] ? add_wait_queue+0x60/0x60
> [  386.319542]  [<ffffffffa0102873>] lock_extent_buffer_for_io+0x103/0x260 [btrfs]
> [  386.319581]  [<ffffffffa010862c>] btree_write_cache_pages+0x21c/0x410 [btrfs]
> [  386.319619]  [<ffffffffa00f1e40>] ? can_nocow_odirect+0x2b0/0x2b0 [btrfs]
> [  386.319654]  [<ffffffffa00e4a6b>] btree_writepages+0x3b/0x40 [btrfs]
> [  386.319661]  [<ffffffff81138450>] do_writepages+0x20/0x40
> [  386.319670]  [<ffffffff811af12f>] __writeback_single_inode.isra.32+0x3f/0x190
> [  386.319678]  [<ffffffff811af850>] writeback_sb_inodes+0x1a0/0x350
> [  386.319685]  [<ffffffff811afbbf>] wb_writeback+0xef/0x340
> [  386.319693]  [<ffffffff811b1468>] wb_do_writeback+0xb8/0x1d0
> [  386.319701]  [<ffffffff81067c20>] ? usleep_range+0x50/0x50
> [  386.319709]  [<ffffffff811b160b>] bdi_writeback_thread+0x8b/0x290
> [  386.319717]  [<ffffffff811b1580>] ? wb_do_writeback+0x1d0/0x1d0
> [  386.319723]  [<ffffffff8107c3f3>] kthread+0x93/0xa0
> [  386.319730]  [<ffffffff816a7a84>] kernel_thread_helper+0x4/0x10
> [  386.319738]  [<ffffffff8107c360>] ? flush_kthread_worker+0xb0/0xb0
> [  386.319744]  [<ffffffff816a7a80>] ? gs_change+0x13/0x13
> [  386.319748] sync            D ffffffff8180d440     0  3585   3570 0x00000000
> [  386.319754]  ffff8803dacb1cf8 0000000000000082 ffff8803dacb1cd8 ffffffff81094699
> [  386.319761]  ffff8803dacb1fd8 ffff8803dacb1fd8 ffff8803dacb1fd8 0000000000013dc0
> [  386.319768]  ffff88040d92db40 ffff88040bc14470 0000000000013dc0 7fffffffffffffff
> [  386.319774] Call Trace:
> [  386.319783]  [<ffffffff81094699>] ? check_preempt_wakeup+0x1c9/0x270
> [  386.319789]  [<ffffffff8169d0e9>] schedule+0x29/0x70
> [  386.319796]  [<ffffffff8169b82d>] schedule_timeout+0x1fd/0x260
> [  386.319803]  [<ffffffff8108c1a6>] ? ttwu_do_activate.constprop.86+0x66/0x70
> [  386.319809]  [<ffffffff8108c286>] ? ttwu_queue+0xd6/0xf0
> [  386.319815]  [<ffffffff8169cf3f>] wait_for_common+0xdf/0x180
> [  386.319822]  [<ffffffff811b4fc0>] ? fdatawrite_one_bdev+0x20/0x20
> [  386.319828]  [<ffffffff8108eec0>] ? try_to_wake_up+0x200/0x200
> [  386.319834]  [<ffffffff811b4fc0>] ? fdatawrite_one_bdev+0x20/0x20
> [  386.319840]  [<ffffffff8169d0bd>] wait_for_completion+0x1d/0x20
> [  386.319847]  [<ffffffff811ad907>] sync_inodes_sb+0x97/0xd0
> [  386.319854]  [<ffffffff811b4fdd>] sync_inodes_one_sb+0x1d/0x30
> [  386.319862]  [<ffffffff811894a1>] iterate_supers+0x101/0x110
> [  386.319867]  [<ffffffff811b5145>] sys_sync+0x35/0x90
> [  386.319874]  [<ffffffff816a686d>] system_call_fastpath+0x1a/0x1f
> [  386.319881] Sched Debug Version: v0.10, 3.6.0-030600rc5-generic #201209082035
> [  386.319885] ktime                                   : 386839.691480
> [  386.319889] sched_clk                               : 386319.878549
> [  386.319893] cpu_clk                                 : 386319.878681
> [  386.319896] jiffies                                 : 4294989005
> [  386.319899] sched_clock_stable                      : 1
> [  386.319901] 
> [  386.319903] sysctl_sched
> [  386.319907]   .sysctl_sched_latency                    : 12.000000
> [  386.319911]   .sysctl_sched_min_granularity            : 1.500000
> [  386.319914]   .sysctl_sched_wakeup_granularity         : 2.000000
> [  386.319917]   .sysctl_sched_child_runs_first           : 0
> [  386.319920]   .sysctl_sched_features                   : 24119
> [  386.319924]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [  386.319929] 
> [  386.319929] cpu#0, 3013.515 MHz
> [  386.319933]   .nr_running                    : 2
> [  386.319936]   .load                          : 2048
> [  386.319939]   .nr_switches                   : 437801
> [  386.319942]   .nr_load_updates               : 22334
> [  386.319945]   .nr_uninterruptible            : 3
> [  386.319948]   .next_balance                  : 4294.988996
> [  386.319951]   .curr->pid                     : 3590
> [  386.319954]   .clock                         : 386317.815742
> [  386.319957]   .cpu_load[0]                   : 0
> [  386.319960]   .cpu_load[1]                   : 0
> [  386.319962]   .cpu_load[2]                   : 0
> [  386.319965]   .cpu_load[3]                   : 0
> [  386.319967]   .cpu_load[4]                   : 0
> [  386.319970]   .yld_count                     : 0
> [  386.319973]   .sched_count                   : 445110
> [  386.319976]   .sched_goidle                  : 198003
> [  386.319979]   .avg_idle                      : 1000000
> [  386.319982]   .ttwu_count                    : 184667
> [  386.319985]   .ttwu_local                    : 178809
> [  386.319990] 
> [  386.319990] cfs_rq[0]:/autogroup-47
> [  386.319994]   .exec_clock                    : 13.273210
> [  386.319998]   .MIN_vruntime                  : 0.000001
> [  386.320001]   .min_vruntime                  : 13.529500
> [  386.320005]   .max_vruntime                  : 0.000001
> [  386.320008]   .spread                        : 0.000000
> [  386.320011]   .spread0                       : -23453.744689
> [  386.320015]   .nr_spread_over                : 0
> [  386.320018]   .nr_running                    : 1
> [  386.320020]   .load                          : 1024
> [  386.320024]   .load_avg                      : 0.000000
> [  386.320027]   .load_period                   : 9.999999
> [  386.320030]   .load_contrib                  : 0
> [  386.320033]   .load_tg                       : 0
> [  386.320037]   .se->exec_start                : 386317.815742
> [  386.320040]   .se->vruntime                  : 23467.274189
> [  386.320044]   .se->sum_exec_runtime          : 13.339940
> [  386.320047]   .se->statistics.wait_start     : 0.000000
> [  386.320051]   .se->statistics.sleep_start    : 0.000000
> [  386.320054]   .se->statistics.block_start    : 0.000000
> [  386.320057]   .se->statistics.sleep_max      : 0.000000
> [  386.320060]   .se->statistics.block_max      : 0.000000
> [  386.320063]   .se->statistics.exec_max       : 1.952409
> [  386.320067]   .se->statistics.slice_max      : 0.000000
> [  386.320070]   .se->statistics.wait_max       : 0.029838
> [  386.320073]   .se->statistics.wait_sum       : 0.036460
> [  386.320076]   .se->statistics.wait_count     : 32
> [  386.320079]   .se->load.weight               : 1024
> [  386.320083] 
> [  386.320083] cfs_rq[0]:/
> [  386.320087]   .exec_clock                    : 23614.135229
> [  386.320090]   .MIN_vruntime                  : 23465.802624
> [  386.320094]   .min_vruntime                  : 23467.274189
> [  386.320097]   .max_vruntime                  : 23465.802624
> [  386.320100]   .spread                        : 0.000000
> [  386.320103]   .spread0                       : 0.000000
> [  386.320106]   .nr_spread_over                : 117
> [  386.320109]   .nr_running                    : 2
> [  386.320112]   .load                          : 2048
> [  386.320115]   .load_avg                      : 0.000000
> [  386.320118]   .load_period                   : 0.000000
> [  386.320121]   .load_contrib                  : 0
> [  386.320123]   .load_tg                       : 0
> [  386.320131] 
> [  386.320131] rt_rq[0]:/
> [  386.320135]   .rt_nr_running                 : 0
> [  386.320137]   .rt_throttled                  : 0
> [  386.320140]   .rt_time                       : 0.000000
> [  386.320144]   .rt_runtime                    : 950.000000
> [  386.320148] 
> [  386.320148] runnable tasks:
> [  386.320148]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [  386.320148] ----------------------------------------------------------------------------------------------------------
> [  386.320173]      kworker/0:6  3413     23465.802624      9246   120     23465.802624       187.949272    352670.165012 /
> [  386.320190] R           bash  3590        13.529500        34   120        13.529500        16.465746     17470.132476 /autogroup-47
> [  386.320203] 
> [  386.320203] cpu#1, 3013.515 MHz
> [  386.320207]   .nr_running                    : 0
> [  386.320210]   .load                          : 0
> [  386.320213]   .nr_switches                   : 291294
> [  386.320216]   .nr_load_updates               : 35844
> [  386.320219]   .nr_uninterruptible            : 1
> [  386.320222]   .next_balance                  : 4294.988982
> [  386.320225]   .curr->pid                     : 0
> [  386.320228]   .clock                         : 386317.758699
> [  386.320231]   .cpu_load[0]                   : 0
> [  386.320234]   .cpu_load[1]                   : 0
> [  386.320237]   .cpu_load[2]                   : 0
> [  386.320239]   .cpu_load[3]                   : 0
> [  386.320242]   .cpu_load[4]                   : 2
> [  386.320245]   .yld_count                     : 0
> [  386.320248]   .sched_count                   : 311183
> [  386.320251]   .sched_goidle                  : 130944
> [  386.320253]   .avg_idle                      : 1000000
> [  386.320256]   .ttwu_count                    : 186513
> [  386.320259]   .ttwu_local                    : 143360
> [  386.320263] 
> [  386.320263] cfs_rq[1]:/autogroup-46
> [  386.320268]   .exec_clock                    : 64.885545
> [  386.320271]   .MIN_vruntime                  : 0.000001
> [  386.320274]   .min_vruntime                  : 63.581650
> [  386.320278]   .max_vruntime                  : 0.000001
> [  386.320281]   .spread                        : 0.000000
> [  386.320284]   .spread0                       : -23403.692539
> [  386.320287]   .nr_spread_over                : 1
> [  386.320290]   .nr_running                    : 0
> [  386.320292]   .load                          : 0
> [  386.320296]   .load_avg                      : 5119.999488
> [  386.320299]   .load_period                   : 5.010586
> [  386.320302]   .load_contrib                  : 1021
> [  386.320305]   .load_tg                       : 1021
> [  386.320309]   .se->exec_start                : 386317.737525
> [  386.320312]   .se->vruntime                  : 16960.176657
> [  386.320315]   .se->sum_exec_runtime          : 64.885545
> [  386.320319]   .se->statistics.wait_start     : 0.000000
> [  386.320322]   .se->statistics.sleep_start    : 0.000000
> [  386.320325]   .se->statistics.block_start    : 0.000000
> [  386.320328]   .se->statistics.sleep_max      : 0.000000
> [  386.320331]   .se->statistics.block_max      : 0.000000
> [  386.320335]   .se->statistics.exec_max       : 3.994871
> [  386.320338]   .se->statistics.slice_max      : 0.000000
> [  386.320341]   .se->statistics.wait_max       : 4.113969
> [  386.320344]   .se->statistics.wait_sum       : 4.372857
> [  386.320347]   .se->statistics.wait_count     : 93
> [  386.320350]   .se->load.weight               : 2
> [  386.320353] 
> [  386.320353] cfs_rq[1]:/
> [  386.320357]   .exec_clock                    : 18869.698887
> [  386.320360]   .MIN_vruntime                  : 0.000001
> [  386.320364]   .min_vruntime                  : 16966.057472
> [  386.320367]   .max_vruntime                  : 0.000001
> [  386.320370]   .spread                        : 0.000000
> [  386.320373]   .spread0                       : -6501.216717
> [  386.320376]   .nr_spread_over                : 73
> [  386.320379]   .nr_running                    : 0
> [  386.320382]   .load                          : 0
> [  386.320385]   .load_avg                      : 0.000000
> [  386.320388]   .load_period                   : 0.000000
> [  386.320390]   .load_contrib                  : 0
> [  386.320393]   .load_tg                       : 0
> [  386.320397] 
> [  386.320397] rt_rq[1]:/
> [  386.320401]   .rt_nr_running                 : 0
> [  386.320404]   .rt_throttled                  : 0
> [  386.320407]   .rt_time                       : 0.000000
> [  386.320410]   .rt_runtime                    : 950.000000
> [  386.320413] 
> [  386.320413] runnable tasks:
> [  386.320413]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [  386.320413] ----------------------------------------------------------------------------------------------------------
> [  386.320437]
> 

