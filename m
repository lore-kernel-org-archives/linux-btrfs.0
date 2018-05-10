Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935101AbeEJMpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4CA50AEED
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/17] btrfs: Remove fs_info argument from add_block_group_free_space
Date: Thu, 10 May 2018 15:44:41 +0300
Message-Id: <1525956296-32118-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We also pass in a transaction handle which has a reference to the
fs_info. Just remove the extraneous argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c                 | 2 +-
 fs/btrfs/free-space-tree.c             | 2 +-
 fs/btrfs/free-space-tree.h             | 1 -
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2d359b912e1d..1d3140ce34f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10258,7 +10258,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 					       key.offset);
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
-		add_block_group_free_space(trans, fs_info, block_group);
+		add_block_group_free_space(trans, block_group);
 		/* already aborted the transaction if it failed. */
 next:
 		list_del_init(&block_group->bg_list);
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 7019afe6e727..0d4a719c8820 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1292,9 +1292,9 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 }
 
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_block_group_cache *block_group)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_path *path = NULL;
 	int ret = 0;
 
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 874b4feecad2..e0abc265dc59 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -19,7 +19,6 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info);
 int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info);
 int load_free_space_tree(struct btrfs_caching_control *caching_ctl);
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_block_group_cache *block_group);
 int remove_block_group_free_space(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index a24ead6ceb2b..f3dfd9fc762f 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -491,7 +491,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 		goto out;
 	}
 
-	ret = add_block_group_free_space(&trans, root->fs_info, cache);
+	ret = add_block_group_free_space(&trans, cache);
 	if (ret) {
 		test_msg("Could not add block group free space\n");
 		goto out;
-- 
2.7.4

