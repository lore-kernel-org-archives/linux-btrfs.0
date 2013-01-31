Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab3AaSVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 13:21:15 -0500
Message-ID: <510AB618.6080400@redhat.com>
Date: Thu, 31 Jan 2013 12:21:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH] btrfs: remove cache only arguments from defrag path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The entry point at the defrag ioctl always sets "cache only" to 0;
the codepaths haven't run for a long time as far as I can
tell.  Chris says they're dead code, so remove them.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Compile-tested only, FWIW.

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ac4a424..549598a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1442,7 +1442,7 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
  */
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
-		       int start_slot, int cache_only, u64 *last_ret,
+		       int start_slot, u64 *last_ret,
 		       struct btrfs_key *progress)
 {
 	struct extent_buffer *cur;
@@ -1462,8 +1462,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	struct btrfs_disk_key disk_key;
 
 	parent_level = btrfs_header_level(parent);
-	if (cache_only && parent_level != 1)
-		return 0;
 
 	WARN_ON(trans->transaction != root->fs_info->running_transaction);
 	WARN_ON(trans->transid != root->fs_info->generation);
@@ -1509,10 +1507,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		else
 			uptodate = 0;
 		if (!cur || !uptodate) {
-			if (cache_only) {
-				free_extent_buffer(cur);
-				continue;
-			}
 			if (!cur) {
 				cur = read_tree_block(root, blocknr,
 							 blocksize, gen);
@@ -4826,8 +4820,8 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 
 /*
  * A helper function to walk down the tree starting at min_key, and looking
- * for nodes or leaves that are either in cache or have a minimum
- * transaction id.  This is used by the btree defrag code, and tree logging
+ * for nodes or leaves that are have a minimum transaction id.
+ * This is used by the btree defrag code, and tree logging
  *
  * This does not cow, but it does stuff the starting key it finds back
  * into min_key, so you can call btrfs_search_slot with cow=1 on the
@@ -4848,7 +4842,7 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
  */
 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			 struct btrfs_key *max_key,
-			 struct btrfs_path *path, int cache_only,
+			 struct btrfs_path *path,
 			 u64 min_trans)
 {
 	struct extent_buffer *cur;
@@ -4888,15 +4882,12 @@ again:
 		if (sret && slot > 0)
 			slot--;
 		/*
-		 * check this node pointer against the cache_only and
-		 * min_trans parameters.  If it isn't in cache or is too
-		 * old, skip to the next one.
+		 * check this node pointer against the min_trans parameters.
+		 * If it is too old, old, skip to the next one.
 		 */
 		while (slot < nritems) {
 			u64 blockptr;
 			u64 gen;
-			struct extent_buffer *tmp;
-			struct btrfs_disk_key disk_key;
 
 			blockptr = btrfs_node_blockptr(cur, slot);
 			gen = btrfs_node_ptr_generation(cur, slot);
@@ -4904,27 +4895,7 @@ again:
 				slot++;
 				continue;
 			}
-			if (!cache_only)
-				break;
-
-			if (max_key) {
-				btrfs_node_key(cur, &disk_key, slot);
-				if (comp_keys(&disk_key, max_key) >= 0) {
-					ret = 1;
-					goto out;
-				}
-			}
-
-			tmp = btrfs_find_tree_block(root, blockptr,
-					    btrfs_level_size(root, level - 1));
-
-			if (tmp && btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
-				free_extent_buffer(tmp);
-				break;
-			}
-			if (tmp)
-				free_extent_buffer(tmp);
-			slot++;
+			break;
 		}
 find_next_key:
 		/*
@@ -4935,7 +4906,7 @@ find_next_key:
 			path->slots[level] = slot;
 			btrfs_set_path_blocking(path);
 			sret = btrfs_find_next_key(root, path, min_key, level,
-						  cache_only, min_trans);
+						  min_trans);
 			if (sret == 0) {
 				btrfs_release_path(path);
 				goto again;
@@ -5400,8 +5371,7 @@ out:
 /*
  * this is similar to btrfs_next_leaf, but does not try to preserve
  * and fixup the path.  It looks for and returns the next key in the
- * tree based on the current path and the cache_only and min_trans
- * parameters.
+ * tree based on the current path and the min_trans parameters.
  *
  * 0 is returned if another key is found, < 0 if there are any errors
  * and 1 is returned if there are no higher keys in the tree
@@ -5410,8 +5380,7 @@ out:
  * calling this function.
  */
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
-			struct btrfs_key *key, int level,
-			int cache_only, u64 min_trans)
+			struct btrfs_key *key, int level, u64 min_trans)
 {
 	int slot;
 	struct extent_buffer *c;
@@ -5462,22 +5431,8 @@ next:
 		if (level == 0)
 			btrfs_item_key_to_cpu(c, key, slot);
 		else {
-			u64 blockptr = btrfs_node_blockptr(c, slot);
 			u64 gen = btrfs_node_ptr_generation(c, slot);
 
-			if (cache_only) {
-				struct extent_buffer *cur;
-				cur = btrfs_find_tree_block(root, blockptr,
-					    btrfs_level_size(root, level - 1));
-				if (!cur ||
-				    btrfs_buffer_uptodate(cur, gen, 1) <= 0) {
-					slot++;
-					if (cur)
-						free_extent_buffer(cur);
-					goto next;
-				}
-				free_extent_buffer(cur);
-			}
 			if (gen < min_trans) {
 				slot++;
 				goto next;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 57121fc..413b462 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3092,10 +3092,10 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
 			struct btrfs_key *key, int lowest_level,
-			int cache_only, u64 min_trans);
+			u64 min_trans);
 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 			 struct btrfs_key *max_key,
-			 struct btrfs_path *path, int cache_only,
+			 struct btrfs_path *path,
 			 u64 min_trans);
 enum btrfs_compare_tree_result {
 	BTRFS_COMPARE_TREE_NEW,
@@ -3148,7 +3148,7 @@ int btrfs_search_slot_for_read(struct btrfs_root *root,
 			       int find_higher, int return_any);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
-		       int start_slot, int cache_only, u64 *last_ret,
+		       int start_slot, u64 *last_ret,
 		       struct btrfs_key *progress);
 void btrfs_release_path(struct btrfs_path *p);
 struct btrfs_path *btrfs_alloc_path(void);
