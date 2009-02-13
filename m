From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/5] Btrfs: handle transaction start failures
Date: Fri, 13 Feb 2009 17:17:40 -0500
Message-ID: <1234563463-7585-2-git-send-email-jeffm@suse.com>
References: <1234563463-7585-1-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234563463-7585-1-git-send-email-jeffm@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch changes start_transaction() to return an ERR_PTR instead of
 NULL. Things like I/O errors and allocation failures can be handled
 differently.

 It also checks every start_transaction call. Where the error can be
 handled simply, we clean up state and return an error.

 If the recovery is more involved, we BUG. This isn't a change in
 functionality since we'd Oops anyway. The more complex recovery should
 be done in separate patches, so this is really just to annotate where
 that needs to happen.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c     |    4 +++
 fs/btrfs/extent-tree.c |   24 ++++++++++++++----
 fs/btrfs/extent_io.c   |   18 ++++++++-----
 fs/btrfs/file.c        |    9 ++++---
 fs/btrfs/inode.c       |   62 ++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.c       |   34 +++++++++++++++++++++----
 fs/btrfs/super.c       |   11 +++++++-
 fs/btrfs/transaction.c |   23 ++++++++++++++++-
 fs/btrfs/tree-log.c    |    4 +++
 fs/btrfs/volumes.c     |   17 ++++++++++---
 10 files changed, 163 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index adda739..c7d4136 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1492,6 +1492,8 @@ static int transaction_kthread(void *arg)
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			goto sleep;
 		ret = btrfs_commit_transaction(trans, root);
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
@@ -2241,10 +2243,12 @@ int btrfs_commit_super(struct btrfs_root *root)
 	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 777af73..ad699c2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5276,7 +5276,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BUG_ON(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
@@ -5334,7 +5334,7 @@ int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
 
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		ret = btrfs_commit_transaction(trans, root);
 		BUG_ON(ret);
 	}
