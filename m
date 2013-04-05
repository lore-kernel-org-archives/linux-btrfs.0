Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38311 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3DEFxC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:02 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355r13p001004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:01 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355r0fU000199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:00 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355r0ra021053
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:00 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
Date: Fri,  5 Apr 2013 13:54:15 +0800
Message-Id: <1365141259-10529-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
References: <5127022B.6070200@oracle.com>
 <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce flag BTRFS_SCAN_REGISTER to replace the parameter run_ioctl
which controls calling the function btrfs_register_one_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |  4 ++--
 disk-io.c     |  3 ++-
 find-root.c   |  3 ++-
 utils.c       | 20 +++++++++++---------
 utils.h       |  7 ++++---
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..a90fb67 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -203,9 +203,9 @@ static int cmd_scan_dev(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems\n");
 		if(checklist)
-			ret = btrfs_scan_block_devices(1);
+			ret = btrfs_scan_block_devices(BTRFS_SCAN_REGISTER);
 		else
-			ret = btrfs_scan_one_dir("/dev", 1);
+			ret = btrfs_scan_one_dir("/dev", BTRFS_SCAN_REGISTER);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
diff --git a/disk-io.c b/disk-io.c
index be4abb8..6a03e9c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -835,7 +835,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
+			BTRFS_SCAN_REGISTER);
 		if (ret)
 			goto out;
 	}
diff --git a/find-root.c b/find-root.c
index 810d835..16920ed 100644
--- a/find-root.c
+++ b/find-root.c
@@ -110,7 +110,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
+			BTRFS_SCAN_REGISTER);
 		if (ret)
 			goto out;
 	}
diff --git a/utils.c b/utils.c
index a4f7b06..a15789e 100644
--- a/utils.c
+++ b/utils.c
@@ -927,7 +927,8 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs,
+				BTRFS_SCAN_REGISTER)))
 			return ret;
 	}
 
@@ -1039,7 +1040,7 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
+int btrfs_scan_one_dir(char *dirname, u64 flags)
 {
 	DIR *dirp = NULL;
 	struct dirent *dirent;
@@ -1112,7 +1113,8 @@ again:
 				ENOMEDIUM (No medium found -> 
 					like a cd tray empty)
 			*/
-			if(errno != ENXIO && errno != ENOMEDIUM) 
+			if(errno != ENXIO && errno != ENOMEDIUM &&
+				errno != EBUSY)
 				fprintf(stderr, "failed to read %s: %s\n", 
 					fullpath, strerror(errno));
 			continue;
@@ -1120,7 +1122,7 @@ again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
@@ -1145,13 +1147,13 @@ fail:
 }
 
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+			u64 flags)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	ret = btrfs_scan_block_devices(flags);
 	if (ret)
-		ret = btrfs_scan_one_dir("/dev", run_ioctls);
+		ret = btrfs_scan_one_dir("/dev", flags);
 	return ret;
 }
 
@@ -1384,7 +1386,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(u64 flags)
 {
 
 	struct stat st;
@@ -1451,7 +1453,7 @@ scan_again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
diff --git a/utils.h b/utils.h
index 4dcdc31..1de5143 100644
--- a/utils.h
+++ b/utils.h
@@ -23,6 +23,7 @@
 #include "ctree.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define BTRFS_SCAN_REGISTER	(1ULL << 1)
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -36,9 +37,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls);
+			u64 flags);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
+int btrfs_scan_one_dir(char *dirname, u64 flags);
 int check_mounted(const char *devicename);
 int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
@@ -46,7 +47,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
-int btrfs_scan_block_devices(int run_ioctl);
+int btrfs_scan_block_devices(u64 flags);
 u64 parse_size(char *s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
-- 
1.8.1.227.g44fe835

