Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46284 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 02/24] Btrfs: look into the extent during find_all_leafs
Date: Sun, 20 May 2012 18:06:13 +0200
Message-Id: <d7c72992c5f939f529b55dbf3d937410d792cc1b.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch we called find_all_leafs for a data extent, then called
find_all_roots and then looked into the extent to grab the information
we were seeking. This was done without holding the leaves locked to avoid
deadlocks. However, this can obviouly race with concurrent tree
modifications.

Instead, we now look into the extent while we're holding the lock during
find_all_leafs and store this information together with the leaf list.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |  222 +++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/backref.h |    2 +-
 2 files changed, 188 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 710029e..e6c54d8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -24,6 +24,79 @@
 #include "delayed-ref.h"
 #include "locking.h"
 
+struct extent_inode_elem {
+	u64 inum;
+	u64 offset;
+	struct extent_inode_elem *next;
+};
+
+static int check_extent_in_eb(struct btrfs_key *key, struct extent_buffer *eb,
+				struct btrfs_file_extent_item *fi,
+				u64 extent_item_pos,
+				struct extent_inode_elem **eie)
+{
+	u64 data_offset;
+	u64 data_len;
+	struct extent_inode_elem *e;
+
+	data_offset = btrfs_file_extent_offset(eb, fi);
+	data_len = btrfs_file_extent_num_bytes(eb, fi);
+
+	if (extent_item_pos < data_offset ||
+	    extent_item_pos >= data_offset + data_len)
+		return 1;
+
+	e = kmalloc(sizeof(*e), GFP_NOFS);
+	if (!e)
+		return -ENOMEM;
+
+	e->next = *eie;
+	e->inum = key->objectid;
+	e->offset = key->offset + (extent_item_pos - data_offset);
+	*eie = e;
+
+	return 0;
+}
+
+static int find_extent_in_eb(struct extent_buffer *eb, u64 wanted_disk_byte,
+				u64 extent_item_pos,
+				struct extent_inode_elem **eie)
+{
+	u64 disk_byte;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	int slot;
+	int nritems;
+	int extent_type;
+	int ret;
+
+	/*
+	 * from the shared data ref, we only have the leaf but we need
+	 * the key. thus, we must look into all items and see that we
+	 * find one (some) with a reference to our extent item.
+	 */
+	nritems = btrfs_header_nritems(eb);
+	for (slot = 0; slot < nritems; ++slot) {
+		btrfs_item_key_to_cpu(eb, &key, slot);
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+		extent_type = btrfs_file_extent_type(eb, fi);
+		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+		/* don't skip BTRFS_FILE_EXTENT_PREALLOC, we can handle that */
+		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
+		if (disk_byte != wanted_disk_byte)
+			continue;
+
+		ret = check_extent_in_eb(&key, eb, fi, extent_item_pos, eie);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * this structure records all encountered refs on the way up to the root
  */
@@ -33,6 +106,7 @@ struct __prelim_ref {
 	struct btrfs_key key_for_search;
 	int level;
 	int count;
+	struct extent_inode_elem *inode_list;
 	u64 parent;
 	u64 wanted_disk_byte;
 };
@@ -93,6 +167,7 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 	else
 		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
 
+	ref->inode_list = NULL;
 	ref->level = level;
 	ref->count = count;
 	ref->parent = parent;
@@ -103,18 +178,26 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 }
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
-				struct ulist *parents,
-				struct extent_buffer *eb, int level,
-				u64 wanted_objectid, u64 wanted_disk_byte)
+				struct ulist *parents, int level,
+				struct btrfs_key *key, u64 wanted_disk_byte,
+				const u64 *extent_item_pos)
 {
 	int ret;
-	int slot;
+	int slot = path->slots[level];
+	struct extent_buffer *eb = path->nodes[level];
 	struct btrfs_file_extent_item *fi;
-	struct btrfs_key key;
+	struct extent_inode_elem *eie = NULL;
 	u64 disk_byte;
+	u64 wanted_objectid = key->objectid;
 
 add_parent:
-	ret = ulist_add(parents, eb->start, 0, GFP_NOFS);
+	if (level == 0 && extent_item_pos) {
+		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+		ret = check_extent_in_eb(key, eb, fi, *extent_item_pos, &eie);
+		if (ret < 0)
+			return ret;
+	}
+	ret = ulist_add(parents, eb->start, (unsigned long)eie, GFP_NOFS);
 	if (ret < 0)
 		return ret;
 
@@ -128,6 +211,7 @@ add_parent:
 	 * repeat this until we don't find any additional EXTENT_DATA items.
 	 */
 	while (1) {
+		eie = NULL;
 		ret = btrfs_next_leaf(root, path);
 		if (ret < 0)
 			return ret;
@@ -136,9 +220,9 @@ add_parent:
 
 		eb = path->nodes[0];
 		for (slot = 0; slot < btrfs_header_nritems(eb); ++slot) {
-			btrfs_item_key_to_cpu(eb, &key, slot);
-			if (key.objectid != wanted_objectid ||
-			    key.type != BTRFS_EXTENT_DATA_KEY)
+			btrfs_item_key_to_cpu(eb, key, slot);
+			if (key->objectid != wanted_objectid ||
+			    key->type != BTRFS_EXTENT_DATA_KEY)
 				return 0;
 			fi = btrfs_item_ptr(eb, slot,
 						struct btrfs_file_extent_item);
@@ -158,7 +242,8 @@ add_parent:
 static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 					int search_commit_root,
 					struct __prelim_ref *ref,
-					struct ulist *parents)
+					struct ulist *parents,
+					const u64 *extent_item_pos)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root;
@@ -219,9 +304,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
 	}
 
