Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaAFB5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:53 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vfHS002425
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 9/9] btrfs: Add treelog mount option.
Date: Mon, 6 Jan 2014 09:58:33 +0800
Message-Id: <1388973513-11240-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add treelog mount option to enable tree log with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: Add treelog option
v3: None
---
 Documentation/filesystems/btrfs.txt | 3 ++-
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index e05c6ae..d11cc2f 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -164,8 +164,9 @@ Options with (*) are default options and will not show in the mount options.
 	Enable/disable data checksumming for newly created files.
 	Datasum implies datacow.
 
+  treelog(*)
   notreelog
-	Disable the tree logging used for fsync and O_SYNC writes.
+	Enable/disable the tree logging used for fsync and O_SYNC writes.
 
   recovery
 	Enable autorecovery attempts if a bad tree root is found at mount time.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fa74252..d353b9e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -325,7 +325,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
-	Opt_datasum,
+	Opt_datasum, Opt_treelog,
 	Opt_err,
 };
 
@@ -353,6 +353,7 @@ static match_table_t tokens = {
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
+	{Opt_treelog, "treelog"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
@@ -579,6 +580,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "disabling tree log");
 			btrfs_set_opt(info->mount_opt, NOTREELOG);
 			break;
+		case Opt_treelog:
+			if (btrfs_test_opt(root, NOTREELOG))
+				btrfs_info(root->fs_info, "enabling tree log");
+			btrfs_clear_opt(info->mount_opt, NOTREELOG);
+			break;
 		case Opt_flushoncommit:
 			btrfs_info(root->fs_info, "turning on flush-on-commit");
 			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
-- 
1.8.5.2

