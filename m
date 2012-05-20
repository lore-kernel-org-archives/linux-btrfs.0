Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33907 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 10/24] Btrfs: use the tree modification log for backref resolving
Date: Sun, 20 May 2012 18:06:21 +0200
Message-Id: <93d6e0d92c054e597050f443a71e1f1e83bc38a3.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This enables backref resolving on life trees while they are changing. This
is a prerequisite for quota groups and just nice to have for everything
else.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   43 +++++++++++++++++++++++++++----------------
 fs/btrfs/backref.h |    3 ++-
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e6c54d8..b63c2c5 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -241,6 +241,7 @@ add_parent:
  */
 static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 					int search_commit_root,
+					u64 time_seq,
 					struct __prelim_ref *ref,
 					struct ulist *parents,
 					const u64 *extent_item_pos)
@@ -276,7 +277,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	path->lowest_level = level;
-	ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path, 0, 0);
+	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
 	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
 		 "%d for key (%llu %u %llu)\n",
 		 (unsigned long long)ref->root_id, level, ref->count, ret,
@@ -315,7 +316,7 @@ out:
  * resolve all indirect backrefs from the list
  */
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
-				   int search_commit_root,
+				   int search_commit_root, u64 time_seq,
 				   struct list_head *head,
 				   const u64 *extent_item_pos)
 {
@@ -342,7 +343,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		if (ref->count == 0)
 			continue;
 		err = __resolve_indirect_ref(fs_info, search_commit_root,
-					     ref, parents, extent_item_pos);
+					     time_seq, ref, parents,
+					     extent_item_pos);
 		if (err) {
 			if (ret == 0)
 				ret = err;
@@ -762,7 +764,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
-			     u64 seq, struct ulist *refs, struct ulist *roots,
+			     u64 delayed_ref_seq, u64 time_seq,
+			     struct ulist *refs, struct ulist *roots,
 			     const u64 *extent_item_pos)
 {
 	struct btrfs_key key;
@@ -825,7 +828,8 @@ again:
 				btrfs_put_delayed_ref(&head->node);
 				goto again;
 			}
-			ret = __add_delayed_refs(head, seq, &prefs_delayed);
+			ret = __add_delayed_refs(head, delayed_ref_seq,
+						 &prefs_delayed);
 			if (ret) {
 				spin_unlock(&delayed_refs->lock);
 				goto out;
@@ -865,8 +869,8 @@ again:
 	if (ret)
 		goto out;
 
-	ret = __resolve_indirect_refs(fs_info, search_commit_root, &prefs,
-				      extent_item_pos);
+	ret = __resolve_indirect_refs(fs_info, search_commit_root, time_seq,
+				      &prefs, extent_item_pos);
 	if (ret)
 		goto out;
 
@@ -956,7 +960,8 @@ static void free_leaf_list(struct ulist *blocks)
  */
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 seq, struct ulist **leafs,
+				u64 delayed_ref_seq, u64 time_seq,
+				struct ulist **leafs,
 				const u64 *extent_item_pos)
 {
 	struct ulist *tmp;
@@ -971,8 +976,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ret = find_parent_nodes(trans, fs_info, bytenr, seq, *leafs, tmp,
-				extent_item_pos);
+	ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+				time_seq, *leafs, tmp, extent_item_pos);
 	ulist_free(tmp);
 
 	if (ret < 0 && ret != -ENOENT) {
@@ -998,7 +1003,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 seq, struct ulist **roots)
+				u64 delayed_ref_seq, u64 time_seq,
+				struct ulist **roots)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1014,8 +1020,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
-					tmp, *roots, NULL);
+		ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+					time_seq, tmp, *roots, NULL);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1413,7 +1419,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist *roots = NULL;
 	struct ulist_node *ref_node = NULL;
 	struct ulist_node *root_node = NULL;
-	struct seq_list seq_elem;
+	struct seq_list seq_elem = {};
+	struct seq_list tree_mod_seq_elem = {};
 	struct btrfs_delayed_ref_root *delayed_refs = NULL;
 
 	pr_debug("resolving all inodes for extent %llu\n",
@@ -1430,16 +1437,19 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 		spin_lock(&delayed_refs->lock);
 		btrfs_get_delayed_seq(delayed_refs, &seq_elem);
 		spin_unlock(&delayed_refs->lock);
+		btrfs_get_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 	}
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
-				   seq_elem.seq, &refs, &extent_item_pos);
+				   seq_elem.seq, tree_mod_seq_elem.seq, &refs,
+				   &extent_item_pos);
 	if (ret)
 		goto out;
 
 	while (!ret && (ref_node = ulist_next(refs, ref_node))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
-						seq_elem.seq, &roots);
+						seq_elem.seq,
+						tree_mod_seq_elem.seq, &roots);
 		if (ret)
 			break;
 		while (!ret && (root_node = ulist_next(roots, root_node))) {
@@ -1457,6 +1467,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	ulist_free(roots);
 out:
 	if (!search_commit_root) {
+		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
 		btrfs_put_delayed_seq(delayed_refs, &seq_elem);
 		btrfs_end_transaction(trans, fs_info->extent_root);
 	}
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 94ba1b2..c18d8ac 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -58,7 +58,8 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 seq, struct ulist **roots);
+				u64 delayed_ref_seq, u64 time_seq,
+				struct ulist **roots);
 
 struct btrfs_data_container *init_data_container(u32 total_bytes);
 struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
-- 
1.7.3.4

