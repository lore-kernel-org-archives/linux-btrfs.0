Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37988 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbcFPRWp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 13:22:45 -0400
Received: by mail-wm0-f54.google.com with SMTP id m124so79203866wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 10:22:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0scWA4vQ9ZZcxaUo42qy1c8r7d1xaeajNjYn2Rfrj-rAGA@mail.gmail.com>
References: <CAK9QOun4rHcd6om7ZXaiv=ZGMCSufcZTJAFs2Sop=vBhcnxHJQ@mail.gmail.com>
 <CAK9QOu=yjjPtq0DMDF_JG3qsjs4pJjCzHhrRDwx8QPkDT_xxaA@mail.gmail.com> <CAG1y0scWA4vQ9ZZcxaUo42qy1c8r7d1xaeajNjYn2Rfrj-rAGA@mail.gmail.com>
From: Paul Verreth <paul@verreth.be>
Date: Thu, 16 Jun 2016 19:22:03 +0200
Message-ID: <CAK9QOu=rmn2uTNN0VYp_CEmBBr3iOh6PaE1OgnfvtADdtwR0ng@mail.gmail.com>
Subject: Re: BTRFS, remarkable problem: filesystem turns to read-only caused
 by firefox download
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

New test:

I booted from a live USB-stick with all updates installed
(4.4.0-21-generic), and after mount of the btrfs filesystem, the
balance continued, and a bug appeared in kern.log.

The filesystem turned readonly
An important directory was missing.


