From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: proper metadata -ENOSPC handling
Date: Mon, 24 Aug 2009 14:51:46 -0400
Message-ID: <20090824185144.GF2323@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch finally gives us full proper -ENOSPC handling for btrfs.  Now
whenever you do a btrfs_start_transaction, you must specify the number of items
you are planning to add/delete/modify.  The worst case number of blocks that
could be modified by changing that number of items will be calculated and
checked against the amount of free space in the space_info where the root you
are modifying would allocate out of.  If there is not enough free space, you
will get an PTR_ERR(-ENOSPC) returned.  Now the data ENOSPC checker does not
check metadata space, it only checks data space, and this seems to speed up my
fs_mark tests quite a bit.

Everytime we start a new transaction, we calculate how much space we have for
metadata and store it in the transaction, so we do not go above that number of
bytes.  Also, we calculate how many bytes would be needed to commit the
transaction, and subtract that from the maximum number of bytes allowed to be
used in the transaction.  This makes sure that if we start a transaction we can
_always_ commit it.

There are some gotcha's related with this patch.  Relocation seems to work for
the most part, but you may hit problems with btrfs_drop_snapshots.  The problem
is not easy to hit, but its not terribly hard either.  This will be fixed later
by Yan, since he is already planning on re-working that code.

This patch also turns off the metadata_ratio stuff in order to make sure users
can get the most disk space as possible.  We only force metadata chunk
allocations when we pass 80% used in the metadata space.

Also, instead of doing a

trans = btrfs_start_transaction(root, 1);
btrfs_commit_transaction(trans, root);

You will want to do

btrfs_force_transacation_commit(root, 0);

This does not do any of the free space checks that btrfs_start_transaction or
btrfs_join_transaction does, since we expect to _only_ be committing the
transaction.  This makes sure that we use the reserved space for committing the
transaction and don't end up with ENOSPC being returned to the transaction
kthread.

