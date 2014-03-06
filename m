Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaCFF4A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:56:00 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265tv8W010090
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:55:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs-progs: fsck: deal with really corrupted extent tree
Date: Thu, 6 Mar 2014 13:53:56 +0800
Message-Id: <1394085240-23520-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To reinit extent root, we need find a free extent, however,
we may have a really corrupted extent tree, so we can't rely
on existed extent tree to cache block group any more.

During test, we fail to reinit extent tree which is because we
can not find a free extent so let's make block group cache ourselves
firstly.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 98199ce..3cf59b6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6030,11 +6030,13 @@ static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
 
 static int reset_block_groups(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_block_group_cache *cache;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_chunk *chunk;
 	struct btrfs_key key;
 	int ret;
+	u64 start;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -6085,8 +6087,19 @@ static int reset_block_groups(struct btrfs_fs_info *fs_info)
 				      btrfs_chunk_type(leaf, chunk),
 				      key.objectid, key.offset,
 				      btrfs_chunk_length(leaf, chunk));
+		set_extent_dirty(&fs_info->free_space_cache, key.offset,
+				 key.offset + btrfs_chunk_length(leaf, chunk),
+				 GFP_NOFS);
 		path->slots[0]++;
 	}
+	start = 0;
+	while (1) {
+		cache = btrfs_lookup_first_block_group(fs_info, start);
+		if (!cache)
+			break;
+		cache->cached = 1;
+		start = cache->key.objectid + cache->key.offset;
+	}
 
 	btrfs_free_path(path);
 	return 0;
-- 
1.9.0

