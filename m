From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use bytes_may_use for all ENOSPC reservations V2
Date: Wed, 27 Jul 2011 11:22:00 -0400
Message-ID: <1311780120-9893-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have been using bytes_reserved for metadata reservations, which is wrong
since we use that to keep track of outstanding reservations from the allocator.
This resulted in us doing a lot of silly things to make sure we don't allocate a
bunch of metadata chunks since we never had a real view of how much space was
actually in use by metadata.

There are a lot of fixes in here to make this work, but the biggest things are
this

1) When we make a disk reservation we drop bytes_may_use and add to
bytes_reserved.  We didn't use to do this because delalloc would update
bytes_may_use when it cleared delalloc.  So now we don't do this, we only will
update bytes_may_use if we have an error and have to clear the accounting
manually.

2) In should_alloc_chunk() we need to take into account the global_rsv size
since that is basically used space.  This will make sure we do actually alloc
chunks.  This logic needs to be reworked anyway, but since this is all very
touchy I'll leave that for a different patch.

This passes Arne's enospc test and xfstests as well as my own enospc tests.
Hopefully this will get us moving in the right direction.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: Don't take the global_rsv->lock in should_alloc_chunk since it's the
wrong locking order.  We don't need it anyway, size only changes every
transaction commit.
 fs/btrfs/ctree.h            |    9 +-
 fs/btrfs/disk-io.c          |    6 +-
 fs/btrfs/extent-tree.c      |  190 +++++++++++++++++++++++++------------------
 fs/btrfs/file.c             |    7 ++-
 fs/btrfs/free-space-cache.c |    9 +--
 fs/btrfs/inode.c            |    6 +-
 6 files changed, 128 insertions(+), 99 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ad28922..8b9e1f9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2198,8 +2198,6 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 root_objectid, u64 owner, u64 offset);
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
-int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				u64 num_bytes, int reserve, int sinfo);
 int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
@@ -2269,8 +2267,11 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
 				   u64 start, u64 end);
-int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
-			       u64 num_bytes, u64 *actual_bytes);
+int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
+			 u64 *actual_bytes);
+int btrfs_error_discard_extent(struct btrfs_root *root,
+			       struct btrfs_block_group_cache *block_group,
+			       u64 bytenr, u64 num_bytes, u64 *actual_bytes);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 type);
 int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 36d19e8..15b3857 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3003,9 +3003,9 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 
 		/* opt_discard */
 		if (btrfs_test_opt(root, DISCARD))
-			ret = btrfs_error_discard_extent(root, start,
-							 end + 1 - start,
-							 NULL);
+			ret = btrfs_discard_extent(root, start,
+						   end + 1 - start,
+						   NULL);
 
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 		btrfs_error_unpin_extent_range(root, start, end);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4256ab0..ef2cc09 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -52,6 +52,21 @@ enum {
 	CHUNK_ALLOC_LIMITED = 2,
 };
 
+/*
+ * Control how reservations are dealt with.
+ *
+ * RESERVE_FREE - freeing a reservation.
+ * RESERVE_ALLOC - a reservation from the allocator.  We do the ENOSPC
+ *	accounting in this case
+ * RESERVE_LOG - a reservation from the tree logging code.  We don't do the
+ *	ENOSPC accounting in this case.
+ */
+enum {
+	RESERVE_FREE = 0,
+	RESERVE_ALLOC = 1,
+	RESERVE_LOG = 2,
+};
+
 static int update_block_group(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc);
@@ -81,6 +96,8 @@ static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups);
+static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				       u64 num_bytes, int reserve);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -1764,8 +1781,8 @@ static int btrfs_issue_discard(struct block_device *bdev,
 	return blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
 }
 
-static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
-				u64 num_bytes, u64 *actual_bytes)
+int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
+			 u64 *actual_bytes)
 {
 	int ret;
 	u64 discarded_bytes = 0;
@@ -2739,7 +2756,8 @@ again:
 					      &alloc_hint);
 	if (!ret)
 		dcs = BTRFS_DC_SETUP;
-	btrfs_free_reserved_data_space(inode, num_pages);
+	else
+		btrfs_free_reserved_data_space(inode, num_pages);
 out_put:
 	iput(inode);
 out_free:
