Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaACGJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:48 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0369f9M003655
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 14:09:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 04/11] btrfs: Add nodiscard mount option.
Date: Fri, 3 Jan 2014 14:10:27 +0800
Message-Id: <1388729434-19799-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add nodiscard mount option to disable discard with remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2: Add nodiscard mount option.
---
 Documentation/filesystems/btrfs.txt | 7 +++++--
 fs/btrfs/super.c                    | 5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index aab54e9..344e67f 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -101,9 +101,12 @@ Options with (*) are default options and will not show in the mount options.
 	can be avoided.  Especially useful when trying to mount a multi-device
 	setup as root.  May be specified multiple times for multiple devices.
 
+  nodiscard(*)
   discard
-	Issue frequent commands to let the block device reclaim space freed by
-	the filesystem.  This is useful for SSD devices, thinly provisioned
+	Disable/enable discard mount option.
+	Discard issues frequent commands to let the block device reclaim space
+	freed by the filesystem.
+	This is useful for SSD devices, thinly provisioned
 	LUNs and virtual machine images, but may have a significant
 	performance impact.  (The fstrim command is also available to
 	initiate batch trims from userspace).
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b408d05..3ab11d4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -324,6 +324,7 @@ enum {
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nocheck_integrity,
+	Opt_nodiscard,
 	Opt_err,
 };
 
@@ -351,6 +352,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_space_cache, "space_cache"},
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
@@ -576,6 +578,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_nodiscard:
+			btrfs_clear_opt(info->mount_opt, DISCARD);
+			break;
 		case Opt_space_cache:
 			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 			break;
-- 
1.8.5.2

