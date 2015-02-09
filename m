Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52800 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759967AbbBIMcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 07:32:55 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t19CW8Q5002961
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Feb 2015 20:32:08 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: remove unused chunk_tree argument in several functions
Date: Mon, 9 Feb 2015 20:31:44 +0800
Message-ID: <1423485104-623-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

There functions include unused chunk_tree argument from the begining,
it is time to remove them and clean up relative code to prepare value
of this argument in caller.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8a94642..270b401 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2485,8 +2485,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root,
-			    u64 chunk_tree, u64 chunk_objectid,
+			    struct btrfs_root *root, u64 chunk_objectid,
 			    u64 chunk_offset)
 {
 	int ret;
@@ -2578,7 +2577,6 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	struct map_lookup *map;
 	u64 dev_extent_len = 0;
 	u64 chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	u64 chunk_tree = root->fs_info->chunk_root->objectid;
 	int i, ret = 0;
 
 	/* Just in case */
@@ -2632,8 +2630,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 			}
 		}
 	}
-	ret = btrfs_free_chunk(trans, root, chunk_tree, chunk_objectid,
-			       chunk_offset);
+	ret = btrfs_free_chunk(trans, root, chunk_objectid, chunk_offset);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
 		goto out;
@@ -2662,8 +2659,8 @@ out:
 }
 
 static int btrfs_relocate_chunk(struct btrfs_root *root,
-			 u64 chunk_tree, u64 chunk_objectid,
-			 u64 chunk_offset)
+				u64 chunk_objectid,
+				u64 chunk_offset)
 {
 	struct btrfs_root *extent_root;
 	struct btrfs_trans_handle *trans;
@@ -2705,7 +2702,6 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 	struct btrfs_chunk *chunk;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	u64 chunk_tree = chunk_root->root_key.objectid;
 	u64 chunk_type;
 	bool retried = false;
 	int failed = 0;
@@ -2742,7 +2738,7 @@ again:
 		btrfs_release_path(path);
 
 		if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) {
-			ret = btrfs_relocate_chunk(chunk_root, chunk_tree,
+			ret = btrfs_relocate_chunk(chunk_root,
 						   found_key.objectid,
 						   found_key.offset);
 			if (ret == -ENOSPC)
@@ -3253,7 +3249,6 @@ again:
 		}
 
 		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
 					   found_key.objectid,
 					   found_key.offset);
 		if (ret && ret != -ENOSPC)
@@ -3955,7 +3950,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
 	u64 length;
-	u64 chunk_tree;
 	u64 chunk_objectid;
 	u64 chunk_offset;
 	int ret;
@@ -4025,13 +4019,11 @@ again:
 			break;
 		}
 
-		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
 		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
 		btrfs_release_path(path);
 
-		ret = btrfs_relocate_chunk(root, chunk_tree, chunk_objectid,
-					   chunk_offset);
+		ret = btrfs_relocate_chunk(root, chunk_objectid, chunk_offset);
 		if (ret && ret != -ENOSPC)
 			goto done;
 		if (ret == -ENOSPC)
-- 
1.8.5.1

