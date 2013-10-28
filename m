Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:38050 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab3J1KJw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 06:09:52 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id B7BB135A984
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 11:09:49 +0100 (CET)
Received: from localhost (e0109-106-188-70-246.uqwimax.jp [106.188.70.246])
	by mail.virtall.com (Postfix) with ESMTPSA id A8F5135A97C
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 11:09:48 +0100 (CET)
Date: Mon, 28 Oct 2013 19:09:40 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/inode.c:1595!
Message-ID: <20131028190940.224d375a@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I seem to be hitting this only when creating snapshots (in addition to
other fs activity, like adding, removing, modifying multiple files at
different speeds at once, running "sync" etc.).

Before kernel "BUG at fs/btrfs/inode.c:1595!" was reported, I could also see the following:

BTRFS critical (device sdb5): unable to find logical 8091413542285438976 len 4096

btrfs bad fsid on block 0


The filesystem shows no more activity after that ("hangs").

"reboot" won't reboot the server (would be waiting for hanged processes accessing the fs), I have to echo b to sysrq-trigger to "recover".

This is with 3.12.0-rc7.

The fs passes scrub without showing any errors; memtest passes memory test.


Here is a full trace, the fs lasted just 2 h after the last similar hang:

[ 7921.918722] ------------[ cut here ]------------
[ 7921.918781] WARNING: CPU: 3 PID: 11764 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[ 7921.918872] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop button i2c_i801 video pcspkr acpi_cpufreq freq_table i2c_core ehci_pci ehci_hcd lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7921.920316] CPU: 3 PID: 11764 Comm: btrfs-endio-wri Not tainted 3.12.0-rc7 #1
[ 7921.920365] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7921.920455]  0000000000000009 ffff8805018877e8 ffffffff8138176b 0000000000000006
[ 7921.920545]  0000000000000000 ffff880501887828 ffffffff810366a9 0000020d25bf8000
[ 7921.920635]  ffffffffa023ae23 ffff8807f0010090 ffff880036e08800 ffff8802c9f09e00
[ 7921.920725] Call Trace:
[ 7921.920773]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[ 7921.920821]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[ 7921.920873]  [<ffffffffa023ae23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 7921.920923]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[ 7921.920973]  [<ffffffffa023ae23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 7921.921029]  [<ffffffffa029e6e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[ 7921.921085]  [<ffffffffa026fdf3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[ 7921.921139]  [<ffffffffa029f0dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[ 7921.921193]  [<ffffffffa029f40b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[ 7921.921246]  [<ffffffffa02a0300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[ 7921.921300]  [<ffffffffa02a2562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[ 7921.921391]  [<ffffffffa0242805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[ 7921.921485]  [<ffffffffa0256475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[ 7921.921539]  [<ffffffffa025670c>] btrfs_end_transaction+0xb/0xd [btrfs]
[ 7921.921593]  [<ffffffffa025f95d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[ 7921.921646]  [<ffffffffa0260185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[ 7921.921700]  [<ffffffffa0260296>] finish_ordered_fn+0x10/0x12 [btrfs]
[ 7921.921754]  [<ffffffffa027b322>] worker_loop+0x15e/0x494 [btrfs]
[ 7921.921806]  [<ffffffffa027b1c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[ 7921.921856]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[ 7921.921903]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7921.921952]  [<ffffffff813864fc>] ret_from_fork+0x7c/0xb0
[ 7921.922000]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7921.922057] ---[ end trace c54471a3030c30db ]---
[ 7922.511022] btrfs bad fsid on block 0
[ 7922.511117] ------------[ cut here ]------------
[ 7922.511173] WARNING: CPU: 1 PID: 11764 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[ 7922.511264] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop button i2c_i801 video pcspkr acpi_cpufreq freq_table i2c_core ehci_pci ehci_hcd lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7922.511576] CPU: 1 PID: 11764 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc7 #1
[ 7922.511665] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7922.511788]  0000000000000009 ffff8805018877e8 ffffffff8138176b 0000000000000006
[ 7922.511895]  0000000000000000 ffff880501887828 ffffffff810366a9 0000020d25bf8000
[ 7922.511984]  ffffffffa023ae23 ffff8807f0010090 ffff880036e08800 ffff8802c9f09e00
[ 7922.512073] Call Trace:
[ 7922.512119]  [<ffffffff8138176b>] dump_stack+0x46/0x58
[ 7922.512168]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[ 7922.512218]  [<ffffffffa023ae23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 7922.512268]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[ 7922.512320]  [<ffffffffa023ae23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 7922.512378]  [<ffffffffa029e6e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[ 7922.512435]  [<ffffffffa026fdf3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[ 7922.512489]  [<ffffffffa029f0dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[ 7922.512545]  [<ffffffffa029f40b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[ 7922.512598]  [<ffffffffa02a0300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[ 7922.512653]  [<ffffffffa02a2562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[ 7922.512748]  [<ffffffffa0242805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[ 7922.512842]  [<ffffffffa0256475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[ 7922.512895]  [<ffffffffa025670c>] btrfs_end_transaction+0xb/0xd [btrfs]
[ 7922.512948]  [<ffffffffa025f95d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[ 7922.513001]  [<ffffffffa0260185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[ 7922.513053]  [<ffffffffa0260296>] finish_ordered_fn+0x10/0x12 [btrfs]
[ 7922.513106]  [<ffffffffa027b322>] worker_loop+0x15e/0x494 [btrfs]
[ 7922.513161]  [<ffffffffa027b1c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[ 7922.513211]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[ 7922.513260]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7922.513311]  [<ffffffff813864fc>] ret_from_fork+0x7c/0xb0
[ 7922.513359]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7922.513409] ---[ end trace c54471a3030c30dc ]---
[ 7922.513464] BTRFS critical (device sdb5): unable to find logical 8091413542285438976 len 4096
[ 7922.513561] ------------[ cut here ]------------
[ 7922.513606] kernel BUG at fs/btrfs/inode.c:1595!
[ 7922.513653] invalid opcode: 0000 [#1] SMP 
[ 7922.513700] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop button i2c_i801 video pcspkr acpi_cpufreq freq_table i2c_core ehci_pci ehci_hcd lpc_ich mfd_core ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7922.514016] CPU: 1 PID: 11764 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc7 #1
[ 7922.514107] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7922.514199] task: ffff8807d3381720 ti: ffff880501886000 task.ti: ffff880501886000
[ 7922.514289] RIP: 0010:[<ffffffffa0259325>]  [<ffffffffa0259325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[ 7922.514387] RSP: 0018:ffff880501887458  EFLAGS: 00010282
[ 7922.514436] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000046
[ 7922.514484] RDX: 0000000000000006 RSI: 0000000000000046 RDI: ffff88081fa4d080
[ 7922.514534] RBP: ffff880501887478 R08: 0000000000000000 R09: 0000000000000000
[ 7922.514583] R10: 0000000000000000 R11: ffff8807ff420000 R12: 0000000000001000
[ 7922.514631] R13: ffff8802365f8068 R14: 0038253cdf8f5ac0 R15: ffff8807ff150040
[ 7922.514682] FS:  0000000000000000(0000) GS:ffff88081fa40000(0000) knlGS:0000000000000000
[ 7922.514770] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7922.514819] CR2: 00007f635fdec000 CR3: 000000000160b000 CR4: 00000000001407e0
[ 7922.514867] Stack:
[ 7922.514909]  0000000000000004 0000000000001000 0000000000001000 ffff8805018876c8
[ 7922.514998]  ffff8805018874d8 ffffffffa026d752 ffff8805018874d8 0000000000000000
[ 7922.515092]  ffffea0008500880 0000002000000000 ffff880501887528 704a79bf1eb58000
[ 7922.515184] Call Trace:
[ 7922.515235]  [<ffffffffa026d752>] submit_extent_page.isra.40+0xea/0x17e [btrfs]
[ 7922.515330]  [<ffffffffa026e74c>] __do_readpage+0x4cc/0x56d [btrfs]
[ 7922.515384]  [<ffffffffa026da03>] ? repair_io_failure+0x1dc/0x1dc [btrfs]
[ 7922.515438]  [<ffffffffa024eac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 7922.515493]  [<ffffffffa026a832>] ? btrfs_lookup_ordered_extent+0x5d/0xb3 [btrfs]
[ 7922.515591]  [<ffffffffa026e8a2>] __extent_read_full_page+0xb5/0xc4 [btrfs]
[ 7922.515643]  [<ffffffffa024eac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 7922.515697]  [<ffffffffa02709ba>] read_extent_buffer_pages+0x208/0x222 [btrfs]
[ 7922.515791]  [<ffffffffa024eac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 7922.515846]  [<ffffffffa02502bd>] btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
[ 7922.515943]  [<ffffffffa0251789>] read_tree_block+0x2c/0x45 [btrfs]
[ 7922.515994]  [<ffffffffa0238868>] read_block_for_search.isra.44+0x2b4/0x2fb [btrfs]
[ 7922.516083]  [<ffffffff810366b8>] ? warn_slowpath_common+0x86/0x91
[ 7922.516136]  [<ffffffffa023afb3>] btrfs_search_old_slot+0x4c8/0x81d [btrfs]
[ 7922.516192]  [<ffffffffa029e6e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[ 7922.516246]  [<ffffffffa026fdf3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[ 7922.516299]  [<ffffffffa029f0dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[ 7922.516355]  [<ffffffffa029f40b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[ 7922.516410]  [<ffffffffa02a0300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[ 7922.516462]  [<ffffffffa02a2562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[ 7922.516556]  [<ffffffffa0242805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[ 7922.516654]  [<ffffffffa0256475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[ 7922.516707]  [<ffffffffa025670c>] btrfs_end_transaction+0xb/0xd [btrfs]
[ 7922.516762]  [<ffffffffa025f95d>] relink_extent_backref+0x68a/0x6cf [btrfs]
[ 7922.516817]  [<ffffffffa0260185>] btrfs_finish_ordered_io+0x7e3/0x8e4 [btrfs]
[ 7922.516872]  [<ffffffffa0260296>] finish_ordered_fn+0x10/0x12 [btrfs]
[ 7922.516925]  [<ffffffffa027b322>] worker_loop+0x15e/0x494 [btrfs]
[ 7922.516980]  [<ffffffffa027b1c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[ 7922.517031]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[ 7922.517077]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7922.517129]  [<ffffffff813864fc>] ret_from_fork+0x7c/0xb0
[ 7922.517179]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 7922.517230] Code: 8b 58 30 41 89 fa 48 8b b9 e8 01 00 00 48 8d 4d e8 48 c1 e2 09 45 31 c9 45 31 c0 44 89 d6 48 89 5d e8 e8 1a e1 01 00 85 c0 79 02 <0f> 0b 31 c0 4c 01 e3 48 39 5d e8 0f 92 c0 5a 59 5b 41 5c 5d c3
[ 7922.517417] RIP  [<ffffffffa0259325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[ 7922.517471]  RSP <ffff880501887458>
[ 7922.517794] ---[ end trace c54471a3030c30dd ]---


-- 
Tomasz Chmielewski
http://wpkg.org

