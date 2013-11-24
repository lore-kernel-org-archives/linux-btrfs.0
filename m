Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56971 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab3KXFM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 00:12:57 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 980E2366543
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 06:12:53 +0100 (CET)
Received: from localhost (e0109-106-188-79-69.uqwimax.jp [106.188.79.69])
	by mail.virtall.com (Postfix) with ESMTPSA id DBE34366519
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 06:12:52 +0100 (CET)
Date: Sun, 24 Nov 2013 14:12:45 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: WARNING: CPU: 7 PID: 1239 at fs/btrfs/inode.c:4721
 inode_tree_add+0xc2/0x13f [btrfs]()
Message-ID: <20131124141245.6fd7bb1b@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting these with 3.13-rc1:

[53358.655620] ------------[ cut here ]------------
[53358.655686] WARNING: CPU: 7 PID: 1239 at fs/btrfs/inode.c:4721 inode_tree_add+0xc2/0x13f [btrfs]()
[53358.655779] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop i2c_i801 i2c_core lpc_ich ehci_pci ehci_hcd mfd_core button video acpi_cpufreq pcspkr ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[53358.656094] CPU: 7 PID: 1239 Comm: btrfs-endio-wri Not tainted 3.13.0-rc1 #1
[53358.656142] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[53358.656232]  0000000000000009 ffff8803f1fedb18 ffffffff81389e7d 0000000000000006
[53358.656322]  0000000000000000 ffff8803f1fedb58 ffffffff810370a9 ffff88053edb7e00
[53358.656411]  ffffffffa02715f7 ffff8804434aa580 ffff8804434a3230 ffff8807edb37800
[53358.656500] Call Trace:
[53358.656546]  [<ffffffff81389e7d>] dump_stack+0x46/0x58
[53358.656595]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
[53358.656648]  [<ffffffffa02715f7>] ? inode_tree_add+0xc2/0x13f [btrfs]
[53358.656697]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
[53358.656749]  [<ffffffffa02715f7>] inode_tree_add+0xc2/0x13f [btrfs]
[53358.656802]  [<ffffffffa027809f>] btrfs_iget+0x46c/0x4b6 [btrfs]
[53358.656851]  [<ffffffff81108700>] ? igrab+0x40/0x41
[53358.656902]  [<ffffffffa02781ee>] relink_extent_backref+0x105/0x6cf [btrfs]
[53358.656955]  [<ffffffffa0278f75>] btrfs_finish_ordered_io+0x7bd/0x877 [btrfs]
[53358.657008]  [<ffffffffa027903f>] finish_ordered_fn+0x10/0x12 [btrfs]
[53358.657063]  [<ffffffffa02940f5>] worker_loop+0x15e/0x495 [btrfs]
[53358.657115]  [<ffffffffa0293f97>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[53358.657165]  [<ffffffff8104ee3a>] kthread+0xcd/0xd5
[53358.657211]  [<ffffffff8104ed6d>] ? kthread_freezable_should_stop+0x43/0x43
[53358.657260]  [<ffffffff8138ec3c>] ret_from_fork+0x7c/0xb0
[53358.657307]  [<ffffffff8104ed6d>] ? kthread_freezable_should_stop+0x43/0x43
[53358.657355] ---[ end trace bf9f7dd59e43977f ]---


-- 
Tomasz Chmielewski
http://wpkg.org
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
