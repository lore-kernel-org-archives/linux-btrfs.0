Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaJWNBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 09:01:18 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s9ND1Hsp013688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 13:01:18 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s9ND1FHl022581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 13:01:16 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s9ND1F6U018038
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 13:01:15 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v2] btrfs-progs: optimize btrfs_scan_lblkid() for multiple calls
Date: Thu, 23 Oct 2014 14:30:08 +0800
Message-Id: <1414045808-6930-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1413334270-25766-2-git-send-email-anand.jain@oracle.com>
References: <1413334270-25766-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_lblikd() is called by most the device related command functions.
And btrfs_scan_lblkid() is most expensive function and it becomes more expensive
as number of devices in the system increase. Further some threads call this
function more than once for absolutely no extra benefit and the real waste of
resources.

  btrfs-find-root            1
  btrfs rescue super-recover 2
  btrfs-debug-tree           1
  btrfs-image -r             2
  btrfs check                2
  btrfs restore              2
  calc-size                  NC
  btrfs-corrupt-block        NC
  btrfs-image                NC
  btrfs-map-logical          1
  btrfs-select-super         NC
  btrfstune                  2
  btrfs-zero-log             NC
  tester                     NC
  quick-test.c               NC
  btrfs-convert              0
  mkfs                       #number of devices to be mkfs
  btrfs label set unmounted  2
  btrfs get label unmounted  2

This patch will:
  move out calling register_one_device with in btrfs_scan_lblkid()
  and so function setting the BTRFS_UPDATE_KERNEL to yes will
  call btrfs_register_all_devices() separately.

  introduce a global variable scan_done, which is set when scan is
  done succssfully per thread. So that following calls to this function
  will just return success.

  Further if any function needs to force scan after scan_done is set,
  then it can be done when there is such a requirement, but as of now there
  isn't any such requirement.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: rebase on 3.17. And add more info to commit

 cmds-device.c     |  7 ++++++-
 cmds-filesystem.c |  2 +-
 disk-io.c         |  2 +-
 utils.c           | 14 ++++++++++----
 utils.h           |  2 +-
 5 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 8a33634..519314b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -28,6 +28,8 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
+#include "volumes.h"
+
 
 #include "commands.h"
 
@@ -235,9 +237,12 @@ static int cmd_scan_dev(int argc, char **argv)
 
 	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = btrfs_scan_lblkid(BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid();
 		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		ret = btrfs_register_all_devices();
+		if (ret)
+			fprintf(stderr, "ERROR: error %d while registering\n", ret);
 		goto out;
 	}
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 695a3d5..011907d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -698,7 +698,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+	ret = btrfs_scan_lblkid();
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index 77fc610..2fb50f9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1012,7 +1012,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid();
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index 90e228b..a8691fe 100644
--- a/utils.c
+++ b/utils.c
@@ -52,6 +52,8 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+int scan_done = 0;
+
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
 void fixup_argv0(char **argv, const char *token)
@@ -1186,7 +1188,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid();
 		if (ret)
 			return ret;
 	}
@@ -2169,7 +2171,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int btrfs_scan_lblkid(int update_kernel)
+int btrfs_scan_lblkid()
 {
 	int fd = -1;
 	int ret;
@@ -2180,6 +2182,9 @@ int btrfs_scan_lblkid(int update_kernel)
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
 
+	if (scan_done)
+		return 0;
+
 	if (blkid_get_cache(&cache, 0) < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
@@ -2208,11 +2213,12 @@ int btrfs_scan_lblkid(int update_kernel)
 		}
 
 		close(fd);
-		if (update_kernel)
-			btrfs_register_one_device(path);
 	}
 	blkid_dev_iterate_end(iter);
 	blkid_put_cache(cache);
+
+	scan_done = 1;
+
 	return 0;
 }
 
diff --git a/utils.h b/utils.h
index fea26ef..d1af33d 100644
--- a/utils.h
+++ b/utils.h
@@ -127,7 +127,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
-int btrfs_scan_lblkid(int update_kernel);
+int btrfs_scan_lblkid(void);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int find_mount_root(const char *path, char **mount_root);
 int get_device_info(int fd, u64 devid,
-- 
2.0.0.153.g79dcccc

