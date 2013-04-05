Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38336 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3DEFxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:06 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355r52F001250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355r4fT003205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:05 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355r4RK021089
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:04 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs-progs: disable using backup superblock by default
Date: Fri,  5 Apr 2013 13:54:18 +0800
Message-Id: <1365141259-10529-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
References: <5127022B.6070200@oracle.com>
 <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

except for check_mounted 

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c   | 2 +-
 find-root.c | 2 +-
 utils.c     | 2 +-
 volumes.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 82c3b66..589b37a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -881,7 +881,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, sb_bytenr,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/find-root.c b/find-root.c
index eac3d79..27512df 100644
--- a/find-root.c
+++ b/find-root.c
@@ -153,7 +153,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/utils.c b/utils.c
index 3b46889..27574a0 100644
--- a/utils.c
+++ b/utils.c
@@ -923,7 +923,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
 				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
-				    0ull);
+				    BTRFS_SCAN_BACKUP_SB);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
diff --git a/volumes.c b/volumes.c
index a18b219..b555ded 100644
--- a/volumes.c
+++ b/volumes.c
@@ -228,7 +228,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
-			BTRFS_SCAN_BACKUP_SB);
+			flags);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
-- 
1.8.1.227.g44fe835

