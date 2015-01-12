Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43928 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbALM1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 07:27:14 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1YAe5Q-0004Jn-29
	for linux-btrfs@vger.kernel.org; Mon, 12 Jan 2015 12:27:12 +0000
Date: Mon, 12 Jan 2015 12:27:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Stuck balance, 3.18.0
Message-ID: <20150112122710.GO32182@carfax.org.uk>
References: <20150112112158.GM32182@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jdM5ZcN/ZcXXVwZs"
In-Reply-To: <20150112112158.GM32182@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jdM5ZcN/ZcXXVwZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 12, 2015 at 11:21:58AM +0000, Hugo Mills wrote:
>    I've just added a new disk to my main storage filesystem. Running
> the obligatory balance to spread the data out, it's managed about 14%
> of the job, and then has gone into some kind of tight loop. No chunks
> have been found or balanced in the last 2 hours, and one kworker
> thread is pegged at 100%. There were no unusual or unexpected messages
> in the logs. Balance cancel has been waiting for the last 10 minutes
> without effect (as would be expected with the other symptoms).

   OK, an hour after I executed the cancel, and three hours after it
apparently jammed up, the cancel completed. I have restarted the
balance from the point it left off, and I'll see if it does something
similar again.

   Hugo.

>    Syslog resulting from SysRq-w is included below. I tried getting a
> SysRq-t as well, but there's no output from that (in dmesg or
> syslog). Is there anything else needed before I reboot the machine?
> 
>    Hugo.
> 
> Jan 12 11:11:47 s_src@amelia kernel: INFO: task btrfs:9224 blocked for more than 120 seconds.
> Jan 12 11:11:47 s_src@amelia kernel:       Not tainted 3.18.0-dirty #8
> Jan 12 11:11:47 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 12 11:11:47 s_src@amelia kernel: btrfs           D ffff88021fc919c0     0  9224   9213 0x00000000
> Jan 12 11:11:47 s_src@amelia kernel:  ffff88020a603720 0000000000000086 00000000000119c0 ffff88020a603720
> Jan 12 11:11:47 s_src@amelia kernel:  ffff8801f0ceffd8 ffff8802168dc6e0 0000000000000246 ffff88021577f000
> Jan 12 11:11:47 s_src@amelia kernel:  ffff88021577fb40 ffff88021577fb70 ffff88021577fb80 ffff8800cb2a2600
> Jan 12 11:11:47 s_src@amelia kernel: Call Trace:
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff811870ff>] ? btrfs_cancel_balance+0xb3/0x13c
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff8105fa3b>] ? finish_wait+0x5d/0x5d
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff81192411>] ? btrfs_ioctl+0xf33/0x2083
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff810d6f2e>] ? handle_mm_fault+0x712/0x739
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff8102d94f>] ? __do_page_fault+0x2a2/0x31a
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff810d90f8>] ? vma_link+0x67/0x85
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff810fd20e>] ? do_vfs_ioctl+0x34d/0x403
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff810fd2fd>] ? SyS_ioctl+0x39/0x55
> Jan 12 11:11:47 s_src@amelia kernel:  [<ffffffff813d1a56>] ? system_call_fastpath+0x16/0x1b
> Jan 12 11:12:45 s_src@amelia kernel: SysRq : Show Blocked State
> Jan 12 11:12:45 s_src@amelia kernel:   task                        PC stack   pid father
> Jan 12 11:12:45 s_src@amelia kernel: btrfs           D ffff88021fc919c0     0  7739   7732 0x00000000
> Jan 12 11:12:45 s_src@amelia kernel:  ffff8800ca277620 0000000000000082 00000000000119c0 ffff8800ca277620
> Jan 12 11:12:45 s_src@amelia kernel:  ffff88005924ffd8 ffff8802168dc6e0 ffff88021fc119c0 7fffffffffffffff
> Jan 12 11:12:45 s_src@amelia kernel:  ffff880161e92618 ffff880161e92620 0000000000000002 ffffffff813d0e10
> Jan 12 11:12:45 s_src@amelia kernel: Call Trace:
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff813d0e10>] ? console_conditional_schedule+0xf/0xf
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff813d0e2c>] ? schedule_timeout+0x1c/0xf0
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810558cf>] ? try_to_wake_up+0x19c/0x1ae
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff813cfc98>] ? __wait_for_common+0x127/0x164
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81055914>] ? wake_up_state+0x7/0x7
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81154bd0>] ? btrfs_async_run_delayed_refs+0xbf/0xd5
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81168e4a>] ? __btrfs_end_transaction+0x2a4/0x2e8
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff811a652d>] ? relocate_block_group+0x2ad/0x4aa
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff811a6885>] ? btrfs_relocate_block_group+0x15b/0x26f
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81186cca>] ? btrfs_relocate_chunk.isra.36+0x36/0x9e
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81188062>] ? btrfs_balance+0x9db/0xb70
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810befb6>] ? __alloc_pages_nodemask+0xef/0x5e3
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff8118e20a>] ? btrfs_ioctl_balance+0x216/0x284
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff811923e0>] ? btrfs_ioctl+0xf02/0x2083
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810d6f2e>] ? handle_mm_fault+0x712/0x739
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff8102d94f>] ? __do_page_fault+0x2a2/0x31a
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810d90f8>] ? vma_link+0x67/0x85
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810fd20e>] ? do_vfs_ioctl+0x34d/0x403
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810fd2fd>] ? SyS_ioctl+0x39/0x55
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff813d1a56>] ? system_call_fastpath+0x16/0x1b
> Jan 12 11:12:45 s_src@amelia kernel: btrfs           D ffff88021fc919c0     0  9224   9213 0x00000000
> Jan 12 11:12:45 s_src@amelia kernel:  ffff88020a603720 0000000000000086 00000000000119c0 ffff88020a603720
> Jan 12 11:12:45 s_src@amelia kernel:  ffff8801f0ceffd8 ffff8802168dc6e0 0000000000000246 ffff88021577f000
> Jan 12 11:12:45 s_src@amelia kernel:  ffff88021577fb40 ffff88021577fb70 ffff88021577fb80 ffff8800cb2a2600
> Jan 12 11:12:45 s_src@amelia kernel: Call Trace:
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff811870ff>] ? btrfs_cancel_balance+0xb3/0x13c
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff8105fa3b>] ? finish_wait+0x5d/0x5d
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff81192411>] ? btrfs_ioctl+0xf33/0x2083
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810d6f2e>] ? handle_mm_fault+0x712/0x739
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff8102d94f>] ? __do_page_fault+0x2a2/0x31a
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810d90f8>] ? vma_link+0x67/0x85
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810fd20e>] ? do_vfs_ioctl+0x34d/0x403
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff810fd2fd>] ? SyS_ioctl+0x39/0x55
> Jan 12 11:12:45 s_src@amelia kernel:  [<ffffffff813d1a56>] ? system_call_fastpath+0x16/0x1b
> Jan 12 11:12:45 s_src@amelia kernel: Sched Debug Version: v0.11, 3.18.0-dirty #8
> Jan 12 11:12:45 s_src@amelia kernel: ktime                                   : 155818861.752772
> Jan 12 11:12:45 s_src@amelia kernel: sched_clk                               : 155824855.265338
> Jan 12 11:12:45 s_src@amelia kernel: cpu_clk                                 : 155824855.265406
> Jan 12 11:12:45 s_src@amelia kernel: jiffies                                 : 4310519182
> Jan 12 11:12:45 s_src@amelia kernel: sched_clock_stable()                    : 1
> Jan 12 11:12:45 s_src@amelia kernel: 
> Jan 12 11:12:45 s_src@amelia kernel: sysctl_sched
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_latency                    : 12.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_min_granularity            : 1.500000
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_wakeup_granularity         : 2.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_child_runs_first           : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_features                   : 11899
> Jan 12 11:12:45 s_src@amelia kernel:   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> Jan 12 11:12:45 s_src@amelia kernel: 
> Jan 12 11:12:45 s_src@amelia kernel: cpu#0, 1297.848 MHz
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 3040
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_switches                   : 241482934
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_load_updates               : 13970850
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_uninterruptible            : 109334
> Jan 12 11:12:45 s_src@amelia kernel:   .next_balance                  : 4310.519186
> Jan 12 11:12:45 s_src@amelia kernel:   .curr->pid                     : 10541
> Jan 12 11:12:45 s_src@amelia kernel:   .clock                         : 155824854.888938
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[0]                   : 1034
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[1]                   : 1046
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[2]                   : 1124
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[3]                   : 1153
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[4]                   : 1120
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[0]:/autogroup-3425
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 78493.324652
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 78493.442931
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 78493.324652
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30213821.690785
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 2048
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 165
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 165
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 17
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 231
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 149
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824854.888938
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 30292310.359674
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 58189.617192
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 992
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 889
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 46551
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 35
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606161
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[0]:/
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 30292309.133716
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 30292315.133716
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 30292315.133716
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 6.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 3040
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 1058
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 545
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 1591
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 1010
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 4269
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 2026
> Jan 12 11:12:45 s_src@amelia kernel:   .avg->runnable_avg_sum         : 46622
> Jan 12 11:12:45 s_src@amelia kernel:   .avg->runnable_avg_period      : 46637
> Jan 12 11:12:45 s_src@amelia kernel: \x0art_rq[0]:
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_nr_running                 : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_throttled                  : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_time                       : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_runtime                    : 950.000000
> Jan 12 11:12:45 s_src@amelia kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Jan 12 11:12:45 s_src@amelia kernel:      ksoftirqd/0     3  30282165.559312    291242   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/0:0H     5      1376.539114         6   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      migration/0     9         0.000000     36170     0               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        kdevtmpfs    15  19572611.060642       193   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:            netns    16       268.684333         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             perf    17       268.696858         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        writeback    19       282.928511         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             ksmd    20     18590.174580         3   125               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          ata_sff    25       792.675571         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:    fsnotify_mark    33  19574633.236096        26   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_0    50      1005.211562        20   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_1    52      1005.223289        21   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_1    53       951.963509         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_2    54      1005.098256        21   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_3    56      1005.096158        20   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_3    57       964.199486         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      kworker/0:2    62  30292309.133716   1122562   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           bioset    65      1014.964792         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_4   105      1244.704642         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_5   106      1417.280315        22   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_5   107      1253.438711         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/0:1H   113  30283357.393198    615622   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-worker-hi   156  27239045.682881        27   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:   btrfs-delalloc   157      1822.180602         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-flush_del   158      1828.190065         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      btrfs-cache   159      1834.199768         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      btrfs-fixup   161      1846.218430         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      btrfs-endio   162  20698663.447574         3   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-endio-met   163      1858.237365         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-endio-met   164      1864.246749         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-endio-rai   165      1870.256102         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-endio-rep   166      1876.265315         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        btrfs-rmw   167      1882.274699         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-endio-wri   168  29549485.966407         6   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-freespace   169      1894.292990         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-delayed-m   170      1900.302256         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-readahead   171      1906.311258         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-qgroup-re   172      1912.320492         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  btrfs-extent-re   173  20649304.270928         6   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_6   434  28077482.250438     24149   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      edac-poller   442      3343.122551         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  kvm-irqfd-clean   468      3700.738814         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           bioset   497      3885.540623         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      md127_raid1   498  29982192.439258       277   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      md126_raid1   622  29982192.444744       182   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           rpciod  1897      9046.455479         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           nfsiod  1901      9059.247386         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       rpc.idmapd  1910         3.604770       590   120               0               0               0.000000               0.000000               0.000000 /autogroup-8
> Jan 12 11:12:45 s_src@amelia kernel:         rpc.gssd  1914         0.484355         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-9
> Jan 12 11:12:45 s_src@amelia kernel:        syslog-ng  2167         6.145294         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-12
> Jan 12 11:12:45 s_src@amelia kernel:            mdadm  2232        26.216620       172   120               0               0               0.000000               0.000000               0.000000 /autogroup-14
> Jan 12 11:12:45 s_src@amelia kernel:            named  2248     14716.496066    114781   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
> Jan 12 11:12:45 s_src@amelia kernel:            named  2249     14716.603361    115005   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
> Jan 12 11:12:45 s_src@amelia kernel:            named  2252     14711.018883    130852   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
> Jan 12 11:12:45 s_src@amelia kernel:              atd  2305         0.569238        48   120               0               0               0.000000               0.000000               0.000000 /autogroup-18
> Jan 12 11:12:45 s_src@amelia kernel:          kadmind  2589        77.724379      2625   120               0               0               0.000000               0.000000               0.000000 /autogroup-25
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2711  30107995.389906   2581924   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2712  30082536.764078   2451294   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2713  30082536.317077   2625929   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2715  30185117.464535   2479705   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2718  30082509.712583   2474785   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      rpc.svcgssd  2722        12.482086       601   120               0               0               0.000000               0.000000               0.000000 /autogroup-28
> Jan 12 11:12:45 s_src@amelia kernel:       rpc.mountd  2724       652.920103      1170   120               0               0               0.000000               0.000000               0.000000 /autogroup-29
> Jan 12 11:12:45 s_src@amelia kernel:    apt-cacher-ng 20573     71554.585241    167849   120               0               0               0.000000               0.000000               0.000000 /autogroup-31
> Jan 12 11:12:45 s_src@amelia kernel:    apt-cacher-ng 20575     71559.736092     60731   120               0               0               0.000000               0.000000               0.000000 /autogroup-31
> Jan 12 11:12:45 s_src@amelia kernel:       4s-backend  3313        17.233796         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-36
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3335        52.024351       595   120               0               0               0.000000               0.000000               0.000000 /autogroup-39
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3338      7896.816189     77516   120               0               0               0.000000               0.000000               0.000000 /autogroup-42
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3339      9810.041836     43904   120               0               0               0.000000               0.000000               0.000000 /autogroup-43
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4094         1.546556       123   120               0               0               0.000000               0.000000               0.000000 /autogroup-49
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4095         0.115156       124   120               0               0               0.000000               0.000000               0.000000 /autogroup-50
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4096         0.181228       124   120               0               0               0.000000               0.000000               0.000000 /autogroup-51
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4097         0.199111       124   120               0               0               0.000000               0.000000               0.000000 /autogroup-52
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4098         0.179085       124   120               0               0               0.000000               0.000000               0.000000 /autogroup-53
> Jan 12 11:12:45 s_src@amelia kernel:            getty  4099         0.406846       125   120               0               0               0.000000               0.000000               0.000000 /autogroup-54
> Jan 12 11:12:45 s_src@amelia kernel:  calliope-server  4484       321.489978        57   120               0               0               0.000000               0.000000               0.000000 /autogroup-62
> Jan 12 11:12:45 s_src@amelia kernel:        ssh-agent 15536       257.294990       174   120               0               0               0.000000               0.000000               0.000000 /autogroup-1068
> Jan 12 11:12:45 s_src@amelia kernel:             sshd 29019        41.265982        38   120               0               0               0.000000               0.000000               0.000000 /autogroup-2507
> Jan 12 11:12:45 s_src@amelia kernel:             bash 29030    338389.350678       739   120               0               0               0.000000               0.000000               0.000000 /autogroup-2508
> Jan 12 11:12:45 s_src@amelia kernel:             sshd  6755        67.641131       429   120               0               0               0.000000               0.000000               0.000000 /autogroup-3431
> Jan 12 11:12:45 s_src@amelia kernel:             bash  6758      1247.198584       192   120               0               0               0.000000               0.000000               0.000000 /autogroup-3432
> Jan 12 11:12:45 s_src@amelia kernel:             sudo  7732      1265.398399         6   120               0               0               0.000000               0.000000               0.000000 /autogroup-3432
> Jan 12 11:12:45 s_src@amelia kernel:             sshd 29374        31.517150        32   120               0               0               0.000000               0.000000               0.000000 /autogroup-3935
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27383    111816.477051        59   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27386    109605.942689       821   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27387    109286.935186       899   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27388    109601.755370       815   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27389    109605.569167      1619   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27392    109608.880728       418   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27396    109286.940840       416   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27398    109606.253960       874   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27304     99800.359705       108   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27332    109389.268843         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27334    109371.330882         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27336    109371.369175        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27338    109354.802337         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27340    109342.661643         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27342    109348.063493         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27344    109312.472269         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27346    109360.697543         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27349    109360.627704         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27351    109347.931892         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27353    109378.747890         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27355    109378.663616         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27357    109312.368011         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27359    109302.669681         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27361    109295.330683         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27363    109302.598164         6   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27365    109288.621111         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27367    109283.672352         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27369    109283.629693         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27371    109395.746831         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27373    109400.221232         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27375    109403.700368         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27377    109403.213647         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27379    109400.266712         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27381    109401.325955         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27331    107523.806324        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27333    107515.202907        19   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27335    107522.449439        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27337    107523.728739        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27339    107527.719188        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27341    107523.850970        19   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27348    107501.548271        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27350    107505.705030        23   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27352    109620.949397        23   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27354    107493.320319        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27356    107484.922082        17   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27358    109600.351154        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27362    109568.656814        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27364    109546.435825        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27376    107530.709449        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27328     99838.180063         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27402    109546.506987        15   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27403    109573.860999        15   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27404    109551.608209        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27407    109587.156552        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27408    109602.930767        15   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27411    109606.188255        15   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27413    109499.850040        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27415    109499.874661        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27417    109513.587534        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27418    109513.499362        14   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27420    109546.559325        18   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u9:3   538  30274495.398944     45876   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:    kworker/u8:11  1016  30274467.237100    147334   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u9:0  4007  30274491.674222     33125   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      kworker/0:1  4477  26345052.325161         3   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:0  7909  30200854.780348     33640   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u9:4  8112  30199934.195441      7529   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:1  8768  30200846.651933     14845   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:5  8787  30292315.133716     20995   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:2  9022  30200841.587827      2090   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             sudo 10534     78493.324652         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-3425
> Jan 12 11:12:45 s_src@amelia kernel: R            tee 10541     78493.442931         5   120               0               0               0.000000               0.000000               0.000000 /autogroup-3425
> Jan 12 11:12:45 s_src@amelia kernel: 
> Jan 12 11:12:45 s_src@amelia kernel: cpu#1, 1297.848 MHz
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 1
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 1024
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_switches                   : 330318800
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_load_updates               : 14697986
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_uninterruptible            : -109332
> Jan 12 11:12:45 s_src@amelia kernel:   .next_balance                  : 4310.519192
> Jan 12 11:12:45 s_src@amelia kernel:   .curr->pid                     : 175
> Jan 12 11:12:45 s_src@amelia kernel:   .clock                         : 155824854.047680
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[0]                   : 1023
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[1]                   : 1036
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[2]                   : 1134
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[3]                   : 1206
> Jan 12 11:12:45 s_src@amelia kernel:   .cpu_load[4]                   : 1125
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-22
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 12676.931476
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30279638.202240
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824811.321711
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611038.610129
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 12680.947105
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 103
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 48026
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606121
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-30
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 3860.610966
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30288454.522750
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824797.762796
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611025.971205
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 3856.237089
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 229
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 47170
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606108
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-13
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 11068.491003
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30281246.642713
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824787.148991
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611016.921770
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 11082.951902
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 203
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 47447
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606098
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-3425
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 63252.843290
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30229062.290426
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 66
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 66
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 132
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 231
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 149
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824805.552474
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611033.488165
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 43748.617322
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 6048
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 46679
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 115
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606115
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-3424
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 289.819744
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30292025.313972
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824703.710277
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14610970.001021
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 284.979914
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 214
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 47207
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606018
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-17
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 65755.201556
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30226559.932160
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824770.227974
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611004.978260
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 65918.626824
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 188
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 47249
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 3
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606082
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 121475.555623
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30170839.578093
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 7
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 7
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824840.112767
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611066.736356
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 198197.660787
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 406
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 47758
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606148
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/autogroup-62
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 207440.209290
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -30084874.924426
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 11
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 4
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 11
> Jan 12 11:12:45 s_src@amelia kernel:   .se->exec_start                : 155824848.030919
> Jan 12 11:12:45 s_src@amelia kernel:   .se->vruntime                  : 14611074.590210
> Jan 12 11:12:45 s_src@amelia kernel:   .se->sum_exec_runtime          : 235132.909577
> Jan 12 11:12:45 s_src@amelia kernel:   .se->load.weight               : 2
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_sum      : 534
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.runnable_avg_period   : 46328
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.load_avg_contrib      : 8
> Jan 12 11:12:45 s_src@amelia kernel:   .se->avg.decay_count           : 148606156
> Jan 12 11:12:45 s_src@amelia kernel: \x0acfs_rq[1]:/
> Jan 12 11:12:45 s_src@amelia kernel:   .exec_clock                    : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .MIN_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .min_vruntime                  : 14611085.009326
> Jan 12 11:12:45 s_src@amelia kernel:   .max_vruntime                  : 0.000001
> Jan 12 11:12:45 s_src@amelia kernel:   .spread                        : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .spread0                       : -15681230.124390
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_spread_over                : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .nr_running                    : 1
> Jan 12 11:12:45 s_src@amelia kernel:   .load                          : 1024
> Jan 12 11:12:45 s_src@amelia kernel:   .runnable_load_avg             : 1023
> Jan 12 11:12:45 s_src@amelia kernel:   .blocked_load_avg              : 2474
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_contrib               : 2678
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_runnable_contrib           : 1016
> Jan 12 11:12:45 s_src@amelia kernel:   .tg_load_avg                   : 4269
> Jan 12 11:12:45 s_src@amelia kernel:   .tg->runnable_avg              : 2026
> Jan 12 11:12:45 s_src@amelia kernel:   .avg->runnable_avg_sum         : 46334
> Jan 12 11:12:45 s_src@amelia kernel:   .avg->runnable_avg_period      : 46349
> Jan 12 11:12:45 s_src@amelia kernel: \x0art_rq[1]:
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_nr_running                 : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_throttled                  : 0
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_time                       : 0.000000
> Jan 12 11:12:45 s_src@amelia kernel:   .rt_runtime                    : 950.000000
> Jan 12 11:12:45 s_src@amelia kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Jan 12 11:12:45 s_src@amelia kernel:             init     1      1658.372067     32275   120               0               0               0.000000               0.000000               0.000000 /autogroup-2
> Jan 12 11:12:45 s_src@amelia kernel:         kthreadd     2  14212661.131514       918   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        rcu_sched     7  14611079.477826   3891436   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           rcu_bh     8   4881348.422187        85   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      migration/1    10         0.000000     33950     0               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      ksoftirqd/1    11  14611060.246892   2961951   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/1:0H    13      2949.103815         7   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          khelper    14         4.969768         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       khungtaskd    18  14587950.248996      1302   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           crypto    21       216.294160         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      kintegrityd    22       222.305476         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           bioset    23       228.316518         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          kblockd    24       234.327321         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       devfreq_wq    26       263.425445         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          kswapd0    32  14611007.990885     71398   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:         pencrypt    40      1610.905470         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:         pdecrypt    41      1616.924213         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_0    51      1650.495329         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_2    55      1662.745889         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:    ipv6_addrconf    64      2715.148181         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          deferwq    66      2721.163542         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_4   104      3067.891522       738   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/1:1H   112  14611079.009360 125354896   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     btrfs-worker   154  14212634.137513         9   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     btrfs-submit   160   7790198.355151        29   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:    btrfs-cleaner   174  14597260.710580     14364   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel: Rbtrfs-transacti   175  14611085.009326   1792798   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:            udevd   360       540.356438       783   120               0               0               0.000000               0.000000               0.000000 /autogroup-4
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_6   435      4708.521538         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_7   436      4830.109091         4   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_7   437      4716.240315         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:        scsi_eh_8   443      4778.464014         2   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:       scsi_tmf_8   444      4782.462309         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      usb-storage   445  12575455.960561      2709   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:               md   486      5021.095897         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:           bioset   621      5470.165677         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          rpcbind  1862      1469.379149     10300   120               0               0               0.000000               0.000000               0.000000 /autogroup-5
> Jan 12 11:12:45 s_src@amelia kernel:        rpc.statd  1890         9.617998        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-6
> Jan 12 11:12:45 s_src@amelia kernel:        syslog-ng  2168     11068.491003     54674   120               0               0               0.000000               0.000000               0.000000 /autogroup-13
> Jan 12 11:12:45 s_src@amelia kernel:            named  2247         2.181284         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
> Jan 12 11:12:45 s_src@amelia kernel:            named  2250     15852.912958     43189   120               0               0               0.000000               0.000000               0.000000 /autogroup-15
> Jan 12 11:12:45 s_src@amelia kernel:            acpid  2266         0.036954         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-16
> Jan 12 11:12:45 s_src@amelia kernel:        mosquitto  2276     65755.201556   1576367   120               0               0               0.000000               0.000000               0.000000 /autogroup-17
> Jan 12 11:12:45 s_src@amelia kernel:       nbd-server  2335         0.632230         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-19
> Jan 12 11:12:45 s_src@amelia kernel:            inetd  2366        27.449539        37   120               0               0               0.000000               0.000000               0.000000 /autogroup-20
> Jan 12 11:12:45 s_src@amelia kernel:      dbus-daemon  2384         6.723069        81   120               0               0               0.000000               0.000000               0.000000 /autogroup-21
> Jan 12 11:12:45 s_src@amelia kernel:             ntpd  2404     12676.931476    166707   120               0               0               0.000000               0.000000               0.000000 /autogroup-22
> Jan 12 11:12:45 s_src@amelia kernel:          krb5kdc  2423       144.278854      2869   120               0               0               0.000000               0.000000               0.000000 /autogroup-23
> Jan 12 11:12:45 s_src@amelia kernel:          apache2  2464    121469.107539    158096   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:             cron  2642      1645.936276      2800   120               0               0               0.000000               0.000000               0.000000 /autogroup-26
> Jan 12 11:12:45 s_src@amelia kernel:             sshd  2668        50.665403        58   120               0               0               0.000000               0.000000               0.000000 /autogroup-27
> Jan 12 11:12:45 s_src@amelia kernel:            nfsd4  2706     11876.586960         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  nfsd4_callbacks  2707     11882.605872         2   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:            lockd  2708  14610671.355527    422631   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2714  14610551.464540   2613864   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2716  14610512.038383   2612299   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             nfsd  2717  14610465.577729   2507160   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     avahi-daemon  2744      3860.610966     32076   120               0               0               0.000000               0.000000               0.000000 /autogroup-30
> Jan 12 11:12:45 s_src@amelia kernel:     avahi-daemon  2745        26.077070         9   120               0               0               0.000000               0.000000               0.000000 /autogroup-30
> Jan 12 11:12:45 s_src@amelia kernel:    apt-cacher-ng  2763     31326.237223         7   120               0               0               0.000000               0.000000               0.000000 /autogroup-31
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3036     15513.370445     12458   120               0               0               0.000000               0.000000               0.000000 /autogroup-33
> Jan 12 11:12:45 s_src@amelia kernel:       4s-backend  3201         9.173782         8   120               0               0               0.000000               0.000000               0.000000 /autogroup-36
> Jan 12 11:12:45 s_src@amelia kernel:            gmain  3262         7.854303         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-36
> Jan 12 11:12:45 s_src@amelia kernel:         4s-httpd  3256        12.260826         3   120               0               0               0.000000               0.000000               0.000000 /autogroup-38
> Jan 12 11:12:45 s_src@amelia kernel:         4s-httpd  3258        18.207290        40   120               0               0               0.000000               0.000000               0.000000 /autogroup-38
> Jan 12 11:12:45 s_src@amelia kernel:       4s-backend  3261         5.249460        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-36
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3336      1289.015040     31301   120               0               0               0.000000               0.000000               0.000000 /autogroup-40
> Jan 12 11:12:45 s_src@amelia kernel:         postgres  3337      1231.224168     31352   120               0               0               0.000000               0.000000               0.000000 /autogroup-41
> Jan 12 11:12:45 s_src@amelia kernel:            exim4  4064      1302.179693       194   120               0               0               0.000000               0.000000               0.000000 /autogroup-48
> Jan 12 11:12:45 s_src@amelia kernel:  qemu-system-x86  4092     98849.132375    119068   120               0               0               0.000000               0.000000               0.000000 /autogroup-11
> Jan 12 11:12:45 s_src@amelia kernel:  qemu-system-x86  4355     98856.880456    602331   120               0               0               0.000000               0.000000               0.000000 /autogroup-11
> Jan 12 11:12:45 s_src@amelia kernel:  qemu-system-x86  4357      3966.980123         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-11
> Jan 12 11:12:45 s_src@amelia kernel:         startpar  4093        -1.036876         4   120               0               0               0.000000               0.000000               0.000000 /autogroup-55
> Jan 12 11:12:45 s_src@amelia kernel:     kvm-pit/4092  4356     22298.008213       202   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:  calliope-server  4450    207432.224912    371467   120               0               0               0.000000               0.000000               0.000000 /autogroup-62
> Jan 12 11:12:45 s_src@amelia kernel:  calliope-server  4483    207440.209290   3213092   120               0               0               0.000000               0.000000               0.000000 /autogroup-62
> Jan 12 11:12:45 s_src@amelia kernel:        gpg-agent 15560      2862.496509     42922   120               0               0               0.000000               0.000000               0.000000 /autogroup-1069
> Jan 12 11:12:45 s_src@amelia kernel:             sshd 29027       500.937814      6234   120               0               0               0.000000               0.000000               0.000000 /autogroup-2507
> Jan 12 11:12:45 s_src@amelia kernel:             sshd  6307        42.490603        15   120               0               0               0.000000               0.000000               0.000000 /autogroup-3424
> Jan 12 11:12:45 s_src@amelia kernel:             sshd  6315       289.819744      2278   120               0               0               0.000000               0.000000               0.000000 /autogroup-3424
> Jan 12 11:12:45 s_src@amelia kernel:             bash  6318     63231.646201       364   120               0               0               0.000000               0.000000               0.000000 /autogroup-3425
> Jan 12 11:12:45 s_src@amelia kernel:             sshd  6747        42.296366        53   120               0               0               0.000000               0.000000               0.000000 /autogroup-3431
> Jan 12 11:12:45 s_src@amelia kernel:            btrfs  7739   3372772.354213   6512632   120               0               0               0.000000               0.000000               0.000000 /autogroup-3432
> Jan 12 11:12:45 s_src@amelia kernel:             sshd 29382       213.725612      2798   120               0               0               0.000000               0.000000               0.000000 /autogroup-3935
> Jan 12 11:12:45 s_src@amelia kernel:             bash 29385      1269.591590       308   120               0               0               0.000000               0.000000               0.000000 /autogroup-3936
> Jan 12 11:12:45 s_src@amelia kernel:      kworker/1:1 16506  14611060.281244    223725   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27303    109482.127295        79   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27384    121468.804301     17041   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27385    109482.964528         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27390    118870.255255       973   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27391    109482.968064         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27393    109482.964392         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27394    109482.964645         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27395    109482.963932         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27397    109482.964486         1   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27399    118879.582175       309   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27382    121475.044055    169631   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27305    109481.319714        82   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27343    117729.442579        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27345    118761.318619        22   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27347    118818.665413        18   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27360    118873.683601        23   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27366    118843.239376        20   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27368    118716.113803        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27370    118854.046061        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27372    118792.436531        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27374    117742.946679        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27378    118670.857795        21   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27380    121474.413308    169658   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27401    118855.851061        19   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27405    118854.632885        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27406    118859.350528        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27409    118859.460027        17   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27410    118859.248763        16   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27412    118830.530803        13   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27414    118843.180229        14   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27416    118849.042162        13   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27419    118854.411939        13   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27421    118854.097928        11   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27422    118854.062947        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27423    118854.559849        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27424    118853.864163        10   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27425    118854.213513        12   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:          apache2 27426    121475.555623    169657   120               0               0               0.000000               0.000000               0.000000 /autogroup-24
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:3  3987  14610542.830837     79510   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u9:2  5854  14596228.375532     22182   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:    kworker/u8:10  7257  14610536.837309     41423   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u9:1  8532  14596228.314681      4703   100               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:     kworker/u8:6  8806  14610983.048556      4684   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:      kworker/1:0  9043  14082346.196805         2   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel:             sudo  9213      1302.133488        62   120               0               0               0.000000               0.000000               0.000000 /autogroup-3936
> Jan 12 11:12:45 s_src@amelia kernel:            btrfs  9224      1309.541436         2   120               0               0               0.000000               0.000000               0.000000 /autogroup-3936
> Jan 12 11:12:45 s_src@amelia kernel:    kworker/u8:12  9405  14611079.414484      4261   120               0               0               0.000000               0.000000               0.000000 /
> Jan 12 11:12:45 s_src@amelia kernel: 
> Jan 12 11:13:47 s_src@amelia kernel: INFO: task btrfs:9224 blocked for more than 120 seconds.
> Jan 12 11:13:47 s_src@amelia kernel:       Not tainted 3.18.0-dirty #8
> Jan 12 11:13:47 s_src@amelia kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 12 11:13:47 s_src@amelia kernel: btrfs           D ffff88021fc919c0     0  9224   9213 0x00000000
> Jan 12 11:13:47 s_src@amelia kernel:  ffff88020a603720 0000000000000086 00000000000119c0 ffff88020a603720
> Jan 12 11:13:47 s_src@amelia kernel:  ffff8801f0ceffd8 ffff8802168dc6e0 0000000000000246 ffff88021577f000
> Jan 12 11:13:47 s_src@amelia kernel:  ffff88021577fb40 ffff88021577fb70 ffff88021577fb80 ffff8800cb2a2600
> Jan 12 11:13:47 s_src@amelia kernel: Call Trace:
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff811870ff>] ? btrfs_cancel_balance+0xb3/0x13c
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff8105fa3b>] ? finish_wait+0x5d/0x5d
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff81192411>] ? btrfs_ioctl+0xf33/0x2083
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff810d6f2e>] ? handle_mm_fault+0x712/0x739
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff8102d94f>] ? __do_page_fault+0x2a2/0x31a
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff810d90f8>] ? vma_link+0x67/0x85
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff810fd20e>] ? do_vfs_ioctl+0x34d/0x403
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff810fd2fd>] ? SyS_ioctl+0x39/0x55
> Jan 12 11:13:47 s_src@amelia kernel:  [<ffffffff813d1a56>] ? system_call_fastpath+0x16/0x1b
> 
> 

