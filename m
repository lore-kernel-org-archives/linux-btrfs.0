Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3CHPYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2013 10:24:43 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r28FOgB0015728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:43 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r28FOfGC007199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:42 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r28FOfnp023266
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 09:24:41 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
Date: Fri,  8 Mar 2013 23:24:58 +0800
Message-Id: <1362756300-30212-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>

Introduce flag BTRFS_SCAN_REGISTER to replace the parameter run_ioctl
which controls calling the function btrfs_register_one_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfsctl.c    |  2 +-
 cmds-device.c |  4 ++--
 disk-io.c     |  3 ++-
 find-root.c   |  3 ++-
 utils.c       | 17 +++++++++--------
 utils.h       |  7 ++++---
 6 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 8fd8cc3..75bc52d 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -115,7 +115,7 @@ int main(int ac, char **av)
 	
 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
-		btrfs_scan_one_dir("/dev", 1);
+		btrfs_scan_one_dir("/dev", BTRFS_SCAN_REGISTER);
 		exit(0);
 	}
 	for (i = 1; i < ac; i++) {
diff --git a/cmds-device.c b/cmds-device.c
index 58df6da..1b8f378 100644
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
index 897d0cf..5197456 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -833,7 +833,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs,
+			BTRFS_SCAN_REGISTER);
 		if (ret)
 			goto out;
 	}
diff --git a/find-root.c b/find-root.c
index 20ff972..234daf4 100644
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
index 1813dda..feee572 100644
--- a/utils.c
+++ b/utils.c
@@ -840,7 +840,8 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs,
+				BTRFS_SCAN_REGISTER)))
 			return ret;
 	}
 
@@ -951,7 +952,7 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
+int btrfs_scan_one_dir(char *dirname, u64 flags)
 {
 	DIR *dirp = NULL;
 	struct dirent *dirent;
@@ -1032,7 +1033,7 @@ again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
@@ -1057,13 +1058,13 @@ fail:
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
 
@@ -1294,7 +1295,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(u64 flags)
 {
 
 	struct stat st;
@@ -1361,7 +1362,7 @@ scan_again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
diff --git a/utils.h b/utils.h
index 0b681ed..c4d0d00 100644
--- a/utils.h
+++ b/utils.h
@@ -22,6 +22,7 @@
 #include "ctree.h"
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define BTRFS_SCAN_REGISTER	(1ULL << 1)
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -35,9 +36,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
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
@@ -45,7 +46,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
-int btrfs_scan_block_devices(int run_ioctl);
+int btrfs_scan_block_devices(u64 flags);
 u64 parse_size(char *s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
-- 
1.8.1.191.g414c78c

