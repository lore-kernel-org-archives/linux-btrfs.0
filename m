Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8148 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaACGJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9Q003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/11] btrfs: Add datacow mount option.
Date: Fri, 3 Jan 2014 14:10:32 +0800
Message-Id: <1388729434-19799-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add datacow mount option to enable copy-on-write with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add datacow mount option.
---
 Documentation/filesystems/btrfs.txt | 5 +++--
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 6f2de1b..48c1833 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -159,9 +159,10 @@ Options with (*) are default options and will not show in the mount options.
 	(non-battery-backed) write-back cache, this option will lead to
 	filesystem corruption on a system crash or power loss.
 
+  datacow(*)
   nodatacow
-	Disable data copy-on-write for newly created files.  Implies nodatasum,
-	and disables all compression.
+	Enable/disable data copy-on-write for newly created files.
+	Nodatacow implies nodatasum, and disables all compression.
 
   nodatasum
 	Disable data checksumming for newly created files.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a5c25fd..cb4c90d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -325,7 +325,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
 	Opt_nodiscard, Opt_noenospc_debug, Opt_noflushoncommit,
-	Opt_noinode_cache, Opt_acl,
+	Opt_noinode_cache, Opt_acl, Opt_datacow,
 	Opt_err,
 };
 
@@ -336,6 +336,7 @@ static match_table_t tokens = {
 	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
+	{Opt_datacow, "datacow"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_barrier, "barrier"},
 	{Opt_max_inline, "max_inline=%s"},
@@ -449,6 +450,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, NODATACOW);
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
+		case Opt_datacow:
+			if (btrfs_test_opt(root, NODATACOW))
+				btrfs_info(root->fs_info, "setting datacow");
+			btrfs_clear_opt(info->mount_opt, NODATACOW);
+			break;
 		case Opt_compress_force:
 		case Opt_compress_force_type:
 			compress_force = true;
-- 
1.8.5.2

