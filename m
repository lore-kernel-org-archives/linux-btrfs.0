Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab3GCOAl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:41 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODx3003962
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/12] Btrfs-progs: cleanup similar code in open_ctree_* and close_ctree
Date: Wed, 3 Jul 2013 21:25:12 +0800
Message-Id: <1372857920-4678-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-find-root.c | 137 +++-------------
 disk-io.c         | 473 +++++++++++++++++++++++++++++++-----------------------
 disk-io.h         |  12 ++
 3 files changed, 307 insertions(+), 315 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index da22c1d..f2cc1bf 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -67,74 +67,31 @@ int csum_block(void *buf, u32 len)
 
 static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 {
-	u32 sectorsize;
-	u32 nodesize;
-	u32 leafsize;
-	u32 blocksize;
-	u32 stripesize;
-	u64 generation;
-	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
-	int ret;
+	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_fs_devices *fs_devices = NULL;
-	u64 total_devs;
-	u64 features;
-
-	ret = btrfs_scan_one_device(fd, device, &fs_devices,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+	struct extent_buffer *eb;
+	int ret;
 
-	if (ret) {
-		fprintf(stderr, "No valid Btrfs found on %s\n", device);
-		goto out;
+	fs_info = btrfs_new_fs_info(0, BTRFS_SUPER_INFO_OFFSET);
+	if (!fs_info) {
+		fprintf(stderr, "Failed to allocate memory for fs_info\n");
+		return NULL;
 	}
 
-	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
-		if (ret)
-			goto out;
-	}
-
-	memset(fs_info, 0, sizeof(*fs_info));
-	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
-	fs_info->tree_root = tree_root;
-	fs_info->extent_root = extent_root;
-	fs_info->chunk_root = chunk_root;
-	fs_info->dev_root = dev_root;
-	fs_info->csum_root = csum_root;
-
-	fs_info->readonly = 1;
-
-	extent_io_tree_init(&fs_info->extent_cache);
-	extent_io_tree_init(&fs_info->free_space_cache);
-	extent_io_tree_init(&fs_info->block_group_cache);
-	extent_io_tree_init(&fs_info->pinned_extents);
-	extent_io_tree_init(&fs_info->pending_del);
-	extent_io_tree_init(&fs_info->extent_ins);
-	cache_tree_init(&fs_info->fs_root_cache);
-
-	cache_tree_init(&fs_info->mapping_tree.cache_tree);
+	ret = btrfs_scan_fs_devices(fd, device, &fs_devices);
+	if (ret)
+		goto out;
 
-	mutex_init(&fs_info->fs_mutex);
 	fs_info->fs_devices = fs_devices;
-	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
-	INIT_LIST_HEAD(&fs_info->space_info);
-
-	__setup_root(4096, 4096, 4096, 4096, tree_root,
-		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	ret = btrfs_open_devices(fs_devices, O_RDONLY);
 	if (ret)
-		goto out_cleanup;
+		goto out_devices;
 
-	fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, BTRFS_SUPER_INFO_OFFSET);
+				   disk_super, fs_info->super_bytenr);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -142,77 +99,27 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
-
-	features = btrfs_super_incompat_flags(disk_super) &
-		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
-	if (features) {
-		printk("couldn't open because of unsupported "
-		       "option features (%Lx).\n", features);
-		goto out_devices;
-	}
-
-	features = btrfs_super_incompat_flags(disk_super);
-	if (!(features & BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF)) {
-		features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-		btrfs_set_super_incompat_flags(disk_super, features);
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	leafsize = btrfs_super_leafsize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = btrfs_super_stripesize(disk_super);
-	tree_root->nodesize = nodesize;
-	tree_root->leafsize = leafsize;
-	tree_root->sectorsize = sectorsize;
-	tree_root->stripesize = stripesize;
-
-	ret = btrfs_read_sys_array(tree_root);
+	ret = btrfs_check_fs_compatibility(disk_super, 0);
 	if (ret)
 		goto out_devices;
-	blocksize = btrfs_level_size(tree_root,
-				     btrfs_super_chunk_root_level(disk_super));
-	generation = btrfs_super_chunk_root_generation(disk_super);
-
-	__setup_root(nodesize, leafsize, sectorsize, stripesize,
-		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
-
-	chunk_root->node = read_tree_block(chunk_root,
-					   btrfs_super_chunk_root(disk_super),
-					   blocksize, generation);
-	if (!chunk_root->node) {
-		printk("Couldn't read chunk root\n");
-		goto out_devices;
-	}
 
-	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
-	         (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
-		 BTRFS_UUID_SIZE);
+	ret = btrfs_setup_chunk_tree_and_device_map(fs_info);
+	if (ret)
+		goto out_chunk;
 
-	if (!(btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)) {
-		ret = btrfs_read_chunk_tree(chunk_root);
-		if (ret)
-			goto out_chunk;
-	}
+	eb = fs_info->chunk_root->node;
+	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
+			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
+			   BTRFS_UUID_SIZE);
 
 	return fs_info->chunk_root;
 out_chunk:
 	free_extent_buffer(fs_info->chunk_root->node);
+	btrfs_cleanup_all_caches(fs_info);
 out_devices:
 	btrfs_close_devices(fs_info->fs_devices);
-out_cleanup:
-	extent_io_tree_cleanup(&fs_info->extent_cache);
-	extent_io_tree_cleanup(&fs_info->free_space_cache);
-	extent_io_tree_cleanup(&fs_info->block_group_cache);
-	extent_io_tree_cleanup(&fs_info->pinned_extents);
-	extent_io_tree_cleanup(&fs_info->pending_del);
-	extent_io_tree_cleanup(&fs_info->extent_ins);
 out:
-	free(tree_root);
-	free(extent_root);
-	free(chunk_root);
-	free(dev_root);
-	free(csum_root);
-	free(fs_info);
+	btrfs_free_fs_info(fs_info);
 	return NULL;
 }
 
diff --git a/disk-io.c b/disk-io.c
index a8176a5..8116afc 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -796,61 +796,46 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	return root;
 }
 
