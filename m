From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs: speed up fstrim
Date: Thu, 29 Dec 2011 17:49:58 +0800
Message-ID: <4EFC37C6.40307@cn.fujitsu.com>
References: <4EFC378D.7090606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFC378D.7090606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

By remembering which areas has been trimmed, we can speed up
fstrim significantly.

    # fstrim -v /mnt/
    /mnt/: 152772608 bytes were trimmed
    # fstrim -v /mnt/
    /mnt/: 0 bytes were trimmed

No bytes has to be trimmed for the second run.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c      |   29 ++++++++++++++++++-----------
 fs/btrfs/free-space-cache.c |   38 ++++++++++++++++++++++++++++++++------
 fs/btrfs/free-space-cache.h |    7 ++++---
 fs/btrfs/inode-map.c        |   16 +++++++++-------
 4 files changed, 63 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5fbe57..e743395 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -319,7 +319,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 			size = extent_start - start;
 			total_added += size;
 			ret = btrfs_add_free_space(block_group, start,
-						   size);
+						   size, false);
 			BUG_ON(ret);
 			start = extent_end + 1;
 		} else {
@@ -330,7 +330,7 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	if (start < end) {
 		size = end - start;
 		total_added += size;
-		ret = btrfs_add_free_space(block_group, start, size);
+		ret = btrfs_add_free_space(block_group, start, size, false);
 		BUG_ON(ret);
 	}
 
@@ -4631,7 +4631,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 
 		if (start < cache->last_byte_to_unpin) {
 			len = min(len, cache->last_byte_to_unpin - start);
-			btrfs_add_free_space(cache, start, len);
+			btrfs_add_free_space(cache, start, len, false);
 		}
 
 		start += len;
@@ -4987,7 +4987,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
 
-		btrfs_add_free_space(cache, buf->start, buf->len);
+		btrfs_add_free_space(cache, buf->start, buf->len, false);
 		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
 	}
 out:
@@ -5427,14 +5427,16 @@ checks:
 		search_start = stripe_align(root, offset);
 		/* move on to the next group */
 		if (search_start + num_bytes >= search_end) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
+			btrfs_add_free_space(used_block_group, offset,
+					     num_bytes, false);
 			goto loop;
 		}
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
 		    used_block_group->key.objectid + used_block_group->key.offset) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
+			btrfs_add_free_space(used_block_group, offset,
+					     num_bytes, false);
 			goto loop;
 		}
 
@@ -5443,13 +5445,14 @@ checks:
 
 		if (offset < search_start)
 			btrfs_add_free_space(used_block_group, offset,
-					     search_start - offset);
+					     search_start - offset, false);
 		BUG_ON(offset > search_start);
 
 		ret = btrfs_update_reserved_bytes(used_block_group, num_bytes,
 						  alloc_type);
 		if (ret == -EAGAIN) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
+			btrfs_add_free_space(used_block_group, offset,
+					     num_bytes, false);
 			goto loop;
 		}
 
@@ -5459,7 +5462,7 @@ checks:
 
 		if (offset < search_start)
 			btrfs_add_free_space(used_block_group, offset,
-					     search_start - offset);
+					     search_start - offset, false);
 		BUG_ON(offset > search_start);
 		if (used_block_group != block_group)
 			btrfs_put_block_group(used_block_group);
@@ -5668,6 +5671,7 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 {
 	struct btrfs_block_group_cache *cache;
 	int ret = 0;
+	bool trimmed = false;
 
 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
@@ -5676,13 +5680,16 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 		return -ENOSPC;
 	}
 
-	if (btrfs_test_opt(root, DISCARD))
+	if (btrfs_test_opt(root, DISCARD)) {
 		ret = btrfs_discard_extent(root, start, len, NULL);
+		if (!ret)
+			trimmed = true;
+	}
 
 	if (pin)
 		pin_down_extent(root, cache, start, len, 1);
 	else {
-		btrfs_add_free_space(cache, start, len);
+		btrfs_add_free_space(cache, start, len, trimmed);
 		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE);
 	}
 	btrfs_put_block_group(cache);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 044c0ec..cba2a94 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1567,7 +1567,7 @@ again:
 
 static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 			       struct btrfs_free_space *info, u64 offset,
