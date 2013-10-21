Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:58921 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3JUDVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 23:21:36 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id ED8F7355985
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 05:21:32 +0200 (CEST)
Received: from localhost (e0109-106-188-60-224.uqwimax.jp [106.188.60.224])
	by mail.virtall.com (Postfix) with ESMTPSA id E0B7334DAF1
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 05:21:31 +0200 (CEST)
Date: Mon, 21 Oct 2013 12:21:23 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131021122123.43b3aa50@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this with Linux 3.12-rc5:

[67893.388276] ------------[ cut here ]------------
[67893.388335] WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[67893.388437] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd pcspkr lpc_ich mfd_core i2c_i801 acpi_cpufreq freq_table i2c_core video button ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[67893.388749] CPU: 2 PID: 1543 Comm: btrfs-endio-wri Not tainted 3.12.0-rc5 #1
[67893.388798] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[67893.388887]  0000000000000009 ffff88054a2fb898 ffffffff8138190b 0000000000000006
[67893.388976]  0000000000000000 ffff88054a2fb8d8 ffffffff810366a9 000002527354d000
[67893.389065]  ffffffffa027ce23 ffff8807ff3ddd80 ffff8803fd093800 ffff8802289b0140
[67893.389154] Call Trace:
[67893.389200]  [<ffffffff8138190b>] dump_stack+0x46/0x58
[67893.389248]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[67893.389300]  [<ffffffffa027ce23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[67893.389349]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[67893.389408]  [<ffffffffa027ce23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[67893.389464]  [<ffffffffa02b1d01>] ? alloc_extent_buffer+0x2e4/0x30f [btrfs]
[67893.389519]  [<ffffffffa02e06e0>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[67893.389574]  [<ffffffffa02ad8f3>] ? release_extent_buffer+0x7d/0x8f [btrfs]
[67893.389628]  [<ffffffffa02e0b44>] ? __add_missing_keys.isra.16+0xf2/0x10d [btrfs]
[67893.389721]  [<ffffffffa02e10d5>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[67893.389774]  [<ffffffffa02e1403>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[67893.389828]  [<ffffffffa02e1bbf>] iterate_extent_inodes+0x105/0x1d6 [btrfs]
[67893.389881]  [<ffffffffa0299aa3>] ? record_extent_backrefs+0xc1/0xc1 [btrfs]
[67893.389935]  [<ffffffffa0299aa3>] ? record_extent_backrefs+0xc1/0xc1 [btrfs]
[67893.389989]  [<ffffffffa02e1d0f>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[67893.390081]  [<ffffffffa0299a3d>] record_extent_backrefs+0x5b/0xc1 [btrfs]
[67893.390134]  [<ffffffffa02a213d>] btrfs_finish_ordered_io+0x79b/0x8e4 [btrfs]
[67893.390188]  [<ffffffffa02a2296>] finish_ordered_fn+0x10/0x12 [btrfs]
[67893.390241]  [<ffffffffa02bd31a>] worker_loop+0x15e/0x494 [btrfs]
[67893.390294]  [<ffffffffa02bd1bc>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[67893.390343]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[67893.390390]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[67893.390439]  [<ffffffff813866bc>] ret_from_fork+0x7c/0xb0
[67893.390486]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[67893.390534] ---[ end trace 2b74aa1647d2ae0b ]---
[67893.390592] BTRFS critical (device sdb5): unable to find logical 69225652694147072 len 4096
[67893.390686] ------------[ cut here ]------------
[67893.390731] kernel BUG at fs/btrfs/inode.c:1595!
[67893.390788] invalid opcode: 0000 [#1] SMP 
[67893.391952] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd pcspkr lpc_ich mfd_core i2c_i801 acpi_cpufreq freq_table i2c_core video button ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[67893.392262] CPU: 2 PID: 1543 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc5 #1
[67893.392351] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[67893.392440] task: ffff8807eb66c530 ti: ffff88054a2fa000 task.ti: ffff88054a2fa000
[67893.392527] RIP: 0010:[<ffffffffa029b325>]  [<ffffffffa029b325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[67893.392624] RSP: 0018:ffff88054a2fb508  EFLAGS: 00010282
[67893.392670] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000046
[67893.392727] RDX: 0000000000000006 RSI: 0000000000000046 RDI: ffff88081fa8d080
[67893.392783] RBP: ffff88054a2fb528 R08: 0000000000000000 R09: 0000000000000000
[67893.392850] R10: 0000000000000000 R11: ffff8807ff420000 R12: 0000000000001000
[67893.392907] R13: ffff880480ecae28 R14: 00007af82ea316f8 R15: ffff8807ff1e0040
[67893.392955] FS:  0000000000000000(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
[67893.393043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[67893.393089] CR2: 00007fc7b8e8f000 CR3: 000000000160b000 CR4: 00000000001407e0
[67893.393137] Stack:
[67893.393179]  0000000000000004 0000000000001000 0000000000001000 ffff88054a2fb778
[67893.393268]  ffff88054a2fb588 ffffffffa02af74a ffff88054a2fb588 0000000000000000
[67893.393357]  ffffea0002aa7ec0 0000002000000000 ffff88054a2fb5d8 00f5f05d462df000
[67893.393446] Call Trace:
[67893.393495]  [<ffffffffa02af74a>] submit_extent_page.isra.40+0xea/0x17e [btrfs]
[67893.393587]  [<ffffffffa02b0744>] __do_readpage+0x4cc/0x56d [btrfs]
[67893.393639]  [<ffffffffa02af9fb>] ? repair_io_failure+0x1dc/0x1dc [btrfs]
[67893.393692]  [<ffffffffa0290ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[67893.393746]  [<ffffffffa02ac82a>] ? btrfs_lookup_ordered_extent+0x5d/0xb3 [btrfs]
[67893.393838]  [<ffffffffa02b089a>] __extent_read_full_page+0xb5/0xc4 [btrfs]
[67893.393891]  [<ffffffffa0290ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[67893.393945]  [<ffffffffa02b29b2>] read_extent_buffer_pages+0x208/0x222 [btrfs]
[67893.394033]  [<ffffffff8104ed3e>] ? __wake_up_bit+0x2c/0x2e
[67893.394084]  [<ffffffffa0290ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[67893.394136]  [<ffffffffa02922bd>] btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
[67893.394230]  [<ffffffffa0293789>] read_tree_block+0x2c/0x45 [btrfs]
[67893.394280]  [<ffffffffa027a868>] read_block_for_search.isra.44+0x2b4/0x2fb [btrfs]
[67893.394369]  [<ffffffff810366b8>] ? warn_slowpath_common+0x86/0x91
[67893.394419]  [<ffffffffa027cfb3>] btrfs_search_old_slot+0x4c8/0x81d [btrfs]
[67893.394478]  [<ffffffffa02b1d01>] ? alloc_extent_buffer+0x2e4/0x30f [btrfs]
[67893.394532]  [<ffffffffa02e06e0>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[67893.394586]  [<ffffffffa02ad8f3>] ? release_extent_buffer+0x7d/0x8f [btrfs]
[67893.394639]  [<ffffffffa02e0b44>] ? __add_missing_keys.isra.16+0xf2/0x10d [btrfs]
[67893.394732]  [<ffffffffa02e10d5>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[67893.394784]  [<ffffffffa02e1403>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[67893.394837]  [<ffffffffa02e1bbf>] iterate_extent_inodes+0x105/0x1d6 [btrfs]
[67893.394890]  [<ffffffffa0299aa3>] ? record_extent_backrefs+0xc1/0xc1 [btrfs]
[67893.394943]  [<ffffffffa0299aa3>] ? record_extent_backrefs+0xc1/0xc1 [btrfs]
[67893.394996]  [<ffffffffa02e1d0f>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[67893.395088]  [<ffffffffa0299a3d>] record_extent_backrefs+0x5b/0xc1 [btrfs]
[67893.395144]  [<ffffffffa02a213d>] btrfs_finish_ordered_io+0x79b/0x8e4 [btrfs]
[67893.395198]  [<ffffffffa02a2296>] finish_ordered_fn+0x10/0x12 [btrfs]
[67893.395250]  [<ffffffffa02bd31a>] worker_loop+0x15e/0x494 [btrfs]
[67893.395303]  [<ffffffffa02bd1bc>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[67893.395354]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[67893.395402]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[67893.395451]  [<ffffffff813866bc>] ret_from_fork+0x7c/0xb0
[67893.395498]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[67893.395546] Code: 8b 58 30 41 89 fa 48 8b b9 e8 01 00 00 48 8d 4d e8 48 c1 e2 09 45 31 c9 45 31 c0 44 89 d6 48 89 5d e8 e8 12 e1 01 00 85 c0 79 02 <0f> 0b 31 c0 4c 01 e3 48 39 5d e8 0f 92 c0 5a 59 5b 41 5c 5d c3
[67893.395718] RIP  [<ffffffffa029b325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[67893.395771]  RSP <ffff88054a2fb508>
[67893.396087] ---[ end trace 2b74aa1647d2ae0c ]---



-- 
Tomasz Chmielewski
http://wpkg.org
