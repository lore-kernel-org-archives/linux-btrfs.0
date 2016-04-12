Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:51529 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbcDLUCs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 16:02:48 -0400
Date: Tue, 12 Apr 2016 23:02:42 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 00/13] Introduce device state 'failed', spare device
 and auto replace
Message-ID: <20160412200242.GB17845@jeknote.loshitsa1.net>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 10:15:50PM +0800, Anand Jain wrote:
> Thanks for various comments, tests and feedback.

Seems working for me. I have triggered OOM killer while testing this in VirtualBox but
I don't think that it is related to autoreplace, it seems to be
scrub implementation issue:

[  449.615157] CPU: 0 PID: 1771 Comm: btrfs-health Not tainted 4.4.5-scst31x+ #25
[  449.621763] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  449.647614]  0000000000000000 ffff8800601c7660 ffffffff813529e3 ffff8800601c7858
[  449.659766]  ffff88005ba66140 ffff8800601c76d0 ffffffff8121b41e ffff8800601c7680
[  449.683167]  ffffffff810d7ccd ffff8800601c76a0 0000000000000206 ffffffff81c6d0e0
[  449.700746] Call Trace:
[  449.705078]  [<ffffffff813529e3>] dump_stack+0x85/0xc2
[  449.715238]  [<ffffffff8121b41e>] dump_header+0x5a/0x21d
[  449.725400]  [<ffffffff810d7ccd>] ? trace_hardirqs_on+0xd/0x10
[  449.741261]  [<ffffffff811a3e80>] oom_kill_process+0x200/0x3d0
[  449.753042]  [<ffffffff811a4602>] out_of_memory+0x562/0x580
[  449.765923]  [<ffffffff811a4373>] ? out_of_memory+0x2d3/0x580
[  449.768455]  [<ffffffff811aa98c>] __alloc_pages_nodemask+0xafc/0xc80
[  449.770281]  [<ffffffff811f5ebb>] alloc_pages_current+0x9b/0x1c0
[  449.783371]  [<ffffffffa02160f5>] scrub_pages+0xb5/0x400 [btrfs]
[  449.804598]  [<ffffffffa0212a65>] ? scrub_find_csum+0xd5/0x110 [btrfs]
[  449.819145]  [<ffffffffa0216dce>] scrub_stripe+0x82e/0x1180 [btrfs]
[  449.829299]  [<ffffffffa0217830>] scrub_chunk+0x110/0x160 [btrfs]
[  449.835859]  [<ffffffffa0217afc>] scrub_enumerate_chunks+0x27c/0x560 [btrfs]
[  449.852805]  [<ffffffff810ceb00>] ? wake_atomic_t_function+0x30/0x70
[  449.867081]  [<ffffffffa021930d>] btrfs_scrub_dev+0x1cd/0x680 [btrfs]
[  449.876784]  [<ffffffffa022d234>] btrfs_dev_replace_start+0x334/0x540 [btrfs]
[  449.891503]  [<ffffffffa022def8>] btrfs_auto_replace_start+0xf8/0x140 [btrfs]
[  449.911958]  [<ffffffffa01ac4e6>] health_kthread+0x246/0x490 [btrfs]
[  449.922132]  [<ffffffffa01ac3d8>] ? health_kthread+0x138/0x490 [btrfs]
[  449.946273]  [<ffffffffa01ac2a0>] ? btrfs_congested_fn+0x180/0x180 [btrfs]
[  449.975742]  [<ffffffff810a70df>] kthread+0xef/0x110
[  449.994914]  [<ffffffff810dc081>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[  450.022306]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[  450.036069]  [<ffffffff81637d2f>] ret_from_fork+0x3f/0x70
[  450.045622]  [<ffffffff810a6ff0>] ? kthread_create_on_node+0x200/0x200
[  450.047625] Mem-Info:
[  450.055195] active_anon:30 inactive_anon:71 isolated_anon:0
[  450.055195]  active_file:220 inactive_file:980 isolated_file:0
[  450.055195]  unevictable:527 dirty:41 writeback:59 unstable:0
[  450.055195]  slab_reclaimable:18226 slab_unreclaimable:283931
[  450.055195]  mapped:612 shmem:10 pagetables:1209 bounce:0
[  450.055195]  free:3310 free_pcp:153 free_cma:0
[  450.069070] Node 0 DMA free:6232kB min:48kB low:60kB high:72kB active_anon:0kB inactive_anon:0kB active_file:8kB ina
ctive_file:16kB unevictable:28kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:28kB dir
ty:4kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:788kB slab_unreclaimable:6236kB kernel_stack:96kB pagetables
:48kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:220 all_unreclaim
able? yes
[  450.161023] lowmem_reserve[]: 0 1546 1546 1546
[  450.181786] Node 0 DMA32 free:10620kB min:4896kB low:6120kB high:7344kB active_anon:120kB inactive_anon:176kB active
_file:964kB inactive_file:1132kB unevictable:2080kB isolated(anon):0kB isolated(file):0kB present:1668032kB managed:158
3780kB mlocked:2080kB dirty:160kB writeback:112kB mapped:2568kB shmem:40kB slab_reclaimable:72116kB slab_unreclaimable:1129488kB kernel_stack:4192kB pagetables:4788kB unstable:0kB bounce:0kB free_pcp:740kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  450.267804] lowmem_reserve[]: 0 0 0 0
[  450.272899] Node 0 DMA: 45*4kB (UME) 31*8kB (UME) 19*16kB (ME) 10*32kB (ME) 7*64kB (ME) 7*128kB (UME) 3*256kB (UME) 2*512kB (UM) 2*1024kB (M) 0*2048kB 0*4096kB = 6236kB
[  450.286381] Node 0 DMA32: 2006*4kB (UME) 453*8kB (UME) 68*16kB (UME) 15*32kB (UM) 2*64kB (UM) 1*128kB (M) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 13472kB
[  450.299928] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  450.304622] 985 total pagecache pages
[  450.306857] 111 pages in swap cache
[  450.308870] Swap cache stats: add 9380, delete 9269, find 113/183
[  450.312090] Free swap  = 381628kB
[  450.314188] Total swap = 418492kB
[  450.317644] 421006 pages RAM
[  450.319573] 0 pages HighMem/MovableOnly
[  450.322100] 21084 pages reserved
[  450.323853] 0 pages hwpoisoned
...

-- 
Yauhen Kharuzhy
