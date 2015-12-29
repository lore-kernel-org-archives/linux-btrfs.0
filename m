Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbbL2ICh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:02:37 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id A7FD041887F4
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:32 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 13/14] btrfs: dedup: Add support to delete hash for on-disk backend
Date: Tue, 29 Dec 2015 16:01:22 +0800
Message-ID: <1451376083-30474-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend can delete hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 82e21a6..704c3c7 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -468,6 +468,58 @@ static int inmem_del(struct btrfs_dedup_info *dedup_info, u64 bytenr)
 	return 0;
 }
 
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
+	ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+
+	/* There should be at most one item with same objectid and type */
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid != bytenr || key.type != BTRFS_DEDUP_BYTENR_ITEM_KEY) {
+		ret = 0;
+		goto out;
+	}
+
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
@@ -480,6 +532,8 @@ int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		return inmem_del(dedup_info, bytenr);
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		return ondisk_del(trans, dedup_info, bytenr);
 	return -EINVAL;
 }
 
-- 
2.6.4