-static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
-					     u64 sb_bytenr,
-					     u64 root_tree_bytenr, int writes,
-					     int partial)
+void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 {
-	u32 sectorsize;
-	u32 nodesize;
-	u32 leafsize;
-	u32 blocksize;
-	u32 stripesize;
-	u64 generation;
-	struct btrfs_key key;
-	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
-	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
-	int ret;
-	struct btrfs_super_block *disk_super;
-	struct btrfs_fs_devices *fs_devices = NULL;
-	u64 total_devs;
-	u64 features;
-
-	if (sb_bytenr == 0)
-		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
+	free(fs_info->tree_root);
+	free(fs_info->extent_root);
+	free(fs_info->chunk_root);
+	free(fs_info->dev_root);
+	free(fs_info->csum_root);
+	free(fs_info->super_copy);
+	free(fs_info->log_root_tree);
+	free(fs_info);
+}
 
-	/* try to drop all the caches */
-	if (posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED))
-		fprintf(stderr, "Warning, could not drop caches\n");
+struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
+{
+	struct btrfs_fs_info *fs_info;
 
-	ret = btrfs_scan_one_device(fp, path, &fs_devices,
-				    &total_devs, sb_bytenr);
+	fs_info = malloc(sizeof(struct btrfs_fs_info));
+	if (!fs_info)
+		return NULL;
 
-	if (ret) {
-		fprintf(stderr, "No valid Btrfs found on %s\n", path);
-		goto out;
-	}
+	memset(fs_info, 0, sizeof(struct btrfs_fs_info));
 
-	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
-		if (ret)
-			goto out;
-	}
+	fs_info->tree_root = malloc(sizeof(struct btrfs_root));
+	fs_info->extent_root = malloc(sizeof(struct btrfs_root));
+	fs_info->chunk_root = malloc(sizeof(struct btrfs_root));
+	fs_info->dev_root = malloc(sizeof(struct btrfs_root));
+	fs_info->csum_root = malloc(sizeof(struct btrfs_root));
+	fs_info->super_copy = malloc(BTRFS_SUPER_INFO_SIZE);
 
-	memset(fs_info, 0, sizeof(*fs_info));
-	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
-	fs_info->tree_root = tree_root;
-	fs_info->extent_root = extent_root;
-	fs_info->chunk_root = chunk_root;
-	fs_info->dev_root = dev_root;
-	fs_info->csum_root = csum_root;
+	if (!fs_info->tree_root || !fs_info->extent_root ||
+	    !fs_info->chunk_root || !fs_info->dev_root ||
+	    !fs_info->csum_root || !fs_info->super_copy)
+		goto free_all;
 
