Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33376 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdIUAmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 20:42:38 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: add a flag to iterate_inodes_from_logical to find all extent refs for uncompressed extents
Date: Wed, 20 Sep 2017 20:33:31 -0400
Message-Id: <20170921003333.12467-1-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The LOGICAL_INO ioctl provides a backward mapping from extent bytenr and
offset (encoded as a single logical address) to a list of extent refs.
LOGICAL_INO complements TREE_SEARCH, which provides the forward mapping
(extent ref -> extent bytenr and offset, or logical address).  These are
useful capabilities for programs that manipulate extents and extent
references from userspace (e.g. dedup and defrag utilities).

When the extents are uncompressed (and not encrypted and not other),
check_extent_in_eb performs filtering of the extent refs to remove any
extent refs which do not contain the same extent offset as the 'logical'
parameter's extent offset.  This prevents LOGICAL_INO from returning
references to more than a single block.

To find the set of extent references to an uncompressed extent from [a,
b), userspace has to run a loop like this pseudocode:

	for (i = a; i < b; ++i)
		extent_ref_set += LOGICAL_INO(i);

At each iteration of the loop (up to 32768 iterations for a 128M extent),
data we are interested in is collected in the kernel, then deleted by
the filter in check_extent_in_eb.

When the extents are compressed (or encrypted or other), the 'logical'
parameter must be an extent bytenr (the 'a' parameter in the loop).
No filtering by extent offset is done (or possible?) so the result is
the complete set of extent refs for the entire extent.  This removes
the need for the loop, since we get all the extent refs in one call.

Add an 'ignore_offset' argument to iterate_inodes_from_logical,
[...several levels of function call graph...], and check_extent_in_eb, so
that we can disable the extent offset filtering for uncompressed extents.
This flag can be set by an improved version of the LOGICAL_INO ioctl to
get either behavior as desired.

There is no functional change in this patch.  The new flag is always
false.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 fs/btrfs/backref.c | 62 ++++++++++++++++++++++++++++++++----------------------
 fs/btrfs/backref.h |  8 ++++---
 fs/btrfs/inode.c   |  2 +-
 fs/btrfs/ioctl.c   |  2 +-
 fs/btrfs/qgroup.c  |  8 +++----
 fs/btrfs/scrub.c   |  6 +++---
 fs/btrfs/send.c    |  2 +-
 7 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1d71a5a4b1b9..3bffd36c6897 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -302,12 +302,14 @@ static int ref_tree_add(struct ref_root *ref_tree, u64 root_id, u64 object_id,
 static int check_extent_in_eb(struct btrfs_key *key, struct extent_buffer *eb,
 				struct btrfs_file_extent_item *fi,
 				u64 extent_item_pos,
-				struct extent_inode_elem **eie)
+				struct extent_inode_elem **eie,
+				bool ignore_offset)
 {
 	u64 offset = 0;
 	struct extent_inode_elem *e;
 
-	if (!btrfs_file_extent_compression(eb, fi) &&
+	if (!ignore_offset &&
+	    !btrfs_file_extent_compression(eb, fi) &&
 	    !btrfs_file_extent_encryption(eb, fi) &&
 	    !btrfs_file_extent_other_encoding(eb, fi)) {
 		u64 data_offset;
@@ -346,7 +348,8 @@ static void free_inode_elem_list(struct extent_inode_elem *eie)
 
 static int find_extent_in_eb(struct extent_buffer *eb, u64 wanted_disk_byte,
 				u64 extent_item_pos,
-				struct extent_inode_elem **eie)
+				struct extent_inode_elem **eie,
+				bool ignore_offset)
 {
 	u64 disk_byte;
 	struct btrfs_key key;
@@ -375,7 +378,7 @@ static int find_extent_in_eb(struct extent_buffer *eb, u64 wanted_disk_byte,
 		if (disk_byte != wanted_disk_byte)
 			continue;
 
-		ret = check_extent_in_eb(&key, eb, fi, extent_item_pos, eie);
+		ret = check_extent_in_eb(&key, eb, fi, extent_item_pos, eie, ignore_offset);
 		if (ret < 0)
 			return ret;
 	}
@@ -511,7 +514,7 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			   struct ulist *parents, struct __prelim_ref *ref,
 			   int level, u64 time_seq, const u64 *extent_item_pos,
-			   u64 total_refs)
+			   u64 total_refs, bool ignore_offset)
 {
 	int ret = 0;
 	int slot;
@@ -564,7 +567,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			if (extent_item_pos) {
 				ret = check_extent_in_eb(&key, eb, fi,
 						*extent_item_pos,
-						&eie);
+						&eie, ignore_offset);
 				if (ret < 0)
 					break;
 			}
@@ -603,7 +606,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 				  struct btrfs_path *path, u64 time_seq,
 				  struct __prelim_ref *ref,
 				  struct ulist *parents,
-				  const u64 *extent_item_pos, u64 total_refs)
+				  const u64 *extent_item_pos, u64 total_refs,
+				  bool ignore_offset)
 {
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
@@ -674,7 +678,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = add_all_parents(root, path, parents, ref, level, time_seq,
-			      extent_item_pos, total_refs);
+			      extent_item_pos, total_refs, ignore_offset);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
@@ -688,7 +692,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				   struct btrfs_path *path, u64 time_seq,
 				   struct list_head *head,
 				   const u64 *extent_item_pos, u64 total_refs,
