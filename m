Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33724 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3HEQfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 12:35:18 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 9532E35150B
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Aug 2013 18:35:13 +0200 (CEST)
Received: from localhost (cm218-254-66-194.hkcable.com.hk [218.254.66.194])
	by mail.virtall.com (Postfix) with ESMTPSA id 0BB653514FB
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Aug 2013 18:35:11 +0200 (CEST)
Date: Tue, 6 Aug 2013 00:35:05 +0800
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Heavy memory leak when using quota groups
Message-ID: <20130806003505.7d7feff6@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I am trying to use qgroups
> functionality & with a basic random-write workload, it constantly
> keeps leaking memory & within few minutes of IO, there is either
> out-of-memory killer trying to kill some tasks or there are
> page-allocation failures that btrfs or other kernel module
> experiences.

FYI, I just saw something similar with 3.10 on a server with 32 GB RAM:

The result was a frozen server and a need to hard reset.

Aug  4 21:51:14 bkp010 kernel: [661831.436751] btrfs-endio-wri: page allocation failure: order:0, mode:0x284020
Aug  4 21:51:14 bkp010 kernel: [661831.436805] CPU: 3 PID: 19598 Comm: btrfs-endio-wri Not tainted 3.10.0 #3
Aug  4 21:51:14 bkp010 kernel: [661831.436853] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Aug  4 21:51:14 bkp010 kernel: [661831.436943]  0000000000284020 ffff88047e3fd518 ffffffff81371348 ffff88047e3fd5a8
Aug  4 21:51:14 bkp010 kernel: [661831.437033]  ffffffff810a5629 0000000000000000 ffffea0002adab20 ffff88081fad4a70
Aug  4 21:51:14 bkp010 kernel: [661831.437123]  ffff88081fdd9a00 ffff88081fdd9a38 0000000100000000 0000000000000000
Aug  4 21:51:14 bkp010 kernel: [661831.437213] Call Trace:
Aug  4 21:51:14 bkp010 kernel: [661831.437263]  [<ffffffff81371348>] dump_stack+0x19/0x1b
Aug  4 21:51:14 bkp010 kernel: [661831.437312]  [<ffffffff810a5629>] warn_alloc_failed+0x110/0x124
Aug  4 21:51:14 bkp010 kernel: [661831.437360]  [<ffffffff810a7be3>] __alloc_pages_nodemask+0x6a4/0x793
Aug  4 21:51:14 bkp010 kernel: [661831.437419]  [<ffffffff810d07fc>] alloc_pages_current+0xc8/0xe5
Aug  4 21:51:14 bkp010 kernel: [661831.437477]  [<ffffffff810d3fb9>] new_slab+0xb5/0x269
Aug  4 21:51:14 bkp010 kernel: [661831.437525]  [<ffffffff813701b2>] __slab_alloc+0x30e/0x493
Aug  4 21:51:14 bkp010 kernel: [661831.437583]  [<ffffffffa071b6a6>] ? __alloc_extent_buffer+0x25/0xd8 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.437637]  [<ffffffffa071b6a6>] ? __alloc_extent_buffer+0x25/0xd8 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.437686]  [<ffffffff810d5ddb>] kmem_cache_alloc+0x95/0x110
Aug  4 21:51:14 bkp010 kernel: [661831.437737]  [<ffffffffa071b6a6>] __alloc_extent_buffer+0x25/0xd8 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.437769] swapper/7: page allocation failure: order:0, mode:0x20
Aug  4 21:51:14 bkp010 kernel: [661831.437770] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.10.0 #3
Aug  4 21:51:14 bkp010 kernel: [661831.437771] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Aug  4 21:51:14 bkp010 kernel: [661831.437772]  0000000000000020 ffff88081fbc3b88 ffffffff81371348 ffff88081fbc3c18
Aug  4 21:51:14 bkp010 kernel: [661831.437774]  ffffffff810a5629 ffff880400000000 0000000000011780 ffff88081fbc3bd8
Aug  4 21:51:14 bkp010 kernel: [661831.437775]  ffff88081fdd9a00 ffff88081fdd9a38 0000000100000000 0000000000000000
Aug  4 21:51:14 bkp010 kernel: [661831.437775] Call Trace:
Aug  4 21:51:14 bkp010 kernel: [661831.437778]  <IRQ>  [<ffffffff81371348>] dump_stack+0x19/0x1b
Aug  4 21:51:14 bkp010 kernel: [661831.437780]  [<ffffffff810a5629>] warn_alloc_failed+0x110/0x124
Aug  4 21:51:14 bkp010 kernel: [661831.437782]  [<ffffffff810a7be3>] __alloc_pages_nodemask+0x6a4/0x793
Aug  4 21:51:14 bkp010 kernel: [661831.437785]  [<ffffffff810d07fc>] alloc_pages_current+0xc8/0xe5
Aug  4 21:51:14 bkp010 kernel: [661831.437788]  [<ffffffff812c9a91>] __netdev_alloc_frag+0x52/0xf3
Aug  4 21:51:14 bkp010 kernel: [661831.437789]  [<ffffffff812cb019>] __netdev_alloc_skb+0x43/0xdb
Aug  4 21:51:14 bkp010 kernel: [661831.437798]  [<ffffffffa0007375>] rtl8169_poll+0x241/0x4e2 [r8169]
Aug  4 21:51:14 bkp010 kernel: [661831.437800]  [<ffffffff812d47f2>] net_rx_action+0xa3/0x182
Aug  4 21:51:14 bkp010 kernel: [661831.437803]  [<ffffffff81034c55>] __do_softirq+0xb7/0x16d
Aug  4 21:51:14 bkp010 kernel: [661831.437804]  [<ffffffff81034dde>] irq_exit+0x3e/0x83
Aug  4 21:51:14 bkp010 kernel: [661831.437807]  [<ffffffff81003c35>] do_IRQ+0x98/0xaf
Aug  4 21:51:14 bkp010 kernel: [661831.437809]  [<ffffffff813750ea>] common_interrupt+0x6a/0x6a
Aug  4 21:51:14 bkp010 kernel: [661831.437811]  <EOI>  [<ffffffff812a3a67>] ? cpuidle_enter_state+0x49/0xac
Aug  4 21:51:14 bkp010 kernel: [661831.437812]  [<ffffffff812a3a60>] ? cpuidle_enter_state+0x42/0xac
Aug  4 21:51:14 bkp010 kernel: [661831.437813]  [<ffffffff812a3b8d>] cpuidle_idle_call+0xc3/0x10f
Aug  4 21:51:14 bkp010 kernel: [661831.437815]  [<ffffffff810097de>] arch_cpu_idle+0x9/0x18
Aug  4 21:51:14 bkp010 kernel: [661831.437816]  [<ffffffff81062a7c>] cpu_startup_entry+0xa8/0x104
Aug  4 21:51:14 bkp010 kernel: [661831.437819]  [<ffffffff8136581f>] start_secondary+0x1af/0x1b3
Aug  4 21:51:14 bkp010 kernel: [661831.437819] Mem-Info:
Aug  4 21:51:14 bkp010 kernel: [661831.437820] Node 0 DMA per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.437821] CPU    0: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437821] CPU    1: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437822] CPU    2: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437822] CPU    3: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437823] CPU    4: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437823] CPU    5: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437824] CPU    6: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437825] CPU    7: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437825] Node 0 DMA32 per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.437826] CPU    0: hi:  186, btch:  31 usd: 176
Aug  4 21:51:14 bkp010 kernel: [661831.437826] CPU    1: hi:  186, btch:  31 usd:  37
Aug  4 21:51:14 bkp010 kernel: [661831.437827] CPU    2: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437827] CPU    3: hi:  186, btch:  31 usd:  41
Aug  4 21:51:14 bkp010 kernel: [661831.437828] CPU    4: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437828] CPU    5: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437829] CPU    6: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.437830] CPU    7: hi:  186, btch:  31 usd: 172
Aug  4 21:51:14 bkp010 kernel: [661831.437830] Node 0 Normal per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.437831] CPU    0: hi:  186, btch:  31 usd: 180
Aug  4 21:51:14 bkp010 kernel: [661831.437832] CPU    1: hi:  186, btch:  31 usd:  64
Aug  4 21:51:14 bkp010 kernel: [661831.437833] CPU    2: hi:  186, btch:  31 usd:  60
Aug  4 21:51:14 bkp010 kernel: [661831.437833] CPU    3: hi:  186, btch:  31 usd:  84
Aug  4 21:51:14 bkp010 kernel: [661831.437834] CPU    4: hi:  186, btch:  31 usd:  90
Aug  4 21:51:14 bkp010 kernel: [661831.437835] CPU    5: hi:  186, btch:  31 usd:  66
Aug  4 21:51:14 bkp010 kernel: [661831.437835] CPU    6: hi:  186, btch:  31 usd:  20
Aug  4 21:51:14 bkp010 kernel: [661831.437836] CPU    7: hi:  186, btch:  31 usd: 209
Aug  4 21:51:14 bkp010 kernel: [661831.437839] active_anon:49535 inactive_anon:56858 isolated_anon:0
Aug  4 21:51:14 bkp010 kernel: [661831.437839]  active_file:12576 inactive_file:14674 isolated_file:0
Aug  4 21:51:14 bkp010 kernel: [661831.437839]  unevictable:0 dirty:4574 writeback:17253 unstable:0
Aug  4 21:51:14 bkp010 kernel: [661831.437839]  free:34679 slab_reclaimable:1154786 slab_unreclaimable:18894
Aug  4 21:51:14 bkp010 kernel: [661831.437839]  mapped:1456 shmem:169 pagetables:3293 bounce:0
Aug  4 21:51:14 bkp010 kernel: [661831.437839]  free_cma:0
Aug  4 21:51:14 bkp010 kernel: [661831.437843] Node 0 DMA free:15900kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Aug  4 21:51:14 bkp010 kernel: [661831.437845] lowmem_reserve[]: 0 3174 31846 31846
Aug  4 21:51:14 bkp010 kernel: [661831.437849] Node 0 DMA32 free:115440kB min:2276kB low:2844kB high:3412kB active_anon:56kB inactive_anon:28672kB active_file:31172kB inactive_file:32616kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3334376kB managed:3250672kB mlocked:0kB dirty:144kB writeback:0kB mapped:1184kB shmem:0kB slab_reclaimable:1883292kB slab_unreclaimable:14256kB kernel_stack:80kB pagetables:20kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:68 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.437850] lowmem_reserve[]: 0 0 28672 28672
Aug  4 21:51:14 bkp010 kernel: [661831.437853] Node 0 Normal free:7376kB min:20560kB low:25700kB high:30840kB active_anon:198084kB inactive_anon:198760kB active_file:19132kB inactive_file:26080kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:29882368kB managed:29360436kB mlocked:0kB dirty:18152kB writeback:69012kB mapped:4640kB shmem:676kB slab_reclaimable:2735852kB slab_unreclaimable:61320kB kernel_stack:3984kB pagetables:13152kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:101 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.437854] lowmem_reserve[]: 0 0 0 0
Aug  4 21:51:14 bkp010 kernel: [661831.437859] Node 0 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15900kB
Aug  4 21:51:14 bkp010 kernel: [661831.437863] Node 0 DMA32: 28844*4kB (EM) 0*8kB 0*16kB 1*32kB (R) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 115408kB
Aug  4 21:51:14 bkp010 kernel: [661831.437867] Node 0 Normal: 1367*4kB (M) 0*8kB 0*16kB 7*32kB (R) 1*64kB (R) 1*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 7164kB
Aug  4 21:51:14 bkp010 kernel: [661831.437868] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Aug  4 21:51:14 bkp010 kernel: [661831.437869] 44196 total pagecache pages
Aug  4 21:51:14 bkp010 kernel: [661831.437870] 16756 pages in swap cache
Aug  4 21:51:14 bkp010 kernel: [661831.437870] Swap cache stats: add 828307, delete 811551, find 615437/665659
Aug  4 21:51:14 bkp010 kernel: [661831.437870] Free swap  = 16634240kB
Aug  4 21:51:14 bkp010 kernel: [661831.437871] Total swap = 16776116kB
Aug  4 21:51:14 bkp010 kernel: [661831.443483]  [<ffffffffa072128d>] btrfs_clone_extent_buffer+0x3a/0xc3 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443574]  [<ffffffffa06ebefb>] btrfs_search_old_slot+0x680/0x78b [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443626]  [<ffffffffa06edd71>] btrfs_next_old_leaf+0xc9/0x3a6 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443680]  [<ffffffffa074da50>] __resolve_indirect_refs+0x331/0x467 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443772]  [<ffffffffa074e205>] find_parent_nodes+0x357/0x5be [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443825]  [<ffffffffa074e4e8>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.443874]  [<ffffffff810d58b9>] ? kmem_cache_free+0x164/0x17a
Aug  4 21:51:14 bkp010 kernel: [661831.443925]  [<ffffffffa07514bd>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444018]  [<ffffffffa071c49f>] ? clear_state_bit+0x106/0x115 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444069]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444163]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444215]  [<ffffffffa06f4514>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444307]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444360]  [<ffffffffa0711224>] btrfs_finish_ordered_io+0x683/0x84e [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444448]  [<ffffffff810a3683>] ? mempool_free_slab+0x12/0x14
Aug  4 21:51:14 bkp010 kernel: [661831.444496]  [<ffffffff810a3717>] ? mempool_free+0x72/0x7a
Aug  4 21:51:14 bkp010 kernel: [661831.444547]  [<ffffffffa073c357>] ? end_compressed_bio_write+0xc0/0xc8 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444639]  [<ffffffffa07113ff>] finish_ordered_fn+0x10/0x12 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444692]  [<ffffffffa072ab5c>] worker_loop+0x15e/0x48e [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444744]  [<ffffffffa072a9fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
Aug  4 21:51:14 bkp010 kernel: [661831.444793]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
Aug  4 21:51:14 bkp010 kernel: [661831.444840]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
Aug  4 21:51:14 bkp010 kernel: [661831.444889]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
Aug  4 21:51:14 bkp010 kernel: [661831.444936]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
Aug  4 21:51:14 bkp010 kernel: [661831.444984] Mem-Info:
Aug  4 21:51:14 bkp010 kernel: [661831.445026] Node 0 DMA per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.445070] CPU    0: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445115] CPU    1: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445161] CPU    2: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445206] CPU    3: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445235] swapper/7: page allocation failure: order:0, mode:0x20
Aug  4 21:51:14 bkp010 kernel: [661831.445237] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.10.0 #3
Aug  4 21:51:14 bkp010 kernel: [661831.445237] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Aug  4 21:51:14 bkp010 kernel: [661831.445238]  0000000000000020 ffff88081fbc3b88 ffffffff81371348 ffff88081fbc3c18
Aug  4 21:51:14 bkp010 kernel: [661831.445240]  ffffffff810a5629 ffff880700000000 ffff88081fa51780 ffff88081fbc3bc8
Aug  4 21:51:14 bkp010 kernel: [661831.445241]  ffff88081fdd9a00 ffff88081fdd9a38 0000000100000000 0000000000000000
Aug  4 21:51:14 bkp010 kernel: [661831.445241] Call Trace:
Aug  4 21:51:14 bkp010 kernel: [661831.445244]  <IRQ>  [<ffffffff81371348>] dump_stack+0x19/0x1b
Aug  4 21:51:14 bkp010 kernel: [661831.445245]  [<ffffffff810a5629>] warn_alloc_failed+0x110/0x124
Aug  4 21:51:14 bkp010 kernel: [661831.445247]  [<ffffffff810a7be3>] __alloc_pages_nodemask+0x6a4/0x793
Aug  4 21:51:14 bkp010 kernel: [661831.445250]  [<ffffffff810d07fc>] alloc_pages_current+0xc8/0xe5
Aug  4 21:51:14 bkp010 kernel: [661831.445252]  [<ffffffff812c9a91>] __netdev_alloc_frag+0x52/0xf3
Aug  4 21:51:14 bkp010 kernel: [661831.445254]  [<ffffffff812cb019>] __netdev_alloc_skb+0x43/0xdb
Aug  4 21:51:14 bkp010 kernel: [661831.445260]  [<ffffffffa0007375>] rtl8169_poll+0x241/0x4e2 [r8169]
Aug  4 21:51:14 bkp010 kernel: [661831.445261]  [<ffffffff812d47f2>] net_rx_action+0xa3/0x182
Aug  4 21:51:14 bkp010 kernel: [661831.445264]  [<ffffffff81034c55>] __do_softirq+0xb7/0x16d
Aug  4 21:51:14 bkp010 kernel: [661831.445265]  [<ffffffff81034dde>] irq_exit+0x3e/0x83
Aug  4 21:51:14 bkp010 kernel: [661831.445267]  [<ffffffff81003c35>] do_IRQ+0x98/0xaf
Aug  4 21:51:14 bkp010 kernel: [661831.445268]  [<ffffffff813750ea>] common_interrupt+0x6a/0x6a
Aug  4 21:51:14 bkp010 kernel: [661831.445270]  <EOI>  [<ffffffff812a3a67>] ? cpuidle_enter_state+0x49/0xac
Aug  4 21:51:14 bkp010 kernel: [661831.445271]  [<ffffffff812a3a60>] ? cpuidle_enter_state+0x42/0xac
Aug  4 21:51:14 bkp010 kernel: [661831.445272]  [<ffffffff812a3b8d>] cpuidle_idle_call+0xc3/0x10f
Aug  4 21:51:14 bkp010 kernel: [661831.445274]  [<ffffffff810097de>] arch_cpu_idle+0x9/0x18
Aug  4 21:51:14 bkp010 kernel: [661831.445275]  [<ffffffff81062a7c>] cpu_startup_entry+0xa8/0x104
Aug  4 21:51:14 bkp010 kernel: [661831.445277]  [<ffffffff8136581f>] start_secondary+0x1af/0x1b3
Aug  4 21:51:14 bkp010 kernel: [661831.445278] Mem-Info:
Aug  4 21:51:14 bkp010 kernel: [661831.445278] Node 0 DMA per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.445279] CPU    0: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445279] CPU    1: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445280] CPU    2: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445280] CPU    3: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445280] CPU    4: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445281] CPU    5: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445281] CPU    6: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445282] CPU    7: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445282] Node 0 DMA32 per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.445283] CPU    0: hi:  186, btch:  31 usd: 165
Aug  4 21:51:14 bkp010 kernel: [661831.445284] CPU    1: hi:  186, btch:  31 usd:  37
Aug  4 21:51:14 bkp010 kernel: [661831.445284] CPU    2: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445285] CPU    3: hi:  186, btch:  31 usd:  41
Aug  4 21:51:14 bkp010 kernel: [661831.445285] CPU    4: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445286] CPU    5: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445286] CPU    6: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.445287] CPU    7: hi:  186, btch:  31 usd: 172
Aug  4 21:51:14 bkp010 kernel: [661831.445287] Node 0 Normal per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.445288] CPU    0: hi:  186, btch:  31 usd: 181
Aug  4 21:51:14 bkp010 kernel: [661831.445288] CPU    1: hi:  186, btch:  31 usd:  64
Aug  4 21:51:14 bkp010 kernel: [661831.445289] CPU    2: hi:  186, btch:  31 usd:  60
Aug  4 21:51:14 bkp010 kernel: [661831.445289] CPU    3: hi:  186, btch:  31 usd:  84
Aug  4 21:51:14 bkp010 kernel: [661831.445290] CPU    4: hi:  186, btch:  31 usd:  90
Aug  4 21:51:14 bkp010 kernel: [661831.445290] CPU    5: hi:  186, btch:  31 usd:  66
Aug  4 21:51:14 bkp010 kernel: [661831.445291] CPU    6: hi:  186, btch:  31 usd:  20
Aug  4 21:51:14 bkp010 kernel: [661831.445291] CPU    7: hi:  186, btch:  31 usd: 209
Aug  4 21:51:14 bkp010 kernel: [661831.445293] active_anon:49535 inactive_anon:56858 isolated_anon:0
Aug  4 21:51:14 bkp010 kernel: [661831.445293]  active_file:12576 inactive_file:14654 isolated_file:0
Aug  4 21:51:14 bkp010 kernel: [661831.445293]  unevictable:0 dirty:4574 writeback:17362 unstable:0
Aug  4 21:51:14 bkp010 kernel: [661831.445293]  free:34697 slab_reclaimable:1154786 slab_unreclaimable:18894
Aug  4 21:51:14 bkp010 kernel: [661831.445293]  mapped:1456 shmem:169 pagetables:3293 bounce:0
Aug  4 21:51:14 bkp010 kernel: [661831.445293]  free_cma:0
Aug  4 21:51:14 bkp010 kernel: [661831.445298] Node 0 DMA free:15900kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Aug  4 21:51:14 bkp010 kernel: [661831.445299] lowmem_reserve[]: 0 3174 31846 31846
Aug  4 21:51:14 bkp010 kernel: [661831.445303] Node 0 DMA32 free:115512kB min:2276kB low:2844kB high:3412kB active_anon:56kB inactive_anon:28672kB active_file:31172kB inactive_file:32536kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3334376kB managed:3250672kB mlocked:0kB dirty:144kB writeback:0kB mapped:1184kB shmem:0kB slab_reclaimable:1883292kB slab_unreclaimable:14256kB kernel_stack:80kB pagetables:20kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:9 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.445305] lowmem_reserve[]: 0 0 28672 28672
Aug  4 21:51:14 bkp010 kernel: [661831.445309] Node 0 Normal free:7376kB min:20560kB low:25700kB high:30840kB active_anon:198084kB inactive_anon:198760kB active_file:19132kB inactive_file:26080kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:29882368kB managed:29360436kB mlocked:0kB dirty:18152kB writeback:69448kB mapped:4640kB shmem:676kB slab_reclaimable:2735852kB slab_unreclaimable:61320kB kernel_stack:3984kB pagetables:13152kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:311 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.445310] lowmem_reserve[]: 0 0 0 0
Aug  4 21:51:14 bkp010 kernel: [661831.445316] Node 0 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15900kB
Aug  4 21:51:14 bkp010 kernel: [661831.445320] Node 0 DMA32: 28841*4kB (UEM) 15*8kB (UEM) 1*16kB (M) 1*32kB (R) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 115532kB
Aug  4 21:51:14 bkp010 kernel: [661831.445324] Node 0 Normal: 1367*4kB (M) 0*8kB 0*16kB 7*32kB (R) 1*64kB (R) 1*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 7164kB
Aug  4 21:51:14 bkp010 kernel: [661831.445325] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Aug  4 21:51:14 bkp010 kernel: [661831.445325] 44279 total pagecache pages
Aug  4 21:51:14 bkp010 kernel: [661831.445326] 16820 pages in swap cache
Aug  4 21:51:14 bkp010 kernel: [661831.445326] Swap cache stats: add 828373, delete 811553, find 615437/665659
Aug  4 21:51:14 bkp010 kernel: [661831.445327] Free swap  = 16633976kB
Aug  4 21:51:14 bkp010 kernel: [661831.445327] Total swap = 16776116kB
Aug  4 21:51:14 bkp010 kernel: [661831.450878] CPU    4: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.450924] CPU    5: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.450969] CPU    6: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451014] CPU    7: hi:    0, btch:   1 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451059] Node 0 DMA32 per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.451104] CPU    0: hi:  186, btch:  31 usd: 165
Aug  4 21:51:14 bkp010 kernel: [661831.451149] CPU    1: hi:  186, btch:  31 usd:  37
Aug  4 21:51:14 bkp010 kernel: [661831.451194] CPU    2: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451240] CPU    3: hi:  186, btch:  31 usd:  41
Aug  4 21:51:14 bkp010 kernel: [661831.451285] CPU    4: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451330] CPU    5: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451376] CPU    6: hi:  186, btch:  31 usd:   0
Aug  4 21:51:14 bkp010 kernel: [661831.451421] CPU    7: hi:  186, btch:  31 usd: 172
Aug  4 21:51:14 bkp010 kernel: [661831.451466] Node 0 Normal per-cpu:
Aug  4 21:51:14 bkp010 kernel: [661831.451510] CPU    0: hi:  186, btch:  31 usd: 181
Aug  4 21:51:14 bkp010 kernel: [661831.451556] CPU    1: hi:  186, btch:  31 usd:  64
Aug  4 21:51:14 bkp010 kernel: [661831.451601] CPU    2: hi:  186, btch:  31 usd:  60
Aug  4 21:51:14 bkp010 kernel: [661831.451647] CPU    3: hi:  186, btch:  31 usd:  84
Aug  4 21:51:14 bkp010 kernel: [661831.451692] CPU    4: hi:  186, btch:  31 usd:  90
Aug  4 21:51:14 bkp010 kernel: [661831.451737] CPU    5: hi:  186, btch:  31 usd:  66
Aug  4 21:51:14 bkp010 kernel: [661831.451783] CPU    6: hi:  186, btch:  31 usd:  20
Aug  4 21:51:14 bkp010 kernel: [661831.451828] CPU    7: hi:  186, btch:  31 usd: 209
Aug  4 21:51:14 bkp010 kernel: [661831.451875] active_anon:49535 inactive_anon:56858 isolated_anon:0
Aug  4 21:51:14 bkp010 kernel: [661831.451875]  active_file:12576 inactive_file:14654 isolated_file:0
Aug  4 21:51:14 bkp010 kernel: [661831.451875]  unevictable:0 dirty:4574 writeback:17362 unstable:0
Aug  4 21:51:14 bkp010 kernel: [661831.451875]  free:34697 slab_reclaimable:1154786 slab_unreclaimable:18894
Aug  4 21:51:14 bkp010 kernel: [661831.451875]  mapped:1456 shmem:169 pagetables:3293 bounce:0
Aug  4 21:51:14 bkp010 kernel: [661831.451875]  free_cma:0
Aug  4 21:51:14 bkp010 kernel: [661831.452149] Node 0 DMA free:15900kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Aug  4 21:51:14 bkp010 kernel: [661831.452432] lowmem_reserve[]: 0 3174 31846 31846
Aug  4 21:51:14 bkp010 kernel: [661831.452479] Node 0 DMA32 free:115512kB min:2276kB low:2844kB high:3412kB active_anon:56kB inactive_anon:28672kB active_file:31172kB inactive_file:32536kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3334376kB managed:3250672kB mlocked:0kB dirty:144kB writeback:0kB mapped:1184kB shmem:0kB slab_reclaimable:1883292kB slab_unreclaimable:14256kB kernel_stack:80kB pagetables:20kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:9 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.452806] lowmem_reserve[]: 0 0 28672 28672
Aug  4 21:51:14 bkp010 kernel: [661831.452853] Node 0 Normal free:7376kB min:20560kB low:25700kB high:30840kB active_anon:198084kB inactive_anon:198760kB active_file:19132kB inactive_file:26080kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:29882368kB managed:29360436kB mlocked:0kB dirty:18152kB writeback:69448kB mapped:4640kB shmem:676kB slab_reclaimable:2735852kB slab_unreclaimable:61320kB kernel_stack:3984kB pagetables:13152kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:311 all_unreclaimable? no
Aug  4 21:51:14 bkp010 kernel: [661831.453182] lowmem_reserve[]: 0 0 0 0
Aug  4 21:51:14 bkp010 kernel: [661831.453230] swapper/7: page allocation failure: order:0, mode:0x20
Aug  4 21:51:14 bkp010 kernel: [661831.453231] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.10.0 #3
Aug  4 21:51:14 bkp010 kernel: [661831.453231] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
Aug  4 21:51:14 bkp010 kernel: [661831.453233]  0000000000000020 ffff88081fbc3b88 ffffffff81371348 ffff88081fbc3c18
Aug  4 21:51:14 bkp010 kernel: [661831.453235]  ffffffff810a5629 ffff880700000000 ffff88081fa51780 ffff88081fbc3bc8
Aug  4 21:51:14 bkp010 kernel: [661831.453236]  ffff88081fdd9a00 ffff88081fdd9a38 0000000100000000 0000000000000000


-- 
Tomasz Chmielewski
http://wpkg.org
