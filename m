Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:58746 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422646AbaJaAaQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 20:30:16 -0400
Received: by mail-yh0-f51.google.com with SMTP id c41so2186986yho.38
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 17:30:15 -0700 (PDT)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Fri, 31 Oct 2014 01:29:55 +0100
Message-ID: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
Subject: filesystem corruption
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I was using a btrfs RAID1 with two disks under Ubuntu 14.04, kernel
3.13 and btrfs-tools 3.14.1 for weeks without issues.

Now I updated to kernel 3.17.1 and btrfs-tools 3.17. After a reboot
everything looked fine and I started some tests. While running
duperemover (just scanning, not doing anything) and a balance at the
same time the load suddenly went up to >30 and the system was not
responding anymore. Everyhting working with the filesystem stopped
responding. So I did a hard reset.

I was able to reboot, but on the login prompt nothing happened but a
kernel bug. Same back in kernel 3.13.

Now I started a live system (Ubuntu 14.10, kernel 3.16.x, btrfs-tools
3.14.1), and mounted the btrfs filesystem. I can browse through the
files but sometimes, especially when accessing my snapshots or trying
to create a new snapshot, the kernel bug appears and the filesystem
hangs.

It shows this:
Oct 31 00:09:14 ubuntu kernel: [  187.661731] ------------[ cut here
]------------
Oct 31 00:09:14 ubuntu kernel: [  187.661770] WARNING: CPU: 1 PID:
4417 at /build/buildd/linux-3.16.0/fs/btrfs/relocation.c:924
build_backref_tree+0xcab/0x1240 [btrfs]()
Oct 31 00:09:14 ubuntu kernel: [  187.661772] Modules linked in:
nls_iso8859_1 dm_crypt gpio_ich coretemp lpc_ich kvm_intel kvm
dm_multipath scsi_dh serio_raw xgifb(C) bnep rfcomm bluetooth
6lowpan_iphc i3000_edac edac_core parport_pc mac_hid ppdev shpchp lp
parport squashfs overlayfs nls_utf8 isofs btrfs xor raid6_pq dm_mirror
dm_region_hash dm_log hid_generic usbhid hid uas usb_storage ahci
e1000e libahci ptp pps_core
Oct 31 00:09:14 ubuntu kernel: [  187.661800] CPU: 1 PID: 4417 Comm:
btrfs-balance Tainted: G         C    3.16.0-23-generic #31-Ubuntu
Oct 31 00:09:14 ubuntu kernel: [  187.661802] Hardware name:
Supermicro PDSML/PDSML+, BIOS 6.00 03/06/2009
Oct 31 00:09:14 ubuntu kernel: [  187.661804]  0000000000000009
ffff8800a0ae7a00 ffffffff8177fcbc 0000000000000000
Oct 31 00:09:14 ubuntu kernel: [  187.661807]  ffff8800a0ae7a38
ffffffff8106fd8d ffff8800a1440750 ffff8800a1440b48
Oct 31 00:09:14 ubuntu kernel: [  187.661809]  ffff88020a8ce000
0000000000000001 ffff88020b6b0d00 ffff8800a0ae7a48
Oct 31 00:09:14 ubuntu kernel: [  187.661812] Call Trace:
Oct 31 00:09:14 ubuntu kernel: [  187.661820]  [<ffffffff8177fcbc>]
dump_stack+0x45/0x56
Oct 31 00:09:14 ubuntu kernel: [  187.661825]  [<ffffffff8106fd8d>]
warn_slowpath_common+0x7d/0xa0
Oct 31 00:09:14 ubuntu kernel: [  187.661827]  [<ffffffff8106fe6a>]
warn_slowpath_null+0x1a/0x20
Oct 31 00:09:14 ubuntu kernel: [  187.661842]  [<ffffffffc01b734b>]
build_backref_tree+0xcab/0x1240 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661857]  [<ffffffffc01b7ae1>]
relocate_tree_blocks+0x201/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661872]  [<ffffffffc01b88d8>] ?
add_data_references+0x268/0x2a0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661887]  [<ffffffffc01b96fd>]
relocate_block_group+0x25d/0x6b0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661902]  [<ffffffffc01b9d36>]
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661916]  [<ffffffffc0190988>]
btrfs_relocate_chunk.isra.27+0x58/0x720 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661926]  [<ffffffffc0140dc1>] ?
btrfs_set_path_blocking+0x41/0x80 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661935]  [<ffffffffc0145dfd>] ?
btrfs_search_slot+0x48d/0xa40 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661950]  [<ffffffffc018b49b>] ?
release_extent_buffer+0x2b/0xd0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661964]  [<ffffffffc018b95f>] ?
free_extent_buffer+0x4f/0xa0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661979]  [<ffffffffc01936c3>]
__btrfs_balance+0x4d3/0x8d0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.661993]  [<ffffffffc0193d48>]
btrfs_balance+0x288/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.662008]  [<ffffffffc019411d>]
balance_kthread+0x5d/0x80 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.662022]  [<ffffffffc01940c0>] ?
btrfs_balance+0x600/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.662026]  [<ffffffff81094aeb>]
kthread+0xdb/0x100
Oct 31 00:09:14 ubuntu kernel: [  187.662029]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:09:14 ubuntu kernel: [  187.662032]  [<ffffffff81787c3c>]
ret_from_fork+0x7c/0xb0
Oct 31 00:09:14 ubuntu kernel: [  187.662035]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:09:14 ubuntu kernel: [  187.662037] ---[ end trace
fb7849e4a6f20424 ]---

