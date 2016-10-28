Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965908AbcJ1Cck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 15/19] btrfs-progs: extent-tree: Introduce function to check if there is any extent in given range.
Date: Fri, 28 Oct 2016 10:31:51 +0800
Message-Id: <20161028023155.27336-16-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Will be used for later scrub usage.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h       |  2 ++
 extent-tree.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/ctree.h b/ctree.h
index e0dd2e4..b511ff2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2363,6 +2363,8 @@ int exclude_super_stripes(struct btrfs_root *root,
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       struct btrfs_fs_info *info, u64 start, u64 end);
 u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
+int btrfs_check_extent_exists(struct btrfs_fs_info *fs_info, u64 start,
+			      u64 len);
 
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
diff --git a/extent-tree.c b/extent-tree.c
index f6d0a7c..88b91df 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4244,3 +4244,55 @@ u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 
 	return total_added;
 }
+
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
2.10.1