This has been hammered on pretty well with various tests and seems to work well.
Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    4 +-
 fs/btrfs/disk-io.c     |   13 +--
 fs/btrfs/extent-tree.c |  139 +++++++++++---------
 fs/btrfs/file.c        |   17 ++-
 fs/btrfs/inode.c       |  186 +++++++++++++++++++--------
 fs/btrfs/ioctl.c       |   14 +--
 fs/btrfs/relocation.c  |   63 +++++++--
 fs/btrfs/super.c       |    3 +
 fs/btrfs/transaction.c |  336 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/transaction.h |   27 ++++-
 fs/btrfs/volumes.c     |   17 ++-
 11 files changed, 632 insertions(+), 187 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index db02e26..003400a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -672,6 +672,7 @@ struct btrfs_space_info {
 	u64 bytes_reserved;	/* total bytes the allocator has reserved for
 				   current allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
+	u64 bytes_super;	/* total bytes reserved for the super blocks */
 
 	/* delalloc accounting */
 	u64 bytes_delalloc;	/* number of bytes reserved for allocation,
@@ -744,6 +745,7 @@ struct btrfs_block_group_cache {
 	spinlock_t lock;
 	u64 pinned;
 	u64 reserved;
+	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
 	int extents_thresh;
@@ -2012,7 +2014,7 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
-int btrfs_check_metadata_free_space(struct btrfs_root *root);
+u64 btrfs_metadata_free_space(struct btrfs_root *root);
 int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes);
 void btrfs_free_reserved_data_space(struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fafd6f2..dbd2f13 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1456,7 +1456,6 @@ static int cleaner_kthread(void *arg)
 static int transaction_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
-	struct btrfs_trans_handle *trans;
 	struct btrfs_transaction *cur;
 	unsigned long now;
 	unsigned long delay;
@@ -1485,8 +1484,7 @@ static int transaction_kthread(void *arg)
 			goto sleep;
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
-		trans = btrfs_start_transaction(root, 1);
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_force_transaction_commit(root, 0);
 
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
@@ -1574,7 +1572,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
-	fs_info->metadata_ratio = 8;
+	fs_info->metadata_ratio = 0;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
@@ -2285,18 +2283,15 @@ int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 
 int btrfs_commit_super(struct btrfs_root *root)
 {
-	struct btrfs_trans_handle *trans;
 	int ret;
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
-	trans = btrfs_start_transaction(root, 1);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_force_transaction_commit(root, 0);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_commit_transaction(trans, root);
+	btrfs_force_transaction_commit(root, 0);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 92bc72e..82fc8ca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -201,6 +201,7 @@ static int exclude_super_stripes(struct btrfs_root *root,
 		BUG_ON(ret);
 
 		while (nr--) {
+			cache->bytes_super += stripe_len;
 			ret = add_excluded_extent(root, logical[nr],
 						  stripe_len);
 			BUG_ON(ret);
@@ -295,6 +296,9 @@ static int caching_kthread(void *data)
 		return -ENOMEM;
 
 	exclude_super_stripes(extent_root, block_group);
+	spin_lock(&block_group->space_info->lock);
+	block_group->space_info->bytes_super += block_group->bytes_super;
+	spin_unlock(&block_group->space_info->lock);
 
 	last = max_t(u64, block_group->key.objectid, BTRFS_SUPER_INFO_OFFSET);
 
@@ -2069,7 +2073,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	if (root == root->fs_info->extent_root)
 		root = root->fs_info->tree_root;
 
+	BUG_ON(IS_ERR(trans));
 	delayed_refs = &trans->transaction->delayed_refs;
+	if (!delayed_refs->num_entries)
+		return 0;
+
 	INIT_LIST_HEAD(&cluster);
 again:
 	spin_lock(&delayed_refs->lock);
@@ -2761,62 +2769,39 @@ void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
 }
 
 /*
- * for now this just makes sure we have at least 5% of our metadata space free
- * for use.
+ * Figure out how much metadata space we have free.
  */
-int btrfs_check_metadata_free_space(struct btrfs_root *root)
+u64 btrfs_metadata_free_space(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *meta_sinfo;
-	u64 alloc_target, thresh;
-	int committed = 0, ret;
+	u64 alloc_target, thresh, used, total;
 
 	/* get the space info for where the metadata will live */
 	alloc_target = btrfs_get_alloc_profile(root, 0);
 	meta_sinfo = __find_space_info(info, alloc_target);
 
-again:
 	spin_lock(&meta_sinfo->lock);
-	if (!meta_sinfo->full)
-		thresh = meta_sinfo->total_bytes * 80;
-	else
-		thresh = meta_sinfo->total_bytes * 95;
-
-	do_div(thresh, 100);
+	total = meta_sinfo->total_bytes;
+	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+		meta_sinfo->bytes_super;
 
-	if (meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly > thresh) {
-		struct btrfs_trans_handle *trans;
-		if (!meta_sinfo->full) {
+	/*
+	 * if we are approaching the 80% full line for metadata space, lets make
+	 * sure that somewhere down the line we force a chunk allocation for
+	 * metadata just in case.
+	 */
+	if (!meta_sinfo->full) {
+		thresh = meta_sinfo->total_bytes * 80;
+		do_div(thresh, 100);
+		if (used > thresh)
 			meta_sinfo->force_alloc = 1;
-			spin_unlock(&meta_sinfo->lock);
-
-			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
-
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-					     2 * 1024 * 1024, alloc_target, 0);
-			btrfs_end_transaction(trans, root);
-			goto again;
-		}
-		spin_unlock(&meta_sinfo->lock);
-
-		if (!committed) {
-			committed = 1;
-			trans = btrfs_join_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
-			ret = btrfs_commit_transaction(trans, root);
-			if (ret)
-				return ret;
-			goto again;
-		}
-		return -ENOSPC;
 	}
+
 	spin_unlock(&meta_sinfo->lock);
 
-	return 0;
+	return (total - used);
 }
 
 /*
@@ -2827,6 +2812,7 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
+	u64 used;
 	int ret = 0, committed = 0;
 
 	/* make sure bytes are sectorsize aligned */
@@ -2836,10 +2822,13 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 again:
 	/* make sure we have enough space to handle the data first */
 	spin_lock(&data_sinfo->lock);
-	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
-	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
-	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
-	    data_sinfo->bytes_may_use < bytes) {
+
+	used = data_sinfo->bytes_used + data_sinfo->bytes_delalloc +
+		data_sinfo->bytes_reserved + data_sinfo->bytes_pinned +
+		data_sinfo->bytes_readonly + data_sinfo->bytes_may_use +
+		data_sinfo->bytes_super;
+
+	if (data_sinfo->total_bytes - used < bytes) {
 		struct btrfs_trans_handle *trans;
 
 		/*
@@ -2854,8 +2843,8 @@ again:
 
 			alloc_target = btrfs_get_alloc_profile(root, 1);
 			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     bytes + 2 * 1024 * 1024,
@@ -2870,10 +2859,7 @@ again:
 		/* commit the current transaction and try again */
 		if (!committed) {
 			committed = 1;
-			trans = btrfs_join_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
-			ret = btrfs_commit_transaction(trans, root);
+			ret = btrfs_force_transaction_commit(root, 0);
 			if (ret)
 				return ret;
 			goto again;
@@ -2896,7 +2882,7 @@ again:
 	BTRFS_I(inode)->reserved_bytes += bytes;
 	spin_unlock(&data_sinfo->lock);
 
-	return btrfs_check_metadata_free_space(root);
+	return 0;
 }
 
 /*
@@ -3019,7 +3005,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	 * we keep a reasonable number of metadata chunks allocated in the
 	 * FS as well.
 	 */
-	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+	if (flags & BTRFS_BLOCK_GROUP_DATA && fs_info->metadata_ratio) {
 		fs_info->data_chunk_allocations++;
 		if (!(fs_info->data_chunk_allocations %
 		      fs_info->metadata_ratio))
@@ -3737,7 +3723,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	space_info = __find_space_info(root->fs_info, data);
 
-	if (orig_root->ref_cows || empty_size)
+	if ((orig_root->ref_cows || empty_size) && !trans->is_relocate)
 		allowed_chunk_alloc = 1;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA) {
@@ -4058,26 +4044,32 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 
 	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
-				    info->bytes_pinned - info->bytes_reserved),
+				    info->bytes_pinned - info->bytes_reserved -
+				    info->bytes_readonly),
 	       (info->full) ? "" : "not ");
 	printk(KERN_INFO "space_info total=%llu, pinned=%llu, delalloc=%llu,"
-	       " may_use=%llu, used=%llu\n",
+	       " may_use=%llu, used=%llu, read-only=%llu, super=%llu\n",
 	       (unsigned long long)info->total_bytes,
 	       (unsigned long long)info->bytes_pinned,
 	       (unsigned long long)info->bytes_delalloc,
 	       (unsigned long long)info->bytes_may_use,
-	       (unsigned long long)info->bytes_used);
+	       (unsigned long long)info->bytes_used,
+	       (unsigned long long)info->bytes_readonly,
+	       (unsigned long long)info->bytes_super);
 
 	down_read(&info->groups_sem);
 	list_for_each_entry(cache, &info->block_groups, list) {
 		spin_lock(&cache->lock);
 		printk(KERN_INFO "block group %llu has %llu bytes, %llu used "
-		       "%llu pinned %llu reserved\n",
+		       "%llu pinned %llu reserved %llu super and is%s "
+		       "read only\n",
 		       (unsigned long long)cache->key.objectid,
 		       (unsigned long long)cache->key.offset,
 		       (unsigned long long)btrfs_block_group_used(&cache->item),
 		       (unsigned long long)cache->pinned,
-		       (unsigned long long)cache->reserved);
+		       (unsigned long long)cache->reserved,
+		       (unsigned long long)cache->bytes_super,
+		       cache->ro ? "" : " not");
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
@@ -4137,6 +4129,9 @@ again:
 		dump_space_info(sinfo, num_bytes);
 	}
 
