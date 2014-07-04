Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37062 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaGDGX4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 02:23:56 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 5A4A63EE0C0
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 15:23:54 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 3DACCAC0934
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 15:23:53 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B1A2F1DB803E
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 15:23:52 +0900 (JST)
Message-ID: <53B6486D.9010006@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 15:23:41 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <russell@coker.com.au>, Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
References: <20140704011938.GO11539@merlins.org> <1937402.nCIA16QR35@xev>
In-Reply-To: <1937402.nCIA16QR35@xev>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

(2014/07/04 13:33), Russell Coker wrote:
> On Thu, 3 Jul 2014 18:19:38 Marc MERLIN wrote:
>> I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
>> running out of memory and deadlocking (panic= doesn't even work).
>> I downgraded back to 3.14, but I already had the problem once since then.
>
> Is there any correlation between such problems and BTRFS operations such as
> creating snapshots or running a scrub/balance?

Were you running scrub, Marc?

http://marc.merlins.org/tmp/btrfs-oom.txt:
===
...
[90621.895922] [ 8034]     0  8034     1315      164       5       46             0 btrfs-scrub
...
===

In this case, you would hit kernel memory leak. However, I can't find
who is the root cause from this log.

Marc, do you change

  - software and its setting,
  - operations,
  - hardware configuration,

or any other, just before detecting first OOM?

You have 8GB RAM and there is plenty of swap space.

===============================================================================
[90621.895719] 2021665 pages RAM
...
[90621.895718] Free swap  = 15230536kB
===============================================================================

Here are the avaliable memory of for each OOM-killer.

1st OOM:
===============================================================================
[90622.074758] Out of memory: Kill process 11452 (mh) score 2 or sacrifice child
[90622.074760] Killed process 11452 (mh) total-vm:66208kB, anon-rss:0kB, file-rss:872kB
[90622.425826] rfx-xpl-static invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
                                                   ~~~~~~~~~~~~~~~~~~~~~~~~~~

It failed to acquire order=0 (2^0=1) page. So it's not
kernel-memory-fragmentation case. Since __GFP_IO(0x80) and __GFP_FS(0x80) is
set in gfp_mask, it can swap out anon/file pages to swap/filesystems to prepare
free memories.


[90622.425829] rfx-xpl-static cpuset=/ mems_allowed=0
[90622.425832] CPU: 2 PID: 748 Comm: rfx-xpl-static Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[90622.425833] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[90622.425834]  0000000000000000 ffff8801414a79d8 ffffffff8160a06d ffff8801434b2050
[90622.425838]  ffff8801414a7a68 ffffffff81607078 0000000000000000 ffffffff8160dd00
[90622.425841]  ffff8801414a7a08 ffffffff810501b4 ffff8801414a7a48 ffffffff8109cb05
[90622.425844] Call Trace:
[90622.425846]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[90622.425851]  [<ffffffff81607078>] dump_header+0x7f/0x206
[90622.425854]  [<ffffffff8160dd00>] ? mutex_unlock+0x16/0x18
[90622.425857]  [<ffffffff810501b4>] ? put_online_cpus+0x6c/0x6e
[90622.425861]  [<ffffffff8109cb05>] ? rcu_oom_notify+0xb3/0xc6
[90622.425865]  [<ffffffff81101a7f>] oom_kill_process+0x6e/0x30e
[90622.425869]  [<ffffffff811022b6>] out_of_memory+0x42e/0x461
[90622.425872]  [<ffffffff81106dfe>] __alloc_pages_nodemask+0x673/0x854
[90622.425876]  [<ffffffff8113b654>] alloc_pages_vma+0xd1/0x116
[90622.425880]  [<ffffffff81130ab7>] read_swap_cache_async+0x74/0x13b
[90622.425883]  [<ffffffff81130cc1>] swapin_readahead+0x143/0x152
[90622.425886]  [<ffffffff810fede9>] ? find_get_page+0x69/0x75
[90622.425889]  [<ffffffff81122adf>] handle_mm_fault+0x56b/0x9b0
[90622.425892]  [<ffffffff81612de6>] __do_page_fault+0x381/0x3cd
[90622.425895]  [<ffffffff81078cfc>] ? wake_up_state+0x12/0x12
[90622.425899]  [<ffffffff8115d770>] ? path_put+0x1e/0x21
[90622.425903]  [<ffffffff81612e57>] do_page_fault+0x25/0x27
[90622.425906]  [<ffffffff816103f8>] page_fault+0x28/0x30
[90622.425910] Mem-Info:
[90622.425910] Node 0 DMA per-cpu:
[90622.425913] CPU    0: hi:    0, btch:   1 usd:   0
[90622.425914] CPU    1: hi:    0, btch:   1 usd:   0
[90622.425915] CPU    2: hi:    0, btch:   1 usd:   0
[90622.425916] CPU    3: hi:    0, btch:   1 usd:   0
[90622.425916] Node 0 DMA32 per-cpu:
[90622.425919] CPU    0: hi:  186, btch:  31 usd:  24
[90622.425920] CPU    1: hi:  186, btch:  31 usd:   1
[90622.425921] CPU    2: hi:  186, btch:  31 usd:   0
[90622.425922] CPU    3: hi:  186, btch:  31 usd:   0
[90622.425923] Node 0 Normal per-cpu:
[90622.425924] CPU    0: hi:  186, btch:  31 usd:   0
[90622.425925] CPU    1: hi:  186, btch:  31 usd:   0
[90622.425926] CPU    2: hi:  186, btch:  31 usd:   0
[90622.425928] CPU    3: hi:  186, btch:  31 usd:   0
[90622.425932] active_anon:57 inactive_anon:92 isolated_anon:0
[90622.425932]  active_file:987 inactive_file:1232 isolated_file:0
[90622.425932]  unevictable:1389 dirty:590 writeback:1 unstable:0
[90622.425932]  free:25102 slab_reclaimable:9147 slab_unreclaimable:30944


There are few anon/file, in other word, reclaimable pages.
The system would be almost full of kernel memory.
As I said, kernel memory leak would happen here.


[90622.425932]  mapped:771 shmem:104 pagetables:1487 bounce:0
[90622.425932]  free_cma:0
[90622.425933] Node 0 DMA free:15360kB min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15980kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
~~~~~~~~~~~~~~~~~~~~~~


"all_unreclaimable? == yes" means "page reclaim work do my best
and there is nothing to do any more".


[90622.425940] lowmem_reserve[]: 0 3204 7691 7691
[90622.425943] Node 0 DMA32 free:45816kB min:28100kB low:35124kB high:42148kB active_anon:0kB inactive_anon:88kB active_file:1336kB inactive_file:1624kB unevictable:1708kB isolated(anon):0kB isolated(file):0kB present:3362328kB managed:3284952kB mlocked:1708kB dirty:244kB writeback:0kB mapped:964kB shmem:0kB slab_reclaimable:128kB slab_unreclaimable:4712kB kernel_stack:1824kB pagetables:2096kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:4807 all_unreclaimable? yes
[90622.425950] lowmem_reserve[]: 0 0 4486 4486
[90622.425953] Node 0 Normal free:39232kB min:39348kB low:49184kB high:59020kB active_anon:228kB inactive_anon:280kB active_file:2612kB inactive_file:3304kB unevictable:3848kB isolated(anon):0kB isolated(file):0kB present:4708352kB managed:4594480kB mlocked:3848kB dirty:2116kB writeback:4kB mapped:2120kB shmem:416kB slab_reclaimable:36460kB slab_unreclaimable:119064kB kernel_stack:2040kB pagetables:3852kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:9683 all_unreclaimable? yes
[90622.425959] lowmem_reserve[]: 0 0 0 0
[90622.425962] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15360kB
[90622.425973] Node 0 DMA32: 10492*4kB (UEM) 2*8kB (U) 0*16kB 0*32kB 1*64kB (R) 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 46016kB
[90622.425985] Node 0 Normal: 8763*4kB (UEM) 33*8kB (UE) 2*16kB (U) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB (R) = 39444kB
[90622.425997] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[90622.425998] 3257 total pagecache pages
[90622.425999] 53 pages in swap cache
[90622.426000] Swap cache stats: add 145114, delete 145061, find 3322456/3324032
[90622.426001] Free swap  = 15277320kB
[90622.426002] Total swap = 15616764kB
[90622.426002] 2021665 pages RAM
[90622.426003] 0 pages HighMem/MovableOnly
[90622.426004] 28468 pages reserved
[90622.426004] 0 pages hwpoisoned
[90622.426005] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[90622.426011] [  917]     0   917      754       96       5      135         -1000 udevd
[90622.426014] [ 1634]     0  1634      592       81       5       50             0 bootlogd
[90622.426016] [ 1635]     0  1635      510       50       4       15             0 startpar
[90622.426020] [ 4336]     0  4336     1257      153       5      260             0 pinggw
[90622.426022] [ 7130]     0  7130      677       99       5       57             0 rpcbind
[90622.426024] [ 7160]   122  7160      746      152       5      100             0 rpc.statd
[90622.426026] [ 7195]     0  7195      757       74       5       44             0 rpc.idmapd
[90622.426028] [ 7604]     0  7604      753       87       5      136         -1000 udevd
[90622.426030] [ 8016]     0  8016      564      144       4       24             0 getty
===============================================================================

All processes above uses a little memory. It's because they are
already evicted to swap/filesystem beforehand.

Thanks,
Satoru

>
> Back in ~3.10 days I had serious problems with BTRFS memory use when removing
> multiple snapshots or balancing.  But at about 3.13 they all seemed to get
> fixed.
>
> I usually didn't have a kernel panic when I had such problems (although I
> sometimes had a system lock up solid such that I couldn't even determine what
> it's problem was).  Usually the Oom handler started killing big processes such
> as chromium when it shouldn't have needed to.
>
> Note that I haven't verified that the BTRFS memory use is reasonable in all
> such situations.  Merely that it doesn't use enough to kill my systems.
>

