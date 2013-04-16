Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35838 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3DPFSd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 01:18:33 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id C18A03EE0BD
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id ADDB445DE4D
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 96AA945DD78
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 87E39E08005
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 35E221DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from m1001.css.fujitsu.com (m1001 [127.0.0.1])
	by m1001.s.css.fujitsu.com (Postfix) with ESMTP id 0E7F4615AE
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:31 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by m1001.s.css.fujitsu.com (Postfix) with SMTP id D7CF9615D0
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 14:18:30 +0900 (JST)
Message-Id: <201304160518.AA00025@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 16 Apr 2013 14:18:22 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: cleanup of function where fixup_low_keys() is called
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If argument 'trans' is unnecessary in the function where
fixup_low_keys() is called, 'trans' is deleted.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c         | 28 ++++++++++++----------------
 fs/btrfs/ctree.h         | 10 +++-------
 fs/btrfs/delayed-inode.c | 11 +++++------
 fs/btrfs/dir-item.c      |  3 +--
 fs/btrfs/extent-tree.c   |  9 ++++-----
 fs/btrfs/file-item.c     | 11 +++++------
 fs/btrfs/file.c          |  8 ++++----
 fs/btrfs/inode-item.c    |  4 ++--
 fs/btrfs/inode.c         |  3 +--
 fs/btrfs/tree-log.c      |  4 ++--
 10 files changed, 39 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b5eec7c..76e11d7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -37,8 +37,8 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *dst_buf,
 			      struct extent_buffer *src_buf);
