Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadow.officetone.com ([38.109.180.24]:41083 "EHLO
	shadow.officetone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaCICYI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 21:24:08 -0500
Received: from maria.officetone.com (shadow.officetone.com [127.0.0.1])
	by shadow.officetone.com (Postfix) with ESMTP id AA7D11FF6F3
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 02:24:07 +0000 (UTC)
Message-ID: <531BD0C5.1040607@travislists.com>
Date: Sun, 09 Mar 2014 02:24:05 +0000
From: Travis Cross <tc@travislists.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs send fails with "cannot allocate memory"
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

When running:

  btrfs send -vvv <subvol> | ssh <host> "btrfs receive -vvve <dir>"

the command fails well into the send with:

  ERROR: send ioctl failed with -12: Cannot allocate memory
  ERROR: unexpected EOF in stream.

I've been able to successfully btrfs send other large volumes off of
this filesystem, but the two volumes that have a particularly large
number of small files both hit this error consistently.  The system
has 4G of memory.

I had hoped that adding a fast swap device would help get past this
issue, but no such luck.  Despite 60G of SSD swap being available, it
was never touched.  The box isn't doing anything other than this
send.

Someone reported a similar issue in the bug tracker, but then
abandoned it and moved to using rsync:

  https://bugzilla.kernel.org/show_bug.cgi?id=60761

On 2013-12-05 Jim Salter <jim@jrs-s.net> also reported this issue to
the mailing list.  He was running on a lightly loaded box with 32G of
RAM.  Duncan <1i5t5.duncan@cox.net> mentioned that work on memory
leaks was going in on the 3.13 cycle, and that the devs would be
interested if it was still an issue on 3.13.  Apparently it is.

I'm running a fully up-to-date Debian sid box at Linux 3.13.5.  I'm
including below the full kernel output when this fails.

Also, does there exist some workaround for recreating the parent
subvolume on another device such that child subvolumes can be btrfs
sent against it (perhaps with rsync)?  I tried the obvious approaches
and couldn't get a seemingly identical volume to be recognized as the
parent of a btrfs send by btrfs receive.

$ uname -a
Linux 3.13-1-amd64 #1 SMP Debian 3.13.5-1 (2014-03-04) x86_64 GNU/Linux

Mar  9 00:51:42 kernel: [13332.222953] btrfs: page allocation failure: order:5, mode:0x204050
Mar  9 00:51:42 kernel: [13332.229190] CPU: 0 PID: 1225 Comm: btrfs Tainted: G        W    3.13-1-amd64 #1 Debian 3.13.5-1
Mar  9 00:51:42 kernel: [13332.237951] Hardware name: Supermicro X7SPA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
Mar  9 00:51:42 kernel: [13332.245715]  ffff8800b7d41708 ffffffff814a0927 0000000000204050 ffffffff8111b4f3
Mar  9 00:51:42 kernel: [13332.253356]  0000000000000000 ffff88013fff9b00 0000000000000002 0000000000000000
Mar  9 00:51:42 kernel: [13332.260860]  0000000000000005 ffffffff81130fad ffff88013fff9b08 0000000000000002
Mar  9 00:51:42 kernel: [13332.268463] Call Trace:
Mar  9 00:51:42 kernel: [13332.270943]  [<ffffffff814a0927>] ? dump_stack+0x41/0x51
Mar  9 00:51:42 kernel: [13332.276320]  [<ffffffff8111b4f3>] ? warn_alloc_failed+0xe3/0x130
Mar  9 00:51:42 kernel: [13332.282389]  [<ffffffff81130fad>] ? next_online_pgdat+0x1d/0x50
Mar  9 00:51:42 kernel: [13332.288369]  [<ffffffff8111f5ba>] ? __alloc_pages_nodemask+0x81a/0x9d0
Mar  9 00:51:42 kernel: [13332.294936]  [<ffffffff8116076f>] ? kmem_getpages+0x5f/0x140
Mar  9 00:51:42 kernel: [13332.300639]  [<ffffffff81161f1e>] ? fallback_alloc+0x15e/0x200
Mar  9 00:51:42 kernel: [13332.306541]  [<ffffffff811639fa>] ? __kmalloc_track_caller+0x2da/0x4a0
Mar  9 00:51:42 kernel: [13332.313178]  [<ffffffffa027cdcf>] ? ulist_add_merge+0x1bf/0x290 [btrfs]
Mar  9 00:51:42 kernel: [13332.319841]  [<ffffffff81130538>] ? krealloc+0x48/0xa0
Mar  9 00:51:42 kernel: [13332.325052]  [<ffffffffa027cdcf>] ? ulist_add_merge+0x1bf/0x290 [btrfs]
Mar  9 00:51:42 kernel: [13332.331731]  [<ffffffffa027b582>] ? find_parent_nodes+0x9c2/0xe90 [btrfs]
Mar  9 00:51:42 kernel: [13332.338579]  [<ffffffffa027bb02>] ? btrfs_find_all_roots+0x92/0x100 [btrfs]
Mar  9 00:51:42 kernel: [13332.345603]  [<ffffffffa0280d30>] ? record_ref+0xc0/0xc0 [btrfs]
Mar  9 00:51:42 kernel: [13332.351674]  [<ffffffffa027c402>] ? iterate_extent_inodes+0x132/0x250 [btrfs]
Mar  9 00:51:42 kernel: [13332.358871]  [<ffffffffa0284eb3>] ? process_extent+0x6c3/0x1130 [btrfs]
Mar  9 00:51:42 kernel: [13332.365544]  [<ffffffffa02212ed>] ? btrfs_buffer_uptodate+0x4d/0x70 [btrfs]
Mar  9 00:51:42 kernel: [13332.372569]  [<ffffffffa0285bfd>] ? changed_cb+0x2dd/0x9d0 [btrfs]
Mar  9 00:51:42 kernel: [13332.378805]  [<ffffffffa0224db7>] ? record_root_in_trans+0xa7/0x100 [btrfs]
Mar  9 00:51:42 kernel: [13332.385824]  [<ffffffffa0245168>] ? read_extent_buffer+0xc8/0x120 [btrfs]
Mar  9 00:51:42 kernel: [13332.392669]  [<ffffffffa0208a73>] ? btrfs_search_slot_for_read+0xa3/0x190 [btrfs]
Mar  9 00:51:42 kernel: [13332.400213]  [<ffffffffa0286cdc>] ? btrfs_ioctl_send+0x9ec/0xbc0 [btrfs]
Mar  9 00:51:42 kernel: [13332.406972]  [<ffffffffa0256b6a>] ? btrfs_ioctl+0xfca/0x25d0 [btrfs]
Mar  9 00:51:42 kernel: [13332.413361]  [<ffffffff8108706c>] ? set_task_cpu+0x5c/0x160
Mar  9 00:51:42 kernel: [13332.418963]  [<ffffffff8126f860>] ? cpumask_next_and+0x30/0x40
Mar  9 00:51:42 kernel: [13332.424833]  [<ffffffff8108d4ef>] ? select_task_rq_fair+0x2af/0x6f0
Mar  9 00:51:42 kernel: [13332.431131]  [<ffffffff8101981f>] ? native_sched_clock+0xf/0x70
Mar  9 00:51:42 kernel: [13332.437088]  [<ffffffff8108f827>] ? enqueue_task_fair+0x2c7/0xe10
Mar  9 00:51:42 kernel: [13332.443211]  [<ffffffff81086e25>] ? check_preempt_curr+0x65/0x90
Mar  9 00:51:42 kernel: [13332.449261]  [<ffffffff81088c45>] ? wake_up_new_task+0xd5/0x160
Mar  9 00:51:42 kernel: [13332.455215]  [<ffffffff8118b5bf>] ? do_vfs_ioctl+0x2cf/0x4a0
Mar  9 00:51:42 kernel: [13332.460912]  [<ffffffff8118b810>] ? SyS_ioctl+0x80/0xa0
Mar  9 00:51:42 kernel: [13332.466169]  [<ffffffff814ade99>] ? stub_clone+0x69/0x90
Mar  9 00:51:42 kernel: [13332.471519]  [<ffffffff814adb39>] ? system_call_fastpath+0x16/0x1b
Mar  9 00:51:42 kernel: [13332.477725] Mem-Info:
Mar  9 00:51:42 kernel: [13332.480027] Node 0 DMA per-cpu:
Mar  9 00:51:42 kernel: [13332.483194] CPU    0: hi:    0, btch:   1 usd:   0
Mar  9 00:51:42 kernel: [13332.488020] CPU    1: hi:    0, btch:   1 usd:   0
Mar  9 00:51:42 kernel: [13332.492846] CPU    2: hi:    0, btch:   1 usd:   0
Mar  9 00:51:42 kernel: [13332.497666] CPU    3: hi:    0, btch:   1 usd:   0
Mar  9 00:51:42 kernel: [13332.502485] Node 0 DMA32 per-cpu:
Mar  9 00:51:42 kernel: [13332.505840] CPU    0: hi:  186, btch:  31 usd:   0
Mar  9 00:51:42 kernel: [13332.510656] CPU    1: hi:  186, btch:  31 usd:   0
Mar  9 00:51:42 kernel: [13332.515476] CPU    2: hi:  186, btch:  31 usd:   0
Mar  9 00:51:42 kernel: [13332.520295] CPU    3: hi:  186, btch:  31 usd:   0
Mar  9 00:51:43 kernel: [13332.525120] Node 0 Normal per-cpu:
Mar  9 00:51:43 kernel: [13332.528575] CPU    0: hi:  186, btch:  31 usd:   0
Mar  9 00:51:43 kernel: [13332.533399] CPU    1: hi:  186, btch:  31 usd:  53
Mar  9 00:51:43 kernel: [13332.538217] CPU    2: hi:  186, btch:  31 usd:  50
Mar  9 00:51:43 kernel: [13332.543078] CPU    3: hi:  186, btch:  31 usd:  51
Mar  9 00:51:43 kernel: [13332.547947] active_anon:12268 inactive_anon:4521 isolated_anon:0
Mar  9 00:51:43 kernel: [13332.547947]  active_file:406703 inactive_file:417940 isolated_file:0
Mar  9 00:51:43 kernel: [13332.547947]  unevictable:0 dirty:0 writeback:0 unstable:0
Mar  9 00:51:43 kernel: [13332.547947]  free:92360 slab_reclaimable:64963 slab_unreclaimable:5878
Mar  9 00:51:43 kernel: [13332.547947]  mapped:1719 shmem:304 pagetables:730 bounce:0
Mar  9 00:51:43 kernel: [13332.547947]  free_cma:0
Mar  9 00:51:43 kernel: [13332.580098] Node 0 DMA free:15904kB min:264kB low:328kB high:396kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15988kB managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Mar  9 00:51:43 kernel: [13332.619392] lowmem_reserve[]: 0 2980 3947 3947
Mar  9 00:51:43 kernel: [13332.624048] Node 0 DMA32 free:254184kB min:50832kB low:63540kB high:76248kB active_anon:41484kB inactive_anon:10484kB active_file:1251728kB inactive_file:1262232kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3128832kB managed:3055144kB mlocked:0kB dirty:0kB writeback:0kB mapped:5364kB shmem:1032kB slab_reclaimable:193640kB slab_unreclaimable:14924kB kernel_stack:800kB pagetables:2280kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Mar  9 00:51:43 kernel: [13332.667841] lowmem_reserve[]: 0 0 966 966
Mar  9 00:51:43 kernel: [13332.671961] Node 0 Normal free:98708kB min:16484kB low:20604kB high:24724kB active_anon:7588kB inactive_anon:7600kB active_file:375084kB inactive_file:409628kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1048576kB managed:990020kB mlocked:0kB dirty:0kB writeback:0kB mapped:1512kB shmem:184kB slab_reclaimable:66212kB slab_unreclaimable:8588kB kernel_stack:424kB pagetables:640kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Mar  9 00:51:43 kernel: [13332.714972] lowmem_reserve[]: 0 0 0 0
Mar  9 00:51:43 kernel: [13332.718742] Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15904kB
Mar  9 00:51:43 kernel: [13332.732221] Node 0 DMA32: 41340*4kB (UEM) 8769*8kB (UEM) 763*16kB (UEM) 77*32kB (UEM) 6*64kB (UE) 1*128kB (R) 0*256kB 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 254280kB
Mar  9 00:51:43 kernel: [13332.748316] Node 0 Normal: 21479*4kB (UE) 1386*8kB (UM) 0*16kB 7*32kB (R) 2*64kB (R) 1*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 98764kB
Mar  9 00:51:43 kernel: [13332.762771] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Mar  9 00:51:43 kernel: [13332.771229] 825017 total pagecache pages
Mar  9 00:51:43 kernel: [13332.775191] 6 pages in swap cache
Mar  9 00:51:43 kernel: [13332.778536] Swap cache stats: add 152, delete 146, find 0/1
Mar  9 00:51:43 kernel: [13332.784141] Free swap  = 58615120kB
Mar  9 00:51:43 kernel: [13332.787634] Total swap = 58615700kB
Mar  9 00:51:43 kernel: [13332.791152] 1048349 pages RAM
Mar  9 00:51:43 kernel: [13332.794165] 0 pages HighMem/MovableOnly
Mar  9 00:51:43 kernel: [13332.798035] 14639 pages reserved
Mar  9 00:51:43 kernel: [13332.801301] SLAB: Unable to allocate memory on node 0 (gfp=0x4050)
Mar  9 00:51:43 kernel: [13332.807507]   cache: kmalloc-131072, object size: 131072, order: 5
Mar  9 00:51:43 kernel: [13332.813737]   node 0: slabs: 16/16, objs: 16/16, free: 0

Cheers,

-- TC
