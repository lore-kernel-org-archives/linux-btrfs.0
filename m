Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42366 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbcEBSS4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 14:18:56 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: vegard.nossum@oracle.com, sterba@suse.com
Subject: [PATCH 3/3] Btrfs-progs: add fuzz testing images
Date: Mon,  2 May 2016 11:18:55 -0700
Message-Id: <1462213135-29678-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
References: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds 4 fuzz testing images, btrfsck either doesn't detect errors
in them or crashes immediately.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
Note: The *.txt file contains "trailing whitespace" errors due to
 the panic information.

 .../images/superblock-stripsize-bogus.raw.txt      |  32 ++++++++++++
 .../images/superblock-stripsize-bogus.raw.xz       | Bin 0 -> 41512 bytes
 .../images/superblock-total-bytes-0.raw.txt        |  50 +++++++++++++++++++
 .../images/superblock-total-bytes-0.raw.xz         | Bin 0 -> 41424 bytes
 .../images/sys-chunk-stripe-len-bogus.raw.txt      |  54 ++++++++++++++++++++
 .../images/sys-chunk-stripe-len-bogus.raw.xz       | Bin 0 -> 41440 bytes
 .../fuzz-tests/images/sys-chunk-type-bogus.raw.txt |  55 +++++++++++++++++++++
 .../fuzz-tests/images/sys-chunk-type-bogus.raw.xz  | Bin 0 -> 41524 bytes
 8 files changed, 191 insertions(+)
 create mode 100644 tests/fuzz-tests/images/superblock-stripsize-bogus.raw.txt
 create mode 100644 tests/fuzz-tests/images/superblock-stripsize-bogus.raw.xz
 create mode 100644 tests/fuzz-tests/images/superblock-total-bytes-0.raw.txt
 create mode 100644 tests/fuzz-tests/images/superblock-total-bytes-0.raw.xz
 create mode 100644 tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.txt
 create mode 100644 tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.xz
 create mode 100644 tests/fuzz-tests/images/sys-chunk-type-bogus.raw.txt
 create mode 100644 tests/fuzz-tests/images/sys-chunk-type-bogus.raw.xz

