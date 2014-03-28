Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33797 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaC1Qm3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 12:42:29 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id D8F3A4282A1
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 17:42:27 +0100 (CET)
Received: from localhost (ip-95-223-253-98.unitymediagroup.de [95.223.253.98])
	by mail.virtall.com (Postfix) with ESMTPSA id C4BDE42829C
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 17:42:27 +0100 (CET)
Date: Fri, 28 Mar 2014 17:42:26 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 - handling disk failures?
Message-ID: <20140328174226.25045186@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 2) In btrfs, once you drop below the natural minimum number of devices
> to sustain that raid type, btrfs goes read-only as writes can no
> longer be done in the configured raid mode, which naturally blocks
> anything attempting to write to the filesystem.  I suspect that's
> what's happening to you.

No, it never went into read only mode.
If it did, I would see:

# touch testfile
touch: cannot touch `testfile': Read-only file system

and not waiting for IO.

Anyway, the RAID-1 filesystem looks now hosed after a drive failed in
it, and btrfs filesystem hanged when adding a new device.

Getting these kernel oopses now when trying to write anything there:

[  553.040075] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
[  553.040264] IP: [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  553.040378] PGD 0 
[  553.040484] Oops: 0000 [#1] SMP 
[  553.040622] Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 parport_pc i2c_core parport tpm_infineon tpm_tis video ehci_pci pcspkr ehci_hcd lpc_ich mfd_core acpi_cpufreq button battery tpm ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[  553.042270] CPU: 1 PID: 4951 Comm: btrfs-delalloc- Not tainted 3.14.0-rc8 #1
[  553.042351] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  553.042474] task: ffff8807f3f98000 ti: ffff8807ebc42000 task.ti: ffff8807ebc42000
[  553.042594] RIP: 0010:[<ffffffff8111f33b>]  [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  553.042749] RSP: 0018:ffff8807ebc43af0  EFLAGS: 00010246
[  553.042828] RAX: 0000000000000100 RBX: 0000000000001000 RCX: 0000000214919ca0
[  553.042909] RDX: ffffea001f4ccc00 RSI: ffff8807ff148430 RDI: 0000000000000000
[  553.042990] RBP: ffff8807ebc43b48 R08: 0000000000001000 R09: 0000000000000000
[  553.043071] R10: 0000000000000000 R11: 0000000000014a98 R12: ffff8807ebc43c78
[  553.043151] R13: 0000000000000000 R14: 0000000214919ca0 R15: ffff8807ff148430
[  553.043233] FS:  0000000000000000(0000) GS:ffff88081fa40000(0000) knlGS:0000000000000000
[  553.043354] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  553.043433] CR2: 0000000000000098 CR3: 000000000160b000 CR4: 00000000001407e0
[  553.043513] Stack:
[  553.043587]  ffffffffa02e3b08 00000010ebc43b28 0000000000000000 ffffea001f4ccc00
[  553.043835]  0000041100000000 ffff8807ebc43b28 ffffea001f4ccc00 0000000000000000
[  553.044082]  0000000000000001 ffff8807ff148430 ffff8807ff1485a8 ffff8807ebc43c58
[  553.044330] Call Trace:
[  553.044419]  [<ffffffffa02e3b08>] ? submit_extent_page.isra.38+0x10c/0x17e [btrfs]
[  553.044551]  [<ffffffffa02e535d>] __extent_writepage+0x542/0x5d2 [btrfs]
[  553.044643]  [<ffffffffa02e389a>] ? end_extent_writepage+0x5c/0x5c [btrfs]
[  553.044734]  [<ffffffffa02e58c6>] extent_write_locked_range+0xbf/0x124 [btrfs]
[  553.044865]  [<ffffffffa02cec56>] ? btrfs_fiemap+0x4c/0x4c [btrfs]
[  553.044954]  [<ffffffffa02d2349>] submit_compressed_extents+0x133/0x424 [btrfs]
[  553.045084]  [<ffffffffa02d26bd>] async_cow_submit+0x83/0x88 [btrfs]
[  553.045174]  [<ffffffffa02f0fcc>] run_ordered_completions+0x68/0xc5 [btrfs]
[  553.045264]  [<ffffffffa02f1659>] worker_loop+0x16e/0x495 [btrfs]
[  553.045353]  [<ffffffffa02f14eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[  553.045435]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[  553.045516]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[  553.045598]  [<ffffffff8139a03c>] ret_from_fork+0x7c/0xb0
[  553.045678]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[  553.045758] Code: c4 b8 f1 ff 48 83 c8 ff 41 59 5b 5d c3 90 90 90 55 48 89 e5 53 48 89 f3 51 f6 46 10 08 75 05 e8 e6 62 07 00 8b 43 38 5a 5b 5d c3 <48> 8b 87 98 00 00 00 55 b9 00 01 00 00 48 89 e5 48 8b 90 80 02 
[  553.048083] RIP  [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  553.048196]  RSP <ffff8807ebc43af0>
[  553.048272] CR2: 0000000000000098
[  553.048349] ---[ end trace 36d74486b120a453 ]---
[  581.331680] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
[  581.331867] IP: [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  581.331981] PGD 0 
[  581.332087] Oops: 0000 [#2] SMP 
[  581.332227] Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 parport_pc i2c_core parport tpm_infineon tpm_tis video ehci_pci pcspkr ehci_hcd lpc_ich mfd_core acpi_cpufreq button battery tpm ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[  581.333870] CPU: 3 PID: 5025 Comm: btrfs-transacti Tainted: G      D      3.14.0-rc8 #1
[  581.333989] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[  581.334109] task: ffff8807f3e30000 ti: ffff8807e770a000 task.ti: ffff8807e770a000
[  581.334226] RIP: 0010:[<ffffffff8111f33b>]  [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  581.334377] RSP: 0018:ffff8807e770b7d0  EFLAGS: 00010246
[  581.334454] RAX: 0000000000000100 RBX: 0000000000001000 RCX: 00000001a049e238
[  581.334534] RDX: ffffea001f24a400 RSI: ffff8807e9888040 RDI: 0000000000000000
[  581.334614] RBP: ffff8807e770b828 R08: 0000000000001000 R09: 0000000000000000
[  581.334694] R10: 0000000000000000 R11: ffff8807cfed9690 R12: ffff8807e770ba08
[  581.334774] R13: 0000000000000000 R14: 00000001a049e238 R15: ffff8807e9888040
[  581.334854] FS:  0000000000000000(0000) GS:ffff88081fac0000(0000) knlGS:0000000000000000
[  581.334974] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  581.335053] CR2: 0000000000000098 CR3: 000000000160b000 CR4: 00000000001407e0
[  581.335133] Stack:
[  581.335206]  ffffffffa02e3b08 ffff8807e770b828 0000000000000000 ffffea001f24a400
[  581.335449]  0000002000000000 ffff8807e770b8c0 0000034093c47000 ffffea001f24a400
[  581.335693]  0000000000001000 0000000000000000 0000000000000000 ffff8807e770b938
[  581.335935] Call Trace:
[  581.336021]  [<ffffffffa02e3b08>] ? submit_extent_page.isra.38+0x10c/0x17e [btrfs]
[  581.336147]  [<ffffffffa02e4a97>] __do_readpage+0x49f/0x540 [btrfs]
[  581.336251]  [<ffffffffa02e3d59>] ? repair_io_failure+0x19e/0x19e [btrfs]
[  581.336335]  [<ffffffffa02c42f0>] ? verify_parent_transid+0x146/0x146 [btrfs]
[  581.336420]  [<ffffffffa02e09dd>] ? btrfs_lookup_ordered_extent+0x5d/0xb4 [btrfs]
[  581.336544]  [<ffffffffa02e4bed>] __extent_read_full_page+0xb5/0xc4 [btrfs]
[  581.336628]  [<ffffffffa02c42f0>] ? verify_parent_transid+0x146/0x146 [btrfs]
[  581.336712]  [<ffffffffa02e6ce7>] read_extent_buffer_pages+0x1ff/0x219 [btrfs]
[  581.336831]  [<ffffffff811ac285>] ? radix_tree_insert+0xf3/0x1bf
[  581.336914]  [<ffffffffa02c42f0>] ? verify_parent_transid+0x146/0x146 [btrfs]
[  581.336997]  [<ffffffffa02c5865>] btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
[  581.337121]  [<ffffffffa02c5dea>] read_tree_block+0x2c/0x45 [btrfs]
[  581.337204]  [<ffffffffa02ae1bf>] read_block_for_search.isra.40+0x2b4/0x2fb [btrfs]
[  581.337326]  [<ffffffffa02a9745>] ? unlock_up+0xdd/0x120 [btrfs]
[  581.338518]  [<ffffffffa02b02e2>] btrfs_search_slot+0x5ee/0x7dd [btrfs]
[  581.338600]  [<ffffffffa02b17d9>] btrfs_insert_empty_items+0x58/0xa4 [btrfs]
[  581.338683]  [<ffffffffa02bc11c>] __btrfs_run_delayed_refs+0x6c6/0xc36 [btrfs]
[  581.338806]  [<ffffffffa02be2b3>] btrfs_run_delayed_refs+0x7e/0x212 [btrfs]
[  581.338890]  [<ffffffffa02cbb3d>] btrfs_commit_transaction+0x375/0x7ff [btrfs]
[  581.339013]  [<ffffffffa02c9ea8>] transaction_kthread+0xef/0x1c3 [btrfs]
[  581.339107]  [<ffffffffa02c9db9>] ? open_ctree+0x1b5c/0x1b5c [btrfs]
[  581.339195]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[  581.339272]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[  581.339351]  [<ffffffff8139a03c>] ret_from_fork+0x7c/0xb0
[  581.339429]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[  581.339507] Code: c4 b8 f1 ff 48 83 c8 ff 41 59 5b 5d c3 90 90 90 55 48 89 e5 53 48 89 f3 51 f6 46 10 08 75 05 e8 e6 62 07 00 8b 43 38 5a 5b 5d c3 <48> 8b 87 98 00 00 00 55 b9 00 01 00 00 48 89 e5 48 8b 90 80 02
[  581.341762] RIP  [<ffffffff8111f33b>] bio_get_nr_vecs+0x0/0x38
[  581.341870]  RSP <ffff8807e770b7d0>
[  581.341944] CR2: 0000000000000098
[  581.342019] ---[ end trace 36d74486b120a454 ]---


-- 
Tomasz Chmielewski
http://wpkg.org
