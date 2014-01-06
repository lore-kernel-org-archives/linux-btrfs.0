Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaAFB5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:51 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vm2I002454
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 7/9] btrfs: Add datacow mount option.
Date: Mon, 6 Jan 2014 09:58:31 +0800
Message-Id: <1388973513-11240-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add datacow mount option to enable copy-on-write with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: add datacow mount option
v3: None
---
 Documentation/filesystems/btrfs.txt | 5 +++--
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 79c08f3..bbd1f0f 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -154,9 +154,10 @@ Options with (*) are default options and will not show in the mount options.
 	(non-battery-backed) write-back cache, nobarrier option will lead to
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
index 3d743cf..1bf9202 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,7 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
-	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl,
+	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_err,
 };
 
@@ -335,6 +335,7 @@ static match_table_t tokens = {
 	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
+	{Opt_datacow, "datacow"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_barrier, "barrier"},
 	{Opt_max_inline, "max_inline=%s"},
@@ -446,6 +447,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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

