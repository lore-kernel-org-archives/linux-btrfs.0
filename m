Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37747 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2KHRwU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 12:52:20 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so3136683oag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2012 09:52:19 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 11:52:19 -0600
Message-ID: <CAKcLGm-JWd846J9P98jKWKEdtHNhF2BZbi0rH0a5nErNVwFzYw@mail.gmail.com>
Subject: Btrfs Slow Down (Metadata Starvation?)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of my Btrfs partitions ran into a severe slowdown recently.
Operations that would normally complete in 20-30 seconds were now
requiring hours.

There were no errors or warnings in dmesg (Alt-SysRq-W is below, but
shows nothing out of the ordinary).  And if I took the partition
offline, it would pass btrfsck without error.  So far, I've found not
indications of corruption.

The kernel is a version 3.6.6 merged with the for-linus branch for
3.7.  I usually mount with compress-force-lzo, but no autodefrag or
other options.

The symptoms were consistent with some kind of corner case metadata starvation.

While under pressure, my 'btrfs df' would show something like the following:

# btrfs fi df /mnt/sabayon9/
Data: total=7.00GB, used=6.00GB
System: total=4.00MB, used=4.00KB
Metadata: total=768.00MB, used=737.65MB

For some reason, btrfs was not allocating any additional metadata space.

The partition is 25 GB, and not very full:
/dev/sda2      btrfs     25165824   7047816  18082844  29% /mnt/sabayon9

When I rebooted into a 3.4 kernel (which is merged with the Btrfs code
for 3.5), the slow down cleared after I mounted the partition, and
triggered an allocation of metadata up to 1 GB.

I would note that I tried my 3.5 vintage kernel (which is merged with
the Btrfs code for 3.6), and was unable to clear the issue.  This
tends to strengthen my suspicion that this is some kind of corner case
since this code has been out there for a while now.

Currently, I'm showing something like this with 'btrfs df'

# btrfs fi df /mnt/sabayon9/
Data: total=8.00GB, used=5.97GB
System: total=4.00MB, used=4.00KB
Metadata: total=1.00GB, used=722.65MB

Now, everything is operating normally in my 3.6.6 kernel.

I've saved an image of the partition in it's 'slow-down' condition in
case it becomes desirable to test something in that condition.

I'm including my dmesg output of an Alt-SysRq-W operation, but I don't
see anything useful there.

