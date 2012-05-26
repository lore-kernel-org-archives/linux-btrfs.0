Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:56281 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab2EZK7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:51 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/15] Btrfs: bugfix: ignore the wrong key for indirect tree block backrefs
Date: Sat, 26 May 2012 12:59:37 +0200
Message-Id: <d5c88b735fdf2ef796bb937396dd58dac84e8407.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The key we store with a tree block backref is only a hint. It is set when
the ref is created and can remain correct for a long time. As the tree is
rebalanced, however, eventually the key no longer points to the correct
destination.

With this patch, we change find_parent_nodes to no longer add keys unless it
knows for sure they're correct (e.g. because they're for an extent data
backref). Then when we later encounter a backref ref with no parent and no
key set, we grab the block and take the first key from the block itself.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |  185 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 135 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index c69a846..366978c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -30,16 +30,55 @@
 struct __prelim_ref {
 	struct list_head list;
 	u64 root_id;
-	struct btrfs_key key;
+	struct btrfs_key key_for_search;
 	int level;
 	int count;
 	u64 parent;
 	u64 wanted_disk_byte;
 };
 
+/*
+ * the rules for all callers of this function are:
+ * - obtaining the parent is the goal
+ * - if you add a key, you must know that it is a correct key
+ * - if you cannot add the parent or a correct key, then we will look into the
+ *   block later to set a correct key
+ *
+ * delayed refs
+ * ============
+ *        backref type | shared | indirect | shared | indirect
+ * information         |   tree |     tree |   data |     data
+ * --------------------+--------+----------+--------+----------
+ *      parent logical |    y   |     -    |    -   |     -
+ *      key to resolve |    -   |     y    |    y   |     y
+ *  tree block logical |    -   |     -    |    -   |     -
+ *  root for resolving |    y   |     y    |    y   |     y
+ *
+ * - column 1:       we've the parent -> done
+ * - column 2, 3, 4: we use the key to find the parent
+ *
+ * on disk refs (inline or keyed)
+ * ==============================
+ *        backref type | shared | indirect | shared | indirect
+ * information         |   tree |     tree |   data |     data
+ * --------------------+--------+----------+--------+----------
+ *      parent logical |    y   |     -    |    y   |     -
+ *      key to resolve |    -   |     -    |    -   |     y
+ *  tree block logical |    y   |     y    |    y   |     y
+ *  root for resolving |    -   |     y    |    y   |     y
+ *
+ * - column 1, 3: we've the parent -> done
+ * - column 2:    we take the first key from the block to find the parent
+ *                (see __add_missing_keys)
+ * - column 4:    we use the key to find the parent
+ *
+ * additional information that's available but not required to find the parent
+ * block might help in merging entries to gain some speed.
+ */
+
 static int __add_prelim_ref(struct list_head *head, u64 root_id,
-			    struct btrfs_key *key, int level, u64 parent,
-			    u64 wanted_disk_byte, int count)
+			    struct btrfs_key *key, int level,
+			    u64 parent, u64 wanted_disk_byte, int count)
 {
 	struct __prelim_ref *ref;
 
@@ -50,9 +89,9 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 
 	ref->root_id = root_id;
 	if (key)
-		ref->key = *key;
+		ref->key_for_search = *key;
 	else
-		memset(&ref->key, 0, sizeof(ref->key));
+		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
 
 	ref->level = level;
 	ref->count = count;
@@ -152,12 +191,13 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 
 	path->lowest_level = level;
-	ret = btrfs_search_slot(NULL, root, &ref->key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, root, &ref->key_for_search, path, 0, 0);
 	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
 		 "%d for key (%llu %u %llu)\n",
 		 (unsigned long long)ref->root_id, level, ref->count, ret,
-		 (unsigned long long)ref->key.objectid, ref->key.type,
-		 (unsigned long long)ref->key.offset);
+		 (unsigned long long)ref->key_for_search.objectid,
+		 ref->key_for_search.type,
+		 (unsigned long long)ref->key_for_search.offset);
 	if (ret < 0)
 		goto out;
 
