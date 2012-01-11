From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 09/11][RESEND] Btrfs: rewrite btrfs_trim_block_group()
Date: Wed, 11 Jan 2012 13:55:07 +0800
Message-ID: <4F0D243B.2020906@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

There are various bugs in block group trimming:

- It may trim from offset smaller than user-specified offset.
- It may trim beyond user-specified range.
- It may leak free space for extents smaller than specified minlen.
- It may truncate the last trimmed extent thus leak free space.
- With mixed extents+bitmaps, some extents may not be trimmed.
- With mixed extents+bitmaps, some bitmaps may not be trimmed (even
none will be trimmed). Even for those trimmed, not all the free space
in the bitmaps will be trimmed.

I rewrite btrfs_trim_block_group() and break it into two functions.
One is to trim extents only, and the other is to trim bitmaps only.

Before patching:

	# fstrim -v /mnt/
	/mnt/: 1496465408 bytes were trimmed

After patching:

	# fstrim -v /mnt/
	/mnt/: 2193768448 bytes were trimmed

And this matches the total free space:

	# btrfs fi df /mnt
	Data: total=3.58GB, used=1.79GB
	System, DUP: total=8.00MB, used=4.00KB
	System: total=4.00MB, used=0.00
	Metadata, DUP: total=205.12MB, used=97.14MB
	Metadata: total=8.00MB, used=0.00

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |  235 ++++++++++++++++++++++++++++++-------------
 1 files changed, 164 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e4eb222..b3cbb89 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2594,17 +2594,57 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	cluster->block_group = NULL;
 }
 
-int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
-			   u64 *trimmed, u64 start, u64 end, u64 minlen)
+static int do_trimming(struct btrfs_block_group_cache *block_group,
+		       u64 *total_trimmed, u64 start, u64 bytes,
+		       u64 reserved_start, u64 reserved_bytes)
 {
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_free_space *entry = NULL;
+	struct btrfs_space_info *space_info = block_group->space_info;
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	u64 bytes = 0;
-	u64 actually_trimmed;
-	int ret = 0;
+	int ret;
+	int update = 0;
+	u64 trimmed = 0;
 
-	*trimmed = 0;
+	spin_lock(&space_info->lock);
+	spin_lock(&block_group->lock);
+	if (!block_group->ro) {
+		block_group->reserved += reserved_bytes;
+		space_info->bytes_reserved += reserved_bytes;
+		update = 1;
+	}
+	spin_unlock(&block_group->lock);
+	spin_unlock(&space_info->lock);
+
+	ret = btrfs_error_discard_extent(fs_info->extent_root,
+					 start, bytes, &trimmed);
+	if (!ret)
+		*total_trimmed += trimmed;
+
+	btrfs_add_free_space(block_group, reserved_start, reserved_bytes);
+
+	if (update) {
+		spin_lock(&space_info->lock);
+		spin_lock(&block_group->lock);
+		if (block_group->ro)
+			space_info->bytes_readonly += reserved_bytes;
+		block_group->reserved -= reserved_bytes;
+		space_info->bytes_reserved -= reserved_bytes;
+		spin_unlock(&space_info->lock);
+		spin_unlock(&block_group->lock);
+	}
+
+	return ret;
+}
+
+static int trim_no_bitmap(struct btrfs_block_group_cache *block_group,
+			  u64 *total_trimmed, u64 start, u64 end, u64 minlen)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct btrfs_free_space *entry;
+	struct rb_node *node;
+	int ret = 0;
+	u64 extent_start;
+	u64 extent_bytes;
+	u64 bytes;
 
 	while (start < end) {
 		spin_lock(&ctl->tree_lock);
@@ -2615,81 +2655,118 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 		}
 
 		entry = tree_search_offset(ctl, start, 0, 1);
