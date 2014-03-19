Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46636 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191AbaCSPpO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 11:45:14 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WQIg6-00010P-2g
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Mar 2014 08:45:14 -0700
Date: Wed, 19 Mar 2014 08:45:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Message-ID: <20140319154513.GQ6143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My server died last night during a btrfs send/receive to a btrfs radi5 array

Here are the logs. Is this anything known or with a possible workaround?

Thanks,
Marc

btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
CPU: 1 PID: 12499 Comm: btrfs-rmw-2 Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88000549d780 ffffffff816090b3 0000000000000000
 ffff88000549d808 ffffffff811037b0 00000001fffffffe ffff88007ff7ce00
 0000000000000000 0000000200000000 0000003000000000 ffff88007ff7ce00
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff811037b0>] warn_alloc_failed+0x111/0x125
 [<ffffffff81106cb2>] __alloc_pages_nodemask+0x707/0x854
 [<ffffffff81014650>] ? dma_generic_alloc_coherent+0xa7/0x11c
 [<ffffffff81014650>] dma_generic_alloc_coherent+0xa7/0x11c
 [<ffffffff811354e8>] dma_pool_alloc+0x10a/0x1cb
 [<ffffffffa0084aa0>] mvs_task_prep+0x192/0xa42 [mvsas]
 [<ffffffff812f9fa2>] ? blkg_path.isra.80.constprop.90+0x17/0x38
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffffa00853ad>] mvs_task_exec.isra.9+0x5d/0xc9 [mvsas]
 [<ffffffffa0085a76>] mvs_queue_command+0x3d/0x29b [mvsas]
 [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
 [<ffffffffa0064d1c>] sas_ata_qc_issue+0x1cd/0x235 [libsas]
 [<ffffffff814a9598>] ata_qc_issue+0x291/0x2f1
 [<ffffffff814af413>] ? ata_scsiop_mode_sense+0x29c/0x29c
 [<ffffffff814b049e>] __ata_scsi_queuecmd+0x184/0x1e0
 [<ffffffff814b05a5>] ata_sas_queuecmd+0x31/0x4d
 [<ffffffffa00637ba>] sas_queuecommand+0x98/0x1fe [libsas]
 [<ffffffff8148fdee>] scsi_dispatch_cmd+0x14f/0x22e
 [<ffffffff814964da>] scsi_request_fn+0x4da/0x507
 [<ffffffff812e512c>] ? blk_recount_segments+0x1e/0x2e
 [<ffffffff812e01a3>] __blk_run_queue_uncond+0x22/0x2b
 [<ffffffff812e01c5>] __blk_run_queue+0x19/0x1b
 [<ffffffff812e1c74>] blk_queue_bio+0x23f/0x256
 [<ffffffff812df92c>] generic_make_request+0x9c/0xdb
 [<ffffffff812dfa7d>] submit_bio+0x112/0x131
 [<ffffffff8128274c>] rmw_work+0x112/0x162
 [<ffffffff8125073f>] worker_loop+0x168/0x4d8
 [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 171
CPU    1: hi:  186, btch:  31 usd: 190
active_anon:17298 inactive_anon:21061 isolated_anon:0
 active_file:67491 inactive_file:94189 isolated_file:32
 unevictable:1260 dirty:38914 writeback:49596 unstable:0
 free:15999 slab_reclaimable:8198 slab_unreclaimable:9741
 mapped:12981 shmem:1661 pagetables:2711 bounce:0
 free_cma:0
Node 0 DMA free:8084kB min:348kB low:432kB high:520kB active_anon:360kB inactive_anon:764kB active_file:288kB inactive_file:2040kB unevictable:100kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:100kB dirty:0kB writeback:1272kB mapped:252kB shmem:8kB slab_reclaimable:168kB slab_unreclaimable:336kB kernel_stack:88kB pagetables:128kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1987 1987 1987
Node 0 DMA32 free:56080kB min:44704kB low:55880kB high:67056kB active_anon:68832kB inactive_anon:83480kB active_file:269676kB inactive_file:374588kB unevictable:4940kB isolated(anon):0kB isolated(file):128kB present:2080256kB managed:2039064kB mlocked:4940kB dirty:155668kB writeback:197112kB mapped:51672kB shmem:6636kB slab_reclaimable:32624kB slab_unreclaimable:38628kB kernel_stack:2912kB pagetables:10716kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 85*4kB (UEM) 22*8kB (UEM) 62*16kB (UEM) 6*32kB (UM) 2*64kB (UE) 5*128kB (UEM) 6*256kB (UEM) 4*512kB (EM) 0*1024kB 1*2048kB (R) 0*4096kB = 8100kB
Node 0 DMA32: 13004*4kB (M) 16*8kB (M) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 56240kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
164139 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 9255932kB
Total swap = 9255932kB
524058 pages RAM
0 pages HighMem/MovableOnly
10298 pages reserved
0 pages hwpoisoned
mvsas 0000:01:00.0: mvsas prep failed[0]!
btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
CPU: 1 PID: 12499 Comm: btrfs-rmw-2 Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88000549d690 ffffffff816090b3 0000000000000000
 ffff88000549d718 ffffffff811037b0 00000001fffffffe ffff88000549d6c8
 ffffffff8160e9c4 0000000200000000 0000003000000000 ffff88007ff7ce00
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff811037b0>] warn_alloc_failed+0x111/0x125
 [<ffffffff8160e9c4>] ? _raw_spin_trylock+0x20/0x50
 [<ffffffff81106cb2>] __alloc_pages_nodemask+0x707/0x854
 [<ffffffff81093ce9>] ? console_unlock+0x2f6/0x302
 [<ffffffff81014650>] dma_generic_alloc_coherent+0xa7/0x11c
 [<ffffffff811354e8>] dma_pool_alloc+0x10a/0x1cb
 [<ffffffffa0084aa0>] mvs_task_prep+0x192/0xa42 [mvsas]
 [<ffffffff811063d7>] ? get_page_from_freelist+0x549/0x71d
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffffa00853ad>] mvs_task_exec.isra.9+0x5d/0xc9 [mvsas]
 [<ffffffffa0085a76>] mvs_queue_command+0x3d/0x29b [mvsas]
 [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
 [<ffffffffa0064d1c>] sas_ata_qc_issue+0x1cd/0x235 [libsas]
 [<ffffffff814a9598>] ata_qc_issue+0x291/0x2f1
 [<ffffffff814af413>] ? ata_scsiop_mode_sense+0x29c/0x29c
 [<ffffffff814b049e>] __ata_scsi_queuecmd+0x184/0x1e0
 [<ffffffff814b05a5>] ata_sas_queuecmd+0x31/0x4d
 [<ffffffffa00637ba>] sas_queuecommand+0x98/0x1fe [libsas]
 [<ffffffff8148fdee>] scsi_dispatch_cmd+0x14f/0x22e
 [<ffffffff814964da>] scsi_request_fn+0x4da/0x507
 [<ffffffff812e01a3>] __blk_run_queue_uncond+0x22/0x2b
 [<ffffffff812e01c5>] __blk_run_queue+0x19/0x1b
 [<ffffffff812fc16d>] cfq_insert_request+0x391/0x3b5
 [<ffffffff812e002f>] ? perf_trace_block_rq_with_error+0x45/0x14f
 [<ffffffff812e512c>] ? blk_recount_segments+0x1e/0x2e
 [<ffffffff812dc08c>] __elv_add_request+0x1fc/0x276
 [<ffffffff812e1c6c>] blk_queue_bio+0x237/0x256
 [<ffffffff812df92c>] generic_make_request+0x9c/0xdb
 [<ffffffff812dfa7d>] submit_bio+0x112/0x131
 [<ffffffff8128274c>] rmw_work+0x112/0x162
 [<ffffffff8125073f>] worker_loop+0x168/0x4d8
 [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 179
CPU    1: hi:  186, btch:  31 usd: 213
active_anon:17298 inactive_anon:21061 isolated_anon:0
 active_file:67491 inactive_file:93709 isolated_file:32
 unevictable:1260 dirty:38914 writeback:49627 unstable:0
 free:16338 slab_reclaimable:8198 slab_unreclaimable:9741
 mapped:12981 shmem:1661 pagetables:2711 bounce:0
 free_cma:0
Node 0 DMA free:8084kB min:348kB low:432kB high:520kB active_anon:360kB inactive_anon:764kB active_file:288kB inactive_file:2040kB unevictable:100kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:100kB dirty:0kB writeback:1272kB mapped:252kB shmem:8kB slab_reclaimable:168kB slab_unreclaimable:336kB kernel_stack:88kB pagetables:128kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1987 1987 1987
Node 0 DMA32 free:57352kB min:44704kB low:55880kB high:67056kB active_anon:68832kB inactive_anon:83480kB active_file:269676kB inactive_file:372680kB unevictable:4940kB isolated(anon):0kB isolated(file):116kB present:2080256kB managed:2039064kB mlocked:4940kB dirty:155668kB writeback:197236kB mapped:51672kB shmem:6636kB slab_reclaimable:32624kB slab_unreclaimable:38628kB kernel_stack:2912kB pagetables:10716kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:29 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 85*4kB (UEM) 22*8kB (UEM) 62*16kB (UEM) 6*32kB (UM) 2*64kB (UE) 5*128kB (UEM) 6*256kB (UEM) 4*512kB (EM) 0*1024kB 1*2048kB (R) 0*4096kB = 8100kB
Node 0 DMA32: 13283*4kB (M) 16*8kB (M) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 57356kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
163658 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 9255932kB
Total swap = 9255932kB
524058 pages RAM
0 pages HighMem/MovableOnly
10298 pages reserved
0 pages hwpoisoned
mvsas 0000:01:00.0: mvsas prep failed[0]!
btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
CPU: 1 PID: 12499 Comm: btrfs-rmw-2 Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88000549d780 ffffffff816090b3 0000000000000000
 ffff88000549d808 ffffffff811037b0 00000001fffffffe ffff880000000000
 0000000000000046 0000000200000000 0000003000000000 ffff88007ff7ce00
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff811037b0>] warn_alloc_failed+0x111/0x125
 [<ffffffff81106cb2>] __alloc_pages_nodemask+0x707/0x854
 [<ffffffff811063d7>] ? get_page_from_freelist+0x549/0x71d
 [<ffffffff81014650>] dma_generic_alloc_coherent+0xa7/0x11c
 [<ffffffff811354e8>] dma_pool_alloc+0x10a/0x1cb
 [<ffffffffa0084aa0>] mvs_task_prep+0x192/0xa42 [mvsas]
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffffa00853ad>] mvs_task_exec.isra.9+0x5d/0xc9 [mvsas]
 [<ffffffffa0085a76>] mvs_queue_command+0x3d/0x29b [mvsas]
 [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
 [<ffffffffa0064d1c>] sas_ata_qc_issue+0x1cd/0x235 [libsas]
 [<ffffffff814a9598>] ata_qc_issue+0x291/0x2f1
 [<ffffffff814af413>] ? ata_scsiop_mode_sense+0x29c/0x29c
 [<ffffffff814b049e>] __ata_scsi_queuecmd+0x184/0x1e0
 [<ffffffff814b05a5>] ata_sas_queuecmd+0x31/0x4d
 [<ffffffffa00637ba>] sas_queuecommand+0x98/0x1fe [libsas]
 [<ffffffff8148fdee>] scsi_dispatch_cmd+0x14f/0x22e
 [<ffffffff814964da>] scsi_request_fn+0x4da/0x507
 [<ffffffff812e512c>] ? blk_recount_segments+0x1e/0x2e
 [<ffffffff812e01a3>] __blk_run_queue_uncond+0x22/0x2b
 [<ffffffff812e01c5>] __blk_run_queue+0x19/0x1b
 [<ffffffff812e1c74>] blk_queue_bio+0x23f/0x256
 [<ffffffff812df92c>] generic_make_request+0x9c/0xdb
 [<ffffffff812dfa7d>] submit_bio+0x112/0x131
 [<ffffffff8128274c>] rmw_work+0x112/0x162
 [<ffffffff8125073f>] worker_loop+0x168/0x4d8
 [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 169
CPU    1: hi:  186, btch:  31 usd: 185
active_anon:17298 inactive_anon:21061 isolated_anon:0
 active_file:67491 inactive_file:93277 isolated_file:32
 unevictable:1260 dirty:38914 writeback:49627 unstable:0
 free:16250 slab_reclaimable:8198 slab_unreclaimable:9762
 mapped:12981 shmem:1661 pagetables:2711 bounce:0
 free_cma:0
Node 0 DMA free:8080kB min:348kB low:432kB high:520kB active_anon:360kB inactive_anon:764kB active_file:288kB inactive_file:1980kB unevictable:100kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:100kB dirty:0kB writeback:1272kB mapped:252kB shmem:8kB slab_reclaimable:168kB slab_unreclaimable:336kB kernel_stack:88kB pagetables:128kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1987 1987 1987
Node 0 DMA32 free:56920kB min:44704kB low:55880kB high:67056kB active_anon:68832kB inactive_anon:83480kB active_file:269676kB inactive_file:371128kB unevictable:4940kB isolated(anon):0kB isolated(file):128kB present:2080256kB managed:2039064kB mlocked:4940kB dirty:155668kB writeback:197236kB mapped:51672kB shmem:6636kB slab_reclaimable:32624kB slab_unreclaimable:38712kB kernel_stack:2912kB pagetables:10716kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:160 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 86*4kB (UEM) 19*8kB (UEM) 62*16kB (UEM) 6*32kB (UM) 2*64kB (UE) 5*128kB (UEM) 6*256kB (UEM) 4*512kB (EM) 0*1024kB 1*2048kB (R) 0*4096kB = 8080kB
Node 0 DMA32: 13210*4kB (M) 6*8kB (M) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 56984kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
163317 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 9255932kB
Total swap = 9255932kB
524058 pages RAM
0 pages HighMem/MovableOnly
10298 pages reserved
0 pages hwpoisoned
mvsas 0000:01:00.0: mvsas prep failed[0]!
btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
CPU: 1 PID: 12499 Comm: btrfs-rmw-2 Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88000549d780 ffffffff816090b3 0000000000000000
 ffff88000549d808 ffffffff811037b0 00000001fffffffe ffffffff00000029
 ffffffff81e8fe40 0000000200000000 0000003000000000 ffff88007ff7ce00
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff811037b0>] warn_alloc_failed+0x111/0x125
 [<ffffffff81106cb2>] __alloc_pages_nodemask+0x707/0x854
 [<ffffffff81014650>] dma_generic_alloc_coherent+0xa7/0x11c
 [<ffffffff811354e8>] dma_pool_alloc+0x10a/0x1cb
 [<ffffffffa0084aa0>] mvs_task_prep+0x192/0xa42 [mvsas]
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffffa00853ad>] mvs_task_exec.isra.9+0x5d/0xc9 [mvsas]
 [<ffffffffa0085a76>] mvs_queue_command+0x3d/0x29b [mvsas]
 [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
 [<ffffffffa0064d1c>] sas_ata_qc_issue+0x1cd/0x235 [libsas]
 [<ffffffff814a9598>] ata_qc_issue+0x291/0x2f1
 [<ffffffff814af413>] ? ata_scsiop_mode_sense+0x29c/0x29c
 [<ffffffff814b049e>] __ata_scsi_queuecmd+0x184/0x1e0
 [<ffffffff814b05a5>] ata_sas_queuecmd+0x31/0x4d
 [<ffffffffa00637ba>] sas_queuecommand+0x98/0x1fe [libsas]
 [<ffffffff8148fdee>] scsi_dispatch_cmd+0x14f/0x22e
 [<ffffffff814964da>] scsi_request_fn+0x4da/0x507
 [<ffffffff812e512c>] ? blk_recount_segments+0x1e/0x2e
 [<ffffffff812e01a3>] __blk_run_queue_uncond+0x22/0x2b
 [<ffffffff812e01c5>] __blk_run_queue+0x19/0x1b
 [<ffffffff812e1c74>] blk_queue_bio+0x23f/0x256
 [<ffffffff812df92c>] generic_make_request+0x9c/0xdb
 [<ffffffff812dfa7d>] submit_bio+0x112/0x131
 [<ffffffff8128274c>] rmw_work+0x112/0x162
 [<ffffffff8125073f>] worker_loop+0x168/0x4d8
 [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 169
CPU    1: hi:  186, btch:  31 usd: 185
active_anon:17298 inactive_anon:21061 isolated_anon:0
 active_file:67491 inactive_file:93298 isolated_file:0
 unevictable:1260 dirty:38914 writeback:49627 unstable:0
 free:16250 slab_reclaimable:8198 slab_unreclaimable:9762
 mapped:12981 shmem:1661 pagetables:2711 bounce:0
 free_cma:0
Node 0 DMA free:8080kB min:348kB low:432kB high:520kB active_anon:360kB inactive_anon:764kB active_file:288kB inactive_file:1980kB unevictable:100kB isolated(anon):0kB isolated(file):0kB present:15976kB managed:15892kB mlocked:100kB dirty:0kB writeback:1272kB mapped:252kB shmem:8kB slab_reclaimable:168kB slab_unreclaimable:336kB kernel_stack:88kB pagetables:128kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1987 1987 1987
Node 0 DMA32 free:56920kB min:44704kB low:55880kB high:67056kB active_anon:68832kB inactive_anon:83480kB active_file:269676kB inactive_file:371212kB unevictable:4940kB isolated(anon):0kB isolated(file):0kB present:2080256kB managed:2039064kB mlocked:4940kB dirty:155668kB writeback:197236kB mapped:51672kB shmem:6636kB slab_reclaimable:32624kB slab_unreclaimable:38712kB kernel_stack:2912kB pagetables:10716kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:544 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 86*4kB (UEM) 19*8kB (UEM) 62*16kB (UEM) 6*32kB (UM) 2*64kB (UE) 5*128kB (UEM) 6*256kB (UEM) 4*512kB (EM) 0*1024kB 1*2048kB (R) 0*4096kB = 8080kB
Node 0 DMA32: 13210*4kB (M) 6*8kB (M) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 56984kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
163317 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 9255932kB
Total swap = 9255932kB
524058 pages RAM
0 pages HighMem/MovableOnly
10298 pages reserved
0 pages hwpoisoned


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
