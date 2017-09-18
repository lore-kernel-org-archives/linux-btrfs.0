Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63538 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdIRHVs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:48 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 01/14] btrfs-progs: Refactor find_next_chunk() to get rid of parameter root and objectid
Date: Mon, 18 Sep 2017 16:21:26 +0900
Message-Id: <20170918072139.6300-2-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function find_next_chunk() is used to find next chunk start position,
which should only do search on chunk tree and objectid is fixed to
BTRFS_FIRST_CHUNK_TREE_OBJECTID.

So refactor the parameter list to get rid of @root, which should be get
from fs_info->chunk_root, and @objectid, which is fixed to
BTRFS_FIRST_CHUNK_TREE_OBJECTID.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 volumes.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/volumes.c b/volumes.c
index 2ae2d1bb..2209e5a9 100644
--- a/volumes.c
+++ b/volumes.c
@@ -505,8 +505,9 @@ err:
 	return ret;
 }
 
-static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
+static int find_next_chunk(struct btrfs_fs_info *fs_info, u64 *offset)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path *path;
 	int ret;
 	struct btrfs_key key;
@@ -517,7 +518,7 @@ static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = objectid;
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
@@ -533,7 +534,7 @@ static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
 	} else {
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 				      path->slots[0]);
-		if (found_key.objectid != objectid)
+		if (found_key.objectid != BTRFS_FIRST_CHUNK_TREE_OBJECTID)
 			*offset = 0;
 		else {
 			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
@@ -995,8 +996,7 @@ again:
 		}
 		return -ENOSPC;
 	}
-	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-			      &offset);
+	ret = find_next_chunk(info, &offset);
 	if (ret)
 		return ret;
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
@@ -1129,9 +1129,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	} else {
 		u64 tmp;
 
-		ret = find_next_chunk(chunk_root,
-				      BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				      &tmp);
+		ret = find_next_chunk(info, &tmp);
 		key.offset = tmp;
 		if (ret)
 			return ret;
-- 
2.14.1

