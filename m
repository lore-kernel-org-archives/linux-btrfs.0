From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 1/6] btrfs: Avoid producing dead subvolume trees
Date: Mon, 11 May 2009 23:24:20 +0800
Message-ID: <4A084324.4040303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When a non-shared tree block is cow'd, the reference count of
all blocks it points to is increased by one. After the commit
finishes, the old block will get freed when dropping the dead
tree. At that time, the reference count of all blocks the old
block points to will be decreased by one. The increments and
decrements cancel out. Actually the COW operation can be done
in a smarter way. When a non-shared tree block is cow'd, we
free the old block at once, the new block inherits old block's
references. When a shared tree block is cow'd, we decrease its
reference count by one, and increase the reference count of all
blocks it points to by one for the new block.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-04-21 07:03:51.343320128 +0800
+++ 2/fs/btrfs/ctree.c	2009-05-11 15:40:07.000000000 +0800
@@ -244,6 +244,147 @@ int btrfs_copy_root(struct btrfs_trans_h
 }
 
 /*
+ * check if the tree block can be shared by multiple trees
+ */
+int btrfs_block_can_be_shared(struct btrfs_root *root,
+			      struct extent_buffer *buf)
+{
+	/*
+	 * Tree blocks not in refernece counted trees and tree roots
+	 * are never shared. If a block was allocated after the last
+	 * snapshot and the block was not allocated by tree relocation,
+	 * we know the block is not shared.
+	 */
+	if (root->ref_cows &&
+	    buf != root->node && buf != root->commit_root &&
+	    (btrfs_header_generation(buf) <=
+	     btrfs_root_last_snapshot(&root->root_item) ||
+	     btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
+		return 1;
+	return 0;
+}
+
+static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct extent_buffer *buf,
+				       struct extent_buffer *cow)
+{
+	u64 refs;
+	u64 owner;
+	u64 flags;
+	u64 new_flags = 0;
+	int ret;
+
+	/*
+	 * Backrefs update rules:
+	 *
+	 * Always use full backrefs for extent pointers in tree block
+	 * allocated by tree relocation.
+	 *
+	 * If a shared tree block is no longer referenced by its owner
+	 * tree (btrfs_header_owner(buf) == root->root_key.objectid),
+	 * set the BTRFS_BLOCK_NO_OWNER_REF extent flag and use full
+	 * backrefs for extent pointers in tree block.
+	 *
+	 * If a tree block is been relocating
+	 * (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID),
+	 * use full backrefs for extent pointers in tree block.
+	 * The reason for this is some operations (such as drop tree)
+	 * used by the relocation code are only allowed for the full
+	 * backrefs format.
+	 */
+
+	owner = btrfs_header_owner(buf);
+	BUG_ON(owner == BTRFS_TREE_RELOC_OBJECTID);
+
+	if (!btrfs_block_can_be_shared(root, buf)) {
+		if (root->root_key.objectid ==
+		    BTRFS_TREE_RELOC_OBJECTID) {
+			ret = btrfs_inc_ref(trans, root, cow, 1);
+			BUG_ON(ret);
+			ret = btrfs_dec_ref(trans, root, buf, 1);
+			BUG_ON(ret);
+		}
+		clean_tree_block(trans, root, buf);
+		return 0;
+	}
+
+	ret = btrfs_lookup_extent_info(trans, root, buf->start,
+				       buf->len, &refs, &flags);
+	BUG_ON(ret);
+	BUG_ON(refs == 0);
+
+	/* relocation doesn't change blocks' BTRFS_BLOCK_NO_OWNER_REF flag */
+	if ((flags & BTRFS_BLOCK_NO_OWNER_REF) &&
+	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		ret = btrfs_set_block_flags(trans, root, cow->start, cow->len,
+					    BTRFS_BLOCK_NO_OWNER_REF);
+		BUG_ON(ret);
+	}
+
+	if (refs > 1) {
+		if ((owner == root->root_key.objectid ||
+		     root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) &&
+		    !(flags & BTRFS_BLOCK_FULL_BACKREF)) {
+			ret = btrfs_inc_ref(trans, root, buf, 1);
+			BUG_ON(ret);
+
+			if (root->root_key.objectid ==
+			    BTRFS_TREE_RELOC_OBJECTID) {
+				ret = btrfs_dec_ref(trans, root, buf, 0);
+				BUG_ON(ret);
+				ret = btrfs_inc_ref(trans, root, cow, 1);
+				BUG_ON(ret);
+			} else {
+				/* owner == root->root_key.objectid */
+				BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+				new_flags |= BTRFS_BLOCK_NO_OWNER_REF;
+			}
+			new_flags |= BTRFS_BLOCK_FULL_BACKREF;
+		} else {
+
+			if (root->root_key.objectid ==
+			    BTRFS_TREE_RELOC_OBJECTID)
+				ret = btrfs_inc_ref(trans, root, cow, 1);
+			else
+				ret = btrfs_inc_ref(trans, root, cow, 0);
+			BUG_ON(ret);
+
+			if (owner == root->root_key.objectid) {
+				BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+				new_flags |= BTRFS_BLOCK_NO_OWNER_REF;
+			}
+		}
+		if (new_flags != 0) {
+			ret = btrfs_set_block_flags(trans, root, buf->start,
+						    buf->len, new_flags);
+			BUG_ON(ret);
+		}
+	} else {
+		if (flags & BTRFS_BLOCK_FULL_BACKREF) {
+			if (root->root_key.objectid ==
+			    BTRFS_TREE_RELOC_OBJECTID)
+				ret = btrfs_inc_ref(trans, root, cow, 1);
+			else
+				ret = btrfs_inc_ref(trans, root, cow, 0);
+			BUG_ON(ret);
+			ret = btrfs_dec_ref(trans, root, buf, 1);
+			BUG_ON(ret);
+		} else {
+			/*
+			 * this is the last reference and we don't use
+			 * full backrefs, so this reference must come
+			 * from block's owner tree.
+			 */
+			BUG_ON(owner != root->root_key.objectid);
+			BUG_ON(flags & BTRFS_BLOCK_NO_OWNER_REF);
+		}
+		clean_tree_block(trans, root, buf);
+	}
+	return 0;
+}
+
+/*
  * does the dirty work in cow of a single block.  The parent block (if
  * supplied) is updated to point to the new cow copy.  The new buffer is marked
  * dirty and returned locked.  If you modify the block it needs to be marked
@@ -298,83 +439,51 @@ static noinline int __btrfs_cow_block(st
 	copy_extent_buffer(cow, buf, 0, 0, cow->len);
 	btrfs_set_header_bytenr(cow, cow->start);
 	btrfs_set_header_generation(cow, trans->transid);
-	btrfs_set_header_owner(cow, root->root_key.objectid);
-	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
+	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN |
+				     BTRFS_HEADER_FLAG_RELOC);
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		btrfs_set_header_flag(cow, BTRFS_HEADER_FLAG_RELOC);
+	else
+		btrfs_set_header_owner(cow, root->root_key.objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
 			    (unsigned long)btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
-	WARN_ON(btrfs_header_generation(buf) > trans->transid);
-	if (btrfs_header_generation(buf) != trans->transid) {
-		u32 nr_extents;
-		ret = btrfs_inc_ref(trans, root, buf, cow, &nr_extents);
-		if (ret)
-			return ret;
-
-		ret = btrfs_cache_ref(trans, root, buf, nr_extents);
-		WARN_ON(ret);
-	} else if (btrfs_header_owner(buf) == BTRFS_TREE_RELOC_OBJECTID) {
-		/*
-		 * There are only two places that can drop reference to
-		 * tree blocks owned by living reloc trees, one is here,
-		 * the other place is btrfs_drop_subtree. In both places,
-		 * we check reference count while tree block is locked.
-		 * Furthermore, if reference count is one, it won't get
-		 * increased by someone else.
-		 */
-		u32 refs;
-		ret = btrfs_lookup_extent_ref(trans, root, buf->start,
-					      buf->len, &refs);
-		BUG_ON(ret);
-		if (refs == 1) {
-			ret = btrfs_update_ref(trans, root, buf, cow,
-					       0, nritems);
-			clean_tree_block(trans, root, buf);
-		} else {
-			ret = btrfs_inc_ref(trans, root, buf, cow, NULL);
-		}
-		BUG_ON(ret);
-	} else {
-		ret = btrfs_update_ref(trans, root, buf, cow, 0, nritems);
-		if (ret)
-			return ret;
-		clean_tree_block(trans, root, buf);
-	}
-
-	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		ret = btrfs_reloc_tree_cache_ref(trans, root, cow, buf->start);
-		WARN_ON(ret);
-	}
+	update_ref_for_cow(trans, root, buf, cow);
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
+		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			parent_start = buf->start;
+		else
+			parent_start = 0;
 
 		spin_lock(&root->node_lock);
 		root->node = cow;
 		extent_buffer_get(cow);
 		spin_unlock(&root->node_lock);
 
