From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix tree logs parallel sync
Date: Tue, 20 Jan 2009 01:11:04 +0800
Message-ID: <4974B428.1070003@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

To improve performance, btrfs_sync_log merges tree log sync
requests. But it wrongly merges sync requests for different
tree logs. If multiple tree logs are synced at the same time,
only one tree log, only one of them actually gets synced.

This patch has following changes to fix the bug.

Move most tree log related fields in btrfs_fs_info to
btrfs_root. This allows merging sync requests separately
for each tree log.

Don't insert root item into the log root tree immediately
after log tree is allocated. Root item for log tree is
inserted when log tree get synced for the first time. This
allows syncing the log root tree without first syncing all
log trees.

At tree-log sync, btrfs_sync_log first sync the log tree;
then updates corresponding root item in the log root tree;
sync the log root tree; finally updates the super block.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-01-06 22:20:42.801117041 +0800
+++ 2/fs/btrfs/ctree.h	2009-01-19 15:42:02.000000000 +0800
@@ -701,9 +701,7 @@ struct btrfs_fs_info {
 	struct btrfs_transaction *running_transaction;
 	wait_queue_head_t transaction_throttle;
 	wait_queue_head_t transaction_wait;
-
 	wait_queue_head_t async_submit_wait;
-	wait_queue_head_t tree_log_wait;
 
 	struct btrfs_super_block super_copy;
 	struct btrfs_super_block super_for_commit;
@@ -730,10 +728,6 @@ struct btrfs_fs_info {
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
-	atomic_t tree_log_writers;
-	atomic_t tree_log_commit;
-	unsigned long tree_log_batch;
-	u64 tree_log_transid;
 
 	/*
 	 * this is used by the balancing code to wait for all the pending
@@ -833,7 +827,14 @@ struct btrfs_root {
 	struct kobject root_kobj;
 	struct completion kobj_unregister;
 	struct mutex objectid_mutex;
+
 	struct mutex log_mutex;
+	wait_queue_head_t log_writer_wait;
+	wait_queue_head_t log_commit_wait[2];
+	atomic_t log_writers;
+	atomic_t log_commit[2];
+	unsigned long log_transid;
+	unsigned long log_batch;
 
 	u64 objectid;
 	u64 last_trans;
diff -urp 1/fs/btrfs/disk-io.c 2/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2009-01-06 22:20:42.805117060 +0800
+++ 2/fs/btrfs/disk-io.c	2009-01-19 15:42:02.000000000 +0800
@@ -850,6 +850,14 @@ static int __setup_root(u32 nodesize, u3
 	spin_lock_init(&root->list_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
+	init_waitqueue_head(&root->log_writer_wait);
+	init_waitqueue_head(&root->log_commit_wait[0]);
+	init_waitqueue_head(&root->log_commit_wait[1]);
+	atomic_set(&root->log_commit[0], 0);
+	atomic_set(&root->log_commit[1], 0);
+	atomic_set(&root->log_writers, 0);
+	root->log_batch = 0;
+	root->log_transid = 0;
 	extent_io_tree_init(&root->dirty_log_pages,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 
@@ -934,15 +942,16 @@ int btrfs_free_log_root_tree(struct btrf
 	return 0;
 }
 
-int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info)
+static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
+					 struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct extent_buffer *leaf;
 
 	root = kzalloc(sizeof(*root), GFP_NOFS);
 	if (!root)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
 		     tree_root->sectorsize, tree_root->stripesize,
@@ -951,12 +960,23 @@ int btrfs_init_log_root_tree(struct btrf
 	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root->root_key.offset = BTRFS_TREE_LOG_OBJECTID;
+	/*
+	 * log trees do not get reference counted because they go away
+	 * before a real commit is actually done.  They do store pointers
+	 * to file data extents, and those reference counts still get
+	 * updated (along with back refs to the log tree).
+	 */
 	root->ref_cows = 0;
 
-	root->node = btrfs_alloc_free_block(trans, root, root->leafsize,
-					    0, BTRFS_TREE_LOG_OBJECTID,
-					    trans->transid, 0, 0, 0);
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+				      0, BTRFS_TREE_LOG_OBJECTID,
+				      trans->transid, 0, 0, 0);
+	if (IS_ERR(leaf)) {
+		kfree(root);
+		return ERR_CAST(leaf);
+	}
 
+	root->node = leaf;
 	btrfs_set_header_nritems(root->node, 0);
 	btrfs_set_header_level(root->node, 0);
 	btrfs_set_header_bytenr(root->node, root->node->start);
@@ -968,7 +988,48 @@ int btrfs_init_log_root_tree(struct btrf
 			    BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
-	fs_info->log_root_tree = root;
+	return root;
+}
+
+int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *log_root;
+
+	log_root = alloc_log_tree(trans, fs_info);
+	if (IS_ERR(log_root))
+		return PTR_ERR(log_root);
+	WARN_ON(fs_info->log_root_tree);
+	fs_info->log_root_tree = log_root;
+	return 0;
+}
+
+int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root)
+{
+	struct btrfs_root *log_root;
+	struct btrfs_inode_item *inode_item;
+
+	log_root = alloc_log_tree(trans, root->fs_info);
+	if (IS_ERR(log_root))
+		return PTR_ERR(log_root);
+
+	log_root->last_trans = trans->transid;
+	log_root->root_key.offset = root->root_key.objectid;
+
+	inode_item = &log_root->root_item.inode;
+	inode_item->generation = cpu_to_le64(1);
+	inode_item->size = cpu_to_le64(3);
+	inode_item->nlink = cpu_to_le32(1);
+	inode_item->nbytes = cpu_to_le64(root->leafsize);
+	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
+
+	btrfs_set_root_bytenr(&log_root->root_item, log_root->node->start);
+	btrfs_set_root_generation(&log_root->root_item, trans->transid);
+
+	WARN_ON(root->log_root);
+	root->log_root = log_root;
+	root->log_transid = 0;
 	return 0;
 }
 
