Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0057.outbound.protection.outlook.com ([104.47.40.57]:58319
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932069AbeCITFI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 14:05:08 -0500
From: Alex Adriaanse <alex@oseberg.io>
To: Nikolay Borisov <nborisov@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ongoing Btrfs stability issues
Date: Fri, 9 Mar 2018 19:05:03 +0000
Message-ID: <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
 <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
In-Reply-To: <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 9, 2018, at 3:54 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> <snip>
>> Sorry, I clearly missed that one. I have applied the patch you referenced and rebooted the VM in question. This morning we had another FS failure on the same machine that caused it to go into readonly mode. This happened after that device was experiencing 100% I/O utilization for some time. No balance was running at the time; last balance finished about 6 hours prior to the error.
>> 
>> Kernel messages:
>> [211238.262683] use_block_rsv: 163 callbacks suppressed
>> [211238.262683] BTRFS: block rsv returned -28
>> [211238.266718] ------------[ cut here ]------------
>> [211238.270462] WARNING: CPU: 0 PID: 391 at fs/btrfs/extent-tree.c:8463 btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
>> [211238.277203] Modules linked in: xt_nat xt_tcpudp veth ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat nf_conntrack libcrc32c crc32c_generic br_netfilter bridge stp llc intel_rapl sb_edac crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ppdev parport_pc intel_rapl_perf parport serio_raw evdev ip_tables x_tables autofs4 btrfs xor zstd_decompress zstd_compress xxhash raid6_pq ata_generic crc32c_intel ata_piix libata xen_blkfront cirrus ttm drm_kms_helper aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse drm ena scsi_mod i2c_piix4 button
>> [211238.319618] CPU: 0 PID: 391 Comm: btrfs-transacti Tainted: G        W       4.14.13 #3
>> [211238.325479] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
>> [211238.330742] task: ffff9cb43abb70c0 task.stack: ffffb234c3b58000
>> [211238.335575] RIP: 0010:btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
>> [211238.340454] RSP: 0018:ffffb234c3b5b958 EFLAGS: 00010282
>> [211238.344782] RAX: 000000000000001d RBX: ffff9cb43bdea128 RCX: 0000000000000000
>> [211238.350562] RDX: 0000000000000000 RSI: ffff9cb440a166f8 RDI: ffff9cb440a166f8
>> [211238.356066] RBP: 0000000000004000 R08: 0000000000000001 R09: 0000000000007d81
>> [211238.361649] R10: 0000000000000001 R11: 0000000000007d81 R12: ffff9cb43bdea000
>> [211238.367304] R13: ffff9cb437f2c800 R14: 0000000000000001 R15: 00000000ffffffe4
>> [211238.372658] FS:  0000000000000000(0000) GS:ffff9cb440a00000(0000) knlGS:0000000000000000
>> [211238.379048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [211238.384681] CR2: 00007f90a6677000 CR3: 00000003cea0a006 CR4: 00000000001606f0
>> [211238.391380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [211238.398050] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [211238.404730] Call Trace:
>> [211238.407880]  __btrfs_cow_block+0x125/0x5c0 [btrfs]
>> [211238.412455]  btrfs_cow_block+0xcb/0x1b0 [btrfs]
>> [211238.416292]  btrfs_search_slot+0x1fd/0x9e0 [btrfs]
>> [211238.420630]  lookup_inline_extent_backref+0x105/0x610 [btrfs]
>> [211238.425215]  __btrfs_free_extent.isra.61+0xf5/0xd30 [btrfs]
>> [211238.429663]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
>> [211238.434077]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
>> [211238.438541]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
>> [211238.442899]  ? remove_wait_queue+0x60/0x60
>> [211238.446503]  transaction_kthread+0x195/0x1b0 [btrfs]
>> [211238.450578]  kthread+0xfc/0x130
>> [211238.453924]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
>> [211238.458381]  ? kthread_create_on_node+0x70/0x70
>> [211238.462225]  ? do_group_exit+0x3a/0xa0
>> [211238.465586]  ret_from_fork+0x1f/0x30
>> [211238.468814] Code: ff 48 c7 c6 28 97 58 c0 48 c7 c7 a0 e1 5d c0 e8 0c d0 f7 d5 85 c0 0f 84 1c fd ff ff 44 89 fe 48 c7 c7 58 0c 59 c0 e8 70 2f 9e d5 <0f> ff e9 06 fd ff ff 4c 63 e8 31 d2 48 89 ee 48 89 df e8 4e eb
>> [211238.482366] ---[ end trace 48dd1ab4e2e46f6e ]---
>> [211238.486524] BTRFS info (device xvdc): space_info 4 has 18446744073258958848 free, is not full
>> [211238.493014] BTRFS info (device xvdc): space_info total=10737418240, used=7828127744, pinned=2128166912, reserved=243367936, may_use=988282880, readonly=65536
> 
> Ok so the numbers here are helpful, they show that we have enough space
> to allocate a chunk. I've also looked at the logic in 4.14.13 and all
> the necessary patches are there. Unfortunately none of this matters due
> to the fact that reserve_metadata_bytes is being called with
> BTRFS_RESERVE_NO_FLUSH from use_block_rsv, meaning the code won't make
> any effort to flush anything at all.
> 
> Can you tell again what the workload is - is it some sort of a database,
> constantly writing to its files?

Yes, we have PostgreSQL databases running these VMs that put a heavy I/O load on these machines. We also have snapshots being deleted and created every 15 minutes. Looking at historical atop data for the two most recent crashes:

1. Right before last week's crash, looking at the last three minutes before crash, Postgres databases were averaging a total of 45 MB/s in reads and 29 MB/s in writes. btrfs balance was also running at that time, which was reading at 1 MB/s and writing at 30 MB/s. btrfs-transacti kernel processes were doing only a small amount disk I/O, until a minute before the crash, at which time they ramped up to 0.4 MB/s in reads and 6 MB/s in writes. For cumulative I/O on the entire VM In the three minutes prior to the crash we saw an average of 95% I/O utilization, 2,200 read ops/sec, 47 MB/s read, 2,700 write ops/sec, 77 MB/s written.

2. Right before yesterday's crash (which had no balance running), Postgres databases were averaging a total of 81 MB/s in reads and 14 MB/s in writes. btrfs-cleaner and btrfs-transacti kernel processes weren't doing much I/O until the minute before the crash, at which point btrfs-cleaner was reading at 2 MB/s and writing at 16 MB/s, and btrfs-transacti was reading at 1 MB/s and writing at 5 MB/s. For cumulative I/O on the entire VM In the three minutes prior to the crash we saw an average of 103% I/O utilization, 2,600 read ops/sec, 86 MB/s read, 1,300 write ops/sec, 35 MB/s written.

I just realized both crashes happened within 5 minutes of snapshot creation + deletion. Not sure if that's just a coincidence.


> If so, btrfs is not really suited for
> rewrite-heavy workloads since this causes excessive CoW. In such cases
> you really ought to set nodatacow on the specified files. For more
> information:
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#Can_copy-on-write_be_turned_off_for_data_blocks.3F

Am I correct to understand that nodatacow doesn't really avoid CoW when you're using snapshots? In a filesystem that's snapshotted every 15 minutes, is there a difference between normal CoW and nodatacow when (in the case of Postgres) you update a small portion of a 1GB file many times per minute? Do you anticipate us seeing a benefit in stability and performance if we set nodatacow for the entire FS while retaining snapshots? Does nodatacow increase the chance of corruption in a database like Postgres, i.e. are writes still properly ordered/sync'ed when flushed to disk?


> The other thing that comes to mind is to try and tune the default commit
> interval. Currently this is 30 seconds, meaning a transaction will
> happen roughly every 30 seconds (unless there is enough data batched
> that it should happen "NOW", where "NOW" is defined as "during the life
> cycle of some arbitrary operation"). Perhaps in your case you could
> potentially lower it to, say 15s. This will likely have performance
> impact but should reduce the premature ENOSPC since there should be a
> lot less data in the transaction.
> 
> In the meantime I will investigate what can be done in case we get
> ENOSPC from NO_FLUSH contexts, my feeling is that we should be able to
> force allocate a new chunk. But this will take some time to verify.

Thanks for your help!

Alex

