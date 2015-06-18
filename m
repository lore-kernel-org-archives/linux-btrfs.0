Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50186 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821AbbFRGqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 02:46:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5I6icCG009954
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 14:44:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Allow "filesystem show" command to handle different units
Date: Thu, 18 Jun 2015 14:46:11 +0800
Message-ID: <1434609972-8513-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now "filesystem show" command can handle different units now.

This is handy for higher level programs to get accurate output from "fi
show" command.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 66 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 14 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index dcd3f47..a9dbcfe 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -375,7 +375,7 @@ static void splice_device_list(struct list_head *seed_devices,
 }
 
 static void print_devices(struct btrfs_fs_devices *fs_devices,
-			  u64 *devs_found)
+			  u64 *devs_found, unsigned unit_mode)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_fs;
@@ -393,14 +393,16 @@ static void print_devices(struct btrfs_fs_devices *fs_devices,
 	list_for_each_entry(device, all_devices, dev_list) {
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
-		       pretty_size(device->total_bytes),
-		       pretty_size(device->bytes_used), device->name);
+		       pretty_size_mode(device->total_bytes, unit_mode),
+		       pretty_size_mode(device->bytes_used, unit_mode),
+		       device->name);
 
 		(*devs_found)++;
 	}
 }
 
-static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
+static void print_one_uuid(struct btrfs_fs_devices *fs_devices,
+			   unsigned unit_mode)
 {
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_device *device;
@@ -421,9 +423,9 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
 	       (unsigned long long)total,
-	       pretty_size(device->super_bytes_used));
+	       pretty_size_mode(device->super_bytes_used, unit_mode));
 
-	print_devices(fs_devices, &devs_found);
+	print_devices(fs_devices, &devs_found, unit_mode);
 
 	if (devs_found < total) {
 		printf("\t*** Some devices missing\n");
@@ -445,7 +447,7 @@ static u64 calc_used_bytes(struct btrfs_ioctl_space_args *si)
 static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 		struct btrfs_ioctl_dev_info_args *dev_info,
 		struct btrfs_ioctl_space_args *space_info,
-		char *label, char *path)
+		char *label, char *path, unsigned unit_mode)
 {
 	int i;
 	int fd;
@@ -468,7 +470,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
 			fs_info->num_devices,
-			pretty_size(calc_used_bytes(space_info)));
+			pretty_size_mode(calc_used_bytes(space_info),
+					 unit_mode));
 
 	for (i = 0; i < fs_info->num_devices; i++) {
 		char *canonical_path;
@@ -485,8 +488,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 		canonical_path = canonicalize_path((char *)tmp_dev_info->path);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 			tmp_dev_info->devid,
-			pretty_size(tmp_dev_info->total_bytes),
-			pretty_size(tmp_dev_info->bytes_used),
+			pretty_size_mode(tmp_dev_info->total_bytes, unit_mode),
+			pretty_size_mode(tmp_dev_info->bytes_used, unit_mode),
 			canonical_path);
 
 		free(canonical_path);
@@ -498,7 +501,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	return 0;
 }
 
-static int btrfs_scan_kernel(void *search)
+static int btrfs_scan_kernel(void *search, unsigned unit_mode)
 {
 	int ret = 0, fd;
 	int found = 0;
@@ -537,7 +540,8 @@ static int btrfs_scan_kernel(void *search)
 		fd = open(mnt->mnt_dir, O_RDONLY);
 		if ((fd != -1) && !get_df(fd, &space_info_arg)) {
 			print_one_fs(&fs_info_arg, dev_info_arg,
-					space_info_arg, label, mnt->mnt_dir);
+				     space_info_arg, label, mnt->mnt_dir,
+				     unit_mode);
 			kfree(space_info_arg);
 			memset(label, 0, sizeof(label));
 			found = 1;
@@ -833,6 +837,7 @@ static int cmd_show(int argc, char **argv)
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
 	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
+	unsigned unit_mode = UNITS_DEFAULT;
 	int found = 0;
 
 	while (1) {
@@ -840,6 +845,15 @@ static int cmd_show(int argc, char **argv)
 		static const struct option long_options[] = {
 			{ "all-devices", no_argument, NULL, 'd'},
 			{ "mounted", no_argument, NULL, 'm'},
+			{ "raw", no_argument, NULL, GETOPT_VAL_RAW},
+			{ "kbytes", no_argument, NULL, GETOPT_VAL_KBYTES},
+			{ "mbytes", no_argument, NULL, GETOPT_VAL_MBYTES},
+			{ "gbytes", no_argument, NULL, GETOPT_VAL_GBYTES},
+			{ "tbytes", no_argument, NULL, GETOPT_VAL_TBYTES},
+			{ "si", no_argument, NULL, GETOPT_VAL_SI},
+			{ "iec", no_argument, NULL, GETOPT_VAL_IEC},
+			{ "human-readable", no_argument, NULL,
+				GETOPT_VAL_HUMAN_READABLE},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -853,6 +867,30 @@ static int cmd_show(int argc, char **argv)
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
 			break;
+		case GETOPT_VAL_RAW:
+			units_set_mode(&unit_mode, UNITS_RAW);
+			break;
+		case GETOPT_VAL_KBYTES:
+			units_set_base(&unit_mode, UNITS_KBYTES);
+			break;
+		case GETOPT_VAL_MBYTES:
+			units_set_base(&unit_mode, UNITS_MBYTES);
+			break;
+		case GETOPT_VAL_GBYTES:
+			units_set_base(&unit_mode, UNITS_GBYTES);
+			break;
+		case GETOPT_VAL_TBYTES:
+			units_set_base(&unit_mode, UNITS_TBYTES);
+			break;
+		case GETOPT_VAL_SI:
+			units_set_mode(&unit_mode, UNITS_DECIMAL);
+			break;
+		case GETOPT_VAL_IEC:
+			units_set_mode(&unit_mode, UNITS_BINARY);
+			break;
+		case GETOPT_VAL_HUMAN_READABLE:
+			units_set_mode(&unit_mode, UNITS_HUMAN_BINARY);
+			break;
 		default:
 			usage(cmd_show_usage);
 		}
@@ -908,7 +946,7 @@ static int cmd_show(int argc, char **argv)
 		goto devs_only;
 
 	/* show mounted btrfs */
-	ret = btrfs_scan_kernel(search);
+	ret = btrfs_scan_kernel(search, unit_mode);
 	if (search && !ret) {
 		/* since search is found we are done */
 		goto out;
@@ -945,7 +983,7 @@ devs_only:
 	}
 
 	list_for_each_entry(fs_devices, &all_uuids, list)
-		print_one_uuid(fs_devices);
+		print_one_uuid(fs_devices, unit_mode);
 
 	if (search && !found)
 		ret = 1;
-- 
2.4.3

