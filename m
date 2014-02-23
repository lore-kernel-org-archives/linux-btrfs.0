Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:39724 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaBWLZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Feb 2014 06:25:33 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id ABF3C405DCF
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Feb 2014 12:25:29 +0100 (CET)
Received: from localhost (ip-176-198-177-122.unitymediagroup.de [176.198.177.122])
	by mail.virtall.com (Postfix) with ESMTPSA id 924474057A1
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Feb 2014 12:25:29 +0100 (CET)
Date: Sun, 23 Feb 2014 12:25:28 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/ctree.c:3215!
Message-ID: <20140223122528.1340bb03@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this with 3.14-rc3:

[525983.966567] ------------[ cut here ]------------
[525983.966645] kernel BUG at fs/btrfs/ctree.c:3215!
[525983.966705] invalid opcode: 0000 [#1] SMP
[525983.966765] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop parport_pc parport battery button video tpm_infineon tpm_tis tpm ehci_pci pcspkr acpi_cpufreq ehci_hcd i2c_i801 i2c_core lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[525983.967240] CPU: 4 PID: 15321 Comm: btrfs-endio-wri Not tainted 3.14.0-rc3 #1
[525983.967351] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[525983.967465] task: ffff8807f12a0000 ti: ffff8805eb9f8000 task.ti: ffff8805eb9f8000
[525983.967576] RIP: 0010:[<ffffffffa02a8361>]  [<ffffffffa02a8361>] btrfs_set_item_key_safe+0xb2/0x119 [btrfs]
[525983.967706] RSP: 0018:ffff8805eb9f9b18  EFLAGS: 00010286
[525983.967766] RAX: 00000000ffffffff RBX: 000000000000000a RCX: 0000000000000000
[525983.967877] RDX: 00000000033c9000 RSI: ffff8805eb9f9c4f RDI: ffff8805eb9f9af7
[525983.967987] RBP: ffff8805eb9f9b68 R08: ffff8805eb9f9b38 R09: ffff88047c1ccc08
[525983.968098] R10: 0000000000001000 R11: 0000160000000000 R12: ffff88047c1ccb40
[525983.968209] R13: ffff8807e7c76360 R14: ffff8802a351a000 R15: ffff8805eb9f9c4f
[525983.968321] FS:  0000000000000000(0000) GS:ffff88081fb00000(0000) knlGS:0000000000000000
[525983.968434] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[525983.968494] CR2: 00000000040f9fe8 CR3: 000000000160b000 CR4: 00000000001407e0
[525983.968604] Stack:
[525983.968657]  0000000000000000 2600000000000000 6c0000000000030f 00000000033c5000
[525983.968773]  0000000000030f26 ffff8807e7c76360 ffff88047c1ccb40 00000000033e0000
[525983.968888]  0000000000000000 0000000000000000 ffff8805eb9f9ca8 ffffffffa02d589d
[525983.969003] Call Trace:
[525983.969076]  [<ffffffffa02d589d>] __btrfs_drop_extents+0x6c1/0xb12 [btrfs]
[525983.969155]  [<ffffffffa02c9811>] insert_reserved_file_extent.constprop.63+0x9a/0x2a5 [btrfs]
[525983.969281]  [<ffffffffa02ccebb>] btrfs_finish_ordered_io+0x265/0x3ef [btrfs]
[525983.969403]  [<ffffffffa02cd055>] finish_ordered_fn+0x10/0x12 [btrfs]
[525983.969481]  [<ffffffffa02eb649>] worker_loop+0x15e/0x495 [btrfs]
[525983.969556]  [<ffffffffa02eb4eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[525983.969623]  [<ffffffff81050c76>] kthread+0xcd/0xd5
[525983.969685]  [<ffffffff81050ba9>] ? kthread_freezable_should_stop+0x43/0x43
[525983.969749]  [<ffffffff81398a7c>] ret_from_fork+0x7c/0xb0
[525983.969811]  [<ffffffff81050ba9>] ? kthread_freezable_should_stop+0x43/0x43
[525983.969873] Code: 8d 75 bf b9 11 00 00 00 4c 89 e7 48 63 d2 48 6b d2 19 48 83 c2 65 e8 b0 89 03 00 48 8d 7d bf 4c 89 fe e8 9e f5 ff ff 85 c0 7f 02 <0f> 0b 49 8b 47 09 48 63 d3 48 8d 75 bf 48 6b d2 19 b9 11 00 00
[525983.970116] RIP  [<ffffffffa02a8361>] btrfs_set_item_key_safe+0xb2/0x119 [btrfs]
[525983.970237]  RSP <ffff8805eb9f9b18>
[525983.970581] ---[ end trace 40b604c8c92dba0d ]---



-- 
Tomasz Chmielewski
http://wpkg.org
