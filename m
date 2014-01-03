Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaACGJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:50 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369l7m003671
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 08/11] btrfs: Add acl mount option.
Date: Fri, 3 Jan 2014 14:10:31 +0800
Message-Id: <1388729434-19799-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add acl mount option to enable acl with remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add acl mount option.
---
 Documentation/filesystems/btrfs.txt | 3 ++-
 fs/btrfs/super.c                    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index ffb40f3..6f2de1b 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -146,8 +146,9 @@ Options with (*) are default options and will not show in the mount options.
 	Specify that 1 metadata chunk should be allocated after every <value>
 	data chunks.  Off by default.
 
+  acl(*)
   noacl
-	Disable support for Posix Access Control Lists (ACLs).  See the
+	Enable/disable support for Posix Access Control Lists (ACLs).  See the
 	acl(5) manual page for more information about ACLs.
 
   barrier(*)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 16da3d1..a5c25fd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -325,7 +325,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
 	Opt_nodiscard, Opt_noenospc_debug, Opt_noflushoncommit,
-	Opt_noinode_cache,
+	Opt_noinode_cache, Opt_acl,
 	Opt_err,
 };
 
@@ -348,6 +348,7 @@ static match_table_t tokens = {
 	{Opt_ssd, "ssd"},
 	{Opt_ssd_spread, "ssd_spread"},
 	{Opt_nossd, "nossd"},
+	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
 	{Opt_flushoncommit, "flushoncommit"},
@@ -555,6 +556,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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

