Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54901 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdG0Rgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 13:36:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 230BFAE7C
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 17:36:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: remove superfluous chunk_tree argument from btrfs_alloc_dev_extent
Date: Thu, 27 Jul 2017 20:36:36 +0300
Message-Id: <1501176997-24059-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this function is always called with the object id of the root key of
the chunk_tree, which is always BTRFS_CHUNK_TREE_OBJECTID. So let's subsume it
straight into the function itself. No functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1c0a5fff0e2f..5a1913956f20 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1578,8 +1578,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
-				  u64 chunk_tree, u64 chunk_offset, u64 start,
-				  u64 num_bytes)
+				  u64 chunk_offset, u64 start, u64 num_bytes)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1606,7 +1605,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_dev_extent);
-	btrfs_set_dev_extent_chunk_tree(leaf, extent, chunk_tree);
+	btrfs_set_dev_extent_chunk_tree(leaf, extent,
+					BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
 					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
@@ -4931,10 +4931,8 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 		ret = btrfs_update_device(trans, device);
 		if (ret)
 			break;
-		ret = btrfs_alloc_dev_extent(trans, device,
-					     chunk_root->root_key.objectid,
-					     chunk_offset, dev_offset,
-					     stripe_size);
+		ret = btrfs_alloc_dev_extent(trans, device, chunk_offset,
+					     dev_offset, stripe_size);
 		if (ret)
 			break;
 	}
-- 
2.7.4

