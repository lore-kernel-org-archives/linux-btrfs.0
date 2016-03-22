Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758161AbcCVBi4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 04/27] btrfs: dedupe: Introduce function to remove hash from in-memory tree
Date: Tue, 22 Mar 2016 09:35:29 +0800
Message-Id: <1458610552-9845-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_del() to remove hash from in-memory
dedupe tree.
And implement btrfs_dedupe_del() and btrfs_dedup_destroy() interfaces.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 013600a..e44993b 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -257,3 +257,108 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
 		return inmem_add(dedupe_info, hash);
 	return -EINVAL;
 }
+
+static struct inmem_hash *
+inmem_search_bytenr(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
+{
+	struct rb_node **p = &dedupe_info->bytenr_root.rb_node;
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
+/* Delete a hash from in-memory dedupe tree */
+static int inmem_del(struct btrfs_dedupe_info *dedupe_info, u64 bytenr)
+{
+	struct inmem_hash *hash;
+
+	mutex_lock(&dedupe_info->lock);
+	hash = inmem_search_bytenr(dedupe_info, bytenr);
+	if (!hash) {
+		mutex_unlock(&dedupe_info->lock);
+		return 0;
+	}
+
+	__inmem_del(dedupe_info, hash);
+	mutex_unlock(&dedupe_info->lock);
+	return 0;
+}
+
+/* Remove a dedupe hash from dedupe tree */
+int btrfs_dedupe_del(struct btrfs_trans_handle *trans,
+		     struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	if (!fs_info->dedupe_enabled)
+		return 0;
+
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		return inmem_del(dedupe_info, bytenr);
+	return -EINVAL;
+}
+
+static void inmem_destroy(struct btrfs_dedupe_info *dedupe_info)
+{
+	struct inmem_hash *entry, *tmp;
+
+	mutex_lock(&dedupe_info->lock);
+	list_for_each_entry_safe(entry, tmp, &dedupe_info->lru_list, lru_list)
+		__inmem_del(dedupe_info, entry);
+	mutex_unlock(&dedupe_info->lock);
+}
+
+int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	int ret;
+
+	/* Here we don't want to increase refs of dedupe_info */
+	fs_info->dedupe_enabled = 0;
+
+	dedupe_info = fs_info->dedupe_info;
+
+	if (!dedupe_info)
+		return 0;
+
+	/* Don't allow disable status change in RO mount */
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	/*
+	 * Wait for all unfinished write to complete dedupe routine
+	 * As disable operation is not a frequent operation, we are
+	 * OK to use heavy but safe sync_filesystem().
+	 */
+	down_read(&fs_info->sb->s_umount);
+	ret = sync_filesystem(fs_info->sb);
+	up_read(&fs_info->sb->s_umount);
+	if (ret < 0)
+		return ret;
+
+	fs_info->dedupe_info = NULL;
+
+	/* now we are OK to clean up everything */
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		inmem_destroy(dedupe_info);
+
+	crypto_free_shash(dedupe_info->dedupe_driver);
+	kfree(dedupe_info);
+	return 0;
+}
-- 
2.7.3



