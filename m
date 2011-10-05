From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/8] btrfs: separate superblock items out of fs_info
Date: Wed,  5 Oct 2011 12:21:37 +0200
Message-ID: <aab6db8776b89acf94c7b4af7b93e02f397af83c.1317746377.git.dsterba@suse.cz>
References: <cover.1317746377.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317746377.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

fs_info has now ~9kb, more than fits into one page. This will cause
mount failure when memory is too fragmented. Top space consumers are
super block structures super_copy and super_for_commit, ~2.8kb each.
Allocate them dynamically. fs_info will be ~3.5kb. (measured on x86_64)

Add a wrapper for freeing fs_info.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/compression.c |    3 ++-
 fs/btrfs/ctree.h       |   10 ++++++++--
 fs/btrfs/disk-io.c     |   21 ++++++++++-----------
 fs/btrfs/extent-tree.c |   18 +++++++++---------
 fs/btrfs/file-item.c   |   17 ++++++-----------
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |    6 +++---
 fs/btrfs/scrub.c       |    2 +-
 fs/btrfs/super.c       |   17 ++++++++++++-----
 fs/btrfs/transaction.c |   10 +++++-----
 fs/btrfs/tree-log.c    |    4 ++--
 fs/btrfs/volumes.c     |   24 ++++++++++++------------
 12 files changed, 71 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..14f1c5a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -85,7 +85,8 @@ struct compressed_bio {
 static inline int compressed_bio_size(struct btrfs_root *root,
 				      unsigned long disk_size)
 {
-	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+
 	return sizeof(struct compressed_bio) +
 		((disk_size + root->sectorsize - 1) / root->sectorsize) *
 		csum_size;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1eafccb..e7276f6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -935,8 +935,8 @@ struct btrfs_fs_info {
 	wait_queue_head_t transaction_blocked_wait;
 	wait_queue_head_t async_submit_wait;
 
-	struct btrfs_super_block super_copy;
-	struct btrfs_super_block super_for_commit;
+	struct btrfs_super_block *super_copy;
+	struct btrfs_super_block *super_for_commit;
 	struct block_device *__bdev;
 	struct super_block *sb;
 	struct inode *btree_inode;
@@ -2379,6 +2379,12 @@ static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 	smp_mb();
 	return fs_info->closing;
 }
+static inline void free_fs_info(struct btrfs_fs_info *fs_info)
+{
+	kfree(fs_info->super_copy);
+	kfree(fs_info->super_for_commit);
+	kfree(fs_info);
+}
 
 /* root-item.c */
 int btrfs_find_root_ref(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 51372a5..6cb5d4e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -256,8 +256,7 @@ void btrfs_csum_final(u32 crc, char *result)
 static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify)
 {
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	char *result = NULL;
 	unsigned long len;
 	unsigned long cur_len;
@@ -1766,14 +1765,14 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy));
-	memcpy(&fs_info->super_for_commit, &fs_info->super_copy,
-	       sizeof(fs_info->super_for_commit));
+	memcpy(fs_info->super_copy, bh->b_data, sizeof(*fs_info->super_copy));
+	memcpy(fs_info->super_for_commit, fs_info->super_copy,
+	       sizeof(*fs_info->super_for_commit));
 	brelse(bh);
 
-	memcpy(fs_info->fsid, fs_info->super_copy.fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	disk_super = &fs_info->super_copy;
+	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
 		goto fail_alloc;
 
@@ -2166,10 +2165,10 @@ fail_srcu:
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
-	kfree(fs_info);
 	kfree(chunk_root);
 	kfree(dev_root);
 	kfree(csum_root);
+	free_fs_info(fs_info);
 	return ERR_PTR(err);
 }
 
@@ -2338,10 +2337,10 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	int total_errors = 0;
 	u64 flags;
 
-	max_errors = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
+	max_errors = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 	do_barriers = !btrfs_test_opt(root, NOBARRIER);
 
-	sb = &root->fs_info->super_for_commit;
+	sb = root->fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
@@ -2629,7 +2628,7 @@ int close_ctree(struct btrfs_root *root)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
-	kfree(fs_info);
+	free_fs_info(fs_info);
 
 	return 0;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 25b69d0..8732585 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3201,7 +3201,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	 * about 1% of the FS size.
 	 */
 	if (force == CHUNK_ALLOC_LIMITED) {
-		thresh = btrfs_super_total_bytes(&root->fs_info->super_copy);
+		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 		thresh = max_t(u64, 64 * 1024 * 1024,
 			       div_factor_fine(thresh, 1));
 
@@ -3223,7 +3223,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
 		return 0;
 
-	thresh = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 
 	/* 256MB or 5% of the FS */
 	thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 5));
@@ -3808,7 +3808,7 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	u64 num_bytes;
 	u64 meta_used;
 	u64 data_used;
-	int csum_size = btrfs_super_csum_size(&fs_info->super_copy);
+	int csum_size = btrfs_super_csum_size(fs_info->super_copy);
 
 	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
 	spin_lock(&sinfo->lock);
@@ -4190,12 +4190,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 
 	/* block accounting for super block */
 	spin_lock(&info->delalloc_lock);
