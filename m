Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56012 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcFVXOP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 19:14:15 -0400
Subject: Re: btrfs: page allocation failure: order:1, mode:0x2204020
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b0e70e1a-6eb5-9f9f-86e0-9049ae12f470@mendix.com>
 <20160620124902.GO4915@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <71f4ab7b-83ba-7ed7-ecc3-1d8c3cd33068@mendix.com>
Date: Thu, 23 Jun 2016 01:14:08 +0200
MIME-Version: 1.0
In-Reply-To: <20160620124902.GO4915@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2016 02:49 PM, David Sterba wrote:
> On Sat, Jun 18, 2016 at 08:47:55PM +0200, Hans van Kranenburg wrote:
>> Last night, one of my btrfs filesystems went read-only after a memory
>> allocation failure (logging attached).
>
> According to the logs, the allocation itself happens out of btrfs so we
> can't do much here.
>
> More specifically, when creating a new subvolume and requesting an
> anonymous block device (via get_anon_bdev), there's a call to request a
> free id for it. This could ask for "order-1" ie 8kb of contiguous
> memory. And it failed.
>
> This depends on memory fragmentation, ie. how the pages are allocated
> and freed over time. Tweaking vm.min_free_kbytes could help but it's not
> designed to prevent memory allocations in such scenario.
>
> The id range sturctures themselves do not need more than a 4k page, but
> the slab cache tries to provide more objects per slab, I see this on my
> box right now:
>
> Excerpt from /proc/slabinfo:
>
> idr_layer_cache      474    486   2096    3    2
>
> where  3 == objperslab and 2 == pages per slab, which corresponds to the
> 8kb. This seems to depend on internal slab cache logic, and nothing I'd
> like to go chaning right now.

Aha, interesting. The output of "sort -nk 6 < /proc/slabinfo" shows me 
that most of them use the 4k.

> [...]
>> I've seen this happen once before somewhere else, also during snapshot
>> creation, also with a 4.5.x kernel.

Speaking of the devil... Yesterday another one crashed, and this one is 
using Debian 3.16.7-ckt25-2. Errors attached.

>> There's a bug report at Debian, in which is suggested to increase the
>> value of vm.min_free_kbytes:
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666021
>
> [...]
>
>> [2363000.815554] Node 0 Normal: 2424*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB
>> 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 9696kB
>
> Just to confirm the fragmentation, there are no page orders higher than
> 0 (ie.  8k and up).
>
> So, technically not a btrfs bug but we could get affected by it badly.

Ah, so the list is what's still free, and there's no 8kB block available.

Now this also makes perfect sense to me:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666021#90

So while increasing the min_free_kbytes will not fix the fragmentation 
issue, it is at least a workaround by just throwing some more dedicated 
space at it and decreasing the chance of this happening.

This one was even more spectacular, since it ends in oopsing and the 
whole box going down a bit later. I see no line with "Normal" in here by 
the way...

