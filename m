Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:33159 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3BDHld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 02:41:33 -0500
Received: from lampka.siedziba.pl (localhost.graciarnia [127.0.0.1])
	by zlom.siedziba.pl (Postfix) with ESMTPA id 7F87E82D7E4
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2013 08:41:27 +0100 (CET)
Message-ID: <69d32024cba2f7912082b19a18e0d49f.squirrel@lampka.siedziba.pl>
In-Reply-To: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
Date: Mon, 4 Feb 2013 08:41:27 +0100
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1755 (was: 1772)
From: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I also tried for-linus branch, looks like the same problem:

# mount /dev/hdb -odevice=/dev/hdc /mnt/test
device label root devid 2 transid 56098 /dev/hdc
device label root devid 1 transid 56098 /dev/hdb
btrfs: disk space caching is enabled
------------[ cut here ]------------
WARNING: at fs/btrfs/delayed-ref.c:454 update_existing_ref+0xd2/0x110()
Hardware name: Bochs
Pid: 305, comm: exe Not tainted 3.7.0+ #1
Call Trace:
 [<c10202b8>] warn_slowpath_common+0x68/0xa0
 [<c1176712>] ? update_existing_ref+0xd2/0x110
 [<c1176712>] ? update_existing_ref+0xd2/0x110
 [<c102039b>] warn_slowpath_null+0x1b/0x20
 [<c1176712>] update_existing_ref+0xd2/0x110
 [<c1176c0b>] add_delayed_tree_ref+0x12b/0x160
 [<c1177688>] btrfs_add_delayed_tree_ref+0xf8/0x180
 [<c111fbd5>] btrfs_free_extent+0x125/0x1a0
 [<c11795e4>] replace_path+0x6d4/0x770
 [<c114a037>] ? btrfs_get_token_64+0x57/0x110
 [<c117df43>] merge_reloc_root+0x293/0x4e0
 [<c117e276>] merge_reloc_roots+0xe6/0x120
 [<c117f2b4>] btrfs_recover_relocation+0x384/0x3f0
 [<c1131fde>] open_ctree+0x18be/0x1a60
 [<c112c2d0>] ? btrfs_alloc_root+0x40/0x40
 [<c11b09dd>] ? strlcpy+0x1d/0x110
 [<c110c4b7>] btrfs_mount+0x677/0x850
 [<c11ad4ad>] ? ida_get_new_above+0x1ed/0x220
 [<c1081310>] ? __kmalloc_track_caller+0x70/0x130
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c1085acc>] mount_fs+0x1c/0xc0
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c109b0a4>] vfs_kern_mount+0x44/0xd0
 [<c109b197>] do_kern_mount+0x37/0xf0
 [<c109c594>] do_mount+0x3b4/0x700
 [<c109c946>] sys_mount+0x66/0xa0
 [<c122b2f5>] syscall_call+0x7/0xb