+	if (!ret && (data & BTRFS_BLOCK_GROUP_METADATA))
+		btrfs_trans_used_bytes(trans, ins->offset);
+
 	return ret;
 }
 
@@ -4788,7 +4783,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	BUG_ON(!wc);
 
-	trans = btrfs_start_transaction(tree_root, 1);
+	trans = btrfs_start_transaction(tree_root, BTRFS_MAX_LEVEL + 1);
+	BUG_ON(IS_ERR(trans));
 
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
@@ -4812,6 +4808,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 			err = ret;
 			goto out;
 		}
+
 		btrfs_node_key_to_cpu(path->nodes[level], &key,
 				      path->slots[level]);
 		WARN_ON(memcmp(&key, &wc->update_progress, sizeof(key)));
@@ -4877,7 +4874,9 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 		}
 
 		BUG_ON(wc->level == 0);
-		if (trans->transaction->in_commit ||
+		ret = btrfs_try_extend_transaction(trans, tree_root,
+						   BTRFS_MAX_LEVEL);
+		if (ret || trans->transaction->in_commit ||
 		    trans->transaction->delayed_refs.flushing) {
 			ret = btrfs_update_root(trans, tree_root,
 						&root->root_key,
@@ -4885,7 +4884,9 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 			BUG_ON(ret);
 
 			btrfs_end_transaction(trans, tree_root);
-			trans = btrfs_start_transaction(tree_root, 1);
+			trans = btrfs_start_transaction(tree_root,
+							BTRFS_MAX_LEVEL + 1);
+			BUG_ON(IS_ERR(trans));
 		} else {
 			unsigned long update;
 			update = trans->delayed_ref_updates;
@@ -4895,6 +4896,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 						       update);
 		}
 	}
+
 	btrfs_release_path(root, path);
 	BUG_ON(err);
 
@@ -6027,7 +6029,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BUG_ON(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
@@ -6329,7 +6331,7 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
@@ -6812,6 +6814,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 					&space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
+		spin_lock(&cache->space_info->lock);
+		cache->space_info->bytes_super += cache->bytes_super;
+		spin_unlock(&cache->space_info->lock);
+
 		down_write(&space_info->groups_sem);
 		list_add_tail(&cache->list, &space_info->block_groups);
 		up_write(&space_info->groups_sem);
@@ -6881,6 +6887,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
+
+	spin_lock(&cache->space_info->lock);
+	cache->space_info->bytes_super += cache->bytes_super;
+	spin_unlock(&cache->space_info->lock);
+
 	down_write(&cache->space_info->groups_sem);
 	list_add_tail(&cache->list, &cache->space_info->block_groups);
 	up_write(&cache->space_info->groups_sem);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7c3cd24..cabd0b2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -129,8 +129,8 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 
 	lock_extent(io_tree, start_pos, end_of_last_block, GFP_NOFS);
 	trans = btrfs_join_transaction(root, 1);
-	if (!trans) {
-		err = -ENOMEM;
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
 		goto out_unlock;
 	}
 	btrfs_set_trans_block_group(trans, inode);
@@ -323,6 +323,10 @@ noinline int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	while (1) {
 		recow = 0;
 		btrfs_release_path(root, path);
+		ret = btrfs_extend_transaction(trans, root, 1);
+		if (ret)
+			goto out;
+
 		ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
 					       search_start, -1);
 		if (ret < 0)
@@ -1080,6 +1084,10 @@ out_nolock:
 
 		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
+				goto fail;
+			}
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
 			if (ret == 0) {
@@ -1092,6 +1100,7 @@ out_nolock:
 				btrfs_commit_transaction(trans, root);
 			}
 		}