Jun 16 17:38:08 ubuntu kernel: [  195.482907] BTRFS info (device
sdb5): enabling auto recovery
Jun 16 17:38:08 ubuntu kernel: [  195.482914] BTRFS info (device
sdb5): disk space caching is enabled
Jun 16 17:38:08 ubuntu kernel: [  195.488335] BTRFS info (device
sdb5): bdev /dev/sdb5 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
Jun 16 17:38:08 ubuntu kernel: [  195.488340] BTRFS info (device
sdb5): bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
Jun 16 17:38:08 ubuntu kernel: [  195.559146] BTRFS: detected SSD
devices, enabling SSD mode
Jun 16 17:38:08 ubuntu kernel: [  195.560224] BTRFS: checking UUID tree
Jun 16 17:38:08 ubuntu kernel: [  195.560226] BTRFS info (device
sdb5): continuing balance
Jun 16 17:38:08 ubuntu kernel: [  195.560229] BTRFS info (device
sdb5): force reducing metadata integrity
Jun 16 17:38:08 ubuntu kernel: [  195.583979] BTRFS info (device
sdb5): relocating block group 297447456768 flags 20
Jun 16 17:38:12 ubuntu kernel: [  199.340273] ------------[ cut here
]------------
Jun 16 17:38:12 ubuntu kernel: [  199.340290] kernel BUG at
/build/linux-Ay7j_C/linux-4.4.0/fs/btrfs/relocation.c:2683!
Jun 16 17:38:12 ubuntu kernel: [  199.340308] invalid opcode: 0000 [#1] SMP
Jun 16 17:38:12 ubuntu kernel: [  199.340319] Modules linked in:
intel_rapl snd_hda_codec_realtek x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_hdmi snd_hda_codec_generic coretemp snd_hda_intel
snd_hda_codec kvm snd_hda_core snd_hwdep snd_pcm irqbypass
snd_seq_midi snd_seq_midi_event crct10dif_pclmul snd_rawmidi
crc32_pclmul snd_seq aesni_intel eeepc_wmi snd_seq_device aes_x86_64
asus_wmi input_leds lrw snd_timer sparse_keymap mei_me lpc_ich
serio_raw mei snd gf128mul 8250_fintek soundcore glue_helper shpchp
ablk_helper cryptd tpm_infineon mac_hid parport_pc ppdev lp parport
autofs4 squashfs overlay nls_utf8 isofs hid_generic usbhid hid uas
usb_storage btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log i915 mxm_wmi i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt e1000e fb_sys_fops drm ahci ptp libahci pps_core
fjes wmi video
Jun 16 17:38:12 ubuntu kernel: [  199.340540] CPU: 1 PID: 7602 Comm:
btrfs-balance Not tainted 4.4.0-21-generic #37-Ubuntu
Jun 16 17:38:12 ubuntu kernel: [  199.340558] Hardware name: ASUS All
Series/Z87-PLUS, BIOS 1707 12/13/2013
Jun 16 17:38:12 ubuntu kernel: [  199.340573] task: ffff8804173b3700
ti: ffff8803ec36c000 task.ti: ffff8803ec36c000
Jun 16 17:38:12 ubuntu kernel: [  199.340589] RIP:
0010:[<ffffffffc033be85>]  [<ffffffffc033be85>]
do_relocation+0x515/0x520 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340631] RSP:
0018:ffff8803ec36fb00  EFLAGS: 00010202
Jun 16 17:38:12 ubuntu kernel: [  199.340643] RAX: 0000000000000001
RBX: ffff8800bc72ca80 RCX: 0000000000000000
Jun 16 17:38:12 ubuntu kernel: [  199.340658] RDX: 0000000000000000
RSI: 0000000000000000 RDI: 0000000000000000
Jun 16 17:38:12 ubuntu kernel: [  199.340674] RBP: ffff8803ec36fbb8
R08: ffff8803ec36fab4 R09: 0000160000000000
Jun 16 17:38:12 ubuntu kernel: [  199.340689] R10: 0000000000000002
R11: 0000000000000045 R12: ffff8803ec33f680
Jun 16 17:38:12 ubuntu kernel: [  199.340704] R13: ffff88041b110000
R14: ffff88040026e180 R15: 0000000000000001
Jun 16 17:38:12 ubuntu kernel: [  199.340720] FS:
0000000000000000(0000) GS:ffff88042fa40000(0000)
knlGS:0000000000000000
Jun 16 17:38:12 ubuntu kernel: [  199.340738] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jun 16 17:38:12 ubuntu kernel: [  199.340750] CR2: 0000000001263860
CR3: 0000000001e0a000 CR4: 00000000001406e0
Jun 16 17:38:12 ubuntu kernel: [  199.340766] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 17:38:12 ubuntu kernel: [  199.340781] DR3: 0000000000000000
DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 16 17:38:12 ubuntu kernel: [  199.340796] Stack:
Jun 16 17:38:12 ubuntu kernel: [  199.340801]  0000000000000000
ffff880405bf7920 ffff880415279870 ffff8803ec33f6c0
Jun 16 17:38:12 ubuntu kernel: [  199.340820]  ffff880405bf7800
ffff88040026ece0 0000000100000000 ffff8803ed251be0
Jun 16 17:38:12 ubuntu kernel: [  199.340839]  ffff8803ec36fb40
ffff8803ec36fb40 ffff8800c4956780 ffff88040026e180
Jun 16 17:38:12 ubuntu kernel: [  199.340858] Call Trace:
Jun 16 17:38:12 ubuntu kernel: [  199.340873]  [<ffffffffc02d8a67>] ?
btrfs_block_rsv_refill+0x37/0xb0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340897]  [<ffffffffc033e50e>]
relocate_tree_blocks+0x4ee/0x5f0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340920]  [<ffffffffc0338c1d>] ?
tree_insert+0x4d/0x60 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340940]  [<ffffffffc033c415>] ?
add_tree_block+0x155/0x1e0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340961]  [<ffffffffc033fa7a>]
relocate_block_group+0x41a/0x6c0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.340985]  [<ffffffffc0307860>] ?
btrfs_wait_ordered_roots+0x1d0/0x200 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341008]  [<ffffffffc033fed3>]
btrfs_relocate_block_group+0x1b3/0x290 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341032]  [<ffffffffc0315567>]
btrfs_relocate_chunk.isra.38+0x47/0xd0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341056]  [<ffffffffc03169c9>]
__btrfs_balance+0x5b9/0xba0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341073]  [<ffffffff810d8b59>] ?
vprintk_default+0x29/0x40
Jun 16 17:38:12 ubuntu kernel: [  199.341093]  [<ffffffffc0317240>]
btrfs_balance+0x290/0x5f0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341113]  [<ffffffffc03175fb>]
balance_kthread+0x5b/0x80 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341133]  [<ffffffffc03175a0>] ?
btrfs_balance+0x5f0/0x5f0 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341148]  [<ffffffff810a0528>]
kthread+0xd8/0xf0
Jun 16 17:38:12 ubuntu kernel: [  199.341160]  [<ffffffff810a0450>] ?
kthread_create_on_node+0x1e0/0x1e0
Jun 16 17:38:12 ubuntu kernel: [  199.341176]  [<ffffffff8182488f>]
ret_from_fork+0x3f/0x70
Jun 16 17:38:12 ubuntu kernel: [  199.341188]  [<ffffffff810a0450>] ?
kthread_create_on_node+0x1e0/0x1e0
Jun 16 17:38:12 ubuntu kernel: [  199.341202] Code: fd ff ff 0f 0b 0f
b6 43 70 48 8b b5 58 ff ff ff 48 8d 04 c6 48 8b 10 48 89 53 68 48 c7
00 00 00 00 00 0f b6 53 70 e9 db fe ff ff <0f> 0b 0f 0b e8 b2 4e d4 c0
66 90 0f 1f 44 00 00 55 ba b8 05 00
Jun 16 17:38:12 ubuntu kernel: [  199.341289] RIP
[<ffffffffc033be85>] do_relocation+0x515/0x520 [btrfs]
Jun 16 17:38:12 ubuntu kernel: [  199.341312]  RSP <ffff8803ec36fb00>
Jun 16 17:38:12 ubuntu kernel: [  199.344515] ---[ end trace
b4381932edc4fa48 ]---
Jun 16 17:38:13 ubuntu kernel: [  200.443946] ------------[ cut here
]------------
Jun 16 17:38:13 ubuntu kernel: [  200.443967] WARNING: CPU: 7 PID:
7604 at /build/linux-Ay7j_C/linux-4.4.0/fs/btrfs/extent-tree.c:6543
__btrfs_free_extent.isra.70+0x898/0xd30 [btrfs]()
Jun 16 17:38:13 ubuntu kernel: [  200.443968] Modules linked in:
intel_rapl snd_hda_codec_realtek x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_hdmi snd_hda_codec_generic coretemp snd_hda_intel
snd_hda_codec kvm snd_hda_core snd_hwdep snd_pcm irqbypass
snd_seq_midi snd_seq_midi_event crct10dif_pclmul snd_rawmidi
crc32_pclmul snd_seq aesni_intel eeepc_wmi snd_seq_device aes_x86_64
asus_wmi input_leds lrw snd_timer sparse_keymap mei_me lpc_ich
serio_raw mei snd gf128mul 8250_fintek soundcore glue_helper shpchp
ablk_helper cryptd tpm_infineon mac_hid parport_pc ppdev lp parport
autofs4 squashfs overlay nls_utf8 isofs hid_generic usbhid hid uas
usb_storage btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log i915 mxm_wmi i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt e1000e fb_sys_fops drm ahci ptp libahci pps_core
fjes wmi video
Jun 16 17:38:13 ubuntu kernel: [  200.444000] CPU: 7 PID: 7604 Comm:
ls Tainted: G      D         4.4.0-21-generic #37-Ubuntu
Jun 16 17:38:13 ubuntu kernel: [  200.444001] Hardware name: ASUS All
Series/Z87-PLUS, BIOS 1707 12/13/2013
Jun 16 17:38:13 ubuntu kernel: [  200.444002]  0000000000000286
0000000074438112 ffff8800b959f690 ffffffff813e93c3
Jun 16 17:38:13 ubuntu kernel: [  200.444003]  0000000000000000
ffffffffc036f468 ffff8800b959f6c8 ffffffff81080f62
Jun 16 17:38:13 ubuntu kernel: [  200.444005]  00000005f96c9000
00000000fffffffe 0000000000000000 ffff88041d0c6000
Jun 16 17:38:13 ubuntu kernel: [  200.444006] Call Trace:
Jun 16 17:38:13 ubuntu kernel: [  200.444011]  [<ffffffff813e93c3>]
dump_stack+0x63/0x90
Jun 16 17:38:13 ubuntu kernel: [  200.444014]  [<ffffffff81080f62>]
warn_slowpath_common+0x82/0xc0
Jun 16 17:38:13 ubuntu kernel: [  200.444016]  [<ffffffff810810aa>]
warn_slowpath_null+0x1a/0x20
Jun 16 17:38:13 ubuntu kernel: [  200.444026]  [<ffffffffc02cf458>]
__btrfs_free_extent.isra.70+0x898/0xd30 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444028]  [<ffffffff8119aa75>] ?
__set_page_dirty_nobuffers+0xe5/0x140
Jun 16 17:38:13 ubuntu kernel: [  200.444036]  [<ffffffffc02c9500>] ?
btrfs_previous_extent_item+0x90/0x110 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444044]  [<ffffffffc02d346b>]
__btrfs_run_delayed_refs+0xaab/0x11f0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444052]  [<ffffffffc02d69fd>]
btrfs_run_delayed_refs+0x7d/0x2a0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444062]  [<ffffffffc0308c61>] ?
release_extent_buffer+0x61/0xd0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444071]  [<ffffffffc02eb60a>]
btrfs_should_end_transaction+0x5a/0x60 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444080]  [<ffffffffc02f7017>]
btrfs_truncate_inode_items+0x737/0xd20 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444089]  [<ffffffffc02f8577>]
btrfs_evict_inode+0x477/0x5c0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444092]  [<ffffffff810c3a50>] ?
autoremove_wake_function+0x40/0x40
Jun 16 17:38:13 ubuntu kernel: [  200.444094]  [<ffffffff81227d5e>]
evict+0xbe/0x190
Jun 16 17:38:13 ubuntu kernel: [  200.444096]  [<ffffffff81228041>]
iput+0x1c1/0x240
Jun 16 17:38:13 ubuntu kernel: [  200.444106]  [<ffffffffc02f9117>]
btrfs_orphan_cleanup+0x1f7/0x400 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444116]  [<ffffffffc02f96ae>]
btrfs_lookup_dentry+0x38e/0x520 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444126]  [<ffffffffc02f9852>]
btrfs_lookup+0x12/0x40 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444128]  [<ffffffff8121649d>]
lookup_real+0x1d/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444129]  [<ffffffff81217d62>]
__lookup_hash+0x42/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444131]  [<ffffffff812194d6>]
walk_component+0x226/0x300
Jun 16 17:38:13 ubuntu kernel: [  200.444133]  [<ffffffff8121a61d>]
path_lookupat+0x5d/0x110
Jun 16 17:38:13 ubuntu kernel: [  200.444135]  [<ffffffff8121c291>]
filename_lookup+0xb1/0x180
Jun 16 17:38:13 ubuntu kernel: [  200.444144]  [<ffffffffc02ecdb9>] ?
__btrfs_end_transaction+0x1d9/0x340 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444146]  [<ffffffff811eb137>] ?
kmem_cache_alloc+0x187/0x1f0
Jun 16 17:38:13 ubuntu kernel: [  200.444148]  [<ffffffff8121be96>] ?
getname_flags+0x56/0x1f0
Jun 16 17:38:13 ubuntu kernel: [  200.444150]  [<ffffffff8121c436>]
user_path_at_empty+0x36/0x40
Jun 16 17:38:13 ubuntu kernel: [  200.444151]  [<ffffffff812115e6>]
vfs_fstatat+0x66/0xc0
Jun 16 17:38:13 ubuntu kernel: [  200.444152]  [<ffffffff81211ba1>]
SYSC_newlstat+0x31/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444154]  [<ffffffff81211cde>]
SyS_newlstat+0xe/0x10
Jun 16 17:38:13 ubuntu kernel: [  200.444156]  [<ffffffff818244f2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 16 17:38:13 ubuntu kernel: [  200.444158] ---[ end trace
b4381932edc4fa49 ]---
Jun 16 17:38:13 ubuntu kernel: [  200.444160] BTRFS info (device
sdb5): leaf 515623321600 total ptrs 23 free space 2229
Jun 16 17:38:13 ubuntu kernel: [  200.444161]     item 0 key
(25659432960 168 4096) itemoff 3944 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444162]         extent refs 1
gen 6963944 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444163]         tree block key
(36385751040 168 53248) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444164]         tree block backref root 2
Jun 16 17:38:13 ubuntu kernel: [  200.444165]     item 1 key
(25659437056 168 4096) itemoff 3893 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444166]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444166]         tree block key
(18446744073709551606 128 483529912320) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444167]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444168]     item 2 key
(25659441152 168 4096) itemoff 3842 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444169]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444170]         tree block key
(18446744073709551606 128 483533946880) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444170]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444171]     item 3 key
(25659445248 168 4096) itemoff 3791 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444172]         extent refs 1
gen 6963944 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444173]         tree block key
(36389679104 168 4096) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444173]         tree block backref root 2
Jun 16 17:38:13 ubuntu kernel: [  200.444174]     item 4 key
(25659449344 168 4096) itemoff 3740 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444175]         extent refs 1
gen 331079 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444176]         tree block key
(18446744073709551611 48 797595) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444177]         shared block
backref parent 25719652352
Jun 16 17:38:13 ubuntu kernel: [  200.444178]     item 5 key
(25659453440 168 4096) itemoff 3689 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444178]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444179]         tree block key
(18446744073709551606 128 483537981440) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444180]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444181]     item 6 key
(25659457536 168 4096) itemoff 3638 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444181]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444182]         tree block key
(18446744073709551606 128 483542016000) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444183]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444184]     item 7 key
(25659461632 168 4096) itemoff 3587 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444184]         extent refs 1
gen 6963944 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444185]         tree block key
(36394369024 168 8192) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444186]         tree block backref root 2
Jun 16 17:38:13 ubuntu kernel: [  200.444187]     item 8 key
(25659465728 168 4096) itemoff 3536 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444187]         extent refs 1
gen 1250494 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444188]         tree block key
(77172 96 424) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444189]         shared block
backref parent 202993840128
Jun 16 17:38:13 ubuntu kernel: [  200.444190]     item 9 key
(25659469824 168 4096) itemoff 3485 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444190]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444191]         tree block key
(18446744073709551606 128 483546050560) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444192]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444193]     item 10 key
(25659473920 168 4096) itemoff 3434 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444193]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444194]         tree block key
(18446744073709551606 128 483550085120) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444195]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444195]     item 11 key
(25659478016 168 4096) itemoff 3383 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444196]         extent refs 1
gen 6963944 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444197]         tree block key
(36394938368 168 106496) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444197]         tree block
backref root 281474976710658
Jun 16 17:38:13 ubuntu kernel: [  200.444198]     item 12 key
(25659482112 168 4096) itemoff 3332 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444199]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444200]         tree block key
(18446744073709551606 128 483554119680) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444200]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444201]     item 13 key
(25659486208 168 4096) itemoff 3272 itemsize 60
Jun 16 17:38:13 ubuntu kernel: [  200.444202]         extent refs 2
gen 1999492 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444203]         tree block key
(13164463 1 0) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444203]         shared block
backref parent 515618316288
Jun 16 17:38:13 ubuntu kernel: [  200.444204]         shared block
backref parent 75169234944
Jun 16 17:38:13 ubuntu kernel: [  200.444205]     item 14 key
(25659490304 168 4096) itemoff 3221 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444206]         extent refs 1
gen 331079 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444207]         tree block key
(18446744073709551611 48 795747) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444207]         shared block
backref parent 25719652352
Jun 16 17:38:13 ubuntu kernel: [  200.444208]     item 15 key
(25659502592 168 4096) itemoff 3170 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444209]         extent refs 1
gen 331079 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444210]         tree block key
(18446744073709551611 48 797595) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444210]         shared block
backref parent 25719652352
Jun 16 17:38:13 ubuntu kernel: [  200.444211]     item 16 key
(25659506688 168 4096) itemoff 3119 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444212]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444213]         tree block key
(18446744073709551606 128 483558154240) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444214]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444214]     item 17 key
(25659510784 168 4096) itemoff 3068 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444215]         extent refs 1
gen 7097652 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444216]         tree block key
(18446744073709551606 128 483562188800) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444216]         tree block backref root 7
Jun 16 17:38:13 ubuntu kernel: [  200.444217]     item 18 key
(25659514880 168 4096) itemoff 3008 itemsize 60
Jun 16 17:38:13 ubuntu kernel: [  200.444217]         extent refs 2
gen 1824756 flags 2
Jun 16 17:38:13 ubuntu kernel: [  200.444218]         tree block key
(12691756 1 0) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444219]         shared block
backref parent 515636400128
Jun 16 17:38:13 ubuntu kernel: [  200.444219]         shared block
backref parent 297494913024
Jun 16 17:38:13 ubuntu kernel: [  200.444220]     item 19 key
(25659518976 168 4096) itemoff 2957 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444221]         extent refs 1
gen 331079 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444222]         tree block key
(18446744073709551611 48 795747) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444223]         shared block
backref parent 25719652352
Jun 16 17:38:13 ubuntu kernel: [  200.444224]     item 20 key
(25659523072 168 4096) itemoff 2906 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444224]         extent refs 1
gen 636672 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444225]         tree block key
(101100 96 2199) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444226]         shared block
backref parent 75175694336
Jun 16 17:38:13 ubuntu kernel: [  200.444227]     item 21 key
(25659531264 168 4096) itemoff 2855 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444228]         extent refs 1
gen 636672 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444228]         tree block key
(101100 96 2258) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444229]         shared block
backref parent 75175694336
Jun 16 17:38:13 ubuntu kernel: [  200.444230]     item 22 key
(25659535360 168 4096) itemoff 2804 itemsize 51
Jun 16 17:38:13 ubuntu kernel: [  200.444231]         extent refs 1
gen 331079 flags 258
Jun 16 17:38:13 ubuntu kernel: [  200.444231]         tree block key
(18446744073709551611 48 797595) level 0
Jun 16 17:38:13 ubuntu kernel: [  200.444232]         shared block
backref parent 25719652352
Jun 16 17:38:13 ubuntu kernel: [  200.444234] BTRFS error (device
sdb5): unable to find ref byte nr 25659478016 parent 0 root 2  owner 0
offset 0
Jun 16 17:38:13 ubuntu kernel: [  200.444234] ------------[ cut here
]------------
Jun 16 17:38:13 ubuntu kernel: [  200.444243] WARNING: CPU: 7 PID:
7604 at /build/linux-Ay7j_C/linux-4.4.0/fs/btrfs/extent-tree.c:6549
__btrfs_free_extent.isra.70+0x8ff/0xd30 [btrfs]()
Jun 16 17:38:13 ubuntu kernel: [  200.444243] BTRFS: Transaction
aborted (error -2)
Jun 16 17:38:13 ubuntu kernel: [  200.444244] Modules linked in:
intel_rapl snd_hda_codec_realtek x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_hdmi snd_hda_codec_generic coretemp snd_hda_intel
snd_hda_codec kvm snd_hda_core snd_hwdep snd_pcm irqbypass
snd_seq_midi snd_seq_midi_event crct10dif_pclmul snd_rawmidi
crc32_pclmul snd_seq aesni_intel eeepc_wmi snd_seq_device aes_x86_64
asus_wmi input_leds lrw snd_timer sparse_keymap mei_me lpc_ich
serio_raw mei snd gf128mul 8250_fintek soundcore glue_helper shpchp
ablk_helper cryptd tpm_infineon mac_hid parport_pc ppdev lp parport
autofs4 squashfs overlay nls_utf8 isofs hid_generic usbhid hid uas
usb_storage btrfs xor raid6_pq nls_iso8859_1 dm_mirror dm_region_hash
dm_log i915 mxm_wmi i2c_algo_bit drm_kms_helper syscopyarea
sysfillrect sysimgblt e1000e fb_sys_fops drm ahci ptp libahci pps_core
fjes wmi video
Jun 16 17:38:13 ubuntu kernel: [  200.444268] CPU: 7 PID: 7604 Comm:
ls Tainted: G      D W       4.4.0-21-generic #37-Ubuntu
Jun 16 17:38:13 ubuntu kernel: [  200.444269] Hardware name: ASUS All
Series/Z87-PLUS, BIOS 1707 12/13/2013
Jun 16 17:38:13 ubuntu kernel: [  200.444269]  0000000000000286
0000000074438112 ffff8800b959f638 ffffffff813e93c3
Jun 16 17:38:13 ubuntu kernel: [  200.444271]  ffff8800b959f680
ffffffffc036f468 ffff8800b959f670 ffffffff81080f62
Jun 16 17:38:13 ubuntu kernel: [  200.444273]  00000005f96c9000
00000000fffffffe 0000000000000000 ffff88041d0c6000
Jun 16 17:38:13 ubuntu kernel: [  200.444274] Call Trace:
Jun 16 17:38:13 ubuntu kernel: [  200.444276]  [<ffffffff813e93c3>]
dump_stack+0x63/0x90
Jun 16 17:38:13 ubuntu kernel: [  200.444278]  [<ffffffff81080f62>]
warn_slowpath_common+0x82/0xc0
Jun 16 17:38:13 ubuntu kernel: [  200.444279]  [<ffffffff81080ffc>]
warn_slowpath_fmt+0x5c/0x80
Jun 16 17:38:13 ubuntu kernel: [  200.444287]  [<ffffffffc02cf4bf>]
__btrfs_free_extent.isra.70+0x8ff/0xd30 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444289]  [<ffffffff8119aa75>] ?
__set_page_dirty_nobuffers+0xe5/0x140
Jun 16 17:38:13 ubuntu kernel: [  200.444297]  [<ffffffffc02c9500>] ?
btrfs_previous_extent_item+0x90/0x110 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444305]  [<ffffffffc02d346b>]
__btrfs_run_delayed_refs+0xaab/0x11f0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444313]  [<ffffffffc02d69fd>]
btrfs_run_delayed_refs+0x7d/0x2a0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444324]  [<ffffffffc0308c61>] ?
release_extent_buffer+0x61/0xd0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444333]  [<ffffffffc02eb60a>]
btrfs_should_end_transaction+0x5a/0x60 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444342]  [<ffffffffc02f7017>]
btrfs_truncate_inode_items+0x737/0xd20 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444353]  [<ffffffffc02f8577>]
btrfs_evict_inode+0x477/0x5c0 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444355]  [<ffffffff810c3a50>] ?
autoremove_wake_function+0x40/0x40
Jun 16 17:38:13 ubuntu kernel: [  200.444356]  [<ffffffff81227d5e>]
evict+0xbe/0x190
Jun 16 17:38:13 ubuntu kernel: [  200.444358]  [<ffffffff81228041>]
iput+0x1c1/0x240
Jun 16 17:38:13 ubuntu kernel: [  200.444367]  [<ffffffffc02f9117>]
btrfs_orphan_cleanup+0x1f7/0x400 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444377]  [<ffffffffc02f96ae>]
btrfs_lookup_dentry+0x38e/0x520 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444387]  [<ffffffffc02f9852>]
btrfs_lookup+0x12/0x40 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444388]  [<ffffffff8121649d>]
lookup_real+0x1d/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444390]  [<ffffffff81217d62>]
__lookup_hash+0x42/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444392]  [<ffffffff812194d6>]
walk_component+0x226/0x300
Jun 16 17:38:13 ubuntu kernel: [  200.444393]  [<ffffffff8121a61d>]
path_lookupat+0x5d/0x110
Jun 16 17:38:13 ubuntu kernel: [  200.444395]  [<ffffffff8121c291>]
filename_lookup+0xb1/0x180
Jun 16 17:38:13 ubuntu kernel: [  200.444404]  [<ffffffffc02ecdb9>] ?
__btrfs_end_transaction+0x1d9/0x340 [btrfs]
Jun 16 17:38:13 ubuntu kernel: [  200.444406]  [<ffffffff811eb137>] ?
kmem_cache_alloc+0x187/0x1f0
Jun 16 17:38:13 ubuntu kernel: [  200.444408]  [<ffffffff8121be96>] ?
getname_flags+0x56/0x1f0
Jun 16 17:38:13 ubuntu kernel: [  200.444410]  [<ffffffff8121c436>]
user_path_at_empty+0x36/0x40
Jun 16 17:38:13 ubuntu kernel: [  200.444411]  [<ffffffff812115e6>]
vfs_fstatat+0x66/0xc0
Jun 16 17:38:13 ubuntu kernel: [  200.444412]  [<ffffffff81211ba1>]
SYSC_newlstat+0x31/0x60
Jun 16 17:38:13 ubuntu kernel: [  200.444413]  [<ffffffff81211cde>]
SyS_newlstat+0xe/0x10
Jun 16 17:38:13 ubuntu kernel: [  200.444415]  [<ffffffff818244f2>]
entry_SYSCALL_64_fastpath+0x16/0x71
Jun 16 17:38:13 ubuntu kernel: [  200.444416] ---[ end trace
b4381932edc4fa4a ]---
Jun 16 17:38:13 ubuntu kernel: [  200.444418] BTRFS: error (device
sdb5) in __btrfs_free_extent:6549: errno=-2 No such entry
Jun 16 17:38:13 ubuntu kernel: [  200.444419] BTRFS info (device
sdb5): forced readonly
Jun 16 17:38:13 ubuntu kernel: [  200.444420] BTRFS: error (device
sdb5) in btrfs_run_delayed_refs:2927: errno=-2 No such entry
Jun 16 17:38:13 ubuntu kernel: [  200.444430] BTRFS error (device
sdb5): Error removing orphan entry, stopping orphan cleanup
Jun 16 17:38:13 ubuntu kernel: [  200.444431] BTRFS error (device
sdb5): could not do orphan cleanup -22

