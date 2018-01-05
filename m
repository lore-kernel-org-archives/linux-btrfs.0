Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34826 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751503AbeAELR2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:28 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 10/16] btrfs-progs: extent-tree: Introduce function to check if there is any extent in given range.
Date: Fri, 5 Jan 2018 19:01:18 +0800
Message-ID: <1515150084-17231-11-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introduce a new function, btrfs_check_extent_exists(), to check if there
is any extent in the range specified by user.

The parameter can be a large range, and if any extent exists in the
range, it will return >0 (in fact it will return 1).
Or return 0 if no extent is found.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.h       |  2 ++
 extent-tree.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/ctree.h b/ctree.h
index a7d26455..7d58cb33 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2521,6 +2521,8 @@ int exclude_super_stripes(struct btrfs_root *root,
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
 u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
+int btrfs_check_extent_exists(struct btrfs_fs_info *fs_info, u64 start,
+			      u64 len);
 
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
diff --git a/extent-tree.c b/extent-tree.c
index 055582c3..3af0c1f1 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4256,3 +4256,63 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	return total_added;
 }
+
+/*
+ * Check if there is any extent(both data and metadata) in the range
+ * [@start, @start + @len)
+ *
+ * Return 0 for no extent found.
+ * Return >0 for found extent.
+ * Return <0 for fatal error.
+ */
+int btrfs_check_extent_exists(struct btrfs_fs_info *fs_info, u64 start,
+			      u64 len)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 extent_start;
+	u64 extent_len;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = start + len;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	/*
+	 * Now we're pointing at slot whose key.object >= end, skip to previous
+	 * extent.
+	 */
+	ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	extent_start = key.objectid;
+	if (key.type == BTRFS_METADATA_ITEM_KEY)
+		extent_len = fs_info->nodesize;
+	else
+		extent_len = key.offset;
+
+	/*
+	 * search_slot() and previous_extent_item() has ensured that our
+	 * extent_start < start + len, we only need to care extent end.
+	 */
+	if (extent_start + extent_len <= start)
+		ret = 0;
+	else
+		ret = 1;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.14.3



