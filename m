Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:52766 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3JZCE1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 22:04:27 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 4C3AD35464F
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 04:04:23 +0200 (CEST)
Received: from localhost (e0109-106-188-126-3.uqwimax.jp [106.188.126.3])
	by mail.virtall.com (Postfix) with ESMTPSA id 32228354635
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 04:04:21 +0200 (CEST)
Date: Sat, 26 Oct 2013 11:04:14 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS critical: unable to find logical, No mapping for
Message-ID: <20131026110414.1c8a5873@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just saw this with 3.12-rc6:

[57459.603773] ------------[ cut here ]------------
[57459.603798] WARNING: CPU: 6 PID: 30148 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[57459.603812] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop video button pcspkr acpi_cpufreq ehci_pci ehci_hcd freq_table lpc_ich mfd_core i2c_i801 i2c_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[57459.604256] CPU: 6 PID: 30148 Comm: btrfs-endio-wri Not tainted 3.12.0-rc6 #1
[57459.604320] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[57459.604436]  0000000000000009 ffff88059890f7e8 ffffffff8138145b 0000000000000006
[57459.604557]  0000000000000000 ffff88059890f828 ffffffff810366a9 0000021b31eb7000
[57459.604673]  ffffffffa0270e23 ffff8807ec16e750 ffff8807ed73d000 ffff8804caac2780
[57459.604796] Call Trace:
[57459.604861]  [<ffffffff8138145b>] dump_stack+0x46/0x58
[57459.604928]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[57459.605002]  [<ffffffffa0270e23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[57459.605071]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[57459.605143]  [<ffffffffa0270e23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[57459.605229]  [<ffffffffa02a5d01>] ? alloc_extent_buffer+0x2dc/0x30f [btrfs]
[57459.605311]  [<ffffffffa02d46e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[57459.605391]  [<ffffffffa02a5df3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[57459.605474]  [<ffffffffa02d50dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[57459.605553]  [<ffffffffa02d540b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[57459.605632]  [<ffffffffa02d6300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[57459.605710]  [<ffffffffa02d8562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[57459.605838]  [<ffffffffa0278805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[57459.605971]  [<ffffffffa028c475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[57459.606049]  [<ffffffffa028c70c>] btrfs_end_transaction+0xb/0xd [btrfs]
[57459.606128]  [<ffffffffa029595d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[57459.606208]  [<ffffffffa0296185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[57459.606285]  [<ffffffffa0296296>] finish_ordered_fn+0x10/0x12 [btrfs]
[57459.606365]  [<ffffffffa02b1322>] worker_loop+0x15e/0x494 [btrfs]
[57459.606443]  [<ffffffffa02b11c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[57459.606512]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[57459.606576]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[57459.606643]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[57459.606707]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[57459.606772] ---[ end trace acb45ba9d3ec7864 ]---
[57459.606846] BTRFS critical (device sdb5): unable to find logical 478201511936 len 4096
[57459.606968] BTRFS critical (device sdb5): No mapping for 478201511936-478201516032
[57459.606968]
[57459.607145] ------------[ cut here ]------------
[57459.607212] WARNING: CPU: 6 PID: 30148 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[57459.607329] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop video button pcspkr acpi_cpufreq ehci_pci ehci_hcd freq_table lpc_ich mfd_core i2c_i801 i2c_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 mii scsi_mod
[57459.607751] CPU: 6 PID: 30148 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc6 #1
[57459.607866] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[57459.607982]  0000000000000009 ffff88059890f7e8 ffffffff8138145b 0000000000000006
[57459.608099]  0000000000000000 ffff88059890f828 ffffffff810366a9 0000021b31eb7000
[57459.608218]  ffffffffa0270e23 ffff8807ec16e750 ffff8807ed73d000 ffff8804caac2780
[57459.608334] Call Trace:
[57459.608393]  [<ffffffff8138145b>] dump_stack+0x46/0x58
[57459.608457]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[57459.608527]  [<ffffffffa0270e23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[57459.608594]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[57459.608664]  [<ffffffffa0270e23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[57459.608743]  [<ffffffffa02a5d01>] ? alloc_extent_buffer+0x2dc/0x30f [btrfs]
[57459.608821]  [<ffffffffa02d46e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[57459.608899]  [<ffffffffa02a5df3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[57459.608975]  [<ffffffffa02d50dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[57459.609052]  [<ffffffffa02d540b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[57459.609128]  [<ffffffffa02d6300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[57459.609203]  [<ffffffffa02d8562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[57459.609327]  [<ffffffffa0278805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[57459.609456]  [<ffffffffa028c475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[57459.609530]  [<ffffffffa028c70c>] btrfs_end_transaction+0xb/0xd [btrfs]
[57459.609604]  [<ffffffffa029595d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[57459.609679]  [<ffffffffa0296185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[57459.609754]  [<ffffffffa0296296>] finish_ordered_fn+0x10/0x12 [btrfs]
[57459.609829]  [<ffffffffa02b1322>] worker_loop+0x15e/0x494 [btrfs]
[57459.609902]  [<ffffffffa02b11c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[57459.609967]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[57459.610028]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[57459.610092]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[57459.610154]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[57459.610216] ---[ end trace acb45ba9d3ec7865 ]---



-- 
Tomasz Chmielewski
http://wpkg.org
