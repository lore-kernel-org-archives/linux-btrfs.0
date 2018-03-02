Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32996 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165155AbeCBSci (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 13:32:38 -0500
Date: Fri, 2 Mar 2018 10:29:52 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Alex Adriaanse <alex@oseberg.io>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ongoing Btrfs stability issues
Message-ID: <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2018 at 09:40:41PM +0200, Nikolay Borisov wrote:
> 
> 
> On  1.03.2018 21:04, Alex Adriaanse wrote:
> > On Feb 16, 2018, at 1:44 PM, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
...
> <snip>
> > [496003.641729] BTRFS: error (device xvdc) in __btrfs_free_extent:7076: errno=-28 No space left
> > [496003.641994] BTRFS: error (device xvdc) in btrfs_drop_snapshot:9332: errno=-28 No space left
> > [496003.641996] BTRFS info (device xvdc): forced readonly
> > [496003.641998] BTRFS: error (device xvdc) in merge_reloc_roots:2470: errno=-28 No space left
> > [496003.642060] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > [496003.642086] IP: __del_reloc_root+0x3c/0x100 [btrfs]
> > [496003.642087] PGD 80000005fe08c067 P4D 80000005fe08c067 PUD 3bd2f4067 PMD 0
> > [496003.642091] Oops: 0000 [#1] SMP PTI
> > [496003.642093] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
> > [496003.642128] CPU: 1 PID: 25327 Comm: btrfs Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
> > [496003.642129] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
> > [496003.642130] task: ffff8fbffb8dd080 task.stack: ffff9e81c7b8c000
> > [496003.642149] RIP: 0010:__del_reloc_root+0x3c/0x100 [btrfs]
> 
> 
> if you happen to have the vmlinux of that kernel can you run the
> following from the kernel source directory:
> 
> ./scripts/faddr2line  __del_reloc_root+0x3c/0x100 vmlinux
>

I thought this was fixed by bb166d7 btrfs: fix NULL pointer dereference from free_reloc_roots(),
Alex, do you mind checking if it's included in your kernel?

You can also check if the following change is merged in kernel-src deb.

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3a49a3c..9841fae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2400,11 +2400,11 @@ void free_reloc_roots(struct list_head *list)
        while (!list_empty(list)) {
                reloc_root = list_entry(list->next, struct btrfs_root,
                                        root_list);
+               __del_reloc_root(reloc_root);
                free_extent_buffer(reloc_root->node);
                free_extent_buffer(reloc_root->commit_root);
                reloc_root->node = NULL;
                reloc_root->commit_root = NULL;
-               __del_reloc_root(reloc_root);
        }
 }


Thanks,

-liubo

> 
> > [496003.642151] RSP: 0018:ffff9e81c7b8fab0 EFLAGS: 00010286
> > [496003.642153] RAX: 0000000000000000 RBX: ffff8fb90a10a3c0 RCX: ffffca5d1fda5a5f
> > [496003.642154] RDX: 0000000000000001 RSI: ffff8fc05eae62c0 RDI: ffff8fbc4fd87d70
> > [496003.642154] RBP: ffff8fbbb5139000 R08: 0000000000000000 R09: 0000000000000000
> > [496003.642155] R10: ffff8fc05eae62c0 R11: 00000000000001bc R12: ffff8fc0fbeac000
> > [496003.642156] R13: ffff8fbc4fd87d70 R14: ffff8fbc4fd87800 R15: 00000000ffffffe4
> > [496003.642157] FS:  00007f64196708c0(0000) GS:ffff8fc100a40000(0000) knlGS:0000000000000000
> > [496003.642159] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [496003.642160] CR2: 0000000000000000 CR3: 000000069b972004 CR4: 00000000001606e0
> > [496003.642162] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [496003.642163] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [496003.642164] Call Trace:
> > [496003.642185]  free_reloc_roots+0x22/0x60 [btrfs]
> > [496003.642202]  merge_reloc_roots+0x184/0x260 [btrfs]
> > [496003.642217]  relocate_block_group+0x29a/0x610 [btrfs]
> > [496003.642232]  btrfs_relocate_block_group+0x17b/0x230 [btrfs]
> > [496003.642254]  btrfs_relocate_chunk+0x38/0xb0 [btrfs]
> > [496003.642272]  btrfs_balance+0xa15/0x1250 [btrfs]
> > [496003.642292]  btrfs_ioctl_balance+0x368/0x380 [btrfs]
> > [496003.642309]  btrfs_ioctl+0x1170/0x24e0 [btrfs]
> > [496003.642312]  ? mem_cgroup_try_charge+0x86/0x1a0
> > [496003.642315]  ? __handle_mm_fault+0x640/0x10e0
> > [496003.642318]  ? do_vfs_ioctl+0x9f/0x600
> > [496003.642319]  do_vfs_ioctl+0x9f/0x600
> > [496003.642321]  ? handle_mm_fault+0xc6/0x1b0
> > [496003.642325]  ? __do_page_fault+0x289/0x500
> > [496003.642327]  SyS_ioctl+0x74/0x80
> > [496003.642330]  system_call_fast_compare_end+0xc/0x6f
> > [496003.642332] RIP: 0033:0x7f64186f8e07
> > [496003.642333] RSP: 002b:00007ffcdf69d1b8 EFLAGS: 00000206
> > [496003.642334] Code: 8b a7 f0 01 00 00 4d 8b b4 24 40 14 00 00 4d 8d ae 70 05 00 00 4c 89 ef e8 c2 b9 3e c2 49 8b 9e 68 05 00 00 48 8b 45 00 48 85 db <48> 8b 10 75 0e e9 ad 00 00 00 48 8b 5b 10 48 85 db 74 11 48 3b
> > [496003.642376] RIP: __del_reloc_root+0x3c/0x100 [btrfs] RSP: ffff9e81c7b8fab0
> > [496003.642377] CR2: 0000000000000000
> > [496003.642393] ---[ end trace 6f05416539a50c4e ]---
> 
