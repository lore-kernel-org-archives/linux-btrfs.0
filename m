Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25001 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756554AbbGGIPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 6/7] btrfs-progs: extent-tree: Introduce btrfs_free_block_group function.
Date: Tue, 7 Jul 2015 16:15:27 +0800
Message-ID: <1436256928-23812-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function will be used to free a empty chunk.

This provides the basis for later temp chunk cleanup.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h       |  2 ++
 extent-tree.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/ctree.h b/ctree.h
index f14a795..5550d45 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2275,6 +2275,8 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      struct btrfs_inode_item *inode,
 			      u64 file_pos, u64 disk_bytenr,
 			      u64 num_bytes);
+int btrfs_free_block_group(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 39d6288..358bd19 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3743,6 +3743,86 @@ out:
 	return ret;
 }
 
+int btrfs_free_block_group(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info, u64 bytenr, u64 len)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_path *path;
+	struct btrfs_block_group_item *bgi;
+	struct btrfs_key key;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = len;
+
+	/* Double check the block group to ensure it's empty */
+	ret = btrfs_search_slot(trans, extent_root, &key, path, 0, 0);
+	if (ret > 0) {
+		ret = -ENONET;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	bgi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			     struct btrfs_block_group_item);
+	if (btrfs_disk_block_group_used(path->nodes[0], bgi)) {
+		fprintf(stderr,
+			"warning: block group [%llu,%llu) is not empty to free\n",
+			bytenr, bytenr + len);
+		ret = -EINVAL;
+		goto out;
+	}
+	btrfs_release_path(path);
+
+	/*
+	 * Now pin all space in the block group, to prevent further transaction
+	 * allocate space from it.
+	 * Every operation needs a transaction must be in the range.
+	 */
+	btrfs_pin_extent(fs_info, bytenr, len);
+
+	/* delete block group item and chunk item */
+	ret = free_block_group_item(trans, fs_info, bytenr, len);
+	if (ret < 0) {
+		fprintf(stderr,
+			"failed to free block group item for [%llu,%llu)\n",
+			bytenr, bytenr + len);
+		btrfs_unpin_extent(fs_info, bytenr, len);
+		goto out;
+	}
+
+	ret = free_chunk_dev_extent_items(trans, fs_info, bytenr);
+	if (ret < 0) {
+		fprintf(stderr,
+			"failed to dev extents belongs to [%llu,%llu)\n",
+			bytenr, bytenr + len);
+		btrfs_unpin_extent(fs_info, bytenr, len);
+		goto out;
+	}
+	ret = free_chunk_item(trans, fs_info, bytenr, len);
+	if (ret < 0) {
+		fprintf(stderr,
+			"failed to free chunk for [%llu,%llu)\n",
+			bytenr, bytenr + len);
+		btrfs_unpin_extent(fs_info, bytenr, len);
+		goto out;
+	}
+
+	/* Now release the block_group_cache */
+	ret = free_block_group_cache(trans, fs_info, bytenr, len);
+	btrfs_unpin_extent(fs_info, bytenr, len);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
-- 
2.4.4

