Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33383 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbbLJCfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 21:35:31 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 534A241887CB
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 10:34:08 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] btrfs: Introduce new mount option to disable tree log replay
Date: Thu, 10 Dec 2015 10:34:06 +0800
Message-ID: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new mount option "nologreplay" to co-operate with "ro" mount
option to get real readonly mount, like "norecovery" in ext* and xfs.

Since the new parse_options() need to check new flags at remount time,
so add a new parameter for parse_options().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
v2:
  Make RO check mandatory for btrfs_parse_options().
  Add btrfs_show_options() support for nologreplay.

  Document for btrfs-mount(5) will follow after the patch being merged.
v3:
  Apply the document suggestion from  Chandan Rajendra.
---
 Documentation/filesystems/btrfs.txt |  9 +++++++++
 fs/btrfs/ctree.h                    |  4 +++-
 fs/btrfs/disk-io.c                  |  7 ++++---
 fs/btrfs/super.c                    | 29 +++++++++++++++++++++++++----
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index c772b47..0f2ed48 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -168,6 +168,15 @@ Options with (*) are default options and will not show in the mount options.
   notreelog
 	Enable/disable the tree logging used for fsync and O_SYNC writes.
 
+  nologreplay
+	Disable the log tree replay at mount time to prevent filesystem
+	from getting modified.
+	Must be used with 'ro' mount option.
+	A filesystem mounted with the 'nologreplay' option cannot
+	transition to a read-write mount via remount,rw - the filesystem
+	must be unmounted and mounted back again if read-write access is
+	desired.
+
   recovery
 	Enable autorecovery attempts if a bad tree root is found at mount time.
 	Currently this scans a list of several previous tree roots and tries to
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0165c6..c54ff25 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2184,6 +2184,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
 #define BTRFS_MOUNT_FRAGMENT_DATA	(1 << 24)
 #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
+#define BTRFS_MOUNT_NOLOGREPLAY		(1 << 26)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(8192)
@@ -4070,7 +4071,8 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 /* super.c */
-int btrfs_parse_options(struct btrfs_root *root, char *options);
+int btrfs_parse_options(struct btrfs_root *root, char *options,
+			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
 #ifdef CONFIG_PRINTK
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1eb0839..617bf4f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2711,7 +2711,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
-	ret = btrfs_parse_options(tree_root, options);
+	ret = btrfs_parse_options(tree_root, options, sb->s_flags);
 	if (ret) {
 		err = ret;
 		goto fail_alloc;
@@ -3009,8 +3009,9 @@ retry_root_backup:
 	if (ret)
 		goto fail_trans_kthread;
 
-	/* do not make disk changes in broken FS */
-	if (btrfs_super_log_root(disk_super) != 0) {
+	/* do not make disk changes in broken FS or nologreplay is given */
+	if (btrfs_super_log_root(disk_super) != 0 &&
+	    !btrfs_test_opt(tree_root, NOLOGREPLAY)) {
 		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
 			err = ret;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 24154e4..55989cb 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -302,7 +302,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum, Opt_treelog, Opt_noinode_cache,
+	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_nologreplay,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -334,6 +334,7 @@ static match_table_t tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_treelog, "treelog"},
+	{Opt_nologreplay, "nologreplay"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
@@ -371,7 +372,8 @@ static match_table_t tokens = {
  * reading in a new superblock is parsed here.
  * XXX JDM: This needs to be cleaned up for remount.
  */
-int btrfs_parse_options(struct btrfs_root *root, char *options)
+int btrfs_parse_options(struct btrfs_root *root, char *options,
+			unsigned long new_flags)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
@@ -386,8 +388,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	if (cache_gen)
 		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 
+	/*
+	 * Even the options are empty, we still need to do extra check
+	 * against new flags
+	 */
 	if (!options)
-		goto out;
+		goto check;
 
 	/*
 	 * strsep changes the string, duplicate it because parse_options
@@ -587,6 +593,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_clear_and_info(root, NOTREELOG,
 					     "enabling tree log");
 			break;
+		case Opt_nologreplay:
+			btrfs_set_and_info(root, NOLOGREPLAY,
+					   "disabling log replay at mount time");
+			break;
 		case Opt_flushoncommit:
 			btrfs_set_and_info(root, FLUSHONCOMMIT,
 					   "turning on flush-on-commit");
@@ -753,6 +763,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 		}
 	}
+check:
+	/*
+	 * Extra check for current option against current flag
+	 */
+	if (btrfs_test_opt(root, NOLOGREPLAY) && !(new_flags & MS_RDONLY)) {
+		btrfs_err(root->fs_info,
+			  "nologreplay must be used with ro mount option");
+		ret = -EINVAL;
+	}
 out:
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
 		btrfs_info(root->fs_info, "disk space caching is enabled");
@@ -1154,6 +1173,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",ssd");
 	if (btrfs_test_opt(root, NOTREELOG))
 		seq_puts(seq, ",notreelog");
+	if (btrfs_test_opt(root, NOLOGREPLAY))
+		seq_puts(seq, ",nologreplay");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
 	if (btrfs_test_opt(root, DISCARD))
@@ -1637,7 +1658,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 
-	ret = btrfs_parse_options(root, data);
+	ret = btrfs_parse_options(root, data, *flags);
 	if (ret) {
 		ret = -EINVAL;
 		goto restore;
-- 
2.6.3



