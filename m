Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61779 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2JSQS7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 12:18:59 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so895249iea.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 09:18:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny> <CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
 <CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com> <CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
From: Marguerite Su <i@marguerite.su>
Date: Sat, 20 Oct 2012 00:18:38 +0800
Message-ID: <CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: cwillu <cwillu@cwillu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 19, 2012 at 11:41 PM, cwillu <cwillu@cwillu.com> wrote:
> Also, next time just put the output directly in the email, that way
> it's permanently around to look at and search for.

Hi,

I did it. here's my dmesg:

[   25.623660] SysRq : Show Blocked State
[   25.623667]   task                        PC stack   pid father
[   25.623682] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
[   25.623687]  ffff880036b09a70 0000000000000046 00000000000000d7
ffff880036b09fd8
[   25.623691]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
ffff880036b09fd8
[   25.623695]  ffffffff81c13420 ffff880036a56840 0000000000000000
ffff8800bec13b20
[   25.623699] Call Trace:
[   25.623713]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
[   25.623720]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
[   25.623725]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
[   25.623730]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
[   25.623757]  [<ffffffffa0067455>]
read_extent_buffer_pages+0x265/0x340 [btrfs]
[   25.623844]  [<ffffffffa00418fe>]
btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
[   25.623889]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
[   25.623932]  [<ffffffffa0026665>]
read_block_for_search.isra.48+0x165/0x420 [btrfs]
[   25.623957]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
[   25.623984]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
[   25.624018]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
[   25.624087]  [<ffffffff810688d5>] kthread+0x85/0x90
[   25.624093]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
[   25.624097] mount           D ffffffff81608240     0   232      1 0x00000000
[   25.624100]  ffff880036ff37a0 0000000000000086 ffffffff81077798
ffff880036ff3fd8
[   25.624104]  0000000081080557 ffff880036ff3fd8 ffff880036ff3fd8
ffff880036ff3fd8
[   25.624107]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
ffff8800b6f4e600
[   25.624111] Call Trace:
[   25.624116]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
[   25.624122]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
[   25.624126]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
[   25.624138]  [<ffffffffa002ec61>]
cache_block_group.isra.44+0x241/0x380 [btrfs]
[   25.624167]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
[   25.624200]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
[   25.624235]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
[   25.624269]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
[   25.624291]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
[   25.624313]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
[   25.624340]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
[   25.624384]  [<ffffffffa0092286>]
btrfs_update_delayed_inode+0x76/0x160 [btrfs]
[   25.624484]  [<ffffffffa009341e>]
__btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
[   25.624584]  [<ffffffffa00496e7>]
btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
[   25.624625]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
[   25.624631]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
[   25.624636]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
[   25.624641]  [<ffffffff811917aa>] do_mount+0x20a/0x260
[   25.624646]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
[   25.624649]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
[   25.624649]  [<00007f91f7141a3a>] 0x7f91f7141a39
[   25.624649] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
[   25.624649] ktime                                   : 25624.659099
[   25.624649] sched_clk                               : 7064.337499
[   25.624649] cpu_clk                                 : 25624.649041
[   25.624649] jiffies                                 : 4294692919
[   25.624649] sched_clock_stable                      : 0
[   25.624649]
[   25.624649] sysctl_sched
[   25.624649]   .sysctl_sched_latency                    : 12.000000
[   25.624649]   .sysctl_sched_min_granularity            : 1.500000
[   25.624649]   .sysctl_sched_wakeup_granularity         : 2.000000
[   25.624649]   .sysctl_sched_child_runs_first           : 0
[   25.624649]   .sysctl_sched_features                   : 24119
[   25.624649]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[   25.624649]
[   25.624649] cpu#0, 1795.416 MHz
[   25.624649]   .nr_running                    : 0
[   25.624649]   .load                          : 0
[   25.624649]   .nr_switches                   : 15640
[   25.624649]   .nr_load_updates               : 6257
[   25.624649]   .nr_uninterruptible            : -3
[   25.624649]   .next_balance                  : 4294.692918
[   25.624649]   .curr->pid                     : 0
[   25.624649]   .clock                         : 25618.786824
[   25.624649]   .cpu_load[0]                   : 0
[   25.624649]   .cpu_load[1]                   : 0
[   25.624649]   .cpu_load[2]                   : 0
[   25.624649]   .cpu_load[3]                   : 0
[   25.624649]   .cpu_load[4]                   : 0
[   25.624649]   .yld_count                     : 0
[   25.624649]   .sched_count                   : 17355
[   25.624649]   .sched_goidle                  : 6154
[   25.624649]   .avg_idle                      : 898778
[   25.624649]   .ttwu_count                    : 7843
[   25.624649]   .ttwu_local                    : 6132
[   25.624649]
[   25.624649] cfs_rq[0]:/
[   25.624649]   .exec_clock                    : 1882.913755
[   25.624649]   .MIN_vruntime                  : 0.000001
[   25.624649]   .min_vruntime                  : 2133.320027
[   25.624649]   .max_vruntime                  : 0.000001
[   25.624649]   .spread                        : 0.000000
[   25.624649]   .spread0                       : 0.000000
[   25.624649]   .nr_spread_over                : 47
[   25.624649]   .nr_running                    : 0
[   25.624649]   .load                          : 0
[   25.624649]   .load_avg                      : 0.000000
[   25.624649]   .load_period                   : 0.000000
[   25.624649]   .load_contrib                  : 0
[   25.624649]   .load_tg                       : 0
[   25.624649]
[   25.624649] rt_rq[0]:/
[   25.624649]   .rt_nr_running                 : 0
[   25.624649]   .rt_throttled                  : 0
[   25.624649]   .rt_time                       : 0.000000
[   25.624649]   .rt_runtime                    : 950.000000
[   25.624649]
[   25.624649] runnable tasks:
[   25.624649]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   25.624649] ----------------------------------------------------------------------------------------------------------
[   25.624649]
[   25.624649] cpu#1, 1795.416 MHz
[   25.624649]   .nr_running                    : 0
[   25.624649]   .load                          : 0
[   25.624649]   .nr_switches                   : 14240
[   25.624649]   .nr_load_updates               : 7029
[   25.624649]   .nr_uninterruptible            : 5
[   25.624649]   .next_balance                  : 4294.693064
[   25.624649]   .curr->pid                     : 0
[   25.624649]   .clock                         : 25620.774323
[   25.624649]   .cpu_load[0]                   : 0
[   25.624649]   .cpu_load[1]                   : 128
[   25.624649]   .cpu_load[2]                   : 144
[   25.624649]   .cpu_load[3]                   : 104
[   25.624649]   .cpu_load[4]                   : 82
[   25.624649]   .yld_count                     : 0
[   25.624649]   .sched_count                   : 15721
[   25.624649]   .sched_goidle                  : 5413
[   25.624649]   .avg_idle                      : 1000000
[   25.624649]   .ttwu_count                    : 8077
[   25.624649]   .ttwu_local                    : 5875
[   25.624649]
[   25.624649] cfs_rq[1]:/
[   25.624649]   .exec_clock                    : 3328.821504
[   25.624649]   .MIN_vruntime                  : 0.000001
[   25.624649]   .min_vruntime                  : 4011.902391
[   25.624649]   .max_vruntime                  : 0.000001
[   25.624649]   .spread                        : 0.000000
[   25.624649]   .spread0                       : 1878.582364
[   25.624649]   .nr_spread_over                : 75
[   25.624649]   .nr_running                    : 0
[   25.624649]   .load                          : 0
[   25.624649]   .load_avg                      : 0.000000
[   25.624649]   .load_period                   : 0.000000
[   25.624649]   .load_contrib                  : 0
[   25.624649]   .load_tg                       : 0
[   25.624649]
[   25.624649] rt_rq[1]:/
[   25.624649]   .rt_nr_running                 : 0
[   25.624649]   .rt_throttled                  : 0
[   25.624649]   .rt_time                       : 0.000000
[   25.624649]   .rt_runtime                    : 950.000000
[   25.624649]
[   25.624649] runnable tasks:
[   25.624649]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   25.624649] ----------------------------------------------------------------------------------------------------------
[   25.624649]
[   36.120328] SysRq : Show Blocked State
[   36.120334]   task                        PC stack   pid father
[   36.120349] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
[   36.120354]  ffff880036b09a70 0000000000000046 00000000000005a5
ffff880036b09fd8
[   36.120358]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
ffff880036b09fd8
[   36.120362]  ffff8800ba3323c0 ffff880036a56840 0000000000000000
ffff8800bed13b20
[   36.120366] Call Trace:
[   36.120380]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
[   36.120387]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
[   36.120393]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
[   36.120398]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
[   36.120424]  [<ffffffffa0067455>]
read_extent_buffer_pages+0x265/0x340 [btrfs]
[   36.120506]  [<ffffffffa00418fe>]
btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
[   36.120551]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
[   36.120594]  [<ffffffffa0026665>]
read_block_for_search.isra.48+0x165/0x420 [btrfs]
[   36.120618]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
[   36.120646]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
[   36.120680]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
[   36.120749]  [<ffffffff810688d5>] kthread+0x85/0x90
[   36.120754]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
[   36.120758] mount           D ffffffff81608240     0   232      1 0x00000000
[   36.120762]  ffff880036ff37a0 0000000000000086 ffffffff81077798
ffff880036ff3fd8
[   36.120765]  0000000081080557 ffff880036ff3fd8 ffff880036ff3fd8
ffff880036ff3fd8
[   36.120769]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
ffff8800b6f4e600
[   36.120772] Call Trace:
[   36.120777]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
[   36.120783]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
[   36.120787]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
[   36.120799]  [<ffffffffa002ec61>]
cache_block_group.isra.44+0x241/0x380 [btrfs]
[   36.120828]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
[   36.120862]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
[   36.120897]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
[   36.120931]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
[   36.120953]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
[   36.120975]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
[   36.121002]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
[   36.121045]  [<ffffffffa0092286>]
btrfs_update_delayed_inode+0x76/0x160 [btrfs]
[   36.121145]  [<ffffffffa009341e>]
__btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
[   36.121245]  [<ffffffffa00496e7>]
btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
[   36.121286]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
[   36.121292]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
[   36.121297]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
[   36.121302]  [<ffffffff811917aa>] do_mount+0x20a/0x260
[   36.121307]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
[   36.121311]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
[   36.121316]  [<00007f91f7141a3a>] 0x7f91f7141a39
[   36.121318] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
[   36.121318] ktime                                   : 36121.320077
[   36.121318] sched_clk                               : 8391.291398
[   36.121318] cpu_clk                                 : 36121.318470
[   36.121318] jiffies                                 : 4294703416
[   36.121318] sched_clock_stable                      : 0
[   36.121318]
[   36.121318] sysctl_sched
[   36.121318]   .sysctl_sched_latency                    : 12.000000
[   36.121318]   .sysctl_sched_min_granularity            : 1.500000
[   36.121318]   .sysctl_sched_wakeup_granularity         : 2.000000
[   36.121318]   .sysctl_sched_child_runs_first           : 0
[   36.121318]   .sysctl_sched_features                   : 24119
[   36.121318]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[   36.121318]
[   36.121318] cpu#0, 1795.416 MHz
[   36.121318]   .nr_running                    : 0
[   36.121318]   .load                          : 0
[   36.121318]   .nr_switches                   : 20280
[   36.121318]   .nr_load_updates               : 8517
[   36.121318]   .nr_uninterruptible            : -3
[   36.121318]   .next_balance                  : 4294.703418
[   36.121318]   .curr->pid                     : 0
[   36.121318]   .clock                         : 36118.067602
[   36.121318]   .cpu_load[0]                   : 0
[   36.121318]   .cpu_load[1]                   : 0
[   36.121318]   .cpu_load[2]                   : 0
[   36.121318]   .cpu_load[3]                   : 0
[   36.121318]   .cpu_load[4]                   : 0
[   36.121318]   .yld_count                     : 0
[   36.121318]   .sched_count                   : 22925
[   36.121318]   .sched_goidle                  : 8213
[   36.121318]   .avg_idle                      : 717345
[   36.121318]   .ttwu_count                    : 10297
[   36.121318]   .ttwu_local                    : 7984
[   36.121318]
[   36.121318] cfs_rq[0]:/
[   36.121318]   .exec_clock                    : 2417.624169
[   36.121318]   .MIN_vruntime                  : 0.000001
[   36.121318]   .min_vruntime                  : 2599.573906
[   36.121318]   .max_vruntime                  : 0.000001
[   36.121318]   .spread                        : 0.000000
[   36.121318]   .spread0                       : 0.000000
[   36.121318]   .nr_spread_over                : 47
[   36.121318]   .nr_running                    : 0
[   36.121318]   .load                          : 0
[   36.121318]   .load_avg                      : 0.000000
[   36.121318]   .load_period                   : 0.000000
[   36.121318]   .load_contrib                  : 0
[   36.121318]   .load_tg                       : 0
[   36.121318]
[   36.121318] rt_rq[0]:/
[   36.121318]   .rt_nr_running                 : 0
[   36.121318]   .rt_throttled                  : 0
[   36.121318]   .rt_time                       : 0.030199
[   36.121318]   .rt_runtime                    : 950.000000
[   36.121318]
[   36.121318] runnable tasks:
[   36.121318]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   36.121318] ----------------------------------------------------------------------------------------------------------
[   36.121318]
[   36.121318] cpu#1, 1795.416 MHz
[   36.121318]   .nr_running                    : 0
[   36.121318]   .load                          : 0
[   36.121318]   .nr_switches                   : 18668
[   36.121318]   .nr_load_updates               : 9064
[   36.121318]   .nr_uninterruptible            : 5
[   36.121318]   .next_balance                  : 4294.703493
[   36.121318]   .curr->pid                     : 0
[   36.121318]   .clock                         : 36111.032064
[   36.121318]   .cpu_load[0]                   : 1024
[   36.121318]   .cpu_load[1]                   : 560
[   36.121318]   .cpu_load[2]                   : 403
[   36.121318]   .cpu_load[3]                   : 293
[   36.121318]   .cpu_load[4]                   : 204
[   36.121318]   .yld_count                     : 0
[   36.121318]   .sched_count                   : 21114
[   36.121318]   .sched_goidle                  : 7366
[   36.121318]   .avg_idle                      : 709543
[   36.121318]   .ttwu_count                    : 10475
[   36.121318]   .ttwu_local                    : 7655
[   36.121318]
[   36.121318] cfs_rq[1]:/
[   36.121318]   .exec_clock                    : 3757.233371
[   36.121318]   .MIN_vruntime                  : 0.000001
[   36.121318]   .min_vruntime                  : 4373.535480
[   36.121318]   .max_vruntime                  : 0.000001
[   36.121318]   .spread                        : 0.000000
[   36.121318]   .spread0                       : 1773.961574
[   36.121318]   .nr_spread_over                : 75
[   36.121318]   .nr_running                    : 0
[   36.121318]   .load                          : 0
[   36.121318]   .load_avg                      : 0.000000
[   36.121318]   .load_period                   : 0.000000
[   36.121318]   .load_contrib                  : 0
[   36.121318]   .load_tg                       : 0
[   36.121318]
[   36.121318] rt_rq[1]:/
[   36.121318]   .rt_nr_running                 : 0
[   36.121318]   .rt_throttled                  : 0
[   36.121318]   .rt_time                       : 0.017123
[   36.121318]   .rt_runtime                    : 950.000000
[   36.121318]
[   36.121318] runnable tasks:
[   36.121318]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   36.121318] ----------------------------------------------------------------------------------------------------------
[   36.121318]
[   95.634151] SysRq : Show Blocked State
[   95.634344]   task                        PC stack   pid father
[   95.634358] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
[   95.634363]  ffff880036b09a70 0000000000000046 000000000000016e
ffff880036b09fd8
[   95.634367]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
ffff880036b09fd8
[   95.634370]  ffff8800ba3323c0 ffff880036a56840 0000000000000000
ffff8800bed13b20
[   95.634374] Call Trace:
[   95.634389]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
[   95.634395]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
[   95.634400]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
[   95.634404]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
[   95.634430]  [<ffffffffa0067455>]
read_extent_buffer_pages+0x265/0x340 [btrfs]
[   95.634504]  [<ffffffffa00418fe>]
btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
[   95.634549]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
[   95.634592]  [<ffffffffa0026665>]
read_block_for_search.isra.48+0x165/0x420 [btrfs]
[   95.634617]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
[   95.634645]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
[   95.634679]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
[   95.634747]  [<ffffffff810688d5>] kthread+0x85/0x90
[   95.634753]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
[   95.634757] btrfs-transacti D ffffffff81608240     0   226      2 0x00000000
[   95.634760]  ffff880036f37db0 0000000000000046 0000000000000000
ffff880036f37fd8
[   95.634764]  ffff88003688e1c0 ffff880036f37fd8 ffff880036f37fd8
ffff880036f37fd8
[   95.634767]  ffff8800ba3323c0 ffff88003688e1c0 0000000000000246
ffff88003645fe70
[   95.634771] Call Trace:
[   95.634786]  [<ffffffffa0047c55>] wait_for_commit.isra.19+0x55/0x90 [btrfs]
[   95.634835]  [<ffffffffa0049c31>]
btrfs_commit_transaction+0x901/0xb40 [btrfs]
[   95.634885]  [<ffffffffa00425fd>] transaction_kthread+0x19d/0x220 [btrfs]
[   95.634920]  [<ffffffff810688d5>] kthread+0x85/0x90
[   95.634924]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
[   95.634927] mount           D ffffffff81608240     0   232      1 0x00000000
[   95.634930]  ffff880036ff37a0 0000000000000086 ffffffff81077798
ffff880036ff3fd8
[   95.634934]  ffff880036a56e74 ffff880036ff3fd8 ffff880036ff3fd8
ffff880036ff3fd8
[   95.634937]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
ffff8800b6f4e600
[   95.634940] Call Trace:
[   95.634945]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
[   95.634951]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
[   95.634955]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
[   95.634967]  [<ffffffffa002ec61>]
cache_block_group.isra.44+0x241/0x380 [btrfs]
[   95.634996]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
[   95.635029]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
[   95.635065]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
[   95.635098]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
[   95.635120]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
[   95.635141]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
[   95.635141]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
[   95.635141]  [<ffffffffa0092286>]
btrfs_update_delayed_inode+0x76/0x160 [btrfs]
[   95.635141]  [<ffffffffa009341e>]
__btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
[   95.635141]  [<ffffffffa00496e7>]
btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
[   95.635141]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
[   95.635141]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
[   95.635141]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
[   95.635141]  [<ffffffff811917aa>] do_mount+0x20a/0x260
[   95.635141]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
[   95.635141]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
[   95.635141]  [<00007f91f7141a3a>] 0x7f91f7141a39
[   95.635141] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
[   95.635141] ktime                                   : 95635.487872
[   95.635141] sched_clk                               : 11797.958510
[   95.635141] cpu_clk                                 : 95635.141180
[   95.635141] jiffies                                 : 4294762930
[   95.635141] sched_clock_stable                      : 0
[   95.635141]
[   95.635141] sysctl_sched
[   95.635141]   .sysctl_sched_latency                    : 12.000000
[   95.635141]   .sysctl_sched_min_granularity            : 1.500000
[   95.635141]   .sysctl_sched_wakeup_granularity         : 2.000000
[   95.635141]   .sysctl_sched_child_runs_first           : 0
[   95.635141]   .sysctl_sched_features                   : 24119
[   95.635141]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[   95.635141]
[   95.635141] cpu#0, 1795.416 MHz
[   95.635141]   .nr_running                    : 0
[   95.635141]   .load                          : 0
[   95.635141]   .nr_switches                   : 40507
[   95.635141]   .nr_load_updates               : 17782
[   95.635141]   .nr_uninterruptible            : -3
[   95.635141]   .next_balance                  : 4294.762900
[   95.635141]   .curr->pid                     : 0
[   95.635141]   .clock                         : 95631.914946
[   95.635141]   .cpu_load[0]                   : 0
[   95.635141]   .cpu_load[1]                   : 0
[   95.635141]   .cpu_load[2]                   : 0
[   95.635141]   .cpu_load[3]                   : 0
[   95.635141]   .cpu_load[4]                   : 0
[   95.635141]   .yld_count                     : 0
[   95.635141]   .sched_count                   : 47787
[   95.635141]   .sched_goidle                  : 17131
[   95.635141]   .avg_idle                      : 889340
[   95.635141]   .ttwu_count                    : 21460
[   95.635141]   .ttwu_local                    : 15717
[   95.635141]
[   95.635141] cfs_rq[0]:/
[   95.635141]   .exec_clock                    : 3245.515102
[   95.635141]   .MIN_vruntime                  : 0.000001
[   95.635141]   .min_vruntime                  : 3320.081027
[   95.635141]   .max_vruntime                  : 0.000001
[   95.635141]   .spread                        : 0.000000
[   95.635141]   .spread0                       : 0.000000
[   95.635141]   .nr_spread_over                : 47
[   95.635141]   .nr_running                    : 0
[   95.635141]   .load                          : 0
[   95.635141]   .load_avg                      : 0.000000
[   95.635141]   .load_period                   : 0.000000
[   95.635141]   .load_contrib                  : 0
[   95.635141]   .load_tg                       : 0
[   95.635141]
[   95.635141] rt_rq[0]:/
[   95.635141]   .rt_nr_running                 : 0
[   95.635141]   .rt_throttled                  : 0
[   95.635141]   .rt_time                       : 0.000000
[   95.635141]   .rt_runtime                    : 950.000000
[   95.635141]
[   95.635141] runnable tasks:
[   95.635141]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   95.635141] ----------------------------------------------------------------------------------------------------------
[   95.635141]
[   95.635141] cpu#1, 1795.416 MHz
[   95.635141]   .nr_running                    : 0
[   95.635141]   .load                          : 0
[   95.635141]   .nr_switches                   : 38358
[   95.635141]   .nr_load_updates               : 17854
[   95.635141]   .nr_uninterruptible            : 6
[   95.635141]   .next_balance                  : 4294.762929
[   95.635141]   .curr->pid                     : 0
[   95.635141]   .clock                         : 95631.964813
[   95.635141]   .cpu_load[0]                   : 0
[   95.635141]   .cpu_load[1]                   : 0
[   95.635141]   .cpu_load[2]                   : 0
[   95.635141]   .cpu_load[3]                   : 0
[   95.635141]   .cpu_load[4]                   : 0
[   95.635141]   .yld_count                     : 0
[   95.635141]   .sched_count                   : 45459
[   95.635141]   .sched_goidle                  : 16039
[   95.635141]   .avg_idle                      : 902589
[   95.635141]   .ttwu_count                    : 21363
[   95.635141]   .ttwu_local                    : 15125
[   95.635141]
[   95.635141] cfs_rq[1]:/
[   95.635141]   .exec_clock                    : 4548.674243
[   95.635141]   .MIN_vruntime                  : 0.000001
[   95.635141]   .min_vruntime                  : 5061.497501
[   95.635141]   .max_vruntime                  : 0.000001
[   95.635141]   .spread                        : 0.000000
[   95.635141]   .spread0                       : 1741.416474
[   95.635141]   .nr_spread_over                : 75
[   95.635141]   .nr_running                    : 0
[   95.635141]   .load                          : 0
[   95.635141]   .load_avg                      : 0.000000
[   95.635141]   .load_period                   : 0.000000
[   95.635141]   .load_contrib                  : 0
[   95.635141]   .load_tg                       : 0
[   95.635141]
[   95.635141] rt_rq[1]:/
[   95.635141]   .rt_nr_running                 : 0
[   95.635141]   .rt_throttled                  : 0
[   95.635141]   .rt_time                       : 0.000000
[   95.635141]   .rt_runtime                    : 950.000000
[   95.635141]
[   95.635141] runnable tasks:
[   95.635141]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[   95.635141] ----------------------------------------------------------------------------------------------------------
[   95.635141]
[  129.014483] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
[  132.309219] udevd[313]: starting version 182
[  136.204791] firmware microcode: firmware_loading_store: unexpected value (0)


