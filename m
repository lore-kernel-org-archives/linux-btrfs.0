Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42137 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3FZQo1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 12:44:27 -0400
Received: by mail-wg0-f45.google.com with SMTP id j13so10853191wgh.24
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 09:44:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2 5/5] Btrfs-progs: Validate super block checksum
Date: Wed, 26 Jun 2013 17:42:46 +0100
Message-Id: <1372264966-10251-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After finding a super block in a device also validate its
checksum. This validation is done in the kernel but it was
missing in btrfs-progs.

The function btrfs_check_super_csum() is imported from the
file fs/btrfs/disk-io.c in the kernel source tree.

v2:

When finding the super block for a device ignore checksum
validation failures if we're running the btrfsck tool, the
restore or check commands of the btrfs tool, btrfs-debug-tree
or btrfs-find-root tools. For all cases, print a warning
message whenever the checksum validation fails, mentioning
the superblock offset and device path.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 btrfs-debug-tree.c |    2 +-
 btrfs-find-root.c  |    8 ++--
 cmds-check.c       |    2 +-
 cmds-device.c      |    2 +-
 cmds-filesystem.c  |    2 +-
 cmds-replace.c     |    2 +-
 cmds-restore.c     |    2 +-
 disk-io.c          |  103 ++++++++++++++++++++++++++++++++++++++++------------
 disk-io.h          |    7 +++-
 utils.c            |   15 ++++----
 utils.h            |    4 +-
 volumes.c          |    6 ++-
 volumes.h          |    3 +-
 13 files changed, 110 insertions(+), 48 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 74d4d66..6fa9e83 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -166,7 +166,7 @@ int main(int ac, char **av)
 	if (ac != 1)
 		print_usage();
 
-	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1);
+	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1, 1);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 810d835..d7abc8a 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
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
@@ -149,8 +149,8 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	disk_super = fs_info->super_copy;
-	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, BTRFS_SUPER_INFO_OFFSET);
+	ret = btrfs_read_dev_super(fs_devices->latest_bdev, device,
+				   disk_super, BTRFS_SUPER_INFO_OFFSET, 1);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/cmds-check.c b/cmds-check.c
index 68cdd52..7aa5e82 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5185,7 +5185,7 @@ int cmd_check(int argc, char **argv)
 		return -EBUSY;
 	}
 
-	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1);
+	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1, 1);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		return -EIO;
diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..723ce2e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -203,7 +203,7 @@ static int cmd_scan_dev(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems\n");
 		if(checklist)
-			ret = btrfs_scan_block_devices(1);
+			ret = btrfs_scan_block_devices(1, 0);
 		else
 			ret = btrfs_scan_one_dir("/dev", 1);
 		if (ret){
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..2178986 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -257,7 +257,7 @@ static int cmd_show(int argc, char **argv)
 		usage(cmd_show_usage);
 
 	if(checklist)
-		ret = btrfs_scan_block_devices(0);
+		ret = btrfs_scan_block_devices(0, 0);
 	else
 		ret = btrfs_scan_one_dir("/dev", 0);
 
diff --git a/cmds-replace.c b/cmds-replace.c
index 6397bb5..16b17f0 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -280,7 +280,7 @@ static int cmd_start_replace(int argc, char **argv)
 		goto leave_with_error;
 	}
 	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0);
 	if (ret >= 0 && !force_using_targetdev) {
 		fprintf(stderr,
 			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
diff --git a/cmds-restore.c b/cmds-restore.c
index eca528d..39f19cd 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -842,7 +842,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0, 1);
+		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0, 1, 1);
 		if (fs_info)
 			break;
 		fprintf(stderr, "Could not open root, trying backup super\n");
diff --git a/disk-io.c b/disk-io.c
index 768adda..350daa1 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -801,7 +801,8 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr, int writes,
-					     int partial)
+					     int partial,
+					     int ignore_sb_csum)
 {
 	u32 sectorsize;
 	u32 nodesize;
@@ -830,7 +831,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fprintf(stderr, "Warning, could not drop caches\n");
 
 	ret = btrfs_scan_one_device(fp, path, &fs_devices,
-				    &total_devs, sb_bytenr);
+				    &total_devs, sb_bytenr, ignore_sb_csum);
 
 	if (ret) {
 		fprintf(stderr, "No valid Btrfs found on %s\n", path);
@@ -838,7 +839,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1, ignore_sb_csum);
 		if (ret)
 			goto out;
 	}
