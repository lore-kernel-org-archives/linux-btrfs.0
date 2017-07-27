Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54905 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbdG0Rgr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 13:36:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6AFF7AE7C
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 17:36:44 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Simplify btrfs_alloc_dev_extent
Date: Thu, 27 Jul 2017 20:36:37 +0300
Message-Id: <1501176997-24059-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1501176997-24059-1-git-send-email-nborisov@suse.com>
References: <1501176997-24059-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_alloc_dev_extent essentially open codes btrfs_insert_item. So
let's remove the superfluous code, leaving only the important bits, namely
initialising the device extent and just calling btrfs_insert_item. So first add
definition for the stack-based set/get function. And then use them.
Additionally, remove the code which sets the uuid of the block header, since
this is something which is already handled by the core btree code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h   |  8 ++++++++
 fs/btrfs/volumes.c | 34 ++++++++++++----------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cd9497bcdb1e..567fbf186257 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1740,6 +1740,14 @@ BTRFS_SETGET_FUNCS(dev_extent_chunk_objectid, struct btrfs_dev_extent,
 BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
 		   chunk_offset, 64);
 BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_tree, struct btrfs_dev_extent,
+			 chunk_tree, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_objectid,
+			 struct btrfs_dev_extent, chunk_objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_offset, struct btrfs_dev_extent,
+			 chunk_offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_length, struct btrfs_dev_extent,
+			 length, 64);
 
 static inline unsigned long btrfs_dev_extent_chunk_tree_uuid(struct btrfs_dev_extent *dev)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5a1913956f20..94e98261dbd0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1581,42 +1581,32 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  u64 chunk_offset, u64 start, u64 num_bytes)
 {
 	int ret;
-	struct btrfs_path *path;
-	struct btrfs_fs_info *fs_info = device->fs_info;
-	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_root *root = device->fs_info->dev_root;
 	struct btrfs_dev_extent *extent;
-	struct extent_buffer *leaf;
 	struct btrfs_key key;
 
 	WARN_ON(!device->in_fs_metadata);
 	WARN_ON(device->is_tgtdev_for_dev_replace);
-	path = btrfs_alloc_path();
-	if (!path)
+
+	extent = kzalloc(sizeof(*extent), GFP_NOFS);
+	if (!extent)
 		return -ENOMEM;
 
 	key.objectid = device->devid;
 	key.offset = start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
-	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(*extent));
-	if (ret)
-		goto out;
 
-	leaf = path->nodes[0];
-	extent = btrfs_item_ptr(leaf, path->slots[0],
-				struct btrfs_dev_extent);
-	btrfs_set_dev_extent_chunk_tree(leaf, extent,
-					BTRFS_CHUNK_TREE_OBJECTID);
-	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
+	btrfs_set_stack_dev_extent_chunk_tree(extent,
+					      BTRFS_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_dev_extent_chunk_objectid(extent,
 					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
-	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
+	btrfs_set_stack_dev_extent_chunk_offset(extent, chunk_offset);
+	btrfs_set_stack_dev_extent_length(extent, num_bytes);
 
-	write_extent_buffer_chunk_tree_uuid(leaf, fs_info->chunk_tree_uuid);
+	ret = btrfs_insert_item(trans, root, &key, extent, sizeof(*extent));
+	if (ret)
+		kfree(extent);
 
-	btrfs_set_dev_extent_length(leaf, extent, num_bytes);
-	btrfs_mark_buffer_dirty(leaf);
-out:
-	btrfs_free_path(path);
 	return ret;
 }
 
-- 
2.7.4

