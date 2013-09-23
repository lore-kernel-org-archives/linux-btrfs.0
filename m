Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55501 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab3IWAw4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 20:52:56 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 00BFE3518FF
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 02:45:12 +0200 (CEST)
Received: from localhost (unknown [183.182.118.232])
	by mail.virtall.com (Postfix) with ESMTPSA id 325F83518EE
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 02:45:09 +0200 (CEST)
Date: Mon, 23 Sep 2013 07:43:44 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs: qgroup scan failed with -12
Message-ID: <20130923074344.60f629d7@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure if it's anything interesting - I had the following entry in
dmesg a few days ago, on a server with 32 GB RAM. The system is still working fine.

[1878432.675210] btrfs-qgroup-re: page allocation failure: order:5, mode:0x104050
[1878432.675319] CPU: 5 PID: 22251 Comm: btrfs-qgroup-re Not tainted 3.11.0-rc7 #2
[1878432.675417] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
[1878432.675517]  0000000000104050 ffff88062a981948 ffffffff81378c52 ffff88083fb4d958
[1878432.675618]  0000000000000001 ffff88062a9819d8 ffffffff810af9a4 0000000000000000
[1878432.675721]  ffffffff817c8100 ffff88062a981978 ffff88083fddea00 ffff88083fddea38
[1878432.675821] Call Trace:
[1878432.675874]  [<ffffffff81378c52>] dump_stack+0x46/0x58
[1878432.675927]  [<ffffffff810af9a4>] warn_alloc_failed+0x110/0x124
[1878432.675981]  [<ffffffff810b1fd8>] __alloc_pages_nodemask+0x6a4/0x793
[1878432.676036]  [<ffffffff810db7e8>] alloc_pages_current+0xc8/0xe5
[1878432.676098]  [<ffffffff810af06c>] __get_free_pages+0x9/0x36
[1878432.676150]  [<ffffffff810e27b9>] __kmalloc_track_caller+0x35/0x163
[1878432.676204]  [<ffffffff810bde12>] krealloc+0x52/0x8c
[1878432.676265]  [<ffffffffa036cdcb>] ulist_add_merge+0xe1/0x14e [btrfs]
[1878432.676324]  [<ffffffffa036bcf0>] find_parent_nodes+0x49c/0x5a5 [btrfs]
[1878432.676383]  [<ffffffffa036be75>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[1878432.676441]  [<ffffffffa036d6e1>] ? qgroup_account_ref_step1+0xea/0x102 [btrfs]
[1878432.676542]  [<ffffffffa036d915>] btrfs_qgroup_rescan_worker+0x21c/0x516 [btrfs]
[1878432.676645]  [<ffffffffa03482cc>] worker_loop+0x15e/0x48e [btrfs]
[1878432.676702]  [<ffffffffa034816e>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[1878432.676757]  [<ffffffff8104e51a>] kthread+0xb5/0xbd
[1878432.676809]  [<ffffffff8104e465>] ? kthread_freezable_should_stop+0x43/0x43
[1878432.676881]  [<ffffffff8137da2c>] ret_from_fork+0x7c/0xb0
[1878432.676950]  [<ffffffff8104e465>] ? kthread_freezable_should_stop+0x43/0x43
[1878432.677004] Mem-Info:
[1878432.678293] Node 0 DMA per-cpu:
[1878432.678341] CPU    0: hi:    0, btch:   1 usd:   0
[1878432.678392] CPU    1: hi:    0, btch:   1 usd:   0
[1878432.678443] CPU    2: hi:    0, btch:   1 usd:   0
[1878432.678494] CPU    3: hi:    0, btch:   1 usd:   0
[1878432.678544] CPU    4: hi:    0, btch:   1 usd:   0
[1878432.678595] CPU    5: hi:    0, btch:   1 usd:   0
[1878432.678646] CPU    6: hi:    0, btch:   1 usd:   0
[1878432.678697] CPU    7: hi:    0, btch:   1 usd:   0
[1878432.678747] Node 0 DMA32 per-cpu:
[1878432.678797] CPU    0: hi:  186, btch:  31 usd:   0
[1878432.678847] CPU    1: hi:  186, btch:  31 usd:   0
[1878432.678897] CPU    2: hi:  186, btch:  31 usd:   0
[1878432.678948] CPU    3: hi:  186, btch:  31 usd:   0
[1878432.678998] CPU    4: hi:  186, btch:  31 usd:   0
[1878432.679049] CPU    5: hi:  186, btch:  31 usd:   0
[1878432.679111] CPU    6: hi:  186, btch:  31 usd:   0
[1878432.679162] CPU    7: hi:  186, btch:  31 usd:   2
[1878432.679214] Node 0 Normal per-cpu:
[1878432.679270] CPU    0: hi:  186, btch:  31 usd:  31
[1878432.679321] CPU    1: hi:  186, btch:  31 usd:   0
[1878432.679372] CPU    2: hi:  186, btch:  31 usd:   0
[1878432.679444] CPU    3: hi:  186, btch:  31 usd:   0
[1878432.679495] CPU    4: hi:  186, btch:  31 usd:   0
[1878432.679546] CPU    5: hi:  186, btch:  31 usd:   0
[1878432.679596] CPU    6: hi:  186, btch:  31 usd:  30
[1878432.679647] CPU    7: hi:  186, btch:  31 usd: 169
[1878432.679700] active_anon:1062992 inactive_anon:522620 isolated_anon:0
[1878432.679700]  active_file:1050823 inactive_file:1052143 isolated_file:0
[1878432.679700]  unevictable:5892 dirty:1004 writeback:0 unstable:0
[1878432.679700]  free:2184567 slab_reclaimable:1142980 slab_unreclaimable:86405
[1878432.679700]  mapped:754301 shmem:9119 pagetables:21518 bounce:0
[1878432.679700]  free_cma:0
[1878432.680007] Node 0 DMA free:15360kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[1878432.680322] lowmem_reserve[]: 0 2897 32077 32077
[1878432.680375] Node 0 DMA32 free:417660kB min:2068kB low:2584kB high:3100kB active_anon:4384kB inactive_anon:59696kB active_file:45640kB inactive_file:45652kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3040872kB managed:2968600kB mlocked:0kB dirty:4kB writeback:0kB mapped:224kB shmem:324kB slab_reclaimable:2333732kB slab_unreclaimable:59700kB kernel_stack:8kB pagetables:1708kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:4 all_unreclaimable? no
[1878432.680771] lowmem_reserve[]: 0 0 29180 29180
[1878432.680831] Node 0 Normal free:8305248kB min:20844kB low:26052kB high:31264kB active_anon:4247584kB inactive_anon:2030784kB active_file:4157652kB inactive_file:4162920kB unevictable:23568kB isolated(anon):0kB isolated(file):0kB present:30406656kB managed:29880648kB mlocked:23568kB dirty:4012kB writeback:0kB mapped:3016980kB shmem:36152kB slab_reclaimable:2238188kB slab_unreclaimable:285920kB kernel_stack:3328kB pagetables:84364kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1878432.681207] lowmem_reserve[]: 0 0 0 0
[1878432.681258] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15360kB
[1878432.681371] Node 0 DMA32: 19878*4kB (UEM) 18133*8kB (UEM) 12056*16kB (UEM) 1*32kB (U) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 417504kB
[1878432.681486] Node 0 Normal: 544554*4kB (EM) 536220*8kB (UEM) 114800*16kB (UM) 1*32kB (M) 2*64kB (R) 2*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 8306472kB
[1878432.681649] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[1878432.681747] 2186705 total pagecache pages
[1878432.681797] 73757 pages in swap cache
[1878432.681846] Swap cache stats: add 8877981, delete 8804224, find 97677523/98270314
[1878432.681943] Free swap  = 32338688kB
[1878432.681992] Total swap = 33553332kB
[1878432.762593] 8388095 pages RAM
[1878432.762659] 171943 pages reserved
[1878432.762716] 4144353 pages shared
[1878432.762764] 3906447 pages non-shared
[1878432.762841] btrfs: qgroup scan failed with -12


-- 
Tomasz Chmielewski