@@ -1535,10 +1596,6 @@ struct btrfs_root *open_ctree(struct sup
 	init_waitqueue_head(&fs_info->transaction_throttle);
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
-	init_waitqueue_head(&fs_info->tree_log_wait);
-	atomic_set(&fs_info->tree_log_commit, 0);
-	atomic_set(&fs_info->tree_log_writers, 0);
-	fs_info->tree_log_transid = 0;
 
 	__setup_root(4096, 4096, 4096, 4096, tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
diff -urp 1/fs/btrfs/disk-io.h 2/fs/btrfs/disk-io.h
--- 1/fs/btrfs/disk-io.h	2008-12-09 08:27:03.010645557 +0800
+++ 2/fs/btrfs/disk-io.h	2009-01-19 15:42:02.000000000 +0800
@@ -98,5 +98,7 @@ int btrfs_free_log_root_tree(struct btrf
 			     struct btrfs_fs_info *fs_info);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
+int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root);
 int btree_lock_page_hook(struct page *page);
 #endif
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-01-07 07:16:42.762364700 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-01-19 15:42:02.000000000 +0800
@@ -2700,13 +2700,9 @@ static int __btrfs_free_extent(struct bt
 	/* if metadata always pin */
 	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
 		if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
-			struct btrfs_block_group_cache *cache;
-
-			/* btrfs_free_reserved_extent */
-			cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-			BUG_ON(!cache);
-			btrfs_add_free_space(cache, bytenr, num_bytes);
-			put_block_group(cache);
+			mutex_lock(&root->fs_info->pinned_mutex);
+			btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
+			mutex_unlock(&root->fs_info->pinned_mutex);
 			update_reserved_extents(root, bytenr, num_bytes, 0);
 			return 0;
 		}
diff -urp 1/fs/btrfs/file.c 2/fs/btrfs/file.c
--- 1/fs/btrfs/file.c	2009-01-07 07:16:42.765367735 +0800
+++ 2/fs/btrfs/file.c	2009-01-19 15:42:02.000000000 +0800
@@ -1215,10 +1215,10 @@ int btrfs_sync_file(struct file *file, s
 	}
 	mutex_unlock(&root->fs_info->trans_mutex);
 
-	root->fs_info->tree_log_batch++;
+	root->log_batch++;
 	filemap_fdatawrite(inode->i_mapping);
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
-	root->fs_info->tree_log_batch++;
+	root->log_batch++;
 
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2009-01-13 18:57:01.188452187 +0800
+++ 2/fs/btrfs/tree-log.c	2009-01-19 15:42:02.000000000 +0800
@@ -78,104 +78,6 @@ static int link_to_fixup_dir(struct btrf
  */
 
 /*
- * btrfs_add_log_tree adds a new per-subvolume log tree into the
- * tree of log tree roots.  This must be called with a tree log transaction
- * running (see start_log_trans).
- */
-static int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root)
-{
-	struct btrfs_key key;
-	struct btrfs_root_item root_item;
-	struct btrfs_inode_item *inode_item;
-	struct extent_buffer *leaf;
-	struct btrfs_root *new_root = root;
-	int ret;
-	u64 objectid = root->root_key.objectid;
-
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
-				      BTRFS_TREE_LOG_OBJECTID,
-				      trans->transid, 0, 0, 0);
-	if (IS_ERR(leaf)) {
-		ret = PTR_ERR(leaf);
-		return ret;
-	}
-
-	btrfs_set_header_nritems(leaf, 0);
-	btrfs_set_header_level(leaf, 0);
-	btrfs_set_header_bytenr(leaf, leaf->start);
-	btrfs_set_header_generation(leaf, trans->transid);
-	btrfs_set_header_owner(leaf, BTRFS_TREE_LOG_OBJECTID);
-
-	write_extent_buffer(leaf, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(leaf),
-			    BTRFS_FSID_SIZE);
-	btrfs_mark_buffer_dirty(leaf);
-
-	inode_item = &root_item.inode;
-	memset(inode_item, 0, sizeof(*inode_item));
-	inode_item->generation = cpu_to_le64(1);
-	inode_item->size = cpu_to_le64(3);
-	inode_item->nlink = cpu_to_le32(1);
-	inode_item->nbytes = cpu_to_le64(root->leafsize);
-	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
-
-	btrfs_set_root_bytenr(&root_item, leaf->start);
-	btrfs_set_root_generation(&root_item, trans->transid);
-	btrfs_set_root_level(&root_item, 0);
-	btrfs_set_root_refs(&root_item, 0);
-	btrfs_set_root_used(&root_item, 0);
-
-	memset(&root_item.drop_progress, 0, sizeof(root_item.drop_progress));
-	root_item.drop_level = 0;
-
-	btrfs_tree_unlock(leaf);
-	free_extent_buffer(leaf);
-	leaf = NULL;
-
-	btrfs_set_root_dirid(&root_item, 0);
-
-	key.objectid = BTRFS_TREE_LOG_OBJECTID;
-	key.offset = objectid;
-	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
-	ret = btrfs_insert_root(trans, root->fs_info->log_root_tree, &key,
-				&root_item);
-	if (ret)
-		goto fail;
-
-	new_root = btrfs_read_fs_root_no_radix(root->fs_info->log_root_tree,
-					       &key);
-	BUG_ON(!new_root);
-
-	WARN_ON(root->log_root);
-	root->log_root = new_root;
-
-	/*
-	 * log trees do not get reference counted because they go away
-	 * before a real commit is actually done.  They do store pointers
-	 * to file data extents, and those reference counts still get
-	 * updated (along with back refs to the log tree).
-	 */
-	new_root->ref_cows = 0;
-	new_root->last_trans = trans->transid;
-
-	/*
-	 * we need to make sure the root block for this new tree
-	 * is marked as dirty in the dirty_log_pages tree.  This
-	 * is how it gets flushed down to disk at tree log commit time.
-	 *
-	 * the tree logging mutex keeps others from coming in and changing
-	 * the new_root->node, so we can safely access it here
-	 */
-	set_extent_dirty(&new_root->dirty_log_pages, new_root->node->start,
-			 new_root->node->start + new_root->node->len - 1,
-			 GFP_NOFS);
-
-fail:
-	return ret;
-}
-
-/*
  * start a sub transaction and setup the log tree
  * this increments the log tree writer count to make the people
  * syncing the tree wait for us to finish
@@ -184,6 +86,14 @@ static int start_log_trans(struct btrfs_
 			   struct btrfs_root *root)
 {
 	int ret;
+
+	mutex_lock(&root->log_mutex);
+	if (root->log_root) {
+		root->log_batch++;
+		atomic_inc(&root->log_writers);
+		mutex_unlock(&root->log_mutex);
+		return 0;
+	}
 	mutex_lock(&root->fs_info->tree_log_mutex);
 	if (!root->fs_info->log_root_tree) {
 		ret = btrfs_init_log_root_tree(trans, root->fs_info);
@@ -193,9 +103,10 @@ static int start_log_trans(struct btrfs_
 		ret = btrfs_add_log_tree(trans, root);
 		BUG_ON(ret);
 	}
-	atomic_inc(&root->fs_info->tree_log_writers);
-	root->fs_info->tree_log_batch++;
 	mutex_unlock(&root->fs_info->tree_log_mutex);
+	root->log_batch++;
+	atomic_inc(&root->log_writers);
+	mutex_unlock(&root->log_mutex);
 	return 0;
 }
 
@@ -212,13 +123,12 @@ static int join_running_log_trans(struct
 	if (!root->log_root)
 		return -ENOENT;
 
-	mutex_lock(&root->fs_info->tree_log_mutex);
+	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
 		ret = 0;
-		atomic_inc(&root->fs_info->tree_log_writers);
-		root->fs_info->tree_log_batch++;
+		atomic_inc(&root->log_writers);
 	}
-	mutex_unlock(&root->fs_info->tree_log_mutex);
+	mutex_unlock(&root->log_mutex);
 	return ret;
 }
 
@@ -228,10 +138,11 @@ static int join_running_log_trans(struct
  */
 static int end_log_trans(struct btrfs_root *root)
 {
-	atomic_dec(&root->fs_info->tree_log_writers);
-	smp_mb();
-	if (waitqueue_active(&root->fs_info->tree_log_wait))
-		wake_up(&root->fs_info->tree_log_wait);
+	if (atomic_dec_and_test(&root->log_writers)) {
+		smp_mb();
+		if (waitqueue_active(&root->log_writer_wait))
+			wake_up(&root->log_writer_wait);
+	}
 	return 0;
 }
 
