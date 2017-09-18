Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51098 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751700AbdIRHVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:53 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 05/14] btrfs-progs: Avoid BUG_ON for chunk allocation when ENOSPC happens
Date: Mon, 18 Sep 2017 16:21:30 +0900
Message-Id: <20170918072139.6300-6-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When passing directory larger than block device using --rootdir
parameter, we get the following backtrace:

------
extent-tree.c:2693: btrfs_reserve_extent: BUG_ON `ret` triggered, value -28
./mkfs.btrfs(+0x1a05d)[0x557939e6b05d]
./mkfs.btrfs(btrfs_reserve_extent+0xb5a)[0x557939e710c8]
./mkfs.btrfs(+0xb0b6)[0x557939e5c0b6]
./mkfs.btrfs(main+0x15d5)[0x557939e5de04]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f83b101af6a]
./mkfs.btrfs(_start+0x2a)[0x557939e5af5a]
------

Nothing special, just BUG_ON() abusing from ancient code.

Fix them by using correct return.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 extent-tree.c |  3 ++-
 volumes.c     | 18 ++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 525a237e..055582c3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2690,7 +2690,8 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			       search_start, search_end, hint_byte, ins,
 			       trans->alloc_exclude_start,
 			       trans->alloc_exclude_nr, data);
-	BUG_ON(ret);
+	if (ret < 0)
+		return ret;
 	clear_extent_dirty(&info->free_space_cache,
 			   ins->objectid, ins->objectid + ins->offset - 1);
 	return ret;
diff --git a/volumes.c b/volumes.c
index 2209e5a9..e1ee27d5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1032,11 +1032,13 @@ again:
 			     info->chunk_root->root_key.objectid,
 			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
 			     calc_size, &dev_offset, 0);
-		BUG_ON(ret);
+		if (ret < 0)
+			goto out_chunk_map;
 
 		device->bytes_used += calc_size;
 		ret = btrfs_update_device(trans, device);
-		BUG_ON(ret);
+		if (ret < 0)
+			goto out_chunk_map;
 
 		map->stripes[index].dev = device;
 		map->stripes[index].physical = dev_offset;
@@ -1075,16 +1077,24 @@ again:
 	map->ce.size = *num_bytes;
 
 	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
-	BUG_ON(ret);
+	if (ret < 0)
+		goto out_chunk_map;
 
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		ret = btrfs_add_system_chunk(info, &key,
 				    chunk, btrfs_chunk_item_size(num_stripes));
-		BUG_ON(ret);
+		if (ret < 0)
+			goto out_chunk;
 	}
 
 	kfree(chunk);
 	return ret;
+
+out_chunk_map:
+	kfree(map);
+out_chunk:
+	kfree(chunk);
+	return ret;
 }
 
 /*
-- 
2.14.1

