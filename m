Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbcAGBIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:51 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 32CF941887F2
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 14/16] btrfs: dedup: Add support to delete hash for on-disk backend
Date: Thu, 7 Jan 2016 09:08:15 +0800
Message-ID: <1452128897-5433-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can delete hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Change order for ondisk_add().
---
 fs/btrfs/dedup.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 4bcdf5d..f448e27 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -448,6 +448,93 @@ static int inmem_del(struct btrfs_dedup_info *dedup_info, u64 bytenr)
 	return 0;
 }
 
+/*
+ * If prepare_del is given, this will setup search_slot() for delete.
+ * Caller needs to do proper locking.
+ *
+ * Return > 0 for found.
+ * Return 0 for not found.
+ * Return < 0 for error.
+ */
+static int ondisk_search_bytenr(struct btrfs_trans_handle *trans,
+				struct btrfs_dedup_info *dedup_info,
+				struct btrfs_path *path, u64 bytenr,
+				int prepare_del)
+{
+	struct btrfs_key key;
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	int ret;
+	int ins_len = 0;
+	int cow = 0;
+
+	if (prepare_del) {
+		if (WARN_ON(trans == NULL))
+			return -EINVAL;
+		cow = 1;
+		ins_len = -1;
+	}
+
+	key.objectid = bytenr;
+	key.type = BTRFS_DEDUP_BYTENR_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, dedup_root, &key, path,
+				ins_len, cow);
+	if (ret < 0)
+		return ret;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid != bytenr || key.type != BTRFS_DEDUP_BYTENR_ITEM_KEY)
+		return 0;
+	return 1;
+}
+
+static int ondisk_del(struct btrfs_trans_handle *trans,
+		      struct btrfs_dedup_info *dedup_info, u64 bytenr)
+{
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_DEDUP_BYTENR_ITEM_KEY;
+	key.offset = 0;
+
+	mutex_lock(&dedup_info->ondisk_lock);
+
+	ret = ondisk_search_bytenr(trans, dedup_info, path, bytenr, 1);
+	if (ret <= 0)
+		goto out;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	btrfs_del_item(trans, dedup_root, path);
+	btrfs_release_path(path);
+
+	/* Search for hash item and delete it */
+	key.objectid = key.offset;
+	key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
+	key.offset = bytenr;
+
+	ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
+	if (WARN_ON(ret > 0)) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+	btrfs_del_item(trans, dedup_root, path);
+
+out:
+	btrfs_free_path(path);
+	mutex_unlock(&dedup_info->ondisk_lock);
+	return ret;
+}
+
 /* Remove a dedup hash from dedup tree */
 int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		    u64 bytenr)
@@ -460,6 +547,8 @@ int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		return inmem_del(dedup_info, bytenr);
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return ondisk_del(trans, dedup_info, bytenr);
 	return -EINVAL;
 }
 
-- 
2.6.4



