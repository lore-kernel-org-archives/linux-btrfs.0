From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 3/4] update nodatacow code v2
Date: Fri, 31 Oct 2008 01:02:35 +0800
Message-ID: <4909E8AB.8050706@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, ukernel@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch simplifies the nodatacow checker. If all references
were created after the latest snapshot, then we can avoid COW
safely. This patch also updates run_delalloc_nocow to do more
fine-grained checking.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2008-10-30 13:06:26.000000000 +0800
+++ 4/fs/btrfs/ctree.h	2008-10-30 13:45:33.000000000 +0800
@@ -454,6 +454,7 @@ struct btrfs_root_item {
 	__le64 bytenr;
 	__le64 byte_limit;
 	__le64 bytes_used;
+	__le64 last_snapshot;
 	__le32 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
@@ -1413,6 +1414,8 @@ BTRFS_SETGET_STACK_FUNCS(root_refs, stru
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 32);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
+BTRFS_SETGET_STACK_FUNCS(root_last_snapshot, struct btrfs_root_item,
+			 last_snapshot, 64);
 
 /* struct btrfs_super_block */
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
@@ -1564,9 +1567,8 @@ int btrfs_update_pinned_extents(struct b
 				u64 bytenr, u64 num, int pin);
 int btrfs_drop_leaf_ref(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct extent_buffer *leaf);
-int btrfs_cross_ref_exists(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   struct btrfs_key *key, u64 bytenr);
+int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 bytenr);
 int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root);
 int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy);
diff -urp 3/fs/btrfs/extent-tree.c 4/fs/btrfs/extent-tree.c
--- 3/fs/btrfs/extent-tree.c	2008-10-30 15:22:16.000000000 +0800
+++ 4/fs/btrfs/extent-tree.c	2008-10-30 15:21:55.000000000 +0800
@@ -848,9 +848,8 @@ out:
 	return 0;
 }
 