@@ -248,10 +288,65 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static inline int ref_for_same_block(struct __prelim_ref *ref1,
+				     struct __prelim_ref *ref2)
+{
+	if (ref1->level != ref2->level)
+		return 0;
+	if (ref1->root_id != ref2->root_id)
+		return 0;
+	if (ref1->key_for_search.type != ref2->key_for_search.type)
+		return 0;
+	if (ref1->key_for_search.objectid != ref2->key_for_search.objectid)
+		return 0;
+	if (ref1->key_for_search.offset != ref2->key_for_search.offset)
+		return 0;
+	if (ref1->parent != ref2->parent)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * read tree blocks and add keys where required.
+ */
+static int __add_missing_keys(struct btrfs_fs_info *fs_info,
+			      struct list_head *head)
+{
+	struct list_head *pos;
+	struct extent_buffer *eb;
+
+	list_for_each(pos, head) {
+		struct __prelim_ref *ref;
+		ref = list_entry(pos, struct __prelim_ref, list);
+
+		if (ref->parent)
+			continue;
+		if (ref->key_for_search.type)
+			continue;
+		BUG_ON(!ref->wanted_disk_byte);
+		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
+				     fs_info->tree_root->leafsize, 0);
+		BUG_ON(!eb);
+		btrfs_tree_read_lock(eb);
+		if (btrfs_header_level(eb) == 0)
+			btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0);
+		else
+			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
+		btrfs_tree_read_unlock(eb);
+		free_extent_buffer(eb);
+	}
+	return 0;
+}
+
 /*
  * merge two lists of backrefs and adjust counts accordingly
  *
  * mode = 1: merge identical keys, if key is set
+ *    FIXME: if we add more keys in __add_prelim_ref, we can merge more here.
+ *           additionally, we could even add a key range for the blocks we
+ *           looked into to merge even more (-> replace unresolved refs by those
+ *           having a parent).
  * mode = 2: merge identical parents
  */
 static int __merge_refs(struct list_head *head, int mode)
@@ -265,20 +360,21 @@ static int __merge_refs(struct list_head *head, int mode)
 
 		ref1 = list_entry(pos1, struct __prelim_ref, list);
 
-		if (mode == 1 && ref1->key.type == 0)
-			continue;
 		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
 		     pos2 = n2, n2 = pos2->next) {
 			struct __prelim_ref *ref2;
+			struct __prelim_ref *xchg;
 
 			ref2 = list_entry(pos2, struct __prelim_ref, list);
 
 			if (mode == 1) {
-				if (memcmp(&ref1->key, &ref2->key,
-					   sizeof(ref1->key)) ||
-				    ref1->level != ref2->level ||
-				    ref1->root_id != ref2->root_id)
+				if (!ref_for_same_block(ref1, ref2))
 					continue;
+				if (!ref1->parent && ref2->parent) {
+					xchg = ref1;
+					ref1 = ref2;
+					ref2 = xchg;
+				}
 				ref1->count += ref2->count;
 			} else {
 				if (ref1->parent != ref2->parent)
@@ -298,16 +394,17 @@ static int __merge_refs(struct list_head *head, int mode)
  * smaller or equal that seq to the list
  */
 static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
-			      struct btrfs_key *info_key,
 			      struct list_head *prefs)
 {
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct rb_node *n = &head->node.rb_node;
+	struct btrfs_key key;
+	struct btrfs_key op_key = {0};
 	int sgn;
 	int ret = 0;
 
 	if (extent_op && extent_op->update_key)
-		btrfs_disk_key_to_cpu(info_key, &extent_op->key);
+		btrfs_disk_key_to_cpu(&op_key, &extent_op->key);
 
 	while ((n = rb_prev(n))) {
 		struct btrfs_delayed_ref_node *node;
@@ -339,7 +436,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			struct btrfs_delayed_tree_ref *ref;
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
-			ret = __add_prelim_ref(prefs, ref->root, info_key,
+			ret = __add_prelim_ref(prefs, ref->root, &op_key,
 					       ref->level + 1, 0, node->bytenr,
 					       node->ref_mod * sgn);
 			break;
@@ -348,7 +445,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			struct btrfs_delayed_tree_ref *ref;
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
-			ret = __add_prelim_ref(prefs, ref->root, info_key,
+			ret = __add_prelim_ref(prefs, ref->root, NULL,
 					       ref->level + 1, ref->parent,
 					       node->bytenr,
 					       node->ref_mod * sgn);
@@ -356,8 +453,6 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		}
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_delayed_data_ref *ref;
-			struct btrfs_key key;
-
 			ref = btrfs_delayed_node_to_data_ref(node);
 
 			key.objectid = ref->objectid;
@@ -370,7 +465,6 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 		}
 		case BTRFS_SHARED_DATA_REF_KEY: {
 			struct btrfs_delayed_data_ref *ref;
-			struct btrfs_key key;
 
 			ref = btrfs_delayed_node_to_data_ref(node);
 
@@ -396,8 +490,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
  */
 static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path, u64 bytenr,
-			     struct btrfs_key *info_key, int *info_level,
-			     struct list_head *prefs)
+			     int *info_level, struct list_head *prefs)
 {
 	int ret = 0;
 	int slot;
@@ -426,12 +519,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		struct btrfs_tree_block_info *info;
-		struct btrfs_disk_key disk_key;
 
 		info = (struct btrfs_tree_block_info *)ptr;
 		*info_level = btrfs_tree_block_level(leaf, info);
-		btrfs_tree_block_key(leaf, info, &disk_key);
-		btrfs_disk_key_to_cpu(info_key, &disk_key);
 		ptr += sizeof(struct btrfs_tree_block_info);
 		BUG_ON(ptr > end);
 	} else {
@@ -449,7 +539,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 		switch (type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, 0, info_key,
+			ret = __add_prelim_ref(prefs, 0, NULL,
 						*info_level + 1, offset,
 						bytenr, 1);
 			break;
@@ -464,8 +554,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, offset, info_key,
-					       *info_level + 1, 0, bytenr, 1);
+			ret = __add_prelim_ref(prefs, offset, NULL,
+					       *info_level + 1, 0,
+					       bytenr, 1);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -479,8 +570,8 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
-			ret = __add_prelim_ref(prefs, root, &key, 0, 0, bytenr,
-						count);
+			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
+					       bytenr, count);
 			break;
 		}
 		default:
@@ -498,8 +589,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
  */
 static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			    struct btrfs_path *path, u64 bytenr,
-			    struct btrfs_key *info_key, int info_level,
-			    struct list_head *prefs)
+			    int info_level, struct list_head *prefs)
 {
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	int ret;
@@ -529,7 +619,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 
 		switch (key.type) {
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, 0, info_key,
+			ret = __add_prelim_ref(prefs, 0, NULL,
 						info_level + 1, key.offset,
 						bytenr, 1);
 			break;
@@ -545,8 +635,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			break;
 		}
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			ret = __add_prelim_ref(prefs, key.offset, info_key,
-						info_level + 1, 0, bytenr, 1);
+			ret = __add_prelim_ref(prefs, key.offset, NULL,
+					       info_level + 1, 0,
+					       bytenr, 1);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY: {
 			struct btrfs_extent_data_ref *dref;
@@ -562,7 +653,7 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
-						bytenr, count);
+					       bytenr, count);
 			break;
 		}
 		default:
