Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58245 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757154AbaIRDcj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 23:32:39 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/3] btrfs-progs: remove BTRFS_SCAN_PROC scan method
Date: Thu, 18 Sep 2014 11:31:44 +0800
Message-ID: <1411011106-21945-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

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
index a7183e3..a728f21 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -200,13 +200,13 @@ static int cmd_rm_dev(int argc, char **argv)
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
@@ -224,7 +224,6 @@ static int cmd_scan_dev(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
 			all = 1;
 			break;
 		default:
@@ -237,7 +236,7 @@ static int cmd_scan_dev(int argc, char **argv)
 
 	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid(BTRFS_UPDATE_KERNEL);
 		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 		goto out;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 69c1ca5..dc5185e 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -505,7 +505,7 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
-	int where = BTRFS_SCAN_LBLKID;
+	int where = -1; // default, search both kernel and udev
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
@@ -526,7 +526,7 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
+			where = BTRFS_SCAN_LBLKID;
 			break;
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
@@ -550,7 +550,7 @@ static int cmd_show(int argc, char **argv)
 		 * right away
 		 */
 		if (type == BTRFS_ARG_BLKDEV) {
-			if (where == BTRFS_SCAN_PROC) {
+			if (where == BTRFS_SCAN_LBLKID) {
 				/* we need to do this because
 				 * legacy BTRFS_SCAN_DEV
 				 * provides /dev/dm-x paths
@@ -586,7 +586,7 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (where == BTRFS_SCAN_PROC)
+	if (where == BTRFS_SCAN_LBLKID)
 		goto devs_only;
 
 	/* show mounted btrfs */
@@ -601,7 +601,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = scan_for_btrfs(where, !BTRFS_UPDATE_KERNEL);
+	ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index c7901f4..9fe8769 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1005,7 +1005,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctl);
+		ret = btrfs_scan_lblkid(run_ioctl);
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index fb78dd6..0ae0475 100644
--- a/utils.c
+++ b/utils.c
@@ -1150,7 +1150,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if ((ret = scan_for_btrfs(BTRFS_SCAN_PROC, !BTRFS_UPDATE_KERNEL)))
+		if ((ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL)))
 			return ret;
 	}
 
@@ -2181,9 +2181,6 @@ int scan_for_btrfs(int where, int update_kernel)
 	int ret = 0;
 
 	switch (where) {
-	case BTRFS_SCAN_PROC:
-		ret = btrfs_scan_block_devices(update_kernel);
-		break;
 	case BTRFS_SCAN_LBLKID:
 		ret = btrfs_scan_lblkid(update_kernel);
 		break;
diff --git a/utils.h b/utils.h
index 01b3259..13f2e60 100644
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
1.8.1.4

