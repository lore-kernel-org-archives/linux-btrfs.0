Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23114 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbbHDOoo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 10:44:44 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t74EihJr001056
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t74EihaO027164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:43 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t74EiD5o019506
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/3] Btrfs: allow -o rw,degraded for single group profile
Date: Tue,  4 Aug 2015 22:43:51 +0800
Message-Id: <1438699433-1581-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now mount with missing device with degraded option is
allowed as long as number of missing devices is below the
number of device failure/missing that a group profile could
tolerate.

However there is feature/bug in the btrfs that when write
happens with least number of devices with which degraded mount
is possible, chunk allocation would default to single.

Which means any further mount with missing device will fail
even with degraded option as the number of device failure that
single group profile could tolerate is zero. Which also means
the user has to find the missing device to mount the FS RW able
to recover from this situation, which is not practical. A self
inflected problem.

test case eg:
 mkfs.btrfs -draid1 -mraid /dev/sdc /dev/sdd
 modprobe -r btrfs && modprobe btrfs  <== dev scan is cleared
 mount -o degraded /dev/sdc /btrfs <== sdd is not used
 dd if=/dev/zero of=/btrfs/tf1 count=1 <== creates single profile
 btrfs fi sync /btrfs
 umount /btrfs
 mount -o degraded /dev/sdc /btrfs  <== fails.
                    since single profile would need all the disks

This patch will let the RW mount to succeed with degraded option,
when the group profile tolerance is zero or below the number of
device missing. Now users have a choice to rebalance the group
profile back to their desired when missing device reappears during
the subsequent mounts.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 fs/btrfs/super.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2593952..da7b7bf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2897,7 +2897,8 @@ retry_root_backup:
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
 	if (fs_info->fs_devices->missing_devices >
 	     fs_info->num_tolerated_disk_barrier_failures &&
-	    !(sb->s_flags & MS_RDONLY)) {
+	    !(sb->s_flags & MS_RDONLY ||
+		btrfs_test_opt(fs_info->dev_root, DEGRADED))) {
 		printk(KERN_WARNING "BTRFS: "
 			"too many missing devices, writable mount is not allowed\n");
 		goto fail_sysfs;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 96a7857..16687c2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1656,7 +1656,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		if (fs_info->fs_devices->missing_devices >
 		     fs_info->num_tolerated_disk_barrier_failures &&
-		    !(*flags & MS_RDONLY)) {
+		    !(*flags & MS_RDONLY ||
+			btrfs_test_opt(root, DEGRADED))) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writable remount is not allowed");
 			ret = -EACCES;
-- 
2.4.1

