Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41313 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3GHNWD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 09:22:03 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so3687174wgh.15
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jul 2013 06:22:01 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2 5/5] Btrfs-progs: don't ignore errors in extent-tree.c
Date: Mon,  8 Jul 2013 14:21:24 +0100
Message-Id: <1373289684-9441-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several function return values were being completely
ignored.

V2: Added more error checking all over extent-tree.c

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 6490d8a..6458ce4 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2110,6 +2110,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						extent_op->flags,
 						&extent_op->key,
 						extent_op->level, &key);
+			BUG_ON(ret);
 		} else {
 			BUG_ON(1);
 		}
@@ -2756,7 +2757,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = update_block_group(trans, root, ins->objectid, root->leafsize,
 				 1, 0);
-	return 0;
+	return ret;
 }
 
 static int alloc_tree_block(struct btrfs_trans_handle *trans,
@@ -3345,12 +3346,14 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	BUG_ON(ret);
 
 	bit = block_group_state_bits(type);
-	set_extent_bits(block_group_cache, chunk_offset,
-			chunk_offset + size - 1,
-			bit | EXTENT_LOCKED, GFP_NOFS);
+	ret = set_extent_bits(block_group_cache, chunk_offset,
+			      chunk_offset + size - 1,
+			      bit | EXTENT_LOCKED, GFP_NOFS);
+	BUG_ON(ret);
 
-	set_state_private(block_group_cache, chunk_offset,
-			  (unsigned long)cache);
+	ret = set_state_private(block_group_cache, chunk_offset,
+				(unsigned long)cache);
+	BUG_ON(ret);
 	set_avail_alloc_bits(fs_info, type);
 
 	return cache;
@@ -3372,8 +3375,11 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 				sizeof(cache->item));
 	BUG_ON(ret);
 
-	finish_current_insert(trans, extent_root);
+	ret = finish_current_insert(trans, extent_root);
+	BUG_ON(ret);
 	ret = del_pending_extents(trans, extent_root);
+	BUG_ON(ret);
+
 	return 0;
 }
 
-- 
1.7.9.5