-				   u64 root_objectid)
+				   u64 root_objectid, bool ignore_offset)
 {
 	int err;
 	int ret = 0;
@@ -719,7 +723,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 		err = __resolve_indirect_ref(fs_info, path, time_seq, ref,
 					     parents, extent_item_pos,
-					     total_refs);
+					     total_refs, ignore_offset);
 		/*
 		 * we can only tolerate ENOENT,otherwise,we should catch error
 		 * and return directly.
@@ -1209,13 +1213,18 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  * If check_shared is set to 1, any extent has more than one ref item, will
  * be returned BACKREF_FOUND_SHARED immediately.
  *
+ * If ignore_offset is set to false, only extent refs whose offsets match
+ * extent_item_pos are returned.  If true, every extent ref is returned
+ * and extent_item_pos is ignored.
+ *
  * FIXME some caching might speed things up
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
 			     u64 time_seq, struct ulist *refs,
 			     struct ulist *roots, const u64 *extent_item_pos,
-			     u64 root_objectid, u64 inum, int check_shared)
+			     u64 root_objectid, u64 inum, int check_shared,
+			     bool ignore_offset)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -1383,7 +1392,7 @@ again:
 
 	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
 				      extent_item_pos, total_refs,
-				      root_objectid);
+				      root_objectid, ignore_offset);
 	if (ret)
 		goto out;
 
@@ -1420,7 +1429,7 @@ again:
 				btrfs_tree_read_lock(eb);
 				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
-							*extent_item_pos, &eie);
+							*extent_item_pos, &eie, ignore_offset);
 				btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
@@ -1497,7 +1506,7 @@ static void free_leaf_list(struct ulist *blocks)
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
 				u64 time_seq, struct ulist **leafs,
-				const u64 *extent_item_pos)
+				const u64 *extent_item_pos, bool ignore_offset)
 {
 	int ret;
 
@@ -1506,7 +1515,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-				*leafs, NULL, extent_item_pos, 0, 0, 0);
+				*leafs, NULL, extent_item_pos, 0, 0, 0, ignore_offset);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
@@ -1530,7 +1539,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info, u64 bytenr,
-				  u64 time_seq, struct ulist **roots)
+				  u64 time_seq, struct ulist **roots, bool ignore_offset)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1549,7 +1558,7 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-					tmp, *roots, NULL, 0, 0, 0);
+					tmp, *roots, NULL, 0, 0, 0, ignore_offset);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1568,13 +1577,14 @@ static int __btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots)
+			 u64 time_seq, struct ulist **roots,
+			 bool ignore_offset)
 {
 	int ret;
 
 	if (!trans)
 		down_read(&fs_info->commit_root_sem);
-	ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots);
+	ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots, ignore_offset);
 	if (!trans)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
@@ -1619,7 +1629,7 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
-					roots, NULL, root_objectid, inum, 1);
+					roots, NULL, root_objectid, inum, 1, false);
 		if (ret == BACKREF_FOUND_SHARED) {
 			/* this is the only condition under which we return 1 */
 			ret = 1;
