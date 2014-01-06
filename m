Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaAFB5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vfHQ002425
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 4/9] btrfs: Add noenospc_debug mount option.
Date: Mon, 6 Jan 2014 09:58:28 +0800
Message-Id: <1388973513-11240-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add noenospc_debug mount option to disable ENOSPC debug with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: Add noenospc_debug option
v3: None
---
 Documentation/filesystems/btrfs.txt | 3 ++-
 fs/btrfs/super.c                    | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 7254cf5..13a7cac 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -108,8 +108,9 @@ Options with (*) are default options and will not show in the mount options.
 	performance impact.  (The fstrim command is also available to
 	initiate batch trims from userspace).
 
+  noenospc_debug(*)
   enospc_debug
-	Debugging option to be more verbose in some ENOSPC conditions.
+	Disable/enable debugging option to be more verbose in some ENOSPC conditions.
 
   fatal_errors=<action>
 	Action to take when encountering a fatal error: 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8731ee6..acf3e7d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,6 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
+	Opt_noenospc_debug,
 	Opt_err,
 };
 
@@ -356,6 +357,7 @@ static match_table_t tokens = {
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
 	{Opt_enospc_debug, "enospc_debug"},
+	{Opt_noenospc_debug, "noenospc_debug"},
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
 	{Opt_nodefrag, "noautodefrag"},
@@ -603,6 +605,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_enospc_debug:
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
+		case Opt_noenospc_debug:
+			btrfs_clear_opt(info->mount_opt, ENOSPC_DEBUG);
+			break;
 		case Opt_defrag:
 			btrfs_info(root->fs_info, "enabling auto defrag");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
-- 
1.8.5.2

