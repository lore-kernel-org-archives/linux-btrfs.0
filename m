Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41495 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964920AbeEJMpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A16DCACA8
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 17/17] btrfs: Remove fs_info argument from populate_free_space_tree
Date: Thu, 10 May 2018 15:44:56 +0300
Message-Id: <1525956296-32118-18-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function always takes a transaction handle which contains a
reference to the fs_info. Use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 494ff0815988..b5950aacd697 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1039,10 +1039,9 @@ int add_to_free_space_tree(struct btrfs_trans_handle *trans,
  * through the normal add/remove hooks.
  */
 static int populate_free_space_tree(struct btrfs_trans_handle *trans,
-				    struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_group_cache *block_group)
 {
-	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *extent_root = trans->fs_info->extent_root;
 	struct btrfs_path *path, *path2;
 	struct btrfs_key key;
 	u64 start, end;
@@ -1102,7 +1101,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 			}
 			start = key.objectid;
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
-				start += fs_info->nodesize;
+				start += trans->fs_info->nodesize;
 			else
 				start += key.offset;
 		} else if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
@@ -1158,7 +1157,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	while (node) {
 		block_group = rb_entry(node, struct btrfs_block_group_cache,
 				       cache_node);
-		ret = populate_free_space_tree(trans, fs_info, block_group);
+		ret = populate_free_space_tree(trans, block_group);
 		if (ret)
 			goto abort;
 		node = rb_next(node);
-- 
2.7.4

