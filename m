Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaAMFgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 00:36:20 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: Add noinode_cache mount option
Date: Mon, 13 Jan 2014 13:36:06 +0800
Message-Id: <1389591367-23420-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add noinode_cache mount option for btrfs.

Since inode map cache involves all the btrfs_find_free_ino/return_ino
things and if just trigger the mount_opt,
an inode number get from inode map cache will not returned to inode map
cache.

To keep the find and return inode both in the same behavior,
a new bit in mount_opt, CHANGE_INODE_CACHE, is introduced for this idea.
CHANGE_INODE_CACHE is set/cleared in remounting, and the original
INODE_MAP_CACHE is set/cleared according to CHANGE_INODE_CACHE after a
success transaction.
Since find/return inode is all done between btrfs_start_transaction and
btrfs_commit_transaction, this will keep consistent behavior.

Also noinode_cache mount option will not stop the caching_kthread.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/disk-io.c     |  4 ++++
 fs/btrfs/super.c       | 10 ++++++++--
 fs/btrfs/transaction.c |  9 +++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3cebb4a..0a357ca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2022,6 +2022,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
+#define	BTRFS_MOUNT_CHANGE_INODE_CACHE	(1 << 24)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9850a51..629f411 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2776,6 +2776,10 @@ retry_root_backup:
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
 
+	/* Set the real inode map cache flag */
+	if (btrfs_test_opt(tree_root, CHANGE_INODE_CACHE))
+		btrfs_set_opt(tree_root->fs_info->mount_opt, INODE_MAP_CACHE);
+
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
 		ret = btrfsic_mount(tree_root, fs_devices,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 461e41c..d1012251 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -326,7 +326,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog,
+	Opt_datasum, Opt_treelog, Opt_noinode_cache,
 	Opt_err,
 };
 
@@ -369,6 +369,7 @@ static match_table_t tokens = {
 	{Opt_defrag, "autodefrag"},
 	{Opt_nodefrag, "noautodefrag"},
 	{Opt_inode_cache, "inode_cache"},
+	{Opt_noinode_cache, "noinode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
 	{Opt_skip_balance, "skip_balance"},
@@ -626,7 +627,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 		case Opt_inode_cache:
 			btrfs_info(root->fs_info, "enabling inode map caching");
-			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
+			btrfs_set_opt(info->mount_opt, CHANGE_INODE_CACHE);
+			break;
+		case Opt_noinode_cache:
+			if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
+				btrfs_info(root->fs_info, "disabling inode map caching");
+			btrfs_clear_opt(info->mount_opt, CHANGE_INODE_CACHE);
 			break;
 		case Opt_clear_cache:
 			btrfs_info(root->fs_info, "force clearing of disk cache");
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index da2ac4c..b5ef045 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1830,6 +1830,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
+	/*
+	 * Since the transaction is done, we should set the inode map cache flag
+	 * before any other comming transaction.
+	 */
+	if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
+		btrfs_set_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
+	else
+		btrfs_clear_opt(root->fs_info->mount_opt, INODE_MAP_CACHE);
+
 	/* commit_fs_roots gets rid of all the tree log roots, it is now
 	 * safe to free the root of tree log roots
 	 */
-- 
1.8.5.2

