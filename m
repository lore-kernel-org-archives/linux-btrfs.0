Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964919AbeEJMpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 641B9AEED
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 16/17] btrfs: Remove fs_info argument from add_to_free_space_tree
Date: Thu, 10 May 2018 15:44:55 +0300
Message-Id: <1525956296-32118-17-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function takes a transaction handle which already contains a
reference to the fs_info. So use it and remove the extra function
argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c     | 2 +-
 fs/btrfs/free-space-tree.c | 5 ++---
 fs/btrfs/free-space-tree.h | 1 -
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6a1641597d6e..bf06a81412f4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7126,7 +7126,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
-		ret = add_to_free_space_tree(trans, info, bytenr, num_bytes);
+		ret = add_to_free_space_tree(trans, bytenr, num_bytes);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 36da2c3a28f6..494ff0815988 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -999,14 +999,13 @@ int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 }
 
 int add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info,
 			   u64 start, u64 size)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_path *path;
 	int ret;
 
-	if (!btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
 		return 0;
 
 	path = btrfs_alloc_path();
@@ -1015,7 +1014,7 @@ int add_to_free_space_tree(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	block_group = btrfs_lookup_block_group(fs_info, start);
+	block_group = btrfs_lookup_block_group(trans->fs_info, start);
 	if (!block_group) {
 		ASSERT(0);
 		ret = -ENOENT;
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 95916320abec..3133651d7d70 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -23,7 +23,6 @@ int add_block_group_free_space(struct btrfs_trans_handle *trans,
 int remove_block_group_free_space(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group);
 int add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info,
 			   u64 start, u64 size);
 int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				u64 start, u64 size);
-- 
2.7.4