@@ -3543,7 +3543,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, int cache_only);
+			struct btrfs_root *root);
 
 /* sysfs.c */
 int btrfs_init_sysfs(void);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5b22d45..54cb280 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -815,7 +815,7 @@ static int find_new_extents(struct btrfs_root *root,
 
 	while(1) {
 		ret = btrfs_search_forward(root, &min_key, &max_key,
-					   path, 0, newer_than);
+					   path, newer_than);
 		if (ret != 0)
 			goto none;
 		if (min_key.objectid != ino)
@@ -1860,7 +1860,7 @@ static noinline int search_ioctl(struct inode *inode,
 	path->keep_locks = 1;
 
 	while(1) {
-		ret = btrfs_search_forward(root, &key, &max_key, path, 0,
+		ret = btrfs_search_forward(root, &key, &max_key, path,
 					   sk->min_transid);
 		if (ret != 0) {
 			if (ret > 0)
@@ -2208,10 +2208,10 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			ret = -EPERM;
 			goto out;
 		}
-		ret = btrfs_defrag_root(root, 0);
+		ret = btrfs_defrag_root(root);
 		if (ret)
 			goto out;
-		ret = btrfs_defrag_root(root->fs_info->extent_root, 0);
+		ret = btrfs_defrag_root(root->fs_info->extent_root);
 		break;
 	case S_IFREG:
 		if (!(file->f_mode & FMODE_WRITE)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f154946..6ace4d6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -950,10 +950,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 }
 
 /*
- * defrag a given btree.  If cacheonly == 1, this won't read from the disk,
- * otherwise every leaf in the btree is read and defragged.
+ * defrag a given btree.
+ * Every leaf in the btree is read and defragged.
  */
-int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
+int btrfs_defrag_root(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_trans_handle *trans;
@@ -967,7 +967,7 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
-		ret = btrfs_defrag_leaves(trans, root, cacheonly);
+		ret = btrfs_defrag_leaves(trans, root);
 
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(info->tree_root);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 0e8aa1e..8c12ecb 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -116,7 +116,7 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 
 int btrfs_add_dead_root(struct btrfs_root *root);
-int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
+int btrfs_defrag_root(struct btrfs_root *root);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 3b580ee..94e05c1 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -23,13 +23,14 @@
 #include "transaction.h"
 #include "locking.h"
 
-/* defrag all the leaves in a given btree.  If cache_only == 1, don't read
- * things from disk, otherwise read all the leaves and try to get key order to
+/*
+ * Defrag all the leaves in a given btree.
+ * Read all the leaves and try to get key order to
  * better reflect disk order
  */
 
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, int cache_only)
+			struct btrfs_root *root)
 {
 	struct btrfs_path *path = NULL;
 	struct btrfs_key key;
@@ -41,9 +42,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	u64 last_ret = 0;
 	u64 min_trans = 0;
 
-	if (cache_only)
-		goto out;
-
 	if (root->fs_info->extent_root == root) {
 		/*
 		 * there's recursion here right now in the tree locking,
@@ -86,11 +84,8 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	}
 
 	path->keep_locks = 1;
-	if (cache_only)
-		min_trans = root->defrag_trans_start;
 
-	ret = btrfs_search_forward(root, &key, NULL, path,
-				   cache_only, min_trans);
+	ret = btrfs_search_forward(root, &key, NULL, path, min_trans);
 	if (ret < 0)
 		goto out;
 	if (ret > 0) {
@@ -109,11 +104,11 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 	path->slots[1] = btrfs_header_nritems(path->nodes[1]);
-	next_key_ret = btrfs_find_next_key(root, path, &key, 1, cache_only,
+	next_key_ret = btrfs_find_next_key(root, path, &key, 1,
 					   min_trans);
 	ret = btrfs_realloc_node(trans, root,
 				 path->nodes[1], 0,
-				 cache_only, &last_ret,
+				 &last_ret,
 				 &root->defrag_progress);
 	if (ret) {
 		WARN_ON(ret == -EAGAIN);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9027bb1..e378850 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2724,7 +2724,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	path->keep_locks = 1;
 
 	ret = btrfs_search_forward(root, &min_key, &max_key,
-				   path, 0, trans->transid);
+				   path, trans->transid);
 
 	/*
 	 * we didn't find anything from this transaction, see if there
@@ -3558,7 +3558,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	while (1) {
 		ins_nr = 0;
 		ret = btrfs_search_forward(root, &min_key, &max_key,
-					   path, 0, trans->transid);
+					   path, trans->transid);
 		if (ret != 0)
 			break;
 again:

