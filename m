Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27484 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaJOIon (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:44:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 2/2] btrfs-progs: optimize btrfs_scan_lblkid() for multiple calls
Date: Wed, 15 Oct 2014 08:51:10 +0800
Message-Id: <1413334270-25766-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_lblikd is called by most the device related command functions.
And btrfs_scan_lblkid is most expensive function and it becomes more expensive
as number of devices in the system increase.

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
 cmds-device.c     |  6 +++++-
 cmds-filesystem.c |  2 +-
 disk-io.c         |  2 +-
 utils.c           | 14 ++++++++++----
 utils.h           |  2 +-
 5 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 57ad0b2..d4605fd 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -29,6 +29,7 @@
 #include "ioctl.h"
 #include "utils.h"
 #include "cmds-fi-disk_usage.h"
+#include "volumes.h"
 
 #include "commands.h"
 
@@ -236,9 +237,12 @@ static int cmd_scan_dev(int argc, char **argv)
 
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
index 6fcf111..4a3c09c 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -661,7 +661,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+	ret = btrfs_scan_lblkid();
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index 7ef5ac4..6a053ea 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1013,7 +1013,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid();
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index 017c513..f18cc46 100644
--- a/utils.c
+++ b/utils.c
@@ -54,6 +54,8 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+int scan_done = 0;
+
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
 void fixup_argv0(char **argv, const char *token)
@@ -1183,7 +1185,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		ret = btrfs_scan_lblkid(!BTRFS_UPDATE_KERNEL);
+		ret = btrfs_scan_lblkid();
 		if (ret)
 			return ret;
 	}
@@ -2093,7 +2095,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int btrfs_scan_lblkid(int update_kernel)
+int btrfs_scan_lblkid()
 {
 	int fd = -1;
 	int ret;
@@ -2104,6 +2106,9 @@ int btrfs_scan_lblkid(int update_kernel)
 	blkid_cache cache = NULL;
 	char path[PATH_MAX];
 
+	if (scan_done)
+		return 0;
+
 	if (blkid_get_cache(&cache, 0) < 0) {
 		printf("ERROR: lblkid cache get failed\n");
 		return 1;
@@ -2132,11 +2137,12 @@ int btrfs_scan_lblkid(int update_kernel)
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
index 237cf64..ab0c49e 100644
--- a/utils.h
+++ b/utils.h
@@ -126,7 +126,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
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

