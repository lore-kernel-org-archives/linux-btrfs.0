Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37323 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] Btrfs-progs: remove some dead/unbuilt code
Date: Fri, 26 Apr 2013 16:06:06 -0500
Message-Id: <1367010370-21571-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove some commented-out & #if 0'd code:

 * close_blocks()
 * btrfs_drop_snapshot()
 * btrfs_realloc_node()
 * btrfs_find_dead_roots()

There are still some #if 0'd functions in there, but I'm hedging
on those for now, they have been copied to cmds-check.c and I want
to see if they can be brough back into ctree.c eventually.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 ctree.c       |  140 ---------------------------------------------------------
 ctree.h       |    8 ---
 extent-tree.c |   71 -----------------------------
 root-tree.c   |   71 -----------------------------
 4 files changed, 0 insertions(+), 290 deletions(-)

diff --git a/ctree.c b/ctree.c
index 0b73bdf..b7b12a3 100644
--- a/ctree.c
+++ b/ctree.c
@@ -373,17 +373,6 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 }
 
 /*
-static int close_blocks(u64 blocknr, u64 other, u32 blocksize)
-{
-	if (blocknr < other && other - (blocknr + blocksize) < 32768)
-		return 1;
-	if (blocknr > other && blocknr - (other + blocksize) < 32768)
-		return 1;
-	return 0;
-}
-*/
-
-/*
  * compare two keys in a memcmp fashion
  */
 int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
@@ -407,135 +396,6 @@ int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
 	return 0;
 }
 
-
-#if 0
-int btrfs_realloc_node(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, struct extent_buffer *parent,
-		       int start_slot, int cache_only, u64 *last_ret,
-		       struct btrfs_key *progress)
-{
-	struct extent_buffer *cur;
-	struct extent_buffer *tmp;
-	u64 blocknr;
-	u64 gen;
-	u64 search_start = *last_ret;
-	u64 last_block = 0;
-	u64 other;
-	u32 parent_nritems;
-	int end_slot;
-	int i;
-	int err = 0;
-	int parent_level;
-	int uptodate;
-	u32 blocksize;
-	int progress_passed = 0;
-	struct btrfs_disk_key disk_key;
-
-	parent_level = btrfs_header_level(parent);
-	if (cache_only && parent_level != 1)
-		return 0;
-
-	if (trans->transaction != root->fs_info->running_transaction) {
-		printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
-		       root->fs_info->running_transaction->transid);
-		WARN_ON(1);
-	}
-	if (trans->transid != root->fs_info->generation) {
-		printk(KERN_CRIT "trans %Lu running %Lu\n", trans->transid,
-		       root->fs_info->generation);
-		WARN_ON(1);
-	}
-
-	parent_nritems = btrfs_header_nritems(parent);
-	blocksize = btrfs_level_size(root, parent_level - 1);
-	end_slot = parent_nritems;
-
-	if (parent_nritems == 1)
-		return 0;
-
-	for (i = start_slot; i < end_slot; i++) {
-		int close = 1;
-
-		if (!parent->map_token) {
-			map_extent_buffer(parent,
-					btrfs_node_key_ptr_offset(i),
-					sizeof(struct btrfs_key_ptr),
-					&parent->map_token, &parent->kaddr,
-					&parent->map_start, &parent->map_len,
-					KM_USER1);
-		}
-		btrfs_node_key(parent, &disk_key, i);
-		if (!progress_passed && comp_keys(&disk_key, progress) < 0)
-			continue;
-
-		progress_passed = 1;
-		blocknr = btrfs_node_blockptr(parent, i);
-		gen = btrfs_node_ptr_generation(parent, i);
-		if (last_block == 0)
-			last_block = blocknr;
-
-		if (i > 0) {
-			other = btrfs_node_blockptr(parent, i - 1);
-			close = close_blocks(blocknr, other, blocksize);
-		}
-		if (close && i < end_slot - 2) {
-			other = btrfs_node_blockptr(parent, i + 1);
-			close = close_blocks(blocknr, other, blocksize);
-		}
-		if (close) {
-			last_block = blocknr;
-			continue;
-		}
-		if (parent->map_token) {
-			unmap_extent_buffer(parent, parent->map_token,
-					    KM_USER1);
-			parent->map_token = NULL;
-		}
-
-		cur = btrfs_find_tree_block(root, blocknr, blocksize);
-		if (cur)
-			uptodate = btrfs_buffer_uptodate(cur, gen);
-		else
-			uptodate = 0;
-		if (!cur || !uptodate) {
-			if (cache_only) {
-				free_extent_buffer(cur);
-				continue;
-			}
-			if (!cur) {
-				cur = read_tree_block(root, blocknr,
-							 blocksize, gen);
-			} else if (!uptodate) {
-				btrfs_read_buffer(cur, gen);
-			}
-		}
-		if (search_start == 0)
-			search_start = last_block;
-
-		err = __btrfs_cow_block(trans, root, cur, parent, i,
-					&tmp, search_start,
-					min(16 * blocksize,
-					    (end_slot - i) * blocksize));
-		if (err) {
-			free_extent_buffer(cur);
-			break;
-		}
-		search_start = tmp->start;
-		last_block = tmp->start;
-		*last_ret = search_start;
-		if (parent_level == 1)
-			btrfs_clear_buffer_defrag(tmp);
-		free_extent_buffer(tmp);
-	}
-	if (parent->map_token) {
-		unmap_extent_buffer(parent, parent->map_token,
-				    KM_USER1);
-		parent->map_token = NULL;
-	}
-	return err;
-}
-#endif
-
 /*
  * The leaf data grows from end-to-front in the node.
  * this returns the address of the start of the last item,
diff --git a/ctree.h b/ctree.h
index f96b2f0..a73384d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2207,10 +2207,6 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
-int btrfs_realloc_node(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, struct extent_buffer *parent,
-		       int start_slot, int cache_only, u64 *last_ret,
-		       struct btrfs_key *progress);
 void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
 void add_root_to_dirty_list(struct btrfs_root *root);
 struct btrfs_path *btrfs_alloc_path(void);
@@ -2245,8 +2241,6 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
-			*root);
 int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *new_key);
@@ -2267,8 +2261,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *item);
 int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
 			 btrfs_root_item *item, struct btrfs_key *key);
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid,
-			  struct btrfs_root *latest_root);
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
diff --git a/extent-tree.c b/extent-tree.c
index 381572d..e8b6999 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3098,77 +3098,6 @@ static int noinline walk_up_tree(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
-/*
- * drop the reference count on the tree rooted at 'snap'.  This traverses
- * the tree freeing any blocks that have a ref count of zero after being
- * decremented.
- */
-int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
-			*root)
-{
-	int ret = 0;
-	int wret;
-	int level;
-	struct btrfs_path *path;
-	int i;
-	int orig_level;
-	struct btrfs_root_item *root_item = &root->root_item;
-
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
-	level = btrfs_header_level(root->node);
-	orig_level = level;
-	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
-		path->nodes[level] = root->node;
-		extent_buffer_get(root->node);
-		path->slots[level] = 0;
-	} else {
-		struct btrfs_key key;
-		struct btrfs_disk_key found_key;
-		struct extent_buffer *node;
-
-		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
-		level = root_item->drop_level;
-		path->lowest_level = level;
-		wret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-		if (wret < 0) {
-			ret = wret;
-			goto out;
-		}
-		node = path->nodes[level];
-		btrfs_node_key(node, &found_key, path->slots[level]);
-		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
-			       sizeof(found_key)));
-	}
-	while(1) {
-		wret = walk_down_tree(trans, root, path, &level);
-		if (wret < 0)
-			ret = wret;
-		if (wret != 0)
-			break;
-
-		wret = walk_up_tree(trans, root, path, &level);
-		if (wret < 0)
-			ret = wret;
-		if (wret != 0)
-			break;
-		/*
-		ret = -EAGAIN;
-		break;
-		*/
-	}
-	for (i = 0; i <= orig_level; i++) {
-		if (path->nodes[i]) {
-			free_extent_buffer(path->nodes[i]);
-			path->nodes[i] = NULL;
-		}
-	}
-out:
-	btrfs_free_path(path);
-	return ret;
-}
-
 #endif
 
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
diff --git a/root-tree.c b/root-tree.c
index ba380bd..c6b13dc 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -138,77 +138,6 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	return ret;
 }
 