-- 
Hugo Mills             | In my day, we didn't have fancy high numbers. We had
hugo@... carfax.org.uk | "nowt", "one", "twain" and "multitudes".
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--jdM5ZcN/ZcXXVwZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUs72eAAoJEFheFHXiqx3kQSUP+wcLqCoKeTyM9/0rCdRDObhD
18JYEJYaW8TvzIElRxlAUMQ1gunqURgcA+VtwHA6Z8RUjHVRhlGLhp0j6tIl1+jQ
1+77OPiw2gV0GtUYGKjUbDlfsbi0wDyhUFctYBpol/LdhG4csa7bVCyHa97T4QGh
PxTWygVjCGI2AR5HX6K53tj5AwlZ+jAzyMiW7lEShtWdd/ZhoZtz7lYt6swnuDGO
N4nh0Ju3HrxQmgIOKI3nKOG47tfrsYTdOTP9gSc/nv78H4DUfyvVYGxQ65E/BWuC
2DqMJzJnxLAtOXWiViB3l0p95FUaYlCdPtJSZBu759GiBeahSWvvQ0JBHt6pbz9i
jkg9+e2hX5RT2xBtImoPxoc22sYTYQkqWCiwXC7Q+2gGuQiDd6mcxRYxnFX/dbww
yo8i4cDMpLAhWw/xaFepwGOz4rpgASOccGvkjCoiyFYRWmJkwOnXvrbI+FBIbJw3
Ps1z+ft29dItxhuufFl62E8+8cTpOSqYHNyhtFmVzSE1AgCyYoNvFlaS8O6TzAIc
647FaigMxaYlqADExYWdVfDBqND7dQZi8R//MDipY5wJn9viC69zJGcgEUjNeikX
19DmeZJw0nTq4UCYg+T5BU3Eo6VGaBtrvGGXzgmYYcKD8m2ZQOH22H7IRQnOYHjb
OlTMAv6hQa9WeytZCGaQ
=avud
-----END PGP SIGNATURE-----

--jdM5ZcN/ZcXXVwZs--