-			       u64 bytes)
+			       u64 bytes, bool trimmed)
 {
 	u64 bytes_to_set = 0;
 	u64 end;
@@ -1578,6 +1578,9 @@ static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 
 	bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
+	if (info->trimmed && !trimmed)
+		info->trimmed = false;
+
 	return bytes_to_set;
 
 }
@@ -1631,9 +1634,11 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 	int added = 0;
 	u64 bytes, offset, bytes_added;
 	int ret;
+	bool trimmed;
 
 	bytes = info->bytes;
 	offset = info->offset;
+	trimmed = info->trimmed;
 
 	if (!ctl->op->use_bitmap(ctl, info))
 		return 0;
@@ -1669,7 +1674,8 @@ again:
 
 		if (entry->offset == offset_to_bitmap(ctl, offset)) {
 			bytes_added = add_bytes_to_bitmap(ctl, entry,
-							  offset, bytes);
+							  offset, bytes,
+							  trimmed);
 			bytes -= bytes_added;
 			offset += bytes_added;
 		}
@@ -1688,7 +1694,8 @@ no_cluster_bitmap:
 		goto new_bitmap;
 	}
 
-	bytes_added = add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes);
+	bytes_added = add_bytes_to_bitmap(ctl, bitmap_info, offset, bytes,
+					  trimmed);
 	bytes -= bytes_added;
 	offset += bytes_added;
 	added = 0;
@@ -1721,6 +1728,7 @@ new_bitmap:
 
 		/* allocate the bitmap */
 		info->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+		info->trimmed = trimmed;
 		spin_lock(&ctl->tree_lock);
 		if (!info->bitmap) {
 			ret = -ENOMEM;
@@ -1766,6 +1774,8 @@ static bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 		else
 			__unlink_free_space(ctl, right_info);
 		info->bytes += right_info->bytes;
+		if (!right_info->trimmed)
+			info->trimmed = false;
 		kmem_cache_free(btrfs_free_space_cachep, right_info);
 		merged = true;
 	}
@@ -1778,6 +1788,8 @@ static bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 			__unlink_free_space(ctl, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
+		if (!left_info->trimmed)
+			info->trimmed = false;
 		kmem_cache_free(btrfs_free_space_cachep, left_info);
 		merged = true;
 	}
@@ -1786,7 +1798,7 @@ static bool try_merge_free_space(struct btrfs_free_space_ctl *ctl,
 }
 
 int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
-			   u64 offset, u64 bytes)
+			   u64 offset, u64 bytes, bool trimmed)
 {
 	struct btrfs_free_space *info;
 	int ret = 0;
@@ -1797,6 +1809,7 @@ int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
 
 	info->offset = offset;
 	info->bytes = bytes;
+	info->trimmed = trimmed;
 
 	spin_lock(&ctl->tree_lock);
 
@@ -1940,7 +1953,7 @@ again:
 		 * anything before the hole
 		 */
 		ret = btrfs_add_free_space(block_group, old_start,
-					   offset - old_start);
+					   offset - old_start, false);
 		WARN_ON(ret);
 		goto out;
 	}
