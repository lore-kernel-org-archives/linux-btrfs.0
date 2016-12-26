Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2344 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754943AbcLZGaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:20 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 38FEC41B4BE3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 12/19] btrfs-progs: scrub: Introduce function to scrub one extent
Date: Mon, 26 Dec 2016 14:29:32 +0800
Message-Id: <20161226062939.5841-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_one_extent(), as a wrapper to check one
extent.

It will accept a btrfs_path parameter @path, which must points to a
META/EXTENT_ITEM.
And @start, @len, which must be a subset of META/EXTENT_ITEM.

Parameter @report will determine if we output error.
Since the function will be reused by RAID56 code, we want it able to be
silent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/scrub.c b/scrub.c
index 2563f407..f4ed0b78 100644
--- a/scrub.c
+++ b/scrub.c
@@ -272,3 +272,82 @@ out:
 		return -EIO;
 	return ret;
 }
+
+/*
+ * Check all copies of range @start, @len.
+ * Caller must ensure the range is covered by EXTENT_ITEM/METADATA_ITEM
+ * specified by leaf of @path.
+ * And @start, @len must be a subset of the EXTENT_ITEM/METADATA_ITEM.
+ *
+ * If @report is set, it will report if the range is recoverable or totally
+ * corrupted if it has corrupted mirror.
+ * This parameter is used for silent verification for RAID5/6 recovery code.
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
+		if (metadata) {
+			ret = scrub_tree_mirror(fs_info, scrub_ctx,
+					NULL, extent_start, i);
+			scrub_ctx->tree_extents_scrubbed++;
+		} else {
+			ret = scrub_data_mirror(fs_info, scrub_ctx, NULL,
+						start, len, i);
+			scrub_ctx->data_extents_scrubbed++;
+		}
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
2.11.0



