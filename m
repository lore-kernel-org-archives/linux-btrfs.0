Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaACGJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9P003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 07/11] btrfs: Add noinode_cache mount option.
Date: Fri, 3 Jan 2014 14:10:30 +0800
Message-Id: <1388729434-19799-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add noinode_cache mount option to disable inode map cache with
remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add noinode_cache mount option.
---
 Documentation/filesystems/btrfs.txt | 6 ++++--
 fs/btrfs/super.c                    | 7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 516ed65..ffb40f3 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -129,9 +129,11 @@ Options with (*) are default options and will not show in the mount options.
 	operations).  This was previously the behavior only when a snapshot is
 	created.
 
+  noinode_cache(*)
   inode_cache
-	Enable free inode number caching.   Defaults to off due to an overflow
-	problem when the free space crcs don't fit inside a single page.
+	Disable/enable free inode number caching.
+	Defaults to off due to an overflow problem when the free space crcs
+	don't fit inside a single page.
 
   max_inline=<bytes>
 	Specify the maximum amount of space, in bytes, that can be inlined in
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c511239..16da3d1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -325,6 +325,7 @@ enum {
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
 	Opt_nodiscard, Opt_noenospc_debug, Opt_noflushoncommit,
+	Opt_noinode_cache,
 	Opt_err,
 };
 
@@ -363,6 +364,7 @@ static match_table_t tokens = {
 	{Opt_defrag, "autodefrag"},
 	{Opt_nodefrag, "noautodefrag"},
 	{Opt_inode_cache, "inode_cache"},
+	{Opt_noinode_cache, "noinode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
 	{Opt_skip_balance, "skip_balance"},
@@ -602,6 +604,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "enabling inode map caching");
 			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
 			break;
+		case Opt_noinode_cache:
+			if (btrfs_test_opt(root, INODE_MAP_CACHE))
+				btrfs_info(root->fs_info, "disabling inode map caching");
+			btrfs_clear_opt(info->mount_opt, INODE_MAP_CACHE);
+			break;
 		case Opt_clear_cache:
 			btrfs_info(root->fs_info, "force clearing of disk cache");
 			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
-- 
1.8.5.2