-	if (!writes)
-		fs_info->readonly = 1;
+	memset(fs_info->super_copy, 0, BTRFS_SUPER_INFO_SIZE);
+	memset(fs_info->tree_root, 0, sizeof(struct btrfs_root));
+	memset(fs_info->extent_root, 0, sizeof(struct btrfs_root));
+	memset(fs_info->chunk_root, 0, sizeof(struct btrfs_root));
+	memset(fs_info->dev_root, 0, sizeof(struct btrfs_root));
+	memset(fs_info->csum_root, 0, sizeof(struct btrfs_root));
 
 	extent_io_tree_init(&fs_info->extent_cache);
 	extent_io_tree_init(&fs_info->free_space_cache);
@@ -858,139 +843,121 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	extent_io_tree_init(&fs_info->pinned_extents);
 	extent_io_tree_init(&fs_info->pending_del);
 	extent_io_tree_init(&fs_info->extent_ins);
-	cache_tree_init(&fs_info->fs_root_cache);
 
+	cache_tree_init(&fs_info->fs_root_cache);
 	cache_tree_init(&fs_info->mapping_tree.cache_tree);
 
 	mutex_init(&fs_info->fs_mutex);
-	fs_info->fs_devices = fs_devices;
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
 
-	__setup_root(4096, 4096, 4096, 4096, tree_root,
-		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
-
-	if (writes)
-		ret = btrfs_open_devices(fs_devices, O_RDWR);
-	else
-		ret = btrfs_open_devices(fs_devices, O_RDONLY);
-	if (ret)
-		goto out_cleanup;
+	if (!writable)
+		fs_info->readonly = 1;
 
 	fs_info->super_bytenr = sb_bytenr;
-	disk_super = fs_info->super_copy;
-	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, sb_bytenr);
-	if (ret) {
-		printk("No valid btrfs found\n");
-		goto out_devices;
-	}
-
-	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+	fs_info->data_alloc_profile = (u64)-1;
+	fs_info->metadata_alloc_profile = (u64)-1;
+	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
+	return fs_info;
+free_all:
+	btrfs_free_fs_info(fs_info);
+	return NULL;
+}
 
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
+{
+	u64 features;
 
-	features = btrfs_super_incompat_flags(disk_super) &
+	features = btrfs_super_incompat_flags(sb) &
 		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		printk("couldn't open because of unsupported "
 		       "option features (%Lx).\n",
 		       (unsigned long long)features);
-		goto out_devices;
+		return -ENOTSUP;
 	}
 
-	features = btrfs_super_incompat_flags(disk_super);
+	features = btrfs_super_incompat_flags(sb);
 	if (!(features & BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF)) {
 		features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-		btrfs_set_super_incompat_flags(disk_super, features);
+		btrfs_set_super_incompat_flags(sb, features);
 	}
 
-	features = btrfs_super_compat_ro_flags(disk_super) &
+	features = btrfs_super_compat_ro_flags(sb) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
-	if (writes && features) {
+	if (writable && features) {
 		printk("couldn't open RDWR because of unsupported "
 		       "option features (%Lx).\n",
 		       (unsigned long long)features);
-		goto out_devices;
+		return -ENOTSUP;
 	}
+	return 0;
+}
 