@@ -5581,7 +5581,8 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
@@ -5761,6 +5762,8 @@ static int __alloc_chunk_for_shrink(struct btrfs_root *root,
 		spin_unlock(&shrink_block_group->lock);
 
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		spin_lock(&shrink_block_group->lock);
 
 		new_alloc_flags = update_block_group_flags(root,
@@ -5831,7 +5834,8 @@ static noinline struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 		return ERR_CAST(root);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return ERR_CAST(trans);
 
 	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
 	if (err)
@@ -5943,7 +5947,8 @@ int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start)
 	reloc_inode = create_reloc_inode(info, block_group);
 	BUG_ON(IS_ERR(reloc_inode));
 
-	__alloc_chunk_for_shrink(root, block_group, 1);
+	ret = __alloc_chunk_for_shrink(root, block_group, 1);
+	BUG_ON(ret);
 	set_block_group_readonly(block_group);
 
 	btrfs_start_delalloc_inodes(info->tree_root);
@@ -5958,6 +5963,10 @@ again:
 	cur_byte = key.objectid;
 
 	trans = btrfs_start_transaction(info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_commit_transaction(trans, info->tree_root);
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
@@ -6008,7 +6017,8 @@ next:
 		cur_byte = key.objectid + key.offset;
 		btrfs_release_path(root, path);
 
-		__alloc_chunk_for_shrink(root, block_group, 0);
+		ret = __alloc_chunk_for_shrink(root, block_group, 0);
+		BUG_ON(ret);
 		ret = relocate_one_extent(root, path, &key, block_group,
 					  reloc_inode, pass);
 		BUG_ON(ret < 0);
@@ -6034,6 +6044,7 @@ next:
 		if (total_found == skipped && pass > 2) {
 			iput(reloc_inode);
 			reloc_inode = create_reloc_inode(info, block_group);
+			BUG_ON(IS_ERR(reloc_inode));
 			pass = 0;
 		}
 		goto again;
@@ -6044,6 +6055,7 @@ next:
 
 	/* unpin extents in this range */
 	trans = btrfs_start_transaction(info->tree_root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_commit_transaction(trans, info->tree_root);
 
 	spin_lock(&block_group->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ebe6b29..b192a15 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1848,10 +1848,11 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 
 	bio_get(bio);
 
-	if (tree->ops && tree->ops->submit_bio_hook)
-		tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
-					   mirror_num, bio_flags);
-	else
+	if (tree->ops && tree->ops->submit_bio_hook) {
+		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
+						 mirror_num, bio_flags);
+		BUG_ON(ret);
+	} else
 		submit_bio(rw, bio);
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
@@ -2174,9 +2175,12 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 				delalloc_start = delalloc_end + 1;
 				continue;
 			}
-			tree->ops->fill_delalloc(inode, page, delalloc_start,
-						 delalloc_end, &page_started,
-						 &nr_written);
+			ret = tree->ops->fill_delalloc(inode, page,
+						       delalloc_start,
+						       delalloc_end,
+						       &page_started,
+						       &nr_written);
+			BUG_ON(ret);
 			delalloc_start = delalloc_end + 1;
 		}
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3e8023e..c5419a4 100644
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
@@ -1154,6 +1154,7 @@ out_nolock:
 
 		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			BUG_ON(IS_ERR(trans));
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
 			if (ret == 0) {
@@ -1226,8 +1227,8 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		btrfs_ioctl_trans_end(file);
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3cee77a..18a65f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -429,7 +429,7 @@ again:
 	}
 	if (start == 0) {
 		trans = btrfs_join_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
 
 		/* lets try to make an inline extent */
@@ -588,11 +588,12 @@ static noinline int submit_compressed_extents(struct inode *inode,
 				    async_extent->ram_size - 1, GFP_NOFS);
 
 			/* allocate blocks */
-			cow_file_range(inode, async_cow->locked_page,
-				       async_extent->start,
-				       async_extent->start +
-				       async_extent->ram_size - 1,
-				       &page_started, &nr_written, 0);
+			ret = cow_file_range(inode, async_cow->locked_page,
+					     async_extent->start,
+					     async_extent->start +
+					     async_extent->ram_size - 1,
+					     &page_started, &nr_written, 0);
+			BUG_ON(ret);
 
 			/*
 			 * if page_started, cow_file_range inserted an
@@ -725,7 +726,8 @@ static noinline int cow_file_range(struct inode *inode,
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -987,7 +989,8 @@ static int run_delalloc_nocow(struct inode *inode, struct page *locked_page,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1954,6 +1957,7 @@ void btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			BUG_ON(IS_ERR(trans));
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2250,6 +2254,10 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
@@ -2289,6 +2297,10 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_orphan_add(trans, inode);
@@ -2837,6 +2849,10 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_set_trans_block_group(trans, inode);
 
 	cur_offset = hole_start;
@@ -2869,6 +2885,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	}
 
 	btrfs_end_transaction(trans, root);
+out:
 	unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
 	return err;
 }
@@ -3607,6 +3624,10 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3669,6 +3690,10 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	if (err)
 		goto fail;
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3741,6 +3766,11 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		BTRFS_I(dir)->index_cnt = index;
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -3784,13 +3814,13 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out_unlock;
 
 	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_trans_block_group(trans, dir);
-
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		goto out_unlock;
 	}
 
+	btrfs_set_trans_block_group(trans, dir);
+
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
 	if (err) {
 		err = -ENOSPC;
@@ -4400,7 +4430,7 @@ static void btrfs_truncate(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr;
+	unsigned long nr = 0;
 	u64 mask = root->sectorsize - 1;
 
 	if (!S_ISREG(inode->i_mode))
@@ -4412,6 +4442,8 @@ static void btrfs_truncate(struct inode *inode)
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return;
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_i_size_write(inode, inode->i_size);
 
@@ -4636,6 +4668,10 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto out_unlock;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
 
 	btrfs_set_trans_block_group(trans, new_dir);
 
@@ -4754,6 +4790,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -4855,7 +4892,8 @@ static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	while (num_bytes > 0) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 988fdc8..4b62868 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -75,7 +75,10 @@ static noinline int create_subvol(struct btrfs_root *root,
 		goto fail_commit;
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail_commit;
+	}
 
 	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
 				       0, &objectid);
@@ -174,7 +177,11 @@ static noinline int create_subvol(struct btrfs_root *root,
 	BUG_ON(!new_root);
 
 	trans = btrfs_start_transaction(new_root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		/* JDM: When is all the stuff we just made cleaned up? */
+		ret = PTR_ERR(trans);
+		goto fail_commit;
+	}
 
 	ret = btrfs_create_subvol_root(trans, new_root, dentry, new_dirid,
 				       BTRFS_I(dir)->block_group);
