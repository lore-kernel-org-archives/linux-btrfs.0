Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57276 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932240AbcJQB2R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:17 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id C0FD241B4BC6
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:49 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 08/14] btrfs-progs: check/scrub: Introduce function to scrub one data stripe
Date: Mon, 17 Oct 2016 09:27:37 +0800
Message-Id: <20161017012743.9692-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, scrub_one_data_stripe(), to check all data and
tree blocks inside the data stripe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index cdba469..f29effa 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -297,3 +297,114 @@ invalid_arg:
 	error("invalid parameter for %s", __func__);
 	return -EINVAL;
 }
+
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
+			extent_len = extent_root->nodesize;
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
+			if (check_crossing_stripes(extent_start,
+					extent_root->nodesize)) {
+				error("tree block at %llu is crossing stripe boundary, unable to scrub",
+					extent_start);
+				ret = -EIO;
+				goto out;
+			}
+			data = stripe->data + extent_start - stripe->logical;
+			ret = scrub_tree_mirror(fs_info, scrub_ctx,
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
+		ret = scrub_data_mirror(fs_info, scrub_ctx, data, check_start,
+					check_len, 0);
+		/* Csum mismatch, no need to continue anyway*/
+		if (ret < 0) {
+			stripe->csum_mismatch = 1;
+			goto out;
+		}
+		/* Check if there is any missing csum for data */
+		if (scrub_ctx->csum_discards != orig_csum_discards)
+			stripe->csum_missing = 1;
+		ret = 0;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.10.0



