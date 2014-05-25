Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.bluemoose.org.uk ([217.169.27.91]:40464 "EHLO
	mail.bluemoose.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEYLuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 May 2014 07:50:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.bluemoose.org.uk (Postfix) with ESMTP id 585A758135
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 12:42:40 +0100 (BST)
Received: from mail.bluemoose.org.uk ([127.0.0.1])
	by localhost (mailtest.bluemoose.org.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HKxfyXC_VuHr for <linux-btrfs@vger.kernel.org>;
	Sun, 25 May 2014 12:42:32 +0100 (BST)
Received: from zebedee (f.6.6.f.6.f.f.2.0.7.3.8.3.a.1.b.b.5.2.3.c.4.b.f.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:fb4c:325b:b1a3:8370:2ff6:f66f])
	(Authenticated sender: kim@bluemoose.org.uk)
	by mail.bluemoose.org.uk (Postfix) with ESMTPSA id 1C0145804F
	for <linux-btrfs@vger.kernel.org>; Sun, 25 May 2014 12:42:32 +0100 (BST)
From: <kim-btrfs@bluemoose.org.uk>
To: <linux-btrfs@vger.kernel.org>
References: <019301cf4da9$bf837930$3e8a6b90$@bluemoose.org.uk> <pan$1bfd3$d8184f3c$26ab13aa$2e81c88f@cox.net>
In-Reply-To: <pan$1bfd3$d8184f3c$26ab13aa$2e81c88f@cox.net>
Subject: RE: BTRFS hangs - possibly NFS related?
Date: Sun, 25 May 2014 12:42:32 +0100
Message-ID: <058b01cf780e$6ae065c0$40a13140$@bluemoose.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's been a while, I'm afraid other things took over, but I've finally got back to it.  
Definitely repeatable problem , and possibly not NFS

Symptoms - when under significant disk load (this was re-muxing a load of video) anything trying to access the btrfs array locks up (local processes and via samba).    Other processes run, but anything accessing the disk stops.      Previously the heavy access was over NFS.  This is now from a local process (actually a VM, but running locally) - that may take one thing out of the list.

A "sync" will fix it immediately - everything springs back to life, otherwise it runs until the 120s timeout.

System as before - but now 5 disks, RAID1 for data and metadata.     I think the question of fragmentation is sorted -  the VM images are now in NOCOW files and a daily check of fragmentation shows them in the tens to hundreds of fragments and not growing.

I did manage to catch it in the act and did the standard:
	echo 1 > /proc/sys/kernel/sysrq
	echo w > /proc/sysrq-trigger
	dmesg

Result below.

I'm currently keeping it going with the band-aid of putting a " btrfs filesystem sync" in the crontab at 1 minute intervals.   Works apparently fine, but not ideal...!

Any ideas of what I can do to help debug it...?

Cheers
Kim



####################################################
May 25 12:19:45 neo kernel: [909247.414599] SysRq : Show Blocked State
May 25 12:19:45 neo kernel: [909247.414634]   task                        PC stack   pid father
May 25 12:19:45 neo kernel: [909247.414640] kswapd0         D ffff880291ddf350     0    26      2 0x00000000
May 25 12:19:45 neo kernel: [909247.414644]  ffff880291ddf010 0000000000000046 0000000000014280 0000000000014280
May 25 12:19:45 neo kernel: [909247.414647]  ffff88029154bfd8 ffff880291ddf010 ffffffff819edc40 ffff88029154bb08
May 25 12:19:45 neo kernel: [909247.414650]  ffff88029154ba80 000000010d8cf042 ffffffff819edc40 000000000000e118
May 25 12:19:45 neo kernel: [909247.414653] Call Trace:
May 25 12:19:45 neo kernel: [909247.414661]  [<ffffffff814a348d>] ? schedule_timeout+0x16d/0x2c0
May 25 12:19:45 neo kernel: [909247.414665]  [<ffffffff81066cc0>] ? ftrace_raw_output_tick_stop+0x60/0x60
May 25 12:19:45 neo kernel: [909247.414669]  [<ffffffff814a473f>] ? io_schedule_timeout+0x8f/0xe0
May 25 12:19:45 neo kernel: [909247.414672]  [<ffffffff81133399>] ? congestion_wait+0x69/0xf0
May 25 12:19:45 neo kernel: [909247.414676]  [<ffffffff81096f50>] ? prepare_to_wait_event+0xf0/0xf0
May 25 12:19:45 neo kernel: [909247.414680]  [<ffffffff81128b06>] ? shrink_inactive_list+0x456/0x4e0
May 25 12:19:45 neo kernel: [909247.414683]  [<ffffffff811291f9>] ? shrink_lruvec+0x2e9/0x600
May 25 12:19:45 neo kernel: [909247.414707]  [<ffffffffa0316322>] ? ext4_es_scan+0xa2/0x100 [ext4]
May 25 12:19:45 neo kernel: [909247.414716]  [<ffffffffa0316322>] ? ext4_es_scan+0xa2/0x100 [ext4]
May 25 12:19:45 neo kernel: [909247.414719]  [<ffffffff8112956e>] ? shrink_zone+0x5e/0x180
May 25 12:19:45 neo kernel: [909247.414722]  [<ffffffff8112a6dc>] ? balance_pgdat+0x37c/0x5b0
May 25 12:19:45 neo kernel: [909247.414725]  [<ffffffff8112aa5f>] ? kswapd+0x14f/0x3e0
May 25 12:19:45 neo kernel: [909247.414728]  [<ffffffff81096f50>] ? prepare_to_wait_event+0xf0/0xf0
May 25 12:19:45 neo kernel: [909247.414731]  [<ffffffff8112a910>] ? balance_pgdat+0x5b0/0x5b0
May 25 12:19:45 neo kernel: [909247.414734]  [<ffffffff8107bb51>] ? kthread+0xc1/0xe0
May 25 12:19:45 neo kernel: [909247.414736]  [<ffffffff8107ba90>] ? kthread_create_on_node+0x180/0x180
May 25 12:19:45 neo kernel: [909247.414739]  [<ffffffff814aeacc>] ? ret_from_fork+0x7c/0xb0
May 25 12:19:45 neo kernel: [909247.414741]  [<ffffffff8107ba90>] ? kthread_create_on_node+0x180/0x180
May 25 12:19:45 neo kernel: [909247.414788] smbd            D ffff880291137b40     0 20527  32222 0x00000000
May 25 12:19:45 neo kernel: [909247.414791]  ffff880291137800 0000000000000082 0000000000014280 0000000000014280
May 25 12:19:45 neo kernel: [909247.414794]  ffff8801172c1fd8 ffff880291137800 ffffffff819edc40 ffff8801172c1770
May 25 12:19:45 neo kernel: [909247.414796]  ffff8801172c16e0 000000010d8cf02c ffffffff819edc40 000000000000e118
May 25 12:19:45 neo kernel: [909247.414798] Call Trace:
May 25 12:19:45 neo kernel: [909247.414801]  [<ffffffff814a348d>] ? schedule_timeout+0x16d/0x2c0
May 25 12:19:45 neo kernel: [909247.414804]  [<ffffffff81066cc0>] ? ftrace_raw_output_tick_stop+0x60/0x60
May 25 12:19:45 neo kernel: [909247.414807]  [<ffffffff814a473f>] ? io_schedule_timeout+0x8f/0xe0
May 25 12:19:45 neo kernel: [909247.414809]  [<ffffffff81133399>] ? congestion_wait+0x69/0xf0
May 25 12:19:45 neo kernel: [909247.414812]  [<ffffffff81096f50>] ? prepare_to_wait_event+0xf0/0xf0
May 25 12:19:45 neo kernel: [909247.414815]  [<ffffffff81128b06>] ? shrink_inactive_list+0x456/0x4e0
May 25 12:19:45 neo kernel: [909247.414818]  [<ffffffff811291f9>] ? shrink_lruvec+0x2e9/0x600
May 25 12:19:45 neo kernel: [909247.414821]  [<ffffffff81086e65>] ? check_preempt_curr+0x75/0x90
May 25 12:19:45 neo kernel: [909247.414824]  [<ffffffff8112956e>] ? shrink_zone+0x5e/0x180
May 25 12:19:45 neo kernel: [909247.414827]  [<ffffffff81129a30>] ? do_try_to_free_pages+0xe0/0x550
May 25 12:19:45 neo kernel: [909247.414830]  [<ffffffff81129f88>] ? try_to_free_pages+0xe8/0x170
May 25 12:19:45 neo kernel: [909247.414833]  [<ffffffff8111f4a4>] ? __alloc_pages_nodemask+0x684/0x9d0
May 25 12:19:45 neo kernel: [909247.414837]  [<ffffffff81159a37>] ? alloc_pages_current+0x97/0x150
May 25 12:19:45 neo kernel: [909247.414841]  [<ffffffff813ab16e>] ? skb_page_frag_refill+0x5e/0xb0
May 25 12:19:45 neo kernel: [909247.414844]  [<ffffffff813abbf4>] ? sk_page_frag_refill+0x14/0x70
May 25 12:19:45 neo kernel: [909247.414847]  [<ffffffff813ffd7d>] ? tcp_sendmsg+0x29d/0xdd0
May 25 12:19:45 neo kernel: [909247.414850]  [<ffffffff813a72c6>] ? sock_aio_write+0xf6/0x120
May 25 12:19:45 neo kernel: [909247.414854]  [<ffffffff81192779>] ? touch_atime+0x69/0x140
May 25 12:19:45 neo kernel: [909247.414857]  [<ffffffff81179183>] ? do_sync_readv_writev+0x43/0x70
May 25 12:19:45 neo kernel: [909247.414860]  [<ffffffff8117a57b>] ? do_readv_writev+0xab/0x210
May 25 12:19:45 neo kernel: [909247.414863]  [<ffffffff811796e5>] ? vfs_read+0xe5/0x160
May 25 12:19:45 neo kernel: [909247.414866]  [<ffffffff8117a887>] ? SyS_writev+0x47/0xc0
May 25 12:19:45 neo kernel: [909247.414869]  [<ffffffff814aeb79>] ? system_call_fastpath+0x16/0x1b
May 25 12:19:45 neo kernel: [909247.414874] ShFolders       D ffff880120529b40     0 20603  29582 0x00000000
May 25 12:19:45 neo kernel: [909247.414876]  ffff880120529800 0000000000000082 0000000000014280 0000000000014280
May 25 12:19:45 neo kernel: [909247.414879]  ffff88001025bfd8 ffff880120529800 ffffffff819edc40 ffff88001025b7a8
May 25 12:19:45 neo kernel: [909247.414881]  ffff88001025b720 000000010d8cf042 ffffffff819edc40 000000000000e118
May 25 12:19:45 neo kernel: [909247.414883] Call Trace:
May 25 12:19:45 neo kernel: [909247.414886]  [<ffffffff814a348d>] ? schedule_timeout+0x16d/0x2c0
May 25 12:19:45 neo kernel: [909247.414888]  [<ffffffff81066cc0>] ? ftrace_raw_output_tick_stop+0x60/0x60
May 25 12:19:45 neo kernel: [909247.414891]  [<ffffffff814a473f>] ? io_schedule_timeout+0x8f/0xe0
May 25 12:19:45 neo kernel: [909247.414894]  [<ffffffff81133399>] ? congestion_wait+0x69/0xf0
May 25 12:19:45 neo kernel: [909247.414896]  [<ffffffff81096f50>] ? prepare_to_wait_event+0xf0/0xf0
May 25 12:19:45 neo kernel: [909247.414899]  [<ffffffff81128b06>] ? shrink_inactive_list+0x456/0x4e0
May 25 12:19:45 neo kernel: [909247.414902]  [<ffffffff811291f9>] ? shrink_lruvec+0x2e9/0x600
May 25 12:19:45 neo kernel: [909247.414905]  [<ffffffff8112956e>] ? shrink_zone+0x5e/0x180
May 25 12:19:45 neo kernel: [909247.414908]  [<ffffffff81129a30>] ? do_try_to_free_pages+0xe0/0x550
May 25 12:19:45 neo kernel: [909247.414911]  [<ffffffff81129f88>] ? try_to_free_pages+0xe8/0x170
May 25 12:19:45 neo kernel: [909247.414913]  [<ffffffff8111f4a4>] ? __alloc_pages_nodemask+0x684/0x9d0
May 25 12:19:45 neo kernel: [909247.414917]  [<ffffffff81159a37>] ? alloc_pages_current+0x97/0x150
May 25 12:19:45 neo kernel: [909247.414920]  [<ffffffff81116bd5>] ? find_or_create_page+0x35/0x90
May 25 12:19:45 neo kernel: [909247.414938]  [<ffffffffa02208f8>] ? prepare_pages.isra.17+0x198/0x350 [btrfs]
May 25 12:19:45 neo kernel: [909247.414950]  [<ffffffffa022163a>] ? __btrfs_buffered_write+0x29a/0x4d0 [btrfs]
May 25 12:19:45 neo kernel: [909247.414962]  [<ffffffffa0221a85>] ? btrfs_file_aio_write+0x215/0x520 [btrfs]
May 25 12:19:45 neo kernel: [909247.414965]  [<ffffffff81118808>] ? generic_file_aio_read+0x588/0x6e0
May 25 12:19:45 neo kernel: [909247.414968]  [<ffffffff81179107>] ? do_sync_write+0x57/0x90
May 25 12:19:45 neo kernel: [909247.414971]  [<ffffffff8117980a>] ? vfs_write+0xaa/0x1e0
May 25 12:19:45 neo kernel: [909247.414973]  [<ffffffff8117a213>] ? SyS_write+0x43/0xa0
May 25 12:19:45 neo kernel: [909247.414976]  [<ffffffff814aeb79>] ? system_call_fastpath+0x16/0x1b
May 25 12:19:45 neo kernel: [909247.414978] ATA-0           D ffff8801197e1350     0 20605  29582 0x00000000
May 25 12:19:45 neo kernel: [909247.414980]  ffff8801197e1010 0000000000000082 0000000000014280 0000000000014280
May 25 12:19:45 neo kernel: [909247.414983]  ffff8800bd117fd8 ffff8801197e1010 ffff88029458c000 ffff8800bd117828
May 25 12:19:45 neo kernel: [909247.414985]  ffff8800bd1177a0 000000010d8cf042 ffff88029458c000 000000000000e118
May 25 12:19:45 neo kernel: [909247.414987] Call Trace:
May 25 12:19:45 neo kernel: [909247.414990]  [<ffffffff814a348d>] ? schedule_timeout+0x16d/0x2c0
May 25 12:19:45 neo kernel: [909247.414992]  [<ffffffff81066cc0>] ? ftrace_raw_output_tick_stop+0x60/0x60
May 25 12:19:45 neo kernel: [909247.414995]  [<ffffffff814a473f>] ? io_schedule_timeout+0x8f/0xe0
May 25 12:19:45 neo kernel: [909247.414997]  [<ffffffff81133399>] ? congestion_wait+0x69/0xf0
May 25 12:19:45 neo kernel: [909247.415000]  [<ffffffff81096f50>] ? prepare_to_wait_event+0xf0/0xf0
May 25 12:19:45 neo kernel: [909247.415003]  [<ffffffff81128b06>] ? shrink_inactive_list+0x456/0x4e0
May 25 12:19:45 neo kernel: [909247.415006]  [<ffffffff811291f9>] ? shrink_lruvec+0x2e9/0x600
May 25 12:19:45 neo kernel: [909247.415009]  [<ffffffff8124fec4>] ? ll_back_merge_fn+0x94/0x1b0
May 25 12:19:45 neo kernel: [909247.415013]  [<ffffffff8117bc90>] ? put_super+0x10/0x30
May 25 12:19:45 neo kernel: [909247.415015]  [<ffffffff8117bc90>] ? put_super+0x10/0x30
May 25 12:19:45 neo kernel: [909247.415018]  [<ffffffff8112956e>] ? shrink_zone+0x5e/0x180
May 25 12:19:45 neo kernel: [909247.415021]  [<ffffffff81129a30>] ? do_try_to_free_pages+0xe0/0x550
May 25 12:19:45 neo kernel: [909247.415024]  [<ffffffff81129f88>] ? try_to_free_pages+0xe8/0x170
May 25 12:19:45 neo kernel: [909247.415027]  [<ffffffff8111f4a4>] ? __alloc_pages_nodemask+0x684/0x9d0
May 25 12:19:45 neo kernel: [909247.415030]  [<ffffffff81159a37>] ? alloc_pages_current+0x97/0x150
May 25 12:19:45 neo kernel: [909247.415033]  [<ffffffff81121ebd>] ? __do_page_cache_readahead+0xcd/0x240
May 25 12:19:45 neo kernel: [909247.415036]  [<ffffffff8112243a>] ? ondemand_readahead+0x14a/0x280
May 25 12:19:45 neo kernel: [909247.415038]  [<ffffffff811186d9>] ? generic_file_aio_read+0x459/0x6e0
May 25 12:19:45 neo kernel: [909247.415041]  [<ffffffff81179077>] ? do_sync_read+0x57/0x90
May 25 12:19:45 neo kernel: [909247.415044]  [<ffffffff8117968b>] ? vfs_read+0x8b/0x160
May 25 12:19:45 neo kernel: [909247.415046]  [<ffffffff8117a173>] ? SyS_read+0x43/0xa0
May 25 12:19:45 neo kernel: [909247.415049]  [<ffffffff814aeb79>] ? system_call_fastpath+0x16/0x1b
May 25 12:19:45 neo kernel: [909247.415056] Sched Debug Version: v0.11, 3.13-1-amd64 #1
May 25 12:19:45 neo kernel: [909247.415058] ktime                                   : 909661319.717192
May 25 12:19:45 neo kernel: [909247.415060] sched_clk                               : 909247415.055227
May 25 12:19:45 neo kernel: [909247.415062] cpu_clk                                 : 909247415.055288
May 25 12:19:45 neo kernel: [909247.415063] jiffies                                 : 4522307625
May 25 12:19:45 neo kernel: [909247.415064] sched_clock_stable                      : 1
May 25 12:19:45 neo kernel: [909247.415065] 
May 25 12:19:45 neo kernel: [909247.415066] sysctl_sched
May 25 12:19:45 neo kernel: [909247.415068]   .sysctl_sched_latency                    : 12.000000
May 25 12:19:45 neo kernel: [909247.415069]   .sysctl_sched_min_granularity            : 1.500000
May 25 12:19:45 neo kernel: [909247.415071]   .sysctl_sched_wakeup_granularity         : 2.000000
May 25 12:19:45 neo kernel: [909247.415072]   .sysctl_sched_child_runs_first           : 0
May 25 12:19:45 neo kernel: [909247.415073]   .sysctl_sched_features                   : 77435
May 25 12:19:45 neo kernel: [909247.415075]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
May 25 12:19:45 neo kernel: [909247.415076] 
May 25 12:19:45 neo kernel: [909247.415078] cpu#0, 2196.379 MHz
May 25 12:19:45 neo kernel: [909247.415079]   .nr_running                    : 5
May 25 12:19:45 neo kernel: [909247.415080]   .load                          : 2188
May 25 12:19:45 neo kernel: [909247.415081]   .nr_switches                   : 1703105187
May 25 12:19:45 neo kernel: [909247.415083]   .nr_load_updates               : 225590773
May 25 12:19:45 neo kernel: [909247.415084]   .nr_uninterruptible            : -213229
May 25 12:19:45 neo kernel: [909247.415086]   .next_balance                  : 4522.307627
May 25 12:19:45 neo kernel: [909247.415087]   .curr->pid                     : 21436
May 25 12:19:45 neo kernel: [909247.415088]   .clock                         : 909247413.555303
May 25 12:19:45 neo kernel: [909247.415090]   .cpu_load[0]                   : 28
May 25 12:19:45 neo kernel: [909247.415091]   .cpu_load[1]                   : 137
May 25 12:19:45 neo kernel: [909247.415092]   .cpu_load[2]                   : 141
May 25 12:19:45 neo kernel: [909247.415093]   .cpu_load[3]                   : 147
May 25 12:19:45 neo kernel: [909247.415094]   .cpu_load[4]                   : 149
May 25 12:19:45 neo kernel: [909247.415097] 
May 25 12:19:45 neo kernel: [909247.415097] cfs_rq[0]:/
May 25 12:19:45 neo kernel: [909247.415099]   .exec_clock                    : 0.000000
May 25 12:19:45 neo kernel: [909247.415101]   .MIN_vruntime                  : 1018252991.955421
May 25 12:19:45 neo kernel: [909247.415102]   .min_vruntime                  : 1018252997.955421
May 25 12:19:45 neo kernel: [909247.415104]   .max_vruntime                  : 1018253019.037601
May 25 12:19:45 neo kernel: [909247.415105]   .spread                        : 27.082180
May 25 12:19:45 neo kernel: [909247.415106]   .spread0                       : 0.000000
May 25 12:19:45 neo kernel: [909247.415108]   .nr_spread_over                : 0
May 25 12:19:45 neo kernel: [909247.415109]   .nr_running                    : 5
May 25 12:19:45 neo kernel: [909247.415110]   .load                          : 2188
May 25 12:19:45 neo kernel: [909247.415111]   .runnable_load_avg             : 357
May 25 12:19:45 neo kernel: [909247.415113]   .blocked_load_avg              : 1585
May 25 12:19:45 neo kernel: [909247.415114]   .tg_load_contrib               : 1964
May 25 12:19:45 neo kernel: [909247.415115]   .tg_runnable_contrib           : 1006
May 25 12:19:45 neo kernel: [909247.415116]   .tg_load_avg                   : 2924
May 25 12:19:45 neo kernel: [909247.415118]   .tg->runnable_avg              : 2024
May 25 12:19:45 neo kernel: [909247.415119]   .avg->runnable_avg_sum         : 46069
May 25 12:19:45 neo kernel: [909247.415121]   .avg->runnable_avg_period      : 46239
May 25 12:19:45 neo kernel: [909247.415122] 
May 25 12:19:45 neo kernel: [909247.415122] rt_rq[0]:
May 25 12:19:45 neo kernel: [909247.415124]   .rt_nr_running                 : 0
May 25 12:19:45 neo kernel: [909247.415125]   .rt_throttled                  : 0
May 25 12:19:45 neo kernel: [909247.415127]   .rt_time                       : 0.000000
May 25 12:19:45 neo kernel: [909247.415128]   .rt_runtime                    : 950.000000
May 25 12:19:45 neo kernel: [909247.415129] 
May 25 12:19:45 neo kernel: [909247.415129] runnable tasks:
May 25 12:19:45 neo kernel: [909247.415129]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
May 25 12:19:45 neo kernel: [909247.415129] ----------------------------------------------------------------------------------------------------------
May 25 12:19:45 neo kernel: [909247.415133]             init     1 1018221277.139894    186604   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415138]         kthreadd     2 1016828210.561187     39032   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415143]      ksoftirqd/0     3 1018233698.317512   2395381   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415147]     kworker/0:0H     5      1658.935610         6   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415150]        rcu_sched     7 1018248909.242474   8492807   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415154]           rcu_bh     8       159.650722         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415158]      migration/0     9         0.000000    433725     0               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415163]       watchdog/0    10         0.000000    227418     0               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415167]        kdevtmpfs    17  44384332.338681       193   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415171]            netns    18       198.003970         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415176]          kswapd0    26 1018252923.579015   3537194   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415180]    fsnotify_mark    29 1005836842.969209       529   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415185]            khubd    79  44383876.086313       278   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415189]          ata_sff    92      1426.380191         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415194]        scsi_eh_5   142      1592.864152         5   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415198]     kworker/0:1H   181 1017964642.132399    411848   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415202]        scsi_eh_7   200      1761.274955         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415206]  ext4-rsv-conver   227      2140.176753         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415210]            udevd   378  44572687.062504       796   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415214]         ttm_swap   616      3311.339644         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415218]  btrfs-genwork-1  1259 1017804158.923196     23054   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415222]  btrfs-delalloc-  1261 1017762913.657522      9099   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415226]    btrfs-fixup-1  1262 1017762596.898438      9207   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415230]      btrfs-rmw-1  1265 1017760942.742345      8911   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415236]    acpi_fakekeyd  2335      9401.002251         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415241]          apcupsd  2525     10126.808388         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415245]          apcupsd  2615     10418.270803         4   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415249]              atd  2534 952368260.800085       254   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415253]      dbus-daemon  2618  44100629.861567        22   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415258]            getty  3143     12694.801990       139   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415262]            getty  3144     12696.384363       136   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415266]            getty  3147     12693.933509       130   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415271]  btrfs-delayed-m 32347 1018134976.420676     34611   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415274]            nfsd4   344  16701979.238007         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415279]  nfsd4_callbacks   345  16701983.251957         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415282]            lockd   346  16701989.685192         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415287]         xfsalloc 22626  44054472.250556         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415292]         php5-fpm 24081 1018251758.103144    247522   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415297]             iprt 26601  44098734.632721         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415301]           nspr-2 26692 1018225817.874069      6688   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415306]           nspr-3 29617 1018225817.878395      6671   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415310]           nspr-4 29618 1018225817.860707      6659   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415314]            CGMgr 26700  44099144.489407         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415318]          TimerLR 26701 1018230418.447207    414519   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415323]      dns-monitor 26703  52144460.811009        38   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415327]          Watcher 26704 1018250540.902936    451525   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415331]     EventHandler 26705 1018171373.324521      9923   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415336]           nspr-2 29486  44141903.475687        48   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415341]              EMT 29507 1018252967.790677 135160653   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415345]      ShClipboard 29508  44141965.308308         4   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415349]   DragAndDropSvc 29509  44141971.799072         4   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415353]     GuestPropSvc 29510  44141978.302741        10   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415356]  GuestControlSvc 29511  44141984.725113         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415360]            Timer 29512 1018252987.207149  22512157   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415364]          PDMNsTx 29513 1018251276.151282   2245575   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415368]             VDMA 29515  44142005.765407         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415372]            ATA-0 29516 1017223138.155216    651147   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415377]      INTNET-XMIT 29519  44142024.910870         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415381]      ACPI Poller 29520 1018248636.198068     11253   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415385]          TimerLR 29492  44141878.254345         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415389]            CGMgr 29493  44141882.605655         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415393]          Watcher 29496 1018238534.785748    449777   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415397]           nspr-2 29532  44144419.252927        40   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415401]          VRDP-IN 29537 1018247856.588885    898638   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415405]         VRDP-OUT 29538 1018252878.803226   5589163   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415409]       remote usb 29539 1018225892.190060    112474   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415413]              EMT 29540 1018252967.530337 134558604   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415418]            Timer 29545 1018252856.567453  22506582   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415421]          PDMNsTx 29546 1018251741.122635   2245536   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415426]            Port0 29549 1018248993.434647   1469622   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415430]            ATA-0 29550 1018148806.011180   1054970   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415433]            ATA-1 29551  44154556.242952         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415437]      INTNET-RECV 29552 1018249504.103762   2694723   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415441]      ACPI Poller 29554 1017977570.165957     11252   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415446]           nspr-2 29588 1018171373.305198      9430   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415450]   VBoxSVCWatcher 29589 1018103960.783797     20688   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415454]   MainHGCMthread 29593 429806294.017191        52   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415457]          VRDP-IN 29594 1018247970.451711    898761   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415461]         VRDP-OUT 29595 1018251196.035389   5575526   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415465]              EMT 29597 1018252949.553480  15909227   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415470]          PDMNsTx 29603 1018251425.951099   2245340   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415474]        AioMgr0-N 29606 1016888497.045578    203416   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415478]            ATA-1 29609  44164857.682626       176   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415482]      ACPI Poller 29612 1017972176.529222     11251   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415486]           nspr-3 29621 1018222708.513853      9367   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415491]        in:imklog 32069 1011054484.146513        34   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415495]         in:imudp 32070  44570206.946514         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415499]      jbd2/sdh1-8 32174 534839679.946261     56646   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415503]             nmbd 32193 1018176735.925512     30221   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415507]             smbd 32267 1018129889.385936   3537883   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415511]          php-cgi   855  61487021.159112        34   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415515]          php-cgi   872 1013305115.220422        34   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415519]   btrfs-submit-2  5659 1017967464.399799     53015   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415523]             smbd 14632 1017957085.831876      1084   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415527]      kworker/0:0 15177 1018252991.955421   2078348   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415531]             smbd 16374 1017646194.835057    195008   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415534]   btrfs-worker-2 18316 1017967464.848661     14242   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415538]      multivid.pl 19354 976189048.384364       160   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415543]      kworker/0:2 20191 884232215.766062         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415546]               sh 20438 976189054.764110         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415550]         kbvid.sh 20439 976189055.617093         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415555]     HandBrakeCLI 20441 1018252526.501440     35233   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415559]     HandBrakeCLI 20445 1018190930.744783      5361   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415563]     HandBrakeCLI 20446 1018190930.828377      5348   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415567]     HandBrakeCLI 20453 1018251075.314066     55103   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415572]     HandBrakeCLI 20460 1018249525.175883     20897   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415576]     HandBrakeCLI 20464 1018249002.405986     57649   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415580]     HandBrakeCLI 20466 1018253019.037601    962629   139               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415584]     HandBrakeCLI 20467 1018253002.496825    961879   139               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415588]     HandBrakeCLI 20468 1018252012.600264    348515   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415593]     HandBrakeCLI 20472 1018252991.955421      8926   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415597]  btrfs-flush_del 20506 1017961458.455369     21665   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415601]     kworker/u8:1 20509 1015445371.296226      3634   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415605]             smbd 20527 1018251331.636643     31802   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415610]          TimerLR 20590 1018235283.613011      3019   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415614]         VRDP-OUT 20594 1018252748.591887     35936   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415618]       remote usb 20595 1018241473.997861       534   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415622]              EMT 20596 1018252872.923479   1237885   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415627]            Timer 20601 1018252760.897459    106652   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415631]          PDMNsTx 20602 1018252424.494870     10649   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415635]        ShFolders 20603 1018252923.561188     65922   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415639]             VDMA 20604 1002827790.331107         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415643]            ATA-1 20606 1018232383.417191      3194   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415647]  btrfs-endio-wri 20662 1017966854.895705      3055   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415652]             bash 21029 1017133575.925076       176   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415656]               su 21435 1017164680.165242        36   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415660] R           bash 21436 1018252992.001665        83   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415664] 
May 25 12:19:45 neo kernel: [909247.415665] cpu#1, 2196.379 MHz
May 25 12:19:45 neo kernel: [909247.415667]   .nr_running                    : 1
May 25 12:19:45 neo kernel: [909247.415668]   .load                          : 15
May 25 12:19:45 neo kernel: [909247.415669]   .nr_switches                   : 1677103648
May 25 12:19:45 neo kernel: [909247.415671]   .nr_load_updates               : 226384226
May 25 12:19:45 neo kernel: [909247.415672]   .nr_uninterruptible            : 213233
May 25 12:19:45 neo kernel: [909247.415673]   .next_balance                  : 4522.307642
May 25 12:19:45 neo kernel: [909247.415675]   .curr->pid                     : 20465
May 25 12:19:45 neo kernel: [909247.415676]   .clock                         : 909247415.350966
May 25 12:19:45 neo kernel: [909247.415677]   .cpu_load[0]                   : 14
May 25 12:19:45 neo kernel: [909247.415678]   .cpu_load[1]                   : 14
May 25 12:19:45 neo kernel: [909247.415679]   .cpu_load[2]                   : 14
May 25 12:19:45 neo kernel: [909247.415681]   .cpu_load[3]                   : 14
May 25 12:19:45 neo kernel: [909247.415682]   .cpu_load[4]                   : 17
May 25 12:19:45 neo kernel: [909247.415683] 
May 25 12:19:45 neo kernel: [909247.415683] cfs_rq[1]:/
May 25 12:19:45 neo kernel: [909247.415685]   .exec_clock                    : 0.000000
May 25 12:19:45 neo kernel: [909247.415686]   .MIN_vruntime                  : 0.000001
May 25 12:19:45 neo kernel: [909247.415688]   .min_vruntime                  : 1021635336.232912
May 25 12:19:45 neo kernel: [909247.415689]   .max_vruntime                  : 0.000001
May 25 12:19:45 neo kernel: [909247.415690]   .spread                        : 0.000000
May 25 12:19:45 neo kernel: [909247.415692]   .spread0                       : 3382338.277491
May 25 12:19:45 neo kernel: [909247.415693]   .nr_spread_over                : 0
May 25 12:19:45 neo kernel: [909247.415694]   .nr_running                    : 1
May 25 12:19:45 neo kernel: [909247.415695]   .load                          : 15
May 25 12:19:45 neo kernel: [909247.415697]   .runnable_load_avg             : 14
May 25 12:19:45 neo kernel: [909247.415698]   .blocked_load_avg              : 905
May 25 12:19:45 neo kernel: [909247.415699]   .tg_load_contrib               : 919
May 25 12:19:45 neo kernel: [909247.415700]   .tg_runnable_contrib           : 1018
May 25 12:19:45 neo kernel: [909247.415702]   .tg_load_avg                   : 2883
May 25 12:19:45 neo kernel: [909247.415703]   .tg->runnable_avg              : 2024
May 25 12:19:45 neo kernel: [909247.415704]   .avg->runnable_avg_sum         : 47616
May 25 12:19:45 neo kernel: [909247.415706]   .avg->runnable_avg_period      : 47648
May 25 12:19:45 neo kernel: [909247.415707] 
May 25 12:19:45 neo kernel: [909247.415707] rt_rq[1]:
May 25 12:19:45 neo kernel: [909247.415708]   .rt_nr_running                 : 0
May 25 12:19:45 neo kernel: [909247.415709]   .rt_throttled                  : 0
May 25 12:19:45 neo kernel: [909247.415711]   .rt_time                       : 0.000000
May 25 12:19:45 neo kernel: [909247.415712]   .rt_runtime                    : 950.000000
May 25 12:19:45 neo kernel: [909247.415714] 
May 25 12:19:45 neo kernel: [909247.415714] runnable tasks:
May 25 12:19:45 neo kernel: [909247.415714]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
May 25 12:19:45 neo kernel: [909247.415714] ----------------------------------------------------------------------------------------------------------
May 25 12:19:45 neo kernel: [909247.415717]       watchdog/1    11        -2.971590    227418     0               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415721]      migration/1    12         0.000000    507506     0               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415725]      ksoftirqd/1    13 1021607397.993440   4292965   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415729]     kworker/1:0H    15      1403.760533         7   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415733]          khelper    16         2.967639         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415737]        writeback    19 171311652.266364       159   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415741]      kintegrityd    20        23.636663         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415745]           bioset    21        29.645818         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415749]          kblockd    22        33.652249         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415753]       khungtaskd    25 1021035218.294721      7582   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415757]             ksmd    27      1105.812165         2   125               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415761]       khugepaged    28 1021135428.676142      8574   139               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415765]           crypto    30      1116.421051         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415769]         kthrotld    35      1130.613301         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415773]          deferwq    36      1134.626987         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415777]       mpt_poll_0    91 333054119.725284       117   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415781]            mpt/0    93      1226.205106         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415785]        scsi_eh_0   130      1336.570200        24   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415789]        scsi_eh_1   134      1336.552198        24   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415793]        scsi_eh_2   135      1336.400764        24   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415796]        scsi_eh_3   136      1336.399153        23   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415800]        scsi_eh_4   141      1335.966545         9   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415805]     kworker/1:1H   174 1021626157.802525   4443928   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415809]           bioset   220      1579.940088         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415813]      jbd2/sde1-8   226 1021551366.884411    158504   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415817]      edac-poller   558 121659212.937637       105   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415821]  kvm-irqfd-clean   603      2893.492716         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415825]  btrfs-endio-rai  1266 1021186045.289890      8543   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415829]  btrfs-endio-met  1267 1021186142.646621     11079   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415833]  btrfs-freespace  1269 1021373909.786973    564842   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415837]    btrfs-cache-1  1271 1020391224.042296     11565   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415841]  btrfs-readahead  1272 1021186122.903044     10459   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415845]  btrfs-qgroup-re  1274 1021186170.209354     11819   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415849]    btrfs-cleaner  1282 1021376463.712619     55224   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415853]  btrfs-transacti  1283 1021376463.838591   1321608   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415857]          rpcbind  1950 1021256780.108296     30491   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415860]        rpc.statd  1978      7614.766308         8   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415864]           rpciod  1983      7636.261658         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415868]           nfsiod  1986      7642.290388         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415872]       rpc.idmapd  1993 1020059731.665158       564   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415876]            acpid  2395  49758033.700384       663   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415880]          apcupsd  2524 1021598486.783407   2844096   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415884]          dnsmasq  2617 1021591764.801864    442274   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415888]             cron  2685 1021186508.555739     25182   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415892]  nullmailer-send  2828 537537698.365646        92   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415896]             ntpd  2856 1021625900.226323    995941   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415900]         winbindd  3000 1021336259.562332      9401   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415904]         winbindd  3068 1021335797.842322     30615   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415908]           smartd  3073 1014479689.914724      9724   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415913]            getty  3145     12737.761363       122   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415916]            getty  3146     12737.422317        82   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415921]          kauditd  3150     12784.778568         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415924]         winbindd  3339 1021493786.024708     31844   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415928]         winbindd  3341 1021488297.726106     30332   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415932]            getty 31172  17144826.418321        10   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415937]             nfsd   347 1011835277.010671    736676   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415941]             nfsd   348 1020059731.913418    734655   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415945]             nfsd   349 1011835276.986828    727002   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415949]             nfsd   350 1015873122.229289    705544   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415953]       rpc.mountd   353 1020059731.819841       547   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415957]    xfs_mru_cache 22627  49187876.093308         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415961]          xfslogd 22628  49187880.107803         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415965]            jfsIO 22631  49187900.218235         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415969]        jfsCommit 22632  49187904.235989         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415973]        jfsCommit 22633  49187908.249559         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415976]          jfsSync 22634  49187912.264872         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415980]         php5-fpm 24082  49194864.370449         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415984]         php5-fpm 24083  49194867.482649         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415988]       vboxwebsrv 26687 1021593917.298449     73519   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415992]           nspr-1 26691 1021593917.696862    240856   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.415996]   VBoxSVCWatcher 26706 1021261031.265856     20713   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416000]            SQPmp 26707 1021591792.562302      3495   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416004]         Watchdog 26708 1021593920.407944     45087   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416008]            SQW01 29556 1021593919.209130     92648   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416011]            SQW02 29562 1021591792.460574     90023   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416016]    VBoxXPCOMIPCD 26689 1021607998.187508    673304   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416020]          VBoxSVC 26694 1021607998.135343    535777   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416024]           nspr-1 26697 1021607998.180797   1002557   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416028]           nspr-2 26698 1021607998.150876    233247   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416032]          TimerLR 26699  49233592.129414         1   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416036]         USBPROXY 26702  49576191.529017        33   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416040]           nspr-3 29582 1021606570.201235    227143   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416044]           nspr-4 29590 1021593917.321499    227645   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416047]             sshd 26830 1015412703.314733        30   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416051]     VBoxHeadless 29471 1021627200.625364    233322   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416055]           nspr-1 29485 1021627200.685291    696321   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416059]   VBoxSVCWatcher 29498 1021560148.837639     20644   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416063]          TimerLR 29500 1021627200.719010    686558   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416067]   MainHGCMthread 29502  49274682.790630        46   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416071]          VRDP-IN 29504 1021630876.682551    898734   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416075]         VRDP-OUT 29505 1021632819.293845   5578416   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416079]       remote usb 29506 1021604098.205047    112479   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416084]        ShFolders 29514  49274658.654582         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416088]            ATA-1 29517 1021195415.982910    508137   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416092]      INTNET-RECV 29518 1021492313.624911   2603747   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416096]    VBoxXPCOMIPCD 29483 1021627200.673966    931062   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416100]          VBoxSVC 29488 1021627200.633625    807634   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416104]           nspr-1 29490 1021627200.678048   1397442   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416108]           nspr-2 29491 1021619460.685347    465594   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416112]          TimerLR 29494 1021624748.429572    412755   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416116]      dns-monitor 29495  57389248.425500        30   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416120]     EventHandler 29497  49274965.128877         7   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416124]           nspr-3 29499 1021627200.642719    465605   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416128]     VBoxHeadless 29521 1021619460.667037    233671   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416132]           nspr-1 29531 1021619460.730888    696371   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416136]   VBoxSVCWatcher 29533 1021287339.856716     20660   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416140]          TimerLR 29534 1021619460.757452    694309   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416143]   MainHGCMthread 29536  49274965.013089        75   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416148]      ShClipboard 29541  49274907.024731        11   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416151]   DragAndDropSvc 29542  49274907.740004        11   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416155]     GuestPropSvc 29543  49274910.428906        21   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416159]  GuestControlSvc 29544  49274914.610523         7   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416163]        ShFolders 29547  49274942.074963         7   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416167]             VDMA 29548  49274942.331271         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416171]      INTNET-XMIT 29553  49274965.064784         5   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416175]     VBoxHeadless 29585 1021606570.184849    245624   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416179]           nspr-1 29587 1021606570.238594    719489   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416183]          TimerLR 29591 1021606570.257591    690828   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416187]       remote usb 29596 1021616516.302725    112468   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416191]      ShClipboard 29598 434073173.385003         7   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416195]   DragAndDropSvc 29599  49290152.283653         4   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416198]     GuestPropSvc 29600  49290156.608889        10   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416202]  GuestControlSvc 29601  49290160.849160         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416206]            Timer 29602 1021635139.946697  22529818   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416210]        ShFolders 29604  49290190.438398         4   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416214]             VDMA 29605  49290200.600573         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416218]            Port0 29607 1020318080.275159    116210   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416222]            ATA-0 29608  49297607.790994         8   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416227]      INTNET-RECV 29610 1021607720.843335   1383577   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416230]      INTNET-XMIT 29611  49290220.074984         5   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416234]        scsi_eh_9 31390  49576159.921569         2   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416238]      usb-storage 31391 538709984.886684    436549   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416242]         rsyslogd 32066 539150493.099308        12   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416246]      in:imuxsock 32068 1021299059.519745     14418   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416251]    rs:main Q:Reg 32071 1021299059.566128     14377   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416255]  ext4-rsv-conver 32175  49850457.923401         2   100               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416259]             smbd 32222 1021418630.818291     13411   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416263]             smbd 32247 1021187227.600567      4448   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416267]            snmpd   509 1021579936.199989    153022   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416271]         lighttpd   852 1021627251.504629    224761   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416275]          php-cgi   869 1010105208.471636      5733   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416279]             smbd 14631 1021194767.393922     11344   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416284]    btrfs-endio-4 19709 1021570811.540610     60052   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416289]     HandBrakeCLI 20440 1021626789.001532      8738   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416293]     HandBrakeCLI 20444 1021629862.614591     27286   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416297]     HandBrakeCLI 20447 1021627212.700569     68754   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416301]     HandBrakeCLI 20448 1021627212.565224     71313   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416305]     HandBrakeCLI 20449 1021627714.291464     29611   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416309]     HandBrakeCLI 20450 1021627717.343382     40958   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416313]     HandBrakeCLI 20451 1021627212.385994     37760   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416317]     HandBrakeCLI 20452 1021627212.244206     37339   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416321]     HandBrakeCLI 20454 1021627713.231493     55223   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416324]     HandBrakeCLI 20455 1021627332.735967     47089   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416328]     HandBrakeCLI 20456 1021627332.782978     47160   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416332]     HandBrakeCLI 20457 1021626158.791409     16784   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416336]     HandBrakeCLI 20458 1021627714.516237    176590   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416340]     HandBrakeCLI 20459 1021626801.193402     11132   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416344]     HandBrakeCLI 20461 1021626157.895326     15483   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416348]     HandBrakeCLI 20462 1021626167.259784     44524   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416352]     HandBrakeCLI 20463 1021626166.365035     56710   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416356] R   HandBrakeCLI 20465 1021635336.232912    977173   139               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416360]     HandBrakeCLI 20469 1021629872.352960     50729   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416364]     HandBrakeCLI 20470 1021626162.253525     17783   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416368]     HandBrakeCLI 20471 1021626216.868422     78815   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416372]     HandBrakeCLI 20473 1021626210.869931     37622   130               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416376]    btrfs-endio-3 20510 1021626157.826783     60135   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416380]      kworker/1:1 20543 1021635205.071253    104540   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416384]     kworker/u8:0 20547 1021621158.079094       202   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416388]    btrfs-endio-3 20554 1021598489.770036     43127   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416392]  btrfs-endio-met 20556 1021495003.540018       982   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416396]     VBoxHeadless 20585 1021607998.128113     15631   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416400]           nspr-1 20587 1021607998.210594     25414   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416404]           nspr-2 20588 1021593923.419059     13923   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416408]   VBoxSVCWatcher 20589 1021585836.555139        91   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416412]   MainHGCMthread 20592 1010072585.502051        79   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416416]          VRDP-IN 20593 1021623952.577389      5099   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416420]      ShClipboard 20597 1009935447.645600        18   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416424]   DragAndDropSvc 20598 1004818856.278852         6   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416428]     GuestPropSvc 20599 1021563237.064661       641   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416432]  GuestControlSvc 20600 1006220412.601652         7   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416437]            ATA-0 20605 1021635067.850001    576985   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416440]      INTNET-RECV 20607 1021492313.585384     13143   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416444]      INTNET-XMIT 20608 1004828787.733866         5   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416448]      ACPI Poller 20609 1021496832.033816        55   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416452]           nspr-3 20619 1021593917.291746     13622   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416456]    btrfs-endio-4 20827 1021493079.529618     38360   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416460]      kworker/1:2 20967 1014479677.347347         3   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416464]  btrfs-endio-met 20987 1021564746.740600       741   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416468]             sshd 21021 1015412707.707534        46   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416472]  btrfs-endio-met 21025 1021495003.490469       605   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416476]             sshd 21028 1021635205.129256       719   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416480]  btrfs-endio-met 21116 1021564755.913369       561   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416484]          php-cgi 21188 1021593920.628345      6190   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416488]     kworker/u8:2 21331 1020628630.563225       389   120               0               0               0.000000               0.000000               0.000000 0 /
May 25 12:19:45 neo kernel: [909247.416492]





