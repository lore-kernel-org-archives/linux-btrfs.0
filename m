From: Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: [PATCH] Btrfs: check return value for kthread_run() correctly
Date: Tue, 20 Jan 2009 00:28:44 +0800
Message-ID: <4974aa4d.0e0d6e0a.4824.5c2b@mx.google.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

kthread_run() returns the kthread or ERR_PTR(-ENOMEM), not NULL.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81a3138..f718d25 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1740,13 +1740,13 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
 					       "btrfs-cleaner");
-	if (!fs_info->cleaner_kthread)
+	if (IS_ERR(fs_info->cleaner_kthread))
 		goto fail_csum_root;
 
 	fs_info->transaction_kthread = kthread_run(transaction_kthread,
 						   tree_root,
 						   "btrfs-transaction");
-	if (!fs_info->transaction_kthread)
+	if (IS_ERR(fs_info->transaction_kthread))
 		goto fail_cleaner;
 
 	if (btrfs_super_log_root(disk_super) != 0) {

