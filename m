Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:51744 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaFMKvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 06:51:33 -0400
Received: by mail-yh0-f54.google.com with SMTP id i57so1943548yha.41
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 03:51:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 13 Jun 2014 12:51:32 +0200
Message-ID: <CA+3u+RfJQ07aci3k=PBO33RNjWzNx6iBZdKaVJ+gGyU44-VrTQ@mail.gmail.com>
Subject: Btrfs filesystem read only on error
From: David Bloquel <david.bloquel@jimywoo.fr>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Today my btrfs disk suddently turned to read only after than an error
occured, I guess it's a security measure to avoid any corrupted data
after a filesystem error.

Here is the syslog:

Jun 13 04:59:39 nas1 kernel: [110663.709572] btrfs: page allocation
failure: order:1, mode:0x200020
Jun 13 04:59:39 nas1 kernel: [110663.709579] CPU: 3 PID: 21177 Comm:
btrfs Not tainted 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
Jun 13 04:59:39 nas1 kernel: [110663.709581] Hardware name: Supermicro
A1SAi/A1SAi, BIOS 1.0b 11/06/2013
Jun 13 04:59:39 nas1 kernel: [110663.709584]  0000000000000000
0000000000000001 ffffffff814be0b3 0000000000200020
Jun 13 04:59:39 nas1 kernel: [110663.709590]  ffffffff8112535c
ffff88047ffefb00 0000000000000000 0000000200000002
Jun 13 04:59:39 nas1 kernel: [110663.709594]  ffff88047ffefb08
0000000000000002 0000000000000000 0000000000000000
Jun 13 04:59:39 nas1 kernel: [110663.709599] Call Trace:
Jun 13 04:59:39 nas1 kernel: [110663.709608]  [<ffffffff814be0b3>] ?
dump_stack+0x41/0x51
Jun 13 04:59:39 nas1 kernel: [110663.709614]  [<ffffffff8112535c>] ?
warn_alloc_failed+0x10c/0x160
Jun 13 04:59:39 nas1 kernel: [110663.709618]  [<ffffffff811292b2>] ?
__alloc_pages_nodemask+0x9c2/0xaa0
Jun 13 04:59:39 nas1 kernel: [110663.709623]  [<ffffffff8116d5c5>] ?
kmem_getpages+0x65/0x1a0
Jun 13 04:59:39 nas1 kernel: [110663.709627]  [<ffffffff8116efd2>] ?
fallback_alloc+0x172/0x260
Jun 13 04:59:39 nas1 kernel: [110663.709631]  [<ffffffff8116f904>] ?
kmem_cache_alloc+0x144/0x1f0
Jun 13 04:59:39 nas1 kernel: [110663.709635]  [<ffffffff81281f98>] ?
__idr_pre_get+0x68/0x90
Jun 13 04:59:39 nas1 kernel: [110663.709639]  [<ffffffff81282128>] ?
ida_pre_get+0x18/0x90
Jun 13 04:59:39 nas1 kernel: [110663.709644]  [<ffffffff81187561>] ?
get_anon_bdev+0x21/0xe0
Jun 13 04:59:39 nas1 kernel: [110663.709665]  [<ffffffffa048a768>] ?
btrfs_init_fs_root+0xa8/0xf0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709677]  [<ffffffffa048b32e>] ?
btrfs_get_fs_root+0xce/0x220 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709689]  [<ffffffffa048e5fe>] ?
create_pending_snapshot+0x6ee/0x980 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709701]  [<ffffffffa048e919>] ?
create_pending_snapshots+0x89/0xa0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709713]  [<ffffffffa048fd1a>] ?
btrfs_commit_transaction+0x46a/0x9f0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709718]  [<ffffffff81082d20>] ?
add_wait_queue+0x60/0x60
Jun 13 04:59:39 nas1 kernel: [110663.709731]  [<ffffffffa04bf39d>] ?
btrfs_mksubvol.isra.59+0x3cd/0x3f0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709743]  [<ffffffffa04bf4d0>] ?
btrfs_ioctl_snap_create_transid+0x110/0x1a0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709755]  [<ffffffffa04bf621>] ?
btrfs_ioctl_snap_create_v2+0x41/0x140 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709767]  [<ffffffffa04bf6e9>] ?
btrfs_ioctl_snap_create_v2+0x109/0x140 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709780]  [<ffffffffa04c2bd2>] ?
btrfs_ioctl+0xc32/0x1d30 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.709785]  [<ffffffff81151544>] ?
mmap_region+0x274/0x600
Jun 13 04:59:39 nas1 kernel: [110663.709790]  [<ffffffff814c75b8>] ?
__do_page_fault+0x2b8/0x540
Jun 13 04:59:39 nas1 kernel: [110663.709795]  [<ffffffff811971ca>] ?
do_vfs_ioctl+0x8a/0x4f0
Jun 13 04:59:39 nas1 kernel: [110663.709799]  [<ffffffff811976d0>] ?
SyS_ioctl+0xa0/0xc0
Jun 13 04:59:39 nas1 kernel: [110663.709803]  [<ffffffff814cb7b9>] ?
system_call_fastpath+0x16/0x1b
 Jun 13 04:59:39 nas1 kernel: [110663.709805] Mem-Info:
