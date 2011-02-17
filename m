From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 29302] New: Null pointer dereference with
 large max_sectors_kb
Date: Thu, 17 Feb 2011 15:37:19 -0800
Message-ID: <20110217153719.9ecc67df.akpm@linux-foundation.org>
References: <bug-29302-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, fox@murder.cz
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bug-29302-10286@https.bugzilla.kernel.org/>
List-ID: <linux-btrfs.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 17 Feb 2011 13:20:20 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=29302
> 
>            Summary: Null pointer dereference with large max_sectors_kb
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.36 - 2.6.38-rc5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Block Layer
>         AssignedTo: axboe@kernel.dk
>         ReportedBy: fox@murder.cz
>         Regression: No
> 
> 
> Created an attachment (id=48132)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=48132)
> dmesg with error displayed.
> 
> Hello, 
> I'm not really sure I identified the problem product/component correctly, but
> this seems most appropriate.
> 
> 
> [140517]stg-bot ~ # echo 256 >  /sys/block/sdb/queue/max_sectors_kb
> [140523]stg-bot ~ # mkfs.btrfs /dev/sdb
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> fs created label (null) on /dev/sdb
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
> Btrfs Btrfs v0.19
> [140532]stg-bot ~ # mount /dev/sdb /mnt
> [140540]stg-bot ~ # umount /mnt
> [140543]stg-bot ~ # cat /sys/block/sdb/queue/max_hw_sectors_kb >
> /sys/block/sdb/queue/max_sectors_kb
> [140710]stg-bot ~ # mkfs.btrfs /dev/sdb
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> fs created label (null) on /dev/sdb
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
> Btrfs Btrfs v0.19
> [140713]stg-bot ~ # mount /dev/sdb /mnt
> Killed
> [140715]stg-bot ~ #
> 
> Now there is a bug in dmesg (output attached) and another attempt to mount the
> device kind of freezes it. The mount blocks, sync blocks, but i can read/write
> the device using dd. And if I, instead of trying to mount again, zero out first
> 1MB, mkfs.btrfs and mount, I get the bug again. Freeze again on second mount
> attempt after that. 
> 
> This happens on 2.6.36 and 2.6.37 with scst patches, 2.6.37 vanilla and on
> 2.6.38-rc5 it just freezes the first time I try to mount. No outuput in dmesg.
> 
> The hardware is Dual Xeon E5620, 12GB ram, Areca 1880 with 3 arrays (testing on
> 3TB raid10 and 10TB raid6), SuperMicro X8DTU-F.
> 
> If I left out any important info, please let me know ;).
> 

A btrfs bug, I suspect.


