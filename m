Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33345 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbcDAGfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 19/21] btrfs: dedupe: Add support to delete hash for on-disk backend
Date: Fri,  1 Apr 2016 14:35:10 +0800
Message-Id: <1459492512-31435-20-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can delete hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 00f2a01..7c5d58a 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -500,6 +500,104 @@ static int inmem_del(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
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
+				struct btrfs_dedupe_info *dedupe_info,
+				struct btrfs_path *path, u64 bytenr,
+				int prepare_del)
+{
+	struct btrfs_key key;
+	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
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
+	key.type = BTRFS_DEDUPE_BYTENR_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(trans, dedupe_root, &key, path,
+				ins_len, cow);
+
+	if (ret < 0)
+		return ret;
+	/*
+	 * Although it's almost impossible, it's still possible that
+	 * the last 64bits are all 1.
+	 */
+	if (ret == 0)
+		return 1;
+
+	ret = btrfs_previous_item(dedupe_root, path, bytenr,
+				  BTRFS_DEDUPE_BYTENR_ITEM_KEY);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		return 0;
+	return 1;
+}
+
+static int ondisk_del(struct btrfs_trans_handle *trans,
+		      struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
+{
+	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = bytenr;
+	key.type = BTRFS_DEDUPE_BYTENR_ITEM_KEY;
+	key.offset = 0;
+
+	mutex_lock(&dedupe_info->lock);
+
+	ret = ondisk_search_bytenr(trans, dedupe_info, path, bytenr, 1);
+	if (ret <= 0)
+		goto out;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	ret = btrfs_del_item(trans, dedupe_root, path);
+	btrfs_release_path(path);
+	if (ret < 0)
+		goto out;
+	/* Search for hash item and delete it */
+	key.objectid = key.offset;
+	key.type = BTRFS_DEDUPE_HASH_ITEM_KEY;
+	key.offset = bytenr;
+
+	ret = btrfs_search_slot(trans, dedupe_root, &key, path, -1, 1);
+	if (WARN_ON(ret > 0)) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+	ret = btrfs_del_item(trans, dedupe_root, path);
+
+out:
+	btrfs_free_path(path);
+	mutex_unlock(&dedupe_info->lock);
+	return ret;
+}
+
 /* Remove a dedupe hash from dedupe tree */
 int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info, u64 bytenr)
@@ -514,6 +612,8 @@ int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
 
 	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
 		return inmem_del(dedupe_info, bytenr);
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_ONDISK)
+		return ondisk_del(trans, dedupe_info, bytenr);
 	return -EINVAL;
 }
 
-- 
2.7.4