-----Original Message-----
From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Duncan
Sent: 02 April 2014 07:59
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hangs - possibly NFS related?

kim-btrfs posted on Tue, 01 Apr 2014 13:56:06 +0100 as excerpted:

> Apologies if this is known, but I've been lurking a while on the list 
> and not seen anything similar - and I'm running out of ideas on what 
> to do next to debug it.
> 
> Small HP microserver box, running Debian, EXT4 system disk plus 4 disk 
> BTRFS array shared over NFS (nfs-kernel-server) and SMB - the disks 
> recently moved from a different box where they've been running 
> faultlessly for months, although that didn't use NFS.

First off I have absolutely zero experience with NFS or SMB, so if it has anything at all to do with that, I'd be clueless.  That said, I do know a few other things to look at, and some idea of how to look at them.  The below is what I'd be looking at were it me.

> Under reasonable combined NFS and SMB load with only a couple of 
> clients, the shares lock up, load average on server and clients goes
> high and stays high (10-12) and stays there.     Apparently not actually
> CPU and there's little if any disk activity on the server.

First thing, high load, but little CPU and little I/O.  That's very strange, but there's a few things besides that to check to see if you can run down where all that load is going.

With the right tools CPU/load can be categorized into several areas, low- priority/niced, normal, kernel, IRQ, soft-IRQ, IO-wait, steal, guest, altho steal and guest are VM related (steal is CPU taken by the hypervisor or another guest if measured from within a guest, and thus not available to it, quest is of course guests, when measured from the hypervisor) and will be zero if you're not running them, and irq and soft-irq won't show much either in the normal case.  And of course niced doesn't show either unless you're running something niced.

