Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbcBBDIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:07 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 04/19] btrfs: dedup: Introduce function to remove hash from in-memory tree
Date: Tue,  2 Feb 2016 11:05:36 +0800
Message-Id: <1454382351-31775-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_del() to remove hash from in-memory
dedup tree.
And implement btrfs_dedup_del() and btrfs_dedup_destroy() interfaces.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedup.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index b6bff0a..57c9dfe 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -255,3 +255,91 @@ int btrfs_dedup_add(struct btrfs_trans_handle *trans,
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
+int btrfs_dedup_del(struct btrfs_trans_handle *trans,
+		    struct btrfs_dedup_info *dedup_info, u64 bytenr)
+{
+	if (!dedup_info)
+		return 0;
+
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		return inmem_del(dedup_info, bytenr);
+	return -EINVAL;
+}
+
+static void inmem_destroy(struct btrfs_dedup_info *dedup_info)
+{
+	struct inmem_hash *entry, *tmp;
+
+	mutex_lock(&dedup_info->lock);
+	list_for_each_entry_safe(entry, tmp, &dedup_info->lru_list, lru_list)
+		__inmem_del(dedup_info, entry);
+	mutex_unlock(&dedup_info->lock);
+}
+
+int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedup_info *dedup_info;
+
+	/* Here we don't want to increase refs of dedup_info */
+	spin_lock(&fs_info->dedup_ref_lock);
+	dedup_info = fs_info->dedup_info;
+
+	/* Block other caller from deduping */
+	fs_info->dedup_info = NULL;
+	spin_unlock(&fs_info->dedup_ref_lock);
+
+	if (!dedup_info)
+		return 0;
+
+	/* Wait all existing callers exit */
+	wait_event(dedup_info->refs_wq, atomic_read(&dedup_info->refs) == 0);
+
+	/* now we are OK to clean up everything */
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
+		inmem_destroy(dedup_info);
+
+	crypto_free_shash(dedup_info->dedup_driver);
+	kfree(dedup_info);
+	return 0;
+}
-- 
2.7.0