btrfs: page allocation failure: order:1, mode:0x204020
CPU: 0 PID: 9475 Comm: btrfs Not tainted 3.16.0-4-amd64 #1 Debian 
3.16.7-ckt25-2
  0000000000000000 ffffffff8150e835 0000000000204020 ffff8800052f7838
  ffffffff81142d3f 0000000000000000 0000000000000000 ffff880000000002
  0000000000000041 ffff8800ef8a5c00 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff8150e835>] ? dump_stack+0x5d/0x78
  [<ffffffff81142d3f>] ? warn_alloc_failed+0xdf/0x130
  [<ffffffff81146fea>] ? __alloc_pages_nodemask+0x8ca/0xb30
  [<ffffffff8118d08b>] ? kmem_getpages+0x5b/0x110
  [<ffffffff8118e6bf>] ? fallback_alloc+0x1cf/0x210
  [<ffffffff8118f2a0>] ? kmem_cache_alloc+0x1f0/0x450
  [<ffffffff812abd20>] ? ida_pre_get+0x60/0xe0
  [<ffffffff811aa9e2>] ? get_anon_bdev+0x62/0xe0
  [<ffffffffa00a43f1>] ? btrfs_init_fs_root+0x101/0x190 [btrfs]
  [<ffffffffa00a5a86>] ? btrfs_get_fs_root+0xb6/0x270 [btrfs]
  [<ffffffffa00a9bb6>] ? create_pending_snapshot+0x6f6/0x960 [btrfs]
  [<ffffffffa00a9ea9>] ? create_pending_snapshots+0x89/0xb0 [btrfs]
  [<ffffffffa00ab0ac>] ? btrfs_commit_transaction+0x40c/0xa10 [btrfs]
  [<ffffffffa00ab740>] ? start_transaction+0x90/0x570 [btrfs]
  [<ffffffffa00dcbba>] ? btrfs_mksubvol.isra.29+0x54a/0x5a0 [btrfs]
  [<ffffffff810a7e60>] ? prepare_to_wait_event+0xf0/0xf0
  [<ffffffffa00dcda1>] ? btrfs_ioctl_snap_create_transid+0x191/0x1a0 [btrfs]
  [<ffffffffa00dcf0e>] ? btrfs_ioctl_snap_create_v2+0xee/0x140 [btrfs]
  [<ffffffffa00e0704>] ? btrfs_ioctl+0xcc4/0x2b50 [btrfs]
  [<ffffffff81169b8c>] ? handle_mm_fault+0x63c/0x11c0
  [<ffffffff8116ffcf>] ? mmap_region+0x15f/0x650
  [<ffffffff81057311>] ? __do_page_fault+0x1d1/0x4f0
  [<ffffffff811707a9>] ? do_mmap_pgoff+0x2e9/0x3b0
  [<ffffffff811bacdf>] ? do_vfs_ioctl+0x2cf/0x4b0
  [<ffffffff811baf41>] ? SyS_ioctl+0x81/0xa0
  [<ffffffff81516a28>] ? page_fault+0x28/0x30
  [<ffffffff81514a0d>] ? system_call_fast_compare_end+0x10/0x15
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 135
active_anon:58342 inactive_anon:20518 isolated_anon:0
  active_file:371028 inactive_file:364279 isolated_file:0
  unevictable:0 dirty:25166 writeback:0 unstable:0
  free:85089 slab_reclaimable:46135 slab_unreclaimable:9219
  mapped:5560 shmem:20579 pagetables:1492 bounce:0
  free_cma:0
Node 0 DMA free:14984kB min:32kB low:40kB high:48kB active_anon:344kB 
inactive_anon:160kB active_file:40kB inactive_file:36kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15996kB managed:15912kB 
mlocked:0kB dirty:16kB writeback:0kB mapped:32kB shmem:160kB 
slab_reclaimable:84kB slab_unreclaimable:60kB kernel_stack:64kB 
pagetables:16kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:11 all_unreclaimable? no
lowmem_reserve[]: 0 3743 3743 3743
Node 0 DMA32 free:325372kB min:7808kB low:9760kB high:11712kB 
active_anon:233024kB inactive_anon:81912kB active_file:1484072kB 
inactive_file:1457080kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:3923968kB managed:3835376kB mlocked:0kB 
dirty:100648kB writeback:0kB mapped:22208kB shmem:82156kB 
slab_reclaimable:184456kB slab_unreclaimable:36816kB kernel_stack:3200kB 
pagetables:5952kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 10*4kB (UEM) 6*8kB (UEM) 5*16kB (UEM) 1*32kB (E) 3*64kB 
(UEM) 4*128kB (UM) 1*256kB (E) 1*512kB (E) 3*1024kB (UEM) 3*2048kB (EMR) 
1*4096kB (M) = 14984kB
Node 0 DMA32: 81023*4kB (UE) 0*8kB 0*16kB 8*32kB (R) 2*64kB (R) 3*128kB 
(R) 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 325372kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 
hugepages_size=2048kB
755878 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
984991 pages RAM
0 pages HighMem/MovableOnly
22148 pages reserved
0 pages hwpoisoned
------------[ cut here ]------------
WARNING: CPU: 0 PID: 9475 at 
/build/linux-lqALYs/linux-3.16.7-ckt25/fs/btrfs/super.c:259 
__btrfs_abort_transaction+0x4b/0x110 [btrfs]()
Modules linked in: binfmt_misc ip6t_REJECT nf_conntrack_ipv6 
nf_defrag_ipv6 ip6table_filter ip6table_mangle ip6table_raw ip6_tables 
xt_LOG xt_limit ipt_REJECT xt_tcpudp xt_owner xt_conntrack 
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat iptable_mangle xt_CT nf_conntrack xt_multiport iptable_raw 
ip_tables x_tables x86_pkg_temp_thermal thermal_sys coretemp 
crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper 
cryptd quota_v2 quota_tree loop autofs4 ext4 crc16 mbcache jbd2 btrfs 
xen_netfront xen_blkfront crct10dif_pclmul crct10dif_common xor 
crc32c_intel raid6_pq
CPU: 0 PID: 9475 Comm: btrfs Not tainted 3.16.0-4-amd64 #1 Debian 
3.16.7-ckt25-2
  0000000000000000 ffffffff8150e835 ffff8800052f7a88 0000000000000009
  ffffffff810677f7 00000000fffffff4 ffff8800052f7ad8 ffff88002a4b44e8
  ffffffffa0123070 000000000000053e ffffffff8106785c ffffffffa0126af8
