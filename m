Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13225 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbcGAFb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 01:31:28 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id A96804056403
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jul 2016 13:28:03 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: mkfs: fix allocation information output of block group types
Date: Fri,  1 Jul 2016 13:26:25 +0800
Message-Id: <20160701052625.7748-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cleanup_temp_chunks() removes block groups, it forgot to update
mkfs_allocation accordingly, fix this.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 mkfs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 697bdc2..e837131 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1275,6 +1275,7 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
 	int ret = 0;
+	u64 flags;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -1318,10 +1319,26 @@ static int cleanup_temp_chunks(struct btrfs_fs_info *fs_info,
 		if (is_temp_block_group(path->nodes[0], bgi,
 					data_profile, meta_profile,
 					sys_profile)) {
+			flags = btrfs_disk_block_group_flags(path->nodes[0],
+							     bgi);
 			ret = btrfs_free_block_group(trans, fs_info,
 					found_key.objectid, found_key.offset);
 			if (ret < 0)
 				goto out;
+
+			if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+			    BTRFS_BLOCK_GROUP_DATA)
+				alloc->data -= found_key.offset;
+			else if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+				 BTRFS_BLOCK_GROUP_METADATA)
+				alloc->metadata -= found_key.offset;
+			else if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+				 BTRFS_BLOCK_GROUP_SYSTEM)
+				alloc->system -= found_key.offset;
+			else if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) ==
+				 (BTRFS_BLOCK_GROUP_METADATA|
+				 BTRFS_BLOCK_GROUP_DATA))
+				alloc->mixed -= found_key.offset;
 		}
 		btrfs_release_path(path);
 		key.objectid = found_key.objectid + found_key.offset;
-- 
2.9.0



