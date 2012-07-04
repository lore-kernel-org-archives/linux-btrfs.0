Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49358 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2GDPP5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 11:15:57 -0400
Date: Wed, 4 Jul 2012 08:15:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device dm-0): Aborting unused transaction
Message-ID: <20120704151556.GD6807@merlins.org>
References: <20120626193637.GA27856@merlins.org> <20120626193637.GA27856@merlins.org> <20120627013818.GA3556@merlins.org> <20120627052012.GA32533@merlins.org> <20120629123624.GS7472@merlins.org> <20120702195820.GA10655@merlins.org> <4FF3DB87.5090405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120626193637.GA27856@merlins.org> <4FF3DB87.5090405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 01:58:31PM +0800, Liu Bo wrote:
> The dmesg log, sysrq log and stack dump info can usually be very helpful.
> 
> From your report, we can see the csum error and hang on log,
> 'no csum' is not that bad while hanging-on is serious and dangerous.
> 
> so can you please get any 'sysrq + w' log in the hanging-on case and paste them here,
> and the log may tell us who blocks other threads.

Hi, thanks for the answer.
 
I dumped all sysrq data, that was in my original Email. Here are two
different sysrq+w runs, as well as aborted transaction messages from that
Email. 
Sorry that the original was a bit long and contained a bunch of sysrq output.

>From doing further testing since then, it does seem that the code just start
doing bad things, including the file corruption I saw, when I'm running low
on free space.

Anything else that would help?

Thanks,
Marc