@@ -1902,26 +1813,59 @@ static int walk_log_tree(struct btrfs_tr
 		}
 	}
 	btrfs_free_path(path);
-	if (wc->free)
-		free_extent_buffer(log->node);
 	return ret;
 }
 
-static int wait_log_commit(struct btrfs_root *log)
+/*
+ * helper function to update the item for a given subvolumes log root
+ * in the tree of log roots
+ */
+static int update_log_root(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *log)
 {
-	DEFINE_WAIT(wait);
-	u64 transid = log->fs_info->tree_log_transid;
+	int ret;
 
+	if (log->log_transid == 1) {
+		/* insert root item on the first sync */
+		ret = btrfs_insert_root(trans, log->fs_info->log_root_tree,
+				&log->root_key, &log->root_item);
+	} else {
+		ret = btrfs_update_root(trans, log->fs_info->log_root_tree,
+				&log->root_key, &log->root_item);
+	}
+	return ret;
+}
+
+static int wait_log_commit(struct btrfs_root *root, unsigned long transid)
+{
+	DEFINE_WAIT(wait);
+	int index = transid % 2;
 	do {
-		prepare_to_wait(&log->fs_info->tree_log_wait, &wait,
-				TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&log->fs_info->tree_log_mutex);
-		if (atomic_read(&log->fs_info->tree_log_commit))
+		prepare_to_wait(&root->log_commit_wait[index],
+				&wait, TASK_UNINTERRUPTIBLE);
+		mutex_unlock(&root->log_mutex);
+		if (root->log_transid < transid + 2 &&
+		    atomic_read(&root->log_commit[index]))
 			schedule();
-		finish_wait(&log->fs_info->tree_log_wait, &wait);
-		mutex_lock(&log->fs_info->tree_log_mutex);
-	} while (transid == log->fs_info->tree_log_transid &&
-		atomic_read(&log->fs_info->tree_log_commit));
+		finish_wait(&root->log_commit_wait[index], &wait);
+		mutex_lock(&root->log_mutex);
+	} while (root->log_transid < transid + 2 &&
+		 atomic_read(&root->log_commit[index]));
+	return 0;
+}
+
+static int wait_for_writer(struct btrfs_root *root)
+{
+	DEFINE_WAIT(wait);
+	while (atomic_read(&root->log_writers)) {
+		prepare_to_wait(&root->log_writer_wait,
+				&wait, TASK_UNINTERRUPTIBLE);
+		mutex_unlock(&root->log_mutex);
+		if (atomic_read(&root->log_writers))
+			schedule();
+		mutex_lock(&root->log_mutex);
+		finish_wait(&root->log_writer_wait, &wait);
+	}
 	return 0;
 }
 
