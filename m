Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56685 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaLAP2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 10:28:16 -0500
Received: from mfilter6-d.gandi.net (mfilter6-d.gandi.net [217.70.178.135])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 6CF721720F0
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Dec 2014 16:28:14 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter6-d.gandi.net (mfilter6-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 2wEMwFYh27r9 for <linux-btrfs@vger.kernel.org>;
	Mon,  1 Dec 2014 16:28:12 +0100 (CET)
Received: from vajra.localnet (unknown [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 9C917172131
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Dec 2014 16:28:11 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BRFS balance crash
Date: Mon, 01 Dec 2014 16:28:10 +0100
Message-ID: <4473709.PbjLf1Boa1@vajra>
In-Reply-To: <4619625.ssjvlSibEN@vajra>
References: <4619625.ssjvlSibEN@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I got another kernel crash during a balance, this time with a nice "kernel 
bug"...:

déc. 01 16:19:09 vajra kernel: ------------[ cut here ]------------
déc. 01 16:19:09 vajra kernel: WARNING: CPU: 0 PID: 5396 at fs/btrfs/extent-
tree.c:876 btrfs_lookup_extent_info+0x4c6/0x4e0 [btrfs]()
déc. 01 16:19:09 vajra kernel: Modules linked in: vfat fat uas usb_storage ccm 
rfcomm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge 
stp llc 
déc. 01 16:19:09 vajra kernel:  rfkill snd_seq wmi snd_seq_device snd_pcm 
parport_pc parport snd_timer mei_me hp_accel lis3lv02d i2c_i801 mei 
input_polldev snd tpm_tis
déc. 01 16:19:09 vajra kernel: CPU: 0 PID: 5396 Comm: btrfs Tainted: G           
OE  3.17.4-300.fc21.x86_64 #1
déc. 01 16:19:09 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 16:19:09 vajra kernel:  0000000000000000 00000000d0ba426b 
ffff880193fdb7e0 ffffffff8173f929
déc. 01 16:19:09 vajra kernel:  0000000000000000 ffff880193fdb818 ffffffff810970ad 
ffff88017913b2d0
déc. 01 16:19:09 vajra kernel:  ffff8802298f9800 000000ccd2424000 
0000000000000001 ffff88011c675320
déc. 01 16:19:09 vajra kernel: Call Trace:
déc. 01 16:19:09 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 16:19:09 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 16:19:09 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0248966>] 
btrfs_lookup_extent_info+0x4c6/0x4e0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02491bd>] walk_down_proc+0x1cd/0x340 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024c4b3>] walk_down_tree+0x73/0x110 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024ff44>] 
btrfs_drop_snapshot+0x414/0x880 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b3c09>] merge_reloc_roots+0x109/0x260 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b416e>] 
relocate_block_group+0x40e/0x6d0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b4616>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028a25a>] 
btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02387a1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa023da5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa027ada9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02851ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028d540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0294b98>] 
btrfs_ioctl_balance+0x168/0x3c0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0298ba8>] btrfs_ioctl+0x558/0x27d0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c3728>] ? 
handle_mm_fault+0xa88/0x1010
déc. 01 16:19:09 vajra kernel:  [<ffffffff8121d40b>] ? path_openat+0xcb/0x6d0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217862>] ? final_putname+0x22/0x50
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217ae9>] ? putname+0x29/0x40
déc. 01 16:19:09 vajra kernel:  [<ffffffff81060a7c>] ? __do_page_fault+0x29c/0x580
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c7a28>] ? __vma_link_rb+0xb8/0xe0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220910>] do_vfs_ioctl+0x2d0/0x4b0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220b71>] SyS_ioctl+0x81/0xa0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81746ae9>] 
system_call_fastpath+0x16/0x1b
déc. 01 16:19:09 vajra kernel: ---[ end trace b3c094f5b3ca386b ]---
déc. 01 16:19:09 vajra kernel: ------------[ cut here ]------------
déc. 01 16:19:09 vajra kernel: kernel BUG at fs/btrfs/extent-tree.c:7733!
déc. 01 16:19:09 vajra kernel: invalid opcode: 0000 [#1] SMP 
déc. 01 16:19:09 vajra kernel: Modules linked in: vfat fat uas usb_storage ccm 
rfcomm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge 
stp llc 
déc. 01 16:19:09 vajra kernel:  rfkill snd_seq wmi snd_seq_device snd_pcm 
parport_pc parport snd_timer mei_me hp_accel lis3lv02d i2c_i801 mei 
input_polldev snd tpm_tis
déc. 01 16:19:09 vajra kernel: CPU: 0 PID: 5396 Comm: btrfs Tainted: G        
W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 16:19:09 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 16:19:09 vajra kernel: task: ffff880088586220 ti: ffff880193fd8000 
task.ti: ffff880193fd8000
déc. 01 16:19:09 vajra kernel: RIP: 0010:[<ffffffffa024930a>]  [<ffffffffa024930a>] 
walk_down_proc+0x31a/0x340 [btrfs]
déc. 01 16:19:09 vajra kernel: RSP: 0018:ffff880193fdb8e8  EFLAGS: 00010246
déc. 01 16:19:09 vajra kernel: RAX: 0000000000000000 RBX: ffff880182abbb40 RCX: 
0000000000000000
déc. 01 16:19:09 vajra kernel: RDX: 00000000008cf241 RSI: ffff88017913b2d0 RDI: 
ffff880232924400
déc. 01 16:19:09 vajra kernel: RBP: ffff880193fdb928 R08: 000060fdc12005c0 R09: 
ffffffffa0238926
déc. 01 16:19:09 vajra kernel: R10: ffff8802298f9800 R11: ffff88011c675320 R12: 
0000000000000003
déc. 01 16:19:09 vajra kernel: R13: ffff88017913b870 R14: ffff8800605455f8 R15: 
0000000000000003
déc. 01 16:19:09 vajra kernel: FS:  00007f96e0bd78c0(0000) 
GS:ffff88023ea00000(0000) knlGS:0000000000000000
déc. 01 16:19:09 vajra kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
déc. 01 16:19:09 vajra kernel: CR2: 00007f7172b51000 CR3: 00000001348b1000 
CR4: 00000000001407f0
déc. 01 16:19:09 vajra kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
déc. 01 16:19:09 vajra kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
déc. 01 16:19:09 vajra kernel: Stack:
déc. 01 16:19:09 vajra kernel:  ffff880182abbb98 ffff8802298f9800 ffff88011c675320 
ffff88017913b870
déc. 01 16:19:09 vajra kernel:  0000000000000003 ffff880182abbb40 ffff8802298f99df 
ffff8802298f9800
déc. 01 16:19:09 vajra kernel:  ffff880193fdb978 ffffffffa024c4b3 ffff88011c675320 
00000001298f9800
déc. 01 16:19:09 vajra kernel: Call Trace:
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024c4b3>] walk_down_tree+0x73/0x110 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024ff44>] 
btrfs_drop_snapshot+0x414/0x880 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b3c09>] merge_reloc_roots+0x109/0x260 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b416e>] 
relocate_block_group+0x40e/0x6d0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b4616>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028a25a>] 
btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02387a1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa023da5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa027ada9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02851ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028d540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0294b98>] 
btrfs_ioctl_balance+0x168/0x3c0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0298ba8>] btrfs_ioctl+0x558/0x27d0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c3728>] ? 
handle_mm_fault+0xa88/0x1010
déc. 01 16:19:09 vajra kernel:  [<ffffffff8121d40b>] ? path_openat+0xcb/0x6d0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217862>] ? final_putname+0x22/0x50
déc. 01 16:19:09 vajra kernel:  [<ffffffffa023da5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa027ada9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02851ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028d540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0294b98>] 
btrfs_ioctl_balance+0x168/0x3c0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0298ba8>] btrfs_ioctl+0x558/0x27d0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c3728>] ? 
handle_mm_fault+0xa88/0x1010
déc. 01 16:19:09 vajra kernel:  [<ffffffff8121d40b>] ? path_openat+0xcb/0x6d0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217862>] ? final_putname+0x22/0x50
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217ae9>] ? putname+0x29/0x40
déc. 01 16:19:09 vajra kernel:  [<ffffffff81060a7c>] ? __do_page_fault+0x29c/0x580
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c7a28>] ? __vma_link_rb+0xb8/0xe0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220910>] do_vfs_ioctl+0x2d0/0x4b0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220b71>] SyS_ioctl+0x81/0xa0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81746ae9>] 
system_call_fastpath+0x16/0x1b
déc. 01 16:19:09 vajra kernel: ---[ end trace b3c094f5b3ca386b ]---
déc. 01 16:19:09 vajra kernel: ------------[ cut here ]------------
déc. 01 16:19:09 vajra kernel: kernel BUG at fs/btrfs/extent-tree.c:7733!
déc. 01 16:19:09 vajra kernel: invalid opcode: 0000 [#1] SMP 
déc. 01 16:19:09 vajra kernel: Modules linked in: vfat fat uas usb_storage ccm 
rfcomm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge 
stp llc 
déc. 01 16:19:09 vajra kernel:  rfkill snd_seq wmi snd_seq_device snd_pcm 
parport_pc parport snd_timer mei_me hp_accel lis3lv02d i2c_i801 mei 
input_polldev snd tpm_tis
déc. 01 16:19:09 vajra kernel: CPU: 0 PID: 5396 Comm: btrfs Tainted: G        
W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 16:19:09 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 16:19:09 vajra kernel: task: ffff880088586220 ti: ffff880193fd8000 
task.ti: ffff880193fd8000
déc. 01 16:19:09 vajra kernel: RIP: 0010:[<ffffffffa024930a>]  [<ffffffffa024930a>] 
walk_down_proc+0x31a/0x340 [btrfs]
déc. 01 16:19:09 vajra kernel: RSP: 0018:ffff880193fdb8e8  EFLAGS: 00010246
déc. 01 16:19:09 vajra kernel: RAX: 0000000000000000 RBX: ffff880182abbb40 RCX: 
0000000000000000
déc. 01 16:19:09 vajra kernel: RDX: 00000000008cf241 RSI: ffff88017913b2d0 RDI: 
ffff880232924400
déc. 01 16:19:09 vajra kernel: RBP: ffff880193fdb928 R08: 000060fdc12005c0 R09: 
ffffffffa0238926
déc. 01 16:19:09 vajra kernel: R10: ffff8802298f9800 R11: ffff88011c675320 R12: 
0000000000000003
déc. 01 16:19:09 vajra kernel: R13: ffff88017913b870 R14: ffff8800605455f8 R15: 
0000000000000003
déc. 01 16:19:09 vajra kernel: FS:  00007f96e0bd78c0(0000) 
GS:ffff88023ea00000(0000) knlGS:0000000000000000
déc. 01 16:19:09 vajra kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
déc. 01 16:19:09 vajra kernel: CR2: 00007f7172b51000 CR3: 00000001348b1000 
CR4: 00000000001407f0
déc. 01 16:19:09 vajra kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
déc. 01 16:19:09 vajra kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
déc. 01 16:19:09 vajra kernel: Stack:
déc. 01 16:19:09 vajra kernel:  ffff880182abbb98 ffff8802298f9800 ffff88011c675320 
ffff88017913b870
déc. 01 16:19:09 vajra kernel:  0000000000000003 ffff880182abbb40 ffff8802298f99df 
ffff8802298f9800
déc. 01 16:19:09 vajra kernel:  ffff880193fdb978 ffffffffa024c4b3 ffff88011c675320 
00000001298f9800
déc. 01 16:19:09 vajra kernel: Call Trace:
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024c4b3>] walk_down_tree+0x73/0x110 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa024ff44>] 
btrfs_drop_snapshot+0x414/0x880 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b3c09>] merge_reloc_roots+0x109/0x260 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b416e>] 
relocate_block_group+0x40e/0x6d0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02b4616>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028a25a>] 
btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02387a1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa023da5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa027ada9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa02851ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa028d540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0294b98>] 
btrfs_ioctl_balance+0x168/0x3c0 [btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffffa0298ba8>] btrfs_ioctl+0x558/0x27d0 
[btrfs]
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c3728>] ? 
handle_mm_fault+0xa88/0x1010
déc. 01 16:19:09 vajra kernel:  [<ffffffff8121d40b>] ? path_openat+0xcb/0x6d0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217862>] ? final_putname+0x22/0x50
déc. 01 16:19:09 vajra kernel:  [<ffffffff81217ae9>] ? putname+0x29/0x40
déc. 01 16:19:09 vajra kernel:  [<ffffffff81060a7c>] ? __do_page_fault+0x29c/0x580
déc. 01 16:19:09 vajra kernel:  [<ffffffff811c7a28>] ? __vma_link_rb+0xb8/0xe0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220910>] do_vfs_ioctl+0x2d0/0x4b0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81220b71>] SyS_ioctl+0x81/0xa0
déc. 01 16:19:09 vajra kernel:  [<ffffffff81746ae9>] 
system_call_fastpath+0x16/0x1b
déc. 01 16:19:09 vajra kernel: Code: 00 0f 0b 66 0f 1f 44 00 00 0f 0b 66 0f 1f 
44 00 00 0f 0b 66 0f 1f 44 00 00 4c 89 f7 e8 c0 1f 05 00 e9 4a fe ff ff 0f 1f 00 
0f 0b <
déc. 01 16:19:09 vajra kernel: RIP  [<ffffffffa024930a>] 
walk_down_proc+0x31a/0x340 [btrfs]
-- Reboot --



