Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42295 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaBXOmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:42 -0500
Received: by mail-bk0-f47.google.com with SMTP id w10so246276bkz.34
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 06:42:40 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140224144511.2bd54d47@virtall.com>
References: <20140223122528.1340bb03@virtall.com>
	<20140224144511.2bd54d47@virtall.com>
Date: Mon, 24 Feb 2014 14:42:40 +0000
Message-ID: <CAL3q7H4-C0rHGrCHkmdpMSTYMDCUJzhQCb03hK9vNOzEL3yEkg@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:3215!
From: Filipe David Manana <fdmanana@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 1:45 PM, Tomasz Chmielewski <tch@virtall.com> wrote:
> FYI, this crash was reproducible and was happening when using rsync
> with --inplace option on a fragmented file:
>
> # filefrag *
> bayes_journal: 2 extents found
> bayes_seen: 988 extents found
> bayes_toks: 41 extents found
>
>
> rsync process was hanging here:
>
> var/lib/amavis/.spamassassin/
> var/lib/amavis/.spamassassin/bayes_journal
> (no more entries after that)
>
> Mount option contains "autodefrag"; there were arond 20 snapshots of
> that subvolume present.
> After removing the fragmented file, it doesn't crash anymore. The size
> of the file was around 80 MB.
>
> Unfortunately I didn't check if the issue shows up with autodefrag
> mount option disabled.

That seems to suggest a leaf is getting keys out of order.
I run often the patch below to catch such issues during development,
it requires having CONFIG_BTRFS_FS_CHECK_INTEGRITY=y in the kernel
config file. If CONFIG_BTRFS_ASSERT=y is set too, it causes a BUG_ON
whenever a key is written out of order to a leaf. It's useful for
debugging.

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cc1b423..9fb4562 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3686,6 +3686,13 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
                __percpu_counter_add(&root->fs_info->dirty_metadata_bytes,
                                     buf->len,
                                     root->fs_info->dirty_metadata_batch);
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+       if (btrfs_header_level(buf) == 0 && check_leaf(root, buf)) {
+               btrfs_print_leaf(root, buf);
+               ASSERT(0);
+       }
+#endif
 }

 static void __btrfs_btree_balance_dirty(struct btrfs_root *root,



>
> --
> Tomasz Chmielewski
> http://wpkg.org
>
> On Sun, 23 Feb 2014 12:25:28 +0100
> Tomasz Chmielewski <tch@virtall.com> wrote:
>
>> Got this with 3.14-rc3:
>>
>> [525983.966567] ------------[ cut here ]------------
>> [525983.966645] kernel BUG at fs/btrfs/ctree.c:3215!
>> [525983.966705] invalid opcode: 0000 [#1] SMP
>> [525983.966765] Modules linked in: ipt_MASQUERADE iptable_nat
>> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
>> ip_tables x_tables cpufreq_ondemand cpufreq_conservative
>> cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor
>> raid6_pq zlib_deflate loop parport_pc parport battery button video
>> tpm_infineon tpm_tis tpm ehci_pci pcspkr acpi_cpufreq ehci_hcd
>> i2c_i801 i2c_core lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg
>> sd_mod ahci libahci libata scsi_mod r8169 mii [525983.967240] CPU: 4
>> PID: 15321 Comm: btrfs-endio-wri Not tainted 3.14.0-rc3 #1
>> [525983.967351] Hardware name: System manufacturer System Product
>> Name/P8H77-M PRO, BIOS 1101 02/04/2013 [525983.967465] task:
>> ffff8807f12a0000 ti: ffff8805eb9f8000 task.ti: ffff8805eb9f8000
>> [525983.967576] RIP: 0010:[<ffffffffa02a8361>]  [<ffffffffa02a8361>]
>> btrfs_set_item_key_safe+0xb2/0x119 [btrfs] [525983.967706] RSP:
>> 0018:ffff8805eb9f9b18  EFLAGS: 00010286 [525983.967766] RAX:
>> 00000000ffffffff RBX: 000000000000000a RCX: 0000000000000000
>> [525983.967877] RDX: 00000000033c9000 RSI: ffff8805eb9f9c4f RDI:
>> ffff8805eb9f9af7 [525983.967987] RBP: ffff8805eb9f9b68 R08:
>> ffff8805eb9f9b38 R09: ffff88047c1ccc08 [525983.968098] R10:
>> 0000000000001000 R11: 0000160000000000 R12: ffff88047c1ccb40
>> [525983.968209] R13: ffff8807e7c76360 R14: ffff8802a351a000 R15:
>> ffff8805eb9f9c4f [525983.968321] FS:  0000000000000000(0000)
>> GS:ffff88081fb00000(0000) knlGS:0000000000000000 [525983.968434] CS:
>> 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [525983.968494] CR2:
>> 00000000040f9fe8 CR3: 000000000160b000 CR4: 00000000001407e0
>> [525983.968604] Stack: [525983.968657]  0000000000000000
>> 2600000000000000 6c0000000000030f 00000000033c5000 [525983.968773]
>> 0000000000030f26 ffff8807e7c76360 ffff88047c1ccb40 00000000033e0000
>> [525983.968888]  0000000000000000 0000000000000000 ffff8805eb9f9ca8
>> ffffffffa02d589d [525983.969003] Call Trace: [525983.969076]
>> [<ffffffffa02d589d>] __btrfs_drop_extents+0x6c1/0xb12 [btrfs]
>> [525983.969155]  [<ffffffffa02c9811>]
>> insert_reserved_file_extent.constprop.63+0x9a/0x2a5 [btrfs]
>> [525983.969281]  [<ffffffffa02ccebb>]
>> btrfs_finish_ordered_io+0x265/0x3ef [btrfs] [525983.969403]
>> [<ffffffffa02cd055>] finish_ordered_fn+0x10/0x12 [btrfs]
>> [525983.969481]  [<ffffffffa02eb649>] worker_loop+0x15e/0x495 [btrfs]
>> [525983.969556]  [<ffffffffa02eb4eb>] ?
>> btrfs_queue_worker+0x269/0x269 [btrfs] [525983.969623]
>> [<ffffffff81050c76>] kthread+0xcd/0xd5 [525983.969685]
>> [<ffffffff81050ba9>] ? kthread_freezable_should_stop+0x43/0x43
>> [525983.969749]  [<ffffffff81398a7c>] ret_from_fork+0x7c/0xb0
>> [525983.969811]  [<ffffffff81050ba9>] ?
>> kthread_freezable_should_stop+0x43/0x43 [525983.969873] Code: 8d 75
>> bf b9 11 00 00 00 4c 89 e7 48 63 d2 48 6b d2 19 48 83 c2 65 e8 b0 89
>> 03 00 48 8d 7d bf 4c 89 fe e8 9e f5 ff ff 85 c0 7f 02 <0f> 0b 49 8b
>> 47 09 48 63 d3 48 8d 75 bf 48 6b d2 19 b9 11 00 00 [525983.970116]
>> RIP  [<ffffffffa02a8361>] btrfs_set_item_key_safe+0xb2/0x119 [btrfs]
>> [525983.970237]  RSP <ffff8805eb9f9b18> [525983.970581] ---[ end
>> trace 40b604c8c92dba0d ]---
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