What I'm wondering here is if it's all going to IO-wait as I suspect... 
or something else.

If you don't have a tool that shows all that, one available tool that does is htop.  It's a "better" top, ncurses/semi-gui-based so run it in a terminal window or text-login VT.

Of course you can see which threads are using all that CPU-time "load" 
that isn't, while you're at it.

Also check out iotop, to see what processes are actually doing IO and the total IO speed.  Both these tools have manpages...

What could be interesting is what happens when you do that sync.  Does a thread or several threads spring to life momentarily (say in iotop) and then idle again, or... ?

> Killing NFS and/or Samba sometimes helps, but it's always back when 
> the load comes back on. Chased round NFS and Samba options, then find 
> that when the clients hang it's unresponsive on the server directly to 
> the disk.
> 
> Notice  a "btrfs-transacti" process hung in "d".    As are all the NFS
> processes:
> 
> 3779 ?        S<     0:00 [nfsd4]
> 3780 ?        S<     0:00 [nfsd4_callbacks]
> 3782 ?        D      0:27 [nfsd]
> 3783 ?        D      0:27 [nfsd]
> 3784 ?        D      0:28 [nfsd]
> 3785 ?        D      0:26 [nfsd]
> 
> "sync" instantly unsticks everything and it all works again for another
> couple of minutes, when it locks up again, same symptoms.     Nothing
> apparently written to kern.log or dmesg, which has been the 
> frustration all through - I don't know where to find the culprit!
> 
> As a band-aid I've put btrfs filesystem sync /mnt/btrfs
> 
> In the crontab once a minute which is actually working just fine  and 
> has been all morning - every 5 minutes was not enough.
> 
> Any recommendations on where I can look next, or any known holes I've 
> fallen in.?  Do I need to force NFS clients to sync in their mount 
> options?
> 
> 
> Background:
> Kernel - 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25)    AMD N54L
> with 10GB RAM.
> 
> ##################################################
>	Total devices 4 FS bytes used 848.88GiB
>	devid    2 size 465.76GiB used 319.03GiB path /dev/sdc
>	devid    4 size 465.76GiB used 319.00GiB path /dev/sda
>	devid    5 size 455.76GiB used 309.03GiB path /dev/sdb2
>	devid    6 size 931.51GiB used 785.00GiB path /dev/sdd
> 
> ##################################################

