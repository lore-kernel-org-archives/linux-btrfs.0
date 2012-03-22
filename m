From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 30/35] btrfs: enhance transaction abort infrastructure
Date: Wed, 21 Mar 2012 21:11:34 -0400
Message-ID: <20120322011137.208823973@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |   13 +++-
 fs/btrfs/disk-io.c     |   50 ++++++++++++-
 fs/btrfs/disk-io.h     |    4 +
 fs/btrfs/relocation.c  |   14 ++--
 fs/btrfs/scrub.c       |    8 ++-
 fs/btrfs/super.c       |   74 +++++++++++++++++--
 fs/btrfs/transaction.c |  190 +++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/transaction.h |    3 +
 8 files changed, 300 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8829f80..b6ebea5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2968,6 +2968,16 @@ void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
 
+void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, const char *function,
+			       unsigned int line, int errno);
+
+#define btrfs_abort_transaction(trans, root, errno)		\
+do {								\
+	__btrfs_abort_transaction(trans, root, __func__,	\
+				  __LINE__, errno);		\
+} while (0)
+
 #define btrfs_std_error(fs_info, errno)				\
 do {								\
 	if ((errno))						\
@@ -3024,7 +3034,7 @@ void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 void btrfs_reloc_pre_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending,
 			      u64 *bytes_to_reserve);
-void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
+int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending);
 
 /* scrub.c */
@@ -3034,6 +3044,7 @@ void btrfs_scrub_pause(struct btrfs_root *root);
 void btrfs_scrub_pause_super(struct btrfs_root *root);
 void btrfs_scrub_continue(struct btrfs_root *root);
 void btrfs_scrub_continue_super(struct btrfs_root *root);
+int __btrfs_scrub_cancel(struct btrfs_fs_info *info);
 int btrfs_scrub_cancel(struct btrfs_root *root);
 int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev);
 int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 69ef456..6297a03 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,7 +61,6 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					int mark);
 static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 				       struct extent_io_tree *pinned_extents);
-static int btrfs_cleanup_transaction(struct btrfs_root *root);
 
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
@@ -2896,6 +2895,19 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/* Kill all outstanding I/O */
+void btrfs_abort_devices(struct btrfs_root *root)
+{
+	struct list_head *head;
+	struct btrfs_device *dev;
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	head = &root->fs_info->fs_devices->devices;
+	list_for_each_entry_rcu(dev, head, dev_list) {
+		blk_abort_queue(dev->bdev->bd_disk->queue);
+	}
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+}
+
 void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
@@ -3536,13 +3548,43 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 	return 0;
 }
 
-static int btrfs_cleanup_transaction(struct btrfs_root *root)
+void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
+				   struct btrfs_root *root)
+{
+	btrfs_destroy_delayed_refs(cur_trans, root);
+	btrfs_block_rsv_release(root, &root->fs_info->trans_block_rsv,
+				cur_trans->dirty_pages.dirty_bytes);
+
+	/* FIXME: cleanup wait for commit */
+	cur_trans->in_commit = 1;
+	cur_trans->blocked = 1;
+	if (waitqueue_active(&root->fs_info->transaction_blocked_wait))
+		wake_up(&root->fs_info->transaction_blocked_wait);
+
+	cur_trans->blocked = 0;
+	if (waitqueue_active(&root->fs_info->transaction_wait))
+		wake_up(&root->fs_info->transaction_wait);
+
+	cur_trans->commit_done = 1;
+	if (waitqueue_active(&cur_trans->commit_wait))
+		wake_up(&cur_trans->commit_wait);
+
+	btrfs_destroy_pending_snapshots(cur_trans);
+
+	btrfs_destroy_marked_extents(root, &cur_trans->dirty_pages,
+				     EXTENT_DIRTY);
+
+	/*
+	memset(cur_trans, 0, sizeof(*cur_trans));
+	kmem_cache_free(btrfs_transaction_cachep, cur_trans);
+	*/
+}
+
+int btrfs_cleanup_transaction(struct btrfs_root *root)
 {
 	struct btrfs_transaction *t;
 	LIST_HEAD(list);
 
-	WARN_ON(1);
-
 	mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 	spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 1608492..a7ace1a 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -85,6 +85,10 @@ int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root);