and here's my boot.log:

Trying manual resume from
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
Invoking userspace resume from
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
resume: libgcrypt version: 1.5.0
Trying manual resume from
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
Invoking in-kernel resume from
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
Waiting for device /dev/root to appear:  ok
fsck from util-linux 2.21.2
[/sbin/fsck.btrfs (1) -- /] fsck.btrfs -a /dev/sda6
fsck succeeded. Mounting root device read-write.
Mounting root /dev/root
mount -o rw,defaults,comment=systemd.automount -t btrfs /dev/root /root

Welcome to  [0;32mopenSUSE 12.2 (Mantis) (x86_64) [0m!

Starting Collect Read-Ahead Data...
Starting Replay Read-Ahead Data...
Starting LSB: setup hostname and yp...
Starting Runtime Directory...
Starting Huge Pages File System...
Starting POSIX Message Queue File System...
Starting Debug File System...
Starting Security File System...
Starting create /dev/root symlink with dynamic rule...
Starting Journal Service...
Started Journal Service
                                                [ [1;32m  OK   [0m]
Started Collect Read-Ahead Data
                                                [ [1;32m  OK   [0m]
Started Replay Read-Ahead Data
                                                [ [1;32m  OK   [0m]
Started Set Up Additional Binary Formats
                                                [ [1;32m  OK   [0m]
Starting Load Kernel Modules...
Starting Load Random Seed...
Starting Setup Virtual Console...
Started Load Random Seed
                                                [ [1;32m  OK   [0m]
Started Runtime Directory
                                                [ [1;32m  OK   [0m]
Started Debug File System
                                                [ [1;32m  OK   [0m]
Started POSIX Message Queue File System
                                                [ [1;32m  OK   [0m]
Started Huge Pages File System
                                                [ [1;32m  OK   [0m]
Started Security File System
                                                [ [1;32m  OK   [0m]
Started LSB: setup hostname and yp
                                                [ [1;32m  OK   [0m]
 (KStarted create /dev/root symlink with dynamic rule
                                                   [ [1;32m  OK   [0m]
Starting udev Kernel Device Manager...
Started udev Kernel Device Manager
                                                [ [1;32m  OK   [0m]
Started Setup Virtual Console
                                                [ [1;32m  OK   [0m]
Starting udev Coldplug all Devices...
Started udev Coldplug all Devices
                                                [ [1;32m  OK   [0m]
Started Show Plymouth Boot Screen
                                                [ [1;32m  OK   [0m]
Started Load Kernel Modules
                                                [ [1;32m  OK   [0m]
Started FUSE Control File System
                                                [ [1;32m  OK   [0m]
Started Configuration File System
                                                [ [1;32m  OK   [0m]
Starting Apply Kernel Variables...
Started Apply Kernel Variables
                                                [ [1;32m  OK   [0m]
Starting File System Check on
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part2...
Starting /dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1...
Started /dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
                                                [ [1;32m  OK   [0m]
Started File System Check on
/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part2
                   [ [1;32m  OK   [0m]
Starting /boot...
Started /boot
                                                [ [1;32m  OK   [0m]
Starting Recreate Volatile Files and Directories...
Starting Tell Plymouth To Write Out Runtime Data...
Started Recreate Volatile Files and Directories
                                                [ [1;32m  OK   [0m]
Started Tell Plymouth To Write Out Runtime Data
                                                [ [1;32m  OK   [0m]
Starting Restore Sound Card State...
Starting Console System Startup Logging...
Starting LSB: Framebuffer setup...
Starting System Logging Service...
Starting Haveged Entropy Gathering Daemon...
Started Haveged Entropy Gathering Daemon
                                                [ [1;32m  OK   [0m]
Starting Name Service Cache Daemon...
Started Name Service Cache Daemon
                                                [ [1;32m  OK   [0m]
Started YaST2 Second Stage
                                                [ [1;32m  OK   [0m]
Started YaST2 Firstboot
                                                [ [1;32m  OK   [0m]
Starting LSB: Configure the localfs depending network interfaces...
Starting Login Service...
Starting Permit User Sessions...
Started Restore Sound Card State
                                                [ [1;32m  OK   [0m]
Started Console System Startup Logging
                                                [ [1;32m  OK   [0m]
Started LSB: Framebuffer setup
                                                [ [1;32m  OK   [0m]
Started Permit User Sessions
                                                [ [1;32m  OK   [0m]
Starting Getty on tty1...
Started Getty on tty1
                                                [ [1;32m  OK   [0m]
Stopped systemd-kmsg-syslogd.service
                                                [ [1;32m  OK   [0m]
Started LSB: Configure the localfs depending network interfaces
                                                [ [1;32m  OK   [0m]
Started System Logging Service
                                                [ [1;32m  OK   [0m]
Starting ACPI Event Daemon...
Starting D-Bus System Message Bus...
Started D-Bus System Message Bus
                                                [ [1;32m  OK   [0m]
Starting LSB: VirtualBox Linux kernel module...
Starting Network Manager...
Started ACPI Event Daemon
                                                [ [1;32m  OK   [0m]
Started Login Service
                                                [ [1;32m  OK   [0m]
Started LSB: VirtualBox Linux kernel module
                                                [ [1;32m  OK   [0m]
Starting LSB: VirtualBox balloon control daemon...
Starting LSB: VirtualBox autostart service...
Starting LSB: VirtualBox web service API...
Started LSB: VirtualBox autostart service
                                                [ [1;32m  OK   [0m]
Started LSB: VirtualBox balloon control daemon
                                                [ [1;32m  OK   [0m]
Started LSB: VirtualBox web service API
                                                [ [1;32m  OK   [0m]
systemd-fsck[537]: /dev/sda2: clean, 351/128520 files, 83570/514080 blocks
Started Network Manager
                                                [ [1;32m  OK   [0m]
Starting Network Manager Wait Online...
Started Network Manager Wait Online
                                                [ [1;32m  OK   [0m]
Starting Command Scheduler...
Started Command Scheduler
                                                [ [1;32m  OK   [0m]
Starting LSB: handles udev coldplug of bluetooth dongles...
Starting LSB: Configure the remote-fs depending network interfaces...
Starting /etc/init.d/boot.local Compatibility...
Started /etc/init.d/boot.local Compatibility
                                                [ [1;32m  OK   [0m]
Started Network Manager
                                                [ [1;32m  OK   [0m]
Started LSB: Configure the remote-fs depending network interfaces
                                                [ [1;32m  OK   [0m]
Starting LSB: Network time protocol daemon (ntpd)...
Started LSB: handles udev coldplug of bluetooth dongles
                                                [ [1;32m  OK   [0m]
Started LSB: Network time protocol daemon (ntpd)
                                                [ [1;32m  OK   [0m]
Starting LSB: X Display Manager...
Started LSB: X Display Manager
                                                [ [1;32m  OK   [0m]


I made the snapshot at:

mount -o rw,defaults,comment=systemd.automount -t btrfs /dev/root /root

and

Starting Tell Plymouth To Write Out Runtime Data...
Started Recreate Volatile Files and Directories


is it useful this time?

Thanks!

Marguerite