[18697.498504] SysRq : Show Blocked State
[18697.498510]   task                        PC stack   pid father
[18697.498551] btrfs-submit-1  D 0000000000000210     0  4236      2 0x00000000
[18697.498556]  ffff880123d53b70 0000000000000046 ffff8801231908d0
ffff880123d53fd8
[18697.498560]  0000000000004000 0000000000012700 ffff88012aaf4380
ffff880124269680
[18697.498563]  0000000000000006 ffff880125e18000 ffff880125e18000
0000000000000000
[18697.498567] Call Trace:
[18697.498576]  [<ffffffff812d8750>] ? __blk_run_queue+0x1e/0x20
[18697.498580]  [<ffffffff812db573>] ? queue_unplugged+0x83/0x99
[18697.498585]  [<ffffffff8161dcf4>] schedule+0x64/0x66
[18697.498588]  [<ffffffff8161dd85>] io_schedule+0x8f/0xce
[18697.498591]  [<ffffffff812dd520>] get_request+0x559/0x5b0
[18697.498596]  [<ffffffff8104c79b>] ? abort_exclusive_wait+0x8e/0x8e
[18697.498599]  [<ffffffff812de7de>] blk_queue_bio+0x1b7/0x315
[18697.498602]  [<ffffffff812dcbc3>] generic_make_request+0x9f/0xe1
[18697.498605]  [<ffffffff812dcce9>] submit_bio+0xe4/0x103
[18697.498640]  [<ffffffffa006a145>] run_scheduled_bios+0x28c/0x428 [btrfs]
[18697.498660]  [<ffffffffa006a2f6>] pending_bios_fn+0x15/0x17 [btrfs]
[18697.498679]  [<ffffffffa0071840>] worker_loop+0x15f/0x497 [btrfs]
[18697.498698]  [<ffffffffa00716e1>] ? btrfs_queue_worker+0x272/0x272 [btrfs]
[18697.498702]  [<ffffffff8104c072>] kthread+0x8b/0x93
[18697.498707]  [<ffffffff816205b4>] kernel_thread_helper+0x4/0x10
[18697.498710]  [<ffffffff8104bfe7>] ? kthread_freezable_should_stop+0x57/0x57
[18697.498714]  [<ffffffff816205b0>] ? gs_change+0xb/0xb
[18697.498718] btrfs-transacti D 0000000000000002     0  4248      2 0x00000000
[18697.498721]  ffff880123d83b70 0000000000000046 0000000000000000
ffff880123d83fd8
[18697.498725]  0000000000004000 0000000000012700 ffff88012aaf4380
ffff880123d79680
[18697.498728]  ffffffffa0049342 ffff880123d83bf0 ffff880123d83b10
ffffffff810c9ee4
[18697.498732] Call Trace:
[18697.498748]  [<ffffffffa0049342>] ? check_leaf+0x2d4/0x2d4 [btrfs]
[18697.498753]  [<ffffffff810c9ee4>] ? release_pages+0x1b2/0x1c1
[18697.498772]  [<ffffffffa0063068>] ? submit_one_bio+0x8a/0x94 [btrfs]
[18697.498776]  [<ffffffff8106c8db>] ? ktime_get_ts+0x56/0xbc
[18697.498780]  [<ffffffff8109c171>] ? delayacct_end+0x79/0x84
[18697.498784]  [<ffffffff810bf744>] ? __lock_page+0x68/0x68
[18697.498787]  [<ffffffff8161dcf4>] schedule+0x64/0x66
[18697.498790]  [<ffffffff8161dd85>] io_schedule+0x8f/0xce
[18697.498793]  [<ffffffff810bf752>] sleep_on_page+0xe/0x12
[18697.498796]  [<ffffffff8161c436>] __wait_on_bit+0x48/0x7b
[18697.498799]  [<ffffffff810bf4b9>] ? find_get_pages_tag+0xf4/0x130
[18697.498803]  [<ffffffff810bf97d>] wait_on_page_bit+0x72/0x74
[18697.498806]  [<ffffffff8104c7d3>] ? autoremove_wake_function+0x38/0x38
[18697.498810]  [<ffffffff810bfa4c>] filemap_fdatawait_range+0x87/0x13e
[18697.498829]  [<ffffffffa0063c09>] ? free_extent_state+0x7d/0x85 [btrfs]
[18697.498849]  [<ffffffffa0064631>] ? clear_extent_bit+0x272/0x2aa [btrfs]
[18697.498866]  [<ffffffffa004f696>] btrfs_wait_marked_extents+0x7d/0xce [btrfs]
[18697.498884]  [<ffffffffa004f715>]
btrfs_write_and_wait_marked_extents+0x2e/0x3e [btrfs]
[18697.498902]  [<ffffffffa004f769>]
btrfs_write_and_wait_transaction+0x44/0x46 [btrfs]
[18697.498919]  [<ffffffffa004fea0>]
btrfs_commit_transaction+0x65b/0x969 [btrfs]
[18697.498923]  [<ffffffff8104c79b>] ? abort_exclusive_wait+0x8e/0x8e
[18697.498939]  [<ffffffffa0049700>] transaction_kthread+0xdf/0x1a0 [btrfs]
[18697.498956]  [<ffffffffa0049621>] ? cleaner_kthread+0xe6/0xe6 [btrfs]
[18697.498959]  [<ffffffff8104c072>] kthread+0x8b/0x93
[18697.498963]  [<ffffffff816205b4>] kernel_thread_helper+0x4/0x10
[18697.498967]  [<ffffffff8104bfe7>] ? kthread_freezable_should_stop+0x57/0x57
[18697.498970]  [<ffffffff816205b0>] ? gs_change+0xb/0xb
[18697.498987] cp              D 0000000000030000     0  5847   4147 0x00000000
[18697.498990]  ffff880100ce1ba8 0000000000000086 ffff880100ce1aa8
ffff880100ce1fd8
[18697.498994]  0000000000004000 0000000000012700 ffff880123d79680
ffff880096ea2d00
[18697.498998]  ffff880100ce1b28 0000000000000004 ffff880100ce1ae8
ffff880124339b00
[18697.499001] Call Trace:
[18697.499016]  [<ffffffffa003e133>] ?
reserve_metadata_bytes.isra.61+0x229/0x6ac [btrfs]
[18697.499020]  [<ffffffff8161dcf4>] schedule+0x64/0x66
[18697.499037]  [<ffffffffa004f309>]
wait_current_trans.isra.28+0xac/0xdd [btrfs]
[18697.499041]  [<ffffffff8104c79b>] ? abort_exclusive_wait+0x8e/0x8e
[18697.499059]  [<ffffffffa00508a6>] start_transaction+0x3ae/0x3c3 [btrfs]
[18697.499077]  [<ffffffffa0050b5f>] btrfs_start_transaction+0x15/0x17 [btrfs]
[18697.499096]  [<ffffffffa00615b0>] __btrfs_setxattr+0x4d/0xd9 [btrfs]
[18697.499115]  [<ffffffffa009cfe7>] btrfs_set_acl+0x10b/0x19c [btrfs]
[18697.499119]  [<ffffffff81118b07>] ? __d_lookup+0x67/0x133
[18697.499137]  [<ffffffffa009d100>] btrfs_xattr_acl_set+0x88/0xb4 [btrfs]
[18697.499141]  [<ffffffff8111de43>] ? mntput_no_expire+0x3f/0x13c
[18697.499144]  [<ffffffff811213d6>] generic_removexattr+0x4f/0x56
[18697.499164]  [<ffffffffa0061a85>] btrfs_removexattr+0x51/0x86 [btrfs]
[18697.499167]  [<ffffffff811215f8>] vfs_removexattr+0x83/0xf1
[18697.499170]  [<ffffffff811216c1>] removexattr+0x5b/0x7b
[18697.499174]  [<ffffffff8110ee64>] ? putname+0x32/0x3b
[18697.499177]  [<ffffffff81112b71>] ? user_path_at_empty+0x61/0x92
[18697.499181]  [<ffffffff81106e5e>] ? __sb_start_write+0xbc/0xf0
[18697.499184]  [<ffffffff8111de43>] ? mntput_no_expire+0x3f/0x13c
[18697.499187]  [<ffffffff8111e19f>] ? __mnt_want_write+0x37/0x4f
[18697.499190]  [<ffffffff8111e1e3>] ? mnt_want_write+0x2c/0x4b
[18697.499193]  [<ffffffff811223d2>] sys_removexattr+0x4d/0x6c
[18697.499197]  [<ffffffff8161f3d6>] system_call_fastpath+0x1a/0x1f
[18697.499201] Sched Debug Version: v0.10, 3.6.6-git-local+ #1
[18697.499203] ktime                                   : 18697499.202192
[18697.499205] sched_clk                               : 18649901.375756
[18697.499207] cpu_clk                                 : 18697499.200417
[18697.499209] jiffies                                 : 4313364794
[18697.499210] sched_clock_stable                      : 0
[18697.499211]
[18697.499212] sysctl_sched
[18697.499214]   .sysctl_sched_latency                    : 12.000000
[18697.499216]   .sysctl_sched_min_granularity            : 1.500000
[18697.499217]   .sysctl_sched_wakeup_granularity         : 2.000000
[18697.499219]   .sysctl_sched_child_runs_first           : 0
[18697.499220]   .sysctl_sched_features                   : 24119
[18697.499222]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[18697.499224]
[18697.499224] cpu#0, 2666.778 MHz
[18697.499226]   .nr_running                    : 0
[18697.499228]   .load                          : 0
[18697.499229]   .nr_switches                   : 8543763
[18697.499231]   .nr_load_updates               : 7498116
[18697.499232]   .nr_uninterruptible            : -65
[18697.499234]   .next_balance                  : 4313.364935
[18697.499235]   .curr->pid                     : 0
[18697.499237]   .clock                         : 18697492.765964
[18697.499239]   .cpu_load[0]                   : 0
[18697.499240]   .cpu_load[1]                   : 0
[18697.499241]   .cpu_load[2]                   : 0
[18697.499242]   .cpu_load[3]                   : 0
[18697.499244]   .cpu_load[4]                   : 22
[18697.499245]   .yld_count                     : 2011
[18697.499246]   .sched_count                   : 8848041
[18697.499248]   .sched_goidle                  : 2422414
[18697.499249]   .avg_idle                      : 1000000
[18697.499251]   .ttwu_count                    : 4070219
[18697.499252]   .ttwu_local                    : 2763355
[18697.499254]
[18697.499254] cfs_rq[0]:/autogroup-10
[18697.499257]   .exec_clock                    : 517.528854
[18697.499258]   .MIN_vruntime                  : 0.000001
[18697.499260]   .min_vruntime                  : 1475.651593
[18697.499262]   .max_vruntime                  : 0.000001
[18697.499263]   .spread                        : 0.000000
[18697.499265]   .spread0                       : -12058621.131098
[18697.499266]   .nr_spread_over                : 188
[18697.499268]   .nr_running                    : 0
[18697.499269]   .load                          : 0
[18697.499271]   .load_avg                      : 319.999968
[18697.499272]   .load_period                   : 6.594176
[18697.499274]   .load_contrib                  : 48
[18697.499275]   .load_tg                       : 48
[18697.499277]   .se->exec_start                : 18697468.292146
[18697.499279]   .se->vruntime                  : 12060089.947822
[18697.499281]   .se->sum_exec_runtime          : 517.547323
[18697.499282]   .se->statistics.wait_start     : 0.000000
[18697.499284]   .se->statistics.sleep_start    : 0.000000
[18697.499285]   .se->statistics.block_start    : 0.000000
[18697.499287]   .se->statistics.sleep_max      : 0.000000
[18697.499288]   .se->statistics.block_max      : 0.000000
[18697.499290]   .se->statistics.exec_max       : 9.876033
[18697.499292]   .se->statistics.slice_max      : 0.515916
[18697.499293]   .se->statistics.wait_max       : 3.792060
[18697.499295]   .se->statistics.wait_sum       : 19.139268
[18697.499296]   .se->statistics.wait_count     : 9966
[18697.499298]   .se->load.weight               : 2
[18697.499300]
[18697.499300] cfs_rq[0]:/
[18697.499302]   .exec_clock                    : 5842563.144833
[18697.499304]   .MIN_vruntime                  : 0.000001
[18697.499306]   .min_vruntime                  : 12060096.782691
[18697.499307]   .max_vruntime                  : 0.000001
[18697.499309]   .spread                        : 0.000000
[18697.499310]   .spread0                       : 0.000000
[18697.499312]   .nr_spread_over                : 1914
[18697.499313]   .nr_running                    : 0
[18697.499314]   .load                          : 0
[18697.499316]   .load_avg                      : 0.000000
[18697.499317]   .load_period                   : 0.000000
[18697.499319]   .load_contrib                  : 0
[18697.499320]   .load_tg                       : 0
[18697.499322]
[18697.499322] rt_rq[0]:
[18697.499323]   .rt_nr_running                 : 0
[18697.499325]   .rt_throttled                  : 0
[18697.499326]   .rt_time                       : 0.000000
[18697.499328]   .rt_runtime                    : 950.000000
[18697.499330]
[18697.499330] runnable tasks:
[18697.499330]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[18697.499330] ----------------------------------------------------------------------------------------------------------
[18697.499349]
[18697.499349] cpu#1, 2666.778 MHz
[18697.499351]   .nr_running                    : 0
[18697.499352]   .load                          : 0
[18697.499353]   .nr_switches                   : 8541355
[18697.499355]   .nr_load_updates               : 7522324
[18697.499356]   .nr_uninterruptible            : 68
[18697.499358]   .next_balance                  : 4313.364923
[18697.499359]   .curr->pid                     : 0
[18697.499361]   .clock                         : 18697487.653089
[18697.499362]   .cpu_load[0]                   : 0
[18697.499364]   .cpu_load[1]                   : 0
[18697.499365]   .cpu_load[2]                   : 0
[18697.499366]   .cpu_load[3]                   : 1
[18697.499368]   .cpu_load[4]                   : 48
[18697.499369]   .yld_count                     : 170835
[18697.499370]   .sched_count                   : 9035951
[18697.499372]   .sched_goidle                  : 2395497
[18697.499373]   .avg_idle                      : 890294
[18697.499375]   .ttwu_count                    : 4174757
[18697.499376]   .ttwu_local                    : 2827268
[18697.499378]
[18697.499378] cfs_rq[1]:/autogroup-35
[18697.499380]   .exec_clock                    : 30930.525657
[18697.499382]   .MIN_vruntime                  : 0.000001
[18697.499383]   .min_vruntime                  : 30935.261755
[18697.499385]   .max_vruntime                  : 0.000001
[18697.499386]   .spread                        : 0.000000
[18697.499388]   .spread0                       : -12029161.520936
[18697.499389]   .nr_spread_over                : 2
[18697.499391]   .nr_running                    : 0
[18697.499392]   .load                          : 0
[18697.499394]   .load_avg                      : 3.527416
[18697.499395]   .load_period                   : 8.786121
[18697.499397]   .load_contrib                  : 0
[18697.499398]   .load_tg                       : 0
[18697.499400]   .se->exec_start                : 18697463.132124
[18697.499402]   .se->vruntime                  : 12034839.379971
[18697.499403]   .se->sum_exec_runtime          : 30932.319294
[18697.499405]   .se->statistics.wait_start     : 0.000000
[18697.499406]   .se->statistics.sleep_start    : 0.000000
[18697.499408]   .se->statistics.block_start    : 0.000000
[18697.499410]   .se->statistics.sleep_max      : 0.000000
[18697.499411]   .se->statistics.block_max      : 0.000000
[18697.499413]   .se->statistics.exec_max       : 8.785310
[18697.499414]   .se->statistics.slice_max      : 10.840062
[18697.499416]   .se->statistics.wait_max       : 22.000422
[18697.499418]   .se->statistics.wait_sum       : 1792.026119
[18697.499419]   .se->statistics.wait_count     : 259517
[18697.499421]   .se->load.weight               : 2
[18697.499422]
[18697.499422] cfs_rq[1]:/
[18697.499424]   .exec_clock                    : 5857108.141776
[18697.499426]   .MIN_vruntime                  : 0.000001
[18697.499428]   .min_vruntime                  : 12034846.600155
[18697.499429]   .max_vruntime                  : 0.000001
[18697.499431]   .spread                        : 0.000000
[18697.499432]   .spread0                       : -25250.182536
[18697.499434]   .nr_spread_over                : 1735
[18697.499435]   .nr_running                    : 0
[18697.499437]   .load                          : 0
[18697.499438]   .load_avg                      : 0.000000
[18697.499440]   .load_period                   : 0.000000
[18697.499441]   .load_contrib                  : 0
[18697.499442]   .load_tg                       : 0
[18697.499444]
[18697.499444] rt_rq[1]:
[18697.499445]   .rt_nr_running                 : 0
[18697.499447]   .rt_throttled                  : 0
[18697.499448]   .rt_time                       : 0.000000
[18697.499450]   .rt_runtime                    : 950.000000
[18697.499452]
[18697.499452] runnable tasks:
[18697.499452]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[18697.499452] ----------------------------------------------------------------------------------------------------------
[18697.499465]
[18802.797748] SysRq : Show Blocked State
[18802.797754]   task                        PC stack   pid father
[18802.797798] btrfs-transacti D 0000000000000002     0  4248      2 0x00000000
[18802.797803]  ffff880123d83b70 0000000000000046 ffff880126b25a48
ffff880123d83fd8
[18802.797807]  0000000000004000 0000000000012700 ffffffff81c14410
ffff880123d79680
[18802.797810]  ffff88012fc12770 ffff880126b25a48 ffff880123d83af0
ffffffff8105cf95
[18802.797814] Call Trace:
[18802.797823]  [<ffffffff8105cf95>] ? pick_next_task_fair+0xcb/0x12c
[18802.797859]  [<ffffffffa0063310>] ? alloc_extent_state+0x20/0x9f [btrfs]
[18802.797863]  [<ffffffff8161d97d>] ? __schedule+0x7a2/0x83a
[18802.797867]  [<ffffffff8106c8db>] ? ktime_get_ts+0x56/0xbc
[18802.797871]  [<ffffffff8109c171>] ? delayacct_end+0x79/0x84
[18802.797876]  [<ffffffff810bf744>] ? __lock_page+0x68/0x68
[18802.797878]  [<ffffffff8161dcf4>] schedule+0x64/0x66
[18802.797881]  [<ffffffff8161dd85>] io_schedule+0x8f/0xce
[18802.797885]  [<ffffffff810bf752>] sleep_on_page+0xe/0x12
[18802.797888]  [<ffffffff8161c436>] __wait_on_bit+0x48/0x7b
[18802.797891]  [<ffffffff810bf4b9>] ? find_get_pages_tag+0xf4/0x130
[18802.797894]  [<ffffffff810bf97d>] wait_on_page_bit+0x72/0x74
[18802.797899]  [<ffffffff8104c7d3>] ? autoremove_wake_function+0x38/0x38
[18802.797902]  [<ffffffff810bfa4c>] filemap_fdatawait_range+0x87/0x13e
[18802.797921]  [<ffffffffa0063c09>] ? free_extent_state+0x7d/0x85 [btrfs]
[18802.797941]  [<ffffffffa0064631>] ? clear_extent_bit+0x272/0x2aa [btrfs]
[18802.797959]  [<ffffffffa004f696>] btrfs_wait_marked_extents+0x7d/0xce [btrfs]
[18802.797977]  [<ffffffffa004f715>]
btrfs_write_and_wait_marked_extents+0x2e/0x3e [btrfs]
[18802.797994]  [<ffffffffa004f769>]
btrfs_write_and_wait_transaction+0x44/0x46 [btrfs]
[18802.798012]  [<ffffffffa004fea0>]
btrfs_commit_transaction+0x65b/0x969 [btrfs]
[18802.798015]  [<ffffffff8104c79b>] ? abort_exclusive_wait+0x8e/0x8e
[18802.798032]  [<ffffffffa0049700>] transaction_kthread+0xdf/0x1a0 [btrfs]
[18802.798048]  [<ffffffffa0049621>] ? cleaner_kthread+0xe6/0xe6 [btrfs]
[18802.798052]  [<ffffffff8104c072>] kthread+0x8b/0x93
[18802.798056]  [<ffffffff816205b4>] kernel_thread_helper+0x4/0x10
[18802.798060]  [<ffffffff8104bfe7>] ? kthread_freezable_should_stop+0x57/0x57
[18802.798063]  [<ffffffff816205b0>] ? gs_change+0xb/0xb
[18802.798079] cp              D 0000000000078000     0  5847   4147 0x00000000
[18802.798083]  ffff880100ce1b48 0000000000000086 ffff880100ce1a48
ffff880100ce1fd8
[18802.798086]  0000000000004000 0000000000012700 ffff88002e5cad00
ffff880096ea2d00
[18802.798090]  ffff88008a7c6968 0000000000000004 ffff880100ce1ba7
ffff880124339b00
[18802.798093] Call Trace:
[18802.798108]  [<ffffffffa003e133>] ?
reserve_metadata_bytes.isra.61+0x229/0x6ac [btrfs]
[18802.798122]  [<ffffffffa00352e9>] ? btrfs_search_slot+0x6fc/0x75f [btrfs]
[18802.798125]  [<ffffffff8161dcf4>] schedule+0x64/0x66
[18802.798142]  [<ffffffffa004f309>]
wait_current_trans.isra.28+0xac/0xdd [btrfs]
[18802.798146]  [<ffffffff8104c79b>] ? abort_exclusive_wait+0x8e/0x8e
[18802.798164]  [<ffffffffa00508a6>] start_transaction+0x3ae/0x3c3 [btrfs]
[18802.798177]  [<ffffffffa00309fc>] ? btrfs_free_path+0x27/0x2c [btrfs]
[18802.798194]  [<ffffffffa0050b5f>] btrfs_start_transaction+0x15/0x17 [btrfs]
[18802.798213]  [<ffffffffa005b763>] btrfs_create+0x3a/0x1e0 [btrfs]
[18802.798217]  [<ffffffff811101ad>] vfs_create+0x98/0xf1
[18802.798220]  [<ffffffff81111f60>] do_last+0x645/0xbd1
[18802.798224]  [<ffffffff8110f4d2>] ? link_path_walk+0x7e/0x79c
[18802.798227]  [<ffffffff811125b1>] path_openat+0xc5/0x424
[18802.798231]  [<ffffffff81112bed>] do_filp_open+0x38/0x86
[18802.798235]  [<ffffffff8111cbe6>] ? alloc_fd+0x72/0x101
[18802.798239]  [<ffffffff81104d05>] do_sys_open+0x112/0x1a4
[18802.798242]  [<ffffffff81104db8>] sys_open+0x21/0x23
[18802.798246]  [<ffffffff8161f3d6>] system_call_fastpath+0x1a/0x1f
[18802.798251] Sched Debug Version: v0.10, 3.6.6-git-local+ #1
[18802.798253] ktime                                   : 18802798.250983
[18802.798255] sched_clk                               : 18754926.134124
[18802.798256] cpu_clk                                 : 18802798.249729
[18802.798258] jiffies                                 : 4313470093
[18802.798259] sched_clock_stable                      : 0
[18802.798260]
[18802.798262] sysctl_sched
[18802.798263]   .sysctl_sched_latency                    : 12.000000
[18802.798265]   .sysctl_sched_min_granularity            : 1.500000
[18802.798267]   .sysctl_sched_wakeup_granularity         : 2.000000
[18802.798268]   .sysctl_sched_child_runs_first           : 0
[18802.798270]   .sysctl_sched_features                   : 24119
[18802.798271]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[18802.798274]
[18802.798274] cpu#0, 2666.778 MHz
[18802.798276]   .nr_running                    : 0
[18802.798277]   .load                          : 0
[18802.798279]   .nr_switches                   : 8667113
[18802.798280]   .nr_load_updates               : 7533867
[18802.798282]   .nr_uninterruptible            : -70
[18802.798283]   .next_balance                  : 4313.470181
[18802.798285]   .curr->pid                     : 0
[18802.798287]   .clock                         : 18802797.530296
[18802.798288]   .cpu_load[0]                   : 0
[18802.798289]   .cpu_load[1]                   : 0
[18802.798291]   .cpu_load[2]                   : 0
[18802.798292]   .cpu_load[3]                   : 6
[18802.798293]   .cpu_load[4]                   : 14
[18802.798295]   .yld_count                     : 2011
[18802.798296]   .sched_count                   : 8988377
[18802.798298]   .sched_goidle                  : 2467717
[18802.798299]   .avg_idle                      : 1000000
[18802.798300]   .ttwu_count                    : 4134537
[18802.798302]   .ttwu_local                    : 2815417
[18802.798304]
[18802.798304] cfs_rq[0]:/autogroup-35
[18802.798306]   .exec_clock                    : 28601.033797
[18802.798308]   .MIN_vruntime                  : 0.000001
[18802.798310]   .min_vruntime                  : 28598.089785
[18802.798311]   .max_vruntime                  : 0.000001
[18802.798313]   .spread                        : 0.000000
[18802.798315]   .spread0                       : -12034226.063599
[18802.798316]   .nr_spread_over                : 0
[18802.798318]   .nr_running                    : 0
[18802.798319]   .load                          : 0
[18802.798321]   .load_avg                      : 44.871676
[18802.798322]   .load_period                   : 8.608018
[18802.798324]   .load_contrib                  : 5
[18802.798325]   .load_tg                       : 5
[18802.798327]   .se->exec_start                : 18802782.433811
[18802.798329]   .se->vruntime                  : 12062817.920135
[18802.798330]   .se->sum_exec_runtime          : 28602.752864
[18802.798332]   .se->statistics.wait_start     : 0.000000
[18802.798334]   .se->statistics.sleep_start    : 0.000000
[18802.798335]   .se->statistics.block_start    : 0.000000
[18802.798337]   .se->statistics.sleep_max      : 0.000000
[18802.798338]   .se->statistics.block_max      : 0.000000
[18802.798340]   .se->statistics.exec_max       : 9.949400
[18802.798342]   .se->statistics.slice_max      : 16.022897
[18802.798343]   .se->statistics.wait_max       : 18.604128
[18802.798345]   .se->statistics.wait_sum       : 1373.495158
[18802.798347]   .se->statistics.wait_count     : 243328
[18802.798348]   .se->load.weight               : 2
[18802.798350]
[18802.798350] cfs_rq[0]:/
[18802.798352]   .exec_clock                    : 5846108.499298
[18802.798354]   .MIN_vruntime                  : 0.000001
[18802.798355]   .min_vruntime                  : 12062824.153384
[18802.798357]   .max_vruntime                  : 0.000001
[18802.798359]   .spread                        : 0.000000
[18802.798360]   .spread0                       : 0.000000
[18802.798361]   .nr_spread_over                : 1914
[18802.798363]   .nr_running                    : 0
[18802.798364]   .load                          : 0
[18802.798366]   .load_avg                      : 0.000000
[18802.798367]   .load_period                   : 0.000000
[18802.798369]   .load_contrib                  : 0
[18802.798370]   .load_tg                       : 0
[18802.798371]
[18802.798371] rt_rq[0]:
[18802.798373]   .rt_nr_running                 : 0
[18802.798375]   .rt_throttled                  : 0
[18802.798376]   .rt_time                       : 0.000000
[18802.798378]   .rt_runtime                    : 950.000000
[18802.798380]
[18802.798380] runnable tasks:
[18802.798380]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[18802.798380] ----------------------------------------------------------------------------------------------------------
[18802.798396]
[18802.798396] cpu#1, 2666.778 MHz
[18802.798398]   .nr_running                    : 0
[18802.798399]   .load                          : 0
[18802.798401]   .nr_switches                   : 8667417
[18802.798402]   .nr_load_updates               : 7558261
[18802.798404]   .nr_uninterruptible            : 72
[18802.798405]   .next_balance                  : 4313.470188
[18802.798407]   .curr->pid                     : 0
[18802.798409]   .clock                         : 18802789.528166
[18802.798410]   .cpu_load[0]                   : 0
[18802.798411]   .cpu_load[1]                   : 0
[18802.798413]   .cpu_load[2]                   : 0
[18802.798414]   .cpu_load[3]                   : 0
[18802.798415]   .cpu_load[4]                   : 0
[18802.798416]   .yld_count                     : 170835
[18802.798418]   .sched_count                   : 9179024
[18802.798419]   .sched_goidle                  : 2441686
[18802.798421]   .avg_idle                      : 1000000
[18802.798422]   .ttwu_count                    : 4237599
[18802.798424]   .ttwu_local                    : 2879379
[18802.798425]
[18802.798425] cfs_rq[1]:/
[18802.798427]   .exec_clock                    : 5860657.264448
[18802.798429]   .MIN_vruntime                  : 0.000001
[18802.798431]   .min_vruntime                  : 12037518.524875
[18802.798432]   .max_vruntime                  : 0.000001
[18802.798434]   .spread                        : 0.000000
[18802.798435]   .spread0                       : -25305.628509
[18802.798437]   .nr_spread_over                : 1736
[18802.798438]   .nr_running                    : 0
[18802.798440]   .load                          : 0
[18802.798441]   .load_avg                      : 0.000000
[18802.798443]   .load_period                   : 0.000000
[18802.798444]   .load_contrib                  : 0
[18802.798446]   .load_tg                       : 0
[18802.798447]
[18802.798447] rt_rq[1]:
[18802.798449]   .rt_nr_running                 : 0
[18802.798450]   .rt_throttled                  : 0
[18802.798452]   .rt_time                       : 0.000000
[18802.798453]   .rt_runtime                    : 950.000000
[18802.798455]
[18802.798455] runnable tasks:
[18802.798455]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[18802.798455] ----------------------------------------------------------------------------------------------------------
[18802.798466]
