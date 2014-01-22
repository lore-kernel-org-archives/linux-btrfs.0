Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48546 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaAVMHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 07:07:22 -0500
Date: Wed, 22 Jan 2014 13:07:16 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/inode.c:1593! with 3.13.0-rc7
Message-ID: <20140122130716.03c8db23@virtall.com>
In-Reply-To: <52D3905E.9090606@cn.fujitsu.com>
References: <20140112234702.63f4750a@virtall.com>
	<52D3905E.9090606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I could still see the bug (below) with 3.13 and tried to apply the patch.

It did apply:

patching file fs/btrfs/ctree.c
Hunk #1 succeeded at 39 with fuzz 2.
Hunk #2 succeeded at 475 (offset 1 line).
Hunk #3 succeeded at 485 (offset 1 line).
Hunk #4 succeeded at 505 (offset 1 line).
Hunk #5 succeeded at 527 (offset 1 line).
Hunk #6 succeeded at 568 (offset 1 line).
Hunk #7 succeeded at 578 (offset 1 line).
Hunk #8 succeeded at 606 (offset 1 line).
Hunk #9 succeeded at 703 (offset 1 line).
Hunk #10 succeeded at 742 (offset 1 line).
Hunk #11 succeeded at 834 (offset 1 line).
Hunk #12 succeeded at 927 (offset 1 line).
Hunk #13 succeeded at 1230 (offset 1 line).
Hunk #14 succeeded at 3216 (offset -42 lines).
Hunk #15 succeeded at 3291 (offset -42 lines).
Hunk #16 succeeded at 3497 (offset -42 lines).


however, the kernel fails to compile:

  LD      fs/btrfs/built-in.o
  CC [M]  fs/btrfs/super.o
  CC [M]  fs/btrfs/ctree.o
fs/btrfs/ctree.c: In function ‘tree_mod_log_set_node_key’:
fs/btrfs/ctree.c:924:2: error: implicit declaration of function ‘__tree_mod_log_insert_key’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [fs/btrfs/ctree.o] Error 1


Is there a patch which works with 3.13?