-static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct btrfs_path *path, int level, int slot);
+static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
+		    int level, int slot);
 static void tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb);
 struct extent_buffer *read_old_tree_block(struct btrfs_root *root, u64 bytenr,
@@ -1818,7 +1818,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (btrfs_header_nritems(right) == 0) {
 			clean_tree_block(trans, root, right);
 			btrfs_tree_unlock(right);
-			del_ptr(trans, root, path, level + 1, pslot + 1);
+			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1);
 			free_extent_buffer_stale(right);
@@ -1862,7 +1862,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (btrfs_header_nritems(mid) == 0) {
 		clean_tree_block(trans, root, mid);
 		btrfs_tree_unlock(mid);
-		del_ptr(trans, root, path, level + 1, pslot);
+		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1);
 		free_extent_buffer_stale(mid);
@@ -2927,8 +2927,7 @@ static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
  * This function isn't completely safe. It's the caller's responsibility
  * that the new key won't break the order
  */
-void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			     struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
@@ -4262,7 +4261,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 		return ret;
 
 	path->slots[0]++;
-	setup_items_for_insert(trans, root, path, new_key, &item_size,
+	setup_items_for_insert(root, path, new_key, &item_size,
 			       item_size, item_size +
 			       sizeof(struct btrfs_item), 1);
 	leaf = path->nodes[0];
@@ -4279,9 +4278,7 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
  * off the end of the item or if we shift the item to chop bytes off
  * the front.
  */
-void btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 struct btrfs_path *path,
+void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			 u32 new_size, int from_end)
 {
 	int slot;
@@ -4452,8 +4449,7 @@ void btrfs_extend_item(struct btrfs_trans_handle *trans,
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-void setup_items_for_insert(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *cpu_key, u32 *data_size,
 			    u32 total_data, u32 total_size, int nr)
 {
@@ -4569,7 +4565,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	setup_items_for_insert(trans, root, path, cpu_key, data_size,
+	setup_items_for_insert(root, path, cpu_key, data_size,
 			       total_data, total_size, nr);
 	return 0;
 }
@@ -4607,8 +4603,8 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
  * the tree should have been previously balanced so the deletion does not
  * empty a node.
  */
-static void del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		    struct btrfs_path *path, int level, int slot)
+static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
+		    int level, int slot)
 {
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
@@ -4661,7 +4657,7 @@ static noinline void btrfs_del_leaf(struct btrfs_trans_handle *trans,
 				    struct extent_buffer *leaf)
 {
 	WARN_ON(btrfs_header_generation(leaf) != trans->transid);
-	del_ptr(trans, root, path, 1, path->slots[1]);
+	del_ptr(root, path, 1, path->slots[1]);
 
 	/*
 	 * btrfs_free_extent is expensive, we want to make sure we
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d82922..7da1b74 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3161,8 +3161,7 @@ int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_previous_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid,
 			int type);
-void btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
@@ -3201,9 +3200,7 @@ int btrfs_block_can_be_shared(struct btrfs_root *root,
 void btrfs_extend_item(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct btrfs_path *path,
 		       u32 data_size);
-void btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
-			 struct btrfs_path *path,
+void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 			 u32 new_size, int from_end);
 int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
@@ -3243,8 +3240,7 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
-void setup_items_for_insert(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *cpu_key, u32 *data_size,
 			    u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 14fce27..71b78c2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -766,10 +766,9 @@ static void btrfs_delayed_inode_release_metadata(struct btrfs_root *root,
  * This helper will insert some continuous items into the same leaf according
  * to the free space of the leaf.
  */
-static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct btrfs_path *path,
-				struct btrfs_delayed_item *item)
+static int btrfs_batch_insert_items(struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct btrfs_delayed_item *item)
 {
 	struct btrfs_delayed_item *curr, *next;
 	int free_space;
@@ -848,7 +847,7 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	btrfs_clear_path_blocking(path, NULL, 0);
 
 	/* insert the keys of the items */
-	setup_items_for_insert(trans, root, path, keys, data_size,
+	setup_items_for_insert(root, path, keys, data_size,
 			       total_data_size, total_size, nitems);
 
 	/* insert the dir index items */
@@ -932,7 +931,7 @@ do_again:
 	if (curr && btrfs_is_continuous_delayed_item(prev, curr)) {
 		/* insert the continuous items into the same leaf */
 		path->slots[0]++;
-		btrfs_batch_insert_items(trans, root, path, curr);
+		btrfs_batch_insert_items(root, path, curr);
 	}
 	btrfs_release_delayed_item(prev);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 502c215..47cab8d 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -442,8 +442,7 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			item_len - (ptr + sub_item_len - start));
-		btrfs_truncate_item(trans, root, path,
-				    item_len - sub_item_len, 1);
+		btrfs_truncate_item(root, path, item_len - sub_item_len, 1);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d84787..d265625 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1683,8 +1683,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-void update_inline_extent_backref(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
+void update_inline_extent_backref(struct btrfs_root *root,
 				  struct btrfs_path *path,
 				  struct btrfs_extent_inline_ref *iref,
 				  int refs_to_mod,
@@ -1740,7 +1739,7 @@ void update_inline_extent_backref(struct btrfs_trans_handle *trans,
 			memmove_extent_buffer(leaf, ptr, ptr + size,
 					      end - ptr - size);
 		item_size -= size;
-		btrfs_truncate_item(trans, root, path, item_size, 1);
+		btrfs_truncate_item(root, path, item_size, 1);
 	}
 	btrfs_mark_buffer_dirty(leaf);
 }
@@ -1762,7 +1761,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		update_inline_extent_backref(trans, root, path, iref,
+		update_inline_extent_backref(root, path, iref,
 					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
 		setup_inline_extent_backref(trans, root, path, iref, parent,
@@ -1802,7 +1801,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		update_inline_extent_backref(trans, root, path, iref,
+		update_inline_extent_backref(root, path, iref,
 					     -refs_to_drop, NULL);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c4628a2..def004f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -518,8 +518,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
  * This calls btrfs_truncate_item with the correct args based on the
  * overlap, and fixes up the key as required.
  */
-static noinline void truncate_one_csum(struct btrfs_trans_handle *trans,
-				       struct btrfs_root *root,
+static noinline void truncate_one_csum(struct btrfs_root *root,
 				       struct btrfs_path *path,
 				       struct btrfs_key *key,
 				       u64 bytenr, u64 len)
@@ -544,7 +543,7 @@ static noinline void truncate_one_csum(struct btrfs_trans_handle *trans,
 		 */
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
-		btrfs_truncate_item(trans, root, path, new_size, 1);
+		btrfs_truncate_item(root, path, new_size, 1);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
 		/*
@@ -556,10 +555,10 @@ static noinline void truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (csum_end - end_byte) >> blocksize_bits;
 		new_size *= csum_size;
 
-		btrfs_truncate_item(trans, root, path, new_size, 0);
+		btrfs_truncate_item(root, path, new_size, 0);
 
 		key->offset = end_byte;
-		btrfs_set_item_key_safe(trans, root, path, key);
+		btrfs_set_item_key_safe(root, path, key);
 	} else {
 		BUG();
 	}
@@ -674,7 +673,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 			key.offset = end_byte - 1;
 		} else {
-			truncate_one_csum(trans, root, path, &key, bytenr, len);
+			truncate_one_csum(root, path, &key, bytenr, len);
 			if (key.offset < bytenr)
 				break;
 		}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1be25b9..784bed0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -821,7 +821,7 @@ next_slot:
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = end;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(root, path, &new_key);
 
 			extent_offset += end - key.offset;
 			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
@@ -1037,7 +1037,7 @@ again:
 				     ino, bytenr, orig_offset,
 				     &other_start, &other_end)) {
 			new_key.offset = end;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(root, path, &new_key);
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_generation(leaf, fi,
@@ -1071,7 +1071,7 @@ again:
 							 trans->transid);
 			path->slots[0]++;
 			new_key.offset = start;
-			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			btrfs_set_item_key_safe(root, path, &new_key);
 
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
@@ -1885,7 +1885,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 
 		path->slots[0]++;
 		key.offset = offset;
-		btrfs_set_item_key_safe(trans, root, path, &key);
+		btrfs_set_item_key_safe(root, path, &key);
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) + end -
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 48b8fda..cb44398 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -246,7 +246,7 @@ int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
 	memmove_extent_buffer(leaf, ptr, ptr + del_len,
 			      item_size - (ptr + del_len - item_start));
 
-	btrfs_truncate_item(trans, root, path, item_size - del_len, 1);
+	btrfs_truncate_item(root, path, item_size - del_len, 1);
 
 out:
 	btrfs_free_path(path);
@@ -309,7 +309,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			      item_size - (ptr + sub_item_len - item_start));
-	btrfs_truncate_item(trans, root, path, item_size - sub_item_len, 1);
+	btrfs_truncate_item(root, path, item_size - sub_item_len, 1);
 out:
 	btrfs_free_path(path);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b883815..bd6eea9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4175,8 +4175,7 @@ search_again:
 				}
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
-				btrfs_truncate_item(trans, root, path,
-						    size, 1);
+				btrfs_truncate_item(root, path, size, 1);
 			} else if (root->ref_cows) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ef96381..c2d55ed 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -408,7 +408,7 @@ insert:
 		found_size = btrfs_item_size_nr(path->nodes[0],
 						path->slots[0]);
 		if (found_size > item_size)
-			btrfs_truncate_item(trans, root, path, item_size, 1);
+			btrfs_truncate_item(root, path, item_size, 1);
 		else if (found_size < item_size)
 			btrfs_extend_item(trans, root, path,
 					  item_size - found_size);
@@ -3302,7 +3302,7 @@ static int drop_adjacent_extents(struct btrfs_trans_handle *trans,
 		BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
 		memcpy(&new_key, &key, sizeof(new_key));
 		new_key.offset = em->start + em->len;
-		btrfs_set_item_key_safe(trans, root, path, &new_key);
+		btrfs_set_item_key_safe(root, path, &new_key);
 		extent_offset += em->start + em->len - key.offset;
 		btrfs_set_token_file_extent_offset(leaf, fi, extent_offset,
 						   &token);
-- 
1.7.12.2

