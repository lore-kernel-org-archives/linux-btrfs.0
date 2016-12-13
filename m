Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.208.21]:42468 "EHLO
        extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753840AbcLMU01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 15:26:27 -0500
Subject: Re: page allocation stall in kernel 4.9 when copying files from one
 btrfs hdd to another
To: Xin Zhou <xin.zhou@gmx.com>
References: <bd1cf980-56cc-3212-8de0-b2cc1bf576cf@prnet.org>
 <trinity-edd53cea-8cca-472f-a0e4-884b7fea9e2c-1481658929256@3capp-mailcom-bs06>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
From: David Arendt <admin@prnet.org>
Message-ID: <a46f1790-9819-0e44-dd41-1db7d26ac8ae@prnet.org>
Date: Tue, 13 Dec 2016 21:26:04 +0100
MIME-Version: 1.0
In-Reply-To: <trinity-edd53cea-8cca-472f-a0e4-884b7fea9e2c-1481658929256@3capp-mailcom-bs06>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

unfortunately I did not dump meminfo before the crash.

Here is the actual meminfo as of now with the copy running for about 3
hours.

MemTotal:       32806572 kB
MemFree:          197336 kB
MemAvailable:   31226888 kB
Buffers:              52 kB
Cached:         30603160 kB
SwapCached:        11880 kB
Active:         29015008 kB
Inactive:        2017292 kB
Active(anon):     162124 kB
Inactive(anon):   285104 kB
Active(file):   28852884 kB
Inactive(file):  1732188 kB
Unevictable:        7092 kB
Mlocked:            7092 kB
SwapTotal:      62522692 kB
SwapFree:       62460464 kB
Dirty:            231944 kB
Writeback:             0 kB
AnonPages:        425160 kB
Mapped:           227656 kB
Shmem:             12160 kB
Slab:            1380280 kB
SReclaimable:     774584 kB
SUnreclaim:       605696 kB
KernelStack:        7840 kB
PageTables:        12800 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    78925976 kB
Committed_AS:    1883256 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:    20220592 kB
DirectMap2M:    13238272 kB
DirectMap1G:     1048576 kB

I will write a cronjob that dumps meminfo every 5 minutes to a file, so
I will have more info on the next crash.

The crash is not an isolated one as I already had this crash multiple
times with -rc7 and -rc8. It seems only to occur when copying from
7200rpm harddisks to 5600rpm ones, and never when copying between two
7200rpm or two 5400rpm.

Thanks,
David Arendt

