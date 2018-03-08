Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0051.outbound.protection.outlook.com ([104.47.41.51]:63449
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752135AbeCHRkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 12:40:41 -0500
From: Alex Adriaanse <alex@oseberg.io>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ongoing Btrfs stability issues
Date: Thu, 8 Mar 2018 17:40:38 +0000
Message-ID: <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
In-Reply-To: <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 2, 2018, at 11:29 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Mar 01, 2018 at 09:40:41PM +0200, Nikolay Borisov wrote:
>> On  1.03.2018 21:04, Alex Adriaanse wrote:
>>> Thanks so much for the suggestions so far, everyone. I wanted to report back on this. Last Friday I made the following changes per suggestions from this thread:
>>> 
>>> 1. Change the nightly balance to the following:
>>> 
>>>    btrfs balance start -dusage=20 <fs>
>>>    btrfs balance start -dusage=40,limit=10 <fs>
>>>    btrfs balance start -musage=30 <fs>
>>> 
>>> 2. Upgrade kernels for all VMs to 4.14.13-1~bpo9+1, which contains the SSD space allocation fix.
>>> 
>>> 3. Boot Linux with the elevator=noop option
>>> 
>>> 4. Change /sys/block/xvd*/queue/scheduler to "none"
>>> 
>>> 5. Mount all our Btrfs filesystems with the "enospc_debug" option.
>> 
>> SO that's good, however you didn't apply the out of tree patch (it has
>> already been merged into the for-next so will likely land in 4.17) I
>> pointed you at. As a result when you your ENOSPC error there is no extra
>> information being printed so we can't really reason about what might be
>> going wrong in the metadata flushing algorithms.

Sorry, I clearly missed that one. I have applied the patch you referenced and rebooted the VM in question. This morning we had another FS failure on the same machine that caused it to go into readonly mode. This happened after that device was experiencing 100% I/O utilization for some time. No balance was running at the time; last balance finished about 6 hours prior to the error.

Kernel messages:
[211238.262683] use_block_rsv: 163 callbacks suppressed
[211238.262683] BTRFS: block rsv returned -28
[211238.266718] ------------[ cut here ]------------
[211238.270462] WARNING: CPU: 0 PID: 391 at fs/btrfs/extent-tree.c:8463 btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
[211238.277203] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev parport_pc intel_rapl_perf parport serio_raw evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm drm_kms_helper aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse drm ena scsi_mod i2c_piix4 button
[211238.319618] CPU: 0 PID: 391 Comm: btrfs-transacti Tainted: G        W       4.14.13 #3
[211238.325479] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[211238.330742] task: ffff9cb43abb70c0 task.stack: ffffb234c3b58000
[211238.335575] RIP: 0010:btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
[211238.340454] RSP: 0018:ffffb234c3b5b958 EFLAGS: 00010282
[211238.344782] RAX: 000000000000001d RBX: ffff9cb43bdea128 RCX: 0000000000000000
[211238.350562] RDX: 0000000000000000 RSI: ffff9cb440a166f8 RDI: ffff9cb440a166f8
[211238.356066] RBP: 0000000000004000 R08: 0000000000000001 R09: 0000000000007d81
[211238.361649] R10: 0000000000000001 R11: 0000000000007d81 R12: ffff9cb43bdea000
[211238.367304] R13: ffff9cb437f2c800 R14: 0000000000000001 R15: 00000000ffffffe4
[211238.372658] FS:  0000000000000000(0000) GS:ffff9cb440a00000(0000) knlGS:0000000000000000
[211238.379048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[211238.384681] CR2: 00007f90a6677000 CR3: 00000003cea0a006 CR4: 00000000001606f0
[211238.391380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[211238.398050] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[211238.404730] Call Trace:
[211238.407880]  __btrfs_cow_block+0x125/0x5c0 [btrfs]
[211238.412455]  btrfs_cow_block+0xcb/0x1b0 [btrfs]
[211238.416292]  btrfs_search_slot+0x1fd/0x9e0 [btrfs]
[211238.420630]  lookup_inline_extent_backref+0x105/0x610 [btrfs]
[211238.425215]  __btrfs_free_extent.isra.61+0xf5/0xd30 [btrfs]
[211238.429663]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
[211238.434077]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
[211238.438541]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
[211238.442899]  ? remove_wait_queue+0x60/0x60
[211238.446503]  transaction_kthread+0x195/0x1b0 [btrfs]
[211238.450578]  kthread+0xfc/0x130
[211238.453924]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[211238.458381]  ? kthread_create_on_node+0x70/0x70
[211238.462225]  ? do_group_exit+0x3a/0xa0
[211238.465586]  ret_from_fork+0x1f/0x30
[211238.468814] Code: ff 48 c7 c6 28 97 58 c0 48 c7 c7 a0 e1 5d c0 e8 0c d0 f7 d5 85 c0 0f 84 1c fd ff ff 44 89 fe 48 c7 c7 58 0c 59 c0 e8 70 2f 9e d5 <0f> ff e9 06 fd ff ff 4c 63 e8 31 d2 48 89 ee 48 89 df e8 4e eb
[211238.482366] ---[ end trace 48dd1ab4e2e46f6e ]---
[211238.486524] BTRFS info (device xvdc): space_info 4 has 18446744073258958848 free, is not full
[211238.493014] BTRFS info (device xvdc): space_info total=10737418240, used=7828127744, pinned=2128166912, reserved=243367936, may_use=988282880, readonly=65536
[211238.503799] BTRFS: Transaction aborted (error -28)
[211238.503824] ------------[ cut here ]------------
[211238.507828] WARNING: CPU: 0 PID: 391 at fs/btrfs/extent-tree.c:7081 __btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[211238.514371] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev parport_pc intel_rapl_perf parport serio_raw evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm drm_kms_helper aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse drm ena scsi_mod i2c_piix4 button
[211238.552170] CPU: 0 PID: 391 Comm: btrfs-transacti Tainted: G        W       4.14.13 #3
[211238.557481] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[211238.562201] task: ffff9cb43abb70c0 task.stack: ffffb234c3b58000
[211238.566531] RIP: 0010:__btrfs_free_extent.isra.61+0xaed/0xd30 [btrfs]
[211238.571114] RSP: 0018:ffffb234c3b5bc30 EFLAGS: 00010286
[211238.574984] RAX: 0000000000000026 RBX: 000000ffb55b9000 RCX: 0000000000000006
[211238.579691] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff9cb440a166f0
[211238.584312] RBP: 00000000ffffffe4 R08: 0000000000000001 R09: 0000000000007da8
[211238.589144] R10: 0000000000000001 R11: 0000000000007da8 R12: ffff9cb43bdea000
[211238.594002] R13: ffff9caca472ed90 R14: 0000000000000000 R15: 000000000000a872
[211238.598817] FS:  0000000000000000(0000) GS:ffff9cb440a00000(0000) knlGS:0000000000000000
[211238.604230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[211238.608419] CR2: 00007f90a6677000 CR3: 00000003cea0a006 CR4: 00000000001606f0
[211238.613183] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[211238.617894] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[211238.622673] Call Trace:
[211238.625288]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
[211238.629399]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
[211238.633234]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
[211238.637135]  ? remove_wait_queue+0x60/0x60
[211238.640505]  transaction_kthread+0x195/0x1b0 [btrfs]
[211238.644313]  kthread+0xfc/0x130
[211238.647251]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[211238.651407]  ? kthread_create_on_node+0x70/0x70
[211238.654830]  ? do_group_exit+0x3a/0xa0
[211238.657961]  ret_from_fork+0x1f/0x30
[211238.661090] Code: 33 1b 0a 00 e9 39 f9 ff ff 8b 74 24 30 48 c7 c7 c8 07 59 c0 e8 a0 d7 9e d5 0f ff eb cc 89 ee 48 c7 c7 c8 07 59 c0 e8 8e d7 9e d5 <0f> ff e9 f9 f8 ff ff 8b 94 24 c0 00 00 00 48 89 c1 49 89 d8 48
[211238.672818] ---[ end trace 48dd1ab4e2e46f6f ]---
[211238.676465] BTRFS: error (device xvdc) in __btrfs_free_extent:7081: errno=-28 No space left
[211238.676713] BTRFS: error (device xvdc) in btrfs_drop_snapshot:9337: errno=-28 No space left
[211238.676716] BTRFS info (device xvdc): forced readonly
[211238.694217] BTRFS: error (device xvdc) in btrfs_run_delayed_refs:3089: errno=-28 No space left
[211238.700660] BTRFS warning (device xvdc): Skipping commit of aborted transaction.
[211238.706303] BTRFS: error (device xvdc) in cleanup_transaction:1873: errno=-28 No space left
...
[211243.218453] BTRFS error (device xvdc): pending csums is 4448256


btrfs filesystem usage:

Overall:
    Device size:		   1.37TiB
    Device allocated:		 656.04GiB
    Device unallocated:		 743.96GiB
    Device missing:		     0.00B
    Used:			 630.21GiB
    Free (estimated):		 767.05GiB	(min: 767.05GiB)
    Data ratio:			      1.00
    Metadata ratio:		      1.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:646.01GiB, Used:622.92GiB
   /dev/xvdc	 646.01GiB

Metadata,single: Size:10.00GiB, Used:7.29GiB
   /dev/xvdc	  10.00GiB

System,single: Size:32.00MiB, Used:112.00KiB
   /dev/xvdc	  32.00MiB

Unallocated:
   /dev/xvdc	 743.96GiB

>> <snip>
>>> [496003.641729] BTRFS: error (device xvdc) in __btrfs_free_extent:7076: errno=-28 No space left
>>> [496003.641994] BTRFS: error (device xvdc) in btrfs_drop_snapshot:9332: errno=-28 No space left
>>> [496003.641996] BTRFS info (device xvdc): forced readonly
>>> [496003.641998] BTRFS: error (device xvdc) in merge_reloc_roots:2470: errno=-28 No space left
>>> [496003.642060] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [496003.642086] IP: __del_reloc_root+0x3c/0x100 [btrfs]
>>> [496003.642087] PGD 80000005fe08c067 P4D 80000005fe08c067 PUD 3bd2f4067 PMD 0
>>> [496003.642091] Oops: 0000 [#1] SMP PTI
>>> [496003.642093] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
>>> [496003.642128] CPU: 1 PID: 25327 Comm: btrfs Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
>>> [496003.642129] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
>>> [496003.642130] task: ffff8fbffb8dd080 task.stack: ffff9e81c7b8c000
>>> [496003.642149] RIP: 0010:__del_reloc_root+0x3c/0x100 [btrfs]
>> 
>> 
>> if you happen to have the vmlinux of that kernel can you run the
>> following from the kernel source directory:
>> 
>> ./scripts/faddr2line  __del_reloc_root+0x3c/0x100 vmlinux
>> 

I used extract-vmlinux on the Debian-provided kernel, which is what was running previously, then ran the faddr2line command (with the filename first), but it couldn't find a match. I also did the same thing for the current kernel (for which I have a full vmlinux file available) with the function/offset from today's message, and still, no match.

$ scripts/faddr2line vmlinux btrfs_alloc_tree_block+0x39b/0x4c0
no match for btrfs_alloc_tree_block+0x39b/0x4c0


> I thought this was fixed by bb166d7 btrfs: fix NULL pointer dereference from free_reloc_roots(),
> Alex, do you mind checking if it's included in your kernel?
> 
> You can also check if the following change is merged in kernel-src deb.
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 3a49a3c..9841fae 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -2400,11 +2400,11 @@ void free_reloc_roots(struct list_head *list)
>        while (!list_empty(list)) {
>                reloc_root = list_entry(list->next, struct btrfs_root,
>                                        root_list);
> +               __del_reloc_root(reloc_root);
>                free_extent_buffer(reloc_root->node);
>                free_extent_buffer(reloc_root->commit_root);
>                reloc_root->node = NULL;
>                reloc_root->commit_root = NULL;
> -               __del_reloc_root(reloc_root);
>        }
> }
> 


I can confirm that this commit has indeed been applied to both the kernel we were running this morning that error'ed out, as well as the stock Debian linux-image-4.14.0-0.bpo.3-amd64 package that we were running when last week's error happened.


On Mar 1, 2018, at 10:02 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> Would you please try to use "btrfs check" to check the filesystem offline?
> I'm wondering if it's extent tree or free space cache get corrupted and
> makes kernel confused about its space allocation.
> 
> 
> I'm not completely sure, but it may also be something wrong with the
> space cache.
> 
> So either mount it with nospace_cache option of use "btrfs check
> --clear-space-cache v1" may help.


Running btrfs check some time after the VM had been rebooted and FS had been remounted (and then unmounted), I didn't see any btrfs check errors. However, running btrfs check today immediately after rebooting the VM, before remounting the FS, yielded the following output:

# btrfs check /dev/xvdc
Checking filesystem on /dev/xvdc
UUID: 2dd35565-641a-40f7-b29d-916c5c7e3ffe
checking extents
parent transid verify failed on 929281753088 wanted 202268 found 202782
parent transid verify failed on 929281753088 wanted 202268 found 202782
Ignoring transid failure
leaf parent key incorrect 929281753088
bad block 929281753088
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
checking csums
checking root refs
Transid errors in file system
found 676316246080 bytes used err is 1
total csum bytes: 652799620
total tree bytes: 7539572736
total fs tree bytes: 3933503488
total extent tree bytes: 2580004864
btree space waste bytes: 1502581682
file data blocks allocated: 4644964134912
 referenced 1503039082496


Alex