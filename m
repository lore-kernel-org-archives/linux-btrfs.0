Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63417 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3KTBFo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 20:05:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAK15fLw015879
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 09:05:41 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com
Subject: [PATCH] Btrfs: improve forever loop when doing balance relocation
Date: Wed, 20 Nov 2013 09:01:52 +0800
Message-Id: <1384909312-17190-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We hit a forever loop when doing balance relocation,the reason
is that we firstly reserve 4M(node size is 16k).and within transaction
we will try to add extra reservation for snapshot roots,this will
return -EAGAIN if there has been a thread flushing space to reserve
space.We will do this again and again with filesystem becoming nearly
full.

If the above '-EAGAIN' case happens, we try to refill reservation more
outsize of transaction, and this will return eariler in enospc case,however,
this dosen't really hurt because it makes no sense doing balance relocation
with the filesystem nearly full.

Miao Xie helped a lot to track this issue, thanks.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 74 +++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ce459a7..4c56444 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -94,6 +94,7 @@ struct backref_edge {
 
 #define LOWER	0
 #define UPPER	1
+#define RELOCATION_RESERVED_NODES	256
 
 struct backref_cache {
 	/* red black tree of all backref nodes in the cache */
@@ -176,6 +177,8 @@ struct reloc_control {
 	u64 merging_rsv_size;
 	/* size of relocated tree nodes */
 	u64 nodes_relocated;
+	/* reserved size for block group relocation*/
+	u64 reserved_bytes;
 
 	u64 search_start;
 	u64 extents_found;
@@ -184,7 +187,6 @@ struct reloc_control {
 	unsigned int create_reloc_tree:1;
 	unsigned int merge_reloc_tree:1;
 	unsigned int found_file_extent:1;
-	unsigned int commit_transaction:1;
 };
 
 /* stages of data relocation */
@@ -2562,28 +2564,36 @@ static int reserve_metadata_space(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = rc->extent_root;
 	u64 num_bytes;
 	int ret;
+	u64 tmp;
 
 	num_bytes = calcu_metadata_size(rc, node, 1) * 2;
 
 	trans->block_rsv = rc->block_rsv;
-	ret = btrfs_block_rsv_add(root, rc->block_rsv, num_bytes,
-				  BTRFS_RESERVE_FLUSH_ALL);
+	rc->reserved_bytes += num_bytes;
+	ret = btrfs_block_rsv_refill(root, rc->block_rsv, num_bytes,
+				BTRFS_RESERVE_FLUSH_ALL);
 	if (ret) {
-		if (ret == -EAGAIN)
-			rc->commit_transaction = 1;
+		if (ret == -EAGAIN) {
+			tmp = rc->extent_root->nodesize *
+				RELOCATION_RESERVED_NODES;
+			while (tmp <= rc->reserved_bytes)
+				tmp <<= 1;
+			/*
+			 * only one thread can access block_rsv at this point,
+			 * so we don't need hold lock to protect block_rsv.
+			 * we expand more reservation size here to allow enough
+			 * space for relocation and we will return eailer in
+			 * enospc case.
+			 */
+			rc->block_rsv->size = tmp + rc->extent_root->nodesize *
+					      RELOCATION_RESERVED_NODES;
+		}
 		return ret;
 	}
 
 	return 0;
 }
 
-static void release_metadata_space(struct reloc_control *rc,
-				   struct backref_node *node)
-{
-	u64 num_bytes = calcu_metadata_size(rc, node, 0) * 2;
-	btrfs_block_rsv_release(rc->extent_root, rc->block_rsv, num_bytes);
-}
-
 /*
  * relocate a block tree, and then update pointers in upper level
  * blocks that reference the block to point to the new location.
@@ -2870,7 +2880,6 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 				struct btrfs_path *path)
 {
 	struct btrfs_root *root;
-	int release = 0;
 	int ret = 0;
 
 	if (!node)
@@ -2887,7 +2896,6 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 		ret = reserve_metadata_space(trans, rc, node);
 		if (ret)
 			goto out;
-		release = 1;
 	}
 
 	if (root) {
@@ -2912,11 +2920,8 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 		ret = do_relocation(trans, rc, node, key, path, 1);
 	}
 out:
-	if (ret || node->level == 0 || node->cowonly) {
-		if (release)
-			release_metadata_space(rc, node);
+	if (ret || node->level == 0 || node->cowonly)
 		remove_backref_node(&rc->backref_cache, node);
-	}
 	return ret;
 }
 
@@ -3839,29 +3844,20 @@ static noinline_for_stack
 int prepare_to_relocate(struct reloc_control *rc)
 {
 	struct btrfs_trans_handle *trans;
-	int ret;
 
 	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root,
 					      BTRFS_BLOCK_RSV_TEMP);
 	if (!rc->block_rsv)
 		return -ENOMEM;
 
-	/*
-	 * reserve some space for creating reloc trees.
-	 * btrfs_init_reloc_root will use them when there
-	 * is no reservation in transaction handle.
-	 */
-	ret = btrfs_block_rsv_add(rc->extent_root, rc->block_rsv,
-				  rc->extent_root->nodesize * 256,
-				  BTRFS_RESERVE_FLUSH_ALL);
-	if (ret)
-		return ret;
-
 	memset(&rc->cluster, 0, sizeof(rc->cluster));
 	rc->search_start = rc->block_group->key.objectid;
 	rc->extents_found = 0;
 	rc->nodes_relocated = 0;
 	rc->merging_rsv_size = 0;
+	rc->reserved_bytes = 0;
+	rc->block_rsv->size = rc->extent_root->nodesize *
+			      RELOCATION_RESERVED_NODES;
 
 	rc->create_reloc_tree = 1;
 	set_reloc_control(rc);
@@ -3905,6 +3901,14 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	}
 
 	while (1) {
+		rc->reserved_bytes = 0;
+		ret = btrfs_block_rsv_refill(rc->extent_root,
+					rc->block_rsv, rc->block_rsv->size,
+					BTRFS_RESERVE_FLUSH_ALL);
+		if (ret) {
+			err = ret;
+			break;
+		}
 		progress++;
 		trans = btrfs_start_transaction(rc->extent_root, 0);
 		if (IS_ERR(trans)) {
@@ -3992,14 +3996,8 @@ restart:
 			}
 		}
 
-		if (rc->commit_transaction) {
-			rc->commit_transaction = 0;
-			ret = btrfs_commit_transaction(trans, rc->extent_root);
-			BUG_ON(ret);
-		} else {
-			btrfs_end_transaction_throttle(trans, rc->extent_root);
-			btrfs_btree_balance_dirty(rc->extent_root);
-		}
+		btrfs_end_transaction_throttle(trans, rc->extent_root);
+		btrfs_btree_balance_dirty(rc->extent_root);
 		trans = NULL;
 
 		if (rc->stage == MOVE_DATA_EXTENTS &&
-- 
1.8.3.1

