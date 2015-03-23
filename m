Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57612 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbbCWMTv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 08:19:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id DD3415C3715
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 13:19:48 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2wsKHDL0KJOD for <linux-btrfs@vger.kernel.org>;
	Mon, 23 Mar 2015 13:19:48 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 13:19:48 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 23 Mar 2015 21:19:48 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BTRFS: unable to add free space :-17
Message-ID: <d1161c0c22333dfe9b77144aa18779b1@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this with 4.0.0-rc5 when doing a degraded mount:

Mar 23 13:09:22 server1 kernel: [  665.197957] BTRFS info (device sdb4): 
allowing degraded mounts
Mar 23 13:09:22 server1 kernel: [  665.198030] BTRFS info (device sdb4): 
disk space caching is enabled
Mar 23 13:09:22 server1 kernel: [  665.213163] BTRFS warning (device 
sdb4): devid 2 missing
Mar 23 13:09:22 server1 kernel: [  665.260077] BTRFS: bdev (null) errs: 
wr 1, rd 1, flush 0, corrupt 0, gen 0
Mar 23 13:10:01 server1 kernel: [  704.310874] ------------[ cut here 
]------------
Mar 23 13:10:01 server1 kernel: [  704.310936] WARNING: CPU: 1 PID: 4706 
at fs/btrfs/free-space-cache.c:1349 tree_insert_offset+0x7d/0xc3 
[btrfs]()
Mar 23 13:10:01 server1 kernel: [  704.310989] Modules linked in: ipv6 
cpufreq_stats cpufreq_powersave cpufreq_conservative btrfs xor raid6_pq 
zlib_deflate ext3 jbd loop 8250_fintek i2c_i801 parport_pc tpm_infineon 
tpm_tis tpm lpc_ich ehci_pci ehci_hcd mfd_core i2c_core parport pcspkr 
acpi_cpufreq button video ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci 
libahci libata scsi_mod r8169 mii
Mar 23 13:10:01 server1 kernel: [  704.312632] CPU: 1 PID: 4706 Comm: 
btrfs-transacti Not tainted 4.0.0-rc5 #1
Mar 23 13:10:01 server1 kernel: [  704.312680] Hardware name: System 
manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
Mar 23 13:10:01 server1 kernel: [  704.312732]  0000000000000009 
ffff880819917c18 ffffffff813c2f57 ffff88083fa4d801
Mar 23 13:10:01 server1 kernel: [  704.312928]  0000000000000000 
ffff880819917c58 ffffffff8103b031 ffff880036eb9540
Mar 23 13:10:01 server1 kernel: [  704.313124]  ffffffffa03126f6 
00000000ffffffef ffff880036eb9540 000001dd651b4000
Mar 23 13:10:01 server1 kernel: [  704.313321] Call Trace:
Mar 23 13:10:01 server1 kernel: [  704.313394]  [<ffffffff813c2f57>] 
dump_stack+0x45/0x57
Mar 23 13:10:01 server1 kernel: [  704.313469]  [<ffffffff8103b031>] 
warn_slowpath_common+0x97/0xb1
Mar 23 13:10:01 server1 kernel: [  704.313551]  [<ffffffffa03126f6>] ? 
tree_insert_offset+0x7d/0xc3 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.313627]  [<ffffffff8103b060>] 
warn_slowpath_null+0x15/0x17
Mar 23 13:10:01 server1 kernel: [  704.313707]  [<ffffffffa03126f6>] 
tree_insert_offset+0x7d/0xc3 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.313788]  [<ffffffffa0313142>] 
link_free_space+0x27/0x3c [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.313868]  [<ffffffffa03143cb>] 
__btrfs_add_free_space+0x354/0x39d [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.313952]  [<ffffffffa02f2864>] ? 
free_extent_state.part.29+0x34/0x39 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314062]  [<ffffffffa02f2864>] ? 
free_extent_state.part.29+0x34/0x39 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314170]  [<ffffffffa02c16b4>] ? 
block_group_cache_tree_search+0x8e/0xbd [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314279]  [<ffffffffa02c5518>] 
unpin_extent_range.isra.78+0xa6/0x199 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314387]  [<ffffffffa02c9aa2>] 
btrfs_finish_extent_commit+0xcb/0xea [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314497]  [<ffffffffa02dbc57>] 
btrfs_commit_transaction+0x850/0x9e1 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314606]  [<ffffffffa02d9bf0>] 
transaction_kthread+0xef/0x1c3 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314687]  [<ffffffffa02d9b01>] ? 
open_ctree+0x1d47/0x1d47 [btrfs]
Mar 23 13:10:01 server1 kernel: [  704.314763]  [<ffffffff810501a3>] 
kthread+0xcd/0xd5
Mar 23 13:10:01 server1 kernel: [  704.314836]  [<ffffffff810500d6>] ? 
kthread_freezable_should_stop+0x43/0x43
Mar 23 13:10:01 server1 kernel: [  704.314913]  [<ffffffff813c7848>] 
ret_from_fork+0x58/0x90
Mar 23 13:10:01 server1 kernel: [  704.314987]  [<ffffffff810500d6>] ? 
kthread_freezable_should_stop+0x43/0x43
Mar 23 13:10:01 server1 kernel: [  704.315063] ---[ end trace 
695f505b58a81c8d ]---
Mar 23 13:10:01 server1 kernel: [  704.315135] BTRFS: unable to add free 
space :-17
Mar 23 13:10:33 server1 kernel: [  736.510895] BTRFS: unable to add free 
space :-17
Mar 23 13:11:03 server1 kernel: [  765.780069] BTRFS: unable to add free 
space :-17
Mar 23 13:11:13 server1 kernel: [  776.030671] BTRFS: unable to add free 
space :-17
Mar 23 13:12:39 server1 kernel: [  861.791031] BTRFS: unable to add free 
space :-17
Mar 23 13:13:29 server1 kernel: [  911.761852] BTRFS: unable to add free 
space :-17
Mar 23 13:13:53 server1 kernel: [  936.124674] BTRFS: unable to add free 
space :-17



-- 
Tomasz Chmielewski
http://www.sslrack.com

