Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53778 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964863AbaFQVi4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 17:38:56 -0400
Message-ID: <53A0B568.9070700@gmail.com>
Date: Wed, 18 Jun 2014 00:38:48 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: axboe@fb.com, linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: commit 762380a "block: add notion of a chunk size for
 request merging" stops io on btrfs
References: <53A0B491.1040901@gmail.com>
In-Reply-To: <53A0B491.1040901@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030606070706000909050807"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030606070706000909050807
Content-Type: text/plain; charset=windows-1253; format=flowed
Content-Transfer-Encoding: 8bit

On 18/6/2014 12:35 рм, Konstantinos Skarlatos wrote:
> Hi all,
> with 3.16-rc1  rsync stops writing to my btrfs filesystem and stays at 
> a D+ state.
> git bisect showed that the problematic commit is:
>
> 762380ad9322951cea4ce9d24864265f9c66a916 is the first bad commit
> commit 762380ad9322951cea4ce9d24864265f9c66a916
> Author: Jens Axboe <axboe@fb.com>
> Date:   Thu Jun 5 13:38:39 2014 -0600
>
>     block: add notion of a chunk size for request merging
>
>     Some drivers have different limits on what size a request should
>     optimally be, depending on the offset of the request. Similar to
>     dividing a device into chunks. Add a setting that allows the driver
>     to inform the block layer of such a chunk size. The block layer will
>     then prevent merging across the chunks.
>
>     This is needed to optimally support NVMe with a non-zero stripe size.
>
>     Signed-off-by: Jens Axboe <axboe@fb.com>
>
> sysrq w gives:
Just ran another  echo w > /proc/sysrq-trigger, attaching output.

>
> [ 3287.169569] SysRq : Show Blocked State
> [ 3287.169655]   task                        PC stack   pid father
> [ 3287.169675] rsync           D 0000000000000001     0   626 613 
> 0x00000000
> [ 3287.169685]  ffff8802037c7d08 0000000000000082 ffff8800cf2e7010 
> 0000000000014500
> [ 3287.169693]  ffff8802037c7fd8 0000000000014500 ffff8800cf2e7010 
> ffff8802037c7c98
> [ 3287.169700]  0000000000000292 0000000000000292 ffff8802037c7c50 
> ffff8802037c7c50
> [ 3287.169706] Call Trace:
> [ 3287.169722]  [<ffffffff814f71d2>] ? do_page_fault+0x22/0x30
> [ 3287.169733]  [<ffffffff8101cd89>] ? read_tsc+0x9/0x20
> [ 3287.169743]  [<ffffffff811379d0>] ? sleep_on_page+0x20/0x20
> [ 3287.169749]  [<ffffffff814eff29>] schedule+0x29/0x70
> [ 3287.169756]  [<ffffffff814f0214>] io_schedule+0x94/0xf0
> [ 3287.169763]  [<ffffffff811379de>] sleep_on_page_killable+0xe/0x50
> [ 3287.169770]  [<ffffffff814f0748>] __wait_on_bit_lock+0x48/0xb0
> [ 3287.169777]  [<ffffffff8128c753>] ? radix_tree_lookup_slot+0x13/0x30
> [ 3287.169785]  [<ffffffff81137b7a>] __lock_page_killable+0x6a/0x70
> [ 3287.169792]  [<ffffffff810acec0>] ? autoremove_wake_function+0x40/0x40
> [ 3287.169799]  [<ffffffff811398c8>] generic_file_aio_read+0x458/0x6a0
> [ 3287.169808]  [<ffffffff811ab63a>] do_sync_read+0x5a/0x90
> [ 3287.169816]  [<ffffffff811abc47>] vfs_read+0x97/0x160
> [ 3287.169823]  [<ffffffff811ac886>] SyS_read+0x46/0xc0
> [ 3287.169831]  [<ffffffff814fb969>] system_call_fastpath+0x16/0x1b
>
> $ btrfs filesystem show /storage/btrfs
> Label: none  uuid: bde3c349-9e08-45bb-8517-b9a6dda81e88
>         Total devices 6 FS bytes used 8.58TiB
>         devid    1 size 3.64TiB used 3.02TiB path /dev/sdf
>         devid    2 size 1.82TiB used 1.20TiB path /dev/sda
>         devid    3 size 1.82TiB used 1.20TiB path /dev/sdb
>         devid    4 size 1.82TiB used 1.20TiB path /dev/sdc
>         devid    5 size 1.82TiB used 1.20TiB path /dev/sdd
>         devid    6 size 1.82TiB used 1.20TiB path /dev/sdh
>
> Btrfs v3.14.2-dirty
>
> $ btrfs fi df /storage/btrfs
> Data, single: total=8.89TiB, used=8.51TiB
> System, RAID1: total=32.00MiB, used=992.00KiB
> Metadata, RAID1: total=69.00GiB, used=67.83GiB
> unknown, single: total=512.00MiB, used=0.00
>
> full dmesg attached
> Please CC me if replying on LKML, as I am not subscribed there


--------------030606070706000909050807
Content-Type: text/plain; charset=windows-1253;
 name="dmesg_blocked2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_blocked2.txt"

