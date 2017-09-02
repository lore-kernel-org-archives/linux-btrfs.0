Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54440 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752697AbdIBQJ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Sep 2017 12:09:56 -0400
Date: Sat, 2 Sep 2017 09:09:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170902160942.imo2hotpur3pnops@merlins.org>
References: <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
 <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
 <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 11:01:30PM +0000, Josef Bacik wrote:
> You'll be fine, it's only happening on the one fs right?  That's 13gib of metadata with checksums and all that shit, it'll probably look like 8 or 9gib of ram worst case.  I'd mount with -o ref_verify and check the slab amount in /proc/meminfo to get an idea of real usage.  Once the mount is finished that'll be about as much metadata you will use, of course it'll grow as metadata usage grows but it should be nominal.  Thanks,

Looks like I don't have enough RAM :(

[   80.964838] BTRFS info (device dm-2): bdev /dev/mapper/dshelf1 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[ 1382.968986]Tbcache_writebaceinvoked oom-killer:dgfp_mask=0x14000c0(GFP_KERNEL), nodemask=(null),  order=0, oom_score_adj=0
[ 1383.003255] bcache_writebac cpuset=/ mems_allowed=0
[ 1383.018947] CPU: 6 PID: 2359 Comm: bcache_writebac Tainted: G     U		4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1383.052448] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1383.080911] Call Trace:
[ 1383.089336]	dump_stack+0x61/0x7d
[ 1383.100132]	dump_header+0x97/0x239
[ 1383.111354]	? _raw_spin_unlock_irqrestore+0x14/0x24
[ 1383.127322]	oom_kill_process+0x86/0x379
[ 1383.140208]	out_of_memory+0x3b8/0x416
[ 1383.152581]	__alloc_pages_slowpath+0x890/0xa55
[ 1383.166960]	? _raw_spin_unlock_irq+0x11/0x21
[ 1383.180806]	__alloc_pages_nodemask+0x141/0x1f5
[ 1383.195144]	alloc_pages_current+0x8d/0x96
[ 1383.208310]	bio_alloc_pages+0x29/0x6a
[ 1383.220472]	bch_writeback_thread+0x53b/0x6ff [bcache]
[ 1383.236942]	? write_dirty+0x90/0x90 [bcache]
[ 1383.250734]	kthread+0xfb/0x100
[ 1383.261230]	? init_completion+0x24/0x24
[ 1383.273988]	? do_fast_syscall_32+0xb7/0xfe
[ 1383.287265]	ret_from_fork+0x25/0x30
[ 1383.298733] Mem-Info:
[ 1383.306446] active_anon:1 inactive_anon:3 isolated_anon:0
[ 1383.306446]	active_file:190 inactive_file:180 isolated_file:0
[ 1383.306446]	unevictable:0 dirty:0 writeback:1 unstable:0
[ 1383.306446]	slab_reclaimable:3436 slab_unreclaimable:8033273
[ 1383.306446]	mapped:1 shmem:2 pagetables:74 bounce:0
[ 1383.306446]	free:53127 free_pcp:0 free_cma:3741
[ 1383.406332] Node 0 active_anon:0kB inactive_anon:16kB active_file:896kB inactive_file:824kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:4kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[ 1383.486392] Node 0 DMA free:15880kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1383.565818] lowmem_reserve[]: 0 3201 31832 31832 31832
[ 1383.581956] Node 0 DMA32 free:121256kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:44kB inactive_file:52kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1383.665831] lowmem_reserve[]: 0 0 28631 28631 28631
[ 1383.681212] Node 0 Normal free:75372kB min:60760kB low:90092kB high:119424kB active_anon:0kB inactive_anon:16kB active_file:788kB inactive_file:836kB unevictable:0kB writepending:0kB present:29874176kB managed:29337252kB mlocked:0kB kernel_stack:8048kB pagetables:296kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:14964kB
[ 1383.769793] lowmem_reserve[]: 0 0 0 0 0
[ 1383.782429] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1383.823171] Node 0 DMA32: 4*4kB (UM) 21*8kB (UME) 9*16kB (UME) 5*32kB (ME) 5*64kB (UME) 5*128kB (UME) 6*256kB (UME) 5*512kB (UME) 5*1024kB (ME) 4*2048kB (UME) 25*4096kB (M) = 121256kB
[ 1383.874564] Node 0 Normal: 773*4kB (UMEC) 494*8kB (ME) 373*16kB (UMEC) 284*32kB (MEC) 177*64kB (UMEC) 108*128kB (UME) 36*256kB (UME) 9*512kB (UMEC) 0*1024kB 1*2048kB (C) 3*4096kB (C) = 75412kB
[ 1383.927787] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1383.954002] 467 total pagecache pages
[ 1383.965889] 3 pages in swap cache
[ 1383.976715] Swap cache stats: add 1253, delete 1250, find 21/36
[ 1383.995325] Free swap  = 15610620kB
[ 1384.006675] Total swap = 15616764kB
[ 1384.018005] 8313052 pages RAM
[ 1384.027730] 0 pages HighMem/MovableOnly
[ 1384.040076] 150644 pages reserved
[ 1384.050845] 4096 pages cma reserved
[ 1384.062127] 0 pages hwpoisoned
[ 1384.072133] [ pid ]	 uid  tgid total_vm	 rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1384.098531] [  983]	   0   983	936	   0	   6	   2	   32		  0 init
[ 1384.124971] [  984]	   0   984	941	   1	   5	   2	   98		  0 rc
[ 1384.150843] [ 1103]	   0  1103	920	   1	   5	   2	  188	      -1000 udevd
[ 1384.177534] [ 1311]	   0  1311	925	   1	   5	   2	   67	      -1000 net.agent
[ 1384.205278] [ 1352]	   0  1352	925	   1	   5	   2	   66	      -1000 net.agent
[ 1384.233017] [ 1703]	   0  1703	926	   1	   5	   2	   68	      -1000 net.agent
[ 1384.260731] [ 1935]	   0  1935	587	   0	   5	   2	   31		  0 bootlogd
[ 1384.288190] [ 2469]	   0  2469	993	   0	   5	   2	  262	      -1000 udevd
[ 1384.314846] [ 2470]	   0  2470	993	   0	   5	   2	  261	      -1000 udevd
[ 1384.341494] [ 3049]	   0  3049     1538	   1	   6	   2	  177		  0 S13mountall.sh
[ 1384.370576] [ 3125]	   0  3125     1718	   0	   7	   2	  128		  0 mount
[ 1384.397360] [15456]	   0 15456	124	   0	   3	   2	   10	      -1000 sleep
[ 1384.424026] [15457]	   0 15457	124	   0	   3	   2	   12	      -1000 sleep
[ 1384.450650] [15458]	   0 15458	124	   1	   3	   2	   10	      -1000 sleep
[ 1384.477317] Out of memory: Kill process 3049 (S13mountall.sh) score 0 or sacrifice child
[ 1384.502384] Killed process 3125 (mount) total-vm:6872kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1384.535964] oom_reaper: reaped process 3125 (mount), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[ 1384.573082] bcache_writebac invoked oom-killer: gfp_mask=0x14000c0(GFP_KERNEL), nodemask=(null),  order=0, oom_score_adj=0
[ 1384.607340] bcache_writebac cpuset=/ mems_allowed=0
[ 1384.623102] CPU: 0 PID: 2359 Comm: bcache_writebac Tainted: G     U		4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1384.656825] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1384.685361] Call Trace:
[ 1384.693823]	dump_stack+0x61/0x7d
[ 1384.704866]	dump_header+0x97/0x239
[ 1384.716086]	? _raw_spin_unlock_irqrestore+0x14/0x24
[ 1384.731697]	oom_kill_process+0x86/0x379
[ 1384.744201]	out_of_memory+0x3b8/0x416
[ 1384.756259]	__alloc_pages_slowpath+0x890/0xa55
[ 1384.770536]	? _raw_spin_unlock_irq+0x11/0x21
[ 1384.784302]	__alloc_pages_nodemask+0x141/0x1f5
[ 1384.798539]	alloc_pages_current+0x8d/0x96
[ 1384.811465]	bio_alloc_pages+0x29/0x6a
[ 1384.823334]	bch_writeback_thread+0x53b/0x6ff [bcache]
[ 1384.839334]	? write_dirty+0x90/0x90 [bcache]
[ 1384.852984]	kthread+0xfb/0x100
[ 1384.862970]	? init_completion+0x24/0x24
[ 1384.875285]	? do_fast_syscall_32+0xb7/0xfe
[ 1384.888368]	ret_from_fork+0x25/0x30
[ 1384.899696] Mem-Info:
[ 1384.907064] active_anon:0 inactive_anon:2 isolated_anon:0
[ 1384.907064]	active_file:189 inactive_file:273 isolated_file:0
[ 1384.907064]	unevictable:0 dirty:0 writeback:0 unstable:0
[ 1384.907064]	slab_reclaimable:3414 slab_unreclaimable:8053934
[ 1384.907064]	mapped:1 shmem:2 pagetables:74 bounce:0
[ 1384.907064]	free:32075 free_pcp:25 free_cma:3741
[ 1384.922833] kworker/6:1H: page allocation failure: order:0, mode:0x1284020(GFP_ATOMIC|__GFP_COMP|__GFP_NOTRACK), nodemask=(null)
[ 1384.922836] kworker/6:1H cpuset=/ mems_allowed=0
[ 1384.922840] CPU: 6 PID: 400 Comm: kworker/6:1H Tainted: G	 U	    4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1384.922841] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1384.922844] Workqueue: kblockd blk_mq_run_work_fn
[ 1384.922845] Call Trace:
[ 1384.922849]	dump_stack+0x61/0x7d
[ 1384.922851]	warn_alloc+0xfc/0x18c
[ 1384.922854]	__alloc_pages_slowpath+0x9ca/0xa55
[ 1384.922856]	? __alloc_pages_slowpath+0x9ca/0xa55
[ 1384.922858]	__alloc_pages_nodemask+0x141/0x1f5
[ 1384.922862]	cache_grow_begin+0xa4/0x294
[ 1384.922863]	fallback_alloc+0x154/0x196
[ 1384.922865]	? cache_grow_begin+0xa4/0x294
[ 1384.922867]	____cache_alloc_node+0xdd/0xe9
[ 1384.922869]	kmem_cache_alloc+0x98/0x143
[ 1384.922873]	sas_alloc_task+0x1d/0x32 [libsas]
[ 1384.922876]	sas_ata_qc_issue+0x71/0x21c [libsas]
[ 1384.922878]	ata_qc_issue+0x1fc/0x24c
[ 1384.922880]	? ata_scsi_write_same_xlat+0x2d1/0x2d1
[ 1384.922882]	__ata_scsi_queuecmd+0x18f/0x1eb
[ 1384.922883]	ata_sas_queuecmd+0x31/0x4d
[ 1384.922886]	sas_queuecommand+0x83/0x1cf [libsas]
[ 1384.922889]	? blk_add_timer+0xcb/0x10f
[ 1384.922892]	scsi_dispatch_cmd+0x141/0x210
[ 1384.922893]	scsi_queue_rq+0x1c7/0x28f
[ 1384.922895]	blk_mq_dispatch_rq_list+0x1a6/0x2cf
[ 1384.922896]	? find_next_bit+0xb/0xd
[ 1384.922899]	blk_mq_sched_dispatch_requests+0x14e/0x1e7
[ 1384.922900]	? __switch_to+0x288/0x44b
[ 1384.922911]	__blk_mq_run_hw_queue+0x4c/0x7f
[ 1384.922912]	blk_mq_run_work_fn+0x2c/0x2e
[ 1384.922913]	process_one_work+0x179/0x2a5
[ 1384.922915]	? rescuer_thread+0x273/0x273
[ 1384.922915]	worker_thread+0x1a8/0x25b
[ 1384.922917]	? rescuer_thread+0x273/0x273
[ 1384.922917]	kthread+0xfb/0x100
[ 1384.922918]	? init_completion+0x24/0x24
[ 1384.922919]	? do_fast_syscall_32+0xb7/0xfe
[ 1384.922920]	ret_from_fork+0x25/0x30
[ 1384.922922] Mem-Info:
[ 1384.922924] active_anon:0 inactive_anon:2 isolated_anon:0
[ 1384.922924]	active_file:199 inactive_file:263 isolated_file:0
[ 1384.922924]	unevictable:0 dirty:0 writeback:0 unstable:0
[ 1384.922924]	slab_reclaimable:3414 slab_unreclaimable:8055394
[ 1384.922924]	mapped:1 shmem:2 pagetables:74 bounce:0
[ 1384.922924]	free:30587 free_pcp:18 free_cma:3741
[ 1384.922926] Node 0 active_anon:0kB inactive_anon:8kB active_file:796kB inactive_file:1052kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:4kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[ 1384.922926] Node 0 DMA free:15880kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1384.922928] lowmem_reserve[]: 0 3201 31832 31832 31832
[ 1384.922930] Node 0 DMA32 free:91392kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:56kB inactive_file:56kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:72kB local_pcp:72kB free_cma:0kB
[ 1384.922932] lowmem_reserve[]: 0 0 28631 28631 28631
[ 1384.922933] Node 0 Normal free:15076kB min:60760kB low:90092kB high:119424kB active_anon:0kB inactive_anon:8kB active_file:740kB inactive_file:996kB unevictable:0kB writepending:0kB present:29874176kB managed:29337252kB mlocked:0kB kernel_stack:8048kB pagetables:296kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:14964kB
[ 1384.922935] lowmem_reserve[]: 0 0 0 0 0
[ 1384.922936] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[ 1384.922941] Node 0 DMA32: 2*4kB (UM) 3*8kB (ME) 4*16kB (UME) 5*32kB (ME) 4*64kB (ME) 4*128kB (ME) 5*256kB (ME) 4*512kB (ME) 5*1024kB (ME) 4*2048kB (UME) 18*4096kB (M) = 91392kB
[ 1384.922946] Node 0 Normal: 1*4kB (C) 0*8kB 1*16kB (C) 1*32kB (C) 1*64kB (C) 0*128kB 0*256kB 1*512kB (C) 0*1024kB 1*2048kB (C) 3*4096kB (C) = 14964kB
[ 1384.922951] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1384.922951] 464 total pagecache pages
[ 1384.922953] 0 pages in swap cache
[ 1384.922954] Swap cache stats: add 1253, delete 1253, find 21/36
[ 1384.922954] Free swap  = 15611132kB
[ 1384.922954] Total swap = 15616764kB
[ 1384.922955] 8313052 pages RAM
[ 1384.922955] 0 pages HighMem/MovableOnly
[ 1384.922955] 150644 pages reserved
[ 1384.922956] 4096 pages cma reserved
[ 1384.922956] 0 pages hwpoisoned
[ 1385.007958] ata17.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x0
[ 1385.007961] ata17.00: failed command: READ FPDMA QUEUED
[ 1385.007965] ata17.00: cmd 60/20:80:90:81:6f/00:00:35:01:00/40 tag 16 ncq dma 16384 in
[ 1385.007965]		res 40/00:78:10:2c:8d/00:00:f1:00:00/40 Emask 0x40 (internal error)
[ 1385.007966] ata17.00: status: { DRDY }
[ 1385.008982] ata17.00: Security Log not supported
[ 1385.010102] ata17.00: Security Log not supported
[ 1385.010104] ata17.00: configured for UDMA/133
[ 1385.010110] ata17: EH complete
[ 1385.010162] scsi_eh_10: page allocation failure: order:0, mode:0x1284020(GFP_ATOMIC|__GFP_COMP|__GFP_NOTRACK), nodemask=(null)
[ 1385.010164] scsi_eh_10 cpuset=/ mems_allowed=0
[ 1385.010175] CPU: 6 PID: 409 Comm: scsi_eh_10 Tainted: G     U	  4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1385.010175] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1385.010175] Call Trace:
[ 1385.010178]	dump_stack+0x61/0x7d
[ 1385.010179]	warn_alloc+0xfc/0x18c
[ 1385.010181]	__alloc_pages_slowpath+0x9ca/0xa55
[ 1385.010182]	? __alloc_pages_slowpath+0x9ca/0xa55
[ 1385.010184]	__alloc_pages_nodemask+0x141/0x1f5
[ 1385.010186]	cache_grow_begin+0xa4/0x294
[ 1385.010187]	fallback_alloc+0x154/0x196
[ 1385.010188]	? cache_grow_begin+0xa4/0x294
[ 1385.010189]	____cache_alloc_node+0xdd/0xe9
[ 1385.010191]	kmem_cache_alloc+0x98/0x143
[ 1385.010193]	sas_alloc_task+0x1d/0x32 [libsas]
[ 1385.010195]	sas_ata_qc_issue+0x71/0x21c [libsas]
[ 1385.010196]	ata_qc_issue+0x1fc/0x24c
[ 1385.010198]	? ata_scsi_write_same_xlat+0x2d1/0x2d1
[ 1385.010198]	__ata_scsi_queuecmd+0x18f/0x1eb
[ 1385.010200]	ata_sas_queuecmd+0x31/0x4d
[ 1385.010202]	sas_queuecommand+0x83/0x1cf [libsas]
[ 1385.010203]	? blk_add_timer+0xcb/0x10f
[ 1385.010205]	scsi_dispatch_cmd+0x141/0x210
[ 1385.010205]	scsi_queue_rq+0x1c7/0x28f
[ 1385.010207]	blk_mq_dispatch_rq_list+0x1a6/0x2cf
[ 1385.010208]	blk_mq_sched_dispatch_requests+0x129/0x1e7
[ 1385.010209]	__blk_mq_run_hw_queue+0x4c/0x7f
[ 1385.010210]	__blk_mq_delay_run_hw_queue+0x5c/0xa2
[ 1385.010211]	blk_mq_run_hw_queue+0x14/0x16
[ 1385.010212]	blk_mq_run_hw_queues+0x2e/0x5e
[ 1385.010212]	scsi_run_queue+0x236/0x2c1
[ 1385.010214]	scsi_run_host_queues+0x1f/0x37
[ 1385.010215]	scsi_error_handler+0x467/0x523
[ 1385.010216]	? __schedule+0x4f5/0x5c5
[ 1385.010217]	? scsi_eh_get_sense+0x1a9/0x1a9
[ 1385.010218]	kthread+0xfb/0x100
[ 1385.010219]	? init_completion+0x24/0x24
[ 1385.010220]	ret_from_fork+0x25/0x30
[ 1385.010260] ata17.00: exception Emask 0x0 SAct 0x20000 SErr 0x0 action 0x0
[ 1385.010263] ata17.00: failed command: READ FPDMA QUEUED
[ 1385.010266] ata17.00: cmd 60/20:88:90:81:6f/00:00:35:01:00/40 tag 17 ncq dma 16384 in
[ 1385.010266]		res 50/00:01:30:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[ 1385.010267] ata17.00: status: { DRDY }
[ 1385.011259] ata17.00: Security Log not supported
[ 1385.012380] ata17.00: Security Log not supported
[ 1385.012382] ata17.00: configured for UDMA/133
[ 1385.012385] ata17: EH complete
[ 1385.335912] mount: page allocation failure: order:0, mode:0x1604040(GFP_NOFS|__GFP_COMP|__GFP_NOTRACK), nodemask=(null)
[ 1385.335916] mount cpuset=/ mems_allowed=0
[ 1385.335920] CPU: 7 PID: 3125 Comm: mount Tainted: G	   U	      4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1385.335920] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1385.335921] Call Trace:
[ 1385.335927]	dump_stack+0x61/0x7d
[ 1385.335930]	warn_alloc+0xfc/0x18c
[ 1385.335933]	? call_timer_fn+0x140/0x140
[ 1385.335935]	__alloc_pages_slowpath+0x9ca/0xa55
[ 1385.335939]	__alloc_pages_nodemask+0x141/0x1f5
[ 1385.335943]	cache_grow_begin+0xa4/0x294
[ 1385.335945]	fallback_alloc+0x154/0x196
[ 1385.335946]	? cache_grow_begin+0xa4/0x294
[ 1385.335948]	____cache_alloc_node+0xdd/0xe9
[ 1385.335950]	kmem_cache_alloc_trace+0xa0/0xfc
[ 1385.335953]	add_tree_block+0x6a/0x1a1
[ 1385.335955]	build_ref_tree_for_root+0x1aa/0x3c8
[ 1385.335956]	btrfs_build_ref_tree+0x142/0x179
[ 1385.335958]	open_ctree+0x19af/0x1ffe
[ 1385.335961]	? _raw_spin_unlock_bh+0x1a/0x1c
[ 1385.335964]	btrfs_mount+0xa0e/0xb86
[ 1385.335965]	? btrfs_mount+0xa0e/0xb86
[ 1385.335967]	? find_next_bit+0xb/0xd
[ 1385.335970]	mount_fs+0x67/0x111
[ 1385.335973]	vfs_kern_mount+0x6b/0xd5
[ 1385.335974]	btrfs_mount+0x1de/0xb86
[ 1385.335975]	? find_next_bit+0xb/0xd
[ 1385.335978]	mount_fs+0x67/0x111
[ 1385.335979]	vfs_kern_mount+0x6b/0xd5
[ 1385.335981]	do_mount+0x6e9/0x987
[ 1385.335984]	compat_SyS_mount+0x185/0x1ae
[ 1385.335986]	do_fast_syscall_32+0xb7/0xfe
[ 1385.335988]	entry_SYSENTER_compat+0x4c/0x5b
[ 1385.335990] RIP: 0023:0xf7f69c29
[ 1385.335991] RSP: 002b:00000000ffa6fed0 EFLAGS: 00000297 ORIG_RAX: 0000000000000015
[ 1385.335992] RAX: ffffffffffffffda RBX: 0000000009877050 RCX: 00000000098771e8
[ 1385.335993] RDX: 0000000009877370 RSI: 00000000c0ed0400 RDI: 00000000098bd548
[ 1385.335993] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 1385.335994] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 1385.335994] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1387.789938] Node 0 active_anon:588kB inactive_anon:300kB active_file:3988kB inactive_file:1428kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:2184kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[ 1387.871500] Node 0 DMA free:0kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[ 1387.949345] lowmem_reserve[]: 0 3201 31832 31832 31832
[ 1387.965376] Node 0 DMA32 free:621628kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:84kB inactive_file:28kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:640kB local_pcp:0kB free_cma:0kB
[ 1388.049300] lowmem_reserve[]: 0 0 28631 28631 28631
[ 1388.064560] Node 0 Normal free:4812428kB min:60760kB low:90092kB high:119424kB active_anon:588kB inactive_anon:300kB active_file:3904kB inactive_file:1400kB unevictable:0kB writepending:0kB present:29874176kB managed:29337252kB mlocked:0kB kernel_stack:8080kB pagetables:320kB bounce:0kB free_pcp:4124kB local_pcp:420kB free_cma:11288kB
[ 1388.155296] lowmem_reserve[]: 0 0 0 0 0
[ 1388.167479] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[ 1388.198947] Node 0 DMA32: 4430*4kB (U) 3580*8kB (U) 1883*16kB (U) 1009*32kB (U) 17*64kB (U) 16*128kB (U) 12*256kB (U) 10*512kB (U) 17*1024kB (U) 18*2048kB (U) 126*4096kB (U) = 690472kB
[ 1388.249622] Node 0 Normal: 71828*4kB (UC) 54033*8kB (UC) 34313*16kB (UC) 21097*32kB (UC) 10342*64kB (U) 2801*128kB (UC) 201*256kB (UC) 96*512kB (UC) 68*1024kB (U) 48*2048kB (UC) 457*4096kB (UC) = 5104520kB
[ 1388.305855] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1388.331978] 1467 total pagecache pages
[ 1388.344026] 111 pages in swap cache
[ 1388.355282] Swap cache stats: add 1465, delete 1354, find 364/553
[ 1388.374360] Free swap  = 15611132kB
[ 1388.385607] Total swap = 15616764kB
[ 1388.396863] 8313052 pages RAM
[ 1388.406556] 0 pages HighMem/MovableOnly
[ 1388.418861] 150644 pages reserved
[ 1388.429595] 4096 pages cma reserved
[ 1388.440853] 0 pages hwpoisoned
[ 1388.450807] [ pid ]	 uid  tgid total_vm	 rss nr_ptes nr_pmds swapents oom_score_adj name
[ 1388.477200] [  983]	   0   983	936	   0	   6	   2	   32		  0 init
[ 1388.503586] [  984]	   0   984	941	   1	   5	   2	   98		  0 rc
[ 1388.529456] [ 1103]	   0  1103	920	   1	   5	   2	  188	      -1000 udevd
[ 1388.556123] [ 1311]	   0  1311	925	 443	   5	   2	   24	      -1000 net.agent
[ 1388.583800] [ 1352]	   0  1352	925	 441	   5	   2	   26	      -1000 net.agent
[ 1388.611490] [ 1703]	   0  1703	926	 442	   5	   2	   26	      -1000 net.agent
[ 1388.639176] [ 1935]	   0  1935	587	   0	   5	   2	   31		  0 bootlogd
[ 1388.666611] [ 2469]	   0  2469	993	   0	   5	   2	  262	      -1000 udevd
[ 1388.693254] [ 2470]	   0  2470	993	   0	   5	   2	  261	      -1000 udevd
[ 1388.719913] [ 3049]	   0  3049     1538	   1	   6	   2	  177		  0 S13mountall.sh
[ 1388.748886] [ 3125]	   0  3125     1718	   0	   7	   2	    0		  0 mount
[ 1388.775570] [15483]	   0 15483	558	 141	   5	   2	    0	      -1000 sleep
[ 1388.802207] [15484]	   0 15484	558	 146	   4	   2	    0	      -1000 sleep
[ 1388.828828] [15485]	   0 15485	558	 145	   5	   2	    0	      -1000 sleep
[ 1388.855456] Out of memory: Kill process 3049 (S13mountall.sh) score 0 or sacrifice child

And hopefully totally unrelated (but maybe not), after the boot continues, it
crashes with:
[ 1523.299228] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffbd1d4c2c
[ 1523.299228]
[ 1523.334262] CPU: 2 PID: 19932 Comm: avahi-daemon Tainted: G	   U	      4.13.0-rc5-amd64-preempt-sysrq-20170406+ #1
[ 1523.367142] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 1523.395339] Call Trace:
[ 1523.403515]	dump_stack+0x61/0x7d
[ 1523.414266]	panic+0xe7/0x235
[ 1523.423982]	? compat_core_sys_select+0x25b/0x26d
[ 1523.438878]	__stack_chk_fail+0x19/0x19
[ 1523.451168]	compat_core_sys_select+0x25b/0x26d
[ 1523.465552]	? compat_SyS_select+0xe/0x10
[ 1523.478358]	? do_fast_syscall_32+0xb7/0xfe
[ 1523.491698]	? entry_SYSENTER_compat+0x4c/0x5b
[ 1523.505858] Kernel Offset: 0x3c000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 1523.538981] Rebooting in 20 seconds..

I did add stack-protector in 4.13, and it seems to be finding an unrelated bug.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
