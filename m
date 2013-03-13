Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3CMLn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 07:43:57 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2DBhuVg009812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 11:43:57 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2DBhthS006794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 11:43:56 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2DBhtJK026854
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 06:43:55 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3 v3] btrfs-progs: disable using backup superblock by default
Date: Wed, 13 Mar 2013 19:44:20 +0800
Message-Id: <1363175060-30970-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1363175060-30970-1-git-send-email-anand.jain@oracle.com>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
 <1363175060-30970-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c   | 2 +-
 find-root.c | 2 +-
 volumes.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 796394f..030f080 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -880,7 +880,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, sb_bytenr,
-				   BTRFS_SCAN_BACKUP_SB);
+				   NULL);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/find-root.c b/find-root.c
index 9be4fc7..b74cd1e 100644
--- a/find-root.c
+++ b/find-root.c
@@ -151,7 +151,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET,
-				   BTRFS_SCAN_BACKUP_SB);
+				   NULL);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/volumes.c b/volumes.c
index 1a28cdd..dfd78fb 100644
--- a/volumes.c
+++ b/volumes.c
@@ -228,7 +228,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
-		BTRFS_SCAN_BACKUP_SB);
+				   NULL);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
-- 
1.8.1.227.g44fe835

