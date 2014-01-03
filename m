Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaACGJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9K003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 02/11] btrfs: Add noautodefrag mount option.
Date: Fri, 3 Jan 2014 14:10:25 +0800
Message-Id: <1388729434-19799-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has autodefrag mount option but no pairing noautodefrag option,
which makes it impossible to disable autodefrag without umount.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add noauitodefrag mount option
---
 Documentation/filesystems/btrfs.txt | 8 +++++---
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 2d2e016..65e885f 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -46,10 +46,12 @@ Options with (*) are default options and will not show in the mount options.
 	bytes, optionally with a K, M, or G suffix, case insensitive.
 	Default is 1MB.
 
+  noautodefrag(*)
   autodefrag
-	Detect small random writes into files and queue them up for the
-	defrag process.  Works best for small files; Not well suited for
-	large database workloads.
+	Disable/enable auto defragmentation.
+	Auto defragmentation detects small random writes into files and queue
+	them up for the defrag process.  Works best for small files;
+	Not well suited for large database workloads.
 
   check_int
   check_int_data
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fe9d8a6..c65f696 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,7 +323,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval, Opt_barrier,
+	Opt_commit_interval, Opt_barrier, Opt_nodefrag,
 	Opt_err,
 };
 
@@ -357,6 +357,7 @@ static match_table_t tokens = {
 	{Opt_enospc_debug, "enospc_debug"},
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
+	{Opt_nodefrag, "noautodefrag"},
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
@@ -602,6 +603,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "enabling auto defrag");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
+		case Opt_nodefrag:
+			if (btrfs_test_opt(root, AUTO_DEFRAG))
+				btrfs_info(root->fs_info, "disabling auto defrag");
+			btrfs_clear_opt(info->mount_opt, AUTO_DEFRAG);
+			break;
 		case Opt_recovery:
 			btrfs_info(root->fs_info, "enabling auto recovery");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
-- 
1.8.5.2

