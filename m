From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Improve space balancing code
Date: Tue, 21 Oct 2008 15:59:22 +0800
Message-ID: <48FD8BDA.4060605@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch improves the space balancing code to keep more sharing
of tree blocks. The only case that breaks sharing of tree blocks is
data extents get fragmented during balancing. The main changes in
this patch are:

Add a 'drop sub-tree' function. This solves the problem in old code
that BTRFS_HEADER_FLAG_WRITTEN check breaks sharing of tree block.

Remove relocation mapping tree. Relocation mappings are stored in
struct btrfs_ref_path and updated dynamically during walking up/down
the reference path. This reduces CPU usage and simplifies code.

This patch also fixes a bug. Root items for reloc trees should be
updated in btrfs_free_reloc_root.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9caeb37..73899d0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -287,7 +287,7 @@ int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		/*
 		 * There are only two places that can drop reference to
 		 * tree blocks owned by living reloc trees, one is here,
-		 * the other place is btrfs_merge_path. In both places,
+		 * the other place is btrfs_drop_subtree. In both places,
 		 * we check reference count while tree block is locked.
 		 * Furthermore, if reference count is one, it won't get
 		 * increased by someone else.
@@ -312,9 +312,6 @@ int noinline __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	}
 
 	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
-		ret = btrfs_add_reloc_mapping(root, buf->start,
-					      buf->len, cow->start);
-		BUG_ON(ret);
 		ret = btrfs_reloc_tree_cache_ref(trans, root, cow, buf->start);
 		WARN_ON(ret);
 	}
@@ -1627,61 +1624,57 @@ int btrfs_merge_path(struct btrfs_trans_handle *trans,
 		btrfs_node_key_to_cpu(eb, &key, slot);
 		key_match = !memcmp(&key, &node_keys[level - 1], sizeof(key));
 
+		if (generation == trans->transid) {
+			eb = read_tree_block(root, bytenr, blocksize,
+					     generation);
+			btrfs_tree_lock(eb);
+		}
+
 		/*
 		 * if node keys match and node pointer hasn't been modified
 		 * in the running transaction, we can merge the path. for
-		 * reloc trees, the node pointer check is skipped, this is
-		 * because the reloc trees are fully controlled by the space
-		 * balance code, no one else can modify them.
+		 * blocks owened by reloc trees, the node pointer check is
+		 * skipped, this is because these blocks are fully controlled
+		 * by the space balance code, no one else can modify them.
 		 */
 		if (!nodes[level - 1] || !key_match ||
 		    (generation == trans->transid &&
-		     root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID)) {
-next_level:
-			if (level == 1 || level == lowest_level + 1)
+		     btrfs_header_owner(eb) != BTRFS_TREE_RELOC_OBJECTID)) {
+			if (level == 1 || level == lowest_level + 1) {
+				if (generation == trans->transid) {
+					btrfs_tree_unlock(eb);
+					free_extent_buffer(eb);
+				}
 				break;
+			}
 
-			eb = read_tree_block(root, bytenr, blocksize,
-					     generation);
-			btrfs_tree_lock(eb);
+			if (generation != trans->transid) {
+				eb = read_tree_block(root, bytenr, blocksize,
+						generation);
+				btrfs_tree_lock(eb);
+			}
 
 			ret = btrfs_cow_block(trans, root, eb, parent, slot,
 					      &eb, 0);
 			BUG_ON(ret);
 
+			if (root->root_key.objectid ==
+			    BTRFS_TREE_RELOC_OBJECTID) {
+				if (!nodes[level - 1]) {
+					nodes[level - 1] = eb->start;
+					memcpy(&node_keys[level - 1], &key,
+					       sizeof(node_keys[0]));
+				} else {
+					WARN_ON(1);
+				}
+			}
+
 			btrfs_tree_unlock(parent);
 			free_extent_buffer(parent);
 			parent = eb;
 			continue;
 		}
 
-		if (generation == trans->transid) {
-			u32 refs;
-			BUG_ON(btrfs_header_owner(eb) !=
-			       BTRFS_TREE_RELOC_OBJECTID);
-			/*
-			 * lock the block to keep __btrfs_cow_block from
-			 * changing the reference count.
-			 */
-			eb = read_tree_block(root, bytenr, blocksize,
-					     generation);
-			btrfs_tree_lock(eb);
-
-			ret = btrfs_lookup_extent_ref(trans, root, bytenr,
-						      blocksize, &refs);
-			BUG_ON(ret);
-			/*
-			 * if replace block whose reference count is one,
-			 * we have to "drop the subtree". so skip it for
-			 * simplicity
-			 */
-			if (refs == 1) {
-				btrfs_tree_unlock(eb);
-				free_extent_buffer(eb);
-				goto next_level;
-			}
-		}
-
 		btrfs_set_node_blockptr(parent, slot, nodes[level - 1]);
 		btrfs_set_node_ptr_generation(parent, slot, trans->transid);
 		btrfs_mark_buffer_dirty(parent);
