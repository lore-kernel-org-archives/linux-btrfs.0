Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755176AbeDTOYS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92A3CAEBF
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: extend trim callchain to pass the operation type
Date: Fri, 20 Apr 2018 16:21:46 +0200
Message-Id: <79ff1b7536a13f0c9d6794dcafc1fa23a5c48126.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is preparatory work to implement clearing free space by zeroing,
much in the same way the FITRIM ioctl works.  This patch simply defines
a symbolic name for the current clearing operation and passes the
parameter around. No functional change.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h            | 11 ++++++++-
 fs/btrfs/extent-tree.c      | 54 +++++++++++++++++++++++++++++++--------------
 fs/btrfs/free-space-cache.c | 22 ++++++++++--------
 fs/btrfs/free-space-cache.h |  3 ++-
 4 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5474ef14d6e6..7cde72683b8e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -674,6 +674,14 @@ struct btrfs_stripe_hash {
 	spinlock_t lock;
 };
 
+/*
+ * Type of operation that will be used to clear unused blocks.
+ */
+enum btrfs_clear_op_type {
+	BTRFS_CLEAR_OP_DISCARD = 0,
+	BTRFS_NR_CLEAR_OP_TYPES,
+};
+
 /* used by the raid56 code to lock stripes for read/modify/write */
 struct btrfs_stripe_hash_table {
 	struct list_head stripe_cache;
@@ -2789,7 +2797,8 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
 				   u64 start, u64 end);
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 num_bytes, u64 *actual_bytes);
+			 u64 num_bytes, u64 *actual_bytes,
+			 enum btrfs_clear_op_type clear);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 type);
 int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5bdb5636d552..ffdd3aba508c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2036,7 +2036,8 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 
 #define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
 static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
-			       u64 *discarded_bytes)
+			       u64 *discarded_bytes,
+			       enum btrfs_clear_op_type clear)
 {
 	int j, ret = 0;
 	u64 bytes_left, end;
@@ -2082,8 +2083,11 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 		}
 
 		if (size) {
-			ret = blkdev_issue_discard(bdev, start >> 9, size >> 9,
-						   GFP_NOFS, 0);
+			if (clear == BTRFS_CLEAR_OP_DISCARD)
+				ret = blkdev_issue_discard(bdev, start >> 9,
+						size >> 9, GFP_NOFS, 0);
+			else
+				ret = -EOPNOTSUPP;
 			if (!ret)
 				*discarded_bytes += size;
 			else if (ret != -EOPNOTSUPP)
@@ -2099,8 +2103,11 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 	}
 
 	if (bytes_left) {
-		ret = blkdev_issue_discard(bdev, start >> 9, bytes_left >> 9,
-					   GFP_NOFS, 0);
+		if (clear == BTRFS_CLEAR_OP_DISCARD)
+			ret = blkdev_issue_discard(bdev, start >> 9,
+					bytes_left >> 9, GFP_NOFS, 0);
+		else
+			ret = -EOPNOTSUPP;
 		if (!ret)
 			*discarded_bytes += bytes_left;
 	}
@@ -2108,12 +2115,18 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 }
 
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
-			 u64 num_bytes, u64 *actual_bytes)
+			 u64 num_bytes, u64 *actual_bytes,
+			 enum btrfs_clear_op_type clear)
 {
 	int ret;
 	u64 discarded_bytes = 0;
 	struct btrfs_bio *bbio = NULL;
+	int rw;
 
+	if (clear == BTRFS_CLEAR_OP_DISCARD)
+		rw = BTRFS_MAP_DISCARD;
+	else
+		rw = BTRFS_MAP_WRITE;
 
 	/*
 	 * Avoid races with device replace and make sure our bbio has devices
@@ -2121,8 +2134,7 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, bytenr, &num_bytes,
-			      &bbio, 0);
+	ret = btrfs_map_block(fs_info, rw, bytenr, &num_bytes, &bbio, 0);
 	/* Error condition is -ENOMEM */
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = bbio->stripes;
@@ -2138,13 +2150,14 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 				continue;
 			}
 			req_q = bdev_get_queue(stripe->dev->bdev);
-			if (!blk_queue_discard(req_q))
+			if (clear == BTRFS_CLEAR_OP_DISCARD &&
+			    !blk_queue_discard(req_q))
 				continue;
 
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length,
-						  &bytes);
+						  &bytes, clear);
 			if (!ret)
 				discarded_bytes += bytes;
 			else if (ret != -EOPNOTSUPP)
@@ -6785,7 +6798,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 
 		if (btrfs_test_opt(fs_info, DISCARD))
 			ret = btrfs_discard_extent(fs_info, start,
-						   end + 1 - start, NULL);
+						   end + 1 - start, NULL,
+						   BTRFS_CLEAR_OP_DISCARD);
 
 		clear_extent_dirty(unpin, start, end);
 		unpin_extent_range(fs_info, start, end, true);
@@ -6807,7 +6821,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 			ret = btrfs_discard_extent(fs_info,
 						   block_group->key.objectid,
 						   block_group->key.offset,
-						   &trimmed);
+						   &trimmed,
+						   BTRFS_CLEAR_OP_DISCARD);
 
 		list_del_init(&block_group->bg_list);
 		btrfs_put_block_group_trimming(block_group);