+int btrfs_cleanup_transaction(struct btrfs_root *root);
+void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
+				  struct btrfs_root *root);
+void btrfs_abort_devices(struct btrfs_root *root);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void btrfs_init_lockdep(void);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a87678e..cba7a0b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4410,7 +4410,7 @@ void btrfs_reloc_pre_snapshot(struct btrfs_trans_handle *trans,
  * called after snapshot is created. migrate block reservation
  * and create reloc root for the newly created snapshot
  */
-void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
+int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			       struct btrfs_pending_snapshot *pending)
 {
 	struct btrfs_root *root = pending->root;
@@ -4420,7 +4420,7 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (!root->reloc_root)
-		return;
+		return 0;
 
 	rc = root->fs_info->reloc_ctl;
 	rc->merging_rsv_size += rc->nodes_relocated;
@@ -4429,19 +4429,21 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      rc->block_rsv,
 					      rc->nodes_relocated);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 	new_root = pending->snap;
 	reloc_root = create_reloc_root(trans, root->reloc_root,
 				       new_root->root_key.objectid);
+	if (IS_ERR(reloc_root))
+		return PTR_ERR(reloc_root);
 
 	ret = __add_reloc_root(reloc_root);
 	BUG_ON(ret < 0);
 	new_root->reloc_root = reloc_root;
 
-	if (rc->create_reloc_tree) {
+	if (rc->create_reloc_tree)
 		ret = clone_backref_node(trans, rc, root, reloc_root);
-		BUG_ON(ret);
-	}
+	return ret;
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a2e8aa4..794cbb5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1680,9 +1680,8 @@ void btrfs_scrub_continue_super(struct btrfs_root *root)
 	up_write(&root->fs_info->scrub_super_lock);
 }
 
-int btrfs_scrub_cancel(struct btrfs_root *root)
+int __btrfs_scrub_cancel(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	mutex_lock(&fs_info->scrub_lock);
 	if (!atomic_read(&fs_info->scrubs_running)) {
@@ -1703,6 +1702,11 @@ int btrfs_scrub_cancel(struct btrfs_root *root)
 	return 0;
 }
 
+int btrfs_scrub_cancel(struct btrfs_root *root)
+{
+	return __btrfs_scrub_cancel(root->fs_info);
+}
+
 int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fe69ee..0517bd7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -119,6 +119,8 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		sb->s_flags |= MS_RDONLY;
 		printk(KERN_INFO "btrfs is forced readonly\n");
+		__btrfs_scrub_cancel(fs_info);
+//		WARN_ON(1);
 	}
 }
 
@@ -198,6 +200,34 @@ void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 }
 
 /*
+ * We only mark the transaction aborted and then set the file system read-only.
+ * This will prevent new transactions from starting or trying to join this
+ * one.
+ *
+ * This means that error recovery at the call site is limited to freeing
+ * any local memory allocations and passing the error code up without
+ * further cleanup. The transaction should complete as it normally would
+ * in the call path but will return -EIO.
+ *
+ * We'll complete the cleanup in btrfs_end_transaction and
+ * btrfs_commit_transaction.
+ */
+void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, const char *function,
+			       unsigned int line, int errno)
+{
+	WARN_ON_ONCE(1);
+	trans->aborted = errno;
+	/* Nothing used. The other threads that have joined this
+	 * transaction may be able to continue. */
+	if (!trans->blocks_used) {
+		btrfs_printk(root->fs_info, "Aborting unused transaction.\n");
+		return;
+	}
+	trans->transaction->aborted = errno;
+	__btrfs_std_error(root->fs_info, function, line, errno, NULL);
+}
+/*
  * __btrfs_panic decodes unexpected, fatal errors from the caller,
  * issues an alert, and either panics or BUGs, depending on mount options.
  */