@@ -222,7 +229,12 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->name[namelen] = '\0';
 	pending_snapshot->dentry = dentry;
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		kfree(pending_snapshot->name);
+		kfree(pending_snapshot);
+		ret = PTR_ERR(trans);
+		goto fail_unlock;
+	}
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
@@ -537,6 +549,10 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out_unlock;
+		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
 	} else {
@@ -651,8 +667,9 @@ static int btrfs_ioctl_defrag(struct file *file)
 			ret = -EPERM;
 			goto out;
 		}
-		btrfs_defrag_root(root, 0);
-		btrfs_defrag_root(root->fs_info->extent_root, 0);
+		ret = btrfs_defrag_root(root, 0);
+		if (!ret)
+			ret = btrfs_defrag_root(root->fs_info->extent_root, 0);
 		break;
 	case S_IFREG:
 		if (!(file->f_mode & FMODE_WRITE)) {
@@ -827,7 +844,12 @@ static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		btrfs_release_path(root, path);
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
 
 	/* punch hole in destination first */
 	btrfs_drop_extents(trans, root, inode, off, off+len, 0, &hint_byte);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 19a4daf..19af4ca 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -380,7 +380,13 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_start_transaction(root, 1);
-	ret = btrfs_commit_transaction(trans, root);
+	if (!IS_ERR(trans))
+		ret = btrfs_commit_transaction(trans, root);
+	else
+		ret = PTR_ERR(trans);
+
+	/* Even if the transaction isn't committed, sync_supers
+	 * will loop if we don't clear the dirty flag */
 	sb->s_dirt = 0;
 	return ret;
 }
@@ -530,7 +536,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			return -EINVAL;
 
 		ret = btrfs_cleanup_reloc_trees(root);
-		WARN_ON(ret);
+		if (ret)
+			return ret;
 
 		ret = btrfs_cleanup_fs_roots(root->fs_info);
 		WARN_ON(ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4112d53..fa07264 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -51,7 +51,8 @@ static noinline int join_transaction(struct btrfs_root *root)
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		BUG_ON(!cur_trans);
+		if (!cur_trans)
+			return -ENOMEM;
 		root->fs_info->generation++;
 		root->fs_info->last_alloc = 0;
 		root->fs_info->last_data_alloc = 0;
@@ -167,12 +168,18 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	int ret;
 
+	if (!h)
+		return ERR_PTR(-ENOMEM);
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (!root->fs_info->log_root_recovering &&
 	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
 		wait_current_trans(root);
 	ret = join_transaction(root);
-	BUG_ON(ret);
+	if (ret) {
+		h = ERR_PTR(ret);
+		goto out;
+	}
 
 	btrfs_record_root_in_trans(root);
 	h->transid = root->fs_info->running_transaction->transid;
@@ -183,6 +190,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	h->alloc_exclude_nr = 0;
 	h->alloc_exclude_start = 0;
 	root->fs_info->running_transaction->use_count++;
+out:
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
@@ -616,6 +624,8 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 	if (root->defrag_running)
 		return 0;
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	while (1) {
 		root->defrag_running = 1;
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
@@ -625,6 +635,11 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 		cond_resched();
 
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			root->defrag_running = 0;
+			smp_mb();
+			return PTR_ERR(trans);
+		}
 		if (root->fs_info->closing || ret != -EAGAIN)
 			break;
 	}
@@ -662,6 +677,10 @@ static noinline int drop_dirty_roots(struct btrfs_root *tree_root,
 
 		while (1) {
 			trans = btrfs_start_transaction(tree_root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				break;
+			}
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, dirty->root);
 			if (ret != -EAGAIN)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9c462fb..b161e63 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2793,6 +2793,10 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 	BUG_ON(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 
 	wc.trans = trans;
 	wc.pin = 1;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1316139..1b35ae0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -951,6 +951,10 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1324,6 +1328,11 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		kfree(device);
+		ret = PTR_ERR(trans);
+		goto error;
+	}
 	lock_chunks(root);
 
 	device->barriers = 1;
@@ -1569,7 +1578,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	BUG_ON(ret);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	lock_chunks(root);
 
@@ -1725,7 +1734,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		BUG_ON(ret);
 
 		trans = btrfs_start_transaction(dev_root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
@@ -1816,8 +1825,8 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto done;
 	}
 
-- 
1.6.0.2