-	/* the last two parameters will only be used for level == 0 */
-	ret = add_all_parents(root, path, parents, eb, level, key.objectid,
-				ref->wanted_disk_byte);
+	ret = add_all_parents(root, path, parents, level, &key,
+				ref->wanted_disk_byte, extent_item_pos);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -232,7 +316,8 @@ out:
  */
 static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 				   int search_commit_root,
-				   struct list_head *head)
+				   struct list_head *head,
+				   const u64 *extent_item_pos)
 {
 	int err;
 	int ret = 0;
@@ -257,7 +342,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		if (ref->count == 0)
 			continue;
 		err = __resolve_indirect_ref(fs_info, search_commit_root,
-					     ref, parents);
+					     ref, parents, extent_item_pos);
 		if (err) {
 			if (ret == 0)
 				ret = err;
@@ -267,6 +352,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		/* we put the first parent into the ref at hand */
 		node = ulist_next(parents, NULL);
 		ref->parent = node ? node->val : 0;
+		ref->inode_list =
+			node ? (struct extent_inode_elem *)node->aux : 0;
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, node))) {
@@ -277,6 +364,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 			}
 			memcpy(new_ref, ref, sizeof(*ref));
 			new_ref->parent = node->val;
+			new_ref->inode_list =
+					(struct extent_inode_elem *)node->aux;
 			list_add(&new_ref->list, &ref->list);
 		}
 		ulist_reinit(parents);
@@ -673,7 +762,8 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
  */
 static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info, u64 bytenr,
-			     u64 seq, struct ulist *refs, struct ulist *roots)
+			     u64 seq, struct ulist *refs, struct ulist *roots,
+			     const u64 *extent_item_pos)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -775,7 +865,8 @@ again:
 	if (ret)
 		goto out;
 
-	ret = __resolve_indirect_refs(fs_info, search_commit_root, &prefs);
+	ret = __resolve_indirect_refs(fs_info, search_commit_root, &prefs,
+				      extent_item_pos);
 	if (ret)
 		goto out;
 
@@ -794,7 +885,23 @@ again:
 			BUG_ON(ret < 0);
 		}
 		if (ref->count && ref->parent) {
-			ret = ulist_add(refs, ref->parent, 0, GFP_NOFS);
+			if (extent_item_pos && !ref->inode_list) {
+				u32 bsz;
+				struct extent_inode_elem *eie = NULL;
+				struct extent_buffer *eb;
+				bsz = btrfs_level_size(fs_info->extent_root,
+							info_level);
+				eb = btrfs_find_tree_block(fs_info->extent_root,
+							   ref->parent, bsz);
+				BUG_ON(!eb);
+				ret = find_extent_in_eb(eb, bytenr,
+							*extent_item_pos, &eie);
+				ref->inode_list = eie;
+				free_extent_buffer(eb);
+			}
+			ret = ulist_add(refs, ref->parent,
+					(unsigned long)ref->inode_list,
+					GFP_NOFS);
 			BUG_ON(ret < 0);
 		}
 		kfree(ref);
@@ -819,6 +926,26 @@ out:
 	return ret;
 }
 