[18278.207224] SysRq : Show Blocked State
[18278.207308]   task                        PC stack   pid father
[18278.207322] jbd2/sde3-8     D 0000000000000002     0   154      2 0x00000000
[18278.207332]  ffff880202db7bd8 0000000000000046 ffff880203291e90 0000000000014500
[18278.207340]  ffff880202db7fd8 0000000000014500 ffff880203291e90 ffff8801ed4be170
[18278.207347]  ffff880202db7b38 ffffffff8125f45d ffff880203051168 ffff880203051048
[18278.207353] Call Trace:
[18278.207368]  [<ffffffff8125f45d>] ? blk_insert_flush+0x1dd/0x1f0
[18278.207379]  [<ffffffff81259443>] ? __blk_run_queue+0x33/0x40
[18278.207386]  [<ffffffff8125d72a>] ? blk_queue_bio+0x23a/0x370
[18278.207394]  [<ffffffff8101cd89>] ? read_tsc+0x9/0x20
[18278.207403]  [<ffffffff811dc370>] ? generic_block_bmap+0x50/0x50
[18278.207410]  [<ffffffff814efe49>] schedule+0x29/0x70
[18278.207416]  [<ffffffff814f0134>] io_schedule+0x94/0xf0
[18278.207423]  [<ffffffff811dc37e>] sleep_on_buffer+0xe/0x20
[18278.207429]  [<ffffffff814f0573>] __wait_on_bit+0x83/0xa0
[18278.207437]  [<ffffffff811dc370>] ? generic_block_bmap+0x50/0x50
[18278.207443]  [<ffffffff814f0607>] out_of_line_wait_on_bit+0x77/0x90
[18278.207450]  [<ffffffff810acec0>] ? autoremove_wake_function+0x40/0x40
[18278.207458]  [<ffffffff811dc46a>] __wait_on_buffer+0x2a/0x30
[18278.207480]  [<ffffffffa08a1e81>] jbd2_journal_commit_transaction+0x1941/0x1950 [jbd2]
[18278.207495]  [<ffffffffa08a7299>] kjournald2+0xd9/0x280 [jbd2]
[18278.207501]  [<ffffffff810ace80>] ? __wake_up_sync+0x20/0x20
[18278.207513]  [<ffffffffa08a71c0>] ? commit_timeout+0x10/0x10 [jbd2]
[18278.207520]  [<ffffffff8108933b>] kthread+0xdb/0x100
[18278.207527]  [<ffffffff81089260>] ? kthread_create_on_node+0x180/0x180
[18278.207534]  [<ffffffff814fb7fc>] ret_from_fork+0x7c/0xb0
[18278.207540]  [<ffffffff81089260>] ? kthread_create_on_node+0x180/0x180
[18278.207545] systemd-journal D 0000000000000000     0   178      1 0x00000000
[18278.207552]  ffff8800cb617e50 0000000000000082 ffff880203311460 0000000000014500
[18278.207558]  ffff8800cb617fd8 0000000000014500 ffff880203311460 0000000000000046
[18278.207565]  ffff8800cb617de0 ffffffff8109940f ffff880202079cb0 0000000000000000
[18278.207571] Call Trace:
[18278.207580]  [<ffffffff8109940f>] ? try_to_wake_up+0x1ff/0x2e0
[18278.207589]  [<ffffffff81099552>] ? default_wake_function+0x12/0x20
[18278.207595]  [<ffffffff814efe49>] schedule+0x29/0x70
[18278.207607]  [<ffffffffa08a62fd>] jbd2_log_wait_commit+0x9d/0x110 [jbd2]
[18278.207613]  [<ffffffff810ace80>] ? __wake_up_sync+0x20/0x20
[18278.207625]  [<ffffffffa08a7e5c>] jbd2_complete_transaction+0x6c/0x90 [jbd2]
[18278.207642]  [<ffffffffa08cb6f8>] ext4_sync_file+0x1f8/0x370 [ext4]
[18278.207650]  [<ffffffff811dad2e>] do_fsync+0x4e/0x80
[18278.207657]  [<ffffffff811dafc0>] SyS_fsync+0x10/0x20
[18278.207663]  [<ffffffff814fb8a9>] system_call_fastpath+0x16/0x1b
[18278.207674] rsync           D 0000000000000003     0   696    682 0x00000000
[18278.207680]  ffff8801f43d3d08 0000000000000086 ffff880202b965e0 0000000000014500
[18278.207686]  ffff8801f43d3fd8 0000000000014500 ffff880202b965e0 ffff8801f43d3c98
[18278.207692]  0000000000000292 0000000000000292 ffff8801f43d3c50 ffff8801f43d3c50
[18278.207698] Call Trace:
[18278.207707]  [<ffffffff814f7112>] ? do_page_fault+0x22/0x30
[18278.207714]  [<ffffffff8101cd89>] ? read_tsc+0x9/0x20
[18278.207722]  [<ffffffff811379d0>] ? sleep_on_page+0x20/0x20
[18278.207727]  [<ffffffff814efe49>] schedule+0x29/0x70
[18278.207733]  [<ffffffff814f0134>] io_schedule+0x94/0xf0
[18278.207740]  [<ffffffff811379de>] sleep_on_page_killable+0xe/0x50
[18278.207746]  [<ffffffff814f0668>] __wait_on_bit_lock+0x48/0xb0
[18278.207753]  [<ffffffff8128c673>] ? radix_tree_lookup_slot+0x13/0x30
[18278.207761]  [<ffffffff81137b7a>] __lock_page_killable+0x6a/0x70
[18278.207767]  [<ffffffff810acec0>] ? autoremove_wake_function+0x40/0x40
[18278.207773]  [<ffffffff811398c8>] generic_file_aio_read+0x458/0x6a0
[18278.207782]  [<ffffffff811ab63a>] do_sync_read+0x5a/0x90
[18278.207790]  [<ffffffff811abc47>] vfs_read+0x97/0x160
[18278.207797]  [<ffffffff811ac886>] SyS_read+0x46/0xc0
[18278.207804]  [<ffffffff814fb8a9>] system_call_fastpath+0x16/0x1b
[18278.207809] smbd            D 0000000000000001     0  1440    377 0x00000000
[18278.207815]  ffff8800bcc67d08 0000000000000082 ffff8801f42c8000 0000000000014500
[18278.207821]  ffff8800bcc67fd8 0000000000014500 ffff8801f42c8000 ffffffff81446971
[18278.207827]  00000000000094a8 ffff8800bcc67ca8 ffffffff81453b14 ffff8800bcc67fd8
[18278.207833] Call Trace:
[18278.207842]  [<ffffffff81446971>] ? tcp_sendmsg+0x941/0xd50
[18278.207848]  [<ffffffff81453b14>] ? tcp_transmit_skb+0x504/0x980
[18278.207855]  [<ffffffff814f330a>] ? _raw_spin_unlock_bh+0x1a/0x20
[18278.207862]  [<ffffffff813e9238>] ? release_sock+0x118/0x170
[18278.207868]  [<ffffffff8101cd89>] ? read_tsc+0x9/0x20
[18278.207876]  [<ffffffff811379d0>] ? sleep_on_page+0x20/0x20
[18278.207881]  [<ffffffff814efe49>] schedule+0x29/0x70
[18278.207887]  [<ffffffff814f0134>] io_schedule+0x94/0xf0
[18278.207894]  [<ffffffff811379de>] sleep_on_page_killable+0xe/0x50
[18278.207900]  [<ffffffff814f0668>] __wait_on_bit_lock+0x48/0xb0
[18278.207906]  [<ffffffff8128c673>] ? radix_tree_lookup_slot+0x13/0x30
[18278.207914]  [<ffffffff81137b7a>] __lock_page_killable+0x6a/0x70
[18278.207920]  [<ffffffff810acec0>] ? autoremove_wake_function+0x40/0x40
[18278.207926]  [<ffffffff811398c8>] generic_file_aio_read+0x458/0x6a0
[18278.207934]  [<ffffffff811ab63a>] do_sync_read+0x5a/0x90
[18278.207942]  [<ffffffff811abc47>] vfs_read+0x97/0x160
[18278.207949]  [<ffffffff811aca3a>] SyS_pread64+0x7a/0xa0
[18278.207956]  [<ffffffff814fb8a9>] system_call_fastpath+0x16/0x1b
[18278.207964] Sched Debug Version: v0.11, 3.15.0-rc8-g762380a #1
[18278.207969] ktime                                   : 18253931.549509
[18278.207973] sched_clk                               : 18278207.961561
[18278.207977] cpu_clk                                 : 18278207.961662
[18278.207981] jiffies                                 : 4300353476
[18278.207985] sched_clock_stable()                    : 1

[18278.207990] sysctl_sched
[18278.207994]   .sysctl_sched_latency                    : 18.000000
[18278.207997]   .sysctl_sched_min_granularity            : 2.250000
[18278.208001]   .sysctl_sched_wakeup_granularity         : 3.000000
[18278.208004]   .sysctl_sched_child_runs_first           : 0
[18278.208008]   .sysctl_sched_features                   : 77435
[18278.208012]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

