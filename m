Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3IYNr3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 09:47:29 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8PDlMZQ026984
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 21:47:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs: fix BUG_ON() casued by the reserved space migration
Date: Wed, 25 Sep 2013 21:47:45 +0800
Message-Id: <1380116865-23406-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com>
References: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we did space balance and snapshot creation at the same time, we might
meet the following oops:
 kernel BUG at fs/btrfs/inode.c:3038!
 [SNIP]
 Call Trace:
 [<ffffffffa0411ec7>] btrfs_orphan_cleanup+0x293/0x407 [btrfs]
 [<ffffffffa042dc45>] btrfs_mksubvol.isra.28+0x259/0x373 [btrfs]
 [<ffffffffa042de85>] btrfs_ioctl_snap_create_transid+0x126/0x156 [btrfs]
 [<ffffffffa042dff1>] btrfs_ioctl_snap_create_v2+0xd0/0x121 [btrfs]
 [<ffffffffa0430b2c>] btrfs_ioctl+0x414/0x1854 [btrfs]
 [<ffffffff813b60b7>] ? __do_page_fault+0x305/0x379
 [<ffffffff811215a9>] vfs_ioctl+0x1d/0x39
 [<ffffffff81121d7c>] do_vfs_ioctl+0x32d/0x3e2
 [<ffffffff81057fe7>] ? finish_task_switch+0x80/0xb8
 [<ffffffff81121e88>] SyS_ioctl+0x57/0x83
 [<ffffffff813b39ff>] ? do_device_not_available+0x12/0x14
 [<ffffffff813b99c2>] system_call_fastpath+0x16/0x1b
 [SNIP]
 RIP  [<ffffffffa040da40>] btrfs_orphan_add+0xc3/0x126 [btrfs]

The reason of the problem is that the relocation root creation stole
the reserved space, which was reserved for orphan item deletion.

There are several ways to fix this problem, one is to increasing
the reserved space size of the space balace, and then we can use
that space to create the relocation tree for each fs/file trees.
But it is hard to calculate the suitable size because we doesn't
know how many fs/file trees we need relocate.

We fixed this problem by reserving the space for relocation root creation
actively since the space it need is very small (one tree block, used for
root node copy), then we use that reserved space to create the
relocation tree. If we don't reserve space for relocation tree creation,
we will use the reserved space of the balance.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c  |  6 ++++--
 fs/btrfs/transaction.c | 24 +++++++++++++++++++++++-
 fs/btrfs/transaction.h |  1 +
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1ba09d1..0b5fc05 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1383,6 +1383,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *reloc_root;
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
+	struct btrfs_block_rsv *rsv;
 	int clear_rsv = 0;
 	int ret;
 
@@ -1396,13 +1397,14 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
 		return 0;
 
-	if (!trans->block_rsv) {
+	if (!trans->reloc_reserved) {
+		rsv = trans->block_rsv;
 		trans->block_rsv = rc->block_rsv;
 		clear_rsv = 1;
 	}
 	reloc_root = create_reloc_root(trans, root, root->root_key.objectid);
 	if (clear_rsv)
-		trans->block_rsv = NULL;
+		trans->block_rsv = rsv;
 
 	ret = __add_reloc_root(reloc_root);
 	BUG_ON(ret < 0);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cac4a3f..012e003 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -353,6 +353,17 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 	return 0;
 }
 
+static inline bool need_reserve_reloc_root(struct btrfs_root *root)
+{
+	if (!root->fs_info->reloc_ctl ||
+	    !root->ref_cows ||
+	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	    root->reloc_root)
+		return false;
+
+	return true;
+}
+
 static struct btrfs_trans_handle *
 start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		  enum btrfs_reserve_flush_enum flush)
@@ -360,8 +371,9 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
 	u64 num_bytes = 0;
-	int ret;
 	u64 qgroup_reserved = 0;
+	bool reloc_reserved = false;
+	int ret;
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return ERR_PTR(-EROFS);
@@ -390,6 +402,14 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 		}
 
 		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
+		/*
+		 * Do the reservation for the relocation root creation
+		 */
+		if (unlikely(need_reserve_reloc_root(root))) {
+			num_bytes += root->nodesize;
+			reloc_reserved = true;
+		}
+
 		ret = btrfs_block_rsv_add(root,
 					  &root->fs_info->trans_block_rsv,
 					  num_bytes, flush);
@@ -451,6 +471,7 @@ again:
 	h->delayed_ref_elem.seq = 0;
 	h->type = type;
 	h->allocating_chunk = false;
+	h->reloc_reserved = false;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
 	INIT_LIST_HEAD(&h->new_bgs);
 
@@ -466,6 +487,7 @@ again:
 					      h->transid, num_bytes, 1);
 		h->block_rsv = &root->fs_info->trans_block_rsv;
 		h->bytes_reserved = num_bytes;
+		h->reloc_reserved = reloc_reserved;
 	}
 	h->qgroup_reserved = qgroup_reserved;
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5c2af84..150e5dc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -92,6 +92,7 @@ struct btrfs_trans_handle {
 	short aborted;
 	short adding_csums;
 	bool allocating_chunk;
+	bool reloc_reserved;
 	unsigned int type;
 	/*
 	 * this root is only needed to validate that the root passed to
-- 
1.8.3.1

