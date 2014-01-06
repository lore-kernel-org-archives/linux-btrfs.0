Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23518 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaAFB5r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 20:57:47 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s061vfHP002425
	for <linux-btrfs@vger.kernel.org>; Mon, 6 Jan 2014 09:57:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/9] btrfs: Add nodiscard mount option.
Date: Mon, 6 Jan 2014 09:58:27 +0800
Message-Id: <1388973513-11240-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1388973513-11240-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add nodiscard mount option to disable discard with remount option.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

---
Changelog:
v2: Add nodiscard option
v3: None
---
 Documentation/filesystems/btrfs.txt | 7 +++++--
 fs/btrfs/super.c                    | 6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index e87609a..7254cf5 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -98,9 +98,12 @@ Options with (*) are default options and will not show in the mount options.
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
index c65f696..8731ee6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -323,7 +323,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
-	Opt_commit_interval, Opt_barrier, Opt_nodefrag,
+	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_err,
 };
 
@@ -351,6 +351,7 @@ static match_table_t tokens = {
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
 	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_space_cache, "space_cache"},
 	{Opt_clear_cache, "clear_cache"},
 	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
@@ -575,6 +576,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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