Call Trace:
  [<ffffffff8150e835>] ? dump_stack+0x5d/0x78
  [<ffffffff810677f7>] ? warn_slowpath_common+0x77/0x90
  [<ffffffff8106785c>] ? warn_slowpath_fmt+0x4c/0x50
  [<ffffffffa007e00b>] ? __btrfs_abort_transaction+0x4b/0x110 [btrfs]
  [<ffffffffa00a9ce8>] ? create_pending_snapshot+0x828/0x960 [btrfs]
  [<ffffffffa00a9ea9>] ? create_pending_snapshots+0x89/0xb0 [btrfs]
  [<ffffffffa00ab0ac>] ? btrfs_commit_transaction+0x40c/0xa10 [btrfs]
  [<ffffffffa00ab740>] ? start_transaction+0x90/0x570 [btrfs]
  [<ffffffffa00dcbba>] ? btrfs_mksubvol.isra.29+0x54a/0x5a0 [btrfs]
  [<ffffffff810a7e60>] ? prepare_to_wait_event+0xf0/0xf0
  [<ffffffffa00dcda1>] ? btrfs_ioctl_snap_create_transid+0x191/0x1a0 [btrfs]
  [<ffffffffa00dcf0e>] ? btrfs_ioctl_snap_create_v2+0xee/0x140 [btrfs]
  [<ffffffffa00e0704>] ? btrfs_ioctl+0xcc4/0x2b50 [btrfs]
  [<ffffffff81169b8c>] ? handle_mm_fault+0x63c/0x11c0
  [<ffffffff8116ffcf>] ? mmap_region+0x15f/0x650
  [<ffffffff81057311>] ? __do_page_fault+0x1d1/0x4f0
  [<ffffffff811707a9>] ? do_mmap_pgoff+0x2e9/0x3b0
  [<ffffffff811bacdf>] ? do_vfs_ioctl+0x2cf/0x4b0
  [<ffffffff811baf41>] ? SyS_ioctl+0x81/0xa0
  [<ffffffff81516a28>] ? page_fault+0x28/0x30
  [<ffffffff81514a0d>] ? system_call_fast_compare_end+0x10/0x15
---[ end trace 57a77704ddefbd3c ]---
BTRFS: error (device xvdn) in create_pending_snapshot:1342: errno=-12 
Out of memory
BTRFS info (device xvdn): forced readonly
BTRFS warning (device xvdn): Skipping commit of aborted transaction.
BTRFS: error (device xvdn) in cleanup_transaction:1585: errno=-12 Out of 
memory

