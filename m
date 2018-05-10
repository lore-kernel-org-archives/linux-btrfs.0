Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41501 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934935AbeEJMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0C172ACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/17] btrfs: Remove fs_info argument from convert_free_space_to_bitmaps
Date: Thu, 10 May 2018 15:44:47 +0300
Message-Id: <1525956296-32118-9-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which contains a
reference to fs_info. So use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c             | 5 ++---
 fs/btrfs/free-space-tree.h             | 1 -
 fs/btrfs/tests/free-space-tree-tests.c | 5 ++---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 4a7bef5b8de3..1dea35ac7139 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -177,10 +177,10 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 }
 
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
 	struct btrfs_free_space_info *info;
 	struct btrfs_key key, found_key;
@@ -477,8 +477,7 @@ static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
 
 	if (!(flags & BTRFS_FREE_SPACE_USING_BITMAPS) &&
 	    extent_count > block_group->bitmap_high_thresh) {
-		ret = convert_free_space_to_bitmaps(trans, fs_info, block_group,
-						    path);
+		ret = convert_free_space_to_bitmaps(trans, block_group, path);
 	} else if ((flags & BTRFS_FREE_SPACE_USING_BITMAPS) &&
 		   extent_count < block_group->bitmap_low_thresh) {
 		ret = convert_free_space_to_extents(trans, fs_info, block_group,
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index c4adfd05f34f..72ff743611ff 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -43,7 +43,6 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path, u64 start, u64 size);
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path);
 int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 86955cf8c9be..d3983ae6173a 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -137,7 +137,7 @@ static int check_free_space_extents(struct btrfs_trans_handle *trans,
 			return ret;
 		}
 	} else {
-		ret = convert_free_space_to_bitmaps(trans, fs_info, cache, path);
+		ret = convert_free_space_to_bitmaps(trans, cache, path);
 		if (ret) {
 			test_msg("Could not convert to bitmaps\n");
 			return ret;
@@ -498,8 +498,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	}
 
 	if (bitmaps) {
-		ret = convert_free_space_to_bitmaps(&trans, root->fs_info,
-						    cache, path);
+		ret = convert_free_space_to_bitmaps(&trans, cache, path);
 		if (ret) {
 			test_msg("Could not convert block group to bitmaps\n");
 			goto out;
-- 
2.7.4

