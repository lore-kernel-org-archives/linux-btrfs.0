Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44103 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935084AbcCPIoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 04:44:19 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 5/5] btrfs: move error handling code together in ctree.h
Date: Wed, 16 Mar 2016 16:43:08 +0800
Message-Id: <1458117788-840-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like we added the incompatible defines in between the error
handling defines in the file ctree.h. Now group them back.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h | 78 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bb5a1114da7c..d5848b8b67be 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4295,6 +4295,46 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
 
+/*
+ * Call btrfs_abort_transaction as early as possible when an error condition is
+ * detected, that way the exact line number is reported.
+ */
+#define btrfs_abort_transaction(trans, root, errno)		\
+do {								\
+	/* Report first abort since mount */			\
+	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
+			&((root)->fs_info->fs_state))) {	\
+		WARN(1, KERN_DEBUG				\
+		"BTRFS: Transaction aborted (error %d)\n",	\
+		(errno));					\
+	}							\
+	__btrfs_abort_transaction((trans), (root), __func__,	\
+				  __LINE__, (errno));		\
+} while (0)
+
+#define btrfs_handle_fs_error(fs_info, errno, fmt, args...)		\
+do {								\
+	__btrfs_handle_fs_error((fs_info), __func__, __LINE__,	\
+			  (errno), fmt, ##args);		\
+} while (0)
+
+__printf(5, 6)
+__cold
+void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
+		   unsigned int line, int errno, const char *fmt, ...);
+/*
+ * If BTRFS_MOUNT_PANIC_ON_FATAL_ERROR is in mount_opt, __btrfs_panic
+ * will panic().  Otherwise we BUG() here.
+ */
+#define btrfs_panic(fs_info, errno, fmt, args...)			\
+do {									\
+	__btrfs_panic(fs_info, __func__, __LINE__, errno, fmt, ##args);	\
+	BUG();								\
+} while (0)
+
+
+/* compatibility and incompatibility defines */
+
 #define btrfs_set_fs_incompat(__fs_info, opt) \
 	__btrfs_set_fs_incompat((__fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
 
@@ -4411,44 +4451,6 @@ static inline int __btrfs_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag)
 	return !!(btrfs_super_compat_ro_flags(disk_super) & flag);
 }
 
-/*
- * Call btrfs_abort_transaction as early as possible when an error condition is
- * detected, that way the exact line number is reported.
- */
-#define btrfs_abort_transaction(trans, root, errno)		\
-do {								\
-	/* Report first abort since mount */			\
-	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
-			&((root)->fs_info->fs_state))) {	\
-		WARN(1, KERN_DEBUG				\
-		"BTRFS: Transaction aborted (error %d)\n",	\
-		(errno));					\
-	}							\
-	__btrfs_abort_transaction((trans), (root), __func__,	\
-				  __LINE__, (errno));		\
-} while (0)
-
-#define btrfs_handle_fs_error(fs_info, errno, fmt, args...)		\
-do {								\
-	__btrfs_handle_fs_error((fs_info), __func__, __LINE__,	\
-			  (errno), fmt, ##args);		\
-} while (0)
-
-__printf(5, 6)
-__cold
-void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
-		   unsigned int line, int errno, const char *fmt, ...);
-
-/*
- * If BTRFS_MOUNT_PANIC_ON_FATAL_ERROR is in mount_opt, __btrfs_panic
- * will panic().  Otherwise we BUG() here.
- */
-#define btrfs_panic(fs_info, errno, fmt, args...)			\
-do {									\
-	__btrfs_panic(fs_info, __func__, __LINE__, errno, fmt, ##args);	\
-	BUG();								\
-} while (0)
-
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type);
-- 
2.7.0

