From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 2/3] btrfs: pass fs_info to btrfs_test_opt instead of root
Date: Tue, 31 May 2011 12:16:25 +0200
Message-ID: <05e6777c204031bd94288501d3feecbe06157f66.1306836192.git.sensille@gmx.net>
References: <cover.1306836192.git.sensille@gmx.net>
Cc: julia@diku.dk
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306836192.git.sensille@gmx.net>
In-Reply-To: <cover.1306836192.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_test_opt only needs fs_info from the root passed. So just pass
the fs_info directly.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/disk-io.c          |    8 +++---
 fs/btrfs/extent-tree.c      |   55 ++++++++++++++++++++++---------------------
 fs/btrfs/file.c             |    2 +-
 fs/btrfs/free-space-cache.c |    2 +-
 fs/btrfs/inode.c            |   10 ++++----
 fs/btrfs/ioctl.c            |    2 +-
 fs/btrfs/super.c            |   30 +++++++++++-----------
 fs/btrfs/transaction.c      |    5 ++-
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |    2 +-
 fs/btrfs/volumes.c          |    9 ++++---
 12 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b51a06c..b2fdcca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1343,7 +1343,7 @@ struct btrfs_ioctl_defrag_range_args {
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
-#define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
+#define btrfs_test_opt(fs_info, opt)	((fs_info)->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 /*
  * Inode flags
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c67a1e6..4d28eaf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1990,8 +1990,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (IS_ERR(fs_info->transaction_kthread))
 		goto fail_cleaner;
 
-	if (!btrfs_test_opt(tree_root, SSD) &&
-	    !btrfs_test_opt(tree_root, NOSSD) &&
+	if (!btrfs_test_opt(fs_info, SSD) &&
+	    !btrfs_test_opt(fs_info, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
 		printk(KERN_INFO "Btrfs detected SSD devices, enabling SSD "
 		       "mode\n");
@@ -2304,7 +2304,7 @@ int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	u64 flags;
 
 	max_errors = btrfs_super_num_devices(&root->fs_info->super_copy) - 1;
-	do_barriers = !btrfs_test_opt(root, NOBARRIER);
+	do_barriers = !btrfs_test_opt(root->fs_info, NOBARRIER);
 
 	sb = &root->fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
@@ -3002,7 +3002,7 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 			break;
 
 		/* opt_discard */
-		if (btrfs_test_opt(root, DISCARD))
+		if (btrfs_test_opt(root->fs_info, DISCARD))
 			ret = btrfs_error_discard_extent(root, start,
 							 end + 1 - start,
 							 NULL);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2236c77..27cc348 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4298,7 +4298,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		if (ret)
 			break;
 
-		if (btrfs_test_opt(root, DISCARD))
+		if (btrfs_test_opt(fs_info, DISCARD))
 			ret = btrfs_discard_extent(root, start,
 						   end + 1 - start, NULL);
 
@@ -4811,7 +4811,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     int data)
 {
 	int ret = 0;
-	struct btrfs_root *root = orig_root->fs_info->extent_root;
+	struct btrfs_fs_info *fs_info = orig_root->fs_info;
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	int empty_cluster = 2 * 1024 * 1024;
@@ -4833,7 +4834,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	space_info = __find_space_info(root->fs_info, data);
+	space_info = __find_space_info(fs_info, data);
 	if (!space_info) {
 		printk(KERN_ERR "No space info for %d\n", data);
 		return -ENOSPC;
@@ -4850,14 +4851,14 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		allowed_chunk_alloc = 1;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
-		last_ptr = &root->fs_info->meta_alloc_cluster;
-		if (!btrfs_test_opt(root, SSD))
+		last_ptr = &fs_info->meta_alloc_cluster;
+		if (!btrfs_test_opt(fs_info, SSD))
 			empty_cluster = 64 * 1024;
 	}
 
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
-	    btrfs_test_opt(root, SSD)) {
-		last_ptr = &root->fs_info->data_alloc_cluster;
+	    btrfs_test_opt(fs_info, SSD)) {
+		last_ptr = &fs_info->data_alloc_cluster;
 	}
 
 	if (last_ptr) {
@@ -4875,8 +4876,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	if (search_start == hint_byte) {
 ideal_cache:
-		block_group = btrfs_lookup_block_group(root->fs_info,
-						       search_start);
+		block_group = btrfs_lookup_block_group(fs_info, search_start);
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
@@ -5307,6 +5307,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	u64 search_start = 0;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	data = btrfs_get_alloc_profile(root, data);
 again:
@@ -5315,7 +5316,7 @@ again:
 	 * is not called recursively on allocations
 	 */
 	if (empty_size || root->ref_cows)
-		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+		ret = do_chunk_alloc(trans, fs_info->extent_root,
 				     num_bytes + 2 * 1024 * 1024, data,
 				     CHUNK_ALLOC_NO_FORCE);
 
@@ -5328,14 +5329,14 @@ again:
 		num_bytes = num_bytes >> 1;
 		num_bytes = num_bytes & ~(root->sectorsize - 1);
 		num_bytes = max(num_bytes, min_alloc_size);
-		do_chunk_alloc(trans, root->fs_info->extent_root,
+		do_chunk_alloc(trans, fs_info->extent_root,
 			       num_bytes, data, CHUNK_ALLOC_FORCE);
 		goto again;
 	}
-	if (ret == -ENOSPC && btrfs_test_opt(root, ENOSPC_DEBUG)) {
+	if (ret == -ENOSPC && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
 		struct btrfs_space_info *sinfo;
 
-		sinfo = __find_space_info(root->fs_info, data);
+		sinfo = __find_space_info(fs_info, data);
 		printk(KERN_ERR "btrfs allocation failed flags %llu, "
 		       "wanted %llu\n", (unsigned long long)data,
 		       (unsigned long long)num_bytes);
@@ -5359,7 +5360,7 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 		return -ENOSPC;
 	}
 
-	if (btrfs_test_opt(root, DISCARD))
+	if (btrfs_test_opt(root->fs_info, DISCARD))
 		ret = btrfs_discard_extent(root, start, len, NULL);
 
 	btrfs_add_free_space(cache, start, len);
@@ -6863,7 +6864,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	struct btrfs_path *path;
 	int ret;
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
@@ -6871,7 +6872,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	int need_clear = 0;
 	u64 cache_gen;
 
-	root = info->extent_root;
+	root = fs_info->extent_root;
 	key.objectid = 0;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_BLOCK_GROUP_ITEM_KEY);
@@ -6879,13 +6880,13 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
-	cache_gen = btrfs_super_cache_generation(&root->fs_info->super_copy);
+	cache_gen = btrfs_super_cache_generation(&fs_info->super_copy);
 	if (cache_gen != 0 &&
-	    btrfs_super_generation(&root->fs_info->super_copy) != cache_gen)
+	    btrfs_super_generation(&fs_info->super_copy) != cache_gen)
 		need_clear = 1;
-	if (btrfs_test_opt(root, CLEAR_CACHE))
+	if (btrfs_test_opt(fs_info, CLEAR_CACHE))
 		need_clear = 1;
-	if (!btrfs_test_opt(root, SPACE_CACHE) && cache_gen)
+	if (!btrfs_test_opt(fs_info, SPACE_CACHE) && cache_gen)
 		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
 
 	while (1) {
@@ -6911,7 +6912,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		atomic_set(&cache->count, 1);
 		spin_lock_init(&cache->lock);
-		cache->fs_info = info;
+		cache->fs_info = fs_info;
 		INIT_LIST_HEAD(&cache->list);
 		INIT_LIST_HEAD(&cache->cluster_list);
 
@@ -6951,14 +6952,14 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
 			cache->last_byte_to_unpin = (u64)-1;
 			cache->cached = BTRFS_CACHE_FINISHED;
-			add_new_free_space(cache, root->fs_info,
+			add_new_free_space(cache, fs_info,
 					   found_key.objectid,
 					   found_key.objectid +
 					   found_key.offset);
 			free_excluded_extents(root, cache);
 		}
 
-		ret = update_space_info(info, cache->flags, found_key.offset,
+		ret = update_space_info(fs_info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
 					&space_info);
 		BUG_ON(ret);
@@ -6969,15 +6970,15 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 
 		__link_block_group(space_info, cache);
 
-		ret = btrfs_add_block_group_cache(root->fs_info, cache);
+		ret = btrfs_add_block_group_cache(fs_info, cache);
 		BUG_ON(ret);
 
-		set_avail_alloc_bits(root->fs_info, cache->flags);
+		set_avail_alloc_bits(fs_info, cache->flags);
 		if (btrfs_chunk_readonly(root, cache->key.objectid))
 			set_block_group_ro(cache);
 	}
 
-	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
+	list_for_each_entry_rcu(space_info, &fs_info->space_info, list) {
 		if (!(get_alloc_profile(root, space_info->flags) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
@@ -6993,7 +6994,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 			set_block_group_ro(cache);
 	}
 
-	init_global_block_rsv(info);
+	init_global_block_rsv(fs_info);
 	ret = 0;
 error:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c6a22d7..3446d39 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -126,7 +126,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	u64 transid;
 
-	if (!btrfs_test_opt(root, AUTO_DEFRAG))
+	if (!btrfs_test_opt(root->fs_info, AUTO_DEFRAG))
 		return 0;
 
 	if (root->fs_info->closing)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 898f184..a5c353f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2257,7 +2257,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	int ret;
 
 	/* for metadata, allow allocates with more holes */
-	if (btrfs_test_opt(root, SSD_SPREAD)) {
+	if (btrfs_test_opt(root->fs_info, SSD_SPREAD)) {
 		min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
 		/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 25e73f1..c2264e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -389,7 +389,7 @@ again:
 	 * change at any time if we discover bad compression ratios.
 	 */
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
-	    (btrfs_test_opt(root, COMPRESS) ||
+	    (btrfs_test_opt(root->fs_info, COMPRESS) ||
 	     (BTRFS_I(inode)->force_compress) ||
 	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
 		WARN_ON(pages);
@@ -500,7 +500,7 @@ again:
 		nr_pages_ret = 0;
 
 		/* flag the file so we don't compress in the future */
-		if (!btrfs_test_opt(root, FORCE_COMPRESS) &&
+		if (!btrfs_test_opt(root->fs_info, FORCE_COMPRESS) &&
 		    !(BTRFS_I(inode)->force_compress)) {
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
 		}
@@ -1280,7 +1280,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC)
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	else if (!btrfs_test_opt(root, COMPRESS) &&
+	else if (!btrfs_test_opt(root->fs_info, COMPRESS) &&
 		 !(BTRFS_I(inode)->force_compress) &&
 		 !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))
 		ret = cow_file_range(inode, locked_page, start, end,
@@ -4516,9 +4516,9 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_inherit_iflags(inode, dir);
 
 	if ((mode & S_IFREG)) {
-		if (btrfs_test_opt(root, NODATASUM))
+		if (btrfs_test_opt(root->fs_info, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
-		if (btrfs_test_opt(root, NODATACOW) ||
+		if (btrfs_test_opt(root->fs_info, NODATACOW) ||
 		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
 	}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index db439a3..b8cae79 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1854,7 +1854,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		 * rmdir(2).
 		 */
 		err = -EPERM;
-		if (!btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
+		if (!btrfs_test_opt(root->fs_info, USER_SUBVOL_RM_ALLOWED))
 			goto out_dput;
 
 		/*
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9b2e7e5..6a6472b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -670,13 +670,13 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct btrfs_fs_info *info = root->fs_info;
 	char *compress_type;
 
-	if (btrfs_test_opt(root, DEGRADED))
+	if (btrfs_test_opt(info, DEGRADED))
 		seq_puts(seq, ",degraded");
-	if (btrfs_test_opt(root, NODATASUM))
+	if (btrfs_test_opt(info, NODATASUM))
 		seq_puts(seq, ",nodatasum");
-	if (btrfs_test_opt(root, NODATACOW))
+	if (btrfs_test_opt(info, NODATACOW))
 		seq_puts(seq, ",nodatacow");
-	if (btrfs_test_opt(root, NOBARRIER))
+	if (btrfs_test_opt(info, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (info->max_inline != 8192 * 1024)
 		seq_printf(seq, ",max_inline=%llu",
@@ -687,35 +687,35 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
-	if (btrfs_test_opt(root, COMPRESS)) {
+	if (btrfs_test_opt(info, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
 		else
 			compress_type = "lzo";
-		if (btrfs_test_opt(root, FORCE_COMPRESS))
+		if (btrfs_test_opt(info, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
 			seq_printf(seq, ",compress=%s", compress_type);
 	}
-	if (btrfs_test_opt(root, NOSSD))
+	if (btrfs_test_opt(info, NOSSD))
 		seq_puts(seq, ",nossd");
-	if (btrfs_test_opt(root, SSD_SPREAD))
+	if (btrfs_test_opt(info, SSD_SPREAD))
 		seq_puts(seq, ",ssd_spread");
-	else if (btrfs_test_opt(root, SSD))
+	else if (btrfs_test_opt(info, SSD))
 		seq_puts(seq, ",ssd");
-	if (btrfs_test_opt(root, NOTREELOG))
+	if (btrfs_test_opt(info, NOTREELOG))
 		seq_puts(seq, ",notreelog");
-	if (btrfs_test_opt(root, FLUSHONCOMMIT))
+	if (btrfs_test_opt(info, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
-	if (btrfs_test_opt(root, DISCARD))
+	if (btrfs_test_opt(info, DISCARD))
 		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
-	if (btrfs_test_opt(root, SPACE_CACHE))
+	if (btrfs_test_opt(info, SPACE_CACHE))
 		seq_puts(seq, ",space_cache");
-	if (btrfs_test_opt(root, CLEAR_CACHE))
+	if (btrfs_test_opt(info, CLEAR_CACHE))
 		seq_puts(seq, ",clear_cache");
-	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
+	if (btrfs_test_opt(info, USER_SUBVOL_RM_ALLOWED))
 		seq_puts(seq, ",user_subvol_rm_allowed");
 	return 0;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dc80f71..baae99d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -960,7 +960,8 @@ static void update_super_roots(struct btrfs_root *root)
 	super->root = root_item->bytenr;
 	super->generation = root_item->generation;
 	super->root_level = root_item->level;
-	if (super->cache_generation != 0 || btrfs_test_opt(root, SPACE_CACHE))
+	if (super->cache_generation != 0 || btrfs_test_opt(root->fs_info,
+							   SPACE_CACHE))
 		super->cache_generation = root_item->generation;
 }
 
@@ -1117,7 +1118,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	int ret;
 	int should_grow = 0;
 	unsigned long now = get_seconds();
-	int flush_on_commit = btrfs_test_opt(root, FLUSHONCOMMIT);
+	int flush_on_commit = btrfs_test_opt(root->fs_info, FLUSHONCOMMIT);
 
 	btrfs_run_ordered_operations(root, 0);
 
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 3b580ee..38b0567 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -55,7 +55,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 	if (root->ref_cows == 0 && !is_extent)
 		goto out;
 
-	if (btrfs_test_opt(root, SSD))
+	if (btrfs_test_opt(root->fs_info, SSD))
 		goto out;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 592396c..41ff3a0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3013,7 +3013,7 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 
 	sb = inode->i_sb;
 
-	if (btrfs_test_opt(root, NOTREELOG)) {
+	if (btrfs_test_opt(root->fs_info, NOTREELOG)) {
 		ret = 1;
 		goto end_no_trans;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c48214e..710d3df 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2721,7 +2721,7 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	if (!em)
 		return 1;
 
-	if (btrfs_test_opt(root, DEGRADED)) {
+	if (btrfs_test_opt(root->fs_info, DEGRADED)) {
 		free_extent_map(em);
 		return 0;
 	}
@@ -3421,7 +3421,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 				   BTRFS_UUID_SIZE);
 		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
 							NULL);
-		if (!map->stripes[i].dev && !btrfs_test_opt(root, DEGRADED)) {
+		if (!map->stripes[i].dev && !btrfs_test_opt(root->fs_info,
+							    DEGRADED)) {
 			kfree(map);
 			free_extent_map(em);
 			return -EIO;
@@ -3535,13 +3536,13 @@ static int read_one_dev(struct btrfs_root *root,
 
 	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
 		ret = open_seed_devices(root, fs_uuid);
-		if (ret && !btrfs_test_opt(root, DEGRADED))
+		if (ret && !btrfs_test_opt(root->fs_info, DEGRADED))
 			return ret;
 	}
 
 	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
 	if (!device || !device->bdev) {
-		if (!btrfs_test_opt(root, DEGRADED))
+		if (!btrfs_test_opt(root->fs_info, DEGRADED))
 			return -EIO;
 
 		if (!device) {
-- 
1.7.3.4

