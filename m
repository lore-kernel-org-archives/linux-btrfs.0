From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH V2 08/12] Btrfs: Introduce global metadata reservation
Date: Mon, 26 Apr 2010 18:45:29 +0800
Message-ID: <4BD56EC9.2080604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Reserve metadata space for extent tree, checksum tree and root tree

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2010-04-26 17:27:31.644829469 +0800
+++ 3/fs/btrfs/ctree.h	2010-04-26 17:27:31.648830941 +0800
@@ -682,21 +682,15 @@ struct btrfs_space_info {
 	u64 bytes_reserved;	/* total bytes the allocator has reserved for
 				   current allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
-	u64 bytes_super;	/* total bytes reserved for the super blocks */
-	u64 bytes_root;		/* the number of bytes needed to commit a
-				   transaction */
+
 	u64 bytes_may_use;	/* number of bytes that may be used for
 				   delalloc/allocations */
-	u64 bytes_delalloc;	/* number of bytes currently reserved for
-				   delayed allocation */
 	u64 disk_used;		/* total bytes used on disk */
 
 	int full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
 	int force_alloc;	/* set if we need to force a chunk alloc for
 				   this space */
-	int force_delalloc;	/* make people start doing filemap_flush until
-				   we're under a threshold */
 
 	struct list_head list;
 
diff -urp 2/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 2/fs/btrfs/disk-io.c	2010-04-26 17:27:31.638850832 +0800
+++ 3/fs/btrfs/disk-io.c	2010-04-26 17:27:31.649830174 +0800
@@ -1472,10 +1472,6 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
-		smp_mb();
-		if (root->fs_info->closing)
-			break;
-
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
@@ -1488,11 +1484,9 @@ static int cleaner_kthread(void *arg)
 		if (freezing(current)) {
 			refrigerator();
 		} else {
-			smp_mb();
-			if (root->fs_info->closing)
-				break;
 			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
+			if (!kthread_should_stop())
+				schedule();
 			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
@@ -1504,36 +1498,39 @@ static int transaction_kthread(void *arg
 	struct btrfs_root *root = arg;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_transaction *cur;
+	u64 transid;
 	unsigned long now;
 	unsigned long delay;
 	int ret;
 
 	do {
-		smp_mb();
-		if (root->fs_info->closing)
-			break;
-
 		delay = HZ * 30;
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
-		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
-		mutex_lock(&root->fs_info->trans_mutex);
+		spin_lock(&root->fs_info->new_trans_lock);
 		cur = root->fs_info->running_transaction;
 		if (!cur) {
-			mutex_unlock(&root->fs_info->trans_mutex);
+			spin_unlock(&root->fs_info->new_trans_lock);
 			goto sleep;
 		}
 
 		now = get_seconds();
-		if (now < cur->start_time || now - cur->start_time < 30) {
-			mutex_unlock(&root->fs_info->trans_mutex);
+		if (!cur->blocked &&
+		    (now < cur->start_time || now - cur->start_time < 30)) {
+			spin_unlock(&root->fs_info->new_trans_lock);
 			delay = HZ * 5;
 			goto sleep;
 		}
-		mutex_unlock(&root->fs_info->trans_mutex);
-		trans = btrfs_join_transaction(root, 1);
-		ret = btrfs_commit_transaction(trans, root);
+		transid = cur->transid;
+		spin_unlock(&root->fs_info->new_trans_lock);
 
+		trans = btrfs_join_transaction(root, 1);
+		if (transid == trans->transid) {
+			ret = btrfs_commit_transaction(trans, root);
+			BUG_ON(ret);
+		} else {
+			btrfs_end_transaction(trans, root);
+		}
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
@@ -1541,10 +1538,10 @@ sleep:
 		if (freezing(current)) {
 			refrigerator();
 		} else {
-			if (root->fs_info->closing)
-				break;
 			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(delay);
+			if (!kthread_should_stop() &&
+			    !btrfs_transaction_blocked(root->fs_info))
+				schedule_timeout(delay);
 			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
@@ -1926,17 +1923,18 @@ struct btrfs_root *open_ctree(struct sup
 
 	csum_root->track_dirty = 1;
 
+	fs_info->generation = generation;
+	fs_info->last_trans_committed = generation;
+	fs_info->data_alloc_profile = (u64)-1;
+	fs_info->metadata_alloc_profile = (u64)-1;
+	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
+
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
 		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
 		goto fail_block_groups;
 	}
 
-	fs_info->generation = generation;
-	fs_info->last_trans_committed = generation;
-	fs_info->data_alloc_profile = (u64)-1;
-	fs_info->metadata_alloc_profile = (u64)-1;
-	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
@@ -2439,15 +2437,15 @@ int close_ctree(struct btrfs_root *root)
 	fs_info->closing = 1;
 	smp_mb();
 
-	kthread_stop(root->fs_info->transaction_kthread);
-	kthread_stop(root->fs_info->cleaner_kthread);
-
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret =  btrfs_commit_super(root);
 		if (ret)
 			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
 	}
 
+	kthread_stop(root->fs_info->transaction_kthread);
+	kthread_stop(root->fs_info->cleaner_kthread);
+
 	fs_info->closing = 2;
 	smp_mb();
 
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2010-04-26 17:27:31.644829469 +0800
+++ 3/fs/btrfs/extent-tree.c	2010-04-26 17:27:31.651829828 +0800
@@ -2894,10 +2894,9 @@ int btrfs_check_data_free_space(struct i
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
-	used = data_sinfo->bytes_used + data_sinfo->bytes_delalloc +
-		data_sinfo->bytes_reserved + data_sinfo->bytes_pinned +
-		data_sinfo->bytes_readonly + data_sinfo->bytes_may_use +
-		data_sinfo->bytes_super;
+	used = data_sinfo->bytes_used + data_sinfo->bytes_reserved +
+		data_sinfo->bytes_pinned + data_sinfo->bytes_readonly +
+		data_sinfo->bytes_may_use;
 
 	if (used + bytes > data_sinfo->total_bytes) {
 		struct btrfs_trans_handle *trans;
@@ -2921,7 +2920,7 @@ alloc:
 					     bytes + 2 * 1024 * 1024,
 					     alloc_target, 0);
 			btrfs_end_transaction(trans, root);
-			if (ret)
+			if (ret < 0)
 				return ret;
 
 			if (!data_sinfo) {
@@ -2944,11 +2943,10 @@ alloc:
 			goto again;
 		}
 
-		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
-		       ", %llu bytes_used, %llu bytes_reserved, "
-		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use "
-		       "%llu total\n", (unsigned long long)bytes,
-		       (unsigned long long)data_sinfo->bytes_delalloc,
+		printk(KERN_ERR "no space left, need %llu, %llu bytes_used, "
+		       "%llu bytes_reserved, " "%llu bytes_pinned, "
+		       "%llu bytes_readonly, %llu may use %llu total\n",
+		       (unsigned long long)bytes,
 		       (unsigned long long)data_sinfo->bytes_used,
 		       (unsigned long long)data_sinfo->bytes_reserved,
 		       (unsigned long long)data_sinfo->bytes_pinned,
@@ -3463,6 +3461,91 @@ void btrfs_block_rsv_release(struct btrf
 	block_rsv_release_bytes(block_rsv, global_rsv, num_bytes);
 }
 
+/*
+ * helper to calculate size of global block reservation.
+ * the desired value is sum of space used by extent tree,
+ * checksum tree and root tree
+ */
+static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_space_info *sinfo;
+	u64 num_bytes;
+	u64 meta_used;
+	u64 data_used;
+	int csum_size = btrfs_super_csum_size(&fs_info->super_copy);
+#if 0
+	/*
+	 * per tree used space accounting can be inaccuracy, so we
+	 * can't rely on it.
+	 */
+	spin_lock(&fs_info->extent_root->accounting_lock);
+	num_bytes = btrfs_root_used(&fs_info->extent_root->root_item);
+	spin_unlock(&fs_info->extent_root->accounting_lock);
+
+	spin_lock(&fs_info->csum_root->accounting_lock);
+	num_bytes += btrfs_root_used(&fs_info->csum_root->root_item);
+	spin_unlock(&fs_info->csum_root->accounting_lock);
+
+	spin_lock(&fs_info->tree_root->accounting_lock);
+	num_bytes += btrfs_root_used(&fs_info->tree_root->root_item);
+	spin_unlock(&fs_info->tree_root->accounting_lock);
+#endif
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
+	spin_lock(&sinfo->lock);
+	data_used = sinfo->bytes_used;
+	spin_unlock(&sinfo->lock);
+
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
+	spin_lock(&sinfo->lock);
+	meta_used = sinfo->bytes_used;
+	spin_unlock(&sinfo->lock);
+
+	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
+		    csum_size * 2;
+	num_bytes += div64_u64(data_used + meta_used, 50);
+
+	if (num_bytes * 3 > meta_used)
+		num_bytes = div64_u64(meta_used, 3);
+
+	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
+}
+
+static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
+	struct btrfs_space_info *sinfo = block_rsv->space_info;
+	u64 num_bytes;
+
+	num_bytes = calc_global_metadata_size(fs_info);
+
+	spin_lock(&block_rsv->lock);
+	spin_lock(&sinfo->lock);
+
+	block_rsv->size = num_bytes;
+
+	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
+		    sinfo->bytes_reserved + sinfo->bytes_readonly;
+
+	if (sinfo->total_bytes > num_bytes) {
+		num_bytes = sinfo->total_bytes - num_bytes;
+		block_rsv->reserved += num_bytes;
+		sinfo->bytes_reserved += num_bytes;
+	}
+
+	if (block_rsv->reserved >= block_rsv->size) {
+		num_bytes = block_rsv->reserved - block_rsv->size;
+		sinfo->bytes_reserved -= num_bytes;
+		block_rsv->reserved = block_rsv->size;
+		block_rsv->full = 1;
+	}
+#if 0
+	printk(KERN_INFO"global block rsv size %llu reserved %llu\n",
+		block_rsv->size, block_rsv->reserved);
+#endif
+	spin_unlock(&sinfo->lock);
+	spin_unlock(&block_rsv->lock);
+}
+
 static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_space_info *space_info;
@@ -3472,11 +3555,36 @@ static void init_global_block_rsv(struct
 	fs_info->chunk_block_rsv.priority = 10;
 
 	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
+	fs_info->global_block_rsv.space_info = space_info;
+	fs_info->global_block_rsv.priority = 10;
+	fs_info->global_block_rsv.refill_used = 1;
+	fs_info->delalloc_block_rsv.space_info = space_info;
 	fs_info->trans_block_rsv.space_info = space_info;
 	fs_info->empty_block_rsv.space_info = space_info;
 	fs_info->empty_block_rsv.priority = 10;
 
+	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
+
+	btrfs_add_durable_block_rsv(fs_info, &fs_info->global_block_rsv);
+
+	btrfs_add_durable_block_rsv(fs_info, &fs_info->delalloc_block_rsv);
+
+	update_global_block_rsv(fs_info);
+}
+
+static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
+{
+	block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);
+	WARN_ON(fs_info->delalloc_block_rsv.size > 0);
+	WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
+	WARN_ON(fs_info->trans_block_rsv.size > 0);
+	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
+	WARN_ON(fs_info->chunk_block_rsv.size > 0);
+	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
 }
 
 static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
@@ -3825,6 +3933,8 @@ int btrfs_prepare_extent_commit(struct b
 		fs_info->pinned_extents = &fs_info->freed_extents[0];
 
 	up_write(&fs_info->extent_commit_sem);
+
+	update_global_block_rsv(fs_info);
 	return 0;
 }
 
@@ -4817,19 +4927,16 @@ static void dump_space_info(struct btrfs
 	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
 				    info->bytes_pinned - info->bytes_reserved -
-				    info->bytes_super),
+				    info->bytes_readonly),
 	       (info->full) ? "" : "not ");
-	printk(KERN_INFO "space_info total=%llu, pinned=%llu, delalloc=%llu,"
-	       " may_use=%llu, used=%llu, root=%llu, super=%llu, reserved=%llu"
-	       "\n",
+	printk(KERN_INFO "space_info total=%llu, used=%llu, pinned=%llu, "
+	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
 	       (unsigned long long)info->total_bytes,
+	       (unsigned long long)info->bytes_used,
 	       (unsigned long long)info->bytes_pinned,
-	       (unsigned long long)info->bytes_delalloc,
+	       (unsigned long long)info->bytes_reserved,
 	       (unsigned long long)info->bytes_may_use,
-	       (unsigned long long)info->bytes_used,
-	       (unsigned long long)info->bytes_root,
-	       (unsigned long long)info->bytes_super,
-	       (unsigned long long)info->bytes_reserved);
+	       (unsigned long long)info->bytes_readonly);
 	spin_unlock(&info->lock);
 
 	if (!dump_block_groups)
@@ -7726,6 +7833,8 @@ int btrfs_free_block_groups(struct btrfs
 	 */
 	synchronize_rcu();
 
+	release_global_block_rsv(info);
+
 	while(!list_empty(&info->space_info)) {
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2010-04-26 17:27:31.640840079 +0800
+++ 3/fs/btrfs/inode.c	2010-04-26 17:27:31.653829551 +0800
@@ -4059,7 +4059,7 @@ int btrfs_write_inode(struct inode *inod
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
-	if (root->fs_info->btree_inode == inode)
+	if (BTRFS_I(inode)->dummy_inode)
 		return 0;
 
 	if (wait) {
@@ -4080,10 +4080,19 @@ void btrfs_dirty_inode(struct inode *ino
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
+	int ret;
+
+	if (BTRFS_I(inode)->dummy_inode)
+		return;
 
 	trans = btrfs_join_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
-	btrfs_update_inode(trans, root, inode);
+
+	ret = btrfs_update_inode(trans, root, inode);
+	if (ret)
+		printk(KERN_ERR"btrfs: fail to dirty inode %lu error %d\n",
+			inode->i_ino, ret);
+
 	btrfs_end_transaction(trans, root);
 }
 
diff -urp 2/fs/btrfs/ioctl.c 3/fs/btrfs/ioctl.c
--- 2/fs/btrfs/ioctl.c	2010-04-26 17:27:31.638850832 +0800
+++ 3/fs/btrfs/ioctl.c	2010-04-26 17:27:31.654850854 +0800
@@ -1340,8 +1340,10 @@ static int btrfs_ioctl_defrag(struct fil
 			ret = -EPERM;
 			goto out;
 		}
-		btrfs_defrag_root(root, 0);
-		btrfs_defrag_root(root->fs_info->extent_root, 0);
+		ret = btrfs_defrag_root(root, 0);
+		if (ret)
+			goto out;
+		ret = btrfs_defrag_root(root->fs_info->extent_root, 0);
 		break;
 	case S_IFREG:
 		if (!(file->f_mode & FMODE_WRITE)) {
@@ -1371,9 +1373,11 @@ static int btrfs_ioctl_defrag(struct fil
 			/* the rest are all set to zero by kzalloc */
 			range->len = (u64)-1;
 		}
-		btrfs_defrag_file(file, range);
+		ret = btrfs_defrag_file(file, range);
 		kfree(range);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 out:
 	mnt_drop_write(file->f_path.mnt);
diff -urp 2/fs/btrfs/transaction.c 3/fs/btrfs/transaction.c
--- 2/fs/btrfs/transaction.c	2010-04-26 17:27:31.638850832 +0800
+++ 3/fs/btrfs/transaction.c	2010-04-26 17:27:31.654850854 +0800
@@ -320,10 +320,36 @@ void btrfs_throttle(struct btrfs_root *r
 	mutex_unlock(&root->fs_info->trans_mutex);
 }
 
+static int should_end_transaction(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root)
+{
+	int ret;
+	ret = btrfs_block_rsv_check(trans, root,
+				    &root->fs_info->global_block_rsv, 0, 5);
+	return ret ? 1 : 0;
+}
+
+int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root)
+{
+	struct btrfs_transaction *cur_trans = trans->transaction;
+	int updates;
+
+	if (cur_trans->blocked || cur_trans->delayed_refs.flushing)
+		return 1;
+
+	updates = trans->delayed_ref_updates;
+	trans->delayed_ref_updates = 0;
+	if (updates)
+		btrfs_run_delayed_refs(trans, root, updates);
+
+	return should_end_transaction(trans, root);
+}
+
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, int throttle)
 {
-	struct btrfs_transaction *cur_trans;
+	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *info = root->fs_info;
 	int count = 0;
 
@@ -349,9 +375,19 @@ static int __btrfs_end_transaction(struc
 
 	btrfs_trans_release_metadata(trans, root);
 
+	if (!root->fs_info->open_ioctl_trans &&
+	    should_end_transaction(trans, root))
+		trans->transaction->blocked = 1;
+
+	if (cur_trans->blocked && !cur_trans->in_commit) {
+		if (throttle)
+			return btrfs_commit_transaction(trans, root);
+		else
+			wake_up_process(info->transaction_kthread);
+	}
+
 	mutex_lock(&info->trans_mutex);
-	cur_trans = info->running_transaction;
-	WARN_ON(cur_trans != trans->transaction);
+	WARN_ON(cur_trans != info->running_transaction);
 	WARN_ON(cur_trans->num_writers < 1);
 	cur_trans->num_writers--;
 
@@ -663,30 +699,30 @@ static noinline int commit_fs_roots(stru
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 {
 	struct btrfs_fs_info *info = root->fs_info;
-	int ret;
 	struct btrfs_trans_handle *trans;
+	int ret;
 	unsigned long nr;
 
-	smp_mb();
-	if (root->defrag_running)
+	if (xchg(&root->defrag_running, 1))
 		return 0;
-	trans = btrfs_start_transaction(root, 1);
+
 	while (1) {
-		root->defrag_running = 1;
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
+
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(info->tree_root, nr);
 		cond_resched();
 
-		trans = btrfs_start_transaction(root, 1);
 		if (root->fs_info->closing || ret != -EAGAIN)
 			break;
 	}
 	root->defrag_running = 0;
-	smp_mb();
-	btrfs_end_transaction(trans, root);
-	return 0;
+	return ret;
 }
 
 #if 0
@@ -923,6 +959,16 @@ int btrfs_transaction_in_commit(struct b
 	return ret;
 }
 
+int btrfs_transaction_blocked(struct btrfs_fs_info *info)
+{
+	int ret = 0;
+	spin_lock(&info->new_trans_lock);
+	if (info->running_transaction)
+		ret = info->running_transaction->blocked;
+	spin_unlock(&info->new_trans_lock);
+	return ret;
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
diff -urp 2/fs/btrfs/transaction.h 3/fs/btrfs/transaction.h
--- 2/fs/btrfs/transaction.h	2010-04-26 17:27:31.639840497 +0800
+++ 3/fs/btrfs/transaction.h	2010-04-26 17:27:31.655839960 +0800
@@ -106,6 +106,8 @@ int btrfs_commit_transaction(struct btrf
 			     struct btrfs_root *root);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
+int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_root *root);
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
@@ -115,5 +117,6 @@ int btrfs_write_marked_extents(struct bt
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_wait_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
+int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 #endif
diff -urp 2/fs/btrfs/tree-defrag.c 3/fs/btrfs/tree-defrag.c
--- 2/fs/btrfs/tree-defrag.c	2010-04-26 17:27:31.638850832 +0800
+++ 3/fs/btrfs/tree-defrag.c	2010-04-26 17:27:31.655839960 +0800
@@ -117,13 +117,14 @@ int btrfs_defrag_leaves(struct btrfs_tra
 				 path->nodes[1], 0,
 				 cache_only, &last_ret,
 				 &root->defrag_progress);
-	WARN_ON(ret && ret != -EAGAIN);
+	if (ret) {
+		WARN_ON(ret == -EAGAIN);
+		goto out;
+	}
 	if (next_key_ret == 0) {
 		memcpy(&root->defrag_progress, &key, sizeof(key));
 		ret = -EAGAIN;
 	}
-
-	btrfs_release_path(root, path);
 out:
 	if (path)
 		btrfs_free_path(path);
