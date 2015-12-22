Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41182 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbbLVCSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:18:31 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 2303941887CB
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 10:16:42 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 2/2] btrfs: Introduce new mount option to disable tree log replay
Date: Tue, 22 Dec 2015 10:16:36 +0800
Message-ID: <1450750596-14627-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1450750596-14627-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v4:
  Add 'norecovery' alias for 'nologreplay'.
---
 Documentation/filesystems/btrfs.txt |  9 +++++++++
 fs/btrfs/ctree.h                    |  4 +++-
 fs/btrfs/disk-io.c                  |  7 ++++---
 fs/btrfs/super.c                    | 30 +++++++++++++++++++++++++++---
 4 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index cc84c63..78d584a 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -168,6 +168,15 @@ Options with (*) are default options and will not show in the mount options.
   notreelog
 	Enable/disable the tree logging used for fsync and O_SYNC writes.
 
+  norecovery
+  nologreplay
+	Disable the log tree replay at mount time to prevent filesystem
+	from getting modified.
+	Must be used with 'ro' mount option.
+	A filesystem mounted with this option cannot transition to a
+	read-write mount via remount,rw - the filesystem must be unmounted
+	and mounted back again if read-write access is desired.
+
   backuproot
 	Enable attempts to use backup tree roots if a bad tree root is found at
 	mount time.
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b3bff1..4c23f34 100644
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
index c0e953d..b213439 100644
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
index 920f0cd..29fce48 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -303,6 +303,7 @@ enum {
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_backuproot,
+	Opt_norecovery, Opt_nologreplay,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -334,6 +335,8 @@ static match_table_t tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_treelog, "treelog"},
+	{Opt_norecovery, "norecovery"},
+	{Opt_nologreplay, "nologreplay"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
@@ -372,7 +375,8 @@ static match_table_t tokens = {
  * reading in a new superblock is parsed here.
  * XXX JDM: This needs to be cleaned up for remount.
  */
-int btrfs_parse_options(struct btrfs_root *root, char *options)
+int btrfs_parse_options(struct btrfs_root *root, char *options,
+			unsigned long new_flags)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
@@ -387,8 +391,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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
@@ -588,6 +596,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_clear_and_info(root, NOTREELOG,
 					     "enabling tree log");
 			break;
+		case Opt_nologreplay:
+		case Opt_norecovery:
+			btrfs_set_and_info(root, NOLOGREPLAY,
+					   "disabling log replay at mount time");
+			break;
 		case Opt_flushoncommit:
 			btrfs_set_and_info(root, FLUSHONCOMMIT,
 					   "turning on flush-on-commit");
@@ -758,6 +771,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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
@@ -1159,6 +1181,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",ssd");
 	if (btrfs_test_opt(root, NOTREELOG))
 		seq_puts(seq, ",notreelog");
+	if (btrfs_test_opt(root, NOLOGREPLAY))
+		seq_puts(seq, ",nologreplay");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
 	if (btrfs_test_opt(root, DISCARD))
@@ -1642,7 +1666,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 	}
 
-	ret = btrfs_parse_options(root, data);
+	ret = btrfs_parse_options(root, data, *flags);
 	if (ret) {
 		ret = -EINVAL;
 		goto restore;
-- 
2.6.4



