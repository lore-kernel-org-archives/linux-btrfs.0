Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57704 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726544AbeIDLXr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 07:23:47 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, Mark Fasheh <mfasheh@suse.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15 04/13] btrfs: dedupe: Introduce function to remove hash from in-memory tree
Date: Tue, 4 Sep 2018 14:59:33 +0800
Message-ID: <20180904065942.3621-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
References: <20180904065942.3621-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 131 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 784bb3a8a5ab..951fefd19fde 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -170,12 +170,6 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
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
@@ -317,3 +311,128 @@ int btrfs_dedupe_add(struct btrfs_fs_info *fs_info,
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
+int btrfs_dedupe_del(struct btrfs_fs_info *fs_info, u64 bytenr)
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
2.18.0
