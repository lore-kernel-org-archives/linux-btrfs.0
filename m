Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56976 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3H0QLl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 12:11:41 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so2315916wid.6
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 09:11:40 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sbehrens@giantdisaster.de, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix deadlock in uuid scan kthread
Date: Tue, 27 Aug 2013 17:11:29 +0100
Message-Id: <1377619889-12272-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1377618715-30476-1-git-send-email-fdmanana@gmail.com>
References: <1377618715-30476-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there's an ongoing transaction when the uuid scan kthread attempts
to create one, the kthread will block, waiting for that transaction to
finish while it's keeping locks on the tree root, and in turn the existing
transaction is waiting for those locks to be free.

The stack trace reported by the kernel follows.

[36700.671601] INFO: task btrfs-uuid:15480 blocked for more than 120 seconds.
[36700.671602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36700.671602] btrfs-uuid      D 0000000000000000     0 15480      2 0x00000000
[36700.671604]  ffff880710bd5b88 0000000000000046 ffff8803d36ba850 0000000000030000
[36700.671605]  ffff8806d76dc530 ffff880710bd5fd8 ffff880710bd5fd8 ffff880710bd5fd8
[36700.671607]  ffff8808098ac530 ffff8806d76dc530 ffff880710bd5b98 ffff8805e4508e40
[36700.671608] Call Trace:
[36700.671610]  [<ffffffff816f36b9>] schedule+0x29/0x70
[36700.671620]  [<ffffffffa05a3bdf>] wait_current_trans.isra.33+0xbf/0x120 [btrfs]
[36700.671623]  [<ffffffff81066760>] ? add_wait_queue+0x60/0x60
[36700.671629]  [<ffffffffa05a5b06>] start_transaction+0x3d6/0x530 [btrfs]
[36700.671636]  [<ffffffffa05bb1f4>] ? btrfs_get_token_32+0x64/0xf0 [btrfs]
[36700.671642]  [<ffffffffa05a5fbb>] btrfs_start_transaction+0x1b/0x20 [btrfs]
[36700.671649]  [<ffffffffa05c8a81>] btrfs_uuid_scan_kthread+0x211/0x3d0 [btrfs]
[36700.671655]  [<ffffffffa05c8870>] ? __btrfs_open_devices+0x2a0/0x2a0 [btrfs]
[36700.671657]  [<ffffffff81065fa0>] kthread+0xc0/0xd0
[36700.671659]  [<ffffffff81065ee0>] ? flush_kthread_worker+0xb0/0xb0
[36700.671661]  [<ffffffff816fcd1c>] ret_from_fork+0x7c/0xb0
[36700.671662]  [<ffffffff81065ee0>] ? flush_kthread_worker+0xb0/0xb0
[36700.671663] INFO: task btrfs:15481 blocked for more than 120 seconds.
[36700.671664] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[36700.671665] btrfs           D 0000000000000000     0 15481  15212 0x00000004
[36700.671666]  ffff880248cbf4c8 0000000000000086 ffff8803d36ba700 ffff8801dbd5c280
[36700.671668]  ffff880807815c40 ffff880248cbffd8 ffff880248cbffd8 ffff880248cbffd8
[36700.671669]  ffff8805e86a0000 ffff880807815c40 ffff880248cbf4d8 ffff8801dbd5c280
[36700.671670] Call Trace:
[36700.671672]  [<ffffffff816f36b9>] schedule+0x29/0x70
[36700.671679]  [<ffffffffa05d9b0d>] btrfs_tree_lock+0x6d/0x230 [btrfs]
[36700.671680]  [<ffffffff81066760>] ? add_wait_queue+0x60/0x60
[36700.671685]  [<ffffffffa0582829>] btrfs_search_slot+0x999/0xb00 [btrfs]
[36700.671691]  [<ffffffffa05bd9de>] ? btrfs_lookup_first_ordered_extent+0x5e/0xb0 [btrfs]
[36700.671698]  [<ffffffffa05e3e54>] __btrfs_write_out_cache+0x8c4/0xa80 [btrfs]
[36700.671704]  [<ffffffffa05e4362>] btrfs_write_out_cache+0xb2/0xf0 [btrfs]
[36700.671710]  [<ffffffffa05c4441>] ? free_extent_buffer+0x61/0xc0 [btrfs]
[36700.671716]  [<ffffffffa0594c82>] btrfs_write_dirty_block_groups+0x562/0x650 [btrfs]
[36700.671723]  [<ffffffffa0610092>] commit_cowonly_roots+0x171/0x24b [btrfs]
[36700.671729]  [<ffffffffa05a4dde>] btrfs_commit_transaction+0x4fe/0xa10 [btrfs]
[36700.671735]  [<ffffffffa0610af3>] create_subvol+0x5c0/0x636 [btrfs]
[36700.671742]  [<ffffffffa05d49ff>] btrfs_mksubvol.isra.60+0x33f/0x3f0 [btrfs]
[36700.671747]  [<ffffffffa05d4bf2>] btrfs_ioctl_snap_create_transid+0x142/0x190 [btrfs]
[36700.671752]  [<ffffffffa05d4c6c>] ? btrfs_ioctl_snap_create+0x2c/0x80 [btrfs]
[36700.671757]  [<ffffffffa05d4c9e>] btrfs_ioctl_snap_create+0x5e/0x80 [btrfs]
[36700.671759]  [<ffffffff8113a764>] ? handle_pte_fault+0x84/0x920
[36700.671764]  [<ffffffffa05d87eb>] btrfs_ioctl+0xf0b/0x1d00 [btrfs]
[36700.671766]  [<ffffffff8113c120>] ? handle_mm_fault+0x210/0x310
[36700.671768]  [<ffffffff816f83a4>] ? __do_page_fault+0x284/0x4e0
[36700.671770]  [<ffffffff81180aa6>] do_vfs_ioctl+0x96/0x550
[36700.671772]  [<ffffffff81170fe3>] ? __sb_end_write+0x33/0x70
[36700.671774]  [<ffffffff81180ff1>] SyS_ioctl+0x91/0xb0
[36700.671775]  [<ffffffff816fcdc2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Removed wrong assignment of NULL to transaction pointer, and
    addressed code style comment from Josef.

 fs/btrfs/volumes.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f42e412..3cb9649 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3465,7 +3465,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 	int slot;
 	struct btrfs_root_item root_item;
 	u32 item_size;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -3503,13 +3503,18 @@ static int btrfs_uuid_scan_kthread(void *data)
 		if (item_size < sizeof(root_item))
 			goto skip;
 
-		trans = NULL;
 		read_extent_buffer(eb, &root_item,
 				   btrfs_item_ptr_offset(eb, slot),
 				   (int)sizeof(root_item));
 		if (btrfs_root_refs(&root_item) == 0)
 			goto skip;
-		if (!btrfs_is_empty_uuid(root_item.uuid)) {
+
+		if (!btrfs_is_empty_uuid(root_item.uuid) ||
+		    !btrfs_is_empty_uuid(root_item.received_uuid)) {
+			if (trans)
+				goto update_tree;
+
+			btrfs_release_path(path);
 			/*
 			 * 1 - subvol uuid item
 			 * 1 - received_subvol uuid item
@@ -3519,6 +3524,12 @@ static int btrfs_uuid_scan_kthread(void *data)
 				ret = PTR_ERR(trans);
 				break;
 			}
+			continue;
+		} else {
+			goto skip;
+		}
+update_tree:
+		if (!btrfs_is_empty_uuid(root_item.uuid)) {
 			ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root,
 						  root_item.uuid,
 						  BTRFS_UUID_KEY_SUBVOL,
@@ -3533,15 +3544,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 		}
 
 		if (!btrfs_is_empty_uuid(root_item.received_uuid)) {
-			if (!trans) {
-				/* 1 - received_subvol uuid item */
-				trans = btrfs_start_transaction(
-						fs_info->uuid_root, 1);
-				if (IS_ERR(trans)) {
-					ret = PTR_ERR(trans);
-					break;
-				}
-			}
 			ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root,
 						  root_item.received_uuid,
 						 BTRFS_UUID_KEY_RECEIVED_SUBVOL,
@@ -3557,6 +3559,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 
 		if (trans) {
 			ret = btrfs_end_transaction(trans, fs_info->uuid_root);
+			trans = NULL;
 			if (ret)
 				break;
 		}
-- 
1.7.9.5

