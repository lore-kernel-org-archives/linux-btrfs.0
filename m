Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43241 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750971AbdHRO63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 10:58:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9D78AEB2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 14:58:27 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
Date: Fri, 18 Aug 2017 17:58:22 +0300
Message-Id: <1503068303-27545-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20170818141402.GW2866@twin.jikos.cz>
References: <20170818141402.GW2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

THe function is always called with chunk_objectid set to
BTRFS_FIRST_CHUNK_TREE_OBJECTID. Let's collapse the parameter in the function
itself. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a37a31ba6843..63608c5f4487 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1571,8 +1571,8 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
-				  u64 chunk_tree, u64 chunk_objectid,
-				  u64 chunk_offset, u64 start, u64 num_bytes)
+				  u64 chunk_tree, u64 chunk_offset, u64 start,
+				  u64 num_bytes)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -1600,7 +1600,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	extent = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_dev_extent);
 	btrfs_set_dev_extent_chunk_tree(leaf, extent, chunk_tree);
-	btrfs_set_dev_extent_chunk_objectid(leaf, extent, chunk_objectid);
+	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
+					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
 
 	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
@@ -4904,7 +4905,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 			break;
 		ret = btrfs_alloc_dev_extent(trans, device,
 					     chunk_root->root_key.objectid,
-					     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
 					     chunk_offset, dev_offset,
 					     stripe_size);
 		if (ret)
-- 
2.7.4

