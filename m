Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbeCIJyJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 04:54:09 -0500
Subject: Re: Ongoing Btrfs stability issues
To: Alex Adriaanse <alex@oseberg.io>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
Date: Fri, 9 Mar 2018 11:54:05 +0200
MIME-Version: 1.0
In-Reply-To: <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

<snip>
> Sorry, I clearly missed that one. I have applied the patch you referenced and rebooted the VM in question. This morning we had another FS failure on the same machine that caused it to go into readonly mode. This happened after that device was experiencing 100% I/O utilization for some time. No balance was running at the time; last balance finished about 6 hours prior to the error.
> 
> Kernel messages:
> [211238.262683] use_block_rsv: 163 callbacks suppressed
> [211238.262683] BTRFS: block rsv returned -28
> [211238.266718] ------------[ cut here ]------------
> [211238.270462] WARNING: CPU: 0 PID: 391 at fs/btrfs/extent-tree.c:8463 btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
> [211238.277203] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev parport_pc intel_rapl_perf parport serio_raw evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm drm_kms_helper aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse drm ena scsi_mod i2c_piix4 button
> [211238.319618] CPU: 0 PID: 391 Comm: btrfs-transacti Tainted: G        W       4.14.13 #3
> [211238.325479] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
> [211238.330742] task: ffff9cb43abb70c0 task.stack: ffffb234c3b58000
> [211238.335575] RIP: 0010:btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
> [211238.340454] RSP: 0018:ffffb234c3b5b958 EFLAGS: 00010282
> [211238.344782] RAX: 000000000000001d RBX: ffff9cb43bdea128 RCX: 0000000000000000
> [211238.350562] RDX: 0000000000000000 RSI: ffff9cb440a166f8 RDI: ffff9cb440a166f8
> [211238.356066] RBP: 0000000000004000 R08: 0000000000000001 R09: 0000000000007d81
> [211238.361649] R10: 0000000000000001 R11: 0000000000007d81 R12: ffff9cb43bdea000
> [211238.367304] R13: ffff9cb437f2c800 R14: 0000000000000001 R15: 00000000ffffffe4
> [211238.372658] FS:  0000000000000000(0000) GS:ffff9cb440a00000(0000) knlGS:0000000000000000
> [211238.379048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [211238.384681] CR2: 00007f90a6677000 CR3: 00000003cea0a006 CR4: 00000000001606f0
> [211238.391380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [211238.398050] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [211238.404730] Call Trace:
> [211238.407880]  __btrfs_cow_block+0x125/0x5c0 [btrfs]
> [211238.412455]  btrfs_cow_block+0xcb/0x1b0 [btrfs]
> [211238.416292]  btrfs_search_slot+0x1fd/0x9e0 [btrfs]
> [211238.420630]  lookup_inline_extent_backref+0x105/0x610 [btrfs]
> [211238.425215]  __btrfs_free_extent.isra.61+0xf5/0xd30 [btrfs]
> [211238.429663]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
> [211238.434077]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
> [211238.438541]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
> [211238.442899]  ? remove_wait_queue+0x60/0x60
> [211238.446503]  transaction_kthread+0x195/0x1b0 [btrfs]
> [211238.450578]  kthread+0xfc/0x130
> [211238.453924]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
> [211238.458381]  ? kthread_create_on_node+0x70/0x70
> [211238.462225]  ? do_group_exit+0x3a/0xa0
> [211238.465586]  ret_from_fork+0x1f/0x30
> [211238.468814] Code: ff 48 c7 c6 28 97 58 c0 48 c7 c7 a0 e1 5d c0 e8 0c d0 f7 d5 85 c0 0f 84 1c fd ff ff 44 89 fe 48 c7 c7 58 0c 59 c0 e8 70 2f 9e d5 <0f> ff e9 06 fd ff ff 4c 63 e8 31 d2 48 89 ee 48 89 df e8 4e eb
> [211238.482366] ---[ end trace 48dd1ab4e2e46f6e ]---
> [211238.486524] BTRFS info (device xvdc): space_info 4 has 18446744073258958848 free, is not full
> [211238.493014] BTRFS info (device xvdc): space_info total=10737418240, used=7828127744, pinned=2128166912, reserved=243367936, may_use=988282880, readonly=65536

Ok so the numbers here are helpful, they show that we have enough space
to allocate a chunk. I've also looked at the logic in 4.14.13 and all
the necessary patches are there. Unfortunately none of this matters due
to the fact that reserve_metadata_bytes is being called with
BTRFS_RESERVE_NO_FLUSH from use_block_rsv, meaning the code won't make
any effort to flush anything at all.

Can you tell again what the workload is - is it some sort of a database,
constantly writing to its files? If so, btrfs is not really suited for
rewrite-heavy workloads since this causes excessive CoW. In such cases
you really ought to set nodatacow on the specified files. For more
information:

https://btrfs.wiki.kernel.org/index.php/FAQ#Can_copy-on-write_be_turned_off_for_data_blocks.3F

The other thing that comes to mind is to try and tune the default commit
interval. Currently this is 30 seconds, meaning a transaction will
happen roughly every 30 seconds (unless there is enough data batched
that it should happen "NOW", where "NOW" is defined as "during the life
cycle of some arbitrary operation"). Perhaps in your case you could
potentially lower it to, say 15s. This will likely have performance
impact but should reduce the premature ENOSPC since there should be a
lot less data in the transaction.

In the meantime I will investigate what can be done in case we get
ENOSPC from NO_FLUSH contexts, my feeling is that we should be able to
force allocate a new chunk. But this will take some time to verify.

<snip>

> 
> 
> btrfs filesystem usage:
> 
> Overall:
>     Device size:		   1.37TiB
>     Device allocated:		 656.04GiB
>     Device unallocated:		 743.96GiB
>     Device missing:		     0.00B
>     Used:			 630.21GiB
>     Free (estimated):		 767.05GiB	(min: 767.05GiB)
>     Data ratio:			      1.00
>     Metadata ratio:		      1.00
>     Global reserve:		 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:646.01GiB, Used:622.92GiB
>    /dev/xvdc	 646.01GiB
> 
> Metadata,single: Size:10.00GiB, Used:7.29GiB
>    /dev/xvdc	  10.00GiB
> 
> System,single: Size:32.00MiB, Used:112.00KiB
>    /dev/xvdc	  32.00MiB
> 
> Unallocated:
>    /dev/xvdc	 743.96GiB
> 
>>> <snip>
>>>> [496003.641729] BTRFS: error (device xvdc) in __btrfs_free_extent:7076: errno=-28 No space left
>>>> [496003.641994] BTRFS: error (device xvdc) in btrfs_drop_snapshot:9332: errno=-28 No space left
>>>> [496003.641996] BTRFS info (device xvdc): forced readonly
>>>> [496003.641998] BTRFS: error (device xvdc) in merge_reloc_roots:2470: errno=-28 No space left
>>>> [496003.642060] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>>> [496003.642086] IP: __del_reloc_root+0x3c/0x100 [btrfs]
>>>> [496003.642087] PGD 80000005fe08c067 P4D 80000005fe08c067 PUD 3bd2f4067 PMD 0
>>>> [496003.642091] Oops: 0000 [#1] SMP PTI
>>>> [496003.642093] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev intel_rapl_perf serio_raw parport_pc parport evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm aesni_intel aes_x86_64 crypto_simd drm_kms_helper cryptd glue_helper ena psmouse drm scsi_mod i2c_piix4 button
>>>> [496003.642128] CPU: 1 PID: 25327 Comm: btrfs Tainted: G        W       4.14.0-0.bpo.3-amd64 #1 Debian 4.14.13-1~bpo9+1
>>>> [496003.642129] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
>>>> [496003.642130] task: ffff8fbffb8dd080 task.stack: ffff9e81c7b8c000
>>>> [496003.642149] RIP: 0010:__del_reloc_root+0x3c/0x100 [btrfs]
>>>
>>>
>>> if you happen to have the vmlinux of that kernel can you run the
>>> following from the kernel source directory:
>>>
>>> ./scripts/faddr2line  __del_reloc_root+0x3c/0x100 vmlinux
>>>
> 
> I used extract-vmlinux on the Debian-provided kernel, which is what was running previously, then ran the faddr2line command (with the filename first), but it couldn't find a match. I also did the same thing for the current kernel (for which I have a full vmlinux file available) with the function/offset from today's message, and still, no match.
> 
> $ scripts/faddr2line vmlinux btrfs_alloc_tree_block+0x39b/0x4c0
> no match for btrfs_alloc_tree_block+0x39b/0x4c0
> 
> 
>> I thought this was fixed by bb166d7 btrfs: fix NULL pointer dereference from free_reloc_roots(),
>> Alex, do you mind checking if it's included in your kernel?
>>
>> You can also check if the following change is merged in kernel-src deb.
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 3a49a3c..9841fae 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -2400,11 +2400,11 @@ void free_reloc_roots(struct list_head *list)
>>        while (!list_empty(list)) {
>>                reloc_root = list_entry(list->next, struct btrfs_root,
>>                                        root_list);
>> +               __del_reloc_root(reloc_root);
>>                free_extent_buffer(reloc_root->node);
>>                free_extent_buffer(reloc_root->commit_root);
>>                reloc_root->node = NULL;
>>                reloc_root->commit_root = NULL;
>> -               __del_reloc_root(reloc_root);
>>        }
>> }
>>
> 
> 
> I can confirm that this commit has indeed been applied to both the kernel we were running this morning that error'ed out, as well as the stock Debian linux-image-4.14.0-0.bpo.3-amd64 package that we were running when last week's error happened.
> 
> 
> On Mar 1, 2018, at 10:02 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> Would you please try to use "btrfs check" to check the filesystem offline?
>> I'm wondering if it's extent tree or free space cache get corrupted and
>> makes kernel confused about its space allocation.
>>
>>
>> I'm not completely sure, but it may also be something wrong with the
>> space cache.
>>
>> So either mount it with nospace_cache option of use "btrfs check
>> --clear-space-cache v1" may help.
> 
> 
> Running btrfs check some time after the VM had been rebooted and FS had been remounted (and then unmounted), I didn't see any btrfs check errors. However, running btrfs check today immediately after rebooting the VM, before remounting the FS, yielded the following output:
> 
> # btrfs check /dev/xvdc
> Checking filesystem on /dev/xvdc
> UUID: 2dd35565-641a-40f7-b29d-916c5c7e3ffe
> checking extents
> parent transid verify failed on 929281753088 wanted 202268 found 202782
> parent transid verify failed on 929281753088 wanted 202268 found 202782
> Ignoring transid failure
> leaf parent key incorrect 929281753088
> bad block 929281753088
> Errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Transid errors in file system
> found 676316246080 bytes used err is 1
> total csum bytes: 652799620
> total tree bytes: 7539572736
> total fs tree bytes: 3933503488
> total extent tree bytes: 2580004864
> btree space waste bytes: 1502581682
> file data blocks allocated: 4644964134912
>  referenced 1503039082496
> 
> 
> Alex
> 
