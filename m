Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:53063 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaCXNAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 09:00:37 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 77DC84239D0
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 14:00:34 +0100 (CET)
Received: from localhost (ip-95-223-253-98.unitymediagroup.de [95.223.253.98])
	by mail.virtall.com (Postfix) with ESMTPSA id 581184239C3
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 14:00:34 +0100 (CET)
Date: Mon, 24 Mar 2014 14:00:33 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Mysterious Kernel Bug
Message-ID: <20140324140033.1098f4b3@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had something similar with 3.14.0-rc7.

I saw it also with 3.14.0-rc3, as discussed in this thread:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/32938/focus=32977

Here is the trace for 3.14.0-rc7:

[377944.904848] ------------[ cut here ]------------
[377944.904947] kernel BUG at fs/btrfs/ctree.c:3215!
[377944.905007] invalid opcode: 0000 [#1] SMP
[377944.906494] Modules linked in: cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd battery tpm_infineon lpc_ich mfd_core pcspkr video tpm_tis tpm acpi_cpufreq button i2c_i801 parport_pc i2c_core parport ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 scsi_mod mii
[377944.906849] CPU: 4 PID: 10787 Comm: btrfs-endio-wri Not tainted 3.14.0-rc7 #1
[377944.906960] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[377944.907075] task: ffff8807f276b000 ti: ffff880601fb8000 task.ti: ffff880601fb8000
[377944.907187] RIP: 0010:[<ffffffffa02a8361>]  [<ffffffffa02a8361>] btrfs_set_item_key_safe+0xb2/0x119 [btrfs]
[377944.907316] RSP: 0018:ffff880601fb9b18  EFLAGS: 00010286
[377944.907375] RAX: 00000000ffffffff RBX: 0000000000000005 RCX: 0000000000000000
[377944.907487] RDX: 00000000001ce000 RSI: ffff880601fb9c4f RDI: ffff880601fb9af7
[377944.907598] RBP: ffff880601fb9b68 R08: ffff880601fb9b38 R09: ffff880123f56d48
[377944.907708] R10: 0000000000001000 R11: 0000160000000000 R12: ffff880123f56c80
[377944.907820] R13: ffff8807eff09990 R14: ffff88043cdc7000 R15: ffff880601fb9c4f
[377944.907931] FS:  0000000000000000(0000) GS:ffff88081fb00000(0000) knlGS:0000000000000000
[377944.908045] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[377944.908105] CR2: 00007fb78313d9de CR3: 000000000160b000 CR4: 00000000001407e0
[377944.908215] Stack:
[377944.908269]  ffff880691594000 a200000000000000 6c00000000000926 00000000001cc000
[377944.908384]  ffff880601fb9b68 ffff8807eff09990 ffff880123f56c80 00000000001e0000
[377944.908499]  0000000000000000 0000000000000001 ffff880601fb9ca8 ffffffffa02d589d
[377944.908615] Call Trace:
[377944.908687]  [<ffffffffa02d589d>] __btrfs_drop_extents+0x6c1/0xb12 [btrfs]
[377944.908765]  [<ffffffffa02c9811>] insert_reserved_file_extent.constprop.63+0x9a/0x2a5 [btrfs]
[377944.908892]  [<ffffffffa02ccebb>] btrfs_finish_ordered_io+0x265/0x3ef [btrfs]
[377944.909009]  [<ffffffff81040e5d>] ? usleep_range+0x3d/0x3d
[377944.909080]  [<ffffffffa02cd055>] finish_ordered_fn+0x10/0x12 [btrfs]
[377944.909157]  [<ffffffffa02eb649>] worker_loop+0x15e/0x495 [btrfs]
[377944.909232]  [<ffffffffa02eb4eb>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[377944.909298]  [<ffffffff81050c92>] kthread+0xcd/0xd5
[377944.909360]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[377944.909425]  [<ffffffff81399d7c>] ret_from_fork+0x7c/0xb0
[377944.909487]  [<ffffffff81050bc5>] ? kthread_freezable_should_stop+0x43/0x43
[377944.909549] Code: 8d 75 bf b9 11 00 00 00 4c 89 e7 48 63 d2 48 6b d2 19 48 83 c2 65 e8 b0 89 03 00 48 8d 7d bf 4c 89 fe e8 9e f5 ff ff 85 c0 7f 02 <0f> 0b 49 8b 47 09 48 63 d3 48 8d 75 bf 48 6b d2 19 b9 11 00 00
[377944.909794] RIP  [<ffffffffa02a8361>] btrfs_set_item_key_safe+0xb2/0x119 [btrfs]
[377944.909914]  RSP <ffff880601fb9b18>
[377944.910260] ---[ end trace e209399cfd0911cd ]---



-- 
Tomasz Chmielewski
http://wpkg.org
