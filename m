Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21539 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932167AbcKNIAB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 03:00:01 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v14.1 07/16] btrfs: dedupe: Introduce function to remove hash from in-memory tree
Date: Mon, 14 Nov 2016 15:58:30 +0800
Message-Id: <20161114075839.23587-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
References: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_del() to remove hash from in-memory
dedupe tree.
And implement btrfs_dedupe_del() and btrfs_dedup_disable() interfaces.

Also for btrfs_dedupe_disable(), add new functions to wait existing
writer and block incoming writers to eliminate all possible race.

Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 132 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 126 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index e51412b..14c57fa 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -186,12 +186,6 @@ enable:
 	return ret;
 }
 
-int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
-{
-	/* Place holder for bisect, will be implemented in later patches */
-	return 0;
-}
-
 static int inmem_insert_hash(struct rb_root *root,
 			     struct inmem_hash *hash, int hash_len)
 {
@@ -334,3 +328,129 @@ int btrfs_dedupe_add(struct btrfs_trans_handle *trans,
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
+/*
+ * Helper function to wait and block all incoming writers
+ *
+ * Use rw_sem introduced for freeze to wait/block writers.
+ * So during the block time, no new write will happen, so we can
+ * do something quite safe, espcially helpful for dedupe disable,
+ * as it affect buffered write.
+ */
+static void block_all_writers(struct btrfs_fs_info *fs_info)
+{
+	struct super_block *sb = fs_info->sb;
+
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
+	down_write(&sb->s_umount);
+}
+
+static void unblock_all_writers(struct btrfs_fs_info *fs_info)
+{
+	struct super_block *sb = fs_info->sb;
+
+	up_write(&sb->s_umount);
+	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
+}
+
+int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_dedupe_info *dedupe_info;
+	int ret;
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
+	 * Wait for all unfinished writers and block further writers.
+	 * Then sync the whole fs so all current write will go through
+	 * dedupe, and all later write won't go through dedupe.
+	 */
+	block_all_writers(fs_info);
+	ret = sync_filesystem(fs_info->sb);
+	fs_info->dedupe_enabled = 0;
+	fs_info->dedupe_info = NULL;
+	unblock_all_writers(fs_info);
+	if (ret < 0)
+		return ret;
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
2.10.2



