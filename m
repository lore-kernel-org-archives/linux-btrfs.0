Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41483 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935272AbeEJMpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:01 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9234FAECB
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:00 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/17] btrfs: Remove fs_info argument from __add_block_group_free_space
Date: Thu, 10 May 2018 15:44:42 +0300
Message-Id: <1525956296-32118-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which has a reference
to the fs_info.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 0d4a719c8820..a1ff604456b7 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -12,7 +12,6 @@
 #include "transaction.h"
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
-					struct btrfs_fs_info *fs_info,
 					struct btrfs_block_group_cache *block_group,
 					struct btrfs_path *path);
 
@@ -791,8 +790,7 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (block_group->needs_free_space) {
-		ret = __add_block_group_free_space(trans, fs_info, block_group,
-						   path);
+		ret = __add_block_group_free_space(trans, block_group, path);
 		if (ret)
 			return ret;
 	}
@@ -987,8 +985,7 @@ int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (block_group->needs_free_space) {
-		ret = __add_block_group_free_space(trans, fs_info, block_group,
-						   path);
+		ret = __add_block_group_free_space(trans, block_group, path);
 		if (ret)
 			return ret;
 	}
@@ -1274,7 +1271,6 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 }
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
-					struct btrfs_fs_info *fs_info,
 					struct btrfs_block_group_cache *block_group,
 					struct btrfs_path *path)
 {
@@ -1282,11 +1278,12 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 
 	block_group->needs_free_space = 0;
 
-	ret = add_new_free_space_info(trans, fs_info, block_group, path);
+	ret = add_new_free_space_info(trans, trans->fs_info, block_group, path);
 	if (ret)
 		return ret;
 
-	return __add_to_free_space_tree(trans, fs_info, block_group, path,
+	return __add_to_free_space_tree(trans, trans->fs_info, block_group,
+					path,
 					block_group->key.objectid,
 					block_group->key.offset);
 }
@@ -1311,7 +1308,7 @@ int add_block_group_free_space(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	ret = __add_block_group_free_space(trans, fs_info, block_group, path);
+	ret = __add_block_group_free_space(trans, block_group, path);
 
 out:
 	btrfs_free_path(path);
-- 
2.7.4

