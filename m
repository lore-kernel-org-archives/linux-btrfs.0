From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/6] btrfs: add a helper try_merge_free_space()
Date: Mon, 23 Aug 2010 09:23:44 +0800
Message-ID: <4C71CDA0.5010107@cn.fujitsu.com>
References: <4C71CD4B.10606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C71CD4B.10606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

When adding a new extent, we'll firstly see if we can merge
this extent to the left or/and right extent. Extract this as
a helper try_merge_free_space().

As a side effect, we fix a small bug that if the new extent
has non-bitmap left entry but is unmergeble, we'll directly
link the extent without trying to drop it into bitmap.

This also prepares for the next patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   75 ++++++++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 20f3141..faeec8f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -610,22 +610,14 @@ out:
 	return ret;
 }
 
-int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
-			 u64 offset, u64 bytes)
+bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
+			  struct btrfs_free_space *info)
 {
-	struct btrfs_free_space *right_info = NULL;
-	struct btrfs_free_space *left_info = NULL;
-	struct btrfs_free_space *info = NULL;
-	int ret = 0;
-
-	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
-	if (!info)
-		return -ENOMEM;
-
-	info->offset = offset;
-	info->bytes = bytes;
-
-	spin_lock(&block_group->tree_lock);
+	struct btrfs_free_space *left_info;
+	struct btrfs_free_space *right_info;
+	bool merged = false;
+	u64 offset = info->offset;
+	u64 bytes = info->bytes;
 
 	/*
 	 * first we want to see if there is free space adjacent to the range we
@@ -639,27 +631,11 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 	else
 		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
 
-	/*
-	 * If there was no extent directly to the left or right of this new
-	 * extent then we know we're going to have to allocate a new extent, so
-	 * before we do that see if we need to drop this into a bitmap
-	 */
-	if ((!left_info || left_info->bitmap) &&
-	    (!right_info || right_info->bitmap)) {
-		ret = insert_into_bitmap(block_group, info);
-
-		if (ret < 0) {
-			goto out;
-		} else if (ret) {
-			ret = 0;
-			goto out;
-		}
-	}
-
 	if (right_info && !right_info->bitmap) {
 		unlink_free_space(block_group, right_info);
 		info->bytes += right_info->bytes;
 		kfree(right_info);
+		merged = true;
 	}
 
 	if (left_info && !left_info->bitmap &&
@@ -668,8 +644,43 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
 		info->offset = left_info->offset;
 		info->bytes += left_info->bytes;
 		kfree(left_info);
+		merged = true;
 	}
 
+	return merged;
+}
+
+int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
+			 u64 offset, u64 bytes)
+{
+	struct btrfs_free_space *info;
+	int ret = 0;
+
+	info = kzalloc(sizeof(struct btrfs_free_space), GFP_NOFS);
+	if (!info)
+		return -ENOMEM;
+
+	info->offset = offset;
+	info->bytes = bytes;
+
+	spin_lock(&block_group->tree_lock);
+
+	if (try_merge_free_space(block_group, info))
+		goto link;
+
+	/*
+	 * There was no extent directly to the left or right of this new
+	 * extent then we know we're going to have to allocate a new extent, so
+	 * before we do that see if we need to drop this into a bitmap
+	 */
+	ret = insert_into_bitmap(block_group, info);
+	if (ret < 0) {
+		goto out;
+	} else if (ret) {
+		ret = 0;
+		goto out;
+	}
+link:
 	ret = link_free_space(block_group, info);
 	if (ret)
 		kfree(info);
-- 
1.7.0.1

