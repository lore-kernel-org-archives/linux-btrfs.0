From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 6/9] Btrfs: improve log with sub transaction
Date: Thu, 19 May 2011 16:11:29 +0800
Message-ID: <1305792692-10635-7-git-send-email-liubo2009@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When logging an inode _A_, current btrfs will
a) clear all items belonged to _A_ in log,
b) copy all items belonged to _A_ from fs/file tree to log tree,
and this just wastes a lot of time, especially when logging big files.

So we want to use a smarter approach, i.e. "find and merge".
The amount of file extent items is the largest, so we focus on it.
Thanks to sub transaction, now we can find those file extent items which
are changed after last _transaction commit_ or last _log commit_, and
then merge them with the existed ones in log tree.

It will be great helpful on fsync performance, cause the common case is
"make changes on a _part_ of inode".

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/tree-log.c |  177 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 126 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 51d5024..745933c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2561,60 +2561,106 @@ again:
 }
 
 /*
- * a helper function to drop items from the log before we relog an
- * inode.  max_key_type indicates the highest item type to remove.
- * This cannot be run for file data extents because it does not
- * free the extents they point to.
+ * a helper function to drop items from the log before we merge
+ * the uptodate items into the log tree.
  */
-static int drop_objectid_items(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *log,
-				  struct btrfs_path *path,
-				  u64 objectid, int max_key_type)
+static int prepare_for_merge_items(struct btrfs_trans_handle *trans,
+				   struct inode *inode,
+				   struct extent_buffer *eb,
+				   int slot, int nr)
 {
-	int ret;
-	struct btrfs_key key;
+	struct btrfs_root *log = BTRFS_I(inode)->root->log_root;
+	struct btrfs_path *path;
 	struct btrfs_key found_key;
+	struct btrfs_key key;
+	int i;
+	int ret;
 
-	key.objectid = objectid;
-	key.type = max_key_type;
-	key.offset = (u64)-1;
+	/* There are no relative items of the inode in log. */
+	if (BTRFS_I(inode)->logged_trans < trans->transaction->transid)
+		return 0;
 
-	while (1) {
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		btrfs_item_key_to_cpu(eb, &key, i + slot);
+
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
+			struct btrfs_file_extent_item *fi;
+			int found_type;
+			u64 mask = BTRFS_I(inode)->root->sectorsize - 1;
+			u64 start = key.offset;
+			u64 extent_end;
+			u64 hint;
+			unsigned long size;
+
+			fi = btrfs_item_ptr(eb, slot + i,
+						 struct btrfs_file_extent_item);
+			found_type = btrfs_file_extent_type(eb, fi);
+
+			if (found_type == BTRFS_FILE_EXTENT_REG ||
+			    found_type == BTRFS_FILE_EXTENT_PREALLOC)
+				extent_end = start +
+					btrfs_file_extent_num_bytes(eb, fi);
+			else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+				size = btrfs_file_extent_inline_len(eb, fi);
+				extent_end = (start + size + mask) & ~mask;
+			} else
+				BUG_ON(1);
+
+			/* drop any overlapping extents */
+			ret = btrfs_drop_extents(trans, inode, start,
+						 extent_end, &hint, 0, 1);
+			BUG_ON(ret);
+
+			continue;
+		}
+
+		/* non file extent */
 		ret = btrfs_search_slot(trans, log, &key, path, -1, 1);
-		BUG_ON(ret == 0);
 		if (ret < 0)
 			break;
 
-		if (path->slots[0] == 0)
+		/* empty log! */
+		if (ret > 0 && path->slots[0] == 0)
 			break;
 
-		path->slots[0]--;
+		if (ret > 0) {
+			btrfs_release_path(log, path);
+			continue;
+		}
+
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
 
-		if (found_key.objectid != objectid)
-			break;
+		if (btrfs_comp_cpu_keys(&found_key, &key))
+			BUG_ON(1);
 
 		ret = btrfs_del_item(trans, log, path);
 		BUG_ON(ret);
 		btrfs_release_path(log, path);
 	}
 	btrfs_release_path(log, path);