> [84951.680847] Sched Debug Version: v0.10, 3.4.4-amd64-preempt-noide-20120410 #1
> [84951.680850] ktime                                   : 84951680.847904
> [84951.680851] sched_clk                               : 55820767.832790
> [84951.680853] cpu_clk                                 : 84951680.846676
> [84951.680855] jiffies                                 : 4316130216
> [84951.680857] sched_clock_stable                      : 0
> [84951.680858] 
> [84951.680859] sysctl_sched
> [84951.680860]   .sysctl_sched_latency                    : 12.000000
> [84951.680862]   .sysctl_sched_min_granularity            : 1.500000
> [84951.680864]   .sysctl_sched_wakeup_granularity         : 2.000000
> [84951.680865]   .sysctl_sched_child_runs_first           : 0
> [84951.680867]   .sysctl_sched_features                   : 24119
> [84951.680869]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [84951.680871] 
> [84951.680872] cpu#0, 2527.110 MHz
> [84951.680873]   .nr_running                    : 4
> [84951.680875]   .load                          : 1542
> [84951.680876]   .nr_switches                   : 298015357
> [84951.680878]   .nr_load_updates               : 16858906
> [84951.680879]   .nr_uninterruptible            : -7812
> [84951.680881]   .next_balance                  : 4316.130229
> [84951.680883]   .curr->pid                     : 6859
> [84951.680884]   .clock                         : 84951679.104864
> [84951.680886]   .cpu_load[0]                   : 1277
> [84951.680887]   .cpu_load[1]                   : 885
> [84951.680889]   .cpu_load[2]                   : 728
> [84951.680890]   .cpu_load[3]                   : 693
> [84951.680892]   .cpu_load[4]                   : 731
> [84951.680894] 
> [84951.680894] cfs_rq[0]:/autogroup-69
> [84951.680896]   .exec_clock                    : 0.000000
> [84951.680898]   .MIN_vruntime                  : 0.000001
> [84951.680899]   .min_vruntime                  : 194572.976125
> [84951.680901]   .max_vruntime                  : 0.000001
> [84951.680903]   .spread                        : 0.000000
> [84951.680904]   .spread0                       : -52160826.593685
> [84951.680906]   .nr_spread_over                : 0
> [84951.680907]   .nr_running                    : 0
> [84951.680909]   .load                          : 0
> [84951.680910]   .load_avg                      : 5179.920896
> [84951.680912]   .load_period                   : 8.310703
> [84951.680913]   .load_contrib                  : 623
> [84951.680915]   .load_tg                       : 623
> [84951.680917]   .se->exec_start                : 84951675.234336
> [84951.680918]   .se->vruntime                  : 52355393.270692
> [84951.680920]   .se->sum_exec_runtime          : 241715.485721
> [84951.680922]   .se->load.weight               : 2
> [84951.680923] 
> [84951.680924] cfs_rq[0]:/autogroup-20
> [84951.680925]   .exec_clock                    : 0.000000
> [84951.680927]   .MIN_vruntime                  : 0.000001
> [84951.680929]   .min_vruntime                  : 13027.823103
> [84951.680930]   .max_vruntime                  : 0.000001
> [84951.680932]   .spread                        : 0.000000
> [84951.680934]   .spread0                       : -52342371.746707
> [84951.680935]   .nr_spread_over                : 0
> [84951.680937]   .nr_running                    : 0
> [84951.680938]   .load                          : 0
> [84951.680940]   .load_avg                      : 1279.999872
> [84951.680941]   .load_period                   : 6.444962
> [84951.680943]   .load_contrib                  : 198
> [84951.680944]   .load_tg                       : 257
> [84951.680946]   .se->exec_start                : 84951664.094034
> [84951.680948]   .se->vruntime                  : 52355389.621584
> [84951.680950]   .se->sum_exec_runtime          : 13082.655453
> [84951.680951]   .se->load.weight               : 2
> [84951.680953] 
> [84951.680954] cfs_rq[0]:/autogroup-74
> [84951.680955]   .exec_clock                    : 0.000000
> [84951.680957]   .MIN_vruntime                  : 1323610.934982
> [84951.680959]   .min_vruntime                  : 1323616.934982
> [84951.680960]   .max_vruntime                  : 1323610.934982
> [84951.680962]   .spread                        : 0.000000
> [84951.680964]   .spread0                       : -51031782.634828
> [84951.680965]   .nr_spread_over                : 0
> [84951.680967]   .nr_running                    : 1
> [84951.680968]   .load                          : 1024
> [84951.680970]   .load_avg                      : 252.855291
> [84951.680971]   .load_period                   : 6.216878
> [84951.680973]   .load_contrib                  : 44
> [84951.680974]   .load_tg                       : 991
> [84951.680976]   .se->exec_start                : 84951670.049973
> [84951.680978]   .se->vruntime                  : 52355393.569810
> [84951.680980]   .se->sum_exec_runtime          : 2397898.918671
> [84951.680981]   .se->load.weight               : 532
> [84951.680983] 
> [84951.680984] cfs_rq[0]:/autogroup-28
> [84951.680985]   .exec_clock                    : 0.000000
> [84951.680987]   .MIN_vruntime                  : 0.000001
> [84951.680989]   .min_vruntime                  : 3527635.809340
> [84951.680990]   .max_vruntime                  : 0.000001
> [84951.680992]   .spread                        : 0.000000
> [84951.680993]   .spread0                       : -48827763.760470
> [84951.680995]   .nr_spread_over                : 0
> [84951.680996]   .nr_running                    : 0
> [84951.680998]   .load                          : 0
> [84951.680999]   .load_avg                      : 1058.675911
> [84951.681001]   .load_period                   : 6.328132
> [84951.681002]   .load_contrib                  : 155
> [84951.681004]   .load_tg                       : 1169
> [84951.681006]   .se->exec_start                : 84951678.610201
> [84951.681007]   .se->vruntime                  : 52355394.509141
> [84951.681009]   .se->sum_exec_runtime          : 3528010.809431
> [84951.681011]   .se->load.weight               : 2
> [84951.681013] 
> [84951.681013] cfs_rq[0]:/autogroup-39
> [84951.681015]   .exec_clock                    : 0.000000
> [84951.681016]   .MIN_vruntime                  : 0.000001
> [84951.681018]   .min_vruntime                  : 4931529.000259
> [84951.681020]   .max_vruntime                  : 0.000001
> [84951.681021]   .spread                        : 0.000000
> [84951.681023]   .spread0                       : -47423870.569551
> [84951.681025]   .nr_spread_over                : 0
> [84951.681026]   .nr_running                    : 0
> [84951.681028]   .load                          : 0
> [84951.681029]   .load_avg                      : 4701.742763
> [84951.681031]   .load_period                   : 9.302606
> [84951.681032]   .load_contrib                  : 505
> [84951.681034]   .load_tg                       : 1033
> [84951.681036]   .se->exec_start                : 84951675.470082
> [84951.681037]   .se->vruntime                  : 52355399.569810
> [84951.681039]   .se->sum_exec_runtime          : 4256492.512746
> [84951.681041]   .se->load.weight               : 2
> [84951.681043] 
> [84951.681043] cfs_rq[0]:/autogroup-84
> [84951.681045]   .exec_clock                    : 0.000000
> [84951.681047]   .MIN_vruntime                  : 12773469.982548
> [84951.681048]   .min_vruntime                  : 12773475.929218
> [84951.681050]   .max_vruntime                  : 12773475.929218
> [84951.681052]   .spread                        : 5.946670
> [84951.681053]   .spread0                       : -39581923.640592
> [84951.681055]   .nr_spread_over                : 0
> [84951.681056]   .nr_running                    : 3
> [84951.681058]   .load                          : 1578
> [84951.681059]   .load_avg                      : 2389.940390
> [84951.681061]   .load_period                   : 6.650024
> [84951.681063]   .load_contrib                  : 289
> [84951.681064]   .load_tg                       : 310
> [84951.681066]   .se->exec_start                : 84951679.104864
> [84951.681068]   .se->vruntime                  : 52355396.091688
> [84951.681069]   .se->sum_exec_runtime          : 11567512.453793
> [84951.681071]   .se->load.weight               : 1010
> [84951.681073] 
> [84951.681073] cfs_rq[0]:/
> [84951.681075]   .exec_clock                    : 0.000000
> [84951.681076]   .MIN_vruntime                  : 52355393.569810
> [84951.681078]   .min_vruntime                  : 52355399.569810
> [84951.681080]   .max_vruntime                  : 52355393.569810
> [84951.681082]   .spread                        : 0.000000
> [84951.681083]   .spread0                       : 0.000000
> [84951.681085]   .nr_spread_over                : 0
> [84951.681086]   .nr_running                    : 2
> [84951.681087]   .load                          : 1542
> [84951.681089]   .load_avg                      : 0.000000
> [84951.681091]   .load_period                   : 0.000000
> [84951.681092]   .load_contrib                  : 0
> [84951.681093]   .load_tg                       : 0
> [84951.681095] 
> [84951.681095] rt_rq[0]:
> [84951.681097]   .rt_nr_running                 : 0
> [84951.681098]   .rt_throttled                  : 0
> [84951.681099]   .rt_time                       : 0.000000
> [84951.681101]   .rt_runtime                    : 950.000000
> [84951.681103] 
> [84951.681104] runnable tasks:
> [84951.681104]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [84951.681105] ----------------------------------------------------------------------------------------------------------
> [84951.681119] R         chrome  6859  12773469.929218  31318750   123               0               0               0.000000               0.000000               0.000000 /autogroup-84
> [84951.681129]           chrome  7268  12773475.929218  72627834   123               0               0               0.000000               0.000000               0.000000 /autogroup-84
> [84951.681135]  Chrome_ChildIOT  7270  12773469.982548  20491354   123               0               0               0.000000               0.000000               0.000000 /autogroup-84
> [84951.681143]  chromium-browse 28255   1323610.934982   2145602   120               0               0               0.000000               0.000000               0.000000 /autogroup-74
> [84951.681152] 
> [84951.681153] cpu#1, 2527.110 MHz
> [84951.681154]   .nr_running                    : 1
> [84951.681156]   .load                          : 1024
> [84951.681157]   .nr_switches                   : 193625464
> [84951.681159]   .nr_load_updates               : 19156541
> [84951.681160]   .nr_uninterruptible            : 7826
> [84951.681162]   .next_balance                  : 4316.130228
> [84951.681163]   .curr->pid                     : 5589
> [84951.681165]   .clock                         : 84951680.008137
> [84951.681167]   .cpu_load[0]                   : 1024
> [84951.681168]   .cpu_load[1]                   : 1024
> [84951.681169]   .cpu_load[2]                   : 1024
> [84951.681171]   .cpu_load[3]                   : 1024
> [84951.681172]   .cpu_load[4]                   : 1029
> [84951.681174] 
> [84951.681175] cfs_rq[1]:/autogroup-74
> [84951.681176]   .exec_clock                    : 0.000000
> [84951.681178]   .MIN_vruntime                  : 0.000001
> [84951.681179]   .min_vruntime                  : 1424197.278711
> [84951.681181]   .max_vruntime                  : 0.000001
> [84951.681183]   .spread                        : 0.000000
> [84951.681184]   .spread0                       : -50931202.291099
> [84951.681186]   .nr_spread_over                : 0
> [84951.681187]   .nr_running                    : 0
> [84951.681189]   .load                          : 0
> [84951.681190]   .load_avg                      : 5245.213184
> [84951.681192]   .load_period                   : 5.523241
> [84951.681194]   .load_contrib                  : 947
> [84951.681195]   .load_tg                       : 991
> [84951.681197]   .se->exec_start                : 84951600.488928
> [84951.681199]   .se->vruntime                  : 71918776.133351
> [84951.681201]   .se->sum_exec_runtime          : 2565479.414558
> [84951.681202]   .se->load.weight               : 2
> [84951.681204] 
> [84951.681205] cfs_rq[1]:/autogroup-20
> [84951.681206]   .exec_clock                    : 0.000000
> [84951.681208]   .MIN_vruntime                  : 0.000001
> [84951.681210]   .min_vruntime                  : 16579.934530
> [84951.681211]   .max_vruntime                  : 0.000001
> [84951.681213]   .spread                        : 0.000000
> [84951.681214]   .spread0                       : -52338819.635280
> [84951.681216]   .nr_spread_over                : 0
> [84951.681217]   .nr_running                    : 0
> [84951.681219]   .load                          : 0
> [84951.681220]   .load_avg                      : 440.283872
> [84951.681222]   .load_period                   : 6.022332
> [84951.681224]   .load_contrib                  : 59
> [84951.681225]   .load_tg                       : 257
> [84951.681227]   .se->exec_start                : 84951604.151757
> [84951.681229]   .se->vruntime                  : 71918779.019518
> [84951.681230]   .se->sum_exec_runtime          : 16600.817243
> [84951.681232]   .se->load.weight               : 2
> [84951.681234] 
> [84951.681234] cfs_rq[1]:/autogroup-39
> [84951.681236]   .exec_clock                    : 0.000000
> [84951.681238]   .MIN_vruntime                  : 0.000001
> [84951.681239]   .min_vruntime                  : 4238682.043047
> [84951.681241]   .max_vruntime                  : 0.000001
> [84951.681242]   .spread                        : 0.000000
> [84951.681244]   .spread0                       : -48116717.526763
> [84951.681246]   .nr_spread_over                : 0
> [84951.681247]   .nr_running                    : 0
> [84951.681248]   .load                          : 0
> [84951.681250]   .load_avg                      : 5176.058368
> [84951.681252]   .load_period                   : 9.746619
> [84951.681253]   .load_contrib                  : 528
> [84951.681255]   .load_tg                       : 1033
> [84951.681257]   .se->exec_start                : 84951600.594975
> [84951.681258]   .se->vruntime                  : 71918775.930447
> [84951.681260]   .se->sum_exec_runtime          : 4311876.124090
> [84951.681262]   .se->load.weight               : 2
> [84951.681264] 
> [84951.681264] cfs_rq[1]:/autogroup-84
> [84951.681266]   .exec_clock                    : 0.000000
> [84951.681267]   .MIN_vruntime                  : 0.000001
> [84951.681269]   .min_vruntime                  : 7070943.272798
> [84951.681271]   .max_vruntime                  : 0.000001
> [84951.681272]   .spread                        : 0.000000
> [84951.681274]   .spread0                       : -45284456.297012
> [84951.681275]   .nr_spread_over                : 0
> [84951.681277]   .nr_running                    : 0
> [84951.681278]   .load                          : 0
> [84951.681280]   .load_avg                      : 5259.999474
> [84951.681281]   .load_period                   : 9.999999
> [84951.681283]   .load_contrib                  : 21
> [84951.681284]   .load_tg                       : 310
> [84951.681286]   .se->exec_start                : 84951649.364685
> [84951.681288]   .se->vruntime                  : 71918824.034522
> [84951.681290]   .se->sum_exec_runtime          : 6502960.496865
> [84951.681292]   .se->load.weight               : 2
> [84951.681293] 
> [84951.681294] cfs_rq[1]:/autogroup-28
> [84951.681295]   .exec_clock                    : 0.000000
> [84951.681297]   .MIN_vruntime                  : 0.000001
> [84951.681299]   .min_vruntime                  : 1961436.099473
> [84951.681301]   .max_vruntime                  : 0.000001
> [84951.681302]   .spread                        : 0.000000
> [84951.681304]   .spread0                       : -50393963.470337
> [84951.681305]   .nr_spread_over                : 0
> [84951.681307]   .nr_running                    : 0
> [84951.681308]   .load                          : 0
> [84951.681310]   .load_avg                      : 5174.934016
> [84951.681311]   .load_period                   : 5.101167
> [84951.681313]   .load_contrib                  : 1014
> [84951.681314]   .load_tg                       : 1169
> [84951.681316]   .se->exec_start                : 84951649.415319
> [84951.681318]   .se->vruntime                  : 71918824.084299
> [84951.681320]   .se->sum_exec_runtime          : 1961721.167843
> [84951.681321]   .se->load.weight               : 2
> [84951.681323] 
> [84951.681323] cfs_rq[1]:/
> [84951.681325]   .exec_clock                    : 0.000000
> [84951.681326]   .MIN_vruntime                  : 0.000001
> [84951.681328]   .min_vruntime                  : 71918860.488271
> [84951.681330]   .max_vruntime                  : 0.000001
> [84951.681331]   .spread                        : 0.000000
> [84951.681333]   .spread0                       : 19563460.918461
> [84951.681334]   .nr_spread_over                : 0
> [84951.681336]   .nr_running                    : 1
> [84951.681337]   .load                          : 1024
> [84951.681339]   .load_avg                      : 0.000000
> [84951.681340]   .load_period                   : 0.000000
> [84951.681342]   .load_contrib                  : 0
> [84951.681343]   .load_tg                       : 0
> [84951.681345] 
> [84951.681345] rt_rq[1]:
> [84951.681346]   .rt_nr_running                 : 0
> [84951.681348]   .rt_throttled                  : 0
> [84951.681349]   .rt_time                       : 0.000000
> [84951.681351]   .rt_runtime                    : 950.000000
> [84951.681353] 
> [84951.681353] runnable tasks:
> [84951.681354]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [84951.681355] ----------------------------------------------------------------------------------------------------------
> [84951.681370] Rbtrfs-delalloc-  5589  71918860.488271    173262   120               0               0               0.000000               0.000000               0.000000 /