+fail:
 		if (file->f_flags & O_DIRECT) {
 			invalidate_mapping_pages(inode->i_mapping,
 			      start_pos >> PAGE_CACHE_SHIFT,
@@ -1169,8 +1178,8 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		btrfs_ioctl_trans_end(file);
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea827d..8aacabd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -400,7 +400,7 @@ again:
 	}
 	if (start == 0) {
 		trans = btrfs_join_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
 
 		/* lets try to make an inline extent */
@@ -695,8 +695,12 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;
 
-	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	/*
+	 * 1 for the inode
+	 * 1 for the extent we have to insert
+	 */
+	trans = btrfs_join_transaction(root, 2);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -786,6 +790,10 @@ static noinline int cow_file_range(struct inode *inode,
 		num_bytes -= cur_alloc_size;
 		alloc_hint = ins.objectid + ins.offset;
 		start += cur_alloc_size;
+
+		/* 1 for the extent we are going to have to add */
+		ret = btrfs_extend_transaction(trans, root, 1);
+		BUG_ON(ret);
 	}
 out:
 	ret = 0;
@@ -955,7 +963,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1566,6 +1574,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	}
 
 	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 
 	if (!ordered_extent)
 		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
@@ -1981,7 +1990,9 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * do a destroy_inode
 		 */
 		if (is_bad_inode(inode)) {
+			/* 1 item for the orphan entry */
 			trans = btrfs_start_transaction(root, 1);
+			BUG_ON(IS_ERR(trans));
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2337,7 +2348,16 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 	root = BTRFS_I(dir)->root;
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 1 item for the orphan entry
+	 * 1 for the actual inode
+	 * 1 for inode ref
+	 * 2 for dir items
+	 * 2 for the log entries
+	 */
+	trans = btrfs_start_transaction(root, 7);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2374,7 +2394,11 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		return -ENOTEMPTY;
 	}
 
+	/* 1 for the orphan item */
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_orphan_add(trans, inode);
@@ -2610,12 +2634,15 @@ noinline int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	BUG_ON(!path);
 	path->reada = -1;
 
-	/* FIXME, add redo link to tree so we don't leak on crash */
 	key.objectid = inode->i_ino;
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
 
 search_again:
+	ret = btrfs_extend_transaction(trans, root, 1);
+	if (ret)
+		goto error;
+
 	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
@@ -2900,15 +2927,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
-	int err;
+	int err = 0;
 
 	if (size <= hole_start)
 		return 0;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		return err;
-
 	btrfs_truncate_page(inode->i_mapping, inode->i_size);
 
 	while (1) {
@@ -2923,7 +2946,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 		btrfs_put_ordered_extent(ordered);
 	}
 
+	/* 1 item for the file extent */
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_set_trans_block_group(trans, inode);
 
 	cur_offset = hole_start;
@@ -2954,6 +2981,10 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 		cur_offset = last_byte;
 		if (err || cur_offset >= block_end)
 			break;
+		/* 1 item for the file extent */
+		err = btrfs_extend_transaction(trans, root, 1);
+		if (err)
+			break;
 	}
 
 	btrfs_end_transaction(trans, root);
@@ -3009,7 +3040,17 @@ void btrfs_delete_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	btrfs_i_size_write(inode, 0);
-	trans = btrfs_join_transaction(root, 1);
+
+	/*
+	 * 1 for the orphan entry
+	 * 1 for the inode
+	 */
+	trans = btrfs_join_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		WARN_ON(1);
+		btrfs_orphan_del(NULL, inode);
+		goto no_delete;
+	}
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 0);
@@ -3438,6 +3479,8 @@ int btrfs_write_inode(struct inode *inode, int wait)
 
 	if (wait) {
 		trans = btrfs_join_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		btrfs_set_trans_block_group(trans, inode);
 		ret = btrfs_commit_transaction(trans, root);
 	}
@@ -3456,6 +3499,8 @@ void btrfs_dirty_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 
 	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		return;
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_update_inode(trans, root, inode);
 	btrfs_end_transaction(trans, root);
@@ -3733,11 +3778,15 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		goto fail;
+	/*
+	 * 2 for inode item and ref
+	 * 2 for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
-	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3775,7 +3824,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-fail:
+
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -3796,10 +3845,15 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		goto fail;
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 2 for inode item and ref
+	 * 2 for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3840,7 +3894,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-fail:
+
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -3864,14 +3918,18 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		return -ENOENT;
 
 	btrfs_inc_nlink(inode);
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		goto fail;
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 1 items for inode ref
+	 * 2 items for dir items
+	 */
+	trans = btrfs_start_transaction(root, 3);
+	err = PTR_ERR(trans);
+	if (IS_ERR(trans))
+		goto fail;
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -3912,18 +3970,16 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		goto out_unlock;
-
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 2 items for inode and ref
+	 * 2 items for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, dir);
 
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
-		goto out_unlock;
-	}
-
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
 	if (err) {
 		err = -ENOSPC;
@@ -4230,6 +4286,11 @@ again:
 				em = NULL;
 				btrfs_release_path(root, path);
 				trans = btrfs_join_transaction(root, 1);
+				if (IS_ERR(trans)) {
+					err = PTR_ERR(trans);
+					trans = NULL;
+					goto out;
+				}
 				goto again;
 			}
 			map = kmap(page);
@@ -4552,7 +4613,15 @@ static void btrfs_truncate(struct inode *inode)
 	btrfs_truncate_page(inode->i_mapping, inode->i_size);
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 1 item for orphan item
+	 * 1 item for the inode item
+	 */
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		WARN_ON(1);
+		return;
+	}
 
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
@@ -4580,7 +4649,7 @@ static void btrfs_truncate(struct inode *inode)
 	ret = btrfs_orphan_add(trans, inode);
 	if (ret)
 		goto out;