-	return ret;
+	btrfs_free_path(path);
+
+	return 0;
 }
 
 static noinline int copy_items(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *log,
+			       struct inode *inode,
 			       struct btrfs_path *dst_path,
 			       struct extent_buffer *src,
 			       int start_slot, int nr, int inode_only)
 {
 	unsigned long src_offset;
 	unsigned long dst_offset;
+	struct btrfs_root *log = BTRFS_I(inode)->root->log_root;
 	struct btrfs_file_extent_item *extent;
 	struct btrfs_inode_item *inode_item;
-	int ret;
 	struct btrfs_key *ins_keys;
+	int ret;
 	u32 *ins_sizes;
 	char *ins_data;
 	int i;
@@ -2622,6 +2668,10 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&ordered_sums);
 
+	ret = prepare_for_merge_items(trans, inode, src, start_slot, nr);
+	if (ret)
+		return ret;
+
 	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
 			   nr * sizeof(u32), GFP_NOFS);
 	if (!ins_data)
@@ -2725,6 +2775,34 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * a helper function to filter the old file extent items by checking their
+ * generation.
+ */
+static inline int is_extent_uptodate(struct btrfs_path *path, u64 min_trans)
+{
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	int slot;
+	u64 gen;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+
+	if (btrfs_key_type(&key) != BTRFS_EXTENT_DATA_KEY)
+		return 1;
+
+	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+	gen = btrfs_file_extent_generation(eb, fi);
+	if (gen < min_trans)
+		return 0;
+
+	return 1;
+}
+
 /* log a single inode in the tree log.
  * At least one parent directory for this inode must exist in the tree
  * or be logged already.
@@ -2754,6 +2832,16 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int nritems;
 	int ins_start_slot = 0;
 	int ins_nr;
+	u64 transid;
+
+	/*
+	 * We use transid in btrfs_search_forward() as a filter, in order to
+	 * find the uptodate block (node or leaf).
+	 */
+	if (BTRFS_I(inode)->first_sub_trans > trans->transaction->transid)
+		transid = BTRFS_I(inode)->first_sub_trans;
+	else
+		transid = trans->transaction->transid;
 
 	log = root->log_root;
 
@@ -2784,30 +2872,12 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	/*
-	 * a brute force approach to making sure we get the most uptodate
-	 * copies of everything.
-	 */
-	if (S_ISDIR(inode->i_mode)) {
-		int max_key_type = BTRFS_DIR_LOG_INDEX_KEY;
-
-		if (inode_only == LOG_INODE_EXISTS)
-			max_key_type = BTRFS_XATTR_ITEM_KEY;
-		ret = drop_objectid_items(trans, log, path,
-					  inode->i_ino, max_key_type);
-	} else {
-		ret = btrfs_truncate_inode_items(trans, log, inode, 0, 0);
-	}
-	if (ret) {
-		err = ret;
-		goto out_unlock;
-	}
 	path->keep_locks = 1;
 
 	while (1) {
 		ins_nr = 0;
 		ret = btrfs_search_forward(root, &min_key, &max_key,
-					   path, 0, trans->transid);
+					   path, 0, transid);
 		if (ret != 0)
 			break;
 again:
@@ -2818,6 +2888,9 @@ again:
 			break;
 
 		src = path->nodes[0];
+		if (!is_extent_uptodate(path, transid))
+			goto filter;
+
 		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
 			ins_nr++;
 			goto next_slot;
@@ -2826,15 +2899,17 @@ again:
 			ins_nr = 1;
 			goto next_slot;
 		}
-
-		ret = copy_items(trans, log, dst_path, src, ins_start_slot,
-				 ins_nr, inode_only);
-		if (ret) {
-			err = ret;
-			goto out_unlock;
+filter:
+		if (ins_nr) {
+			ret = copy_items(trans, inode, dst_path, src,
+					 ins_start_slot,
+					 ins_nr, inode_only);
+			if (ret) {
+				err = ret;
+				goto out_unlock;
+			}
+			ins_nr = 0;
 		}
-		ins_nr = 1;
-		ins_start_slot = path->slots[0];
 next_slot:
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
@@ -2845,7 +2920,7 @@ next_slot:
 			goto again;
 		}
 		if (ins_nr) {
-			ret = copy_items(trans, log, dst_path, src,
+			ret = copy_items(trans, inode, dst_path, src,
 					 ins_start_slot,
 					 ins_nr, inode_only);
 			if (ret) {
@@ -2866,7 +2941,7 @@ next_slot:
 			break;
 	}
 	if (ins_nr) {
-		ret = copy_items(trans, log, dst_path, src,
+		ret = copy_items(trans, inode, dst_path, src,
 				 ins_start_slot,
 				 ins_nr, inode_only);
 		if (ret) {
-- 
1.6.5.2

