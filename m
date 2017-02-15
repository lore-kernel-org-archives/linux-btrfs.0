Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbdBOV2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:41 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58E99AD71
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:40 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/8] btrfs: pass fs_info to (more) routines that are only called with extent_root
Date: Wed, 15 Feb 2017 16:28:27 -0500
Message-Id: <1487194114-12786-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Outside of interactions with qgroups, the roots passed in extent-tree.c
are usually passed to ensure that we don't do refcounts on log trees or
to get the allocation profile for an allocation request.  Otherwise, it
operates on the extent root.  This patch converts some more routines in
extent-tree.c that are always called with the extent root to accept
an fs_info instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 103 +++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dcd2e79..d4c0f8a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1035,10 +1035,11 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
+				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_path *path,
 				  u64 owner, u32 extra_size)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_extent_item *item;
 	struct btrfs_extent_item_v0 *ei0;
 	struct btrfs_extent_ref_v0 *ref0;
@@ -1092,7 +1093,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 		return ret;
 	BUG_ON(ret); /* Corruption */
 
-	btrfs_extend_item(root->fs_info, path, new_size);
+	btrfs_extend_item(fs_info, path, new_size);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1151,12 +1152,13 @@ static int match_extent_data_ref(struct extent_buffer *leaf,
 }
 
 static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
-					   struct btrfs_root *root,
+					   struct btrfs_fs_info *fs_info,
 					   struct btrfs_path *path,
 					   u64 bytenr, u64 parent,
 					   u64 root_objectid,
 					   u64 owner, u64 offset)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_key key;
 	struct btrfs_extent_data_ref *ref;
 	struct extent_buffer *leaf;
@@ -1238,12 +1240,13 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
-					   struct btrfs_root *root,
+					   struct btrfs_fs_info *fs_info,
 					   struct btrfs_path *path,
 					   u64 bytenr, u64 parent,
 					   u64 root_objectid, u64 owner,
 					   u64 offset, int refs_to_add)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	u32 size;
@@ -1317,7 +1320,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
-					   struct btrfs_root *root,
+					   struct btrfs_fs_info *fs_info,
 					   struct btrfs_path *path,
 					   int refs_to_drop, int *last_ref)
 {
@@ -1354,7 +1357,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 	num_refs -= refs_to_drop;
 
 	if (num_refs == 0) {
-		ret = btrfs_del_item(trans, root, path);
+		ret = btrfs_del_item(trans, fs_info->extent_root, path);
 		*last_ref = 1;
 	} else {
 		if (key.type == BTRFS_EXTENT_DATA_REF_KEY)
@@ -1416,11 +1419,12 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 }
 
 static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
+					  struct btrfs_fs_info *fs_info,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 root_objectid)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_key key;
 	int ret;
 
@@ -1449,7 +1453,7 @@ static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
 }
 
 static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
-					  struct btrfs_root *root,
+					  struct btrfs_fs_info *fs_info,
 					  struct btrfs_path *path,
 					  u64 bytenr, u64 parent,
 					  u64 root_objectid)
@@ -1466,7 +1470,8 @@ static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
 		key.offset = root_objectid;
 	}
 
-	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	ret = btrfs_insert_empty_item(trans, fs_info->extent_root,
+				      path, &key, 0);
 	btrfs_release_path(path);
 	return ret;
 }
@@ -1524,14 +1529,14 @@ static int find_next_key(struct btrfs_path *path, int level,
  */
 static noinline_for_stack
 int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref **ref_ret,
 				 u64 bytenr, u64 num_bytes,
 				 u64 parent, u64 root_objectid,
 				 u64 owner, u64 offset, int insert)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -1614,7 +1619,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 			err = -ENOENT;
 			goto out;
 		}