@@ -3119,9 +3137,7 @@ commit_trans:
 }
 
 /*
- * called when we are clearing an delalloc extent from the
- * inode's io_tree or there was an error for whatever reason
- * after calling btrfs_check_data_free_space
+ * Called if we need to clear a data reservation for this inode.
  */
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 {
@@ -3154,6 +3170,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 			      struct btrfs_space_info *sinfo, u64 alloc_bytes,
 			      int force)
 {
+	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
 	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved;
 	u64 thresh;
@@ -3162,6 +3179,13 @@ static int should_alloc_chunk(struct btrfs_root *root,
 		return 1;
 
 	/*
+	 * We need to take into account the global rsv because for all intents
+	 * and purposes it's used space.  Don't worry about locking the
+	 * global_rsv, it doesn't change except when the transaction commits.
+	 */
+	num_allocated += global_rsv->size;
+
+	/*
 	 * in limited mode, we want to have some free space up to
 	 * about 1% of the FS size.
 	 */
@@ -3304,7 +3328,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	space_info = block_rsv->space_info;
 
 	smp_mb();
-	reserved = space_info->bytes_reserved;
+	reserved = space_info->bytes_may_use;
 	progress = space_info->reservation_progress;
 
 	if (reserved == 0)
@@ -3328,9 +3352,9 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
 
 		spin_lock(&space_info->lock);
-		if (reserved > space_info->bytes_reserved)
-			reclaimed += reserved - space_info->bytes_reserved;
-		reserved = space_info->bytes_reserved;
+		if (reserved > space_info->bytes_may_use)
+			reclaimed += reserved - space_info->bytes_may_use;
+		reserved = space_info->bytes_may_use;
 		spin_unlock(&space_info->lock);
 
 		loops++;
@@ -3388,7 +3412,6 @@ static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	bool committed = false;
 	bool flushing = false;
-
 again:
 	ret = 0;
 	spin_lock(&space_info->lock);
@@ -3430,7 +3453,7 @@ again:
 	if (unused <= space_info->total_bytes) {
 		unused = space_info->total_bytes - unused;
 		if (unused >= num_bytes) {
-			space_info->bytes_reserved += orig_bytes;
+			space_info->bytes_may_use += orig_bytes;
 			ret = 0;
 		} else {
 			/*
@@ -3596,7 +3619,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 		}
 		if (num_bytes) {
 			spin_lock(&space_info->lock);
-			space_info->bytes_reserved -= num_bytes;
+			space_info->bytes_may_use -= num_bytes;
 			space_info->reservation_progress++;
 			spin_unlock(&space_info->lock);
 		}
@@ -3807,12 +3830,12 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	if (sinfo->total_bytes > num_bytes) {
 		num_bytes = sinfo->total_bytes - num_bytes;
 		block_rsv->reserved += num_bytes;
-		sinfo->bytes_reserved += num_bytes;
+		sinfo->bytes_may_use += num_bytes;
 	}
 
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
-		sinfo->bytes_reserved -= num_bytes;
+		sinfo->bytes_may_use -= num_bytes;
 		sinfo->reservation_progress++;
 		block_rsv->reserved = block_rsv->size;
 		block_rsv->full = 1;
@@ -4115,7 +4138,6 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->reserved -= num_bytes;
 			cache->space_info->bytes_reserved -= num_bytes;
-			cache->space_info->reservation_progress++;
 			cache->space_info->bytes_used += num_bytes;
 			cache->space_info->disk_used += num_bytes * factor;
 			spin_unlock(&cache->lock);
@@ -4167,7 +4189,6 @@ static int pin_down_extent(struct btrfs_root *root,
 	if (reserved) {
 		cache->reserved -= num_bytes;
 		cache->space_info->bytes_reserved -= num_bytes;
-		cache->space_info->reservation_progress++;
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
@@ -4194,46 +4215,56 @@ int btrfs_pin_extent(struct btrfs_root *root,
 	return 0;
 }
 
-/*
- * update size of reserved extents. this function may return -EAGAIN
- * if 'reserve' is true or 'sinfo' is false.
+/**
+ * btrfs_update_reserved_bytes - update the block_group and space info counters
+ * @cache:	The cache we are manipulating
+ * @num_bytes:	The number of bytes in question
+ * @reserve:	One of the reservation enums
+ *
+ * This is called by the allocator when it reserves space, or by somebody who is
+ * freeing space that was never actually used on disk.  For example if you
+ * reserve some space for a new leaf in transaction A and before transaction A
+ * commits you free that leaf, you call this with reserve set to 0 in order to
+ * clear the reservation.
+ *
+ * In the reservation case this will decrement bytes_may_use in order to account
+ * for ENOSPC handling.  space_info->bytes_may_use accounts for what we beleive
+ * we may allocate from disk, so when we make a disk allocation we must update
+ * bytes_may_use to account for the reservation.
+ *
+ * may_use only matters if reserve == 1 and should always be set to 1 unless 
+ *
+ * If this is a reservation and the block group has become read only we cannot
+ * make the reservation and return -EAGAIN, otherwise this function always
+ * succeeds.
  */
-int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				u64 num_bytes, int reserve, int sinfo)
+static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
+				       u64 num_bytes, int reserve)
 {
+	struct btrfs_space_info *space_info = cache->space_info;
 	int ret = 0;
-	if (sinfo) {
-		struct btrfs_space_info *space_info = cache->space_info;
-		spin_lock(&space_info->lock);
-		spin_lock(&cache->lock);
-		if (reserve) {
-			if (cache->ro) {
-				ret = -EAGAIN;
-			} else {
-				cache->reserved += num_bytes;
-				space_info->bytes_reserved += num_bytes;
-			}
-		} else {
-			if (cache->ro)
-				space_info->bytes_readonly += num_bytes;
-			cache->reserved -= num_bytes;
-			space_info->bytes_reserved -= num_bytes;
-			space_info->reservation_progress++;
-		}
-		spin_unlock(&cache->lock);
-		spin_unlock(&space_info->lock);
-	} else {
-		spin_lock(&cache->lock);
+	spin_lock(&space_info->lock);
+	spin_lock(&cache->lock);
+	if (reserve != RESERVE_FREE) {
 		if (cache->ro) {
 			ret = -EAGAIN;
 		} else {
-			if (reserve)
-				cache->reserved += num_bytes;
-			else
-				cache->reserved -= num_bytes;
+			cache->reserved += num_bytes;
+			space_info->bytes_reserved += num_bytes;
+			if (reserve == RESERVE_ALLOC) {
+				BUG_ON(space_info->bytes_may_use < num_bytes);
+				space_info->bytes_may_use -= num_bytes;
+			}
 		}
-		spin_unlock(&cache->lock);
+	} else {
+		if (cache->ro)
+			space_info->bytes_readonly += num_bytes;
+		cache->reserved -= num_bytes;
+		space_info->bytes_reserved -= num_bytes;
+		space_info->reservation_progress++;
 	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&space_info->lock);
 	return ret;
 }
 
@@ -4304,7 +4335,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 		} else if (cache->reserved_pinned > 0) {
 			len = min(len, cache->reserved_pinned);
 			cache->reserved_pinned -= len;
-			cache->space_info->bytes_reserved += len;
+			cache->space_info->bytes_may_use += len;
 		}
 		spin_unlock(&cache->lock);
 		spin_unlock(&cache->space_info->lock);
@@ -4683,27 +4714,8 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
-		ret = btrfs_update_reserved_bytes(cache, buf->len, 0, 0);
-		if (ret == -EAGAIN) {
-			/* block group became read-only */
-			btrfs_update_reserved_bytes(cache, buf->len, 0, 1);
-			goto out;
-		}
-
-		ret = 1;
-		spin_lock(&block_rsv->lock);
-		if (block_rsv->reserved < block_rsv->size) {
-			block_rsv->reserved += buf->len;
-			ret = 0;
-		}
-		spin_unlock(&block_rsv->lock);
+		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
 
-		if (ret) {
-			spin_lock(&cache->space_info->lock);
-			cache->space_info->bytes_reserved -= buf->len;
-			cache->space_info->reservation_progress++;
-			spin_unlock(&cache->space_info->lock);
-		}
 		goto out;
 	}
 pin:
@@ -5180,8 +5192,8 @@ checks:
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
-		ret = btrfs_update_reserved_bytes(block_group, num_bytes, 1,
-					    (data & BTRFS_BLOCK_GROUP_DATA));
+		ret = btrfs_update_reserved_bytes(block_group, num_bytes,
+						  RESERVE_ALLOC);
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
@@ -5405,7 +5417,7 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 		ret = btrfs_discard_extent(root, start, len, NULL);
 
 	btrfs_add_free_space(cache, start, len);
-	btrfs_update_reserved_bytes(cache, len, 0, 1);
+	btrfs_update_reserved_bytes(cache, len, RESERVE_FREE);
 	btrfs_put_block_group(cache);
 
 	trace_btrfs_reserved_extent_free(root, start, len);
@@ -5607,7 +5619,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		put_caching_control(caching_ctl);
 	}
 
