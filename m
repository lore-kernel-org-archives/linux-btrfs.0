Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3F0Jiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 05:38:55 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5R9crg0010049
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 17:38:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH] btrfs: Cleanup unneeded extra variant in btrfs_read_sys_array
Date: Thu, 27 Jun 2013 17:39:35 +0800
Message-Id: <1372325975-7004-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_read_sys_array function uses 3 variants to read data from
super block.

But the three variants are related to each other, so the patch removes
unneeded extra variants and make code a little simpler.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2494008..9d7cf92 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5613,12 +5613,10 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
 	u8 *ptr;
-	unsigned long sb_ptr;
+	u8 *array_end;
 	int ret = 0;
 	u32 num_stripes;
-	u32 array_size;
 	u32 len = 0;
-	u32 cur;
 	struct btrfs_key key;
 
 	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -5643,22 +5641,19 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 		SetPageUptodate(sb->pages[0]);
 
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
-	array_size = btrfs_super_sys_array_size(super_copy);
+	array_end = ((u8 *)super_copy->sys_chunk_array) +
+		    btrfs_super_sys_array_size(super_copy);
 
 	ptr = super_copy->sys_chunk_array;
-	sb_ptr = offsetof(struct btrfs_super_block, sys_chunk_array);
-	cur = 0;
 
-	while (cur < array_size) {
+	while (ptr < array_end) {
 		disk_key = (struct btrfs_disk_key *)ptr;
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
 		len = sizeof(*disk_key); ptr += len;
-		sb_ptr += len;
-		cur += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
-			chunk = (struct btrfs_chunk *)sb_ptr;
+			chunk = (struct btrfs_chunk *)(ptr - (u8 *)super_copy);
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
@@ -5669,8 +5664,6 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 			break;
 		}
 		ptr += len;
-		sb_ptr += len;
-		cur += len;
 	}
 	free_extent_buffer(sb);
 	return ret;
-- 
1.8.3.1

