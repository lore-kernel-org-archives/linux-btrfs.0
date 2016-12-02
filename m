Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbcLBFHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 09E1EABE4
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:46 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 01/18] btrfs: call functions that overwrite their root parameter with fs_info
Date: Fri,  2 Dec 2016 00:07:21 -0500
Message-Id: <1480655258-15400-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

There are 11 functions that accept a root parameter and immediately
overwrite it.  We can pass those an fs_info pointer instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h            |  4 ++--
 fs/btrfs/disk-io.c          |  4 ++--
 fs/btrfs/extent-tree.c      | 17 +++++++-------
 fs/btrfs/file-item.c        |  5 ++---
 fs/btrfs/free-space-cache.c |  5 ++---
 fs/btrfs/free-space-cache.h |  2 +-
 fs/btrfs/transaction.c      |  9 ++++----
 fs/btrfs/tree-log.c         |  6 ++---
 fs/btrfs/volumes.c          | 55 +++++++++++++++++++++------------------------
 fs/btrfs/volumes.h          |  4 ++--
 10 files changed, 52 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1b25a46..51cd757 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2639,7 +2639,7 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
-int btrfs_read_block_groups(struct btrfs_root *root);
+int btrfs_read_block_groups(struct btrfs_fs_info *info);
 int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
@@ -3055,7 +3055,7 @@ int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 /* file-item.c */
 struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, u64 bytenr, u64 len);
+		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 811662c..92c2aea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2937,7 +2937,7 @@ int open_ctree(struct super_block *sb,
 	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
 	   btrfs_header_chunk_tree_uuid(chunk_root->node), BTRFS_UUID_SIZE);
 
-	ret = btrfs_read_chunk_tree(chunk_root);
+	ret = btrfs_read_chunk_tree(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "failed to read chunk tree: %d", ret);
 		goto fail_tree_roots;
@@ -3038,7 +3038,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_sysfs;
 	}
 
