Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3656 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbbGGIPg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 2/7] btrfs-progs: extent-tree: Introduce free_block_group_item function.
Date: Tue, 7 Jul 2015 16:15:23 +0800
Message-ID: <1436256928-23812-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used to free a block group item.
It must be called with all the space in the block group pinned.
Or there is a possibility that tree blocks be allocated into the range.

The function is used for later block group/chunk free function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index c24af6a..d002a4f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3448,6 +3448,42 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * Just remove a block group item in extent tree
+ * Caller should ensure the block group is empty and all space is pinned.
+ * Or new tree block/data may be allocated into it.
+ */
+static int free_block_group_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_fs_info *fs_info,
+				 u64 bytenr, u64 len)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *root = fs_info->extent_root;
+	int ret = 0;
+
+	key.objectid = bytenr;
+	key.offset = len;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	ret = btrfs_del_item(trans, root, path);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
  */
-- 
2.4.4