> [  605.109630] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [  605.109928] IP: [<ffffffff81100a7a>] bio_add_page+0xa/0x40
> [  605.110089] PGD 277d70067 PUD 277e0a067 PMD 0 
> [  605.110247] Oops: 0000 [#1] SMP 
> [  605.110394] last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
> [  605.110686] CPU 6 
> [  605.110698] Modules linked in: ip6table_filter ip6_tables nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_physdev xt_hashlimit nfs ib_iser libiscsi scsi_transport_iscsi ib_ucm ib_ipoib rdma_ucm rdma_cm ib_cm iw_cm ib_sa ib_addr ib_uverbs ib_umad mlx4_ib ib_mthca ib_mad ib_core i7core_edac edac_core mlx4_core iTCO_wdt iTCO_vendor_support
> [  605.112285] 
> [  605.112419] Pid: 16666, comm: mount Not tainted 2.6.37stg #6 X8DTU/X8DTU
> [  605.112586] RIP: 0010:[<ffffffff81100a7a>]  [<ffffffff81100a7a>] bio_add_page+0xa/0x40
> [  605.112879] RSP: 0000:ffff8801833b39b8  EFLAGS: 00010296
> [  605.113035] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  605.113207] RDX: 0000000000001000 RSI: ffffea000c3cd200 RDI: 0000000000000000
> [  605.113382] RBP: ffff8801833b3ba0 R08: 0000000000000000 R09: 0000000000000000
> [  605.113554] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  605.113723] R13: 0000000000000000 R14: 000000000000a000 R15: ffff88024a19ab98
> [  605.113895] FS:  00007fbcfd971740(0000) GS:ffff880339c80000(0000) knlGS:0000000000000000
> [  605.114188] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  605.114352] CR2: 0000000000000010 CR3: 00000001c17d5000 CR4: 00000000000006e0
> [  605.114525] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  605.114695] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  605.114864] Process mount (pid: 16666, threadinfo ffff8801833b2000, task ffff8801b8b48cf0)
> [  605.115157] Stack:
> [  605.115290]  0000000000000000 ffffffff81251384 0000000001400000 ffffea000c3cd200
> [  605.115590]  0000000000000000 000000004a19ab88 ffff8801b966f380 0000100000000000
> [  605.115884]  ffffffff81255810 0000000000000000 0000000000000002 0000000001400000
> [  605.116180] Call Trace:
> [  605.116320]  [<ffffffff81251384>] ? submit_extent_page+0x164/0x280
> [  605.116488]  [<ffffffff81255810>] ? end_bio_extent_readpage+0x0/0x210
> [  605.116654]  [<ffffffff81257241>] ? __extent_read_full_page+0x4e1/0x680
> [  605.116820]  [<ffffffff81255810>] ? end_bio_extent_readpage+0x0/0x210
> [  605.116990]  [<ffffffff8122c260>] ? btree_get_extent+0x0/0x1e0
> [  605.117151]  [<ffffffff81257660>] ? read_extent_buffer_pages+0x280/0x3c0
> [  605.117320]  [<ffffffff812d77ec>] ? radix_tree_insert+0x1bc/0x210
> [  605.117488]  [<ffffffff8122c260>] ? btree_get_extent+0x0/0x1e0
> [  605.117651]  [<ffffffff8122e945>] ? btree_read_extent_buffer_pages+0x55/0xb0
> [  605.117820]  [<ffffffff8122ea05>] ? read_tree_block+0x35/0x60
> [  605.117980]  [<ffffffff8122ffc2>] ? open_ctree+0xd22/0x1440
> [  605.118140]  [<ffffffff812118f0>] ? btrfs_set_super+0x0/0x20
> [  605.118300]  [<ffffffff81212302>] ? btrfs_mount+0x372/0x4e0
> [  605.118465]  [<ffffffff810d7c85>] ? vfs_kern_mount+0x75/0x1b0
> [  605.118627]  [<ffffffff810ee19e>] ? get_fs_type+0x3e/0xd0
> [  605.118783]  [<ffffffff810d7e33>] ? do_kern_mount+0x53/0x130
> [  605.118942]  [<ffffffff810f15b9>] ? do_mount+0x2d9/0x840
> [  605.119100]  [<ffffffff810ab7eb>] ? memdup_user+0x3b/0x80
> [  605.119257]  [<ffffffff810f1bba>] ? sys_mount+0x9a/0x100
> [  605.119417]  [<ffffffff81002d7b>] ? system_call_fastpath+0x16/0x1b
> [  605.119579] Code: ff ff ff 44 29 e2 31 c0 41 89 57 08 e9 7b fe ff ff 48 83 63 18 f7 e9 44 ff ff ff 66 0f 1f 44 00 00 48 83 ec 08 48 89 f8 41 89 c8 <48> 8b 4f 10 48 8b 89 98 00 00 00 48 8b b9 f0 01 00 00 89 d1 44 
> [  605.120217] RIP  [<ffffffff81100a7a>] bio_add_page+0xa/0x40
> [  605.120384]  RSP <ffff8801833b39b8>
> [  605.120527] CR2: 0000000000000010
> [  605.121058] ---[ end trace a5eba365422d1ba8 ]---