-	old_val = btrfs_super_bytes_used(&info->super_copy);
+	old_val = btrfs_super_bytes_used(info->super_copy);
 	if (alloc)
 		old_val += num_bytes;
 	else
 		old_val -= num_bytes;
-	btrfs_set_super_bytes_used(&info->super_copy, old_val);
+	btrfs_set_super_bytes_used(info->super_copy, old_val);
 	spin_unlock(&info->delalloc_lock);
 
 	while (total) {
@@ -4223,7 +4223,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		spin_lock(&cache->space_info->lock);
 		spin_lock(&cache->lock);
 
-		if (btrfs_super_cache_generation(&info->super_copy) != 0 &&
+		if (btrfs_super_cache_generation(info->super_copy) != 0 &&
 		    cache->disk_cache_state < BTRFS_DC_CLEAR)
 			cache->disk_cache_state = BTRFS_DC_CLEAR;
 
@@ -7037,9 +7037,9 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		return -ENOMEM;
 	path->reada = 1;
 
-	cache_gen = btrfs_super_cache_generation(&root->fs_info->super_copy);
+	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen != 0 &&
-	    btrfs_super_generation(&root->fs_info->super_copy) != cache_gen)
+	    btrfs_super_generation(root->fs_info->super_copy) != cache_gen)
 		need_clear = 1;
 	if (btrfs_test_opt(root, CLEAR_CACHE))
 		need_clear = 1;
@@ -7370,7 +7370,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 	int mixed = 0;
 	int ret;
 
-	disk_super = &fs_info->super_copy;
+	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
 		return 1;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a1cb782..c7fb3a4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -91,8 +91,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	struct btrfs_csum_item *item;
 	struct extent_buffer *leaf;
 	u64 csum_offset = 0;
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int csums_in_item;
 
 	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -162,8 +161,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 item_last_offset = 0;
 	u64 disk_bytenr;
 	u32 diff;
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item = NULL;
@@ -290,7 +288,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	int ret;
 	size_t size;
 	u64 csum_end;
-	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -492,8 +490,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 				      u64 bytenr, u64 len)
 {
 	struct extent_buffer *leaf;
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	u64 csum_end;
 	u64 end_byte = bytenr + len;
 	u32 blocksize_bits = root->fs_info->sb->s_blocksize_bits;
@@ -549,8 +546,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	u64 csum_end;
 	struct extent_buffer *leaf;
 	int ret;
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int blocksize_bits = root->fs_info->sb->s_blocksize_bits;
 
 	root = root->fs_info->csum_root;
@@ -676,8 +672,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	struct btrfs_sector_sum *sector_sum;
 	u32 nritems;
 	u32 ins_size;
-	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	if (!path)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 102e6c3..95f15b2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -820,7 +820,7 @@ static noinline int cow_file_range(struct inode *inode,
 	}
 
 	BUG_ON(disk_num_bytes >
-	       btrfs_super_total_bytes(&root->fs_info->super_copy));
+	       btrfs_super_total_bytes(root->fs_info->super_copy));
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 24fd75b..540e7d0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1128,7 +1128,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		mutex_unlock(&inode->i_mutex);
 	}
 
-	disk_super = &root->fs_info->super_copy;
+	disk_super = root->fs_info->super_copy;
 	features = btrfs_super_incompat_flags(disk_super);
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
@@ -2579,7 +2579,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 		return PTR_ERR(trans);
 	}
 
