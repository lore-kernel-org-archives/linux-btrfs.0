Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757860AbbFQHtJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lVIW015769
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs-progs: map-logical: Introduce map_one_extent function.
Date: Wed, 17 Jun 2015 15:49:01 +0800
Message-ID: <1434527344-314-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce the function to get accurate extent length based on extent
tree search.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index e5e2da5..8442779 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -35,6 +35,64 @@
  * */
 static FILE *info_file;
 
+static int map_one_extent(struct btrfs_fs_info *fs_info,
+			  u64 *logical_ret, u64 *len_ret, int search_foward)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 logical;
+	u64 len = 0;
+	int ret = 0;
+
+	BUG_ON(!logical_ret);
+	logical = *logical_ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = logical;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path,
+				0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+	ret = 0;
+
+again:
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if ((search_foward && key.objectid < logical) ||
+	    (!search_foward && key.objectid > logical) ||
+	    (key.type != BTRFS_EXTENT_ITEM_KEY &&
+	     key.type != BTRFS_METADATA_ITEM_KEY)) {
+		if (!search_foward)
+			ret = btrfs_previous_extent_item(fs_info->extent_root,
+							 path, 0);
+		else
+			ret = btrfs_next_item(fs_info->extent_root, path);
+		if (ret)
+			goto out;
+		goto again;
+	}
+	logical = key.objectid;
+	if (key.type == BTRFS_METADATA_ITEM_KEY)
+		len = fs_info->tree_root->leafsize;
+	else
+		len = key.offset;
+
+out:
+	btrfs_free_path(path);
+	if (!ret) {
+		*logical_ret = logical;
+		if (len_ret)
+			*len_ret = len;
+	}
+	return ret;
+}
+
 static struct extent_buffer * debug_read_block(struct btrfs_root *root,
 		u64 bytenr, u32 blocksize, u64 copy)
 {
-- 
2.4.3