-		if (buf != root->commit_root) {
-			btrfs_free_extent(trans, root, buf->start,
-					  buf->len, buf->start,
-					  root->root_key.objectid,
-					  btrfs_header_generation(buf),
-					  level, 1);
-		}
+		btrfs_free_extent(trans, root, buf->start, buf->len,
+				  parent_start, root->root_key.objectid,
+				  level, 0);
 		free_extent_buffer(buf);
 		add_root_to_dirty_list(root);
 	} else {
+		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			parent_start = parent->start;
+		else
+			parent_start = 0;
+
+		WARN_ON(trans->transid != btrfs_header_generation(parent));
 		btrfs_set_node_blockptr(parent, parent_slot,
 					cow->start);
-		WARN_ON(trans->transid == 0);
 		btrfs_set_node_ptr_generation(parent, parent_slot,
 					      trans->transid);
 		btrfs_mark_buffer_dirty(parent);
-		WARN_ON(btrfs_header_generation(parent) != trans->transid);
 		btrfs_free_extent(trans, root, buf->start, buf->len,
-				  parent_start, btrfs_header_owner(parent),
-				  btrfs_header_generation(parent), level, 1);
+				  parent_start, root->root_key.objectid,
+				  level, 0);
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
@@ -384,6 +493,18 @@ static noinline int __btrfs_cow_block(st
 	return 0;
 }
 
