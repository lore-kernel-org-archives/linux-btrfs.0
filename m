Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44234 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab2EZK7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:52 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 13/15] Btrfs: use the tree modification log for backref resolving
Date: Sat, 26 May 2012 12:59:47 +0200
Message-Id: <bfcd6ed9ac33bdea87c8a87da740ca6134b5ec2e.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
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
index fd13101..0ac47f2 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -231,6 +231,7 @@ add_parent:
  */
 static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 					int search_commit_root,
+					u64 time_seq,
 					struct __prelim_ref *ref,
 					struct ulist *parents,
 					const u64 *extent_item_pos)
@@ -266,7 +267,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	path->lowest_level = level;
-	ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path, 0, 0);
+	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
 	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
 		 "%d for key (%llu %u %llu)\n",
 		 (unsigned long long)ref->root_id, level, ref->count, ret,
@@ -305,7 +306,7 @@ out:
  * resolve all indirect backrefs from the list
  */
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
-				   int search_commit_root,
+				   int search_commit_root, u64 time_seq,
 				   struct list_head *head,
 				   const u64 *extent_item_pos)
 {
@@ -333,7 +334,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		if (ref->count == 0)
 			continue;
 		err = __resolve_indirect_ref(fs_info, search_commit_root,
-					     ref, parents, extent_item_pos);
+					     time_seq, ref, parents,
+					     extent_item_pos);
 		if (err) {
 			if (ret == 0)
 				ret = err;
@@ -750,7 +752,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
-			     u64 seq, struct ulist *refs, struct ulist *roots,
+			     u64 delayed_ref_seq, u64 time_seq,
+			     struct ulist *refs, struct ulist *roots,
 			     const u64 *extent_item_pos)
 {
 	struct btrfs_key key;
@@ -813,7 +816,8 @@ again:
 				btrfs_put_delayed_ref(&head->node);
 				goto again;
 			}
-			ret = __add_delayed_refs(head, seq, &prefs_delayed);
+			ret = __add_delayed_refs(head, delayed_ref_seq,
+						 &prefs_delayed);
 			if (ret) {
 				spin_unlock(&delayed_refs->lock);
 				goto out;
@@ -854,8 +858,8 @@ again:
 	if (ret)
 		goto out;
 
-	ret = __resolve_indirect_refs(fs_info, search_commit_root, &prefs,
-				      extent_item_pos);
+	ret = __resolve_indirect_refs(fs_info, search_commit_root, time_seq,
+				      &prefs, extent_item_pos);
 	if (ret)
 		goto out;
 
@@ -945,7 +949,8 @@ static void free_leaf_list(struct ulist *blocks)
  */
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 seq, struct ulist **leafs,
+				u64 delayed_ref_seq, u64 time_seq,
+				struct ulist **leafs,
 				const u64 *extent_item_pos)
 {
 	struct ulist *tmp;
@@ -960,8 +965,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ret = find_parent_nodes(trans, fs_info, bytenr, seq, *leafs, tmp,
-				extent_item_pos);
+	ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+				time_seq, *leafs, tmp, extent_item_pos);
 	ulist_free(tmp);
 
 	if (ret < 0 && ret != -ENOENT) {
@@ -987,7 +992,8 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 seq, struct ulist **roots)
+				u64 delayed_ref_seq, u64 time_seq,
+				struct ulist **roots)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -1005,8 +1011,8 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 	ULIST_ITER_INIT(&uiter);
 	while (1) {
-		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
-					tmp, *roots, NULL);
+		ret = find_parent_nodes(trans, fs_info, bytenr, delayed_ref_seq,
+					time_seq, tmp, *roots, NULL);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1338,7 +1344,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist *roots = NULL;
 	struct ulist_node *ref_node = NULL;
 	struct ulist_node *root_node = NULL;
-	struct seq_list seq_elem;
+	struct seq_list seq_elem = {};
+	struct seq_list tree_mod_seq_elem = {};
 	struct ulist_iterator ref_uiter;
 	struct ulist_iterator root_uiter;
 	struct btrfs_delayed_ref_root *delayed_refs = NULL;
@@ -1357,17 +1364,20 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
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
 
 	ULIST_ITER_INIT(&ref_uiter);
 	while (!ret && (ref_node = ulist_next(refs, &ref_uiter))) {
 		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
-						seq_elem.seq, &roots);
+						seq_elem.seq,
+						tree_mod_seq_elem.seq, &roots);
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
@@ -1388,6 +1398,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
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

