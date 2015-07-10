Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20209 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805AbbGJELJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 00:11:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6A49NBT016299
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 12:09:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 1/2] btrfs: csum: Introduce partial csum for tree block.
Date: Fri, 10 Jul 2015 12:09:02 +0800
Message-ID: <1436501343-2605-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436501343-2605-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436501343-2605-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the new partial csum mechanism for tree block.

[Old tree block csum]
0     4     8    12    16    20    24    28    32
-------------------------------------------------
|csum |   unused, all 0				|
-------------------------------------------------
Csum is the crc32 of the whole tree block data.

[New tree block csum]
-------------------------------------------------
|csum0|csum1|csum2|csum3|csum4|csum5|csum6|csum7|
-------------------------------------------------
Where csum0 is the same as the old one, crc32 of the whole tree block
data.

But csum1~csum7 will restore crc32 of each eighth part.
Take example of 16K leafsize, then:
csum1: crc32 of BTRFS_CSUM_SIZE~4K
csum2: crc32 of 4K~6K
...
csum7: crc32 of 14K~16K

This provides the ability for btrfs not only to detect corruption but
also to know where corruption is.
Further improve the robustness of btrfs.

Although the best practise is to introduce new csum type and put every
eighth crc32 into corresponding place, but the benefit is not worthy to
break the backward compatibility.
So keep csum0 and modify csum1 range to keep backward compatibility.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 74 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2ef9a4b..b2d8526 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -271,47 +271,75 @@ void btrfs_csum_final(u32 crc, char *result)
 }
 
 /*
- * compute the csum for a btree block, and either verify it or write it
- * into the csum field of the block.
+ * Calcuate partial crc32 for each part.
+ *
+ * Part should be in [0, 7].
+ * Part 0 is the old crc32 of the whole leaf/node.
+ * Part 1 is the crc32 of 32~ 2/8 of leaf/node.
+ * Part 2 is the crc32 of 3/8 of leaf/node.
+ * Part 3 is the crc32 of 4/8 of lean/node and so on.
  */
-static int csum_tree_block(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *buf,
-			   int verify)
+static int csum_tree_block_part(struct extent_buffer *buf,
+				char *result, int part)
 {
-	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	char *result = NULL;
+	int offset;
+	int err;
 	unsigned long len;
 	unsigned long cur_len;
-	unsigned long offset = BTRFS_CSUM_SIZE;
-	char *kaddr;
 	unsigned long map_start;
 	unsigned long map_len;
-	int err;
+	char *kaddr;
 	u32 crc = ~(u32)0;
-	unsigned long inline_result;
 
-	len = buf->len - offset;
+	BUG_ON(part >= 8 || part < 0);
+	BUG_ON(ALIGN(buf->len, 8) != buf->len);
+
+	if (part == 0) {
+		offset = BTRFS_CSUM_SIZE;
+		len = buf->len - offset;
+	} else if (part == 1) {
+		offset = BTRFS_CSUM_SIZE;
+		len = buf->len * 2 / 8 - offset;
+	} else {
+		offset = part * buf->len / 8;
+		len = buf->len / 8;
+	}
+
 	while (len > 0) {
 		err = map_private_extent_buffer(buf, offset, 32,
 					&kaddr, &map_start, &map_len);
 		if (err)
-			return 1;
+			return err;
 		cur_len = min(len, map_len - (offset - map_start));
 		crc = btrfs_csum_data(kaddr + offset - map_start,
 				      crc, cur_len);
 		len -= cur_len;
 		offset += cur_len;
 	}
-	if (csum_size > sizeof(inline_result)) {
-		result = kzalloc(csum_size, GFP_NOFS);
-		if (!result)
+	btrfs_csum_final(crc, result + BTRFS_CSUM_SIZE * part / 8);
+	return 0;
+}
+
+/*
+ * compute the csum for a btree block, and either verify it or write it
+ * into the csum field of the block.
+ */
+static int csum_tree_block(struct btrfs_fs_info *fs_info,
+			   struct extent_buffer *buf,
+			   int verify)
+{
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
+	char result[BTRFS_CSUM_SIZE] = {0};
+	int err;
+	int index = 0;
+
+	/* get every part csum */
+	for (index = 0; index < 8; index++) {
+		err = csum_tree_block_part(buf, result, index);
+		if (err)
 			return 1;
-	} else {
-		result = (char *)&inline_result;
 	}
 
-	btrfs_csum_final(crc, result);
-
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
 			u32 val;
@@ -324,15 +352,11 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 				"level %d\n",
 				fs_info->sb->s_id, buf->start,
 				val, found, btrfs_header_level(buf));
-			if (result != (char *)&inline_result)
-				kfree(result);
 			return 1;
 		}
 	} else {
-		write_extent_buffer(buf, result, 0, csum_size);
+		write_extent_buffer(buf, result, 0, BTRFS_CSUM_SIZE);
 	}
-	if (result != (char *)&inline_result)
-		kfree(result);
 	return 0;
 }
 
-- 
2.4.5

