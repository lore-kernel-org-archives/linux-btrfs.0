From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: remove trans and root argument from fixup_low_keys()
Date: Thu, 21 Apr 2011 18:54:45 +0900
Message-ID: <201104210954.AA00015@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

'trans' and 'root' argument not used in fixup_low_keys() are deleted.
And, the argument that became unnecessary is deleted about the caller
of fixup_low_keys().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       |   49 ++++++++++++++++++++---------------------------
 fs/btrfs/ctree.h       |    6 +---
 fs/btrfs/dir-item.c    |    2 +-
 fs/btrfs/extent-tree.c |    9 +++----
 fs/btrfs/file-item.c   |   11 ++++-----
 fs/btrfs/file.c        |    6 ++--
 fs/btrfs/inode-item.c  |    3 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/tree-log.c    |    2 +-
 9 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..d080042 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -36,10 +36,10 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+static int del_ptr(struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
-static int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct btrfs_path *path,
+static int setup_items_for_insert(struct btrfs_root *root,
+			struct btrfs_path *path,
 			struct btrfs_key *cpu_key, u32 *data_size,
 			u32 total_data, u32 total_size, int nr);
 
@@ -994,8 +994,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			wret = del_ptr(trans, root, path, level + 1, pslot +
-				       1);
+			wret = del_ptr(root, path, level + 1, pslot + 1);
 			if (wret)
 				ret = wret;
 			root_sub_used(root, right->len);
@@ -1035,7 +1034,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		wret = del_ptr(trans, root, path, level + 1, pslot);
+		wret = del_ptr(root, path, level + 1, pslot);
 		if (wret)
 			ret = wret;
 		root_sub_used(root, mid->len);
@@ -1767,8 +1766,7 @@ done:
  * If this fails to write a tree block, it returns -1, but continues
  * fixing up the blocks in ram so the tree is consistent.
  */
-static int fixup_low_keys(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
+static int fixup_low_keys(struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level)
 {
 	int i;
@@ -1794,8 +1792,7 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
  * This function isn't completely safe. It's the caller's responsibility
  * that the new key won't break the order
  */
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+int btrfs_set_item_key_safe(struct btrfs_path *path,
 			    struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
@@ -1819,7 +1816,7 @@ int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(path, &disk_key, 1);
 	return 0;
 }
 
@@ -2584,7 +2581,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
+	wret = fixup_low_keys(path, &disk_key, 1);
 	if (wret)
 		ret = wret;
 
@@ -2971,8 +2968,7 @@ again:
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
-						path, &disk_key, 1);
+				wret = fixup_low_keys(path, &disk_key, 1);
 				if (wret)
 					ret = wret;
 			}
@@ -3192,7 +3188,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 		return ret;
 
 	path->slots[0]++;
-	ret = setup_items_for_insert(trans, root, path, new_key, &item_size,
+	ret = setup_items_for_insert(root, path, new_key, &item_size,
 				     item_size, item_size +
 				     sizeof(struct btrfs_item), 1);
 	BUG_ON(ret);
@@ -3211,8 +3207,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
  * off the end of the item or if we shift the item to chop bytes off
  * the front.
  */
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
+int btrfs_truncate_item(struct btrfs_root *root,
 			struct btrfs_path *path,
 			u32 new_size, int from_end)
 {
@@ -3307,7 +3302,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(trans, root, path, &disk_key, 1);
+			fixup_low_keys(path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(leaf, slot);
@@ -3541,7 +3536,7 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		ret = fixup_low_keys(path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3560,8 +3555,7 @@ out:
  * that doesn't call btrfs_search_slot
  */
 static noinline_for_stack int
-setup_items_for_insert(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
+setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 		      struct btrfs_key *cpu_key, u32 *data_size,
 		      u32 total_data, u32 total_size, int nr)
 {
@@ -3649,7 +3643,7 @@ setup_items_for_insert(struct btrfs_trans_handle *trans,
 	if (slot == 0) {
 		struct btrfs_disk_key disk_key;
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		ret = fixup_low_keys(path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3690,7 +3684,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	ret = setup_items_for_insert(trans, root, path, cpu_key, data_size,
+	ret = setup_items_for_insert(root, path, cpu_key, data_size,
 			       total_data, total_size, nr);
 
 out:
@@ -3730,7 +3724,7 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
  * the tree should have been previously balanced so the deletion does not
  * empty a node.
  */
-static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+static int del_ptr(struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot)
 {
 	struct extent_buffer *parent = path->nodes[level];
@@ -3756,7 +3750,7 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
+		wret = fixup_low_keys(path, &disk_key, level + 1);
 		if (wret)
 			ret = wret;
 	}
@@ -3782,7 +3776,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	int ret;
 
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	ret = del_ptr(trans, root, path, 1, path->slots[1]);
+	ret = del_ptr(root, path, 1, path->slots[1]);
 	if (ret)
 		return ret;
 
@@ -3873,8 +3867,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
-					      &disk_key, 1);
+			wret = fixup_low_keys(path, &disk_key, 1);
 			if (wret)
 				ret = wret;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e61fe1..0f191fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2246,8 +2246,7 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+int btrfs_set_item_key_safe(struct btrfs_path *path,
 			    struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
@@ -2270,8 +2269,7 @@ int btrfs_block_can_be_shared(struct btrfs_root *root,
 			      struct extent_buffer *buf);
 int btrfs_extend_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, u32 data_size);
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
+int btrfs_truncate_item(struct btrfs_root *root,
 			struct btrfs_path *path,
 			u32 new_size, int from_end);
 int btrfs_split_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..c80994f 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -429,7 +429,7 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			item_len - (ptr + sub_item_len - start));
-		ret = btrfs_truncate_item(trans, root, path,
+		ret = btrfs_truncate_item(root, path,
 					  item_len - sub_item_len, 1);
 	}
 	return ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31f33ba..73c3a27 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1625,8 +1625,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-int update_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+int update_inline_extent_backref(struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
 				 int refs_to_mod,
@@ -1683,7 +1682,7 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 			memmove_extent_buffer(leaf, ptr, ptr + size,
 					      end - ptr - size);
 		item_size -= size;
-		ret = btrfs_truncate_item(trans, root, path, item_size, 1);
+		ret = btrfs_truncate_item(root, path, item_size, 1);
 		BUG_ON(ret);
 	}
 	btrfs_mark_buffer_dirty(leaf);
@@ -1707,7 +1706,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		ret = update_inline_extent_backref(trans, root, path, iref,
+		ret = update_inline_extent_backref(root, path, iref,
 						   refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
 		ret = setup_inline_extent_backref(trans, root, path, iref,
@@ -1747,7 +1746,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		ret = update_inline_extent_backref(trans, root, path, iref,
+		ret = update_inline_extent_backref(root, path, iref,
 						   -refs_to_drop, NULL);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..60ff3e9 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -466,8 +466,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
  * This calls btrfs_truncate_item with the correct args based on the
  * overlap, and fixes up the key as required.
  */
-static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
+static noinline int truncate_one_csum(struct btrfs_root *root,
 				      struct btrfs_path *path,
 				      struct btrfs_key *key,
 				      u64 bytenr, u64 len)
@@ -494,7 +493,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		 */
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
-		ret = btrfs_truncate_item(trans, root, path, new_size, 1);
+		ret = btrfs_truncate_item(root, path, new_size, 1);
 		BUG_ON(ret);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
@@ -507,11 +506,11 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (csum_end - end_byte) >> blocksize_bits;
 		new_size *= csum_size;
 
-		ret = btrfs_truncate_item(trans, root, path, new_size, 0);
+		ret = btrfs_truncate_item(root, path, new_size, 0);
 		BUG_ON(ret);
 
 		key->offset = end_byte;
-		ret = btrfs_set_item_key_safe(trans, root, path, key);
+		ret = btrfs_set_item_key_safe(path, key);
 		BUG_ON(ret);
 	} else {
 		BUG();
@@ -625,7 +624,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 			key.offset = end_byte - 1;
 		} else {
-			ret = truncate_one_csum(trans, root, path,
+			ret = truncate_one_csum(root, path,
 						&key, bytenr, len);
 			BUG_ON(ret);
 			if (key.offset < bytenr)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 75899a0..6ef6f7d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -434,7 +434,7 @@ next_slot:
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = end;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(path, &new_key);
 
 			extent_offset += end - key.offset;
 			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
@@ -633,7 +633,7 @@ again:
 				     inode->i_ino, bytenr, orig_offset,
 				     &other_start, &other_end)) {
 			new_key.offset = end;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(path, &new_key);
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
@@ -661,7 +661,7 @@ again:
 							start - key.offset);
 			path->slots[0]++;
 			new_key.offset = start;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(path, &new_key);
 
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 64f1150..ea3862d 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -128,8 +128,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			      item_size - (ptr + sub_item_len - item_start));
-	ret = btrfs_truncate_item(trans, root, path,
-				  item_size - sub_item_len, 1);
+	ret = btrfs_truncate_item(root, path, item_size - sub_item_len, 1);
 	BUG_ON(ret);
 out:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4157cf..f8bd217 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3424,7 +3424,7 @@ search_again:
 				}
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
-				ret = btrfs_truncate_item(trans, root, path,
+				ret = btrfs_truncate_item(root, path,
 							  size, 1);
 				BUG_ON(ret);
 			} else if (root->ref_cows) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..e002353 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -378,7 +378,7 @@ insert:
 		found_size = btrfs_item_size_nr(path->nodes[0],
 						path->slots[0]);
 		if (found_size > item_size) {
-			btrfs_truncate_item(trans, root, path, item_size, 1);
+			btrfs_truncate_item(root, path, item_size, 1);
 		} else if (found_size < item_size) {
 			ret = btrfs_extend_item(trans, root, path,
 						item_size - found_size);