[18278.208019] cpu#0, 3214.094 MHz
[18278.208022]   .nr_running                    : 0
[18278.208026]   .load                          : 0
[18278.208029]   .nr_switches                   : 176134
[18278.208032]   .nr_load_updates               : 70761
[18278.208036]   .nr_uninterruptible            : 78
[18278.208039]   .next_balance                  : 4300.353482
[18278.208043]   .curr->pid                     : 0
[18278.208046]   .clock                         : 18278206.221722
[18278.208050]   .cpu_load[0]                   : 384
[18278.208053]   .cpu_load[1]                   : 333
[18278.208056]   .cpu_load[2]                   : 231
[18278.208059]   .cpu_load[3]                   : 138
[18278.208062]   .cpu_load[4]                   : 76
[18278.208065]   .yld_count                     : 3
[18278.208069]   .sched_count                   : 185307
[18278.208072]   .sched_goidle                  : 93625
[18278.208075]   .avg_idle                      : 885569
[18278.208079]   .max_idle_balance_cost         : 500000
[18278.208082]   .ttwu_count                    : 67433
[18278.208085]   .ttwu_local                    : 40416
[18278.208090]
cfs_rq[0]:/autogroup-40
[18278.208096]   .exec_clock                    : 285.176604
[18278.208101]   .MIN_vruntime                  : 0.000001
[18278.208104]   .min_vruntime                  : 1299.959284
[18278.208108]   .max_vruntime                  : 0.000001
[18278.208112]   .spread                        : 0.000000
[18278.208116]   .spread0                       : -6679.735729
[18278.208119]   .nr_spread_over                : 99
[18278.208123]   .nr_running                    : 0
[18278.208126]   .load                          : 0
[18278.208129]   .runnable_load_avg             : 0
[18278.208133]   .blocked_load_avg              : 972
[18278.208136]   .tg_load_contrib               : 972
[18278.208140]   .tg_runnable_contrib           : 233
[18278.208143]   .tg_load_avg                   : 2133
[18278.208146]   .tg->runnable_avg              : 473
[18278.208150]   .tg->cfs_bandwidth.timer_active: 0
[18278.208153]   .throttled                     : 0
[18278.208156]   .throttle_count                : 0
[18278.208161]   .se->exec_start                : 18278206.220209
[18278.208165]   .se->vruntime                  : 7979.695013
[18278.208168]   .se->sum_exec_runtime          : 285.176604
[18278.208172]   .se->statistics.wait_start     : 0.000000
[18278.208176]   .se->statistics.sleep_start    : 0.000000
[18278.208179]   .se->statistics.block_start    : 0.000000
[18278.208183]   .se->statistics.sleep_max      : 0.000000
[18278.208186]   .se->statistics.block_max      : 0.000000
[18278.208190]   .se->statistics.exec_max       : 3.344396
[18278.208194]   .se->statistics.slice_max      : 0.395955
[18278.208197]   .se->statistics.wait_max       : 0.061146
[18278.208201]   .se->statistics.wait_sum       : 2.325952
[18278.208204]   .se->statistics.wait_count     : 396
[18278.208208]   .se->load.weight               : 2
[18278.208211]   .se->avg.runnable_avg_sum      : 10796
[18278.208215]   .se->avg.runnable_avg_period   : 48112
[18278.208218]   .se->avg.load_avg_contrib      : 205
[18278.208221]   .se->avg.decay_count           : 17431456
[18278.208226]
cfs_rq[0]:/
[18278.208231]   .exec_clock                    : 8905.241023
[18278.208235]   .MIN_vruntime                  : 0.000001
[18278.208238]   .min_vruntime                  : 7979.695013
[18278.208242]   .max_vruntime                  : 0.000001
[18278.208245]   .spread                        : 0.000000
[18278.208248]   .spread0                       : 0.000000
[18278.208252]   .nr_spread_over                : 30
[18278.208255]   .nr_running                    : 0
[18278.208258]   .load                          : 0
[18278.208261]   .runnable_load_avg             : 0
[18278.208265]   .blocked_load_avg              : 205
[18278.208268]   .tg_load_contrib               : 205
[18278.208271]   .tg_runnable_contrib           : 226
[18278.208275]   .tg_load_avg                   : 554
[18278.208278]   .tg->runnable_avg              : 507
[18278.208281]   .tg->cfs_bandwidth.timer_active: 0
[18278.208284]   .throttled                     : 0
[18278.208287]   .throttle_count                : 0
[18278.208291]   .avg->runnable_avg_sum         : 10737
[18278.208294]   .avg->runnable_avg_period      : 48429
[18278.208300]
rt_rq[0]:/
[18278.208305]   .rt_nr_running                 : 0
[18278.208308]   .rt_throttled                  : 0
[18278.208311]   .rt_time                       : 0.000000
[18278.208315]   .rt_runtime                    : 950.000000
[18278.208319]
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[18278.208327]      ksoftirqd/0     3      7970.650994      3216   120      7970.650994       122.690447  18277896.497368 0 /
[18278.208339]     kworker/0:0H     5       668.411491         6   100       668.411491         3.366551      1747.874725 0 /
[18278.208351]           rcu_bh     9       155.263192         2   120       155.263192         0.001173         0.000000 0 /
[18278.208361]      migration/0    10         0.000000       112     0         0.000000        39.085159         0.000000 0 /
[18278.208372]       watchdog/0    11         0.000000      4567     0         0.000000       106.337865         0.000000 0 /
[18278.208384]          kblockd    37       668.407208         4   100       668.407208         0.025149      1684.614320 0 /
[18278.208394]            khubd    78       451.613137        11   120       451.613137         0.207903       367.116121 0 /
[18278.208404]       scsi_tmf_2    84       358.676999         2   100       358.676999         0.012141         0.189501 0 /
[18278.208414]    kworker/u16:3    90      6376.831781      6992   120      6376.831781      1020.661868  15070323.727485 0 /
[18278.208424]       scsi_tmf_4    92       399.823600         2   100       399.823600         0.011947         0.004929 0 /
[18278.208434]       scsi_tmf_5    94       417.350890         2   100       417.350890         0.017084         0.008773 0 /
[18278.208445]     kworker/0:1H   137      7769.714647       159   100      7769.714647         3.308124  16665119.522124 0 /
[18278.208456]  ext4-rsv-conver   155       773.634852         2   100       773.634852         0.008357         0.003145 0 /
[18278.208466]      kworker/0:2   183      7966.045472     30306   120      7966.045472      1211.404118  18267187.281035 0 /
[18278.208476]    systemd-udevd   194       197.720176       408   120       197.720176       398.638919    396841.953950 0 /autogroup-12
[18278.208488]        hd-audio0   252      1241.521523         2   100      1241.521523         0.048002         0.014246 0 /
[18278.208498]  ext4-rsv-conver   264      1336.049975         2   100      1336.049975         0.027726         0.016338 0 /
[18278.208508]            named   364        19.757217        56   120        19.757217        22.354739      1033.525131 0 /autogroup-27
[18278.208519]            named   369        18.013616       208   120        18.013616         6.924516  18024080.220706 0 /autogroup-27
[18278.208529]            named   370        19.779042       176   120        19.779042         6.580362  18024080.038764 0 /autogroup-27
[18278.208541]     btrfs-worker   508      3327.844182         2   100      3327.844182         0.023831         0.010155 0 /
[18278.208551]   btrfs-delalloc   511      3336.866736         2   100      3336.866736         0.025767         0.015455 0 /
[18278.208561]     btrfs-submit   514      3341.385104         2   100      3341.385104         0.021756         0.009838 0 /
[18278.208571]      btrfs-fixup   515      3347.405115         2   100      3347.405115         0.022670         0.008702 0 /
[18278.208581]      btrfs-endio   516      3353.423671         2   100      3353.423671         0.021030         0.008608 0 /
[18278.208590]  btrfs-endio-met   517      3359.441273         2   100      3359.441273         0.020180         0.008990 0 /
[18278.208600]  btrfs-endio-met   518      3365.458847         2   100      3365.458847         0.019899         0.008551 0 /
[18278.208609]  btrfs-endio-rai   519      3371.476299         2   100      3371.476299         0.019716         0.008737 0 /
[18278.208619]        btrfs-rmw   520      3377.493168         2   100      3377.493168         0.018948         0.008260 0 /
[18278.208629]  btrfs-endio-wri   521      3383.510916         2   100      3383.510916         0.020197         0.008445 0 /
[18278.208638]  btrfs-freespace   522      3389.528843         2   100      3389.528843         0.020479         0.008735 0 /
[18278.208648]  btrfs-delayed-m   523      3395.547136         2   100      3395.547136         0.021189         0.008845 0 /
[18278.208657]  btrfs-readahead   524      3401.564524         2   100      3401.564524         0.019797         0.008330 0 /
[18278.208667]  btrfs-qgroup-re   525      3407.583121         2   100      3407.583121         0.020792         0.009610 0 /
[18278.208677]            rsync   698      1482.332372       295   120      1482.332372        10.795915  17620340.131198 0 /autogroup-38
[18278.208689]        run-parts  1523      7499.289877         7   120      7499.289877        13.217625        44.049658 0 /
[18278.208699]      kworker/0:0  1538      7804.547322         3   120      7804.547322         0.020380    301850.159506 0 /
[18278.208709]             sudo  1661      1299.959284         5   120      1299.959284        12.822718         0.968634 0 /autogroup-40