@@ -1933,57 +1877,106 @@ static int wait_log_commit(struct btrfs_
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root)
 {
+	int index1;
+	int index2;
 	int ret;
-	unsigned long batch;
 	struct btrfs_root *log = root->log_root;
+	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
 
-	mutex_lock(&log->fs_info->tree_log_mutex);
-	if (atomic_read(&log->fs_info->tree_log_commit)) {
-		wait_log_commit(log);
-		goto out;
+	mutex_lock(&root->log_mutex);
+	index1 = root->log_transid % 2;
+	if (atomic_read(&root->log_commit[index1])) {
+		wait_log_commit(root, root->log_transid);
+		mutex_unlock(&root->log_mutex);
+		return 0;
 	}
-	atomic_set(&log->fs_info->tree_log_commit, 1);
+	atomic_set(&root->log_commit[index1], 1);
+
+	/* wait for previous tree log sync to complete */
+	if (atomic_read(&root->log_commit[(index1 + 1) % 2]))
+		wait_log_commit(root, root->log_transid - 1);
 
 	while (1) {
-		batch = log->fs_info->tree_log_batch;
-		mutex_unlock(&log->fs_info->tree_log_mutex);
+		unsigned long batch = root->log_batch;
+		mutex_unlock(&root->log_mutex);
 		schedule_timeout_uninterruptible(1);
-		mutex_lock(&log->fs_info->tree_log_mutex);
-
-		while (atomic_read(&log->fs_info->tree_log_writers)) {
-			DEFINE_WAIT(wait);
-			prepare_to_wait(&log->fs_info->tree_log_wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-			mutex_unlock(&log->fs_info->tree_log_mutex);
-			if (atomic_read(&log->fs_info->tree_log_writers))
-				schedule();
-			mutex_lock(&log->fs_info->tree_log_mutex);
-			finish_wait(&log->fs_info->tree_log_wait, &wait);
-		}
-		if (batch == log->fs_info->tree_log_batch)
+		mutex_lock(&root->log_mutex);
+		wait_for_writer(root);
+		if (batch == root->log_batch)
 			break;
 	}
 
 	ret = btrfs_write_and_wait_marked_extents(log, &log->dirty_log_pages);
 	BUG_ON(ret);
-	ret = btrfs_write_and_wait_marked_extents(root->fs_info->log_root_tree,
-			       &root->fs_info->log_root_tree->dirty_log_pages);
+
+	btrfs_set_root_bytenr(&log->root_item, log->node->start);
+	btrfs_set_root_generation(&log->root_item, trans->transid);
+	btrfs_set_root_level(&log->root_item, btrfs_header_level(log->node));
+
+	root->log_batch = 0;
+	root->log_transid++;
+	log->log_transid = root->log_transid;
+	smp_mb();
+	/*
+	 * log tree has been flushed to disk, new modifications of
+	 * the log will be written to new positions. so it's safe to
+	 * allow log writers to go in.
+	 */
+	mutex_unlock(&root->log_mutex);
+
+	mutex_lock(&log_root_tree->log_mutex);
+	log_root_tree->log_batch++;
+	atomic_inc(&log_root_tree->log_writers);
+	mutex_unlock(&log_root_tree->log_mutex);
+
+	ret = update_log_root(trans, log);
+	BUG_ON(ret);
+
+	mutex_lock(&log_root_tree->log_mutex);
+	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
+		smp_mb();
+		if (waitqueue_active(&log_root_tree->log_writer_wait))
+			wake_up(&log_root_tree->log_writer_wait);
+	}
+
+	index2 = log_root_tree->log_transid % 2;
+	if (atomic_read(&log_root_tree->log_commit[index2])) {
+		wait_log_commit(log_root_tree, log_root_tree->log_transid);
+		mutex_unlock(&log_root_tree->log_mutex);
+		goto out;
+	}
+	atomic_set(&log_root_tree->log_commit[index2], 1);
+
+	if (atomic_read(&log_root_tree->log_commit[(index2 + 1) % 2]))
+		wait_log_commit(log_root_tree, log_root_tree->log_transid - 1);
+
+	wait_for_writer(log_root_tree);
+
+	ret = btrfs_write_and_wait_marked_extents(log_root_tree,
+				&log_root_tree->dirty_log_pages);
 	BUG_ON(ret);
 
 	btrfs_set_super_log_root(&root->fs_info->super_for_commit,
-				 log->fs_info->log_root_tree->node->start);
+				log_root_tree->node->start);
 	btrfs_set_super_log_root_level(&root->fs_info->super_for_commit,
-		       btrfs_header_level(log->fs_info->log_root_tree->node));
+				btrfs_header_level(log_root_tree->node));
+
+	log_root_tree->log_batch = 0;
+	log_root_tree->log_transid++;
+	smp_mb();
+	mutex_unlock(&log_root_tree->log_mutex);
+
+	write_ctree_super(trans, root->fs_info->tree_root, 2);
 
