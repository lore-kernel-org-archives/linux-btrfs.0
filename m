Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29487 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3I0MY7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 08:24:59 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3 v3] btrfs-progs: use kernel for mounted disk for show
Date: Fri, 27 Sep 2013 20:24:42 +0800
Message-Id: <1380284683-3751-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1380284683-3751-1-git-send-email-anand.jain@oracle.com>
References: <1380284683-3751-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user wants to cross verify their operation like,
label or device delete or add... etc. so this
patch will read from the kernel ioctl if it finds
that disk is mounted.


v3:
  rebase on 20130920 and splits new parameter to new patch
v2:
  accepts David suggested

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 201 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 man/btrfs.8.in    |  16 +++--
 utils.h           |  11 ++-
 3 files changed, 206 insertions(+), 22 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 23dcd94..5300060 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,10 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <mntent.h>
+#include <fcntl.h>
+#include <linux/limits.h>
+#include <getopt.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -247,9 +251,131 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	printf("\n");
 }
 
+/* adds up all the used spaces as reported by the space info ioctl
+ */
+static u64 calc_used_bytes(struct btrfs_ioctl_space_args *si)
+{
+	u64 ret = 0;
+	int i;
+	for (i = 0; i < si->total_spaces; i++)
+		ret += si->spaces[i].used_bytes;
+	return ret;
+}
+
+static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
+		struct btrfs_ioctl_dev_info_args *dev_info,
+		struct btrfs_ioctl_space_args *space_info,
+		char *label, char *path)
+{
+	int i;
+	char uuidbuf[37];
+	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
+
+	uuid_unparse(fs_info->fsid, uuidbuf);
+	printf("Label: %s  uuid: %s\n",
+		strlen(label) ? label : "none", uuidbuf);
+
+	printf("\tTotal devices %llu FS bytes used %s\n",
+				fs_info->num_devices,
+			pretty_size(calc_used_bytes(space_info)));
+
+	for (i = 0; i < fs_info->num_devices; i++) {
+		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
+		printf("\tdevid    %llu size %s used %s path %s\n",
+			tmp_dev_info->devid,
+			pretty_size(tmp_dev_info->total_bytes),
+			pretty_size(tmp_dev_info->bytes_used),
+			tmp_dev_info->path);
+	}
+
+	printf("\n");
+	return 0;
+}
+
+/* This function checks if the given input parameter is
+ * an uuid or a path
+ * return -1: some error in the given input
+ * return 0: unknow input
+ * return 1: given input is uuid
+ * return 2: given input is path
+ */
+static int check_arg_type(char *input)
+{
+	uuid_t	out;
+	char path[PATH_MAX];
+
+	if (!input)
+		return BTRFS_ARG_UNKNOWN;
+
+	if (realpath(input, path))
+		return BTRFS_ARG_PATH;
+
+	if (!uuid_parse(input, out))
+		return BTRFS_ARG_UUID;
+
+	return BTRFS_ARG_UNKNOWN;
+}
+
+static int btrfs_scan_kernel(void *search)
+{
+	int ret = 0, fd, type;
+	FILE *f;
+	struct mntent *mnt;
+	struct btrfs_ioctl_fs_info_args fs_info_arg;
+	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
+	struct btrfs_ioctl_space_args *space_info_arg;
+	char label[BTRFS_LABEL_SIZE];
+	uuid_t uuid;
+
+	f = setmntent("/proc/self/mounts", "r");
+	if (f == NULL)
+		return 1;
+
+	type = check_arg_type(search);
+
+	while ((mnt = getmntent(f)) != NULL) {
+		if (strcmp(mnt->mnt_type, "btrfs"))
+			continue;
+		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
+				&dev_info_arg);
+		if (ret)
+			return ret;
+
+		switch (type) {
+		case BTRFS_ARG_UUID:
+			ret = uuid_parse(search, uuid);
+			if (ret)
+				return 1;
+			if (uuid_compare(fs_info_arg.fsid, uuid))
+				continue;
+			break;
+		case BTRFS_ARG_PATH:
+			if (strcmp(search, mnt->mnt_dir))
+				continue;
+			break;
+		default:
+			break;
+		}
+
+		fd = open(mnt->mnt_dir, O_RDONLY);
+		if (fd > 0 && !get_df(fd, &space_info_arg)) {
+			get_label_mounted(mnt->mnt_dir, label);
+			print_one_fs(&fs_info_arg, dev_info_arg,
+					space_info_arg, label, mnt->mnt_dir);
+			free(space_info_arg);
+		}
+		if (fd > 0)
+			close(fd);
+		free(dev_info_arg);
+	}
+	return ret;
+}
+
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|<uuid>]",
+	"btrfs filesystem show [options] [<path>|<uuid>]",
 	"Show the structure of a filesystem",
+	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
+	"-m|--mounted       show only mounted btrfs",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
 };
