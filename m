Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41495 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934693AbeEJMpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA6DDACA8
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/17] btrfs: Remove fs_info parameter from remove_block_group_free_space
Date: Thu, 10 May 2018 15:44:46 +0300
Message-Id: <1525956296-32118-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always takes a trans handle which contains a reference to
the fs_info. Use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c                 | 2 +-
 fs/btrfs/free-space-tree.c             | 5 ++---
 fs/btrfs/free-space-tree.h             | 1 -
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 02948c81ebe0..7bccd8a8bee1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10637,7 +10637,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	mutex_unlock(&fs_info->chunk_mutex);
 
-	ret = remove_block_group_free_space(trans, fs_info, block_group);
+	ret = remove_block_group_free_space(trans, block_group);
 	if (ret)
 		goto out;
 
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index ecf07fdcf2d8..4a7bef5b8de3 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1316,10 +1316,9 @@ int add_block_group_free_space(struct btrfs_trans_handle *trans,
 }
 
 int remove_block_group_free_space(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group)
 {
-	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_root *root = trans->fs_info->free_space_root;
 	struct btrfs_path *path;
 	struct btrfs_key key, found_key;
 	struct extent_buffer *leaf;
@@ -1327,7 +1326,7 @@ int remove_block_group_free_space(struct btrfs_trans_handle *trans,
 	int done = 0, nr;
 	int ret;
 
-	if (!btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
 		return 0;
 
 	if (block_group->needs_free_space) {
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 7555f64d6731..c4adfd05f34f 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -21,7 +21,6 @@ int load_free_space_tree(struct btrfs_caching_control *caching_ctl);
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
 			       struct btrfs_block_group_cache *block_group);
 int remove_block_group_free_space(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *block_group);
 int add_to_free_space_tree(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 6d2b8f736020..86955cf8c9be 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -510,7 +510,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 	if (ret)
 		goto out;
 
-	ret = remove_block_group_free_space(&trans, root->fs_info, cache);
+	ret = remove_block_group_free_space(&trans, cache);
 	if (ret) {
 		test_msg("Could not remove block group free space\n");
 		goto out;
-- 
2.7.4