+static void free_leaf_list(struct ulist *blocks)
+{
+	struct ulist_node *node = NULL;
+	struct extent_inode_elem *eie;
+	struct extent_inode_elem *eie_next;
+
+	while ((node = ulist_next(blocks, node))) {
+		if (!node->aux)
+			continue;
+		eie = (struct extent_inode_elem *)node->aux;
+		for (; eie; eie = eie_next) {
+			eie_next = eie->next;
+			kfree(eie);
+		}
+		node->aux = 0;
+	}
+
+	ulist_free(blocks);
+}
+
 /*
  * Finds all leafs with a reference to the specified combination of bytenr and
  * offset. key_list_head will point to a list of corresponding keys (caller must
@@ -829,7 +956,8 @@ out:
  */
 static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 num_bytes, u64 seq, struct ulist **leafs)
+				u64 seq, struct ulist **leafs,
+				const u64 *extent_item_pos)
 {
 	struct ulist *tmp;
 	int ret;
@@ -843,11 +971,12 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ret = find_parent_nodes(trans, fs_info, bytenr, seq, *leafs, tmp);
+	ret = find_parent_nodes(trans, fs_info, bytenr, seq, *leafs, tmp,
+				extent_item_pos);
 	ulist_free(tmp);
 
 	if (ret < 0 && ret != -ENOENT) {
-		ulist_free(*leafs);
+		free_leaf_list(*leafs);
 		return ret;
 	}
 
@@ -869,7 +998,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
  */
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 num_bytes, u64 seq, struct ulist **roots)
+				u64 seq, struct ulist **roots)
 {
 	struct ulist *tmp;
 	struct ulist_node *node = NULL;
@@ -886,7 +1015,7 @@ int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = find_parent_nodes(trans, fs_info, bytenr, seq,
-					tmp, *roots);
+					tmp, *roots, NULL);
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
@@ -1178,7 +1307,31 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 	return 0;
 }
 
-static int iterate_leaf_refs(struct btrfs_fs_info *fs_info, u64 logical,
+static int iterate_leaf_refs(struct extent_inode_elem *inode_list,
+				u64 root, u64 extent_item_objectid,
+				iterate_extent_inodes_t *iterate, void *ctx)
+{
+	struct extent_inode_elem *eie;
+	struct extent_inode_elem *eie_next;
+	int ret = 0;
+
+	for (eie = inode_list; eie; eie = eie_next) {
+		pr_debug("ref for %llu resolved, key (%llu EXTEND_DATA %llu), "
+			 "root %llu\n", extent_item_objectid,
+			 eie->inum, eie->offset, root);
+		ret = iterate(eie->inum, eie->offset, root, ctx);
+		if (ret) {
+			pr_debug("stopping iteration for %llu due to ret=%d\n",
+				 extent_item_objectid, ret);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+int iterate_leaf_refs_old(struct btrfs_fs_info *fs_info,
+				struct btrfs_path *path, u64 logical,
 				u64 orig_extent_item_objectid,
 				u64 extent_item_pos, u64 root,
 				iterate_extent_inodes_t *iterate, void *ctx)
@@ -1280,28 +1433,27 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = btrfs_find_all_leafs(trans, fs_info, extent_item_objectid,
-				   extent_item_pos, seq_elem.seq,
-				   &refs);
-
+				   seq_elem.seq, &refs, &extent_item_pos);
 	if (ret)
 		goto out;
 
 	while (!ret && (ref_node = ulist_next(refs, ref_node))) {
-		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val, -1,
+		ret = btrfs_find_all_roots(trans, fs_info, ref_node->val,
 						seq_elem.seq, &roots);
 		if (ret)
 			break;
 		while (!ret && (root_node = ulist_next(roots, root_node))) {
-			pr_debug("root %llu references leaf %llu\n",
-					root_node->val, ref_node->val);
-			ret = iterate_leaf_refs(fs_info, ref_node->val,
-						extent_item_objectid,
-						extent_item_pos, root_node->val,
-						iterate, ctx);
+			pr_debug("root %llu references leaf %llu, data list "
+				 "%#lx\n", root_node->val, ref_node->val,
+				 ref_node->aux);
+			ret = iterate_leaf_refs(
+				(struct extent_inode_elem *)ref_node->aux,
+				root_node->val, extent_item_objectid,
+				iterate, ctx);
 		}
 	}
 
-	ulist_free(refs);
+	free_leaf_list(refs);
 	ulist_free(roots);
 out:
 	if (!search_commit_root) {
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 57ea2e9..94ba1b2 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -58,7 +58,7 @@ int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
 
 int btrfs_find_all_roots(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info, u64 bytenr,
-				u64 num_bytes, u64 seq, struct ulist **roots);
+				u64 seq, struct ulist **roots);
 
 struct btrfs_data_container *init_data_container(u32 total_bytes);
 struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
-- 
1.7.3.4

