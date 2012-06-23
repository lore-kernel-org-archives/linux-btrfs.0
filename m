Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54948 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2FWU1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 16:27:42 -0400
Received: by qabj40 with SMTP id j40so564432qab.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 13:27:41 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 2/5] btrfs: lz4: add incompat flags and compression types
Date: Sat, 23 Jun 2012 16:21:56 -0400
Message-Id: <1340482916-10359-1-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340438748-348-3-git-send-email-andrew.mahone@gmail.com>
References: <1340438748-348-3-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/ctree.h   | 16 ++++++++++++----
 fs/btrfs/disk-io.c |  4 ++++
 fs/btrfs/ioctl.c   |  5 +++++
 fs/btrfs/super.c   | 22 +++++++++++++++++++++-
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..6d59831 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -478,7 +478,12 @@ struct btrfs_super_block {
  * Note we don't actually support it, we're just reserving the
  * number
  */
-#define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZOv2	(1ULL << 4)
+/*
+ * This covers adding LZ4 in real-time and high-compression modes
+ *
+ * TODO: cover also the other container formats
+ */
+#define BTRFS_FEATURE_INCOMPAT_COMPRESSION_LZ4	(1ULL << 4)
 
 /*
  * older kernels tried to do bigger metadata blocks, but the
@@ -492,8 +497,9 @@ struct btrfs_super_block {
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_BIG_METADATA |		\
-	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
+	 BTRFS_FEATURE_INCOMPAT_COMPRESSION_LZ4)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -649,8 +655,10 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_COMPRESS_LZ4   = 3,
+	BTRFS_COMPRESS_LZ4HC = 4,
+	BTRFS_COMPRESS_TYPES = 5,
+	BTRFS_COMPRESS_LAST  = 5,
 };
 
 struct btrfs_inode_item {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7b845ff..20f7632 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2121,6 +2121,10 @@ int open_ctree(struct super_block *sb,
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZ4)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_LZ4;
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZ4HC)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_LZ4;
 
 	/*
 	 * flag our filesystem as having big metadata blocks if
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9ec23b9..3eb2290 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1245,6 +1245,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 		btrfs_set_super_incompat_flags(disk_super, features);
 	}
+	if (range->compress_type == BTRFS_COMPRESS_LZ4 ||
+	    range->compress_type == BTRFS_COMPRESS_LZ4HC) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESSION_LZ4;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
 
 	ret = defrag_count;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 23fc7e8..5824886 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -401,6 +401,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+			} else if (strcmp(args[0].from, "lz4") == 0) {
+				compress_type = "lz4";
+				info->compress_type = BTRFS_COMPRESS_LZ4;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				/* remove when implemented */
+				ret = -EINVAL;
+				goto out;
+			} else if (strcmp(args[0].from, "lz4hc") == 0) {
+				compress_type = "lz4hc";
+				info->compress_type = BTRFS_COMPRESS_LZ4HC;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				/* remove when implemented */
+				ret = -EINVAL;
+				goto out;
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				info->compress_type = BTRFS_COMPRESS_NONE;
@@ -856,8 +870,14 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
-		else
+		else if (info->compress_type == BTRFS_COMPRESS_LZ4)
+			compress_type = "lz4";
+		else if (info->compress_type == BTRFS_COMPRESS_LZ4HC)
+			compress_type = "lz4hc";
+		else if (info->compress_type == BTRFS_COMPRESS_LZO)
 			compress_type = "lzo";
+		else
+			compress_type = "none";
 		if (btrfs_test_opt(root, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
-- 
1.7.11