@@ -1693,16 +1686,24 @@ next_level:
 					btrfs_header_generation(parent),
 					level - 1);
 		BUG_ON(ret);
-		ret = btrfs_free_extent(trans, root, bytenr,
-					blocksize, parent->start,
-					btrfs_header_owner(parent),
-					btrfs_header_generation(parent),
-					level - 1, 1);
-		BUG_ON(ret);
 
+		/*
+		 * If the block was created in the running transaction,
+		 * it's possible this is the last reference to it, so we
+		 * should drop the subtree.
+		 */
 		if (generation == trans->transid) {
+			ret = btrfs_drop_subtree(trans, root, eb, parent);
+			BUG_ON(ret);
 			btrfs_tree_unlock(eb);
 			free_extent_buffer(eb);
+		} else {
+			ret = btrfs_free_extent(trans, root, bytenr,
+					blocksize, parent->start,
+					btrfs_header_owner(parent),
+					btrfs_header_generation(parent),
+					level - 1, 1);
+			BUG_ON(ret);
 		}
 		break;
 	}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8559f39..119e971 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -648,7 +648,6 @@ struct btrfs_fs_info {
 	int thread_pool_size;
 
 	/* tree relocation relocated fields */
-	struct extent_io_tree reloc_mapping_tree;
 	struct list_head dead_reloc_roots;
 	struct btrfs_leaf_ref_tree reloc_ref_tree;
 	struct btrfs_leaf_ref_tree shared_ref_tree;
@@ -1576,13 +1575,9 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
 int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
-int btrfs_free_reloc_root(struct btrfs_root *root);
+int btrfs_free_reloc_root(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root);
 int btrfs_drop_dead_reloc_roots(struct btrfs_root *root);
-int btrfs_add_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
-			    u64 num_bytes, u64 new_bytenr);
-int btrfs_get_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
-			    u64 num_bytes, u64 *new_bytenr);
-void btrfs_free_reloc_mappings(struct btrfs_root *root);
 int btrfs_reloc_tree_cache_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct extent_buffer *buf, u64 orig_start);
@@ -1666,6 +1661,10 @@ int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
 			*root);
+int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct extent_buffer *node,
+			struct extent_buffer *parent);
 /* root-item.c */
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0be044b..21ac708 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1443,8 +1443,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	fs_info->do_barriers = 1;
 
