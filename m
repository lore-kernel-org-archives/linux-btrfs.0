Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27277 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JXOex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:34:53 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9OEYqVs021290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 14:34:53 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9OEYqcv026751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 14:34:52 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9OEYqYb026745
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 14:34:52 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: make filesystem show by label work
Date: Thu, 24 Oct 2013 22:42:56 +0800
Message-Id: <1382625776-17974-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

with design revamp around filesystem show the fsid filter
by label wasn't planned. but apparently that seemed to be
necessary. this patch will fix it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |  120 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 73 insertions(+), 47 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index d08007e..d2cad81 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -179,6 +179,26 @@ static int cmd_df(int argc, char **argv)
 	return !!ret;
 }
 
+static int match_search_item_kernel(__u8 *fsid, char *mnt, char *label,
+					char *search)
+{
+	char uuidbuf[37];
+	int search_len = strlen(search);
+
+	search_len = min(search_len, 37);
+	uuid_unparse(fsid, uuidbuf);
+	if (!strncmp(uuidbuf, search, search_len))
+		return 1;
+
+	if (strlen(label) && strcmp(label, search) == 0)
+		return 1;
+
+	if (strcmp(mnt, search) == 0)
+		return 1;
+
+	return 0;
+}
+
 static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
 {
 	char uuidbuf[37];
@@ -275,16 +295,18 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 
 	uuid_unparse(fs_info->fsid, uuidbuf);
-	printf("Label: %s  uuid: %s\n",
-		strlen(label) ? label : "none", uuidbuf);
+	if (label && strlen(label))
+		printf("Label: '%s' ", label);
+	else
+		printf("Label: none ");
 
-	printf("\tTotal devices %llu FS bytes used %s\n",
-				fs_info->num_devices,
+	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
+			fs_info->num_devices,
 			pretty_size(calc_used_bytes(space_info)));
 
 	for (i = 0; i < fs_info->num_devices; i++) {
 		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
-		printf("\tdevid    %llu size %s used %s path %s\n",
+		printf("\tdevid %4llu size %s used %s path %s\n",
 			tmp_dev_info->devid,
 			pretty_size(tmp_dev_info->total_bytes),
 			pretty_size(tmp_dev_info->bytes_used),
@@ -308,7 +330,7 @@ static int check_arg_type(char *input)
 	char path[PATH_MAX];
 
 	if (!input)
-		return BTRFS_ARG_UNKNOWN;
+		return -EINVAL;
 
 	if (realpath(input, path)) {
 		if (is_block_device(input) == 1)
@@ -320,7 +342,7 @@ static int check_arg_type(char *input)
 		return BTRFS_ARG_UNKNOWN;
 	}
 
-	if (!uuid_parse(input, out))
+	if (strlen(input) == 36 && !uuid_parse(input, out))
 		return BTRFS_ARG_UUID;
 
 	return BTRFS_ARG_UNKNOWN;
@@ -328,23 +350,19 @@ static int check_arg_type(char *input)
 
 static int btrfs_scan_kernel(void *search)
 {
-	int ret = 0, fd, type;
+	int ret = 0, fd;
 	FILE *f;
 	struct mntent *mnt;
 	struct btrfs_ioctl_fs_info_args fs_info_arg;
 	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
 	struct btrfs_ioctl_space_args *space_info_arg;
 	char label[BTRFS_LABEL_SIZE];
-	uuid_t uuid;
 
 	f = setmntent("/proc/self/mounts", "r");
 	if (f == NULL)
 		return 1;
 
-	type = check_arg_type(search);
-	if (type == BTRFS_ARG_BLKDEV)
-		return 1;
-
+	memset(label, 0, sizeof(label));
 	while ((mnt = getmntent(f)) != NULL) {
 		if (strcmp(mnt->mnt_type, "btrfs"))
 			continue;
@@ -353,38 +371,36 @@ static int btrfs_scan_kernel(void *search)
 		if (ret)
 			return ret;
 
-		switch (type) {
-		case BTRFS_ARG_UUID:
-			ret = uuid_parse(search, uuid);
-			if (ret)
-				return 1;
-			if (uuid_compare(fs_info_arg.fsid, uuid))
-				continue;
-			break;
-		case BTRFS_ARG_MNTPOINT:
-			if (strcmp(search, mnt->mnt_dir))
-				continue;
-			break;
-		case BTRFS_ARG_UNKNOWN:
-			break;
+		if (get_label_mounted(mnt->mnt_dir, label)) {
+			kfree(dev_info_arg);
+			return 1;
+		}
+		if (search && !match_search_item_kernel(fs_info_arg.fsid,
+					mnt->mnt_dir, label, search)) {
+			kfree(dev_info_arg);
+			continue;
 		}
 
 		fd = open(mnt->mnt_dir, O_RDONLY);
 		if (fd > 0 && !get_df(fd, &space_info_arg)) {
-			get_label_mounted(mnt->mnt_dir, label);
 			print_one_fs(&fs_info_arg, dev_info_arg,
 					space_info_arg, label, mnt->mnt_dir);
-			free(space_info_arg);
+			kfree(space_info_arg);
+			memset(label, 0, sizeof(label));
 		}
 		if (fd > 0)
 			close(fd);
-		free(dev_info_arg);
+		kfree(dev_info_arg);
+		if (search)
+			return 0;
 	}
-	return ret;
+	if (search)
+		return 1;
+	return 0;
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [options] [<path>|<uuid>|<device>]",
+	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
 	"Show the structure of a filesystem",
 	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
 	"-m|--mounted       show only mounted btrfs",
@@ -402,6 +418,7 @@ static int cmd_show(int argc, char **argv)
 	int where = BTRFS_SCAN_LBLKID;
 	int type = 0;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
+	char path[PATH_MAX];
 
 	while (1) {
 		int long_index;
@@ -426,24 +443,31 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (where == BTRFS_SCAN_LBLKID) {
-		if (check_argc_max(argc, optind + 1))
-			usage(cmd_show_usage);
-	} else {
-		if (check_argc_max(argc, optind))
-			usage(cmd_show_usage);
-	}
+	if (check_argc_max(argc, optind + 1))
+		usage(cmd_show_usage);
+
 	if (argc > optind) {
 		search = argv[optind];
-		type = check_arg_type(search);
-		if (type == BTRFS_ARG_UNKNOWN) {
-			fprintf(stderr, "ERROR: arg type unknown\n");
+		if (strlen(search) == 0)
 			usage(cmd_show_usage);
-		}
+		type = check_arg_type(search);
 		if (type == BTRFS_ARG_BLKDEV) {
-			ret = get_btrfs_mount(search, mp, sizeof(mp));
-			if (ret == 0)
-				search = mp;
+			if (where == BTRFS_SCAN_DEV) {
+				/* we need to do this because
+				 * legacy BTRFS_SCAN_DEV
+				 * provides /dev/dm-x paths
+				 */
+				if (realpath(search, path))
+					search = path;
+			} else {
+				ret = get_btrfs_mount(search,
+						mp, sizeof(mp));
+				if (!ret)
+					/* given block dev is mounted*/
+					search = mp;
+				else
+					goto devs_only;
+			}
 		}
 	}
 
@@ -451,7 +475,9 @@ static int cmd_show(int argc, char **argv)
 		goto devs_only;
 
 	/* show mounted btrfs */
-	btrfs_scan_kernel(search);
+	ret = btrfs_scan_kernel(search);
+	if (search && !ret)
+		return 0;
 
 	/* shows mounted only */
 	if (where == BTRFS_SCAN_MOUNTED)
-- 
1.7.1

