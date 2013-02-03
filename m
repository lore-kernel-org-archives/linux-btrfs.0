Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:56794 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3BCXiD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 18:38:03 -0500
Received: from lampka.siedziba.pl (localhost.graciarnia [127.0.0.1])
	by zlom.siedziba.pl (Postfix) with ESMTPA id F080A887D89
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2013 00:37:58 +0100 (CET)
Message-ID: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
Date: Mon, 4 Feb 2013 00:37:58 +0100
Subject: kernel BUG at fs/btrfs/extent-tree.c:1772
From: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

1 week ago I bought a new 2TB hard drive, created 1 partition on the whole
disk, and created root and swap LVM volumes on it. I formatted root to
btrfs with default options, except meta-data profile which I set to
"single". I copied all my data to it and unplugged my old hard drives. It
worked for a week.

Today I installed another 2TB hard drive, created LVM volumes as before,
and added to my root filesystem. I started balance with data and metadata
conversion to raid1. I left it doing its job, and returned few hours
later. When I returned hard disks were idle, screen would not unlock, and
I could not log in. I had to reset it.

After reset it won't mount. I booted the computer from a live-cd. It has
an ancient kernel, so I installed qemu and captured the oops on the
current version compiled from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git:

# mount /dev/hdb /mnt/test -odevice=/dev/hdc
device label root devid 2 transid 56098 /dev/hdc
device label root devid 1 transid 56098 /dev/hdb
btrfs: disk space caching is enabled
------------[ cut here ]------------
WARNING: at fs/btrfs/delayed-ref.c:454 update_existing_ref+0xd2/0x110()
Hardware name: Bochs
Pid: 309, comm: exe Not tainted 3.6.0+ #1
Call Trace:
 [<c101f4b8>] warn_slowpath_common+0x68/0xa0
 [<c1171362>] ? update_existing_ref+0xd2/0x110
 [<c1171362>] ? update_existing_ref+0xd2/0x110
 [<c101f59b>] warn_slowpath_null+0x1b/0x20
 [<c1171362>] update_existing_ref+0xd2/0x110
 [<c117185b>] add_delayed_tree_ref+0x12b/0x160
 [<c11722d8>] btrfs_add_delayed_tree_ref+0xf8/0x180
 [<c111d6f5>] btrfs_free_extent+0x125/0x1a0
 [<c1174234>] replace_path+0x6d4/0x770
 [<c1146457>] ? btrfs_get_token_64+0x57/0x110
 [<c1178bdc>] merge_reloc_root+0x2ac/0x4f0
 [<c1178f06>] merge_reloc_roots+0xe6/0x120
 [<c1179ee4>] btrfs_recover_relocation+0x384/0x3f0
 [<c112ecd5>] open_ctree+0x1695/0x1940
 [<c1129270>] ? cleaner_kthread+0xb0/0xb0
 [<c11a84dd>] ? strlcpy+0x1d/0x110
 [<c1109b27>] btrfs_mount+0x677/0x850
 [<c11a4bbd>] ? ida_get_new_above+0x1ed/0x220
 [<c107ee60>] ? __kmalloc_track_caller+0x70/0x130
 [<c1098712>] ? alloc_vfsmnt+0x62/0x100
 [<c108388c>] mount_fs+0x1c/0xc0
 [<c1098712>] ? alloc_vfsmnt+0x62/0x100
 [<c1099314>] vfs_kern_mount+0x44/0xd0
 [<c1099407>] do_kern_mount+0x37/0xf0
 [<c109a804>] do_mount+0x3b4/0x700
 [<c109abb6>] sys_mount+0x66/0xa0
 [<c1221a45>] syscall_call+0x7/0xb
