From: Jeff Mahoney <jeffm@suse.com>
Subject: PATCH] btrfs: Check transaction start
Date: Wed, 11 Feb 2009 22:09:08 -0500
Message-ID: <499392D4.5020709@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
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
 fs/btrfs/extent_io.c   |   18 ++++++++------
 fs/btrfs/file.c        |    9 +++----
 fs/btrfs/inode.c       |   62 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/ioctl.c       |   34 ++++++++++++++++++++++----
 fs/btrfs/super.c       |   13 +++++++---
 fs/btrfs/transaction.c |   25 ++++++++++++++++++-
 fs/btrfs/tree-log.c    |    4 +++
 fs/btrfs/volumes.c     |   17 ++++++++++---
 10 files changed, 166 insertions(+), 44 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1447,6 +1447,8 @@ static int transaction_kthread(void *arg
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			goto sleep;
 		ret = btrfs_commit_transaction(trans, root);
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
@@ -2197,10 +2199,12 @@ int btrfs_commit_super(struct btrfs_root
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
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5259,7 +5259,7 @@ int btrfs_drop_dead_reloc_roots(struct b
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BUG_ON(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
@@ -5317,7 +5317,7 @@ int btrfs_cleanup_reloc_trees(struct btr
 
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		ret = btrfs_commit_transaction(trans, root);
 		BUG_ON(ret);
 	}
@@ -5564,7 +5564,8 @@ static noinline int relocate_one_extent(
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
@@ -5742,6 +5743,8 @@ static int __alloc_chunk_for_shrink(stru
 		spin_unlock(&shrink_block_group->lock);
 
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		spin_lock(&shrink_block_group->lock);
 
 		new_alloc_flags = update_block_group_flags(root,
@@ -5812,7 +5815,8 @@ static noinline struct inode *create_rel
 		return ERR_CAST(root);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return ERR_CAST(trans);
 
 	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
 	if (err)
@@ -5924,7 +5928,8 @@ int btrfs_relocate_block_group(struct bt
 	reloc_inode = create_reloc_inode(info, block_group);
 	BUG_ON(IS_ERR(reloc_inode));
 
-	__alloc_chunk_for_shrink(root, block_group, 1);
+	ret = __alloc_chunk_for_shrink(root, block_group, 1);
+	BUG_ON(ret);
 	set_block_group_readonly(block_group);
 
 	btrfs_start_delalloc_inodes(info->tree_root);
@@ -5939,6 +5944,10 @@ again:
 	cur_byte = key.objectid;
 
 	trans = btrfs_start_transaction(info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_commit_transaction(trans, info->tree_root);
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
@@ -5989,7 +5998,8 @@ next:
 		cur_byte = key.objectid + key.offset;
 		btrfs_release_path(root, path);
 
-		__alloc_chunk_for_shrink(root, block_group, 0);
+		ret = __alloc_chunk_for_shrink(root, block_group, 0);
+		BUG_ON(ret);
 		ret = relocate_one_extent(root, path, &key, block_group,
 					  reloc_inode, pass);
 		BUG_ON(ret < 0);
@@ -6015,6 +6025,7 @@ next:
 		if (total_found == skipped && pass > 2) {
 			iput(reloc_inode);
 			reloc_inode = create_reloc_inode(info, block_group);
+			BUG_ON(IS_ERR(reloc_inode));
 			pass = 0;
 		}
 		goto again;
@@ -6025,6 +6036,7 @@ next:
 
 	/* unpin extents in this range */
 	trans = btrfs_start_transaction(info->tree_root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_commit_transaction(trans, info->tree_root);
 
 	spin_lock(&block_group->lock);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1850,10 +1850,11 @@ static int submit_one_bio(int rw, struct
 
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
@@ -2176,9 +2177,12 @@ static int __extent_writepage(struct pag
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
 
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -129,8 +129,8 @@ static noinline int dirty_and_release_pa
 
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
@@ -1226,8 +1227,8 @@ int btrfs_sync_file(struct file *file, s
 		btrfs_ioctl_trans_end(file);
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
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
@@ -588,11 +588,12 @@ static noinline int submit_compressed_ex
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
@@ -725,7 +726,8 @@ static noinline int cow_file_range(struc
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -987,7 +989,8 @@ static int run_delalloc_nocow(struct ino
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1954,6 +1957,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			BUG_ON(IS_ERR(trans));
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2250,6 +2254,10 @@ static int btrfs_unlink(struct inode *di
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
@@ -2289,6 +2297,10 @@ static int btrfs_rmdir(struct inode *dir
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_orphan_add(trans, inode);
@@ -2839,6 +2851,10 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_set_trans_block_group(trans, inode);
 
 	cur_offset = hole_start;
@@ -2871,6 +2887,7 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	btrfs_end_transaction(trans, root);
+out:
 	unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
 	return err;
 }
@@ -3609,6 +3626,10 @@ static int btrfs_mknod(struct inode *dir
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3671,6 +3692,10 @@ static int btrfs_create(struct inode *di
 	if (err)
 		goto fail;
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3743,6 +3768,11 @@ static int btrfs_link(struct dentry *old
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		BTRFS_I(dir)->index_cnt = index;
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -3786,13 +3816,13 @@ static int btrfs_mkdir(struct inode *dir
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
@@ -4402,7 +4432,7 @@ static void btrfs_truncate(struct inode
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr;
+	unsigned long nr = 0;
 	u64 mask = root->sectorsize - 1;
 
 	if (!S_ISREG(inode->i_mode))
@@ -4414,6 +4444,8 @@ static void btrfs_truncate(struct inode
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return;
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_i_size_write(inode, inode->i_size);
 
@@ -4638,6 +4670,10 @@ static int btrfs_rename(struct inode *ol
 		goto out_unlock;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
 
 	btrfs_set_trans_block_group(trans, new_dir);
 
@@ -4756,6 +4792,7 @@ static int btrfs_symlink(struct inode *d
 		goto out_fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -4857,7 +4894,8 @@ static int prealloc_file_range(struct in
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	while (num_bytes > 0) {
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -75,7 +75,10 @@ static noinline int create_subvol(struct
 		goto fail_commit;
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail_commit;
+	}
 
 	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
 				       0, &objectid);
@@ -174,7 +177,11 @@ static noinline int create_subvol(struct
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
@@ -222,7 +229,12 @@ static int create_snapshot(struct btrfs_
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
@@ -537,6 +549,10 @@ static int btrfs_ioctl_resize(struct btr
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out_unlock;
+		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
 	} else {
@@ -651,8 +667,9 @@ static int btrfs_ioctl_defrag(struct fil
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
@@ -827,7 +844,12 @@ static long btrfs_ioctl_clone(struct fil
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
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -381,7 +381,13 @@ int btrfs_sync_fs(struct super_block *sb
 
 	btrfs_clean_old_snapshots(root);
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
@@ -527,7 +533,8 @@ static int btrfs_remount(struct super_bl
 			return -EINVAL;
 
 		ret = btrfs_cleanup_reloc_trees(root);
-		WARN_ON(ret);
+		if (ret)
+			return ret;
 
 		ret = btrfs_cleanup_fs_roots(root->fs_info);
 		WARN_ON(ret);
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -51,7 +51,8 @@ static noinline int join_transaction(str
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		BUG_ON(!cur_trans);
+		if (!cur_trans)
+			return -ENOMEM;
 		root->fs_info->generation++;
 		root->fs_info->last_alloc = 0;
 		root->fs_info->last_data_alloc = 0;
@@ -167,12 +168,20 @@ static struct btrfs_trans_handle *start_
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	int ret;
 
+	if (!h) {
+		WARN_ON_ONCE(1);
+		return ERR_PTR(-ENOMEM);
+	}
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
@@ -183,6 +192,7 @@ static struct btrfs_trans_handle *start_
 	h->alloc_exclude_nr = 0;
 	h->alloc_exclude_start = 0;
 	root->fs_info->running_transaction->use_count++;
+out:
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
@@ -616,6 +626,8 @@ int btrfs_defrag_root(struct btrfs_root
 	if (root->defrag_running)
 		return 0;
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	while (1) {
 		root->defrag_running = 1;
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
@@ -625,6 +637,11 @@ int btrfs_defrag_root(struct btrfs_root
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
@@ -662,6 +679,10 @@ static noinline int drop_dirty_roots(str
 
 		while (1) {
 			trans = btrfs_start_transaction(tree_root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				break;
+			}
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, dirty->root);
 			if (ret != -EAGAIN)
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2793,6 +2793,10 @@ int btrfs_recover_log_trees(struct btrfs
 	BUG_ON(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 
 	wc.trans = trans;
 	wc.pin = 1;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -951,6 +951,10 @@ static int btrfs_rm_dev_item(struct btrf
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1324,6 +1328,11 @@ int btrfs_init_new_device(struct btrfs_r
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		kfree(device);
+		ret = PTR_ERR(trans);
+		goto error;
+	}
 	lock_chunks(root);
 
 	device->barriers = 1;
@@ -1569,7 +1578,7 @@ static int btrfs_relocate_chunk(struct b
 	BUG_ON(ret);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	lock_chunks(root);
 
@@ -1725,7 +1734,7 @@ int btrfs_balance(struct btrfs_root *dev
 		BUG_ON(ret);
 
 		trans = btrfs_start_transaction(dev_root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
@@ -1816,8 +1825,8 @@ int btrfs_shrink_device(struct btrfs_dev
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto done;
 	}
 
