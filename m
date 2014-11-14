Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbaKNKdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DE59CACFC
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 10:33:04 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] btrfs: add support for processing pending changes
Date: Fri, 14 Nov 2014 11:33:04 +0100
Message-Id: <572d9ab7845ea0e043ec34cd733a75228130ad03.1415894837.git.dsterba@suse.cz>
In-Reply-To: <cover.1415894837.git.dsterba@suse.cz>
References: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some actions that modify global filesystem state but cannot be
performed at the time of request, but later at the transaction commit
time when the filesystem is in a known state.

For example enabling new incompat features on-the-fly or issuing
transaction commit from unsafe contexts (sysfs handlers).

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.c     |  6 ++++++
 fs/btrfs/transaction.c | 16 ++++++++++++++++
 fs/btrfs/transaction.h |  2 ++
 4 files changed, 69 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fe69edda11fb..f30b061ef77d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1402,6 +1402,11 @@ struct btrfs_fs_info {
 	 */
 	u64 last_trans_log_full_commit;
 	unsigned long mount_opt;
+	/*
+	 * Track requests for actions that need to be done during transaction
+	 * commit (like for some mount options).
+	 */
+	unsigned long pending_changes;
 	unsigned long compress_type:4;
 	int commit_interval;
 	/*
@@ -2103,6 +2108,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
 #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
 					 BTRFS_MOUNT_##opt)
+
 #define btrfs_set_and_info(root, opt, fmt, args...)			\
 {									\
 	if (!btrfs_test_opt(root, opt))					\
@@ -2118,6 +2124,45 @@ struct btrfs_ioctl_defrag_range_args {
 }
 
 /*
+ * Requests for changes that need to be done during transaction commit.
+ *
+ * Internal mount options that are used for special handling of the real
+ * mount options (eg. cannot be set during remount and have to be set during
+ * transaction commit)
+ */
+
+#define btrfs_test_pending(info, opt)	\
+	test_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
+#define btrfs_set_pending(info, opt)	\
+	set_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
+#define btrfs_clear_pending(info, opt)	\
+	clear_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
+
+/*
+ * Helpers for setting pending mount option changes.
+ *
+ * Expects corresponding macros
+ * BTRFS_PENDING_SET_ and CLEAR_ + short mount option name
+ */
+#define btrfs_set_pending_and_info(info, opt, fmt, args...)            \
+do {                                                                   \
+       if (!btrfs_raw_test_opt((info)->mount_opt, opt)) {              \
+               btrfs_info((info), fmt, ##args);                        \
+               btrfs_set_pending((info), SET_##opt);                   \
+               btrfs_clear_pending((info), CLEAR_##opt);               \
+       }                                                               \
+} while(0)
+
+#define btrfs_clear_pending_and_info(info, opt, fmt, args...)          \
+do {                                                                   \
+       if (btrfs_raw_test_opt((info)->mount_opt, opt)) {               \
+               btrfs_info((info), fmt, ##args);                        \
+               btrfs_set_pending((info), CLEAR_##opt);                 \
+               btrfs_clear_pending((info), SET_##opt);                 \
+       }                                                               \
+} while(0)
+
+/*
  * Inode flags
  */
 #define BTRFS_INODE_NODATASUM		(1 << 0)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1bf9f897065d..fd80c0d98421 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2834,6 +2834,12 @@ retry_root_backup:
 	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
 		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
 
+	/*
+	 * Mount does not set all options immediatelly, we can do it now and do
+	 * not have to wait for transaction commit
+	 */
+	btrfs_apply_pending_changes(fs_info);
+
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
 		ret = btrfsic_mount(tree_root, fs_devices,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dcaae3616728..7a4024a55e5c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1850,6 +1850,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	else
 		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
 
+	btrfs_apply_pending_changes(root->fs_info);
+
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
 	 */
@@ -2019,3 +2021,17 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 
 	return (ret < 0) ? 0 : 1;
 }
+
+void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
+{
+	unsigned long prev;
+	unsigned long bit;
+
+	prev = cmpxchg(&fs_info->pending_changes, 0, 0);
+	if (!prev)
+		return;
+
+	if (prev)
+		btrfs_warn(fs_info,
+			"unknown pending changes left 0x%lx, ignoring", prev);
+}
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8f40e1a5d2d..75ebcfce9d57 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -170,4 +170,6 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
 void btrfs_put_transaction(struct btrfs_transaction *transaction);
+void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info);
+
 #endif
-- 
1.8.4.5