[18278.208723] cpu#1, 3214.094 MHz
[18278.208727]   .nr_running                    : 0
[18278.208730]   .load                          : 0
[18278.208734]   .nr_switches                   : 200715
[18278.208737]   .nr_load_updates               : 80291
[18278.208741]   .nr_uninterruptible            : -37
[18278.208745]   .next_balance                  : 4300.353478
[18278.208748]   .curr->pid                     : 0
[18278.208752]   .clock                         : 18278205.575310
[18278.208755]   .cpu_load[0]                   : 0
[18278.208758]   .cpu_load[1]                   : 7
[18278.208761]   .cpu_load[2]                   : 18
[18278.208764]   .cpu_load[3]                   : 18
[18278.208768]   .cpu_load[4]                   : 12
[18278.208771]   .yld_count                     : 0
[18278.208774]   .sched_count                   : 209801
[18278.208777]   .sched_goidle                  : 101830
[18278.208781]   .avg_idle                      : 989872
[18278.208784]   .max_idle_balance_cost         : 500000
[18278.208788]   .ttwu_count                    : 73879
[18278.208791]   .ttwu_local                    : 53717
[18278.208795]
cfs_rq[1]:/autogroup-8
[18278.208800]   .exec_clock                    : 81.418140
[18278.208804]   .MIN_vruntime                  : 0.000001
[18278.208808]   .min_vruntime                  : 80.369564
[18278.208811]   .max_vruntime                  : 0.000001
[18278.208815]   .spread                        : 0.000000
[18278.208819]   .spread0                       : -7899.325449
[18278.208822]   .nr_spread_over                : 0
[18278.208825]   .nr_running                    : 0
[18278.208828]   .load                          : 0
[18278.208832]   .runnable_load_avg             : 0
[18278.208835]   .blocked_load_avg              : 0
[18278.208838]   .tg_load_contrib               : 0
[18278.208841]   .tg_runnable_contrib           : 8
[18278.208844]   .tg_load_avg                   : 0
[18278.208848]   .tg->runnable_avg              : 8
[18278.208851]   .tg->cfs_bandwidth.timer_active: 0
[18278.208854]   .throttled                     : 0
[18278.208857]   .throttle_count                : 0
[18278.208861]   .se->exec_start                : 18278202.654051
[18278.208865]   .se->vruntime                  : 6037.971773
[18278.208869]   .se->sum_exec_runtime          : 81.425530
[18278.208872]   .se->statistics.wait_start     : 0.000000
[18278.208876]   .se->statistics.sleep_start    : 0.000000
[18278.208879]   .se->statistics.block_start    : 0.000000
[18278.208883]   .se->statistics.sleep_max      : 0.000000
[18278.208886]   .se->statistics.block_max      : 0.000000
[18278.208890]   .se->statistics.exec_max       : 3.339075
[18278.208894]   .se->statistics.slice_max      : 0.153286
[18278.208897]   .se->statistics.wait_max       : 0.698593
[18278.208901]   .se->statistics.wait_sum       : 1.309107
[18278.208904]   .se->statistics.wait_count     : 110
[18278.208907]   .se->load.weight               : 2
[18278.208911]   .se->avg.runnable_avg_sum      : 391
[18278.208914]   .se->avg.runnable_avg_period   : 48608
[18278.208917]   .se->avg.load_avg_contrib      : 0
[18278.208921]   .se->avg.decay_count           : 17431453
[18278.208925]
cfs_rq[1]:/autogroup-40
[18278.208930]   .exec_clock                    : 364.699921
[18278.208934]   .MIN_vruntime                  : 0.000001
[18278.208938]   .min_vruntime                  : 1174.176439
[18278.208941]   .max_vruntime                  : 0.000001
[18278.208945]   .spread                        : 0.000000
[18278.208948]   .spread0                       : -6805.518574
[18278.208952]   .nr_spread_over                : 56
[18278.208955]   .nr_running                    : 0
[18278.208958]   .load                          : 0
[18278.208961]   .runnable_load_avg             : 0
[18278.208965]   .blocked_load_avg              : 0
[18278.208968]   .tg_load_contrib               : 0
[18278.208971]   .tg_runnable_contrib           : 146
[18278.208974]   .tg_load_avg                   : 2133
[18278.208978]   .tg->runnable_avg              : 473
[18278.208981]   .tg->cfs_bandwidth.timer_active: 0
[18278.208984]   .throttled                     : 0
[18278.208988]   .throttle_count                : 0
[18278.208991]   .se->exec_start                : 18278205.552269
[18278.208995]   .se->vruntime                  : 6047.352628
[18278.208999]   .se->sum_exec_runtime          : 364.699921
[18278.209002]   .se->statistics.wait_start     : 0.000000
[18278.209006]   .se->statistics.sleep_start    : 0.000000
[18278.209010]   .se->statistics.block_start    : 0.000000
[18278.209013]   .se->statistics.sleep_max      : 0.000000
[18278.209016]   .se->statistics.block_max      : 0.000000
[18278.209020]   .se->statistics.exec_max       : 3.342586
[18278.209024]   .se->statistics.slice_max      : 0.000000
[18278.209027]   .se->statistics.wait_max       : 0.064633
[18278.209031]   .se->statistics.wait_sum       : 8.861315
[18278.209034]   .se->statistics.wait_count     : 4894
[18278.209037]   .se->load.weight               : 2
[18278.209041]   .se->avg.runnable_avg_sum      : 7088
[18278.209044]   .se->avg.runnable_avg_period   : 47826
[18278.209047]   .se->avg.load_avg_contrib      : 201
[18278.209051]   .se->avg.decay_count           : 17431456
[18278.209054]
cfs_rq[1]:/
[18278.209059]   .exec_clock                    : 7397.026976
[18278.209063]   .MIN_vruntime                  : 0.000001
[18278.209067]   .min_vruntime                  : 6047.352628
[18278.209070]   .max_vruntime                  : 0.000001
[18278.209074]   .spread                        : 0.000000
[18278.209077]   .spread0                       : -1932.342385
[18278.209081]   .nr_spread_over                : 38
[18278.209084]   .nr_running                    : 0
[18278.209087]   .load                          : 0
[18278.209090]   .runnable_load_avg             : 0
[18278.209094]   .blocked_load_avg              : 209
[18278.209097]   .tg_load_contrib               : 209
[18278.209100]   .tg_runnable_contrib           : 158
[18278.209103]   .tg_load_avg                   : 554
[18278.209107]   .tg->runnable_avg              : 507
[18278.209110]   .tg->cfs_bandwidth.timer_active: 0
[18278.209113]   .throttled                     : 0
[18278.209116]   .throttle_count                : 0
[18278.209120]   .avg->runnable_avg_sum         : 7602
[18278.209123]   .avg->runnable_avg_period      : 48909
[18278.209127]
rt_rq[1]:/
[18278.209132]   .rt_nr_running                 : 0
[18278.209135]   .rt_throttled                  : 0
[18278.209138]   .rt_time                       : 0.000000
[18278.209142]   .rt_runtime                    : 950.000000
[18278.209145]
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[18278.209153]         kthreadd     2      5826.999191       161   120      5826.999191         3.249500  16667120.269330 0 /
[18278.209164]        rcu_sched     8      1574.198414        29   120      1574.198414         0.506276    118147.524258 0 /
[18278.209174]       watchdog/1    12        -2.977429      4567     0        -2.977429        99.973449         0.000000 0 /
[18278.209184]      migration/1    13         0.000000       139     0         0.000000         5.997613         0.000000 0 /
[18278.209194]      ksoftirqd/1    14      6037.547356      2814   120      6037.547356       100.883884  18277888.142702 0 /
[18278.209203]     kworker/1:0H    16       314.272745         7   100       314.272745         0.046487      4323.556642 0 /
[18278.209214]        kdevtmpfs    28       649.876853       146   120       649.876853         2.261950     14573.638099 0 /
[18278.209225]         kthrotld    44         8.091400         2   100         8.091400         0.015555         0.007082 0 /
[18278.209234]    ipv6_addrconf    45        17.106643         2   100        17.106643         0.016500         0.007634 0 /
[18278.209244]          deferwq    46        26.122380         2   100        26.122380         0.017050         0.007365 0 /
[18278.209254]        scsi_eh_2    83       243.017875         5   120       243.017875         0.197952       152.856454 0 /
[18278.209263]       scsi_tmf_3    86       195.038503         2   100       195.038503         0.006546         0.004825 0 /
[18278.209274]       scsi_tmf_9   108       248.253960         2   100       248.253960         0.013197         0.009032 0 /
[18278.209283]           bioset   143       312.422065         2   100       312.422065         0.011770         0.000000 0 /
[18278.209293]     kworker/1:1H   150      5763.102018       110   100      5763.102018         2.210108  16659933.678318 0 /
[18278.209303]  kvm-irqfd-clean   256       586.122582         2   100       586.122582         0.011624         0.018528 0 /
[18278.209313]            crond   273        78.592984       326   120        78.592984        97.623152  18221928.795258 0 /autogroup-20
[18278.209324]           agetty   286         1.834804         9   120         1.834804        16.210705      5164.820008 0 /autogroup-32
[18278.209334]            named   372        30.752128       262   120        30.752128        36.869318  18024048.848870 0 /autogroup-27
[18278.209345]    kworker/u17:0   509      3724.427873        10   100      3724.427873        14.351555    605549.420117 0 /
[18278.209355]  btrfs-flush_del   512      1789.624926         2   100      1789.624926         0.029969         0.010746 0 /
[18278.209366]    kworker/u17:2   708      3464.730080         6   100      3464.730080        14.868514         0.027461 0 /
[18278.209376]      kworker/1:0   811      5837.017223     15654   120      5837.017223       669.179652  15952161.656976 0 /
[18278.209386]             smbd  1440       216.408985      1151   120       216.408985       209.848892      3164.041373 0 /autogroup-35
[18278.209397]      kworker/1:1  1509      6037.566504      7393   120      6037.566504       203.715981   1725106.065661 0 /
[18278.209407]            crond  1522        71.214608         4   120        71.214608        10.396548        54.910307 0 /autogroup-20

