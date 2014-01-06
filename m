Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbaAFB5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:51 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vldM002450
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 8/9] btrfs: Add datasum mount option.
Date: Mon, 6 Jan 2014 09:58:32 +0800
Message-Id: <1388973513-11240-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add datasum mount option to enable checksum with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: Add datasum option
v3: None
---
 Documentation/filesystems/btrfs.txt |  4 +++-
 fs/btrfs/super.c                    | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index bbd1f0f..e05c6ae 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -159,8 +159,10 @@ Options with (*) are default options and will not show in the mount options.
 	Enable/disable data copy-on-write for newly created files.
 	Nodatacow implies nodatasum, and disables all compression.
 
+  datasum(*)
   nodatasum
-	Disable data checksumming for newly created files.
+	Enable/disable data checksumming for newly created files.
+	Datasum implies datacow.
 
   notreelog
 	Disable the tree logging used for fsync and O_SYNC writes.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1bf9202..fa74252 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -325,6 +325,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
+	Opt_datasum,
 	Opt_err,
 };
 
@@ -334,6 +335,7 @@ static match_table_t tokens = {
 	{Opt_subvolid, "subvolid=%s"},
 	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
+	{Opt_datasum, "datasum"},
 	{Opt_nodatacow, "nodatacow"},
 	{Opt_datacow, "datacow"},
 	{Opt_nobarrier, "nobarrier"},
@@ -434,6 +436,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "setting nodatasum");
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
+		case Opt_datasum:
+			if (btrfs_test_opt(root, NODATACOW))
+				btrfs_info(root->fs_info, "setting datasum, datacow enabled");
+			else
+				btrfs_info(root->fs_info, "setting datasum");
+			btrfs_clear_opt(info->mount_opt, NODATACOW);
+			btrfs_clear_opt(info->mount_opt, NODATASUM);
+			break;
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(root, COMPRESS) ||
 				!btrfs_test_opt(root, FORCE_COMPRESS)) {
-- 
1.8.5.2