end this:
Oct 31 00:09:14 ubuntu kernel: [  187.682629] ------------[ cut here
]------------
Oct 31 00:09:14 ubuntu kernel: [  187.682635] kernel BUG at
/build/buildd/linux-3.16.0/fs/btrfs/extent-tree.c:868!
Oct 31 00:09:14 ubuntu kernel: [  187.682638] invalid opcode: 0000 [#1] SMP
Oct 31 00:09:14 ubuntu kernel: [  187.682642] Modules linked in:
nls_iso8859_1 dm_crypt gpio_ich coretemp lpc_ich kvm_intel kvm
dm_multipath scsi_dh serio_raw xgifb(C) bnep rfcomm bluetooth
6lowpan_iphc i3000_edac edac_core parport_pc mac_hid ppdev shpchp lp
parport squashfs overlayfs nls_utf8 isofs btrfs xor raid6_pq dm_mirror
dm_region_hash dm_log hid_generic usbhid hid uas usb_storage ahci
e1000e libahci ptp pps_core
Oct 31 00:09:14 ubuntu kernel: [  187.682686] CPU: 1 PID: 4417 Comm:
btrfs-balance Tainted: G        WC    3.16.0-23-generic #31-Ubuntu
Oct 31 00:09:14 ubuntu kernel: [  187.682688] Hardware name:
Supermicro PDSML/PDSML+, BIOS 6.00 03/06/2009
Oct 31 00:09:14 ubuntu kernel: [  187.682690] task: ffff8801bb5728c0
ti: ffff8800a0ae4000 task.ti: ffff8800a0ae4000
Oct 31 00:09:14 ubuntu kernel: [  187.682691] RIP:
0010:[<ffffffffc0150609>]  [<ffffffffc0150609>]
btrfs_lookup_extent_info+0x469/0x4a0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682704] RSP:
0018:ffff8800a0ae7810  EFLAGS: 00010246
Oct 31 00:09:14 ubuntu kernel: [  187.682706] RAX: 0000000000000000
RBX: ffff8800a1440b40 RCX: 000000129457c000
Oct 31 00:09:14 ubuntu kernel: [  187.682708] RDX: ffff8801ab1be3c0
RSI: 000000129457c000 RDI: ffff8801ab1be428
Oct 31 00:09:14 ubuntu kernel: [  187.682709] RBP: ffff8800a0ae7898
R08: ffff8801ab1be3c0 R09: 0000160000000000
Oct 31 00:09:14 ubuntu kernel: [  187.682711] R10: 0000000000000000
R11: 000000000000003a R12: ffff8801ab1be428
Oct 31 00:09:14 ubuntu kernel: [  187.682713] R13: 000000129457c000
R14: ffff8801b8800be0 R15: 0000000000000000
Oct 31 00:09:14 ubuntu kernel: [  187.682715] FS:
0000000000000000(0000) GS:ffff880217c80000(0000)
knlGS:0000000000000000
Oct 31 00:09:14 ubuntu kernel: [  187.682717] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Oct 31 00:09:14 ubuntu kernel: [  187.682718] CR2: 0000000000ed3970
CR3: 0000000208e63000 CR4: 00000000000007e0
Oct 31 00:09:14 ubuntu kernel: [  187.682720] Stack:
Oct 31 00:09:14 ubuntu kernel: [  187.682721]  ffff8800a0ae78c0
0000000000000000 0000000000000000 ffff8801ab1be3c0
Oct 31 00:09:14 ubuntu kernel: [  187.682724]  ffff8801b88be1b0
ffff8801ab1be3c0 ffff8801ab1be400 c0008801b8a45720
Oct 31 00:09:14 ubuntu kernel: [  187.682727]  00a8000000129457
ff00000000000040 ffffffffc01570d1 0000000000000001
Oct 31 00:09:14 ubuntu kernel: [  187.682730] Call Trace:
Oct 31 00:09:14 ubuntu kernel: [  187.682742]  [<ffffffffc01570d1>] ?
btrfs_alloc_free_block+0x3a1/0x470 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682751]  [<ffffffffc01416f4>]
update_ref_for_cow+0x174/0x360 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682761]  [<ffffffffc0141afd>]
__btrfs_cow_block+0x21d/0x510 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682770]  [<ffffffffc0141f86>]
btrfs_cow_block+0x116/0x1b0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682779]  [<ffffffffc0145b44>]
btrfs_search_slot+0x1d4/0xa40 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682791]  [<ffffffffc01677ad>] ?
record_root_in_trans+0xad/0x120 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682807]  [<ffffffffc01b64f3>]
do_relocation+0x3c3/0x570 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682817]  [<ffffffffc0152878>] ?
btrfs_block_rsv_refill+0x48/0xa0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682832]  [<ffffffffc01b7e35>]
relocate_tree_blocks+0x555/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682847]  [<ffffffffc01b88d8>] ?
add_data_references+0x268/0x2a0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682862]  [<ffffffffc01b96fd>]
relocate_block_group+0x25d/0x6b0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682876]  [<ffffffffc01b9d36>]
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682891]  [<ffffffffc0190988>]
btrfs_relocate_chunk.isra.27+0x58/0x720 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682900]  [<ffffffffc0140dc1>] ?
btrfs_set_path_blocking+0x41/0x80 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682909]  [<ffffffffc0145dfd>] ?
btrfs_search_slot+0x48d/0xa40 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682924]  [<ffffffffc018b49b>] ?
release_extent_buffer+0x2b/0xd0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682938]  [<ffffffffc018b95f>] ?
free_extent_buffer+0x4f/0xa0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682953]  [<ffffffffc01936c3>]
__btrfs_balance+0x4d3/0x8d0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682968]  [<ffffffffc0193d48>]
btrfs_balance+0x288/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682982]  [<ffffffffc019411d>]
balance_kthread+0x5d/0x80 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.682997]  [<ffffffffc01940c0>] ?
btrfs_balance+0x600/0x600 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.683001]  [<ffffffff81094aeb>]
kthread+0xdb/0x100
Oct 31 00:09:14 ubuntu kernel: [  187.683004]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:09:14 ubuntu kernel: [  187.683007]  [<ffffffff81787c3c>]
ret_from_fork+0x7c/0xb0
Oct 31 00:09:14 ubuntu kernel: [  187.683010]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:09:14 ubuntu kernel: [  187.683011] Code: be b0 00 00 00 48
c7 c7 90 77 1e c0 48 89 55 a8 e8 5d f8 f1 c0 48 8b 55 a8 e9 2e fe ff
ff 0f 0b 48 83 7d 88 00 0f 85 8d fe ff ff <0f> 0b 31 c0 e9 de fe ff ff
be 6c 03 00 00 48 c7 c7 28 77 1e c0
Oct 31 00:09:14 ubuntu kernel: [  187.683040] RIP
[<ffffffffc0150609>] btrfs_lookup_extent_info+0x469/0x4a0 [btrfs]
Oct 31 00:09:14 ubuntu kernel: [  187.683050]  RSP <ffff8800a0ae7810>
Oct 31 00:09:14 ubuntu kernel: [  187.683052] ---[ end trace
fb7849e4a6f20425 ]---

