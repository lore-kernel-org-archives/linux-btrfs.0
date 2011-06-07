From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix btrfs_update_reserved_bytes usage
Date: Tue,  7 Jun 2011 13:38:02 -0400
Message-ID: <1307468282-22779-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For some reason btrfs_update_reserved_bytes was only ever updating the
bytes_reserved counter of the space info if the space info was data.  I assume
this is because the original enospc stuff used bytes_reserved to account for
space reserved for enospc accounting, but now that we're using bytes_may_use
thats incorrect.  So this patch fixes btrfs_update_reserved_bytes to always
update the space_info as well.  Also it fixes a weird case where we tried to add
the space to the enospc accounting stuff.  Rather than doing that just add it
back to the space info and then it can be accounted for later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/extent-tree.c      |   76 ++++++++++++------------------------------
 fs/btrfs/free-space-cache.c |    4 +-
 3 files changed, 25 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 93a409f..0c62c6c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2177,7 +2177,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
 int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				u64 num_bytes, int reserve, int sinfo);
+				u64 num_bytes, int reserve);
 int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 933d7dc..aa2b592a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4194,44 +4194,33 @@ int btrfs_pin_extent(struct btrfs_root *root,
 
 /*
  * update size of reserved extents. this function may return -EAGAIN
- * if 'reserve' is true or 'sinfo' is false.
+ * if 'reserve' is true.
  */
 int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				u64 num_bytes, int reserve, int sinfo)
+				u64 num_bytes, int reserve)
 {
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
+	struct btrfs_space_info *space_info = cache->space_info;
+
+	spin_lock(&space_info->lock);
+	spin_lock(&cache->lock);
+	if (reserve) {
 		if (cache->ro) {
 			ret = -EAGAIN;
 		} else {
-			if (reserve)
-				cache->reserved += num_bytes;
-			else
-				cache->reserved -= num_bytes;
+			cache->reserved += num_bytes;
+			space_info->bytes_reserved += num_bytes;
 		}
-		spin_unlock(&cache->lock);
+	} else {
+		if (cache->ro)
+			space_info->bytes_readonly += num_bytes;
+		cache->reserved -= num_bytes;
+		WARN_ON(space_info->bytes_reserved < num_bytes);
+		space_info->bytes_reserved -= num_bytes;
+		space_info->reservation_progress++;
 	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&space_info->lock);
 	return ret;
 }
 
@@ -4679,27 +4668,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
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
-
-		if (ret) {
-			spin_lock(&cache->space_info->lock);
-			cache->space_info->bytes_reserved -= buf->len;
-			cache->space_info->reservation_progress++;
-			spin_unlock(&cache->space_info->lock);
-		}
+		btrfs_update_reserved_bytes(cache, buf->len, 0);
 		goto out;
 	}
 pin:
@@ -5180,8 +5149,7 @@ checks:
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
-		ret = btrfs_update_reserved_bytes(block_group, num_bytes, 1,
-					    (data & BTRFS_BLOCK_GROUP_DATA));
+		ret = btrfs_update_reserved_bytes(block_group, num_bytes, 1);
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
@@ -5406,7 +5374,7 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 		ret = btrfs_discard_extent(root, start, len, NULL);
 
 	btrfs_add_free_space(cache, start, len);
-	btrfs_update_reserved_bytes(cache, len, 0, 1);
+	btrfs_update_reserved_bytes(cache, len, 0);
 	btrfs_put_block_group(cache);
 
 	trace_btrfs_reserved_extent_free(root, start, len);
@@ -5608,7 +5576,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		put_caching_control(caching_ctl);
 	}
 
-	ret = btrfs_update_reserved_bytes(block_group, ins->offset, 1, 1);
+	ret = btrfs_update_reserved_bytes(block_group, ins->offset, 1);
 	BUG_ON(ret);
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 38f3fd9..c97fa7e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2511,7 +2511,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		if (bytes >= minlen) {
 			int update_ret;
 			update_ret = btrfs_update_reserved_bytes(block_group,
-								 bytes, 1, 1);
+								 bytes, 1);
 
 			ret = btrfs_error_discard_extent(fs_info->extent_root,
 							 start,
@@ -2521,7 +2521,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			btrfs_add_free_space(block_group, start, bytes);
 			if (!update_ret)
 				btrfs_update_reserved_bytes(block_group,
-							    bytes, 0, 1);
+							    bytes, 0);
 
 			if (ret)
 				break;
-- 
1.7.2.3