-		if (!entry)
-			entry = tree_search_offset(ctl,
-						   offset_to_bitmap(ctl, start),
-						   1, 1);
-
-		if (!entry || entry->offset >= end) {
+		if (!entry) {
 			spin_unlock(&ctl->tree_lock);
 			break;
 		}
 
-		if (entry->bitmap) {
-			ret = search_bitmap(ctl, entry, &start, &bytes);
-			if (!ret) {
-				if (start >= end) {
-					spin_unlock(&ctl->tree_lock);
-					break;
-				}
-				bytes = min(bytes, end - start);
-				bitmap_clear_bits(ctl, entry, start, bytes);
-				if (entry->bytes == 0)
-					free_bitmap(ctl, entry);
-			} else {
-				start = entry->offset + BITS_PER_BITMAP *
-					block_group->sectorsize;
+		/* skip bitmaps */
+		while (entry->bitmap) {
+			node = rb_next(&entry->offset_index);
+			if (!node) {
 				spin_unlock(&ctl->tree_lock);
-				ret = 0;
-				continue;
+				goto out;
 			}
-		} else {
-			start = entry->offset;
-			bytes = min(entry->bytes, end - start);
-			unlink_free_space(ctl, entry);
-			kmem_cache_free(btrfs_free_space_cachep, entry);
+			entry = rb_entry(node, struct btrfs_free_space,
+					 offset_index);
+		}
+
+		if (entry->offset >= end) {
+			spin_unlock(&ctl->tree_lock);
+			break;
+		}
+
+		extent_start = entry->offset;
+		extent_bytes = entry->bytes;
+		start = max(start, extent_start);
+		bytes = min(extent_start + extent_bytes, end) - start;
+		if (bytes < minlen) {
+			spin_unlock(&ctl->tree_lock);
+			goto next;
 		}
 
+		unlink_free_space(ctl, entry);
+		kmem_cache_free(btrfs_free_space_cachep, entry);
+
 		spin_unlock(&ctl->tree_lock);
 
-		if (bytes >= minlen) {
-			struct btrfs_space_info *space_info;
-			int update = 0;
-
-			space_info = block_group->space_info;
-			spin_lock(&space_info->lock);
-			spin_lock(&block_group->lock);
-			if (!block_group->ro) {
-				block_group->reserved += bytes;
-				space_info->bytes_reserved += bytes;
-				update = 1;
-			}
-			spin_unlock(&block_group->lock);
-			spin_unlock(&space_info->lock);
-
-			ret = btrfs_error_discard_extent(fs_info->extent_root,
-							 start,
-							 bytes,
-							 &actually_trimmed);
-
-			btrfs_add_free_space(block_group, start, bytes);
-			if (update) {
-				spin_lock(&space_info->lock);
-				spin_lock(&block_group->lock);
-				if (block_group->ro)
-					space_info->bytes_readonly += bytes;
-				block_group->reserved -= bytes;
-				space_info->bytes_reserved -= bytes;
-				spin_unlock(&space_info->lock);
-				spin_unlock(&block_group->lock);
-			}
+		ret = do_trimming(block_group, total_trimmed, start, bytes,
+				  extent_start, extent_bytes);
+		if (ret)
+			break;
+next:
+		start += bytes;
 
-			if (ret)
-				break;
-			*trimmed += actually_trimmed;
+		if (fatal_signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		cond_resched();
+	}
+out:
+	return ret;
+}
+
+static int trim_bitmaps(struct btrfs_block_group_cache *block_group,
+			u64 *total_trimmed, u64 start, u64 end, u64 minlen)
+{
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
+	struct btrfs_free_space *entry;
+	int ret = 0;
+	int ret2;
+	u64 bytes;
+	u64 offset = offset_to_bitmap(ctl, start);
+
+	while (offset < end) {
+		bool next_bitmap = false;
+
+		spin_lock(&ctl->tree_lock);
+
+		if (ctl->free_space < minlen) {
+			spin_unlock(&ctl->tree_lock);
+			break;
+		}
+
+		entry = tree_search_offset(ctl, offset, 1, 0);
+		if (!entry) {
+			spin_unlock(&ctl->tree_lock);
+			next_bitmap = true;
+			goto next;
+		}
+
+		bytes = minlen;
+		ret2 = search_bitmap(ctl, entry, &start, &bytes);
+		if (ret2 || start >= end) {
+			spin_unlock(&ctl->tree_lock);
+			next_bitmap = true;
+			goto next;
+		}
+
+		bytes = min(bytes, end - start);
+		if (bytes < minlen) {
+			spin_unlock(&ctl->tree_lock);
+			goto next;
+		}
+
+		bitmap_clear_bits(ctl, entry, start, bytes);
+		if (entry->bytes == 0)
+			free_bitmap(ctl, entry);
+
+		spin_unlock(&ctl->tree_lock);
+
+		ret = do_trimming(block_group, total_trimmed, start, bytes,
+				  start, bytes);
+		if (ret)
+			break;
+next:
+		if (next_bitmap) {
+			offset += BITS_PER_BITMAP * ctl->unit;
+		} else {
+			start += bytes;
+			if (start >= offset + BITS_PER_BITMAP * ctl->unit)
+				offset += BITS_PER_BITMAP * ctl->unit;
 		}
-		start += bytes;
-		bytes = 0;
 
 		if (fatal_signal_pending(current)) {
 			ret = -ERESTARTSYS;
@@ -2702,6 +2779,22 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 	return ret;
 }
 
+int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
+			   u64 *trimmed, u64 start, u64 end, u64 minlen)
+{
+	int ret;
+
+	*trimmed = 0;
+
+	ret = trim_no_bitmap(block_group, trimmed, start, end, minlen);
+	if (ret)
+		return ret;
+
+	ret = trim_bitmaps(block_group, trimmed, start, end, minlen);
+
+	return ret;
+}
+
 /*
  * Find the left-most item in the cache tree, and then return the
  * smallest inode number in the item.
-- 
1.7.3.1
