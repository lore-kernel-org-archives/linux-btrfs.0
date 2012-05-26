Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:56284 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2EZK7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 05/15] Btrfs: don't set for_cow parameter for tree block functions
Date: Sat, 26 May 2012 12:59:39 +0200
Message-Id: <5581a51a59a1f5f51ac3d4bacafb738d35e0350b.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Three callers of btrfs_free_tree_block or btrfs_alloc_tree_block passed
parameter for_cow = 1. In fact, these two functions should never mark
their tree modification operations as for_cow, because they can change
the number of blocks referenced by a tree.

Hence, we remove the extra for_cow parameter from these functions and
make them pass a zero down.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c       |   22 +++++++++++-----------
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |   10 +++++-----
 fs/btrfs/ioctl.c       |    2 +-
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4106264..56485b3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -255,7 +255,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
 				     new_root_objectid, &disk_key, level,
-				     buf->start, 0, 1);
+				     buf->start, 0);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -467,7 +467,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
 				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size, 1);
+				     level, search_start, empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -509,7 +509,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref, 1);
+				      last_ref);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
@@ -525,7 +525,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
 		btrfs_free_tree_block(trans, root, buf, parent_start,
-				      last_ref, 1);
+				      last_ref);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -987,7 +987,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer(mid);
 
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		/* once for the root ptr */
 		free_extent_buffer_stale(mid);
 		return 0;
@@ -1042,7 +1042,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			btrfs_tree_unlock(right);
 			del_ptr(trans, root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
-			btrfs_free_tree_block(trans, root, right, 0, 1, 0);
+			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer_stale(right);
 			right = NULL;
 		} else {
@@ -1084,7 +1084,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		btrfs_tree_unlock(mid);
 		del_ptr(trans, root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
-		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
+		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer_stale(mid);
 		mid = NULL;
 	} else {
@@ -2129,7 +2129,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 
 	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				   root->root_key.objectid, &lower_key,
-				   level, root->node->start, 0, 0);
+				   level, root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -2252,7 +2252,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 
 	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 					root->root_key.objectid,
-					&disk_key, level, c->start, 0, 0);
+					&disk_key, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -3004,7 +3004,7 @@ again:
 
 	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 					root->root_key.objectid,
-					&disk_key, 0, l->start, 0, 0);
+					&disk_key, 0, l->start, 0);
 	if (IS_ERR(right))
 		return PTR_ERR(right);
 
@@ -3804,7 +3804,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	root_sub_used(root, leaf->len);
 
 	extent_buffer_get(leaf);
-	btrfs_free_tree_block(trans, root, leaf, 0, 1, 0);
+	btrfs_free_tree_block(trans, root, leaf, 0, 1);
 	free_extent_buffer_stale(leaf);
 }
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ec42a24..e863188 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2496,11 +2496,11 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size, int for_cow);
+					u64 hint, u64 empty_size);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   u64 parent, int last_ref, int for_cow);
+			   u64 parent, int last_ref);
 struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..f433074 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1252,7 +1252,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
 				      BTRFS_TREE_LOG_OBJECTID, NULL,
-				      0, 0, 0, 0);
+				      0, 0, 0);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 49fd7b6..b68eb7a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5217,7 +5217,7 @@ out:
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf,
-			   u64 parent, int last_ref, int for_cow)
+			   u64 parent, int last_ref)
 {
 	struct btrfs_block_group_cache *cache = NULL;
 	int ret;
@@ -5227,7 +5227,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 					buf->start, buf->len,
 					parent, root->root_key.objectid,
 					btrfs_header_level(buf),
-					BTRFS_DROP_DELAYED_REF, NULL, for_cow);
+					BTRFS_DROP_DELAYED_REF, NULL, 0);
 		BUG_ON(ret); /* -ENOMEM */
 	}
 
@@ -6249,7 +6249,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root, u32 blocksize,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
-					u64 hint, u64 empty_size, int for_cow)
+					u64 hint, u64 empty_size)
 {
 	struct btrfs_key ins;
 	struct btrfs_block_rsv *block_rsv;
@@ -6297,7 +6297,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 					ins.objectid,
 					ins.offset, parent, root_objectid,
 					level, BTRFS_ADD_DELAYED_EXTENT,
-					extent_op, for_cow);
+					extent_op, 0);
 		BUG_ON(ret); /* -ENOMEM */
 	}
 	return buf;
@@ -6715,7 +6715,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			       btrfs_header_owner(path->nodes[level + 1]));
 	}
 
-	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1, 0);
+	btrfs_free_tree_block(trans, root, eb, parent, wc->refs[level] == 1);
 out:
 	wc->refs[level] = 0;
 	wc->flags[level] = 0;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14f8e1f..7f3a913 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -367,7 +367,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 		return PTR_ERR(trans);
 
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
-				      0, objectid, NULL, 0, 0, 0, 0);
+				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
-- 
1.7.3.4

