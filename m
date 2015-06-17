Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19003 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758112AbbFQHtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:10 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lXHV015776
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs-progs: map-logical: Introduce write_extent_content function.
Date: Wed, 17 Jun 2015 15:49:03 +0800
Message-ID: <1434527344-314-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function will write extent content info desired file.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 22ece82..1ee101c 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -30,6 +30,8 @@
 #include "list.h"
 #include "utils.h"
 
+#define BUFFER_SIZE (64 * 1024)
+
 /* we write the mirror info to stdout unless they are dumping the data
  * to stdout
  * */
@@ -156,6 +158,38 @@ static int print_mapping_info(struct btrfs_fs_info *fs_info, u64 logical,
 	return ret;
 }
 
+/* Same requisition as print_mapping_info function */
+static int write_extent_content(struct btrfs_fs_info *fs_info, int out_fd,
+				u64 logical, u64 length, int mirror)
+{
+	char buffer[BUFFER_SIZE];
+	u64 cur_offset = 0;
+	u64 cur_len;
+	int ret = 0;
+
+	while (cur_offset < length) {
+		cur_len = min_t(u64, length - cur_offset, BUFFER_SIZE);
+		ret = read_extent_data(fs_info->tree_root, buffer,
+				       logical + cur_offset, &cur_len, mirror);
+		if (ret < 0) {
+			fprintf(stderr,
+				"Failed to read extent at [%llu, %llu]: %s\n",
+				logical, logical + length, strerror(-ret));
+			return ret;
+		}
+		ret = write(out_fd, buffer, cur_len);
+		if (ret < 0 || ret != cur_len) {
+			if (ret > 0)
+				ret = -EINTR;
+			fprintf(stderr, "output file write failed: %s\n",
+				strerror(-ret));
+			return ret;
+		}
+		cur_offset += cur_len;
+	}
+	return ret;
+}
+
 static struct extent_buffer * debug_read_block(struct btrfs_root *root,
 		u64 bytenr, u32 blocksize, u64 copy)
 {
-- 
2.4.3

