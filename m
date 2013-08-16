Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46783 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3HPMmX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 08:42:23 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7GCgL0D000306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:22 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgJIu027641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:21 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgI4A003963
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: read from the kernel when disk is mounted
Date: Fri, 16 Aug 2013 20:48:22 +0800
Message-Id: <1376657303-14931-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their last operation like,
labeling or device delete or add... etc.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |  166 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 157 insertions(+), 9 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index be8afde..508ba90 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,9 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <mntent.h>
+#include <fcntl.h>
+#include <linux/limits.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -251,8 +254,124 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	printf("\n");
 }
 
+/* adds up all the used spaces as reported by the space info ioctl
+ */
+static u64 cal_used_bytes(struct btrfs_ioctl_space_args *si)
+{
+	u64 ret = 0;
+	int i;
+	for (i = 0; i < si->total_spaces; i++)
+		ret += si->spaces[i].used_bytes;
+	return ret;
+}
+
+static int print_one_fs(struct btrfs_ioctl_fs_info_args *fi,
+		struct btrfs_ioctl_dev_info_args *di_n,
+		struct btrfs_ioctl_space_args *si_n, char *label, char *path)
+{
+	int i;
+	char uuidbuf[37];
+	struct btrfs_ioctl_dev_info_args *di = di_n;
+	u64 flags;
+
+	uuid_unparse(fi->fsid, uuidbuf);
+	printf("Label: %s  uuid: %s mounted: %s\n",
+		strlen(label)?label:"none", uuidbuf, path);
+	printf("\tGroup profile:");
+	for (i = si_n->total_spaces - 1; i >= 0; i--) {
+		flags = si_n->spaces[i].flags;
+		if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			continue;
+		printf(" %s: %s", group_type_str(flags),
+					group_profile_str(flags));
+		printf(" ");
+	}
+	printf("\n");
+
+	printf("\tTotal devices %llu FS bytes used %s\n",
+				fi->num_devices,
+			pretty_size(cal_used_bytes(si_n)));
+
+	for (i = 0; i < fi->num_devices; i++) {
+		di = (struct btrfs_ioctl_dev_info_args *)&di_n[i];
+		printf("\tdevid    %llu size %s used %s path %s\n",
+			di->devid,
+			pretty_size(di->total_bytes),
+			pretty_size(di->bytes_used),
+			di->path);
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
+static int check_arg_type(char *input, u8 *processed)
+{
+	int ret = 0;
+	if (!uuid_parse(input, processed))
+		ret = 1;
+	else if (realpath(input, (char *)processed))
+		ret = 2;
+	return ret;
+}
+
+static int btrfs_scan_kernel(void *input, int type)
+{
+	int ret = 0, fd;
+	FILE *f;
+	struct mntent *mnt;
+	struct btrfs_ioctl_fs_info_args fi;
+	struct btrfs_ioctl_dev_info_args *di = NULL;
+	struct btrfs_ioctl_space_args *si;
+	char label[BTRFS_LABEL_SIZE];
+
+	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+		return -errno;
+
+	while ((mnt = getmntent (f)) != NULL) {
+		if (strcmp(mnt->mnt_type, "btrfs"))
+			continue;
+		ret = get_fs_info(mnt->mnt_dir, &fi, &di);
+		if (ret)
+			return ret;
+
+		switch (type) {
+		case 0:
+			break;
+		case 1:
+			if (uuid_compare(fi.fsid, (u8 *)input))
+				continue;
+			break;
+		case 2:
+			if (strcmp(input, mnt->mnt_dir))
+				continue;
+			break;
+		default:
+			break;
+		}
+
+		fd = open(mnt->mnt_dir, O_RDONLY);
+		if (fd > 0 && !get_df(fd, &si)) {
+			get_label_mounted(mnt->mnt_dir, label);
+			print_one_fs(&fi, di, si, label, mnt->mnt_dir);
+			free(si);
+		}
+		if (fd > 0)
+			close(fd);
+		free(di);
+	}
+	return ret;
+}
+
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -264,23 +383,52 @@ static int cmd_show(int argc, char **argv)
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
 	char *search = 0;
-	int ret;
+	int ret = 0;
 	int where = BTRFS_SCAN_PROC;
 	int searchstart = 1;
+	u8 processed[PATH_MAX];
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
+	if( argc > 1 && !strcmp(argv[1], "--all-devices")){
 		where = BTRFS_SCAN_DEV;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1], "--kernel")) {
+		where = 0;
+		searchstart += 1;
 	}
 
-	if (check_argc_max(argc, searchstart + 1))
-		usage(cmd_show_usage);
+	if (!where) {
+		/* option --kernel*/
+		if (! (searchstart < argc))
+			ret = btrfs_scan_kernel(NULL, 0);
+
+		while (searchstart < argc) {
+			ret = check_arg_type(argv[searchstart], processed);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR at input %s\n",
+							argv[searchstart]);
+				return 1;
+			}
+			if (!ret) {
+				fprintf(stderr, "ERROR unknown %s\n",
+					argv[searchstart]);
+				return 1;
+			}
 
-	ret = scan_for_btrfs(where, 0);
+			ret = btrfs_scan_kernel(processed, ret);
+			if (ret)
+				break;
+			searchstart++;
+		}
+		if (ret)
+			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
+				ret);
+		return ret;
+	}
 
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-		return 18;
+	ret = scan_for_btrfs(where, 0);
+	if (ret) {
+		fprintf(stderr, "ERROR: %d while scanning\n", ret);
+		return 1;
 	}
 	
 	if(searchstart < argc)
-- 
1.7.1

