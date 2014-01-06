Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbaAFB5u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vldL002450
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/9] btrfs: Add noflushoncommit mount option.
Date: Mon, 6 Jan 2014 09:58:29 +0800
Message-Id: <1388973513-11240-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add noflushoncommit mount option to disable flush on commit with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: Add noflushoncommit option
v3: None
---
 Documentation/filesystems/btrfs.txt | 1 +
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 13a7cac..303b49c 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -117,6 +117,7 @@ Options with (*) are default options and will not show in the mount options.
 	  "bug" - BUG() on a fatal error.  This is the default.
 	  "panic" - panic() on a fatal error.
 
+  noflushoncommit(*)
   flushoncommit
 	The 'flushoncommit' mount option forces any data dirtied by a write in a
 	prior transaction to commit as part of the current commit.  This makes
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index acf3e7d..b2c752e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,7 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
-	Opt_noenospc_debug,
+	Opt_noenospc_debug, Opt_noflushoncommit,
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
@@ -562,6 +563,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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

