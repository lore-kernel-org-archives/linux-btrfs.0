Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935420AbeEJMpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DAD4AAEF5
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/17] btrfs: Remove fs_info argument from __add_to_free_space_tree
Date: Thu, 10 May 2018 15:44:43 +0300
Message-Id: <1525956296-32118-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which contains a
reference to fs_info.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c             | 14 ++++++--------
 fs/btrfs/free-space-tree.h             |  1 -
 fs/btrfs/tests/free-space-tree-tests.c | 26 +++++++++++++-------------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index a1ff604456b7..501769b941a8 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -976,10 +976,10 @@ static int add_free_space_extent(struct btrfs_trans_handle *trans,
 }
 
 int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_path *path, u64 start, u64 size)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_free_space_info *info;
 	u32 flags;
 	int ret;
@@ -1030,8 +1030,7 @@ int add_to_free_space_tree(struct btrfs_trans_handle *trans,
 	}
 
 	mutex_lock(&block_group->free_space_lock);
-	ret = __add_to_free_space_tree(trans, fs_info, block_group, path, start,
-				       size);
+	ret = __add_to_free_space_tree(trans, block_group, path, start, size);
 	mutex_unlock(&block_group->free_space_lock);
 
 	btrfs_put_block_group(block_group);
@@ -1101,7 +1100,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 				break;
 
 			if (start < key.objectid) {
-				ret = __add_to_free_space_tree(trans, fs_info,
+				ret = __add_to_free_space_tree(trans,
 							       block_group,
 							       path2, start,
 							       key.objectid -
@@ -1126,8 +1125,8 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 			break;
 	}
 	if (start < end) {
-		ret = __add_to_free_space_tree(trans, fs_info, block_group,
-					       path2, start, end - start);
+		ret = __add_to_free_space_tree(trans, block_group, path2,
+					       start, end - start);
 		if (ret)
 			goto out_locked;
 	}
@@ -1282,8 +1281,7 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	return __add_to_free_space_tree(trans, trans->fs_info, block_group,
-					path,
+	return __add_to_free_space_tree(trans, block_group, path,
 					block_group->key.objectid,
 					block_group->key.offset);
 }
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index e0abc265dc59..7555f64d6731 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -37,7 +37,6 @@ search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_block_group_cache *block_group,
 		       struct btrfs_path *path, int cow);
 int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_path *path, u64 start, u64 size);
 int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index f3dfd9fc762f..6d2b8f736020 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -274,14 +274,14 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, alignment);
+	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
@@ -312,7 +312,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
@@ -320,7 +320,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
@@ -351,14 +351,14 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, alignment);
+	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
@@ -366,7 +366,7 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + alignment,
 				       alignment);
 	if (ret) {
@@ -399,14 +399,14 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, alignment);
+	ret = __add_to_free_space_tree(trans, cache, path, cache->key.objectid,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + 4 * alignment,
 				       alignment);
 	if (ret) {
@@ -414,7 +414,7 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
+	ret = __add_to_free_space_tree(trans, cache, path,
 				       cache->key.objectid + 2 * alignment,
 				       alignment);
 	if (ret) {
-- 
2.7.4

