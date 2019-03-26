Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51706C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 08:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226B120856
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 08:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbfCZImf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:42:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:59468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726645AbfCZImf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 04:42:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1CA39AD4E;
        Tue, 26 Mar 2019 08:42:33 +0000 (UTC)
Subject: Re: WARNING at fs/btrfs/delayed-ref.c:296
 btrfs_merge_delayed_refs+0x3dc/0x410 (new on 5.0.4, not in 5.0.3)
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
References: <20190326025028.GG16651@hungrycats.org>
 <20190326043005.GH16651@hungrycats.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <00ced6df-c0c6-c762-0119-76218ab4ca0b@suse.com>
Date:   Tue, 26 Mar 2019 10:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190326043005.GH16651@hungrycats.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 26.03.19 г. 6:30 ч., Zygo Blaxell wrote:
> On Mon, Mar 25, 2019 at 10:50:28PM -0400, Zygo Blaxell wrote:
>> Running balance, rsync, and dedupe, I get kernel warnings every few
>> minutes on 5.0.4.  No warnings on 5.0.3 under similar conditions.
>>
>> Mount options are:  flushoncommit,space_cache=v2,compress=zstd.
>>
>> There are two different stacks on the warnings.  This one comes from
>> btrfs balance:
> 
> [snip]
> 
> Possibly unrelated, but I'm also repeatably getting this in 5.0.4 and
> not 5.0.3, after about 5 hours of uptime.  Different processes, same
> kernel stack:
> 
> 	[Mon Mar 25 23:35:17 2019] kworker/u8:4: page allocation failure: order:0, mode:0x404000(GFP_NOWAIT|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
> 	[Mon Mar 25 23:35:17 2019] CPU: 2 PID: 29518 Comm: kworker/u8:4 Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1

What commits does this kernel include because it doesn't seem to be a
pristine upstream 5.0.4 ? Also what you are seeing below is definitely a
bug in MM. The question is whether it's due to your doing faulty
backports in the kernel or it's due to something that got automatically
backported to 5.0.4

> 	[Mon Mar 25 23:35:17 2019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> 	[Mon Mar 25 23:35:17 2019] Workqueue: btrfs-submit btrfs_submit_helper
> 	[Mon Mar 25 23:35:17 2019] Call Trace:
> 	[Mon Mar 25 23:35:17 2019]  dump_stack+0x7d/0xbb
> 	[Mon Mar 25 23:35:17 2019]  warn_alloc+0x108/0x190
> 	[Mon Mar 25 23:35:17 2019]  __alloc_pages_nodemask+0x12c4/0x13f0
> 	[Mon Mar 25 23:35:17 2019]  ? rcu_read_lock_sched_held+0x68/0x70
> 	[Mon Mar 25 23:35:17 2019]  ? __update_load_avg_se+0x208/0x280
> 	[Mon Mar 25 23:35:17 2019]  cache_grow_begin+0x79/0x730
> 	[Mon Mar 25 23:35:17 2019]  ? cache_grow_begin+0x79/0x730
> 	[Mon Mar 25 23:35:17 2019]  ? ____cache_alloc_node+0x165/0x1e0
> 	[Mon Mar 25 23:35:17 2019]  fallback_alloc+0x1e4/0x280
> 	[Mon Mar 25 23:35:17 2019]  kmem_cache_alloc+0x2e9/0x310
> 	[Mon Mar 25 23:35:17 2019]  btracker_queue+0x47/0x170 [dm_cache]
> 	[Mon Mar 25 23:35:17 2019]  __lookup+0x51a/0x600 [dm_cache_smq]
> 	[Mon Mar 25 23:35:17 2019]  ? smq_lookup+0x37/0x7b [dm_cache_smq]
> 	[Mon Mar 25 23:35:17 2019]  smq_lookup+0x5d/0x7b [dm_cache_smq]
> 	[Mon Mar 25 23:35:18 2019]  map_bio.part.40+0x14d/0x5d0 [dm_cache]
> 	[Mon Mar 25 23:35:18 2019]  ? bio_detain_shared+0xb3/0x120 [dm_cache]
> 	[Mon Mar 25 23:35:18 2019]  cache_map+0x120/0x170 [dm_cache]
> 	[Mon Mar 25 23:35:18 2019]  __map_bio+0x42/0x1f0 [dm_mod]
> 	[Mon Mar 25 23:35:18 2019]  __split_and_process_non_flush+0x152/0x1e0 [dm_mod]
> 	[Mon Mar 25 23:35:18 2019]  __split_and_process_bio+0xd4/0x400 [dm_mod]
> 	[Mon Mar 25 23:35:18 2019]  ? lock_acquire+0xbc/0x1c0
> 	[Mon Mar 25 23:35:18 2019]  ? dm_get_live_table+0x5/0xc0 [dm_mod]
> 	[Mon Mar 25 23:35:18 2019]  dm_make_request+0x4d/0x100 [dm_mod]
> 	[Mon Mar 25 23:35:18 2019]  generic_make_request+0x297/0x470
> 	[Mon Mar 25 23:35:18 2019]  ? kvm_sched_clock_read+0x14/0x30
> 	[Mon Mar 25 23:35:18 2019]  ? submit_bio+0x6c/0x140
> 	[Mon Mar 25 23:35:18 2019]  submit_bio+0x6c/0x140
> 	[Mon Mar 25 23:35:18 2019]  run_scheduled_bios+0x1e6/0x500
> 	[Mon Mar 25 23:35:18 2019]  ? normal_work_helper+0x95/0x530
> 	[Mon Mar 25 23:35:18 2019]  normal_work_helper+0x95/0x530
> 	[Mon Mar 25 23:35:18 2019]  process_one_work+0x223/0x5d0
> 	[Mon Mar 25 23:35:18 2019]  worker_thread+0x4f/0x3b0
> 	[Mon Mar 25 23:35:18 2019]  kthread+0x106/0x140
> 	[Mon Mar 25 23:35:18 2019]  ? process_one_work+0x5d0/0x5d0
> 	[Mon Mar 25 23:35:18 2019]  ? kthread_park+0x90/0x90
> 	[Mon Mar 25 23:35:18 2019]  ret_from_fork+0x3a/0x50
> 	[Mon Mar 25 23:35:18 2019] Mem-Info:
> 	[Mon Mar 25 23:35:18 2019] active_anon:195872 inactive_anon:15658 isolated_anon:0
> 				    active_file:629653 inactive_file:308914 isolated_file:0
> 				    unevictable:65536 dirty:14449 writeback:27580 unstable:0
> 				    slab_reclaimable:492522 slab_unreclaimable:94393
> 				    mapped:10915 shmem:18846 pagetables:2178 bounce:0
> 				    free:66082 free_pcp:1963 free_cma:24
> 	[Mon Mar 25 23:35:18 2019] Node 0 active_anon:783488kB inactive_anon:62632kB active_file:2516656kB inactive_file:1235604kB unevictable:262144kB isolated(anon):0kB isolated(file):0kB mapped:43660kB dirty:57796kB writeback:110320kB shmem:75384kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 137216kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> 	[Mon Mar 25 23:35:18 2019] Node 0 DMA free:15844kB min:132kB low:164kB high:196kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> 	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 2939 7906 7906 7906
> 	[Mon Mar 25 23:35:18 2019] Node 0 DMA32 free:116632kB min:81336kB low:87592kB high:93848kB active_anon:330436kB inactive_anon:31840kB active_file:531512kB inactive_file:491372kB unevictable:108544kB writepending:121984kB present:3129176kB managed:3019336kB mlocked:108544kB kernel_stack:2704kB pagetables:2944kB bounce:0kB free_pcp:3800kB local_pcp:256kB free_cma:0kB
> 	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 0 4966 4966 4966
> 	[Mon Mar 25 23:35:18 2019] Node 0 Normal free:141932kB min:42420kB low:53024kB high:63628kB active_anon:453224kB inactive_anon:30792kB active_file:1984568kB inactive_file:737244kB unevictable:153600kB writepending:46544kB present:5242880kB managed:5102032kB mlocked:153600kB kernel_stack:7020kB pagetables:5768kB bounce:0kB free_pcp:4188kB local_pcp:1700kB free_cma:96kB
> 	[Mon Mar 25 23:35:18 2019] lowmem_reserve[]: 0 0 0 0 0
> 	[Mon Mar 25 23:35:18 2019] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15844kB
> 	[Mon Mar 25 23:35:18 2019] Node 0 DMA32: 12698*4kB (UME) 6110*8kB (UME) 1087*16kB (UME) 4*32kB (M) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 117192kB
> 	[Mon Mar 25 23:35:18 2019] Node 0 Normal: 13507*4kB (UMEHC) 8008*8kB (UMEHC) 1374*16kB (UMEH) 3*32kB (H) 4*64kB (H) 4*128kB (H) 2*256kB (H) 1*512kB (H) 0*1024kB 0*2048kB 0*4096kB = 141964kB
> 	[Mon Mar 25 23:35:18 2019] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
> 	[Mon Mar 25 23:35:18 2019] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> 	[Mon Mar 25 23:35:18 2019] 955001 total pagecache pages
> 	[Mon Mar 25 23:35:18 2019] 0 pages in swap cache
> 	[Mon Mar 25 23:35:18 2019] Swap cache stats: add 0, delete 0, find 0/0
> 	[Mon Mar 25 23:35:18 2019] Free swap  = 0kB
> 	[Mon Mar 25 23:35:18 2019] Total swap = 0kB
> 	[Mon Mar 25 23:35:18 2019] 2097012 pages RAM
> 	[Mon Mar 25 23:35:18 2019] 0 pages HighMem/MovableOnly
> 	[Mon Mar 25 23:35:18 2019] 62693 pages reserved
> 	[Mon Mar 25 23:35:18 2019] 4096 pages cma reserved
> 	[Mon Mar 25 23:35:18 2019] 0 pages hwpoisoned
> 
> As far as I can tell from logs of memory usage (recording memcg and
> MemAvail stats every second), there are gigabytes of available (clean
> page cache) RAM at all times during these tests.
> 