-	nodesize = btrfs_super_nodesize(disk_super);
-	leafsize = btrfs_super_leafsize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = btrfs_super_stripesize(disk_super);
-	tree_root->nodesize = nodesize;
-	tree_root->leafsize = leafsize;
-	tree_root->sectorsize = sectorsize;
-	tree_root->stripesize = stripesize;
+int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
+			  u64 root_tree_bytenr, int partial)
+{
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	u32 sectorsize;
+	u32 nodesize;
+	u32 leafsize;
+	u32 stripesize;
+	u64 generation;
+	u32 blocksize;
+	int ret;
 
-	ret = btrfs_read_sys_array(tree_root);
-	if (ret)
-		goto out_devices;
-	blocksize = btrfs_level_size(tree_root,
-				     btrfs_super_chunk_root_level(disk_super));
-	generation = btrfs_super_chunk_root_generation(disk_super);
+	nodesize = btrfs_super_nodesize(sb);
+	leafsize = btrfs_super_leafsize(sb);
+	sectorsize = btrfs_super_sectorsize(sb);
+	stripesize = btrfs_super_stripesize(sb);
 
+	root = fs_info->tree_root;
 	__setup_root(nodesize, leafsize, sectorsize, stripesize,
-		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
-
-	chunk_root->node = read_tree_block(chunk_root,
-					   btrfs_super_chunk_root(disk_super),
-					   blocksize, generation);
-	if (!extent_buffer_uptodate(chunk_root->node)) {
-		printk("Couldn't read chunk root\n");
-		goto out_devices;
-	}
-
-	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
-	         (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
-		 BTRFS_UUID_SIZE);
-
-	if (!(btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)) {
-		ret = btrfs_read_chunk_tree(chunk_root);
-		if (ret) {
-			printk("Couldn't read chunk tree\n");
-			goto out_chunk;
-		}
-	}
-
-	blocksize = btrfs_level_size(tree_root,
-				     btrfs_super_root_level(disk_super));
-	generation = btrfs_super_generation(disk_super);
+		     root, fs_info, BTRFS_ROOT_TREE_OBJECTID);
+	blocksize = btrfs_level_size(root, btrfs_super_root_level(sb));
+	generation = btrfs_super_generation(sb);
 
 	if (!root_tree_bytenr)
-		root_tree_bytenr = btrfs_super_root(disk_super);
-	tree_root->node = read_tree_block(tree_root,
-					  root_tree_bytenr,
-					  blocksize, generation);
-	if (!extent_buffer_uptodate(tree_root->node)) {
-		printk("Couldn't read tree root\n");
-		goto out_failed;
+		root_tree_bytenr = btrfs_super_root(sb);
+	root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+				     generation);
+	if (!extent_buffer_uptodate(root->node)) {
+		fprintf(stderr, "Couldn't read tree root\n");
+		return -EIO;
 	}
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
+
+	ret = find_and_setup_root(root, fs_info, BTRFS_EXTENT_TREE_OBJECTID,
+				  fs_info->extent_root);
 	if (ret) {
 		printk("Couldn't setup extent tree\n");
-		goto out_failed;
+		return -EIO;
 	}
-	extent_root->track_dirty = 1;
+	fs_info->extent_root->track_dirty = 1;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_DEV_TREE_OBJECTID, dev_root);
+	ret = find_and_setup_root(root, fs_info, BTRFS_DEV_TREE_OBJECTID,
+				  fs_info->dev_root);
 	if (ret) {
 		printk("Couldn't setup device tree\n");
-		goto out_failed;
+		return -EIO;
 	}
-	dev_root->track_dirty = 1;
+	fs_info->dev_root->track_dirty = 1;
 
-	ret = find_and_setup_root(tree_root, fs_info,
-				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
+	ret = find_and_setup_root(root, fs_info, BTRFS_CSUM_TREE_OBJECTID,
+				  fs_info->csum_root);
 	if (ret) {
 		printk("Couldn't setup csum tree\n");
 		if (!partial)
-			goto out_failed;
+			return -EIO;
 	}
-	csum_root->track_dirty = 1;
+	fs_info->csum_root->track_dirty = 1;
 
-	find_and_setup_log_root(tree_root, fs_info, disk_super);
+	ret = find_and_setup_log_root(root, fs_info, sb);
+	if (ret) {
+		printk("Couldn't setup log root tree\n");
+		return -EIO;
+	}
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
@@ -1002,18 +969,12 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	fs_info->fs_root = btrfs_read_fs_root(fs_info, &key);
 
 	if (!fs_info->fs_root)
-		goto out_failed;
-
-	fs_info->data_alloc_profile = (u64)-1;
-	fs_info->metadata_alloc_profile = (u64)-1;
-	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
-
-	return fs_info;
-
-out_failed:
-	if (partial)
-		return fs_info;
+		return -EIO;
+	return 0;
+}
 
