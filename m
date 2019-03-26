Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5DFC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA7F2063F
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 15:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfCZPpa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:45:30 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40336 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfCZPpa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 11:45:30 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id ED66227DDB0; Tue, 26 Mar 2019 11:45:24 -0400 (EDT)
Date:   Tue, 26 Mar 2019 11:45:23 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: WARNING at fs/btrfs/delayed-ref.c:296
 btrfs_merge_delayed_refs+0x3dc/0x410 (new on 5.0.4, not in 5.0.3)
Message-ID: <20190326154523.GK16651@hungrycats.org>
References: <20190326025028.GG16651@hungrycats.org>
 <20190326043005.GH16651@hungrycats.org>
 <00ced6df-c0c6-c762-0119-76218ab4ca0b@suse.com>
 <20190326150936.GI16651@hungrycats.org>
 <d5a66daf-cb5a-0acc-3131-7ba150658f06@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <d5a66daf-cb5a-0acc-3131-7ba150658f06@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 05:13:53PM +0200, Nikolay Borisov wrote:
> 
> 
> On 26.03.19 г. 17:09 ч., Zygo Blaxell wrote:
> > On Tue, Mar 26, 2019 at 10:42:31AM +0200, Nikolay Borisov wrote:
> >>
> >>
> >> On 26.03.19 г. 6:30 ч., Zygo Blaxell wrote:
> >>> On Mon, Mar 25, 2019 at 10:50:28PM -0400, Zygo Blaxell wrote:
> >>>> Running balance, rsync, and dedupe, I get kernel warnings every few
> >>>> minutes on 5.0.4.  No warnings on 5.0.3 under similar conditions.
> >>>>
> >>>> Mount options are:  flushoncommit,space_cache=v2,compress=zstd.
> >>>>
> >>>> There are two different stacks on the warnings.  This one comes from
> >>>> btrfs balance:
> >>>
> >>> [snip]
> >>>
> >>> Possibly unrelated, but I'm also repeatably getting this in 5.0.4 and
> >>> not 5.0.3, after about 5 hours of uptime.  Different processes, same
> >>> kernel stack:
> >>>
> >>> 	[Mon Mar 25 23:35:17 2019] kworker/u8:4: page allocation failure: order:0, mode:0x404000(GFP_NOWAIT|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
> >>> 	[Mon Mar 25 23:35:17 2019] CPU: 2 PID: 29518 Comm: kworker/u8:4 Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1
> >>
> >> What commits does this kernel include because it doesn't seem to be a
> >> pristine upstream 5.0.4 ? Also what you are seeing below is definitely a
> >> bug in MM. The question is whether it's due to your doing faulty
> >> backports in the kernel or it's due to something that got automatically
> >> backported to 5.0.4
> > 
> > That was the first thing I thought of, so I reverted to vanilla 5.0.4,
> > repeated the test, and obtained the same result.
> > 
> > You may have a point about non-btrfs patches in 5.0.4, though.
> > I previously tested 5.0.3 with most of the 5.0.4 fs/btrfs commits
> > already included by cherry-pick:
> > 
> > 	1098803b8cb7 Btrfs: fix deadlock between clone/dedupe and rename
> > 	3486142a68e3 Btrfs: fix corruption reading shared and compressed extents after hole punching
> > 	fb9c36acfab1 btrfs: scrub: fix circular locking dependency warning
> > 	9d7b327affb8 Btrfs: setup a nofs context for memory allocation at __btrfs_set_acl
> > 	80dcd07c27df Btrfs: setup a nofs context for memory allocation at btrfs_create_tree()
> > 
> > The commits that are in 5.0.4 but not in my last 5.0.3 test run are:
> > 
> > 	ebbb48419e8a btrfs: init csum_list before possible free
> > 	88e610ae4c3a btrfs: ensure that a DUP or RAID1 block group has exactly two stripes
> > 	9c58f2ada4fa btrfs: drop the lock on error in btrfs_dev_replace_cancel
> > 
> > and I don't see how those commits could lead to the observed changes
> > in behavior.  I didn't include them for 5.0.3 because my test scenario
> > doesn't execute the code they touch.  So the problem might be outside
> > of btrfs completely.
> 
> I think it might very well be outside of btrfs because you are seeing an
> order 0 failure when you have plenty of order 0 free pages. That's
> definitely something you might want to report to mm.

I found a similar incident in logs from older (and slightly different)
test runs, this one on 4.20.13:

	[112241.575678] kworker/u8:17: page allocation failure: order:0, mode:0x404000(GFP_NOWAIT|__GFP_COMP), nodemask=(null)
	[112241.587462] kworker/u8:17 cpuset=/ mems_allowed=0
	[112241.588442] CPU: 1 PID: 22891 Comm: kworker/u8:17 Not tainted 4.20.13-zb64+ #1
	[112241.589550] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[112241.590814] Workqueue: btrfs-submit btrfs_submit_helper
	[112241.591611] Call Trace:
	[112241.592034]  dump_stack+0x7d/0xbb
	[112241.592564]  warn_alloc+0xfc/0x180
	[112241.593121]  __alloc_pages_nodemask+0x1297/0x13e0
	[112241.593860]  ? rcu_read_lock_sched_held+0x68/0x70
	[112241.594607]  cache_grow_begin+0x79/0x730
	[112241.595226]  ? cache_grow_begin+0x79/0x730
	[112241.595875]  ? ____cache_alloc_node+0x165/0x1e0
	[112241.596573]  fallback_alloc+0x1e4/0x280
	[112241.597162]  kmem_cache_alloc+0x2e9/0x310
	[112241.597763]  btracker_queue+0x47/0x170 [dm_cache]
	[112241.598465]  __lookup+0x474/0x600 [dm_cache_smq]
	[112241.599151]  ? smq_lookup+0x37/0x7b [dm_cache_smq]
	[112241.599867]  smq_lookup+0x5d/0x7b [dm_cache_smq]
	[112241.600554]  map_bio.part.40+0x14d/0x5d0 [dm_cache]
	[112241.601307]  ? bio_detain_shared+0xb3/0x120 [dm_cache]
	[112241.602075]  cache_map+0x120/0x1a0 [dm_cache]
	[112241.602813]  __map_bio+0x42/0x1f0 [dm_mod]
	[112241.603506]  __split_and_process_non_flush+0x10e/0x1e0 [dm_mod]
	[112241.604418]  __split_and_process_bio+0xb2/0x1a0 [dm_mod]
	[112241.605371]  ? __process_bio+0x170/0x170 [dm_mod]
	[112241.606099]  __dm_make_request.isra.20+0x4c/0x100 [dm_mod]
	[112241.606936]  generic_make_request+0x29d/0x470
	[112241.607611]  ? kvm_sched_clock_read+0x14/0x30
	[112241.608282]  ? submit_bio+0x6c/0x140
	[112241.608841]  submit_bio+0x6c/0x140
	[112241.609379]  run_scheduled_bios+0x1f5/0x530
	[112241.610034]  ? normal_work_helper+0x95/0x530
	[112241.610699]  normal_work_helper+0x95/0x530
	[112241.611343]  process_one_work+0x223/0x5d0
	[112241.611973]  worker_thread+0x4f/0x3b0
	[112241.612545]  kthread+0x106/0x140
	[112241.613059]  ? process_one_work+0x5d0/0x5d0
	[112241.613721]  ? kthread_park+0x90/0x90
	[112241.614305]  ret_from_fork+0x3a/0x50
	[112241.614949] Mem-Info:
	[112241.615320] active_anon:155365 inactive_anon:2116 isolated_anon:0
	[112241.615320]  active_file:466942 inactive_file:242123 isolated_file:0
	[112241.615320]  unevictable:262144 dirty:30009 writeback:23033 unstable:0
	[112241.615320]  slab_reclaimable:39503 slab_unreclaimable:19905
	[112241.615320]  mapped:2750 shmem:2447 pagetables:2077 bounce:0
	[112241.615320]  free:38378 free_pcp:1387 free_cma:2928
	[112241.620633] Node 0 active_anon:621460kB inactive_anon:8464kB active_file:1867768kB inactive_file:968492kB unevictable:1048576kB isolated(anon):0kB isolated(file):0kB mapped:11000kB dirty:114264kB writeback:97756kB shmem:9788kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 1146880kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
	[112241.625103] Node 0 DMA free:15844kB min:212kB low:264kB high:316kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
	[112241.629016] lowmem_reserve[]: 0 2939 4882 4882 4882
	[112241.629776] Node 0 DMA32 free:78616kB min:40432kB low:50540kB high:60648kB active_anon:411892kB inactive_anon:24kB active_file:1374720kB inactive_file:701652kB unevictable:241664kB writepending:133964kB present:3129176kB managed:3019400kB mlocked:241664kB kernel_stack:752kB pagetables:3860kB bounce:0kB free_pcp:1980kB local_pcp:0kB free_cma:0kB
	[112241.634350] lowmem_reserve[]: 0 0 1942 1942 1942
	[112241.635098] Node 0 Normal free:43292kB min:26936kB low:33668kB high:40400kB active_anon:209568kB inactive_anon:8440kB active_file:494452kB inactive_file:266024kB unevictable:806912kB writepending:77516kB present:2097152kB managed:2005456kB mlocked:806912kB kernel_stack:2768kB pagetables:4448kB bounce:0kB free_pcp:3032kB local_pcp:0kB free_cma:11712kB
	[112241.639679] lowmem_reserve[]: 0 0 0 0 0
	[112241.640262] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15844kB
	[112241.642205] Node 0 DMA32: 7549*4kB (UME) 4950*8kB (UME) 484*16kB (UME) 25*32kB (UE) 1*64kB (M) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 78404kB
	[112241.644176] Node 0 Normal: 3796*4kB (UMEHC) 2435*8kB (UMEHC) 317*16kB (UMHC) 51*32kB (UMHC) 7*64kB (HC) 3*128kB (UH) 3*256kB (H) 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 43480kB
	[112241.646403] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
	[112241.647639] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
	[112241.648839] 711461 total pagecache pages
	[112241.649416] 0 pages in swap cache
	[112241.649912] Swap cache stats: add 0, delete 0, find 0/0
	[112241.650664] Free swap  = 0kB
	[112241.651098] Total swap = 0kB
	[112241.651656] 1310580 pages RAM
	[112241.652107] 0 pages HighMem/MovableOnly
	[112241.652669] 50389 pages reserved
	[112241.653150] 4096 pages cma reserved
	[112241.653662] 0 pages hwpoisoned

It happens on 4.20.14 as well.  Not sure why it's so rare on 5.0.3
(3x longer test run than 4.20.x or 5.0.4, no incidents), and I don't
have data from older kernels running sufficiently similar tests to
widen the data set.

I have been noticing a lot of unexpected OOM kills on 4.20+ kernels,
but I increased RAM in the test VMs and those went away.  Maybe I
misidentified the cause of that problem as something in userspace,
when it was really a MM bug.
