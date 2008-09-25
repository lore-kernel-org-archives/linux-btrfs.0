From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH 3/4] Various changes and fixes
Date: Thu, 25 Sep 2008 17:39:42 +0800
Message-ID: <48DB5C5E.6070700@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch contains various changes and fixes required for the
new space balancing code.

Regards
Yan Zheng

---
diff -r 96e213553923 ctree.c
--- a/ctree.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/ctree.c	Thu Sep 25 16:05:16 2008 +0800
@@ -290,7 +290,6 @@
 		    struct extent_buffer **cow_ret, u64 prealloc_dest)
 {
 	u64 search_start;
-	u64 header_trans;
 	int ret;
 
 	if (trans->transaction != root->fs_info->running_transaction) {
@@ -304,9 +303,9 @@
 		WARN_ON(1);
 	}
 
-	header_trans = btrfs_header_generation(buf);
 	spin_lock(&root->fs_info->hash_lock);
-	if (header_trans == trans->transid &&
+	if (btrfs_header_generation(buf) == trans->transid &&
+	    btrfs_header_owner(buf) == root->root_key.objectid &&
 	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
 		*cow_ret = buf;
 		spin_unlock(&root->fs_info->hash_lock);
@@ -1300,6 +1299,7 @@
 			/* is a cow on this block not required */
 			spin_lock(&root->fs_info->hash_lock);
 			if (btrfs_header_generation(b) == trans->transid &&
+			    btrfs_header_owner(b) == root->root_key.objectid &&
 			    !btrfs_header_flag(b, BTRFS_HEADER_FLAG_WRITTEN)) {
 				spin_unlock(&root->fs_info->hash_lock);
 				goto cow_done;
@@ -1396,7 +1396,8 @@
 
 			/* this is only true while dropping a snapshot */
 			if (level == lowest_level) {
-				break;
+				ret = 0;
+				goto done;
 			}
 
 			blocknr = btrfs_node_blockptr(b, slot);
diff -r 96e213553923 ctree.h
--- a/ctree.h	Thu Sep 25 16:02:40 2008 +0800
+++ b/ctree.h	Thu Sep 25 16:05:16 2008 +0800
@@ -1489,6 +1489,9 @@
 
 /* extent-tree.c */
 int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len);
+int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, u64 bytenr,
+			    u64 num_bytes, u32 *refs);
 int btrfs_update_pinned_extents(struct btrfs_root *root,
 				u64 bytenr, u64 num, int pin);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
@@ -1815,6 +1818,8 @@
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
+struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
+			    struct btrfs_root *root, int wait);
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
@@ -1827,13 +1832,17 @@
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
+int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
+void btrfs_orphan_cleanup(struct btrfs_root *root);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /* file.c */
 int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync);
-int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end);
+int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
+			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
 extern struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
diff -r 96e213553923 extent_io.c
--- a/extent_io.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/extent_io.c	Thu Sep 25 16:05:16 2008 +0800
@@ -292,7 +292,7 @@
 	struct extent_state *other;
 	struct rb_node *other_node;
 
-	if (state->state & EXTENT_IOBITS)
+	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		return 0;
 
 	other_node = rb_prev(&state->rb_node);