+void btrfs_release_all_roots(struct btrfs_fs_info *fs_info)
+{
 	if (fs_info->csum_root)
 		free_extent_buffer(fs_info->csum_root->node);
 	if (fs_info->dev_root)
@@ -1022,25 +983,179 @@ out_failed:
 		free_extent_buffer(fs_info->extent_root->node);
 	if (fs_info->tree_root)
 		free_extent_buffer(fs_info->tree_root->node);
-out_chunk:
+	if (fs_info->log_root_tree)
+		free_extent_buffer(fs_info->log_root_tree->node);
 	if (fs_info->chunk_root)
 		free_extent_buffer(fs_info->chunk_root->node);
-out_devices:
-	btrfs_close_devices(fs_info->fs_devices);
-out_cleanup:
+}
+
+static void free_mapping_cache(struct btrfs_fs_info *fs_info)
+{
+	struct cache_tree *cache_tree = &fs_info->mapping_tree.cache_tree;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+
+	while ((ce = find_first_cache_extent(cache_tree, 0))) {
+		map = container_of(ce, struct map_lookup, ce);
+		remove_cache_extent(cache_tree, ce);
+		kfree(map);
+	}
+}
+
+void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info)
+{
+	free_mapping_cache(fs_info);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
 	extent_io_tree_cleanup(&fs_info->block_group_cache);
 	extent_io_tree_cleanup(&fs_info->pinned_extents);
 	extent_io_tree_cleanup(&fs_info->pending_del);
 	extent_io_tree_cleanup(&fs_info->extent_ins);
+}
+
+int btrfs_scan_fs_devices(int fd, const char *path,
+			  struct btrfs_fs_devices **fs_devices)
+{
+	u64 total_devs;
+	int ret;
+
+	ret = btrfs_scan_one_device(fd, path, fs_devices,
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+	if (ret) {
+		fprintf(stderr, "No valid Btrfs found on %s\n", path);
+		return ret;
+	}
+
+	if (total_devs != 1) {
+		ret = btrfs_scan_for_fsid(*fs_devices, total_devs, 1);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	u32 sectorsize;
+	u32 nodesize;
+	u32 leafsize;
+	u32 blocksize;
+	u32 stripesize;
+	u64 generation;
+	int ret;
+
+	nodesize = btrfs_super_nodesize(sb);
+	leafsize = btrfs_super_leafsize(sb);
+	sectorsize = btrfs_super_sectorsize(sb);
+	stripesize = btrfs_super_stripesize(sb);
+
+	__setup_root(nodesize, leafsize, sectorsize, stripesize,
+		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+
+	ret = btrfs_read_sys_array(fs_info->chunk_root);
+	if (ret)
+		return ret;
+
+	blocksize = btrfs_level_size(fs_info->chunk_root,
+				     btrfs_super_chunk_root_level(sb));
+	generation = btrfs_super_chunk_root_generation(sb);
+
+	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
+						    btrfs_super_chunk_root(sb),
+						    blocksize, generation);
+	if (!fs_info->chunk_root->node ||
+	    !extent_buffer_uptodate(fs_info->chunk_root->node)) {
+		fprintf(stderr, "Couldn't read chunk root\n");
+		return ret;
+	}
+
+	if (!(btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
+		ret = btrfs_read_chunk_tree(fs_info->chunk_root);
+		if (ret) {
+			fprintf(stderr, "Couldn't read chunk tree\n");
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
+					     u64 sb_bytenr,
+					     u64 root_tree_bytenr, int writes,
+					     int partial)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_super_block *disk_super;
+	struct btrfs_fs_devices *fs_devices = NULL;
+	struct extent_buffer *eb;
+	int ret;
+
+	if (sb_bytenr == 0)
+		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
+
+	/* try to drop all the caches */
+	if (posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED))
+		fprintf(stderr, "Warning, could not drop caches\n");
+
+	fs_info = btrfs_new_fs_info(writes, sb_bytenr);
+	if (!fs_info) {
+		fprintf(stderr, "Failed to allocate memory for fs_info\n");
+		return NULL;
+	}
+
+	ret = btrfs_scan_fs_devices(fp, path, &fs_devices);
+	if (ret)
+		goto out;
+
+	fs_info->fs_devices = fs_devices;
+	if (writes)
+		ret = btrfs_open_devices(fs_devices, O_RDWR);
+	else
+		ret = btrfs_open_devices(fs_devices, O_RDONLY);
+	if (ret)
+		goto out_devices;
+
+
+	disk_super = fs_info->super_copy;
+	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
+				   disk_super, sb_bytenr);
+	if (ret) {
+		printk("No valid btrfs found\n");
+		goto out_devices;
+	}
+
+	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+
+	ret = btrfs_check_fs_compatibility(fs_info->super_copy, writes);
+	if (ret)
+		goto out_devices;
+
+	ret = btrfs_setup_chunk_tree_and_device_map(fs_info);
+	if (ret)
+		goto out_chunk;
+
+	eb = fs_info->chunk_root->node;
+	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
+			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
+			   BTRFS_UUID_SIZE);
+
+	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, partial);
+	if (ret)
+		goto out_failed;
+
+	return fs_info;
+
+out_failed:
+	if (partial)
+		return fs_info;
+out_chunk:
+	btrfs_release_all_roots(fs_info);
+	btrfs_cleanup_all_caches(fs_info);
+out_devices:
+	btrfs_close_devices(fs_devices);
 out:
-	free(tree_root);
-	free(extent_root);
-	free(chunk_root);
-	free(dev_root);
-	free(csum_root);
-	free(fs_info);
+	btrfs_free_fs_info(fs_info);
 	return NULL;
 }
 
