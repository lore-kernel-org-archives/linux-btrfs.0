Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9150 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754445AbbAWJdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:33:50 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <miaoxie@huawei.com>
Subject: [PATCH RFC v3 2/5] btrfs: Make btrfs_parse_options() parse mount option in a atomic way
Date: Fri, 23 Jan 2015 17:31:42 +0800
Message-ID: <1422005505-9472-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs_parse_options() is not atomic, which can set and clear a
bit, especially for nospace_cache case.

For example, if a fs is mounted with nospace_cache,
btrfs_parse_options() will set SPACE_CACHE bit first(since
cache_generation is non-zeo) and clear the SPACE_CACHE bit due to
nospace_cache mount option.
So under heavy operations and remount a nospace_cache btrfs, there is a
windows for commit to create space cache.

This bug can be reproduced by fstest/btrfs/071 073 074 with
nospace_cache mount option. It has about 50% chance to create space
cache, and about 10% chance to create wrong space cache, which can't
pass btrfsck.

This patch will do the mount option parse in a copy-and-update method.
First copy the mount_opt from fs_info to new_opt, and only update
options in new_opt. At last, copy the new_opt back to
fs_info->mount_opt.

This patch is already good enough to fix the above nospace_cache +
remount bug, but need later patch to make sure mount options does not
change during transaction.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     |  16 +++----
 fs/btrfs/inode-map.c |   3 +-
 fs/btrfs/super.c     | 115 +++++++++++++++++++++++++++------------------------
 3 files changed, 71 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5f99743..26bb47b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2119,18 +2119,18 @@ struct btrfs_ioctl_defrag_range_args {
 #define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 
-#define btrfs_set_and_info(root, opt, fmt, args...)			\
+#define btrfs_set_and_info(fs_info, val, opt, fmt, args...)		\
 {									\
-	if (!btrfs_test_opt(root, opt))					\
-		btrfs_info(root->fs_info, fmt, ##args);			\
-	btrfs_set_opt(root->fs_info->mount_opt, opt);			\
+	if (!btrfs_raw_test_opt(val, opt))				\
+		btrfs_info(fs_info, fmt, ##args);			\
+	btrfs_set_opt(val, opt);					\
 }
 
-#define btrfs_clear_and_info(root, opt, fmt, args...)			\
+#define btrfs_clear_and_info(fs_info, val, opt, fmt, args...)		\
 {									\
-	if (btrfs_test_opt(root, opt))					\
-		btrfs_info(root->fs_info, fmt, ##args);			\
-	btrfs_clear_opt(root->fs_info->mount_opt, opt);			\
+	if (btrfs_raw_test_opt(val, opt))				\
+		btrfs_info(fs_info, fmt, ##args);			\
+	btrfs_clear_opt(val, opt);					\
 }
 
 /*
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 81efd83..d1edab5 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -178,7 +178,8 @@ static void start_caching(struct btrfs_root *root)
 			  root->root_key.objectid);
 	if (IS_ERR(tsk)) {
 		btrfs_warn(root->fs_info, "failed to start inode caching task");
-		btrfs_clear_and_info(root, CHANGE_INODE_CACHE,
+		btrfs_clear_and_info(root->fs_info, root->fs_info->mount_opt,
+				CHANGE_INODE_CACHE,
 				"disabling inode map caching");
 	}
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b0c45b2..490fe1f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -395,10 +395,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	int ret = 0;
 	char *compress_type;
 	bool compress_force = false;
+	unsigned long new_opt;
+
+	new_opt = info->mount_opt;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
-		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
+		btrfs_set_opt(new_opt, SPACE_CACHE);
 
 	if (!options)
 		goto out;
@@ -422,7 +425,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		switch (token) {
 		case Opt_degraded:
 			btrfs_info(root->fs_info, "allowing degraded mounts");
-			btrfs_set_opt(info->mount_opt, DEGRADED);
+			btrfs_set_opt(new_opt, DEGRADED);
 			break;
 		case Opt_subvol:
 		case Opt_subvolid:
@@ -434,7 +437,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			 */
 			break;
 		case Opt_nodatasum:
-			btrfs_set_and_info(root, NODATASUM,
+			btrfs_set_and_info(info, new_opt, NODATASUM,
 					   "setting nodatasum");
 			break;
 		case Opt_datasum:
@@ -444,8 +447,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				else
 					btrfs_info(root->fs_info, "setting datasum");
 			}
-			btrfs_clear_opt(info->mount_opt, NODATACOW);
-			btrfs_clear_opt(info->mount_opt, NODATASUM);
+			btrfs_clear_opt(new_opt, NODATACOW);
+			btrfs_clear_opt(new_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(root, NODATACOW)) {
@@ -457,13 +460,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 					btrfs_info(root->fs_info, "setting nodatacow");
 				}
 			}
-			btrfs_clear_opt(info->mount_opt, COMPRESS);
-			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
-			btrfs_set_opt(info->mount_opt, NODATACOW);
-			btrfs_set_opt(info->mount_opt, NODATASUM);
+			btrfs_clear_opt(new_opt, COMPRESS);
+			btrfs_clear_opt(new_opt, FORCE_COMPRESS);
+			btrfs_set_opt(new_opt, NODATACOW);
+			btrfs_set_opt(new_opt, NODATASUM);
 			break;
 		case Opt_datacow:
-			btrfs_clear_and_info(root, NODATACOW,
+			btrfs_clear_and_info(info, new_opt, NODATACOW,
 					     "setting datacow");
 			break;
 		case Opt_compress_force:
@@ -477,20 +480,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			    strcmp(args[0].from, "zlib") == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, NODATACOW);
-				btrfs_clear_opt(info->mount_opt, NODATASUM);
+				btrfs_set_opt(new_opt, COMPRESS);
+				btrfs_clear_opt(new_opt, NODATACOW);
+				btrfs_clear_opt(new_opt, NODATASUM);
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, NODATACOW);
-				btrfs_clear_opt(info->mount_opt, NODATASUM);
+				btrfs_set_opt(new_opt, COMPRESS);
+				btrfs_clear_opt(new_opt, NODATACOW);
+				btrfs_clear_opt(new_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
-				btrfs_clear_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+				btrfs_clear_opt(new_opt, COMPRESS);
+				btrfs_clear_opt(new_opt, FORCE_COMPRESS);
 				compress_force = false;
 			} else {
 				ret = -EINVAL;
@@ -498,7 +501,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 
 			if (compress_force) {
-				btrfs_set_and_info(root, FORCE_COMPRESS,
+				btrfs_set_and_info(info, new_opt,
+						   FORCE_COMPRESS,
 						   "force %s compression",
 						   compress_type);
 			} else {
@@ -512,29 +516,29 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				 * flag, otherwise, there is no way for users
 				 * to disable forcible compression separately.
 				 */
-				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+				btrfs_clear_opt(new_opt, FORCE_COMPRESS);
 			}
 			break;
 		case Opt_ssd:
-			btrfs_set_and_info(root, SSD,
+			btrfs_set_and_info(info, new_opt, SSD,
 					   "use ssd allocation scheme");
 			break;
 		case Opt_ssd_spread:
-			btrfs_set_and_info(root, SSD_SPREAD,
+			btrfs_set_and_info(info, new_opt, SSD_SPREAD,
 					   "use spread ssd allocation scheme");
-			btrfs_set_opt(info->mount_opt, SSD);
+			btrfs_set_opt(new_opt, SSD);
 			break;
 		case Opt_nossd:
-			btrfs_set_and_info(root, NOSSD,
-					     "not using ssd allocation scheme");
-			btrfs_clear_opt(info->mount_opt, SSD);
+			btrfs_set_and_info(info, new_opt, NOSSD,
+					   "not using ssd allocation scheme");
+			btrfs_clear_opt(new_opt, SSD);
 			break;
 		case Opt_barrier:
-			btrfs_clear_and_info(root, NOBARRIER,
+			btrfs_clear_and_info(info, new_opt, NOBARRIER,
 					     "turning on barriers");
 			break;
 		case Opt_nobarrier:
-			btrfs_set_and_info(root, NOBARRIER,
+			btrfs_set_and_info(info, new_opt, NOBARRIER,
 					   "turning off barriers");
 			break;
 		case Opt_thread_pool:
@@ -594,19 +598,19 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
 		case Opt_notreelog:
-			btrfs_set_and_info(root, NOTREELOG,
+			btrfs_set_and_info(info, new_opt, NOTREELOG,
 					   "disabling tree log");
 			break;
 		case Opt_treelog:
-			btrfs_clear_and_info(root, NOTREELOG,
+			btrfs_clear_and_info(info, new_opt, NOTREELOG,
 					     "enabling tree log");
 			break;
 		case Opt_flushoncommit:
-			btrfs_set_and_info(root, FLUSHONCOMMIT,
+			btrfs_set_and_info(info, new_opt, FLUSHONCOMMIT,
 					   "turning on flush-on-commit");
 			break;
 		case Opt_noflushoncommit:
-			btrfs_clear_and_info(root, FLUSHONCOMMIT,
+			btrfs_clear_and_info(info, new_opt, FLUSHONCOMMIT,
 					     "turning off flush-on-commit");
 			break;
 		case Opt_ratio:
@@ -623,71 +627,71 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 			break;
 		case Opt_discard:
-			btrfs_set_and_info(root, DISCARD,
+			btrfs_set_and_info(info, new_opt, DISCARD,
 					   "turning on discard");
 			break;
 		case Opt_nodiscard:
-			btrfs_clear_and_info(root, DISCARD,
+			btrfs_clear_and_info(info, new_opt, DISCARD,
 					     "turning off discard");
 			break;
 		case Opt_space_cache:
-			btrfs_set_and_info(root, SPACE_CACHE,
+			btrfs_set_and_info(info, new_opt, SPACE_CACHE,
 					   "enabling disk space caching");
 			break;
 		case Opt_rescan_uuid_tree:
-			btrfs_set_opt(info->mount_opt, RESCAN_UUID_TREE);
+			btrfs_set_opt(new_opt, RESCAN_UUID_TREE);
 			break;
 		case Opt_no_space_cache:
-			btrfs_clear_and_info(root, SPACE_CACHE,
+			btrfs_clear_and_info(info, new_opt, SPACE_CACHE,
 					     "disabling disk space caching");
 			break;
 		case Opt_inode_cache:
-			btrfs_set_pending_and_info(info, INODE_MAP_CACHE,
+			btrfs_set_and_info(info, new_opt, INODE_MAP_CACHE,
 					   "enabling inode map caching");
 			break;
 		case Opt_noinode_cache:
-			btrfs_clear_pending_and_info(info, INODE_MAP_CACHE,
+			btrfs_clear_and_info(info, new_opt, INODE_MAP_CACHE,
 					     "disabling inode map caching");
 			break;
 		case Opt_clear_cache:
-			btrfs_set_and_info(root, CLEAR_CACHE,
+			btrfs_set_and_info(info, new_opt, CLEAR_CACHE,
 					   "force clearing of disk cache");
 			break;
 		case Opt_user_subvol_rm_allowed:
-			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
+			btrfs_set_opt(new_opt, USER_SUBVOL_RM_ALLOWED);
 			break;
 		case Opt_enospc_debug:
-			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
+			btrfs_set_opt(new_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_noenospc_debug:
-			btrfs_clear_opt(info->mount_opt, ENOSPC_DEBUG);
+			btrfs_clear_opt(new_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			btrfs_set_and_info(root, AUTO_DEFRAG,
+			btrfs_set_and_info(info, new_opt, AUTO_DEFRAG,
 					   "enabling auto defrag");
 			break;
 		case Opt_nodefrag:
-			btrfs_clear_and_info(root, AUTO_DEFRAG,
+			btrfs_clear_and_info(info, new_opt, AUTO_DEFRAG,
 					     "disabling auto defrag");
 			break;
 		case Opt_recovery:
 			btrfs_info(root->fs_info, "enabling auto recovery");
-			btrfs_set_opt(info->mount_opt, RECOVERY);
+			btrfs_set_opt(new_opt, RECOVERY);
 			break;
 		case Opt_skip_balance:
-			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
+			btrfs_set_opt(new_opt, SKIP_BALANCE);
 			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
 			btrfs_info(root->fs_info,
 				   "enabling check integrity including extent data");
-			btrfs_set_opt(info->mount_opt,
+			btrfs_set_opt(new_opt,
 				      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
-			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+			btrfs_set_opt(new_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity:
 			btrfs_info(root->fs_info, "enabling check integrity");
-			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+			btrfs_set_opt(new_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity_print_mask:
 			ret = match_int(&args[0], &intarg);
@@ -713,10 +717,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 #endif
 		case Opt_fatal_errors:
 			if (strcmp(args[0].from, "panic") == 0)
-				btrfs_set_opt(info->mount_opt,
+				btrfs_set_opt(new_opt,
 					      PANIC_ON_FATAL_ERROR);
 			else if (strcmp(args[0].from, "bug") == 0)
-				btrfs_clear_opt(info->mount_opt,
+				btrfs_clear_opt(new_opt,
 					      PANIC_ON_FATAL_ERROR);
 			else {
 				ret = -EINVAL;
@@ -752,8 +756,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		}
 	}
 out:
-	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
-		btrfs_info(root->fs_info, "disk space caching is enabled");
+	if (!ret) {
+		if (btrfs_raw_test_opt(new_opt, SPACE_CACHE))
+			btrfs_info(info, "disk space caching is enabled");
+		info->mount_opt = new_opt;
+	}
 	kfree(orig);
 	return ret;
 }
-- 
2.2.2

