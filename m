Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaAMFgW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 00:36:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0D5ZFbU013746
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 13:35:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Cleanup the btrfs_parse_options for remount.
Date: Mon, 13 Jan 2014 13:36:07 +0800
Message-Id: <1389591367-23420-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1389591367-23420-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1389591367-23420-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since remount will pending the new mount options to the original mount
options, which will make btrfs_parse_options check the old options then
new options, causing some stupid output like "enabling XXX" following by
"disable XXX".

This patch will add extra check before every btrfs_info to skip the
output from old options checking.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 137 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 77 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d1012251..fc3fae9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -382,6 +382,20 @@ static match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
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
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
@@ -397,6 +411,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	int ret = 0;
 	char *compress_type;
 	bool compress_force = false;
+	bool compress = false;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
@@ -436,24 +451,28 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			 */
 			break;
 		case Opt_nodatasum:
-			btrfs_info(root->fs_info, "setting nodatasum");
-			btrfs_set_opt(info->mount_opt, NODATASUM);
+			btrfs_set_and_info(root, NODATASUM,
+					   "setting nodatasum");
 			break;
 		case Opt_datasum:
-			if (btrfs_test_opt(root, NODATACOW))
-				btrfs_info(root->fs_info, "setting datasum, datacow enabled");
-			else
-				btrfs_info(root->fs_info, "setting datasum");
+			if (btrfs_test_opt(root, NODATASUM)) {
+				if (btrfs_test_opt(root, NODATACOW))
+					btrfs_info(root->fs_info, "setting datasum, datacow enabled");
+				else
+					btrfs_info(root->fs_info, "setting datasum");
+			}
 			btrfs_clear_opt(info->mount_opt, NODATACOW);
 			btrfs_clear_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
-			if (!btrfs_test_opt(root, COMPRESS) ||
-				!btrfs_test_opt(root, FORCE_COMPRESS)) {
+			if (!btrfs_test_opt(root, NODATACOW)) {
+				if (!btrfs_test_opt(root, COMPRESS) ||
+				    !btrfs_test_opt(root, FORCE_COMPRESS)) {
 					btrfs_info(root->fs_info,
-						"setting nodatacow, compression disabled");
-			} else {
-				btrfs_info(root->fs_info, "setting nodatacow");
+						   "setting nodatacow, compression disabled");
+				} else {
+					btrfs_info(root->fs_info, "setting nodatacow");
+				}
 			}
 			btrfs_clear_opt(info->mount_opt, COMPRESS);
 			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
@@ -461,9 +480,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_datacow:
-			if (btrfs_test_opt(root, NODATACOW))
-				btrfs_info(root->fs_info, "setting datacow");
-			btrfs_clear_opt(info->mount_opt, NODATACOW);
+			btrfs_clear_and_info(root, NODATACOW,
+					     "setting datacow");
 			break;
 		case Opt_compress_force:
 		case Opt_compress_force_type:
@@ -471,6 +489,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			/* Fallthrough */
 		case Opt_compress:
 		case Opt_compress_type:
+			compress = true;
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strcmp(args[0].from, "zlib") == 0) {
@@ -497,37 +516,36 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 
 			if (compress_force) {
-				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
-				btrfs_info(root->fs_info, "force %s compression",
-					compress_type);
-			} else if (btrfs_test_opt(root, COMPRESS)) {
-				pr_info("btrfs: use %s compression\n",
-					compress_type);
+				btrfs_set_and_info(root, FORCE_COMPRESS,
+						   "force %s compression",
+						   compress_type);
+			} else if (compress) {
+				if (!btrfs_test_opt(root, COMPRESS))
+					btrfs_info(root->fs_info,
+						   "btrfs: use %s compression\n",
+						   compress_type);
 			}
 			break;
 		case Opt_ssd:
-			btrfs_info(root->fs_info, "use ssd allocation scheme");
-			btrfs_set_opt(info->mount_opt, SSD);
+			btrfs_set_and_info(root, SSD,
+					   "use ssd allocation scheme");
 			break;
 		case Opt_ssd_spread:
-			btrfs_info(root->fs_info, "use spread ssd allocation scheme");
-			btrfs_set_opt(info->mount_opt, SSD);
-			btrfs_set_opt(info->mount_opt, SSD_SPREAD);
+			btrfs_set_and_info(root, SSD_SPREAD,
+					   "use spread ssd allocation scheme");
 			break;
 		case Opt_nossd:
-			btrfs_info(root->fs_info, "not using ssd allocation scheme");
-			btrfs_set_opt(info->mount_opt, NOSSD);
+			btrfs_clear_and_info(root, NOSSD,
+					     "not using ssd allocation scheme");
 			btrfs_clear_opt(info->mount_opt, SSD);
-			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_barrier:
-			if (btrfs_test_opt(root, NOBARRIER))
-				btrfs_info(root->fs_info, "turning on barriers");
-			btrfs_clear_opt(info->mount_opt, NOBARRIER);
+			btrfs_clear_and_info(root, NOBARRIER,
+					     "turning on barriers");
 			break;
 		case Opt_nobarrier:
-			btrfs_info(root->fs_info, "turning off barriers");
-			btrfs_set_opt(info->mount_opt, NOBARRIER);
+			btrfs_set_and_info(root, NOBARRIER,
+					   "turning off barriers");
 			break;
 		case Opt_thread_pool:
 			ret = match_int(&args[0], &intarg);
@@ -579,22 +597,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
 		case Opt_notreelog:
-			btrfs_info(root->fs_info, "disabling tree log");
-			btrfs_set_opt(info->mount_opt, NOTREELOG);
+			btrfs_set_and_info(root, NOTREELOG,
+					   "disabling tree log");
 			break;
 		case Opt_treelog:
-			if (btrfs_test_opt(root, NOTREELOG))
-				btrfs_info(root->fs_info, "enabling tree log");
-			btrfs_clear_opt(info->mount_opt, NOTREELOG);
+			btrfs_clear_and_info(root, NOTREELOG,
+					     "enabling tree log");
 			break;
 		case Opt_flushoncommit:
-			btrfs_info(root->fs_info, "turning on flush-on-commit");
-			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
+			btrfs_set_and_info(root, FLUSHONCOMMIT,
+					   "turning on flush-on-commit");
 			break;
 		case Opt_noflushoncommit:
-			if (btrfs_test_opt(root, FLUSHONCOMMIT))
-				btrfs_info(root->fs_info, "turning off flush-on-commit");
-			btrfs_clear_opt(info->mount_opt, FLUSHONCOMMIT);
+			btrfs_clear_and_info(root, FLUSHONCOMMIT,
+					     "turning off flush-on-commit");
 			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
@@ -610,33 +626,35 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 			break;
 		case Opt_discard:
-			btrfs_set_opt(info->mount_opt, DISCARD);
+			btrfs_set_and_info(root, DISCARD,
+					   "turning on discard");
 			break;
 		case Opt_nodiscard:
-			btrfs_clear_opt(info->mount_opt, DISCARD);
+			btrfs_clear_and_info(root, DISCARD,
+					     "turning off discard");
 			break;
 		case Opt_space_cache:
-			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
+			btrfs_set_and_info(root, SPACE_CACHE,
+					   "enabling disk space caching");
 			break;
 		case Opt_rescan_uuid_tree:
 			btrfs_set_opt(info->mount_opt, RESCAN_UUID_TREE);
 			break;
 		case Opt_no_space_cache:
-			btrfs_info(root->fs_info, "disabling disk space caching");
-			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
+			btrfs_clear_and_info(root, SPACE_CACHE,
+					     "disabling disk space caching");
 			break;
 		case Opt_inode_cache:
-			btrfs_info(root->fs_info, "enabling inode map caching");
-			btrfs_set_opt(info->mount_opt, CHANGE_INODE_CACHE);
+			btrfs_set_and_info(root, CHANGE_INODE_CACHE,
+					   "enabling inode map caching");
 			break;
 		case Opt_noinode_cache:
-			if (btrfs_test_opt(root, CHANGE_INODE_CACHE))
-				btrfs_info(root->fs_info, "disabling inode map caching");
-			btrfs_clear_opt(info->mount_opt, CHANGE_INODE_CACHE);
+			btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+					     "disabling inode map caching");
 			break;
 		case Opt_clear_cache:
-			btrfs_info(root->fs_info, "force clearing of disk cache");
-			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
+			btrfs_set_and_info(root, CLEAR_CACHE,
+					   "force clearing of disk cache");
 			break;
 		case Opt_user_subvol_rm_allowed:
 			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
@@ -648,13 +666,12 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_clear_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			btrfs_info(root->fs_info, "enabling auto defrag");
-			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
+			btrfs_set_and_info(root, AUTO_DEFRAG,
+					   "enabling auto defrag");
 			break;
 		case Opt_nodefrag:
-			if (btrfs_test_opt(root, AUTO_DEFRAG))
-				btrfs_info(root->fs_info, "disabling auto defrag");
-			btrfs_clear_opt(info->mount_opt, AUTO_DEFRAG);
+			btrfs_clear_and_info(root, AUTO_DEFRAG,
+					     "disabling auto defrag");
 			break;
 		case Opt_recovery:
 			btrfs_info(root->fs_info, "enabling auto recovery");
-- 
1.8.5.2