@@ -1070,7 +1070,8 @@
 
 	while(1) {
 		state = rb_entry(node, struct extent_state, rb_node);
-		if (found && state->start != cur_start) {
+		if (found && (state->start != cur_start ||
+			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1078,7 +1079,7 @@
 				*end = state->end;
 			goto out;
 		}
-		if (!found) {
+		if (!found && !(state->state & EXTENT_BOUNDARY)) {
 			struct extent_state *prev_state;
 			struct rb_node *prev_node = node;
 			while(1) {
@@ -1088,7 +1089,11 @@
 				prev_state = rb_entry(prev_node,
 						      struct extent_state,
 						      rb_node);
-				if (!(prev_state->state & EXTENT_DELALLOC))
+				if ((prev_state->end + 1 != state->start) ||
+				    !(prev_state->state & EXTENT_DELALLOC))
+					break;
+				if ((cur_start - prev_state->start) * 2 >
+				     max_bytes)
 					break;
 				state = prev_state;
 				node = prev_node;
diff -r 96e213553923 extent_io.h
--- a/extent_io.h	Thu Sep 25 16:02:40 2008 +0800
+++ b/extent_io.h	Thu Sep 25 16:05:16 2008 +0800
@@ -15,6 +15,7 @@
 #define EXTENT_BUFFER_FILLED (1 << 8)
 #define EXTENT_ORDERED (1 << 9)
 #define EXTENT_ORDERED_METADATA (1 << 10)
+#define EXTENT_BOUNDARY (1 << 11)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
 /*
diff -r 96e213553923 file.c
--- a/file.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/file.c	Thu Sep 25 16:05:16 2008 +0800
@@ -294,7 +294,7 @@
 						       last_pos_in_file,
 						       0, 0, hole_size, 0);
 			btrfs_drop_extent_cache(inode, last_pos_in_file,
-					last_pos_in_file + hole_size -1);
+					last_pos_in_file + hole_size - 1, 0);
 			mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 			btrfs_check_file(root, inode);
 		}
@@ -337,7 +337,7 @@
 		inline_size -= start_pos;
 		err = insert_inline_extent(trans, root, inode, start_pos,
 					   inline_size, pages, 0, num_pages);
-		btrfs_drop_extent_cache(inode, start_pos, aligned_end - 1);
+		btrfs_drop_extent_cache(inode, start_pos, aligned_end - 1, 0);
 		BUG_ON(err);
 		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
@@ -362,7 +362,8 @@
 	return err;
 }
 
-int noinline btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end)
+int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
+			    int skip_pinned)
 {
 	struct extent_map *em;
 	struct extent_map *split = NULL;
@@ -371,6 +372,7 @@
 	u64 len = end - start + 1;
 	int ret;
 	int testend = 1;
+	unsigned long flags;
 
 	WARN_ON(end < start);
 	if (end == (u64)-1) {
@@ -389,6 +391,23 @@
 			spin_unlock(&em_tree->lock);
 			break;
 		}
+		flags = em->flags;
+		if (skip_pinned && test_bit(EXTENT_FLAG_PINNED, &em->flags)) {
+			spin_unlock(&em_tree->lock);
+			if (em->start <= start &&
+			    (!testend || em->start + em->len >= start + len)) {
+				free_extent_map(em);
+				break;
+			}
+			if (start < em->start) {
+				len = em->start - start;
+			} else {
+				len = start + len - (em->start + em->len);
+				start = em->start + em->len;
+			}
+			free_extent_map(em);
+			continue;
+		}
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 		remove_extent_mapping(em_tree, em);
 
@@ -398,7 +417,7 @@
 			split->len = start - em->start;
 			split->block_start = em->block_start;
 			split->bdev = em->bdev;
-			split->flags = em->flags;
+			split->flags = flags;
 			ret = add_extent_mapping(em_tree, split);
 			BUG_ON(ret);
 			free_extent_map(split);
@@ -412,7 +431,7 @@
 			split->start = start + len;
 			split->len = em->start + em->len - (start + len);
 			split->bdev = em->bdev;
-			split->flags = em->flags;
+			split->flags = flags;
 
 			split->block_start = em->block_start + diff;
 
@@ -541,7 +560,7 @@
 	int recow;
 	int ret;
 
-	btrfs_drop_extent_cache(inode, start, end - 1);
+	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
 	path = btrfs_alloc_path();
 	if (!path)
diff -r 96e213553923 inode-map.c
--- a/inode-map.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/inode-map.c	Thu Sep 25 16:05:16 2008 +0800
@@ -117,10 +117,14 @@
 					*objectid = last_ino;
 					goto found;
 				}
+			} else if (key.objectid > search_start) {
+				*objectid = search_start;
+				goto found;
 			}
 		}
 		if (key.objectid >= BTRFS_LAST_FREE_OBJECTID)
 			break;
+
 		start_found = 1;
 		last_ino = key.objectid + 1;
 		path->slots[0]++;
diff -r 96e213553923 inode.c
--- a/inode.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/inode.c	Thu Sep 25 16:05:16 2008 +0800
@@ -135,7 +135,7 @@
 
 	BUG_ON(num_bytes > btrfs_super_total_bytes(&root->fs_info->super_copy));
 	mutex_lock(&BTRFS_I(inode)->extent_mutex);
-	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1);
+	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
 	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	while(num_bytes > 0) {
@@ -163,7 +163,7 @@
 				break;
 			}
 			btrfs_drop_extent_cache(inode, start,
-						start + ins.offset - 1);
+						start + ins.offset - 1, 0);
 		}
 		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
@@ -587,7 +587,7 @@
 
 	btrfs_drop_extent_cache(inode, ordered_extent->file_offset,
 				ordered_extent->file_offset +
-				ordered_extent->len - 1);
+				ordered_extent->len - 1, 0);
 	mutex_unlock(&BTRFS_I(inode)->extent_mutex);
 
 	ins.objectid = ordered_extent->start;
@@ -878,7 +878,7 @@
 	int ret = 0, nr_unlink = 0, nr_truncate = 0;
 
 	/* don't do orphan cleanup if the fs is readonly. */
-	if (root->inode->i_sb->s_flags & MS_RDONLY)
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return;
 
 	path = btrfs_alloc_path();
@@ -890,8 +890,6 @@
 	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
 	key.offset = (u64)-1;
 
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_trans_block_group(trans, root->inode);
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -931,7 +929,7 @@
 		 * crossing root thing.  we store the inode number in the
 		 * offset of the orphan item.
 		 */
-		inode = btrfs_iget_locked(root->inode->i_sb,
+		inode = btrfs_iget_locked(root->fs_info->sb,
 					  found_key.offset, root);
 		if (!inode)
 			break;
@@ -963,7 +961,9 @@
 		 * do a destroy_inode
 		 */
 		if (is_bad_inode(inode)) {
+			trans = btrfs_start_transaction(root, 1);
 			btrfs_orphan_del(trans, inode);
+			btrfs_end_transaction(trans, root);
 			iput(inode);
 			continue;
 		}
@@ -986,7 +986,6 @@
 		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
 
 	btrfs_free_path(path);
-	btrfs_end_transaction(trans, root);
 }
 
 void btrfs_read_locked_inode(struct inode *inode)
@@ -1341,8 +1340,7 @@
 	u64 mask = root->sectorsize - 1;
 
 	if (root->ref_cows)
-		btrfs_drop_extent_cache(inode,
-					new_size & (~mask), (u64)-1);
+		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
 	path->reada = -1;
 	BUG_ON(!path);
@@ -1675,7 +1673,7 @@
 						       hole_start, 0, 0,
 						       hole_size, 0);
 			btrfs_drop_extent_cache(inode, hole_start,
-						(u64)-1);
+						(u64)-1, 0);
 			btrfs_check_file(root, inode);
 		}
 		mutex_unlock(&BTRFS_I(inode)->extent_mutex);
@@ -1839,6 +1837,24 @@
 	struct btrfs_iget_args *args = opaque;
 	return (args->ino == inode->i_ino &&
 		args->root == BTRFS_I(inode)->root);
+}
+
+struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
+			    struct btrfs_root *root, int wait)
+{
+	struct inode *inode;
+	struct btrfs_iget_args args;
+	args.ino = objectid;
+	args.root = root;
+
+	if (wait) {
+		inode = ilookup5(s, objectid, btrfs_find_actor,
+				 (void *)&args);
+	} else {
+		inode = ilookup5_nowait(s, objectid, btrfs_find_actor,
+					(void *)&args);
+	}
+	return inode;
 }
 
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
@@ -3367,7 +3383,7 @@
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
-	btrfs_drop_extent_cache(inode, 0, (u64)-1);
+	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
@@ -3532,16 +3548,22 @@
 {
 	struct list_head *head = &root->fs_info->delalloc_inodes;
 	struct btrfs_inode *binode;
+	struct inode *inode;
 	unsigned long flags;
 
 	spin_lock_irqsave(&root->fs_info->delalloc_lock, flags);
 	while(!list_empty(head)) {
 		binode = list_entry(head->next, struct btrfs_inode,
 				    delalloc_inodes);
-		atomic_inc(&binode->vfs_inode.i_count);
+		inode = igrab(&binode->vfs_inode);
+		if (!inode)
+			list_del_init(&binode->delalloc_inodes);
 		spin_unlock_irqrestore(&root->fs_info->delalloc_lock, flags);
-		filemap_write_and_wait(binode->vfs_inode.i_mapping);
-		iput(&binode->vfs_inode);
+		if (inode) {
+			filemap_write_and_wait(inode->i_mapping);
+			iput(inode);
+		}
+		cond_resched();
 		spin_lock_irqsave(&root->fs_info->delalloc_lock, flags);
 	}
 	spin_unlock_irqrestore(&root->fs_info->delalloc_lock, flags);
diff -r 96e213553923 ioctl.c
--- a/ioctl.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/ioctl.c	Thu Sep 25 16:05:16 2008 +0800
@@ -444,12 +444,10 @@
 		goto out;
 	}
 
-	mutex_lock(&root->fs_info->drop_mutex);
 	if (root == root->fs_info->tree_root)
 		ret = create_subvol(root, vol_args->name, namelen);
 	else
 		ret = create_snapshot(root, vol_args->name, namelen);
-	mutex_unlock(&root->fs_info->drop_mutex);
 out:
 	kfree(vol_args);
 	return ret;
diff -r 96e213553923 ordered-data.c
--- a/ordered-data.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/ordered-data.c	Thu Sep 25 16:05:16 2008 +0800
@@ -309,7 +309,6 @@
 {
 	struct list_head splice;
 	struct list_head *cur;
-	struct list_head *tmp;
 	struct btrfs_ordered_extent *ordered;
 	struct inode *inode;
 
@@ -317,37 +316,38 @@
 
 	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_splice_init(&root->fs_info->ordered_extents, &splice);
-	list_for_each_safe(cur, tmp, &splice) {
+	while (!list_empty(&splice)) {
 		cur = splice.next;
 		ordered = list_entry(cur, struct btrfs_ordered_extent,
 				     root_extent_list);
 		if (nocow_only &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
+			list_move(&ordered->root_extent_list,
+				  &root->fs_info->ordered_extents);
 			cond_resched_lock(&root->fs_info->ordered_extent_lock);
 			continue;
 		}
 
 		list_del_init(&ordered->root_extent_list);
 		atomic_inc(&ordered->refs);
-		inode = ordered->inode;
 
 		/*
-		 * the inode can't go away until all the pages are gone
-		 * and the pages won't go away while there is still
-		 * an ordered extent and the ordered extent won't go
-		 * away until it is off this list.  So, we can safely
-		 * increment i_count here and call iput later
+		 * the inode may be getting freed (in sys_unlink path).
 		 */
-		atomic_inc(&inode->i_count);
+		inode = igrab(ordered->inode);
+
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 
-		btrfs_start_ordered_extent(inode, ordered, 1);
-		btrfs_put_ordered_extent(ordered);
-		iput(inode);
+		if (inode) {
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			iput(inode);
+		} else {
+			btrfs_put_ordered_extent(ordered);
+		}
 
 		spin_lock(&root->fs_info->ordered_extent_lock);
 	}
-	list_splice_init(&splice, &root->fs_info->ordered_extents);
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 	return 0;
 }
diff -r 96e213553923 transaction.c
--- a/transaction.c	Thu Sep 25 16:02:40 2008 +0800
+++ b/transaction.c	Thu Sep 25 16:05:16 2008 +0800
@@ -109,6 +109,7 @@
 			spin_lock_init(&dirty->root->node_lock);
 			spin_lock_init(&dirty->root->list_lock);
 			mutex_init(&dirty->root->objectid_mutex);
+			mutex_init(&dirty->root->log_mutex);
 			INIT_LIST_HEAD(&dirty->root->dead_list);
 			dirty->root->node = root->commit_root;
 			dirty->root->commit_root = NULL;
@@ -590,13 +591,14 @@
 		root = dirty->latest_root;
 		atomic_inc(&root->fs_info->throttles);
 
-		mutex_lock(&root->fs_info->drop_mutex);
 		while(1) {
 			trans = btrfs_start_transaction(tree_root, 1);
+			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, dirty->root);
 			if (ret != -EAGAIN) {
 				break;
 			}
+			mutex_unlock(&root->fs_info->drop_mutex);
 
 			err = btrfs_update_root(trans,
 					tree_root,
@@ -608,10 +610,8 @@
 			ret = btrfs_end_transaction(trans, tree_root);
 			BUG_ON(ret);
 
-			mutex_unlock(&root->fs_info->drop_mutex);
 			btrfs_btree_balance_dirty(tree_root, nr);
 			cond_resched();
-			mutex_lock(&root->fs_info->drop_mutex);
 		}
 		BUG_ON(ret);
 		atomic_dec(&root->fs_info->throttles);
@@ -689,7 +689,7 @@
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;
-	key.offset = 1;
+	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
 	old = btrfs_lock_root_node(root);
