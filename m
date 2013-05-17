Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27178 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3EQKv5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:51:57 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HApsWa023583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:55 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApt5j005241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:56 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAptbr005235
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:55 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
Date: Fri, 17 May 2013 18:54:42 +0800
Message-Id: <1368788082-12090-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_for_fsid uses only one argument run_ioctl out of 3
so remove the rest two of them

and also update to use the new function
scan_devs_for_btrfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-find-root.c |  2 +-
 disk-io.c         |  2 +-
 utils.c           | 12 +++++++-----
 utils.h           |  3 +--
 4 files changed, 10 insertions(+), 9 deletions(-)

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
index 21b410d..574cca9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -835,7 +835,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(1);
 		if (ret)
 			goto out;
 	}
diff --git a/utils.c b/utils.c
index 663670b..18148c7 100644
--- a/utils.c
+++ b/utils.c
@@ -928,7 +928,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(1)))
 			return ret;
 	}
 
@@ -1114,14 +1114,16 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	/* try the default (0) fist which will scan /dev/mapper and
+	 * /proc/partitions and then /dev (2)
+	*/
+	ret = scan_devs_for_btrfs(0, run_ioctls);
 	if (ret)
-		ret = btrfs_scan_one_dir("/dev", run_ioctls);
+		ret = scan_devs_for_btrfs(2, run_ioctls);
 	return ret;
 }
 
diff --git a/utils.h b/utils.h
index 375c15a..b57044a 100644
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