And then 13329 seconds later:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff812b08b8>] rb_insert_color+0x18/0x180
PGD 2f0d5067 PUD d34cc067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: binfmt_misc ip6t_REJECT nf_conntrack_ipv6 
nf_defrag_ipv6 ip6table_filter ip6table_mangle ip6table_raw ip6_tables 
xt_LOG xt_limit ipt_REJECT xt_tcpudp xt_owner xt_conntrack 
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat iptable_mangle xt_CT nf_conntrack xt_multiport iptable_raw 
ip_tables x_tables x86_pkg_temp_thermal thermal_sys coretemp 
crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper 
cryptd quota_v2 quota_tree loop autofs4 ext4 crc16 mbcache jbd2 btrfs 
xen_netfront xen_blkfront crct10dif_pclmul crct10dif_common xor 
crc32c_intel raid6_pq
CPU: 0 PID: 20222 Comm: btrfs_usage Tainted: G        W 
3.16.0-4-amd64 #1 Debian 3.16.7-ckt25-2
task: ffff880004474310 ti: ffff88005ef70000 task.ti: ffff88005ef70000
RIP: e030:[<ffffffff812b08b8>]  [<ffffffff812b08b8>] 
rb_insert_color+0x18/0x180
RSP: e02b:ffff88005ef73d18  EFLAGS: 00010246
RAX: ffff880039aaacc8 RBX: ffff8800b32e15c0 RCX: ffff880039aaacc8
RDX: 0000000000000000 RSI: ffff880039aaaac0 RDI: ffff8800b32e15c8
RBP: ffff8800db3020a0 R08: 0000000040dd9cd5 R09: ffff8800b32e15c0
R10: 00000000039e1f7b R11: 00000000c1d37d9f R12: ffff880039aaaac0
R13: 0000000040dd9cd4 R14: 00000000a1d8abf1 R15: ffff8800db302ff8
FS:  00007f0a2018c700(0000) GS:ffff8800ef600000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000000996b000 CR4: 0000000000002660
Stack:
  ffffffffa014f75b ffff88000bcad4a0 ffff88005ef73dd8 ffff8800e8c720c8
  0000000000000000 ffff8800db3020a0 ffffffffa015eca0 ffff8800db302000
  0000000000001000 ffff8800000000a0 000000005ef73dfc 0000000000000009
Call Trace:
  [<ffffffffa014f75b>] ? ext4_htree_store_dirent+0xeb/0x120 [ext4]
  [<ffffffffa015eca0>] ? htree_dirblock_to_tree+0x160/0x190 [ext4]
  [<ffffffffa015fed1>] ? ext4_htree_fill_tree+0xc1/0x250 [ext4]
  [<ffffffff811b7adb>] ? path_openat+0xbb/0x680
  [<ffffffffa014eefb>] ? ext4_readdir+0x17b/0x8d0 [ext4]
  [<ffffffff811b884a>] ? do_filp_open+0x3a/0x90
  [<ffffffff811bafff>] ? iterate_dir+0x9f/0x120
  [<ffffffff811bb459>] ? SyS_getdents+0x89/0x100
  [<ffffffff811bb150>] ? fillonedir+0xd0/0xd0
  [<ffffffff81514a0d>] ? system_call_fast_compare_end+0x10/0x15
Code: 89 d0 48 83 e0 fc 75 eb f3 c3 31 c0 c3 66 0f 1f 44 00 00 48 8b 07 
48 85 c0 0f 84 24 01 00 00 48 8b 10 f6 c2 01 0f 85 58 01 00 00 <48> 8b 
4a 08 49 89 d0 48 39 c8 0f 84 93 00 00 00 48 85 c9 74 05
RIP  [<ffffffff812b08b8>] rb_insert_color+0x18/0x180
  RSP <ffff88005ef73d18>
