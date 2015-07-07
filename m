Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25001 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756516AbbGGIPm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 3/7] btrfs-progs: extent-tree: Introduce functions to free dev extents in a chunk
Date: Tue, 7 Jul 2015 16:15:24 +0800
Message-ID: <1436256928-23812-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce two functions, free_dev_extent_item and
free_chunk_dev_extent_items, to free dev extent items in a chunk.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index d002a4f..afc7822 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3483,6 +3483,80 @@ out:
 	return ret;
 }
 
+static int free_dev_extent_item(struct btrfs_trans_handle *trans,
+				struct btrfs_fs_info *fs_info,
+				u64 devid, u64 dev_offset)
+{
+	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+
+	key.objectid = devid;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = dev_offset;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int free_chunk_dev_extent_items(struct btrfs_trans_handle *trans,
+				       struct btrfs_fs_info *fs_info,
+				       u64 chunk_offset)
+{
+	struct btrfs_chunk *chunk = NULL;
+	struct btrfs_root *root= fs_info->chunk_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u16 num_stripes;
+	int i;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = chunk_offset;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			       struct btrfs_chunk);
+	num_stripes = btrfs_chunk_num_stripes(path->nodes[0], chunk);
+	for (i = 0; i < num_stripes; i++) {
+		ret = free_dev_extent_item(trans, fs_info,
+			btrfs_stripe_devid_nr(path->nodes[0], chunk, i),
+			btrfs_stripe_offset_nr(path->nodes[0], chunk, i));
+		if (ret < 0)
+			goto out;
+	}
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

