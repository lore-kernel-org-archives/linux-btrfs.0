Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57227 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab3HGSRR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 14:17:17 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 71DE7353F5F
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 20:17:12 +0200 (CEST)
Received: from localhost (cm218-254-66-194.hkcable.com.hk [218.254.66.194])
	by mail.virtall.com (Postfix) with ESMTPSA id 4CD05353F1C
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 20:17:11 +0200 (CEST)
Date: Thu, 8 Aug 2013 02:17:05 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem "hang" after page allocation failure: order:0 +
 kernel BUG at fs/btrfs/extent_io.c:4151
Message-ID: <20130808021705.1dcb139e@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of btrfs filesystems hanged on my server.

By "hang", I mean it's not possible to finish any write operation, i.e.:

# cd /mnt/btrfs

# ls
some-file

# touch 1
[it never returns to shell here]


There are the following processes in "D" state:

root      2397  0.6  0.0      0     0 ?        D    Aug05  19:17 [btrfs-transacti]
root     12293  2.9  0.1  41512 34344 pts/17   D+   Aug06  68:43 rm -rfv really-lots-of-different-files/
root     26613  0.0  0.0      0     0 ?        D    06:08   0:00 [btrfs-flush_del]
root     27256  0.0  0.0  17752   300 pts/18   D+   06:29   0:00 btrfs subvolume snapshot -r /mnt/lxc1/test/latest /mnt/lxc1/test/2013-08-07-06:18:49
root     27257  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]
root     27258  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]
root     27259  0.0  0.0      0     0 ?        D    06:29   0:00 [btrfs-flush_del]



Memory usage is very high and can be attributed to btrfs (see also "Heavy memory leak when using quota groups" thread).

# free
             total       used       free     shared    buffers     cached
Mem:      32638512   31409396    1229116          0       5824    4261256
-/+ buffers/cache:   27142316    5496196
Swap:     16776116      51196   16724920


"sync" never returns; we have this amount of data in "Dirty" (in /proc/meminfo):

Dirty:                 0 kB
Writeback:          8988 kB


It all happened after a page allocation failure:

