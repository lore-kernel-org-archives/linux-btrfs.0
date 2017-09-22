Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40138 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdIVR6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 13:58:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: add a flag to iterate_inodes_from_logical to find all extent refs for uncompressed extents
Date: Fri, 22 Sep 2017 13:58:45 -0400
Message-Id: <20170922175847.6071-2-ce3g8jdj@umail.furryterror.org>
In-Reply-To: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
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
 fs/btrfs/backref.c            | 63 ++++++++++++++++++++++++++-----------------
 fs/btrfs/backref.h            |  8 +++---
 fs/btrfs/inode.c              |  2 +-
 fs/btrfs/ioctl.c              |  2 +-
 fs/btrfs/qgroup.c             |  8 +++---
 fs/btrfs/scrub.c              |  6 ++---
 fs/btrfs/send.c               |  2 +-
 fs/btrfs/tests/qgroup-tests.c | 20 +++++++-------
 8 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b517ef1477ea..a2609786cd86 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -40,12 +40,14 @@ static int check_extent_in_eb(const struct btrfs_key *key,
 			      const struct extent_buffer *eb,
 			      const struct btrfs_file_extent_item *fi,
 			      u64 extent_item_pos,
-			      struct extent_inode_elem **eie)
+			      struct extent_inode_elem **eie,
+			      bool ignore_offset)
 {
 	u64 offset = 0;
 	struct extent_inode_elem *e;
 
-	if (!btrfs_file_extent_compression(eb, fi) &&
+	if (!ignore_offset &&
+	    !btrfs_file_extent_compression(eb, fi) &&
 	    !btrfs_file_extent_encryption(eb, fi) &&
 	    !btrfs_file_extent_other_encoding(eb, fi)) {
 		u64 data_offset;
@@ -84,7 +86,8 @@ static void free_inode_elem_list(struct extent_inode_elem *eie)
 
 static int find_extent_in_eb(const struct extent_buffer *eb,
 			     u64 wanted_disk_byte, u64 extent_item_pos,
-			     struct extent_inode_elem **eie)
+			     struct extent_inode_elem **eie,
+			     bool ignore_offset)
 {
 	u64 disk_byte;
 	struct btrfs_key key;
@@ -113,7 +116,7 @@ static int find_extent_in_eb(const struct extent_buffer *eb,
 		if (disk_byte != wanted_disk_byte)
 			continue;
 
-		ret = check_extent_in_eb(&key, eb, fi, extent_item_pos, eie);
+		ret = check_extent_in_eb(&key, eb, fi, extent_item_pos, eie, ignore_offset);
 		if (ret < 0)
 			return ret;
 	}
@@ -419,7 +422,7 @@ static int add_indirect_ref(const struct btrfs_fs_info *fs_info,
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			   struct ulist *parents, struct prelim_ref *ref,
 			   int level, u64 time_seq, const u64 *extent_item_pos,
-			   u64 total_refs)
+			   u64 total_refs, bool ignore_offset)
 {
 	int ret = 0;
 	int slot;
@@ -472,7 +475,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			if (extent_item_pos) {
 				ret = check_extent_in_eb(&key, eb, fi,
 						*extent_item_pos,
-						&eie);
+						&eie, ignore_offset);
 				if (ret < 0)
 					break;
 			}
@@ -510,7 +513,8 @@ next:
 static int resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path, u64 time_seq,
 				struct prelim_ref *ref, struct ulist *parents,
-				const u64 *extent_item_pos, u64 total_refs)
+				const u64 *extent_item_pos, u64 total_refs,
+				bool ignore_offset)
 {
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
@@ -581,7 +585,7 @@ static int resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = add_all_parents(root, path, parents, ref, level, time_seq,
-			      extent_item_pos, total_refs);
+			      extent_item_pos, total_refs, ignore_offset);
 out:
 	path->lowest_level = 0;
 	btrfs_release_path(path);
@@ -616,7 +620,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				 struct btrfs_path *path, u64 time_seq,
 				 struct preftrees *preftrees,
 				 const u64 *extent_item_pos, u64 total_refs,