Jun 13 04:59:39 nas1 kernel: [110663.709807] Node 0 DMA per-cpu:
Jun 13 04:59:39 nas1 kernel: [110663.709810] CPU    0: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709812] CPU    1: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709814] CPU    2: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709816] CPU    3: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709818] CPU    4: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709820] CPU    5: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709822] CPU    6: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709824] CPU    7: hi:    0, btch:
  1 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709825] Node 0 DMA32 per-cpu:
Jun 13 04:59:39 nas1 kernel: [110663.709828] CPU    0: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709830] CPU    1: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709832] CPU    2: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709834] CPU    3: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709836] CPU    4: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709838] CPU    5: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709840] CPU    6: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709842] CPU    7: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709844] Node 0 Normal per-cpu:
Jun 13 04:59:39 nas1 kernel: [110663.709846] CPU    0: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709848] CPU    1: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709850] CPU    2: hi:  186, btch:
 31 usd:  29
Jun 13 04:59:39 nas1 kernel: [110663.709852] CPU    3: hi:  186, btch:
 31 usd:  26
Jun 13 04:59:39 nas1 kernel: [110663.709854] CPU    4: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709856] CPU    5: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709858] CPU    6: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709859] CPU    7: hi:  186, btch:
 31 usd:   0
Jun 13 04:59:39 nas1 kernel: [110663.709864] active_anon:9889
inactive_anon:2032 isolated_anon:0
Jun 13 04:59:39 nas1 kernel: [110663.709864]  active_file:1806505
inactive_file:1995567 isolated_file:0
Jun 13 04:59:39 nas1 kernel: [110663.709864]  unevictable:3578
dirty:302353 writeback:668 unstable:0
Jun 13 04:59:39 nas1 kernel: [110663.709864]  free:35449
slab_reclaimable:196930 slab_unreclaimable:13887
Jun 13 04:59:39 nas1 kernel: [110663.709864]  mapped:3221 shmem:47
pagetables:1051 bounce:0
Jun 13 04:59:39 nas1 kernel: [110663.709864]  free_cma:0
Jun 13 04:59:39 nas1 kernel: [110663.709869] Node 0 DMA free:15888kB
min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15972kB managed:15888kB mlocked:0kB
dirty:0k$
Jun 13 04:59:39 nas1 kernel: [110663.709876] lowmem_reserve[]: 0 1948
16058 16058
Jun 13 04:59:39 nas1 kernel: [110663.709880] Node 0 DMA32 free:65380kB
min:8188kB low:10232kB high:12280kB active_anon:1296kB
inactive_anon:2320kB active_file:887784kB inactive_file:904052kB
unevictable:860kB isolated(anon):0kB isolated(file):0kB
present:2071332kB manage$
Jun 13 04:59:39 nas1 kernel: [110663.709886] lowmem_reserve[]: 0 0 14110 14110
Jun 13 04:59:39 nas1 kernel: [110663.709890] Node 0 Normal
free:60528kB min:59324kB low:74152kB high:88984kB active_anon:38260kB
inactive_anon:5808kB active_file:6338236kB inactive_file:7078216kB
unevictable:13452kB isolated(anon):0kB isolated(file):0kB
present:14680064k$
Jun 13 04:59:39 nas1 kernel: [110663.709896] lowmem_reserve[]: 0 0 0 0
Jun 13 04:59:39 nas1 kernel: [110663.709899] Node 0 DMA: 0*4kB 0*8kB
1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB
(U) 1*2048kB (R) 3*4096kB (M) = 15888kB
Jun 13 04:59:39 nas1 kernel: [110663.709913] Node 0 DMA32: 16427*4kB
(UEM) 0*8kB 0*16kB 1*32kB (R) 0*64kB 1*128kB (R) 1*256kB (R) 0*512kB
0*1024kB 0*2048kB 0*4096kB = 66124kB
Jun 13 04:59:39 nas1 kernel: [110663.709925] Node 0 Normal: 14244*4kB
(UM) 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
0*2048kB 1*4096kB (R) = 61072kB
Jun 13 04:59:39 nas1 kernel: [110663.709936] Node 0 hugepages_total=0
hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Jun 13 04:59:39 nas1 kernel: [110663.709938] 3804373 total pagecache pages
Jun 13 04:59:39 nas1 kernel: [110663.709941] 40 pages in swap cache
Jun 13 04:59:39 nas1 kernel: [110663.709943] Swap cache stats: add
162, delete 122, find 77/81
Jun 13 04:59:39 nas1 kernel: [110663.709945] Free swap  = 61433340kB
Jun 13 04:59:39 nas1 kernel: [110663.709946] Total swap = 61433844kB
Jun 13 04:59:39 nas1 kernel: [110663.709948] SLAB: Unable to allocate
memory on node 0 (gfp=0x20)
Jun 13 04:59:39 nas1 kernel: [110663.709951]   cache: idr_layer_cache,
object size: 2112, order: 1
Jun 13 04:59:39 nas1 kernel: [110663.709965]   node 0: slabs: 70/70,
objs: 210/210, free: 0
Jun 13 04:59:39 nas1 kernel: [110663.709969] ------------[ cut here
]------------
Jun 13 04:59:39 nas1 kernel: [110663.709979] WARNING: CPU: 3 PID:
21177 at /build/linux-SMWX37/linux-3.12.9/fs/btrfs/super.c:255
__btrfs_abort_transaction+0x14d/0x160 [btrfs]()
Jun 13 04:59:39 nas1 kernel: [110663.709981] btrfs: Transaction
aborted (error -12)
Jun 13 04:59:39 nas1 kernel: [110663.709982] Modules linked in: drbd
lru_cache xt_multiport nfsd auth_rpcgss oid_registry nfsv3 nfs_acl nfs
lockd sunrpc fscache ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipt_REJECT xt_tcpudp nf_conntrack_ipv4$
Jun 13 04:59:39 nas1 kernel: t unloaded: cpuid]
Jun 13 04:59:39 nas1 kernel: [110663.710051] CPU: 3 PID: 21177 Comm:
btrfs Not tainted 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
Jun 13 04:59:39 nas1 kernel: [110663.710053] Hardware name: Supermicro
A1SAi/A1SAi, BIOS 1.0b 11/06/2013
Jun 13 04:59:39 nas1 kernel: [110663.710055]  0000000000000000
ffffffffa0505178 ffffffff814be0b3 ffff8800561b5a08
Jun 13 04:59:39 nas1 kernel: [110663.710059]  ffffffff810603a7
00000000fffffff4 ffff880463b75000 ffff880435099d10
Jun 13 04:59:39 nas1 kernel: [110663.710063]  0000000000000503
ffffffffa0501e90 ffffffff81060495 ffffffffa05052a8
Jun 13 04:59:39 nas1 kernel: [110663.710067] Call Trace:
Jun 13 04:59:39 nas1 kernel: [110663.710072]  [<ffffffff814be0b3>] ?
dump_stack+0x41/0x51
Jun 13 04:59:39 nas1 kernel: [110663.710077]  [<ffffffff810603a7>] ?
warn_slowpath_common+0x87/0xc0
Jun 13 04:59:39 nas1 kernel: [110663.710082]  [<ffffffff81060495>] ?
warn_slowpath_fmt+0x45/0x50
Jun 13 04:59:39 nas1 kernel: [110663.710092]  [<ffffffffa046448d>] ?
__btrfs_abort_transaction+0x14d/0x160 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710104]  [<ffffffffa048e72b>] ?
create_pending_snapshot+0x81b/0x980 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710116]  [<ffffffffa048e919>] ?
create_pending_snapshots+0x89/0xa0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710128]  [<ffffffffa048fd1a>] ?
btrfs_commit_transaction+0x46a/0x9f0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710132]  [<ffffffff81082d20>] ?
add_wait_queue+0x60/0x60
Jun 13 04:59:39 nas1 kernel: [110663.710144]  [<ffffffffa04bf39d>] ?
btrfs_mksubvol.isra.59+0x3cd/0x3f0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710156]  [<ffffffffa04bf4d0>] ?
btrfs_ioctl_snap_create_transid+0x110/0x1a0 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710168]  [<ffffffffa04bf621>] ?
btrfs_ioctl_snap_create_v2+0x41/0x140 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710181]  [<ffffffffa04bf6e9>] ?
btrfs_ioctl_snap_create_v2+0x109/0x140 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710193]  [<ffffffffa04c2bd2>] ?
btrfs_ioctl+0xc32/0x1d30 [btrfs]
Jun 13 04:59:39 nas1 kernel: [110663.710197]  [<ffffffff81151544>] ?
mmap_region+0x274/0x600
Jun 13 04:59:39 nas1 kernel: [110663.710201]  [<ffffffff814c75b8>] ?
__do_page_fault+0x2b8/0x540
Jun 13 04:59:39 nas1 kernel: [110663.710206]  [<ffffffff811971ca>] ?
do_vfs_ioctl+0x8a/0x4f0
Jun 13 04:59:39 nas1 kernel: [110663.710210]  [<ffffffff811976d0>] ?
SyS_ioctl+0xa0/0xc0
Jun 13 04:59:39 nas1 kernel: [110663.710214]  [<ffffffff814cb7b9>] ?
system_call_fastpath+0x16/0x1b
Jun 13 04:59:39 nas1 kernel: [110663.710216] ---[ end trace
e0639ae35d3831d3 ]---
Jun 13 04:59:39 nas1 kernel: [110663.710234] BTRFS error (device
drbd0) in create_pending_snapshot:1283: errno=-12 Out of memory
Jun 13 04:59:39 nas1 kernel: [110663.710296] BTRFS info (device
drbd0): forced readonly
Jun 13 04:59:39 nas1 kernel: [110663.710300] BTRFS warning (device
drbd0): Skipping commit of aborted transaction.
Jun 13 04:59:39 nas1 kernel: [110663.710303] BTRFS error (device
drbd0) in cleanup_transaction:1526: errno=-12 Out of memory
Jun 13 04:59:39 nas1 kernel: [110663.711764] sock_release: fasync list
not empty!


Informations about my system:
Linux nas1 3.12-0.bpo.1-amd64 #1 SMP Debian 3.12.9-1~bpo70+1
(2014-02-07) x86_64 GNU/Linux
brtfs version:
Btrfs v0.19

Moreoever my system is doing a lot of snapshots every hours (arround
100 snapshots of 8Gb containers) and is deleting arround 2000
snapshots through a cron at 4.00 am. The system is running since few
weeks and is usually working well, it is the first time this problem
happens.

My knowledge of btrfs and of filesystems in general is not good enough
to understand that error so I am looking for some help to understand
the problem and more important to avoid that it happens again in the
future.


I hope some of you could give me some advises

If you need any further information please do not hesitate.

Best regards,
David
