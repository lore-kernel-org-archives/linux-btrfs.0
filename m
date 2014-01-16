Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40921 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaAPF1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 00:27:47 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id ACBCB385305
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 06:27:43 +0100 (CET)
Received: from localhost (aees35.neoplus.adsl.tpnet.pl [79.186.122.35])
	by mail.virtall.com (Postfix) with ESMTPSA id 6D804384A92
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 06:27:43 +0100 (CET)
Date: Thu, 16 Jan 2014 06:27:41 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS critical: unable to find logical 0 len 4096, No mapping for
 0-4096
Message-ID: <20140116062741.2be67c5b@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yet another btrfs filesystem getting bad:

[43013.108612] ------------[ cut here ]------------
[43013.108675] WARNING: CPU: 2 PID: 30756 at fs/btrfs/ctree.c:1321 btrfs_search_old_slot+0x322/0x7ea [btrfs]()
[43013.108766] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci lpc_ich ehci_hcd mfd_core pcspkr video acpi_cpufreq i2c_i801 i2c_core button ext4 crc16 jbd2 mbcache raid1 sg sd_mod r8169 mii ahci libahci libata scsi_mod
[43013.109183] CPU: 2 PID: 30756 Comm: btrfs-endio-wri Not tainted 3.13.0-rc8 #2
[43013.109248] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[43013.109365]  0000000000000009 ffff8800a2b71908 ffffffff813898b7 0000000000000006
[43013.109486]  0000000000000000 ffff8800a2b71948 ffffffff810370a9 0000042f413d2000
[43013.109605]  ffffffffa0247e5a ffff8807ff39cc60 ffff8807c5edb800 ffff88051ce33e00
[43013.109725] Call Trace:
[43013.109789]  [<ffffffff813898b7>] dump_stack+0x46/0x58
[43013.109855]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
[43013.109933]  [<ffffffffa0247e5a>] ? btrfs_search_old_slot+0x322/0x7ea [btrfs]
[43013.110001]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
[43013.110077]  [<ffffffffa0247e5a>] btrfs_search_old_slot+0x322/0x7ea [btrfs]
[43013.110165]  [<ffffffffa02aab43>] __resolve_indirect_refs+0x10f/0x48d [btrfs]
[43013.110253]  [<ffffffffa02aba2e>] find_parent_nodes+0x337/0x5d2 [btrfs]
[43013.110338]  [<ffffffffa02ac4dc>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
[43013.110423]  [<ffffffffa0264981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[43013.110507]  [<ffffffffa0264981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[43013.110593]  [<ffffffffa02ac668>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[43013.110725]  [<ffffffffa0264919>] record_extent_backrefs+0x5b/0xc3 [btrfs]
[43013.110809]  [<ffffffffa026cf67>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
[43013.110877]  [<ffffffff810e4262>] ? kmem_cache_free+0x164/0x17a
[43013.110944]  [<ffffffff810af653>] ? mempool_free_slab+0x12/0x14
[43013.111027]  [<ffffffffa026d074>] finish_ordered_fn+0x10/0x12 [btrfs]
[43013.111111]  [<ffffffffa02880d9>] worker_loop+0x15e/0x495 [btrfs]
[43013.111194]  [<ffffffffa0287f7b>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[43013.111313]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
[43013.111376]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
[43013.111440]  [<ffffffff8138e6fc>] ret_from_fork+0x7c/0xb0
[43013.111513]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
[43013.111578] ---[ end trace 1ad74354031dadcd ]---
[43013.111654] BTRFS critical (device sdd1): unable to find logical 0 len 4096
[43013.111724] BTRFS critical (device sdd1): No mapping for 0-4096
[43013.111724] 
[43013.111848] ------------[ cut here ]------------
[43013.111914] WARNING: CPU: 2 PID: 30756 at fs/btrfs/ctree.c:1321 btrfs_search_old_slot+0x322/0x7ea [btrfs]()
[43013.112021] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci lpc_ich ehci_hcd mfd_core pcspkr video acpi_cpufreq i2c_i801 i2c_core button ext4 crc16 jbd2 mbcache raid1 sg sd_mod r8169 mii ahci libahci libata scsi_mod
[43013.112414] CPU: 2 PID: 30756 Comm: btrfs-endio-wri Tainted: G        W    3.13.0-rc8 #2
[43013.112518] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[43013.112625]  0000000000000009 ffff8800a2b71908 ffffffff813898b7 0000000000000006
[43013.112733]  0000000000000000 ffff8800a2b71948 ffffffff810370a9 0000042f413d2000
[43013.112841]  ffffffffa0247e5a ffff8807ff39cc60 ffff8807c5edb800 ffff88051ce33e00
[43013.112949] Call Trace:
[43013.113003]  [<ffffffff813898b7>] dump_stack+0x46/0x58
[43013.113061]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
[43013.113128]  [<ffffffffa0247e5a>] ? btrfs_search_old_slot+0x322/0x7ea [btrfs]
[43013.113189]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
[43013.113256]  [<ffffffffa0247e5a>] btrfs_search_old_slot+0x322/0x7ea [btrfs]
[43013.113331]  [<ffffffffa02aab43>] __resolve_indirect_refs+0x10f/0x48d [btrfs]
[43013.113406]  [<ffffffffa02aba2e>] find_parent_nodes+0x337/0x5d2 [btrfs]
[43013.113479]  [<ffffffffa02ac4dc>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
[43013.113553]  [<ffffffffa0264981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[43013.113625]  [<ffffffffa0264981>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[43013.113698]  [<ffffffffa02ac668>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[43013.113816]  [<ffffffffa0264919>] record_extent_backrefs+0x5b/0xc3 [btrfs]
[43013.113889]  [<ffffffffa026cf67>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
[43013.113950]  [<ffffffff810e4262>] ? kmem_cache_free+0x164/0x17a
[43013.114009]  [<ffffffff810af653>] ? mempool_free_slab+0x12/0x14
[43013.114081]  [<ffffffffa026d074>] finish_ordered_fn+0x10/0x12 [btrfs]
[43013.114153]  [<ffffffffa02880d9>] worker_loop+0x15e/0x495 [btrfs]
[43013.114226]  [<ffffffffa0287f7b>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[43013.114286]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
[43013.114344]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
[43013.114404]  [<ffffffff8138e6fc>] ret_from_fork+0x7c/0xb0
[43013.114462]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
[43013.114521] ---[ end trace 1ad74354031dadce ]---
[43013.114582] BTRFS critical (device sdd1): unable to find logical 0 len 4096
[43013.114644] BTRFS critical (device sdd1): No mapping for 0-4096
[43013.114644]


-- 
Tomasz Chmielewski
http://wpkg.org