-	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
+	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
 	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, path,
 				   dir_id, "default", 7, 1);
 	if (IS_ERR_OR_NULL(di)) {
@@ -2595,7 +2595,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	disk_super = &root->fs_info->super_copy;
+	disk_super = root->fs_info->super_copy;
 	features = btrfs_super_incompat_flags(disk_super);
 	if (!(features & BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)) {
 		features |= BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a8d03d5..69a600f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -182,7 +182,7 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 	sdev->curr = -1;
 	atomic_set(&sdev->in_flight, 0);
 	atomic_set(&sdev->cancel_req, 0);
-	sdev->csum_size = btrfs_super_csum_size(&fs_info->super_copy);
+	sdev->csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	INIT_LIST_HEAD(&sdev->csum_list);
 
 	spin_lock_init(&sdev->list_lock);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 934789f..6636c9c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -507,7 +507,7 @@ static struct dentry *get_default_root(struct super_block *sb,
 	 * will mount by default if we haven't been given a specific subvolume
 	 * to mount.
 	 */
-	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
+	dir_id = btrfs_super_root_dir(root->fs_info->super_copy);
 	di = btrfs_lookup_dir_item(NULL, root, path, dir_id, "default", 7, 0);
 	if (IS_ERR(di)) {
 		btrfs_free_path(path);
@@ -899,6 +899,13 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	fs_info->fs_devices = fs_devices;
 	tree_root->fs_info = fs_info;
 
+	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
+	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
+	if (!fs_info->super_copy || !fs_info->super_for_commit) {
+		error = -ENOMEM;
+		goto error_close_devices;
+	}
+
 	bdev = fs_devices->latest_bdev;
 	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
 	if (IS_ERR(s)) {
@@ -913,7 +920,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		}
 
 		btrfs_close_devices(fs_devices);
-		kfree(fs_info);
+		free_fs_info(fs_info);
 		kfree(tree_root);
 	} else {
 		char b[BDEVNAME_SIZE];
@@ -941,7 +948,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 
 error_close_devices:
 	btrfs_close_devices(fs_devices);
-	kfree(fs_info);
+	free_fs_info(fs_info);
 	kfree(tree_root);
 	return ERR_PTR(error);
 }
@@ -967,7 +974,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (root->fs_info->fs_devices->rw_devices == 0)
 			return -EACCES;
 
-		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
+		if (btrfs_super_log_root(root->fs_info->super_copy) != 0)
 			return -EINVAL;
 
 		ret = btrfs_cleanup_fs_roots(root->fs_info);
@@ -1133,7 +1140,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_root *root = btrfs_sb(dentry->d_sb);
-	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
+	struct btrfs_super_block *disk_super = root->fs_info->super_copy;
 	struct list_head *head = &root->fs_info->space_info;
 	struct btrfs_space_info *found;
 	u64 total_used = 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4565579..20e0b20 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -992,7 +992,7 @@ static void update_super_roots(struct btrfs_root *root)
 	struct btrfs_root_item *root_item;
 	struct btrfs_super_block *super;
 
-	super = &root->fs_info->super_copy;
+	super = root->fs_info->super_copy;
 
 	root_item = &root->fs_info->chunk_root->root_item;
 	super->chunk_root = root_item->bytenr;
@@ -1303,12 +1303,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	update_super_roots(root);
 
 	if (!root->fs_info->log_root_recovering) {
-		btrfs_set_super_log_root(&root->fs_info->super_copy, 0);
-		btrfs_set_super_log_root_level(&root->fs_info->super_copy, 0);
+		btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+		btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	}
 
-	memcpy(&root->fs_info->super_for_commit, &root->fs_info->super_copy,
-	       sizeof(root->fs_info->super_copy));
+	memcpy(root->fs_info->super_for_commit, root->fs_info->super_copy,
+	       sizeof(*root->fs_info->super_copy));
 
 	trans->transaction->blocked = 0;
 	spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 786639f..5225c17 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2117,9 +2117,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
 
-	btrfs_set_super_log_root(&root->fs_info->super_for_commit,
+	btrfs_set_super_log_root(root->fs_info->super_for_commit,
 				log_root_tree->node->start);
-	btrfs_set_super_log_root_level(&root->fs_info->super_for_commit,
+	btrfs_set_super_log_root_level(root->fs_info->super_for_commit,
 				btrfs_header_level(log_root_tree->node));
 
 	log_root_tree->log_batch = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e138af7..8a05bd0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1397,8 +1397,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	call_rcu(&device->rcu, free_device);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
-	num_devices = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
-	btrfs_set_super_num_devices(&root->fs_info->super_copy, num_devices);
+	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
+	btrfs_set_super_num_devices(root->fs_info->super_copy, num_devices);
 
 	if (cur_devices->open_devices == 0) {
 		struct btrfs_fs_devices *fs_devices;
@@ -1460,7 +1460,7 @@ static int btrfs_prepare_sprout(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_fs_devices *old_devices;
 	struct btrfs_fs_devices *seed_devices;
-	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
+	struct btrfs_super_block *disk_super = root->fs_info->super_copy;
 	struct btrfs_device *device;
 	u64 super_flags;
 
@@ -1708,12 +1708,12 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 		root->fs_info->fs_devices->rotating = 1;
 
-	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
-	btrfs_set_super_total_bytes(&root->fs_info->super_copy,
+	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
+	btrfs_set_super_total_bytes(root->fs_info->super_copy,
 				    total_bytes + device->total_bytes);
 
-	total_bytes = btrfs_super_num_devices(&root->fs_info->super_copy);
-	btrfs_set_super_num_devices(&root->fs_info->super_copy,
+	total_bytes = btrfs_super_num_devices(root->fs_info->super_copy);
+	btrfs_set_super_num_devices(root->fs_info->super_copy,
 				    total_bytes + 1);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
@@ -1804,7 +1804,7 @@ static int __btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size)
 {
 	struct btrfs_super_block *super_copy =
-		&device->dev_root->fs_info->super_copy;
+		device->dev_root->fs_info->super_copy;
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 diff = new_size - device->total_bytes;
 
@@ -1863,7 +1863,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
 			chunk_offset)
 {
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
 	u8 *ptr;
@@ -2189,7 +2189,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	bool retried = false;
 	struct extent_buffer *l;
 	struct btrfs_key key;
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 old_size = device->total_bytes;
 	u64 diff = device->total_bytes - new_size;
@@ -2313,7 +2313,7 @@ static int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size)
 {
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct btrfs_disk_key disk_key;
 	u32 array_size;
 	u8 *ptr;
@@ -3655,7 +3655,7 @@ static int read_one_dev(struct btrfs_root *root,
 
 int btrfs_read_sys_array(struct btrfs_root *root)
 {
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
-- 
1.7.6

