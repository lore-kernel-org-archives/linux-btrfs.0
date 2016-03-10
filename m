Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33864 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752819AbcCJJAf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 04:00:35 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id EA69F42B55E3
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 17:00:26 +0800 (CST)
From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: btrfs-debug-tree: show the compression method string
Date: Thu, 10 Mar 2016 16:40:39 +0800
Message-ID: <1457599239-5512-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 print-tree.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 53a6813..5727cb9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -286,6 +286,20 @@ static void print_uuids(struct extent_buffer *eb)
 	printf("fs uuid %s\nchunk uuid %s\n", fs_uuid, chunk_uuid);
 }
 
+static char *compress_flags_to_str(u8 flag)
+{
+	switch (flag) {
+	case BTRFS_COMPRESS_NONE:
+		return "none";
+	case BTRFS_COMPRESS_ZLIB:
+		return "zlib";
+	case BTRFS_COMPRESS_LZO:
+		return "lzo";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 static void print_file_extent_item(struct extent_buffer *eb,
 				   struct btrfs_item *item,
 				   int slot,
@@ -295,10 +309,10 @@ static void print_file_extent_item(struct extent_buffer *eb,
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		printf("\t\tinline extent data size %u "
-		       "ram %u compress %d\n",
+		       "ram %u compress(%s)\n",
 		  btrfs_file_extent_inline_item_len(eb, item),
 		  btrfs_file_extent_inline_len(eb, slot, fi),
-		  btrfs_file_extent_compression(eb, fi));
+		  compress_flags_to_str(btrfs_file_extent_compression(eb, fi)));
 		return;
 	}
 	if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -317,8 +331,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
 		(unsigned long long)btrfs_file_extent_offset(eb, fi),
 		(unsigned long long)btrfs_file_extent_num_bytes(eb, fi),
 		(unsigned long long)btrfs_file_extent_ram_bytes(eb, fi));
-	printf("\t\textent compression %d\n",
-	       btrfs_file_extent_compression(eb, fi));
+	printf("\t\textent compression(%s)\n",
+	       compress_flags_to_str(btrfs_file_extent_compression(eb, fi)));
 }
 
 /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
-- 
1.8.3.1



