Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3381 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbcJQB2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:21 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id B69D641B4BD3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:52 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 13/14] btrfs-progs: check/scrub: Introduce function to check a whole block group
Date: Mon, 17 Oct 2016 09:27:42 +0800
Message-Id: <20161017012743.9692-14-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, scrub_one_block_group(), to scrub a block group.

For Single/DUP/RAID0/RAID1/RAID10, we use old mirror number based
map_block, and check extent by extent.

For parity based profile (RAID5/6), we use new map_block_v2() and check
full stripe by full stripe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index 1c8e440..94f8744 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -689,3 +689,88 @@ out:
 	free(map_block);
 	return ret;
 }
+
+static int scrub_one_block_group(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 struct btrfs_block_group_cache *bg_cache)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 bg_start = bg_cache->key.objectid;
+	u64 bg_len = bg_cache->key.offset;
+	u64 cur;
+	u64 next;
+	int ret;
+
+	if (bg_cache->flags &
+	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		/* RAID5/6 check full stripe by full stripe */
+		cur = bg_cache->key.objectid;
+
+		while (cur < bg_start + bg_len) {
+			ret = scrub_one_full_stripe(fs_info, scrub_ctx, cur,
+						    &next);
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
+			extent_len = extent_root->nodesize;
+		else
+			extent_len = key.offset;
+
+		ret = scrub_one_extent(fs_info, scrub_ctx, path, extent_start,
+					extent_len, 1);
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
2.10.0



