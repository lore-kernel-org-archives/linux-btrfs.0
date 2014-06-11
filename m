Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59945 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751041AbaFKMPr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 08:15:47 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5BCFiJV029081
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 20:15:44 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix race condition between btrfs and udev
Date: Wed, 11 Jun 2014 20:11:38 +0800
Message-ID: <1402488698-12518-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally this problem was reproduced by the following scripts:

 # dd if=/dev/zero of=data bs=1M count=50
 # losetup /dev/loop1 data
 # i =1
 # while [ 1 ]
   do
   	mkfs.btrfs -fK /dev/loop1 >& /dev/null || exit 1
	((i++))
	echo "loop $i"
   done

Futher, a easy way to trigger this problem is by running the following
c codes repeatedly:

 int main(int argc, char **argv)
 {
 	/* pass a btrfs block device */
 	int fd = open(argv[1], O_RDWR | O_EXCL);
	if (fd < 0) {
		perror("fail to open: %s", strerror(errno));
		exit(1);
	}
	close(fd);
	return 0;
 }

So the problem is RW opening would trigger udev event which will
call btrfs_scan_one_device(). In btrfs_scan_one_device(), it
would open the block device with EXCL flag..meanwhile if another
program try to open that device with O_EXCL, it would fail with
EBUSY.

This happen seldomly in the real world, but if we use loop device
for test, we may hit this annoying problem.

A walkaround way to solve this problem is to wait kernel scanning
finished and then try it again.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c   | 36 +++++++++++++++++++++++++++++++++++-
 utils.h   |  1 +
 volumes.c |  3 ++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index d29de94..20108c3 100644
--- a/utils.c
+++ b/utils.c
@@ -2058,6 +2058,40 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	return 0;
 }
 
+/*
+ * there is a race condition between btrfs and udev, we may fail
+ * because udev call btrfs_scan_device() which will open the block
+ * device with O_EXCL. A walkaround solution is to wait kernel
+ * scanning finished and then try again.
+ */
+int btrfs_open_block_device(char *file, int flag)
+{
+	int ret, fd;
+	struct btrfs_ioctl_vol_args args;
+	int tried = 0;
+
+again:
+	fd = open(file, flag);
+	if (fd < 0) {
+		if (!tried && errno == EBUSY && (flag & O_EXCL)) {
+			tried = 1;
+			fd = open("/dev/btrfs-control", O_RDWR);
+			if (fd < 0) {
+				fprintf(stderr,
+					"unable to open /dev/btrfs-control: %s\n",
+					 strerror(errno));
+				return fd;
+			}
+			strncpy(args.name, file, BTRFS_PATH_NAME_MAX);
+			ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+			close(fd);
+			if (!ret)
+				goto again;
+		}
+	}
+	return fd;
+}
+
 /* Check if disk is suitable for btrfs
  * returns:
  *  1: something is wrong, estr provides the error
@@ -2096,7 +2130,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 		return 1;
 	}
 	/* check if the device is busy */
-	fd = open(file, O_RDWR|O_EXCL);
+	fd = btrfs_open_block_device(file, O_RDWR | O_EXCL);
 	if (fd < 0) {
 		snprintf(estr, sz, "unable to open %s: %s\n", file,
 			strerror(errno));
diff --git a/utils.h b/utils.h
index 0b03830..f6ca252 100644
--- a/utils.h
+++ b/utils.h
@@ -95,6 +95,7 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
+int btrfs_open_block_device(char *file, int flag);
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
diff --git a/volumes.c b/volumes.c
index a61928c..f40740a 100644
--- a/volumes.c
+++ b/volumes.c
@@ -30,6 +30,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "math.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -207,7 +208,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 			continue;
 		}
 
-		fd = open(device->name, flags);
+		fd = btrfs_open_block_device(device->name, flags);
 		if (fd < 0) {
 			ret = -errno;
 			goto fail;
-- 
1.9.0

