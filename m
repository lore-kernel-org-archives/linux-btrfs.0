Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26117 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751484AbeAELR2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:28 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 08/16] btrfs-progs: scrub: Introduce function to scrub one data stripe
Date: Fri, 5 Jan 2018 19:01:16 +0800
Message-ID: <1515150084-17231-9-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce new function, scrub_one_data_stripe(), to check all data and
tree blocks inside the data stripe.

This function will not try to recovery any error, but only check if any
data/tree blocks has mismatch csum.

If data missing csum, which is completely valid for case like nodatasum,
it will just record it, but not report as error.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 scrub.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/scrub.c b/scrub.c
index b0a98b98..5c1c3957 100644
--- a/scrub.c
+++ b/scrub.c
@@ -620,3 +620,132 @@ invalid_arg:
 	error("invalid parameter for %s", __func__);
 	return -EINVAL;
 }
+
+/*
+ * Scrub one full data stripe of RAID5/6.
+ * This means it will check any data/metadata extent in the data stripe
+ * spcified by @stripe and @stripe_len
+ *
+ * This function will only *CHECK* if the data stripe has any corruption.
+ * Won't repair at this function.
+ *
+ * Return 0 if the full stripe is OK.
+ * Return <0 if any error is found.
+ * Note: Missing csum is not counted as error (NODATACSUM is valid)
+ */
+static int scrub_one_data_stripe(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 struct scrub_stripe *stripe, u32 stripe_len)
+{
+	struct btrfs_path *path;
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_key key;
+	u64 extent_start;
+	u64 extent_len;
+	u64 orig_csum_discards;
+	int ret;
+
+	if (!is_data_stripe(stripe))
+		return -EINVAL;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = stripe->logical + stripe_len;
+	key.offset = 0;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		struct btrfs_extent_item *ei;
+		struct extent_buffer *eb;
+		char *data;
+		int slot;
+		int metadata = 0;
+		u64 check_start;
+		u64 check_len;
+
+		ret = btrfs_previous_extent_item(extent_root, path, 0);
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+		if (ret < 0)
+			goto out;
+		eb = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(eb, &key, slot);
+		extent_start = key.objectid;
+		ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
+
+		/* tree block scrub */
+		if (key.type == BTRFS_METADATA_ITEM_KEY ||
+		    btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+			extent_len = extent_root->fs_info->nodesize;
+			metadata = 1;
+		} else {
+			extent_len = key.offset;
+			metadata = 0;
+		}
+
+		/* Current extent is out of our range, loop comes to end */
+		if (extent_start + extent_len <= stripe->logical)
+			break;
+
+		if (metadata) {
+			/*
+			 * Check crossing stripe first, which can't be scrubbed
+			 */
+			if (check_crossing_stripes(fs_info, extent_start,
+					extent_root->fs_info->nodesize)) {
+				error("tree block at %llu is crossing stripe boundary, unable to scrub",
+					extent_start);
+				ret = -EIO;
+				goto out;
+			}
+			data = stripe->data + extent_start - stripe->logical;
+			ret = check_tree_mirror(fs_info, scrub_ctx,
+						data, extent_start, 0);
+			/* Any csum/verify error means the stripe is screwed */
+			if (ret < 0) {
+				stripe->csum_mismatch = 1;
+				ret = -EIO;
+				goto out;
+			}
+			ret = 0;
+			continue;
+		}
+		/* Restrict the extent range to fit stripe range */
+		check_start = max(extent_start, stripe->logical);
+		check_len = min(extent_start + extent_len, stripe->logical +
+				stripe_len) - check_start;
+
+		/* Record original csum_discards to detect missing csum case */
+		orig_csum_discards = scrub_ctx->csum_discards;
+
+		data = stripe->data + check_start - stripe->logical;
+		ret = check_data_mirror(fs_info, scrub_ctx, data, check_start,
+					check_len, 0, NULL);
+		/* Csum mismatch, no need to continue anyway*/
+		if (ret < 0) {
+			stripe->csum_mismatch = 1;
+			goto out;
+		}
+		/* Check if there is any missing csum for data */
+		if (scrub_ctx->csum_discards != orig_csum_discards)
+			stripe->csum_missing = 1;
+		/*
+		 * Only increase data_extents_scrubbed if we are scrubbing the
+		 * tailing part of the data extent
+		 */
+		if (extent_start + extent_len <= stripe->logical + stripe_len)
+			scrub_ctx->data_extents_scrubbed++;
+		ret = 0;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.14.3