@@ -881,8 +882,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	fs_info->super_bytenr = sb_bytenr;
 	disk_super = fs_info->super_copy;
-	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, sb_bytenr);
+	ret = btrfs_read_dev_super(fs_devices->latest_bdev, path,
+				   disk_super, sb_bytenr, ignore_sb_csum);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
@@ -1048,7 +1049,8 @@ out:
 
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial)
+					 int writes, int partial,
+					 int ignore_sb_csum)
 {
 	int fp;
 	struct btrfs_fs_info *info;
@@ -1063,7 +1065,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial);
+			       writes, partial, ignore_sb_csum);
 	close(fp);
 	return info;
 }
@@ -1072,7 +1074,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 {
 	struct btrfs_fs_info *info;
 
-	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0);
+	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
@@ -1082,53 +1084,106 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
 }
 
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
+static int btrfs_check_super_csum(char *raw_disk_sb, const char *path)
+{
+	struct btrfs_super_block *disk_sb =
+		(struct btrfs_super_block *)raw_disk_sb;
+	u16 csum_type = btrfs_super_csum_type(disk_sb);
+	int ret = 0;
+
+	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
+		u32 crc = ~(u32)0;
+		const int csum_size = sizeof(crc);
+		char result[csum_size];
+
+		/*
+		 * The super_block structure does not span the whole
+		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
+		 * is filled with zeros and is included in the checkum.
+		 */
+		crc = btrfs_csum_data(NULL, raw_disk_sb + BTRFS_CSUM_SIZE,
+				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, result);
+
+		if (memcmp(raw_disk_sb, result, csum_size))
+			ret = 1;
+
+		if (ret && btrfs_super_generation(disk_sb) < 1) {
+			fprintf(stderr, "Super block CRCs don't match, "
+				"older mkfs detected\n");
+			ret = 0;
+		}
+	}
+
+	if (ret) {
+		fprintf(stderr,
+			"Super block checksum validation failed, offset %llu,"
+			" device %s\n",
+			(unsigned long long)btrfs_super_bytenr(disk_sb), path);
+	}
+
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		fprintf(stderr, "Unsupported super block checksum algorithm %u\n",
+			csum_type);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+int btrfs_read_dev_super(int fd, const char *path,
+			 struct btrfs_super_block *sb, u64 sb_bytenr,
+			 int ignore_sb_csum)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
-	struct btrfs_super_block buf;
+	char buf[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *tmp_sb = (struct btrfs_super_block *)buf;
 	int i;
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
+		ret = pread64(fd, buf, sizeof(buf), sb_bytenr);
 		if (ret < sizeof(buf))
 			return -1;
 
-		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
-		    buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		if (btrfs_super_bytenr(tmp_sb) != sb_bytenr ||
+		    tmp_sb->magic != cpu_to_le64(BTRFS_MAGIC) ||
+		    (btrfs_check_super_csum(buf, path) && !ignore_sb_csum))
 			return -1;
 
-		memcpy(sb, &buf, sizeof(*sb));
+		memcpy(sb, buf, sizeof(*sb));
 		return 0;
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = pread64(fd, &buf, sizeof(buf), bytenr);
+		ret = pread64(fd, buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr )
+		if (btrfs_super_bytenr(tmp_sb) != bytenr )
 			continue;
 		/* if magic is NULL, the device was removed */
-		if (buf.magic == 0 && i == 0) 
+		if (tmp_sb->magic == 0 && i == 0)
 			return -1;
-		if (buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		if (tmp_sb->magic != cpu_to_le64(BTRFS_MAGIC))
+			continue;
+		if (btrfs_check_super_csum(buf, path) && !ignore_sb_csum)
 			continue;
 
 		if (!fsid_is_initialized) {
-			memcpy(fsid, buf.fsid, sizeof(fsid));
+			memcpy(fsid, tmp_sb->fsid, sizeof(fsid));
 			fsid_is_initialized = 1;
-		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+		} else if (memcmp(fsid, tmp_sb->fsid, sizeof(fsid))) {
 			/*
 			 * the superblocks (the original one and
 			 * its backups) contain data of different
@@ -1137,9 +1192,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 			continue;
 		}
 
-		if (btrfs_super_generation(&buf) > transid) {
-			memcpy(sb, &buf, sizeof(*sb));
-			transid = btrfs_super_generation(&buf);
+		if (btrfs_super_generation(tmp_sb) > transid) {
+			memcpy(sb, buf, sizeof(*sb));
+			transid = btrfs_super_generation(tmp_sb);
 		}
 	}
 
diff --git a/disk-io.h b/disk-io.h
index c29ee8e..f061998 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -52,12 +52,15 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial);
+					 int writes, int partial,
+					 int ignore_sb_csum);
 int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr);
+int btrfs_read_dev_super(int fd, const char *path,
+			 struct btrfs_super_block *sb, u64 sb_bytenr,
+			 int ignore_sb_csum);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
diff --git a/utils.c b/utils.c
index 7b4cd74..4c9e89a 100644
--- a/utils.c
+++ b/utils.c
@@ -923,12 +923,12 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 1);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1, 1)))
 			return ret;
 	}
 
@@ -1085,7 +1085,7 @@ again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET, 0);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
@@ -1111,11 +1111,11 @@ fail:
 }
 
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls)
+			int run_ioctls, int ignore_sb_csum)
 {
 	int ret;
 
-	ret = btrfs_scan_block_devices(run_ioctls);
+	ret = btrfs_scan_block_devices(run_ioctls, ignore_sb_csum);
 	if (ret)
 		ret = btrfs_scan_one_dir("/dev", run_ioctls);
 	return ret;
@@ -1350,7 +1350,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(int run_ioctl, int ignore_sb_csum)
 {
 
 	struct stat st;
@@ -1416,7 +1416,8 @@ scan_again:
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
-					    BTRFS_SUPER_INFO_OFFSET);
+					    BTRFS_SUPER_INFO_OFFSET,
+					    ignore_sb_csum);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
diff --git a/utils.h b/utils.h
index 3c17e14..9c1a98e 100644
--- a/utils.h
+++ b/utils.h
@@ -36,7 +36,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
-			int run_ioctls);
+			int run_ioctls, int ignore_sb_csum);
 void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(const char *devicename);
@@ -46,7 +46,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 int get_mountpt(char *dev, char *mntpt, size_t size);
-int btrfs_scan_block_devices(int run_ioctl);
+int btrfs_scan_block_devices(int run_ioctl, int ignore_sb_csum);
 u64 parse_size(char *s);
 int open_file_or_dir(const char *fname);
 int get_device_info(int fd, u64 devid,
diff --git a/volumes.c b/volumes.c
index 061f094..3178281 100644
--- a/volumes.c
+++ b/volumes.c
@@ -213,7 +213,8 @@ fail:
 
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset)
+			  u64 *total_devs, u64 super_offset,
+			  int ignore_sb_csum)
 {
 	struct btrfs_super_block *disk_super;
 	char *buf;
@@ -227,7 +228,8 @@ int btrfs_scan_one_device(int fd, const char *path,
 		goto error;
 	}
 	disk_super = (struct btrfs_super_block *)buf;
-	ret = btrfs_read_dev_super(fd, disk_super, super_offset);
+	ret = btrfs_read_dev_super(fd, path,
+				   disk_super, super_offset, ignore_sb_csum);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
diff --git a/volumes.h b/volumes.h
index 911f788..e8d1534 100644
--- a/volumes.h
+++ b/volumes.h
@@ -179,7 +179,8 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
-			  u64 *total_devs, u64 super_offset);
+			  u64 *total_devs, u64 super_offset,
+			  int ignore_sb_csum);
 int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 			      struct btrfs_fs_devices *fs_devices);
-- 
1.7.9.5

