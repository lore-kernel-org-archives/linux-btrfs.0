Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39436 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761822AbbA2CZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:25:59 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T2PG4D026240
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 10:25:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND v4 5/8] btrfs: Use btrfs_test_trans_opt() to handle INODE_CACHE if it's under transaction protect.
Date: Thu, 29 Jan 2015 10:24:38 +0800
Message-ID: <1422498281-20493-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert btrfs_test_opt() to btrfs_test_trans_opt() if it's called under
transaction protection.

This will ensure SPACE_CACHE bit is consistent during transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            | 1 -
 fs/btrfs/disk-io.c          | 4 ----
 fs/btrfs/free-space-cache.c | 2 +-
 fs/btrfs/inode-map.c        | 5 +++--
 fs/btrfs/transaction.c      | 9 ---------
 5 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 26bb47b..fa04db9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2108,7 +2108,6 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
-#define	BTRFS_MOUNT_CHANGE_INODE_CACHE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2d3c8b7..f4d168d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2832,10 +2832,6 @@ retry_root_backup:
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
-	/* Set the real inode map cache flag */
-	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
-		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
-
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
 		ret = btrfsic_mount(tree_root, fs_devices,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d6c03f7..2b9cabf 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3348,7 +3348,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
 	int ret;
 
-	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
+	if (!btrfs_test_trans_opt(trans, INODE_MAP_CACHE))
 		return 0;
 
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, trans, path, 0);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 81efd83..49b089c 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -178,7 +178,8 @@ static void start_caching(struct btrfs_root *root)
 			  root->root_key.objectid);
 	if (IS_ERR(tsk)) {
 		btrfs_warn(root->fs_info, "failed to start inode caching task");
-		btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+		btrfs_clear_and_info(root->fs_info, root->fs_info->mount_opt,
+				INODE_MAP_CACHE,
 				"disabling inode map caching");
 	}
 }
@@ -405,7 +406,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	if (btrfs_root_refs(&root->root_item) == 0)
 		return 0;
 
-	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
+	if (!btrfs_test_trans_opt(trans, INODE_MAP_CACHE))
 		return 0;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aec5a5a..dd9e7af 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1939,15 +1939,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto scrub_continue;
 	}
 
-	/*
-	 * Since the transaction is done, we should set the inode map cache flag
-	 * before any other comming transaction.
-	 */
-	if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
-		btrfs_set_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
-	else
-		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
-
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
 	 */
-- 
2.2.2

