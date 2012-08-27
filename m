Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59071 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2H0UoX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 16:44:23 -0400
Received: by obbuo13 with SMTP id uo13so9114845obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2012 13:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm-JYUUTc+NodFHFi2SLpE7=JSwRigygt5x8xgy_bYzzoQ@mail.gmail.com>
References: <CAKcLGm-JYUUTc+NodFHFi2SLpE7=JSwRigygt5x8xgy_bYzzoQ@mail.gmail.com>
Date: Mon, 27 Aug 2012 15:44:22 -0500
Message-ID: <CAKcLGm84fbhqo-w4j6Fzk1O5yE7+zR1YqxxnRpwPuzjSk1gt5g@mail.gmail.com>
Subject: Re: Btrfs Intermittent ENOSPC Issues
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 31, 2012 at 2:37 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I've been working on running down intermittent ENOSPC issues.
>
> I can only seem to replicate ENOSPC errors when running zlib
> compression.  However, I have been seeing similar ENOSPC errors to a
> lesser extent when playing with the LZ4HC patches.
>

I've been spending most of my efforts on the specific areas of code
that are generating the ENOSPC error.  But I've been developing the
perception that the real problem is elsewhere.

I probably should have looked at this a while ago, but if I generate
an Alt-SysRq-W delayed tasks traceback during the intermittent periods
when ENOSPC errors are occurring, I'm seeing delays in other areas.

It may be that the ENOSPC errors are occurring due to a page lock that
is not clearing in another thread.