@@ -1259,19 +1374,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void free_mapping_cache(struct btrfs_fs_info *fs_info)
-{
-	struct cache_tree *cache_tree = &fs_info->mapping_tree.cache_tree;
-	struct cache_extent *ce;
-	struct map_lookup *map;
-
-	while ((ce = find_first_cache_extent(cache_tree, 0))) {
-		map = container_of(ce, struct map_lookup, ce);
-		remove_cache_extent(cache_tree, ce);
-		kfree(map);
-	}
-}
-
 int close_ctree(struct btrfs_root *root)
 {
 	int ret;
@@ -1294,39 +1396,10 @@ int close_ctree(struct btrfs_root *root)
 
 	free_fs_roots(fs_info);
 
-	if (fs_info->extent_root->node)
-		free_extent_buffer(fs_info->extent_root->node);
-	if (fs_info->tree_root->node)
-		free_extent_buffer(fs_info->tree_root->node);
-	if (fs_info->chunk_root->node)
-		free_extent_buffer(fs_info->chunk_root->node);
-	if (fs_info->dev_root->node)
-		free_extent_buffer(fs_info->dev_root->node);
-	if (fs_info->csum_root->node)
-		free_extent_buffer(fs_info->csum_root->node);
-
-	if (fs_info->log_root_tree) {
-		if (fs_info->log_root_tree->node)
-			free_extent_buffer(fs_info->log_root_tree->node);
-		free(fs_info->log_root_tree);
-	}
-
+	btrfs_release_all_roots(fs_info);
 	btrfs_close_devices(fs_info->fs_devices);
-	free_mapping_cache(fs_info);
-	extent_io_tree_cleanup(&fs_info->extent_cache);
-	extent_io_tree_cleanup(&fs_info->free_space_cache);
-	extent_io_tree_cleanup(&fs_info->block_group_cache);
-	extent_io_tree_cleanup(&fs_info->pinned_extents);
-	extent_io_tree_cleanup(&fs_info->pending_del);
-	extent_io_tree_cleanup(&fs_info->extent_ins);
-
-	free(fs_info->tree_root);
-	free(fs_info->extent_root);
-	free(fs_info->chunk_root);
-	free(fs_info->dev_root);
-	free(fs_info->csum_root);
-	free(fs_info);
-
+	btrfs_cleanup_all_caches(fs_info);
+	btrfs_free_fs_info(fs_info);
 	return 0;
 }
 
diff --git a/disk-io.h b/disk-io.h
index c29ee8e..2fe2d72 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -47,6 +47,18 @@ int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
                         struct btrfs_fs_info *fs_info, u64 objectid);
 int clean_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root, struct extent_buffer *buf);
+
+void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
+struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
+int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
+int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
+			  u64 root_tree_bytenr, int partial);
+void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
+void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
+int btrfs_scan_fs_devices(int fd, const char *path,
+			  struct btrfs_fs_devices **fs_devices);
+int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
+
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes);
-- 
1.8.1.4

