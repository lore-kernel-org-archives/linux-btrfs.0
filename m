Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbbHNKd6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
Date: Fri, 14 Aug 2015 18:33:08 +0800
Message-Id: <1439548388-29686-24-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now only the exception to allow mount when number of missing
device is more than group profile tolerance count is
 RDONLY
this patch adds another lateral exception
 DEGRADED

This will enable user to recover from the following and
similar volume unavailability issue

raid1 volume:
 mkfs.btrfs -draid1 -mraid1 /dev/sdc /dev/sdd

unscan the device scan:
 modprobe -r btrfs && modprobe btrfs <= dev scanned is cleared

since kernel does not know about /dev/sdd use degraded
option to mount:
 mount -o degraded /dev/sdc /btrfs   <= sdd is not used
 umount /btrfs

problem: following umount the mount fails even with degraded option:
 mount -o degraded /dev/sdc /btrfs   <== fails.

because: unmount triggered commit used single profile which needs
all the disks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 fs/btrfs/super.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f2379d..3377f1a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2949,7 +2949,8 @@ retry_root_backup:
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
-	    !(sb->s_flags & MS_RDONLY)) {
+	    !(sb->s_flags & MS_RDONLY ||
+		btrfs_test_opt(fs_info->dev_root, DEGRADED))) {
 		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
 			fs_info->fs_devices->missing_devices,
 			fs_info->num_tolerated_disk_barrier_failures);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a8a0109..315035a2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1666,7 +1666,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		if (fs_info->fs_devices->missing_devices >
 		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		    !(*flags & MS_RDONLY ||
+			btrfs_test_opt(root, DEGRADED))) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
-- 
2.4.1

