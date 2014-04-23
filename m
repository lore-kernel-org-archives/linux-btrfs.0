Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbaDWLg4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 07:36:56 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3NBaeWw001609
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 19:36:40 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs: move btrfs_{set,clear}_and_info() to ctree.h
Date: Wed, 23 Apr 2014 19:33:33 +0800
Message-ID: <1398252816-30600-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 14 ++++++++++++++
 fs/btrfs/super.c | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ad1a594..e7c9e1c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2058,6 +2058,20 @@ struct btrfs_ioctl_defrag_range_args {
 #define btrfs_raw_test_opt(o, opt)	((o) & BTRFS_MOUNT_##opt)
 #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
 					 BTRFS_MOUNT_##opt)
+#define btrfs_set_and_info(root, opt, fmt, args...)			\
+{									\
+	if (!btrfs_test_opt(root, opt))					\
+		btrfs_info(root->fs_info, fmt, ##args);			\
+	btrfs_set_opt(root->fs_info->mount_opt, opt);			\
+}
+
+#define btrfs_clear_and_info(root, opt, fmt, args...)			\
+{									\
+	if (btrfs_test_opt(root, opt))					\
+		btrfs_info(root->fs_info, fmt, ##args);			\
+	btrfs_clear_opt(root->fs_info->mount_opt, opt);			\
+}
+
 /*
  * Inode flags
  */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 994c409..6696980 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -385,20 +385,6 @@ static match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
-#define btrfs_set_and_info(root, opt, fmt, args...)			\
-{									\
-	if (!btrfs_test_opt(root, opt))					\
-		btrfs_info(root->fs_info, fmt, ##args);			\
-	btrfs_set_opt(root->fs_info->mount_opt, opt);			\
-}
-
-#define btrfs_clear_and_info(root, opt, fmt, args...)			\
-{									\
-	if (btrfs_test_opt(root, opt))					\
-		btrfs_info(root->fs_info, fmt, ##args);			\
-	btrfs_clear_opt(root->fs_info->mount_opt, opt);			\
-}
-
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
-- 
1.9.0