2016-06-15 8:42 GMT+02:00 Fajar A. Nugraha <list@fajar.net>:
> On Wed, Jun 15, 2016 at 1:29 PM, Paul Verreth <paul@verreth.be> wrote:
>> Dear all.
>>
>> When I download a video using  Firefox DownloadHelper addon, the
>> filesystem suddenly turns read only. Not a coincedence, I tried it
>> several times, and it happened every time again
>>
>> Info:
>> Linux wolfgang 4.2.0-35-generic #40-Ubuntu SMP Tue Mar 15 22:15:45 UTC
>> 2016 x86_64 x86_64 x86_64 GNU/Linux
>
>> Segmentation fault
>>
>> Jun  5 15:03:15 ubuntu kernel: [ 2062.544303] BTRFS info (device
>> sdb5): relocating block group 383447465984 flags 17
>
>
>> What can I do to repair this problem?
>
> The usual starting advice would be "try with latest kernel and see if
> you can still reproduce the problem". Is it ubuntu wily? It'd go end
> of in July anyway, so you might want to upgrade to xenial (or at
> least, just the kernel, for the purpose of troubleshooting your
> problem).
>
> Or even try http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/
> (should be usable, but might report some errors/warning due to missing
> ubuntu patches)
>
> --
> Fajar



-- 

Paul Verreth

Het verschil tussen theorie en praktijk
is klein in theorie,
maar in praktijk daarentegen ...