[18278.209421] cpu#2, 3214.094 MHz
[18278.209424]   .nr_running                    : 1
[18278.209428]   .load                          : 325
[18278.209431]   .nr_switches                   : 493146
[18278.209434]   .nr_load_updates               : 201909
[18278.209438]   .nr_uninterruptible            : -469
[18278.209442]   .next_balance                  : 4300.353445
[18278.209445]   .curr->pid                     : 1662
[18278.209449]   .clock                         : 18278207.214750
[18278.209452]   .cpu_load[0]                   : 0
[18278.209455]   .cpu_load[1]                   : 0
[18278.209458]   .cpu_load[2]                   : 3
[18278.209461]   .cpu_load[3]                   : 4
[18278.209464]   .cpu_load[4]                   : 2
[18278.209468]   .yld_count                     : 0
[18278.209471]   .sched_count                   : 502223
[18278.209474]   .sched_goidle                  : 239378
[18278.209478]   .avg_idle                      : 1000000
[18278.209481]   .max_idle_balance_cost         : 500000
[18278.209485]   .ttwu_count                    : 329424
[18278.209488]   .ttwu_local                    : 246380
[18278.209492]
cfs_rq[2]:/autogroup-8
[18278.209497]   .exec_clock                    : 70.024794
[18278.209501]   .MIN_vruntime                  : 0.000001
[18278.209505]   .min_vruntime                  : 68.976218
[18278.209508]   .max_vruntime                  : 0.000001
[18278.209511]   .spread                        : 0.000000
[18278.209515]   .spread0                       : -7910.718795
[18278.209518]   .nr_spread_over                : 0
[18278.209522]   .nr_running                    : 0
[18278.209525]   .load                          : 0
[18278.209528]   .runnable_load_avg             : 0
[18278.209531]   .blocked_load_avg              : 0
[18278.209534]   .tg_load_contrib               : 0
[18278.209538]   .tg_runnable_contrib           : 0
[18278.209541]   .tg_load_avg                   : 0
[18278.209544]   .tg->runnable_avg              : 8
[18278.209547]   .tg->cfs_bandwidth.timer_active: 0
[18278.209550]   .throttled                     : 0
[18278.209553]   .throttle_count                : 0
[18278.209557]   .se->exec_start                : 18278202.895677
[18278.209561]   .se->vruntime                  : 15951.933539
[18278.209565]   .se->sum_exec_runtime          : 70.024794
[18278.209568]   .se->statistics.wait_start     : 0.000000
[18278.209572]   .se->statistics.sleep_start    : 0.000000
[18278.209576]   .se->statistics.block_start    : 0.000000
[18278.209579]   .se->statistics.sleep_max      : 0.000000
[18278.209583]   .se->statistics.block_max      : 0.000000
[18278.209586]   .se->statistics.exec_max       : 3.338288
[18278.209590]   .se->statistics.slice_max      : 0.710750
[18278.209593]   .se->statistics.wait_max       : 0.285020
[18278.209597]   .se->statistics.wait_sum       : 2.267731
[18278.209600]   .se->statistics.wait_count     : 149
[18278.209604]   .se->load.weight               : 2
[18278.209607]   .se->avg.runnable_avg_sum      : 45
[18278.209610]   .se->avg.runnable_avg_period   : 49013
[18278.209614]   .se->avg.load_avg_contrib      : 0
[18278.209617]   .se->avg.decay_count           : 17431453
[18278.209621]
cfs_rq[2]:/autogroup-24
[18278.209626]   .exec_clock                    : 18.106602
[18278.209630]   .MIN_vruntime                  : 0.000001
[18278.209634]   .min_vruntime                  : 17.058026
[18278.209637]   .max_vruntime                  : 0.000001
[18278.209641]   .spread                        : 0.000000
[18278.209644]   .spread0                       : -7962.636987
[18278.209647]   .nr_spread_over                : 0
[18278.209651]   .nr_running                    : 0
[18278.209654]   .load                          : 0
[18278.209657]   .runnable_load_avg             : 0
[18278.209660]   .blocked_load_avg              : 0
[18278.209663]   .tg_load_contrib               : 0
[18278.209667]   .tg_runnable_contrib           : 7
[18278.209670]   .tg_load_avg                   : 0
[18278.209673]   .tg->runnable_avg              : 7
[18278.209676]   .tg->cfs_bandwidth.timer_active: 0
[18278.209679]   .throttled                     : 0
[18278.209683]   .throttle_count                : 0
[18278.209686]   .se->exec_start                : 18278202.679109
[18278.209690]   .se->vruntime                  : 15952.263644
[18278.209694]   .se->sum_exec_runtime          : 18.106602
[18278.209698]   .se->statistics.wait_start     : 0.000000
[18278.209701]   .se->statistics.sleep_start    : 0.000000
[18278.209705]   .se->statistics.block_start    : 0.000000
[18278.209708]   .se->statistics.sleep_max      : 0.000000
[18278.209712]   .se->statistics.block_max      : 0.000000
[18278.209715]   .se->statistics.exec_max       : 0.869085
[18278.209719]   .se->statistics.slice_max      : 0.381469
[18278.209722]   .se->statistics.wait_max       : 0.606158
[18278.209726]   .se->statistics.wait_sum       : 2.942373
[18278.209729]   .se->statistics.wait_count     : 131
[18278.209732]   .se->load.weight               : 2
[18278.209736]   .se->avg.runnable_avg_sum      : 352
[18278.209739]   .se->avg.runnable_avg_period   : 48835
[18278.209742]   .se->avg.load_avg_contrib      : 0
[18278.209746]   .se->avg.decay_count           : 17431453
[18278.209750]
cfs_rq[2]:/autogroup-40
[18278.209755]   .exec_clock                    : 271.745697
[18278.209759]   .MIN_vruntime                  : 0.000001
[18278.209763]   .min_vruntime                  : 618.693623
[18278.209766]   .max_vruntime                  : 0.000001
[18278.209769]   .spread                        : 0.000000
[18278.209773]   .spread0                       : -7361.001390
[18278.209776]   .nr_spread_over                : 60
[18278.209780]   .nr_running                    : 1
[18278.209783]   .load                          : 1024
[18278.209786]   .runnable_load_avg             : 1023
[18278.209790]   .blocked_load_avg              : 0
[18278.209793]   .tg_load_contrib               : 1023
[18278.209796]   .tg_runnable_contrib           : 92
[18278.209799]   .tg_load_avg                   : 2133
[18278.209803]   .tg->runnable_avg              : 473
[18278.209806]   .tg->cfs_bandwidth.timer_active: 0
[18278.209809]   .throttled                     : 0
[18278.209812]   .throttle_count                : 0
[18278.209816]   .se->exec_start                : 18278207.214750
[18278.209820]   .se->vruntime                  : 15965.975136
[18278.209824]   .se->sum_exec_runtime          : 271.745697
[18278.209827]   .se->statistics.wait_start     : 0.000000
[18278.209831]   .se->statistics.sleep_start    : 0.000000
[18278.209834]   .se->statistics.block_start    : 0.000000
[18278.209838]   .se->statistics.sleep_max      : 0.000000
[18278.209841]   .se->statistics.block_max      : 0.000000
[18278.209845]   .se->statistics.exec_max       : 3.654235
[18278.209849]   .se->statistics.slice_max      : 1.454261
[18278.209852]   .se->statistics.wait_max       : 0.064238
[18278.209856]   .se->statistics.wait_sum       : 5.702704
[18278.209859]   .se->statistics.wait_count     : 403
[18278.209862]   .se->load.weight               : 325
[18278.209866]   .se->avg.runnable_avg_sum      : 4273
[18278.209869]   .se->avg.runnable_avg_period   : 47173
[18278.209872]   .se->avg.load_avg_contrib      : 224
[18278.209876]   .se->avg.decay_count           : 0
[18278.209880]
cfs_rq[2]:/autogroup-39
[18278.209885]   .exec_clock                    : 506.152600
[18278.209889]   .MIN_vruntime                  : 0.000001
[18278.209892]   .min_vruntime                  : 504.891350
[18278.209896]   .max_vruntime                  : 0.000001
[18278.209899]   .spread                        : 0.000000
[18278.209903]   .spread0                       : -7474.803663
[18278.209906]   .nr_spread_over                : 0
[18278.209909]   .nr_running                    : 0
[18278.209912]   .load                          : 0
[18278.209916]   .runnable_load_avg             : 0
[18278.209919]   .blocked_load_avg              : 1
[18278.209922]   .tg_load_contrib               : 1
[18278.209925]   .tg_runnable_contrib           : 6
[18278.209928]   .tg_load_avg                   : 7
[18278.209932]   .tg->runnable_avg              : 6
[18278.209935]   .tg->cfs_bandwidth.timer_active: 0
[18278.209938]   .throttled                     : 0
[18278.209941]   .throttle_count                : 0
[18278.209945]   .se->exec_start                : 18278191.644003
[18278.209949]   .se->vruntime                  : 15951.198082
[18278.209953]   .se->sum_exec_runtime          : 506.152600
[18278.209956]   .se->statistics.wait_start     : 0.000000
[18278.209960]   .se->statistics.sleep_start    : 0.000000
[18278.209963]   .se->statistics.block_start    : 0.000000
[18278.209967]   .se->statistics.sleep_max      : 0.000000
[18278.209970]   .se->statistics.block_max      : 0.000000
[18278.209974]   .se->statistics.exec_max       : 3.353685
[18278.209977]   .se->statistics.slice_max      : 0.156887
[18278.209981]   .se->statistics.wait_max       : 0.187074
[18278.209985]   .se->statistics.wait_sum       : 1.106308
[18278.209988]   .se->statistics.wait_count     : 3976
[18278.209991]   .se->load.weight               : 2
[18278.209994]   .se->avg.runnable_avg_sum      : 283
[18278.209998]   .se->avg.runnable_avg_period   : 47775
[18278.210001]   .se->avg.load_avg_contrib      : 3
[18278.210005]   .se->avg.decay_count           : 17431442
[18278.210008]
cfs_rq[2]:/
[18278.210013]   .exec_clock                    : 19922.277141
[18278.210017]   .MIN_vruntime                  : 0.000001
[18278.210020]   .min_vruntime                  : 15965.975136
[18278.210024]   .max_vruntime                  : 0.000001
[18278.210027]   .spread                        : 0.000000
[18278.210031]   .spread0                       : 7986.280123
[18278.210034]   .nr_spread_over                : 39
[18278.210037]   .nr_running                    : 1
[18278.210041]   .load                          : 325
[18278.210044]   .runnable_load_avg             : 224
[18278.210047]   .blocked_load_avg              : 9
[18278.210050]   .tg_load_contrib               : 140
[18278.210054]   .tg_runnable_contrib           : 111
[18278.210057]   .tg_load_avg                   : 554
[18278.210060]   .tg->runnable_avg              : 507
[18278.210063]   .tg->cfs_bandwidth.timer_active: 0
[18278.210067]   .throttled                     : 0
[18278.210070]   .throttle_count                : 0
[18278.210073]   .avg->runnable_avg_sum         : 5235
[18278.210077]   .avg->runnable_avg_period      : 47883
[18278.210081]
rt_rq[2]:/
[18278.210085]   .rt_nr_running                 : 0
[18278.210088]   .rt_throttled                  : 0
[18278.210092]   .rt_time                       : 0.000000
[18278.210095]   .rt_runtime                    : 950.000000
[18278.210099]
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[18278.210107]      rcu_preempt     7     15951.932476     37104   120     15951.932476      1022.887166  18276900.871931 0 /
[18278.210118]       watchdog/2    17        -5.974018      4567     0        -5.974018       120.436152         0.000000 0 /
[18278.210128]      migration/2    18         0.000000       119     0         0.000000         5.660518         0.000000 0 /
[18278.210137]      ksoftirqd/2    19     15951.894337      8307   120     15951.894337       229.277377  18277708.747551 0 /
[18278.210147]     kworker/2:0H    21       276.416428         7   100       276.416428         0.041062      1449.512580 0 /
[18278.210157]       khungtaskd    30     15947.222063       154   120     15947.222063         6.442826  18264126.468919 0 /
[18278.210167]       khugepaged    33     15957.120347      1829   139     15957.120347        88.409265  18274584.971863 0 /
[18278.210177]           crypto    34         7.959417         2   100         7.959417         0.009277         0.002051 0 /
[18278.210186]      kintegrityd    35        16.965124         2   100        16.965124         0.006466         0.002173 0 /
[18278.210196]           bioset    36        25.971039         2   100        25.971039         0.006553         0.002116 0 /
[18278.210205]          kswapd0    39       240.490276         3   120       240.490276         0.046296        97.568037 0 /
[18278.210215]    fsnotify_mark    40      3228.349012        16   120      3228.349012         0.344184    762009.335133 0 /
[18278.210226]          ata_sff    79       141.983836         2   100       141.983836         0.014661         0.011459 0 /
[18278.210235]        scsi_eh_0    80       265.072299        24   120       265.072299         0.301585       495.816875 0 /
[18278.210245]       scsi_tmf_0    81       162.947376         2   100       162.947376         0.015436         0.007516 0 /
[18278.210255]        scsi_eh_1    82       265.090598        26   120       265.090598         0.376758       494.353886 0 /
[18278.210265]        scsi_eh_3    85       273.828008         5   120       273.828008        11.687633       305.757650 0 /
[18278.210274]       scsi_tmf_1    88       177.466235         2   100       177.466235         0.014676         0.009012 0 /
[18278.210284]        scsi_eh_4    91       265.056062        24   120       265.056062         0.330446       491.685562 0 /
[18278.210294]        scsi_eh_5    93       265.118782        24   120       265.118782         0.350483       491.361906 0 /
[18278.210303]        scsi_eh_6    95       265.060681        24   120       265.060681         0.359100       491.890923 0 /
[18278.210313]        scsi_eh_7    97       265.144191        26   120       265.144191         0.515840       488.171054 0 /
[18278.210322]       scsi_tmf_7    98       212.661097         2   100       212.661097         0.009961         0.001414 0 /
[18278.210332]        scsi_eh_8   105       265.192611        24   120       265.192611         0.460831       487.515304 0 /
[18278.210341]       scsi_tmf_8   106       239.712792         2   100       239.712792         0.018596         0.008056 0 /
[18278.210351]     kworker/2:1H   118     15951.886249     60378   100     15951.886249      1198.258654  18275307.729425 0 /
[18278.210361]      jbd2/sde3-8   154     15952.079433      3129   120     15952.079433       194.702700  18270819.273165 0 /
[18278.210371]  systemd-journal   178        68.976218       873   120        68.976218       312.076972  18268546.579304 0 /autogroup-8
[18278.210382]         ttm_swap   249      1357.535248         2   100      1357.535248         0.005573         0.000000 0 /
[18278.210392]   systemd-logind   275         9.402403       623   120         9.402403        63.897840  18251085.646530 0 /autogroup-22
[18278.210402]      dbus-daemon   276         9.011344       189   120         9.011344        50.443774  16653692.955031 0 /autogroup-23
[18278.210413]        syslog-ng   282        17.058026       556   120        17.058026       133.791977  18263248.109966 0 /autogroup-24
[18278.210424]            named   371        12.023273       196   120        12.023273         7.774733  18024078.558916 0 /autogroup-27
[18278.210435]             sshd   365         0.386980        45   120         0.386980        19.950264    593728.143491 0 /autogroup-28
[18278.210445]             ntpd   368       282.557234     18728   120       282.557234      1018.691618  18257114.331208 0 /autogroup-31
[18278.210455]             nmbd   375       657.863321      5190   120       657.863321       668.050599  18250849.829850 0 /autogroup-33
[18278.210466]      kworker/2:3   382     15957.004438    123098   120     15957.004438      4605.678232  18153906.648685 0 /
[18278.210475]             sshd   396       486.114148      3854   120       486.114148       496.762518  17891790.776368 0 /autogroup-36
[18278.210487]      btrfs-cache   513      2380.984458         2   100      2380.984458         0.014965         0.025295 0 /
[18278.210497]  btrfs-transacti   536     15947.222946      9696   120     15947.222946      1008.805977  17744707.519829 0 /
[18278.210507]              ssh   697       525.649474        21   120       525.649474        27.475167       309.032020 0 /autogroup-38
[18278.210518]      kworker/2:0   810      3725.060067         3   120      3725.060067         0.030187    301232.196894 0 /
[18278.210529]             sadc  1532        48.224005        11   120        48.224005        30.660732   1201587.980932 0 /autogroup-58
[18278.210539] R            tee  1662       618.693623         2   120       618.693623         1.998424         0.000000 0 /autogroup-40

