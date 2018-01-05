Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26117 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750992AbeAELRa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:30 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 14/16] btrfs-progs: scrub: Introduce function to check a whole block group
Date: Fri, 5 Jan 2018 19:01:22 +0800
Message-ID: <1515150084-17231-15-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce new function, scrub_one_block_group(), to scrub a block group.

For Single/DUP/RAID0/RAID1/RAID10, we use old mirror number based
map_block, and check extent by extent.

For parity based profile (RAID5/6), we use new map_block_v2() and check
full stripe by full stripe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 scrub.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/scrub.c b/scrub.c
index e474b18a..1f2fd56d 100644
--- a/scrub.c
+++ b/scrub.c
@@ -1198,3 +1198,95 @@ out:
 	free(map_block);
 	return ret;
 }
+
+/*
+ * Scrub one block group.
+ *
+ * This function will handle all profiles current btrfs supports.
+ * Return 0 for scrubbing the block group. Found error will be recorded into
+ * scrub_ctx.
+ * Return <0 for fatal error preventing scrubing the block group.
+ */
+static int scrub_one_block_group(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 struct btrfs_block_group_cache *bg_cache,
+				 int write)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 bg_start = bg_cache->key.objectid;
+	u64 bg_len = bg_cache->key.offset;
+	int ret;
+
+	if (bg_cache->flags &
+	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		u64 cur = bg_start;
+		u64 next;
+
+		while (cur < bg_start + bg_len) {
+			ret = scrub_one_full_stripe(fs_info, scrub_ctx, cur,
+						    &next, write);
+			/* Ignore any non-fatal error */
+			if (ret < 0 && ret != -EIO) {
+				error("fatal error happens checking one full stripe at bytenr: %llu: %s",
+					cur, strerror(-ret));
+				return ret;
+			}
+			cur = next;
+		}
+		/* Ignore any -EIO error, such error will be reported at last */
+		return 0;
+	}
+	/* None parity based profile, check extent by extent */
+	key.objectid = bg_start;
+	key.type = 0;
+	key.offset = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		struct extent_buffer *eb = path->nodes[0];
+		int slot = path->slots[0];
+		u64 extent_start;
+		u64 extent_len;
+
+		btrfs_item_key_to_cpu(eb, &key, slot);
+		if (key.objectid >= bg_start + bg_len)
+			break;
+		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY)
+			goto next;
+
+		extent_start = key.objectid;
+		if (key.type == BTRFS_METADATA_ITEM_KEY)
+			extent_len = extent_root->fs_info->nodesize;
+		else
+			extent_len = key.offset;
+
+		ret = scrub_one_extent(fs_info, scrub_ctx, path, extent_start,
+					extent_len, write);
+		if (ret < 0 && ret != -EIO) {
+			error("fatal error checking extent bytenr %llu len %llu: %s",
+				extent_start, extent_len, strerror(-ret));
+			goto out;
+		}
+		ret = 0;
+next:
+		ret = btrfs_next_extent_item(extent_root, path, bg_start +
+					     bg_len);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.14.3



