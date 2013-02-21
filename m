Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab3BUGcG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 01:32:06 -0500
Message-ID: <5125BF94.60501@cn.fujitsu.com>
Date: Thu, 21 Feb 2013 14:32:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH V2] Btrfs: fix remount vs autodefrag
References: <50B32FE7.5080908@cn.fujitsu.com> <50B3362D.1030409@cn.fujitsu.com> <20121214175106.GH3152@localhost.localdomain> <50CEC8C5.8010201@cn.fujitsu.com> <20121218133846.GA2403@localhost.localdomain>
In-Reply-To: <20121218133846.GA2403@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we remount the fs to close the auto defragment or make the fs R/O,
we should stop the auto defragment.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- don't use ->s_umount to avoid R/W->R/O remounting during the defragment.
  Instead We add a new state that tell thedefragger the fs is under remount,
  then the defragger pauses.
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/file.c  |  5 +++++
 fs/btrfs/super.c | 40 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1679051..b355bb4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -339,6 +339,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
  * File system states
  */
 #define BTRFS_FS_STATE_ERROR		0
+#define BTRFS_FS_STATE_REMOUNTING	1
 
 /* Super block flags */
 /* Errors detected */
@@ -1864,6 +1865,7 @@ struct btrfs_ioctl_defrag_range_args {
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
+#define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
 #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 /*
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b12ba52..32b5cff 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -374,6 +374,11 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 
 	atomic_inc(&fs_info->defrag_running);
 	while(1) {
+		/* Pause the auto defragger. */
+		if (test_bit(BTRFS_FS_STATE_REMOUNTING,
+			     &fs_info->fs_state))
+			break;
+
 		if (!__need_auto_defrag(fs_info->tree_root))
 			break;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db1ba9a..68a29a1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1202,6 +1202,38 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 			      new_pool_size);
 }
 
+static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info,
+					 unsigned long old_opts, int flags)
+{
+	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+
+	if (btrfs_raw_test_opt(old_opts, AUTO_DEFRAG) &&
+	    (!btrfs_raw_test_opt(fs_info->mount_opt, AUTO_DEFRAG) ||
+	     (flags & MS_RDONLY))) {
+		/* wait for any defraggers to finish */
+		wait_event(fs_info->transaction_wait,
+			   (atomic_read(&fs_info->defrag_running) == 0));
+		if (flags & MS_RDONLY)
+			sync_filesystem(fs_info->sb);
+	}
+}
+
+static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
+					 unsigned long old_opts)
+{
+	/*
+	 * We need cleanup all defragable inodes if the autodefragment is
+	 * close or the fs is R/O.
+	 */
+	if (btrfs_raw_test_opt(old_opts, AUTO_DEFRAG) &&
+	    (!btrfs_raw_test_opt(fs_info->mount_opt, AUTO_DEFRAG) ||
+	     (fs_info->sb->s_flags & MS_RDONLY))) {
+		btrfs_cleanup_defrag_inodes(fs_info);
+	}
+
+	clear_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+}
+
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
@@ -1215,6 +1247,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
 
+	btrfs_remount_prepare(fs_info, old_opts, *flags);
+
 	ret = btrfs_parse_options(root, data);
 	if (ret) {
 		ret = -EINVAL;
@@ -1225,7 +1259,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		fs_info->thread_pool_size, old_thread_pool_size);
 
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
-		return 0;
+		goto out;
 
 	if (*flags & MS_RDONLY) {
 		/*
@@ -1280,7 +1314,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 		sb->s_flags &= ~MS_RDONLY;
 	}
-
+out:
+	btrfs_remount_cleanup(fs_info, old_opts);
 	return 0;
 
 restore:
@@ -1297,6 +1332,7 @@ restore:
 	btrfs_resize_thread_pool(fs_info,
 		old_thread_pool_size, fs_info->thread_pool_size);
 	fs_info->metadata_ratio = old_metadata_ratio;
+	btrfs_remount_cleanup(fs_info, old_opts);
 	return ret;
 }
 
-- 
1.7.11.7

