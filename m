Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935371AbeEYEna (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 00:43:30 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2BBF7AC53
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 04:43:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/3] btrfs: Move btrfs_check_super_valid() to avoid forward declaration
Date: Fri, 25 May 2018 12:43:23 +0800
Message-Id: <20180525044325.3365-2-wqu@suse.com>
In-Reply-To: <20180525044325.3365-1-wqu@suse.com>
References: <20180525044325.3365-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just move btrfs_check_super_valid() before its single caller to avoid
forward declaration.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 299 ++++++++++++++++++++++-----------------------
 1 file changed, 149 insertions(+), 150 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 932ed61d9554..13c5f90995aa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -55,7 +55,6 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2441,6 +2440,155 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	u64 nodesize = btrfs_super_nodesize(sb);
+	u64 sectorsize = btrfs_super_sectorsize(sb);
+	int ret = 0;
+
+	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
+		btrfs_err(fs_info, "no valid FS found");
+		ret = -EINVAL;
+	}
+	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
+		btrfs_err(fs_info, "unrecognized or unsupported super flag: %llu",
+				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		btrfs_err(fs_info, "tree_root level too big: %d >= %d",
+				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		btrfs_err(fs_info, "chunk_root level too big: %d >= %d",
+				btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		btrfs_err(fs_info, "log_root level too big: %d >= %d",
+				btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * Check sectorsize and nodesize first, other check will need it.
+	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
+	 */
+	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
+	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
+		ret = -EINVAL;
+	}
+	/* Only PAGE SIZE is supported yet */
+	if (sectorsize != PAGE_SIZE) {
+		btrfs_err(fs_info,
+			"sectorsize %llu not supported yet, only support %lu",
+			sectorsize, PAGE_SIZE);
+		ret = -EINVAL;
+	}
+	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
+	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
+		ret = -EINVAL;
+	}
+	if (nodesize != le32_to_cpu(sb->__unused_leafsize)) {
+		btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
+			  le32_to_cpu(sb->__unused_leafsize), nodesize);
+		ret = -EINVAL;
+	}
+
+	/* Root alignment check */
+	if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)) {
+		btrfs_warn(fs_info, "tree_root block unaligned: %llu",
+			   btrfs_super_root(sb));
+		ret = -EINVAL;
+	}
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), sectorsize)) {
+		btrfs_warn(fs_info, "chunk_root block unaligned: %llu",
+			   btrfs_super_chunk_root(sb));
+		ret = -EINVAL;
+	}
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
+		btrfs_warn(fs_info, "log_root block unaligned: %llu",
+			   btrfs_super_log_root(sb));
+		ret = -EINVAL;
+	}
+
+	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
+		btrfs_err(fs_info,
+			   "dev_item UUID does not match fsid: %pU != %pU",
+			   fs_info->fsid, sb->dev_item.fsid);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
+	 * done later
+	 */
+	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+		btrfs_err(fs_info, "bytes_used is too small %llu",
+			  btrfs_super_bytes_used(sb));
+		ret = -EINVAL;
+	}
+	if (!is_power_of_2(btrfs_super_stripesize(sb))) {
+		btrfs_err(fs_info, "invalid stripesize %u",
+			  btrfs_super_stripesize(sb));
+		ret = -EINVAL;
+	}
+	if (btrfs_super_num_devices(sb) > (1UL << 31))
+		btrfs_warn(fs_info, "suspicious number of devices: %llu",
+			   btrfs_super_num_devices(sb));
+	if (btrfs_super_num_devices(sb) == 0) {
+		btrfs_err(fs_info, "number of devices is 0");
+		ret = -EINVAL;
+	}
+
+	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
+		btrfs_err(fs_info, "super offset mismatch %llu != %u",
+			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * Obvious sys_chunk_array corruptions, it must hold at least one key
+	 * and one chunk
+	 */
+	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+		btrfs_err(fs_info, "system chunk array too big %u > %u",
+			  btrfs_super_sys_array_size(sb),
+			  BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
+			+ sizeof(struct btrfs_chunk)) {
+		btrfs_err(fs_info, "system chunk array too small %u < %zu",
+			  btrfs_super_sys_array_size(sb),
+			  sizeof(struct btrfs_disk_key)
+			  + sizeof(struct btrfs_chunk));
+		ret = -EINVAL;
+	}
+
+	/*
+	 * The generation is a global counter, we'll trust it more than the others
+	 * but it's still possible that it's the one that's wrong.
+	 */
+	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
+		btrfs_warn(fs_info,
+			"suspicious: generation < chunk_root_generation: %llu < %llu",
+			btrfs_super_generation(sb),
+			btrfs_super_chunk_root_generation(sb));
+	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
+	    && btrfs_super_cache_generation(sb) != (u64)-1)
+		btrfs_warn(fs_info,
+			"suspicious: generation < cache_generation: %llu < %llu",
+			btrfs_super_generation(sb),
+			btrfs_super_cache_generation(sb));
+
+	return ret;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -3972,155 +4120,6 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
 					      level, first_key);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_super_block *sb = fs_info->super_copy;
