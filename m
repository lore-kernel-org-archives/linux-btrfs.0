Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57905 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbbBFFrk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 00:47:40 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t165ktFI016576
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Feb 2015 13:46:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v7 2/9] Revert "btrfs: add support for processing pending changes" related commits
Date: Fri, 6 Feb 2015 13:45:27 +0800
Message-ID: <1423201534-19309-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423201534-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423201534-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 572d9ab7845 ~ a6f69dc8018.

This pending commits patches introduce deadlock with freeze, and fix for
it will introduce extra checks on freeze and read only case.

For mount option change, later patches will introduce per-transaction
mount option to keep mount options consistent during transaction.

For sysfs interface to change label/features, it will use
mnt_want_write() to do the ro/freeze check and keep the 'btrfs pro set'
synchronized behavior.

Revert them to a clean base for later changes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Acked-by: David Sterba <dsterba@suse.cz>

Conflicts:
	fs/btrfs/ctree.h
	fs/btrfs/super.c
---
changelog:
v2:
  Newly introduced.
v3~v7:
  None
---
 fs/btrfs/ctree.h       | 49 +------------------------------------------------
 fs/btrfs/disk-io.c     |  8 +++-----
 fs/btrfs/inode-map.c   |  2 +-
 fs/btrfs/super.c       | 24 +++---------------------
 fs/btrfs/sysfs.c       | 34 +++++++++++++++++++++-------------
 fs/btrfs/transaction.c | 38 ++++++--------------------------------
 fs/btrfs/transaction.h |  2 --
 7 files changed, 35 insertions(+), 122 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b18070..08741e8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1412,11 +1412,6 @@ struct btrfs_fs_info {
 	 */
 	u64 last_trans_log_full_commit;
 	unsigned long mount_opt;
-	/*
-	 * Track requests for actions that need to be done during transaction
-	 * commit (like for some mount options).
-	 */
-	unsigned long pending_changes;
 	unsigned long compress_type:4;
 	int commit_interval;
 	/*
@@ -2114,6 +2109,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
+#define	BTRFS_MOUNT_CHANGE_INODE_CACHE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
@@ -2139,49 +2135,6 @@ struct btrfs_ioctl_defrag_range_args {
 }
 
 /*
- * Requests for changes that need to be done during transaction commit.
- *
- * Internal mount options that are used for special handling of the real
- * mount options (eg. cannot be set during remount and have to be set during
- * transaction commit)
- */
-
-#define BTRFS_PENDING_SET_INODE_MAP_CACHE	(0)
-#define BTRFS_PENDING_CLEAR_INODE_MAP_CACHE	(1)
-#define BTRFS_PENDING_COMMIT			(2)
-
-#define btrfs_test_pending(info, opt)	\
-	test_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
-#define btrfs_set_pending(info, opt)	\
-	set_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
-#define btrfs_clear_pending(info, opt)	\
-	clear_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
-
-/*
- * Helpers for setting pending mount option changes.
- *
- * Expects corresponding macros
- * BTRFS_PENDING_SET_ and CLEAR_ + short mount option name
- */
-#define btrfs_set_pending_and_info(info, opt, fmt, args...)            \
-do {                                                                   \
-       if (!btrfs_raw_test_opt((info)->mount_opt, opt)) {              \
-               btrfs_info((info), fmt, ##args);                        \
-               btrfs_set_pending((info), SET_##opt);                   \
-               btrfs_clear_pending((info), CLEAR_##opt);               \
-       }                                                               \
-} while(0)
-
-#define btrfs_clear_pending_and_info(info, opt, fmt, args...)          \
-do {                                                                   \
-       if (btrfs_raw_test_opt((info)->mount_opt, opt)) {               \
-               btrfs_info((info), fmt, ##args);                        \
-               btrfs_set_pending((info), CLEAR_##opt);                 \
-               btrfs_clear_pending((info), SET_##opt);                 \
-       }                                                               \
-} while(0)
-
-/*
  * Inode flags
  */
 #define BTRFS_INODE_NODATASUM		(1 << 0)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c63419..2d3c8b7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2832,11 +2832,9 @@ retry_root_backup:
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
-	/*
-	 * Mount does not set all options immediatelly, we can do it now and do
-	 * not have to wait for transaction commit
-	 */
-	btrfs_apply_pending_changes(fs_info);
+	/* Set the real inode map cache flag */
+	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
+		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 74faea3..81efd83 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -178,7 +178,7 @@ static void start_caching(struct btrfs_root *root)
 			  root->root_key.objectid);
 	if (IS_ERR(tsk)) {
 		btrfs_warn(root->fs_info, "failed to start inode caching task");
-		btrfs_clear_pending_and_info(root->fs_info, INODE_MAP_CACHE,
+		btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
 				"disabling inode map caching");
 	}
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6f49b28..b0c45b2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -993,27 +993,9 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
-		if (PTR_ERR(trans) == -ENOENT) {
-			/*
-			 * Exit unless we have some pending changes
-			 * that need to go through commit
-			 */
-			if (fs_info->pending_changes == 0)
-				return 0;
-			/*
-			 * A non-blocking test if the fs is frozen. We must not
-			 * start a new transaction here otherwise a deadlock
-			 * happens. The pending operations are delayed to the
-			 * next commit after thawing.
-			 */
-			if (__sb_start_write(sb, SB_FREEZE_WRITE, false))
-				__sb_end_write(sb, SB_FREEZE_WRITE);
-			else
-				return 0;
-			trans = btrfs_start_transaction(root, 0);
-		}
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (PTR_ERR(trans) == -ENOENT)
+			return 0;
+		return PTR_ERR(trans);
 	}
 	return btrfs_commit_transaction(trans, root);
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 92db3f6..b2e7bb4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -111,6 +111,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(a);
+	struct btrfs_trans_handle *trans;
 	u64 features, set, clear;
 	unsigned long val;
 	int ret;
@@ -152,6 +153,10 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	btrfs_info(fs_info, "%s %s feature flag",
 		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
 
+	trans = btrfs_start_transaction(fs_info->fs_root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
 	spin_lock(&fs_info->super_lock);
 	features = get_features(fs_info, fa->feature_set);
 	if (val)
@@ -161,11 +166,9 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	set_features(fs_info, fa->feature_set, features);
 	spin_unlock(&fs_info->super_lock);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
+	if (ret)
+		return ret;
 
 	return count;
 }
@@ -369,6 +372,9 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 				 const char *buf, size_t len)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->fs_root;
+	int ret;
 	size_t p_len;
 
 	if (fs_info->sb->s_flags & MS_RDONLY)
@@ -383,18 +389,20 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
 
-	spin_lock(&fs_info->super_lock);
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	spin_lock(&root->fs_info->super_lock);
 	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
 	memcpy(fs_info->super_copy->label, buf, p_len);
-	spin_unlock(&fs_info->super_lock);
+	spin_unlock(&root->fs_info->super_lock);
+	ret = btrfs_commit_transaction(trans, root);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	if (!ret)
+		return len;
 
-	return len;
+	return ret;
 }
 BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e88b59d..295a135 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1938,10 +1938,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	/*
-	 * Since the transaction is done, we can apply the pending changes
-	 * before the next transaction.
+	 * Since the transaction is done, we should set the inode map cache flag
+	 * before any other comming transaction.
 	 */
-	btrfs_apply_pending_changes(root->fs_info);
+	if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
+		btrfs_set_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
+	else
+		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
 
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
@@ -2112,32 +2115,3 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 
 	return (ret < 0) ? 0 : 1;
 }
-
-void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
-{
-	unsigned long prev;
-	unsigned long bit;
-
-	prev = xchg(&fs_info->pending_changes, 0);
-	if (!prev)
-		return;
-
-	bit = 1 << BTRFS_PENDING_SET_INODE_MAP_CACHE;
-	if (prev & bit)
-		btrfs_set_opt(fs_info->mount_opt, INODE_MAP_CACHE);
-	prev &= ~bit;
-
-	bit = 1 << BTRFS_PENDING_CLEAR_INODE_MAP_CACHE;
-	if (prev & bit)
-		btrfs_clear_opt(fs_info->mount_opt, INODE_MAP_CACHE);
-	prev &= ~bit;
-
-	bit = 1 << BTRFS_PENDING_COMMIT;
-	if (prev & bit)
-		btrfs_debug(fs_info, "pending commit done");
-	prev &= ~bit;
-
-	if (prev)
-		btrfs_warn(fs_info,
-			"unknown pending changes left 0x%lx, ignoring", prev);
-}
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 00ed29c..fd400a3 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -170,6 +170,4 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 void btrfs_put_transaction(struct btrfs_transaction *transaction);
-void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info);
-
 #endif
-- 
2.2.2

