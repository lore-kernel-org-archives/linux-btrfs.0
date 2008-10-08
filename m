From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix leaf reference cache miss
Date: Wed, 08 Oct 2008 15:34:29 +0800
Message-ID: <48EC6285.604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Due to the optimization for truncate, tree leaves only contain
checksum can be deleted without being COW'ed first. This causes
reference cache misses. The way to fix the miss is create cache
entries for tree leaves only contain checksum.

This patch also fixes a -EEXIST issue in shared reference cache.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2938046..8d6d662 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1154,6 +1154,14 @@ int btrfs_cache_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		}
 
 		ret = btrfs_add_leaf_ref(root, ref, shared);
+		if (ret == -EEXIST && shared) {
+			struct btrfs_leaf_ref *old;
+			old = btrfs_lookup_leaf_ref(root, ref->bytenr);
+			BUG_ON(!old);
+			btrfs_remove_leaf_ref(root, old);
+			btrfs_free_leaf_ref(root, old);
+			ret = btrfs_add_leaf_ref(root, ref, shared);
+		}
 		WARN_ON(ret);
 		btrfs_free_leaf_ref(root, ref);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff0c359..4766ceb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -48,6 +48,7 @@
 #include "xattr.h"
 #include "compat.h"
 #include "tree-log.h"
+#include "ref-cache.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -1417,6 +1418,9 @@ static noinline int drop_csum_leaves(struct btrfs_trans_handle *trans,
 	int nritems;
 	struct btrfs_key found_key;
 	struct btrfs_key other_key;
+	struct btrfs_leaf_ref *ref;
+	u64 leaf_gen;
+	u64 leaf_start;
 
 	path->lowest_level = 1;
 	key.objectid = inode->i_ino;
@@ -1510,15 +1514,31 @@ next_node:
 	if (other_key.objectid != inode->i_ino || other_key.type != key.type)
 		goto out;
 
+	leaf_start = btrfs_node_blockptr(path->nodes[1], path->slots[1]);
+	leaf_gen = btrfs_node_ptr_generation(path->nodes[1], path->slots[1]);
 	/*
 	 * it is safe to delete this leaf, it contains only
 	 * csum items from this inode at an offset >= new_size
 	 */
-	ret = btrfs_del_leaf(trans, root, path,
-			     btrfs_node_blockptr(path->nodes[1],
-						 path->slots[1]));
+	ret = btrfs_del_leaf(trans, root, path, leaf_start);
 	BUG_ON(ret);
 
+	if (root->ref_cows && leaf_gen < trans->transid) {
+		ref = btrfs_alloc_leaf_ref(root, 0);
+		if (ref) {
+			ref->root_gen = root->root_key.offset;
+			ref->bytenr = leaf_start;
+			ref->owner = 0;
+			ref->generation = leaf_gen;
+			ref->nritems = 0;
+
+			ret = btrfs_add_leaf_ref(root, ref, 0);
+			WARN_ON(ret);
+			btrfs_free_leaf_ref(root, ref);
+		} else {
+			WARN_ON(1);
+		}
+	}
 next_key:
 	btrfs_release_path(root, path);
 
