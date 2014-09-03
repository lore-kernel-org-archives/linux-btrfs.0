Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41568 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaICRmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 13:42:07 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 4922A406409
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Sep 2014 19:42:04 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at fs/btrfs/extent-tree.c:7727! with 3.17-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 03 Sep 2014 19:42:04 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <4306bc25fe19b7dd623c8e724292d7bb@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got the following with 3.17-rc3 and running balance (had to power cycle 
after that):

[ 1329.952600] ------------[ cut here ]------------
[ 1329.952671] WARNING: CPU: 7 PID: 3106 at fs/btrfs/extent-tree.c:876 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]()
[ 1329.952726] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop parport_pc parport pcspkr i2c_i801 
tpm_infineon tpm_tis tpm i2ccore video battery lpc_ich mfd_core ehci_pci 
ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod 
ahci libahci libata scsi_mod r8169 mii
[ 1329.954740] CPU: 7 PID: 3106 Comm: btrfs-balance Not tainted 
3.17.0-rc3 #1
[ 1329.954789] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 1329.954841]  0000000000000009 ffff880733d4f8d8 ffffffff813ab092 
0000000000000000
[ 1329.955030]  0000000000000000 ffff880733d4f918 ffffffff81039b41 
ffffffff00000007
[ 1329.955219]  ffffffffa02d8560 ffff8807aa536120 0000000000000000 
0000000000000000
[ 1329.955407] Call Trace:
[ 1329.955455]  [<ffffffff813ab092>] dump_stack+0x46/0x58
[ 1329.955503]  [<ffffffff81039b41>] warn_slowpath_common+0x77/0x91
[ 1329.955610]  [<ffffffffa02d8560>] ? 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
[ 1329.955758]  [<ffffffff81039b70>] warn_slowpath_null+0x15/0x17
[ 1329.955862]  [<ffffffffa02d8560>] 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
[ 1329.956018]  [<ffffffffa02d8c8f>] walk_down_proc+0xc5/0x22b [btrfs]
[ 1329.956128]  [<ffffffffa02ebd20>] ? 
join_transaction.isra.30+0x24/0x309 [btrfs]
[ 1329.956285]  [<ffffffffa02dae92>] walk_down_tree+0x45/0xd5 [btrfs]
[ 1329.956391]  [<ffffffffa02dd89a>] btrfs_drop_snapshot+0x2f5/0x68f 
[btrfs]
[ 1329.956505]  [<ffffffffa032e19d>] merge_reloc_roots+0x139/0x23f 
[btrfs]
[ 1329.956617]  [<ffffffffa032e8f6>] relocate_block_group+0x466/0x4de 
[btrfs]
[ 1329.956728]  [<ffffffffa032eac6>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 1329.956890]  [<ffffffffa030b6f0>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 1329.957073]  [<ffffffffa031a8d7>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 1329.957214]  [<ffffffffa02cbb04>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 1329.957297]  [<ffffffffa02d0517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[ 1329.957382]  [<ffffffffa0307bd5>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 1329.957467]  [<ffffffffa030e5cd>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 1329.957547]  [<ffffffff813a8e15>] ? printk+0x48/0x4a
[ 1329.957629]  [<ffffffffa030e829>] balance_kthread+0x57/0x7c [btrfs]
[ 1329.957724]  [<ffffffffa030e7d2>] ? btrfs_balance+0xc80/0xc80 [btrfs]
[ 1329.957807]  [<ffffffffa030e7d2>] ? btrfs_balance+0xc80/0xc80 [btrfs]
[ 1329.957887]  [<ffffffff8104e993>] kthread+0xcd/0xd5
[ 1329.957965]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 1329.958045]  [<ffffffff813afcec>] ret_from_fork+0x7c/0xb0
[ 1329.958122]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 1329.958210] ---[ end trace a368b0643f9207e2 ]---
[ 1329.958293] ------------[ cut here ]------------
[ 1329.958378] kernel BUG at fs/btrfs/extent-tree.c:7727!
[ 1329.958455] invalid opcode: 0000 [#1] SMP
[ 1329.958593] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop parport_pc parport pcspkr i2c_i801 
tpm_infineon tpm_tis tpm i2ccore video battery lpc_ich mfd_core ehci_pci 
ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg sd_mod 
ahci libahci libata scsi_mod r8169 mii
[ 1329.960684] CPU: 7 PID: 3106 Comm: btrfs-balance Tainted: G        W  
     3.17.0-rc3 #1
[ 1329.960803] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 1329.960924] task: ffff8807f18c0000 ti: ffff880733d4c000 task.ti: 
ffff880733d4c000
[ 1329.961043] RIP: 0010:[<ffffffffa02d8ca6>]  [<ffffffffa02d8ca6>] 
walk_down_proc+0xdc/0x22b [btrfs]
[ 1329.961200] RSP: 0018:ffff880733d4f9e8  EFLAGS: 00010246
[ 1329.961277] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 
00000000000f5a50
[ 1329.961356] RDX: 00000000000f5a4f RSI: ffff88081fbd9650 RDI: 
0000000000019650
[ 1329.961436] RBP: ffff880733d4fa38 R08: ffffea001ea94d80 R09: 
00000000000009a2
[ 1329.961515] R10: ffffffffa02cbc38 R11: 0000000000000000 R12: 
ffff8807aa536d80
[ 1329.961594] R13: ffff880733ac5600 R14: ffff880660ba65c8 R15: 
0000000000000002
[ 1329.961674] FS:  0000000000000000(0000) GS:ffff88081fbc0000(0000) 
knlGS:0000000000000000
[ 1329.961794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1329.961872] CR2: 00007f7fa0c3e000 CR3: 0000000001611000 CR4: 
00000000001407e0
[ 1329.961951] Stack:
[ 1329.962024]  ffff880733ac5650 ffffffffa02ebd20 ffff880732a34820 
ffff8807eb201000
[ 1329.962267]  0000000000000000 ffff8807aa536d80 0000000000000002 
ffff880732a34820
[ 1329.962510]  ffff8807eb201000 ffff880733ac5600 ffff880733d4fa98 
ffffffffa02dae92
[ 1329.962754] Call Trace:
[ 1329.962834]  [<ffffffffa02ebd20>] ? 
join_transaction.isra.30+0x24/0x309 [btrfs]
[ 1329.962957]  [<ffffffffa02dae92>] walk_down_tree+0x45/0xd5 [btrfs]
[ 1329.963040]  [<ffffffffa02dd89a>] btrfs_drop_snapshot+0x2f5/0x68f 
[btrfs]
[ 1329.963126]  [<ffffffffa032e19d>] merge_reloc_roots+0x139/0x23f 
[btrfs]
[ 1329.963210]  [<ffffffffa032e8f6>] relocate_block_group+0x466/0x4de 
[btrfs]
[ 1329.963295]  [<ffffffffa032eac6>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 1329.963419]  [<ffffffffa030b6f0>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 1329.963544]  [<ffffffffa031a8d7>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 1329.963666]  [<ffffffffa02cbb04>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 1329.963749]  [<ffffffffa02d0517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[ 1329.963834]  [<ffffffffa0307bd5>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 1329.963918]  [<ffffffffa030e5cd>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 1329.963998]  [<ffffffff813a8e15>] ? printk+0x48/0x4a
[ 1329.964080]  [<ffffffffa030e829>] balance_kthread+0x57/0x7c [btrfs]
[ 1329.964163]  [<ffffffffa030e7d2>] ? btrfs_balance+0xc80/0xc80 [btrfs]
[ 1329.964246]  [<ffffffffa030e7d2>] ? btrfs_balance+0xc80/0xc80 [btrfs]
[ 1329.964326]  [<ffffffff8104e993>] kthread+0xcd/0xd5
[ 1329.964404]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 1329.964484]  [<ffffffff813afcec>] ret_from_fork+0x7c/0xb0
[ 1329.964562]  [<ffffffff8104e8c6>] ? 
kthread_freezable_should_stop+0x43/0x43
[ 1329.964641] Code: b8 01 00 00 00 4c 89 f9 48 89 04 24 49 8b 16 e8 5a 
f5 ff ff 83 f8 f4 75 02 0f 0b 85 c0 0f 85 48 01 00 00 4b 83 7c fd 00 00 
75 02 <0f> 0b 41 83 bd 94 00 00 00 01 48 63 c3 75 2d 49 83 7c c5 00 01
[ 1329.966842] RIP  [<ffffffffa02d8ca6>] walk_down_proc+0xdc/0x22b 
[btrfs]
[ 1329.966956]  RSP <ffff880733d4f9e8>
[ 1329.967040] ---[ end trace a368b0643f9207e3 ]---


-- 
Tomasz Chmielewski
http://www.sslrack.com

