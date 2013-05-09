Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46987 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3EIRvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 13:51:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 11B227C0302
	for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2013 11:51:50 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id YlXNV76T1zSyIeZg (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 11:51:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle running extent ops with skinny metadata
Date: Thu, 9 May 2013 13:51:46 -0400
Message-ID: <1368121906-2293-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris hit a bug where we weren't finding extent records when running extent ops.
This is because we use the delayed_ref_head when running the extent op, which
means we can't use the ->type checks to see if we are metadata.  We also lose
the level of the metadata we are working on.  So to fix this we need to make
sure we save the level of the block we are working with when we run the other
delayed refs and pass this in.  Then secondly we need to check the ->is_data
flag in the delayed ref head to see if it is a metadata op.  With this patch we
no longer fail to find our extent ref when running the extent_op.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2305b5c..d39d69e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -135,6 +135,19 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
 	}
 }
 
+static inline int delayed_ref_is_metadata(struct btrfs_delayed_ref_node *node)
+{
+	if (btrfs_delayed_ref_is_head(node)) {
+		struct btrfs_delayed_ref_head *head;
+
+		head = btrfs_delayed_node_to_head(node);
+		return !head->is_data;
+	}
+
+	return (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
+		node->type == BTRFS_SHARED_BLOCK_REF_KEY);
+}
+
 /*
  * this adds the block group to the fs_info rb tree for the block group
  * cache
@@ -2061,7 +2074,8 @@ static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct btrfs_delayed_ref_node *node,
-				 struct btrfs_delayed_extent_op *extent_op)
+				 struct btrfs_delayed_extent_op *extent_op,
+				 int level)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -2070,8 +2084,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	int ret;
 	int err = 0;
-	int metadata = (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-			node->type == BTRFS_SHARED_BLOCK_REF_KEY);
+	int metadata = delayed_ref_is_metadata(node);
 
 	if (trans->aborted)
 		return 0;
@@ -2086,11 +2099,9 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	key.objectid = node->bytenr;
 
 	if (metadata) {
-		struct btrfs_delayed_tree_ref *tree_ref;
-
-		tree_ref = btrfs_delayed_node_to_tree_ref(node);
+		WARN_ON(level == -1);
 		key.type = BTRFS_METADATA_ITEM_KEY;
-		key.offset = tree_ref->level;
+		key.offset = level;
 	} else {
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.offset = node->num_bytes;
@@ -2287,10 +2298,12 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 	int ret;
 	int count = 0;
 	int must_insert_reserved = 0;
+	int level = -1;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	while (1) {
 		if (!locked_ref) {
+			level = -1;
 			/* pick a new head ref from the cluster list */
 			if (list_empty(cluster))
 				break;
@@ -2373,7 +2386,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 				spin_unlock(&delayed_refs->lock);
 
 				ret = run_delayed_extent_op(trans, root,
-							    ref, extent_op);
+							    ref, extent_op,
+							    level);
 				btrfs_free_delayed_extent_op(extent_op);
 
 				if (ret) {
@@ -2391,6 +2405,13 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		rb_erase(&ref->rb_node, &delayed_refs->root);
 		delayed_refs->num_entries--;
 		if (!btrfs_delayed_ref_is_head(ref)) {
+			if (level < 0 && delayed_ref_is_metadata(ref)) {
+				struct btrfs_delayed_tree_ref *tree_ref;
+
+				tree_ref = btrfs_delayed_node_to_tree_ref(ref);
+				level = tree_ref->level;
+			}
+
 			/*
 			 * when we play the delayed ref, also correct the
 			 * ref_mod on head
-- 
1.7.7.6

