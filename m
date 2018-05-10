Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964878AbeEJMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:03 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5BA19AEC7
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/17] btrfs: Remove fs_info parameter from convert_free_space_to_extents
Date: Thu, 10 May 2018 15:44:48 +0300
Message-Id: <1525956296-32118-10-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always takes a transaction handle which contains a
reference to fs_info. So use that and kill the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c             | 5 ++---
 fs/btrfs/free-space-tree.h             | 1 -
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 1dea35ac7139..3937a3baf2f5 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -316,10 +316,10 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 }
 
 int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
 	struct btrfs_free_space_info *info;
 	struct btrfs_key key, found_key;
@@ -480,8 +480,7 @@ static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
 		ret = convert_free_space_to_bitmaps(trans, block_group, path);
 	} else if ((flags & BTRFS_FREE_SPACE_USING_BITMAPS) &&
 		   extent_count < block_group->bitmap_low_thresh) {
-		ret = convert_free_space_to_extents(trans, fs_info, block_group,
-						    path);
+		ret = convert_free_space_to_extents(trans, block_group, path);
 	}
 
 out:
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 72ff743611ff..7624f2a1f8e7 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -46,7 +46,6 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path);
 int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path);
 int free_space_test_bit(struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index d3983ae6173a..176ee997319c 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -131,7 +131,7 @@ static int check_free_space_extents(struct btrfs_trans_handle *trans,
 
 	/* Flip it to the other format and check that for good measure. */
 	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
-		ret = convert_free_space_to_extents(trans, fs_info, cache, path);
+		ret = convert_free_space_to_extents(trans, cache, path);
 		if (ret) {
 			test_msg("Could not convert to extents\n");
 			return ret;
-- 
2.7.4