[12339.617366] SysRq : HELP : loglevel(0-9) reBoot Crash
terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I)
thaw-filesystems(J) saK show-backtrace-all-active-cpus(L)
show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P)
show-all-timers(Q) unRaw Sync show-task-states(T) Unmount
show-blocked-tasks(W) dump-ftrace-buffer(Z)
[12339.650620] SysRq : Show Blocked State
[12339.650624]   task                        PC stack   pid father
[12339.650678] flush-btrfs-6   D ffffffff810c03bb     0  7162      2 0x00000000
[12339.650681]  ffff880126a83990 0000000000000046 ffff880126a82000
ffff8801266fad40
[12339.650684]  0000000000012280 ffff880126a83fd8 0000000000012280
0000000000004000
[12339.650687]  ffff880126a83fd8 0000000000012280 ffff880129af16a0
ffff8801266fad40
[12339.650690] Call Trace:
[12339.650698]  [<ffffffff8106c6d0>] ? ktime_get_ts+0xae/0xbb
[12339.650701]  [<ffffffff8106c6d0>] ? ktime_get_ts+0xae/0xbb
[12339.650705]  [<ffffffff810c03bb>] ? __lock_page+0x6d/0x6d
[12339.650708]  [<ffffffff8162da84>] schedule+0x64/0x66
[12339.650710]  [<ffffffff8162db12>] io_schedule+0x8c/0xcf
[12339.650713]  [<ffffffff810c03c9>] sleep_on_page+0xe/0x12
[12339.650715]  [<ffffffff8162c159>] __wait_on_bit_lock+0x46/0x8f
[12339.650717]  [<ffffffff810c0117>] ? find_get_pages_tag+0xf8/0x134
[12339.650720]  [<ffffffff810c03b4>] __lock_page+0x66/0x6d
[12339.650723]  [<ffffffff8104b7ff>] ? autoremove_wake_function+0x39/0x39
[12339.650753]  [<ffffffffa0065f28>]
extent_write_cache_pages.clone.16.clone.29+0x143/0x30c [btrfs]
[12339.650770]  [<ffffffffa0066303>] extent_writepages+0x48/0x5d [btrfs]
[12339.650784]  [<ffffffffa0053019>] ?
uncompress_inline.clone.33+0x15f/0x15f [btrfs]
[12339.650788]  [<ffffffff8105c8f4>] ? update_curr+0x81/0x123
[12339.650802]  [<ffffffffa00528ac>] btrfs_writepages+0x27/0x29 [btrfs]
[12339.650805]  [<ffffffff810c9975>] do_writepages+0x20/0x29
[12339.650808]  [<ffffffff8112ec67>]
__writeback_single_inode.clone.22+0x48/0x11c
[12339.650811]  [<ffffffff8112f1cf>] writeback_sb_inodes+0x1f0/0x332
[12339.650813]  [<ffffffff810c870e>] ? global_dirtyable_memory+0x1a/0x3b
[12339.650816]  [<ffffffff8112f389>] __writeback_inodes_wb+0x78/0xb9
[12339.650818]  [<ffffffff8112f510>] wb_writeback+0x146/0x23e
[12339.650820]  [<ffffffff810c891b>] ? global_dirty_limits+0x2f/0x10f
[12339.650822]  [<ffffffff8112fdef>] wb_do_writeback+0x195/0x1b0
[12339.650825]  [<ffffffff8112fe98>] bdi_writeback_thread+0x8e/0x1f1
[12339.650827]  [<ffffffff8112fe0a>] ? wb_do_writeback+0x1b0/0x1b0
[12339.650829]  [<ffffffff8112fe0a>] ? wb_do_writeback+0x1b0/0x1b0
[12339.650832]  [<ffffffff8104b2ef>] kthread+0x89/0x91
[12339.650835]  [<ffffffff816303f4>] kernel_thread_helper+0x4/0x10
[12339.650837]  [<ffffffff8104b266>] ? kthread_freezable_should_stop+0x57/0x57
[12339.650839]  [<ffffffff816303f0>] ? gs_change+0xb/0xb
[12339.650842] tar             D ffff88012683f8b8     0  7173   7152 0x00000000
[12339.650845]  ffff880126c0f9e8 0000000000000086 ffff880126c0e000
ffff8801267496a0
[12339.650848]  0000000000012280 ffff880126c0ffd8 0000000000012280
0000000000004000
[12339.650851]  ffff880126c0ffd8 0000000000012280 ffff880129af16a0
ffff8801267496a0
[12339.650854] Call Trace:
[12339.650866]  [<ffffffffa0037b35>] ?
block_rsv_release_bytes+0xc7/0x127 [btrfs]
[12339.650869]  [<ffffffff8103c073>] ? lock_timer_base.clone.26+0x2b/0x50
[12339.650871]  [<ffffffff8162da84>] schedule+0x64/0x66
[12339.650873]  [<ffffffff8162c075>] schedule_timeout+0x22c/0x26a
[12339.650876]  [<ffffffff8103c038>] ? run_timer_softirq+0x2d4/0x2d4
[12339.650878]  [<ffffffff8162c0f1>] schedule_timeout_killable+0x1e/0x20
[12339.650890]  [<ffffffffa003dd0c>]
reserve_metadata_bytes.clone.57+0x4ba/0x5e7 [btrfs]
[12339.650906]  [<ffffffffa0066b52>] ? free_extent_buffer+0x68/0x6c [btrfs]
[12339.650918]  [<ffffffffa003e1a9>] btrfs_block_rsv_add+0x2b/0x4d [btrfs]
[12339.650932]  [<ffffffffa004ff40>] start_transaction+0x131/0x310 [btrfs]
[12339.650946]  [<ffffffffa0050386>] btrfs_start_transaction+0x13/0x15 [btrfs]
[12339.650961]  [<ffffffffa005b10a>] btrfs_create+0x3a/0x1e0 [btrfs]
[12339.650964]  [<ffffffff81120861>] ? d_splice_alias+0xcc/0xd8
[12339.650966]  [<ffffffff811173aa>] vfs_create+0x9c/0xf5
[12339.650968]  [<ffffffff81119786>] do_last+0x2b9/0x807
[12339.650971]  [<ffffffff81119dd3>] path_openat+0xcc/0x37f
[12339.650973]  [<ffffffff8105c495>] ? pick_next_task_fair+0xfa/0x1a3
[12339.650975]  [<ffffffff8111a188>] do_filp_open+0x3d/0x89
[12339.650978]  [<ffffffff810ff2b0>] ? kmem_cache_alloc+0x31/0x104
[12339.650981]  [<ffffffff811244d8>] ? alloc_fd+0x74/0x103
[12339.650984]  [<ffffffff8110c9c1>] do_sys_open+0x10f/0x1a1
[12339.650986]  [<ffffffff8110ca8a>] sys_openat+0x14/0x16
[12339.650988]  [<ffffffff8162f196>] system_call_fastpath+0x1a/0x1f
[12339.650991] Sched Debug Version: v0.10, 3.5.2-git-local+ #1
[12339.650993] ktime                                   : 12339650.991349
[12339.650994] sched_clk                               : 12307274.537183
[12339.650996] cpu_clk                                 : 12339650.990603
[12339.650997] jiffies                                 : 4307006946
[12339.650998] sched_clock_stable                      : 0
[12339.650999]
[12339.651000] sysctl_sched
[12339.651001]   .sysctl_sched_latency                    : 12.000000
[12339.651002]   .sysctl_sched_min_granularity            : 1.500000
[12339.651004]   .sysctl_sched_wakeup_granularity         : 2.000000
[12339.651005]   .sysctl_sched_child_runs_first           : 0
[12339.651006]   .sysctl_sched_features                   : 24119
[12339.651007]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[12339.651009]
[12339.651009] cpu#0, 2666.695 MHz
[12339.651010]   .nr_running                    : 1
[12339.651012]   .load                          : 1024
[12339.651013]   .nr_switches                   : 1867973
[12339.651014]   .nr_load_updates               : 921873
[12339.651015]   .nr_uninterruptible            : -38
[12339.651016]   .next_balance                  : 4307.007084
[12339.651018]   .curr->pid                     : 7127
[12339.651019]   .clock                         : 12339651.001145
[12339.651020]   .cpu_load[0]                   : 1024
[12339.651021]   .cpu_load[1]                   : 1024
[12339.651022]   .cpu_load[2]                   : 1024
[12339.651023]   .cpu_load[3]                   : 1024
[12339.651024]   .cpu_load[4]                   : 1024
[12339.651025]   .yld_count                     : 1
[12339.651027]   .sched_count                   : 1882299
[12339.651028]   .sched_goidle                  : 912528
[12339.651029]   .avg_idle                      : 377192
[12339.651030]   .ttwu_count                    : 926414
[12339.651031]   .ttwu_local                    : 883111
[12339.651033]
[12339.651033] cfs_rq[0]:/autogroup-1
[12339.651035]   .exec_clock                    : 15.992542
[12339.651036]   .MIN_vruntime                  : 0.000001
[12339.651037]   .min_vruntime                  : 34.248046
[12339.651038]   .max_vruntime                  : 0.000001
[12339.651040]   .spread                        : 0.000000
[12339.651041]   .spread0                       : -40669.589708
[12339.651042]   .nr_spread_over                : 0
[12339.651043]   .nr_running                    : 0
[12339.651044]   .load                          : 0
[12339.651045]   .load_avg                      : 2559.999744
[12339.651047]   .load_period                   : 8.499867
[12339.651048]   .load_contrib                  : 301
[12339.651049]   .load_tg                       : 301
[12339.651050]   .se->exec_start                : 12334559.061047
[12339.651052]   .se->vruntime                  : 40611.002746
[12339.651053]   .se->sum_exec_runtime          : 16.033168
[12339.651054]   .se->statistics.wait_start     : 0.000000
[12339.651055]   .se->statistics.sleep_start    : 0.000000
[12339.651057]   .se->statistics.block_start    : 0.000000
[12339.651058]   .se->statistics.sleep_max      : 0.000000
[12339.651059]   .se->statistics.block_max      : 0.000000
[12339.651060]   .se->statistics.exec_max       : 0.267801
[12339.651061]   .se->statistics.slice_max      : 0.017406
[12339.651063]   .se->statistics.wait_max       : 2.667927
[12339.651064]   .se->statistics.wait_sum       : 7.034526
[12339.651065]   .se->statistics.wait_count     : 1273
[12339.651066]   .se->load.weight               : 2
[12339.651068]
[12339.651068] cfs_rq[0]:/
[12339.651069]   .exec_clock                    : 29641.344277
[12339.651071]   .MIN_vruntime                  : 0.000001
[12339.651072]   .min_vruntime                  : 40703.837754
[12339.651073]   .max_vruntime                  : 0.000001
[12339.651074]   .spread                        : 0.000000
[12339.651075]   .spread0                       : 0.000000
[12339.651076]   .nr_spread_over                : 1163
[12339.651077]   .nr_running                    : 1
[12339.651078]   .load                          : 1024
[12339.651080]   .load_avg                      : 0.000000
[12339.651081]   .load_period                   : 0.000000
[12339.651082]   .load_contrib                  : 0
[12339.651083]   .load_tg                       : 0
[12339.651084]
[12339.651084] rt_rq[0]:
[12339.651085]   .rt_nr_running                 : 0
[12339.651087]   .rt_throttled                  : 0
[12339.651088]   .rt_time                       : 0.000000
[12339.651089]   .rt_runtime                    : 950.000000
[12339.651090]
[12339.651090] runnable tasks:
[12339.651090]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[12339.651090] ----------------------------------------------------------------------------------------------------------