[18278.210553] cpu#3, 3214.094 MHz
[18278.210556]   .nr_running                    : 0
[18278.210560]   .load                          : 0
[18278.210563]   .nr_switches                   : 184291
[18278.210566]   .nr_load_updates               : 74908
[18278.210570]   .nr_uninterruptible            : 432
[18278.210574]   .next_balance                  : 4300.353476
[18278.210577]   .curr->pid                     : 0
[18278.210581]   .clock                         : 18278207.324923
[18278.210584]   .cpu_load[0]                   : 0
[18278.210587]   .cpu_load[1]                   : 0
[18278.210590]   .cpu_load[2]                   : 0
[18278.210593]   .cpu_load[3]                   : 0
[18278.210596]   .cpu_load[4]                   : 0
[18278.210599]   .yld_count                     : 0
[18278.210603]   .sched_count                   : 193368
[18278.210606]   .sched_goidle                  : 96670
[18278.210610]   .avg_idle                      : 1000000
[18278.210613]   .max_idle_balance_cost         : 500000
[18278.210616]   .ttwu_count                    : 74185
[18278.210620]   .ttwu_local                    : 42025
[18278.210624]
cfs_rq[3]:/autogroup-39
[18278.210629]   .exec_clock                    : 27.361298
[18278.210633]   .MIN_vruntime                  : 0.000001
[18278.210636]   .min_vruntime                  : 44.195032
[18278.210640]   .max_vruntime                  : 0.000001
[18278.210643]   .spread                        : 0.000000
[18278.210647]   .spread0                       : -7935.499981
[18278.210650]   .nr_spread_over                : 0
[18278.210654]   .nr_running                    : 0
[18278.210657]   .load                          : 0
[18278.210660]   .runnable_load_avg             : 0
[18278.210663]   .blocked_load_avg              : 6
[18278.210666]   .tg_load_contrib               : 6
[18278.210670]   .tg_runnable_contrib           : 0
[18278.210673]   .tg_load_avg                   : 7
[18278.210676]   .tg->runnable_avg              : 6
[18278.210679]   .tg->cfs_bandwidth.timer_active: 0
[18278.210682]   .throttled                     : 0
[18278.210686]   .throttle_count                : 0
[18278.210690]   .se->exec_start                : 18278207.320182
[18278.210693]   .se->vruntime                  : 7803.366221
[18278.210697]   .se->sum_exec_runtime          : 27.361298
[18278.210701]   .se->statistics.wait_start     : 0.000000
[18278.210704]   .se->statistics.sleep_start    : 0.000000
[18278.210708]   .se->statistics.block_start    : 0.000000
[18278.210711]   .se->statistics.sleep_max      : 0.000000
[18278.210715]   .se->statistics.block_max      : 0.000000
[18278.210718]   .se->statistics.exec_max       : 3.303389
[18278.210722]   .se->statistics.slice_max      : 0.000000
[18278.210725]   .se->statistics.wait_max       : 0.027254
[18278.210729]   .se->statistics.wait_sum       : 0.088775
[18278.210732]   .se->statistics.wait_count     : 80
[18278.210736]   .se->load.weight               : 2
[18278.210739]   .se->avg.runnable_avg_sum      : 113
[18278.210742]   .se->avg.runnable_avg_period   : 48804
[18278.210746]   .se->avg.load_avg_contrib      : 4
[18278.210749]   .se->avg.decay_count           : 17431457
[18278.210753]
cfs_rq[3]:/autogroup-2
[18278.210758]   .exec_clock                    : 526.098730
[18278.210762]   .MIN_vruntime                  : 0.000001
[18278.210766]   .min_vruntime                  : 661.073836
[18278.210769]   .max_vruntime                  : 0.000001
[18278.210773]   .spread                        : 0.000000
[18278.210776]   .spread0                       : -7318.621177
[18278.210780]   .nr_spread_over                : 11
[18278.210783]   .nr_running                    : 0
[18278.210786]   .load                          : 0
[18278.210789]   .runnable_load_avg             : 0
[18278.210792]   .blocked_load_avg              : 3
[18278.210796]   .tg_load_contrib               : 3
[18278.210799]   .tg_runnable_contrib           : 4
[18278.210802]   .tg_load_avg                   : 3
[18278.210805]   .tg->runnable_avg              : 4
[18278.210808]   .tg->cfs_bandwidth.timer_active: 0
[18278.210812]   .throttled                     : 0
[18278.210815]   .throttle_count                : 0
[18278.210819]   .se->exec_start                : 18278202.492620
[18278.210822]   .se->vruntime                  : 7803.469792
[18278.210826]   .se->sum_exec_runtime          : 526.098730
[18278.210830]   .se->statistics.wait_start     : 0.000000
[18278.210833]   .se->statistics.sleep_start    : 0.000000
[18278.210837]   .se->statistics.block_start    : 0.000000
[18278.210840]   .se->statistics.sleep_max      : 0.000000
[18278.210844]   .se->statistics.block_max      : 0.000000
[18278.210847]   .se->statistics.exec_max       : 3.214201
[18278.210851]   .se->statistics.slice_max      : 0.385175
[18278.210855]   .se->statistics.wait_max       : 1.185065
[18278.210858]   .se->statistics.wait_sum       : 6.382706
[18278.210861]   .se->statistics.wait_count     : 6651
[18278.210865]   .se->load.weight               : 2
[18278.210868]   .se->avg.runnable_avg_sum      : 191
[18278.210871]   .se->avg.runnable_avg_period   : 48158
[18278.210875]   .se->avg.load_avg_contrib      : 3
[18278.210878]   .se->avg.decay_count           : 17431453
[18278.210882]
cfs_rq[3]:/autogroup-40
[18278.210888]   .exec_clock                    : 376.743990
[18278.210891]   .MIN_vruntime                  : 0.000001
[18278.210895]   .min_vruntime                  : 420.882135
[18278.210898]   .max_vruntime                  : 0.000001
[18278.210902]   .spread                        : 0.000000
[18278.210905]   .spread0                       : -7558.812878
[18278.210909]   .nr_spread_over                : 25
[18278.210912]   .nr_running                    : 0
[18278.210915]   .load                          : 0
[18278.210918]   .runnable_load_avg             : 0
[18278.210922]   .blocked_load_avg              : 138
[18278.210925]   .tg_load_contrib               : 138
[18278.210928]   .tg_runnable_contrib           : 2
[18278.210932]   .tg_load_avg                   : 2133
[18278.210935]   .tg->runnable_avg              : 473
[18278.210938]   .tg->cfs_bandwidth.timer_active: 0
[18278.210941]   .throttled                     : 0
[18278.210945]   .throttle_count                : 0
[18278.210949]   .se->exec_start                : 18278192.850797
[18278.210952]   .se->vruntime                  : 7812.250380
[18278.210956]   .se->sum_exec_runtime          : 376.743990
[18278.210960]   .se->statistics.wait_start     : 0.000000
[18278.210963]   .se->statistics.sleep_start    : 0.000000
[18278.210967]   .se->statistics.block_start    : 0.000000
[18278.210970]   .se->statistics.sleep_max      : 0.000000
[18278.210974]   .se->statistics.block_max      : 0.000000
[18278.210977]   .se->statistics.exec_max       : 3.340994
[18278.210981]   .se->statistics.slice_max      : 0.027196
[18278.210985]   .se->statistics.wait_max       : 0.073285
[18278.210988]   .se->statistics.wait_sum       : 5.005784
[18278.210991]   .se->statistics.wait_count     : 652
[18278.210995]   .se->load.weight               : 2
[18278.210998]   .se->avg.runnable_avg_sum      : 116
[18278.211001]   .se->avg.runnable_avg_period   : 47850
[18278.211005]   .se->avg.load_avg_contrib      : 30
[18278.211008]   .se->avg.decay_count           : 17431444
[18278.211011]
cfs_rq[3]:/
[18278.211016]   .exec_clock                    : 9560.433628
[18278.211020]   .MIN_vruntime                  : 0.000001
[18278.211024]   .min_vruntime                  : 7812.250380
[18278.211027]   .max_vruntime                  : 0.000001
[18278.211031]   .spread                        : 0.000000
[18278.211034]   .spread0                       : -167.444633
[18278.211038]   .nr_spread_over                : 35
[18278.211041]   .nr_running                    : 0
[18278.211044]   .load                          : 0
[18278.211047]   .runnable_load_avg             : 0
[18278.211050]   .blocked_load_avg              : 0
[18278.211054]   .tg_load_contrib               : 0
[18278.211057]   .tg_runnable_contrib           : 12
[18278.211060]   .tg_load_avg                   : 554
[18278.211064]   .tg->runnable_avg              : 507
[18278.211067]   .tg->cfs_bandwidth.timer_active: 0
[18278.211070]   .throttled                     : 0
[18278.211073]   .throttle_count                : 0
[18278.211077]   .avg->runnable_avg_sum         : 599
[18278.211080]   .avg->runnable_avg_period      : 47751
[18278.211084]
rt_rq[3]:/
[18278.211088]   .rt_nr_running                 : 0
[18278.211092]   .rt_throttled                  : 0
[18278.211095]   .rt_time                       : 0.000000
[18278.211099]   .rt_runtime                    : 950.000000
[18278.211102]
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[18278.211109]          systemd     1       661.073836      2090   120       661.073836       957.362208  18277204.459858 0 /autogroup-2
[18278.211122]       watchdog/3    22        -5.976746      4567     0        -5.976746       101.109125         0.000000 0 /
[18278.211131]      migration/3    23         0.000000       107     0         0.000000         5.651260         0.000000 0 /
[18278.211141]      ksoftirqd/3    24      7802.873509      4309   120      7802.873509       169.391611  18264149.354664 0 /
[18278.211151]     kworker/3:0H    26       550.155136         7   100       550.155136         0.048448      1484.681011 0 /
[18278.211161]          khelper    27         7.964692         2   100         7.964692         0.014908         0.005697 0 /
[18278.211170]            netns    29        26.057102         2   100        26.057102         0.023047         0.005816 0 /
[18278.211180]        writeback    31        44.081234         2   100        44.081234         0.007418         0.002039 0 /
[18278.211190]             ksmd    32        53.091945         2   125        53.091945         0.007793         0.002249 0 /
[18278.211200]      kworker/3:1    38      7803.933329     30195   120      7803.933329      1178.356198  18276141.922810 0 /
[18278.211211]       scsi_tmf_6    96       507.104702         2   100       507.104702         0.009548         0.009052 0 /
[18278.211221]        scsi_eh_9   107       527.668794        24   120       527.668794         0.420877       487.375164 0 /
[18278.211231]     kworker/3:1H   124      7562.875528       299   100      7562.875528         8.507854  16664544.110267 0 /
[18278.211241]      edac-poller   227      1018.154494         2   100      1018.154494         0.031027         0.016345 0 /
[18278.211252]            named   373         3.566353       167   120         3.566353         3.435640  18024084.072643 0 /autogroup-27
[18278.211262]            named   374         0.469168         5   120         0.469168         0.210493       583.994025 0 /autogroup-27
[18278.211272]             smbd   377      4208.674038      1917   120      4208.674038      1096.417422  18215945.820318 0 /autogroup-35
[18278.211283]          systemd   398        14.585524        20   120        14.585524        26.108250    127396.306380 0 /autogroup-37
[18278.211293]         (sd-pam)   399         8.145992         2   120         8.145992         0.194576         0.000000 0 /autogroup-37
[18278.211303]              zsh   401       900.779414       582   120       900.779414       324.360011    234863.546190 0 /autogroup-38
[18278.211314]  btrfs-worker-hi   510      2622.965331         2   100      2622.965331         0.024545         0.009680 0 /
[18278.211325]    btrfs-cleaner   535      7802.684648       596   120      7802.684648        17.986146  17745742.094767 0 /
[18278.211334]             sshd   578        44.195032      4042   120        44.195032       520.727780  17666173.795735 0 /autogroup-39
[18278.211345]              zsh   580       420.882135       724   120       420.882135       345.301299  17664795.585384 0 /autogroup-40
[18278.211355]  btrfs_vserver.s   682       948.515214        14   120       948.515214        11.309807     31295.594534 0 /autogroup-38
[18278.211365]            rsync   696       960.192733        57   120       960.192733        23.863283       549.709619 0 /autogroup-38
[18278.211376]    kworker/u16:6   702      7803.097114      3302   120      7803.097114       334.630207  17579694.968254 0 /
[18278.211386]      kworker/3:0  1515      7562.880576         4   120      7562.880576         0.038685    113728.381369 0 /

--------------030606070706000909050807--
