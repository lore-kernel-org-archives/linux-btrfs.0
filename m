Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14657 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751047AbeAELRY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:24 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 07/16] btrfs-progs: scrub: Introduce function to scrub one mirror-based extent
Date: Fri, 5 Jan 2018 19:01:15 +0800
Message-ID: <1515150084-17231-8-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a new function, scrub_one_extent(), as a wrapper to check one
mirror-based extent.

It will accept a btrfs_path parameter @path, which must point to a
META/EXTENT_ITEM.
And @start, @len, which must be a subset of META/EXTENT_ITEM.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 scrub.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 147 insertions(+), 1 deletion(-)

diff --git a/scrub.c b/scrub.c
index cee6fe14..b0a98b98 100644
--- a/scrub.c
+++ b/scrub.c
@@ -434,7 +434,7 @@ static int recover_data_mirror(struct btrfs_fs_info *fs_info,
 
 	num_copies = btrfs_num_copies(fs_info, start, len);
 	for (i = 0; i < num_copies; i++) {
-		for_each_set_bit(bit, corrupt_bitmaps[i], BITS_PER_LONG) {
+		for_each_set_bit(bit, corrupt_bitmaps[i], len / sectorsize) {
 			u64 cur = start + bit * sectorsize;
 			int good;
 
@@ -474,3 +474,149 @@ out:
 	free(buf);
 	return ret;
 }
+
+/* Btrfs only supports up to 2 copies of data, yet */
+#define BTRFS_MAX_COPIES	2
+
+/*
+ * Check all copies of range @start, @len.
+ * Caller must ensure the range is covered by EXTENT_ITEM/METADATA_ITEM
+ * specified by leaf of @path.
+ * And @start, @len must be a subset of the EXTENT_ITEM/METADATA_ITEM.
+ *
+ * Return 0 if the range is all OK or recovered or recoverable.
+ * Return <0 if the range can't be recoverable.
+ */
+static int scrub_one_extent(struct btrfs_fs_info *fs_info,
+			    struct btrfs_scrub_progress *scrub_ctx,
+			    struct btrfs_path *path, u64 start, u64 len,
+			    int write)
+{
+	struct btrfs_key key;
+	struct btrfs_extent_item *ei;
+	struct extent_buffer *leaf = path->nodes[0];
+	u32 sectorsize = fs_info->sectorsize;
+	unsigned long *corrupt_bitmaps[BTRFS_MAX_COPIES] = { NULL };
+	int slot = path->slots[0];
+	int num_copies;
+	int meta_corrupted = 0;
+	int meta_good_mirror = 0;
+	int data_bad_mirror = 0;
+	u64 extent_start;
+	u64 extent_len;
+	int metadata = 0;
+	int i;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (key.type != BTRFS_METADATA_ITEM_KEY &&
+	    key.type != BTRFS_EXTENT_ITEM_KEY)
+		goto invalid_arg;
+
+	extent_start = key.objectid;
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		extent_len = fs_info->nodesize;
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
+
+	for (i = 0; i < BTRFS_MAX_COPIES; i++) {
+		corrupt_bitmaps[i] = malloc(
+				calculate_bitmap_len(len / sectorsize));
+		if (!corrupt_bitmaps[i])
+			goto out;
+	}
+	num_copies = btrfs_num_copies(fs_info, start, len);
+	for (i = 1; i <= num_copies; i++) {
+		if (metadata) {
+			ret = check_tree_mirror(fs_info, scrub_ctx,
+					NULL, extent_start, i);
+			scrub_ctx->tree_extents_scrubbed++;
+			if (ret < 0)
+				meta_corrupted++;
+			else
+				meta_good_mirror = i;
+		} else {
+			ret = check_data_mirror(fs_info, scrub_ctx, NULL, start,
+						len, i, corrupt_bitmaps[i - 1]);
+			scrub_ctx->data_extents_scrubbed++;
+		}
+	}
+
+	/* Metadata recover and report */
+	if (metadata) {
+		if (!meta_corrupted) {
+			goto out;
+		} else if (meta_corrupted && meta_corrupted < num_copies) {
+			if (write) {
+				ret = recover_tree_mirror(fs_info, scrub_ctx,
+						start, meta_good_mirror);
+				if (ret < 0) {
+					error("failed to recover tree block at bytenr %llu",
+						start);
+					goto out;
+				}
+				printf("extent %llu len %llu REPAIRED: has corrupted mirror, repaired\n",
+					start, len);
+				goto out;
+			}
+			printf("extent %llu len %llu RECOVERABLE: has corrupted mirror, but is recoverable\n",
+				start, len);
+			goto out;
+		} else {
+			error("extent %llu len %llu CORRUPTED: all mirror(s) corrupted, can't be recovered",
+				start, len);
+			ret = -EIO;
+			goto out;
+		}
+	}
+	/* Data recover and report */
+	for (i = 0; i < num_copies; i++) {
+		if (find_first_bit(corrupt_bitmaps[i], len / sectorsize) >=
+		    len / sectorsize)
+			continue;
+		data_bad_mirror = i + 1;
+	}
+	/* All data sectors are good */
+	if (!data_bad_mirror) {
+		ret = 0;
+		goto out;
+	}
+
+	if (check_data_mirror_recoverable(fs_info, start, len,
+					  sectorsize, corrupt_bitmaps)) {
+		if (write) {
+			ret = recover_data_mirror(fs_info, scrub_ctx, start,
+						  len, corrupt_bitmaps);
+			if (ret < 0) {
+				error("failed to recover data extent at bytenr %llu len %llu",
+					start, len);
+				goto out;
+			}
+			printf("extent %llu len %llu REPARIED: has corrupted mirror, repaired\n",
+				start, len);
+			goto out;
+		}
+		printf("extent %llu len %llu RECOVERABLE: has corrupted mirror, recoverable\n",
+			start, len);
+		goto out;
+	}
+	error("extent %llu len %llu CORRUPTED, all mirror(s) corrupted, can't be repaired",
+		start, len);
+	ret = -EIO;
+out:
+	for (i = 0; i < BTRFS_MAX_COPIES; i++)
+		kfree(corrupt_bitmaps[i]);
+	return ret;
+
+invalid_arg:
+	error("invalid parameter for %s", __func__);
+	return -EINVAL;
+}
-- 
2.14.3