-	ret = btrfs_read_block_groups(fs_info->extent_root);
+	ret = btrfs_read_block_groups(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "failed to read block groups: %d", ret);
 		goto fail_sysfs;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d80136..13ef5d5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2414,7 +2414,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			btrfs_pin_extent(root, node->bytenr,
 					 node->num_bytes, 1);
 			if (head->is_data) {
-				ret = btrfs_del_csums(trans, root,
+				ret = btrfs_del_csums(trans, root->fs_info,
 						      node->bytenr,
 						      node->num_bytes);
 			}
@@ -3622,7 +3622,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
 
 		if (cache->disk_cache_state == BTRFS_DC_SETUP) {
 			cache->io_ctl.inode = NULL;
-			ret = btrfs_write_out_cache(root, trans, cache, path);
+			ret = btrfs_write_out_cache(root->fs_info, trans,
+						    cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
 				num_started++;
 				should_put = 0;
@@ -3774,7 +3775,8 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 
 		if (!ret && cache->disk_cache_state == BTRFS_DC_SETUP) {
 			cache->io_ctl.inode = NULL;
-			ret = btrfs_write_out_cache(root, trans, cache, path);
+			ret = btrfs_write_out_cache(root->fs_info, trans,
+						    cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
 				num_started++;
 				should_put = 0;
@@ -7068,7 +7070,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
-			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
+			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
 				goto out;
@@ -9925,12 +9927,12 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 	return cache;
 }
 
-int btrfs_read_block_groups(struct btrfs_root *root)
+int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
+	struct btrfs_root *root = info->extent_root;
 	struct btrfs_path *path;
 	int ret;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -9943,7 +9945,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	feature = btrfs_super_incompat_flags(info->super_copy);
 	mixed = !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
 
-	root = info->extent_root;
 	key.objectid = 0;
 	key.offset = 0;
 	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
@@ -10733,7 +10734,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 * Btrfs_remove_chunk will abort the transaction if things go
 		 * horribly wrong.
 		 */
-		ret = btrfs_remove_chunk(trans, root,
+		ret = btrfs_remove_chunk(trans, fs_info,
 					 block_group->key.objectid);
 
 		if (ret) {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5e74178..41c1145 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -590,8 +590,9 @@ static noinline void truncate_one_csum(struct btrfs_root *root,
  * range of bytes.
  */
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, u64 bytenr, u64 len)
+		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len)
 {
+	struct btrfs_root *root = fs_info->csum_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	u64 end_byte = bytenr + len;
@@ -601,8 +602,6 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int blocksize_bits = root->fs_info->sb->s_blocksize_bits;
 
-	root = root->fs_info->csum_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c698dcc..a538133 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1350,17 +1350,16 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	goto out;
 }
 
-int btrfs_write_out_cache(struct btrfs_root *root,
+int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct inode *inode;
 	int ret = 0;
 
-	root = root->fs_info->tree_root;
-
 	spin_lock(&block_group->lock);
 	if (block_group->disk_cache_state < BTRFS_DC_SETUP) {
 		spin_unlock(&block_group->lock);
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 363fdd9..70e7a7c 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -72,7 +72,7 @@ int btrfs_wait_cache_io(struct btrfs_root *root,
 			struct btrfs_block_group_cache *block_group,
 			struct btrfs_io_ctl *io_ctl,
 			struct btrfs_path *path, u64 offset);
-int btrfs_write_out_cache(struct btrfs_root *root,
+int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9517de0..88be1f8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1219,10 +1219,9 @@ void btrfs_add_dead_root(struct btrfs_root *root)
  * update all the cowonly tree roots on disk
  */
 static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root)
+				    struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *gang[8];
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int i;
 	int ret;
 	int err = 0;
@@ -1236,7 +1235,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 		if (ret == 0)
 			break;
 		for (i = 0; i < ret; i++) {
-			root = gang[i];
+			struct btrfs_root *root = gang[i];
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
@@ -1343,7 +1342,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&fs_info->tree_log_mutex);
 
-	ret = commit_fs_roots(trans, src);
+	ret = commit_fs_roots(trans, fs_info);
 	if (ret)
 		goto out;
 	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
@@ -2132,7 +2131,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	mutex_lock(&root->fs_info->tree_log_mutex);
 
-	ret = commit_fs_roots(trans, root);
+	ret = commit_fs_roots(trans, root->fs_info);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e0478f5..72bd398 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -797,9 +797,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						list);
 				if (!ret)
 					ret = btrfs_del_csums(trans,
-						      root->fs_info->csum_root,
-						      sums->bytenr,
-						      sums->len);
+							      root->fs_info,
+							      sums->bytenr,
+							      sums->len);
 				if (!ret)
 					ret = btrfs_csum_file_blocks(trans,
 						root->fs_info->csum_root,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1886b94..6ce3d15 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1667,9 +1667,10 @@ static noinline int find_next_devid(struct btrfs_fs_info *fs_info,
  * the btrfs_device struct should be fully filled in
  */
 static int btrfs_add_device(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
+			    struct btrfs_fs_info *fs_info,
 			    struct btrfs_device *device)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_dev_item *dev_item;
@@ -1677,8 +1678,6 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	unsigned long ptr;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1737,16 +1736,15 @@ static void update_dev_time(char *path_name)
 	filp_close(filp, NULL);
 }
 
-static int btrfs_rm_dev_item(struct btrfs_root *root,
+static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 			     struct btrfs_device *device)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_trans_handle *trans;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1909,7 +1907,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
 	 * counter although write_all_supers() is not locked out. This
 	 * could give a filesystem state which requires a degraded mount.
 	 */
-	ret = btrfs_rm_dev_item(root->fs_info->chunk_root, device);
+	ret = btrfs_rm_dev_item(root->fs_info, device);
 	if (ret)
 		goto error_undo;
 
@@ -2241,8 +2239,9 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
  * Store the expected generation for seed devices in device items.
  */
 static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
+			       struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_dev_item *dev_item;
@@ -2257,7 +2256,6 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	root = root->fs_info->chunk_root;
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.offset = 0;
 	key.type = BTRFS_DEV_ITEM_KEY;
@@ -2452,7 +2450,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		}
 	}
 
-	ret = btrfs_add_device(trans, root, device);
+	ret = btrfs_add_device(trans, root->fs_info, device);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto error_trans;
@@ -2461,7 +2459,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (seeding_dev) {
 		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 
-		ret = btrfs_finish_sprout(trans, root);
+		ret = btrfs_finish_sprout(trans, root->fs_info);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto error_trans;
@@ -2716,14 +2714,14 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, u64 chunk_objectid,
+			    struct btrfs_fs_info *fs_info, u64 chunk_objectid,
 			    u64 chunk_offset)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 
-	root = root->fs_info->chunk_root;
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2800,8 +2798,9 @@ static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 }
 
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, u64 chunk_offset)
+		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
@@ -2812,8 +2811,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 
 	/* Just in case */
-	root = root->fs_info->chunk_root;
-	em_tree = &root->fs_info->mapping_tree.map_tree;
+	em_tree = &fs_info->mapping_tree.map_tree;
 
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
@@ -2875,7 +2873,8 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	ret = btrfs_free_chunk(trans, root, chunk_objectid, chunk_offset);
+	ret = btrfs_free_chunk(trans, root->fs_info, chunk_objectid,
+			       chunk_offset);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -2903,15 +2902,13 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
+static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
-	struct btrfs_root *extent_root;
+	struct btrfs_root *root = fs_info->chunk_root;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	root = root->fs_info->chunk_root;
-	extent_root = root->fs_info->extent_root;
-
 	/*
 	 * Prevent races with automatic removal of unused block groups.
 	 * After we relocate and before we remove the chunk with offset
@@ -2949,7 +2946,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 	 * step two, delete the device extents and the
 	 * chunk tree entries
 	 */
-	ret = btrfs_remove_chunk(trans, root, chunk_offset);
+	ret = btrfs_remove_chunk(trans, fs_info, chunk_offset);
 	btrfs_end_transaction(trans, extent_root);
 	return ret;
 }
@@ -3003,7 +3000,7 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 		btrfs_release_path(path);
 
 		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
-			ret = btrfs_relocate_chunk(chunk_root,
+			ret = btrfs_relocate_chunk(root->fs_info,
 						   found_key.offset);
 			if (ret == -ENOSPC)
 				failed++;
@@ -3669,8 +3666,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 			chunk_reserved = 1;
 		}
 
-		ret = btrfs_relocate_chunk(chunk_root,
-					   found_key.offset);
+		ret = btrfs_relocate_chunk(fs_info, found_key.offset);
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
 			goto error;
@@ -4439,7 +4435,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
 		btrfs_release_path(path);
 
-		ret = btrfs_relocate_chunk(root, chunk_offset);
+		ret = btrfs_relocate_chunk(root->fs_info, chunk_offset);
 		mutex_unlock(&root->fs_info->delete_unused_bgs_mutex);
 		if (ret && ret != -ENOSPC)
 			goto done;
@@ -6785,8 +6781,9 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	return -EIO;
 }
 
-int btrfs_read_chunk_tree(struct btrfs_root *root)
+int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
@@ -6795,8 +6792,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	int slot;
 	u64 total_dev = 0;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9029a31..416574f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -407,7 +407,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
 int btrfs_read_sys_array(struct btrfs_root *root);
-int btrfs_read_chunk_tree(struct btrfs_root *root);
+int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 type);
 void btrfs_mapping_init(struct btrfs_mapping_tree *tree);
@@ -483,7 +483,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 				struct btrfs_root *extent_root,
 				u64 chunk_offset, u64 chunk_size);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root, u64 chunk_offset);
+		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
 
 static inline int btrfs_dev_stats_dirty(struct btrfs_device *dev)
 {
-- 
2.7.1

