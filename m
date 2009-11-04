From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 09/10] btrfs: handle btrfs_{start,join}_transaction call path failures
Date: Wed, 04 Nov 2009 14:03:55 -0500
Message-ID: <20091104190434.604999770@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes start_transaction() to return an ERR_PTR instead of
NULL. Things like I/O errors and allocation failures can be handled
differently.

Many calls that were previously handled by BTRFS_UERROR are changed to
actually pass the error up the tree where appropriate.

In cases where the handling isn't small or obvious, the BTRFS_UERROR
call is kept for handling in small patches specific to that site.

Eventually it may be preferable to allow passing of gfp_t to
btrfs_start_transaction (or a one-off) so that handling can be done at
allocation time instead of failing all the way up the call path.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/btrfs/compression.c |   10 ++-
 fs/btrfs/disk-io.c     |   37 +++++++++-----
 fs/btrfs/extent-tree.c |   43 ++++++++++------
 fs/btrfs/extent_io.c   |   60 ++++++++++++++--------
 fs/btrfs/file.c        |   16 ++++--
 fs/btrfs/inode.c       |  128 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/ioctl.c       |   73 +++++++++++++++++++--------
 fs/btrfs/relocation.c  |   96 ++++++++++++++++++++++++++++--------
 fs/btrfs/super.c       |   12 +++-
 fs/btrfs/transaction.c |   34 +++++++++----
 fs/btrfs/tree-log.c    |   14 +++--
 fs/btrfs/volumes.c     |   44 ++++++++++------
 fs/btrfs/xattr.c       |    3 -
 13 files changed, 382 insertions(+), 188 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -280,6 +280,7 @@ static void end_compressed_bio_write(str
 	struct inode *inode;
 	struct page *page;
 	unsigned long index;
+	int ret;
 
 	if (err)
 		cb->errors = 1;
@@ -296,10 +297,11 @@ static void end_compressed_bio_write(str
 	inode = cb->inode;
 	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
-	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
-					 cb->start,
-					 cb->start + cb->len - 1,
-					 NULL, 1);
+	ret = tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
+					       cb->start,
+					       cb->start + cb->len - 1,
+					       NULL, 1);
+	BTRFS_UERROR(ret);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb->start, cb->len);
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1468,6 +1468,7 @@ static void end_workqueue_fn(struct btrf
 static int cleaner_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
+	int ret;
 
 	do {
 		smp_mb();
@@ -1478,7 +1479,8 @@ static int cleaner_kthread(void *arg)
 
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
-			btrfs_clean_old_snapshots(root);
+			ret = btrfs_clean_old_snapshots(root);
+			BTRFS_UERROR(ret);
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 		}
 
@@ -1529,9 +1531,11 @@ static int transaction_kthread(void *arg
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
-		ret = btrfs_commit_transaction(trans, root);
+		if (!IS_ERR(trans))
+			ret = btrfs_commit_transaction(trans, root);
 
+		if (IS_ERR(trans) || ret)
+			delay = HZ * 5;
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
@@ -1971,11 +1975,15 @@ struct btrfs_root *open_ctree(struct sup
 						      blocksize,
 						      generation + 1);
 		ret = btrfs_recover_log_trees(log_tree_root);
-		BUG_ON(ret);
+		if (ret) {
+			/* log_tree_root is cleaned up by
+			 * btrfs_recover_log_trees */
+			goto fail_trans_thread;
+		}
 
 		if (sb->s_flags & MS_RDONLY) {
 			ret =  btrfs_commit_super(tree_root);
-			BUG_ON(ret);
+			BTRFS_UERROR(ret);
 		}
 	}
 
@@ -1984,7 +1992,7 @@ struct btrfs_root *open_ctree(struct sup
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_recover_relocation(tree_root);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 	}
 
 	location.objectid = BTRFS_FS_TREE_OBJECTID;
@@ -2393,16 +2401,23 @@ int btrfs_commit_super(struct btrfs_root
 	int ret;
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
-	btrfs_clean_old_snapshots(root);
+	ret = btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
+	if (ret)
+		return ret;
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
-	btrfs_commit_transaction(trans, root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret)
+		return ret;
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
 
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3009,8 +3009,8 @@ static int maybe_allocate_chunk(struct b
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
@@ -3044,6 +3044,7 @@ int btrfs_reserve_metadata_for_delalloc(
 	u64 alloc_target;
 	int flushed = 0;
 	int force_delalloc;
+	int ret = 0;
 
 	/* get the space info for where the metadata will live */
 	alloc_target = btrfs_get_alloc_profile(root, 0);
@@ -3249,8 +3250,8 @@ again:
 alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
 			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 					     bytes + 2 * 1024 * 1024,
@@ -3271,7 +3272,7 @@ alloc:
 		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
-			if (!trans)
+			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 			ret = btrfs_commit_transaction(trans, root);
 			if (ret)
@@ -5396,7 +5397,10 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	}
 
 	trans = btrfs_start_transaction(tree_root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_err;
+	}
 
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
@@ -5493,7 +5497,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 
 			btrfs_end_transaction(trans, tree_root);
 			trans = btrfs_start_transaction(tree_root, 1);
-			BTRFS_UERROR(!trans);
+			BTRFS_UERROR(IS_ERR(trans));
 		} else {
 			unsigned long update;
 			update = trans->delayed_ref_updates;
@@ -5529,6 +5533,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	}
 out:
 	btrfs_end_transaction(trans, tree_root);
+out_err:
 	kfree(wc);
 	btrfs_free_path(path);
 	return err;
@@ -6656,7 +6661,7 @@ int btrfs_drop_dead_reloc_roots(struct b
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BTRFS_UERROR(!trans);
+			BTRFS_UERROR(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
@@ -6669,6 +6674,7 @@ int btrfs_drop_dead_reloc_roots(struct b
 			BUG_ON(ret);
 			btrfs_btree_balance_dirty(root, nr);
 		}
+		BTRFS_UERROR(ret);
 
 		free_extent_buffer(reloc_root->node);
 
@@ -6714,9 +6720,11 @@ int btrfs_cleanup_reloc_trees(struct btr
 
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		ret = btrfs_commit_transaction(trans, root);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 
 	location.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
@@ -6959,7 +6967,8 @@ static noinline int relocate_one_extent(
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
@@ -6989,7 +6998,7 @@ static noinline int relocate_one_extent(
 			continue;
 
 		found_root = read_ref_root(extent_root->fs_info, ref_path);
-		BUG_ON(IS_ERR(found_root));
+		BTRFS_UERROR(IS_ERR(found_root));
 		/*
 		 * for reference counted tree, only process reference paths
 		 * rooted at the latest committed root.
@@ -7142,7 +7151,8 @@ static int __alloc_chunk_for_shrink(stru
 		spin_unlock(&shrink_block_group->lock);
 
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		spin_lock(&shrink_block_group->lock);
 
 		new_alloc_flags = update_block_group_flags(root,
@@ -7169,9 +7179,10 @@ int btrfs_prepare_block_group_relocation
 					 struct btrfs_block_group_cache *group)
 
 {
-	__alloc_chunk_for_shrink(root, group, 1);
-	set_block_group_readonly(group);
-	return 0;
+	int ret = __alloc_chunk_for_shrink(root, group, 1);
+	if (!ret)
+		set_block_group_readonly(group);
+	return ret;
 }
 
 /*
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1899,10 +1899,11 @@ static int submit_one_bio(int rw, struct
 
 	bio_get(bio);
 
-	if (tree->ops && tree->ops->submit_bio_hook)
-		tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
-					   mirror_num, bio_flags);
-	else
+	if (tree->ops && tree->ops->submit_bio_hook) {
+		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
+						 mirror_num, bio_flags);
+		BTRFS_UERROR(ret);
+	} else
 		submit_bio(rw, bio);
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
@@ -2189,7 +2190,7 @@ static int __extent_writepage(struct pag
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em;
 	struct block_device *bdev;
-	int ret;
+	int ret = 0;
 	int nr = 0;
 	size_t pg_offset = 0;
 	size_t blocksize;
@@ -2250,9 +2251,12 @@ static int __extent_writepage(struct pag
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
+			BTRFS_UERROR(ret);
 			/*
 			 * delalloc_end is already one less than the total
 			 * length, so we don't subtract one from
@@ -2306,9 +2310,11 @@ static int __extent_writepage(struct pag
 
 	end = page_end;
 	if (last_byte <= start) {
-		if (tree->ops && tree->ops->writepage_end_io_hook)
-			tree->ops->writepage_end_io_hook(page, start,
-							 page_end, NULL, 1);
+		if (tree->ops && tree->ops->writepage_end_io_hook) {
+			ret = tree->ops->writepage_end_io_hook(page, start,
+							page_end, NULL, 1);
+			BTRFS_UERROR(ret);
+		}
 		unlock_start = page_end + 1;
 		goto done;
 	}
@@ -2317,9 +2323,12 @@ static int __extent_writepage(struct pag
 
 	while (cur <= end) {
 		if (cur >= last_byte) {
-			if (tree->ops && tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 page_end, NULL, 1);
+			if (tree->ops && tree->ops->writepage_end_io_hook) {
+				ret = tree->ops->writepage_end_io_hook(page,
+								cur, page_end,
+								NULL, 1);
+				BTRFS_UERROR(ret);
+			}
 			unlock_start = page_end + 1;
 			break;
 		}
@@ -2353,10 +2362,12 @@ static int __extent_writepage(struct pag
 			 * compressed extents
 			 */
 			if (!compressed && tree->ops &&
-			    tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 cur + iosize - 1,
-							 NULL, 1);
+			    tree->ops->writepage_end_io_hook) {
+				ret = tree->ops->writepage_end_io_hook(page,
+							cur, cur + iosize - 1,
+							NULL, 1);
+				BTRFS_UERROR(ret);
+			}
 			else if (compressed) {
 				/* we don't want to end_page_writeback on
 				 * a compressed extent.  this happens
@@ -2421,7 +2432,7 @@ done_unlocked:
 
 	/* drop our reference on any cached states */
 	free_extent_state(cached_state);
-	return 0;
+	return ret;
 }
 
 /**
@@ -2621,10 +2632,13 @@ int extent_write_locked_range(struct ext
 		if (clear_page_dirty_for_io(page))
 			ret = __extent_writepage(page, &wbc_writepages, &epd);
 		else {
-			if (tree->ops && tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, start,
-						 start + PAGE_CACHE_SIZE - 1,
-						 NULL, 1);
+			if (tree->ops && tree->ops->writepage_end_io_hook) {
+				ret = tree->ops->writepage_end_io_hook(page,
+						start,
+						start + PAGE_CACHE_SIZE - 1,
+						NULL, 1);
+				BTRFS_UERROR(ret);
+			}
 			unlock_page(page);
 		}
 		page_cache_release(page);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1083,7 +1083,10 @@ out_nolock:
 
 		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
-			BTRFS_UERROR(!trans);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
+				goto out;
+			}
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
 			if (ret == 0) {
@@ -1091,9 +1094,11 @@ out_nolock:
 				if (ret == 0)
 					btrfs_end_transaction(trans, root);
 				else
-					btrfs_commit_transaction(trans, root);
+					err = btrfs_commit_transaction(trans,
+								       root);
+
 			} else if (ret != BTRFS_NO_LOG_SYNC) {
-				btrfs_commit_transaction(trans, root);
+				err = btrfs_commit_transaction(trans, root);
 			} else {
 				btrfs_end_transaction(trans, root);
 			}
@@ -1104,6 +1109,7 @@ out_nolock:
 			     (start_pos + num_written - 1) >> PAGE_CACHE_SHIFT);
 		}
 	}
+out:
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
@@ -1180,8 +1186,8 @@ int btrfs_sync_file(struct file *file, s
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
@@ -403,7 +403,7 @@ again:
 	}
 	if (start == 0) {
 		trans = btrfs_join_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
 
 		/* lets try to make an inline extent */
@@ -550,7 +550,8 @@ static noinline int submit_compressed_ex
 		return 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	while (!list_empty(&async_cow->extents)) {
 		async_extent = list_entry(async_cow->extents.next,
@@ -569,11 +570,12 @@ static noinline int submit_compressed_ex
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
+			BTRFS_UERROR(ret);
 
 			/*
 			 * if page_started, cow_file_range inserted an
@@ -581,13 +583,15 @@ static noinline int submit_compressed_ex
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started)
-				extent_write_locked_range(io_tree,
+			if (!page_started) {
+				ret = extent_write_locked_range(io_tree,
 						  inode, async_extent->start,
 						  async_extent->start +
 						  async_extent->ram_size - 1,
 						  btrfs_get_extent,
 						  WB_SYNC_ALL);
+				BTRFS_UERROR(ret);
+			}
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -665,7 +669,7 @@ static noinline int submit_compressed_ex
 
 		BUG_ON(ret);
 		trans = btrfs_join_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
 		cond_resched();
@@ -710,7 +714,8 @@ static noinline int cow_file_range(struc
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -838,10 +843,12 @@ static noinline void async_cow_start(str
 	struct async_cow *async_cow;
 	int num_added = 0;
 	async_cow = container_of(work, struct async_cow, work);
+	int ret;
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	ret = compress_file_range(async_cow->inode, async_cow->locked_page,
+				  async_cow->start, async_cow->end, async_cow,
+				  &num_added);
+	BTRFS_UERROR(ret);
 	if (num_added == 0)
 		async_cow->inode = NULL;
 }
@@ -992,7 +999,8 @@ static noinline int run_delalloc_nocow(s
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1102,7 +1110,7 @@ out_check:
 			ret = cow_file_range(inode, locked_page, cow_start,
 					found_key.offset - 1, page_started,
 					nr_written, 1);
-			BUG_ON(ret);
+			BTRFS_UERROR(ret);
 			cow_start = (u64)-1;
 		}
 
@@ -1154,7 +1162,7 @@ out_check:
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 	}
 
 	ret = btrfs_end_transaction(trans, root);
@@ -1711,7 +1719,8 @@ static int btrfs_finish_ordered_io(struc
 	}
 
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	if (!ordered_extent)
 		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
@@ -2132,7 +2141,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 1);
-			BTRFS_UERROR(!trans);
+			BTRFS_UERROR(IS_ERR(trans));
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2486,7 +2495,8 @@ static int btrfs_unlink(struct inode *di
 	root = BTRFS_I(dir)->root;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2582,7 +2592,9 @@ static int btrfs_rmdir(struct inode *dir
 		return -ENOTEMPTY;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	btrfs_set_trans_block_group(trans, dir);
 
 	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
@@ -3158,14 +3170,17 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_set_trans_block_group(trans, inode);
 
 	cur_offset = hole_start;
 	while (1) {
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				block_end - cur_offset, 0);
-		BUG_ON(IS_ERR(em) || !em);
+		BTRFS_UERROR(IS_ERR(em) || !em);
 		last_byte = min(extent_map_end(em), block_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
@@ -3198,6 +3213,7 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	btrfs_end_transaction(trans, root);
+out:
 	unlock_extent(io_tree, hole_start, block_end - 1, GFP_NOFS);
 	return err;
 }
@@ -3256,7 +3272,7 @@ void btrfs_delete_inode(struct inode *in
 
 	btrfs_i_size_write(inode, 0);
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	BTRFS_UERROR(IS_ERR(trans));
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 0);
@@ -3853,7 +3869,8 @@ int btrfs_write_inode(struct inode *inod
 
 	if (wait) {
 		trans = btrfs_join_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		btrfs_set_trans_block_group(trans, inode);
 		ret = btrfs_commit_transaction(trans, root);
 	}
@@ -3872,7 +3889,8 @@ void btrfs_dirty_inode(struct inode *ino
 	struct btrfs_trans_handle *trans;
 
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return;
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_update_inode(trans, root, inode);
 	btrfs_end_transaction(trans, root);
@@ -4166,9 +4184,10 @@ static int btrfs_mknod(struct inode *dir
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
-	err = -ENOMEM;
-	if (!trans)
-		goto fail;
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 5);
+		return PTR_ERR(trans);
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -4237,9 +4256,10 @@ static int btrfs_create(struct inode *di
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
-	err = -ENOMEM;
-	if (!trans)
-		goto fail;
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 5);
+		return PTR_ERR(trans);
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -4318,7 +4338,12 @@ static int btrfs_link(struct dentry *old
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		btrfs_dec_nlink(inode);
+		BTRFS_I(dir)->index_cnt = index;
+		err = PTR_ERR(trans);
+		goto fail;
+	}
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -4367,8 +4392,8 @@ static int btrfs_mkdir(struct inode *dir
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		err = -ENOMEM;
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
 		goto out_unlock;
 	}
 	btrfs_set_trans_block_group(trans, dir);
@@ -4686,7 +4711,7 @@ again:
 				em = NULL;
 				btrfs_release_path(root, path);
 				trans = btrfs_join_transaction(root, 1);
-				BTRFS_UERROR(!trans);
+				BTRFS_UERROR(IS_ERR(trans));
 				goto again;
 			}
 			map = kmap(page);
@@ -4892,8 +4917,10 @@ static void btrfs_invalidatepage(struct
 		 * for the finish_ordered_io
 		 */
 		if (TestClearPagePrivate2(page)) {
-			btrfs_finish_ordered_io(page->mapping->host,
-						page_start, page_end);
+			int ret;
+			ret = btrfs_finish_ordered_io(page->mapping->host,
+						      page_start, page_end);
+			BTRFS_UERROR(ret);
 		}
 		btrfs_put_ordered_extent(ordered);
 		lock_extent(tree, page_start, page_end, GFP_NOFS);
@@ -5042,7 +5069,7 @@ static void btrfs_truncate(struct inode
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr;
+	unsigned long nr = 0;
 	u64 mask = root->sectorsize - 1;
 
 	if (!S_ISREG(inode->i_mode))
@@ -5056,7 +5083,7 @@ static void btrfs_truncate(struct inode
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	BTRFS_UERROR(IS_ERR(trans));
 
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
@@ -5329,7 +5356,10 @@ static int btrfs_rename(struct inode *ol
 		down_read(&root->fs_info->subvol_sem);
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_fail_notrans;
+	}
 	btrfs_set_trans_block_group(trans, new_dir);
 
 	if (dest != root)
@@ -5425,6 +5455,8 @@ static int btrfs_rename(struct inode *ol
 out_fail:
 	btrfs_end_transaction_throttle(trans, root);
 
+out_fail_notrans:
+
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
@@ -5510,9 +5542,10 @@ static int btrfs_symlink(struct inode *d
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
-	err = -ENOMEM;
-	if (!trans)
-		goto out_fail;
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 5);
+		return PTR_ERR(trans);
+	}
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -5592,7 +5625,6 @@ static int btrfs_symlink(struct inode *d
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
-out_fail:
 	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
@@ -5698,8 +5730,8 @@ static long btrfs_fallocate(struct inode
 		struct btrfs_ordered_extent *ordered;
 
 		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 1);
-		if (!trans) {
-			ret = -EIO;
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
 			goto out_free;
 		}
 
@@ -5735,7 +5767,7 @@ static long btrfs_fallocate(struct inode
 	while (1) {
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
-		BUG_ON(IS_ERR(em) || !em);
+		BTRFS_UERROR(IS_ERR(em) || !em);
 		last_byte = min(extent_map_end(em), alloc_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (em->block_start == EXTENT_MAP_HOLE) {
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -172,6 +172,12 @@ static int btrfs_ioctl_setflags(struct f
 	if (ret)
 		goto out_unlock;
 
+	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_drop_write;
+	}
+
 	if (flags & FS_SYNC_FL)
 		ip->flags |= BTRFS_INODE_SYNC;
 	else
@@ -197,10 +203,6 @@ static int btrfs_ioctl_setflags(struct f
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
 
-
-	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
-
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 
@@ -208,10 +210,11 @@ static int btrfs_ioctl_setflags(struct f
 	inode->i_ctime = CURRENT_TIME;
 	btrfs_end_transaction(trans, root);
 
+out_drop_write:
 	mnt_drop_write(file->f_path.mnt);
- out_unlock:
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
-	return 0;
+	return ret;
 }
 
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
@@ -232,6 +235,7 @@ static noinline int create_subvol(struct
 	struct extent_buffer *leaf;
 	struct btrfs_root *new_root;
 	struct inode *dir = dentry->d_parent->d_inode;
+	struct inode *inode;
 	int ret;
 	int err;
 	u64 objectid;
@@ -250,7 +254,10 @@ static noinline int create_subvol(struct
 		return ret;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		btrfs_unreserve_metadata_space(root, 6);
+		return PTR_ERR(trans);
+	}
 
 	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
 				       0, &objectid);
@@ -312,7 +319,7 @@ static noinline int create_subvol(struct
 
 	key.offset = (u64)-1;
 	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
-	BUG_ON(IS_ERR(new_root));
+	BTRFS_UERROR(IS_ERR(new_root));
 
 	btrfs_record_root_in_trans(trans, new_root);
 
@@ -340,13 +347,14 @@ static noinline int create_subvol(struct
 
 	BUG_ON(ret);
 
-	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
+	inode = btrfs_lookup_dentry(dir, dentry);
+	BTRFS_UERROR(IS_ERR(inode));
+	d_instantiate(dentry, inode);
 fail:
 	nr = trans->blocks_used;
 	err = btrfs_commit_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
-
 	btrfs_unreserve_metadata_space(root, 6);
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
@@ -358,7 +366,6 @@ static int create_snapshot(struct btrfs_
 	struct btrfs_pending_snapshot *pending_snapshot;
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
-	int err;
 	unsigned long nr = 0;
 
 	if (!root->ref_cows)
@@ -391,11 +398,16 @@ static int create_snapshot(struct btrfs_
 	pending_snapshot->name[namelen] = '\0';
 	pending_snapshot->dentry = dentry;
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		kfree(pending_snapshot->name);
+		kfree(pending_snapshot);
+		ret = PTR_ERR(trans);
+		goto fail_unlock;
+	}
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	err = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
 
 fail_unlock:
 	btrfs_btree_balance_dirty(root, nr);
@@ -638,10 +650,15 @@ static noinline int btrfs_ioctl_resize(s
 		device->name, (unsigned long long)new_size);
 
 	if (new_size > old_size) {
+		int err;
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out_unlock;
+		}
 		ret = btrfs_grow_device(trans, device, new_size);
-		btrfs_commit_transaction(trans, root);
+		err = btrfs_commit_transaction(trans, root);
+		ret = ret ?: err;
 	} else {
 		ret = btrfs_shrink_device(device, new_size);
 	}
@@ -805,7 +822,10 @@ static noinline int btrfs_ioctl_snap_des
 		goto out_up_write;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_up_write;
+	}
 	ret = btrfs_unlink_subvol(trans, root, dir,
 				dest->root_key.objectid,
 				dentry->d_name.name,
@@ -825,7 +845,7 @@ static noinline int btrfs_ioctl_snap_des
 	BUG_ON(ret);
 
 	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	BTRFS_UERROR(ret);
 	inode->i_flags |= S_DEAD;
 out_up_write:
 	up_write(&root->fs_info->subvol_sem);
@@ -862,15 +882,16 @@ static int btrfs_ioctl_defrag(struct fil
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
 			ret = -EINVAL;
 			goto out;
 		}
-		btrfs_defrag_file(file);
+		ret = btrfs_defrag_file(file);
 		break;
 	}
 out:
@@ -1026,7 +1047,12 @@ static noinline long btrfs_ioctl_clone(s
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		btrfs_release_path(root, path);
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		goto out_unlock;
+	}
 
 	/* punch hole in destination first */
 	btrfs_drop_extents(trans, root, inode, off, off + len,
@@ -1255,10 +1281,11 @@ static long btrfs_ioctl_trans_start(stru
 	root->fs_info->open_ioctl_trans++;
 	mutex_unlock(&root->fs_info->trans_mutex);
 
-	ret = -ENOMEM;
 	trans = btrfs_start_ioctl_transaction(root, 0);
-	if (!trans)
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto out_drop;
+	}
 
 	file->private_data = trans;
 	return 0;
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -398,7 +398,8 @@ struct btrfs_root *find_tree_root(struct
 	BUG_ON(root_objectid == BTRFS_TREE_RELOC_OBJECTID);
 
 	root = read_fs_root(rc->extent_root->fs_info, root_objectid);
-	BUG_ON(IS_ERR(root));
+	if (IS_ERR(root))
+		return ERR_CAST(root);
 
 	if (root->ref_cows &&
 	    generation != btrfs_root_generation(&root->root_item))
@@ -592,6 +593,7 @@ again:
 				ref0 = btrfs_item_ptr(eb, path1->slots[0],
 						struct btrfs_extent_ref_v0);
 				root = find_tree_root(rc, eb, ref0);
+				BTRFS_UERROR(IS_ERR(root));
 				if (root)
 					cur->root = root;
 				else
@@ -1638,12 +1640,20 @@ static noinline_for_stack int merge_relo
 
 	if (level == 0 && rc->stage == UPDATE_DATA_PTRS) {
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans)) {
+			extent_buffer_put(reloc_root->node);
+		}
+		BTRFS_UERROR(IS_ERR(trans));
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, 0);
 		btrfs_release_path(reloc_root, path);
 
+		if (IS_ERR(trans)) {
+			err = PTR_ERR(trans);
+			goto out;
+		}
+
 		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 		if (ret < 0) {
 			err = ret;
@@ -1665,7 +1675,7 @@ static noinline_for_stack int merge_relo
 		leaf = NULL;
 		replaced = 0;
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 		max_level = level;
 
 		ret = walk_down_reloc_tree(reloc_root, path, &level);
@@ -1788,6 +1798,7 @@ static void merge_func(struct btrfs_work
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
 	struct async_merge *async;
+	int ret = 0;
 
 	async = container_of(work, struct async_merge, work);
 	reloc_root = async->root;
@@ -1795,18 +1806,20 @@ static void merge_func(struct btrfs_work
 	if (btrfs_root_refs(&reloc_root->root_item) > 0) {
 		root = read_fs_root(reloc_root->fs_info,
 				    reloc_root->root_key.offset);
-		BUG_ON(IS_ERR(root));
+		BTRFS_UERROR(IS_ERR(root));
 		BUG_ON(root->reloc_root != reloc_root);
 
-		merge_reloc_root(async->rc, root);
+		ret = merge_reloc_root(async->rc, root);
+		BTRFS_UERROR(ret);
 
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 		btrfs_update_reloc_root(trans, root);
 		btrfs_end_transaction(trans, root);
 	}
 
-	btrfs_drop_snapshot(reloc_root, 0);
+	ret = btrfs_drop_snapshot(reloc_root, 0);
+	BTRFS_UERROR(ret);
 
 	if (atomic_dec_and_test(async->num_pending))
 		complete(async->done);
@@ -1868,7 +1881,8 @@ static int record_reloc_root_in_trans(st
 		return 0;
 
 	root = read_fs_root(reloc_root->fs_info, reloc_root->root_key.offset);
-	BUG_ON(IS_ERR(root));
+	if (IS_ERR(root))
+		return PTR_ERR(root);
 	BUG_ON(root->reloc_root != reloc_root);
 
 	return btrfs_record_root_in_trans(trans, root);
@@ -1888,6 +1902,7 @@ static struct btrfs_root *__select_one_r
 	struct btrfs_root *root;
 	int index;
 	int loop = 0;
+	int ret;
 again:
 	index = 0;
 	next = node;
@@ -1907,7 +1922,11 @@ again:
 		}
 
 		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-			record_reloc_root_in_trans(trans, root);
+			ret = record_reloc_root_in_trans(trans, root);
+			if (ret) {
+				root = ERR_PTR(ret);
+				goto out;
+			}
 			break;
 		}
 
@@ -1946,6 +1965,7 @@ skip:
 	else
 		*nr = 0;
 
+out:
 	return root;
 }
 
@@ -2026,6 +2046,7 @@ static int do_relocation(struct btrfs_tr
 		root = select_reloc_root(trans, upper, edges, &nr);
 		if (!root)
 			continue;
+		BTRFS_UERROR(IS_ERR(root));
 
 		if (upper->eb && !upper->locked)
 			drop_node_buffer(upper);
@@ -2372,6 +2393,11 @@ static int relocate_tree_block(struct bt
 	int ret;
 
 	root = select_one_root(trans, node);
+	if (unlikely(IS_ERR(root))) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
+
 	if (unlikely(!root)) {
 		rc->found_old_snapshot = 1;
 		update_processed_blocks(rc, node);
@@ -3109,6 +3135,7 @@ int add_data_references(struct reloc_con
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
+			BTRFS_UERROR(ret);
 		} else {
 			BUG();
 		}
@@ -3294,12 +3321,18 @@ static noinline_for_stack int relocate_b
 	set_reloc_control(rc);
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
-	BTRFS_UERROR(!trans);
+	BTRFS_UERROR(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		rc->create_reloc_root = 0;
+		smp_mb();
+		unset_reloc_control(rc);
+		return PTR_ERR(trans);
+	}
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	while (1) {
 		trans = btrfs_start_transaction(rc->extent_root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 
 		ret = find_next_extent(trans, rc, path);
 		if (ret < 0)
@@ -3356,6 +3389,7 @@ static noinline_for_stack int relocate_b
 		} else if (rc->stage == UPDATE_DATA_PTRS &&
 			 (flags & BTRFS_EXTENT_FLAG_DATA)) {
 			ret = add_data_references(rc, &key, path, &blocks);
+			BTRFS_UERROR(ret);
 		} else {
 			btrfs_release_path(rc->extent_root, path);
 			ret = 0;
@@ -3410,7 +3444,7 @@ static noinline_for_stack int relocate_b
 
 	if (rc->extents_found > 0) {
 		trans = btrfs_start_transaction(rc->extent_root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 		btrfs_commit_transaction(trans, rc->extent_root);
 	}
 
@@ -3420,7 +3454,7 @@ static noinline_for_stack int relocate_b
 
 	/* get rid of pinned extents */
 	trans = btrfs_start_transaction(rc->extent_root, 1);
-	BTRFS_UERROR(!trans);
+	BTRFS_UERROR(IS_ERR(trans));
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	return err;
@@ -3476,7 +3510,8 @@ static struct inode *create_reloc_inode(
 		return ERR_CAST(root);
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return ERR_CAST(trans);
 
 	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
 	if (err)
@@ -3531,9 +3566,14 @@ int btrfs_relocate_block_group(struct bt
 			   fs_info->thread_pool_size, NULL);
 
 	rc->extent_root = extent_root;
-	btrfs_prepare_block_group_relocation(extent_root, rc->block_group);
+	ret = btrfs_prepare_block_group_relocation(extent_root,
+						   rc->block_group);
+	if (ret)
+		goto out;
 
 	rc->data_inode = create_reloc_inode(fs_info, rc->block_group);
+	/* We can't clean up from btrfs_prepare_block_group_relocation */
+	BTRFS_UERROR(IS_ERR(rc->data_inode));
 	if (IS_ERR(rc->data_inode)) {
 		err = PTR_ERR(rc->data_inode);
 		rc->data_inode = NULL;
@@ -3553,7 +3593,8 @@ int btrfs_relocate_block_group(struct bt
 
 		mutex_lock(&fs_info->cleaner_mutex);
 
-		btrfs_clean_old_snapshots(fs_info->tree_root);
+		ret = btrfs_clean_old_snapshots(fs_info->tree_root);
+		BTRFS_UERROR(ret);
 		ret = relocate_block_group(rc);
 
 		mutex_unlock(&fs_info->cleaner_mutex);
@@ -3610,7 +3651,8 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
@@ -3689,7 +3731,11 @@ int btrfs_recover_relocation(struct btrf
 					err = ret;
 					goto out;
 				}
-				mark_garbage_root(reloc_root);
+				ret = mark_garbage_root(reloc_root);
+				if (ret) {
+					err = ret;
+					goto out;
+				}
 			}
 		}
 
@@ -3738,16 +3784,22 @@ int btrfs_recover_relocation(struct btrf
 	}
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
-	BTRFS_UERROR(!trans);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		unset_reloc_control(rc);
+		goto out;
+	}
+	err = btrfs_commit_transaction(trans, rc->extent_root);
 
 	merge_reloc_roots(rc);
 
 	unset_reloc_control(rc);
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
-	BTRFS_UERROR(!trans);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	err = btrfs_commit_transaction(trans, rc->extent_root);
 out:
 	if (rc) {
 		btrfs_stop_workers(&rc->workers);
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -417,8 +417,11 @@ int btrfs_sync_fs(struct super_block *sb
 	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
-	ret = btrfs_commit_transaction(trans, root);
+	if (!IS_ERR(trans))
+		ret = btrfs_commit_transaction(trans, root);
+	else
+		ret = PTR_ERR(trans);
+
 	return ret;
 }
 
@@ -601,7 +604,8 @@ static int btrfs_remount(struct super_bl
 
 		/* recover relocation */
 		ret = btrfs_recover_relocation(root);
-		WARN_ON(ret);
+		if (ret)
+			return ret;
 
 		ret = btrfs_cleanup_fs_roots(root->fs_info);
 		WARN_ON(ret);
@@ -609,7 +613,7 @@ static int btrfs_remount(struct super_bl
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -181,7 +181,10 @@ static struct btrfs_trans_handle *start_
 	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
 		wait_current_trans(root);
 	ret = join_transaction(root);
-	BUG_ON(ret);
+	if (ret) {
+		h = ERR_PTR(ret);
+		goto out;
+	}
 
 	h->transid = root->fs_info->running_transaction->transid;
 	h->transaction = root->fs_info->running_transaction;
@@ -197,6 +200,7 @@ static struct btrfs_trans_handle *start_
 
 	root->fs_info->running_transaction->use_count++;
 	record_root_in_trans(h, root);
+out:
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
@@ -629,8 +633,11 @@ int btrfs_defrag_root(struct btrfs_root
 	smp_mb();
 	if (root->defrag_running)
 		return 0;
+
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	while (1) {
 		root->defrag_running = 1;
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
@@ -640,14 +647,16 @@ int btrfs_defrag_root(struct btrfs_root
 		cond_resched();
 
 		trans = btrfs_start_transaction(root, 1);
-		BTRFS_UERROR(!trans);
+		if (IS_ERR(trans))
+			ret = PTR_ERR(trans);
 		if (root->fs_info->closing || ret != -EAGAIN)
 			break;
 	}
 	root->defrag_running = 0;
 	smp_mb();
-	btrfs_end_transaction(trans, root);
-	return 0;
+	if (!IS_ERR(trans))
+		btrfs_end_transaction(trans, root);
+	return ret;
 }
 
 #if 0
@@ -814,7 +823,8 @@ static noinline int finish_pending_snaps
 	parent_inode = pending->dentry->d_parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
 	trans = btrfs_join_transaction(parent_root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	/*
 	 * insert the directory item
@@ -842,6 +852,7 @@ static noinline int finish_pending_snaps
 	BUG_ON(ret);
 
 	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
+	BTRFS_UERROR(IS_ERR(inode));
 	d_instantiate(pending->dentry, inode);
 fail:
 	btrfs_end_transaction(trans, fs_info->fs_root);
@@ -876,7 +887,7 @@ static noinline int finish_pending_snaps
 		pending = list_entry(head->next,
 				     struct btrfs_pending_snapshot, list);
 		ret = finish_pending_snapshot(fs_info, pending);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 		list_del(&pending->list);
 		kfree(pending->name);
 		kfree(pending);
@@ -1099,7 +1110,8 @@ int btrfs_commit_transaction(struct btrf
 	btrfs_finish_extent_commit(trans, root);
 
 	/* do the directory inserts of any pending snapshot creations */
-	finish_pending_snapshots(trans, root->fs_info);
+	ret = finish_pending_snapshots(trans, root->fs_info);
+	BTRFS_UERROR(ret);
 
 	mutex_lock(&root->fs_info->trans_mutex);
 
@@ -1128,6 +1140,7 @@ int btrfs_clean_old_snapshots(struct btr
 {
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret = 0;
 
 	mutex_lock(&fs_info->trans_mutex);
 	list_splice_init(&fs_info->dead_roots, &list);
@@ -1139,9 +1152,10 @@ int btrfs_clean_old_snapshots(struct btr
 
 		if (btrfs_header_backref_rev(root->node) <
 		    BTRFS_MIXED_BACKREF_REV)
-			btrfs_drop_snapshot(root, 0);
+			ret = btrfs_drop_snapshot(root, 0);
 		else
-			btrfs_drop_snapshot(root, 1);
+			ret = btrfs_drop_snapshot(root, 1);
+		BTRFS_UERROR(ret);
 	}
 	return 0;
 }
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3024,7 +3024,10 @@ int btrfs_recover_log_trees(struct btrfs
 	BUG_ON(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto fail;
+	}
 
 	wc.trans = trans;
 	wc.pin = 1;
@@ -3053,8 +3056,7 @@ again:
 
 		log = btrfs_read_fs_root_no_radix(log_root_tree,
 						  &found_key);
-		BUG_ON(IS_ERR(log));
-
+		BTRFS_UERROR(IS_ERR(log));
 
 		tmp_key.objectid = found_key.offset;
 		tmp_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -3098,6 +3100,7 @@ again:
 		goto again;
 	}
 
+fail:
 	btrfs_free_path(path);
 
 	free_extent_buffer(log_root_tree->node);
@@ -3105,10 +3108,11 @@ again:
 	fs_info->log_root_recovering = 0;
 
 	/* step 4: commit the transaction, which also unpins the blocks */
-	btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (!ret)
+		ret = btrfs_commit_transaction(trans, fs_info->tree_root);
 
 	kfree(log_root_tree);
-	return 0;
+	return ret;
 }
 
 /*
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1078,7 +1078,7 @@ out:
 static int btrfs_rm_dev_item(struct btrfs_root *root,
 			     struct btrfs_device *device)
 {
-	int ret;
+	int ret, err;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_trans_handle *trans;
@@ -1090,7 +1090,10 @@ static int btrfs_rm_dev_item(struct btrf
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1111,7 +1114,8 @@ static int btrfs_rm_dev_item(struct btrf
 out:
 	btrfs_free_path(path);
 	unlock_chunks(root);
-	btrfs_commit_transaction(trans, root);
+	err = btrfs_commit_transaction(trans, root);
+	ret = ret ?: err;
 	return ret;
 }
 
@@ -1429,7 +1433,7 @@ int btrfs_init_new_device(struct btrfs_r
 	struct super_block *sb = root->fs_info->sb;
 	u64 total_bytes;
 	int seeding_dev = 0;
-	int ret = 0;
+	int err, ret = 0;
 
 	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
 		return -EINVAL;
@@ -1481,7 +1485,12 @@ int btrfs_init_new_device(struct btrfs_r
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans)) {
+		kfree(device->name);
+		kfree(device);
+		ret = PTR_ERR(trans);
+		goto error;
+	}
 	lock_chunks(root);
 
 	device->barriers = 1;
@@ -1550,14 +1559,15 @@ int btrfs_init_new_device(struct btrfs_r
 	btrfs_clear_space_info_full(root->fs_info);
 
 	unlock_chunks(root);
-	btrfs_commit_transaction(trans, root);
+	err = btrfs_commit_transaction(trans, root);
+	ret = ret ?: err;
 
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);
 
 		ret = btrfs_relocate_sys_chunks(root);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 	}
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
@@ -1746,10 +1756,11 @@ static int btrfs_relocate_chunk(struct b
 
 	/* step one, relocate all the extents inside this chunk */
 	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	trans = btrfs_start_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	BTRFS_UERROR(IS_ERR(trans));
 
 	lock_chunks(root);
 
@@ -1855,8 +1866,8 @@ again:
 						   found_key.offset);
 			if (ret == -ENOSPC)
 				failed++;
-			else if (ret)
-				BUG();
+			else
+				BTRFS_UERROR(ret);
 		}
 
 		if (found_key.offset == 0)
@@ -1918,10 +1929,11 @@ int btrfs_balance(struct btrfs_root *dev
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
 		if (ret == -ENOSPC)
 			break;
-		BUG_ON(ret);
+		else if (ret)
+			return ret;
 
 		trans = btrfs_start_transaction(dev_root, 1);
-		BTRFS_UERROR(!trans);
+		BTRFS_UERROR(IS_ERR(trans));
 
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
@@ -1971,7 +1983,7 @@ int btrfs_balance(struct btrfs_root *dev
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
 					   found_key.offset);
-		BUG_ON(ret && ret != -ENOSPC);
+		BTRFS_UERROR(ret && ret != -ENOSPC);
 		key.offset = found_key.offset - 1;
 	}
 	ret = 0;
@@ -2090,8 +2102,8 @@ again:
 
 	/* Shrinking succeeded, else we would be at "done". */
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
 		goto done;
 	}
 	lock_chunks(root);
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -99,7 +99,8 @@ int __btrfs_setxattr(struct inode *inode
 		return -ENOMEM;
 
 	trans = btrfs_join_transaction(root, 1);
-	BTRFS_UERROR(!trans);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	/* first lets see if we already have this xattr */