-		ret = convert_extent_item_v0(trans, root, path, owner,
+		ret = convert_extent_item_v0(trans, fs_info, path, owner,
 					     extra_size);
 		if (ret < 0) {
 			err = ret;
@@ -1716,7 +1721,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
  * helper to add new inline back ref
  */
 static noinline_for_stack
-void setup_inline_extent_backref(struct btrfs_root *root,
+void setup_inline_extent_backref(struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
 				 u64 parent, u64 root_objectid,
@@ -1739,7 +1744,7 @@ void setup_inline_extent_backref(struct btrfs_root *root,
 	type = extent_ref_type(parent, owner);
 	size = btrfs_extent_inline_ref_size(type);
 
-	btrfs_extend_item(root->fs_info, path, size);
+	btrfs_extend_item(fs_info, path, size);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
@@ -1777,7 +1782,7 @@ void setup_inline_extent_backref(struct btrfs_root *root,
 }
 
 static int lookup_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref **ref_ret,
 				 u64 bytenr, u64 num_bytes, u64 parent,
@@ -1785,7 +1790,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	ret = lookup_inline_extent_backref(trans, root, path, ref_ret,
+	ret = lookup_inline_extent_backref(trans, fs_info, path, ref_ret,
 					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset, 0);
 	if (ret != -ENOENT)
@@ -1795,11 +1800,12 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 	*ref_ret = NULL;
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = lookup_tree_block_ref(trans, root, path, bytenr, parent,
-					    root_objectid);
+		ret = lookup_tree_block_ref(trans, fs_info, path, bytenr,
+					    parent, root_objectid);
 	} else {
-		ret = lookup_extent_data_ref(trans, root, path, bytenr, parent,
-					     root_objectid, owner, offset);
+		ret = lookup_extent_data_ref(trans, fs_info, path, bytenr,
+					     parent, root_objectid, owner,
+					     offset);
 	}
 	return ret;
 }
@@ -1808,7 +1814,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-void update_inline_extent_backref(struct btrfs_root *root,
+void update_inline_extent_backref(struct btrfs_fs_info *fs_info,
 				  struct btrfs_path *path,
 				  struct btrfs_extent_inline_ref *iref,
 				  int refs_to_mod,
@@ -1866,14 +1872,14 @@ void update_inline_extent_backref(struct btrfs_root *root,
 			memmove_extent_buffer(leaf, ptr, ptr + size,
 					      end - ptr - size);
 		item_size -= size;
-		btrfs_truncate_item(root->fs_info, path, item_size, 1);
+		btrfs_truncate_item(fs_info, path, item_size, 1);
 	}
 	btrfs_mark_buffer_dirty(leaf);
 }
 
 static noinline_for_stack
 int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 u64 bytenr, u64 num_bytes, u64 parent,
 				 u64 root_objectid, u64 owner,
@@ -1883,15 +1889,15 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	int ret;
 
-	ret = lookup_inline_extent_backref(trans, root, path, &iref,
+	ret = lookup_inline_extent_backref(trans, fs_info, path, &iref,
 					   bytenr, num_bytes, parent,
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		update_inline_extent_backref(root, path, iref,
+		update_inline_extent_backref(fs_info, path, iref,
 					     refs_to_add, extent_op, NULL);
 	} else if (ret == -ENOENT) {
-		setup_inline_extent_backref(root, path, iref, parent,
+		setup_inline_extent_backref(fs_info, path, iref, parent,
 					    root_objectid, owner, offset,
 					    refs_to_add, extent_op);
 		ret = 0;
@@ -1900,7 +1906,7 @@ int insert_inline_extent_backref(struct btrfs_trans_handle *trans,
 }
 
 static int insert_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 u64 bytenr, u64 parent, u64 root_objectid,
 				 u64 owner, u64 offset, int refs_to_add)
@@ -1908,10 +1914,10 @@ static int insert_extent_backref(struct btrfs_trans_handle *trans,
 	int ret;
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		BUG_ON(refs_to_add != 1);
-		ret = insert_tree_block_ref(trans, root, path, bytenr,
+		ret = insert_tree_block_ref(trans, fs_info, path, bytenr,
 					    parent, root_objectid);
 	} else {
-		ret = insert_extent_data_ref(trans, root, path, bytenr,
+		ret = insert_extent_data_ref(trans, fs_info, path, bytenr,
 					     parent, root_objectid,
 					     owner, offset, refs_to_add);
 	}
@@ -1919,7 +1925,7 @@ static int insert_extent_backref(struct btrfs_trans_handle *trans,
 }
 
 static int remove_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
+				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path,
 				 struct btrfs_extent_inline_ref *iref,
 				 int refs_to_drop, int is_data, int *last_ref)
@@ -1928,14 +1934,14 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		update_inline_extent_backref(root, path, iref,
+		update_inline_extent_backref(fs_info, path, iref,
 					     -refs_to_drop, NULL, last_ref);
 	} else if (is_data) {
-		ret = remove_extent_data_ref(trans, root, path, refs_to_drop,
+		ret = remove_extent_data_ref(trans, fs_info, path, refs_to_drop,
 					     last_ref);
 	} else {
 		*last_ref = 1;
-		ret = btrfs_del_item(trans, root, path);
+		ret = btrfs_del_item(trans, fs_info->extent_root, path);
 	}
 	return ret;
 }
@@ -2117,9 +2123,9 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* this will setup the path even if it fails to insert the back ref */
-	ret = insert_inline_extent_backref(trans, fs_info->extent_root, path,
-					   bytenr, num_bytes, parent,
-					   root_objectid, owner, offset,
+	ret = insert_inline_extent_backref(trans, fs_info, path, bytenr,
+					   num_bytes, parent, root_objectid,
+					   owner, offset,
 					   refs_to_add, extent_op);
 	if ((ret < 0 && ret != -EAGAIN) || !ret)
 		goto out;
@@ -2143,9 +2149,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	path->reada = READA_FORWARD;
 	path->leave_spinning = 1;
 	/* now insert the actual backref */
-	ret = insert_extent_backref(trans, fs_info->extent_root,
-				    path, bytenr, parent, root_objectid,
-				    owner, offset, refs_to_add);
+	ret = insert_extent_backref(trans, fs_info, path, bytenr, parent,
+				    root_objectid, owner, offset, refs_to_add);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 out:
@@ -2290,8 +2295,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (item_size < sizeof(*ei)) {
-		ret = convert_extent_item_v0(trans, fs_info->extent_root,
-					     path, (u64)-1, 0);
+		ret = convert_extent_item_v0(trans, fs_info, path, (u64)-1, 0);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -6845,7 +6849,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (is_data)
 		skinny_metadata = 0;
 
-	ret = lookup_extent_backref(trans, extent_root, path, &iref,
+	ret = lookup_extent_backref(trans, info, path, &iref,
 				    bytenr, num_bytes, parent,
 				    root_objectid, owner_objectid,
 				    owner_offset);
@@ -6877,8 +6881,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 #endif
 		if (!found_extent) {
 			BUG_ON(iref);
-			ret = remove_extent_backref(trans, extent_root, path,
-						    NULL, refs_to_drop,
+			ret = remove_extent_backref(trans, info, path, NULL,
+						    refs_to_drop,
 						    is_data, &last_ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
@@ -6953,8 +6957,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (item_size < sizeof(*ei)) {
 		BUG_ON(found_extent || extent_slot != path->slots[0]);
-		ret = convert_extent_item_v0(trans, extent_root, path,
-					     owner_objectid, 0);
+		ret = convert_extent_item_v0(trans, info, path, owner_objectid,
+					     0);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
@@ -7021,7 +7025,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 		}
 		if (found_extent) {
-			ret = remove_extent_backref(trans, extent_root, path,
+			ret = remove_extent_backref(trans, info, path,
 						    iref, refs_to_drop,
 						    is_data, &last_ref);
 			if (ret) {
@@ -7419,12 +7423,11 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
  * If there is no suitable free space, we will record the max size of
  * the free space extent currently.
  */
-static noinline int find_free_extent(struct btrfs_root *orig_root,
+static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				u64 ram_bytes, u64 num_bytes, u64 empty_size,
 				u64 hint_byte, struct btrfs_key *ins,
 				u64 flags, int delalloc)
 {
-	struct btrfs_fs_info *fs_info = orig_root->fs_info;
 	int ret = 0;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
@@ -7951,7 +7954,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	flags = btrfs_get_alloc_profile(root, is_data);
 again:
 	WARN_ON(num_bytes < fs_info->sectorsize);
-	ret = find_free_extent(root, ram_bytes, num_bytes, empty_size,
+	ret = find_free_extent(fs_info, ram_bytes, num_bytes, empty_size,
 			       hint_byte, ins, flags, delalloc);
 	if (!ret && !is_data) {
 		btrfs_dec_block_group_reservations(fs_info, ins->objectid);
-- 
2.7.1