-	/* FIXME, add redo link to tree so we don't leak on crash */
+
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size,
 				      BTRFS_EXTENT_DATA_KEY);
 	btrfs_update_inode(trans, root, inode);
@@ -4797,10 +4866,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -EXDEV;
 
-	ret = btrfs_check_metadata_free_space(root);
-	if (ret)
-		goto out_unlock;
-
 	/*
 	 * we're using rename to replace one file with another.
 	 * and the replacement file is large.  Start IO on it now so
@@ -4811,7 +4876,14 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	    old_inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 		filemap_flush(old_inode->i_mapping);
 
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 2 items for dir items
+	 * 1 item for orphan entry
+	 * 1 item for ref
+	 */
+	trans = btrfs_start_transaction(root, 4);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	/*
 	 * make sure the inode gets flushed if it is replacing
@@ -4881,7 +4953,6 @@ out_fail:
 	 */
 	btrfs_end_log_trans(root);
 	btrfs_end_transaction_throttle(trans, root);
-out_unlock:
 	return ret;
 }
 
@@ -4953,11 +5024,14 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		goto out_fail;
-
-	trans = btrfs_start_transaction(root, 1);
+	/*
+	 * 2 leaves for inode item + ref
+	 * 2 leaves for dir items
+	 * 1 leaf for xattr if selinux is on
+	 */
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -5038,7 +5112,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-out_fail:
+
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -5134,9 +5208,15 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 
-		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-		if (!trans) {
-			ret = -EIO;
+		/*
+		 * this is a bad guess, but its as good as we have now.  Just
+		 * say it will take len / max extent # of items to accomodate
+		 * this change.
+		 */
+		trans = btrfs_start_transaction(BTRFS_I(inode)->root,
+				(int)(len / root->fs_info->max_extent));
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
 			goto out_free;
 		}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9f4db84..e7acdd5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -240,12 +240,8 @@ static noinline int create_subvol(struct btrfs_root *root,
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	ret = btrfs_check_metadata_free_space(root);
-	if (ret)
-		goto fail_commit;
-
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	trans = btrfs_start_transaction(root, 4);
+	BUG_ON(IS_ERR(trans));
 
 	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
 				       0, &objectid);
@@ -376,10 +372,6 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (!root->ref_cows)
 		return -EINVAL;
 
-	ret = btrfs_check_metadata_free_space(root);
-	if (ret)
-		goto fail_unlock;
-
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot) {
 		ret = -ENOMEM;
@@ -395,7 +387,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->name[namelen] = '\0';
 	pending_snapshot->dentry = dentry;
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e71264d..74f40f1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2458,6 +2458,16 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		}
 		remove_backref_node(cache, node);
 		rb_node = rb_next(rb_node);
+
+		/*
+		 * if we can't extend the transaction, just exit so we can end
+		 * this transaction and start again with clean backref cache
+		 */
+		ret = btrfs_try_extend_transaction(trans, rc->extent_root, 1);
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
 	}
 
 	if (level > 0)
@@ -2504,6 +2514,13 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 			}
 			remove_backref_node(cache, node);
 			rb_node = rb_next(rb_node);
+
+			ret = btrfs_try_extend_transaction(trans,
+							   rc->extent_root, 1);
+			if (ret) {
+				ret = 0;
+				goto out;
+			}
 		}
 		free_block_list(blocks);
 
@@ -2515,6 +2532,12 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 			}
 			remove_backref_node(cache, upper);
 		}
+
+		ret = btrfs_try_extend_transaction(trans, rc->extent_root, 1);
+		if (ret) {
+			ret = 0;
+			break;
+		}
 	}
 out:
 	free_block_list(blocks);
@@ -3222,11 +3245,25 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	rc->create_reloc_root = 1;
 	set_reloc_control(rc);
 
-	trans = btrfs_start_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	ret = btrfs_force_transaction_commit(rc->extent_root, 0);
+	if (ret) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 
 	while (1) {
-		trans = btrfs_start_transaction(rc->extent_root, 1);
+		/*
+		 * we could extend the transaction, so we want to make sure we
+		 * have enough room to commit the transaction if we have to, so
+		 * have 6, 1 for every root, plus 1 for the first relocated
+		 * block.
+		 */
+		trans = btrfs_start_transaction(rc->extent_root, 7);
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			trans = NULL;
+			break;
+		}
 
 		ret = find_next_extent(trans, rc, path);
 		if (ret < 0)
@@ -3326,18 +3363,15 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	rc->create_reloc_root = 0;
 	smp_mb();
 
-	if (rc->extents_found > 0) {
-		trans = btrfs_start_transaction(rc->extent_root, 1);
-		btrfs_commit_transaction(trans, rc->extent_root);
-	}
+	if (rc->extents_found > 0)
+		btrfs_force_transaction_commit(rc->extent_root, 0);
 
 	merge_reloc_roots(rc);
 
 	unset_reloc_control(rc);
 
 	/* get rid of pinned extents */
-	trans = btrfs_start_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	btrfs_force_transaction_commit(rc->extent_root, 0);
 
 	return err;
 }
@@ -3540,7 +3574,6 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct reloc_control *rc = NULL;
-	struct btrfs_trans_handle *trans;
 	int ret;
 	int err = 0;
 
@@ -3632,15 +3665,17 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		fs_root->reloc_root = reloc_root;
 	}
 
