Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935532AbeEJMpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2A76FAEFC
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/17] btrfs: Remove fs_info parameter from add_new_free_space_info
Date: Thu, 10 May 2018 15:44:44 +0300
Message-Id: <1525956296-32118-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes trans handle from where fs_info can be
referenced. Remove the redundant parameter.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 501769b941a8..4b687e2f97aa 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -44,11 +44,10 @@ void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache)
 }
 
 static int add_new_free_space_info(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   struct btrfs_block_group_cache *block_group,
 				   struct btrfs_path *path)
 {
-	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_root *root = trans->fs_info->free_space_root;
 	struct btrfs_free_space_info *info;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
@@ -1067,7 +1066,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	ret = add_new_free_space_info(trans, fs_info, block_group, path2);
+	ret = add_new_free_space_info(trans, block_group, path2);
 	if (ret)
 		goto out;
 
@@ -1277,7 +1276,7 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 
 	block_group->needs_free_space = 0;
 
-	ret = add_new_free_space_info(trans, trans->fs_info, block_group, path);
+	ret = add_new_free_space_info(trans, block_group, path);
 	if (ret)
 		return ret;
 
-- 
2.7.4

