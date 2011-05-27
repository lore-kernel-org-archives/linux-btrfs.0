From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix bitmap regression
Date: Fri, 27 May 2011 14:11:17 -0400
Message-ID: <1306519877-2244-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In cleaning up the clustering code I accidently introduced a regression by
adding bitmap entries to the cluster rb tree.  The problem is if we've maxed out
the number of bitmaps we can have for the block group we can only add free space
to the bitmaps, but since the bitmap is on the cluster we can't find it and we
try to create another one.  This would result in a panic because the total
bitmaps was bigger than the max bitmaps that were allowed.  This patch fixes
this by checking to see if we have a cluster, and then looking at the cluster rb
tree to see if it has a bitmap entry and if it does and that space belongs to
that bitmap, go ahead and add it to that bitmap.

I could hit this panic every time with an fs_mark test within a couple of
minutes.  With this patch I no longer hit the panic and fs_mark goes to
completion.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   75 +++++++++++++++++++++++++++++++++---------
 1 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a827c97..dac2546 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1365,12 +1365,28 @@ again:
 	return 0;
 }
 
+static u64 add_bytes_to_bitmap(struct btrfs_block_group_cache *block_group,
+			       struct btrfs_free_space *info, u64 offset,
+			       u64 bytes)
+{
+	u64 bytes_to_set = 0;
+	u64 end;
+
+	end = info->offset + (u64)(BITS_PER_BITMAP * block_group->sectorsize);
+
+	bytes_to_set = min(end - offset, bytes);
+
+	bitmap_set_bits(block_group, info, offset, bytes_to_set);
+
+	return bytes_to_set;
+
+}
 static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_free_space *info)
 {
 	struct btrfs_free_space *bitmap_info;
 	int added = 0;
-	u64 bytes, offset, end;
+	u64 bytes, offset, bytes_added;
 	int ret;
 
 	/*
@@ -1405,6 +1421,44 @@ static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
 	bytes = info->bytes;
 	offset = info->offset;
 
+	/*
+	 * Since we link bitmaps right into the cluster we need to see if we
+	 * have a cluster here, and if so and it has our bitmap we need to add
+	 * the free space to that bitmap.
+	 */
+	if (!list_empty(&block_group->cluster_list)) {
+		struct btrfs_free_cluster *cluster;
+		struct rb_node *node;
+		struct btrfs_free_space *entry;
+
+		cluster = list_entry(block_group->cluster_list.next,
+				     struct btrfs_free_cluster,
+				     block_group_list);
+		spin_lock(&cluster->lock);
+		node = rb_first(&cluster->root);
+		if (!node) {
+			spin_unlock(&cluster->lock);
+			goto again;
+		}
+
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		if (!entry->bitmap) {
+			spin_unlock(&cluster->lock);
+			goto again;
+		}
+
+		if (entry->offset == offset_to_bitmap(block_group, offset)) {
+			bytes_added = add_bytes_to_bitmap(block_group, entry,
+							  offset, bytes);
+			bytes -= bytes_added;
+			offset += bytes_added;
+		}
+		spin_unlock(&cluster->lock);
+		if (!bytes) {
+			ret = 1;
+			goto out;
+		}
+	}
 again:
 	bitmap_info = tree_search_offset(block_group,
 					 offset_to_bitmap(block_group, offset),
@@ -1414,21 +1468,10 @@ again:
 		goto new_bitmap;
 	}
 
-	end = bitmap_info->offset +
-		(u64)(BITS_PER_BITMAP * block_group->sectorsize);
-
-	if (offset >= bitmap_info->offset && offset + bytes > end) {
-		bitmap_set_bits(block_group, bitmap_info, offset,
-				end - offset);
-		bytes -= end - offset;
-		offset = end;
-		added = 0;
-	} else if (offset >= bitmap_info->offset && offset + bytes <= end) {
-		bitmap_set_bits(block_group, bitmap_info, offset, bytes);
-		bytes = 0;
-	} else {
-		BUG();
-	}
+	bytes_added = add_bytes_to_bitmap(block_group, bitmap_info, offset, bytes);
+	bytes -= bytes_added;
+	offset += bytes_added;
+	added = 0;
 
 	if (!bytes) {
 		ret = 1;
-- 
1.7.2.3

