From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] btrfs: separate fs_info allocation from open_ctree()
Date: Thu, 23 Jul 2009 21:14:54 +0300
Message-ID: <1248372894.7187.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752345AbZGWSO5@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

The open_ctree() function is huge so lets move fs_info allocation to a
separate function to clean it up a bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/btrfs/disk-io.c |  163 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 89 insertions(+), 74 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d28d29c..7ea94c1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1520,19 +1520,8 @@ sleep:
 	return 0;
 }
 
-struct btrfs_root *open_ctree(struct super_block *sb,
-			      struct btrfs_fs_devices *fs_devices,
-			      char *options)
+static struct btrfs_fs_info *btrfs_alloc_fs_info(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
-	u32 sectorsize;
-	u32 nodesize;
-	u32 leafsize;
-	u32 blocksize;
-	u32 stripesize;
-	u64 generation;
-	u64 features;
-	struct btrfs_key location;
-	struct buffer_head *bh;
 	struct btrfs_root *extent_root = kzalloc(sizeof(struct btrfs_root),
 						 GFP_NOFS);
 	struct btrfs_root *csum_root = kzalloc(sizeof(struct btrfs_root),
@@ -1545,13 +1534,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 						GFP_NOFS);
 	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
 					      GFP_NOFS);
-	struct btrfs_root *log_tree_root;
 
-	int ret;
 	int err = -EINVAL;
 
-	struct btrfs_super_block *disk_super;
-
 	if (!extent_root || !tree_root || !fs_info ||
 	    !chunk_root || !dev_root || !csum_root) {
 		err = -ENOMEM;
@@ -1646,8 +1631,46 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_throttle);
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
+	return fs_info;
 