@@ -295,6 +325,7 @@ static match_table_t tokens = {
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
+ * XXX JDM: This needs to be cleaned up for remount.
  */
 int btrfs_parse_options(struct btrfs_root *root, char *options)
 {
@@ -1096,11 +1127,20 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
+	unsigned old_flags = sb->s_flags;
+	unsigned long old_opts = fs_info->mount_opt;
+	unsigned long old_compress_type = fs_info->compress_type;
+	u64 old_max_inline = fs_info->max_inline;
+	u64 old_alloc_start = fs_info->alloc_start;
+	int old_thread_pool_size = fs_info->thread_pool_size;
+	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
 
 	ret = btrfs_parse_options(root, data);
-	if (ret)
-		return -EINVAL;
+	if (ret) {
+		ret = -EINVAL;
+		goto restore;
+	}
 
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
@@ -1108,26 +1148,44 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (*flags & MS_RDONLY) {
 		sb->s_flags |= MS_RDONLY;
 
-		ret =  btrfs_commit_super(root);
-		WARN_ON(ret);
+		ret = btrfs_commit_super(root);
+		if (ret)
+			goto restore;
 	} else {
 		if (fs_info->fs_devices->rw_devices == 0)
-			return -EACCES;
+			ret = -EACCES;
+			goto restore;
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0)
-			return -EINVAL;
+			ret = -EINVAL;
+			goto restore;
 
 		ret = btrfs_cleanup_fs_roots(fs_info);
-		WARN_ON(ret);
+		if (ret)
+			goto restore;
 
 		/* recover relocation */
 		ret = btrfs_recover_relocation(root);
-		WARN_ON(ret);
+		if (ret)
+			goto restore;
 
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
 	return 0;
+
+restore:
+	/* We've hit an error - don't reset MS_RDONLY */
+	if (sb->s_flags & MS_RDONLY)
+		old_flags |= MS_RDONLY;
+	sb->s_flags = old_flags;
+	fs_info->mount_opt = old_opts;
+	fs_info->compress_type = old_compress_type;
+	fs_info->max_inline = old_max_inline;
+	fs_info->alloc_start = old_alloc_start;
+	fs_info->thread_pool_size = old_thread_pool_size;
+	fs_info->metadata_ratio = old_metadata_ratio;
+	return ret;
 }
 
 /* Used to sort the devices by max_avail(descending sort) */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fb5cd5a..5a4999a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -31,7 +31,7 @@
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
-static noinline void put_transaction(struct btrfs_transaction *transaction)
+void put_transaction(struct btrfs_transaction *transaction)
 {
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
@@ -58,6 +58,12 @@ static noinline int join_transaction(struct btrfs_root *root, int nofail)
 
 	spin_lock(&root->fs_info->trans_lock);
 loop:
+	/* The file system has been taken offline. No new transactions. */
+	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		spin_unlock(&root->fs_info->trans_lock);
+		return -EROFS;
+	}
+
 	if (root->fs_info->trans_no_join) {
 		if (!nofail) {
 			spin_unlock(&root->fs_info->trans_lock);
@@ -67,6 +73,8 @@ loop:
 
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans) {
+		if (cur_trans->aborted)
+			return cur_trans->aborted;
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
@@ -123,6 +131,7 @@ loop:
 	root->fs_info->generation++;
 	cur_trans->transid = root->fs_info->generation;
 	root->fs_info->running_transaction = cur_trans;
+	cur_trans->aborted = 0;
 	spin_unlock(&root->fs_info->trans_lock);
 
 	return 0;
@@ -318,6 +327,7 @@ again:
 	h->use_count = 1;
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
+	h->aborted = 0;
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -440,6 +450,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_block_rsv *rsv = trans->block_rsv;
 	int updates;
+	int err;
 
 	smp_mb();
 	if (cur_trans->blocked || cur_trans->delayed_refs.flushing)
@@ -453,8 +464,11 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 
 	updates = trans->delayed_ref_updates;
 	trans->delayed_ref_updates = 0;
-	if (updates)
-		btrfs_run_delayed_refs(trans, root, updates);
+	if (updates) {
+		err = btrfs_run_delayed_refs(trans, root, updates);
+		if (err) /* Error code will also eval true */
+			return err;
+	}
 
 	trans->block_rsv = rsv;
 
@@ -525,6 +539,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (throttle)
 		btrfs_run_delayed_iputs(root);
 
+	if (trans->aborted ||
+	    root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		return -EIO;
+	}
+
 	return 0;
 }
 
@@ -690,11 +709,13 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_root(trans, tree_root,
 					&root->root_key,
 					&root->root_item);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 
 		old_root_used = btrfs_root_used(&root->root_item);
 		ret = btrfs_write_dirty_block_groups(trans, root);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 	if (root != root->fs_info->extent_root)
@@ -705,6 +726,10 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 
 /*
  * update all the cowonly tree roots on disk
+ *
+ * The error handling in this function may not be obvious. Any of the
+ * failures will cause the file system to go offline. We still need
+ * to clean up the delayed refs.
  */
 static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root)
@@ -715,22 +740,30 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	eb = btrfs_lock_root_node(fs_info->tree_root);
-	btrfs_cow_block(trans, fs_info->tree_root, eb, NULL, 0, &eb);
+	ret = btrfs_cow_block(trans, fs_info->tree_root, eb, NULL,
+			      0, &eb);
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
 
+	if (ret)
+		return ret;
+
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
 		root = list_entry(next, struct btrfs_root, dirty_list);
 
-		update_cowonly_root(trans, root);
+		ret = update_cowonly_root(trans, root);
+		if (ret)
+			return ret;
 	}
 
 	down_write(&fs_info->extent_commit_sem);
