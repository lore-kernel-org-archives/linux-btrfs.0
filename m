Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39942 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/12] btrfs: factor btrfs_setup_super() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:43 -0500
Message-Id: <1406934766-16974-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move all the superblock flag & geometry testing & fiddling
into its own function.

This does coalesce some far-flung tests, but it ... looks
ok to me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |  207 ++++++++++++++++++++++++++++------------------------
 1 files changed, 112 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 47fcacf..31e9791 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2209,6 +2209,104 @@ static void btrfs_qgroup_init(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->qgroup_rescan_lock);
 }
 
+/*
+ * Test geometry and feature flags at mount time
+ */
+static int btrfs_setup_super(struct super_block *sb,
+			     struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	u32 nodesize = btrfs_super_nodesize(disk_super);
+	u32 leafsize = btrfs_super_leafsize(disk_super);
+	u32 sectorsize = btrfs_super_sectorsize(disk_super);
+	u64 features;
+
+
+	/* First sanity check magic &  sizes */
+	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
+		printk(KERN_INFO "BTRFS: valid FS not found on %s\n", sb->s_id);
+		return -EINVAL;
+	}
+
+	if (leafsize != nodesize) {
+		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		       "blocksizes don't match.  node %d leaf %d\n",
+		       nodesize, leafsize);
+		return -EINVAL;
+	}
+
+	if (leafsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		       "blocksize (%d) was too large\n", leafsize);
+		return -EINVAL;
+	}
+	
+	if (sectorsize != PAGE_SIZE) {
+		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
+		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
+		return -EINVAL;
+	}
+
+	/* check FS state, whether FS is broken. */
+	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
+		set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
+
+	features = btrfs_super_incompat_flags(disk_super);
+	if (features & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		       "unsupported optional features (%Lx).\n",
+		       features & ~BTRFS_FEATURE_INCOMPAT_SUPP);
+		return -EINVAL;
+	}
+
+	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
+	/* Original LZO commit didn't set incompat flag when mounted :( */
+	if (fs_info->compress_type == BTRFS_COMPRESS_LZO)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+
+	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
+		printk(KERN_ERR "BTRFS: has skinny extents\n");
+
+	/*
+	 * flag our filesystem as having big metadata blocks if
+	 * they are bigger than the page size
+	 */
+	if (leafsize > PAGE_CACHE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			printk(KERN_INFO "BTRFS: flagging fs with big metadata feature\n");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
+	/*
+	 * mixed block groups end up with duplicate but slightly offset
+	 * extent buffers for the same range.  It leads to corruptions
+	 */
+	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
+	    (sectorsize != leafsize)) {
+		printk(KERN_WARNING "BTRFS: unequal leaf/node/sector sizes "
+				"are not allowed for mixed block groups on %s\n",
+				sb->s_id);
+		return -EINVAL;
+	}
+
+	/*
+	 * Needn't use the lock because there is no other task which will
+	 * update the flag.
+	 */
+	btrfs_set_super_incompat_flags(disk_super, features);
+
+	features = btrfs_super_compat_ro_flags(disk_super) &
+		~BTRFS_FEATURE_COMPAT_RO_SUPP;
+	if (!(sb->s_flags & MS_RDONLY) && features) {
+		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		       "unsupported option features (%Lx).\n",
+		       features);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2219,7 +2317,6 @@ int open_ctree(struct super_block *sb,
 	u32 blocksize;
 	u32 stripesize;
 	u64 generation;
-	u64 features;
 	struct btrfs_key location;
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
@@ -2458,10 +2555,6 @@ int open_ctree(struct super_block *sb,
 	if (!btrfs_super_root(disk_super))
 		goto fail_alloc;
 
-	/* check FS state, whether FS is broken. */
-	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
-		set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
-
 	/*
 	 * run through our array of backup supers and setup
 	 * our ring pointer to the oldest one
@@ -2469,6 +2562,12 @@ int open_ctree(struct super_block *sb,
 	generation = btrfs_super_generation(disk_super);
 	find_oldest_super_backup(fs_info, generation);
 
+	ret = btrfs_setup_super(sb, fs_info);
+	if (ret) {
+		err = ret;
+		goto fail_alloc;
+	}
+
 	/*
 	 * In the long term, we'll store the compression type in the super
 	 * block, and it'll be used for per file compression control.
@@ -2481,86 +2580,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	features = btrfs_super_incompat_flags(disk_super) &
-		~BTRFS_FEATURE_INCOMPAT_SUPP;
-	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
-		       "unsupported optional features (%Lx).\n",
-		       features);
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
-	if (btrfs_super_leafsize(disk_super) !=
-	    btrfs_super_nodesize(disk_super)) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksizes don't match.  node %d leaf %d\n",
-		       btrfs_super_nodesize(disk_super),
-		       btrfs_super_leafsize(disk_super));
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
-		       "blocksize (%d) was too large\n",
-		       btrfs_super_leafsize(disk_super));
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
-	features = btrfs_super_incompat_flags(disk_super);
-	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-
-	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
-		printk(KERN_ERR "BTRFS: has skinny extents\n");
-
-	/*
-	 * flag our filesystem as having big metadata blocks if
-	 * they are bigger than the page size
-	 */
-	if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			printk(KERN_INFO "BTRFS: flagging fs with big metadata feature\n");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	leafsize = btrfs_super_leafsize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = btrfs_super_stripesize(disk_super);
-	fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
-	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
-
-	/*
-	 * mixed block groups end up with duplicate but slightly offset
-	 * extent buffers for the same range.  It leads to corruptions
-	 */
-	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
-	    (sectorsize != leafsize)) {
-		printk(KERN_WARNING "BTRFS: unequal leaf/node/sector sizes "
-				"are not allowed for mixed block groups on %s\n",
-				sb->s_id);
-		goto fail_alloc;
-	}
-
-	/*
-	 * Needn't use the lock because there is no other task which will
-	 * update the flag.
-	 */
-	btrfs_set_super_incompat_flags(disk_super, features);
-
-	features = btrfs_super_compat_ro_flags(disk_super) &
-		~BTRFS_FEATURE_COMPAT_RO_SUPP;
-	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
-		       "unsupported option features (%Lx).\n",
-		       features);
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
 	max_active = fs_info->thread_pool_size;
 
 	fs_info->workers =
@@ -2636,6 +2655,14 @@ int open_ctree(struct super_block *sb,
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
 				    4 * 1024 * 1024 / PAGE_CACHE_SIZE);
 
+	nodesize = btrfs_super_nodesize(disk_super);
+	leafsize = btrfs_super_leafsize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = btrfs_super_stripesize(disk_super);
+
+	fs_info->dirty_metadata_batch = leafsize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
+
 	tree_root->nodesize = nodesize;
 	tree_root->leafsize = leafsize;
 	tree_root->sectorsize = sectorsize;
@@ -2644,16 +2671,6 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-		printk(KERN_INFO "BTRFS: valid FS not found on %s\n", sb->s_id);
-		goto fail_sb_buffer;
-	}
-
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
-		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
-		goto fail_sb_buffer;
-	}
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
-- 
1.7.1

