Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45979 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1165159AbdEYGWp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:45 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 15/20] btrfs-progs: extent-tree: Introduce function to check if there is any extent in given range.
Date: Thu, 25 May 2017 14:22:00 +0800
Message-ID: <20170525062205.11660-16-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_check_extent_exists(), to check if there
is any extent in the range specified by user.

The parameter can be a large range, and if any extent exists in the
range, it will return >0 (in fact it will return 1).
Or return 0 if no extent is found.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h       |  2 ++
 extent-tree.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/ctree.h b/ctree.h
index 9c999b1f..d3ddf752 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2541,6 +2541,8 @@ int exclude_super_stripes(struct btrfs_root *root,
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
 u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
+int btrfs_check_extent_exists(struct btrfs_fs_info *fs_info, u64 start,
+			      u64 len);
 
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
diff --git a/extent-tree.c b/extent-tree.c
index b12ee290..17c2c10e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4258,3 +4258,63 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 
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
+		extent_len = fs_info->extent_root->nodesize;
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
2.13.0



