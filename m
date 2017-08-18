Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43245 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751052AbdHRO63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 10:58:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9379CAEB6
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 14:58:28 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: remove superfluous chunk_tree argument from btrfs_alloc_dev_extent
Date: Fri, 18 Aug 2017 17:58:23 +0300
Message-Id: <1503068303-27545-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1503068303-27545-1-git-send-email-nborisov@suse.com>
References: <20170818141402.GW2866@twin.jikos.cz>
 <1503068303-27545-1-git-send-email-nborisov@suse.com>
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
index 63608c5f4487..d024f1b07282 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1571,8 +1571,7 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
-				  u64 chunk_tree, u64 chunk_offset, u64 start,
-				  u64 num_bytes)
+				  u64 chunk_offset, u64 start, u64 num_bytes)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1599,7 +1598,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_dev_extent);
-	btrfs_set_dev_extent_chunk_tree(leaf, extent, chunk_tree);
+	btrfs_set_dev_extent_chunk_tree(leaf, extent,
+					BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
 					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
@@ -4903,10 +4903,8 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
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