-	trans = btrfs_start_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	/* 6 - one for every root */
+	err = btrfs_force_transaction_commit(rc->extent_root, 0);
+	if (err)
+		goto out;
 
 	merge_reloc_roots(rc);
 
 	unset_reloc_control(rc);
 
-	trans = btrfs_start_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	/* 6 - one for every root */
+	err = btrfs_force_transaction_commit(rc->extent_root, 0);
 out:
 	if (rc) {
 		btrfs_stop_workers(&rc->workers);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 708ac06..cf21c1b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -407,6 +407,9 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	ret = btrfs_commit_transaction(trans, root);
 	sb->s_dirt = 0;
 	return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6ed6186..4495f48 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -46,6 +46,34 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 	root->commit_root = btrfs_root_node(root);
 }
 
+static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
+{
+	u64 num_bytes;
+
+	/*
+	 * NOTE: these calculations are absolutely the worst possible case.
+	 * This assumes that _every_ item we insert will require a new leaf, and
+	 * that the tree has grown to its maximum level size.
+	 */
+
+	/*
+	 * for every item we insert we could insert both an extent item and a
+	 * extent ref item.  Then for ever item we insert, we will need to cow
+	 * both the original leaf, plus the leaf to the left and right of it.
+	 */
+	num_bytes = (num_items + (2 * num_items)) * 3;
+
+	/*
+	 * num_bytes is total number of leaves we could need times the leaf
+	 * size, and then for every leaf we could end up cow'ing 2 nodes per
+	 * level, down to the leaf level.
+	 */
+	num_bytes = (num_bytes * root->leafsize) +
+		(num_bytes * ((BTRFS_MAX_LEVEL - 1) * 2)) * root->nodesize;
+
+	return num_bytes;
+}
+
 /*
  * either allocate a new transaction or hop into the existing one
  */
@@ -54,6 +82,8 @@ static noinline int join_transaction(struct btrfs_root *root)
 	struct btrfs_transaction *cur_trans;
 	cur_trans = root->fs_info->running_transaction;
 	if (!cur_trans) {
+		u64 root_bytes = calculate_bytes_needed(root, 6);
+
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
 		BUG_ON(!cur_trans);
@@ -67,6 +97,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 		cur_trans->blocked = 0;
 		cur_trans->use_count = 1;
 		cur_trans->commit_done = 0;
+		cur_trans->bytes_reserved = 0;
 		cur_trans->start_time = get_seconds();
 
 		cur_trans->delayed_refs.root.rb_node = NULL;
@@ -82,6 +113,19 @@ static noinline int join_transaction(struct btrfs_root *root)
 		extent_io_tree_init(&cur_trans->dirty_pages,
 				     root->fs_info->btree_inode->i_mapping,
 				     GFP_NOFS);
+
+		/*
+		 * we want to limit the amount of metadata used by the
+		 * transaction to ensure that we don't run out of metadata
+		 * space.  So calculate the amount of metadata space we
+		 * currently have available, and subtract the amount of space
+		 * that would be needed to commit the transaction so we make
+		 * sure that we can always commit.
+		 */
+		cur_trans->max_bytes = btrfs_metadata_free_space(root);
+		BUG_ON(cur_trans->max_bytes < root_bytes);
+		cur_trans->max_bytes -= root_bytes;
+
 		spin_lock(&root->fs_info->new_trans_lock);
 		root->fs_info->running_transaction = cur_trans;
 		spin_unlock(&root->fs_info->new_trans_lock);
@@ -164,50 +208,265 @@ static void wait_current_trans(struct btrfs_root *root)
 	}
 }
 
-static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-					     int num_blocks, int wait)
+static int init_trans_handle(struct btrfs_root *root,
+			     struct btrfs_trans_handle *h)
 {
-	struct btrfs_trans_handle *h =
-		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	struct btrfs_transaction *cur_trans;
 	int ret;
 
-	mutex_lock(&root->fs_info->trans_mutex);
-	if (!root->fs_info->log_root_recovering &&
-	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
-		wait_current_trans(root);
 	ret = join_transaction(root);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
+
+	cur_trans = root->fs_info->running_transaction;
 
-	h->transid = root->fs_info->running_transaction->transid;
-	h->transaction = root->fs_info->running_transaction;
-	h->blocks_reserved = num_blocks;
-	h->blocks_used = 0;
+	h->transid = cur_trans->transid;
+	h->transaction = cur_trans;
+	h->bytes_reserved = 0;
+	h->bytes_used = 0;
 	h->block_group = 0;
 	h->alloc_exclude_nr = 0;
 	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
+	h->use_count = 1;
 
-	root->fs_info->running_transaction->use_count++;
+	cur_trans->use_count++;
 	record_root_in_trans(h, root);
+
+	return ret;
+}
+
+static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
+						    int num_items, int wait)
+{
+	struct btrfs_transaction *cur_trans;
+	struct btrfs_trans_handle *h;
+	u64 num_bytes = 0;
+	bool nested_trans = (current->journal_info);
+	bool committed = false;
+	int ret;
+
+	num_bytes = calculate_bytes_needed(root, num_items);
+
+again:
+	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	if (!h)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	if (!root->fs_info->log_root_recovering &&
+	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
+		wait_current_trans(root);
+
+	ret = init_trans_handle(root, h);
+	if (ret) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		kmem_cache_free(btrfs_trans_handle_cachep, h);
+		return ERR_PTR(ret);
+	}
+
+	cur_trans = h->transaction;
+
+	h->bytes_reserved = num_bytes;
+	if (!nested_trans) {
+		current->journal_info = h;
+		cur_trans->bytes_reserved += num_bytes;
+	}
+
+	if (cur_trans->bytes_reserved >= cur_trans->max_bytes) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		if (committed) {
+			btrfs_end_transaction(h, root);
+			h = ERR_PTR(-ENOSPC);
+			return h;
+		}
+
+		/*
+		 * if we are already at or over the limit and we have a nested
+		 * trans then we need to warn so that we can adjust the original
+		 * transaction holder to account for the blocks that this
+		 * operation is going to need.
+		 */
+		if (nested_trans) {
+			WARN_ON(1);
+			return h;
+		}
+
+		btrfs_commit_transaction(h, root);
+		committed = true;
+		goto again;
+	}
+
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
 