-				 struct share_check *sc)
+				 struct share_check *sc, bool ignore_offset)
 {
 	int err;
 	int ret = 0;
@@ -661,7 +665,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		}
 		err = resolve_indirect_ref(fs_info, path, time_seq, ref,
 					   parents, extent_item_pos,
-					   total_refs);
+					   total_refs, ignore_offset);
 		/*
 		 * we can only tolerate ENOENT,otherwise,we should catch error
 		 * and return directly.
@@ -1107,13 +1111,17 @@ static int add_keyed_refs(struct btrfs_fs_info *fs_info,
  *
  * Otherwise this returns 0 for success and <0 for an error.
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
-			     struct share_check *sc)
+			     struct share_check *sc, bool ignore_offset)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -1235,7 +1243,7 @@ again:
 	WARN_ON(!RB_EMPTY_ROOT(&preftrees.indirect_missing_keys.root));
 
 	ret = resolve_indirect_refs(fs_info, path, time_seq, &preftrees,
-				    extent_item_pos, total_refs, sc);
+				    extent_item_pos, total_refs, sc, ignore_offset);
 	if (ret)
 		goto out;
 
@@ -1282,7 +1290,7 @@ again:
 				btrfs_tree_read_lock(eb);
 				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
-							*extent_item_pos, &eie);
+							*extent_item_pos, &eie, ignore_offset);
 				btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
@@ -1350,7 +1358,7 @@ static void free_leaf_list(struct ulist *blocks)
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
 				u64 time_seq, struct ulist **leafs,
-				const u64 *extent_item_pos)
+				const u64 *extent_item_pos, bool ignore_offset)
 {
 	int ret;
 
@@ -1359,7 +1367,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-				*leafs, NULL, extent_item_pos, NULL);
+				*leafs, NULL, extent_item_pos, NULL, ignore_offset);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
@@ -1383,7 +1391,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 static int btrfs_find_all_roots_safe(struct btrfs_trans_handle *trans,
 				     struct btrfs_fs_info *fs_info, u64 bytenr,
-				     u64 time_seq, struct ulist **roots)
+				     u64 time_seq, struct ulist **roots,
+				     bool ignore_offset)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1402,7 +1411,7 @@ static int btrfs_find_all_roots_safe(struct btrfs_trans_handle *trans,
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, time_seq,
-					tmp, *roots, NULL, NULL);
+					tmp, *roots, NULL, NULL, ignore_offset);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1421,14 +1430,15 @@ static int btrfs_find_all_roots_safe(struct btrfs_trans_handle *trans,
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 time_seq, struct ulist **roots)
+			 u64 time_seq, struct ulist **roots,
+			 bool ignore_offset)
 {
 	int ret;
 
 	if (!trans)
 		down_read(&fs_info->commit_root_sem);
 	ret = btrfs_find_all_roots_safe(trans, fs_info, bytenr,
-					time_seq, roots);
+					time_seq, roots, ignore_offset);
 	if (!trans)
 		up_read(&fs_info->commit_root_sem);
 	return ret;
@@ -1483,7 +1493,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, elem.seq, tmp,
-					roots, NULL, &shared);
+					roots, NULL, &shared, false);
 		if (ret == BACKREF_FOUND_SHARED) {
 			/* this is the only condition under which we return 1 */
 			ret = 1;
@@ -1877,7 +1887,8 @@ static int iterate_leaf_refs(struct btrfs_fs_info *fs_info,
 int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				u64 extent_item_objectid, u64 extent_item_pos,
 				int search_commit_root,
-				iterate_extent_inodes_t *iterate, void *ctx)
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset)
 {
 	int ret;
 	struct btrfs_trans_handle *trans = NULL;
@@ -1903,14 +1914,15 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
 				   tree_mod_seq_elem.seq, &refs,
-				   &extent_item_pos);
+				   &extent_item_pos, ignore_offset);
 	if (ret)
 		goto out;
 
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots_safe(trans, fs_info, ref_node->val,
-						tree_mod_seq_elem.seq, &roots);
+						tree_mod_seq_elem.seq, &roots,
+						ignore_offset);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
@@ -1943,7 +1955,8 @@ out:
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx)
+				iterate_extent_inodes_t *iterate, void *ctx,
+				bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -1961,7 +1974,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx);
+					iterate, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index e410335841aa..0c2fab8514ff 100644
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
index 128f3e58634f..d9aef54e2186 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2452,7 +2452,7 @@ static noinline bool record_extent_backrefs(struct btrfs_path *path,
 		ret = iterate_inodes_from_logical(old->bytenr +
 						  old->extent_offset, fs_info,
 						  path, record_one_backref,
-						  old);
+						  old, false);
 		if (ret < 0 && ret != -ENOENT)
 			return false;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d6715c2bcdc4..b7de32568082 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4566,7 +4566,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes);
+					  build_ino_list, inodes, false);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5c8b61c86e61..6408af8c8fd6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1441,7 +1441,7 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	u64 bytenr = qrecord->bytenr;
 	int ret;
 
-	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root);
+	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
 	if (ret < 0)
 		return ret;
 
@@ -2031,7 +2031,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 				/* Search commit root to find old_roots */
 				ret = btrfs_find_all_roots(NULL, fs_info,
 						record->bytenr, 0,
-						&record->old_roots);
+						&record->old_roots, false);
 				if (ret < 0)
 					goto cleanup;
 			}
@@ -2042,7 +2042,7 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 			 * root. It's safe inside commit_transaction().
 			 */
 			ret = btrfs_find_all_roots(trans, fs_info,
-					record->bytenr, SEQ_LAST, &new_roots);
+					record->bytenr, SEQ_LAST, &new_roots, false);
 			if (ret < 0)
 				goto cleanup;
 			if (qgroup_to_skip) {
@@ -2572,7 +2572,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			num_bytes = found.offset;
 
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
-					   &roots);
+					   &roots, false);
 		if (ret < 0)
 			goto out;
 		/* For rescan, just pass old_roots as NULL */
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3f6c49e5c4d..40153d83ad9a 100644
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
@@ -4390,7 +4390,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	}
 
 	ret = iterate_inodes_from_logical(logical, fs_info, path,
-					  record_inode_for_nocow, nocow_ctx);
+					  record_inode_for_nocow, nocow_ctx, false);
 	if (ret != 0 && ret != -ENOENT) {
 		btrfs_warn(fs_info,
 			   "iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d",
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 32b043ef8ac9..1e211255b1c6 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1429,7 +1429,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 		extent_item_pos = 0;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 				    extent_item_pos, 1, __iterate_backrefs,
-				    backref_ctx);
+				    backref_ctx, false);
 
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 0f4ce970d195..49f010f42bb7 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -240,7 +240,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	 * we can only call btrfs_qgroup_account_extent() directly to test
 	 * quota.
 	 */
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
@@ -252,7 +252,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -275,7 +275,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	old_roots = NULL;
 	new_roots = NULL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
@@ -286,7 +286,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	if (ret)
 		return -EINVAL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -337,7 +337,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
@@ -349,7 +349,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -370,7 +370,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
@@ -382,7 +382,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -409,7 +409,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
@@ -421,7 +421,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
-- 
2.11.0