@@ -588,7 +679,6 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
-	struct btrfs_key info_key = { 0 };
 	struct btrfs_delayed_ref_root *delayed_refs = NULL;
 	struct btrfs_delayed_ref_head *head;
 	int info_level = 0;
@@ -647,8 +737,7 @@ again:
 				btrfs_put_delayed_ref(&head->node);
 				goto again;
 			}
-			ret = __add_delayed_refs(head, seq, &info_key,
-						 &prefs_delayed);
+			ret = __add_delayed_refs(head, seq, &prefs_delayed);
 			if (ret) {
 				spin_unlock(&delayed_refs->lock);
 				goto out;
@@ -668,10 +757,10 @@ again:
 		if (key.objectid == bytenr &&
 		    key.type == BTRFS_EXTENT_ITEM_KEY) {
 			ret = __add_inline_refs(fs_info, path, bytenr,
-						&info_key, &info_level, &prefs);
+						&info_level, &prefs);
 			if (ret)
 				goto out;
-			ret = __add_keyed_refs(fs_info, path, bytenr, &info_key,
+			ret = __add_keyed_refs(fs_info, path, bytenr,
 					       info_level, &prefs);
 			if (ret)
 				goto out;
@@ -679,16 +768,12 @@ again:
 	}
 	btrfs_release_path(path);
 
-	/*
-	 * when adding the delayed refs above, the info_key might not have
-	 * been known yet. Go over the list and replace the missing keys
-	 */
-	list_for_each_entry(ref, &prefs_delayed, list) {
-		if ((ref->key.offset | ref->key.type | ref->key.objectid) == 0)
-			memcpy(&ref->key, &info_key, sizeof(ref->key));
-	}
 	list_splice_init(&prefs_delayed, &prefs);
 
+	ret = __add_missing_keys(fs_info, &prefs);
+	if (ret)
+		goto out;
+
 	ret = __merge_refs(&prefs, 1);
 	if (ret)
 		goto out;
-- 
1.7.3.4