-	write_ctree_super(trans, log->fs_info->tree_root, 2);
-	log->fs_info->tree_log_transid++;
-	log->fs_info->tree_log_batch = 0;
-	atomic_set(&log->fs_info->tree_log_commit, 0);
+	atomic_set(&log_root_tree->log_commit[index2], 0);
 	smp_mb();
-	if (waitqueue_active(&log->fs_info->tree_log_wait))
-		wake_up(&log->fs_info->tree_log_wait);
+	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
+		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
-	mutex_unlock(&log->fs_info->tree_log_mutex);
+	atomic_set(&root->log_commit[index1], 0);
+	smp_mb();
+	if (waitqueue_active(&root->log_commit_wait[index1]))
+		wake_up(&root->log_commit_wait[index1]);
 	return 0;
 }
 
@@ -2019,38 +2012,18 @@ int btrfs_free_log(struct btrfs_trans_ha
 				   start, end, GFP_NOFS);
 	}
 
-	log = root->log_root;
-	ret = btrfs_del_root(trans, root->fs_info->log_root_tree,
-			     &log->root_key);
-	BUG_ON(ret);
+	if (log->log_transid > 0) {
+		ret = btrfs_del_root(trans, root->fs_info->log_root_tree,
+				     &log->root_key);
+		BUG_ON(ret);
+	}
 	root->log_root = NULL;
