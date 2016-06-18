Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57258 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcFRSsA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jun 2016 14:48:00 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by syrinx.knorrie.org (Postfix) with ESMTPSA id 071DF600CC
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jun 2016 20:47:56 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: btrfs: page allocation failure: order:1, mode:0x2204020
Message-ID: <b0e70e1a-6eb5-9f9f-86e0-9049ae12f470@mendix.com>
Date: Sat, 18 Jun 2016 20:47:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last night, one of my btrfs filesystems went read-only after a memory 
allocation failure (logging attached).

I've seen this happen once before somewhere else, also during snapshot 
creation, also with a 4.5.x kernel.

There's a bug report at Debian, in which is suggested to increase the 
value of vm.min_free_kbytes:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=666021

# uname -a
Linux domokun 4.5.0-0.bpo.2-amd64 #1 SMP Debian 4.5.3-2~bpo8+1 
(2016-05-13) x86_64 GNU/Linux

# btrfs fi show
Label: none  uuid: 37c37071-4080-418b-a27a-29d7d15ec00d
	Total devices 1 FS bytes used 1.59TiB
	devid    1 size 2.24TiB used 1.92TiB path /dev/xvdb

# sysctl vm.min_free_kbytes
vm.min_free_kbytes = 11460

# free -m
              total   used   free shared buffers cached
Mem:          8019   7848    171    168      31   6240
-/+ buffers/cache:   1576   6443
Swap:            0      0      0

Lots of the memory is used for disk cache. At the time this happened, 
there was indeed very little "really unused" memory left in the system.

Why is this happening? Does it also make sense to set vm.min_free_kbytes 
= 65536 here? At least I'm going to try that now.

Thanks,