On 12/13/2016 08:55 PM, Xin Zhou wrote:
> Hi David,
>
> It has GFP_NOFS flags, according to definition,
> the issue might have happened during initial DISK/IO.
>
> By the way, did you get a chance to dump the meminfo and run "top" before the system hang?
> It seems more info about the system running state needed to know the issue. Thanks.
>
> Xin
>
>  
>
> Sent: Tuesday, December 13, 2016 at 9:11 AM
> From: "David Arendt" <admin@prnet.org>
> To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: page allocation stall in kernel 4.9 when copying files from one btrfs hdd to another
> Hi,
>
> I receive the following page allocation stall while copying lots of
> large files from one btrfs hdd to another.
>
> Dec 13 13:04:29 server kernel: kworker/u16:8: page allocation stalls for
> 12260ms, order:0, mode:0x2400840(GFP_NOFS|__GFP_NOFAIL)
> Dec 13 13:04:29 server kernel: CPU: 0 PID: 24959 Comm: kworker/u16:8
> Tainted: P O 4.9.0 #1
> Dec 13 13:04:29 server kernel: Hardware name: ASUS All Series/H87M-PRO,
> BIOS 2102 10/28/2014
> Dec 13 13:04:29 server kernel: Workqueue: btrfs-extent-refs
> btrfs_extent_refs_helper
> Dec 13 13:04:29 server kernel: 0000000000000000 ffffffff813f3a59
> ffffffff81976b28 ffffc90011093750
> Dec 13 13:04:29 server kernel: ffffffff81114fc1 02400840f39b6bc0
> ffffffff81976b28 ffffc900110936f8
> Dec 13 13:04:29 server kernel: ffff880700000010 ffffc90011093760
> ffffc90011093710 0000000002400840
> Dec 13 13:04:29 server kernel: Call Trace:
> Dec 13 13:04:29 server kernel: [<ffffffff813f3a59>] ? dump_stack+0x46/0x5d
> Dec 13 13:04:29 server kernel: [<ffffffff81114fc1>] ?
> warn_alloc+0x111/0x130
> Dec 13 13:04:33 server kernel: [<ffffffff81115c38>] ?
> __alloc_pages_nodemask+0xbe8/0xd30
> Dec 13 13:04:33 server kernel: [<ffffffff8110de74>] ?
> pagecache_get_page+0xe4/0x230
> Dec 13 13:04:33 server kernel: [<ffffffff81323a8b>] ?
> alloc_extent_buffer+0x10b/0x400
> Dec 13 13:04:33 server kernel: [<ffffffff812ef8c5>] ?
> btrfs_alloc_tree_block+0x125/0x560
> Dec 13 13:04:33 server kernel: [<ffffffff8132442f>] ?
> read_extent_buffer_pages+0x21f/0x280
> Dec 13 13:04:33 server kernel: [<ffffffff812d81f1>] ?
> __btrfs_cow_block+0x141/0x580
> Dec 13 13:04:33 server kernel: [<ffffffff812d87b0>] ?
> btrfs_cow_block+0x100/0x150
> Dec 13 13:04:33 server kernel: [<ffffffff812dc1d9>] ?
> btrfs_search_slot+0x1e9/0x9c0
> Dec 13 13:04:33 server kernel: [<ffffffff8131ead2>] ?
> __set_extent_bit+0x512/0x550
> Dec 13 13:04:33 server kernel: [<ffffffff812e1ab5>] ?
> lookup_inline_extent_backref+0xf5/0x5e0
> Dec 13 13:04:34 server kernel: [<ffffffff8131f0a4>] ?
> set_extent_bit+0x24/0x30
> Dec 13 13:04:34 server kernel: [<ffffffff812e4334>] ?
> update_block_group.isra.34+0x114/0x380
> Dec 13 13:04:34 server kernel: [<ffffffff812e4694>] ?
> __btrfs_free_extent.isra.35+0xf4/0xd20
> Dec 13 13:04:34 server kernel: [<ffffffff8134d561>] ?
> btrfs_merge_delayed_refs+0x61/0x5d0
> Dec 13 13:04:34 server kernel: [<ffffffff812e8bd2>] ?
> __btrfs_run_delayed_refs+0x902/0x10a0
> Dec 13 13:04:34 server kernel: [<ffffffff812ec0f0>] ?
> btrfs_run_delayed_refs+0x90/0x2a0
> Dec 13 13:04:34 server kernel: [<ffffffff812ec384>] ?
> delayed_ref_async_start+0x84/0xa0
> Dec 13 13:04:34 server kernel: [<ffffffff8109c16d>] ?
> process_one_work+0x11d/0x3b0
> Dec 13 13:04:34 server kernel: [<ffffffff8109c442>] ?
> worker_thread+0x42/0x4b0
> Dec 13 13:04:34 server kernel: [<ffffffff8109c400>] ?
> process_one_work+0x3b0/0x3b0
> Dec 13 13:04:34 server kernel: [<ffffffff8109c400>] ?
> process_one_work+0x3b0/0x3b0
> Dec 13 13:04:34 server kernel: [<ffffffff8108ba5e>] ?
> do_group_exit+0x2e/0xa0
> Dec 13 13:04:34 server kernel: [<ffffffff810a12d9>] ? kthread+0xb9/0xd0
> Dec 13 13:04:34 server kernel: [<ffffffff810a1220>] ?
> kthread_park+0x50/0x50
> Dec 13 13:04:34 server kernel: [<ffffffff81798cd2>] ?
> ret_from_fork+0x22/0x30
> Dec 13 13:04:34 server kernel: Mem-Info:
> Dec 13 13:04:34 server kernel: active_anon:20 inactive_anon:34
> isolated_anon:0\x0a active_file:7370032 inactive_file:450105
> isolated_file:320\x0a unevictable:0 dirty:522748 writeback:189
> unstable:0\x0a slab_reclaimable:178255 slab_unreclaimable:124617\x0a
> mapped:4236 shmem:0 pagetables:1163 bounce:0\x0a free:38224 free_pcp:241
> free_cma:0
> Dec 13 13:04:34 server kernel: Node 0 active_anon:80kB
> inactive_anon:136kB active_file:29480128kB inactive_file:1800420kB
> unevictable:0kB isolated(anon):0kB isolated(file):1280kB mapped:16944kB
> dirty:2090992kB writeback:756kB shmem:0kB writeback_tmp:0kB unstable:0kB
> pages_scanned:258821 all_unreclaimable? no
> Dec 13 13:04:34 server kernel: DMA free:15868kB min:8kB low:20kB
> high:32kB active_anon:0kB inactive_anon:0kB active_file:0kB
> inactive_file:0kB unevictable:0kB writepending:0kB present:15976kB
> managed:15892kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:24kB
> kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
> free_cma:0kB
> Dec 13 13:04:34 server kernel: lowmem_reserve[]: 0 3428 32019 32019
> Dec 13 13:04:34 server kernel: DMA32 free:116800kB min:2448kB low:5956kB
> high:9464kB active_anon:0kB inactive_anon:0kB active_file:3087928kB
> inactive_file:191336kB unevictable:0kB writepending:221828kB
> present:3590832kB managed:3513936kB mlocked:0kB slab_reclaimable:93252kB
> slab_unreclaimable:20520kB kernel_stack:48kB pagetables:212kB bounce:0kB
> free_pcp:4kB local_pcp:0kB free_cma:0kB
> Dec 13 13:04:34 server kernel: lowmem_reserve[]: 0 0 0 0
> Dec 13 13:04:34 server kernel: DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U)
> 1*32kB (U) 1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U)
> 1*2048kB (M) 3*4096kB (M) = 15868kB
> Dec 13 13:04:34 server kernel: DMA32: 940*4kB (UME) 4006*8kB (UME)
> 3308*16kB (UME) 791*32kB (UME) 41*64kB (UE) 1*128kB (U) 0*256kB 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 116800kB
> Dec 13 13:04:34 server kernel: Normal: 75*4kB (E) 192*8kB (UE) 94*16kB
> (UME) 57*32kB (U) 33*64kB (UM) 16*128kB (UM) 10*256kB (UM) 4*512kB (U)
> 0*1024kB 1*2048kB (U) 1*4096kB (U) = 20076kB
> Dec 13 13:04:34 server kernel: Node 0 hugepages_total=0 hugepages_free=0
> hugepages_surp=0 hugepages_size=2048kB
> Dec 13 13:04:34 server kernel: 7820441 total pagecache pages
> Dec 13 13:04:34 server kernel: 69 pages in swap cache
> Dec 13 13:04:34 server kernel: Swap cache stats: add 60282, delete
> 60213, find 249865/258319
> Dec 13 13:04:34 server kernel: Free swap = 62482976kB
> Dec 13 13:04:34 server kernel: Total swap = 62522692kB
> Dec 13 13:04:34 server kernel: 8364614 pages RAM
> Dec 13 13:04:34 server kernel: 0 pages HighMem/MovableOnly
> Dec 13 13:04:34 server kernel: 162971 pages reserved
>
> Has anyone any idea what could go wrong here ?
>
> Thanks in advance,
>
> David Arendt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


