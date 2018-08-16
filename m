Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403803AbeHPQJK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:10 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7432AE86
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/8] btrfs-progs: Make btrfs_write_dirty_block_groups take only trans argument
Date: Thu, 16 Aug 2018 16:10:31 +0300
Message-Id: <1534425035-323-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1534425035-323-1-git-send-email-nborisov@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root argument is used only to get a reference to the fs_info, this
can be achieved with the transaction handle being passed so use that.
This is in preparation for moving this function in the main transaction
commit routine. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.h       | 3 +--
 extent-tree.c | 5 ++---
 transaction.c | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/ctree.h b/ctree.h
index 5242595fe355..75675ef3f781 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2523,8 +2523,7 @@ int btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 			    u64 orig_parent, u64 parent,
 			    u64 root_objectid, u64 ref_generation,
 			    u64 owner_objectid);
-int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root);
+int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_root *root);
 struct btrfs_block_group_cache *
diff --git a/extent-tree.c b/extent-tree.c
index 3356dd2e4cf6..7d6c37c6b371 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1727,8 +1727,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 
 }
 
-int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root)
+int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 {
 	struct extent_io_tree *block_group_cache;
 	struct btrfs_block_group_cache *cache;
@@ -1739,7 +1738,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 	u64 end;
 	u64 ptr;
 
-	block_group_cache = &root->fs_info->block_group_cache;
+	block_group_cache = &trans->fs_info->block_group_cache;
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
diff --git a/transaction.c b/transaction.c
index ecafbb156610..96d9891b0d1c 100644
--- a/transaction.c
+++ b/transaction.c
@@ -61,7 +61,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 	u64 old_root_bytenr;
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
 
-	btrfs_write_dirty_block_groups(trans, root);
+	btrfs_write_dirty_block_groups(trans);
 	while(1) {
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
 		if (old_root_bytenr == root->node->start)
@@ -75,7 +75,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 					&root->root_key,
 					&root->root_item);
 		BUG_ON(ret);
-		btrfs_write_dirty_block_groups(trans, root);
+		btrfs_write_dirty_block_groups(trans);
 	}
 	return 0;
 }
-- 
2.7.4
