Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaACGJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:47 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 01/11] btrfs: Add "barrier" option to support "-o remount,barrier"
Date: Fri, 3 Jan 2014 14:10:24 +0800
Message-Id: <1388729434-19799-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs can be remounted without barrier, but there is no "barrier" option
so nobody can remount btrfs back with barrier on. Only umount and
mount again can re-enable barrier.(Quite awkward)

Also the mount options in the document is also changed slightly for the
further pairing options changes.

Reported-by: Daniel Blueman <daniel@quora.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>
---
changelog:
v1: Add barrier option
v2: Change the document style to fit pairing options better
---
 Documentation/filesystems/btrfs.txt | 13 +++++++------
 fs/btrfs/super.c                    |  8 +++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 5dd282d..2d2e016 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -38,7 +38,7 @@ Mount Options
 =============
 
 When mounting a btrfs filesystem, the following option are accepted.
-Unless otherwise specified, all options default to off.
+Options with (*) are default options and will not show in the mount options.
 
   alloc_start=<bytes>
 	Debugging option to force all block allocations above a certain
@@ -138,12 +138,13 @@ Unless otherwise specified, all options default to off.
 	Disable support for Posix Access Control Lists (ACLs).  See the
 	acl(5) manual page for more information about ACLs.
 
+  barrier(*)
   nobarrier
-        Disables the use of block layer write barriers.  Write barriers ensure
-	that certain IOs make it through the device cache and are on persistent
-	storage.  If used on a device with a volatile (non-battery-backed)
-	write-back cache, this option will lead to filesystem corruption on a
-	system crash or power loss.
+        Disable/enable the use of block layer write barriers.  Write barriers
+	ensure that certain IOs make it through the device cache and are on
+	persistent storage. If used on a device with a volatile
+	(non-battery-backed) write-back cache, this option will lead to
+	filesystem corruption on a system crash or power loss.
 
   nodatacow
 	Disable data copy-on-write for newly created files.  Implies nodatasum,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e9c13fb..fe9d8a6 100644
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
@@ -494,6 +495,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_clear_opt(info->mount_opt, SSD);
 			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
+		case Opt_barrier:
+			if (btrfs_test_opt(root, NOBARRIER))
+				btrfs_info(root->fs_info, "turning on barriers");
+			btrfs_clear_opt(info->mount_opt, NOBARRIER);
+			break;
 		case Opt_nobarrier:
 			btrfs_info(root->fs_info, "turning off barriers");
 			btrfs_set_opt(info->mount_opt, NOBARRIER);
-- 
1.8.5.2

