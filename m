From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH V2 10/12] Btrfs: Metadata ENOSPC handling for tree log
Date: Mon, 26 Apr 2010 18:47:13 +0800
Message-ID: <4BD56F31.8040508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Previous patches make the allocater return -ENOSPC if there is no
unreserved free metadata space. This patch updates tree log code
and various other places to propagate/handle the ENOSPC error.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 2/fs/btrfs/disk-io.c	2010-04-26 17:28:05.496079922 +0800
+++ 3/fs/btrfs/disk-io.c	2010-04-26 17:28:05.506079726 +0800
@@ -973,42 +973,6 @@ static int find_and_setup_root(struct bt
 	return 0;
 }
 
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info)
-{
-	struct extent_buffer *eb;
-	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
-	u64 start = 0;
-	u64 end = 0;
-	int ret;
-
-	if (!log_root_tree)
-		return 0;
-
-	while (1) {
-		ret = find_first_extent_bit(&log_root_tree->dirty_log_pages,
-				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW);
-		if (ret)
-			break;
-
-		clear_extent_bits(&log_root_tree->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
-	}
-	eb = fs_info->log_root_tree->node;
-
-	WARN_ON(btrfs_header_level(eb) != 0);
-	WARN_ON(btrfs_header_nritems(eb) != 0);
-
-	ret = btrfs_free_reserved_extent(fs_info->tree_root,
-				eb->start, eb->len);
-	BUG_ON(ret);
-
-	free_extent_buffer(eb);
-	kfree(fs_info->log_root_tree);
-	fs_info->log_root_tree = NULL;
-	return 0;
-}
-
 static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info)
 {
diff -urp 2/fs/btrfs/disk-io.h 3/fs/btrfs/disk-io.h
--- 2/fs/btrfs/disk-io.h	2010-04-26 17:28:05.495079921 +0800
+++ 3/fs/btrfs/disk-io.h	2010-04-26 17:28:05.507080566 +0800
@@ -95,8 +95,6 @@ int btrfs_congested_async(struct btrfs_f
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
 int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
diff -urp 2/fs/btrfs/file-item.c 3/fs/btrfs/file-item.c
--- 2/fs/btrfs/file-item.c	2010-04-26 17:28:05.503100326 +0800
+++ 3/fs/btrfs/file-item.c	2010-04-26 17:28:05.507080566 +0800
@@ -656,6 +656,9 @@ again:
 		goto found;
 	}
 	ret = PTR_ERR(item);
+	if (ret != -EFBIG && ret != -ENOENT)
+		goto fail_unlock;
+
 	if (ret == -EFBIG) {
 		u32 item_size;
 		/* we found one, but it isn't big enough yet */
diff -urp 2/fs/btrfs/tree-log.c 3/fs/btrfs/tree-log.c
--- 2/fs/btrfs/tree-log.c	2010-04-26 17:28:05.498105836 +0800
+++ 3/fs/btrfs/tree-log.c	2010-04-26 17:28:05.509079730 +0800
@@ -134,6 +134,7 @@ static int start_log_trans(struct btrfs_
 			   struct btrfs_root *root)
 {
 	int ret;
+	int err = 0;
 
 	mutex_lock(&root->log_mutex);
 	if (root->log_root) {
@@ -154,17 +155,19 @@ static int start_log_trans(struct btrfs_
 	mutex_lock(&root->fs_info->tree_log_mutex);
 	if (!root->fs_info->log_root_tree) {
 		ret = btrfs_init_log_root_tree(trans, root->fs_info);
-		BUG_ON(ret);
+		if (ret)
+			err = ret;
 	}
-	if (!root->log_root) {
+	if (err == 0 && !root->log_root) {
 		ret = btrfs_add_log_tree(trans, root);
-		BUG_ON(ret);
+		if (ret)
+			err = ret;
 	}
 	mutex_unlock(&root->fs_info->tree_log_mutex);
 	root->log_batch++;
 	atomic_inc(&root->log_writers);
 	mutex_unlock(&root->log_mutex);
-	return 0;
+	return err;
 }
 
 /*
@@ -375,7 +378,7 @@ insert:
 			BUG_ON(ret);
 		}
 	} else if (ret) {
-		BUG();
+		return ret;
 	}
 	dst_ptr = btrfs_item_ptr_offset(path->nodes[0],
 					path->slots[0]);
@@ -1698,9 +1701,9 @@ static noinline int walk_down_log_tree(s
 
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 
-		wc->process_func(root, next, wc, ptr_gen);
-
 		if (*level == 1) {
+			wc->process_func(root, next, wc, ptr_gen);
+
 			path->slots[*level]++;
 			if (wc->free) {
 				btrfs_read_buffer(next, ptr_gen);
@@ -1733,35 +1736,7 @@ static noinline int walk_down_log_tree(s
 	WARN_ON(*level < 0);
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
 
-	if (path->nodes[*level] == root->node)
-		parent = path->nodes[*level];
-	else
-		parent = path->nodes[*level + 1];
-
-	bytenr = path->nodes[*level]->start;
-
-	blocksize = btrfs_level_size(root, *level);
-	root_owner = btrfs_header_owner(parent);
-	root_gen = btrfs_header_generation(parent);
-
-	wc->process_func(root, path->nodes[*level], wc,
-			 btrfs_header_generation(path->nodes[*level]));
-
-	if (wc->free) {
-		next = path->nodes[*level];
-		btrfs_tree_lock(next);
-		clean_tree_block(trans, root, next);
-		btrfs_set_lock_blocking(next);
-		btrfs_wait_tree_block_writeback(next);
-		btrfs_tree_unlock(next);
-
-		WARN_ON(root_owner != BTRFS_TREE_LOG_OBJECTID);
-		ret = btrfs_free_reserved_extent(root, bytenr, blocksize);
-		BUG_ON(ret);
-	}
-	free_extent_buffer(path->nodes[*level]);
-	path->nodes[*level] = NULL;
-	*level += 1;
+	path->slots[*level] = btrfs_header_nritems(path->nodes[*level]);
 
 	cond_resched();
 	return 0;
@@ -1780,7 +1755,7 @@ static noinline int walk_up_log_tree(str
 
 	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
 		slot = path->slots[i];
-		if (slot < btrfs_header_nritems(path->nodes[i]) - 1) {
+		if (slot + 1 < btrfs_header_nritems(path->nodes[i])) {
 			struct extent_buffer *node;
 			node = path->nodes[i];
 			path->slots[i]++;
@@ -2046,7 +2021,6 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	ret = update_log_root(trans, log);
-	BUG_ON(ret);
 
 	mutex_lock(&log_root_tree->log_mutex);
 	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
@@ -2055,6 +2029,15 @@ int btrfs_sync_log(struct btrfs_trans_ha
 			wake_up(&log_root_tree->log_writer_wait);
 	}
 
+	if (ret) {
+		BUG_ON(ret != -ENOSPC);
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
+		mutex_unlock(&log_root_tree->log_mutex);
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	index2 = log_root_tree->log_transid % 2;
 	if (atomic_read(&log_root_tree->log_commit[index2])) {
 		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
@@ -2128,15 +2111,10 @@ out:
 	return 0;
 }
 
-/*
- * free all the extents used by the tree log.  This should be called
- * at commit time of the full transaction
- */
-int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
+static void free_log_tree(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *log)
 {
 	int ret;
-	struct btrfs_root *log;
-	struct key;
 	u64 start;
 	u64 end;
 	struct walk_control wc = {
@@ -2144,10 +2122,6 @@ int btrfs_free_log(struct btrfs_trans_ha
 		.process_func = process_one_buffer
 	};
 
-	if (!root->log_root || root->fs_info->log_root_recovering)
-		return 0;
-
-	log = root->log_root;
 	ret = walk_log_tree(trans, log, &wc);
 	BUG_ON(ret);
 
@@ -2161,14 +2135,30 @@ int btrfs_free_log(struct btrfs_trans_ha
 				  EXTENT_DIRTY | EXTENT_NEW, GFP_NOFS);
 	}
 
-	if (log->log_transid > 0) {
-		ret = btrfs_del_root(trans, root->fs_info->log_root_tree,
-				     &log->root_key);
-		BUG_ON(ret);
-	}
-	root->log_root = NULL;
 	free_extent_buffer(log->node);
 	kfree(log);
+}
+
+/*
+ * free all the extents used by the tree log.  This should be called
+ * at commit time of the full transaction
+ */
+int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
+{
+	if (root->log_root) {
+		free_log_tree(trans, root->log_root);
+		root->log_root = NULL;
+	}
+	return 0;
+}
+
+int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->log_root_tree) {
+		free_log_tree(trans, fs_info->log_root_tree);
+		fs_info->log_root_tree = NULL;
+	}
 	return 0;
 }
 
@@ -2202,6 +2192,7 @@ int btrfs_del_dir_entries_in_log(struct 
 	struct btrfs_dir_item *di;
 	struct btrfs_path *path;
 	int ret;
+	int err = 0;
 	int bytes_del = 0;
 
 	if (BTRFS_I(dir)->logged_trans < trans->transid)
@@ -2217,7 +2208,11 @@ int btrfs_del_dir_entries_in_log(struct 
 	path = btrfs_alloc_path();
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		err = PTR_ERR(di);
+		goto fail;
+	}
+	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
 		BUG_ON(ret);
@@ -2225,7 +2220,11 @@ int btrfs_del_dir_entries_in_log(struct 
 	btrfs_release_path(log, path);
 	di = btrfs_lookup_dir_index_item(trans, log, path, dir->i_ino,
 					 index, name, name_len, -1);
-	if (di && !IS_ERR(di)) {
+	if (IS_ERR(di)) {
+		err = PTR_ERR(di);
+		goto fail;
+	}
+	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
 		BUG_ON(ret);
@@ -2243,6 +2242,10 @@ int btrfs_del_dir_entries_in_log(struct 
 		btrfs_release_path(log, path);
 
 		ret = btrfs_search_slot(trans, log, &key, path, 0, 1);
+		if (ret < 0) {
+			err = ret;
+			goto fail;
+		}
 		if (ret == 0) {
 			struct btrfs_inode_item *item;
 			u64 i_size;
@@ -2260,9 +2263,13 @@ int btrfs_del_dir_entries_in_log(struct 
 			ret = 0;
 		btrfs_release_path(log, path);
 	}
-
+fail:
 	btrfs_free_path(path);
 	mutex_unlock(&BTRFS_I(dir)->log_mutex);
+	if (ret == -ENOSPC) {
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+		ret = 0;
+	}
 	btrfs_end_log_trans(root);
 
 	return 0;
@@ -2290,6 +2297,10 @@ int btrfs_del_inode_ref_in_log(struct bt
 	ret = btrfs_del_inode_ref(trans, log, name, name_len, inode->i_ino,
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
+	if (ret == -ENOSPC) {
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+		ret = 0;
+	}
 	btrfs_end_log_trans(root);
 
 	return ret;
@@ -2317,7 +2328,8 @@ static noinline int insert_dir_log_key(s
 	else
 		key.type = BTRFS_DIR_LOG_INDEX_KEY;
 	ret = btrfs_insert_empty_item(trans, log, path, &key, sizeof(*item));
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 			      struct btrfs_dir_log_item);
@@ -2342,6 +2354,7 @@ static noinline int log_dir_items(struct
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
 	struct extent_buffer *src;
+	int err = 0;
 	int ret;
 	int i;
 	int nritems;
@@ -2404,6 +2417,10 @@ static noinline int log_dir_items(struct
 			ret = overwrite_item(trans, log, dst_path,
 					     path->nodes[0], path->slots[0],
 					     &tmp);
+			if (ret) {
+				err = ret;
+				goto done;
+			}
 		}
 	}
 	btrfs_release_path(root, path);
@@ -2431,7 +2448,10 @@ static noinline int log_dir_items(struct
 				goto done;
 			ret = overwrite_item(trans, log, dst_path, src, i,
 					     &min_key);
-			BUG_ON(ret);
+			if (ret) {
+				err = ret;
+				goto done;
+			}
 		}
 		path->slots[0] = nritems;
 
@@ -2453,22 +2473,30 @@ static noinline int log_dir_items(struct
 			ret = overwrite_item(trans, log, dst_path,
 					     path->nodes[0], path->slots[0],
 					     &tmp);
-
-			BUG_ON(ret);
-			last_offset = tmp.offset;
+			if (ret)
+				err = ret;
+			else
+				last_offset = tmp.offset;
 			goto done;
 		}
 	}
 done:
-	*last_offset_ret = last_offset;
 	btrfs_release_path(root, path);
 	btrfs_release_path(log, dst_path);
 
-	/* insert the log range keys to indicate where the log is valid */
-	ret = insert_dir_log_key(trans, log, path, key_type, inode->i_ino,
-				 first_offset, last_offset);
-	BUG_ON(ret);
-	return 0;
+	if (err == 0) {
+		*last_offset_ret = last_offset;
+		/*
+		 * insert the log range keys to indicate where the log
+		 * is valid
+		 */
+		ret = insert_dir_log_key(trans, log, path, key_type,
+					 inode->i_ino, first_offset,
+					 last_offset);
+		if (ret)
+			err = ret;
+	}
+	return err;
 }
 
 /*
@@ -2500,7 +2528,8 @@ again:
 		ret = log_dir_items(trans, root, inode, path,
 				    dst_path, key_type, min_key,
 				    &max_key);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		if (max_key == (u64)-1)
 			break;
 		min_key = max_key + 1;
@@ -2534,8 +2563,8 @@ static int drop_objectid_items(struct bt
 
 	while (1) {
 		ret = btrfs_search_slot(trans, log, &key, path, -1, 1);
-
-		if (ret != 1)
+		BUG_ON(ret == 0);
+		if (ret < 0)
 			break;
 
 		if (path->slots[0] == 0)
@@ -2553,7 +2582,7 @@ static int drop_objectid_items(struct bt
 		btrfs_release_path(log, path);
 	}
 	btrfs_release_path(log, path);
-	return 0;
+	return ret;
 }
 
 static noinline int copy_items(struct btrfs_trans_handle *trans,
@@ -2586,7 +2615,10 @@ static noinline int copy_items(struct bt
 	}
 	ret = btrfs_insert_empty_items(trans, log, dst_path,
 				       ins_keys, ins_sizes, nr);
-	BUG_ON(ret);
+	if (ret) {
+		kfree(ins_data);
+		return ret;
+	}
 
 	for (i = 0; i < nr; i++, dst_path->slots[0]++) {
 		dst_offset = btrfs_item_ptr_offset(dst_path->nodes[0],
@@ -2659,16 +2691,17 @@ static noinline int copy_items(struct bt
 	 * we have to do this after the loop above to avoid changing the
 	 * log tree while trying to change the log tree.
 	 */
+	ret = 0;
 	while (!list_empty(&ordered_sums)) {
 		struct btrfs_ordered_sum *sums = list_entry(ordered_sums.next,
 						   struct btrfs_ordered_sum,
 						   list);
-		ret = btrfs_csum_file_blocks(trans, log, sums);
-		BUG_ON(ret);
+		if (!ret)
+			ret = btrfs_csum_file_blocks(trans, log, sums);
 		list_del(&sums->list);
 		kfree(sums);
 	}
-	return 0;
+	return ret;
 }
 
 /* log a single inode in the tree log.
@@ -2696,6 +2729,7 @@ static int btrfs_log_inode(struct btrfs_
 	struct btrfs_root *log = root->log_root;
 	struct extent_buffer *src = NULL;
 	u32 size;
+	int err = 0;
 	int ret;
 	int nritems;
 	int ins_start_slot = 0;
@@ -2738,7 +2772,10 @@ static int btrfs_log_inode(struct btrfs_
 	} else {
 		ret = btrfs_truncate_inode_items(trans, log, inode, 0, 0);
 	}
-	BUG_ON(ret);
+	if (ret) {
+		err = ret;
+		goto out_unlock;
+	}
 	path->keep_locks = 1;
 
 	while (1) {
@@ -2767,7 +2804,10 @@ again:
 
 		ret = copy_items(trans, log, dst_path, src, ins_start_slot,
 				 ins_nr, inode_only);
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto out_unlock;
+		}
 		ins_nr = 1;
 		ins_start_slot = path->slots[0];
 next_slot:
@@ -2783,7 +2823,10 @@ next_slot:
 			ret = copy_items(trans, log, dst_path, src,
 					 ins_start_slot,
 					 ins_nr, inode_only);
-			BUG_ON(ret);
+			if (ret) {
+				err = ret;
+				goto out_unlock;
+			}
 			ins_nr = 0;
 		}
 		btrfs_release_path(root, path);
@@ -2801,7 +2844,10 @@ next_slot:
 		ret = copy_items(trans, log, dst_path, src,
 				 ins_start_slot,
 				 ins_nr, inode_only);
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto out_unlock;
+		}
 		ins_nr = 0;
 	}
 	WARN_ON(ins_nr);
@@ -2809,14 +2855,18 @@ next_slot:
 		btrfs_release_path(root, path);
 		btrfs_release_path(log, dst_path);
 		ret = log_directory_changes(trans, root, inode, path, dst_path);
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto out_unlock;
+		}
 	}
 	BTRFS_I(inode)->logged_trans = trans->transid;
+out_unlock:
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 
 	btrfs_free_path(path);
 	btrfs_free_path(dst_path);
-	return 0;
+	return err;
 }
 
 /*
@@ -2941,10 +2991,13 @@ int btrfs_log_inode_parent(struct btrfs_
 		goto end_no_trans;
 	}
 
-	start_log_trans(trans, root);
+	ret = start_log_trans(trans, root);
+	if (ret)
+		goto end_trans;
 
 	ret = btrfs_log_inode(trans, root, inode, inode_only);
-	BUG_ON(ret);
+	if (ret)
+		goto end_trans;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -2954,8 +3007,10 @@ int btrfs_log_inode_parent(struct btrfs_
 	 */
 	if (S_ISREG(inode->i_mode) &&
 	    BTRFS_I(inode)->generation <= last_committed &&
-	    BTRFS_I(inode)->last_unlink_trans <= last_committed)
-			goto no_parent;
+	    BTRFS_I(inode)->last_unlink_trans <= last_committed) {
+		ret = 0;
+		goto end_trans;
+	}
 
 	inode_only = LOG_INODE_EXISTS;
 	while (1) {
@@ -2969,15 +3024,21 @@ int btrfs_log_inode_parent(struct btrfs_
 		if (BTRFS_I(inode)->generation >
 		    root->fs_info->last_trans_committed) {
 			ret = btrfs_log_inode(trans, root, inode, inode_only);
-			BUG_ON(ret);
+			if (ret)
+				goto end_trans;
 		}
 		if (IS_ROOT(parent))
 			break;
 
 		parent = parent->d_parent;
 	}
-no_parent:
 	ret = 0;
+end_trans:
+	if (ret < 0) {
+		BUG_ON(ret != -ENOSPC);
+		root->fs_info->last_trans_log_full_commit = trans->transid;
+		ret = 1;
+	}
 	btrfs_end_log_trans(root);
 end_no_trans:
 	return ret;
@@ -3019,7 +3080,7 @@ int btrfs_recover_log_trees(struct btrfs
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	trans = btrfs_start_transaction(fs_info->tree_root, 0);
 
 	wc.trans = trans;
 	wc.pin = 1;
diff -urp 2/fs/btrfs/tree-log.h 3/fs/btrfs/tree-log.h
--- 2/fs/btrfs/tree-log.h	2010-04-26 17:28:05.501110590 +0800
+++ 3/fs/btrfs/tree-log.h	2010-04-26 17:28:05.509079730 +0800
@@ -25,6 +25,8 @@
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root);
 int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
+int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info);
 int btrfs_recover_log_trees(struct btrfs_root *tree_root);
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct dentry *dentry);