-	__setup_root(4096, 4096, 4096, 4096, tree_root,
+fail_bdi:
+	bdi_destroy(&fs_info->bdi);
+fail:
+	kfree(extent_root);
+	kfree(tree_root);
+	kfree(fs_info);
+	kfree(chunk_root);
+	kfree(dev_root);
+	kfree(csum_root);
+
+	return ERR_PTR(err);
+}
+
+struct btrfs_root *open_ctree(struct super_block *sb,
+			      struct btrfs_fs_devices *fs_devices,
+			      char *options)
+{
+	struct btrfs_super_block *disk_super;
+	struct btrfs_root *log_tree_root;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_key location;
+	struct buffer_head *bh;
+	int ret, err = -EINVAL;
+	u32 sectorsize;
+	u32 nodesize;
+	u32 leafsize;
+	u32 blocksize;
+	u32 stripesize;
+	u64 generation;
+	u64 features;
+
+	fs_info = btrfs_alloc_fs_info(sb, fs_devices);
+	if (IS_ERR(fs_info)) {
+		err = PTR_ERR(fs_info);
+		goto fail;
+	}
+
+	__setup_root(4096, 4096, 4096, 4096, fs_info->tree_root,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 
@@ -1666,7 +1689,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!btrfs_super_root(disk_super))
 		goto fail_iput;
 
-	ret = btrfs_parse_options(tree_root, options);
+	ret = btrfs_parse_options(fs_info->tree_root, options);
 	if (ret) {
 		err = ret;
 		goto fail_iput;
@@ -1765,10 +1788,10 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	leafsize = btrfs_super_leafsize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
 	stripesize = btrfs_super_stripesize(disk_super);
-	tree_root->nodesize = nodesize;
-	tree_root->leafsize = leafsize;
-	tree_root->sectorsize = sectorsize;
-	tree_root->stripesize = stripesize;
+	fs_info->tree_root->nodesize = nodesize;
+	fs_info->tree_root->leafsize = leafsize;
+	fs_info->tree_root->sectorsize = sectorsize;
+	fs_info->tree_root->stripesize = stripesize;
 
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
@@ -1780,7 +1803,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	}
 
 	mutex_lock(&fs_info->chunk_mutex);
-	ret = btrfs_read_sys_array(tree_root);
+	ret = btrfs_read_sys_array(fs_info->tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
 		printk(KERN_WARNING "btrfs: failed to read the system "
@@ -1788,26 +1811,26 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	blocksize = btrfs_level_size(tree_root,
+	blocksize = btrfs_level_size(fs_info->tree_root,
 				     btrfs_super_chunk_root_level(disk_super));
 	generation = btrfs_super_chunk_root_generation(disk_super);
 
 	__setup_root(nodesize, leafsize, sectorsize, stripesize,
-		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
-	chunk_root->node = read_tree_block(chunk_root,
+	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
 					   btrfs_super_chunk_root(disk_super),
 					   blocksize, generation);
-	BUG_ON(!chunk_root->node);
-	btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
-	chunk_root->commit_root = btrfs_root_node(chunk_root);
+	BUG_ON(!fs_info->chunk_root->node);
+	btrfs_set_root_node(&fs_info->chunk_root->root_item, fs_info->chunk_root->node);
+	fs_info->chunk_root->commit_root = btrfs_root_node(fs_info->chunk_root);
 
-	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
-	   (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
+	read_extent_buffer(fs_info->chunk_root->node, fs_info->chunk_tree_uuid,
+	   (unsigned long)btrfs_header_chunk_tree_uuid(fs_info->chunk_root->node),
 	   BTRFS_UUID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
-	ret = btrfs_read_chunk_tree(chunk_root);
+	ret = btrfs_read_chunk_tree(fs_info->chunk_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
 		printk(KERN_WARNING "btrfs: failed to read chunk tree on %s\n",
@@ -1817,57 +1840,57 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	btrfs_close_extra_devices(fs_devices);
 
-	blocksize = btrfs_level_size(tree_root,
+	blocksize = btrfs_level_size(fs_info->tree_root,
 				     btrfs_super_root_level(disk_super));
 	generation = btrfs_super_generation(disk_super);
 
-	tree_root->node = read_tree_block(tree_root,
+	fs_info->tree_root->node = read_tree_block(fs_info->tree_root,
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
-	if (!tree_root->node)
+	if (!fs_info->tree_root->node)
 		goto fail_chunk_root;
-	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
-	tree_root->commit_root = btrfs_root_node(tree_root);
+	btrfs_set_root_node(&fs_info->tree_root->root_item, fs_info->tree_root->node);
+	fs_info->tree_root->commit_root = btrfs_root_node(fs_info->tree_root);
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
+	ret = find_and_setup_root(fs_info->tree_root, fs_info,
+				  BTRFS_EXTENT_TREE_OBJECTID, fs_info->extent_root);
 	if (ret)
 		goto fail_tree_root;
-	extent_root->track_dirty = 1;
+	fs_info->extent_root->track_dirty = 1;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_DEV_TREE_OBJECTID, dev_root);
+	ret = find_and_setup_root(fs_info->tree_root, fs_info,
+				  BTRFS_DEV_TREE_OBJECTID, fs_info->dev_root);
 	if (ret)
 		goto fail_extent_root;
-	dev_root->track_dirty = 1;
+	fs_info->dev_root->track_dirty = 1;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
+	ret = find_and_setup_root(fs_info->tree_root, fs_info,
+				  BTRFS_CSUM_TREE_OBJECTID, fs_info->csum_root);
 	if (ret)
 		goto fail_dev_root;
 
-	csum_root->track_dirty = 1;
+	fs_info->csum_root->track_dirty = 1;
 
-	btrfs_read_block_groups(extent_root);
+	btrfs_read_block_groups(fs_info->extent_root);
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
 	fs_info->metadata_alloc_profile = (u64)-1;
 	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
-	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
+	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, fs_info->tree_root,
 					       "btrfs-cleaner");
 	if (IS_ERR(fs_info->cleaner_kthread))
 		goto fail_csum_root;
 
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
-						   tree_root,
+						   fs_info->tree_root,
 						   "btrfs-transaction");
 	if (IS_ERR(fs_info->transaction_kthread))
 		goto fail_cleaner;
 
-	if (!btrfs_test_opt(tree_root, SSD) &&
-	    !btrfs_test_opt(tree_root, NOSSD) &&
+	if (!btrfs_test_opt(fs_info->tree_root, SSD) &&
+	    !btrfs_test_opt(fs_info->tree_root, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
 		printk(KERN_INFO "Btrfs detected SSD devices, enabling SSD "
 		       "mode\n");
@@ -1884,7 +1907,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 			goto fail_trans_kthread;
 		}
 		blocksize =
-		     btrfs_level_size(tree_root,
+		     btrfs_level_size(fs_info->tree_root,
 				      btrfs_super_log_root_level(disk_super));
 
 		log_tree_root = kzalloc(sizeof(struct btrfs_root),
@@ -1893,20 +1916,20 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
-		log_tree_root->node = read_tree_block(tree_root, bytenr,
+		log_tree_root->node = read_tree_block(fs_info->tree_root, bytenr,
 						      blocksize,
 						      generation + 1);
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 
 		if (sb->s_flags & MS_RDONLY) {
-			ret =  btrfs_commit_super(tree_root);
+			ret =  btrfs_commit_super(fs_info->tree_root);
 			BUG_ON(ret);
 		}
 	}
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		ret = btrfs_recover_relocation(tree_root);
+		ret = btrfs_recover_relocation(fs_info->tree_root);
 		BUG_ON(ret);
 	}
 
@@ -1918,7 +1941,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!fs_info->fs_root)
 		goto fail_trans_kthread;
 
-	return tree_root;
+	return fs_info->tree_root;
 
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
@@ -1933,20 +1956,20 @@ fail_cleaner:
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 
 fail_csum_root:
-	free_extent_buffer(csum_root->node);
-	free_extent_buffer(csum_root->commit_root);
+	free_extent_buffer(fs_info->csum_root->node);
+	free_extent_buffer(fs_info->csum_root->commit_root);
 fail_dev_root:
-	free_extent_buffer(dev_root->node);
-	free_extent_buffer(dev_root->commit_root);
+	free_extent_buffer(fs_info->dev_root->node);
+	free_extent_buffer(fs_info->dev_root->commit_root);
 fail_extent_root:
-	free_extent_buffer(extent_root->node);
-	free_extent_buffer(extent_root->commit_root);
+	free_extent_buffer(fs_info->extent_root->node);
+	free_extent_buffer(fs_info->extent_root->commit_root);
 fail_tree_root:
-	free_extent_buffer(tree_root->node);
-	free_extent_buffer(tree_root->commit_root);
+	free_extent_buffer(fs_info->tree_root->node);
+	free_extent_buffer(fs_info->tree_root->commit_root);
 fail_chunk_root:
-	free_extent_buffer(chunk_root->node);
-	free_extent_buffer(chunk_root->commit_root);
+	free_extent_buffer(fs_info->chunk_root->node);
+	free_extent_buffer(fs_info->chunk_root->commit_root);
 fail_sb_buffer:
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
@@ -1962,15 +1985,7 @@ fail_iput:
 
 	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
-fail_bdi:
-	bdi_destroy(&fs_info->bdi);
 fail:
-	kfree(extent_root);
-	kfree(tree_root);
-	kfree(fs_info);
-	kfree(chunk_root);
-	kfree(dev_root);
-	kfree(csum_root);
 	return ERR_PTR(err);
 }
 
-- 
1.5.6.3
