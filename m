Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAKNS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 05:13:18 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r21ADH9L030211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:13:17 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r21ADGkr004473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 10:13:17 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r21ADGTh007798
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2013 04:13:16 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: traverse to backup super-block only when indicated
Date: Fri,  1 Mar 2013 18:13:20 +0800
Message-Id: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <5127022B.6070200@oracle.com>
References: <5127022B.6070200@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds 4th parameter to btrfs_scan_one_device()
which when set to non-zero value will traverse to check
backup super-block.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-show.c      |  2 +-
 btrfsctl.c        |  2 +-
 cmds-device.c     |  4 ++--
 cmds-filesystem.c |  4 ++--
 cmds-replace.c    |  2 +-
 disk-io.c         | 11 +++++++----
 disk-io.h         |  3 ++-
 find-root.c       |  6 +++---
 utils.c           | 19 ++++++++++---------
 utils.h           |  6 +++---
 volumes.c         |  4 ++--
 volumes.h         |  2 +-
 12 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/btrfs-show.c b/btrfs-show.c
index 8210fd2..7b1a35f 100644
--- a/btrfs-show.c
+++ b/btrfs-show.c
@@ -138,7 +138,7 @@ int main(int ac, char **av)
 		search = av[optind];
 	}
 
-	ret = btrfs_scan_one_dir("/dev", 0);
+	ret = btrfs_scan_one_dir("/dev", 0, 1);
 	if (ret)
 		fprintf(stderr, "error %d while scanning\n", ret);
 
diff --git a/btrfsctl.c b/btrfsctl.c
index 8fd8cc3..5be0961 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -115,7 +115,7 @@ int main(int ac, char **av)
 	
 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
-		btrfs_scan_one_dir("/dev", 1);
+		btrfs_scan_one_dir("/dev", 1, 1);
 		exit(0);
 	}
 	for (i = 1; i < ac; i++) {
diff --git a/cmds-device.c b/cmds-device.c
index 58df6da..dfc1f56 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -203,9 +203,9 @@ static int cmd_scan_dev(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems\n");
 		if(checklist)
-			ret = btrfs_scan_block_devices(1);
+			ret = btrfs_scan_block_devices(1, 1);
 		else
-			ret = btrfs_scan_one_dir("/dev", 1);
+			ret = btrfs_scan_one_dir("/dev", 1, 1);
 		if (ret){
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 2210020..b41457a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -257,9 +257,9 @@ static int cmd_show(int argc, char **argv)
 		usage(cmd_show_usage);
 
 	if(checklist)
-		ret = btrfs_scan_block_devices(0);
+		ret = btrfs_scan_block_devices(0, 1);
 	else
-		ret = btrfs_scan_one_dir("/dev", 0);
+		ret = btrfs_scan_one_dir("/dev", 0, 1);
 
 	if (ret){
 		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
diff --git a/cmds-replace.c b/cmds-replace.c
index 4cc32df..788a041 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -275,7 +275,7 @@ static int cmd_start_replace(int argc, char **argv)
 		goto leave_with_error;
 	}
 	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 1);
 	if (ret >= 0 && !force_using_targetdev) {
 		fprintf(stderr,
 			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
diff --git a/disk-io.c b/disk-io.c
index 897d0cf..f54c422 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -825,7 +825,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED);
 
 	ret = btrfs_scan_one_device(fp, path, &fs_devices,
-				    &total_devs, sb_bytenr);
+				    &total_devs, sb_bytenr, 1);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
@@ -833,7 +833,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1, 0);
 		if (ret)
 			goto out;
 	}
@@ -876,7 +876,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	fs_info->super_bytenr = sb_bytenr;
 	disk_super = &fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, sb_bytenr);
+				   disk_super, sb_bytenr, 1);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1099,7 +1099,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	return info->fs_root;
 }
 
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+	int rd_sb_mirror)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
@@ -1123,6 +1124,8 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		if (i > 0 && !rd_sb_mirror)
+			break;
 		bytenr = btrfs_sb_offset(i);
 		ret = pread64(fd, &buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
diff --git a/disk-io.h b/disk-io.h
index ff87958..2bc8b3e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -59,7 +59,8 @@ int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr);
+int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
+			int rd_sb_mirror);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
diff --git a/find-root.c b/find-root.c
index 20ff972..e84c8b1 100644
--- a/find-root.c
+++ b/find-root.c
@@ -102,7 +102,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	u64 features;
 
 	ret = btrfs_scan_one_device(fd, device, &fs_devices,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 1);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", device);
@@ -110,7 +110,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1, 1);
 		if (ret)
 			goto out;
 	}
@@ -149,7 +149,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	disk_super = &fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, BTRFS_SUPER_INFO_OFFSET);
+				   disk_super, BTRFS_SUPER_INFO_OFFSET, 1);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/utils.c b/utils.c
index 71da787..1f22660 100644
--- a/utils.c
+++ b/utils.c
@@ -835,12 +835,12 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1, 0)))
 			return ret;
 	}
 
@@ -951,7 +951,7 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
+int btrfs_scan_one_dir(char *dirname, int run_ioctl, int rd_sb_mirror)
 {
 	DIR *dirp = NULL;
 	struct dirent *dirent;
@@ -1031,7 +1031,7 @@ again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET, rd_sb_mirror);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1057,13 +1057,13 @@ fail:
 }
 
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+			int run_ioctls, int rd_sb_mirror)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	ret = btrfs_scan_block_devices(run_ioctls, rd_sb_mirror);
 	if (ret)
-		ret = btrfs_scan_one_dir("/dev", run_ioctls);
+		ret = btrfs_scan_one_dir("/dev", run_ioctls, rd_sb_mirror);
 	return ret;
 }
 
@@ -1294,7 +1294,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(int run_ioctl, int rd_sb_mirror)
 {
 
 	struct stat st;
@@ -1360,7 +1360,8 @@ scan_again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    rd_sb_mirror);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
diff --git a/utils.h b/utils.h
index 0b681ed..a71202e 100644
--- a/utils.h
+++ b/utils.h
@@ -35,9 +35,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls);
+			int run_ioctls, int rd_sb_mirror);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
+int btrfs_scan_one_dir(char *dirname, int run_ioctl, int rd_sb_mirror);
 int check_mounted(const char *devicename);
 int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
@@ -45,7 +45,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
-int btrfs_scan_block_devices(int run_ioctl);
+int btrfs_scan_block_devices(int run_ioctl, int rd_sb_mirror);
 u64 parse_size(char *s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
diff --git a/volumes.c b/volumes.c
index ca1b402..8e4dcea 100644
--- a/volumes.c
+++ b/volumes.c
@@ -211,7 +211,7 @@ fail:
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset)
+			  u64 *total_devs, u64 super_offset, int rd_sb_mirror)
 {
 	struct btrfs_super_block *disk_super;
 	char *buf;
@@ -225,7 +225,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 		goto error;
 	}
 	disk_super = (struct btrfs_super_block *)buf;
-	ret = btrfs_read_dev_super(fd, disk_super, super_offset);
+	ret = btrfs_read_dev_super(fd, disk_super, super_offset, rd_sb_mirror);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
diff --git a/volumes.h b/volumes.h
index 911f788..58110e2 100644
--- a/volumes.h
+++ b/volumes.h
@@ -179,7 +179,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset);
+			  u64 *total_devs, u64 super_offset, int rd_sb_mirror);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 			      struct btrfs_fs_devices *fs_devices);
-- 
1.8.1.227.g44fe835

