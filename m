Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab2JLDZL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 23:25:11 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 258EA3EE0B5
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:10 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 06C2745DD78
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:10 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id E275945DE4D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:09 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id CC6FF1DB803E
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:09 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 72E7B1DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:09 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 495C89F79A0
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:09 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.110])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id E08D89F6C65
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:25:08 +0900 (JST)
Message-ID: <50778D89.4030501@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 12:24:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: make subroutine __btrfs_parse_options
References: <50778C1D.4060807@jp.fujitsu.com>
In-Reply-To: <50778C1D.4060807@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Separate long switch statement to be reused.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/btrfs/super.c |  431 +++++++++++++++++++++++++++---------------------------
 1 files changed, 214 insertions(+), 217 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 83d6f9f..d51aaee 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -349,6 +349,214 @@ static match_table_t tokens = {
 	{Opt_err, NULL},
 };
 
+static int __btrfs_parse_options(struct btrfs_fs_info *info, int token,
+				 substring_t *args)
+{
+	bool compress_force = false;
+	char *compress_type;
+	char *num;
+	int intarg;
+
+	switch (token) {
+	case Opt_degraded:
+		pr_info("btrfs: allowing degraded mounts\n");
+		btrfs_set_opt(info->mount_opt, DEGRADED);
+		break;
+	case Opt_subvol:
+	case Opt_subvolid:
+	case Opt_subvolrootid:
+	case Opt_device:
+		/*
+		 * These are parsed by btrfs_parse_early_options
+		 * and can be happily ignored here.
+		 */
+		break;
+	case Opt_nodatasum:
+		pr_info("btrfs: setting nodatasum\n");
+		btrfs_set_opt(info->mount_opt, NODATASUM);
+		break;
+	case Opt_nodatacow:
+		pr_info("btrfs: setting nodatacow\n");
+		btrfs_set_opt(info->mount_opt, NODATACOW);
+		btrfs_set_opt(info->mount_opt, NODATASUM);
+		break;
+	case Opt_compress_force:
+	case Opt_compress_force_type:
+		compress_force = true;
+	case Opt_compress:
+	case Opt_compress_type:
+		if (token == Opt_compress ||
+		    token == Opt_compress_force ||
+		    strcmp(args[0].from, "zlib") == 0) {
+			compress_type = "zlib";
+			info->compress_type = BTRFS_COMPRESS_ZLIB;
+			btrfs_set_opt(info->mount_opt, COMPRESS);
+		} else if (strcmp(args[0].from, "lzo") == 0) {
+			compress_type = "lzo";
+			info->compress_type = BTRFS_COMPRESS_LZO;
+			btrfs_set_opt(info->mount_opt, COMPRESS);
+			btrfs_set_fs_incompat(info, COMPRESS_LZO);
+		} else if (strncmp(args[0].from, "no", 2) == 0) {
+			compress_type = "no";
+			info->compress_type = BTRFS_COMPRESS_NONE;
+			btrfs_clear_opt(info->mount_opt, COMPRESS);
+			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
+			compress_force = false;
+		} else
+			return -EINVAL;
+
+		if (compress_force) {
+			btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
+			pr_info("btrfs: force %s compression\n", compress_type);
+		} else
+			pr_info("btrfs: use %s compression\n", compress_type);
+		break;
+	case Opt_ssd:
+		pr_info("btrfs: use ssd allocation scheme\n");
+		btrfs_set_opt(info->mount_opt, SSD);
+		break;
+	case Opt_ssd_spread:
+		pr_info("btrfs: use spread ssd allocation scheme\n");
+		btrfs_set_opt(info->mount_opt, SSD);
+		btrfs_set_opt(info->mount_opt, SSD_SPREAD);
+		break;
+	case Opt_nossd:
+		pr_info("btrfs: not using ssd allocation scheme\n");
+		btrfs_set_opt(info->mount_opt, NOSSD);
+		btrfs_clear_opt(info->mount_opt, SSD);
+		btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
+		break;
+	case Opt_nobarrier:
+		pr_info("btrfs: turning off barriers\n");
+		btrfs_set_opt(info->mount_opt, NOBARRIER);
+		break;
+	case Opt_thread_pool:
+		intarg = 0;
+		match_int(&args[0], &intarg);
+		if (intarg)
+			info->thread_pool_size = intarg;
+		break;
+	case Opt_max_inline:
+		num = match_strdup(&args[0]);
+		if (num) {
+			info->max_inline = memparse(num, NULL);
+			kfree(num);
+
+			if (info->max_inline) {
+				info->max_inline = max_t(u64,
+					info->max_inline,
+					info->tree_root->sectorsize);
+			}
+			pr_info("btrfs: max_inline at %llu\n",
+				(unsigned long long)info->max_inline);
+		}
+		break;
+	case Opt_alloc_start:
+		num = match_strdup(&args[0]);
+		if (num) {
+			info->alloc_start = memparse(num, NULL);
+			kfree(num);
+			pr_info("btrfs: allocations start at %llu\n",
+				(unsigned long long)info->alloc_start);
+		}
+		break;
+	case Opt_noacl:
+		info->sb->s_flags &= ~MS_POSIXACL;
+		break;
+	case Opt_notreelog:
+		pr_info("btrfs: disabling tree log\n");
+		btrfs_set_opt(info->mount_opt, NOTREELOG);
+		break;
+	case Opt_flushoncommit:
+		pr_info("btrfs: turning on flush-on-commit\n");
+		btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
+		break;
+	case Opt_ratio:
+		intarg = 0;
+		match_int(&args[0], &intarg);
+		if (intarg) {
+			info->metadata_ratio = intarg;
+			pr_info("btrfs: metadata ratio %d\n",
+				info->metadata_ratio);
+		}
+		break;
+	case Opt_discard:
+		btrfs_set_opt(info->mount_opt, DISCARD);
+		break;
+	case Opt_space_cache:
+		btrfs_set_opt(info->mount_opt, SPACE_CACHE);
+		break;
+	case Opt_no_space_cache:
+		pr_info("btrfs: disabling disk space caching\n");
+		btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
+		break;
+	case Opt_inode_cache:
+		pr_info("btrfs: enabling inode map caching\n");
+		btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
+		break;
+	case Opt_clear_cache:
+		pr_info("btrfs: force clearing of disk cache\n");
+		btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
+		break;
+	case Opt_user_subvol_rm_allowed:
+		btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
+		break;
+	case Opt_enospc_debug:
+		btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
+		break;
+	case Opt_defrag:
+		pr_info("btrfs: enabling auto defrag");
+		btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
+		break;
+	case Opt_recovery:
+		pr_info("btrfs: enabling auto recovery");
+		btrfs_set_opt(info->mount_opt, RECOVERY);
+		break;
+	case Opt_skip_balance:
+		btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
+		break;
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+	case Opt_check_integrity_including_extent_data:
+		pr_info("btrfs: enabling check integrity including extent data\n");
+		btrfs_set_opt(info->mount_opt,
+			      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
+		btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+		break;
+	case Opt_check_integrity:
+		pr_info("btrfs: enabling check integrity\n");
+		btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
+		break;
+	case Opt_check_integrity_print_mask:
+		intarg = 0;
+		match_int(&args[0], &intarg);
+		if (intarg) {
+			info->check_integrity_print_mask = intarg;
+			pr_info("btrfs: check_integrity_print_mask 0x%x\n",
+				info->check_integrity_print_mask);
+		}
+		break;
+#else
+	case Opt_check_integrity_including_extent_data:
+	case Opt_check_integrity:
+	case Opt_check_integrity_print_mask:
+		pr_err("btrfs: support for check_integrity* not compiled in!\n");
+		return -EINVAL;
+#endif
+	case Opt_fatal_errors:
+		if (strcmp(args[0].from, "panic") == 0)
+			btrfs_set_opt(info->mount_opt, PANIC_ON_FATAL_ERROR);
+		else if (strcmp(args[0].from, "bug") == 0)
+			btrfs_clear_opt(info->mount_opt, PANIC_ON_FATAL_ERROR);
+		else
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * Regular mount options parser.  Everything that is needed only when
  * reading in a new superblock is parsed here.
@@ -358,12 +566,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num, *orig = NULL;
+	char *p, *orig = NULL;
 	u64 cache_gen;
-	int intarg;
 	int ret = 0;
-	char *compress_type;
-	bool compress_force = false;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
@@ -388,222 +593,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			continue;
 
 		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_degraded:
-			printk(KERN_INFO "btrfs: allowing degraded mounts\n");
-			btrfs_set_opt(info->mount_opt, DEGRADED);
-			break;
-		case Opt_subvol:
-		case Opt_subvolid:
-		case Opt_subvolrootid:
-		case Opt_device:
-			/*
-			 * These are parsed by btrfs_parse_early_options
-			 * and can be happily ignored here.
-			 */
-			break;
-		case Opt_nodatasum:
-			printk(KERN_INFO "btrfs: setting nodatasum\n");
-			btrfs_set_opt(info->mount_opt, NODATASUM);
-			break;
-		case Opt_nodatacow:
-			printk(KERN_INFO "btrfs: setting nodatacow\n");
-			btrfs_set_opt(info->mount_opt, NODATACOW);
-			btrfs_set_opt(info->mount_opt, NODATASUM);
-			break;
-		case Opt_compress_force:
-		case Opt_compress_force_type:
-			compress_force = true;
-		case Opt_compress:
-		case Opt_compress_type:
-			if (token == Opt_compress ||
-			    token == Opt_compress_force ||
-			    strcmp(args[0].from, "zlib") == 0) {
-				compress_type = "zlib";
-				info->compress_type = BTRFS_COMPRESS_ZLIB;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-			} else if (strcmp(args[0].from, "lzo") == 0) {
-				compress_type = "lzo";
-				info->compress_type = BTRFS_COMPRESS_LZO;
-				btrfs_set_opt(info->mount_opt, COMPRESS);
-				btrfs_set_fs_incompat(info, COMPRESS_LZO);
-			} else if (strncmp(args[0].from, "no", 2) == 0) {
-				compress_type = "no";
-				info->compress_type = BTRFS_COMPRESS_NONE;
-				btrfs_clear_opt(info->mount_opt, COMPRESS);
-				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
-				compress_force = false;
-			} else {
-				ret = -EINVAL;
-				goto out;
-			}
-
-			if (compress_force) {
-				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
-				pr_info("btrfs: force %s compression\n",
-					compress_type);
-			} else
-				pr_info("btrfs: use %s compression\n",
-					compress_type);
-			break;
-		case Opt_ssd:
-			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
-			btrfs_set_opt(info->mount_opt, SSD);
-			break;
-		case Opt_ssd_spread:
-			printk(KERN_INFO "btrfs: use spread ssd "
-			       "allocation scheme\n");
-			btrfs_set_opt(info->mount_opt, SSD);
-			btrfs_set_opt(info->mount_opt, SSD_SPREAD);
-			break;
-		case Opt_nossd:
-			printk(KERN_INFO "btrfs: not using ssd allocation "
-			       "scheme\n");
-			btrfs_set_opt(info->mount_opt, NOSSD);
-			btrfs_clear_opt(info->mount_opt, SSD);
-			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
-			break;
-		case Opt_nobarrier:
-			printk(KERN_INFO "btrfs: turning off barriers\n");
-			btrfs_set_opt(info->mount_opt, NOBARRIER);
-			break;
-		case Opt_thread_pool:
-			intarg = 0;
-			match_int(&args[0], &intarg);
-			if (intarg)
-				info->thread_pool_size = intarg;
-			break;
-		case Opt_max_inline:
-			num = match_strdup(&args[0]);
-			if (num) {
-				info->max_inline = memparse(num, NULL);
-				kfree(num);
-
-				if (info->max_inline) {
-					info->max_inline = max_t(u64,
-						info->max_inline,
-						root->sectorsize);
-				}
-				printk(KERN_INFO "btrfs: max_inline at %llu\n",
-					(unsigned long long)info->max_inline);
-			}
-			break;
-		case Opt_alloc_start:
-			num = match_strdup(&args[0]);
-			if (num) {
-				info->alloc_start = memparse(num, NULL);
-				kfree(num);
-				printk(KERN_INFO
-					"btrfs: allocations start at %llu\n",
-					(unsigned long long)info->alloc_start);
-			}
-			break;
-		case Opt_noacl:
-			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
-			break;
-		case Opt_notreelog:
-			printk(KERN_INFO "btrfs: disabling tree log\n");
-			btrfs_set_opt(info->mount_opt, NOTREELOG);
-			break;
-		case Opt_flushoncommit:
-			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
-			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
-			break;
-		case Opt_ratio:
-			intarg = 0;
-			match_int(&args[0], &intarg);
-			if (intarg) {
-				info->metadata_ratio = intarg;
-				printk(KERN_INFO "btrfs: metadata ratio %d\n",
-				       info->metadata_ratio);
-			}
-			break;
-		case Opt_discard:
-			btrfs_set_opt(info->mount_opt, DISCARD);
-			break;
-		case Opt_space_cache:
-			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
-			break;
-		case Opt_no_space_cache:
-			printk(KERN_INFO "btrfs: disabling disk space caching\n");
-			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
-			break;
-		case Opt_inode_cache:
-			printk(KERN_INFO "btrfs: enabling inode map caching\n");
-			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
-			break;
-		case Opt_clear_cache:
-			printk(KERN_INFO "btrfs: force clearing of disk cache\n");
-			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
-			break;
-		case Opt_user_subvol_rm_allowed:
-			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
-			break;
-		case Opt_enospc_debug:
-			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
-			break;
-		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag");
-			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
-			break;
-		case Opt_recovery:
-			printk(KERN_INFO "btrfs: enabling auto recovery");
-			btrfs_set_opt(info->mount_opt, RECOVERY);
-			break;
-		case Opt_skip_balance:
-			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
-			break;
-#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-		case Opt_check_integrity_including_extent_data:
-			printk(KERN_INFO "btrfs: enabling check integrity"
-			       " including extent data\n");
-			btrfs_set_opt(info->mount_opt,
-				      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
-			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
-			break;
-		case Opt_check_integrity:
-			printk(KERN_INFO "btrfs: enabling check integrity\n");
-			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
-			break;
-		case Opt_check_integrity_print_mask:
-			intarg = 0;
-			match_int(&args[0], &intarg);
-			if (intarg) {
-				info->check_integrity_print_mask = intarg;
-				printk(KERN_INFO "btrfs:"
-				       " check_integrity_print_mask 0x%x\n",
-				       info->check_integrity_print_mask);
-			}
-			break;
-#else
-		case Opt_check_integrity_including_extent_data:
-		case Opt_check_integrity:
-		case Opt_check_integrity_print_mask:
-			printk(KERN_ERR "btrfs: support for check_integrity*"
-			       " not compiled in!\n");
-			ret = -EINVAL;
-			goto out;
-#endif
-		case Opt_fatal_errors:
-			if (strcmp(args[0].from, "panic") == 0)
-				btrfs_set_opt(info->mount_opt,
-					      PANIC_ON_FATAL_ERROR);
-			else if (strcmp(args[0].from, "bug") == 0)
-				btrfs_clear_opt(info->mount_opt,
-					      PANIC_ON_FATAL_ERROR);
-			else {
-				ret = -EINVAL;
-				goto out;
-			}
-			break;
-		case Opt_err:
-			printk(KERN_INFO "btrfs: unrecognized mount option "
-			       "'%s'\n", p);
+		if (token == Opt_err) {
+			pr_info("btrfs: unrecognized mount option '%s'\n", p);
 			ret = -EINVAL;
-			goto out;
-		default:
 			break;
 		}
+		ret = __btrfs_parse_options(info, token, args);
+		if (ret)
+			break;
 	}
 out:
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
-- 
1.7.7.6


