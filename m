Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51016 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbbLPTsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 14:48:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9I3z-0005k4-PL
	for linux-btrfs@vger.kernel.org; Wed, 16 Dec 2015 20:48:39 +0100
Received: from chello213047196183.tirol.surfer.at ([213.47.196.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 20:48:39 +0100
Received: from wertstoffe by chello213047196183.tirol.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 20:48:39 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Kernel-failure - Computer freezes
Date: Wed, 16 Dec 2015 20:47:01 +0100
Message-ID: <lmr8kc-v36.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this Kernel-failure today while making a btrfs-snapshot.

# uname -r
4.2.0-1-amd64


Dez 16 20:33:14 aldebaran kernel: btrfs: page allocation failure:
order:1, mode:0x204020
Dez 16 20:33:14 aldebaran kernel: CPU: 1 PID: 8016 Comm: btrfs Tainted:
G     U  W       4.2.0-1-amd64 #1 Debian 4.2.6-3
Dez 16 20:33:14 aldebaran kernel: Hardware name: Hewlett-Packard HP
ProBook 450 G2/2248, BIOS M74 Ver. 01.08 12/12/2014
Dez 16 20:33:14 aldebaran kernel:  0000000000000000 0000000000000001
ffffffff8154f6c3 0000000000204020
Dez 16 20:33:14 aldebaran kernel:  ffffffff8115727f ffff88014f5fbb00
0000000000000000 0000000000000001
Dez 16 20:33:14 aldebaran kernel:  0000000100000000 0000000000000000
ffff88014f5fdfa8 0000000000000046
Dez 16 20:33:14 aldebaran kernel: Call Trace:
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff8154f6c3>] ?
dump_stack+0x40/0x50
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff8115727f>] ?
warn_alloc_failed+0xcf/0x130
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff8115a984>] ?
__alloc_pages_nodemask+0x2b4/0x9e0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811a21a1>] ?
kmem_getpages+0x61/0x110
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811a3e53>] ?
fallback_alloc+0x143/0x1f0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811a599b>] ?
kmem_cache_alloc+0x1eb/0x430
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff812c63bc>] ?
ida_pre_get+0x5c/0xd0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811be90d>] ?
get_anon_bdev+0x6d/0xe0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa046cfd1>] ?
btrfs_init_free_ino_ctl+0x61/0xa0 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa046fcf6>] ?
btrfs_init_fs_root+0x106/0x180 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa0471063>] ?
btrfs_read_fs_root+0x33/0x40 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa0471103>] ?
btrfs_get_fs_root.part.49+0x93/0x180 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa049a331>] ?
memcmp_extent_buffer+0xc1/0x120 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa04840e5>] ?
btrfs_lookup_dentry+0x285/0x500 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffffa048436e>] ?
btrfs_lookup+0xe/0x30 [btrfs]
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811c5899>] ?
lookup_real+0x19/0x60
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811ca6a8>] ?
path_openat+0xa98/0x14c0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff8117d50e>] ?
do_set_pte+0x9e/0xd0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff8115230e>] ?
filemap_map_pages+0x21e/0x230
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811cc125>] ?
do_filp_open+0x75/0xd0
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811d8c3f>] ?
__alloc_fd+0x3f/0x110
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff811bbaca>] ?
do_sys_open+0x12a/0x200
Dez 16 20:33:14 aldebaran kernel:  [<ffffffff81554df2>] ?
system_call_fast_compare_end+0xc/0x6b
Dez 16 20:33:14 aldebaran kernel: Mem-Info:
Dez 16 20:33:14 aldebaran kernel: active_anon:226184 inactive_anon:65166
isolated_anon:0
                                   active_file:245088
inactive_file:246297 isolated_file:0
                                   unevictable:192 dirty:1706
writeback:50 unstable:0
                                   slab_reclaimable:32362
slab_unreclaimable:16012
                                   mapped:96648 shmem:53953
pagetables:9075 bounce:0
                                   free:7046 free_pcp:1265 free_cma:0
Dez 16 20:33:14 aldebaran kernel: Node 0 DMA free:13364kB min:32kB
low:40kB high:48kB active_anon:252kB inactive_anon:284kB
active_file:560kB inactive_file:660kB unevictable:0kB isolated(anon):0kB
isolated(file)
Dez 16 20:33:14 aldebaran kernel: lowmem_reserve[]: 0 2125 3337 3337
Dez 16 20:33:14 aldebaran kernel: Node 0 DMA32 free:11232kB min:4624kB
low:5780kB high:6936kB active_anon:612872kB inactive_anon:162128kB
active_file:616016kB inactive_file:618100kB unevictable:516kB isolated(an
Dez 16 20:33:14 aldebaran kernel: lowmem_reserve[]: 0 0 1212 1212
Dez 16 20:33:14 aldebaran kernel: Node 0 Normal free:3464kB min:2636kB
low:3292kB high:3952kB active_anon:291612kB inactive_anon:98252kB
active_file:363776kB inactive_file:366212kB unevictable:252kB isolated(ano
Dez 16 20:33:14 aldebaran kernel: lowmem_reserve[]: 0 0 0 0
Dez 16 20:33:14 aldebaran kernel: Node 0 DMA: 31*4kB (UE) 17*8kB (UM)
8*16kB (UE) 5*32kB (UEM) 2*64kB (E) 1*128kB (E) 1*256kB (M) 2*512kB (EM)
1*1024kB (E) 1*2048kB (E) 2*4096kB (UM) = 13348kB
Dez 16 20:33:14 aldebaran kernel: Node 0 DMA32: 2720*4kB (UEM) 30*8kB
(UEM) 7*16kB (UM) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 11232kB
Dez 16 20:33:14 aldebaran kernel: Node 0 Normal: 837*4kB (UEM) 22*8kB
(UM) 0*16kB 2*32kB (M) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB
0*4096kB = 3588kB
Dez 16 20:33:14 aldebaran kernel: Node 0 hugepages_total=0
hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
Dez 16 20:33:14 aldebaran kernel: 545434 total pagecache pages
Dez 16 20:33:14 aldebaran kernel: 4 pages in swap cache
Dez 16 20:33:14 aldebaran kernel: Swap cache stats: add 10, delete 6,
find 0/0
Dez 16 20:33:14 aldebaran kernel: Free swap  = 7812052kB
Dez 16 20:33:14 aldebaran kernel: Total swap = 7812092kB
Dez 16 20:33:14 aldebaran kernel: 892955 pages RAM
Dez 16 20:33:14 aldebaran kernel: 0 pages HighMem/MovableOnly
Dez 16 20:33:14 aldebaran kernel: 33747 pages reserved
Dez 16 20:33:14 aldebaran kernel: 0 pages hwpoisoned
Dez 16 20:33:14 aldebaran kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000022

-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

