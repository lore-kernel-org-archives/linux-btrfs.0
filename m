Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44595 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbbLVCSa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:18:30 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 5415941887C9
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:16:41 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 1/2] btrfs: Introduce new mount option backuproot to replace recovery
Date: Tue, 22 Dec 2015 10:16:35 +0800
Message-ID: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current "recovery" mount option will only try to use backup root.
However the word "recovery" is too generic and may be confusing for some
users.

Here introduce a new and more specific mount option, "backuproot" to
replace "recovery" mount option.
"Recovery" will be kept for compatibility reason, but will be
deprecated.

Also, since "backuproot" will only affect mount behavior and after
open_ctree() it has nothing to do with the filesystem, so clear the flag
after mount succeeded.

This provides the basis for later unified "norecovery" mount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v4:
  Newly introduced to avoid confusion with later 'norecovery' patch.
---
 Documentation/filesystems/btrfs.txt |  9 ++++++---
 fs/btrfs/ctree.h                    |  2 +-
 fs/btrfs/disk-io.c                  |  8 +++++++-
 fs/btrfs/super.c                    | 17 +++++++++++------
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index c772b47..cc84c63 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -168,10 +168,13 @@ Options with (*) are default options and will not show in the mount options.
   notreelog
 	Enable/disable the tree logging used for fsync and O_SYNC writes.
 
-  recovery
-	Enable autorecovery attempts if a bad tree root is found at mount time.
-	Currently this scans a list of several previous tree roots and tries to
+  backuproot
+	Enable attempts to use backup tree roots if a bad tree root is found at
+	mount time.
+	Currently this scans a list of 4 previous tree roots and tries to
 	use the first readable.
+	And since the mount option only affect mount behavior, it won't be
+	shown in mount options.
 
   rescan_uuid_tree
 	Force check and rebuild procedure of the UUID tree. This should not
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0165c6..0b3bff1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2176,7 +2176,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
-#define BTRFS_MOUNT_RECOVERY		(1 << 18)
+#define BTRFS_MOUNT_BACKUPROOT		(1 << 18)
 #define BTRFS_MOUNT_SKIP_BALANCE	(1 << 19)
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1eb0839..c0e953d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3102,6 +3102,12 @@ retry_root_backup:
 
 	fs_info->open = 1;
 
+	/*
+	 * backuproot only affect mount behavior, and if open_ctree succeeded,
+	 * no need to keep the flag
+	 */
+	btrfs_clear_opt(fs_info->mount_opt, BACKUPROOT);
+
 	return 0;
 
 fail_qgroup:
@@ -3156,7 +3162,7 @@ fail:
 	return err;
 
 recovery_tree_root:
-	if (!btrfs_test_opt(tree_root, RECOVERY))
+	if (!btrfs_test_opt(tree_root, BACKUPROOT))
 		goto fail_tree_roots;
 
 	free_root_pointers(fs_info, 0);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 24154e4..920f0cd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -302,7 +302,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog, Opt_noinode_cache,
+	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_backuproot,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -350,7 +350,8 @@ static match_table_t tokens = {
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_noinode_cache, "noinode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
-	{Opt_recovery, "recovery"},
+	{Opt_recovery, "recovery"}, /* deprecated */
+	{Opt_backuproot, "backuproot"},
 	{Opt_skip_balance, "skip_balance"},
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
@@ -657,8 +658,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					     "disabling auto defrag");
 			break;
 		case Opt_recovery:
-			btrfs_info(root->fs_info, "enabling auto recovery");
-			btrfs_set_opt(info->mount_opt, RECOVERY);
+			btrfs_warn(root->fs_info,
+				   "recovery is deprecated, use backuproot instead");
+		case Opt_backuproot:
+			btrfs_info(root->fs_info,
+				   "enabling backup root at mount time");
+			btrfs_set_opt(info->mount_opt, BACKUPROOT);
 			break;
 		case Opt_skip_balance:
 			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
@@ -1178,8 +1183,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",inode_cache");
 	if (btrfs_test_opt(root, SKIP_BALANCE))
 		seq_puts(seq, ",skip_balance");
-	if (btrfs_test_opt(root, RECOVERY))
-		seq_puts(seq, ",recovery");
+	if (btrfs_test_opt(root, BACKUPROOT))
+		seq_puts(seq, ",backuproot");
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	if (btrfs_test_opt(root, CHECK_INTEGRITY_INCLUDING_EXTENT_DATA))
 		seq_puts(seq, ",check_int_data");
-- 
2.6.4



