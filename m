Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964877AbeEJMpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A2B8CAECB
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/17] btrfs: Remove fs_info argument from update_free_space_extent_count
Date: Thu, 10 May 2018 15:44:49 +0300
Message-Id: <1525956296-32118-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes a transaction handle which has a reference
to the fs_info. So use that and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 3937a3baf2f5..4f36016b2476 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -449,7 +449,6 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 }
 
 static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
-					  struct btrfs_fs_info *fs_info,
 					  struct btrfs_block_group_cache *block_group,
 					  struct btrfs_path *path,
 					  int new_extents)
@@ -462,7 +461,8 @@ static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
 	if (new_extents == 0)
 		return 0;
 
-	info = search_free_space_info(trans, fs_info, block_group, path, 1);
+	info = search_free_space_info(trans, trans->fs_info, block_group, path,
+				      1);
 	if (IS_ERR(info)) {
 		ret = PTR_ERR(info);
 		goto out;
@@ -683,7 +683,7 @@ static int modify_free_space_bitmap(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_release_path(path);
-	ret = update_free_space_extent_count(trans, fs_info, block_group, path,
+	ret = update_free_space_extent_count(trans, block_group, path,
 					     new_extents);
 
 out:
@@ -770,7 +770,7 @@ static int remove_free_space_extent(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_release_path(path);
-	ret = update_free_space_extent_count(trans, fs_info, block_group, path,
+	ret = update_free_space_extent_count(trans, block_group, path,
 					     new_extents);
 
 out:
@@ -965,7 +965,7 @@ static int add_free_space_extent(struct btrfs_trans_handle *trans,
 		goto out;
 
 	btrfs_release_path(path);
-	ret = update_free_space_extent_count(trans, fs_info, block_group, path,
+	ret = update_free_space_extent_count(trans, block_group, path,
 					     new_extents);
 
 out:
-- 
2.7.4