-#if 0
-int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid,
-			  struct btrfs_root *latest)
-{
-	struct btrfs_root *dead_root;
-	struct btrfs_item *item;
-	struct btrfs_root_item *ri;
-	struct btrfs_key key;
-	struct btrfs_path *path;
-	int ret;
-	u32 nritems;
-	struct extent_buffer *leaf;
-	int slot;
-
-	key.objectid = objectid;
-	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
-	key.offset = 0;
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0)
-		goto err;
-	while(1) {
-		leaf = path->nodes[0];
-		nritems = btrfs_header_nritems(leaf);
-		slot = path->slots[0];
-		if (slot >= nritems) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret)
-				break;
-			leaf = path->nodes[0];
-			nritems = btrfs_header_nritems(leaf);
-			slot = path->slots[0];
-		}
-		item = btrfs_item_nr(leaf, slot);
-		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (btrfs_key_type(&key) != BTRFS_ROOT_ITEM_KEY)
-			goto next;
-
-		if (key.objectid < objectid)
-			goto next;
-
-		if (key.objectid > objectid)
-			break;
-
-		ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
-		if (btrfs_disk_root_refs(leaf, ri) != 0)
-			goto next;
-
-		dead_root = btrfs_read_fs_root_no_radix(root->fs_info, &key);
-		if (IS_ERR(dead_root)) {
-			ret = PTR_ERR(dead_root);
-			goto err;
-		}
-
-		ret = btrfs_add_dead_root(dead_root, latest,
-					  &root->fs_info->dead_roots);
-		if (ret)
-			goto err;
-next:
-		slot++;
-		path->slots[0]++;
-	}
-	ret = 0;
-err:
-	btrfs_free_path(path);
-	return ret;
-}
-#endif
-
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key)
 {
-- 
1.7.1

