Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbeCIQg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 11:36:28 -0500
Subject: Re: Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs
To: Martin Svec <martin.svec@zoner.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5a54af49-c18f-3534-7d58-5224363926c7@zoner.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3622d05f-b31e-6f3d-a70c-d32c4667ef43@suse.com>
Date: Fri, 9 Mar 2018 18:36:25 +0200
MIME-Version: 1.0
In-Reply-To: <5a54af49-c18f-3534-7d58-5224363926c7@zoner.cz>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.02.2018 16:28, Martin Svec wrote:
> Hello,
> 
> we have a btrfs-based backup system using btrfs snapshots and rsync. Sometimes,
> we hit ENOSPC bug and the filesystem is remounted read-only. However, there's 
> still plenty of unallocated space according to "btrfs fi usage". So I think this
> isn't another edge condition when btrfs runs out of space due to fragmented chunks,
> but a bug in disk space allocation code. It suffices to umount the filesystem and
> remount it back and it works fine again. The frequency of ENOSPC seems to be
> dependent on metadata chunks usage. When there's a lot of free space in existing
> metadata chunks, the bug doesn't happen for months. If most metadata chunks are
> above ~98%, we hit the bug every few days. Below are details regarding the backup
> server and btrfs.
> 
> The backup works as follows: 
> 
>   * Every night, we create a btrfs snapshot on the backup server and rsync data
>     from a production server into it. This snapshot is then marked read-only and
>     will be used as a base subvolume for the next backup snapshot.
>   * Every day, expired snapshots are removed and their space is freed. Cleanup
>     is scheduled in such a way that it doesn't interfere with the backup window.
>   * Multiple production servers are backed up in parallel to one backup server.
>   * The backed up servers are mostly webhosting servers and mail servers, i.e.
>     hundreds of billions of small files. (Yes, we push btrfs to the limits :-))
>   * Backup server contains ~1080 snapshots, Zlib compression is enabled.
>   * Rsync is configured to use whole file copying.
> 
> System configuration:
> 
> Debian Stretch, vanilla stable 4.14.20 kernel with one custom btrfs patch (see below) and
> Nikolay's patch 1b816c23e9 (btrfs: Add enospc_debug printing in metadata_reserve_bytes)
> 
> btrfs mount options: noatime,compress=zlib,enospc_debug,space_cache=v2,commit=15
> 
> $ btrfs fi df /backup:
> 
> Data, single: total=28.05TiB, used=26.37TiB
> System, single: total=32.00MiB, used=3.53MiB
> Metadata, single: total=255.00GiB, used=250.73GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> $ btrfs fi show /backup:
> 
> Label: none  uuid: a52501a9-651c-4712-a76b-7b4238cfff63
>         Total devices 2 FS bytes used 26.62TiB
>         devid    1 size 416.62GiB used 255.03GiB path /dev/sdb
>         devid    2 size 36.38TiB used 28.05TiB path /dev/sdc
> 
> $ btrfs fi usage /backup:
> 
> Overall:
>     Device size:                  36.79TiB
>     Device allocated:             28.30TiB
>     Device unallocated:            8.49TiB
>     Device missing:                  0.00B
>     Used:                         26.62TiB
>     Free (estimated):             10.17TiB      (min: 10.17TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:28.05TiB, Used:26.37TiB
>    /dev/sdc       28.05TiB
> 
> Metadata,single: Size:255.00GiB, Used:250.73GiB
>    /dev/sdb      255.00GiB
> 
> System,single: Size:32.00MiB, Used:3.53MiB
>    /dev/sdb       32.00MiB
> 
> Unallocated:
>    /dev/sdb      161.59GiB
>    /dev/sdc        8.33TiB
> 
> Btrfs filesystem uses two logical drives in single mode, backed by
> hardware RAID controller PERC H710; /dev/sdb is HW RAID1 consisting
> of two SATA SSDs and /dev/sdc is HW RAID6 SATA volume.
> 
> Please note that we have a simple custom patch in btrfs which ensures
> that metadata chunks are allocated preferably on SSD volume and data
> chunks are allocated only on SATA volume. The patch slightly modifies
> __btrfs_alloc_chunk() so that its loop over devices ignores rotating
> devices when a metadata chunk is requested and vice versa. However, 
> I'm quite sure that this patch doesn't cause the reported bug because
> we log every call of the modified code and there're no __btrfs_alloc_chunk()
> calls when ENOSPC is triggered. Moreover, we observed the same bug before
> we developed the patch. (IIRC, Chris Mason mentioned that they work on
> a similar feature in facebook, but I've found no official patches yet.)
> 
> Dmesg dump:
> 
> [285167.750763] use_block_rsv: 62468 callbacks suppressed
> [285167.750764] BTRFS: block rsv returned -28
> [285167.750789] ------------[ cut here ]------------
> [285167.750822] WARNING: CPU: 5 PID: 443 at fs/btrfs/extent-tree.c:8463 btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
> [285167.750823] Modules linked in: binfmt_misc xt_comment xt_tcpudp iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack iptable_raw ip6table_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntr
> [285167.750853]  zstd_compress xxhash raid6_pq sd_mod crc32c_intel psmouse uhci_hcd ehci_pci ehci_hcd megaraid_sas usbcore scsi_mod bnx2
> [285167.750861] CPU: 5 PID: 443 Comm: btrfs-transacti Tainted: G        W I     4.14.20-znr1+ #69
> [285167.750862] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.6.3 02/01/2011
> [285167.750863] task: ffff9c4a1740e280 task.stack: ffffba48c1ecc000
> [285167.750878] RIP: 0010:btrfs_alloc_tree_block+0x39b/0x4c0 [btrfs]
> [285167.750879] RSP: 0018:ffffba48c1ecf958 EFLAGS: 00010282
> [285167.750880] RAX: 000000000000001d RBX: ffff9c4a1c2ce128 RCX: 0000000000000006
> [285167.750881] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff9c4a2fd566f0
> [285167.750882] RBP: 0000000000004000 R08: 0000000000000001 R09: 00000000000003dc
> [285167.750883] R10: 0000000000000001 R11: 00000000000003dc R12: ffff9c4a1c2ce000
> [285167.750883] R13: ffff9c4a17692800 R14: 0000000000000001 R15: 00000000ffffffe4
> [285167.750885] FS:  0000000000000000(0000) GS:ffff9c4a2fd40000(0000) knlGS:0000000000000000
> [285167.750885] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [285167.750886] CR2: 000056250e55bfd0 CR3: 000000000ee0a003 CR4: 00000000000206e0
> [285167.750887] Call Trace:
> [285167.750903]  __btrfs_cow_block+0x125/0x5c0 [btrfs]
> [285167.750917]  btrfs_cow_block+0xcb/0x1b0 [btrfs]
> [285167.750929]  btrfs_search_slot+0x1fd/0x9e0 [btrfs]
> [285167.750943]  lookup_inline_extent_backref+0x105/0x610 [btrfs]
> [285167.750961]  ? set_extent_bit+0x19/0x20 [btrfs]
> [285167.750974]  __btrfs_free_extent.isra.61+0xf5/0xd30 [btrfs]
> [285167.750992]  ? btrfs_merge_delayed_refs+0x63/0x560 [btrfs]
> [285167.751006]  __btrfs_run_delayed_refs+0x516/0x12a0 [btrfs]
> [285167.751021]  btrfs_run_delayed_refs+0x7a/0x270 [btrfs]
> [285167.751037]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
> [285167.751053]  ? start_transaction+0x89/0x410 [btrfs]
> [285167.751068]  transaction_kthread+0x195/0x1b0 [btrfs]
> [285167.751071]  kthread+0xfc/0x130
> [285167.751087]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
> [285167.751088]  ? kthread_create_on_node+0x70/0x70
> [285167.751091]  ret_from_fork+0x35/0x40
> [285167.751092] Code: ff 48 c7 c6 28 d7 44 c0 48 c7 c7 a0 21 4a c0 e8 3c a5 4b cb 85 c0 0f 84 1c fd ff ff 44 89 fe 48 c7 c7 c0 4c 45 c0 e8 80 fd f1 ca <0f> ff e9 06 fd ff ff 4c 63 e8 31 d2 48 89 ee 48 89 df e8 4e eb
> [285167.751114] ---[ end trace 8721883b5af677ec ]---
> [285169.096630] BTRFS info (device sdb): space_info 4 has 18446744072120172544 free, is not full
> [285169.096633] BTRFS info (device sdb): space_info total=273804165120, used=269218267136, pinned=3459629056, reserved=52396032, may_use=2663120896, readonly=131072
> [285169.096638] BTRFS: Transaction aborted (error -28)
> [285169.096664] ------------[ cut here ]------------
> [285169.096691] WARNING: CPU: 7 PID: 443 at fs/btrfs/extent-tree.c:3089 btrfs_run_delayed_refs+0x259/0x270 [btrfs]
> [285169.096692] Modules linked in: binfmt_misc xt_comment xt_tcpudp iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack iptable_raw ip6table_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntr
> [285169.096722]  zstd_compress xxhash raid6_pq sd_mod crc32c_intel psmouse uhci_hcd ehci_pci ehci_hcd megaraid_sas usbcore scsi_mod bnx2
> [285169.096729] CPU: 7 PID: 443 Comm: btrfs-transacti Tainted: G        W I     4.14.20-znr1+ #69
> [285169.096730] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.6.3 02/01/2011
> [285169.096731] task: ffff9c4a1740e280 task.stack: ffffba48c1ecc000
> [285169.096745] RIP: 0010:btrfs_run_delayed_refs+0x259/0x270 [btrfs]
> [285169.096746] RSP: 0018:ffffba48c1ecfde0 EFLAGS: 00010282
> [285169.096747] RAX: 0000000000000026 RBX: ffff9c47990c0780 RCX: 0000000000000006
> [285169.096748] RDX: 0000000000000000 RSI: 0000000000000082 RDI: ffff9c4a2fdd66f0
> [285169.096749] RBP: ffff9c493d509b68 R08: 0000000000000001 R09: 0000000000000403
> [285169.096749] R10: ffff9c49731d6620 R11: 0000000000000403 R12: ffff9c4a1c2ce000
> [285169.096750] R13: ffff9c4a1c2cf1f0 R14: ffffffffffffffff R15: 0000000000000000
> [285169.096751] FS:  0000000000000000(0000) GS:ffff9c4a2fdc0000(0000) knlGS:0000000000000000
> [285169.096752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [285169.096753] CR2: 000055e70555bfe0 CR3: 000000000ee0a005 CR4: 00000000000206e0
> [285169.096754] Call Trace:
> [285169.096774]  btrfs_commit_transaction+0x3e1/0x950 [btrfs]
> [285169.096790]  ? start_transaction+0x89/0x410 [btrfs]
> [285169.096806]  transaction_kthread+0x195/0x1b0 [btrfs]
> [285169.096809]  kthread+0xfc/0x130
> [285169.096825]  ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
> [285169.096826]  ? kthread_create_on_node+0x70/0x70
> [285169.096828]  ret_from_fork+0x35/0x40
> [285169.096830] Code: c7 c6 20 d8 44 c0 48 89 df 44 89 04 24 e8 19 bb 09 00 44 8b 04 24 eb 86 44 89 c6 48 c7 c7 30 48 45 c0 44 89 04 24 e8 d2 40 f2 ca <0f> ff 44 8b 04 24 eb c4 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00
> [285169.096852] ---[ end trace 8721883b5af677ed ]---
> [285169.096918] BTRFS: error (device sdb) in btrfs_run_delayed_refs:3089: errno=-28 No space left
> [285169.096976] BTRFS info (device sdb): forced readonly
> [285169.096979] BTRFS warning (device sdb): Skipping commit of aborted transaction.
> [285169.096981] BTRFS: error (device sdb) in cleanup_transaction:1873: errno=-28 No space left
> 
> 
> How can I help you to fix this issue?

As a first step can you try and apply the following debug diff, recompile 
the kernel, mount again the fs with enospc_debug:

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d227d8514b25..501043bd92d6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8472,6 +8472,21 @@ use_block_rsv(struct btrfs_trans_handle *trans,
                ret = block_rsv_use_bytes(global_rsv, blocksize);
                if (!ret)
                        return global_rsv;
+               else {
+                       u64 reserved = 0;
+                       u64 size = 0;
+                       spin_lock(&global_rsv->lock);
+                       reserved = global_rsv->reserved;
+                       size = global_rsv->size;
+                       spin_unlock(&global_rsv->lock);
+                       pr_info("%s: Couldn't allocate %d bytes from global rsv(reserved = %llu size = %llu)\n",
+                               __func__, blocksize, reserved, size);
+               }
+       } else {
+               if (btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
+                       pr_info("%s: Not using global blockrsv! Current blockrsv->type = %d blockrsv->space_info = %p global_rsv->space_info = %p\n",
+                               __func__, block_rsv->type, block_rsv->space_info, global_rsv->space_info);
+               }
        }
        return ERR_PTR(ret);
 }


And then report back on the output of the extra debug 
statements. 

Your global rsv is essentially unused, this means 
in the worst case the code should fallback to using the global rsv
for satisfying the memory allocation for delayed refs. So we should
figure out why this isn't' happening. 
> 
> Regards,
> 
> Martin Svec
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
