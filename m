Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67118C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 04:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A6E920811
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 04:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfCZEaM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 00:30:12 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42044 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725535AbfCZEaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 00:30:11 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 4DCF727CA8E; Tue, 26 Mar 2019 00:30:09 -0400 (EDT)
Date:   Tue, 26 Mar 2019 00:30:07 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: WARNING at fs/btrfs/delayed-ref.c:296
 btrfs_merge_delayed_refs+0x3dc/0x410 (new on 5.0.4, not in 5.0.3)
Message-ID: <20190326043005.GH16651@hungrycats.org>
References: <20190326025028.GG16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190326025028.GG16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 10:50:28PM -0400, Zygo Blaxell wrote:
> Running balance, rsync, and dedupe, I get kernel warnings every few
> minutes on 5.0.4.  No warnings on 5.0.3 under similar conditions.
> 
> Mount options are:  flushoncommit,space_cache=v2,compress=zstd.
> 
> There are two different stacks on the warnings.  This one comes from
> btrfs balance:

[snip]

Possibly unrelated, but I'm also repeatably getting this in 5.0.4 and
not 5.0.3, after about 5 hours of uptime.  Different processes, same
kernel stack:

	[Mon Mar 25 23:35:17 2019] kworker/u8:4: page allocation failure: order:0, mode:0x404000(GFP_NOWAIT|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
	[Mon Mar 25 23:35:17 2019] CPU: 2 PID: 29518 Comm: kworker/u8:4 Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1
	[Mon Mar 25 23:35:17 2019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[Mon Mar 25 23:35:17 2019] Workqueue: btrfs-submit btrfs_submit_helper
	[Mon Mar 25 23:35:17 2019] Call Trace:
	[Mon Mar 25 23:35:17 2019]  dump_stack+0x7d/0xbb
	[Mon Mar 25 23:35:17 2019]  warn_alloc+0x108/0x190
	[Mon Mar 25 23:35:17 2019]  __alloc_pages_nodemask+0x12c4/0x13f0
	[Mon Mar 25 23:35:17 2019]  ? rcu_read_lock_sched_held+0x68/0x70
	[Mon Mar 25 23:35:17 2019]  ? __update_load_avg_se+0x208/0x280
	[Mon Mar 25 23:35:17 2019]  cache_grow_begin+0x79/0x730
	[Mon Mar 25 23:35:17 2019]  ? cache_grow_begin+0x79/0x730
	[Mon Mar 25 23:35:17 2019]  ? ____cache_alloc_node+0x165/0x1e0
	[Mon Mar 25 23:35:17 2019]  fallback_alloc+0x1e4/0x280
	[Mon Mar 25 23:35:17 2019]  kmem_cache_alloc+0x2e9/0x310
	[Mon Mar 25 23:35:17 2019]  btracker_queue+0x47/0x170 [dm_cache]
	[Mon Mar 25 23:35:17 2019]  __lookup+0x51a/0x600 [dm_cache_smq]
	[Mon Mar 25 23:35:17 2019]  ? smq_lookup+0x37/0x7b [dm_cache_smq]
	[Mon Mar 25 23:35:17 2019]  smq_lookup+0x5d/0x7b [dm_cache_smq]
	[Mon Mar 25 23:35:18 2019]  map_bio.part.40+0x14d/0x5d0 [dm_cache]
	[Mon Mar 25 23:35:18 2019]  ? bio_detain_shared+0xb3/0x120 [dm_cache]
	[Mon Mar 25 23:35:18 2019]  cache_map+0x120/0x170 [dm_cache]
	[Mon Mar 25 23:35:18 2019]  __map_bio+0x42/0x1f0 [dm_mod]
	[Mon Mar 25 23:35:18 2019]  __split_and_process_non_flush+0x152/0x1e0 [dm_mod]
	[Mon Mar 25 23:35:18 2019]  __split_and_process_bio+0xd4/0x400 [dm_mod]
	[Mon Mar 25 23:35:18 2019]  ? lock_acquire+0xbc/0x1c0
	[Mon Mar 25 23:35:18 2019]  ? dm_get_live_table+0x5/0xc0 [dm_mod]
	[Mon Mar 25 23:35:18 2019]  dm_make_request+0x4d/0x100 [dm_mod]
	[Mon Mar 25 23:35:18 2019]  generic_make_request+0x297/0x470
	[Mon Mar 25 23:35:18 2019]  ? kvm_sched_clock_read+0x14/0x30
	[Mon Mar 25 23:35:18 2019]  ? submit_bio+0x6c/0x140
	[Mon Mar 25 23:35:18 2019]  submit_bio+0x6c/0x140
	[Mon Mar 25 23:35:18 2019]  run_scheduled_bios+0x1e6/0x500
	[Mon Mar 25 23:35:18 2019]  ? normal_work_helper+0x95/0x530
	[Mon Mar 25 23:35:18 2019]  normal_work_helper+0x95/0x530
	[Mon Mar 25 23:35:18 2019]  process_one_work+0x223/0x5d0
	[Mon Mar 25 23:35:18 2019]  worker_thread+0x4f/0x3b0
	[Mon Mar 25 23:35:18 2019]  kthread+0x106/0x140
	[Mon Mar 25 23:35:18 2019]  ? process_one_work+0x5d0/0x5d0
	[Mon Mar 25 23:35:18 2019]  ? kthread_park+0x90/0x90
	[Mon Mar 25 23:35:18 2019]  ret_from_fork+0x3a/0x50
	[Mon Mar 25 23:35:18 2019] Mem-Info:
	[Mon Mar 25 23:35:18 2019] active_anon:195872 inactive_anon:15658 isolated_anon:0
				    active_file:629653 inactive_file:308914 isolated_file:0
				    unevictable:65536 dirty:14449 writeback:27580 unstable:0
				    slab_reclaimable:492522 slab_unreclaimable:94393
				    mapped:10915 shmem:18846 pagetables:2178 bounce:0
				    free:66082 free_pcp:1963 free_cma:24
	[Mon Mar 25 23:35:18 2019] Node 0 active_anon:783488kB inactive_anon:62632kB active_file:2516656kB inactive_file:1235604kB unevictable:262144kB isolated(anon):0kB isolated(file):0kB mapped:43660kB dirty:57796kB writeback:110320kB shmem:75384kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 137216kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
	[Mon Mar 25 23:35:18 2019] Node 0 DMA free:15844kB min:132kB low:164kB high:196kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 2939 7906 7906 7906
	[Mon Mar 25 23:35:18 2019] Node 0 DMA32 free:116632kB min:81336kB low:87592kB high:93848kB active_anon:330436kB inactive_anon:31840kB active_file:531512kB inactive_file:491372kB unevictable:108544kB writepending:121984kB present:3129176kB managed:3019336kB mlocked:108544kB kernel_stack:2704kB pagetables:2944kB bounce:0kB free_pcp:3800kB local_pcp:256kB free_cma:0kB
	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 0 4966 4966 4966
	[Mon Mar 25 23:35:18 2019] Node 0 Normal free:141932kB min:42420kB low:53024kB high:63628kB active_anon:453224kB inactive_anon:30792kB active_file:1984568kB inactive_file:737244kB unevictable:153600kB writepending:46544kB present:5242880kB managed:5102032kB mlocked:153600kB kernel_stack:7020kB pagetables:5768kB bounce:0kB free_pcp:4188kB local_pcp:1700kB free_cma:96kB
	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 0 0 0 0
	[Mon Mar 25 23:35:18 2019] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15844kB
	[Mon Mar 25 23:35:18 2019] Node 0 DMA32: 12698*4kB (UME) 6110*8kB (UME) 1087*16kB (UME) 4*32kB (M) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 117192kB
	[Mon Mar 25 23:35:18 2019] Node 0 Normal: 13507*4kB (UMEHC) 8008*8kB (UMEHC) 1374*16kB (UMEH) 3*32kB (H) 4*64kB (H) 4*128kB (H) 2*256kB (H) 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 141964kB
	[Mon Mar 25 23:35:18 2019] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
	[Mon Mar 25 23:35:18 2019] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
	[Mon Mar 25 23:35:18 2019] 955001 total pagecache pages
	[Mon Mar 25 23:35:18 2019] 0 pages in swap cache
	[Mon Mar 25 23:35:18 2019] Swap cache stats: add 0, delete 0, find 0/0
	[Mon Mar 25 23:35:18 2019] Free swap  = 0kB
	[Mon Mar 25 23:35:18 2019] Total swap = 0kB
	[Mon Mar 25 23:35:18 2019] 2097012 pages RAM
	[Mon Mar 25 23:35:18 2019] 0 pages HighMem/MovableOnly
	[Mon Mar 25 23:35:18 2019] 62693 pages reserved
	[Mon Mar 25 23:35:18 2019] 4096 pages cma reserved
	[Mon Mar 25 23:35:18 2019] 0 pages hwpoisoned

As far as I can tell from logs of memory usage (recording memcg and
MemAvail stats every second), there are gigabytes of available (clean
page cache) RAM at all times during these tests.
