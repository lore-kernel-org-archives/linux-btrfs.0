Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55698 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1756892AbcJQB2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:11 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 7732241B4BC5
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:49 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 07/14] btrfs-progs: check/scrub: Introduce function to scrub one extent
Date: Mon, 17 Oct 2016 09:27:36 +0800
Message-Id: <20161017012743.9692-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_one_extent(), as a wrapper to check one
extent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index 5cd8bc4..cdba469 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -224,3 +224,76 @@ out:
 		return -EIO;
 	return ret;
 }
+
+/*
+ * Check all copies of range @start, @len.
+ * Caller must ensure the range is covered by th EXTENT_ITEM/METADATA_ITEM
+ * specified by path.
+ * If @report is set, it will report if the range is recoverable or totally
+ * corrupted if it has corrupted mirror.
+ *
+ * Return 0 if the range is all OK or recoverable.
+ * Return <0 if the range can't be recoverable.
+ */
+static int scrub_one_extent(struct btrfs_fs_info *fs_info,
+			    struct btrfs_scrub_progress *scrub_ctx,
+			    struct btrfs_path *path, u64 start, u64 len,
+			    int report)
+{
+	struct btrfs_key key;
+	struct btrfs_extent_item *ei;
+	struct extent_buffer *leaf = path->nodes[0];
+	int slot = path->slots[0];
+	int num_copies;
+	int corrupted = 0;
+	u64 extent_start;
+	u64 extent_len;
+	int metadata = 0;
+	int i;
+	int ret;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (key.type != BTRFS_METADATA_ITEM_KEY &&
+	    key.type != BTRFS_EXTENT_ITEM_KEY)
+		goto invalid_arg;
+
+	extent_start = key.objectid;
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		extent_len = fs_info->tree_root->nodesize;
+		metadata = 1;
+	} else {
+		extent_len = key.offset;
+		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+		if (btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+			metadata = 1;
+	}
+	if (start >= extent_start + extent_len ||
+	    start + len <= extent_start)
+		goto invalid_arg;
+	num_copies = btrfs_num_copies(&fs_info->mapping_tree, start, len);
+	for (i = 1; i <= num_copies; i++) {
+		if (metadata)
+			ret = scrub_tree_mirror(fs_info, scrub_ctx,
+					NULL, extent_start, i);
+		else
+			ret = scrub_data_mirror(fs_info, scrub_ctx, NULL,
+						start, len, i);
+		if (ret < 0)
+			corrupted++;
+	}
+
+	if (report) {
+		if (corrupted && corrupted < num_copies)
+			printf("bytenr %llu len %llu has corrupted mirror, but is recoverable\n",
+				start, len);
+		else if (corrupted >= num_copies)
+			error("bytenr %llu len %llu has corrupted mirror, can't be recovered",
+				start, len);
+	}
+	if (corrupted < num_copies)
+		return 0;
+	return -EIO;
+invalid_arg:
+	error("invalid parameter for %s", __func__);
+	return -EINVAL;
+}
-- 
2.10.0



