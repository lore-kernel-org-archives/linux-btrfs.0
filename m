Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3476 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3F0GYm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 02:24:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5R6Oa24025290
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 14:24:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs-progs: Cleanup unneeded extra variant in btrfs_read_sys_array
Date: Thu, 27 Jun 2013 14:25:18 +0800
Message-Id: <1372314318-18456-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_read_sys_array function uses 3 variants to read data from
super block.

But the three variants are related to each other, so the patch removes
unneeded extra variants and make code a little simpler.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 volumes.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/volumes.c b/volumes.c
index d6f81f8..8fb0a69 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1649,11 +1649,9 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	struct btrfs_chunk *chunk;
 	struct btrfs_key key;
 	u32 num_stripes;
-	u32 array_size;
 	u32 len = 0;
 	u8 *ptr;
-	unsigned long sb_ptr;
-	u32 cur;
+	u8 *array_end;
 	int ret = 0;
 
 	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -1662,7 +1660,8 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 		return -ENOMEM;
 	btrfs_set_buffer_uptodate(sb);
 	write_extent_buffer(sb, super_copy, 0, sizeof(*super_copy));
-	array_size = btrfs_super_sys_array_size(super_copy);
+	array_end = ((u8 *)super_copy->sys_chunk_array) +
+		    btrfs_super_sys_array_size(super_copy);
 
 	/*
 	 * we do this loop twice, once for the device items and
@@ -1670,20 +1669,16 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	 * structs filled in for every chunk
 	 */
 	ptr = super_copy->sys_chunk_array;
-	sb_ptr = offsetof(struct btrfs_super_block, sys_chunk_array);
-	cur = 0;
 
-	while (cur < array_size) {
+	while (ptr < array_end) {
 		disk_key = (struct btrfs_disk_key *)ptr;
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
 		len = sizeof(*disk_key);
 		ptr += len;
-		sb_ptr += len;
-		cur += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
-			chunk = (struct btrfs_chunk *)sb_ptr;
+			chunk = (struct btrfs_chunk *)(ptr - (u8 *)super_copy);
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
@@ -1693,8 +1688,6 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 			BUG();
 		}
 		ptr += len;
-		sb_ptr += len;
-		cur += len;
 	}
 	free_extent_buffer(sb);
 	return ret;
-- 
1.8.3.1

