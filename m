Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54249 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbcCKF26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 00:28:58 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id B3CDC42B4B17
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 13:28:49 +0800 (CST)
From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: btrfs-debug-tree: show the compression method string
Date: Fri, 11 Mar 2016 13:09:02 +0800
Message-ID: <1457672942-20785-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 print-tree.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 53a6813..87ec498 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -286,19 +286,40 @@ static void print_uuids(struct extent_buffer *eb)
 	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
 }
 
+static void compress_type_to_str(u8 compress_type, char *ret)
+{
+	switch (compress_type) {
+	case BTRFS_COMPRESS_NONE:
+		strcpy(ret, "none");
+		break;
+	case BTRFS_COMPRESS_ZLIB:
+		strcpy(ret, "zlib");
+		break;
+	case BTRFS_COMPRESS_LZO:
+		strcpy(ret, "lzo");
+		break;
+	default:
+		sprintf(ret, "unknown value: %d", compress_type);
+	}
+}
+
 static void print_file_extent_item(struct extent_buffer *eb,
 				   struct btrfs_item *item,
 				   int slot,
 				   struct btrfs_file_extent_item *fi)
 {
 	int extent_type = btrfs_file_extent_type(eb, fi);
+	char compress_str[BTRFS_NAME_LEN];
+
+	compress_type_to_str(btrfs_file_extent_compression(eb, fi),
+			     compress_str);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		printf("\t\tinline extent data size %u "
-		       "ram %u compress %d\n",
+		       "ram %u compress(%s)\n",
 		  btrfs_file_extent_inline_item_len(eb, item),
 		  btrfs_file_extent_inline_len(eb, slot, fi),
-		  btrfs_file_extent_compression(eb, fi));
+		  compress_str);
 		return;
 	}
 	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -317,8 +338,7 @@ static void print_file_extent_item(struct extent_buffer *eb,
 		(unsigned long long)btrfs_file_extent_offset(eb, fi),
 		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
 		(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
-	printf("\t\textent compression %d\n",
-	       btrfs_file_extent_compression(eb, fi));
+	printf("\t\textent compression(%s)\n", compress_str);
 }
 
 /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
-- 
1.8.3.1