@@ -2005,7 +2015,8 @@ static int iterate_leaf_refs(struct btrfs_fs_info *fs_info,
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid, u64 extent_item_pos,
 				int search_commit_root,
-				iterate_extent_inodes_t *iterate, void *ctx)
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset)
 {
 	int ret;
 	struct btrfs_trans_handle *trans = NULL;
@@ -2031,14 +2042,14 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
 				   tree_mod_seq_elem.seq, &refs,
-				   &extent_item_pos);
+				   &extent_item_pos, ignore_offset);
 	if (ret)
 		goto out;
 
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = __btrfs_find_all_roots(trans, fs_info, ref_node->val,
-					     tree_mod_seq_elem.seq, &roots);
+					     tree_mod_seq_elem.seq, &roots, ignore_offset);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
@@ -2071,7 +2082,8 @@ out:
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx)
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -2089,7 +2101,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx);
+					iterate, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 9c41fbac3009..9c9f5e9d7a89 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -43,17 +43,19 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid,
 				u64 extent_offset, int search_commit_root,
-				iterate_extent_inodes_t *iterate, void *ctx);
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx);
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots);
+			 u64 time_seq, struct ulist **roots, bool ignore_offset);
 char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 			u32 name_len, unsigned long name_off,
 			struct extent_buffer *eb_in, u64 parent,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 275366621ac6..9dcb5a2451bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2438,7 +2438,7 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 		ret = iterate_inodes_from_logical(old->bytenr +
 						  old->extent_offset, fs_info,
 						  path, record_one_backref,
-						  old);
+						  old, false);
 		if (ret < 0 && ret != -ENOENT)
 			return false;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8825ae54c968..c6787660d91f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4572,7 +4572,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes);
+					  build_ino_list, inodes, false);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deffbeb74a0b..8c6c423f76c0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1428,7 +1428,7 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 				  node);
 		if (WARN_ON(!record->old_roots))
 			ret = btrfs_find_all_roots(NULL, fs_info,
-					record->bytenr, 0, &record->old_roots);
+					record->bytenr, 0, &record->old_roots, false);
 		if (ret < 0)
 			break;
 		if (qgroup_to_skip)
@@ -1474,7 +1474,7 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	u64 bytenr = qrecord->bytenr;
 	int ret;
 
-	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root);
+	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
 	if (ret < 0)
 		return ret;
 
@@ -2022,7 +2022,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 			 * root. It's safe inside commit_transaction().
 			 */
 			ret = btrfs_find_all_roots(trans, fs_info,
-					record->bytenr, SEQ_LAST, &new_roots);
+					record->bytenr, SEQ_LAST, &new_roots, false);
 			if (ret < 0)
 				goto cleanup;
 			if (qgroup_to_skip)
@@ -2544,7 +2544,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			num_bytes = found.offset;
 
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
-					   &roots);
+					   &roots, false);
 		if (ret < 0)
 			goto out;
 		/* For rescan, just pass old_roots as NULL */
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c7b45eb2403d..cc1fc17b7a50 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -883,7 +883,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 		swarn.dev = dev;
 		iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, 1,
-					scrub_print_warning_inode, &swarn);
+					scrub_print_warning_inode, &swarn, false);
 	}
 
 out:
@@ -1047,7 +1047,7 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 	 * can be found.
 	 */
 	ret = iterate_inodes_from_logical(fixup->logical, fs_info, path,
-					  scrub_fixup_readpage, fixup);
+					  scrub_fixup_readpage, fixup, false);
 	if (ret < 0) {
 		uncorrectable = 1;
 		goto out;
@@ -4442,7 +4442,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	}
 
 	ret = iterate_inodes_from_logical(logical, fs_info, path,
-					  record_inode_for_nocow, nocow_ctx);
+					  record_inode_for_nocow, nocow_ctx, false);
 	if (ret != 0 && ret != -ENOENT) {
 		btrfs_warn(fs_info,
 			   "iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d",
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 641017b68d02..85e23a06c1a3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1433,7 +1433,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 		extent_item_pos = 0;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 				    extent_item_pos, 1, __iterate_backrefs,
-				    backref_ctx);
+				    backref_ctx, false);
 
 	if (ret < 0)
 		goto out;
-- 
2.11.0