[130583.552477] ------------[ cut here ]------------
[130583.552596] WARNING: CPU: 0 PID: 9052 at fs/btrfs/ctree.c:1321 btrfs_search_old_slot+0x322/0x7ea [btrfs]()
[130583.552718] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd video button lpc_ich mfd_core i2c_i801 i2c_core pcspkr acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 scsi_mod mii
[130583.553167] CPU: 0 PID: 9052 Comm: btrfs-endio-wri Tainted: G        W    3.13.0 #1
[130583.553287] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[130583.553409]  0000000000000009 ffff880043697908 ffffffff8138998a 0000000000000006
[130583.553533]  0000000000000000 ffff880043697948 ffffffff810370b5 0000044684a45000
[130583.553688]  ffffffffa025fe5a ffff8807ee7b1510 ffff880741080800 ffff8802e3746000
[130583.553816] Call Trace:
[130583.553880]  [<ffffffff8138998a>] dump_stack+0x46/0x58
[130583.553945]  [<ffffffff810370b5>] warn_slowpath_common+0x77/0x91
[130583.554018]  [<ffffffffa025fe5a>] ? btrfs_search_old_slot+0x322/0x7ea [btrfs]
[130583.554134]  [<ffffffff810370e4>] warn_slowpath_null+0x15/0x17
[130583.554205]  [<ffffffffa025fe5a>] btrfs_search_old_slot+0x322/0x7ea [btrfs]
[130583.554286]  [<ffffffffa02c2b3b>] __resolve_indirect_refs+0x10f/0x48d [btrfs]
[130583.554416]  [<ffffffffa02c3a26>] find_parent_nodes+0x337/0x5d2 [btrfs]
[130583.554493]  [<ffffffffa02c44d4>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
[130583.554590]  [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[130583.554687]  [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[130583.554764]  [<ffffffffa02c4660>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[130583.554891]  [<ffffffffa027c945>] record_extent_backrefs+0x5b/0xc3 [btrfs]
[130583.554968]  [<ffffffffa0284f5e>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
[130583.555105]  [<ffffffff810e42f6>] ? kmem_cache_free+0x164/0x17a
[130583.555171]  [<ffffffff810af6db>] ? mempool_free_slab+0x12/0x14
[130583.555245]  [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12 [btrfs]
[130583.555322]  [<ffffffffa02a00d1>] worker_loop+0x15e/0x495 [btrfs]
[130583.555398]  [<ffffffffa029ff73>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[130583.555465]  [<ffffffff8104eea6>] kthread+0xcd/0xd5
[130583.555528]  [<ffffffff8104edd9>] ? kthread_freezable_should_stop+0x43/0x43
[130583.555594]  [<ffffffff8138e7bc>] ret_from_fork+0x7c/0xb0
[130583.555658]  [<ffffffff8104edd9>] ? kthread_freezable_should_stop+0x43/0x43
[130583.555723] ---[ end trace 29066b81af8a4336 ]---
[130583.555802] BTRFS critical (device sdd1): unable to find logical 3472310704041439232 len 4096
[130583.555926] ------------[ cut here ]------------
[130583.555987] kernel BUG at fs/btrfs/inode.c:1593!
[130583.556047] invalid opcode: 0000 [#1] SMP 
[130583.556108] Modules linked in: ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq zlib_deflate loop ehci_pci ehci_hcd video button lpc_ich mfd_core i2c_i801 i2c_core pcspkr acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata r8169 scsi_mod mii
[130583.556524] CPU: 0 PID: 9052 Comm: btrfs-endio-wri Tainted: G        W    3.13.0 #1
[130583.556637] Hardware name: System manufacturer System Product Name/P8H77-M PRO, BIOS 1101 02/04/2013
[130583.556751] task: ffff8806615adc40 ti: ffff880043696000 task.ti: ffff880043696000
[130583.556862] RIP: 0010:[<ffffffffa027e21c>]  [<ffffffffa027e21c>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[130583.556991] RSP: 0018:ffff880043697588  EFLAGS: 00010282
[130583.557051] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000046
[130583.557161] RDX: 0000000000000006 RSI: 0000000000000046 RDI: ffff88081fa0d040
[130583.557272] RBP: ffff8800436975a8 R08: 0000000000000000 R09: 0000000000000000
[130583.557382] R10: 0000000000000000 R11: ffff8807ff420000 R12: 0000000000001000
[130583.557494] R13: ffff8801dd8d4ce8 R14: 00181810181816a0 R15: ffff8807ff148448
[130583.557605] FS:  0000000000000000(0000) GS:ffff88081fa00000(0000) knlGS:0000000000000000
[130583.557718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[130583.557779] CR2: ffffffffff600400 CR3: 000000000160b000 CR4: 00000000001407f0
[130583.557889] Stack:
[130583.557942]  0000000000000004 0000000000001000 0000000000001000 ffff8800436977e8
[130583.558057]  ffff880043697608 ffffffffa02925f1 ffff880043697608 0000000000000000
[130583.558172]  ffffea000d218bc0 0000002000000000 ffff880043697fd8 30302030302d4000
[130583.558288] Call Trace:
[130583.558358]  [<ffffffffa02925f1>] submit_extent_page.isra.39+0xea/0x17e [btrfs]
[130583.558482]  [<ffffffffa02935b0>] __do_readpage+0x49f/0x540 [btrfs]
[130583.558556]  [<ffffffffa0292864>] ? repair_io_failure+0x19e/0x19e [btrfs]
[130583.558630]  [<ffffffffa0273918>] ? verify_parent_transid+0x146/0x146 [btrfs]
[130583.558756]  [<ffffffffa028f5f3>] ? btrfs_lookup_ordered_extent+0x5d/0xb3 [btrfs]
[130583.558879]  [<ffffffffa0293706>] __extent_read_full_page+0xb5/0xc4 [btrfs]
[130583.558953]  [<ffffffffa0273918>] ? verify_parent_transid+0x146/0x146 [btrfs]
[130583.559077]  [<ffffffffa02957aa>] read_extent_buffer_pages+0x1ff/0x219 [btrfs]
[130583.559193]  [<ffffffff811a6bd1>] ? radix_tree_insert+0xf3/0x1b7
[130583.559264]  [<ffffffffa0273918>] ? verify_parent_transid+0x146/0x146 [btrfs]
[130583.559386]  [<ffffffffa0274e83>] btree_read_extent_buffer_pages.constprop.123+0x61/0xf9 [btrfs]
[130583.560907]  [<ffffffffa0275424>] read_tree_block+0x2c/0x45 [btrfs]
[130583.560977]  [<ffffffffa025d8a4>] read_block_for_search.isra.42+0x2b4/0x2fb [btrfs]
[130583.561092]  [<ffffffff810370c4>] ? warn_slowpath_common+0x86/0x91
[130583.561161]  [<ffffffffa025ffc5>] btrfs_search_old_slot+0x48d/0x7ea [btrfs]
[130583.561237]  [<ffffffffa02c2b3b>] __resolve_indirect_refs+0x10f/0x48d [btrfs]
[130583.561361]  [<ffffffffa02c3a26>] find_parent_nodes+0x337/0x5d2 [btrfs]
[130583.561436]  [<ffffffffa02c44d4>] iterate_extent_inodes+0xc9/0x1d6 [btrfs]
[130583.561511]  [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[130583.561584]  [<ffffffffa027c9ad>] ? record_extent_backrefs+0xc3/0xc3 [btrfs]
[130583.561661]  [<ffffffffa02c4660>] iterate_inodes_from_logical+0x7f/0x95 [btrfs]
[130583.561783]  [<ffffffffa027c945>] record_extent_backrefs+0x5b/0xc3 [btrfs]
[130583.561857]  [<ffffffffa0284f5e>] btrfs_finish_ordered_io+0x77a/0x877 [btrfs]
[130583.561970]  [<ffffffff810e42f6>] ? kmem_cache_free+0x164/0x17a
[130583.562032]  [<ffffffff810af6db>] ? mempool_free_slab+0x12/0x14
[130583.562104]  [<ffffffffa028506b>] finish_ordered_fn+0x10/0x12 [btrfs]
[130583.562186]  [<ffffffffa02a00d1>] worker_loop+0x15e/0x495 [btrfs]
[130583.562269]  [<ffffffffa029ff73>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
[130583.562334]  [<ffffffff8104eea6>] kthread+0xcd/0xd5
[130583.562396]  [<ffffffff8104edd9>] ? kthread_freezable_should_stop+0x43/0x43
[130583.562460]  [<ffffffff8138e7bc>] ret_from_fork+0x7c/0xb0
[130583.562522]  [<ffffffff8104edd9>] ? kthread_freezable_should_stop+0x43/0x43
[130583.562584] Code: 8b 58 30 41 89 fa 48 8b b9 e8 01 00 00 48 8d 4d e8 48 c1 e2 09 45 31 c9 45 31 c0 44 89 d6 48 89 5d e8 e8 aa df 01 00 85 c0 79 02 <0f> 0b 31 c0 4c 01 e3 48 39 5d e8 0f 92 c0 5a 59 5b 41 5c 5d c3
[130583.562830] RIP  [<ffffffffa027e21c>] btrfs_merge_bio_hook+0x53/0x68 [btrfs]
[130583.562904]  RSP <ffff880043697588>
[130583.563248] ---[ end trace 29066b81af8a4337 ]---


On Mon, 13 Jan 2014 15:06:06 +0800
Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:

> On 01/13/2014 06:47 AM, Tomasz Chmielewski wrote:
> 
> Hello Tomasz,
> 
> Chris recently sent a patch that addressed a race condition with
> loading inode, i think it might be related to your first dmesg
> warning.
> 
> Chris' patch url can be seen:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30332.html
> 
> Thanks,
> Wang
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
> > ]------------
> >

