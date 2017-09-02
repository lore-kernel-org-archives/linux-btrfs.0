Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33777 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdIBXx4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Sep 2017 19:53:56 -0400
Date: Sat, 2 Sep 2017 16:53:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170902235344.sb55vzaloglmqaad@merlins.org>
References: <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
 <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
 <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 02, 2017 at 04:52:20PM +0000, Josef Bacik wrote:
> Oops, ok I've updated my tree so we don't save the stack trace of the initial scan, which we don't need anyway.  That should save a decent amount of memory in your case.  It was an in place update so you'll need to blow away your local branch and pull the new one to get the new code.  Thanks,

Still did not work unfortunately (on top of extra unrelated bugs in
4.13rc5 like I was afraid)

mounting the partition still sucks all the memory

[  358.719722] bcache_writebac invoked oom-killer: gfp_mask=0x14000c0(GFP_KERNEL), nodemask=(null),  order=0, oom_score_adj=0
[  358.753716] bcache_writebac cpuset=/ mems_allowed=0
[  358.769071] CPU: 3 PID: 2339 Comm: bcache_writebac Tainted: G     U		4.13.0-rc5-amd64-stkreg-sysrq-20170902+ #2
[  358.802040] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[  358.830082] Call Trace:
[  358.838108]	dump_stack+0x61/0x7d
[  358.848728]	dump_header+0x97/0x239
[  358.859846]	? _raw_spin_unlock_irqrestore+0x14/0x24
[  358.875398]	oom_kill_process+0x86/0x379
[  358.887838]	out_of_memory+0x3a6/0x3ef
[  358.899730]	__alloc_pages_slowpath+0x86e/0xa1f
[  358.913977]	? native_sched_clock+0x1a/0x37
[  358.927197]	__alloc_pages_nodemask+0x134/0x1d4
[  358.941432]	alloc_pages_current+0x8d/0x96
[  358.954343]	bio_alloc_pages+0x29/0x6a
[  358.966194]	bch_writeback_thread+0x51c/0x6d4 [bcache]
[  358.982206]	? write_dirty+0x90/0x90 [bcache]
[  358.995878]	kthread+0xfb/0x100
[  359.005899]	? init_completion+0x24/0x24
[  359.018242]	? do_fast_syscall_32+0xb7/0xfe
[  359.031360]	ret_from_fork+0x25/0x30
[  359.042723] Mem-Info:
[  359.050529] active_anon:0 inactive_anon:2 isolated_anon:0
[  359.050529]	active_file:306 inactive_file:163 isolated_file:0
[  359.050529]	unevictable:0 dirty:0 writeback:0 unstable:0
[  359.050529]	slab_reclaimable:3430 slab_unreclaimable:8034083
[  359.050529]	mapped:1 shmem:2 pagetables:80 bounce:0
[  359.050529]	free:51932 free_pcp:46 free_cma:3741
[  359.149971] Node 0 active_anon:0kB inactive_anon:8kB active_file:1128kB inactive_file:892kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:4kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[  359.229593] Node 0 DMA free:15880kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  359.308570] lowmem_reserve[]: 0 3201 31832 31832 31832
[  359.324706] Node 0 DMA32 free:121124kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:100kB inactive_file:0kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:16kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  359.408498] lowmem_reserve[]: 0 0 28631 28631 28631
[  359.423773] Node 0 Normal free:70792kB min:60760kB low:90092kB high:119424kB active_anon:0kB inactive_anon:8kB active_file:780kB inactive_file:808kB unevictable:0kB writepending:0kB present:29874176kB managed:29337512kB mlocked:0kB kernel_stack:4608kB pagetables:320kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:14964kB
[  359.511284] lowmem_reserve[]: 0 0 0 0 0
[  359.523514] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15880kB
[  359.564260] Node 0 DMA32: 3*4kB (UME) 3*8kB (ME) 4*16kB (UME) 6*32kB (UME) 4*64kB (ME) 4*128kB (ME) 5*256kB (ME) 4*512kB (ME) 6*1024kB (UME) 4*2048kB (UME) 25*4096kB (M) = 121124kB
[  359.614116] Node 0 Normal: 559*4kB (UMEC) 272*8kB (ME) 163*16kB (UMEC) 93*32kB (UMEC) 65*64kB (MEC) 71*128kB (UME) 37*256kB (ME) 18*512kB (UMC) 8*1024kB (M) 4*2048kB (MC) 3*4096kB (C) = 70604kB
[  359.667377] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  359.693519] 456 total pagecache pages
[  359.705331] 0 pages in swap cache
[  359.716151] Swap cache stats: add 1184, delete 1184, find 4/8
[  359.734213] Free swap  = 15610620kB
[  359.745499] Total swap = 15616764kB
[  359.756879] 8313052 pages RAM
[  359.766596] 0 pages HighMem/MovableOnly
[  359.778927] 150579 pages reserved
[  359.789686] 4096 pages cma reserved
[  359.801052] 0 pages hwpoisoned
[  359.811026] [ pid ]	 uid  tgid total_vm	 rss nr_ptes nr_pmds swapents oom_score_adj name
[  359.837419] [  967]	   0   967	936	   0	   6	   2	   32		  0 init
[  359.863819] [  968]	   0   968	941	   1	   5	   2	   98		  0 rc
[  359.889683] [ 1087]	   0  1087	942	   1	   5	   2	  212	      -1000 udevd
[  359.916457] [ 1294]	   0  1294	917	   1	   5	   2	   60	      -1000 net.agent
[  359.944236] [ 1340]	   0  1340	917	   1	   5	   2	   59	      -1000 net.agent
[  359.971915] [ 1750]	   0  1750	918	   1	   5	   2	   59	      -1000 net.agent
[  359.999603] [ 1915]	   0  1915	587	   0	   5	   2	   31		  0 bootlogd
[  360.027033] [ 2442]	   0  2442	942	   0	   5	   2	  211	      -1000 udevd
[  360.053685] [ 2443]	   0  2443	942	   0	   5	   2	  211	      -1000 udevd
[  360.080467] [ 3023]	   0  3023     1538	   1	   6	   2	  177		  0 S13mountall.sh
[  360.109446] [ 3078]	   0  3078     1719	   1	   7	   2	  129		  0 mount
[  360.136111] [ 5722]	   0  5722	558	   0	   5	   2	   16	      -1000 sleep
[  360.162742] [ 5723]	   0  5723	558	   0	   5	   2	   17	      -1000 sleep
[  360.189358] [ 5724]	   0  5724	558	   0	   5	   2	   17	      -1000 sleep
[  360.215977] Out of memory: Kill process 3023 (S13mountall.sh) score 0 or sacrifice child
[  360.241102] Killed process 3078 (mount) total-vm:6876kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
[  360.276193] oom_reaper: reaped process 3078 (mount), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  360.308435] bcache_writebac invoked oom-killer: gfp_mask=0x14000c0(GFP_KERNEL), nodemask=(null),  order=0, oom_score_adj=0
[  360.342339] bcache_writebac cpuset=/ mems_allowed=0
[  360.357757] CPU: 1 PID: 2339 Comm: bcache_writebac Tainted: G     U		4.13.0-rc5-amd64-stkreg-sysrq-20170902+ #2
[  360.390847] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[  360.419010] Call Trace:
[  360.427123]	dump_stack+0x61/0x7d
[  360.437815]	dump_header+0x97/0x239
[  360.449000]	? _raw_spin_unlock_irqrestore+0x14/0x24
[  360.464705]	oom_kill_process+0x86/0x379
[  360.477180]	out_of_memory+0x3a6/0x3ef
[  360.489120]	__alloc_pages_slowpath+0x86e/0xa1f
[  360.503360]	? native_sched_clock+0x1a/0x37
[  360.516712]	__alloc_pages_nodemask+0x134/0x1d4
[  360.530950]	alloc_pages_current+0x8d/0x96
[  360.543852]	bio_alloc_pages+0x29/0x6a
[  360.555696]	bch_writeback_thread+0x51c/0x6d4 [bcache]
[  360.571694]	? write_dirty+0x90/0x90 [bcache]
[  360.585320]	kthread+0xfb/0x100
[  360.595281]	? init_completion+0x24/0x24
[  360.607571]	? do_fast_syscall_32+0xb7/0xfe
[  360.620725]	ret_from_fork+0x25/0x30
[  360.632000] Mem-Info:
[  360.639511] active_anon:0 inactive_anon:2 isolated_anon:0
[  360.639511]	active_file:237 inactive_file:181 isolated_file:0
[  360.639511]	unevictable:0 dirty:0 writeback:0 unstable:0
[  360.639511]	slab_reclaimable:3428 slab_unreclaimable:8054968
[  360.639511]	mapped:1 shmem:2 pagetables:80 bounce:0
[  360.639511]	free:31221 free_pcp:20 free_cma:3741
[  360.738644] Node 0 active_anon:0kB inactive_anon:8kB active_file:1016kB inactive_file:980kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:4kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[  360.818057] Node 0 DMA free:15880kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  360.897260] lowmem_reserve[]: 0 3201 31832 31832 31832
[  360.913324] Node 0 DMA32 free:4760kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:324kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:16kB pagetables:0kB bounce:0kB free_pcp:28kB local_pcp:0kB free_cma:0kB
[  360.968034] mount: page allocation failure: order:0, mode:0x1604040(GFP_NOFS|__GFP_COMP|__GFP_NOTRACK), nodemask=(null)
[  360.968038] mount cpuset=/ mems_allowed=0
[  360.968042] CPU: 0 PID: 3078 Comm: mount Tainted: G	   U	      4.13.0-rc5-amd64-stkreg-sysrq-20170902+ #2
[  360.968043] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[  360.968044] Call Trace:
[  360.968050]	dump_stack+0x61/0x7d
[  360.968052]	warn_alloc+0xe4/0x15d
[  360.968056]	? call_timer_fn+0x140/0x140
[  360.968058]	__alloc_pages_slowpath+0x9a8/0xa1f
[  360.968068]	? __rmqueue+0x285/0x297
[  360.968071]	__alloc_pages_nodemask+0x134/0x1d4
[  360.968075]	cache_grow_begin+0x95/0x26f
[  360.968077]	fallback_alloc+0x154/0x196
[  360.968079]	____cache_alloc_node+0xdd/0xe9
[  360.968081]	kmem_cache_alloc_trace+0xa0/0xfc
[  360.968084]	add_tree_block+0x6a/0x1ac
[  360.968086]	build_ref_tree_for_root+0x19b/0x3a5
[  360.968088]	btrfs_build_ref_tree+0x133/0x156
[  360.968090]	open_ctree+0x1997/0x1fd2
[  360.968093]	btrfs_mount+0x9d5/0xb2d
[  360.968094]	? btrfs_mount+0x9d5/0xb2d
[  360.968096]	? find_next_bit+0xb/0xd
[  360.968099]	mount_fs+0x67/0x111
[  360.968101]	vfs_kern_mount+0x6b/0xd5
[  360.968102]	btrfs_mount+0x1c3/0xb2d
[  360.968103]	? find_next_bit+0xb/0xd
[  360.968106]	mount_fs+0x67/0x111
[  360.968107]	vfs_kern_mount+0x6b/0xd5
[  360.968109]	do_mount+0x6da/0x964
[  360.968111]	? slab_post_alloc_hook.isra.46+0xe/0x1d
[  360.968113]	compat_SyS_mount+0x185/0x1ae
[  360.968116]	do_fast_syscall_32+0xb7/0xfe
[  360.968118]	entry_SYSENTER_compat+0x4c/0x5b
[  360.968119] RIP: 0023:0xf7f21c29
[  360.968120] RSP: 002b:00000000ffd733e0 EFLAGS: 00000297 ORIG_RAX: 0000000000000015
[  360.968122] RAX: ffffffffffffffda RBX: 0000000008ff32c8 RCX: 0000000008ff3118
[  360.968122] RDX: 0000000008ff3010 RSI: 00000000c0ed0400 RDI: 0000000008ff6500
[  360.968123] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  360.968124] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  360.968124] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  360.968126] Mem-Info:
[  360.968130] active_anon:0 inactive_anon:2 isolated_anon:0
[  360.968130]	active_file:333 inactive_file:144 isolated_file:0
[  360.968130]	unevictable:0 dirty:0 writeback:0 unstable:0
[  360.968130]	slab_reclaimable:3428 slab_unreclaimable:8082489
[  360.968130]	mapped:1 shmem:2 pagetables:80 bounce:0
[  360.968130]	free:3717 free_pcp:9 free_cma:3741
[  360.968132] Node 0 active_anon:0kB inactive_anon:8kB active_file:1332kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:4kB dirty:0kB writeback:0kB shmem:8kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[  360.968133] Node 0 DMA free:0kB min:32kB low:44kB high:56kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15964kB managed:15880kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  360.968136] lowmem_reserve[]: 0 3201 31832 31832 31832
[  360.968138] Node 0 DMA32 free:296kB min:6788kB low:10064kB high:13340kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:292kB unevictable:0kB writepending:0kB present:3362068kB managed:3296500kB mlocked:0kB kernel_stack:16kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  360.968141] lowmem_reserve[]: 0 0 28631 28631 28631
[  360.968143] Node 0 Normal free:14572kB min:60760kB low:90092kB high:119424kB active_anon:0kB inactive_anon:8kB active_file:920kB inactive_file:504kB unevictable:0kB writepending:0kB present:29874176kB managed:29337512kB mlocked:0kB kernel_stack:4608kB pagetables:320kB bounce:0kB free_pcp:36kB local_pcp:0kB free_cma:14964kB
[  360.968146] lowmem_reserve[]: 0 0 0 0 0
[  360.968147] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[  360.968152] Node 0 DMA32: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[  360.968157] Node 0 Normal: 1*4kB (C) 0*8kB 1*16kB (C) 1*32kB (C) 1*64kB (C) 0*128kB 0*256kB 1*512kB (C) 0*1024kB 1*2048kB (C) 3*4096kB (C) = 14964kB
[  360.968164] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  360.968165] 495 total pagecache pages
[  360.968167] 0 pages in swap cache
[  360.968168] Swap cache stats: add 1184, delete 1184, find 4/8
[  360.968169] Free swap  = 15611132kB
[  360.968169] Total swap = 15616764kB
[  360.968170] 8313052 pages RAM
[  360.968170] 0 pages HighMem/MovableOnly
[  360.968170] 150579 pages reserved
[  360.968171] 4096 pages cma reserved
[  360.968171] 0 pages hwpoisoned
[  362.324699] lowmem_reserve[]: 0 0 28631 28631 28631
[  362.340147] Node 0 Normal free:2422448kB min:60760kB low:90092kB high:119424kB active_anon:636kB inactive_anon:196kB active_file:3788kB inactive_file:1424kB unevictable:0kB writepending:0kB present:29874176kB managed:29337512kB mlocked:0kB kernel_stack:4608kB pagetables:324kB bounce:0kB free_pcp:4100kB local_pcp:48kB free_cma:11468kB
[  362.431162] lowmem_reserve[]: 0 0 0 0 0
[  362.443496] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
[  362.475115] Node 0 DMA32: 4469*4kB (U) 3639*8kB (U) 3116*16kB (U) 1233*32kB (U) 64*64kB (U) 9*128kB (U) 4*256kB (U) 6*512kB (U) 3*1024kB (U) 6*2048kB (U) 45*4096kB (U) = 345324kB
[  362.524575] Node 0 Normal: 53138*4kB (UMC) 40392*8kB (UMC) 29104*16kB (UM) 16364*32kB (U) 4513*64kB (UC) 658*128kB (UC) 25*256kB (U) 18*512kB (U) 20*1024kB (UC) 19*2048kB (UC) 193*4096kB (UC) = 2763592kB
[  362.580622] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  362.606863] 1429 total pagecache pages
[  362.619062] 96 pages in swap cache
[  362.630199] Swap cache stats: add 1396, delete 1300, find 237/380
[  362.649433] Free swap  = 15611132kB
[  362.660833] Total swap = 15616764kB
[  362.672274] 8313052 pages RAM
[  362.682133] 0 pages HighMem/MovableOnly
[  362.694909] 150579 pages reserved
[  362.705741] 4096 pages cma reserved
[  362.717084] 0 pages hwpoisoned
[  362.727099] [ pid ]	 uid  tgid total_vm	 rss nr_ptes nr_pmds swapents oom_score_adj name
[  362.753547] [  967]	   0   967	936	   0	   6	   2	   32		  0 init
[  362.779963] [  968]	   0   968	941	   1	   5	   2	   98		  0 rc
[  362.805846] [ 1087]	   0  1087	942	   1	   5	   2	  212	      -1000 udevd
[  362.832511] [ 1294]	   0  1294	917	 421	   5	   2	   24	      -1000 net.agent
[  362.860203] [ 1340]	   0  1340	917	 396	   5	   2	   28	      -1000 net.agent
[  362.887851] [ 1750]	   0  1750	918	 419	   5	   2	   25	      -1000 net.agent
[  362.915478] [ 1915]	   0  1915	587	   0	   5	   2	   31		  0 bootlogd
[  362.942839] [ 2442]	   0  2442	942	   0	   5	   2	  211	      -1000 udevd
[  362.969390] [ 2443]	   0  2443	942	   0	   5	   2	  211	      -1000 udevd
[  362.995922] [ 3023]	   0  3023     1538	   1	   6	   2	  177		  0 S13mountall.sh
[  363.024797] [ 3078]	   0  3078     1719	   0	   7	   2	    0		  0 mount
[  363.051309] [ 5743]	   0  5743	558	 147	   5	   2	    0	      -1000 sleep
[  363.077802] [ 5744]	   0  5744	558	 148	   5	   2	    0	      -1000 sleep
[  363.104305] [ 5745]	   0  5745	558	 143	   5	   2	    0	      -1000 sleep
[  363.130752] Out of memory: Kill process 3023 (S13mountall.sh) score 0 or sacrifice child
[  363.155660] Killed process 3023 (S13mountall.sh) total-vm:6152kB, anon-rss:0kB, file-rss:4kB, shmem-rss:0kB
/etc/init.d/rc: line 120:  3023 Killed			$debug "$script" $action

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
