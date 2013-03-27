Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3C0KH1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 06:07:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com, dsterba@suse.cz
Subject: [PATCH 2/5 v5] btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
Date: Wed, 27 Mar 2013 18:07:33 +0800
Message-Id: <1364378856-21053-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
References: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
 <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce flag BTRFS_SCAN_REGISTER to replace the parameter run_ioctl
which controls calling the function btrfs_register_one_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |  4 ++--
 disk-io.c     |  3 ++-
 find-root.c   |  3 ++-
 utils.c       | 17 +++++++++--------
 utils.h       |  7 ++++---
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index b8d05fd..edff0bf 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -218,9 +218,9 @@ static int cmd_scan_dev(int argc, char **argv)
 
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
index 3a0d444..15645c1 100644
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
@@ -1128,7 +1129,7 @@ again:
 					    BTRFS_SUPER_INFO_OFFSET);
 		close(fd);
 
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 	}
@@ -1152,13 +1153,13 @@ fail:
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
 
@@ -1391,7 +1392,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(u64 flags)
 {
 
 	struct stat st;
@@ -1469,7 +1470,7 @@ scan_again:
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
 		close(fd);
-		if (ret == 0 && run_ioctl > 0) {
+		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
 			btrfs_register_one_device(fullpath);
 		}
 	}
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

