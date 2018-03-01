Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0061.outbound.protection.outlook.com ([104.47.34.61]:5134
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1161068AbeCATFA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Mar 2018 14:05:00 -0500
From: Alex Adriaanse <alex@oseberg.io>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ongoing Btrfs stability issues
Date: Thu, 1 Mar 2018 19:04:58 +0000
Message-ID: <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
In-Reply-To: <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Feb 16, 2018, at 1:44 PM, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> I would suggest changing this to eliminate the balance with '-dusage=10' (it's redundant with the '-dusage=20' one unless your filesystem is in pathologically bad shape), and adding equivalent filters for balancing metadata (which generally goes pretty fast).
> 
> Unless you've got a huge filesystem, you can also cut down on that limit filter.  100 data chunks that are 40% full is up to 40GB of data to move on a normally sized filesystem, or potentially up to 200GB if you've got a really big filesystem (I forget what point BTRFS starts scaling up chunk sizes at, but I'm pretty sure it's in the TB range).

Thanks so much for the suggestions so far, everyone. I wanted to report back on this. Last Friday I made the following changes per suggestions from this thread:

1. Change the nightly balance to the following:

    btrfs balance start -dusage=20 <fs>
    btrfs balance start -dusage=40,limit=10 <fs>
    btrfs balance start -musage=30 <fs>

2. Upgrade kernels for all VMs to 4.14.13-1~bpo9+1, which contains the SSD space allocation fix.

3. Boot Linux with the elevator=noop option

4. Change /sys/block/xvd*/queue/scheduler to "none"

5. Mount all our Btrfs filesystems with the "enospc_debug" option.

6. I did NOT add the "nossd" flag because I didn't think it'd make much of a difference after that SSD space allocation fix.

7. After applying the above changes, ran a full balance on all the Btrfs filesystems. I also have not experimented with autodefrag yet.


Despite the changes above, we just experienced another crash this morning. Kernel message (with enospc_debug turned on for the given mountpoint):

[496003.170278] use_block_rsv: 46 callbacks suppressed
[496003.170279] BTRFS: block rsv returned -28
[496003.173875] ------------[ cut here ]------------
[496003.177186] WARNING: CPU: 2 PID: 362 at /build/linux-3RM5ap/linux-4.14.13/fs/btrfs/extent-tree.c:8458 btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
[496003.185369] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
[496003.218484] CPU: 2 PID: 362 Comm: btrfs-transacti Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
[496003.224618] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[496003.228702] task: ffff8fc0fb6bd0c0 task.stack: ffff9e81c3ac0000
[496003.233081] RIP: 0010:btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
[496003.237220] RSP: 0018:ffff9e81c3ac3958 EFLAGS: 00010282
[496003.241404] RAX: 000000000000001d RBX: ffff8fc0fbeac128 RCX: 0000000000000000
[496003.248004] RDX: 0000000000000000 RSI: ffff8fc100a966f8 RDI: ffff8fc100a966f8
[496003.253896] RBP: 0000000000004000 R08: 0000000000000001 R09: 000000000001667b
[496003.258508] R10: 0000000000000001 R11: 000000000001667b R12: ffff8fc0fbeac000
[496003.264759] R13: ffff8fc0fac22800 R14: 0000000000000001 R15: 00000000ffffffe4
[496003.271203] FS:  0000000000000000(0000) GS:ffff8fc100a80000(0000) knlGS:0000000000000000
[496003.278169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[496003.283917] CR2: 00007efe00f36000 CR3: 0000000102a0a001 CR4: 00000000001606e0
[496003.290309] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[496003.296985] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[496003.303335] Call Trace:
[496003.307113]  ? __pagevec_lru_add_fn+0x270/0x270
[496003.312126]  __btrfs_cow_block+0x125/0x5c0 [btrfs]
[496003.316995]  btrfs_cow_block+0xcb/0x1b0 [btrfs]
[496003.321568]  btrfs_search_slot+0x1fd/0x9e0 [btrfs]
[496003.326684]  lookup_inline_extent_backref+0x105/0x610 [btrfs]
[496003.332724]  ? set_extent_bit+0x19/0x20 [btrfs]
[496003.337991]  __btrfs_free_extent.isra.61+0xf5/0xd30 [btrfs]
[496003.343436]  ? btrfs_merge_delayed_refs+0x8f/0x560 [btrfs]
[496003.349322]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
[496003.355157]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
[496003.360707]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
[496003.366022]  ? remove_wait_queue+0x60/0x60
[496003.370898]  transaction_kthread+0x195/0x1b0 [btrfs]
[496003.376411]  kthread+0xfc/0x130
[496003.380741]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[496003.386404]  ? kthread_create_on_node+0x70/0x70
[496003.391287]  ? do_group_exit+0x3a/0xa0
[496003.396201]  ret_from_fork+0x1f/0x30
[496003.400779] Code: ff 48 c7 c6 28 b7 4c c0 48 c7 c7 a0 11 52 c0 e8 2c b0 43 c2 85 c0 0f 84 1c fd ff ff 44 89 fe 48 c7 c7 38 29 4d c0 e8 90 0f ea c1 <0f> ff e9 06 fd ff ff 4c 63 e8 31 d2 48 89 ee 48 89 df e8 6e eb
[496003.416648] ---[ end trace 6f05416539a50c4c ]---
[496003.422202] BTRFS: Transaction aborted (error -28)
[496003.422227] ------------[ cut here ]------------
[496003.427612] WARNING: CPU: 2 PID: 362 at /build/linux-3RM5ap/linux-4.14.13/fs/btrfs/extent-tree.c:7076 __btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[496003.440365] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
[496003.492382] CPU: 2 PID: 362 Comm: btrfs-transacti Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
[496003.502085] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[496003.508078] task: ffff8fc0fb6bd0c0 task.stack: ffff9e81c3ac0000
[496003.514294] RIP: 0010:__btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[496003.520807] RSP: 0018:ffff9e81c3ac3c30 EFLAGS: 00010286
[496003.525146] RAX: 0000000000000026 RBX: 000000d9dc6cc000 RCX: 0000000000000000
[496003.530148] RDX: 0000000000000000 RSI: ffff8fc100a966f8 RDI: ffff8fc100a966f8
[496003.535193] RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 00000000000166a3
[496003.540516] R10: 0000000000000001 R11: 00000000000166a3 R12: ffff8fc0fbeac000
[496003.545968] R13: ffff8fba3bedd930 R14: 0000000000000000 R15: 0000000000000002
[496003.551066] FS:  0000000000000000(0000) GS:ffff8fc100a80000(0000) knlGS:0000000000000000
[496003.557073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[496003.561445] CR2: 00007efe00f36000 CR3: 0000000102a0a001 CR4: 00000000001606e0
[496003.566625] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[496003.571756] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[496003.576948] Call Trace:
[496003.579607]  ? btrfs_merge_delayed_refs+0x8f/0x560 [btrfs]
[496003.583885]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
[496003.588099]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
[496003.592474]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
[496003.596766]  ? remove_wait_queue+0x60/0x60
[496003.600288]  transaction_kthread+0x195/0x1b0 [btrfs]
[496003.605278]  kthread+0xfc/0x130
[496003.608768]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[496003.614107]  ? kthread_create_on_node+0x70/0x70
[496003.617867]  ? do_group_exit+0x3a/0xa0
[496003.621231]  ret_from_fork+0x1f/0x30
[496003.624472] Code: 13 1b 0a 00 e9 39 f9 ff ff 8b 74 24 30 48 c7 c7 a8 24 4d c0 e8 a0 b7 ea c1 0f ff eb cc 89 ee 48 c7 c7 a8 24 4d c0 e8 8e b7 ea c1 <0f> ff e9 f9 f8 ff ff 8b 94 24 c0 00 00 00 48 89 c1 49 89 d8 48
[496003.637764] ---[ end trace 6f05416539a50c4d ]---
[496003.641729] BTRFS: error (device xvdc) in __btrfs_free_extent:7076: errno=-28 No space left
[496003.641994] BTRFS: error (device xvdc) in btrfs_drop_snapshot:9332: errno=-28 No space left
[496003.641996] BTRFS info (device xvdc): forced readonly
[496003.641998] BTRFS: error (device xvdc) in merge_reloc_roots:2470: errno=-28 No space left
[496003.642060] BUG: unable to handle kernel NULL pointer dereference at           (null)
[496003.642086] IP: __del_reloc_root+0x3c/0x100 [btrfs]
[496003.642087] PGD 80000005fe08c067 P4D 80000005fe08c067 PUD 3bd2f4067 PMD 0
[496003.642091] Oops: 0000 [#1] SMP PTI
[496003.642093] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
[496003.642128] CPU: 1 PID: 25327 Comm: btrfs Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
[496003.642129] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[496003.642130] task: ffff8fbffb8dd080 task.stack: ffff9e81c7b8c000
[496003.642149] RIP: 0010:__del_reloc_root+0x3c/0x100 [btrfs]
[496003.642151] RSP: 0018:ffff9e81c7b8fab0 EFLAGS: 00010286
[496003.642153] RAX: 0000000000000000 RBX: ffff8fb90a10a3c0 RCX: ffffca5d1fda5a5f
[496003.642154] RDX: 0000000000000001 RSI: ffff8fc05eae62c0 RDI: ffff8fbc4fd87d70
[496003.642154] RBP: ffff8fbbb5139000 R08: 0000000000000000 R09: 0000000000000000
[496003.642155] R10: ffff8fc05eae62c0 R11: 00000000000001bc R12: ffff8fc0fbeac000
[496003.642156] R13: ffff8fbc4fd87d70 R14: ffff8fbc4fd87800 R15: 00000000ffffffe4
[496003.642157] FS:  00007f64196708c0(0000) GS:ffff8fc100a40000(0000) knlGS:0000000000000000
[496003.642159] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[496003.642160] CR2: 0000000000000000 CR3: 000000069b972004 CR4: 00000000001606e0
[496003.642162] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[496003.642163] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[496003.642164] Call Trace:
[496003.642185]  free_reloc_roots+0x22/0x60 [btrfs]
[496003.642202]  merge_reloc_roots+0x184/0x260 [btrfs]
[496003.642217]  relocate_block_group+0x29a/0x610 [btrfs]
[496003.642232]  btrfs_relocate_block_group+0x17b/0x230 [btrfs]
[496003.642254]  btrfs_relocate_chunk+0x38/0xb0 [btrfs]
[496003.642272]  btrfs_balance+0xa15/0x1250 [btrfs]
[496003.642292]  btrfs_ioctl_balance+0x368/0x380 [btrfs]
[496003.642309]  btrfs_ioctl+0x1170/0x24e0 [btrfs]
[496003.642312]  ? mem_cgroup_try_charge+0x86/0x1a0
[496003.642315]  ? __handle_mm_fault+0x640/0x10e0
[496003.642318]  ? do_vfs_ioctl+0x9f/0x600
[496003.642319]  do_vfs_ioctl+0x9f/0x600
[496003.642321]  ? handle_mm_fault+0xc6/0x1b0
[496003.642325]  ? __do_page_fault+0x289/0x500
[496003.642327]  SyS_ioctl+0x74/0x80
[496003.642330]  system_call_fast_compare_end+0xc/0x6f
[496003.642332] RIP: 0033:0x7f64186f8e07
[496003.642333] RSP: 002b:00007ffcdf69d1b8 EFLAGS: 00000206
[496003.642334] Code: 8b a7 f0 01 00 00 4d 8b b4 24 40 14 00 00 4d 8d ae 70 05 00 00 4c 89 ef e8 c2 b9 3e c2 49 8b 9e 68 05 00 00 48 8b 45 00 48 85 db <48> 8b 10 75 0e e9 ad 00 00 00 48 8b 5b 10 48 85 db 74 11 48 3b
[496003.642376] RIP: __del_reloc_root+0x3c/0x100 [btrfs] RSP: ffff9e81c7b8fab0
[496003.642377] CR2: 0000000000000000
[496003.642393] ---[ end trace 6f05416539a50c4e ]---
[496003.692818] BTRFS info (device xvdb): relocating block group 10657726464 flags data
[496003.981807] BTRFS: error (device xvdc) in btrfs_run_delayed_refs:3089: errno=-28 No space left
[496003.989872] BTRFS warning (device xvdc): Skipping commit of aborted transaction.
[496003.996616] BTRFS: error (device xvdc) in cleanup_transaction:1873: errno=-28 No space left
[496004.517098] BTRFS info (device xvdb): found 7338 extents

At the time of this Oops "btrfs balance start -dusage 40 limit 10 <fs>" was running (it had been running for about 3 hours). Disk I/O utilization was close to 100%, both before the balance started, as well as between the time the balance started and the Oops above.

"btrfs filesystem usage" output, before rebooting:
Overall:
    Device size:		   1.37TiB
    Device allocated:		 688.04GiB
    Device unallocated:		 711.96GiB
    Device missing:		     0.00B
    Used:			 608.88GiB
    Free (estimated):		 788.31GiB	(min: 788.31GiB)
    Data ratio:			      1.00
    Metadata ratio:		      1.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:673.01GiB, Used:596.66GiB
   /dev/xvdc	 673.01GiB

Metadata,single: Size:15.00GiB, Used:12.23GiB
   /dev/xvdc	  15.00GiB

System,single: Size:32.00MiB, Used:112.00KiB
   /dev/xvdc	  32.00MiB

Unallocated:
   /dev/xvdc	 711.96GiB

Sum of /sys/fs/btrfs/<UUID/allocation/*/disk_total (after reboot and after an interrupted balance finished) is 683GB; total device size is 1400GB, so about 49% utilization.

Responding to Shehbaz's email:

On Feb 16, 2018, at 10:34 PM, Shehbaz Jaffer <shehbazjaffer007@gmail.com> wrote:
> Could you confirm if metadata DUP is enabled for your system by
> running the following cmd:
> 
> $btrfs fi df /mnt # mount is the mount point
> Data, single: total=8.00MiB, used=64.00KiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=168.00MiB, used=112.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> If metadata is single in your case as well (and not DUP), that may be
> the problem for btrfs-scrub not working effectively on the fly
> (mid-stream bit-rot correction), causing reliability issues. A couple
> of such bugs that are observed specifically for SSDs is reported here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=198463
> https://bugzilla.kernel.org/show_bug.cgi?id=198807
> 
> These do not occur for HDD, and I believe should not occur when
> filesystem is mounted with nossd mode.

"btrfs filesystem df" output, after rebooting:

Data, single: total=668.01GiB, used=548.25GiB
System, single: total=32.00MiB, used=112.00KiB
Metadata, single: total=15.00GiB, used=9.11GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

We don't run btrfs scrubs. I'm not convinced that duplicate metadata or running scrubs would've helped here, as I'm not experiencing any other signs of corruption other than disk space allocation being messed up.

Thanks,

Alex