@@ -874,7 +907,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
-		pending->error = -ENOMEM;
+		ret = pending->error = -ENOMEM;
 		goto fail;
 	}
 
@@ -911,7 +944,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
-	BUG_ON(ret);
+	BUG_ON(ret); /* -ENOMEM */
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				dentry->d_name.name, dentry->d_name.len,
 				parent_inode, &key,
@@ -920,12 +953,14 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		pending->error = -EEXIST;
 		dput(parent);
 		goto fail;
-	}
+	} else if (ret)
+		goto abort_trans;
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	BUG_ON(ret);
+	if (ret)
+		goto abort_trans;
 
 	/*
 	 * pull in the delayed directory update
@@ -934,7 +969,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * snapshot
 	 */
 	ret = btrfs_run_delayed_items(trans, root);
-	BUG_ON(ret);
+	if (ret) /* Transaction aborted */
+		goto fail;
 
 	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
@@ -949,10 +985,16 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_set_root_flags(new_root_item, root_flags);
 
 	old = btrfs_lock_root_node(root);
-	btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	ret = btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	if (ret)
+		goto abort_trans;
+
 	btrfs_set_lock_blocking(old);
 
-	btrfs_copy_root(trans, root, old, &tmp, objectid);
+	ret = btrfs_copy_root(trans, root, old, &tmp, objectid);
+	if (ret)
+		goto abort_trans;
+
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
 
