Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39297 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaIMJLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 05:11:52 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s8D9BpJ7032619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:52 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s8D9BoOD002432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:50 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s8D9BnCH004812
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 09:11:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs-progs: remove BTRFS_SCAN_PROC scan method
Date: Sat, 13 Sep 2014 09:21:21 +0800
Message-Id: <1410571282-3482-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
References: <1410571282-3482-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The libblkid scan method which was introduced later, will also
scan devices under /proc/partitions. So we don't have to do
the explicit scan of the same.

Remove the scan method BTRFS_SCAN_PROC.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |  5 ++---
 cmds-filesystem.c | 10 +++++-----
 disk-io.c         |  2 +-
 utils.c           |  5 +----
 utils.h           |  5 ++---
 5 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index ad0bd35..86787a4 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -199,13 +199,13 @@ static int cmd_rm_dev(int argc, char **argv)
 static const char * const cmd_scan_dev_usage[] = {
 	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
+	" -d|--all-devices (deprecated)",
 	NULL
 };
 
 static int cmd_scan_dev(int argc, char **argv)
 {
 	int i, fd, e;
-	int where = BTRFS_SCAN_LBLKID;
 	int devstart = 1;
 	int all = 0;
 	int ret = 0;
@@ -223,7 +223,6 @@ static int cmd_scan_dev(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
 			all = 1;
 			break;
 		default:
@@ -236,7 +235,7 @@ static int cmd_scan_dev(int argc, char **argv)
 
 	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid(BTRFS_UPDATE_KERNEL);
 		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 		goto out;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 818e05f..ebaccca 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -542,7 +542,7 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
-	int where = BTRFS_SCAN_LBLKID;
+	int where = -1; // default, search both kernel and udev
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
@@ -563,7 +563,7 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
+			where = BTRFS_SCAN_LBLKID;
 			break;
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
@@ -587,7 +587,7 @@ static int cmd_show(int argc, char **argv)
 		 * right away
 		 */
 		if (type == BTRFS_ARG_BLKDEV) {
-			if (where == BTRFS_SCAN_PROC) {
+			if (where == BTRFS_SCAN_LBLKID) {
 				/* we need to do this because
 				 * legacy BTRFS_SCAN_DEV
 				 * provides /dev/dm-x paths
@@ -618,7 +618,7 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (where == BTRFS_SCAN_PROC)
+	if (where == BTRFS_SCAN_LBLKID)
 		goto devs_only;
 
 	/* show mounted btrfs */
@@ -633,7 +633,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = scan_for_btrfs(where, !BTRFS_UPDATE_KERNEL);
+	ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index 2a1f6d4..bb011d0 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1007,7 +1007,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctl);
+		ret = btrfs_scan_lblkid(run_ioctl);
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index 901127f..7c1e48b 100644
--- a/utils.c
+++ b/utils.c
@@ -1148,7 +1148,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if ((ret = scan_for_btrfs(BTRFS_SCAN_PROC, !BTRFS_UPDATE_KERNEL)))
+		if ((ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL)))
 			return ret;
 	}
 
@@ -2133,9 +2133,6 @@ int scan_for_btrfs(int where, int update_kernel)
 	int ret = 0;
 
 	switch (where) {
-	case BTRFS_SCAN_PROC:
-		ret = btrfs_scan_block_devices(update_kernel);
-		break;
 	case BTRFS_SCAN_LBLKID:
 		ret = btrfs_scan_lblkid(update_kernel);
 		break;
diff --git a/utils.h b/utils.h
index 52a9dfc..ea0d5d4 100644
--- a/utils.h
+++ b/utils.h
@@ -26,9 +26,8 @@
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
 
-#define BTRFS_SCAN_PROC		(1ULL << 0)
-#define BTRFS_SCAN_MOUNTED	(1ULL << 1)
-#define BTRFS_SCAN_LBLKID	(1ULL << 2)
+#define BTRFS_SCAN_MOUNTED	(1ULL << 0)
+#define BTRFS_SCAN_LBLKID	(1ULL << 1)
 
 #define BTRFS_UPDATE_KERNEL	1
 
-- 
2.0.0.153.g79dcccc

