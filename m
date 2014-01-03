Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaACGJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9L003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/11] btrfs: Add nocheck_int mount option.
Date: Fri, 3 Jan 2014 14:10:26 +0800
Message-Id: <1388729434-19799-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add nocheck_int mount option to disable integrity check with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: add nocheck_int mount option
---
 Documentation/filesystems/btrfs.txt |  3 +++
 fs/btrfs/super.c                    | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 65e885f..aab54e9 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -53,6 +53,7 @@ Options with (*) are default options and will not show in the mount options.
 	them up for the defrag process.  Works best for small files;
 	Not well suited for large database workloads.
 
+  nocheck_int(*)
   check_int
   check_int_data
   check_int_print_mask=<value>
@@ -70,6 +71,8 @@ Options with (*) are default options and will not show in the mount options.
 	as defined in fs/btrfs/check-integrity.c, to control the integrity
 	checker module behavior.
 
+	nocheck_int disables all the debug options above.
+
 	See comments at the top of fs/btrfs/check-integrity.c for more info.
 
   commit=<seconds>
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c65f696..b408d05 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,7 +323,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval, Opt_barrier, Opt_nodefrag,
+	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
 	Opt_err,
 };
 
@@ -363,6 +363,7 @@ static match_table_t tokens = {
 	{Opt_recovery, "recovery"},
 	{Opt_skip_balance, "skip_balance"},
 	{Opt_check_integrity, "check_int"},
+	{Opt_nocheck_integrity, "nocheck_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
@@ -616,6 +617,17 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
 			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+		case Opt_nocheck_integrity:
+			if (btrfs_test_opt(root, CHECK_INTEGRITY) ||
+			    btrfs_test_opt(root,
+				    CHECK_INTEGRITY_INCLUDING_EXTENT_DATA) ||
+			    info->check_integrity_print_mask != 0)
+				btrfs_info(root->fs_info, "disabling any integrity check");
+			btrfs_clear_opt(info->mount_opt, CHECK_INTEGRITY);
+			btrfs_clear_opt(info->mount_opt,
+					CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
+			info->check_integrity_print_mask = 0;
+			break;
 		case Opt_check_integrity_including_extent_data:
 			btrfs_info(root->fs_info,
 				   "enabling check integrity including extent data");
@@ -641,6 +653,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 			break;
 #else
+		case Opt_nocheck_integrity:
 		case Opt_check_integrity_including_extent_data:
 		case Opt_check_integrity:
 		case Opt_check_integrity_print_mask:
-- 
1.8.5.2