+int btrfs_force_transaction_commit(struct btrfs_root *root, int num_items)
+{
+	struct btrfs_transaction *cur_trans;
+	struct btrfs_trans_handle *trans;
+	u64 num_bytes;
+	u64 root_bytes;
+	bool nested_trans = (current->journal_info);
+	int ret;
+
+	num_bytes = calculate_bytes_needed(root, num_items);
+
+	/* 6 - one for every root */
+	root_bytes = calculate_bytes_needed(root, 6);
+
+	trans = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	if (!trans)
+		return -ENOMEM;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	ret = init_trans_handle(root, trans);
+	if (ret) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		kmem_cache_free(btrfs_trans_handle_cachep, trans);
+		return ret;
+	}
+
+	cur_trans = trans->transaction;
+	trans->bytes_reserved = num_bytes + root_bytes;
+	if (!nested_trans) {
+		current->journal_info = trans;
+		cur_trans->bytes_reserved += num_bytes;
+	}
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	return btrfs_commit_transaction(trans, root);
+}
+
+/*
+ * try to extend the transaction by num_items number of items.  If we can't
+ * do that because the transaction is currently committing or we'd need to
+ * commit the transaction to get that space, return -1.  Else reserve the
+ * space and return 0.
+ */
+int btrfs_try_extend_transaction(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root, int num_items)
+{
+	struct btrfs_transaction *cur_trans;
+	bool nested_trans = !(current->journal_info == trans);
+	u64 num_bytes = calculate_bytes_needed(root, num_items);
+
+	/*
+	 * we need to not extend in nested transactions, we should be passing
+	 * transaction handles down to whatever this function is.
+	 */
+	BUG_ON(nested_trans);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+
+	cur_trans = trans->transaction;
+	if (trans->transaction->in_commit ||
+	    (cur_trans->bytes_reserved + num_bytes >= cur_trans->max_bytes)) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		return -1;
+	}
+
+	trans->bytes_reserved += num_bytes;
+	cur_trans->bytes_reserved += num_bytes;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	return 0;
+}
+
+/*
+ * WARNING: this will restart the transaction if theres not enough space
+ *
+ * Try to extend the transaction by num_items number of items.  If we
+ * are in the middle of a commit, we will stop this trans handle, wait for the
+ * transaction to commit, and then re-initialize it to attach it to the
+ * current transaction.  If we don't have enough space, we will force a
+ * transaction commit and then re-check to see if we have enough space.  If we
+ * don't have enough space we will return -ENOSPC
+ */
+int btrfs_extend_transaction(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, int num_items)
+{
+	struct btrfs_transaction *cur_trans;
+	bool nested_trans = !(current->journal_info == trans);
+	bool committed = false;
+	u64 num_bytes = calculate_bytes_needed(root, num_items);
+
+	/*
+	 * we need to not extend in nested transactions, we should be passing
+	 * transaction handles down to whatever this function is.
+	 */
+	BUG_ON(nested_trans);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+again:
+	cur_trans = trans->transaction;
+	if (trans->transaction->in_commit) {
+		trans->use_count++;
+		mutex_unlock(&root->fs_info->trans_mutex);
+		btrfs_end_transaction(trans, root);
+
+		mutex_lock(&root->fs_info->trans_mutex);
+		wait_current_trans(root);
+		init_trans_handle(root, trans);
+		current->journal_info = trans;
+		committed = true;
+		goto again;
+	} else if (cur_trans->bytes_reserved + num_bytes >=
+		   cur_trans->max_bytes) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		if (committed)
+			return -ENOSPC;
+
+		trans->use_count++;
+		/*
+		 * if we are already at or over the limit and we have a nested
+		 * trans then we need to warn so that we can adjust the original
+		 * transaction holder to account for the blocks that this
+		 * operation is going to need.
+		 */
+		if (nested_trans) {
+			WARN_ON(1);
+			return 0;
+		}
+
+		btrfs_commit_transaction(trans, root);
+
+		mutex_lock(&root->fs_info->trans_mutex);
+		init_trans_handle(root, trans);
+		current->journal_info = trans;
+		committed = true;
+		goto again;
+	}
+
+	trans->bytes_reserved += num_bytes;
+	cur_trans->bytes_reserved += num_bytes;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	return 0;
+}
+
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-						   int num_blocks)
+						   int num_items)
 {
-	return start_transaction(root, num_blocks, 1);
+	return start_transaction(root, num_items, 1);
 }