-	u64 nodesize = btrfs_super_nodesize(sb);
-	u64 sectorsize = btrfs_super_sectorsize(sb);
-	int ret = 0;
-
-	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
-		btrfs_err(fs_info, "no valid FS found");
-		ret = -EINVAL;
-	}
-	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
-		btrfs_err(fs_info, "unrecognized or unsupported super flag: %llu",
-				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
-		ret = -EINVAL;
-	}
-	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		btrfs_err(fs_info, "tree_root level too big: %d >= %d",
-				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
-	}
-	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		btrfs_err(fs_info, "chunk_root level too big: %d >= %d",
-				btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
-	}
-	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		btrfs_err(fs_info, "log_root level too big: %d >= %d",
-				btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
-		ret = -EINVAL;
-	}
-
-	/*
-	 * Check sectorsize and nodesize first, other check will need it.
-	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
-	 */
-	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
-	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
-		ret = -EINVAL;
-	}
-	/* Only PAGE SIZE is supported yet */
-	if (sectorsize != PAGE_SIZE) {
-		btrfs_err(fs_info,
-			"sectorsize %llu not supported yet, only support %lu",
-			sectorsize, PAGE_SIZE);
-		ret = -EINVAL;
-	}
-	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
-	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
-		ret = -EINVAL;
-	}
-	if (nodesize != le32_to_cpu(sb->__unused_leafsize)) {
-		btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
-			  le32_to_cpu(sb->__unused_leafsize), nodesize);
-		ret = -EINVAL;
-	}
-
-	/* Root alignment check */
-	if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)) {
-		btrfs_warn(fs_info, "tree_root block unaligned: %llu",
-			   btrfs_super_root(sb));
-		ret = -EINVAL;
-	}
-	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), sectorsize)) {
-		btrfs_warn(fs_info, "chunk_root block unaligned: %llu",
-			   btrfs_super_chunk_root(sb));
-		ret = -EINVAL;
-	}
-	if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
-		btrfs_warn(fs_info, "log_root block unaligned: %llu",
-			   btrfs_super_log_root(sb));
-		ret = -EINVAL;
-	}
-
-	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
-		btrfs_err(fs_info,
-			   "dev_item UUID does not match fsid: %pU != %pU",
-			   fs_info->fsid, sb->dev_item.fsid);
-		ret = -EINVAL;
-	}
-
-	/*
-	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
-	 * done later
-	 */
-	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
-		btrfs_err(fs_info, "bytes_used is too small %llu",
-			  btrfs_super_bytes_used(sb));
-		ret = -EINVAL;
-	}
-	if (!is_power_of_2(btrfs_super_stripesize(sb))) {
-		btrfs_err(fs_info, "invalid stripesize %u",
-			  btrfs_super_stripesize(sb));
-		ret = -EINVAL;
-	}
-	if (btrfs_super_num_devices(sb) > (1UL << 31))
-		btrfs_warn(fs_info, "suspicious number of devices: %llu",
-			   btrfs_super_num_devices(sb));
-	if (btrfs_super_num_devices(sb) == 0) {
-		btrfs_err(fs_info, "number of devices is 0");
-		ret = -EINVAL;
-	}
-
-	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
-		btrfs_err(fs_info, "super offset mismatch %llu != %u",
-			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
-		ret = -EINVAL;
-	}
-
-	/*
-	 * Obvious sys_chunk_array corruptions, it must hold at least one key
-	 * and one chunk
-	 */
-	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		btrfs_err(fs_info, "system chunk array too big %u > %u",
-			  btrfs_super_sys_array_size(sb),
-			  BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
-		ret = -EINVAL;
-	}
-	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
-			+ sizeof(struct btrfs_chunk)) {
-		btrfs_err(fs_info, "system chunk array too small %u < %zu",
-			  btrfs_super_sys_array_size(sb),
-			  sizeof(struct btrfs_disk_key)
-			  + sizeof(struct btrfs_chunk));
-		ret = -EINVAL;
-	}
-
-	/*
-	 * The generation is a global counter, we'll trust it more than the others
-	 * but it's still possible that it's the one that's wrong.
-	 */
-	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
-		btrfs_warn(fs_info,
-			"suspicious: generation < chunk_root_generation: %llu < %llu",
-			btrfs_super_generation(sb),
-			btrfs_super_chunk_root_generation(sb));
-	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
-	    && btrfs_super_cache_generation(sb) != (u64)-1)
-		btrfs_warn(fs_info,
-			"suspicious: generation < cache_generation: %llu < %llu",
-			btrfs_super_generation(sb),
-			btrfs_super_cache_generation(sb));
-
-	return ret;
-}
-
 static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
 {
 	mutex_lock(&fs_info->cleaner_mutex);
-- 
2.17.0

