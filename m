Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934693AbeEJMpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 165DDAEC7
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 15/17] btrfs: Remove fs_info argument from remove_from_free_space_tree
Date: Thu, 10 May 2018 15:44:54 +0300
Message-Id: <1525956296-32118-16-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function alreay takes a transaction handle which holds a reference
to the fs_info. Use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c     | 6 ++----
 fs/btrfs/free-space-tree.c | 5 ++---
 fs/btrfs/free-space-tree.h | 1 -
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7bccd8a8bee1..6a1641597d6e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8172,8 +8172,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	ret = remove_from_free_space_tree(trans, fs_info, ins->objectid,
-					  ins->offset);
+	ret = remove_from_free_space_tree(trans, ins->objectid, ins->offset);
 	if (ret)
 		return ret;
 
@@ -8255,8 +8254,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = remove_from_free_space_tree(trans, fs_info, ins->objectid,
-					  num_bytes);
+	ret = remove_from_free_space_tree(trans, ins->objectid, num_bytes);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index d9d464f0c724..36da2c3a28f6 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -806,14 +806,13 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 }
 
 int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
 				u64 start, u64 size)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_path *path;
 	int ret;
 
-	if (!btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
 		return 0;
 
 	path = btrfs_alloc_path();
@@ -822,7 +821,7 @@ int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	block_group = btrfs_lookup_block_group(fs_info, start);
+	block_group = btrfs_lookup_block_group(trans->fs_info, start);
 	if (!block_group) {
 		ASSERT(0);
 		ret = -ENOENT;
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index ca3ad610a8d0..95916320abec 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -26,7 +26,6 @@ int add_to_free_space_tree(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   u64 start, u64 size);
 int remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *fs_info,
 				u64 start, u64 size);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-- 
2.7.4