-	extent_io_tree_init(&fs_info->reloc_mapping_tree,
-			    fs_info->btree_inode->i_mapping, GFP_NOFS);
 	INIT_LIST_HEAD(&fs_info->dead_reloc_roots);
 	btrfs_leaf_ref_tree_init(&fs_info->reloc_ref_tree);
 	btrfs_leaf_ref_tree_init(&fs_info->shared_ref_tree);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 280ac1a..1b9c276 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3032,13 +3032,103 @@ out:
 }
 
 /*
+ * helper function for drop_subtree, this function is similar to
+ * walk_down_tree. The main difference is that it checks reference
+ * counts while tree blocks are locked.
+ */
+static int noinline walk_down_subtree(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      struct btrfs_path *path, int *level)
+{
+	struct extent_buffer *next;
+	struct extent_buffer *cur;
+	struct extent_buffer *parent;
+	u64 bytenr;
+	u64 ptr_gen;
+	u32 blocksize;
+	u32 refs;
+	int ret;
+
+	cur = path->nodes[*level];
+	ret = btrfs_lookup_extent_ref(trans, root, cur->start, cur->len,
+				      &refs);
+	BUG_ON(ret);
+	if (refs > 1)
+		goto out;
+
+	while (*level >= 0) {
+		cur = path->nodes[*level];
+		if (*level == 0) {
+			ret = btrfs_drop_leaf_ref(trans, root, cur);
+			BUG_ON(ret);
+			clean_tree_block(trans, root, cur);
+			break;
+		}
+		if (path->slots[*level] >= btrfs_header_nritems(cur)) {
+			clean_tree_block(trans, root, cur);
+			break;
+		}
+
+		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
+		blocksize = btrfs_level_size(root, *level - 1);
+		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
+
+		next = read_tree_block(root, bytenr, blocksize, ptr_gen);
+		btrfs_tree_lock(next);
+
+		ret = btrfs_lookup_extent_ref(trans, root, bytenr, blocksize,
+					      &refs);
+		BUG_ON(ret);
+		if (refs > 1) {
+			parent = path->nodes[*level];
+			ret = btrfs_free_extent(trans, root, bytenr,
+					blocksize, parent->start,
+					btrfs_header_owner(parent),
+					btrfs_header_generation(parent),
+					*level - 1, 1);
+			BUG_ON(ret);
+			path->slots[*level]++;
+			btrfs_tree_unlock(next);
+			free_extent_buffer(next);
+			continue;
+		}
+
+		*level = btrfs_header_level(next);
+		path->nodes[*level] = next;
+		path->slots[*level] = 0;
+		path->locks[*level] = 1;
+		cond_resched();
+	}
+out:
+	parent = path->nodes[*level + 1];
+	bytenr = path->nodes[*level]->start;
+	blocksize = path->nodes[*level]->len;
+
+	ret = btrfs_free_extent(trans, root, bytenr, blocksize,
+			parent->start, btrfs_header_owner(parent),
+			btrfs_header_generation(parent), *level, 1);
+	BUG_ON(ret);
+
+	if (path->locks[*level]) {
+		btrfs_tree_unlock(path->nodes[*level]);
+		path->locks[*level] = 0;
+	}
+	free_extent_buffer(path->nodes[*level]);
+	path->nodes[*level] = NULL;
+	*level += 1;
+	cond_resched();
+	return 0;
+}
+
+/*
  * helper for dropping snapshots.  This walks back up the tree in the path
  * to find the first node higher up where we haven't yet gone through
  * all the slots
  */
 static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