@@ -8056,7 +8071,8 @@ static int __btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 		pin_down_extent(fs_info, cache, start, len, 1);
 	else {
 		if (btrfs_test_opt(fs_info, DISCARD))
-			ret = btrfs_discard_extent(fs_info, start, len, NULL);
+			ret = btrfs_discard_extent(fs_info, start, len, NULL,
+					BTRFS_CLEAR_OP_DISCARD);
 		btrfs_add_free_space(cache, start, len);
 		btrfs_free_reserved_bytes(cache, len, delalloc);
 		trace_btrfs_reserved_extent_free(fs_info, start, len);
@@ -10892,7 +10908,8 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
  * transaction.
  */
 static int btrfs_trim_free_extents(struct btrfs_device *device,
-				   u64 minlen, u64 *trimmed)
+				   u64 minlen, u64 *trimmed,
+				   enum btrfs_clear_op_type clear)
 {
 	u64 start = 0, len = 0;
 	int ret;
@@ -10939,7 +10956,8 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 			break;
 		}
 
-		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
+		ret = btrfs_issue_discard(device->bdev, start, len, &bytes,
+				clear);
 		up_read(&fs_info->commit_root_sem);
 		mutex_unlock(&fs_info->chunk_mutex);
 
@@ -11007,7 +11025,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 						     &group_trimmed,
 						     start,
 						     end,
-						     range->minlen);
+						     range->minlen,
+						     BTRFS_CLEAR_OP_DISCARD);
 
 			trimmed += group_trimmed;
 			if (ret) {
@@ -11023,7 +11042,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	devices = &fs_info->fs_devices->alloc_list;
 	list_for_each_entry(device, devices, dev_alloc_list) {
 		ret = btrfs_trim_free_extents(device, range->minlen,
-					      &group_trimmed);
+					      &group_trimmed,
+					      BTRFS_CLEAR_OP_DISCARD);
 		if (ret)
 			break;
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e5b569bebc73..be7bfb99df9a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3102,7 +3102,8 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 static int do_trimming(struct btrfs_block_group_cache *block_group,
 		       u64 *total_trimmed, u64 start, u64 bytes,
 		       u64 reserved_start, u64 reserved_bytes,
-		       struct btrfs_trim_range *trim_entry)
+		       struct btrfs_trim_range *trim_entry,
+		       enum btrfs_clear_op_type clear)
 {
 	struct btrfs_space_info *space_info = block_group->space_info;
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
@@ -3121,7 +3122,7 @@ static int do_trimming(struct btrfs_block_group_cache *block_group,
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
 
-	ret = btrfs_discard_extent(fs_info, start, bytes, &trimmed);
+	ret = btrfs_discard_extent(fs_info, start, bytes, &trimmed, clear);
 	if (!ret)
 		*total_trimmed += trimmed;
 
@@ -3145,7 +3146,8 @@ static int do_trimming(struct btrfs_block_group_cache *block_group,
 }
 
 static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
-			  u64 *total_trimmed, u64 start, u64 end, u64 minlen)
+			  u64 *total_trimmed, u64 start, u64 end, u64 minlen,
+			  enum btrfs_clear_op_type clear)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -3212,7 +3214,7 @@ static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
 		mutex_unlock(&ctl->cache_writeout_mutex);
 
 		ret = do_trimming(block_group, total_trimmed, start, bytes,
-				  extent_start, extent_bytes, &trim_entry);
+				extent_start, extent_bytes, &trim_entry, clear);
 		if (ret)
 			break;
 next:
@@ -3230,7 +3232,8 @@ static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
 }
 
 static int trim_bitmaps(struct btrfs_block_group_cache *block_group,
-			u64 *total_trimmed, u64 start, u64 end, u64 minlen)
+			u64 *total_trimmed, u64 start, u64 end, u64 minlen,
+			enum btrfs_clear_op_type clear)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -3287,7 +3290,7 @@ static int trim_bitmaps(struct btrfs_block_group_cache *block_group,
 		mutex_unlock(&ctl->cache_writeout_mutex);
 
 		ret = do_trimming(block_group, total_trimmed, start, bytes,
-				  start, bytes, &trim_entry);
+				  start, bytes, &trim_entry, clear);
 		if (ret)
 			break;
 next:
@@ -3355,7 +3358,8 @@ void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *block_group)
 }
 
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
-			   u64 *trimmed, u64 start, u64 end, u64 minlen)
+			   u64 *trimmed, u64 start, u64 end, u64 minlen,
+			   enum btrfs_clear_op_type clear)
 {
 	int ret;
 
@@ -3369,11 +3373,11 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 	btrfs_get_block_group_trimming(block_group);
 	spin_unlock(&block_group->lock);
 
-	ret = trim_no_bitmap(block_group, trimmed, start, end, minlen);
+	ret = trim_no_bitmap(block_group, trimmed, start, end, minlen, clear);
 	if (ret)
 		goto out;
 
-	ret = trim_bitmaps(block_group, trimmed, start, end, minlen);
+	ret = trim_bitmaps(block_group, trimmed, start, end, minlen, clear);
 out:
 	btrfs_put_block_group_trimming(block_group);
 	return ret;
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 15e30b93db0d..794a444c3f73 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -107,7 +107,8 @@ int btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group_cache *block_group,
 			       struct btrfs_free_cluster *cluster);
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
-			   u64 *trimmed, u64 start, u64 end, u64 minlen);
+			   u64 *trimmed, u64 start, u64 end, u64 minlen,
+			   enum btrfs_clear_op_type clear);
 
 /* Support functions for running our sanity tests */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-- 
2.16.2

