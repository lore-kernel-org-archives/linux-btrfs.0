Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965908AbcJ1Ccr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 12/19] btrfs-progs: check/scrub: Introduce function to scrub one extent
Date: Fri, 28 Oct 2016 10:31:48 +0800
Message-Id: <20161028023155.27336-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_one_extent(), as a wrapper to check one
extent.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index b4bb081..ab78a0d 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -236,3 +236,79 @@ out:
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
2.10.1