[2363000.814981] btrfs: page allocation failure: order:1, mode:0x2204020
[2363000.814997] CPU: 3 PID: 883 Comm: btrfs Tainted: G        W   E 
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.3-2~bpo8+1
[2363000.815017]  0000000000000037 00000000d30c738a ffffffff8130a125 
0000000002204020
[2363000.815027]  ffff88011f06b7c0 ffffffff811726dc 0000000102264220 
0000000000000000
[2363000.815036]  ffff8801ff01c330 ffffffff810b8fee 0000000100000000 
00000000d30c738a
[2363000.815045] Call Trace:
[2363000.815055]  [<ffffffff8130a125>] ? dump_stack+0x5c/0x77
[2363000.815063]  [<ffffffff811726dc>] ? warn_alloc_failed+0xfc/0x150
[2363000.815070]  [<ffffffff810b8fee>] ? __wake_up_common+0x4e/0x90
[2363000.815077]  [<ffffffff81175d30>] ? __alloc_pages_nodemask+0x300/0xc80
[2363000.815085]  [<ffffffff811c9c51>] ? kmem_getpages+0x51/0x170
[2363000.815091]  [<ffffffff811ca789>] ? fallback_alloc+0x159/0x210
[2363000.815097]  [<ffffffff811cbd85>] ? kmem_cache_alloc+0x335/0x4e0
[2363000.815103]  [<ffffffff8130b38c>] ? ida_pre_get+0x5c/0xd0
[2363000.815110]  [<ffffffff811edecd>] ? get_anon_bdev+0x7d/0x100
[2363000.815117]  [<ffffffff815b9d76>] ? 
_raw_spin_unlock_irqrestore+0x16/0x20
[2363000.815142]  [<ffffffffc007e286>] ? btrfs_init_fs_root+0x106/0x1c0 
[btrfs]
[2363000.815159]  [<ffffffffc007f813>] ? 
btrfs_get_fs_root.part.51+0xa3/0x1a0 [btrfs]
[2363000.815178]  [<ffffffffc0083f2b>] ? 
create_pending_snapshot+0x4eb/0xc80 [btrfs]
[2363000.815197]  [<ffffffffc0084724>] ? 
create_pending_snapshots+0x64/0x80 [btrfs]
[2363000.815215]  [<ffffffffc0085d53>] ? 
btrfs_commit_transaction+0x473/0xa30 [btrfs]
[2363000.815232]  [<ffffffffc0085132>] ? 
btrfs_record_root_in_trans+0x52/0x70 [btrfs]
[2363000.815250]  [<ffffffffc00863a6>] ? start_transaction+0x96/0x4d0 
[btrfs]
[2363000.815268]  [<ffffffffc00bbd2a>] ? btrfs_mksubvol+0x5ca/0x5e0 [btrfs]
[2363000.815275]  [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
[2363000.815292]  [<ffffffffc00bbec0>] ? 
btrfs_ioctl_snap_create_transid+0x180/0x190 [btrfs]
[2363000.815312]  [<ffffffffc00bc048>] ? 
btrfs_ioctl_snap_create_v2+0x108/0x160 [btrfs]
[2363000.815331]  [<ffffffffc00c042d>] ? btrfs_ioctl+0x149d/0x2190 [btrfs]
[2363000.815337]  [<ffffffff811c4001>] ? alloc_pages_vma+0xc1/0x240
[2363000.815344]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[2363000.815351]  [<ffffffff811a1288>] ? handle_mm_fault+0x13d8/0x1b90
[2363000.815357]  [<ffffffff811feab9>] ? do_vfs_ioctl+0x99/0x5d0
[2363000.815362]  [<ffffffff811ff066>] ? SyS_ioctl+0x76/0x90
[2363000.815368]  [<ffffffff815ba2b6>] ? 
system_call_fast_compare_end+0xc/0x6b
[2363000.815374] Mem-Info:
[2363000.815380] active_anon:65742 inactive_anon:34423 isolated_anon:0
[2363000.815380]  active_file:784362 inactive_file:784472 isolated_file:0
[2363000.815380]  unevictable:0 dirty:39714 writeback:0 unstable:0
[2363000.815380]  slab_reclaimable:348787 slab_unreclaimable:8382
[2363000.815380]  mapped:4052 shmem:43070 pagetables:862 bounce:0
[2363000.815380]  free:13306 free_pcp:434 free_cma:0
[2363000.815404] Node 0 DMA free:15912kB min:20kB low:24kB high:28kB 
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB 
managed:15912kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB 
pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB 
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[2363000.815432] lowmem_reserve[]: 0 4066 8001 8001 8001
[2363000.815441] Node 0 DMA32 free:27548kB min:5812kB low:7264kB 
high:8716kB active_anon:82216kB inactive_anon:67924kB 
active_file:1693368kB inactive_file:1694900kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:4177920kB 
managed:4166864kB mlocked:0kB dirty:72356kB writeback:0kB mapped:9316kB 
shmem:86876kB slab_reclaimable:570924kB slab_unreclaimable:12088kB 
kernel_stack:1216kB pagetables:1084kB unstable:0kB bounce:0kB 
free_pcp:808kB local_pcp:180kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:412 all_unreclaimable? no
[2363000.815471] lowmem_reserve[]: 0 0 3934 3934 3934
[2363000.815479] Node 0 Normal free:9764kB min:5624kB low:7028kB 
high:8436kB active_anon:180752kB inactive_anon:69768kB 
active_file:1444080kB inactive_file:1442988kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:4194304kB 
managed:4029332kB mlocked:0kB dirty:86500kB writeback:0kB mapped:6892kB 
shmem:85404kB slab_reclaimable:824224kB slab_unreclaimable:21440kB 
kernel_stack:1088kB pagetables:2364kB unstable:0kB bounce:0kB 
free_pcp:928kB local_pcp:220kB free_cma:0kB writeback_tmp:0kB 
pages_scanned:704 all_unreclaimable? no
[2363000.815508] lowmem_reserve[]: 0 0 0 0 0
[2363000.815515] Node 0 DMA: 0*4kB 1*8kB (U) 0*16kB 1*32kB (U) 2*64kB 
(U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB 
(M) = 15912kB
[2363000.815538] Node 0 DMA32: 6843*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 27372kB
[2363000.815554] Node 0 Normal: 2424*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 9696kB
[2363000.815571] 1611937 total pagecache pages
[2363000.815575] 0 pages in swap cache
[2363000.815580] Swap cache stats: add 0, delete 0, find 0/0
[2363000.815584] Free swap  = 0kB
[2363000.815588] Total swap = 0kB
[2363000.815592] 2097055 pages RAM
[2363000.815595] 0 pages HighMem/MovableOnly
[2363000.815599] 44028 pages reserved
[2363000.815603] 0 pages hwpoisoned
[2363000.815611] ------------[ cut here ]------------
[2363000.815628] WARNING: CPU: 3 PID: 883 at 
/build/linux-roORct/linux-4.5.3/fs/btrfs/transaction.c:1497 
create_pending_snapshot+0x89f/0xc80 [btrfs]()
[2363000.815637] BTRFS: Transaction aborted (error -12)
[2363000.815638] Modules linked in: binfmt_misc(E) nf_log_ipv6(E) 
ip6t_REJECT(E) nf_reject_ipv6(E) nf_conntrack_ipv6(E) nf_defrag_ipv6(E) 
ip6table_filter(E) ip6table_mangle(E) ip6table_raw(E) ip6_tables(E) 
nf_log_ipv4(E) nf_log_common(E) xt_LOG(E) xt_limit(E) ipt_REJECT(E) 
nf_reject_ipv4(E) xt_tcpudp(E) xt_owner(E) xt_multiport(E) 
xt_conntrack(E) iptable_filter(E) iptable_nat(E) nf_conntrack_ipv4(E) 
nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) 
iptable_mangle(E) iptable_raw(E) ip_tables(E) x_tables(E) intel_rapl(E) 
x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E) 
ghash_clmulni_intel(E) hmac(E) drbg(E) ansi_cprng(E) evdev(E) 
aesni_intel(E) pcspkr(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) 
ablk_helper(E) cryptd(E) quota_v2(E) quota_tree(E) loop(E) autofs4(E) 
ext4(E) crc16(E) mbcache(E) jbd2(E) btrfs(E) xor(E) raid6_pq(E) 
xen_netfront(E) xen_blkfront(E) crc32c_intel(E)
[2363000.815726] CPU: 3 PID: 883 Comm: btrfs Tainted: G        W   E 
4.5.0-0.bpo.2-amd64 #1 Debian 4.5.3-2~bpo8+1
[2363000.815734]  0000000000000200 00000000d30c738a ffffffff8130a125 
ffff88011f06ba78
[2363000.815743]  ffffffffc010cc98 ffffffff81079ba1 ffff8800d198abc0 
ffff88011f06bad0
[2363000.815751]  ffff88009823e0c0 ffff8800fe084200 ffff8801a8d2e1d0 
ffffffff81079c2c
[2363000.815760] Call Trace:
[2363000.815765]  [<ffffffff8130a125>] ? dump_stack+0x5c/0x77
[2363000.815772]  [<ffffffff81079ba1>] ? warn_slowpath_common+0x81/0xb0
[2363000.815777]  [<ffffffff81079c2c>] ? warn_slowpath_fmt+0x5c/0x80
[2363000.815793]  [<ffffffffc00842df>] ? 
create_pending_snapshot+0x89f/0xc80 [btrfs]
[2363000.815811]  [<ffffffffc0084724>] ? 
create_pending_snapshots+0x64/0x80 [btrfs]
[2363000.815828]  [<ffffffffc0085d53>] ? 
btrfs_commit_transaction+0x473/0xa30 [btrfs]
[2363000.815845]  [<ffffffffc0085132>] ? 
btrfs_record_root_in_trans+0x52/0x70 [btrfs]
[2363000.815862]  [<ffffffffc00863a6>] ? start_transaction+0x96/0x4d0 
[btrfs]
[2363000.815880]  [<ffffffffc00bbd2a>] ? btrfs_mksubvol+0x5ca/0x5e0 [btrfs]
[2363000.815886]  [<ffffffff810b95d0>] ? wait_woken+0x90/0x90
[2363000.815901]  [<ffffffffc00bbec0>] ? 
btrfs_ioctl_snap_create_transid+0x180/0x190 [btrfs]
[2363000.815920]  [<ffffffffc00bc048>] ? 
btrfs_ioctl_snap_create_v2+0x108/0x160 [btrfs]
[2363000.815938]  [<ffffffffc00c042d>] ? btrfs_ioctl+0x149d/0x2190 [btrfs]
[2363000.815944]  [<ffffffff811c4001>] ? alloc_pages_vma+0xc1/0x240
[2363000.815950]  [<ffffffff8100a895>] ? xen_set_pte_at+0x85/0x2d0
[2363000.815955]  [<ffffffff811a1288>] ? handle_mm_fault+0x13d8/0x1b90
[2363000.815961]  [<ffffffff811feab9>] ? do_vfs_ioctl+0x99/0x5d0
[2363000.815967]  [<ffffffff811ff066>] ? SyS_ioctl+0x76/0x90
[2363000.815974]  [<ffffffff815ba2b6>] ? 
system_call_fast_compare_end+0xc/0x6b
[2363000.815979] ---[ end trace bbbe8b54e43e30e8 ]---
[2363000.815985] BTRFS: error (device xvdb) in 
create_pending_snapshot:1497: errno=-12 Out of memory
[2363000.815992] BTRFS info (device xvdb): forced readonly
[2363000.815998] BTRFS warning (device xvdb): Skipping commit of aborted 
transaction.
[2363000.816025] BTRFS: error (device xvdb) in cleanup_transaction:1764: 
errno=-12 Out of memory


-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
