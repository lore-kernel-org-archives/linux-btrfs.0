Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:36171 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaJBH1l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 03:27:41 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 6B10D4880FE
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 09:27:38 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.17.0-rc7: kernel BUG at fs/btrfs/relocation.c:931!
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 02 Oct 2014 09:27:38 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this when running balance with 3.17.0-rc7:

(...)
[173394.571080] BTRFS info (device sdd1): relocating block group 
4391666974720 flags 17
[173405.407779] BTRFS info (device sdd1): found 52296 extents
[173441.235837] BTRFS info (device sdd1): found 52296 extents
[173442.266918] BTRFS info (device sdd1): relocating block group 
4390593232896 flags 17
[173451.515002] BTRFS info (device sdd1): found 22314 extents
[173473.761612] BTRFS info (device sdd1): found 22314 extents
[173474.498414] BTRFS info (device sdd1): relocating block group 
4389519491072 flags 20
[173475.410657] ------------[ cut here ]------------
[173475.410717] kernel BUG at fs/btrfs/relocation.c:931!
[173475.410774] invalid opcode: 0000 [#1] SMP
[173475.410829] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop i2c_i801 i2c_core pcspkr battery 
tpm_infineon tpm_tis tpm parport_pc parport video lpc_ich mfd_core 
ehci_pci ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg 
sd_mod ahci libahci libata scsi_mod r8169 mii
[173475.411284] CPU: 1 PID: 5512 Comm: btrfs Not tainted 3.17.0-rc7 #1
[173475.411341] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[173475.411450] task: ffff8807f1744830 ti: ffff88076e9b0000 task.ti: 
ffff88076e9b0000
[173475.411555] RIP: 0010:[<ffffffffa02ef1ae>]  [<ffffffffa02ef1ae>] 
build_backref_tree+0x64a/0xe77 [btrfs]
[173475.411684] RSP: 0018:ffff88076e9b3888  EFLAGS: 00010287
[173475.411740] RAX: ffff8805abb30480 RBX: ffff880589dfcf00 RCX: 
0000000000000003
[173475.411845] RDX: 00000510a31b8000 RSI: ffff880589dfcac0 RDI: 
ffff8804c69f8800
[173475.411949] RBP: ffff88076e9b3988 R08: 00000000000143e0 R09: 
0000000000000000
[173475.412053] R10: ffff8807c97366f0 R11: 0000000000000000 R12: 
ffff8804c69f8800
[173475.412157] R13: ffff880589dfca80 R14: 0000000000000000 R15: 
ffff88065a3b0000
[173475.412262] FS:  00007f320e446840(0000) GS:ffff88081fa40000(0000) 
knlGS:0000000000000000
[173475.413687] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[173475.413744] CR2: ffffffffff600400 CR3: 00000007ea08f000 CR4: 
00000000001407e0
[173475.413849] Stack:
[173475.413899]  ffff8807c820a000 0000000000000000 ffff880589dfcf00 
ffff8801a22bf7c0
[173475.414007]  ffff8801a22bfb60 ffff880589dfcac0 ffff88065a3b0124 
0000000000000001
[173475.414114]  ffff88065a3b0120 0000000000000003 ffff8805abb30480 
ffff8805dbbb7240
[173475.414223] Call Trace:
[173475.414291]  [<ffffffffa02f0480>] relocate_tree_blocks+0x1b7/0x532 
[btrfs]
[173475.414364]  [<ffffffffa02cac81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[173475.414434]  [<ffffffffa02ebcf3>] ? tree_insert+0x49/0x50 [btrfs]
[173475.414501]  [<ffffffffa02eea1b>] ? add_tree_block+0x13a/0x162 
[btrfs]
[173475.414570]  [<ffffffffa02f1861>] relocate_block_group+0x275/0x4de 
[btrfs]
[173475.414640]  [<ffffffffa02f1c22>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[173475.414763]  [<ffffffffa02ce79c>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[173475.414884]  [<ffffffffa02dd99f>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[173475.414995]  [<ffffffffa028eb04>] ? 
btrfs_set_path_blocking+0x23/0x54 [btrfs]
[173475.415107]  [<ffffffffa0293517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[173475.415177]  [<ffffffffa02cac81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[173475.415248]  [<ffffffffa02d1679>] btrfs_balance+0xa7b/0xc80 [btrfs]
[173475.415318]  [<ffffffffa02d7177>] btrfs_ioctl_balance+0x220/0x29f 
[btrfs]
[173475.415388]  [<ffffffffa02dc1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
[173475.415448]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
[173475.415507]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
[173475.415566]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
[173475.415625]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
[173475.415682]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
[173475.415740]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
[173475.415798]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
[173475.415856] Code: ff ff 01 e9 50 02 00 00 48 63 8d 48 ff ff ff 48 8b 
85 50 ff ff ff 48 83 3c c8 00 75 46 48 8b 53 18 49 39 94 24 d8 00 00 00 
74 02 <0f> 0b 4c 89 e7 e8 9b e8 ff ff 85 c0 74 21 48 8b 55 98 48 8d 43
[173475.416080] RIP  [<ffffffffa02ef1ae>] build_backref_tree+0x64a/0xe77 
[btrfs]
[173475.416151]  RSP <ffff88076e9b3888>
[173475.416482] ---[ end trace 17e512e0d6dc91d7 ]---



-- 
Tomasz Chmielewski
http://www.sslrack.com