> [84959.028005] Sched Debug Version: v0.10, 3.4.4-amd64-preempt-noide-20120410 #1
> [84959.028005] ktime                                   : 84959073.124471
> [84959.028005] sched_clk                               : 55828156.022356
> [84959.028005] cpu_clk                                 : 84959028.005869
> [84959.028005] jiffies                                 : 4316132062
> [84959.028005] sched_clock_stable                      : 0
> [84959.028005] 
> [84959.028005] sysctl_sched
> [84959.028005]   .sysctl_sched_latency                    : 12.000000
> [84959.028005]   .sysctl_sched_min_granularity            : 1.500000
> [84959.028005]   .sysctl_sched_wakeup_granularity         : 2.000000
> [84959.028005]   .sysctl_sched_child_runs_first           : 0
> [84959.028005]   .sysctl_sched_features                   : 24119
> [84959.028005]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [84959.028005] 
> [84959.028005] cpu#0, 2527.110 MHz
> [84959.028005]   .nr_running                    : 1
> [84959.028005]   .load                          : 1024
> [84959.028005]   .nr_switches                   : 298019849
> [84959.028005]   .nr_load_updates               : 16860702
> [84959.028005]   .nr_uninterruptible            : -7812
> [84959.028005]   .next_balance                  : 4316.132064
> [84959.028005]   .curr->pid                     : 5589
> [84959.028005]   .clock                         : 84959024.005728
> [84959.028005]   .cpu_load[0]                   : 1024
> [84959.028005]   .cpu_load[1]                   : 1024
> [84959.028005]   .cpu_load[2]                   : 1024
> [84959.028005]   .cpu_load[3]                   : 1024
> [84959.028005]   .cpu_load[4]                   : 1024
> [84959.028005] 
> [84959.028005] cfs_rq[0]:/
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 52362263.842363
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : 0.000000
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 1
> [84959.028005]   .load                          : 1024
> [84959.028005]   .load_avg                      : 0.000000
> [84959.028005]   .load_period                   : 0.000000
> [84959.028005]   .load_contrib                  : 0
> [84959.028005]   .load_tg                       : 0
> [84959.028005] 
> [84959.028005] rt_rq[0]:
> [84959.028005]   .rt_nr_running                 : 0
> [84959.028005]   .rt_throttled                  : 0
> [84959.028005]   .rt_time                       : 0.000000
> [84959.028005]   .rt_runtime                    : 950.000000
> [84959.028005] 
> [84959.028005] runnable tasks:
> [84959.028005]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [84959.028005] ----------------------------------------------------------------------------------------------------------
> [84959.028005] Rbtrfs-delalloc-  5589  52362263.842363    173591   120               0               0               0.000000               0.000000               0.000000 /
> [84959.028005] 
> [84959.028005] cpu#1, 2527.110 MHz
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .nr_switches                   : 193660011
> [84959.028005]   .nr_load_updates               : 19157733
> [84959.028005]   .nr_uninterruptible            : 7826
> [84959.028005]   .next_balance                  : 4316.132092
> [84959.028005]   .curr->pid                     : 0
> [84959.028005]   .clock                         : 84959064.238592
> [84959.028005]   .cpu_load[0]                   : 4096
> [84959.028005]   .cpu_load[1]                   : 2072
> [84959.028005]   .cpu_load[2]                   : 1194
> [84959.028005]   .cpu_load[3]                   : 869
> [84959.028005]   .cpu_load[4]                   : 762
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-69
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 223361.691158
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -52138902.151205
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 2590.643456
> [84959.028005]   .load_period                   : 6.494722
> [84959.028005]   .load_contrib                  : 398
> [84959.028005]   .load_tg                       : 398
> [84959.028005]   .se->exec_start                : 84959056.335435
> [84959.028005]   .se->vruntime                  : 71921556.083864
> [84959.028005]   .se->sum_exec_runtime          : 271360.995455
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-20
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 16585.443509
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -52345678.398854
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 347.126752
> [84959.028005]   .load_period                   : 6.020438
> [84959.028005]   .load_contrib                  : 57
> [84959.028005]   .load_tg                       : 57
> [84959.028005]   .se->exec_start                : 84959060.122289
> [84959.028005]   .se->vruntime                  : 71921556.040907
> [84959.028005]   .se->sum_exec_runtime          : 16606.326222
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-84
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 7072493.859899
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -45289769.982464
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 6650.423655
> [84959.028005]   .load_period                   : 8.469275
> [84959.028005]   .load_contrib                  : 785
> [84959.028005]   .load_tg                       : 785
> [84959.028005]   .se->exec_start                : 84959064.185687
> [84959.028005]   .se->vruntime                  : 71921564.865429
> [84959.028005]   .se->sum_exec_runtime          : 6504348.221165
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-28
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 1961906.582524
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -50400357.259839
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 994.827639
> [84959.028005]   .load_period                   : 7.072831
> [84959.028005]   .load_contrib                  : 140
> [84959.028005]   .load_tg                       : 140
> [84959.028005]   .se->exec_start                : 84959064.180949
> [84959.028005]   .se->vruntime                  : 71921559.003595
> [84959.028005]   .se->sum_exec_runtime          : 1962191.771814
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-39
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 4239411.104825
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -48122852.737538
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 7224.556007
> [84959.028005]   .load_period                   : 8.698458
> [84959.028005]   .load_contrib                  : 830
> [84959.028005]   .load_tg                       : 830
> [84959.028005]   .se->exec_start                : 84959060.995273
> [84959.028005]   .se->vruntime                  : 71921558.657276
> [84959.028005]   .se->sum_exec_runtime          : 4312867.647890
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/autogroup-74
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 1424529.029769
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : -50937734.812594
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 6439.299117
> [84959.028005]   .load_period                   : 8.633038
> [84959.028005]   .load_contrib                  : 745
> [84959.028005]   .load_tg                       : 745
> [84959.028005]   .se->exec_start                : 84959061.053899
> [84959.028005]   .se->vruntime                  : 71921559.096778
> [84959.028005]   .se->sum_exec_runtime          : 2566083.226405
> [84959.028005]   .se->load.weight               : 2
> [84959.028005] 
> [84959.028005] cfs_rq[1]:/
> [84959.028005]   .exec_clock                    : 0.000000
> [84959.028005]   .MIN_vruntime                  : 0.000001
> [84959.028005]   .min_vruntime                  : 71921564.865429
> [84959.028005]   .max_vruntime                  : 0.000001
> [84959.028005]   .spread                        : 0.000000
> [84959.028005]   .spread0                       : 19559301.023066
> [84959.028005]   .nr_spread_over                : 0
> [84959.028005]   .nr_running                    : 0
> [84959.028005]   .load                          : 0
> [84959.028005]   .load_avg                      : 0.000000
> [84959.028005]   .load_period                   : 0.000000
> [84959.028005]   .load_contrib                  : 0
> [84959.028005]   .load_tg                       : 0
> [84959.028005] 
> [84959.028005] rt_rq[1]:
> [84959.028005]   .rt_nr_running                 : 0
> [84959.028005]   .rt_throttled                  : 0
> [84959.028005]   .rt_time                       : 0.000000
> [84959.028005]   .rt_runtime                    : 950.000000
> [84959.028005] 
> [84959.028005] runnable tasks:
> [84959.028005]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> [84959.028005] ----------------------------------------------------------------------------------------------------------
> [84959.028005] 
> [84960.376059] INFO: task flush-btrfs-1:399 blocked for more than 120 seconds.