+static int should_cow_block(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root,
+			    struct extent_buffer *buf)
+{
+	if (btrfs_header_generation(buf) == trans->transid &&
+	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
+	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
+	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
+		return 0;
+	return 1;
+}
+
 /*
  * cows a single block, see __btrfs_cow_block for the real work.
  * This version of it has extra checks so that a block isn't cow'd more than
@@ -411,9 +532,7 @@ noinline int btrfs_cow_block(struct btrf
 		WARN_ON(1);
 	}
 
-	if (btrfs_header_generation(buf) == trans->transid &&
-	    btrfs_header_owner(buf) == root->root_key.objectid &&
-	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
+	if (!should_cow_block(trans, root, buf)) {
 		*cow_ret = buf;
 		return 0;
 	}
@@ -1620,11 +1739,9 @@ again:
 			 * then we don't want to set the path blocking,
 			 * so we test it here
 			 */
-			if (btrfs_header_generation(b) == trans->transid &&
-			    btrfs_header_owner(b) == root->root_key.objectid &&
-			    !btrfs_header_flag(b, BTRFS_HEADER_FLAG_WRITTEN)) {
+			if (!should_cow_block(trans, root, b))
 				goto cow_done;
-			}
+
 			btrfs_set_path_blocking(p);
 
 			wret = btrfs_cow_block(trans, root, b,
diff -urp 1/fs/btrfs/ctree.h 2/fs/btrfs/ctree.h
--- 1/fs/btrfs/ctree.h	2009-05-08 00:59:34.203958429 +0800
+++ 2/fs/btrfs/ctree.h	2009-05-11 16:40:51.000000000 +0800
@@ -952,8 +952,9 @@ struct btrfs_root {
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
 
+	struct list_head root_list;
+
 	spinlock_t list_lock;
-	struct list_head dead_list;
 	struct list_head orphan_list;
 
 	/*
@@ -2005,8 +2006,9 @@ int btrfs_find_last_root(struct btrfs_ro
 			 btrfs_root_item *item, struct btrfs_key *key);
 int btrfs_search_root(struct btrfs_root *root, u64 search_start,
 		      u64 *found_objectid);
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid,
-			  struct btrfs_root *latest_root);
+int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
+int btrfs_set_root_node(struct btrfs_root_item *item,
+			struct extent_buffer *node);
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
diff -urp 1/fs/btrfs/disk-io.c 2/fs/btrfs/disk-io.c
--- 1/fs/btrfs/disk-io.c	2009-05-08 00:59:34.206958436 +0800
+++ 2/fs/btrfs/disk-io.c	2009-05-11 15:40:07.000000000 +0800
@@ -901,12 +901,14 @@ static int __setup_root(u32 nodesize, u3
 	root->last_inode_alloc = 0;
 	root->name = NULL;
 	root->in_sysfs = 0;
+	root->inode_tree.rb_node = NULL;
 
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->orphan_list);
-	INIT_LIST_HEAD(&root->dead_list);
+	INIT_LIST_HEAD(&root->root_list);
 	spin_lock_init(&root->node_lock);
 	spin_lock_init(&root->list_lock);
+	spin_lock_init(&root->inode_lock);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
 	init_waitqueue_head(&root->log_writer_wait);
@@ -961,6 +963,7 @@ static int find_and_setup_root(struct bt
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
+	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
 	return 0;
 }
@@ -1083,8 +1086,7 @@ int btrfs_add_log_tree(struct btrfs_tran
 	inode_item->nbytes = cpu_to_le64(root->leafsize);
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
-	btrfs_set_root_bytenr(&log_root->root_item, log_root->node->start);
-	btrfs_set_root_generation(&log_root->root_item, trans->transid);
+	btrfs_set_root_node(&log_root->root_item, log_root->node);
 
 	WARN_ON(root->log_root);
 	root->log_root = log_root;
@@ -1146,6 +1148,7 @@ out:
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
+	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
 insert:
 	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
@@ -1210,12 +1213,8 @@ struct btrfs_root *btrfs_read_fs_root_no
 		kfree(root);
 		return ERR_PTR(ret);
 	}
-	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
-		ret = btrfs_find_dead_roots(fs_info->tree_root,
-					    root->root_key.objectid, root);
-		BUG_ON(ret);
+	if (!(fs_info->sb->s_flags & MS_RDONLY))
 		btrfs_orphan_cleanup(root);
-	}
 	return root;
 }
 
@@ -1773,7 +1772,7 @@ struct btrfs_root *open_ctree(struct sup
 	if (ret) {
 		printk(KERN_WARNING "btrfs: failed to read the system "
 		       "array on %s\n", sb->s_id);
-		goto fail_sys_array;
+		goto fail_sb_buffer;
 	}
 
 	blocksize = btrfs_level_size(tree_root,
@@ -1787,6 +1786,8 @@ struct btrfs_root *open_ctree(struct sup
 					   btrfs_super_chunk_root(disk_super),
 					   blocksize, generation);
 	BUG_ON(!chunk_root->node);
+	btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
+	chunk_root->commit_root = btrfs_root_node(chunk_root);
 
 	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
 	   (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
@@ -1812,7 +1813,8 @@ struct btrfs_root *open_ctree(struct sup
 					  blocksize, generation);
 	if (!tree_root->node)
 		goto fail_chunk_root;
-
+	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
+	tree_root->commit_root = btrfs_root_node(tree_root);
 
 	ret = find_and_setup_root(tree_root, fs_info,
 				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
@@ -1822,14 +1824,14 @@ struct btrfs_root *open_ctree(struct sup
 
 	ret = find_and_setup_root(tree_root, fs_info,
 				  BTRFS_DEV_TREE_OBJECTID, dev_root);
-	dev_root->track_dirty = 1;
 	if (ret)
 		goto fail_extent_root;
+	dev_root->track_dirty = 1;
 
 	ret = find_and_setup_root(tree_root, fs_info,
 				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
 	if (ret)
-		goto fail_extent_root;
+		goto fail_dev_root;
 
 	csum_root->track_dirty = 1;
 
@@ -1910,14 +1912,19 @@ fail_cleaner:
 
 fail_csum_root:
 	free_extent_buffer(csum_root->node);
+	free_extent_buffer(csum_root->commit_root);
+fail_dev_root:
+	free_extent_buffer(dev_root->node);
+	free_extent_buffer(dev_root->commit_root);
 fail_extent_root:
 	free_extent_buffer(extent_root->node);
+	free_extent_buffer(extent_root->commit_root);
 fail_tree_root:
 	free_extent_buffer(tree_root->node);
+	free_extent_buffer(tree_root->commit_root);
 fail_chunk_root:
 	free_extent_buffer(chunk_root->node);
-fail_sys_array:
-	free_extent_buffer(dev_root->node);
+	free_extent_buffer(chunk_root->commit_root);
 fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
@@ -2221,14 +2228,10 @@ int btrfs_cleanup_fs_roots(struct btrfs_
 					     ARRAY_SIZE(gang));
 		if (!ret)
 			break;
-		for (i = 0; i < ret; i++) {
-			root_objectid = gang[i]->root_key.objectid;
-			ret = btrfs_find_dead_roots(fs_info->tree_root,
-						    root_objectid, gang[i]);
-			BUG_ON(ret);
+
+		root_objectid = gang[ret - 1]->root_key.objectid + 1;
+		for (i = 0; i < ret; i++)
 			btrfs_orphan_cleanup(gang[i]);
-		}
-		root_objectid++;
 	}
 	return 0;
 }
@@ -2280,20 +2283,16 @@ int close_ctree(struct btrfs_root *root)
 		       (unsigned long long)fs_info->total_ref_cache_size);
 	}
 
-	if (fs_info->extent_root->node)
-		free_extent_buffer(fs_info->extent_root->node);
-
-	if (fs_info->tree_root->node)
-		free_extent_buffer(fs_info->tree_root->node);
-
-	if (root->fs_info->chunk_root->node)
-		free_extent_buffer(root->fs_info->chunk_root->node);
-
-	if (root->fs_info->dev_root->node)
-		free_extent_buffer(root->fs_info->dev_root->node);
-
-	if (root->fs_info->csum_root->node)
-		free_extent_buffer(root->fs_info->csum_root->node);
+	free_extent_buffer(fs_info->extent_root->node);
+	free_extent_buffer(fs_info->extent_root->commit_root);
+	free_extent_buffer(fs_info->tree_root->node);
+	free_extent_buffer(fs_info->tree_root->commit_root);
+	free_extent_buffer(root->fs_info->chunk_root->node);
+	free_extent_buffer(root->fs_info->chunk_root->commit_root);
+	free_extent_buffer(root->fs_info->dev_root->node);
+	free_extent_buffer(root->fs_info->dev_root->commit_root);
+	free_extent_buffer(root->fs_info->csum_root->node);
+	free_extent_buffer(root->fs_info->csum_root->commit_root);
 
 	btrfs_free_block_groups(root->fs_info);
 
diff -urp 1/fs/btrfs/root-tree.c 2/fs/btrfs/root-tree.c
--- 1/fs/btrfs/root-tree.c	2009-03-19 11:04:54.765669417 +0800
+++ 2/fs/btrfs/root-tree.c	2009-05-11 15:40:07.000000000 +0800
@@ -111,6 +111,15 @@ out:
 	return ret;
 }
 
+int btrfs_set_root_node(struct btrfs_root_item *item,
+			struct extent_buffer *node)
+{
+	btrfs_set_root_bytenr(item, node->start);
+	btrfs_set_root_level(item, btrfs_header_level(node));
+	btrfs_set_root_generation(item, btrfs_header_generation(node));
+	return 0;
+}
+
 /*
  * copy the data in 'item' into the btree
  */
@@ -164,8 +173,7 @@ int btrfs_insert_root(struct btrfs_trans
  * offset lower than the latest root.  They need to be queued for deletion to
  * finish what was happening when we crashed.
  */
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid,
-			  struct btrfs_root *latest)
+int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid)
 {
 	struct btrfs_root *dead_root;
 	struct btrfs_item *item;
@@ -227,10 +235,7 @@ again:
 			goto err;
 		}
 
-		if (objectid == BTRFS_TREE_RELOC_OBJECTID)
-			ret = btrfs_add_dead_reloc_root(dead_root);
-		else
-			ret = btrfs_add_dead_root(dead_root, latest);
+		ret = btrfs_add_dead_root(dead_root);
 		if (ret)
 			goto err;
 		goto again;
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-05-08 00:59:34.229960166 +0800
+++ 2/fs/btrfs/transaction.c	2009-05-11 15:40:07.000000000 +0800
@@ -94,45 +94,37 @@ static noinline int join_transaction(str
  * to make sure the old root from before we joined the transaction is deleted
  * when the transaction commits
  */
-noinline int btrfs_record_root_in_trans(struct btrfs_root *root)
+static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
+					 struct btrfs_root *root)
 {
-	struct btrfs_dirty_root *dirty;
-	u64 running_trans_id = root->fs_info->running_transaction->transid;
-	if (root->ref_cows && root->last_trans < running_trans_id) {
+	if (root->ref_cows && root->last_trans < trans->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
-		if (root->root_item.refs != 0) {
-			radix_tree_tag_set(&root->fs_info->fs_roots_radix,
-				   (unsigned long)root->root_key.objectid,
-				   BTRFS_ROOT_TRANS_TAG);
-
-			dirty = kmalloc(sizeof(*dirty), GFP_NOFS);
-			BUG_ON(!dirty);
-			dirty->root = kmalloc(sizeof(*dirty->root), GFP_NOFS);
-			BUG_ON(!dirty->root);
-			dirty->latest_root = root;
-			INIT_LIST_HEAD(&dirty->list);
+		WARN_ON(root->root_item.refs == 0);
+		WARN_ON(root->commit_root != root->node);
 
-			root->commit_root = btrfs_root_node(root);
+		radix_tree_tag_set(&root->fs_info->fs_roots_radix,
+			   (unsigned long)root->root_key.objectid,
+			   BTRFS_ROOT_TRANS_TAG);
+		root->last_trans = trans->transid;
+		btrfs_init_reloc_root(trans, root);
+	}
+	return 0;
+}
 
-			memcpy(dirty->root, root, sizeof(*root));
-			spin_lock_init(&dirty->root->node_lock);
-			spin_lock_init(&dirty->root->list_lock);
-			mutex_init(&dirty->root->objectid_mutex);
-			mutex_init(&dirty->root->log_mutex);
-			INIT_LIST_HEAD(&dirty->root->dead_list);
-			dirty->root->node = root->commit_root;
-			dirty->root->commit_root = NULL;
-
-			spin_lock(&root->list_lock);
-			list_add(&dirty->root->dead_list, &root->dead_list);
-			spin_unlock(&root->list_lock);
+int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
+{
+	if (!root->ref_cows)
+		return 0;
 
-			root->dirty_root = dirty;
-		} else {
-			WARN_ON(1);
-		}
-		root->last_trans = running_trans_id;
+	mutex_lock(&root->fs_info->trans_mutex);
+	if (root->last_trans == trans->transid) {
+		mutex_unlock(&root->fs_info->trans_mutex);
+		return 0;
 	}
+
+	record_root_in_trans(trans, root);
+	mutex_unlock(&root->fs_info->trans_mutex);
 	return 0;
 }
 
@@ -181,7 +173,6 @@ static struct btrfs_trans_handle *start_
 	ret = join_transaction(root);
 	BUG_ON(ret);
 
-	btrfs_record_root_in_trans(root);
 	h->transid = root->fs_info->running_transaction->transid;
 	h->transaction = root->fs_info->running_transaction;
 	h->blocks_reserved = num_blocks;
@@ -192,6 +183,7 @@ static struct btrfs_trans_handle *start_
 	h->delayed_ref_updates = 0;
 
 	root->fs_info->running_transaction->use_count++;
+	record_root_in_trans(h, root);
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return h;
 }
@@ -462,12 +454,8 @@ static int update_cowonly_root(struct bt
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
 		if (old_root_bytenr == root->node->start)
 			break;
-		btrfs_set_root_bytenr(&root->root_item,
-				       root->node->start);
-		btrfs_set_root_level(&root->root_item,
-				     btrfs_header_level(root->node));
-		btrfs_set_root_generation(&root->root_item, trans->transid);
 
+		btrfs_set_root_node(&root->root_item, root->node);
 		ret = btrfs_update_root(trans, tree_root,
 					&root->root_key,
 					&root->root_item);
@@ -477,14 +465,16 @@ static int update_cowonly_root(struct bt
 		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 		BUG_ON(ret);
 	}
+	free_extent_buffer(root->commit_root);
+	root->commit_root = btrfs_root_node(root);
 	return 0;
 }
 
 /*
  * update all the cowonly tree roots on disk
  */
-int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root)
+static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
+					 struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct list_head *next;
@@ -520,118 +510,54 @@ int btrfs_commit_tree_roots(struct btrfs
  * a dirty root struct and adds it into the list of dead roots that need to
  * be deleted
  */
-int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest)
+int btrfs_add_dead_root(struct btrfs_root *root)
 {
-	struct btrfs_dirty_root *dirty;
-
-	dirty = kmalloc(sizeof(*dirty), GFP_NOFS);
-	if (!dirty)
-		return -ENOMEM;
-	dirty->root = root;
-	dirty->latest_root = latest;
-
 	mutex_lock(&root->fs_info->trans_mutex);
-	list_add(&dirty->list, &latest->fs_info->dead_roots);
+	list_add(&root->root_list, &root->fs_info->dead_roots);
 	mutex_unlock(&root->fs_info->trans_mutex);
 	return 0;
 }
 
 /*
- * at transaction commit time we need to schedule the old roots for
- * deletion via btrfs_drop_snapshot.  This runs through all the
- * reference counted roots that were modified in the current
- * transaction and puts them into the drop list
+ * update all the cowonly tree roots on disk
  */
-static noinline int add_dirty_roots(struct btrfs_trans_handle *trans,
-				    struct radix_tree_root *radix,
-				    struct list_head *list)
+static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root)
 {
-	struct btrfs_dirty_root *dirty;
 	struct btrfs_root *gang[8];
-	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int i;
 	int ret;
 	int err = 0;
-	u32 refs;
 
 	while (1) {
-		ret = radix_tree_gang_lookup_tag(radix, (void **)gang, 0,
+		ret = radix_tree_gang_lookup_tag(&fs_info->fs_roots_radix,
+						 (void **)gang, 0,
 						 ARRAY_SIZE(gang),
 						 BTRFS_ROOT_TRANS_TAG);
 		if (ret == 0)
 			break;
 		for (i = 0; i < ret; i++) {
 			root = gang[i];
-			radix_tree_tag_clear(radix,
-				     (unsigned long)root->root_key.objectid,
-				     BTRFS_ROOT_TRANS_TAG);
-
-			BUG_ON(!root->ref_tree);
-			dirty = root->dirty_root;
+			radix_tree_tag_clear(&fs_info->fs_roots_radix,
+					(unsigned long)root->root_key.objectid,
+					BTRFS_ROOT_TRANS_TAG);
 
 			btrfs_free_log(trans, root);
-			btrfs_free_reloc_root(trans, root);
+			btrfs_update_reloc_root(trans, root);
 
-			if (root->commit_root == root->node) {
-				WARN_ON(root->node->start !=
-					btrfs_root_bytenr(&root->root_item));
-
-				free_extent_buffer(root->commit_root);
-				root->commit_root = NULL;
-				root->dirty_root = NULL;
-
-				spin_lock(&root->list_lock);
-				list_del_init(&dirty->root->dead_list);
-				spin_unlock(&root->list_lock);
-
-				kfree(dirty->root);
-				kfree(dirty);
-
-				/* make sure to update the root on disk
-				 * so we get any updates to the block used
-				 * counts
-				 */
-				err = btrfs_update_root(trans,
-						root->fs_info->tree_root,
-						&root->root_key,
-						&root->root_item);
+			if (root->commit_root == root->node)
 				continue;
-			}
 
-			memset(&root->root_item.drop_progress, 0,
-			       sizeof(struct btrfs_disk_key));
-			root->root_item.drop_level = 0;
-			root->commit_root = NULL;
-			root->dirty_root = NULL;
-			root->root_key.offset = root->fs_info->generation;
-			btrfs_set_root_bytenr(&root->root_item,
-					      root->node->start);
-			btrfs_set_root_level(&root->root_item,
-					     btrfs_header_level(root->node));
-			btrfs_set_root_generation(&root->root_item,
-						  root->root_key.offset);
+			free_extent_buffer(root->commit_root);
+			root->commit_root = btrfs_root_node(root);
 
-			err = btrfs_insert_root(trans, root->fs_info->tree_root,
+			btrfs_set_root_node(&root->root_item, root->node);
+			err = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
 			if (err)
 				break;
-
-			refs = btrfs_root_refs(&dirty->root->root_item);
-			btrfs_set_root_refs(&dirty->root->root_item, refs - 1);
-			err = btrfs_update_root(trans, root->fs_info->tree_root,
-						&dirty->root->root_key,
-						&dirty->root->root_item);
-
-			BUG_ON(err);
-			if (refs == 1) {
-				list_add(&dirty->list, list);
-			} else {
-				WARN_ON(1);
-				free_extent_buffer(dirty->root->node);
-				kfree(dirty->root);
-				kfree(dirty);
-			}
 		}
 	}
 	return err;
@@ -705,111 +631,61 @@ static noinline int wait_transaction_pre
  * Given a list of roots that need to be deleted, call btrfs_drop_snapshot on
  * all of them
  */
-static noinline int drop_dirty_roots(struct btrfs_root *tree_root,
-				     struct list_head *list)
+int btrfs_drop_dead_root(struct btrfs_root *root)
 {
-	struct btrfs_dirty_root *dirty;
 	struct btrfs_trans_handle *trans;
+	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	unsigned long nr;
-	u64 num_bytes;
-	u64 bytes_used;
-	u64 max_useless;
-	int ret = 0;
-	int err;
-
-	while (!list_empty(list)) {
-		struct btrfs_root *root;
-
-		dirty = list_entry(list->prev, struct btrfs_dirty_root, list);
-		list_del_init(&dirty->list);
-
-		num_bytes = btrfs_root_used(&dirty->root->root_item);
-		root = dirty->latest_root;
-		atomic_inc(&root->fs_info->throttles);
-
-		while (1) {
-			/*
-			 * we don't want to jump in and create a bunch of
-			 * delayed refs if the transaction is starting to close
-			 */
-			wait_transaction_pre_flush(tree_root->fs_info);
-			trans = btrfs_start_transaction(tree_root, 1);
-
-			/*
-			 * we've joined a transaction, make sure it isn't
-			 * closing right now
-			 */
-			if (trans->transaction->delayed_refs.flushing) {
-				btrfs_end_transaction(trans, tree_root);
-				continue;
-			}
-
-			mutex_lock(&root->fs_info->drop_mutex);
-			ret = btrfs_drop_snapshot(trans, dirty->root);
-			if (ret != -EAGAIN)
-				break;
-			mutex_unlock(&root->fs_info->drop_mutex);
-
-			err = btrfs_update_root(trans,
-					tree_root,
-					&dirty->root->root_key,
-					&dirty->root->root_item);
-			if (err)
-				ret = err;
-			nr = trans->blocks_used;
-			ret = btrfs_end_transaction(trans, tree_root);
-			BUG_ON(ret);
+	int ret;
 
-			btrfs_btree_balance_dirty(tree_root, nr);
-			cond_resched();
-		}
-		BUG_ON(ret);
-		atomic_dec(&root->fs_info->throttles);
-		wake_up(&root->fs_info->transaction_throttle);
+	while (1) {
+		/*
+		 * we don't want to jump in and create a bunch of
+		 * delayed refs if the transaction is starting to close
+		 */
+		wait_transaction_pre_flush(tree_root->fs_info);
+		trans = btrfs_start_transaction(tree_root, 1);
 
-		num_bytes -= btrfs_root_used(&dirty->root->root_item);
-		bytes_used = btrfs_root_used(&root->root_item);
-		if (num_bytes) {
-			mutex_lock(&root->fs_info->trans_mutex);
-			btrfs_record_root_in_trans(root);
-			mutex_unlock(&root->fs_info->trans_mutex);
-			btrfs_set_root_used(&root->root_item,
-					    bytes_used - num_bytes);
+		/*
+		 * we've joined a transaction, make sure it isn't
+		 * closing right now
+		 */
+		if (trans->transaction->delayed_refs.flushing) {
+			btrfs_end_transaction(trans, tree_root);
+			continue;
 		}
 
-		ret = btrfs_del_root(trans, tree_root, &dirty->root->root_key);
-		if (ret) {
-			BUG();
+		ret = btrfs_drop_snapshot(trans, root);
+		if (ret != -EAGAIN)
 			break;
-		}
-		mutex_unlock(&root->fs_info->drop_mutex);
 
-		spin_lock(&root->list_lock);
-		list_del_init(&dirty->root->dead_list);
-		if (!list_empty(&root->dead_list)) {
-			struct btrfs_root *oldest;
-			oldest = list_entry(root->dead_list.prev,
-					    struct btrfs_root, dead_list);
-			max_useless = oldest->root_key.offset - 1;
-		} else {
-			max_useless = root->root_key.offset - 1;
-		}
-		spin_unlock(&root->list_lock);
+		ret = btrfs_update_root(trans, tree_root,
+					&root->root_key,
+					&root->root_item);
+		if (ret)
+			break;
 
 		nr = trans->blocks_used;
 		ret = btrfs_end_transaction(trans, tree_root);
 		BUG_ON(ret);
 
-		ret = btrfs_remove_leaf_refs(root, max_useless, 0);
-		BUG_ON(ret);
-
-		free_extent_buffer(dirty->root->node);
-		kfree(dirty->root);
-		kfree(dirty);
-
 		btrfs_btree_balance_dirty(tree_root, nr);
 		cond_resched();
 	}
+	BUG_ON(ret);
+
+	ret = btrfs_del_root(trans, tree_root, &root->root_key);
+	BUG_ON(ret);
+
+	nr = trans->blocks_used;
+	ret = btrfs_end_transaction(trans, tree_root);
+	BUG_ON(ret);
+
+	free_extent_buffer(root->node);
+	free_extent_buffer(root->commit_root);
+	kfree(root);
+
+	btrfs_btree_balance_dirty(tree_root, nr);
 	return ret;
 }
 
@@ -839,24 +715,23 @@ static noinline int create_pending_snaps
 	if (ret)
 		goto fail;
 
-	btrfs_record_root_in_trans(root);
+	record_root_in_trans(trans, root);
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;
-	key.offset = trans->transid;
+	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
 	old = btrfs_lock_root_node(root);
 	btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	btrfs_set_lock_blocking(old);
 
 	btrfs_copy_root(trans, root, old, &tmp, objectid);
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
 
-	btrfs_set_root_bytenr(new_root_item, tmp->start);
-	btrfs_set_root_level(new_root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(new_root_item, trans->transid);
+	btrfs_set_root_node(new_root_item, tmp);
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
 				new_root_item);
 	btrfs_tree_unlock(tmp);
@@ -964,6 +839,24 @@ static noinline int finish_pending_snaps
 	return 0;
 }
 
+static void update_super_roots(struct btrfs_root *root)
+{
+	struct btrfs_root_item *root_item;
+	struct btrfs_super_block *super;
+
+	super = &root->fs_info->super_copy;
+
+	root_item = &root->fs_info->chunk_root->root_item;
+	super->chunk_root = root_item->bytenr;
+	super->chunk_root_generation = root_item->generation;
+	super->chunk_root_level = root_item->level;
+
+	root_item = &root->fs_info->tree_root->root_item;
+	super->root = root_item->bytenr;
+	super->generation = root_item->generation;
+	super->root_level = root_item->level;
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root)
 {
@@ -971,8 +864,6 @@ int btrfs_commit_transaction(struct btrf
 	unsigned long timeout = 1;
 	struct btrfs_transaction *cur_trans;
 	struct btrfs_transaction *prev_trans = NULL;
-	struct btrfs_root *chunk_root = root->fs_info->chunk_root;
-	struct list_head dirty_fs_roots;
 	struct extent_io_tree *pinned_copy;
 	DEFINE_WAIT(wait);
 	int ret;
@@ -999,7 +890,6 @@ int btrfs_commit_transaction(struct btrf
 	BUG_ON(ret);
 
 	mutex_lock(&root->fs_info->trans_mutex);
-	INIT_LIST_HEAD(&dirty_fs_roots);
 	if (cur_trans->in_commit) {
 		cur_trans->use_count++;
 		mutex_unlock(&root->fs_info->trans_mutex);
@@ -1105,41 +995,36 @@ int btrfs_commit_transaction(struct btrf
 	 * with the tree-log code.
 	 */
 	mutex_lock(&root->fs_info->tree_log_mutex);
-	/*
-	 * keep tree reloc code from adding new reloc trees
-	 */
-	mutex_lock(&root->fs_info->tree_reloc_mutex);
-
 
-	ret = add_dirty_roots(trans, &root->fs_info->fs_roots_radix,
-			      &dirty_fs_roots);
+	ret = commit_fs_roots(trans, root);
 	BUG_ON(ret);
 
-	/* add_dirty_roots gets rid of all the tree log roots, it is now
+	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
 	 */
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
-	ret = btrfs_commit_tree_roots(trans, root);
+	ret = commit_cowonly_roots(trans, root);
 	BUG_ON(ret);
 
 	cur_trans = root->fs_info->running_transaction;
 	spin_lock(&root->fs_info->new_trans_lock);
 	root->fs_info->running_transaction = NULL;
 	spin_unlock(&root->fs_info->new_trans_lock);
-	btrfs_set_super_generation(&root->fs_info->super_copy,
-				   cur_trans->transid);
-	btrfs_set_super_root(&root->fs_info->super_copy,
-			     root->fs_info->tree_root->node->start);
-	btrfs_set_super_root_level(&root->fs_info->super_copy,
-			   btrfs_header_level(root->fs_info->tree_root->node));
-
-	btrfs_set_super_chunk_root(&root->fs_info->super_copy,
-				   chunk_root->node->start);
-	btrfs_set_super_chunk_root_level(&root->fs_info->super_copy,
-					 btrfs_header_level(chunk_root->node));
-	btrfs_set_super_chunk_root_generation(&root->fs_info->super_copy,
-				btrfs_header_generation(chunk_root->node));
+
+	btrfs_set_root_node(&root->fs_info->tree_root->root_item,
+			    root->fs_info->tree_root->node);
+	free_extent_buffer(root->fs_info->tree_root->commit_root);
+	root->fs_info->tree_root->commit_root =
+				btrfs_root_node(root->fs_info->tree_root);
+
+	btrfs_set_root_node(&root->fs_info->chunk_root->root_item,
+			    root->fs_info->chunk_root->node);
+	free_extent_buffer(root->fs_info->chunk_root->commit_root);
+	root->fs_info->chunk_root->commit_root =
+				btrfs_root_node(root->fs_info->chunk_root);
+
+	update_super_roots(root);
 
 	if (!root->fs_info->log_root_recovering) {
 		btrfs_set_super_log_root(&root->fs_info->super_copy, 0);
@@ -1170,9 +1055,6 @@ int btrfs_commit_transaction(struct btrf
 	btrfs_finish_extent_commit(trans, root, pinned_copy);
 	kfree(pinned_copy);
 
-	btrfs_drop_dead_reloc_roots(root);
-	mutex_unlock(&root->fs_info->tree_reloc_mutex);
-
 	/* do the directory inserts of any pending snapshot creations */
 	finish_pending_snapshots(trans, root->fs_info);
 
@@ -1186,16 +1068,9 @@ int btrfs_commit_transaction(struct btrf
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
-	list_splice_init(&dirty_fs_roots, &root->fs_info->dead_roots);
-	if (root->fs_info->closing)
-		list_splice_init(&root->fs_info->dead_roots, &dirty_fs_roots);
-
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-
-	if (root->fs_info->closing)
-		drop_dirty_roots(root->fs_info->tree_root, &dirty_fs_roots);
 	return ret;
 }
 
@@ -1204,16 +1079,17 @@ int btrfs_commit_transaction(struct btrf
  */
 int btrfs_clean_old_snapshots(struct btrfs_root *root)
 {
-	struct list_head dirty_roots;
-	INIT_LIST_HEAD(&dirty_roots);
-again:
-	mutex_lock(&root->fs_info->trans_mutex);
-	list_splice_init(&root->fs_info->dead_roots, &dirty_roots);
-	mutex_unlock(&root->fs_info->trans_mutex);
+	LIST_HEAD(list);
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	if (!list_empty(&dirty_roots)) {
-		drop_dirty_roots(root, &dirty_roots);
-		goto again;
+	mutex_lock(&fs_info->trans_mutex);
+	list_splice_init(&fs_info->dead_roots, &list);
+	mutex_unlock(&fs_info->trans_mutex);
+
+	while (!list_empty(&list)) {
+		root = list_entry(list.next, struct btrfs_root, root_list);
+		list_del_init(&root->root_list);
+		btrfs_drop_dead_root(root);
 	}
 	return 0;
 }
diff -urp 1/fs/btrfs/transaction.h 2/fs/btrfs/transaction.h
--- 1/fs/btrfs/transaction.h	2009-03-25 06:50:03.780352651 +0800
+++ 2/fs/btrfs/transaction.h	2009-05-11 15:40:07.000000000 +0800
@@ -62,12 +62,6 @@ struct btrfs_pending_snapshot {
 	struct list_head list;
 };
 
-struct btrfs_dirty_root {
-	struct list_head list;
-	struct btrfs_root *root;
-	struct btrfs_root *latest_root;
-};
-
 static inline void btrfs_set_trans_block_group(struct btrfs_trans_handle *trans,
 					       struct inode *inode)
 {
@@ -100,7 +94,8 @@ int btrfs_write_and_wait_transaction(str
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 
-int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest);
+int btrfs_add_dead_root(struct btrfs_root *root);
+int btrfs_drop_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
@@ -108,7 +103,8 @@ int btrfs_commit_transaction(struct btrf
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_root *root);
-int btrfs_record_root_in_trans(struct btrfs_root *root);
+int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root);
 int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages);
 #endif
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2009-05-08 00:59:34.232960452 +0800
+++ 2/fs/btrfs/tree-log.c	2009-05-11 15:55:21.000000000 +0800
@@ -3029,9 +3029,7 @@ again:
 		BUG_ON(!wc.replay_dest);
 
 		wc.replay_dest->log_root = log;
-		mutex_lock(&fs_info->trans_mutex);
-		btrfs_record_root_in_trans(wc.replay_dest);
-		mutex_unlock(&fs_info->trans_mutex);
+		btrfs_record_root_in_trans(trans, wc.replay_dest);
 		ret = walk_log_tree(trans, log, &wc);
 		BUG_ON(ret);
 