-				 struct btrfs_path *path, int *level)
+				 struct btrfs_path *path,
+				 int *level, int max_level)
 {
 	u64 root_owner;
 	u64 root_gen;
@@ -3047,7 +3137,7 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 	int slot;
 	int ret;
 
-	for(i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
+	for (i = *level; i < max_level && path->nodes[i]; i++) {
 		slot = path->slots[i];
 		if (slot < btrfs_header_nritems(path->nodes[i]) - 1) {
 			struct extent_buffer *node;
@@ -3070,12 +3160,18 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 
 			root_owner = btrfs_header_owner(parent);
 			root_gen = btrfs_header_generation(parent);
+
+			clean_tree_block(trans, root, path->nodes[*level]);
 			ret = btrfs_free_extent(trans, root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len,
 						parent->start, root_owner,
 						root_gen, *level, 1);
 			BUG_ON(ret);
+			if (path->locks[*level]) {
+				btrfs_tree_unlock(path->nodes[*level]);
+				path->locks[*level] = 0;
+			}
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
 			*level = i + 1;
@@ -3145,7 +3241,8 @@ int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
 		if (wret < 0)
 			ret = wret;
 
-		wret = walk_up_tree(trans, root, path, &level);
+		wret = walk_up_tree(trans, root, path, &level,
+				    BTRFS_MAX_LEVEL);
 		if (wret > 0)
 			break;
 		if (wret < 0)
@@ -3168,6 +3265,50 @@ out:
 	return ret;
 }
 
+int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct extent_buffer *node,
+			struct extent_buffer *parent)
+{
+	struct btrfs_path *path;
+	int level;
+	int parent_level;
+	int ret = 0;
+	int wret;
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	BUG_ON(!btrfs_tree_locked(parent));
+	parent_level = btrfs_header_level(parent);
+	extent_buffer_get(parent);
+	path->nodes[parent_level] = parent;
+	path->slots[parent_level] = btrfs_header_nritems(parent);
+
+	BUG_ON(!btrfs_tree_locked(node));
+	level = btrfs_header_level(node);
+	extent_buffer_get(node);
+	path->nodes[level] = node;
+	path->slots[level] = 0;
+
+	while (1) {
+		wret = walk_down_subtree(trans, root, path, &level);
+		if (wret < 0)
+			ret = wret;
+		if (wret != 0)
+			break;
+
+		wret = walk_up_tree(trans, root, path, &level, parent_level);
+		if (wret < 0)
+			ret = wret;
+		if (wret != 0)
+			break;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
 static unsigned long calc_ra(unsigned long start, unsigned long last,
 			     unsigned long nr)
 {
@@ -3311,6 +3452,10 @@ struct btrfs_ref_path {
 	u32 num_refs;
 	int lowest_level;
 	int current_level;
+	int shared_level;
+
+	struct btrfs_key node_keys[BTRFS_MAX_LEVEL];
+	u64 new_nodes[BTRFS_MAX_LEVEL];
 };
 
 struct disk_extent {
@@ -3355,6 +3500,7 @@ static int noinline __next_ref_path(struct btrfs_trans_handle *trans,
 	if (first_time) {
 		ref_path->lowest_level = -1;
 		ref_path->current_level = -1;
+		ref_path->shared_level = -1;
 		goto walk_up;
 	}
 walk_down:
@@ -3398,8 +3544,11 @@ walk_down:
 
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.objectid == bytenr &&
-				found_key.type == BTRFS_EXTENT_REF_KEY)
+		    found_key.type == BTRFS_EXTENT_REF_KEY) {
+			if (level < ref_path->shared_level)
+				ref_path->shared_level = level;
 			goto found;
+		}
 next:
 		level--;
 		btrfs_release_path(extent_root, path);
@@ -3970,51 +4119,6 @@ out:
 	return ret;
 }
 
-int btrfs_add_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
-			    u64 num_bytes, u64 new_bytenr)
-{
-	set_extent_bits(&root->fs_info->reloc_mapping_tree,
-			orig_bytenr, orig_bytenr + num_bytes - 1,
-			EXTENT_LOCKED, GFP_NOFS);
-	set_state_private(&root->fs_info->reloc_mapping_tree,
-			  orig_bytenr, new_bytenr);
-	return 0;
-}
-
-int btrfs_get_reloc_mapping(struct btrfs_root *root, u64 orig_bytenr,
-			    u64 num_bytes, u64 *new_bytenr)
-{
-	u64 bytenr;
-	u64 cur_bytenr = orig_bytenr;
-	u64 prev_bytenr = orig_bytenr;
-	int ret;
-
-	while (1) {
-		ret = get_state_private(&root->fs_info->reloc_mapping_tree,
-					cur_bytenr, &bytenr);
-		if (ret)
-			break;
-		prev_bytenr = cur_bytenr;
-		cur_bytenr = bytenr;
-	}
-
-	if (orig_bytenr == cur_bytenr)
-		return -ENOENT;
-
-	if (prev_bytenr != orig_bytenr) {
-		set_state_private(&root->fs_info->reloc_mapping_tree,
-				  orig_bytenr, cur_bytenr);
-	}
-	*new_bytenr = cur_bytenr;
-	return 0;
-}
-
-void btrfs_free_reloc_mappings(struct btrfs_root *root)
-{
-	clear_extent_bits(&root->fs_info->reloc_mapping_tree,
-			  0, (u64)-1, -1, GFP_NOFS);
-}
-
 int btrfs_reloc_tree_cache_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct extent_buffer *buf, u64 orig_start)
@@ -4198,15 +4302,30 @@ static int noinline replace_extents_in_leaf(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_free_reloc_root(struct btrfs_root *root)
+int btrfs_free_reloc_root(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
+	int ret;
 
 	if (root->reloc_root) {
 		reloc_root = root->reloc_root;
 		root->reloc_root = NULL;
 		list_add(&reloc_root->dead_list,
 			 &root->fs_info->dead_reloc_roots);
+
+		btrfs_set_root_bytenr(&reloc_root->root_item,
+				      reloc_root->node->start);
+		btrfs_set_root_level(&root->root_item,
+				     btrfs_header_level(reloc_root->node));
+		memset(&reloc_root->root_item.drop_progress, 0,
+			sizeof(struct btrfs_disk_key));
+		reloc_root->root_item.drop_level = 0;
+
+		ret = btrfs_update_root(trans, root->fs_info->tree_root,
+					&reloc_root->root_key,
+					&reloc_root->root_item);
+		BUG_ON(ret);
 	}
 	return 0;
 }
@@ -4332,8 +4451,6 @@ static int noinline init_reloc_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_refs(root_item, 0);
 	btrfs_set_root_bytenr(root_item, eb->start);
 	btrfs_set_root_level(root_item, btrfs_header_level(eb));
-	memset(&root_item->drop_progress, 0, sizeof(root_item->drop_progress));
-	root_item->drop_level = 0;
 
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
@@ -4358,15 +4475,19 @@ static int noinline init_reloc_tree(struct btrfs_trans_handle *trans,
  * Core function of space balance.
  *
  * The idea is using reloc trees to relocate tree blocks in reference
- * counted roots. There is one reloc tree for each subvol, all reloc
- * trees share same key objectid. Reloc trees are snapshots of the
- * latest committed roots (subvol root->commit_root). To relocate a tree
- * block referenced by a subvol, the code COW the block through the reloc
- * tree, then update pointer in the subvol to point to the new block.
- * Since all reloc trees share same key objectid, we can easily do special
- * handing to share tree blocks between reloc trees. Once a tree block has
- * been COWed in one reloc tree, we can use the result when the same block
- * is COWed again through other reloc trees.
+ * counted roots. There is one reloc tree for each subvol, and all
+ * reloc trees share same root key objectid. Reloc trees are snapshots
+ * of the latest committed roots of subvols (root->commit_root).
+ *
+ * To relocate a tree block referenced by a subvol, there are two steps.
+ * COW the block through subvol's reloc tree, then update block pointer
+ * in the subvol to point to the new block. Since all reloc trees share
+ * same root key objectid, doing special handing for tree blocks owned
+ * by them is easy. Once a tree block has been COWed in one reloc tree,
+ * we can use the resulting new block directly when the same block is
+ * required to COW again through other reloc trees. By this way, relocated
+ * tree blocks are shared between reloc trees, so they are also shared
+ * between subvols.
  */
 static int noinline relocate_one_path(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
@@ -4381,15 +4502,14 @@ static int noinline relocate_one_path(struct btrfs_trans_handle *trans,
 	struct btrfs_key *keys;
 	u64 *nodes;
 	int level;
-	int lowest_merge;
+	int shared_level;
 	int lowest_level = 0;
-	int update_refs;
 	int ret;
 
 	if (ref_path->owner_objectid < BTRFS_FIRST_FREE_OBJECTID)
 		lowest_level = ref_path->owner_objectid;
 
-	if (is_cowonly_root(ref_path->root_objectid)) {
+	if (!root->ref_cows) {
 		path->lowest_level = lowest_level;
 		ret = btrfs_search_slot(trans, root, first_key, path, 0, 1);
 		BUG_ON(ret < 0);
@@ -4398,91 +4518,49 @@ static int noinline relocate_one_path(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	keys = kzalloc(sizeof(*keys) * BTRFS_MAX_LEVEL, GFP_NOFS);
-	BUG_ON(!keys);
-	nodes = kzalloc(sizeof(*nodes) * BTRFS_MAX_LEVEL, GFP_NOFS);
-	BUG_ON(!nodes);
-
 	mutex_lock(&root->fs_info->tree_reloc_mutex);
 	ret = init_reloc_tree(trans, root);
 	BUG_ON(ret);
 	reloc_root = root->reloc_root;
 
-	path->lowest_level = lowest_level;
-	ret = btrfs_search_slot(trans, reloc_root, first_key, path, 0, 0);
-	BUG_ON(ret);
-	/*
-	 * get relocation mapping for tree blocks in the path
-	 */
-	lowest_merge = BTRFS_MAX_LEVEL;
-	for (level = BTRFS_MAX_LEVEL - 1; level >= lowest_level; level--) {
-		u64 new_bytenr;
-		eb = path->nodes[level];
-		if (!eb || eb == reloc_root->node)
-			continue;
-		ret = btrfs_get_reloc_mapping(reloc_root, eb->start, eb->len,
-					      &new_bytenr);
-		if (ret)
-			continue;
-		if (level == 0)
-			btrfs_item_key_to_cpu(eb, &keys[level], 0);
-		else
-			btrfs_node_key_to_cpu(eb, &keys[level], 0);
-		nodes[level] = new_bytenr;
-		lowest_merge = level;
-	}
+	shared_level = ref_path->shared_level;
+	ref_path->shared_level = BTRFS_MAX_LEVEL - 1;
 
-	update_refs = 0;
-	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
-		eb = path->nodes[0];
-		if (btrfs_header_generation(eb) < trans->transid)
-			update_refs = 1;
-	}
+	keys = ref_path->node_keys;
+	nodes = ref_path->new_nodes;
+	memset(&keys[shared_level + 1], 0,
+	       sizeof(*keys) * (BTRFS_MAX_LEVEL - shared_level - 1));
+	memset(&nodes[shared_level + 1], 0,
+	       sizeof(*nodes) * (BTRFS_MAX_LEVEL - shared_level - 1));
 
-	btrfs_release_path(reloc_root, path);
-	/*
-	 * merge tree blocks that already relocated in other reloc trees
-	 */
-	if (lowest_merge != BTRFS_MAX_LEVEL) {
+	if (nodes[lowest_level] == 0) {
+		path->lowest_level = lowest_level;
+		ret = btrfs_search_slot(trans, reloc_root, first_key, path,
+					0, 1);
+		BUG_ON(ret);
+		for (level = lowest_level; level < BTRFS_MAX_LEVEL; level++) {
+			eb = path->nodes[level];
+			if (!eb || eb == reloc_root->node)
+				break;
+			nodes[level] = eb->start;
+			if (level == 0)
+				btrfs_item_key_to_cpu(eb, &keys[level], 0);
+			else
+				btrfs_node_key_to_cpu(eb, &keys[level], 0);
+		}
+		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+			eb = path->nodes[0];
+			ret = replace_extents_in_leaf(trans, reloc_root, eb,
+						      group, reloc_inode);
+			BUG_ON(ret);
+		}
+		btrfs_release_path(reloc_root, path);
+	} else {
 		ret = btrfs_merge_path(trans, reloc_root, keys, nodes,
-				       lowest_merge);
-		BUG_ON(ret < 0);
-	}
-	/*
-	 * cow any tree blocks that still haven't been relocated
-	 */
-	ret = btrfs_search_slot(trans, reloc_root, first_key, path, 0, 1);
-	BUG_ON(ret);
-	/*
-	 * if we are relocating data block group, update extent pointers
-	 * in the newly created tree leaf.
-	 */
-	eb = path->nodes[0];
-	if (update_refs && nodes[0] != eb->start) {
-		ret = replace_extents_in_leaf(trans, reloc_root, eb, group,
-					      reloc_inode);
+				       lowest_level);
 		BUG_ON(ret);
 	}
 
-	memset(keys, 0, sizeof(*keys) * BTRFS_MAX_LEVEL);
-	memset(nodes, 0, sizeof(*nodes) * BTRFS_MAX_LEVEL);
-	for (level = BTRFS_MAX_LEVEL - 1; level >= lowest_level; level--) {
-		eb = path->nodes[level];
-		if (!eb || eb == reloc_root->node)
-			continue;
-		BUG_ON(btrfs_header_owner(eb) != BTRFS_TREE_RELOC_OBJECTID);
-		nodes[level] = eb->start;
-		if (level == 0)
-			btrfs_item_key_to_cpu(eb, &keys[level], 0);
-		else
-			btrfs_node_key_to_cpu(eb, &keys[level], 0);
-	}
-
-	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
-		eb = path->nodes[0];
-		extent_buffer_get(eb);
-	}
-	btrfs_release_path(reloc_root, path);
 	/*
 	 * replace tree blocks in the fs tree with tree blocks in
 	 * the reloc tree.
@@ -4491,15 +4569,19 @@ static int noinline relocate_one_path(struct btrfs_trans_handle *trans,
 	BUG_ON(ret < 0);
 
 	if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
+		ret = btrfs_search_slot(trans, reloc_root, first_key, path,
+					0, 0);
+		BUG_ON(ret);
+		extent_buffer_get(path->nodes[0]);
+		eb = path->nodes[0];
+		btrfs_release_path(reloc_root, path);
 		ret = invalidate_extent_cache(reloc_root, eb, group, root);
 		BUG_ON(ret);
 		free_extent_buffer(eb);
 	}
-	mutex_unlock(&root->fs_info->tree_reloc_mutex);
 
+	mutex_unlock(&root->fs_info->tree_reloc_mutex);
 	path->lowest_level = 0;
-	kfree(nodes);
-	kfree(keys);
 	return 0;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5ecc24d..1df6712 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -521,7 +521,7 @@ static noinline int add_dirty_roots(struct btrfs_trans_handle *trans,
 			dirty = root->dirty_root;
 
 			btrfs_free_log(trans, root);
-			btrfs_free_reloc_root(root);
+			btrfs_free_reloc_root(trans, root);
 
 			if (root->commit_root == root->node) {
 				WARN_ON(root->node->start !=
@@ -930,8 +930,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	btrfs_free_log_root_tree(trans, root->fs_info);
 
-	btrfs_free_reloc_mappings(root);
-
 	ret = btrfs_commit_tree_roots(trans, root);
 	BUG_ON(ret);
 

