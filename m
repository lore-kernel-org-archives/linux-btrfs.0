Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41512 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAQCDW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 21:03:22 -0500
Received: by mail-ob0-f172.google.com with SMTP id vb8so3675810obc.17
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 18:03:21 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 20:03:21 -0600
Message-ID: <CAKcLGm-jEdSB+RwA_p_DhRzH947+d7Rr_sCgEqLMO_=3n6OKeQ@mail.gmail.com>
Subject: btrfs-endio-wri: page allocation failure
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I received a btrfs page allocation failure on my 3.12.7 kernel which
is merged with Chris' for-linus branch for the 3.13_rc kernel.

I have several btrfs partitions mounted, but I believe this error is
on my btrfs root partition.

Several things were going on at the same time on this partition.  I
have a snapshot script creating and deleting snapshots of the root
partition.  I was also compiling an application, and running Firefox.

I know the snapshots may be a problem area.  The snapshot script is
currently running with about 550 snapshots of the root partition.  It
adds snapshots every 180 seconds, and removes the oldest snapshots
based on available disk space.

So far, I haven't encountered a crash.

Since this is my root partition, I'll have to reboot to check for corruption.

[111575.089533] btrfs-endio-wri: page allocation failure: order:4, mode:0x104050
[111575.089543] CPU: 1 PID: 14414 Comm: btrfs-endio-wri Tainted: G
    C   3.12.7-git-local #1
[111575.089546] Hardware name: Dell Inc.                 OptiPlex 745
               /0WF810, BIOS 2.6.4  03/01/2010
