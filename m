From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cache bitmaps when searching for a cluster
Date: Wed, 25 May 2011 13:08:44 -0400
Message-ID: <1306343324-25946-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we are looking for a cluster in a particularly sparse or fragmented block
group, we will do a lot of looping through the free space tree looking for
various things, and if we need to look at bitmaps we will endup doing the whole
dance twice.  So instead add the bitmap entries to a temporary list so if we
have to do the bitmap search we can just look through the list of entries we've
found quickly instead of having to loop through the entire tree again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   54 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d634a7e..0bfea7b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2062,6 +2062,7 @@ again:
  */
 static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 				   struct btrfs_free_cluster *cluster,
+				   struct list_head *bitmaps,
 				   u64 offset, u64 bytes, u64 min_bytes)
 {
 	struct btrfs_free_space *first = NULL;
@@ -2083,6 +2084,8 @@ static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	 * extent entry.
 	 */
 	while (entry->bitmap) {
+		if (list_empty(&entry->list))
+			list_add_tail(&entry->list, bitmaps);
 		node = rb_next(&entry->offset_index);
 		if (!node)
 			return -ENOSPC;
@@ -2102,8 +2105,12 @@ static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			return -ENOSPC;
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
-		if (entry->bitmap)
+		if (entry->bitmap) {
+			if (list_empty(&entry->list))
+				list_add_tail(&entry->list, bitmaps);
 			continue;
+		}
+
 		/*
 		 * we haven't filled the empty size and the window is
 		 * very large.  reset and try again
@@ -2157,6 +2164,7 @@ static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
  */
 static int setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 				struct btrfs_free_cluster *cluster,
+				struct list_head *bitmaps,
 				u64 offset, u64 bytes, u64 min_bytes)
 {
 	struct btrfs_free_space *entry;
@@ -2166,12 +2174,41 @@ static int setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	if (block_group->total_bitmaps == 0)
 		return -ENOSPC;
 
+	/*
+	 * First check our cached list of bitmaps and see if there is an entry
+	 * here that will work.
+	 */
+	list_for_each_entry(entry, bitmaps, list) {
+		if (entry->bytes < min_bytes)
+			continue;
+		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
+					   bytes, min_bytes);
+		if (!ret)
+			return 0;
+	}
+
+	/*
+	 * If we do have entries on our list and we are here then we didn't find
+	 * anything, so go ahead and get the next entry after the last entry in
+	 * this list and start the search from there.
+	 */
+	if (!list_empty(bitmaps)) {
+		entry = list_entry(bitmaps->prev, struct btrfs_free_space,
+				   list);
+		node = rb_next(&entry->offset_index);
+		if (!node)
+			return -ENOSPC;
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		goto search;
+	}
+
 	entry = tree_search_offset(block_group,
 				   offset_to_bitmap(block_group, offset),
 				   0, 1);
 	if (!entry)
 		return -ENOSPC;
 
+search:
 	node = &entry->offset_index;
 	do {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
@@ -2201,6 +2238,8 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     struct btrfs_free_cluster *cluster,
 			     u64 offset, u64 bytes, u64 empty_size)
 {
+	struct list_head bitmaps;
+	struct btrfs_free_space *entry, *tmp;
 	u64 min_bytes;
 	int ret;
 
@@ -2239,11 +2278,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	ret = setup_cluster_no_bitmap(block_group, cluster, offset, bytes,
-				      min_bytes);
+	INIT_LIST_HEAD(&bitmaps);
+	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
+				      bytes, min_bytes);
 	if (ret)
-		ret = setup_cluster_bitmap(block_group, cluster, offset,
-					   bytes, min_bytes);
+		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
+					   offset, bytes, min_bytes);
+
+	/* Clear our temporary list */
+	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
+		list_del_init(&entry->list);
 
 	if (!ret) {
 		atomic_inc(&block_group->count);
-- 
1.7.2.3