@@ -2620,6 +2633,13 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		}
 
 		if (entry->bitmap) {
+			if (entry->trimmed) {
+				start = entry->offset + BITS_PER_BITMAP *
+					block_group->sectorsize;
+				spin_unlock(&ctl->tree_lock);
+				continue;
+			}
+
 			ret = search_bitmap(ctl, entry, &start, &bytes);
 			if (!ret) {
 				if (start >= end) {
@@ -2638,6 +2658,12 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 				continue;
 			}
 		} else {
+			if (entry->trimmed) {
+				start = entry->offset + entry->bytes;
+				spin_unlock(&ctl->tree_lock);
+				continue;
+			}
+
 			start = entry->offset;
 			bytes = min(entry->bytes, end - start);
 			unlink_free_space(ctl, entry);
@@ -2666,7 +2692,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 							 bytes,
 							 &actually_trimmed);
 
-			btrfs_add_free_space(block_group, start, bytes);
+			btrfs_add_free_space(block_group, start, bytes, true);
 			if (update) {
 				spin_lock(&space_info->lock);
 				spin_lock(&block_group->lock);
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 8f2613f..befc682 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -25,6 +25,7 @@ struct btrfs_free_space {
 	u64 bytes;
 	unsigned long *bitmap;
 	struct list_head list;
+	bool trimmed;
 };
 
 struct btrfs_free_space_ctl {
@@ -78,13 +79,13 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
 int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
-			   u64 bytenr, u64 size);
+			   u64 bytenr, u64 size, bool trimmed);
 static inline int
 btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-		     u64 bytenr, u64 size)
+		     u64 bytenr, u64 size, bool trimmed)
 {
 	return __btrfs_add_free_space(block_group->free_space_ctl,
-				      bytenr, size);
+				      bytenr, size, trimmed);
 }
 int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			    u64 bytenr, u64 size);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index f8962a9..05d73a4 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -107,7 +107,7 @@ again:
 
 		if (last != (u64)-1 && last + 1 != key.objectid) {
 			__btrfs_add_free_space(ctl, last + 1,
-					       key.objectid - last - 1);
+					       key.objectid - last - 1, false);
 			wake_up(&root->cache_wait);
 		}
 
@@ -118,7 +118,8 @@ next:
 
 	if (last < root->highest_objectid - 1) {
 		__btrfs_add_free_space(ctl, last + 1,
-				       root->highest_objectid - last - 1);
+				       root->highest_objectid - last - 1,
+				       false);
 	}
 
 	spin_lock(&root->cache_lock);
@@ -173,7 +174,8 @@ static void start_caching(struct btrfs_root *root)
 	ret = btrfs_find_free_objectid(root, &objectid);
 	if (!ret && objectid <= BTRFS_LAST_FREE_OBJECTID) {
 		__btrfs_add_free_space(ctl, objectid,
-				       BTRFS_LAST_FREE_OBJECTID - objectid + 1);
+				       BTRFS_LAST_FREE_OBJECTID - objectid + 1,
+				       false);
 	}
 
 	tsk = kthread_run(caching_kthread, root, "btrfs-ino-cache-%llu\n",
@@ -215,7 +217,7 @@ void btrfs_return_ino(struct btrfs_root *root, u64 objectid)
 
 again:
 	if (root->cached == BTRFS_CACHE_FINISHED) {
-		__btrfs_add_free_space(ctl, objectid, 1);
+		__btrfs_add_free_space(ctl, objectid, 1, false);
 	} else {
 		/*
 		 * If we are in the process of caching free ino chunks,
@@ -238,9 +240,9 @@ again:
 
 		if (objectid <= root->cache_progress ||
 		    objectid > root->highest_objectid)
-			__btrfs_add_free_space(ctl, objectid, 1);
+			__btrfs_add_free_space(ctl, objectid, 1, false);
 		else
-			__btrfs_add_free_space(pinned, objectid, 1);
+			__btrfs_add_free_space(pinned, objectid, 1, false);
 
 		mutex_unlock(&root->fs_commit_mutex);
 	}
@@ -280,7 +282,7 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
 		else
 			count = info->bytes;
 
-		__btrfs_add_free_space(ctl, info->offset, count);
+		__btrfs_add_free_space(ctl, info->offset, count, false);
 free:
 		rb_erase(&info->offset_index, rbroot);
 		kfree(info);
-- 1.7.3.1 
