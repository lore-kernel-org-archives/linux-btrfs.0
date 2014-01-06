Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaAFB5u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vfHR002425
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:48 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 6/9] btrfs: Add acl mount option.
Date: Mon, 6 Jan 2014 09:58:30 +0800
Message-Id: <1388973513-11240-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add acl mount option to enable acl with remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: add acl option
v3: None
---
 Documentation/filesystems/btrfs.txt | 3 ++-
 fs/btrfs/super.c                    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 303b49c..79c08f3 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -141,8 +141,9 @@ Options with (*) are default options and will not show in the mount options.
 	Specify that 1 metadata chunk should be allocated after every <value>
 	data chunks.  Off by default.
 
+  acl(*)
   noacl
-	Disable support for Posix Access Control Lists (ACLs).  See the
+	Enable/disable support for Posix Access Control Lists (ACLs).  See the
 	acl(5) manual page for more information about ACLs.
 
   barrier(*)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b2c752e..3d743cf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,7 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
-	Opt_noenospc_debug, Opt_noflushoncommit,
+	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl,
 	Opt_err,
 };
 
@@ -347,6 +347,7 @@ static match_table_t tokens = {
 	{Opt_ssd, "ssd"},
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd, "nossd"},
+	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_flushoncommit, "flushoncommit"},
@@ -552,6 +553,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_acl:
+			root->fs_info->sb->s_flags |= MS_POSIXACL;
+			break;
 		case Opt_noacl:
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
-- 
1.8.5.2