> [85748.849847] BTRFS warning (device dm-0): Aborting unused transaction.
> [85754.690251] BTRFS warning (device dm-0): Aborting unused transaction.
> [85754.787953] BTRFS warning (device dm-0): Aborting unused transaction.
> [85754.871973] BTRFS warning (device dm-0): Aborting unused transaction.
> [85754.971097] BTRFS warning (device dm-0): Aborting unused transaction.
> [85755.242875] BTRFS warning (device dm-0): Aborting unused transaction.
> [85755.522664] BTRFS warning (device dm-0): Aborting unused transaction.
> [85755.670110] BTRFS warning (device dm-0): Aborting unused transaction.
> [85755.811342] BTRFS warning (device dm-0): Aborting unused transaction.
> [85755.971524] BTRFS warning (device dm-0): Aborting unused transaction.
> [85756.175633] BTRFS warning (device dm-0): Aborting unused transaction.
> [85756.329593] BTRFS warning (device dm-0): Aborting unused transaction.
> [85757.064995] BTRFS warning (device dm-0): Aborting unused transaction.
> [85757.210976] BTRFS warning (device dm-0): Aborting unused transaction.
> [85758.058191] BTRFS warning (device dm-0): Aborting unused transaction.
> [85758.454009] BTRFS warning (device dm-0): Aborting unused transaction.
> [85758.742629] BTRFS warning (device dm-0): Aborting unused transaction.
> [85759.082905] BTRFS warning (device dm-0): Aborting unused transaction.
> [85760.355436] BTRFS warning (device dm-0): Aborting unused transaction.
> [85760.795476] BTRFS warning (device dm-0): Aborting unused transaction.
> [85760.921292] BTRFS warning (device dm-0): Aborting unused transaction.
> [85761.041269] BTRFS warning (device dm-0): Aborting unused transaction.
> [85761.160903] BTRFS warning (device dm-0): Aborting unused transaction.
> [85761.265970] BTRFS warning (device dm-0): Aborting unused transaction.
> [85761.376858] BTRFS warning (device dm-0): Aborting unused transaction.
> [85762.271769] BTRFS warning (device dm-0): Aborting unused transaction.
> [85762.888725] BTRFS warning (device dm-0): Aborting unused transaction.


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
