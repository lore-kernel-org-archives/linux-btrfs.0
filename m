Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbeFHMsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:03 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AED57AF9B
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 05/15] btrfs-progs: Make update_block_group take fs_info instead of root
Date: Fri,  8 Jun 2018 15:47:48 +0300
Message-Id: <1528462078-24490-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is in preparation of delayed refs code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 07b5fb99e8cf..6e7a19323efc 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1912,12 +1912,10 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static int update_block_group(struct btrfs_root *root,
-			      u64 bytenr, u64 num_bytes, int alloc,
-			      int mark_free)
+static int update_block_group(struct btrfs_fs_info *info, u64 bytenr,
+			      u64 num_bytes, int alloc, int mark_free)
 {
 	struct btrfs_block_group_cache *cache;
-	struct btrfs_fs_info *info = root->fs_info;
 	u64 total = num_bytes;
 	u64 old_val;
 	u64 byte_in_group;
@@ -2368,7 +2366,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
-		update_block_group(root, bytenr, num_bytes, 0, mark_free);
+		update_block_group(trans->fs_info, bytenr, num_bytes, 0,
+				   mark_free);
 	}
 fail:
 	btrfs_free_path(path);
@@ -2730,7 +2729,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(root, ins->objectid, fs_info->nodesize,
+	ret = update_block_group(fs_info, ins->objectid, fs_info->nodesize,
 				 1, 0);
 	return ret;
 }
@@ -3413,7 +3412,7 @@ int btrfs_update_block_group(struct btrfs_root *root,
 			     u64 bytenr, u64 num_bytes, int alloc,
 			     int mark_free)
 {
-	return update_block_group(root, bytenr, num_bytes,
+	return update_block_group(root->fs_info, bytenr, num_bytes,
 				  alloc, mark_free);
 }
 
-- 
2.7.4