+
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
-						   int num_blocks)
+						  int num_items)
 {
-	return start_transaction(root, num_blocks, 0);
+	return start_transaction(root, num_items, 0);
 }
 
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-							 int num_blocks)
+							 int num_items)
 {
-	return start_transaction(r, num_blocks, 2);
+	return start_transaction(r, num_items, 2);
+}
+
+void btrfs_trans_used_bytes(struct btrfs_trans_handle *trans, u64 num_bytes)
+{
+	trans->bytes_used += num_bytes;
+	WARN_ON(trans->bytes_used > trans->bytes_reserved);
 }
 
 /* wait for a transaction commit to be fully complete */
@@ -286,9 +545,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_transaction *cur_trans;
 	struct btrfs_fs_info *info = root->fs_info;
+	bool nested_trans = !(current->journal_info == trans);
 	int count = 0;
 
-	while (count < 4) {
+	do {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
 		if (cur &&
@@ -306,7 +566,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			break;
 		}
 		count++;
-	}
+	} while (!nested_trans && count < 4);
 
 	mutex_lock(&info->trans_mutex);
 	cur_trans = info->running_transaction;
@@ -314,12 +574,32 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	WARN_ON(cur_trans->num_writers < 1);
 	cur_trans->num_writers--;
 
+	/*
+	 * XXX this needs to be removed once we shake out the bugs with the
+	 * block accounting stuff, this is only supposed to catch a buggy case,
+	 * so ideally this should never happen once we are done with this stuff.
+	 */
+	if (trans->bytes_used > trans->bytes_reserved)
+		cur_trans->bytes_reserved += (trans->bytes_used -
+					       trans->bytes_reserved);
+	else
+		cur_trans->bytes_reserved -= (trans->bytes_reserved -
+					       trans->bytes_used);
+
+	if (!nested_trans)
+		current->journal_info = NULL;
+
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
+
+	trans->use_count--;
 	put_transaction(cur_trans);
 	mutex_unlock(&info->trans_mutex);
-	memset(trans, 0, sizeof(*trans));
-	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+
+	if (!trans->use_count) {
+		memset(trans, 0, sizeof(*trans));
+		kmem_cache_free(btrfs_trans_handle_cachep, trans);
+	}
 
 	return 0;
 }
@@ -1067,9 +1347,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
+	if (current->journal_info == trans)
+		current->journal_info = NULL;
+
+	trans->use_count--;
 	mutex_unlock(&root->fs_info->trans_mutex);
 
-	kmem_cache_free(btrfs_trans_handle_cachep, trans);
+	if (!trans->use_count)
+		kmem_cache_free(btrfs_trans_handle_cachep, trans);
+
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 663c674..06e9ba7 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -30,6 +30,8 @@ struct btrfs_transaction {
 	unsigned long num_writers;
 
 	unsigned long num_joined;
+	u64 bytes_reserved;
+	u64 max_bytes;
 	int in_commit;
 	int use_count;
 	int commit_done;
@@ -45,13 +47,24 @@ struct btrfs_transaction {
 
 struct btrfs_trans_handle {
 	u64 transid;
-	unsigned long blocks_reserved;
+
+	/*
+	 * keep track of how many bytes are in use by this handle.  Ideally when
+	 * this all works perfectly bytes_reserved can take a hike, but until
+	 * then its usefull in making sure we are making the right guesses for
+	 * how many bytes we plan to use for different operations
+	 */
+	u64 bytes_reserved;
+	u64 bytes_used;
 	unsigned long blocks_used;
 	struct btrfs_transaction *transaction;
 	u64 block_group;
 	u64 alloc_exclude_start;
 	u64 alloc_exclude_nr;
 	unsigned long delayed_ref_updates;
+	int use_count;
+	bool is_relocate;	/* if true, this trans is being used to
+				 * relocate chunks */
 };
 
 struct btrfs_pending_snapshot {
@@ -84,11 +97,16 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-						   int num_blocks);
+						   int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
-						   int num_blocks);
+						   int num_items);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-						   int num_blocks);
+						   int num_items);
+int btrfs_try_extend_transaction(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root, int num_items);
+int btrfs_extend_transaction(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, int num_items);
+void btrfs_trans_used_bytes(struct btrfs_trans_handle *trans, u64 num_bytes);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
@@ -98,6 +116,7 @@ int btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_drop_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
+int btrfs_force_transaction_commit(struct btrfs_root *root, int num_items);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8d9c42e..b3430cc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1743,10 +1743,18 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
 	BUG_ON(ret);
 
-	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	/*
+	 * 2 - for one dev extent plus updating the device item, we'll have to
+	 * extend the transaction if there are more than one stripe
+	 * 1 - the chunk item
+	 * 1 - the block group item
+	 */
+	trans = btrfs_start_transaction(root, 4);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	lock_chunks(root);
+	trans->is_relocate = true;
 
 	/*
 	 * step two, delete the device extents and the
@@ -1761,6 +1769,11 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	map = (struct map_lookup *)em->bdev;
 
 	for (i = 0; i < map->num_stripes; i++) {
+		if (i > 0) {
+			/* 2 - 1 for the dev item plus the device item */
+			ret = btrfs_extend_transaction(trans, root, 2);
+			BUG_ON(ret);
+		}
 		ret = btrfs_free_dev_extent(trans, map->stripes[i].dev,
 					    map->stripes[i].physical);
 		BUG_ON(ret);
-- 
1.5.4.3