-	ret = btrfs_update_reserved_bytes(block_group, ins->offset, 1, 1);
+	ret = btrfs_update_reserved_bytes(block_group, ins->offset,
+					  RESERVE_LOG);
 	BUG_ON(ret);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
@@ -6545,7 +6558,7 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache)
 	    sinfo->bytes_may_use + sinfo->bytes_readonly +
 	    cache->reserved_pinned + num_bytes <= sinfo->total_bytes) {
 		sinfo->bytes_readonly += num_bytes;
-		sinfo->bytes_reserved += cache->reserved_pinned;
+		sinfo->bytes_may_use += cache->reserved_pinned;
 		cache->reserved_pinned = 0;
 		cache->ro = 1;
 		ret = 0;
@@ -7287,10 +7300,31 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 	return unpin_extent_range(root, start, end);
 }
 
-int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
-			       u64 num_bytes, u64 *actual_bytes)
+int btrfs_error_discard_extent(struct btrfs_root *root,
+			       struct btrfs_block_group_cache *block_group,
+			       u64 bytenr, u64 num_bytes, u64 *actual_bytes)
 {
-	return btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
+	int update_ret = 1;
+	int ret;
+
+	/*
+	 * This is just for proper space accounting, we already removed the free
+	 * space from the block_group so this is just updating counters.
+	 *
+	 * XXX this is a little racy, we should be doing this first and then
+	 * removing the space, otherwise there is a window where the space
+	 * doesn't exist but the counters think it does.  Granted this is
+	 * small, but it should be fixed at some point.
+	 */
+	update_ret = btrfs_update_reserved_bytes(block_group, num_bytes,
+						 RESERVE_ALLOC);
+
+	ret = btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
+
+	if (!update_ret)
+		btrfs_update_reserved_bytes(block_group, num_bytes,
+					    RESERVE_FREE);
+	return ret;
 }
 
 int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a35e51c..e93cf0a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1670,7 +1670,12 @@ static long btrfs_fallocate(struct file *file, int mode,
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			     &cached_state, GFP_NOFS);
 
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
+	/*
+	 * We failed to allocate some of our space, so free up part of our
+	 * reservation.
+	 */
+	if (cur_offset < alloc_end)
+		btrfs_free_reserved_data_space(inode, alloc_end - cur_offset);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6377713..85bbac9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2462,20 +2462,13 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		spin_unlock(&ctl->tree_lock);
 
 		if (bytes >= minlen) {
-			int update_ret;
-			update_ret = btrfs_update_reserved_bytes(block_group,
-								 bytes, 1, 1);
-
 			ret = btrfs_error_discard_extent(fs_info->extent_root,
+							 block_group,
 							 start,
 							 bytes,
 							 &actually_trimmed);
 
 			btrfs_add_free_space(block_group, start, bytes);
-			if (!update_ret)
-				btrfs_update_reserved_bytes(block_group,
-							    bytes, 0, 1);
-
 			if (ret)
 				break;
 			*trimmed += actually_trimmed;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0b858d7..ffd0924 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1388,11 +1388,7 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		}
 
 		if (*bits & EXTENT_DO_ACCOUNTING)
-			btrfs_delalloc_release_metadata(inode, len);
-
-		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-		    && do_list)
-			btrfs_free_reserved_data_space(inode, len);
+			btrfs_delalloc_release_space(inode, len);
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		root->fs_info->delalloc_bytes -= len;
-- 
1.7.5.2