diff --git a/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.txt b/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.txt
new file mode 100644
index 0000000..80e073f
--- /dev/null
+++ b/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.txt
@@ -0,0 +1,32 @@
+[  125.415910] BTRFS info (device loop0): disk space caching is enabled
+[  125.550479] ------------[ cut here ]------------
+[  125.551145] WARNING: CPU: 6 PID: 1496 at fs/btrfs/locking.c:251 btrfs_tree_lock+0x22e/0x250
+[  125.552292] Modules linked in:
+[  125.552602] CPU: 6 PID: 1496 Comm: btrfs.exe Tainted: G        W       4.6.0-rc5 #130
+[  125.553138] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
+[  125.553775]  0000000000000286 000000009b4bdd50 ffff88006a7478e0 ffffffff8157e563
+[  125.554299]  0000000000000000 0000000000000000 ffff88006a747920 ffffffff810a74ab
+[  125.554825]  000000fb8146c531 ffff88006bfec460 ffff88006bc63000 0000000000000000
+[  125.555373] Call Trace:
+[  125.555545]  [<ffffffff8157e563>] dump_stack+0x85/0xc2
+[  125.555892]  [<ffffffff810a74ab>] __warn+0xcb/0xf0
+[  125.556226]  [<ffffffff810a75dd>] warn_slowpath_null+0x1d/0x20
+[  125.556654]  [<ffffffff814871ee>] btrfs_tree_lock+0x22e/0x250
+[  125.557041]  [<ffffffff81423831>] btrfs_init_new_buffer+0x81/0x160
+[  125.557458]  [<ffffffff8143472a>] btrfs_alloc_tree_block+0x22a/0x430
+[  125.557883]  [<ffffffff8141ae61>] __btrfs_cow_block+0x141/0x590
+[  125.558279]  [<ffffffff8141b44f>] btrfs_cow_block+0x11f/0x1f0
+[  125.558666]  [<ffffffff8141f09e>] btrfs_search_slot+0x1fe/0xa30
+[  125.559063]  [<ffffffff81247c9d>] ? kmem_cache_alloc+0xfd/0x240
+[  125.559482]  [<ffffffff8143b1f0>] btrfs_del_inode_ref+0x80/0x380
+[  125.559884]  [<ffffffff8148e11a>] ? btrfs_del_inode_ref_in_log+0x8a/0x160
+[  125.560340]  [<ffffffff8148e14d>] btrfs_del_inode_ref_in_log+0xbd/0x160
+[  125.560776]  [<ffffffff814507f7>] __btrfs_unlink_inode+0x1d7/0x470
+[  125.561188]  [<ffffffff814567a7>] btrfs_rename2+0x327/0x790
+[  125.561568]  [<ffffffff8127b398>] vfs_rename+0x4d8/0x840
+[  125.561928]  [<ffffffff81281b21>] SyS_rename+0x371/0x390
+[  125.562289]  [<ffffffff819cfd3c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
+[  125.562743] ---[ end trace 3b751f511705fb90 ]---
+
+---------------------------------------------------------------------------
+Fixed by patch:
diff --git a/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.xz b/tests/fuzz-tests/images/superblock-stripsize-bogus.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..f8b3bf54f26ff602853b8c73748f0a13943de991
GIT binary patch
literal 41512
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
F{szo>qe=h(

literal 0
HcmV?d00001

diff --git a/tests/fuzz-tests/images/superblock-total-bytes-0.raw.txt b/tests/fuzz-tests/images/superblock-total-bytes-0.raw.txt
new file mode 100644
index 0000000..d5e1f93
--- /dev/null
+++ b/tests/fuzz-tests/images/superblock-total-bytes-0.raw.txt
@@ -0,0 +1,50 @@
+[342246.846031] BTRFS info (device loop0): disk space caching is enabled
+[342246.862115] ------------[ cut here ]------------
+[342246.862500] kernel BUG at fs/btrfs/inode.c:978!
+[342246.862861] invalid opcode: 0000 [#1] SMP 
+[342246.863176] Modules linked in:
+[342246.863410] CPU: 2 PID: 14504 Comm: btrfs.exe Tainted: G        W       4.6.0-rc5 #130
+[342246.864010] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
+[342246.864674] task: ffff88006fdf0000 ti: ffff8800702e0000 task.ti: ffff8800702e0000
+[342246.865186] RIP: 0010:[<ffffffff8144e9c7>]  [<ffffffff8144e9c7>] cow_file_range+0x3f7/0x440
+[342246.865770] RSP: 0018:ffff8800702e39e0  EFLAGS: 00010206
+[342246.866157] RAX: ffff88006bb23000 RBX: 0000000000000001 RCX: 0000000000010000
+[342246.866687] RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000010000
+[342246.867191] RBP: ffff8800702e3a70 R08: 0000000000000000 R09: 0000000000000000
+[342246.867682] R10: 000000000000ffff R11: 0000000000010000 R12: ffff8800702e3bc0
+[342246.868170] R13: ffff8800702e3b3c R14: 0000000000000000 R15: ffff880075369c10
+[342246.868660] FS:  00007f96f5a38700(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
+[342246.869212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[342246.869642] CR2: 000000000060f4bf CR3: 000000006fc9f000 CR4: 00000000000006e0
+[342246.870146] Stack:
+[342246.870295]  0000000000000000 0000000000000001 000000000000ffff ffffea00010c08c0
+[342246.870838]  ffff8800753698e8 0000000000010000 ffff88006fe0f000 000000000000ffff
+[342246.871397]  000000000000ffff ffffffff814683e5 ffff8800753698c8 ffff8800753698e8
+[342246.871944] Call Trace:
+[342246.872124]  [<ffffffff814683e5>] ? test_range_bit+0xe5/0x130
+[342246.872522]  [<ffffffff8144f906>] run_delalloc_range+0x396/0x3d0
+[342246.872975]  [<ffffffff8146873f>] writepage_delalloc.isra.42+0x10f/0x170
+[342246.873437]  [<ffffffff8146a674>] __extent_writepage+0xf4/0x370
+[342246.873848]  [<ffffffff8146abf4>] extent_write_cache_pages.isra.39.constprop.57+0x304/0x3f0
+[342246.874419]  [<ffffffff8146beec>] extent_writepages+0x5c/0x90
+[342246.874818]  [<ffffffff8144c870>] ? btrfs_real_readdir+0x5f0/0x5f0
+[342246.875245]  [<ffffffff814498f8>] btrfs_writepages+0x28/0x30
+[342246.875641]  [<ffffffff811ebc61>] do_writepages+0x21/0x30
+[342246.876031]  [<ffffffff811dc1a6>] __filemap_fdatawrite_range+0xc6/0x100
+[342246.876487]  [<ffffffff811dc2b3>] filemap_fdatawrite_range+0x13/0x20
+[342246.876949]  [<ffffffff8145eae0>] btrfs_fdatawrite_range+0x20/0x50
+[342246.877375]  [<ffffffff8145eb29>] start_ordered_ops+0x19/0x30
+[342246.877774]  [<ffffffff8145ebc2>] btrfs_sync_file+0x82/0x3f0
+[342246.878166]  [<ffffffff810fb717>] ? update_fast_ctr+0x17/0x30
+[342246.878564]  [<ffffffff812a848b>] vfs_fsync_range+0x4b/0xb0
+[342246.878987]  [<ffffffff8128fce6>] ? __fget_light+0x66/0x90
+[342246.879368]  [<ffffffff812a854d>] do_fsync+0x3d/0x70
+[342246.879708]  [<ffffffff812a8823>] SyS_fdatasync+0x13/0x20
+[342246.880099]  [<ffffffff819cfd3c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
+[342246.880554] Code: 03 00 00 48 c7 c7 00 b3 c9 81 c6 05 54 b6 b1 00 01 e8 0e 8c c5 ff e9 e5 fe ff ff 49 8b 57 40 e9 c0 fe ff ff bb f4 ff ff ff eb a1 <0f> 0b 48 8b 55 80 41 b9 0f 00 00 00 41 b8 68 00 00 00 31 c9 31 
+[342246.882394] RIP  [<ffffffff8144e9c7>] cow_file_range+0x3f7/0x440
+[342246.882810]  RSP <ffff8800702e39e0>
+[342246.883076] ---[ end trace 094193b6df6e45e7 ]---
+
+--------------------------------------------------------
+Fixed by patch: 
diff --git a/tests/fuzz-tests/images/superblock-total-bytes-0.raw.xz b/tests/fuzz-tests/images/superblock-total-bytes-0.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..4b25020e44f56937a01f4f35764bf8e18e810f44
GIT binary patch
literal 41424
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
Z|8|ie5NFb^ZXP_WAV!Ax+eL0>{%?c(anb+)

literal 0
HcmV?d00001

diff --git a/tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.txt b/tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.txt
new file mode 100644
index 0000000..d3dcb0a
--- /dev/null
+++ b/tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.txt
@@ -0,0 +1,54 @@
+[  135.166891] BTRFS info (device loop0): disk space caching is enabled
+[  135.169199] divide error: 0000 [#1] SMP 
+[  135.169581] Modules linked in:
+[  135.169819] CPU: 2 PID: 1512 Comm: btrfs.exe Tainted: G        W       4.6.0-rc5 #130
+[  135.170285] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
+[  135.170958] task: ffff880074925180 ti: ffff880077fa4000 task.ti: ffff880077fa4000
+[  135.171583] RIP: 0010:[<ffffffff81475ba0>]  [<ffffffff81475ba0>] __btrfs_map_block+0xc0/0x11b0
+[  135.172096] RSP: 0000:ffff880077fa77b0  EFLAGS: 00010206
+[  135.172374] RAX: 0000000000020000 RBX: 0000000000020000 RCX: 0000000000000000
+[  135.172754] RDX: 0000000000000000 RSI: 0000000000400000 RDI: ffff880076258270
+[  135.173143] RBP: ffff880077fa7898 R08: 0000000000400000 R09: 0000000000000000
+[  135.173523] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000020000
+[  135.173916] R13: ffff880076258270 R14: ffff880077fa78e0 R15: ffff88006bb3b000
+[  135.174290] FS:  00007fd8267dc700(0000) GS:ffff88007ca00000(0000) knlGS:0000000000000000
+[  135.174718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  135.175019] CR2: 00007ffe9c378df7 CR3: 0000000078788000 CR4: 00000000000006e0
+[  135.175392] Stack:
+[  135.175503]  ffff88007cbe2c40 0000000000000000 ffff88007cbe2c50 ffff880074925180
+[  135.175924]  ffff880074926560 ffff880074925180 0000000200000000 0000000000000000
+[  135.176340]  ffffffffffffffff 0007ffffffffffff ffffffff8143eb18 0240004000000000
+[  135.176778] Call Trace:
+[  135.176913]  [<ffffffff8143eb18>] ? btrfs_bio_wq_end_io+0x28/0x70
+[  135.177234]  [<ffffffff81477218>] btrfs_map_bio+0x88/0x350
+[  135.177522]  [<ffffffff8143eb18>] ? btrfs_bio_wq_end_io+0x28/0x70
+[  135.177960]  [<ffffffff8143ed9d>] btree_submit_bio_hook+0x6d/0x110
+[  135.178410]  [<ffffffff81464d1d>] submit_one_bio+0x6d/0xa0
+[  135.178814]  [<ffffffff8146d6f1>] read_extent_buffer_pages+0x1c1/0x350
+[  135.179276]  [<ffffffff8143cd60>] ? free_root_pointers+0x70/0x70
+[  135.179708]  [<ffffffff8143e12c>] btree_read_extent_buffer_pages.constprop.55+0xac/0x110
+[  135.180261]  [<ffffffff8143f036>] read_tree_block+0x36/0x60
+[  135.180647]  [<ffffffff81443b52>] open_ctree+0x17a2/0x2900
+[  135.181027]  [<ffffffff81417225>] btrfs_mount+0xd05/0xe60
+[  135.181400]  [<ffffffff819cd15a>] ? __mutex_unlock_slowpath+0xfa/0x1c0
+[  135.181850]  [<ffffffff810fd3e4>] ? lockdep_init_map+0x64/0x710
+[  135.182241]  [<ffffffff81272918>] mount_fs+0x38/0x170
+[  135.182609]  [<ffffffff81292b7b>] vfs_kern_mount+0x6b/0x150
+[  135.182998]  [<ffffffff814166e6>] btrfs_mount+0x1c6/0xe60
+[  135.183372]  [<ffffffff819cd15a>] ? __mutex_unlock_slowpath+0xfa/0x1c0
+[  135.183825]  [<ffffffff810fd3e4>] ? lockdep_init_map+0x64/0x710
+[  135.184233]  [<ffffffff81272918>] mount_fs+0x38/0x170
+[  135.184583]  [<ffffffff81292b7b>] vfs_kern_mount+0x6b/0x150
+[  135.184971]  [<ffffffff812958c6>] do_mount+0x256/0xeb0
+[  135.185318]  [<ffffffff8124bb33>] ? __kmalloc_track_caller+0x113/0x290
+[  135.185759]  [<ffffffff812b0b63>] ? block_ioctl+0x43/0x50
+[  135.186124]  [<ffffffff811ff023>] ? memdup_user+0x53/0x80
+[  135.186488]  [<ffffffff81296865>] SyS_mount+0x95/0xe0
+[  135.186877]  [<ffffffff819cfd3c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
+[  135.187308] Code: 8b 70 20 4c 8d 04 31 4c 39 c3 0f 87 2f 0b 00 00 48 8b 45 a8 49 89 dc 31 d2 49 29 cc 48 8b 40 70 48 63 48 10 48 89 45 a0 4c 89 e0 <48> f7 f1 49 89 cf 48 89 45 b8 48 0f af c1 49 39 c4 0f 82 c3 0a 
+[  135.189097] RIP  [<ffffffff81475ba0>] __btrfs_map_block+0xc0/0x11b0
+[  135.189527]  RSP <ffff880077fa77b0>
+[  135.189819] ---[ end trace ea21fae64670799a ]---
+
+---------------------------------------------------------------------------
+Fixed by patch:
diff --git a/tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.xz b/tests/fuzz-tests/images/sys-chunk-stripe-len-bogus.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..57d2a72f9dce40bfc02c3c82d480bd3fd7910150
GIT binary patch
literal 41440
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
MmVf>M-6_j|01}6Uxc~qF

literal 0
HcmV?d00001

diff --git a/tests/fuzz-tests/images/sys-chunk-type-bogus.raw.txt b/tests/fuzz-tests/images/sys-chunk-type-bogus.raw.txt
new file mode 100644
index 0000000..2559924
--- /dev/null
+++ b/tests/fuzz-tests/images/sys-chunk-type-bogus.raw.txt
@@ -0,0 +1,55 @@
+[  145.676440] BTRFS error (device loop0): bad tree block start 0 131072
+[  145.677032] ------------[ cut here ]------------
+[  145.677307] kernel BUG at fs/btrfs/raid56.c:2142!
+[  145.677627] invalid opcode: 0000 [#1] SMP 
+[  145.677955] Modules linked in:
+[  145.678182] CPU: 3 PID: 1538 Comm: btrfs.exe Tainted: G        W       4.6.0-rc5 #130
+[  145.678734] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
+[  145.679402] task: ffff88006c830000 ti: ffff88006fc74000 task.ti: ffff88006fc74000
+[  145.679919] RIP: 0010:[<ffffffff814c5794>]  [<ffffffff814c5794>] raid56_parity_recover+0xc4/0x160
+[  145.680514] RSP: 0018:ffff88006fc77868  EFLAGS: 00010286
+[  145.680865] RAX: ffff88006f725280 RBX: ffff880070ba0a68 RCX: 0000000000020000
+[  145.681373] RDX: 0000000000000100 RSI: 00000000ffffffff RDI: ffffffff831229e8
+[  145.681866] RBP: ffff88006fc77898 R08: 0000000000010000 R09: ffff8800768ff400
+[  145.682380] R10: ffff88007c003180 R11: 0000000000030000 R12: ffff88006f725280
+[  145.682870] R13: ffff88007b449000 R14: 0000000000000001 R15: ffff8800768ff400
+[  145.683363] FS:  00007f68b95a8700(0000) GS:ffff88007cc00000(0000) knlGS:0000000000000000
+[  145.683941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  145.684340] CR2: 00007fff0d130f98 CR3: 000000006bfd7000 CR4: 00000000000006e0
+[  145.684832] Stack:
+[  145.684977]  00000002e6816dd1 ffff880070ba0a68 ffff88007b449000 0000000000000001
+[  145.685541]  0000000000020000 0000000000000002 ffff88006fc77920 ffffffff814773cd
+[  145.686082]  ffff880000000001 0000000002400040 ffff88006fc778f8 0000000081247c9d
+[  145.686654] Call Trace:
+[  145.686831]  [<ffffffff814773cd>] btrfs_map_bio+0x23d/0x350
+[  145.687217]  [<ffffffff8143ed9d>] btree_submit_bio_hook+0x6d/0x110
+[  145.687649]  [<ffffffff81464d1d>] submit_one_bio+0x6d/0xa0
+[  145.688028]  [<ffffffff8146d6f1>] read_extent_buffer_pages+0x1c1/0x350
+[  145.688501]  [<ffffffff8143cd60>] ? free_root_pointers+0x70/0x70
+[  145.688916]  [<ffffffff8143e12c>] btree_read_extent_buffer_pages.constprop.55+0xac/0x110
+[  145.689474]  [<ffffffff8143f036>] read_tree_block+0x36/0x60
+[  145.689861]  [<ffffffff81443b52>] open_ctree+0x17a2/0x2900
+[  145.690242]  [<ffffffff81417225>] btrfs_mount+0xd05/0xe60
+[  145.690623]  [<ffffffff819cd15a>] ? __mutex_unlock_slowpath+0xfa/0x1c0
+[  145.691064]  [<ffffffff810fd3e4>] ? lockdep_init_map+0x64/0x710
+[  145.691510]  [<ffffffff81272918>] mount_fs+0x38/0x170
+[  145.691852]  [<ffffffff81292b7b>] vfs_kern_mount+0x6b/0x150
+[  145.692227]  [<ffffffff814166e6>] btrfs_mount+0x1c6/0xe60
+[  145.692594]  [<ffffffff819cd15a>] ? __mutex_unlock_slowpath+0xfa/0x1c0
+[  145.693032]  [<ffffffff810fd3e4>] ? lockdep_init_map+0x64/0x710
+[  145.693453]  [<ffffffff81272918>] mount_fs+0x38/0x170
+[  145.693793]  [<ffffffff81292b7b>] vfs_kern_mount+0x6b/0x150
+[  145.694168]  [<ffffffff812958c6>] do_mount+0x256/0xeb0
+[  145.694537]  [<ffffffff8124bb33>] ? __kmalloc_track_caller+0x113/0x290
+[  145.694974]  [<ffffffff812b0b63>] ? block_ioctl+0x43/0x50
+[  145.695338]  [<ffffffff811ff023>] ? memdup_user+0x53/0x80
+[  145.695703]  [<ffffffff81296865>] SyS_mount+0x95/0xe0
+[  145.696046]  [<ffffffff819cfd3c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
+[  145.696480] Code: 1f 48 8b 78 58 31 c0 48 8b 14 c7 48 39 d1 72 08 4c 01 c2 48 39 d1 72 15 48 83 c0 01 39 c6 7f e7 41 c7 87 3c 01 00 00 ff ff ff ff <0f> 0b 45 85 f6 41 89 87 3c 01 00 00 75 35 4c 89 e7 e8 e6 02 fb 
+[  145.698326] RIP  [<ffffffff814c5794>] raid56_parity_recover+0xc4/0x160
+[  145.698771]  RSP <ffff88006fc77868>
+[  145.699047] ---[ end trace 22f39f01df276367 ]---
+
+-----------------------------------------------------
+Fixed by patch: 
+
diff --git a/tests/fuzz-tests/images/sys-chunk-type-bogus.raw.xz b/tests/fuzz-tests/images/sys-chunk-type-bogus.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..ef971ca3b12f5e9f4a9abb2264512aa95b136e61
GIT binary patch
literal 41524
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
C!<0(^

literal 0
HcmV?d00001

-- 
2.5.0

