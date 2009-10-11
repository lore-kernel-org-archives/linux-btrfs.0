From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Usage of BUG_ON for memory shortages
Date: Sun, 11 Oct 2009 15:46:51 +0200
Message-ID: <200910111546.51662.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
I'm currently going through the btrfs code in order to understand how it 
works. I found a lot of places where a function tries to allocate a path and 
uses BUG_ON() to check if the allocation was successful. I think that one 
should rather return something like -ENOMEM instead of using BUG_ON().

Here's an example from btrfs_find_last_root() in root-tree.c:

        ...
        path = btrfs_alloc_path();
        BUG_ON(!path);
        ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
        ...

Since btrfs_alloc_path() reserves its space by calling kmem_cache_zalloc(), 
the result might be NULL if there isn't enough memory left. This isn't really
a bug. Even worse, as far as I know, BUG_ON() might be a no-op. In the example
above, a NULL pointer would be passed to btrfs_search_slot().

The patch at the end of the mail replaces the call to BUG_ON() with 
appropriate return statements. As I'm new to kernel development and btrfs,
please use the patch with care. I would be glad about any feedback.

Note: The return type of btrfs_read_locked_inode() is currently void, so
some additional work is required to handle the situation cleanly.

Here's the patch + its description:

Btrfs: Return -ENOMEM instead of using BUG_ON() when allocating paths
This patch replaces code using BUG_ON() to test if btrfs_alloc_path() was
successful with a return statement that lets the function fail with -ENOMEM.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ec96f3a..d93650f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3634,7 +3634,9 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
 	if (!ret) {
 		leaf = path->nodes[0];
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ac8927b..5e3463f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1106,11 +1106,19 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 	root = kzalloc(sizeof(*root), GFP_NOFS);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
+
+	path = btrfs_alloc_path();
+	if(!path) {
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	if (location->offset == (u64)-1) {
 		ret = find_and_setup_root(tree_root, fs_info,
 					  location->objectid, root);
 		if (ret) {
 			kfree(root);
+			btrfs_free_path(path);
 			return ERR_PTR(ret);
 		}
 		goto out;
@@ -1120,8 +1128,6 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 		     tree_root->sectorsize, tree_root->stripesize,
 		     root, fs_info, location->objectid);
 
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
 	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
 	if (ret == 0) {
 		l = path->nodes[0];
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4aedbff..8643f42 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -582,7 +582,9 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -4600,7 +4602,8 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -4661,7 +4664,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -5380,7 +5384,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root, int update_ref)
 	int level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	BUG_ON(!wc);
@@ -5542,7 +5547,8 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	BUG_ON(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	BUG_ON(!wc);
@@ -6001,7 +6007,10 @@ static noinline int get_new_locations(struct inode *reloc_inode,
 	}
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path) {
+		kfree(exts);
+		return -ENOMEM;
+	}
 
 	cur_pos = extent_key->objectid - offset;
 	last_byte = extent_key->objectid + extent_key->offset;
@@ -7523,6 +7532,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret;
 
+	path = btrfs_alloc_path();
+	if(!path)
+		return -ENOMEM;
+
 	root = root->fs_info->extent_root;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, group_start);
@@ -7546,9 +7559,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	btrfs_return_cluster_to_free_space(block_group, cluster);
 	spin_unlock(&cluster->refill_lock);
 
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9b99886..1aecfbd 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -47,7 +47,9 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	file_key.objectid = objectid;
 	file_key.offset = pos;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
@@ -260,7 +262,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.offset = start;
@@ -639,7 +642,9 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 53fb1c9..8a4b7cd 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -296,13 +296,14 @@ noinline int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int recow;
 	int ret;
 
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	inline_limit = 0;
 	if (drop_cache)
 		btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
 	while (1) {
 		recow = 0;
 		btrfs_release_path(root, path);
@@ -639,10 +640,12 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int split_end = 1;
 	int ret;
 
+	path = btrfs_alloc_path();
+	if(!path)
+		return -ENOMEM;
+
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
 again:
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index c56eb59..19ebfa6 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -30,7 +30,8 @@ int btrfs_find_highest_inode(struct btrfs_root *root, u64 *objectid)
 	int slot;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
 	search_key.type = -1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef399a7..f260bb2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -981,7 +981,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int check_prev = 1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	trans = btrfs_join_transaction(root, 1);
 	BUG_ON(!trans);
 
@@ -1580,7 +1582,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 
@@ -2216,7 +2219,8 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BUG_ON(!path); /* FIXME: handle path == NULL correctly */
+
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
@@ -2354,7 +2358,8 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;
 	ret = btrfs_lookup_inode(trans, root, path,
 				 &BTRFS_I(inode)->location, 1);
@@ -2806,10 +2811,13 @@ noinline int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int encoding;
 	u64 mask = root->sectorsize - 1;
 
+	path = btrfs_alloc_path();
+	if(!path)
+		return -ENOMEM;
+
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
+
 	path->reada = -1;
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
@@ -3263,7 +3271,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	int ret = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
 				    namelen, 0);
@@ -3937,7 +3946,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	int owner;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return ERR_PTR(-ENOMEM);
 
 	inode = new_inode(root->fs_info->sb);
 	if (!inode)
@@ -4477,6 +4487,10 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	struct btrfs_trans_handle *trans = NULL;
 	int compressed;
 
+	path = btrfs_alloc_path();
+	if(!path)
+		return ERR_PTR(-ENOMEM);
+
 again:
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, start, len);
@@ -4503,11 +4517,6 @@ again:
 	em->len = (u64)-1;
 	em->block_len = (u64)-1;
 
-	if (!path) {
-		path = btrfs_alloc_path();
-		BUG_ON(!path);
-	}
-
 	ret = btrfs_lookup_file_extent(trans, root, path,
 				       objectid, start, trans != NULL);
 	if (ret < 0) {
@@ -5502,7 +5511,11 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
 	key.objectid = inode->i_ino;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cfcc93c..3724c97 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2873,7 +2873,8 @@ static int block_use_full_backref(struct reloc_control *rc,
 		return 1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	key.objectid = eb->start;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -3274,8 +3275,10 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		kfree(cluster);
 		return -ENOMEM;
+	}
 
 	rc->extents_found = 0;
 	rc->extents_skipped = 0;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 9351428..5cbcef1 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -40,7 +40,8 @@ int btrfs_search_root(struct btrfs_root *root, u64 search_start,
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 again:
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
@@ -88,7 +89,9 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -140,7 +143,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
@@ -319,7 +324,9 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 78f6254..b8485fb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1577,7 +1577,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1840,7 +1841,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 	int orig_level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	level = btrfs_header_level(log->node);
 	orig_level = level;
@@ -2977,7 +2979,8 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	fs_info->log_root_recovering = 1;
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 20cbd2e..154ba17 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -946,7 +946,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path)
+		return -ENOMEM;
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -1928,7 +1929,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
 
 	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if(!path) {
+		ret = -ENOMEM;
+		goto error_path;
+	}
 
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
@@ -1974,6 +1978,7 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	ret = 0;
 error:
 	btrfs_free_path(path);
+error_path:
 	mutex_unlock(&dev_root->fs_info->volume_mutex);
 	return ret;
 }
