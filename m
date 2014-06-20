Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966656AbaFTLCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:02:52 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/8] btrfs: use nodesize everywhere, kill leafsize
Date: Fri, 20 Jun 2014 13:02:49 +0200
Message-Id: <7f70803d49977685c134c88526733716b47cab59.1403260619.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The nodesize and leafsize were never of different values. Unify the
usage and make nodesize the one. Cleanup the redundant checks and
helpers.

Shaves a few bytes from .text:

  text    data     bss     dec     hex filename
852418   24560   23112  900090   dbbfa btrfs.ko.before
851074   24584   23112  898770   db6d2 btrfs.ko.after

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/backref.c         |    8 ++--
 fs/btrfs/check-integrity.c |   13 --------
 fs/btrfs/ctree.c           |   18 +++++-----
 fs/btrfs/ctree.h           |   21 ++----------
 fs/btrfs/disk-io.c         |   74 +++++++++++++++++++------------------------
 fs/btrfs/extent-tree.c     |   36 +++++++++++-----------
 fs/btrfs/file.c            |    2 +-
 fs/btrfs/ioctl.c           |    6 ++--
 fs/btrfs/print-tree.c      |    2 +-
 fs/btrfs/qgroup.c          |    6 +--
 fs/btrfs/reada.c           |    2 +-
 fs/btrfs/relocation.c      |   21 ++++++------
 fs/btrfs/scrub.c           |   17 +---------
 fs/btrfs/transaction.c     |    2 +-
 fs/btrfs/tree-log.c        |    2 +-
 15 files changed, 89 insertions(+), 141 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9fe0deeddc31..d54f0bf2de5c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -483,7 +483,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 			continue;
 		BUG_ON(!ref->wanted_disk_byte);
 		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
-				     fs_info->tree_root->leafsize, 0);
+				     fs_info->tree_root->nodesize, 0);
 		if (!eb || !extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
 			return -EIO;
@@ -992,8 +992,8 @@ again:
 			    ref->level == 0) {
 				u32 bsz;
 				struct extent_buffer *eb;
-				bsz = btrfs_level_size(fs_info->extent_root,
-							ref->level);
+
+				bsz = fs_info->extent_root->nodesize;
 				eb = read_tree_block(fs_info->extent_root,
 							   ref->parent, bsz, 0);
 				if (!eb || !extent_buffer_uptodate(eb)) {
@@ -1364,7 +1364,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	}
 	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
 	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
-		size = fs_info->extent_root->leafsize;
+		size = fs_info->extent_root->nodesize;
 	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
 		size = found_key->offset;
 
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ce92ae30250f..d0690da3b150 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -820,7 +820,6 @@ static int btrfsic_process_superblock_dev_mirror(
 	    btrfs_super_magic(super_tmp) != BTRFS_MAGIC ||
 	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE) ||
 	    btrfs_super_nodesize(super_tmp) != state->metablock_size ||
-	    btrfs_super_leafsize(super_tmp) != state->metablock_size ||
 	    btrfs_super_sectorsize(super_tmp) != state->datablock_size) {
 		brelse(bh);
 		return 0;
@@ -3120,24 +3119,12 @@ int btrfsic_mount(struct btrfs_root *root,
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
 
-	if (root->nodesize != root->leafsize) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle nodesize %d != leafsize %d!\n",
-		       root->nodesize, root->leafsize);
-		return -1;
-	}
 	if (root->nodesize & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: cannot handle nodesize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
 		       root->nodesize, PAGE_CACHE_SIZE);
 		return -1;
 	}
