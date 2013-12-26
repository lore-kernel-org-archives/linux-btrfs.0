Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3LZGoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 01:44:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBQ6iIgr009735
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Dec 2013 14:44:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Add "barrier" option to support "-o remount,barrier"
Date: Thu, 26 Dec 2013 14:45:10 +0800
Message-Id: <1388040310-25092-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs can be remounted without barrier, but there is no "barrier" option
so nobody can remount btrfs back with barrier on. Only umount and
mount again can re-enable barrier.(Quite awkward)

Reported-by: Daniel Blueman <daniel@quora.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/filesystems/btrfs.txt | 6 ++++++
 fs/btrfs/super.c                    | 8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 5dd282d..f6f71d6 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -51,6 +51,12 @@ Unless otherwise specified, all options default to off.
 	defrag process.  Works best for small files; Not well suited for
 	large database workloads.
 
+  barrier
+	Enable the use of block layer write barriers.  Write barriers ensure
+	that certain IOs make it through the device cache and are on persistent
+	storage.
+	Barriers are enabled by default.
+	
   check_int
   check_int_data
   check_int_print_mask=<value>
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e9c13fb..c8f4aca 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,7 +323,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval,
+	Opt_commit_interval, Opt_barrier,
 	Opt_err,
 };
 
@@ -335,6 +335,7 @@ static match_table_t tokens = {
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
 	{Opt_nobarrier, "nobarrier"},
+	{Opt_barrier, "barrier"},
 	{Opt_max_inline, "max_inline=%s"},
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
@@ -498,6 +499,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_info(root->fs_info, "turning off barriers");
 			btrfs_set_opt(info->mount_opt, NOBARRIER);
 			break;
+		case Opt_barrier:
+			if (btrfs_test_opt(root, NOBARRIER))
+				btrfs_info(root->fs_info, "turning on barriers");
+			btrfs_clear_opt(info->mount_opt, NOBARRIER);
+			break;
 		case Opt_thread_pool:
 			ret = match_int(&args[0], &intarg);
 			if (ret) {
-- 
1.8.5.2

