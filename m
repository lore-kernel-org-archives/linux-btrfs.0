Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60848 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbaJDBTG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 21:19:06 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 577F3489182
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Oct 2014 03:19:02 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:7727! with 3.17-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 04 Oct 2014 03:19:02 +0200
From: Tomasz Chmielewski <tch@virtall.com>
In-Reply-To: <48c457ff533eafa20b68d96da6a787e8@admin.virtall.com>
References: <4306bc25fe19b7dd623c8e724292d7bb@admin.virtall.com>
 <48c457ff533eafa20b68d96da6a787e8@admin.virtall.com>
Message-ID: <07bbd61bafff676ba6148b5ab3a2b966@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW still seeing this with 3.17-rc7 when running balance (it's a 
different filesystem than described in "3.17.0-rc7: kernel BUG at 
fs/btrfs/relocation.c:931!" thread):

[ 6945.014952] BTRFS info (device sdb5): relocating block group 
7079521091584 flags 17
[ 6955.696529] BTRFS info (device sdb5): found 2065 extents
[ 6980.650073] BTRFS info (device sdb5): found 2065 extents
[ 6982.055757] BTRFS info (device sdb5): relocating block group 
7078447349760 flags 17
[ 6993.538142] BTRFS info (device sdb5): found 5959 extents
[ 7120.696355] ------------[ cut here ]------------
[ 7120.696419] WARNING: CPU: 7 PID: 4283 at fs/btrfs/extent-tree.c:876 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]()
[ 7120.696512] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop pcspkr parport_pc parport battery 
i2c_i801 i2c_core tpm_infineon lpc_ich mfd_core tpm_tis tpm video 
ehci_pci ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg 
sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7120.696897] CPU: 7 PID: 4283 Comm: btrfs Not tainted 3.17.0-rc7 #3
[ 7120.696945] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7120.697036]  0000000000000009 ffff8807beddf778 ffffffff813ab972 
0000000000000000
[ 7120.697126]  0000000000000000 ffff8807beddf7b8 ffffffff81039b41 
ffffffff0000001e
[ 7120.697217]  ffffffffa027e560 ffff8806bf8b8510 0000000000000000 
0000000000000000
[ 7120.697307] Call Trace:
[ 7120.697356]  [<ffffffff813ab972>] dump_stack+0x46/0x58
[ 7120.697404]  [<ffffffff81039b41>] warn_slowpath_common+0x77/0x91
[ 7120.697457]  [<ffffffffa027e560>] ? 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
[ 7120.697547]  [<ffffffff81039b70>] warn_slowpath_null+0x15/0x17
[ 7120.697607]  [<ffffffffa027e560>] 
btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
[ 7120.697699]  [<ffffffffa027ec8f>] walk_down_proc+0xc5/0x22b [btrfs]
[ 7120.697752]  [<ffffffffa0291d20>] ? 
join_transaction.isra.30+0x24/0x309 [btrfs]
[ 7120.697843]  [<ffffffffa0280e92>] walk_down_tree+0x45/0xd5 [btrfs]
[ 7120.697895]  [<ffffffffa028389a>] btrfs_drop_snapshot+0x2f5/0x68f 
[btrfs]
[ 7120.697951]  [<ffffffffa02d4325>] merge_reloc_roots+0x139/0x23f 
[btrfs]
[ 7120.698005]  [<ffffffffa02d4a7e>] relocate_block_group+0x466/0x4de 
[btrfs]
[ 7120.698059]  [<ffffffffa02d4c4e>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 7120.698153]  [<ffffffffa02b179c>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 7120.698246]  [<ffffffffa02c099f>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 7120.698337]  [<ffffffffa0271b04>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 7120.698389]  [<ffffffffa0276517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[ 7120.698443]  [<ffffffffa02adc81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 7120.698497]  [<ffffffffa02b4679>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 7120.698550]  [<ffffffffa02ba177>] btrfs_ioctl_balance+0x220/0x29f 
[btrfs]
[ 7120.698603]  [<ffffffffa02bf1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
[ 7120.698661]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
[ 7120.698756]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
[ 7120.698806]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
[ 7120.698867]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
[ 7120.698915]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
[ 7120.698964]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
[ 7120.699015]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
[ 7120.699063] ---[ end trace 5ede8b32160a5b9e ]---
[ 7120.699127] ------------[ cut here ]------------
[ 7120.699174] kernel BUG at fs/btrfs/extent-tree.c:7727!
[ 7120.699231] invalid opcode: 0000 [#1] SMP
[ 7120.699279] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop pcspkr parport_pc parport battery 
i2c_i801 i2c_core tpm_infineon lpc_ich mfd_core tpm_tis tpm video 
ehci_pci ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg 
sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7120.699648] CPU: 7 PID: 4283 Comm: btrfs Tainted: G        W      
3.17.0-rc7 #3
[ 7120.699735] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7120.699825] task: ffff8807c0381810 ti: ffff8807beddc000 task.ti: 
ffff8807beddc000
[ 7120.699912] RIP: 0010:[<ffffffffa027eca6>]  [<ffffffffa027eca6>] 
walk_down_proc+0xdc/0x22b [btrfs]
[ 7120.700007] RSP: 0018:ffff8807beddf888  EFLAGS: 00010246
[ 7120.700053] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 
000000000044b954
[ 7120.700101] RDX: 000000000044b953 RSI: ffff88081fbd9650 RDI: 
0000000000019650
[ 7120.700149] RBP: ffff8807beddf8d8 R08: ffffea001afe2e00 R09: 
00000000000008f4
[ 7120.700198] R10: ffffffffa0271c38 R11: 0000000000000000 R12: 
ffff8806bf8b87e0
[ 7120.700246] R13: ffff8807f3ce9780 R14: ffff880009e93ce8 R15: 
0000000000000002
[ 7120.700294] FS:  00007fae1881e840(0000) GS:ffff88081fbc0000(0000) 
knlGS:0000000000000000
[ 7120.700383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7120.700429] CR2: 00007f7a18042000 CR3: 00000007c0309000 CR4: 
00000000001407e0
[ 7120.700477] Stack:
[ 7120.700519]  ffff8807f3ce97d0 ffffffffa0291d20 ffff88010bf83280 
ffff880745c5a800
[ 7120.700608]  0000000000000000 ffff8806bf8b87e0 0000000000000002 
ffff88010bf83280
[ 7120.700697]  ffff880745c5a800 ffff8807f3ce9780 ffff8807beddf938 
ffffffffa0280e92
[ 7120.700786] Call Trace:
[ 7120.700834]  [<ffffffffa0291d20>] ? 
join_transaction.isra.30+0x24/0x309 [btrfs]
[ 7120.700926]  [<ffffffffa0280e92>] walk_down_tree+0x45/0xd5 [btrfs]
[ 7120.700978]  [<ffffffffa028389a>] btrfs_drop_snapshot+0x2f5/0x68f 
[btrfs]
[ 7120.701032]  [<ffffffffa02d4325>] merge_reloc_roots+0x139/0x23f 
[btrfs]
[ 7120.702196]  [<ffffffffa02d4a7e>] relocate_block_group+0x466/0x4de 
[btrfs]
[ 7120.702249]  [<ffffffffa02d4c4e>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 7120.702343]  [<ffffffffa02b179c>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 7120.702436]  [<ffffffffa02c099f>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 7120.702526]  [<ffffffffa0271b04>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 7120.702578]  [<ffffffffa0276517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[ 7120.702632]  [<ffffffffa02adc81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 7120.702685]  [<ffffffffa02b4679>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 7120.702747]  [<ffffffffa02ba177>] btrfs_ioctl_balance+0x220/0x29f 
[btrfs]
[ 7120.702801]  [<ffffffffa02bf1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
[ 7120.702858]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
[ 7120.702905]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
[ 7120.702952]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
[ 7120.703000]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
[ 7120.703047]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
[ 7120.703093]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
[ 7120.703140]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
[ 7120.703187] Code: b8 01 00 00 00 4c 89 f9 48 89 04 24 49 8b 16 e8 5a 
f5 ff ff 83 f8 f4 75 02 0f 0b 85 c0 0f 85 48 01 00 00 4b 83 7c fd 00 00 
75 02 <0f> 0b 41 83 bd 94 00 00 00 01 48 63 c3 75 2d 49 83 7c c5 00 01
[ 7120.703358] RIP  [<ffffffffa027eca6>] walk_down_proc+0xdc/0x22b 
[btrfs]
[ 7120.703410]  RSP <ffff8807beddf888>
[ 7120.703716] ---[ end trace 5ede8b32160a5b9f ]---
[ 7120.703909] BUG: unable to handle kernel paging request at 
000000000001f9c6
[ 7120.704050] IP: [<ffffffffa01188ba>] jbd2__journal_start+0x3d/0x151 
[jbd2]
[ 7120.704162] PGD 0
[ 7120.704266] Oops: 0000 [#2] SMP
[ 7120.704402] Modules linked in: ipt_MASQUERADE iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
ip_tables x_tables cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq 
zlib_deflate coretemp hwmon loop pcspkr parport_pc parport battery 
i2c_i801 i2c_core tpm_infineon lpc_ich mfd_core tpm_tis tpm video 
ehci_pci ehci_hcd button acpi_cpufreq ext4 crc16 jbd2 mbcache raid1 sg 
sd_mod ahci libahci libata scsi_mod r8169 mii
[ 7120.706438] CPU: 7 PID: 4283 Comm: btrfs Tainted: G      D W      
3.17.0-rc7 #3
[ 7120.706556] Hardware name: System manufacturer System Product 
Name/P8H77-M PRO, BIOS 1101 02/04/2013
[ 7120.706676] task: ffff8807c0381810 ti: ffff8807beddc000 task.ti: 
ffff8807beddc000
[ 7120.706795] RIP: 0010:[<ffffffffa01188ba>]  [<ffffffffa01188ba>] 
jbd2__journal_start+0x3d/0x151 [jbd2]
[ 7120.706948] RSP: 0018:ffff8807beddf3d8  EFLAGS: 00010282
[ 7120.707025] RAX: 000000000001f9c6 RBX: ffff88010bf83280 RCX: 
0000000000000050
[ 7120.707103] RDX: 0000000000000000 RSI: 000000000000005b RDI: 
ffff8807f156e000
[ 7120.707182] RBP: ffff8807beddf418 R08: 0000000000000005 R09: 
00000000000000f4
[ 7120.707261] R10: 000000000000003c R11: ffff880036e39830 R12: 
ffff8807f156e000
[ 7120.707340] R13: 0000000000000000 R14: 0000000000000005 R15: 
ffff8807f40c0de0
[ 7120.707419] FS:  00007fae1881e840(0000) GS:ffff88081fbc0000(0000) 
knlGS:0000000000000000
[ 7120.707538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7120.707618] CR2: 000000000001f9c6 CR3: 0000000001611000 CR4: 
00000000001407e0
[ 7120.707697] Stack:
[ 7120.707779]  ffff8807beddf458 00000005000000f4 0000000160f15c0a 
ffff8807f156d000
[ 7120.708021]  000000000000005b 0000000000000000 0000000000000005 
ffff8807f40c0de0
[ 7120.708263]  ffff8807beddf458 ffffffffa0156111 ffff8807beddf438 
ffff8800000000f4
[ 7120.708505] Call Trace:
[ 7120.708585]  [<ffffffffa0156111>] __ext4_journal_start_sb+0x5c/0x67 
[ext4]
[ 7120.708677]  [<ffffffffa013e4cb>] ext4_evict_inode+0x245/0x3d8 [ext4]
[ 7120.708765]  [<ffffffff811137da>] evict+0xa4/0x149
[ 7120.708842]  [<ffffffff81114059>] iput+0x129/0x132
[ 7120.708919]  [<ffffffff81110948>] __dentry_kill+0x145/0x1a4
[ 7120.708996]  [<ffffffff81110f32>] dput+0x130/0x148
[ 7120.709073]  [<ffffffff810fff55>] __fput+0x183/0x1ab
[ 7120.709149]  [<ffffffff810fffab>] ____fput+0x9/0xb
[ 7120.709226]  [<ffffffff8104d8a9>] task_work_run+0x79/0x90
[ 7120.709304]  [<ffffffff8103b9bd>] do_exit+0x3a0/0x8f6
[ 7120.709381]  [<ffffffff810053ae>] oops_end+0xa2/0xab
[ 7120.709457]  [<ffffffff810054de>] die+0x55/0x5f
[ 7120.709535]  [<ffffffff81002c97>] do_trap+0x6a/0x12c
[ 7120.709612]  [<ffffffff8104f593>] ? 
__atomic_notifier_call_chain+0xd/0xf
[ 7120.709691]  [<ffffffff81002e1b>] do_error_trap+0xc2/0xd4
[ 7120.709772]  [<ffffffffa027eca6>] ? walk_down_proc+0xdc/0x22b [btrfs]
[ 7120.709851]  [<ffffffff81063b6e>] ? __wake_up+0x3f/0x48
[ 7120.709935]  [<ffffffffa02adc81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 7120.710016]  [<ffffffffa0271bf7>] ? btrfs_release_path+0x6c/0x8b 
[btrfs]
[ 7120.710095]  [<ffffffff81002e9c>] do_invalid_op+0x1b/0x1d
[ 7120.710173]  [<ffffffff813b1928>] invalid_op+0x18/0x20
[ 7120.710252]  [<ffffffffa0271c38>] ? btrfs_free_path+0x22/0x26 [btrfs]
[ 7120.710335]  [<ffffffffa027eca6>] ? walk_down_proc+0xdc/0x22b [btrfs]
[ 7120.710416]  [<ffffffffa027ec8f>] ? walk_down_proc+0xc5/0x22b [btrfs]
[ 7120.710500]  [<ffffffffa0291d20>] ? 
join_transaction.isra.30+0x24/0x309 [btrfs]
[ 7120.710622]  [<ffffffffa0280e92>] walk_down_tree+0x45/0xd5 [btrfs]
[ 7120.710704]  [<ffffffffa028389a>] btrfs_drop_snapshot+0x2f5/0x68f 
[btrfs]
[ 7120.710789]  [<ffffffffa02d4325>] merge_reloc_roots+0x139/0x23f 
[btrfs]
[ 7120.710873]  [<ffffffffa02d4a7e>] relocate_block_group+0x466/0x4de 
[btrfs]
[ 7120.710957]  [<ffffffffa02d4c4e>] 
btrfs_relocate_block_group+0x158/0x278 [btrfs]
[ 7120.711081]  [<ffffffffa02b179c>] 
btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
[ 7120.711205]  [<ffffffffa02c099f>] ? 
btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
[ 7120.711326]  [<ffffffffa0271b04>] ? btrfs_set_path_blocking+0x23/0x54 
[btrfs]
[ 7120.711408]  [<ffffffffa0276517>] ? btrfs_search_slot+0x7bc/0x816 
[btrfs]
[ 7120.711492]  [<ffffffffa02adc81>] ? free_extent_buffer+0x6f/0x7c 
[btrfs]
[ 7120.711577]  [<ffffffffa02b4679>] btrfs_balance+0xa7b/0xc80 [btrfs]
[ 7120.711660]  [<ffffffffa02ba177>] btrfs_ioctl_balance+0x220/0x29f 
[btrfs]
[ 7120.711744]  [<ffffffffa02bf1e4>] btrfs_ioctl+0x10bd/0x2281 [btrfs]
[ 7120.711823]  [<ffffffff810d5152>] ? handle_mm_fault+0x44d/0xa00
[ 7120.711901]  [<ffffffff81173e76>] ? avc_has_perm+0x2e/0xf7
[ 7120.711979]  [<ffffffff810d7c6d>] ? __vm_enough_memory+0x25/0x13c
[ 7120.712057]  [<ffffffff8110d72d>] do_vfs_ioctl+0x3f2/0x43c
[ 7120.712134]  [<ffffffff8110d7c5>] SyS_ioctl+0x4e/0x7d
[ 7120.712212]  [<ffffffff81030a71>] ? do_page_fault+0xc/0xf
[ 7120.712289]  [<ffffffff813b0652>] system_call_fastpath+0x16/0x1b
[ 7120.712367] Code: 55 41 54 49 89 fc 53 48 83 ec 18 48 85 ff 44 89 45 
cc 44 89 4d c8 48 8b 98 58 07 00 00 0f 84 eb 00 00 00 48 85 db 74 12 48 
8b 03 <48> 39 38 74 02 0f 0b ff 43 14 e9 f3 00 00 00 48 8b 3d 18 9c 00
[ 7120.714556] RIP  [<ffffffffa01188ba>] jbd2__journal_start+0x3d/0x151 
[jbd2]
[ 7120.714668]  RSP <ffff8807beddf3d8>
[ 7120.714742] CR2: 000000000001f9c6
[ 7120.714816] ---[ end trace 5ede8b32160a5ba0 ]---
[ 7120.714892] Fixing recursive fault but reboot is needed!



On 2014-09-08 20:04 (Mon), Tomasz Chmielewski wrote:
> On 2014-09-03 19:42 (Wed), Tomasz Chmielewski wrote:
>> Got the following with 3.17-rc3 and running balance (had to power
>> cycle after that):
> 
> I'm seeing similar BUG with 3.17-rc4:
> 
> [ 1049.755843] BTRFS info (device sdb5): found 35715 extents
> [ 1050.257075] BTRFS info (device sdb5): relocating block group
> 7091332251648 flags 20
> [ 2087.976104] BTRFS info (device sdb5): found 40911 extents
> [ 2091.357102] BTRFS info (device sdb5): relocating block group
> 7006506647552 flags 20
> [ 2518.793237] INFO: task btrfs-balance:5688 blocked for more than 120 
> seconds.
> [ 2518.793263]       Not tainted 3.17.0-rc4 #1
> [ 2518.793269] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2518.793279] btrfs-balance   D ffff88081fad15c0     0  5688      2 
> 0x00000000
> [ 2518.793291]  ffff8807dceebac8 0000000000000046 ffff8807dceeb9c8
> ffff8807f0f83020
> [ 2518.793303]  00000000000115c0 0000000000004000 ffff8807f4153020
> ffff8807f0f83020
> [ 2518.793315]  ffff8807dceeba08 ffffffff8105639d 0000000000000000
> ffff8807f3cd8050
> [ 2518.793404] Call Trace:
> [ 2518.793452]  [<ffffffff8105639d>] ? wake_up_process+0x31/0x35
> [ 2518.793500]  [<ffffffff81049baf>] ? wake_up_worker+0x1f/0x21
> [ 2518.793547]  [<ffffffff81049df6>] ? insert_work+0x87/0x94
> [ 2518.793605]  [<ffffffffa031724b>] ? free_block_list+0x1f/0x34 
> [btrfs]
> [ 2518.793655]  [<ffffffff813ad75e>] ? wait_for_common+0x118/0x13e
> [ 2518.793703]  [<ffffffff813acf2e>] schedule+0x65/0x67
> [ 2518.793755]  [<ffffffffa02d934d>]
> wait_current_trans.isra.32+0x94/0xe2 [btrfs]
> [ 2518.793843]  [<ffffffff81063cdc>] ? add_wait_queue+0x44/0x44
> [ 2518.793895]  [<ffffffffa02da82f>] start_transaction+0x427/0x472 
> [btrfs]
> [ 2518.793948]  [<ffffffffa02dab02>] btrfs_start_transaction+0x16/0x18 
> [btrfs]
> [ 2518.794002]  [<ffffffffa031b51a>] relocate_block_group+0x8a/0x4de 
> [btrfs]
> [ 2518.794055]  [<ffffffffa031bac6>]
> btrfs_relocate_block_group+0x158/0x278 [btrfs]
> [ 2518.794148]  [<ffffffffa02f86f0>]
> btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
> [ 2518.794241]  [<ffffffffa03078d7>] ?
> btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
> [ 2518.794332]  [<ffffffffa02b8b04>] ? 
> btrfs_set_path_blocking+0x23/0x54 [btrfs]
> [ 2518.794383]  [<ffffffffa02bd517>] ? btrfs_search_slot+0x7bc/0x816 
> [btrfs]
> [ 2518.794437]  [<ffffffffa02f4bd5>] ? free_extent_buffer+0x6f/0x7c 
> [btrfs]
> [ 2518.794490]  [<ffffffffa02fb5cd>] btrfs_balance+0xa7b/0xc80 [btrfs]
> [ 2518.794538]  [<ffffffff813a9125>] ? printk+0x48/0x4a
> [ 2518.794589]  [<ffffffffa02fb829>] balance_kthread+0x57/0x7c [btrfs]
> [ 2518.794641]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 2518.794692]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 2518.794741]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 2518.794787]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2518.794836]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 2518.794883]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2518.794935] INFO: task kworker/u16:21:8725 blocked for more than 120 
> seconds.
> [ 2518.794983]       Not tainted 3.17.0-rc4 #1
> [ 2518.795028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2518.795116] kworker/u16:21  D ffff88081fbd15c0     0  8725      2 
> 0x00000000
> [ 2518.795170] Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 2518.795258]  ffff8805bf363b48 0000000000000046 ffff8805bf363a88
> ffff8807f3244830
> [ 2518.795347]  00000000000115c0 0000000000004000 ffff8807f4171810
> ffff8807f3244830
> [ 2518.795436]  ffff8805bf363a88 ffffffff81053484 0000000000200000
> ffff88081fa915c0
> [ 2518.795525] Call Trace:
> [ 2518.795568]  [<ffffffff81053484>] ? resched_curr+0x47/0x57
> [ 2518.795615]  [<ffffffff81053aed>] ? check_preempt_curr+0x3e/0x6d
> [ 2518.795663]  [<ffffffff8105634c>] ? try_to_wake_up+0x240/0x251
> [ 2518.795710]  [<ffffffff8105639d>] ? wake_up_process+0x31/0x35
> [ 2518.795758]  [<ffffffff813acf2e>] schedule+0x65/0x67
> [ 2518.795804]  [<ffffffff813af01c>] schedule_timeout+0x26/0x198
> [ 2518.795851]  [<ffffffff8104a0df>] ? __queue_work+0x1d2/0x204
> [ 2518.795899]  [<ffffffff813ad753>] wait_for_common+0x10d/0x13e
> [ 2518.795946]  [<ffffffff8105635d>] ? try_to_wake_up+0x251/0x251
> [ 2518.795993]  [<ffffffff813ad79c>] wait_for_completion+0x18/0x1a
> [ 2518.796042]  [<ffffffff8111d8aa>] writeback_inodes_sb_nr+0x87/0x8e
> [ 2518.796093]  [<ffffffffa02d0101>] ? btrfs_del_csums+0x1b6/0x2ca 
> [btrfs]
> [ 2518.796145]  [<ffffffffa02c63c9>] flush_space+0x1af/0x407 [btrfs]
> [ 2518.796196]  [<ffffffffa02c5e56>] ? 
> btrfs_get_alloc_profile+0x2b/0x2d [btrfs]
> [ 2518.796248]  [<ffffffffa02c618d>] ? can_overcommit+0x4f/0xdc [btrfs]
> [ 2518.796299]  [<ffffffffa02c6a71>]
> btrfs_async_reclaim_metadata_space+0x10c/0x157 [btrfs]
> [ 2518.796388]  [<ffffffff8104aadb>] process_one_work+0x188/0x2ab
> [ 2518.796435]  [<ffffffff8104ae89>] worker_thread+0x261/0x35e
> [ 2518.796482]  [<ffffffff8104ac28>] ? 
> process_scheduled_works+0x2a/0x2a
> [ 2518.796530]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 2518.796577]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2518.796625]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 2518.796672]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2638.722499] INFO: task kworker/u16:21:8725 blocked for more than 120 
> seconds.
> [ 2638.722568]       Not tainted 3.17.0-rc4 #1
> [ 2638.722625] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2638.722737] kworker/u16:21  D ffff88081fbd15c0     0  8725      2 
> 0x00000000
> [ 2638.722821] Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 2638.722935]  ffff8805bf363b48 0000000000000046 ffff8805bf363a88
> ffff8807f3244830
> [ 2638.723050]  00000000000115c0 0000000000004000 ffff8807f4171810
> ffff8807f3244830
> [ 2638.723165]  ffff8805bf363a88 ffffffff81053484 0000000000200000
> ffff88081fa915c0
> [ 2638.723279] Call Trace:
> [ 2638.723339]  [<ffffffff81053484>] ? resched_curr+0x47/0x57
> [ 2638.723401]  [<ffffffff81053aed>] ? check_preempt_curr+0x3e/0x6d
> [ 2638.723465]  [<ffffffff8105634c>] ? try_to_wake_up+0x240/0x251
> [ 2638.723526]  [<ffffffff8105639d>] ? wake_up_process+0x31/0x35
> [ 2638.723590]  [<ffffffff813acf2e>] schedule+0x65/0x67
> [ 2638.723650]  [<ffffffff813af01c>] schedule_timeout+0x26/0x198
> [ 2638.723713]  [<ffffffff8104a0df>] ? __queue_work+0x1d2/0x204
> [ 2638.723775]  [<ffffffff813ad753>] wait_for_common+0x10d/0x13e
> [ 2638.723837]  [<ffffffff8105635d>] ? try_to_wake_up+0x251/0x251
> [ 2638.723900]  [<ffffffff813ad79c>] wait_for_completion+0x18/0x1a
> [ 2638.723963]  [<ffffffff8111d8aa>] writeback_inodes_sb_nr+0x87/0x8e
> [ 2638.724037]  [<ffffffffa02d0101>] ? btrfs_del_csums+0x1b6/0x2ca 
> [btrfs]
> [ 2638.724109]  [<ffffffffa02c63c9>] flush_space+0x1af/0x407 [btrfs]
> [ 2638.724180]  [<ffffffffa02c5e56>] ? 
> btrfs_get_alloc_profile+0x2b/0x2d [btrfs]
> [ 2638.724252]  [<ffffffffa02c618d>] ? can_overcommit+0x4f/0xdc [btrfs]
> [ 2638.724322]  [<ffffffffa02c6a71>]
> btrfs_async_reclaim_metadata_space+0x10c/0x157 [btrfs]
> [ 2638.724436]  [<ffffffff8104aadb>] process_one_work+0x188/0x2ab
> [ 2638.724498]  [<ffffffff8104ae89>] worker_thread+0x261/0x35e
> [ 2638.724559]  [<ffffffff8104ac28>] ? 
> process_scheduled_works+0x2a/0x2a
> [ 2638.724622]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 2638.724683]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2638.724747]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 2638.724808]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2758.651776] INFO: task kworker/u16:21:8725 blocked for more than 120 
> seconds.
> [ 2758.651842]       Not tainted 3.17.0-rc4 #1
> [ 2758.651899] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2758.652008] kworker/u16:21  D ffff88081fbd15c0     0  8725      2 
> 0x00000000
> [ 2758.652091] Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 2758.652201]  ffff8805bf363b48 0000000000000046 ffff8805bf363a88
> ffff8807f3244830
> [ 2758.652313]  00000000000115c0 0000000000004000 ffff8807f4171810
> ffff8807f3244830
> [ 2758.652425]  ffff8805bf363a88 ffffffff81053484 0000000000200000
> ffff88081fa915c0
> [ 2758.652537] Call Trace:
> [ 2758.652595]  [<ffffffff81053484>] ? resched_curr+0x47/0x57
> [ 2758.652656]  [<ffffffff81053aed>] ? check_preempt_curr+0x3e/0x6d
> [ 2758.652717]  [<ffffffff8105634c>] ? try_to_wake_up+0x240/0x251
> [ 2758.652779]  [<ffffffff8105639d>] ? wake_up_process+0x31/0x35
> [ 2758.652841]  [<ffffffff813acf2e>] schedule+0x65/0x67
> [ 2758.652900]  [<ffffffff813af01c>] schedule_timeout+0x26/0x198
> [ 2758.652962]  [<ffffffff8104a0df>] ? __queue_work+0x1d2/0x204
> [ 2758.653023]  [<ffffffff813ad753>] wait_for_common+0x10d/0x13e
> [ 2758.653084]  [<ffffffff8105635d>] ? try_to_wake_up+0x251/0x251
> [ 2758.653145]  [<ffffffff813ad79c>] wait_for_completion+0x18/0x1a
> [ 2758.653206]  [<ffffffff8111d8aa>] writeback_inodes_sb_nr+0x87/0x8e
> [ 2758.653278]  [<ffffffffa02d0101>] ? btrfs_del_csums+0x1b6/0x2ca 
> [btrfs]
> [ 2758.653347]  [<ffffffffa02c63c9>] flush_space+0x1af/0x407 [btrfs]
> [ 2758.653416]  [<ffffffffa02c5e56>] ? 
> btrfs_get_alloc_profile+0x2b/0x2d [btrfs]
> [ 2758.653486]  [<ffffffffa02c618d>] ? can_overcommit+0x4f/0xdc [btrfs]
> [ 2758.653554]  [<ffffffffa02c6a71>]
> btrfs_async_reclaim_metadata_space+0x10c/0x157 [btrfs]
> [ 2758.653665]  [<ffffffff8104aadb>] process_one_work+0x188/0x2ab
> [ 2758.653726]  [<ffffffff8104ae89>] worker_thread+0x261/0x35e
> [ 2758.653786]  [<ffffffff8104ac28>] ? 
> process_scheduled_works+0x2a/0x2a
> [ 2758.653848]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 2758.653907]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2758.653969]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 2758.654029]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2878.581047] INFO: task kworker/u16:21:8725 blocked for more than 120 
> seconds.
> [ 2878.581117]       Not tainted 3.17.0-rc4 #1
> [ 2878.581174] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2878.581287] kworker/u16:21  D ffff88081fbd15c0     0  8725      2 
> 0x00000000
> [ 2878.581371] Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> [ 2878.582875]  ffff8805bf363b48 0000000000000046 ffff8805bf363a88
> ffff8807f3244830
> [ 2878.582990]  00000000000115c0 0000000000004000 ffff8807f4171810
> ffff8807f3244830
> [ 2878.583105]  ffff8805bf363a88 ffffffff81053484 0000000000200000
> ffff88081fa915c0
> [ 2878.583220] Call Trace:
> [ 2878.583280]  [<ffffffff81053484>] ? resched_curr+0x47/0x57
> [ 2878.583342]  [<ffffffff81053aed>] ? check_preempt_curr+0x3e/0x6d
> [ 2878.583404]  [<ffffffff8105634c>] ? try_to_wake_up+0x240/0x251
> [ 2878.583467]  [<ffffffff8105639d>] ? wake_up_process+0x31/0x35
> [ 2878.583531]  [<ffffffff813acf2e>] schedule+0x65/0x67
> [ 2878.583591]  [<ffffffff813af01c>] schedule_timeout+0x26/0x198
> [ 2878.583655]  [<ffffffff8104a0df>] ? __queue_work+0x1d2/0x204
> [ 2878.583717]  [<ffffffff813ad753>] wait_for_common+0x10d/0x13e
> [ 2878.583780]  [<ffffffff8105635d>] ? try_to_wake_up+0x251/0x251
> [ 2878.583842]  [<ffffffff813ad79c>] wait_for_completion+0x18/0x1a
> [ 2878.583905]  [<ffffffff8111d8aa>] writeback_inodes_sb_nr+0x87/0x8e
> [ 2878.583980]  [<ffffffffa02d0101>] ? btrfs_del_csums+0x1b6/0x2ca 
> [btrfs]
> [ 2878.584052]  [<ffffffffa02c63c9>] flush_space+0x1af/0x407 [btrfs]
> [ 2878.584123]  [<ffffffffa02c5e56>] ? 
> btrfs_get_alloc_profile+0x2b/0x2d [btrfs]
> [ 2878.584195]  [<ffffffffa02c618d>] ? can_overcommit+0x4f/0xdc [btrfs]
> [ 2878.584266]  [<ffffffffa02c6a71>]
> btrfs_async_reclaim_metadata_space+0x10c/0x157 [btrfs]
> [ 2878.584380]  [<ffffffff8104aadb>] process_one_work+0x188/0x2ab
> [ 2878.584442]  [<ffffffff8104ae89>] worker_thread+0x261/0x35e
> [ 2878.584503]  [<ffffffff8104ac28>] ? 
> process_scheduled_works+0x2a/0x2a
> [ 2878.584566]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 2878.584627]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 2878.584691]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 2878.584752]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 3384.754985] ------------[ cut here ]------------
> [ 3384.755050] WARNING: CPU: 2 PID: 5688 at fs/btrfs/extent-tree.c:876
> btrfs_lookup_extent_info+0x377/0x3eb [btrfs]()
> [ 3384.755145] Modules linked in: ipt_MASQUERADE iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> ip_tables x_tables cpufreq_ondemand cpufreq_conservative
> cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq
> zlib_deflate coretemp hwmon loop i2c_i801 i2ccore pcspkr battery
> tpm_infineon tpm_tis tpm parport_pc parport video ehci_pci ehci_hcd
> lpc_ich mfd_core acpi_cpufreq button ext4 crc16 jbd2 mbcache raid1 sg
> sd_mod ahci libahci libata scsi_mod r8169 mii
> [ 3384.755547] CPU: 2 PID: 5688 Comm: btrfs-balance Not tainted 
> 3.17.0-rc4 #1
> [ 3384.755597] Hardware name: System manufacturer System Product
> Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [ 3384.755691]  0000000000000009 ffff8807dceeb8d8 ffffffff813ab3a2
> 0000000000000000
> [ 3384.755785]  0000000000000000 ffff8807dceeb918 ffffffff81039b41
> ffffffff00000024
> [ 3384.755895]  ffffffffa02c5560 ffff8801b195bc60 0000000000000000
> 0000000000000000
> [ 3384.755990] Call Trace:
> [ 3384.756040]  [<ffffffff813ab3a2>] dump_stack+0x46/0x58
> [ 3384.756090]  [<ffffffff81039b41>] warn_slowpath_common+0x77/0x91
> [ 3384.756148]  [<ffffffffa02c5560>] ?
> btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
> [ 3384.756240]  [<ffffffff81039b70>] warn_slowpath_null+0x15/0x17
> [ 3384.756295]  [<ffffffffa02c5560>]
> btrfs_lookup_extent_info+0x377/0x3eb [btrfs]
> [ 3384.756393]  [<ffffffffa02c5c8f>] walk_down_proc+0xc5/0x22b [btrfs]
> [ 3384.756452]  [<ffffffffa02d8d20>] ?
> join_transaction.isra.30+0x24/0x309 [btrfs]
> [ 3384.756545]  [<ffffffffa02c7e92>] walk_down_tree+0x45/0xd5 [btrfs]
> [ 3384.756597]  [<ffffffffa02ca89a>] btrfs_drop_snapshot+0x2f5/0x68f 
> [btrfs]
> [ 3384.756653]  [<ffffffffa031b19d>] merge_reloc_roots+0x139/0x23f 
> [btrfs]
> [ 3384.756707]  [<ffffffffa031b8f6>] relocate_block_group+0x466/0x4de 
> [btrfs]
> [ 3384.756760]  [<ffffffffa031bac6>]
> btrfs_relocate_block_group+0x158/0x278 [btrfs]
> [ 3384.756854]  [<ffffffffa02f86f0>]
> btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
> [ 3384.756947]  [<ffffffffa03078d7>] ?
> btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
> [ 3384.757038]  [<ffffffffa02b8b04>] ? 
> btrfs_set_path_blocking+0x23/0x54 [btrfs]
> [ 3384.757089]  [<ffffffffa02bd517>] ? btrfs_search_slot+0x7bc/0x816 
> [btrfs]
> [ 3384.757143]  [<ffffffffa02f4bd5>] ? free_extent_buffer+0x6f/0x7c 
> [btrfs]
> [ 3384.757197]  [<ffffffffa02fb5cd>] btrfs_balance+0xa7b/0xc80 [btrfs]
> [ 3384.757246]  [<ffffffff813a9125>] ? printk+0x48/0x4a
> [ 3384.757297]  [<ffffffffa02fb829>] balance_kthread+0x57/0x7c [btrfs]
> [ 3384.757349]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 3384.757401]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 3384.757450]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 3384.757496]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 3384.757545]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 3384.757592]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 3384.757640] ---[ end trace 4f32f915eb18c087 ]---
> [ 3384.757691] ------------[ cut here ]------------
> [ 3384.757736] kernel BUG at fs/btrfs/extent-tree.c:7727!
> [ 3384.757782] invalid opcode: 0000 [#1] SMP
> [ 3384.757827] Modules linked in: ipt_MASQUERADE iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
> ip_tables x_tables cpufreq_ondemand cpufreq_conservative
> cpufreq_powersave cpufreq_stats bridge stp llc ipv6 btrfs xor raid6_pq
> zlib_deflate coretemp hwmon loop i2c_i801 i2ccore pcspkr battery
> tpm_infineon tpm_tis tpm parport_pc parport video ehci_pci ehci_hcd
> lpc_ich mfd_core acpi_cpufreq button ext4 crc16 jbd2 mbcache raid1 sg
> sd_mod ahci libahci libata scsi_mod r8169 mii
> [ 3384.758182] CPU: 2 PID: 5688 Comm: btrfs-balance Tainted: G
> W      3.17.0-rc4 #1
> [ 3384.758270] Hardware name: System manufacturer System Product
> Name/P8H77-M PRO, BIOS 1101 02/04/2013
> [ 3384.758360] task: ffff8807f0f83020 ti: ffff8807dcee8000 task.ti:
> ffff8807dcee8000
> [ 3384.758448] RIP: 0010:[<ffffffffa02c5ca6>]  [<ffffffffa02c5ca6>]
> walk_down_proc+0xdc/0x22b [btrfs]
> [ 3384.758542] RSP: 0018:ffff8807dceeb9e8  EFLAGS: 00010246
> [ 3384.758588] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 
> 0000000000984a1c
> [ 3384.758636] RDX: 0000000000984a1b RSI: ffff88081fa99650 RDI: 
> 0000000000019650
> [ 3384.758684] RBP: ffff8807dceeba38 R08: ffffea0006c656c0 R09: 
> 0000000000000000
> [ 3384.758733] R10: ffffffffa02b8c38 R11: 0000000000000000 R12: 
> ffff8801b195bbd0
> [ 3384.758781] R13: ffff88010d092d80 R14: ffff880102ba33a8 R15: 
> 0000000000000002
> [ 3384.758830] FS:  0000000000000000(0000) GS:ffff88081fa80000(0000)
> knlGS:0000000000000000
> [ 3384.758918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3384.758965] CR2: 00007f980e95d000 CR3: 0000000001611000 CR4: 
> 00000000001407e0
> [ 3384.759013] Stack:
> [ 3384.759054]  ffff88010d092dd0 ffffffffa02d8d20 ffff880102516d20
> ffff8807449a9000
> [ 3384.759143]  0000000000000000 ffff8801b195bbd0 0000000000000002
> ffff880102516d20
> [ 3384.759232]  ffff8807449a9000 ffff88010d092d80 ffff8807dceeba98
> ffffffffa02c7e92
> [ 3384.759321] Call Trace:
> [ 3384.759369]  [<ffffffffa02d8d20>] ?
> join_transaction.isra.30+0x24/0x309 [btrfs]
> [ 3384.759461]  [<ffffffffa02c7e92>] walk_down_tree+0x45/0xd5 [btrfs]
> [ 3384.759513]  [<ffffffffa02ca89a>] btrfs_drop_snapshot+0x2f5/0x68f 
> [btrfs]
> [ 3384.759567]  [<ffffffffa031b19d>] merge_reloc_roots+0x139/0x23f 
> [btrfs]
> [ 3384.759620]  [<ffffffffa031b8f6>] relocate_block_group+0x466/0x4de 
> [btrfs]
> [ 3384.759673]  [<ffffffffa031bac6>]
> btrfs_relocate_block_group+0x158/0x278 [btrfs]
> [ 3384.759766]  [<ffffffffa02f86f0>]
> btrfs_relocate_chunk.isra.62+0x58/0x5f7 [btrfs]
> [ 3384.759859]  [<ffffffffa03078d7>] ?
> btrfs_set_lock_blocking_rw+0x68/0x95 [btrfs]
> [ 3384.759950]  [<ffffffffa02b8b04>] ? 
> btrfs_set_path_blocking+0x23/0x54 [btrfs]
> [ 3384.760001]  [<ffffffffa02bd517>] ? btrfs_search_slot+0x7bc/0x816 
> [btrfs]
> [ 3384.760055]  [<ffffffffa02f4bd5>] ? free_extent_buffer+0x6f/0x7c 
> [btrfs]
> [ 3384.760108]  [<ffffffffa02fb5cd>] btrfs_balance+0xa7b/0xc80 [btrfs]
> [ 3384.760156]  [<ffffffff813a9125>] ? printk+0x48/0x4a
> [ 3384.760207]  [<ffffffffa02fb829>] balance_kthread+0x57/0x7c [btrfs]
> [ 3384.760259]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 3384.760310]  [<ffffffffa02fb7d2>] ? btrfs_balance+0xc80/0xc80 
> [btrfs]
> [ 3384.760359]  [<ffffffff8104e993>] kthread+0xcd/0xd5
> [ 3384.760405]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 3384.760453]  [<ffffffff813affec>] ret_from_fork+0x7c/0xb0
> [ 3384.760500]  [<ffffffff8104e8c6>] ? 
> kthread_freezable_should_stop+0x43/0x43
> [ 3384.760548] Code: b8 01 00 00 00 4c 89 f9 48 89 04 24 49 8b 16 e8
> 5a f5 ff ff 83 f8 f4 75 02 0f 0b 85 c0 0f 85 48 01 00 00 4b 83 7c fd
> 00 00 75 02 <0f> 0b 41 83 bd 94 00 00 00 01 48 63 c3 75 2d 49 83 7c c5
> 00 01
> [ 3384.760721] RIP  [<ffffffffa02c5ca6>] walk_down_proc+0xdc/0x22b 
> [btrfs]
> [ 3384.760773]  RSP <ffff8807dceeb9e8>
> [ 3384.761080] ---[ end trace 4f32f915eb18c088 ]---

-- 
Tomasz Chmielewski
http://www.sslrack.com