-	kfree(root->log_root);
+	free_extent_buffer(log->node);
+	kfree(log);
 	return 0;
 }
 
 /*
- * helper function to update the item for a given subvolumes log root
- * in the tree of log roots
- */
-static int update_log_root(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *log)
-{
-	u64 bytenr = btrfs_root_bytenr(&log->root_item);
-	int ret;
-
-	if (log->node->start == bytenr)
-		return 0;
-
-	btrfs_set_root_bytenr(&log->root_item, log->node->start);
-	btrfs_set_root_generation(&log->root_item, trans->transid);
-	btrfs_set_root_level(&log->root_item, btrfs_header_level(log->node));
-	ret = btrfs_update_root(trans, log->fs_info->log_root_tree,
-				&log->root_key, &log->root_item);
-	BUG_ON(ret);
-	return ret;
-}
-
-/*
  * If both a file and directory are logged, and unlinks or renames are
  * mixed in, we have a few interesting corners:
  *
@@ -2711,11 +2684,6 @@ next_slot:
 
 	btrfs_free_path(path);
 	btrfs_free_path(dst_path);
-
-	mutex_lock(&root->fs_info->tree_log_mutex);
-	ret = update_log_root(trans, log);
-	BUG_ON(ret);
-	mutex_unlock(&root->fs_info->tree_log_mutex);
 out:
 	return 0;
 }

