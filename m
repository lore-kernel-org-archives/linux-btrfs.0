Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33720 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3JUGKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 02:10:44 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 0DE4D340D6A
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 08:10:41 +0200 (CEST)
Received: from localhost (e0109-106-188-60-224.uqwimax.jp [106.188.60.224])
	by mail.virtall.com (Postfix) with ESMTPSA id EF956340D20
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 08:10:39 +0200 (CEST)
Date: Mon, 21 Oct 2013 15:10:32 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131021151032.708cc7d2@virtall.com>
In-Reply-To: <20131021122123.43b3aa50@virtall.com>
References: <20131021122123.43b3aa50@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And yet again on 3.12-rc6.

Note the "BTRFS critical (device sdd1): unable to find logical
7598242613674844160 len 4096" there; after that, the fs freezes and
system won't reboot; has to be power cycled.

[ 9138.478015] ------------[ cut here ]------------
[ 9138.478039] WARNING: CPU: 4 PID: 22882 at fs/btrfs/ctree.c:1322 btrfs_search_old_slot+0x338/0x81d [btrfs]()
[ 9138.478053] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr ehci_pci i2c_i801 button video ehci_hcd i2c_core lpc_ich mfd_core acpi_cpufreq freq_table ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[ 9138.478147] CPU: 4 PID: 22882 Comm: btrfs-endio-wri Not tainted 3.12.0-rc6 #1
[ 9138.478158] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 9138.478171]  0000000000000009 ffff880279dc38d8 ffffffff8138145b 0000000000000006
[ 9138.478266]  0000000000000000 ffff880279dc3918 ffffffff810366a9 00000062953b9000
[ 9138.478362]  ffffffffa0240e23 ffff8807ee2ebab0 ffff880433255800 ffff88067ed69e00
[ 9138.478454] Call Trace:
[ 9138.478503]  [<ffffffff8138145b>] dump_stack+0x46/0x58
[ 9138.478554]  [<ffffffff810366a9>] warn_slowpath_common+0x77/0x91
[ 9138.478613]  [<ffffffffa0240e23>] ? btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 9138.478665]  [<ffffffff810366d8>] warn_slowpath_null+0x15/0x17
[ 9138.478728]  [<ffffffffa0240e23>] btrfs_search_old_slot+0x338/0x81d [btrfs]
[ 9138.478786]  [<ffffffffa02a46e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[ 9138.478848]  [<ffffffffa0275df3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[ 9138.478908]  [<ffffffffa02a50dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[ 9138.478962]  [<ffffffffa02a540b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[ 9138.479018]  [<ffffffffa02a6300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[ 9138.479072]  [<ffffffffa02a8562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[ 9138.479170]  [<ffffffffa0248805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[ 9138.479272]  [<ffffffffa025c475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[ 9138.479329]  [<ffffffffa0249ccd>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
[ 9138.479388]  [<ffffffffa025c70c>] btrfs_end_transaction+0xb/0xd [btrfs]
[ 9138.479445]  [<ffffffffa0266066>] btrfs_finish_ordered_io+0x6c4/0x8e4 [btrfs]
[ 9138.479499]  [<ffffffff8103ee15>] ? del_timer_sync+0x2c/0x4b
[ 9138.479549]  [<ffffffff8103e6ed>] ? usleep_range+0x3d/0x3d
[ 9138.479601]  [<ffffffffa0266296>] finish_ordered_fn+0x10/0x12 [btrfs]
[ 9138.479658]  [<ffffffffa0281322>] worker_loop+0x15e/0x494 [btrfs]
[ 9138.479711]  [<ffffffffa02811c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[ 9138.479760]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[ 9138.479809]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 9138.479858]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[ 9138.479905]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 9138.479954] ---[ end trace 963bf814d16095aa ]---
[ 9138.480011] BTRFS critical (device sdd1): unable to find logical 7598242613674844160 len 4096
[ 9138.480105] ------------[ cut here ]------------
[ 9138.480150] kernel BUG at fs/btrfs/inode.c:1595!
[ 9138.480197] invalid opcode: 0000 [#1] SMP 
[ 9138.480243] Modules linked in: veth ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr ehci_pci i2c_i801 button video ehci_hcd i2c_core lpc_ich mfd_core acpi_cpufreq freq_table ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
[ 9138.480557] CPU: 4 PID: 22882 Comm: btrfs-endio-wri Tainted: G        W    3.12.0-rc6 #1
[ 9138.480645] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 9138.480736] task: ffff8807eacf5c80 ti: ffff880279dc2000 task.ti: ffff880279dc2000
[ 9138.480824] RIP: 0010:[<ffffffffa025f325>]  [<ffffffffa025f325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[ 9138.480920] RSP: 0018:ffff880279dc3548  EFLAGS: 00010282
[ 9138.480966] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000046
[ 9138.481015] RDX: 0000000000000006 RSI: 0000000000000046 RDI: ffff88081fb0d080
[ 9138.481063] RBP: ffff880279dc3568 R08: 0000000000000000 R09: 0000000000000000
[ 9138.481112] R10: 0000000000000000 R11: ffff8807ff420000 R12: 0000000000001000
[ 9138.481160] R13: ffff8801e3435aa8 R14: 0034b930b330a998 R15: ffff8807ee090448
[ 9138.481209] FS:  0000000000000000(0000) GS:ffff88081fb00000(0000) knlGS:0000000000000000
[ 9138.481299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 9138.481348] CR2: 00000000015d0ff0 CR3: 000000000160b000 CR4: 00000000001407e0
[ 9138.481398] Stack:
[ 9138.481442]  0000000000000004 0000000000001000 0000000000001000 ffff880279dc37b8
[ 9138.481535]  ffff880279dc35c8 ffffffffa0273752 ffff880279dc35c8 0000000000000000
[ 9138.481629]  ffffea0013434ec0 0000002000000000 ffff880279dc3618 6972616661533000
[ 9138.481722] Call Trace:
[ 9138.481772]  [<ffffffffa0273752>] submit_extent_page.isra.40+0xea/0x17e [btrfs]
[ 9138.481866]  [<ffffffffa027474c>] __do_readpage+0x4cc/0x56d [btrfs]
[ 9138.481919]  [<ffffffffa0273a03>] ? repair_io_failure+0x1dc/0x1dc [btrfs]
[ 9138.481972]  [<ffffffffa0254ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 9138.482027]  [<ffffffffa0270832>] ? btrfs_lookup_ordered_extent+0x5d/0xb3 [btrfs]
[ 9138.482130]  [<ffffffffa02748a2>] __extent_read_full_page+0xb5/0xc4 [btrfs]
[ 9138.482184]  [<ffffffffa0254ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 9138.482241]  [<ffffffffa02769ba>] read_extent_buffer_pages+0x208/0x222 [btrfs]
[ 9138.482340]  [<ffffffffa0254ac8>] ? verify_parent_transid+0x146/0x146 [btrfs]
[ 9138.482397]  [<ffffffffa02562bd>] btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
[ 9138.482498]  [<ffffffffa0257789>] read_tree_block+0x2c/0x45 [btrfs]
[ 9138.482554]  [<ffffffffa023e868>] read_block_for_search.isra.44+0x2b4/0x2fb [btrfs]
[ 9138.482647]  [<ffffffff810366b8>] ? warn_slowpath_common+0x86/0x91
[ 9138.482703]  [<ffffffffa0240fb3>] btrfs_search_old_slot+0x4c8/0x81d [btrfs]
[ 9138.482763]  [<ffffffffa02a46e8>] __resolve_indirect_refs+0x10f/0x481 [btrfs]
[ 9138.482822]  [<ffffffffa0275df3>] ? free_extent_buffer+0x77/0x7c [btrfs]
[ 9138.482881]  [<ffffffffa02a50dd>] find_parent_nodes+0x33b/0x5d6 [btrfs]
[ 9138.482939]  [<ffffffffa02a540b>] btrfs_find_all_roots+0x7c/0xd7 [btrfs]
[ 9138.482996]  [<ffffffffa02a6300>] ? ulist_add_merge+0x7e/0x14e [btrfs]
[ 9138.483050]  [<ffffffffa02a8562>] btrfs_qgroup_account_ref+0x109/0x40d [btrfs]
[ 9138.483144]  [<ffffffffa0248805>] btrfs_delayed_refs_qgroup_accounting+0xac/0xe0 [btrfs]
[ 9138.483239]  [<ffffffffa025c475>] __btrfs_end_transaction+0x51/0x2bd [btrfs]
[ 9138.483292]  [<ffffffffa0249ccd>] ? btrfs_block_rsv_release+0x49/0x4b [btrfs]
[ 9138.483346]  [<ffffffffa025c70c>] btrfs_end_transaction+0xb/0xd [btrfs]
[ 9138.483400]  [<ffffffffa0266066>] btrfs_finish_ordered_io+0x6c4/0x8e4 [btrfs]
[ 9138.483451]  [<ffffffff8103ee15>] ? del_timer_sync+0x2c/0x4b
[ 9138.483499]  [<ffffffff8103e6ed>] ? usleep_range+0x3d/0x3d
[ 9138.483551]  [<ffffffffa0266296>] finish_ordered_fn+0x10/0x12 [btrfs]
[ 9138.483605]  [<ffffffffa0281322>] worker_loop+0x15e/0x494 [btrfs]
[ 9138.483659]  [<ffffffffa02811c4>] ? btrfs_queue_worker+0x26d/0x26d [btrfs]
[ 9138.483708]  [<ffffffff8104e6be>] kthread+0xb5/0xbd
[ 9138.483756]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 9138.483807]  [<ffffffff813861fc>] ret_from_fork+0x7c/0xb0
[ 9138.483857]  [<ffffffff8104e609>] ? kthread_freezable_should_stop+0x43/0x43
[ 9138.483908] Code: 8b 58 30 41 89 fa 48 8b b9 e8 01 00 00 48 8d 4d e8 48 c1 e2 09 45 31 c9 45 31 c0 44 89 d6 48 89 5d e8 e8 1a e1 01 00 85 c0 79 02 <0f> 0b 31 c0 4c 01 e3 48 39 5d e8 0f 92 c0 5a 59 5b 41 5c 5d c3
[ 9138.484085] RIP  [<ffffffffa025f325>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[ 9138.484140]  RSP <ffff880279dc3548>
[ 9138.484457] ---[ end trace 963bf814d16095ab ]---


-- 
Tomasz Chmielewski
http://wpkg.org
