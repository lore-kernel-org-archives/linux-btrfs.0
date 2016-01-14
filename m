Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31538 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751905AbcANGAH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:07 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 60F3541896C2
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:38 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v4 04/18] btrfs: dedup: Introduce function to remove hash from in-memory tree
Date: Thu, 14 Jan 2016 13:57:20 +0800
Message-ID: <1452751054-2365-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_del() to remove hash from in-memory
dedup tree.
And implement btrfs_dedup_del() and btrfs_dedup_destroy() interfaces.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 727424e..39391b8 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -249,3 +249,80 @@ int btrfs_dedup_add(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		return inmem_add(dedup_info, hash);
 	return -EINVAL;
 }
+
+static struct inmem_hash *
+inmem_search_bytenr(struct btrfs_dedup_info *dedup_info, u64 bytenr)
+{
+	struct rb_node **p = &dedup_info->bytenr_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
+
+		if (bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	return NULL;
+}
+
+/* Delete a hash from in-memory dedup tree */
+static int inmem_del(struct btrfs_dedup_info *dedup_info, u64 bytenr)
+{
+	struct inmem_hash *hash;
+
+	mutex_lock(&dedup_info->lock);
+	hash = inmem_search_bytenr(dedup_info, bytenr);
+	if (!hash) {
+		mutex_unlock(&dedup_info->lock);
+		return 0;
+	}
+
+	__inmem_del(dedup_info, hash);
+	mutex_unlock(&dedup_info->lock);
+	return 0;
+}
+
+/* Remove a dedup hash from dedup tree */
+int btrfs_dedup_del(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		    u64 bytenr)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!dedup_info)
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		return inmem_del(dedup_info, bytenr);
+	return -EINVAL;
+}
+
+static void inmem_destroy(struct btrfs_fs_info *fs_info)
+{
+	struct inmem_hash *entry, *tmp;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	mutex_lock(&dedup_info->lock);
+	list_for_each_entry_safe(entry, tmp, &dedup_info->lru_list, lru_list)
+		__inmem_del(dedup_info, entry);
+	mutex_unlock(&dedup_info->lock);
+}
+
+int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!dedup_info)
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		inmem_destroy(fs_info);
+	return 0;
+}
-- 
2.7.0