[111575.089550]  0000000000104050 ffff88007484f6f8 ffffffff81642878
ffff88007f30eaf8
[111575.089556]  0000000000000001 ffff88007484f788 ffffffff810d27cd
ffffffff81ca5d28
[111575.089561]  0000000000000010 ffff8800fffffff0 ffffffff810d4c86
ffff880000000040
[111575.089566] Call Trace:
[111575.089578]  [<ffffffff81642878>] dump_stack+0x46/0x58
[111575.089584]  [<ffffffff810d27cd>] warn_alloc_failed+0x115/0x129
[111575.089589]  [<ffffffff810d4c86>] ? drain_local_pages+0x16/0x18
[111575.089594]  [<ffffffff810d5145>] __alloc_pages_nodemask+0x47a/0x84d
[111575.089620]  [<ffffffffa018dd01>] ? balance_level+0x666/0x6e8 [btrfs]
[111575.089626]  [<ffffffff810d552f>] __get_free_pages+0x17/0x44
[111575.089631]  [<ffffffff810e7e81>] kmalloc_order_trace+0x2e/0x90
[111575.089637]  [<ffffffff8110b1fc>] __kmalloc_track_caller+0x3f/0x12c
[111575.089653]  [<ffffffffa01f8e5c>] ? ulist_add_merge+0xe6/0x153 [btrfs]
[111575.089659]  [<ffffffff810e401e>] krealloc+0x57/0x91
[111575.089674]  [<ffffffffa01f8e5c>] ulist_add_merge+0xe6/0x153 [btrfs]
[111575.089689]  [<ffffffffa01f7b8b>] find_parent_nodes+0x494/0x57e [btrfs]
[111575.089705]  [<ffffffffa01f7d12>] btrfs_find_all_roots+0x81/0xdc [btrfs]
[111575.089721]  [<ffffffffa01f8589>] iterate_extent_inodes+0x12f/0x2c4 [btrfs]
[111575.089737]  [<ffffffffa01aec83>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[111575.089754]  [<ffffffffa01aec83>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[111575.089770]  [<ffffffffa01f87a2>]
iterate_inodes_from_logical+0x84/0x9a [btrfs]
[111575.089787]  [<ffffffffa01aec3c>] record_extent_backrefs+0x60/0xa7 [btrfs]
[111575.089804]  [<ffffffffa01b7515>]
btrfs_finish_ordered_io+0x780/0x87d [btrfs]
[111575.089809]  [<ffffffff810d09cf>] ? mempool_free_slab+0x17/0x19
[111575.089826]  [<ffffffffa01b7627>] finish_ordered_fn+0x15/0x17 [btrfs]
[111575.089843]  [<ffffffffa01d3153>] worker_loop+0x13d/0x4a2 [btrfs]
[111575.089860]  [<ffffffffa01d3016>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[111575.089865]  [<ffffffff81053779>] kthread+0xba/0xc2
[111575.089870]  [<ffffffff810536bf>] ? kthread_freezable_should_stop+0x4d/0x4d
[111575.089875]  [<ffffffff81649dac>] ret_from_fork+0x7c/0xb0
[111575.089879]  [<ffffffff810536bf>] ? kthread_freezable_should_stop+0x4d/0x4d
[111575.089882] Mem-Info:
[111575.089884] DMA per-cpu:
[111575.089887] CPU    0: hi:    0, btch:   1 usd:   0
[111575.089890] CPU    1: hi:    0, btch:   1 usd:   0
[111575.089892] DMA32 per-cpu:
[111575.089895] CPU    0: hi:  186, btch:  31 usd:  27
[111575.089897] CPU    1: hi:  186, btch:  31 usd:   0
[111575.089904] active_anon:169762 inactive_anon:52853 isolated_anon:0
 active_file:115654 inactive_file:114252 isolated_file:0
 unevictable:0 dirty:1795 writeback:0 unstable:0
 free:22811 slab_reclaimable:19321 slab_unreclaimable:4379
 mapped:15644 shmem:10186 pagetables:1982 bounce:0
 free_cma:0
[111575.089918] DMA free:8264kB min:352kB low:440kB high:528kB
active_anon:1496kB inactive_anon:1556kB active_file:1680kB
inactive_file:1692kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15992kB managed:15968kB mlocked:0kB
dirty:0kB writeback:0kB mapped:640kB shmem:300kB
slab_reclaimable:420kB slab_unreclaimable:128kB kernel_stack:24kB
pagetables:88kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[111575.089920] lowmem_reserve[]: 0 1971 1971 1971
[111575.089932] DMA32 free:82980kB min:44700kB low:55872kB
high:67048kB active_anon:677552kB inactive_anon:209856kB
active_file:460936kB inactive_file:455316kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2070524kB
managed:2022852kB mlocked:0kB dirty:7180kB writeback:0kB
mapped:61936kB shmem:40444kB slab_reclaimable:76864kB
slab_unreclaimable:17388kB kernel_stack:2032kB pagetables:7840kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[111575.089935] lowmem_reserve[]: 0 0 0 0
[111575.089940] DMA: 32*4kB (UEM) 32*8kB (UE) 11*16kB (U) 5*32kB (UEM)
14*64kB (M) 8*128kB (UEM) 4*256kB (UEM) 1*512kB (U) 2*1024kB (EM)
1*2048kB (R) 0*4096kB = 8272kB
[111575.089961] DMA32: 10450*4kB (UER) 4299*8kB (UEMR) 165*16kB (UMR)
15*32kB (UMR) 1*64kB (R) 2*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R)
1*2048kB (R) 0*4096kB = 82960kB
[111575.089983] Node 0 hugepages_total=0 hugepages_free=0
hugepages_surp=0 hugepages_size=2048kB
[111575.089985] 242598 total pagecache pages
[111575.089988] 2506 pages in swap cache
[111575.089991] Swap cache stats: add 295632, delete 293125, find 110292/128851
[111575.089993] Free swap  = 2576720kB
[111575.089995] Total swap = 2621428kB
[111575.098764] 521726 pages RAM
[111575.098768] 12022 pages reserved
[111575.098770] 528583 pages shared
[111575.098773] 332468 pages non-shared
[111711.740595] BTRFS debug (device sda3): unlinked 1 orphans