-	if (root->leafsize & ((u64)PAGE_CACHE_SIZE - 1)) {
-		printk(KERN_INFO
-		       "btrfsic: cannot handle leafsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
-		       root->leafsize, PAGE_CACHE_SIZE);
-		return -1;
-	}
 	if (root->sectorsize & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: cannot handle sectorsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index aeab453b8e24..13a9f397ef19 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1444,7 +1444,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
-		blocksize = btrfs_level_size(root, old_root->level);
+		blocksize = root->nodesize;
 		old = read_tree_block(root, logical, blocksize, 0);
 		if (WARN_ON(!old || !extent_buffer_uptodate(old))) {
 			free_extent_buffer(old);
@@ -1651,7 +1651,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	WARN_ON(trans->transid != root->fs_info->generation);
 
 	parent_nritems = btrfs_header_nritems(parent);
-	blocksize = btrfs_level_size(root, parent_level - 1);
+	blocksize = root->nodesize;
 	end_slot = parent_nritems;
 
 	if (parent_nritems == 1)
@@ -1872,7 +1872,7 @@ static noinline struct extent_buffer *read_node_slot(struct btrfs_root *root,
 	BUG_ON(level == 0);
 
 	eb = read_tree_block(root, btrfs_node_blockptr(parent, slot),
-			     btrfs_level_size(root, level - 1),
+			     root->nodesize,
 			     btrfs_node_ptr_generation(parent, slot));
 	if (eb && !extent_buffer_uptodate(eb)) {
 		free_extent_buffer(eb);
@@ -2267,7 +2267,7 @@ static void reada_for_search(struct btrfs_root *root,
 	node = path->nodes[level];
 
 	search = btrfs_node_blockptr(node, slot);
-	blocksize = btrfs_level_size(root, level - 1);
+	blocksize = root->nodesize;
 	eb = btrfs_find_tree_block(root, search, blocksize);
 	if (eb) {
 		free_extent_buffer(eb);
@@ -2325,7 +2325,7 @@ static noinline void reada_for_balance(struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(parent);
 	slot = path->slots[level + 1];
-	blocksize = btrfs_level_size(root, level);
+	blocksize = root->nodesize;
 
 	if (slot > 0) {
 		block1 = btrfs_node_blockptr(parent, slot - 1);
@@ -2461,7 +2461,7 @@ read_block_for_search(struct btrfs_trans_handle *trans,
 
 	blocknr = btrfs_node_blockptr(b, slot);
 	gen = btrfs_node_ptr_generation(b, slot);
-	blocksize = btrfs_level_size(root, level - 1);
+	blocksize = root->nodesize;
 
 	tmp = btrfs_find_tree_block(root, blocknr, blocksize);
 	if (tmp) {
@@ -4282,13 +4282,13 @@ again:
 	else
 		btrfs_item_key(l, &disk_key, mid);
 
-	right = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+	right = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 					root->root_key.objectid,
 					&disk_key, 0, l->start, 0);
 	if (IS_ERR(right))
 		return PTR_ERR(right);
 
-	root_add_used(root, root->leafsize);
+	root_add_used(root, root->nodesize);
 
 	memset_extent_buffer(right, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_bytenr(right, right->start);
@@ -5375,7 +5375,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 		goto out;
 	}
 
-	tmp_buf = kmalloc(left_root->leafsize, GFP_NOFS);
+	tmp_buf = kmalloc(left_root->nodesize, GFP_NOFS);
 	if (!tmp_buf) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d474694bb11d..476a0c1e988a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -391,7 +391,7 @@ struct btrfs_header {
 				      sizeof(struct btrfs_header)) / \
 				     sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
-#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->leafsize))
+#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->nodesize))
 #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
@@ -474,7 +474,7 @@ struct btrfs_super_block {
 	__le64 num_devices;
 	__le32 sectorsize;
 	__le32 nodesize;
-	__le32 leafsize;
+	__le32 __unused_leafsize;
 	__le32 stripesize;
 	__le32 sys_chunk_array_size;
 	__le64 chunk_root_generation;
@@ -1806,9 +1806,6 @@ struct btrfs_root {
 	/* node allocations are done in nodesize units */
 	u32 nodesize;
 
-	/* leaf allocations are done in leafsize units */
-	u32 leafsize;
-
 	u32 stripesize;
 
 	u32 type;
@@ -2995,8 +2992,6 @@ BTRFS_SETGET_STACK_FUNCS(super_sectorsize, struct btrfs_super_block,
 			 sectorsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_nodesize, struct btrfs_super_block,
 			 nodesize, 32);
-BTRFS_SETGET_STACK_FUNCS(super_leafsize, struct btrfs_super_block,
-			 leafsize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_stripesize, struct btrfs_super_block,
 			 stripesize, 32);
 BTRFS_SETGET_STACK_FUNCS(super_root_dir, struct btrfs_super_block,
@@ -3232,13 +3227,6 @@ static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline u32 btrfs_level_size(struct btrfs_root *root, int level)
-{
-	if (level == 0)
-		return root->leafsize;
-	return root->nodesize;
-}
-
 /* helper function to cast into the data area of the leaf. */
 #define btrfs_item_ptr(leaf, slot, type) \
 	((type *)(btrfs_leaf_data(leaf) + \
@@ -3263,7 +3251,7 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
 						 unsigned num_items)
 {
-	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
+	return (root->nodesize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
 		2 * num_items;
 }
 
@@ -3274,8 +3262,7 @@ static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
 static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_root *root,
 						 unsigned num_items)
 {
-	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
-		num_items;
+	return root->nodesize * BTRFS_MAX_LEVEL * num_items;
 }
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 43217afbcaf7..23a5e979d68a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1196,16 +1196,14 @@ btrfs_free_subvolume_writers(struct btrfs_subvolume_writers *writers)
 	kfree(writers);
 }
 
-static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
-			 u32 stripesize, struct btrfs_root *root,
-			 struct btrfs_fs_info *fs_info,
+static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
+			 struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 			 u64 objectid)
 {
 	root->node = NULL;
 	root->commit_root = NULL;
 	root->sectorsize = sectorsize;
 	root->nodesize = nodesize;
-	root->leafsize = leafsize;
 	root->stripesize = stripesize;
 	root->state = 0;
 	root->orphan_cleanup_state = 0;
@@ -1291,7 +1289,7 @@ struct btrfs_root *btrfs_alloc_dummy_root(void)
 	root = btrfs_alloc_root(NULL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
-	__setup_root(4096, 4096, 4096, 4096, root, NULL, 1);
+	__setup_root(4096, 4096, 4096, root, NULL, 1);
 	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 	root->alloc_bytenr = 0;
 
@@ -1314,14 +1312,13 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
-	__setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, objectid);
+	__setup_root(tree_root->nodesize, tree_root->sectorsize,
+		tree_root->stripesize, root, fs_info, objectid);
 	root->root_key.objectid = objectid;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root->root_key.offset = 0;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+	leaf = btrfs_alloc_free_block(trans, root, root->nodesize,
 				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
@@ -1392,9 +1389,9 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
-	__setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, BTRFS_TREE_LOG_OBJECTID);
+	__setup_root(tree_root->nodesize, tree_root->sectorsize,
+		     tree_root->stripesize, root, fs_info,
+		     BTRFS_TREE_LOG_OBJECTID);
 
 	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1409,7 +1406,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	 * updated (along with back refs to the log tree).
 	 */
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize, 0,
+	leaf = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
 				      BTRFS_TREE_LOG_OBJECTID, NULL,
 				      0, 0, 0);
 	if (IS_ERR(leaf)) {
@@ -1461,7 +1458,7 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_generation(inode_item, 1);
 	btrfs_set_stack_inode_size(inode_item, 3);
 	btrfs_set_stack_inode_nlink(inode_item, 1);
-	btrfs_set_stack_inode_nbytes(inode_item, root->leafsize);
+	btrfs_set_stack_inode_nbytes(inode_item, root->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 
 	btrfs_set_root_node(&log_root->root_item, log_root->node);
@@ -1494,9 +1491,8 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 		goto alloc_fail;
 	}
 
-	__setup_root(tree_root->nodesize, tree_root->leafsize,
-		     tree_root->sectorsize, tree_root->stripesize,
-		     root, fs_info, key->objectid);
+	__setup_root(tree_root->nodesize, tree_root->sectorsize,
+		tree_root->stripesize, root, fs_info, key->objectid);
 
 	ret = btrfs_find_root(tree_root, key, path,
 			      &root->root_item, &root->root_key);
@@ -1507,7 +1503,7 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	}
 
 	generation = btrfs_root_generation(&root->root_item);
-	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
+	blocksize = root->nodesize;
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
 	if (!root->node) {
@@ -2139,7 +2135,6 @@ int open_ctree(struct super_block *sb,
 {
 	u32 sectorsize;
 	u32 nodesize;
-	u32 leafsize;
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
@@ -2385,7 +2380,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	__setup_root(4096, 4096, 4096, 4096, tree_root,
+	__setup_root(4096, 4096, 4096, tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	invalidate_bdev(fs_devices->latest_bdev);
@@ -2465,19 +2460,22 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	if (btrfs_super_leafsize(disk_super) !=
+	/*
+	 * Leafsize and nodesize were always equal, this is only a sanity check.
+	 */
+	if (le32_to_cpu(disk_super->__unused_leafsize) !=
 	    btrfs_super_nodesize(disk_super)) {
 		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
 		       "blocksizes don't match.  node %d leaf %d\n",
 		       btrfs_super_nodesize(disk_super),
-		       btrfs_super_leafsize(disk_super));
+		       le32_to_cpu(disk_super->__unused_leafsize));
 		err = -EINVAL;
 		goto fail_alloc;
 	}
-	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
+	if (btrfs_super_nodesize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
 		       "blocksize (%d) was too large\n",
-		       btrfs_super_leafsize(disk_super));
+		       btrfs_super_nodesize(disk_super));
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2494,17 +2492,16 @@ int open_ctree(struct super_block *sb,
 	 * flag our filesystem as having big metadata blocks if
 	 * they are bigger than the page size
 	 */
-	if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
+	if (btrfs_super_nodesize(disk_super) > PAGE_CACHE_SIZE) {
 		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
 			printk(KERN_INFO "BTRFS: flagging fs with big metadata feature\n");
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 	}
 
 	nodesize = btrfs_super_nodesize(disk_super);
-	leafsize = btrfs_super_leafsize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
 	stripesize = btrfs_super_stripesize(disk_super);
-	fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
+	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
 	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
 
 	/*
@@ -2512,7 +2509,7 @@ int open_ctree(struct super_block *sb,
 	 * extent buffers for the same range.  It leads to corruptions
 	 */
 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
-	    (sectorsize != leafsize)) {
+	    (sectorsize != nodesize)) {
 		printk(KERN_WARNING "BTRFS: unequal leaf/node/sector sizes "
 				"are not allowed for mixed block groups on %s\n",
 				sb->s_id);
@@ -2611,7 +2608,6 @@ int open_ctree(struct super_block *sb,
 				    4 * 1024 * 1024 / PAGE_CACHE_SIZE);
 
 	tree_root->nodesize = nodesize;
-	tree_root->leafsize = leafsize;
 	tree_root->sectorsize = sectorsize;
 	tree_root->stripesize = stripesize;
 
@@ -2638,12 +2634,11 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	blocksize = btrfs_level_size(tree_root,
-				     btrfs_super_chunk_root_level(disk_super));
+	blocksize = tree_root->nodesize;
 	generation = btrfs_super_chunk_root_generation(disk_super);
 
-	__setup_root(nodesize, leafsize, sectorsize, stripesize,
-		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+	__setup_root(nodesize, sectorsize, stripesize, chunk_root,
+		     fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
 	chunk_root->node = read_tree_block(chunk_root,
 					   btrfs_super_chunk_root(disk_super),
@@ -2680,8 +2675,7 @@ int open_ctree(struct super_block *sb,
 	}
 
 retry_root_backup:
-	blocksize = btrfs_level_size(tree_root,
-				     btrfs_super_root_level(disk_super));
+	blocksize = tree_root->nodesize;
 	generation = btrfs_super_generation(disk_super);
 
 	tree_root->node = read_tree_block(tree_root,
@@ -2855,9 +2849,7 @@ retry_root_backup:
 			err = -EIO;
 			goto fail_qgroup;
 		}
-		blocksize =
-		     btrfs_level_size(tree_root,
-				      btrfs_super_log_root_level(disk_super));
+		blocksize = tree_root->nodesize;
 
 		log_tree_root = btrfs_alloc_root(fs_info);
 		if (!log_tree_root) {
@@ -2865,7 +2857,7 @@ retry_root_backup:
 			goto fail_qgroup;
 		}
 
-		__setup_root(nodesize, leafsize, sectorsize, stripesize,
+		__setup_root(nodesize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
@@ -4029,8 +4021,8 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
 			eb = btrfs_find_tree_block(root, start,
-						   root->leafsize);
-			start += root->leafsize;
+						   root->nodesize);
+			start += root->nodesize;
 			if (!eb)
 				continue;
 			wait_on_extent_buffer_writeback(eb);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 30c3c5ee9ba2..177a544630ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -491,7 +491,7 @@ next:
 							  key.objectid);
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				last = key.objectid +
-					fs_info->tree_root->leafsize;
+					fs_info->tree_root->nodesize;
 			else
 				last = key.objectid + key.offset;
 
@@ -764,7 +764,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	 * different
 	 */
 	if (metadata && !btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
-		offset = root->leafsize;
+		offset = root->nodesize;
 		metadata = 0;
 	}
 
@@ -798,13 +798,13 @@ again:
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
 			    key.type == BTRFS_EXTENT_ITEM_KEY &&
-			    key.offset == root->leafsize)
+			    key.offset == root->nodesize)
 				ret = 0;
 		}
 		if (ret) {
 			key.objectid = bytenr;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
-			key.offset = root->leafsize;
+			key.offset = root->nodesize;
 			btrfs_release_path(path);
 			goto again;
 		}
@@ -2650,7 +2650,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 	num_heads = heads_to_leaves(root, num_heads);
 	if (num_heads > 1)
-		num_bytes += (num_heads - 1) * root->leafsize;
+		num_bytes += (num_heads - 1) * root->nodesize;
 	num_bytes <<= 1;
 	global_rsv = &root->fs_info->global_block_rsv;
 
@@ -3116,7 +3116,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			num_bytes = btrfs_level_size(root, level - 1);
+			num_bytes = root->nodesize;
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0,
 					   no_quota);
@@ -4844,7 +4844,7 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	if (num_bytes * 3 > meta_used)
 		num_bytes = div64_u64(meta_used, 3);
 
-	return ALIGN(num_bytes, fs_info->extent_root->leafsize << 10);
+	return ALIGN(num_bytes, fs_info->extent_root->nodesize << 10);
 }
 
 static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
@@ -4993,7 +4993,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	if (root->fs_info->quota_enabled) {
 		/* One for parent inode, two for dir entries */
-		num_bytes = 3 * root->leafsize;
+		num_bytes = 3 * root->nodesize;
 		ret = btrfs_qgroup_reserve(root, num_bytes);
 		if (ret)
 			return ret;
@@ -5181,7 +5181,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	if (root->fs_info->quota_enabled) {
 		ret = btrfs_qgroup_reserve(root, num_bytes +
-					   nr_extents * root->leafsize);
+					   nr_extents * root->nodesize);
 		if (ret)
 			goto out_fail;
 	}
@@ -5190,7 +5190,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	if (unlikely(ret)) {
 		if (root->fs_info->quota_enabled)
 			btrfs_qgroup_free(root, num_bytes +
-						nr_extents * root->leafsize);
+						nr_extents * root->nodesize);
 		goto out_fail;
 	}
 
@@ -5306,7 +5306,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 				      btrfs_ino(inode), to_free, 0);
 	if (root->fs_info->quota_enabled) {
 		btrfs_qgroup_free(root, num_bytes +
-					dropped * root->leafsize);
+					dropped * root->nodesize);
 	}
 
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
@@ -7085,7 +7085,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		btrfs_free_and_pin_reserved_extent(root, ins->objectid,
-						   root->leafsize);
+						   root->nodesize);
 		return -ENOMEM;
 	}
 
@@ -7094,7 +7094,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				      ins, size);
 	if (ret) {
 		btrfs_free_and_pin_reserved_extent(root, ins->objectid,
-						   root->leafsize);
+						   root->nodesize);
 		btrfs_free_path(path);
 		return ret;
 	}
@@ -7109,7 +7109,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	if (skinny_metadata) {
 		iref = (struct btrfs_extent_inline_ref *)(extent_item + 1);
-		num_bytes = root->leafsize;
+		num_bytes = root->nodesize;
 	} else {
 		block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 		btrfs_set_tree_block_key(leaf, block_info, key);
@@ -7139,14 +7139,14 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 			return ret;
 	}
 
-	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
+	ret = update_block_group(root, ins->objectid, root->nodesize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
 			ins->objectid, ins->offset);
 		BUG();
 	}
 
-	trace_btrfs_reserved_extent_alloc(root, ins->objectid, root->leafsize);
+	trace_btrfs_reserved_extent_alloc(root, ins->objectid, root->nodesize);
 	return ret;
 }
 
@@ -7425,7 +7425,7 @@ static noinline void reada_walk_down(struct btrfs_trans_handle *trans,
 
 	eb = path->nodes[wc->level];
 	nritems = btrfs_header_nritems(eb);
-	blocksize = btrfs_level_size(root, wc->level - 1);
+	blocksize = root->nodesize;
 
 	for (slot = path->slots[wc->level]; slot < nritems; slot++) {
 		if (nread >= wc->reada_count)
@@ -7599,7 +7599,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	}
 
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
-	blocksize = btrfs_level_size(root, level - 1);
+	blocksize = root->nodesize;
 
 	next = btrfs_find_tree_block(root, bytenr, blocksize);
 	if (!next) {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index aa81897a7ecc..f71d29c76d1e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1652,7 +1652,7 @@ again:
 		cond_resched();
 
 		balance_dirty_pages_ratelimited(inode->i_mapping);
-		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
+		if (dirty_pages < (root->nodesize >> PAGE_CACHE_SHIFT) + 1)
 			btrfs_btree_balance_dirty(root);
 
 		pos += copied;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 32b9c4472e14..f8af35d63881 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -474,7 +474,7 @@ static noinline int create_subvol(struct inode *dir,
 	if (ret)
 		goto fail;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+	leaf = btrfs_alloc_free_block(trans, root, root->nodesize,
 				      0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
@@ -500,7 +500,7 @@ static noinline int create_subvol(struct inode *dir,
 	btrfs_set_stack_inode_generation(inode_item, 1);
 	btrfs_set_stack_inode_size(inode_item, 3);
 	btrfs_set_stack_inode_nlink(inode_item, 1);
-	btrfs_set_stack_inode_nbytes(inode_item, root->leafsize);
+	btrfs_set_stack_inode_nbytes(inode_item, root->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 
 	btrfs_set_root_flags(&root_item, 0);
@@ -3220,7 +3220,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	u64 last_dest_end = destoff;
 
 	ret = -ENOMEM;
-	buf = vmalloc(btrfs_level_size(root, 0));
+	buf = vmalloc(root->nodesize);
 	if (!buf)
 		return ret;
 
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index b7ab8b01ef66..5c7146066a60 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -335,7 +335,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 	for (i = 0; i < nr; i++) {
 		struct extent_buffer *next = read_tree_block(root,
 					btrfs_node_blockptr(c, i),
-					btrfs_level_size(root, level - 1),
+					root->nodesize,
 					btrfs_node_ptr_generation(c, i));
 		if (btrfs_is_leaf(next) &&
 		   level != 1)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 98cb6b2630f9..2989b72a768a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2068,7 +2068,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	if (srcid) {
 		struct btrfs_root *srcroot;
 		struct btrfs_key srckey;
-		int srcroot_level;
 
 		srckey.objectid = srcid;
 		srckey.type = BTRFS_ROOT_ITEM_KEY;
@@ -2080,8 +2079,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		}
 
 		rcu_read_lock();
-		srcroot_level = btrfs_header_level(srcroot->node);
-		level_size = btrfs_level_size(srcroot, srcroot_level);
+		level_size = srcroot->nodesize;
 		rcu_read_unlock();
 	}
 
@@ -2397,7 +2395,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		    found.type != BTRFS_METADATA_ITEM_KEY)
 			continue;
 		if (found.type == BTRFS_METADATA_ITEM_KEY)
-			num_bytes = fs_info->extent_root->leafsize;
+			num_bytes = fs_info->extent_root->nodesize;
 		else
 			num_bytes = found.offset;
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 09230cf3a244..85eb55d47d94 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -347,7 +347,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	if (!re)
 		return NULL;
 
-	blocksize = btrfs_level_size(root, level);
+	blocksize = root->nodesize;
 	re->logical = logical;
 	re->blocksize = blocksize;
 	re->top = *top;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b3329ad34522..2d221c46180c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1787,7 +1787,7 @@ again:
 			btrfs_node_key_to_cpu(parent, next_key, slot + 1);
 
 		old_bytenr = btrfs_node_blockptr(parent, slot);
-		blocksize = btrfs_level_size(dest, level - 1);
+		blocksize = dest->nodesize;
 		old_ptr_gen = btrfs_node_ptr_generation(parent, slot);
 
 		if (level <= max_level) {
@@ -1970,7 +1970,7 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 
 		bytenr = btrfs_node_blockptr(eb, path->slots[i]);
-		blocksize = btrfs_level_size(root, i - 1);
+		blocksize = root->nodesize;
 		eb = read_tree_block(root, bytenr, blocksize, ptr_gen);
 		if (!eb || !extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
@@ -2544,8 +2544,7 @@ u64 calcu_metadata_size(struct reloc_control *rc,
 			if (next->processed && (reserve || next != node))
 				break;
 
-			num_bytes += btrfs_level_size(rc->extent_root,
-						      next->level);
+			num_bytes += rc->extent_root->nodesize;
 
 			if (list_empty(&next->upper))
 				break;
@@ -2679,7 +2678,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 				goto next;
 		}
 
-		blocksize = btrfs_level_size(root, node->level);
+		blocksize = root->nodesize;
 		generation = btrfs_node_ptr_generation(upper->eb, slot);
 		eb = read_tree_block(root, bytenr, blocksize, generation);
 		if (!eb || !extent_buffer_uptodate(eb)) {
@@ -2789,7 +2788,7 @@ static void __mark_block_processed(struct reloc_control *rc,
 	u32 blocksize;
 	if (node->level == 0 ||
 	    in_block_group(node->bytenr, rc->block_group)) {
-		blocksize = btrfs_level_size(rc->extent_root, node->level);
+		blocksize = rc->extent_root->nodesize;
 		mark_block_processed(rc, node->bytenr, blocksize);
 	}
 	node->processed = 1;
@@ -2865,7 +2864,7 @@ static int reada_tree_block(struct reloc_control *rc,
 	if (block->key.type == BTRFS_METADATA_ITEM_KEY)
 		readahead_tree_block(rc->extent_root, block->bytenr,
 				     block->key.objectid,
-				     rc->extent_root->leafsize);
+				     rc->extent_root->nodesize);
 	else
 		readahead_tree_block(rc->extent_root, block->bytenr,
 				     block->key.objectid, block->key.offset);
@@ -3313,7 +3312,7 @@ static int add_tree_block(struct reloc_control *rc,
 		return -ENOMEM;
 
 	block->bytenr = extent_key->objectid;
-	block->key.objectid = rc->extent_root->leafsize;
+	block->key.objectid = rc->extent_root->nodesize;
 	block->key.offset = generation;
 	block->level = level;
 	block->key_ready = 0;
@@ -3640,7 +3639,7 @@ int add_data_references(struct reloc_control *rc,
 	struct btrfs_extent_inline_ref *iref;
 	unsigned long ptr;
 	unsigned long end;
-	u32 blocksize = btrfs_level_size(rc->extent_root, 0);
+	u32 blocksize = rc->extent_root->nodesize;
 	int ret = 0;
 	int err = 0;
 
@@ -3783,7 +3782,7 @@ next:
 		}
 
 		if (key.type == BTRFS_METADATA_ITEM_KEY &&
-		    key.objectid + rc->extent_root->leafsize <=
+		    key.objectid + rc->extent_root->nodesize <=
 		    rc->search_start) {
 			path->slots[0]++;
 			goto next;
@@ -3801,7 +3800,7 @@ next:
 				rc->search_start = key.objectid + key.offset;
 			else
 				rc->search_start = key.objectid +
-					rc->extent_root->leafsize;
+					rc->extent_root->nodesize;
 			memcpy(extent_key, &key, sizeof(key));
 			return 0;
 		}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 95cbb2024a11..ea089b50f391 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -137,7 +137,6 @@ struct scrub_ctx {
 	int			pages_per_rd_bio;
 	u32			sectorsize;
 	u32			nodesize;
-	u32			leafsize;
 
 	int			is_dev_replace;
 	struct scrub_wr_ctx	wr_ctx;
@@ -438,7 +437,6 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	}
 	sctx->first_free = 0;
 	sctx->nodesize = dev->dev_root->nodesize;
-	sctx->leafsize = dev->dev_root->leafsize;
 	sctx->sectorsize = dev->dev_root->sectorsize;
 	atomic_set(&sctx->bios_in_flight, 0);
 	atomic_set(&sctx->workers_pending, 0);
@@ -1757,7 +1755,6 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		   BTRFS_UUID_SIZE))
 		++fail;
 
-	WARN_ON(sctx->nodesize != sctx->leafsize);
 	len = sctx->nodesize - BTRFS_CSUM_SIZE;
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
@@ -2195,7 +2192,6 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 		sctx->stat.data_bytes_scrubbed += len;
 		spin_unlock(&sctx->stat_lock);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		WARN_ON(sctx->nodesize != sctx->leafsize);
 		blocksize = sctx->nodesize;
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.tree_extents_scrubbed++;
@@ -2486,7 +2482,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			btrfs_item_key_to_cpu(l, &key, slot);
 
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
-				bytes = root->leafsize;
+				bytes = root->nodesize;
 			else
 				bytes = key.offset;
 
@@ -2908,17 +2904,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
 
-	/*
-	 * check some assumptions
-	 */
-	if (fs_info->chunk_root->nodesize != fs_info->chunk_root->leafsize) {
-		btrfs_err(fs_info,
-			   "scrub: size assumption nodesize == leafsize (%d == %d) fails",
-		       fs_info->chunk_root->nodesize,
-		       fs_info->chunk_root->leafsize);
-		return -EINVAL;
-	}
-
 	if (fs_info->chunk_root->nodesize > BTRFS_STRIPE_LEN) {
 		/*
 		 * in this case scrub is unable to calculate the checksum
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index da77045785dc..fc75ef5678a1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -407,7 +407,7 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 	if (num_items > 0 && root != root->fs_info->chunk_root) {
 		if (root->fs_info->quota_enabled &&
 		    is_fstree(root->root_key.objectid)) {
-			qgroup_reserved = num_items * root->leafsize;
+			qgroup_reserved = num_items * root->nodesize;
 			ret = btrfs_qgroup_reserve(root, qgroup_reserved);
 			if (ret)
 				return ERR_PTR(ret);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 13cb636c420d..6e0fa1717d07 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2155,7 +2155,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		blocksize = btrfs_level_size(root, *level - 1);
+		blocksize = root->nodesize;
 
 		parent = path->nodes[*level];
 		root_owner = btrfs_header_owner(parent);
-- 
1.7.9

