Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43876 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeACHNX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:23 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/5] btrfs-progs: volumes: Remove unnecessary parameters when allocating device extent
Date: Wed,  3 Jan 2018 15:13:05 +0800
Message-Id: <20180103071306.11500-5-wqu@suse.com>
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
References: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@chunk_tree and @chunk_objectid of device extent is fixed to
BTRFS_CHUNK_TREE_OBJECTID and BTRFS_FIRST_CHUNK_TREE_OBJECTID
respectively.

There is no need to pass them as parameter explicitly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/volumes.c b/volumes.c
index f6c6447fe925..fa3c6de023f9 100644
--- a/volumes.c
+++ b/volumes.c
@@ -466,9 +466,8 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_device *device,
-				  u64 chunk_tree, u64 chunk_objectid,
-				  u64 chunk_offset,
-				  u64 num_bytes, u64 *start, int convert)
+				  u64 chunk_offset, u64 num_bytes, u64 *start,
+				  int convert)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -501,8 +500,9 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
 				struct btrfs_dev_extent);
-	btrfs_set_dev_extent_chunk_tree(leaf, extent, chunk_tree);
-	btrfs_set_dev_extent_chunk_objectid(leaf, extent, chunk_objectid);
+	btrfs_set_dev_extent_chunk_tree(leaf, extent, BTRFS_CHUNK_TREE_OBJECTID);
+	btrfs_set_dev_extent_chunk_objectid(leaf, extent,
+					    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
 
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
@@ -1039,9 +1039,7 @@ again:
 		    (index == num_stripes - 1))
 			list_move_tail(&device->dev_list, dev_list);
 
-		ret = btrfs_alloc_dev_extent(trans, device,
-			     info->chunk_root->root_key.objectid,
-			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
+		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
 			     calc_size, &dev_offset, 0);
 		if (ret < 0)
 			goto out_chunk_map;
@@ -1176,9 +1174,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	while (index < num_stripes) {
 		struct btrfs_stripe *stripe;
 
-		ret = btrfs_alloc_dev_extent(trans, device,
-			     info->chunk_root->root_key.objectid,
-			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
+		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
 			     calc_size, &dev_offset, convert);
 		BUG_ON(ret);
 
-- 
2.15.1

