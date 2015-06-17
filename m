Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43300 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758110AbbFQHtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:10 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lWi6015773
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs-progs: map-logical: Introduce print_mapping_info function.
Date: Wed, 17 Jun 2015 15:49:02 +0800
Message-ID: <1434527344-314-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new function will print the mapping info of given range
[logical, logical+len).

Note, caller must ensure the range are completely inside an extent.
Or btrfs_map_block can return -ENOENT.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 8442779..22ece82 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -93,6 +93,69 @@ out:
 	return ret;
 }
 
+static int __print_mapping_info(struct btrfs_fs_info *fs_info, u64 logical,
+				u64 len, int mirror_num)
+{
+	struct btrfs_multi_bio *multi = NULL;
+	u64 cur_offset = 0;
+	u64 cur_len;
+	int ret = 0;
+
+	while (cur_offset < len) {
+		struct btrfs_device *device;
+		int i;
+
+		cur_len = len - cur_offset;
+		ret = btrfs_map_block(&fs_info->mapping_tree, READ,
+				logical + cur_offset, &cur_len,
+				&multi, mirror_num, NULL);
+		if (ret) {
+			fprintf(info_file,
+				"Error: fails to map mirror%d logical %llu: %s\n",
+				mirror_num, logical, strerror(-ret));
+			return ret;
+		}
+		for (i = 0; i < multi->num_stripes; i++) {
+			device = multi->stripes[i].dev;
+			fprintf(info_file,
+				"mirror %d logical %Lu physical %Lu device %s\n",
+				mirror_num, logical + cur_offset,
+				multi->stripes[0].physical,
+				device->name);
+		}
+		kfree(multi);
+		multi = NULL;
+		cur_offset += cur_len;
+	}
+	return ret;
+}
+
+/*
+ * Logical and len is the exact value of a extent.
+ * And offset is the offset inside the extent. It's only used for case
+ * where user only want to print part of the extent.
+ *
+ * Caller *MUST* ensure the range [logical,logical+len) are in one extent.
+ * Or we can encounter the following case, causing a -ENOENT error:
+ * |<-----given parameter------>|
+ *		|<------ Extent A ----->|
+ */
+static int print_mapping_info(struct btrfs_fs_info *fs_info, u64 logical,
+			      u64 len)
+{
+	int num_copies;
+	int mirror_num;
+	int ret = 0;
+
+	num_copies = btrfs_num_copies(&fs_info->mapping_tree, logical, len);
+	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
+		ret = __print_mapping_info(fs_info, logical, len, mirror_num);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
 static struct extent_buffer * debug_read_block(struct btrfs_root *root,
 		u64 bytenr, u32 blocksize, u64 copy)
 {
-- 
2.4.3