@@ -258,38 +384,87 @@ static int cmd_show(int argc, char **argv)
 {
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
 	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
 	int where = BTRFS_SCAN_PROC;
-	int searchstart = 1;
-
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		where = BTRFS_SCAN_DEV;
-		searchstart += 1;
+	int type = 0;
+
+	while (1) {
+		int long_index;
+		static struct option long_options[] = {
+			{ "all-devices", no_argument, NULL, 'd'},
+			{ "mounted", no_argument, NULL, 'm'},
+			{ NULL, no_argument, NULL, 0 },
+		};
+		int c = getopt_long(argc, argv, "dm", long_options,
+					&long_index);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'd':
+			where = BTRFS_SCAN_DEV;
+			break;
+		case 'm':
+			where = BTRFS_SCAN_MOUNTED;
+			break;
+		default:
+			usage(cmd_show_usage);
+		}
 	}
 
-	if (check_argc_max(argc, searchstart + 1))
+	if (check_argc_max(argc, optind + 1))
 		usage(cmd_show_usage);
+	if (argc > optind) {
+		search = argv[optind];
+		type = check_arg_type(search);
+		if (type == BTRFS_ARG_UNKNOWN) {
+			fprintf(stderr, "ERROR: arg type unknown\n");
+			usage(cmd_show_usage);
+		}
+	}
+
+	if (where == BTRFS_SCAN_DEV)
+		goto devs_only;
 
-	ret = scan_for_btrfs(where, 0);
+	/* show mounted btrfs */
+	btrfs_scan_kernel(search);
 
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+	/* shows mounted only */
+	if (where == BTRFS_SCAN_MOUNTED)
+		goto out;
+
+devs_only:
+	ret = scan_for_btrfs(where, !BTRFS_UPDATE_KERNEL);
+
+	if (ret) {
+		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 1;
 	}
 	
-	if(searchstart < argc)
-		search = argv[searchstart];
-
 	all_uuids = btrfs_scanned_uuids();
 	list_for_each(cur_uuid, all_uuids) {
 		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
 					list);
 		if (search && uuid_search(fs_devices, search) == 0)
 			continue;
+
+		/* skip mounted as they are already printed by
+		 * btrfs_scan_kernel
+		*/
+		/* do it only when user provided no option */
+		if (where == BTRFS_SCAN_PROC) {
+			device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+			ret = check_mounted(device->name);
+			if (ret)
+				continue;
+		}
 		print_one_uuid(fs_devices);
 	}
+
+out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
 }
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be4a6b2..60e02bb 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,7 +25,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP [--all-devices|\fI<uuid>\fP|\fI<label>\fP]\fP
+\fBbtrfs\fP \fBfilesystem show\fP [\fI--mounted\fP|\fI--all-devices\fP|\fI<uuid>\fP]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
@@ -51,7 +51,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBdevice scan\fP [--all-devices|\fI<device> \fP[\fI<device>...\fP]
+\fBbtrfs\fP \fBdevice scan\fP [\fI--all-devices\fP|\fI<device> \P[\fI<device>...\fP]
 .PP
 \fBbtrfs\fP \fBdevice ready\fP\fI <device>\fP
 .PP
@@ -261,9 +261,11 @@ Show information of a given subvolume in the \fI<path>\fR.
 Show space usage information for a mount point.
 .TP
 
-\fBfilesystem show\fR [--all-devices|\fI<uuid>\fR|\fI<label>\fR]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [\fI--mounted\fP|\fI--all-devices\fP|\fI<uuid>\fR]\fR
+Show the btrfs filesystem with some additional info. If no option or \fIUUID\fP
+is passed, \fBbtrfs\fR shows information of all the btrfs filesystem both mounted
+and unmounted.
+If \fB--mounted\fP is passed, it would probe btrfs kernel to list mounted btrfs filesystem(s);
 If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
@@ -405,8 +407,8 @@ Remove device(s) from a filesystem identified by \fI<path>\fR.
 
 \fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
-If no devices are passed, \fBbtrfs\fR scans all the block devices listed
-in the /proc/partitions file.
+If no devices are passed, \fBbtrfs\fR uses block devices containing btrfs
+filesystem as listed by blkid.
 Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
 scanned.
 .TP
diff --git a/utils.h b/utils.h
index 19f028f..e944685 100644
--- a/utils.h
+++ b/utils.h
@@ -25,8 +25,15 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
-#define BTRFS_SCAN_PROC	1
-#define BTRFS_SCAN_DEV		2
+#define BTRFS_SCAN_PROC		(1ULL << 0)
+#define BTRFS_SCAN_DEV		(1ULL << 1)
+#define BTRFS_SCAN_MOUNTED	(1ULL << 2)
+
+#define BTRFS_UPDATE_KERNEL	1
+
+#define BTRFS_ARG_UNKNOWN	0
+#define BTRFS_ARG_PATH		1
+#define BTRFS_ARG_UUID		2
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-- 
1.8.4.rc4.1.g0d8beaa

