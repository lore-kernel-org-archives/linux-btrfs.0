Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbcBEBZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:25:04 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 04/19] btrfs: dedup: Introduce function to remove hash from in-memory tree
Date: Fri,  5 Feb 2016 09:22:24 +0800
Message-Id: <1454635359-10013-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 fs/btrfs/dedup.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 5fa15ae..259b32d 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -257,3 +257,108 @@ int btrfs_dedup_add(struct btrfs_trans_handle *trans,
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
+		    struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+
+	if (!fs_info->dedup_enabled)
+		return 0;
+
+	if (WARN_ON(dedup_info == NULL))
+		return -EINVAL;
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
+	int ret;
+
+	/* Here we don't want to increase refs of dedup_info */
+	fs_info->dedup_enabled = 0;
+
+	dedup_info = fs_info->dedup_info;
+
+	if (!dedup_info)
+		return 0;
+
+	/* Don't allow disable status change in RO mount */
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	/*
+	 * Wait for all unfinished write to complete dedup routine
+	 * As disable operation is not a frequent operation, we are
+	 * OK to use heavy but safe sync_filesystem().
+	 */
+	down_read(&fs_info->sb->s_umount);
+	ret = sync_filesystem(fs_info->sb);
+	up_read(&fs_info->sb->s_umount);
+	if (ret < 0)
+		return ret;
+
+	fs_info->dedup_info = NULL;
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