> Hi,
> 
> I'm running Fedora Core 21 beta with kernel 3.17.4-300.fc21.x86_64 and
> 
> Btrfs-progs-3.17-1.fc21.x86_64
> 
> As my SSD was pretty full, I started :
> 
> btrfs balance start -dusage=75 -musage=75 /
> 
> This ended in "segmentation fault".
> 
> Afterwards my system wouldn't access the disk anymore, and needed a hard
> reboot.
> 
> After reboot balance seemingly has resumed then finished :
> 
> [root@vajra ~]# btrfs balance status /
> Balance on '/' is running
> 17 out of about 24 chunks balanced (123 considered),  29% left
> 
> (later)
> 
> [root@vajra ~]# btrfs balance status /
> No balance found on '/'
> 
> 
> ...but my system has logged a (very high) number of kernel WARNINGS such as
> :
> 
> déc. 01 12:11:26 vajra kernel: ------------[ cut here ]------------
> déc. 01 12:11:26 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
> inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
> déc. 01 12:11:26 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter
> ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables i
> déc. 01 12:11:26 vajra kernel:  rfkill wmi snd_pcm parport_pc parport
> hp_accel snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd
> hp_wireless shpchp i2c_i801 sou
> déc. 01 12:11:26 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted:
> G W  OE  3.17.4-300.fc21.x86_64 #1
> déc. 01 12:11:26 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook
> 820 G1/1991, BIOS L71 Ver. 01.12 06/25/2014
> déc. 01 12:11:26 vajra kernel:  0000000000000000 000000009fd55060
> ffff8800a8467ac8 ffffffff8173f929
> déc. 01 12:11:26 vajra kernel:  0000000000000000 ffff8800a8467b00
> ffffffff810970ad ffff88014b7ee780
> déc. 01 12:11:26 vajra kernel:  0000000000000000 ffff88022fcec800
> ffff88022f9d1a40 0000000000000000
> déc. 01 12:11:26 vajra kernel: Call Trace:
> déc. 01 12:11:26 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
> déc. 01 12:11:26 vajra kernel:  [<ffffffff810970ad>]
> warn_slowpath_common+0x7d/0xa0
> déc. 01 12:11:26 vajra kernel:  [<ffffffff810971da>]
> warn_slowpath_null+0x1a/0x20 déc. 01 12:11:26 vajra kernel: 
> [<ffffffffa02bc169>]
> btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa02675e8>]
> btrfs_commit_transaction+0x388/0x950 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b850d>]
> prepare_to_merge+0x20d/0x230 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b9163>]
> relocate_block_group+0x403/0x6d0 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b9616>]
> btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa028f25a>]
> btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa023d7a1>] ?
> btrfs_set_path_blocking+0x41/0x80 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa0242a5d>] ?
> btrfs_search_slot+0x4ad/0xa70 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa027fda9>] ?
> btrfs_get_token_64+0x119/0x140 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa028a1ff>] ?
> free_extent_buffer+0x4f/0xa0 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292540>]
> btrfs_balance+0x980/0xf40 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292b5d>]
> balance_kthread+0x5d/0x80 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292b00>] ?
> btrfs_balance+0xf40/0xf40 [btrfs]
> déc. 01 12:11:26 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
> déc. 01 12:11:26 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:26 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
> déc. 01 12:11:26 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:26 vajra kernel: ---[ end trace f1f27f48a0abdf6f ]---
> 
> 
> déc. 01 12:11:27 vajra kernel: ------------[ cut here ]------------
> déc. 01 12:11:27 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
> inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
> déc. 01 12:11:27 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter
> ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables i
> déc. 01 12:11:27 vajra kernel:  rfkill wmi snd_pcm parport_pc parport
> hp_accel snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd
> hp_wireless shpchp i2c_i801 sou
> déc. 01 12:11:27 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted:
> G W  OE  3.17.4-300.fc21.x86_64 #1
> déc. 01 12:11:27 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook
> 820 G1/1991, BIOS L71 Ver. 01.12 06/25/2014
> déc. 01 12:11:27 vajra kernel:  0000000000000000 000000009fd55060
> ffff8800a8467b20 ffffffff8173f929
> déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800a8467b58
> ffffffff810970ad ffff880183e6b820
> déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff88022fcec800
> ffff88022f9d1950 0000000000000000
> déc. 01 12:11:27 vajra kernel: Call Trace:
> déc. 01 12:11:27 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810970ad>]
> warn_slowpath_common+0x7d/0xa0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810971da>]
> warn_slowpath_null+0x1a/0x20 déc. 01 12:11:27 vajra kernel: 
> [<ffffffffa02bc169>]
> btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa02675e8>]
> btrfs_commit_transaction+0x388/0x950 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa02b91b4>]
> relocate_block_group+0x454/0x6d0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa02b9616>]
> btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa028f25a>]
> btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa023d7a1>] ?
> btrfs_set_path_blocking+0x41/0x80 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0242a5d>] ?
> btrfs_search_slot+0x4ad/0xa70 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa027fda9>] ?
> btrfs_get_token_64+0x119/0x140 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa028a1ff>] ?
> free_extent_buffer+0x4f/0xa0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292540>]
> btrfs_balance+0x980/0xf40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b5d>]
> balance_kthread+0x5d/0x80 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b00>] ?
> btrfs_balance+0xf40/0xf40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:27 vajra kernel: ---[ end trace f1f27f48a0abdf70 ]---
> 
> 
> déc. 01 12:11:27 vajra kernel: ------------[ cut here ]------------
> déc. 01 12:11:27 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
> inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
> déc. 01 12:11:27 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter
> ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables i
> déc. 01 12:11:27 vajra kernel:  rfkill wmi snd_pcm parport_pc parport
> hp_accel snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd
> hp_wireless shpchp i2c_i801 sou
> déc. 01 12:11:27 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted:
> G W  OE  3.17.4-300.fc21.x86_64 #1
> déc. 01 12:11:27 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook
> 820 G1/1991, BIOS L71 Ver. 01.12 06/25/2014
> déc. 01 12:11:27 vajra kernel:  0000000000000000 000000009fd55060
> ffff8800a8467c70 ffffffff8173f929
> déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800a8467ca8
> ffffffff810970ad ffff8800b03ae640
> déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800aed1e800
> ffff88022f9d1860 0000000000000000
> déc. 01 12:11:27 vajra kernel: Call Trace:
> déc. 01 12:11:27 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810970ad>]
> warn_slowpath_common+0x7d/0xa0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810971da>]
> warn_slowpath_null+0x1a/0x20 déc. 01 12:11:27 vajra kernel: 
> [<ffffffffa02bc169>]
> btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa02675e8>]
> btrfs_commit_transaction+0x388/0x950 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa028a1ff>] ?
> free_extent_buffer+0x4f/0xa0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa023d889>] ?
> btrfs_release_path+0x29/0xa0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa028c83e>]
> __cancel_balance+0x17e/0x1b0 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292631>]
> btrfs_balance+0xa71/0xf40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b5d>]
> balance_kthread+0x5d/0x80 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b00>] ?
> btrfs_balance+0xf40/0xf40 [btrfs]
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
> déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:11:27 vajra kernel: ---[ end trace f1f27f48a0abdf71 ]---
> 
> 
> déc. 01 12:12:01 vajra kernel: ------------[ cut here ]------------
> déc. 01 12:12:01 vajra kernel: WARNING: CPU: 0 PID: 844 at fs/btrfs/delayed-
> inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
> déc. 01 12:12:01 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter
> ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables i
> déc. 01 12:12:01 vajra kernel:  rfkill wmi snd_pcm parport_pc parport
> hp_accel snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd
> hp_wireless shpchp i2c_i801 sou
> déc. 01 12:12:01 vajra kernel: CPU: 0 PID: 844 Comm: btrfs-transacti
> Tainted: G        W  OE  3.17.4-300.fc21.x86_64 #1
> déc. 01 12:12:01 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook
> 820 G1/1991, BIOS L71 Ver. 01.12 06/25/2014
> déc. 01 12:12:01 vajra kernel:  0000000000000000 000000005aad0390
> ffff88003675fdb8 ffffffff8173f929
> déc. 01 12:12:01 vajra kernel:  0000000000000000 ffff88003675fdf0
> ffffffff810970ad ffff8801222c03c0
> déc. 01 12:12:01 vajra kernel:  0000000000000000 ffff8800aed1e800
> ffff88022f9d1770 0000000000000000
> déc. 01 12:12:01 vajra kernel: Call Trace:
> déc. 01 12:12:01 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
> déc. 01 12:12:01 vajra kernel:  [<ffffffff810970ad>]
> warn_slowpath_common+0x7d/0xa0
> déc. 01 12:12:01 vajra kernel:  [<ffffffff810971da>]
> warn_slowpath_null+0x1a/0x20 déc. 01 12:12:01 vajra kernel: 
> [<ffffffffa02bc169>]
> btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
> déc. 01 12:12:01 vajra kernel:  [<ffffffffa02675e8>]
> btrfs_commit_transaction+0x388/0x950 [btrfs]
> déc. 01 12:12:01 vajra kernel:  [<ffffffffa02632b5>]
> transaction_kthread+0x245/0x260 [btrfs]
> déc. 01 12:12:01 vajra kernel:  [<ffffffffa0263070>] ?
> btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> déc. 01 12:12:01 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
> déc. 01 12:12:01 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:12:01 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
> déc. 01 12:12:01 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:12:01 vajra kernel: ---[ end trace f1f27f48a0abdf72 ]---
> 
> 
> déc. 01 12:12:32 vajra kernel: ------------[ cut here ]------------
> déc. 01 12:12:32 vajra kernel: WARNING: CPU: 3 PID: 844 at fs/btrfs/delayed-
> inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
> déc. 01 12:12:32 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter
> ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> ebtable_filter ebtables i
> déc. 01 12:12:32 vajra kernel:  rfkill wmi snd_pcm parport_pc parport
> hp_accel snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd
> hp_wireless shpchp i2c_i801 sou
> déc. 01 12:12:32 vajra kernel: CPU: 3 PID: 844 Comm: btrfs-transacti
> Tainted: G        W  OE  3.17.4-300.fc21.x86_64 #1
> déc. 01 12:12:32 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook
> 820 G1/1991, BIOS L71 Ver. 01.12 06/25/2014
> déc. 01 12:12:32 vajra kernel:  0000000000000000 000000005aad0390
> ffff88003675fdb8 ffffffff8173f929
> déc. 01 12:12:32 vajra kernel:  0000000000000000 ffff88003675fdf0
> ffffffff810970ad ffff880190745500
> déc. 01 12:12:32 vajra kernel:  0000000000000000 ffff8800aed1e800
> ffff8800abeee870 0000000000000000
> déc. 01 12:12:32 vajra kernel: Call Trace:
> déc. 01 12:12:32 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
> déc. 01 12:12:32 vajra kernel:  [<ffffffff810970ad>]
> warn_slowpath_common+0x7d/0xa0
> déc. 01 12:12:32 vajra kernel:  [<ffffffff810971da>]
> warn_slowpath_null+0x1a/0x20 déc. 01 12:12:32 vajra kernel: 
> [<ffffffffa02bc169>]
> btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
> déc. 01 12:12:32 vajra kernel:  [<ffffffffa02675e8>]
> btrfs_commit_transaction+0x388/0x950 [btrfs]
> déc. 01 12:12:32 vajra kernel:  [<ffffffffa02632b5>]
> transaction_kthread+0x245/0x260 [btrfs]
> déc. 01 12:12:32 vajra kernel:  [<ffffffffa0263070>] ?
> btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> déc. 01 12:12:32 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
> déc. 01 12:12:32 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:12:32 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
> déc. 01 12:12:32 vajra kernel:  [<ffffffff810b5210>] ?
> kthread_create_on_node+0x1a0/0x1a0
> déc. 01 12:12:32 vajra kernel: ---[ end trace f1f27f48a0abdf73 ]---
> 
> 
> ...etc.
> 
> Any indight / help much appreciated.
> 
> TIA and kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

La tragédie de l'homme moderne n'est pas qu'il en sache 
de moins en moins sur le sens de la vie
Mais que cela ne le dérange presque plus.
-- Vaclav Havel