@@ -966,7 +1008,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_root(trans, tree_root, &key, new_root_item);
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
-	BUG_ON(ret);
+	if (ret)
+		goto abort_trans;
 
 	/*
 	 * insert root back/forward references
@@ -975,19 +1018,28 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
-	BUG_ON(ret);
+	if (ret)
+		goto fail;
 	dput(parent);
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_read_fs_root_no_name(root->fs_info, &key);
-	BUG_ON(IS_ERR(pending->snap));
+	if (IS_ERR(pending->snap))
+		goto abort_trans;
 
-	btrfs_reloc_post_snapshot(trans, pending);
+	ret = btrfs_reloc_post_snapshot(trans, pending);
+	if (ret)
+		goto abort_trans;
+	ret = 0;
 fail:
 	kfree(new_root_item);
 	trans->block_rsv = rsv;
 	btrfs_block_rsv_release(root, &pending->block_rsv, (u64)-1);
-	return 0;
+	return ret;
+
+abort_trans:
+	btrfs_abort_transaction(trans, root, ret);
+	goto fail;
 }
 
 /*
@@ -1124,6 +1176,33 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+
+static void cleanup_transaction(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root)
+{
+	struct btrfs_transaction *cur_trans = trans->transaction;
+
+	WARN_ON(trans->use_count > 1);
+
+	spin_lock(&root->fs_info->trans_lock);
+	list_del_init(&cur_trans->list);
+	spin_unlock(&root->fs_info->trans_lock);
+
+	btrfs_cleanup_one_transaction(trans->transaction, root);
+
+	put_transaction(cur_trans);
+	put_transaction(cur_trans);
+
+	trace_btrfs_transaction_commit(root);
+
+	btrfs_scrub_continue(root);
+
+	if (current->journal_info == trans)
+		current->journal_info = NULL;
+
+	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+}
+
 /*
  * btrfs_transaction state sequence:
  *    in_commit = 0, blocked = 0  (initial)
@@ -1135,10 +1214,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
 	unsigned long joined = 0;
-	struct btrfs_transaction *cur_trans;
+	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	DEFINE_WAIT(wait);
-	int ret;
+	int ret = -EIO;
 	int should_grow = 0;
 	unsigned long now = get_seconds();
 	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
@@ -1148,13 +1227,18 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
+	if (cur_trans->aborted)
+		goto cleanup_transaction;
+
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	BUG_ON(ret);
+	if (ret)
+		goto cleanup_transaction;
 
 	cur_trans = trans->transaction;
+
 	/*
 	 * set the flushing flag so procs in this transaction have to
 	 * start sending their work down.
@@ -1162,19 +1246,20 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	cur_trans->delayed_refs.flushing = 1;
 
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	BUG_ON(ret);
+	if (ret)
+		goto cleanup_transaction;
 
 	spin_lock(&cur_trans->commit_lock);
 	if (cur_trans->in_commit) {
 		spin_unlock(&cur_trans->commit_lock);
 		atomic_inc(&cur_trans->use_count);
-		btrfs_end_transaction(trans, root);
+		ret = btrfs_end_transaction(trans, root);
 
 		wait_for_commit(root, cur_trans);
 
 		put_transaction(cur_trans);
 
-		return 0;
+		return ret;
 	}
 
 	trans->transaction->in_commit = 1;
@@ -1218,7 +1303,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		}
 
 		ret = btrfs_run_delayed_items(trans, root);
-		BUG_ON(ret);
+		if (ret)
+			goto cleanup_transaction;
 
 		/*
 		 * rename don't use btrfs_join_transaction, so, once we
@@ -1260,13 +1346,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	mutex_lock(&root->fs_info->reloc_mutex);
 
 	ret = btrfs_run_delayed_items(trans, root);
-	BUG_ON(ret);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto cleanup_transaction;
+	}
 
 	ret = create_pending_snapshots(trans, root->fs_info);
-	BUG_ON(ret);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto cleanup_transaction;
+	}
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	if (ret) {
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		goto cleanup_transaction;
+	}
 
 	/*
 	 * make sure none of the code above managed to slip in a
@@ -1293,7 +1388,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	mutex_lock(&root->fs_info->tree_log_mutex);
 
 	ret = commit_fs_roots(trans, root);
-	BUG_ON(ret);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto cleanup_transaction;
+	}
 
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
@@ -1301,7 +1399,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
 	ret = commit_cowonly_roots(trans, root);
-	BUG_ON(ret);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto cleanup_transaction;
+	}
 
 	btrfs_prepare_extent_commit(trans, root);
 
@@ -1335,8 +1436,18 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	wake_up(&root->fs_info->transaction_wait);
 
 	ret = btrfs_write_and_wait_transaction(trans, root);
-	BUG_ON(ret);
-	write_ctree_super(trans, root, 0);
+	if (ret) {
+		btrfs_error(root->fs_info, ret,
+			    "Error while writing out transaction.");
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto cleanup_transaction;
+	}
+
+	ret = write_ctree_super(trans, root, 0);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto cleanup_transaction;
+	}
 
 	/*
 	 * the super is written, we can safely allow the tree-loggers
@@ -1372,6 +1483,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		btrfs_run_delayed_iputs(root);
 
 	return ret;
+
+cleanup_transaction:
+	btrfs_printk(root->fs_info, "Skipping commit of aborted transaction.\n");
+//	WARN_ON(1);
+	if (current->journal_info == trans)
+		current->journal_info = NULL;
+	cleanup_transaction(trans, root);
+
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 02564e6..fe27379 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -43,6 +43,7 @@ struct btrfs_transaction {
 	wait_queue_head_t commit_wait;
 	struct list_head pending_snapshots;
 	struct btrfs_delayed_ref_root delayed_refs;
+	int aborted;
 };
 
 struct btrfs_trans_handle {
@@ -55,6 +56,7 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	int aborted;
 };
 
 struct btrfs_pending_snapshot {
@@ -114,4 +116,5 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
+void put_transaction(struct btrfs_transaction *transaction);
 #endif
-- 
1.7.9