OK, so you're not full allocation.  No problem there.

> Data, RAID1: total=864.00GiB, used=847.86GiB System, RAID1: 
> total=32.00MiB, used=128.00KiB Metadata, RAID1: total=2.00GiB, 
> used=1009.93MiB

That looks healthy. 

> A "scrub" passes without finding any errors.
> 
> There are a couple of VM images with light traffic which do fragment a 
> little but I manually defrag those every day so often and I haven't 
> had any problems there - it certainly isn't thrashing.

If you've been following the list, I'm surprised you didn't mention whether you're doing snapshotting at all.  I'll assume that means no, or only very light/manual snapshotting (as I have here).


My guess is that it might be fragmentation of something other than the VMs.  You're not mounting with autodefrag, I take it?  What about compress?  Do you have any other large actively written files, perhaps databases or pre-allocated-file torrent downloading going on?  How big are they if so, and what does filefrag say about them?  (Note that the reason I mentioned the compress option is that filefrag doesn't understand btrfs compression and counts it as fragmentation, so any files over ~128 MiB that btrfs compresses will appear fragmented.  Also, btrfs data chunks are 1 GiB in size so anything over a gig will likely show a few fragments due simply to data chunk breaks.)

For autodefrag, note that if you try it on a btrfs that has been used some time without it and thus has some fragmentation, you'll likely see lower performance until it catches up.  One way around that is a recursive defrag of everything, so when you turn on autodefrag it only has to maintain, not catch up.

And for the VM images (and databases and pre-allocated torrent downloads), you can try setting NOCOW (tho if you're doing automated snapshots it may not help /that/ much).  I'll assume you've seen some of the discussion of that and know why/how to set it on the directory before putting the files in it so they inherit the attribute, so I don't have to explain that.

Tho the one thing that puzzles me is that sync behavior; nobody else has reported anything like that that I'm aware of, so I'd guess it either didn't occur to anyone else to try that, or possibly, whatever it is you're seeing isn't reported that often, and you may actually be the first to report it.

One other thing I've seen the devs mention:  When you see this happening and the blocked tasks, try:

echo w > /proc/sysrq-trigger

(or simply use the alt-srq-w combo if you're on x86 and have it available, there's more about magic-srq in the kernel's Documentation/ sysrq.txt file).  Assuming the appropriate srq functionality is built into your kernel and enabled, that should dump blocked tasks to the console.  That can be very useful to the devs looking into your problem.

Anyway, those are kind of broad shots in the dark in the hope they make contact with something worth reporting.  Hopefully they do turn up something...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master -- and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


