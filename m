Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755125AbbKRHYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:52 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoSB007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:24:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 16/22] btrfs-progs: extent-tree: Introduce function to find the first overlap extent.
Date: Wed, 18 Nov 2015 15:22:16 +0800
Message-Id: <1447831342-15056-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_search_overlap_extent() to find the first
overlap extent.

It's useful for later btrfs-convert rework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c       | 24 +++++++++++++++++++++++
 ctree.h       |  2 ++
 extent-tree.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/ctree.c b/ctree.c
index 46153e3..dcf824a 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2937,3 +2937,27 @@ int btrfs_previous_extent_item(struct btrfs_root *root,
 	}
 	return 1;
 }
+
+/*
+ * Search in extent tree to found next meta/data extent
+ * Caller need to check no-hole or skinny metadata
+ */
+int btrfs_next_extent_item(struct btrfs_root *root,
+			struct btrfs_path *path, u64 max_objectid)
+{
+	struct btrfs_key found_key;
+	int ret;
+
+	while (1) {
+		ret = btrfs_next_item(root, path);
+		if (ret)
+			return ret;
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key,
+				      path->slots[0]);
+		if (found_key.objectid > max_objectid)
+			return 1;
+		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    found_key.type == BTRFS_METADATA_ITEM_KEY)
+		return 0;
+	}
+}
diff --git a/ctree.h b/ctree.h
index c57f9ca..f97af7e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2301,6 +2301,8 @@ int btrfs_previous_item(struct btrfs_root *root,
 			int type);
 int btrfs_previous_extent_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid);
+int btrfs_next_extent_item(struct btrfs_root *root,
+			struct btrfs_path *path, u64 max_objectid);
 int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, struct extent_buffer *buf,
 		    struct extent_buffer *parent, int parent_slot,
diff --git a/extent-tree.c b/extent-tree.c
index e04d962..9fa9377 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3908,6 +3908,69 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
+			      u64 *start, u64 *len)
+{
+	struct btrfs_key key;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	BUG_ON(!(key.type == BTRFS_EXTENT_ITEM_KEY ||
+		 key.type == BTRFS_METADATA_ITEM_KEY));
+	*start = key.objectid;
+	if (key.type == BTRFS_EXTENT_DATA_KEY)
+		*len = key.offset;
+	else
+		*len = root->nodesize;
+}
+
+/*
+ * Find first overlap extent for range [bytenr, bytenr + len)
+ * Return 0 for found and point path to it.
+ * Return >0 for not found.
+ * Return <0 for err
+ */
+int btrfs_search_overlap_extent(struct btrfs_root *root,
+				struct btrfs_path *path, u64 bytenr, u64 len)
+{
+	struct btrfs_key key;
+	u64 cur_start;
+	u64 cur_len;
+	int ret;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+	BUG_ON(ret == 0);
+
+	ret = btrfs_previous_extent_item(root, path, 0);
+	if (ret < 0)
+		return ret;
+	/* no previous, check next extent */
+	if (ret > 0)
+		goto next;
+	__get_extent_size(root, path, &cur_start, &cur_len);
+	/* Tail overlap */
+	if (cur_start + cur_len > bytenr)
+		return 1;
+
+next:
+	ret = btrfs_next_extent_item(root, path, bytenr + len);
+	if (ret < 0)
+		return ret;
+	/* No next, prev already checked, no overlap */
+	if (ret > 0)
+		return 0;
+	__get_extent_size(root, path, &cur_start, &cur_len);
+	/* head overlap*/
+	if (cur_start < bytenr + len)
+		return 1;
+	return 0;
+}
+
 /*
  * Record a file extent. Do all the required works, such as inserting
  * file extent item, inserting extent item and backref item into extent
-- 
2.6.2