---[ end trace 0437071747fbcc24 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1772!
invalid opcode: 0000 [#1]
Pid: 309, comm: exe Tainted: G        W    3.6.0+ #1 Bochs Bochs
EIP: 0060:[<c1117aec>] EFLAGS: 00010297 CPU: 0
EIP is at insert_inline_extent_backref+0x13c/0x140
EAX: 00000000 EBX: 00000000 ECX: d742b0e0 EDX: 00000000
ESI: 00000000 EDI: 00000002 EBP: d790dabc ESP: d790da68
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: 08053000 CR3: 178fd000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process exe (pid: 309, ti=d790c000 task=d7902fa0 task.ti=d790c000)
Stack:
 d790daac 90e31000 00000125 00001000 00000000 1be77000 000000c8 00000000
 00000000 00000002 00000000 00000000 00000000 00000001 d742b0e0 d78dec00
 d74233c0 00000ecb 00000125 d742b0e0 d722c000 d790db28 c1117b98 90e31000
Call Trace:
 [<c1117b98>] __btrfs_inc_extent_ref+0xa8/0x240
 [<c111e2c1>] run_clustered_refs+0x501/0xaa0
 [<c1172167>] ? btrfs_find_ref_cluster+0xd7/0x150
 [<c112159e>] btrfs_run_delayed_refs+0x8e/0x250
 [<c1130f1a>] __btrfs_end_transaction+0xaa/0x3b0
 [<c113123d>] btrfs_end_transaction_throttle+0xd/0x10
 [<c1178b72>] merge_reloc_root+0x242/0x4f0
 [<c1178f06>] merge_reloc_roots+0xe6/0x120
 [<c1179ee4>] btrfs_recover_relocation+0x384/0x3f0
 [<c112ecd5>] open_ctree+0x1695/0x1940
 [<c1129270>] ? cleaner_kthread+0xb0/0xb0
 [<c11a84dd>] ? strlcpy+0x1d/0x110
 [<c1109b27>] btrfs_mount+0x677/0x850
 [<c11a4bbd>] ? ida_get_new_above+0x1ed/0x220
 [<c107ee60>] ? __kmalloc_track_caller+0x70/0x130
 [<c1098712>] ? alloc_vfsmnt+0x62/0x100
 [<c108388c>] mount_fs+0x1c/0xc0
 [<c1098712>] ? alloc_vfsmnt+0x62/0x100
 [<c1099314>] vfs_kern_mount+0x44/0xd0
 [<c1099407>] do_kern_mount+0x37/0xf0
 [<c109a804>] do_mount+0x3b4/0x700
 [<c109abb6>] sys_mount+0x66/0xa0
 [<c1221a45>] syscall_call+0x7/0xb
Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 15
f9 ff ff eb 8a 8d 76 00 81 ff ff 00 00 00 0f 87 59 ff ff ff <0f> 0b 66 90
55 89 e5 57 89 d7 56 53 83 ec 58 8b 5d 28 89 45 ec
EIP: [<c1117aec>] insert_inline_extent_backref+0x13c/0x140 SS:ESP
0068:d790da68
---[ end trace 0437071747fbcc25 ]---
Segmentation fault
/ # ------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1772!
invalid opcode: 0000 [#2]
Pid: 329, comm: btrfs-transacti Tainted: G      D W    3.6.0+ #1 Bochs Bochs
EIP: 0060:[<c1117aec>] EFLAGS: 00010297 CPU: 0
EIP is at insert_inline_extent_backref+0x13c/0x140
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: 00000002 EBP: d7207d88 ESP: d7207d34
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: b77a8000 CR3: 178f9000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process btrfs-transacti (pid: 329, ti=d7206000 task=d794dc20
task.ti=d7206000)
Stack:
 d7207d78 57175000 000000ef 00001000 00000000 1be77000 000000c8 00000000
 00000000 00000002 00000000 00000000 00000000 00000001 d742b150 d78dec00
 d7423420 0000098e 000000ef d742b150 d78de800 d7207df4 c1117b98 57175000
Call Trace:
 [<c1117b98>] __btrfs_inc_extent_ref+0xa8/0x240
 [<c111e2c1>] run_clustered_refs+0x501/0xaa0
 [<c1172167>] ? btrfs_find_ref_cluster+0xd7/0x150
 [<c112159e>] btrfs_run_delayed_refs+0x8e/0x250
 [<c1130571>] btrfs_commit_transaction+0x71/0x940
 [<c107d66a>] ? kmem_cache_alloc+0x5a/0xf0
 [<c113132e>] ? start_transaction+0xde/0x3d0
 [<c1036b50>] ? abort_exclusive_wait+0x60/0x60
 [<c11293d5>] transaction_kthread+0x165/0x1a0
 [<c1129270>] ? cleaner_kthread+0xb0/0xb0
 [<c10364ac>] kthread+0x6c/0x80
 [<c1036440>] ? kthread_flush_work_fn+0x10/0x10
 [<c1222416>] kernel_thread_helper+0x6/0xd
Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 15
f9 ff ff eb 8a 8d 76 00 81 ff ff 00 00 00 0f 87 59 ff ff ff <0f> 0b 66 90
55 89 e5 57 89 d7 56 53 83 ec 58 8b 5d 28 89 45 ec
EIP: [<c1117aec>] insert_inline_extent_backref+0x13c/0x140 SS:ESP
0068:d7207d34
---[ end trace 0437071747fbcc26 ]---

Reported line is:
1772                 BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);

btrfsck doesn't find anything wrong with the FS:

checking extents
checking fs roots
checking root refs
found 814959656960 bytes used err is 0
total csum bytes: 788550204
total tree bytes: 7330582528
total fs tree bytes: 5939347456
btree space waste bytes: 1823524971
file data blocks allocated: 7249231036416
 referenced 873999015936
Btrfs v0.20-rc1-56-g6cd836d

I tried mounting with -orecovery, clean_cache, skip_balance, nothing
helps. I can, however, mount it read-only.

Other info about the fs:

# btrfs fi show
Label: 'root'  uuid: 8b7a0276-d331-478c-b829-7614f2e7dc6a
	Total devices 2 FS bytes used 758.99GB
	devid    2 size 1.81TB used 554.03GB path /dev/hdc
	devid    1 size 1.81TB used 766.04GB path /dev/hdb

# btrfs fi df /mnt/test
Data, RAID1: total=544.00GB, used=543.33GB
Data: total=209.00GB, used=208.83GB
System, RAID1: total=32.00MB, used=92.00KB
System: total=4.00MB, used=20.00KB
Metadata, RAID1: total=10.00GB, used=4.62GB
Metadata: total=3.00GB, used=2.21GB

Regards

