From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 06/12] btrfs: Check mergeable free space when removing a cluster
Date: Thu, 27 Jan 2011 16:44:20 +0800
Message-ID: <4D413064.5070106@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

After returing extents from a cluster to the block group, some
extents in the block group may be mergeable.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cf67dc3..a5501ed 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -987,11 +987,18 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
 	return entry;
 }
 
-static void unlink_free_space(struct btrfs_block_group_cache *block_group,
-			      struct btrfs_free_space *info)
+static inline void
+__unlink_free_space(struct btrfs_block_group_cache *block_group,
+		    struct btrfs_free_space *info)
 {
 	rb_erase(&info->offset_index, &block_group->free_space_offset);
 	block_group->free_extents--;
+}
+
+static void unlink_free_space(struct btrfs_block_group_cache *block_group,
+			      struct btrfs_free_space *info)
+{
+	__unlink_free_space(block_group, info);
 	block_group->free_space -= info->bytes;
 }
 
@@ -1364,7 +1371,7 @@ out:
 }
 
 bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
-			  struct btrfs_free_space *info)
+			  struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *left_info;
 	struct btrfs_free_space *right_info;
@@ -1385,7 +1392,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
 
 	if (right_info && !right_info->bitmap) {
-		unlink_free_space(block_group, right_info);
+		if (update_stat)
+			unlink_free_space(block_group, right_info);
+		else
+			__unlink_free_space(block_group, right_info);
 		info->bytes += right_info->bytes;
 		kfree(right_info);
 		merged = true;
@@ -1393,7 +1403,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
 
 	if (left_info && !left_info->bitmap &&
 	    left_info->offset + left_info->bytes == offset) {
-		unlink_free_space(block_group, left_info);
+		if (update_stat)
+			unlink_free_space(block_group, left_info);
+		else
+			__unlink_free_space(block_group, left_info);
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
 		kfree(left_info);
@@ -1418,7 +1431,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 
 	spin_lock(&block_group->tree_lock);
 
-	if (try_merge_free_space(block_group, info))
+	if (try_merge_free_space(block_group, info, true))
 		goto link;
 
 	/*
@@ -1636,6 +1649,7 @@ __btrfs_return_cluster_to_free_space(
 		node = rb_next(&entry->offset_index);
 		rb_erase(&entry->offset_index, &cluster->root);
 		BUG_ON(entry->bitmap);
+		try_merge_free_space(block_group, entry, false);
 		tree_insert_offset(&block_group->free_space_offset,
 				   entry->offset, &entry->offset_index, 0);
 	}
-- 
1.6.3
