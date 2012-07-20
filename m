Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60924 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2GTRgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 13:36:38 -0400
Received: by yenl2 with SMTP id l2so4234455yen.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 10:36:38 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 1/2] Btrfs: Check INCOMPAT flags on remount with lzo compression
Date: Fri, 20 Jul 2012 12:36:20 -0500
Message-Id: <1342805781-12162-2-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
References: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In support of the recently added capability to remount with lzo
compression, check the compression INCOMPAT flags when remounting
with lzo compression, and set the flags if necessary.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/super.c |   21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0ee2f8..8bee032 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3094,6 +3094,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 /* super.c */
 int btrfs_parse_options(struct btrfs_root *root, char *options);
+void btrfs_chk_lzo_incompat(struct btrfs_root *root);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 26da344..4398fd2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -401,11 +401,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_chk_lzo_incompat(root);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				info->compress_type = BTRFS_COMPRESS_NONE;
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+				btrfs_clear_opt(info->mount_opt,
+						FORCE_COMPRESS);
 				compress_force = false;
 			} else {
 				ret = -EINVAL;
@@ -587,6 +589,23 @@ out:
 }
 
 /*
+ * Check the INCOMPAT features in the super block, and set the
+ * LZO INCOMPAT flag if it has not been set.
+ */
+void btrfs_chk_lzo_incompat(struct btrfs_root *root)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = root->fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (!(features & BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+}
+
+/*
  * Parse mount options that are required early in the mount process.
  *
  * All other options will be parsed on much later in the mount process and
-- 
1.7.8.6

