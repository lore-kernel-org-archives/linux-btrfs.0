Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:39563 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaAMKNQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 05:13:16 -0500
Date: Mon, 13 Jan 2014 11:13:03 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        pfonseca@mpi-sws.org
Subject: Re: kernel BUG at fs/btrfs/inode.c:1593! with 3.13.0-rc7
Message-ID: <20140113111303.0b5417ed@virtall.com>
In-Reply-To: <1389576253.1568.4.camel@localhost.localdomain>
References: <20140112234702.63f4750a@virtall.com>
	<1389576253.1568.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hard to tell, as I only saw it once.

It happened during rsync; there were snapshots created and dropped a few
minutes before.


On Mon, 13 Jan 2014 09:24:13 +0800
Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:

> Hi Tomasz,
> Similar bug has been reported by Pedro Fonseca <pfonseca@mpi-sws.org>
> before, how do you trigger this or what operations are you doing?
> 
> Thanks,
> Gui
> 
> On Sun, 2014-01-12 at 23:47 +0100, Tomasz Chmielewski wrote:
> > Just had this on a btrfs filesystem running 3.13-rc7.
> > 
> > The filesystem was working fine till now and was passing balance and
> > scrub properly without any issues a couple of days ago:
> > 
> > [273059.042280] ------------[ cut here ]------------
> > [273059.042369] WARNING: CPU: 6 PID: 20754 at fs/btrfs/inode.c:4721
> > inode_tree_add+0xc2/0x13f [btrfs]() [273059.042484] Modules linked
> > in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand
> > cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc
> > ipv6 btrfs xor raid6_pq zlib_deflate loop lpc_ich mfd_core i2c_i801
> > i2c_core pcspkr button video ehci_pci ehci_hcd acpi_cpufreq ext4
> > crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata scsi_mod
> > r8169 mii [273059.042901] CPU: 6 PID: 20754 Comm: btrfs-endio-wri
> > Tainted: G        W    3.13.0-rc7 #1 [273059.043014] Hardware name:
> > System manufacturer System Product Name/P8H77-M PRO, BIOS 1101
> > 02/04/2013 [273059.043129]  0000000000000009 ffff8807a7959b18
> > ffffffff81389887 0000000000000006 [273059.043245]  0000000000000000
> > ffff8807a7959b58 ffffffff810370a9 ffff8801b0d21040 [273059.043360]
> > ffffffffa027d623 ffff880637209968 ffff88020a8bde88 ffff880667c1b800
> > [273059.043476] Call Trace: [273059.043536]  [<ffffffff81389887>]
> > dump_stack+0x46/0x58 [273059.043599]  [<ffffffff810370a9>]
> > warn_slowpath_common+0x77/0x91 [273059.043674]
> > [<ffffffffa027d623>] ? inode_tree_add+0xc2/0x13f [btrfs]
> > [273059.043738]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
> > [273059.043810]  [<ffffffffa027d623>] inode_tree_add+0xc2/0x13f
> > [btrfs] [273059.043885]  [<ffffffffa02840cb>]
> > btrfs_iget+0x46c/0x4b6 [btrfs] [273059.043958]
> > [<ffffffffa028421a>] relink_extent_backref+0x105/0x6cf [btrfs]
> > [273059.044032]  [<ffffffffa0284fa1>]
> > btrfs_finish_ordered_io+0x7bd/0x877 [btrfs] [273059.044155]
> > [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12 [btrfs]
> > [273059.044232]  [<ffffffffa02a00d1>] worker_loop+0x15e/0x495
> > [btrfs] [273059.044307]  [<ffffffffa029ff73>] ?
> > btrfs_queue_worker+0x269/0x269 [btrfs] [273059.044372]
> > [<ffffffff8104ee9a>] kthread+0xcd/0xd5 [273059.044434]
> > [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> > [273059.044498]  [<ffffffff8138e6bc>] ret_from_fork+0x7c/0xb0
> > [273059.044560]  [<ffffffff8104edcd>] ?
> > kthread_freezable_should_stop+0x43/0x43 [273059.044624] ---[ end
> > trace 714ee71af93c5bba ]--- [366782.707007] ------------[ cut here
> > ]------------ [366782.707096] WARNING: CPU: 1 PID: 10513 at
> > fs/btrfs/ctree.c:1321 btrfs_search_old_slot+0x322/0x7ea [btrfs]()
> > [366782.707217] Modules linked in: ipt_MASQUERADE iptable_nat
> > nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> > ip_tables x_tables cpufreq_ondemand cpufreq_conservative
> > cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor
> > raid6_pq zlib_deflate loop lpc_ich mfd_core i2c_i801 i2c_core
> > pcspkr button video ehci_pci ehci_hcd acpi_cpufreq ext4 crc16 jbd2
> > mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
> > [366782.707669] CPU: 1 PID: 10513 Comm: btrfs-endio-wri Tainted:
> > G        W    3.13.0-rc7 #1 [366782.707786] Hardware name: System
> > manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> > [366782.707908]  0000000000000009 ffff8803d5779908 ffffffff81389887
> > 0000000000000006 [366782.708031]  0000000000000000 ffff8803d5779948
> > ffffffff810370a9 00000340ae2ac000 [366782.708154]  ffffffffa025fe5a
> > ffff8807eb4bf7e0 ffff8800632e4800 ffff88072a5a4780 [366782.708277]
> > Call Trace: [366782.708339]  [<ffffffff81389887>]
> > dump_stack+0x46/0x58 [366782.708409]  [<ffffffff810370a9>]
> > warn_slowpath_common+0x77/0x91 [366782.708488]
> > [<ffffffffa025fe5a>] ? btrfs_search_old_slot+0x322/0x7ea [btrfs]
> > [366782.708611]  [<ffffffff810370d8>] warn_slowpath_null+0x15/0x17
> > [366782.708688]  [<ffffffffa025fe5a>]
> > btrfs_search_old_slot+0x322/0x7ea [btrfs] [366782.708779]
> > [<ffffffffa0294be1>] ? free_extent_buffer+0x6f/0x7c [btrfs]
> > [366782.708870]  [<ffffffffa02c2b3b>]
> > __resolve_indirect_refs+0x10f/0x48d [btrfs] [366782.709009]
> > [<ffffffffa02c3a26>] find_parent_nodes+0x337/0x5d2 [btrfs]
> > [366782.709099]  [<ffffffffa02c44d4>]
> > iterate_extent_inodes+0xc9/0x1d6 [btrfs] [366782.709185]
> > [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> > [366782.709273]  [<ffffffffa027c9ad>] ?
> > record_extent_backrefs+0xc3/0xc3 [btrfs] [366782.709361]
> > [<ffffffffa02c4660>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
> > [366782.709501]  [<ffffffffa027c945>]
> > record_extent_backrefs+0x5b/0xc3 [btrfs] [366782.709588]
> > [<ffffffffa0284f5e>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
> > [366782.709729]  [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12
> > [btrfs] [366782.709814]  [<ffffffffa02a00d1>]
> > worker_loop+0x15e/0x495 [btrfs] [366782.709902]
> > [<ffffffffa029ff73>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> > [366782.709976]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> > [366782.710043]  [<ffffffff8104edcd>] ?
> > kthread_freezable_should_stop+0x43/0x43 [366782.710113]
> > [<ffffffff8138e6bc>] ret_from_fork+0x7c/0xb0 [366782.710182]
> > [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> > [366782.710249] ---[ end trace 714ee71af93c5bbb ]---
> > [366782.710335] BTRFS critical (device sdd1): unable to find
> > logical 7014136843253448704 len 4096 [366782.710471]
> > ------------[ cut here ]------------ [366782.711962] kernel BUG at
> > fs/btrfs/inode.c:1593! [366782.712033] invalid opcode: 0000 [#1]
> > SMP [366782.712100] Modules linked in: ipt_MASQUERADE iptable_nat
> > nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> > ip_tables x_tables cpufreq_ondemand cpufreq_conservative
> > cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor
> > raid6_pq zlib_deflate loop lpc_ich mfd_core i2c_i801 i2c_core
> > pcspkr button video ehci_pci ehci_hcd acpi_cpufreq ext4 crc16 jbd2
> > mbcache raid1 sg sd_mod ahci libahci libata scsi_mod r8169 mii
> > [366782.712707] CPU: 1 PID: 10513 Comm: btrfs-endio-wri Tainted:
> > G        W    3.13.0-rc7 #1 [366782.712860] Hardware name: System
> > manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
> > [366782.712998] task: ffff8807f36ddc40 ti: ffff8803d5778000
> > task.ti: ffff8803d5778000 [366782.713157] RIP:
> > 0010:[<ffffffffa027e21c>]  [<ffffffffa027e21c>]
> > btrfs_merge_bio_hook+0x53/0x68 [btrfs] [366782.713310] RSP:
> > 0018:ffff8803d5779588  EFLAGS: 00010282 [366782.713378] RAX:
> > 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000046
> > [366782.713476] RDX: 0000000000000006 RSI: 0000000000000046 RDI:
> > ffff88081fa4d040 [366782.713609] RBP: ffff8803d57795a8 R08:
> > 0000000000000000 R09: 0000000000000000 [366782.713738] R10:
> > 0000000000000000 R11: ffff8807ff420000 R12: 0000000000001000
> > [366782.713877] R13: ffff8806f26882e8 R14: 0030ab9c25f20d08 R15:
> > ffff8807eff10850 [366782.714017] FS:  0000000000000000(0000)
> > GS:ffff88081fa40000(0000) knlGS:0000000000000000 [366782.714170]
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [366782.714240]
> > CR2: 0000000002518000 CR3: 000000000160b000 CR4: 00000000001407e0
> > [366782.714378] Stack: [366782.714442]  0000000000000004
> > 0000000000001000 0000000000001000 ffff8803d57797e8 [366782.714585]
> > ffff8803d5779608 ffffffffa02925f1 ffff8803d5779608 0000000000000000
> > [366782.714720]  ffffea001d4fa680 0000002000000000 ffff8803d5779fd8
> > 6157384be41a1000 [366782.714854] Call Trace: [366782.714928]
> > [<ffffffffa02925f1>] submit_extent_page.isra.39+0xea/0x17e [btrfs]
> > [366782.715074]  [<ffffffffa02935b0>] __do_readpage+0x49f/0x540
> > [btrfs] [366782.715150]  [<ffffffffa0292864>] ?
> > repair_io_failure+0x19e/0x19e [btrfs] [366782.715225]
> > [<ffffffffa0273918>] ? verify_parent_transid+0x146/0x146 [btrfs]
> > [366782.715352]  [<ffffffffa028f5f3>] ?
> > btrfs_lookup_ordered_extent+0x5d/0xb3 [btrfs] [366782.715478]
> > [<ffffffffa0293706>] __extent_read_full_page+0xb5/0xc4 [btrfs]
> > [366782.715553]  [<ffffffffa0273918>] ?
> > verify_parent_transid+0x146/0x146 [btrfs] [366782.715698]
> > [<ffffffffa02957aa>] read_extent_buffer_pages+0x1ff/0x219 [btrfs]
> > [366782.715813]  [<ffffffff811a6b09>] ?
> > radix_tree_insert+0xf3/0x1b7 [366782.715887]
> > [<ffffffffa0273918>] ? verify_parent_transid+0x146/0x146 [btrfs]
> > [366782.716008]  [<ffffffffa0274e83>]
> > btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
> > [366782.716133]  [<ffffffffa0275424>] read_tree_block+0x2c/0x45
> > [btrfs] [366782.716202]  [<ffffffffa025d8a4>]
> > read_block_for_search.isra.42+0x2b4/0x2fb [btrfs] [366782.716316]
> > [<ffffffff810370b8>] ? warn_slowpath_common+0x86/0x91
> > [366782.716385]  [<ffffffffa025ffc5>]
> > btrfs_search_old_slot+0x48d/0x7ea [btrfs] [366782.716461]
> > [<ffffffffa0294be1>] ? free_extent_buffer+0x6f/0x7c [btrfs]
> > [366782.716537]  [<ffffffffa02c2b3b>]
> > __resolve_indirect_refs+0x10f/0x48d [btrfs] [366782.716661]
> > [<ffffffffa02c3a26>] find_parent_nodes+0x337/0x5d2 [btrfs]
> > [366782.716736]  [<ffffffffa02c44d4>]
> > iterate_extent_inodes+0xc9/0x1d6 [btrfs] [366782.716812]
> > [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
> > [366782.716886]  [<ffffffffa027c9ad>] ?
> > record_extent_backrefs+0xc3/0xc3 [btrfs] [366782.716961]
> > [<ffffffffa02c4660>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
> > [366782.717084]  [<ffffffffa027c945>]
> > record_extent_backrefs+0x5b/0xc3 [btrfs] [366782.717159]
> > [<ffffffffa0284f5e>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
> > [366782.717281]  [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12
> > [btrfs] [366782.717356]  [<ffffffffa02a00d1>]
> > worker_loop+0x15e/0x495 [btrfs] [366782.717430]
> > [<ffffffffa029ff73>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
> > [366782.717494]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> > [366782.717555]  [<ffffffff8104edcd>] ?
> > kthread_freezable_should_stop+0x43/0x43 [366782.717619]
> > [<ffffffff8138e6bc>] ret_from_fork+0x7c/0xb0 [366782.717681]
> > [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> > [366782.717743] Code: 8b 58 30 41 89 fa 48 8b b9 e8 01 00 00 48 8d
> > 4d e8 48 c1 e2 09 45 31 c9 45 31 c0 44 89 d6 48 89 5d e8 e8 aa df
> > 01 00 85 c0 79 02 <0f> 0b 31 c0 4c 01 e3 48 39 5d e8 0f 92 c0 5a 59
> > 5b 41 5c 5d c3 [366782.717986] RIP  [<ffffffffa027e21c>]
> > btrfs_merge_bio_hook+0x53/0x68 [btrfs] [366782.718061]  RSP
> > <ffff8803d5779588> [366782.718420] ---[ end trace 714ee71af93c5bbc
> > ]---
> > 
> > 
> 
> 

