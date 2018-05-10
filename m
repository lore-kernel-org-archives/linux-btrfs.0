Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964897AbeEJMpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB1C9AECB
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 14/17] btrfs: Remove fs_info argument from __remove_from_free_space_tree
Date: Thu, 10 May 2018 15:44:53 +0300
Message-Id: <1525956296-32118-15-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function takes a transaction handle which holds a reference to
fs_info. So use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c             |  8 ++++----
 fs/btrfs/free-space-tree.h             |  1 -
 fs/btrfs/tests/free-space-tree-tests.c | 16 ++++++++--------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index f0260cfcf7eb..d9d464f0c724 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -776,7 +776,6 @@ static int remove_free_space_extent(struct btrfs_trans_handle *trans,
 }
 
 int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path, u64 start, u64 size)
 {
@@ -790,7 +789,8 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 			return ret;
 	}
 
-	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
+	info = search_free_space_info(NULL, trans->fs_info, block_group, path,
+				      0);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 	flags = btrfs_free_space_flags(path->nodes[0], info);
@@ -830,8 +830,8 @@ int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 	}
 
 	mutex_lock(&block_group->free_space_lock);
-	ret = __remove_from_free_space_tree(trans, fs_info, block_group, path,
-					    start, size);
+	ret = __remove_from_free_space_tree(trans, block_group, path, start,
+					    size);
 	mutex_unlock(&block_group->free_space_lock);
 
 	btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 7624f2a1f8e7..ca3ad610a8d0 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -39,7 +39,6 @@ int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_path *path, u64 start, u64 size);
 int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path, u64 start, u64 size);
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 176ee997319c..cb92868eec15 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -170,7 +170,7 @@ static int test_remove_all(struct btrfs_trans_handle *trans,
 	const struct free_space_extent extents[] = {};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
@@ -194,7 +194,7 @@ static int test_remove_beginning(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid, alignment);
 	if (ret) {
 		test_msg("Could not remove free space\n");
@@ -217,7 +217,7 @@ static int test_remove_end(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid +
 					    cache->key.offset - alignment,
 					    alignment);
@@ -243,7 +243,7 @@ static int test_remove_middle(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid + alignment,
 					    alignment);
 	if (ret) {
@@ -266,7 +266,7 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
@@ -304,7 +304,7 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
@@ -343,7 +343,7 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
@@ -391,7 +391,7 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 	};
 	int ret;
 
-	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
+	ret = __remove_from_free_space_tree(trans, cache, path,
 					    cache->key.objectid,
 					    cache->key.offset);
 	if (ret) {
-- 
2.7.4