-static int get_reference_status(struct btrfs_root *root, u64 bytenr,
-				u64 parent_gen, u64 ref_objectid,
-			        u64 *min_generation, u32 *ref_count)
+int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 bytenr)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_path *path;
@@ -858,8 +857,8 @@ static int get_reference_status(struct b
 	struct btrfs_extent_ref *ref_item;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	u64 root_objectid = root->root_key.objectid;
-	u64 ref_generation;
+	u64 ref_root;
+	u64 last_snapshot;
 	u32 nritems;
 	int ret;
 
@@ -872,7 +871,9 @@ static int get_reference_status(struct b
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret == 0);
-	if (ret < 0 || path->slots[0] == 0)
+
+	ret = -ENOENT;
+	if (path->slots[0] == 0)
 		goto out;
 
 	path->slots[0]--;
@@ -880,14 +881,10 @@ static int get_reference_status(struct b
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
 	if (found_key.objectid != bytenr ||
-	    found_key.type != BTRFS_EXTENT_ITEM_KEY) {
-		ret = 1;
+	    found_key.type != BTRFS_EXTENT_ITEM_KEY)
 		goto out;
-	}
-
-	*ref_count = 0;
-	*min_generation = (u64)-1;
 
+	last_snapshot = btrfs_root_last_snapshot(&root->root_item);
 	while (1) {
 		leaf = path->nodes[0];
 		nritems = btrfs_header_nritems(leaf);
@@ -910,114 +907,22 @@ static int get_reference_status(struct b
 
 		ref_item = btrfs_item_ptr(leaf, path->slots[0],
 					  struct btrfs_extent_ref);
-		ref_generation = btrfs_ref_generation(leaf, ref_item);
-		/*
-		 * For (parent_gen > 0 && parent_gen > ref_generation):
-		 *
-		 * we reach here through the oldest root, therefore
-		 * all other reference from same snapshot should have
-		 * a larger generation.
-		 */
-		if ((root_objectid != btrfs_ref_root(leaf, ref_item)) ||
-		    (parent_gen > 0 && parent_gen > ref_generation) ||
-		    (ref_objectid >= BTRFS_FIRST_FREE_OBJECTID &&
-		     ref_objectid != btrfs_ref_objectid(leaf, ref_item))) {
-			*ref_count = 2;
-			break;
-		}
-
-		*ref_count = 1;
-		if (*min_generation > ref_generation)
-			*min_generation = ref_generation;
-
-		path->slots[0]++;
-	}
-	ret = 0;
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
-int btrfs_cross_ref_exists(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root,
-			   struct btrfs_key *key, u64 bytenr)
-{
-	struct btrfs_root *old_root;
-	struct btrfs_path *path = NULL;
-	struct extent_buffer *eb;
-	struct btrfs_file_extent_item *item;
-	u64 ref_generation;
-	u64 min_generation;
-	u64 extent_start;
-	u32 ref_count;
-	int level;
-	int ret;
-
-	BUG_ON(trans == NULL);
-	BUG_ON(key->type != BTRFS_EXTENT_DATA_KEY);
-	ret = get_reference_status(root, bytenr, 0, key->objectid,
-				   &min_generation, &ref_count);
-	if (ret)
-		return ret;
-
-	if (ref_count != 1)
-		return 1;
-
-	old_root = root->dirty_root->root;
-	ref_generation = old_root->root_key.offset;
-
-	/* all references are created in running transaction */
-	if (min_generation > ref_generation) {
-		ret = 0;
-		goto out;
-	}
-
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	path->skip_locking = 1;
-	/* if no item found, the extent is referenced by other snapshot */
-	ret = btrfs_search_slot(NULL, old_root, key, path, 0, 0);
-	if (ret)
-		goto out;
-
-	eb = path->nodes[0];
-	item = btrfs_item_ptr(eb, path->slots[0],
-			      struct btrfs_file_extent_item);
-	if (btrfs_file_extent_type(eb, item) != BTRFS_FILE_EXTENT_REG ||
-	    btrfs_file_extent_disk_bytenr(eb, item) != bytenr) {
-		ret = 1;
-		goto out;
-	}
-
-	for (level = BTRFS_MAX_LEVEL - 1; level >= -1; level--) {
-		if (level >= 0) {
-			eb = path->nodes[level];
-			if (!eb)
-				continue;
-			extent_start = eb->start;
-		} else
-			extent_start = bytenr;
-
-		ret = get_reference_status(root, extent_start, ref_generation,
-					   0, &min_generation, &ref_count);
-		if (ret)
+		ref_root = btrfs_ref_root(leaf, ref_item);
+		if (ref_root != root->root_key.objectid &&
+		    ref_root != BTRFS_TREE_LOG_OBJECTID) {
+			ret = 1;
 			goto out;
-
-		if (ref_count != 1) {
+		}
+		if (btrfs_ref_generation(leaf, ref_item) <= last_snapshot) {
 			ret = 1;
 			goto out;
 		}
-		if (level >= 0)
-			ref_generation = btrfs_header_generation(eb);
+
+		path->slots[0]++;
 	}
 	ret = 0;
 out:
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	return ret;
 }
 
diff -urp 3/fs/btrfs/inode.c 4/fs/btrfs/inode.c
--- 3/fs/btrfs/inode.c	2008-10-30 15:48:35.000000000 +0800
+++ 4/fs/btrfs/inode.c	2008-10-30 15:48:49.000000000 +0800
@@ -298,6 +298,7 @@ static int cow_file_range(struct inode *
 	unsigned long max_compressed = 128 * 1024;
 	unsigned long max_uncompressed = 256 * 1024;
 	int i;
+	int ordered_type;
 	int will_compress;
 
 	trans = btrfs_join_transaction(root, 1);
@@ -491,9 +492,10 @@ again:
 		}
 
 		cur_alloc_size = ins.offset;
+		ordered_type = will_compress ? BTRFS_ORDERED_COMPRESSED : 0;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0,
-					       will_compress);
+					       ram_size, cur_alloc_size,
+					       ordered_type);
 		BUG_ON(ret);
 
 		if (disk_num_bytes < cur_alloc_size) {
@@ -587,115 +589,148 @@ free_pages_out:
 static int run_delalloc_nocow(struct inode *inode, struct page *locked_page,
 			      u64 start, u64 end, int *page_started)
 {
-	u64 extent_start;
-	u64 extent_end;
-	u64 bytenr;
-	u64 loops = 0;
-	u64 total_fs_bytes;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_block_group_cache *block_group;
 	struct btrfs_trans_handle *trans;
 	struct extent_buffer *leaf;
-	int found_type;
 	struct btrfs_path *path;
-	struct btrfs_file_extent_item *item;
-	int ret;
-	int err = 0;
+	struct btrfs_file_extent_item *fi;
 	struct btrfs_key found_key;
+	u64 cow_start;
+	u64 cur_offset;
+	u64 extent_end;
+	u64 disk_bytenr;
+	u64 num_bytes;
+	int extent_type;
+	int ret;
+	int nocow;
+	int check_prev = 1;
 
-	total_fs_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(!trans);
-again:
-	ret = btrfs_lookup_file_extent(NULL, root, path,
-				       inode->i_ino, start, 0);
-	if (ret < 0) {
-		err = ret;
-		goto out;
-	}
 
-	if (ret != 0) {
-		if (path->slots[0] == 0)
-			goto not_found;
-		path->slots[0]--;
-	}
-
-	leaf = path->nodes[0];
-	item = btrfs_item_ptr(leaf, path->slots[0],
-			      struct btrfs_file_extent_item);
-
-	/* are we inside the extent that was found? */
-	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-	found_type = btrfs_key_type(&found_key);
-	if (found_key.objectid != inode->i_ino ||
-	    found_type != BTRFS_EXTENT_DATA_KEY)
-		goto not_found;
-
-	found_type = btrfs_file_extent_type(leaf, item);
-	extent_start = found_key.offset;
-	if (found_type == BTRFS_FILE_EXTENT_REG) {
-		u64 extent_num_bytes;
-
-		extent_num_bytes = btrfs_file_extent_num_bytes(leaf, item);
-		extent_end = extent_start + extent_num_bytes;
-		err = 0;
-
-		if (btrfs_file_extent_compression(leaf, item) ||
-		    btrfs_file_extent_encryption(leaf,item) ||
-		    btrfs_file_extent_other_encoding(leaf, item))
-			goto not_found;
-
-		if (loops && start != extent_start)
-			goto not_found;
+	cow_start = (u64)-1;
+	cur_offset = start;
+	while (1) {
+		ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
+					       cur_offset, 0);
+		BUG_ON(ret < 0);
+		if (ret > 0 && path->slots[0] > 0 && check_prev) {
+			leaf = path->nodes[0];
+			btrfs_item_key_to_cpu(leaf, &found_key,
+					      path->slots[0] - 1);
+			if (found_key.objectid == inode->i_ino &&
+			    found_key.type == BTRFS_EXTENT_DATA_KEY)
+				path->slots[0]--;
+		}
+		check_prev = 0;
+next_slot:
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				BUG_ON(1);
+			if (ret > 0)
+				break;
+			leaf = path->nodes[0];
+		}
 
-		if (start < extent_start || start >= extent_end)
-			goto not_found;
+		nocow = 0;
+		disk_bytenr = 0;
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
-		if (bytenr == 0)
-			goto not_found;
+		if (found_key.objectid > inode->i_ino ||
+		    found_key.type > BTRFS_EXTENT_DATA_KEY ||
+		    found_key.offset > end)
+			break;
 
-		if (btrfs_cross_ref_exists(trans, root, &found_key, bytenr))
-			goto not_found;
-		/*
-		 * we may be called by the resizer, make sure we're inside
-		 * the limits of the FS
-		 */
-		block_group = btrfs_lookup_block_group(root->fs_info,
-						       bytenr);
-		if (!block_group || block_group->ro)
-			goto not_found;
+		if (found_key.offset > cur_offset) {
+			extent_end = found_key.offset;
+			goto out_check;
+		}
 
-		bytenr += btrfs_file_extent_offset(leaf, item);
-		extent_num_bytes = min(end + 1, extent_end) - start;
-		ret = btrfs_add_ordered_extent(inode, start, bytenr,
-						extent_num_bytes,
-						extent_num_bytes, 1, 0);
-		if (ret) {
-			err = ret;
-			goto out;
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		extent_type = btrfs_file_extent_type(leaf, fi);
+
+		if (extent_type == BTRFS_FILE_EXTENT_REG) {
+			struct btrfs_block_group_cache *block_group;
+			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+			extent_end = found_key.offset +
+				btrfs_file_extent_num_bytes(leaf, fi);
+			if (extent_end <= start) {
+				path->slots[0]++;
+				goto next_slot;
+			}
+			if (btrfs_file_extent_compression(leaf, fi) ||
+			    btrfs_file_extent_encryption(leaf, fi) ||
+			    btrfs_file_extent_other_encoding(leaf, fi))
+				goto out_check;
+			if (disk_bytenr == 0)
+				goto out_check;
+			if (btrfs_cross_ref_exist(trans, root, disk_bytenr))
+				goto out_check;
+			block_group = btrfs_lookup_block_group(root->fs_info,
+							       disk_bytenr);
+			if (!block_group || block_group->ro)
+				goto out_check;
+			disk_bytenr += btrfs_file_extent_offset(leaf, fi);
+			nocow = 1;
+		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
+			extent_end = found_key.offset +
+				btrfs_file_extent_inline_len(leaf, fi);
+			extent_end = ALIGN(extent_end, root->sectorsize);
+		} else {
+			BUG_ON(1);
+		}
+out_check:
+		if (extent_end <= start) {
+			path->slots[0]++;
+			goto next_slot;
+		}
+		if (!nocow) {
+			if (cow_start == (u64)-1)
+				cow_start = cur_offset;
+			cur_offset = extent_end;
+			if (cur_offset > end)
+				break;
+			path->slots[0]++;
+			goto next_slot;
 		}
 
 		btrfs_release_path(root, path);
-		start = extent_end;
-		if (start <= end) {
-			loops++;
-			goto again;
+		if (cow_start != (u64)-1) {
+			ret = cow_file_range(inode, locked_page, cow_start,
+					found_key.offset - 1, page_started);
+			BUG_ON(ret);
+			cow_start = (u64)-1;
 		}
-	} else {
-not_found:
-		btrfs_end_transaction(trans, root);
-		btrfs_free_path(path);
-		return cow_file_range(inode, locked_page, start, end,
-				      page_started);
+
+		disk_bytenr += cur_offset - found_key.offset;
+		num_bytes = min(end + 1, extent_end) - cur_offset;
+
+		ret = btrfs_add_ordered_extent(inode, cur_offset, disk_bytenr,
+					       num_bytes, num_bytes,
+					       BTRFS_ORDERED_NOCOW);
+		cur_offset = extent_end;
+		if (cur_offset > end)
+			break;
 	}
-out:
-	WARN_ON(err);
-	btrfs_end_transaction(trans, root);
+	btrfs_release_path(root, path);
+
+	if (cur_offset <= end && cow_start == (u64)-1)
+		cow_start = cur_offset;
+	if (cow_start != (u64)-1) {
+		ret = cow_file_range(inode, locked_page, cow_start, end,
+				     page_started);
+		BUG_ON(ret);
+	}
+
+	ret = btrfs_end_transaction(trans, root);
+	BUG_ON(ret);
 	btrfs_free_path(path);
-	return err;
+	return 0;
 }
 
 /*
diff -urp 3/fs/btrfs/ioctl.c 4/fs/btrfs/ioctl.c
--- 3/fs/btrfs/ioctl.c	2008-10-30 07:22:02.000000000 +0800
+++ 4/fs/btrfs/ioctl.c	2008-10-30 15:58:12.000000000 +0800
@@ -112,6 +112,7 @@ static noinline int create_subvol(struct
 	btrfs_set_root_level(&root_item, 0);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, 0);
+	btrfs_set_root_last_snapshot(&root_item, 0);
 
 	memset(&root_item.drop_progress, 0, sizeof(root_item.drop_progress));
 	root_item.drop_level = 0;
diff -urp 3/fs/btrfs/ordered-data.c 4/fs/btrfs/ordered-data.c
--- 3/fs/btrfs/ordered-data.c	2008-10-30 07:22:02.000000000 +0800
+++ 4/fs/btrfs/ordered-data.c	2008-10-30 14:11:17.000000000 +0800
@@ -165,8 +165,7 @@ static inline struct rb_node *tree_searc
  * inserted.
  */
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len, u64 disk_len, int nocow,
-			     int compressed)
+			     u64 start, u64 len, u64 disk_len, int type)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
@@ -183,10 +182,8 @@ int btrfs_add_ordered_extent(struct inod
 	entry->len = len;
 	entry->disk_len = disk_len;
 	entry->inode = inode;
-	if (nocow)
-		set_bit(BTRFS_ORDERED_NOCOW, &entry->flags);
-	if (compressed)
-		set_bit(BTRFS_ORDERED_COMPRESSED, &entry->flags);
+	if (type == BTRFS_ORDERED_NOCOW || type == BTRFS_ORDERED_COMPRESSED)
+		set_bit(type, &entry->flags);
 
 	/* one ref for the tree */
 	atomic_set(&entry->refs, 1);
diff -urp 3/fs/btrfs/ordered-data.h 4/fs/btrfs/ordered-data.h
--- 3/fs/btrfs/ordered-data.h	2008-10-30 07:22:02.000000000 +0800
+++ 4/fs/btrfs/ordered-data.h	2008-10-30 15:56:37.000000000 +0800
@@ -132,8 +132,7 @@ int btrfs_remove_ordered_extent(struct i
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				       u64 file_offset, u64 io_size);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
-			     u64 start, u64 len, u64 disk_len, int nocow,
-			     int compressed);
+			     u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_sum(struct inode *inode,
 			  struct btrfs_ordered_extent *entry,
 			  struct btrfs_ordered_sum *sum);
diff -urp 3/fs/btrfs/transaction.c 4/fs/btrfs/transaction.c
--- 3/fs/btrfs/transaction.c	2008-10-30 07:22:02.000000000 +0800
+++ 4/fs/btrfs/transaction.c	2008-10-30 15:57:16.000000000 +0800
@@ -751,6 +751,8 @@ static noinline int create_pending_snaps
 	if (ret)
 		goto fail;
 
+	btrfs_record_root_in_trans(root);
+	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 
 	key.objectid = objectid;