CR2: 0000000000000008
---[ end trace 57a77704ddefbd3d ]---
BUG: unable to handle kernel paging request at 00000000fffffffe
IP: [<ffffffff8118d67a>] free_block+0x12a/0x1c0
PGD 0
Oops: 0002 [#2] SMP
Modules linked in: binfmt_misc ip6t_REJECT nf_conntrack_ipv6 
nf_defrag_ipv6 ip6table_filter ip6table_mangle ip6table_raw ip6_tables 
xt_LOG xt_limit ipt_REJECT xt_tcpudp xt_owner xt_conntrack 
iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat iptable_mangle xt_CT nf_conntrack xt_multiport iptable_raw 
ip_tables x_tables x86_pkg_temp_thermal thermal_sys coretemp 
crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper 
cryptd quota_v2 quota_tree loop autofs4 ext4 crc16 mbcache jbd2 btrfs 
xen_netfront xen_blkfront crct10dif_pclmul crct10dif_common xor 
crc32c_intel raid6_pq
CPU: 0 PID: 20222 Comm: btrfs_usage Tainted: G      D W 
3.16.0-4-amd64 #1 Debian 3.16.7-ckt25-2
task: ffff880004474310 ti: ffff88005ef70000 task.ti: ffff88005ef70000
RIP: e030:[<ffffffff8118d67a>]  [<ffffffff8118d67a>] free_block+0x12a/0x1c0
RSP: e02b:ffff88005ef73948  EFLAGS: 00010082
RAX: 00000000fffffffe RBX: ffff8800eac0d828 RCX: 0000000000000000
RDX: 0000000000e6aab3 RSI: ffffea0000c9d530 RDI: dead000000200200
RBP: ffff8800eac001c0 R08: ffff8800eac021c0 R09: 0000000000000000
R10: 0000000000000001 R11: fffffffffffffff4 R12: 0000000080000000
R13: ffffea0000000000 R14: 000077ff80000000 R15: ffff8800eac0d9f8
FS:  00007f0a2018c700(0000) GS:ffff8800ef600000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000fffffffe CR3: 0000000001813000 CR4: 0000000000002660
Stack:
  0000000000000000 ffff8800eac0d800 000000000000003c ffff8800eac021c0
  ffff8800eac0d818 ffff8800eac001c0 0000000000000000 ffffffff8150d3d2
  ffff8800eac0d800 ffff880039aaacc0 0000000000000277 0000000000000000
Call Trace:
  [<ffffffff8150d3d2>] ? cache_flusharray+0x78/0xa2
  [<ffffffff8118e938>] ? kfree+0x178/0x220
  [<ffffffffa014e99f>] ? free_rb_tree_fname+0x4f/0x70 [ext4]
  [<ffffffffa014e9da>] ? ext4_release_dir+0x1a/0x30 [ext4]
  [<ffffffff811aa1ea>] ? __fput+0xca/0x1d0
  [<ffffffff810852dc>] ? task_work_run+0x8c/0xb0
  [<ffffffff81069ba1>] ? do_exit+0x2b1/0xa50
  [<ffffffff81016217>] ? oops_end+0x97/0xe0
  [<ffffffff8150b172>] ? no_context+0x2b2/0x2be
  [<ffffffff810575a3>] ? __do_page_fault+0x463/0x4f0
  [<ffffffff811d7c39>] ? __find_get_block_slow+0xc9/0x170
  [<ffffffff811d8dc3>] ? __find_get_block+0x223/0x250
  [<ffffffff81516a28>] ? page_fault+0x28/0x30
  [<ffffffff812b08b8>] ? rb_insert_color+0x18/0x180
  [<ffffffffa014f75b>] ? ext4_htree_store_dirent+0xeb/0x120 [ext4]
  [<ffffffffa015eca0>] ? htree_dirblock_to_tree+0x160/0x190 [ext4]
  [<ffffffffa015fed1>] ? ext4_htree_fill_tree+0xc1/0x250 [ext4]
  [<ffffffff811b7adb>] ? path_openat+0xbb/0x680
  [<ffffffffa014eefb>] ? ext4_readdir+0x17b/0x8d0 [ext4]
  [<ffffffff811b884a>] ? do_filp_open+0x3a/0x90
  [<ffffffff811bafff>] ? iterate_dir+0x9f/0x120
  [<ffffffff811bb459>] ? SyS_getdents+0x89/0x100
  [<ffffffff811bb150>] ? fillonedir+0xd0/0xd0
  [<ffffffff81514a0d>] ? system_call_fast_compare_end+0x10/0x15
Code: 28 8b 4d 10 89 c2 48 0f af d1 0f b6 4d 14 48 c1 ea 20 29 d0 d3 e8 
0f b6 4d 15 01 c2 8b 46 18 d3 ea 48 8b 4e 10 83 e8 01 89 46 18 <88> 14 
01 49 8b 40 38 48 83 c0 01 49 89 40 38 8b 56 18 85 d2 0f
RIP  [<ffffffff8118d67a>] free_block+0x12a/0x1c0
  RSP <ffff88005ef73948>
CR2: 00000000fffffffe
---[ end trace 57a77704ddefbd3e ]---
Fixing recursive fault but reboot is needed!

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
