Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739Ab3E3DhJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:09 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3b6hV029318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:06 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b7kd021421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:07 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b7bi008761
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:07 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6 v2] btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
Date: Thu, 30 May 2013 11:40:21 +0800
Message-Id: <1369885226-3640-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_for_fsid uses only one argument run_ioctl out of 3
so remove the rest two of them

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-find-root.c | 2 +-
 disk-io.c         | 2 +-
 utils.c           | 5 ++---
 utils.h           | 3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..e736cb5 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -110,7 +110,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(1);
 		if (ret)
 			goto out;
 	}
diff --git a/disk-io.c b/disk-io.c
index 9ffe6e4..acd5480 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -838,7 +838,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(1);
 		if (ret)
 			goto out;
 	}
diff --git a/utils.c b/utils.c
index 7b4cd74..25f3cb4 100644
--- a/utils.c
+++ b/utils.c
@@ -928,7 +928,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(1)))
 			return ret;
 	}
 
@@ -1110,8 +1110,7 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
 
diff --git a/utils.h b/utils.h
index 3c17e14..dba37e8 100644
--- a/utils.h
+++ b/utils.h
@@ -35,8 +35,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
-int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls);
+int btrfs_scan_for_fsid(int run_ioctls);
 void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(const char *devicename);
-- 
1.8.1.227.g44fe835