---[ end trace 4c5c7c49fa61dfab ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1755!
invalid opcode: 0000 [#1]
Pid: 305, comm: exe Tainted: G        W    3.7.0+ #1 Bochs Bochs
EIP: 0060:[<c111a7fc>] EFLAGS: 00010297 CPU: 0
EIP is at insert_inline_extent_backref+0x13c/0x140
EAX: 00000000 EBX: 00000000 ECX: d751c070 EDX: 00000000
ESI: 00000000 EDI: 00000002 EBP: d790dabc ESP: d790da68
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: 08053000 CR3: 178e4000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process exe (pid: 305, ti=d790c000 task=d7902fa0 task.ti=d790c000)
Stack:
 d790daac 90e31000 00000125 00001000 00000000 1be77000 000000c8 00000000
 00000000 00000002 00000000 00000000 00000000 00000001 d751c070 d78dec00
 d74233c0 00000ecb 00000125 d751c070 d7230000 d790db28 c111a8a8 90e31000
Call Trace:
 [<c111a8a8>] __btrfs_inc_extent_ref+0xa8/0x240
 [<c11207a1>] run_clustered_refs+0x501/0xb00
 [<c1177517>] ? btrfs_find_ref_cluster+0xd7/0x150
 [<c11244ce>] btrfs_run_delayed_refs+0x8e/0x250
 [<c113419a>] __btrfs_end_transaction+0xaa/0x3b0
 [<c11344bd>] btrfs_end_transaction_throttle+0xd/0x10
 [<c117dee6>] merge_reloc_root+0x236/0x4e0
 [<c117e276>] merge_reloc_roots+0xe6/0x120
 [<c117f2b4>] btrfs_recover_relocation+0x384/0x3f0
 [<c1131fde>] open_ctree+0x18be/0x1a60
 [<c112c2d0>] ? btrfs_alloc_root+0x40/0x40
 [<c11b09dd>] ? strlcpy+0x1d/0x110
 [<c110c4b7>] btrfs_mount+0x677/0x850
 [<c11ad4ad>] ? ida_get_new_above+0x1ed/0x220
 [<c1081310>] ? __kmalloc_track_caller+0x70/0x130
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c1085acc>] mount_fs+0x1c/0xc0
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c109b0a4>] vfs_kern_mount+0x44/0xd0
 [<c109b197>] do_kern_mount+0x37/0xf0
 [<c109c594>] do_mount+0x3b4/0x700
 [<c109c946>] sys_mount+0x66/0xa0
 [<c122b2f5>] syscall_call+0x7/0xb
Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 15
f9 ff ff eb 8a 8d 76 00 81 ff ff 00 00 00 0f 87 59 ff ff ff <0f> 0b 66 90
55 89 e5 57 89 d7 56 53 83 ec 58 8b 5d 28 89 45 ec
EIP: [<c111a7fc>] insert_inline_extent_backref+0x13c/0x140 SS:ESP
0068:d790da68
---[ end trace 4c5c7c49fa61dfac ]---
Segmentation fault
/ # ------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1755!
invalid opcode: 0000 [#2]
Pid: 326, comm: btrfs-transacti Tainted: G      D W    3.7.0+ #1 Bochs Bochs
EIP: 0060:[<c111a7fc>] EFLAGS: 00010297 CPU: 0
EIP is at insert_inline_extent_backref+0x13c/0x140
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 00000002 EBP: d720bd40 ESP: d720bcec
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7779000 CR3: 178fa000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process btrfs-transacti (pid: 326, ti=d720a000 task=d7208000
task.ti=d720a000)
Stack:
 d720bd30 57175000 000000ef 00001000 00000000 1be77000 000000c8 00000000
 00000000 00000002 00000000 00000000 00000000 00000001 d751c4d0 d78dec00
 d7423420 0000098e 000000ef d751c4d0 d78de800 d720bdac c111a8a8 57175000
Call Trace:
 [<c111a8a8>] __btrfs_inc_extent_ref+0xa8/0x240
 [<c11207a1>] run_clustered_refs+0x501/0xb00
 [<c1177517>] ? btrfs_find_ref_cluster+0xd7/0x150
 [<c11244ce>] btrfs_run_delayed_refs+0x8e/0x250
 [<c1133809>] btrfs_commit_transaction+0x69/0x920
 [<c1040e80>] ? update_curr.constprop.48+0x50/0xa0
 [<c107fc8a>] ? kmem_cache_alloc+0x5a/0xf0
 [<c11345be>] ? start_transaction+0xee/0x3e0
 [<c1134540>] ? start_transaction+0x70/0x3e0
 [<c1037a80>] ? abort_exclusive_wait+0x60/0x60
 [<c112c435>] transaction_kthread+0x165/0x1a0
 [<c112c2d0>] ? btrfs_alloc_root+0x40/0x40
 [<c103726e>] kthread+0x8e/0xa0
 [<c122b717>] ret_from_kernel_thread+0x1b/0x28
 [<c10371e0>] ? __kthread_parkme+0x60/0x60
Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 15
f9 ff ff eb 8a 8d 76 00 81 ff ff 00 00 00 0f 87 59 ff ff ff <0f> 0b 66 90
55 89 e5 57 89 d7 56 53 83 ec 58 8b 5d 28 89 45 ec
EIP: [<c111a7fc>] insert_inline_extent_backref+0x13c/0x140 SS:ESP
0068:d720bcec
---[ end trace 4c5c7c49fa61dfad ]---

fs/btrfs/extent-tree.c:1755 is, again:

1755                 BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);

Regards