Then it keeps repeating this:
Oct 31 00:10:07 ubuntu kernel: [  240.100001] BUG: soft lockup - CPU#2
stuck for 22s! [btrfs-transacti:4416]
Oct 31 00:10:07 ubuntu kernel: [  240.100001] Modules linked in:
nls_iso8859_1 dm_crypt gpio_ich coretemp lpc_ich kvm_intel kvm
dm_multipath scsi_dh serio_raw xgifb(C) bnep rfcomm bluetooth
6lowpan_iphc i3000_edac edac_core parport_pc mac_hid ppdev shpchp lp
parport squashfs overlayfs nls_utf8 isofs btrfs xor raid6_pq dm_mirror
dm_region_hash dm_log hid_generic usbhid hid uas usb_storage ahci
e1000e libahci ptp pps_core
Oct 31 00:10:07 ubuntu kernel: [  240.100001] CPU: 2 PID: 4416 Comm:
btrfs-transacti Tainted: G      D WC    3.16.0-23-generic #31-Ubuntu
Oct 31 00:10:07 ubuntu kernel: [  240.100001] Hardware name:
Supermicro PDSML/PDSML+, BIOS 6.00 03/06/2009
Oct 31 00:10:07 ubuntu kernel: [  240.100001] task: ffff8800a23b1460
ti: ffff8801ba8f8000 task.ti: ffff8801ba8f8000
Oct 31 00:10:07 ubuntu kernel: [  240.100001] RIP:
0010:[<ffffffff81787712>]  [<ffffffff81787712>]
_raw_spin_lock+0x32/0x50
Oct 31 00:10:07 ubuntu kernel: [  240.100001] RSP:
0018:ffff8801ba8fbcc8  EFLAGS: 00000202
Oct 31 00:10:07 ubuntu kernel: [  240.100001] RAX: 0000000000004a52
RBX: 0000000000014800 RCX: 0000000000008c82
Oct 31 00:10:07 ubuntu kernel: [  240.100001] RDX: 0000000000008c84
RSI: 0000000000008c84 RDI: ffff8801b88be1b0
Oct 31 00:10:07 ubuntu kernel: [  240.100001] RBP: ffff8801ba8fbcc8
R08: 00000000008dd0e4 R09: 000000002ac4f29b
Oct 31 00:10:07 ubuntu kernel: [  240.100001] R10: 000000929da8c524
R11: 0000000000000020 R12: ffff88020c32c800
Oct 31 00:10:07 ubuntu kernel: [  240.100001] R13: ffff88020c32c808
R14: 0000000200000003 R15: ffff880217d8e4e0
Oct 31 00:10:07 ubuntu kernel: [  240.100001] FS:
0000000000000000(0000) GS:ffff880217d00000(0000)
knlGS:0000000000000000
Oct 31 00:10:07 ubuntu kernel: [  240.100001] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Oct 31 00:10:07 ubuntu kernel: [  240.100001] CR2: 00007fffa496afd8
CR3: 00000002084dd000 CR4: 00000000000007e0
Oct 31 00:10:07 ubuntu kernel: [  240.100001] Stack:
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  ffff8801ba8fbdf0
ffffffffc0153e02 ffffffff810abb55 ffff8800e14532f0
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  ffff8800e1453358
ffff8800a23b14c8 ffff8801ba8fbd60 ffff8801ba8fbd50
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  ffffffff81011661
0000000000014800 ffff880217d11c40 ffff8800a23b1a50
Oct 31 00:10:07 ubuntu kernel: [  240.100001] Call Trace:
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc0153e02>]
__btrfs_run_delayed_refs+0x1e2/0x11e0 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff810abb55>] ?
set_next_entity+0x95/0xb0
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff81011661>] ?
__switch_to+0x191/0x5e0
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff8107dd8a>] ?
del_timer_sync+0x4a/0x60
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc0158df3>]
btrfs_run_delayed_refs.part.64+0x73/0x270 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc0159007>]
btrfs_run_delayed_refs+0x17/0x20 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc0169269>]
btrfs_commit_transaction+0x29/0x80 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc016527d>]
transaction_kthread+0x1ed/0x260 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffffc0165090>] ?
btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff81094aeb>]
kthread+0xdb/0x100
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff81787c3c>]
ret_from_fork+0x7c/0xb0
Oct 31 00:10:07 ubuntu kernel: [  240.100001]  [<ffffffff81094a10>] ?
kthread_create_on_node+0x1c0/0x1c0
Oct 31 00:10:07 ubuntu kernel: [  240.100001] Code: 89 e5 b8 00 00 02
00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 75 04 5d c3 66 90 83 e2 fe 0f
b7 f2 b8 00 80 00 00 eb 0a 0f 1f 00 f3 90 <83> e8 01 74 0a 0f b7 0f 66
39 ca 75 f1 5d c3 66 66 66 90 66 66


Any ideas how to fix this filesystem? I do have backups, but I am
interested in finding out what happened and what to do.

Regards
Tobias
