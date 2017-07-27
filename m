Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42675 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbdG0Lhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 07:37:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99630AD95
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 11:37:32 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove extraneous chunk_objectid variable
Date: Thu, 27 Jul 2017 14:37:29 +0300
Message-Id: <1501155449-8420-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_FIRST_CHUNK_TREE_OBJECTIS id the only objectid being used in the
chunk_tree. So remove a variable which is always set to that value and collapse
its usage in callees which are passed this variable. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 46fe5f2bb5e8..e1ccec14688b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2727,8 +2727,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 }
 
 static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 chunk_objectid,
-			    u64 chunk_offset)
+			    struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	int ret;
@@ -2739,7 +2738,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = chunk_objectid;
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = chunk_offset;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 
@@ -2762,8 +2761,7 @@ static int btrfs_free_chunk(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
-			       u64 chunk_objectid, u64 chunk_offset)
+static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 {
 	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	struct btrfs_disk_key *disk_key;
@@ -2796,7 +2794,7 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
 			ret = -EIO;
 			break;
 		}
-		if (key.objectid == chunk_objectid &&
+		if (key.objectid == BTRFS_FIRST_CHUNK_TREE_OBJECTID &&
 		    key.offset == chunk_offset) {
 			memmove(ptr, ptr + len, array_size - (cur + len));
 			array_size -= len;
@@ -2845,7 +2843,6 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	struct extent_map *em;
 	struct map_lookup *map;
 	u64 dev_extent_len = 0;
-	u64 chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
@@ -2901,7 +2898,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	ret = btrfs_free_chunk(trans, fs_info, chunk_objectid, chunk_offset);
+	ret = btrfs_free_chunk(trans, fs_info, chunk_offset);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -2910,8 +2907,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	trace_btrfs_chunk_free(fs_info, map, chunk_offset, em->len);
 
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_del_sys_chunk(fs_info, chunk_objectid,
-					  chunk_offset);
+		ret = btrfs_del_sys_chunk(fs_info, chunk_offset);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
-- 
2.7.4

