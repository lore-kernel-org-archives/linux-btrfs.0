Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37818 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbcAWXNk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:13:40 -0500
Date: Sat, 23 Jan 2016 15:13:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Message-ID: <20160123231315.GC10113@merlins.org>
References: <20160121045239.GQ17679@merlins.org>
 <20160118233943.GF17679@merlins.org>
 <20160123170354.GA10113@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160123170354.GA10113@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2016 at 09:03:54AM -0800, Marc MERLIN wrote:
> +David, +Qu
> about 
> 1) kernel crash on BUG_ON
> 2) check --repair not giving good clue that
> "type mismatch with chunk" is unfixable, and whether it can be kind of
> ignored or whether your FS really needs to be recreated from scratch
> (many hours of work for me, and probably 2 days of clock time to rebuild
> and restore from backup)
> 3) say more about "root 45948 inode 204452 errors 1000, some csum missing",
> that they aren't being fixed, and whether they're a big deal or not.
> 
> More generally I'm curious to know if check --repair will sometimes fix
> more things on a 2nd (or 3rd...) run than on the first one.

for what it's worth, even after check --repair, the filesystem still
causes the kernel to crash:
btrfs: page allocation failure: order:1, mode:0x204020
CPU: 0 PID: 30591 Comm: btrfs Not tainted 4.3.3-amd64-i915-volpreempt-20150421 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
 0000000000000000 ffff880001fb3708 ffffffff8134150e 0000000000000000
 ffff880001fb37a0 ffffffff8111f6ce 00000000fffffffe 0000000000000000
 ffff880001fb3738 ffffffff816c1143 ffff880001fb3768 ffff88021f5f4e00
Call Trace:
 [<ffffffff8134150e>] dump_stack+0x44/0x55
 [<ffffffff8111f6ce>] warn_alloc_failed+0x111/0x129
 [<ffffffff816c1143>] ? _raw_spin_unlock_irqrestore+0x14/0x16
 [<ffffffff811220f8>] __alloc_pages_nodemask+0x6ae/0x70d
 [<ffffffff8115fb98>] kmem_getpages+0x6a/0x162
 [<ffffffff8115fd89>] fallback_alloc+0xf9/0x193
 [<ffffffff8115ff46>] ____cache_alloc_node+0x123/0x130
 [<ffffffff81160c1d>] kmem_cache_alloc+0xdc/0x187
 [<ffffffff81341dfc>] ida_pre_get+0x32/0xb6
 [<ffffffff8117999e>] get_anon_bdev+0x1f/0xc8
 [<ffffffff812507e5>] btrfs_init_fs_root+0x104/0x14e
 [<ffffffff812518c9>] btrfs_get_fs_root+0xb7/0x1bf
 [<ffffffff812556e1>] create_pending_snapshot+0x65e/0xb09
 [<ffffffff81080c4c>] ? get_sd_balance_interval.isra.34+0x17/0x33
 [<ffffffff81255bfe>] create_pending_snapshots+0x72/0x8e
 [<ffffffff81255bfe>] ? create_pending_snapshots+0x72/0x8e
 [<ffffffff81256b22>] btrfs_commit_transaction+0x423/0x9c1
 [<ffffffff81257440>] ? start_transaction+0x380/0x50b
 [<ffffffff81089e9d>] ? wake_up_atomic_t+0x2c/0x2c
 [<ffffffff812812e3>] btrfs_mksubvol+0x2f4/0x427
 [<ffffffff81089e9d>] ? wake_up_atomic_t+0x2c/0x2c
 [<ffffffff8128155e>] btrfs_ioctl_snap_create_transid+0x148/0x17a
 [<ffffffff812816be>] btrfs_ioctl_snap_create_v2+0xc7/0x110
 [<ffffffff812839d3>] btrfs_ioctl+0x545/0x233e
 [<ffffffff81126cc0>] ? get_page+0xd/0x26
 [<ffffffff811270f2>] ? __lru_cache_add+0x23/0x44
 [<ffffffff811273bf>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
 [<ffffffff8113d6ab>] ? set_pte_at+0x9/0xd
 [<ffffffff8114623b>] ? do_mmap+0x2de/0x327
 [<ffffffff81186550>] do_vfs_ioctl+0x39b/0x412
 [<ffffffff81003482>] ? do_audit_syscall_entry+0x60/0x62
 [<ffffffff8118661e>] SyS_ioctl+0x57/0x79
 [<ffffffff816c1376>] entry_SYSCALL_64_fastpath+0x16/0x75
Mem-Info:
active_anon:415090 inactive_anon:219505 isolated_anon:0
 active_file:463628 inactive_file:550449 isolated_file:0
 unevictable:1202 dirty:29212 writeback:3325 unstable:0
 slab_reclaimable:61297 slab_unreclaimable:48704
 mapped:418528 shmem:409992 pagetables:4730 bounce:0
 free:19084 free_pcp:776 free_cma:0
Node 0 DMA free:15896kB min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15980kB managed:15896kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3203 7674 7674
Node 0 DMA32 free:48860kB min:4644kB low:5804kB high:6964kB active_anon:452600kB inactive_anon:463072kB active_file:838520kB inactive_file:1040240kB unevictable:1152kB isolated(anon):0kB isolated(file):0kB present:3362068kB managed:3283400kB mlocked:1152kB dirty:16192kB writeback:2176kB mapped:702760kB shmem:675320kB slab_reclaimable:76144kB slab_unreclaimable:75212kB kernel_stack:5616kB pagetables:4956kB unstable:0kB bounce:0kB free_pcp:1504kB local_pcp:32kB free_cma:0kB writeback_tmp:0kB pages_scanned:252 all_unreclaimable? no

lowmem_reserve[]: 0 0 4471 4471
Node 0 Normal free:7872kB min:6480kB low:8100kB high:9720kB active_anon:1207760kB inactive_anon:414948kB active_file:1015992kB inactive_file:1161556kB unevictable:3656kB isolated(anon):0kB isolated(file):0kB present:4708352kB managed:4578508kB mlocked:3656kB dirty:95268kB writeback:16596kB mapped:971352kB shmem:964648kB slab_reclaimable:169044kB slab_unreclaimable:119604kB kernel_stack:5664kB pagetables:13964kB unstable:0kB bounce:0kB free_pcp:1320kB local_pcp:296kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 0*4kB 1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15896kB
Node 0 DMA32: 11151*4kB (UE) 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 44604kB
Node 0 Normal: 1899*4kB (UE) 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 7596kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
1455704 total pagecache pages
30458 pages in swap cache
Swap cache stats: add 405385, delete 374927, find 3385111/3435323
Free swap  = 15024996kB
Total swap = 15616764kB
2021600 pages RAM
0 pages HighMem/MovableOnly
52149 pages reserved
4096 pages cma reserved
0 pages hwpoisoned
------------[ cut here ]------------
WARNING: CPU: 0 PID: 30591 at fs/btrfs/transaction.c:1476 create_pending_snapshot+0x6b2/0xb09()
Modules linked in: udp_diag tcp_diag inet_diag loop veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp tun xt_addrtype bridge stp llc autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss snd_hda_codec_realtek

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
