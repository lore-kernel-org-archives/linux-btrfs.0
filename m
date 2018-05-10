Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41501 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964894AbeEJMpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 77BBCACC2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:45:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 13/17] btrfs: Remove fs_info argument from remove_free_space_extent
Date: Thu, 10 May 2018 15:44:52 +0300
Message-Id: <1525956296-32118-14-git-send-email-nborisov@suse.com>
In-Reply-To: <1525956296-32118-1-git-send-email-nborisov@suse.com>
References: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function takes a transaction handle which already has a reference
to the fs_info. Use it and remove the extra argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/free-space-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 4d6f8cbb77d7..f0260cfcf7eb 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -690,12 +690,11 @@ static int modify_free_space_bitmap(struct btrfs_trans_handle *trans,
 }
 
 static int remove_free_space_extent(struct btrfs_trans_handle *trans,
-				    struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_group_cache *block_group,
 				    struct btrfs_path *path,
 				    u64 start, u64 size)
 {
-	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_root *root = trans->fs_info->free_space_root;
 	struct btrfs_key key;
 	u64 found_start, found_end;
 	u64 end = start + size;
@@ -801,8 +800,8 @@ int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 		return modify_free_space_bitmap(trans, block_group, path,
 						start, size, 1);
 	} else {
-		return remove_free_space_extent(trans, fs_info, block_group,
-						path, start, size);
+		return remove_free_space_extent(trans, block_group, path,
+						start, size);
 	}
 }
 
-- 
2.7.4

