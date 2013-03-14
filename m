Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40120 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab3CNDF3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 23:05:29 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2E35Sk9015673
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:05:29 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2E35RTQ028676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:05:28 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2E35RIR006450
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 22:05:27 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by default
Date: Thu, 14 Mar 2013 11:05:57 +0800
Message-Id: <1363230357-7438-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1363230357-7438-1-git-send-email-anand.jain@oracle.com>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
 <1363230357-7438-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c   | 2 +-
 find-root.c | 2 +-
 volumes.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 796394f..c2e1c8a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -880,7 +880,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, sb_bytenr,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/find-root.c b/find-root.c
index 9be4fc7..9923209 100644
--- a/find-root.c
+++ b/find-root.c
@@ -151,7 +151,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/volumes.c b/volumes.c
index 1a28cdd..9003412 100644
--- a/volumes.c
+++ b/volumes.c
@@ -228,7 +228,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
-		BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
-- 
1.8.1.227.g44fe835