[137328.086287] btrfs-endio-wri: page allocation failure: order:0, mode:0x20
[137328.086340] CPU: 5 PID: 26812 Comm: btrfs-endio-wri Not tainted 3.10.0 #3
[137328.086388] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[137328.086477]  0000000000000020 ffff8801a293d698 ffffffff81371348 ffff8801a293d728
[137328.086567]  ffffffff810a5629 0000000000000000 ffff88081fb54a60 ffff88081fb54a60
[137328.086656]  ffff88081fdd9a00 ffff88081fdd9a38 0000000100000000 0000000000000000
[137328.086745] Call Trace:
[137328.086793]  [<ffffffff81371348>] dump_stack+0x19/0x1b
[137328.086841]  [<ffffffff810a5629>] warn_alloc_failed+0x110/0x124
[137328.086889]  [<ffffffff810a7be3>] __alloc_pages_nodemask+0x6a4/0x793
[137328.086947]  [<ffffffffa07023a8>] ? btrfs_buffer_uptodate+0x41/0x57 [btrfs]
[137328.086997]  [<ffffffff810d07fc>] alloc_pages_current+0xc8/0xe5
[137328.087051]  [<ffffffffa07212a6>] btrfs_clone_extent_buffer+0x53/0xc3 [btrfs]
[137328.087142]  [<ffffffffa06ebefb>] btrfs_search_old_slot+0x680/0x78b [btrfs]
[137328.087194]  [<ffffffffa06edd71>] btrfs_next_old_leaf+0xc9/0x3a6 [btrfs]
[137328.087249]  [<ffffffffa0718f92>] ? btrfs_get_token_64+0xac/0xc8 [btrfs]
[137328.087302]  [<ffffffffa0718d54>] ? btrfs_get_token_32+0x6/0xc7 [btrfs]
[137328.087356]  [<ffffffffa074da50>] __resolve_indirect_refs+0x331/0x467 [btrfs]
[137328.087448]  [<ffffffffa074e205>] find_parent_nodes+0x357/0x5be [btrfs]
[137328.087501]  [<ffffffffa074e4e8>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[137328.087550]  [<ffffffff810d58b9>] ? kmem_cache_free+0x164/0x17a
[137328.087602]  [<ffffffffa07514bd>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
[137328.087694]  [<ffffffffa071c49f>] ? clear_state_bit+0x106/0x115 [btrfs]
[137328.087746]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
[137328.087839]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
[137328.087891]  [<ffffffffa06f4514>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
[137328.087983]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
[137328.088036]  [<ffffffffa0711224>] btrfs_finish_ordered_io+0x683/0x84e [btrfs]
[137328.088124]  [<ffffffff810a3683>] ? mempool_free_slab+0x12/0x14
[137328.088172]  [<ffffffff810a3717>] ? mempool_free+0x72/0x7a
[137328.088223]  [<ffffffffa073c357>] ? end_compressed_bio_write+0xc0/0xc8 [btrfs]
[137328.088315]  [<ffffffffa07113ff>] finish_ordered_fn+0x10/0x12 [btrfs]
[137328.088368]  [<ffffffffa072ab5c>] worker_loop+0x15e/0x48e [btrfs]
[137328.088420]  [<ffffffffa072a9fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[137328.088469]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
[137328.088516]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
[137328.088565]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
[137328.088612]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
[137328.088660] Mem-Info:
[137328.088702] Node 0 DMA per-cpu:
[137328.088746] CPU    0: hi:    0, btch:   1 usd:   0
[137328.088792] CPU    1: hi:    0, btch:   1 usd:   0
[137328.088837] CPU    2: hi:    0, btch:   1 usd:   0
[137328.088882] CPU    3: hi:    0, btch:   1 usd:   0
[137328.088928] CPU    4: hi:    0, btch:   1 usd:   0
[137328.088973] CPU    5: hi:    0, btch:   1 usd:   0
[137328.089018] CPU    6: hi:    0, btch:   1 usd:   0
[137328.089064] CPU    7: hi:    0, btch:   1 usd:   0
[137328.089109] Node 0 DMA32 per-cpu:
[137328.089153] CPU    0: hi:  186, btch:  31 usd:   0
[137328.089199] CPU    1: hi:  186, btch:  31 usd:   0
[137328.089244] CPU    2: hi:  186, btch:  31 usd:   0
[137328.089304] CPU    3: hi:  186, btch:  31 usd:   0
[137328.089359] CPU    4: hi:  186, btch:  31 usd:   0
[137328.089411] CPU    5: hi:  186, btch:  31 usd:   0
[137328.089465] CPU    6: hi:  186, btch:  31 usd:   0
[137328.089511] CPU    7: hi:  186, btch:  31 usd:   0
[137328.089556] Node 0 Normal per-cpu:
[137328.089600] CPU    0: hi:  186, btch:  31 usd:   0
[137328.089646] CPU    1: hi:  186, btch:  31 usd:   0
[137328.089691] CPU    2: hi:  186, btch:  31 usd:   0
[137328.089736] CPU    3: hi:  186, btch:  31 usd:   0
[137328.089782] CPU    4: hi:  186, btch:  31 usd:   0
[137328.089827] CPU    5: hi:  186, btch:  31 usd:   0
[137328.089872] CPU    6: hi:  186, btch:  31 usd:   0
[137328.091024] CPU    7: hi:  186, btch:  31 usd:   0
[137328.091071] active_anon:478955 inactive_anon:179998 isolated_anon:0
[137328.091071]  active_file:99053 inactive_file:99424 isolated_file:0
[137328.091071]  unevictable:0 dirty:27200 writeback:2436 unstable:0
[137328.091071]  free:34818 slab_reclaimable:1414616 slab_unreclaimable:33587
[137328.091071]  mapped:1983 shmem:200 pagetables:3860 bounce:0
[137328.091071]  free_cma:0
[137328.091345] Node 0 DMA free:15900kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[137328.091627] lowmem_reserve[]: 0 3174 31846 31846
[137328.091675] Node 0 DMA32 free:115784kB min:2276kB low:2844kB high:3412kB active_anon:5016kB inactive_anon:9464kB active_file:150456kB inactive_file:151720kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3334376kB managed:3250672kB mlocked:0kB dirty:496kB writeback:0kB mapped:304kB shmem:0kB slab_reclaimable:2065552kB slab_unreclaimable:5224kB kernel_stack:24kB pagetables:24kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[137328.092000] lowmem_reserve[]: 0 0 28672 28672
[137328.092047] Node 0 Normal free:7588kB min:20560kB low:25700kB high:30840kB active_anon:1910804kB inactive_anon:710528kB active_file:245756kB inactive_file:245976kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:29882368kB managed:29360436kB mlocked:0kB dirty:108304kB writeback:9744kB mapped:7628kB shmem:800kB slab_reclaimable:3592912kB slab_unreclaimable:129124kB kernel_stack:3640kB pagetables:15416kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[137328.092375] lowmem_reserve[]: 0 0 0 0
[137328.092421] Node 0 DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15900kB
[137328.092527] Node 0 DMA32: 25750*4kB (UEM) 1540*8kB (UEMR) 31*16kB (UMR) 6*32kB (MR) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 116008kB
[137328.092632] Node 0 Normal: 1731*4kB (UEM) 3*8kB (M) 0*16kB 1*32kB (R) 0*64kB 1*128kB (R) 1*256kB (R) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 8388kB
[137328.092737] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[137328.092825] 219301 total pagecache pages
[137328.092870] 20733 pages in swap cache
[137328.092914] Swap cache stats: add 145868, delete 125135, find 103571/111216
[137328.092962] Free swap  = 16600676kB
[137328.093006] Total swap = 16776116kB
[137328.093059] ------------[ cut here ]------------
[137328.093104] kernel BUG at fs/btrfs/extent_io.c:4151!
[137328.093150] invalid opcode: 0000 [#1] SMP 
[137328.093195] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop acpi_cpufreq mperf freq_table intel_powerclamp kvm_intel kvm crc32_pclmul ehci_pci i2c_i801 i2c_core microcode ehci_hcd lpc_ich mfd_core pcspkr button video ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[137328.093553] CPU: 5 PID: 26812 Comm: btrfs-endio-wri Not tainted 3.10.0 #3
[137328.093600] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[137328.093690] task: ffff8807f3d75b80 ti: ffff8801a293c000 task.ti: ffff8801a293c000
[137328.093777] RIP: 0010:[<ffffffffa07212ae>]  [<ffffffffa07212ae>] btrfs_clone_extent_buffer+0x5b/0xc3 [btrfs]
[137328.093874] RSP: 0018:ffff8801a293d888  EFLAGS: 00010246
[137328.093920] RAX: 0000000000000000 RBX: ffff8807b74f23c0 RCX: 0000000000000074
[137328.094007] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81773be4
[137328.094094] RBP: ffff8801a293d8b8 R08: 0000000000000000 R09: 0000000000000000
[137328.094181] R10: 0000000000000000 R11: ffff8807ff420000 R12: 0000000000000000
[137328.094268] R13: 0000000000000001 R14: ffff880084c6be00 R15: 0000000000000000
[137328.094355] FS:  0000000000000000(0000) GS:ffff88081fb40000(0000) knlGS:0000000000000000
[137328.094443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[137328.094489] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407e0
[137328.094576] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[137328.094663] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[137328.094749] Stack:
[137328.094791]  0000000000000000 ffff8807ff0266c0 ffff8807d7762000 ffff880084c6be00
[137328.094880]  ffff8807f3f72000 0000000000000012 ffff8801a293d948 ffffffffa06ebefb
[137328.094969]  ffff8801a293d9d8 ffff880000000000 ffff880100000000 0000006800001000
[137328.095058] Call Trace:
[137328.095104]  [<ffffffffa06ebefb>] btrfs_search_old_slot+0x680/0x78b [btrfs]
[137328.095156]  [<ffffffffa06edd71>] btrfs_next_old_leaf+0xc9/0x3a6 [btrfs]
[137328.095209]  [<ffffffffa0718f92>] ? btrfs_get_token_64+0xac/0xc8 [btrfs]
[137328.095261]  [<ffffffffa0718d54>] ? btrfs_get_token_32+0x6/0xc7 [btrfs]
[137328.095314]  [<ffffffffa074da50>] __resolve_indirect_refs+0x331/0x467 [btrfs]
[137328.095406]  [<ffffffffa074e205>] find_parent_nodes+0x357/0x5be [btrfs]
[137328.095459]  [<ffffffffa074e4e8>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[137328.095507]  [<ffffffff810d58b9>] ? kmem_cache_free+0x164/0x17a
[137328.095559]  [<ffffffffa07514bd>] btrfs_qgroup_account_ref+0x10c/0x44f [btrfs]
[137328.095651]  [<ffffffffa071c49f>] ? clear_state_bit+0x106/0x115 [btrfs]
[137328.095702]  [<ffffffffa06f316f>] btrfs_delayed_refs_qgroup_accounting+0xab/0xdf [btrfs]
[137328.095795]  [<ffffffffa0706896>] __btrfs_end_transaction+0x49/0x281 [btrfs]
[137328.095847]  [<ffffffffa06f4514>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
[137328.095938]  [<ffffffffa0706af9>] btrfs_end_transaction+0xb/0xd [btrfs]
[137328.095991]  [<ffffffffa0711224>] btrfs_finish_ordered_io+0x683/0x84e [btrfs]
[137328.096079]  [<ffffffff810a3683>] ? mempool_free_slab+0x12/0x14
[137328.096126]  [<ffffffff810a3717>] ? mempool_free+0x72/0x7a
[137328.096178]  [<ffffffffa073c357>] ? end_compressed_bio_write+0xc0/0xc8 [btrfs]
[137328.096269]  [<ffffffffa07113ff>] finish_ordered_fn+0x10/0x12 [btrfs]
[137328.096322]  [<ffffffffa072ab5c>] worker_loop+0x15e/0x48e [btrfs]
[137328.096374]  [<ffffffffa072a9fe>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
[137328.096423]  [<ffffffff81048ab2>] kthread+0xb5/0xbd
[137328.096469]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
[137328.096518]  [<ffffffff8137576c>] ret_from_fork+0x7c/0xb0
[137328.096565]  [<ffffffff810489fd>] ? kthread_freezable_should_stop+0x43/0x43
[137328.096613] Code: ed 0c 49 29 c5 e8 f4 a3 ff ff 48 85 c0 48 89 c3 74 72 45 31 ff eb 4b 31 f6 bf 20 00 00 00 e8 8e f4 9a e0 48 85 c0 49 89 c4 75 02 <0f> 0b 48 89 c6 48 89 df e8 22 a3 ff ff 49 8b 04 24 a8 10 74 11
[137328.096785] RIP  [<ffffffffa07212ae>] btrfs_clone_extent_buffer+0x5b/0xc3 [btrfs]
[137328.096877]  RSP <ffff8801a293d888>
[137328.097184] ---[ end trace 64a3e554b4aa9a11 ]---


-- 
Tomasz Chmielewski
http://wpkg.org
