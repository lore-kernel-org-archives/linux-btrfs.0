Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaACGJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9O003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 06/11] btrfs: Add noflushoncommit mount option.
Date: Fri, 3 Jan 2014 14:10:29 +0800
Message-Id: <1388729434-19799-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add noflushoncommit mount option to disable flush on commit with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add noflushoncommit mount option.
---
 Documentation/filesystems/btrfs.txt | 1 +
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 14765e6..516ed65 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -120,6 +120,7 @@ Options with (*) are default options and will not show in the mount options.
 	  "bug" - BUG() on a fatal error.  This is the default.
 	  "panic" - panic() on a fatal error.
 
+  noflushoncommit(*)
   flushoncommit
 	The 'flushoncommit' mount option forces any data dirtied by a write in a
 	prior transaction to commit as part of the current commit.  This makes
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fa9c698..c511239 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,7 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
-	Opt_nodiscard, Opt_noenospc_debug,
+	Opt_nodiscard, Opt_noenospc_debug, Opt_noflushoncommit,
 	Opt_err,
 };
 
@@ -350,6 +350,7 @@ static match_table_t tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_flushoncommit, "flushoncommit"},
+	{Opt_noflushoncommit, "noflushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
@@ -563,6 +564,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "turning on flush-on-commit");
 			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
 			break;
+		case Opt_noflushoncommit:
+			if (btrfs_test_opt(root, FLUSHONCOMMIT))
+				btrfs_info(root->fs_info, "turning off flush-on-commit");
+			btrfs_clear_opt(info->mount_opt, FLUSHONCOMMIT);
+			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
 			if (ret) {
-- 
1.8.5.2

