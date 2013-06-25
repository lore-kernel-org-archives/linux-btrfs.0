Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38936 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FYIkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Jun 2013 04:40:18 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5P8eHZe007790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:40:17 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5P8eGJY006607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:40:17 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5P8eG5L006602
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2013 08:40:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12 v4] btrfs-progs: introduce btrfs filesystem show --kernel
Date: Tue, 25 Jun 2013 16:44:32 +0800
Message-Id: <1372149872-5560-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-6-git-send-email-anand.jain@oracle.com>
References: <1371801485-14571-6-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their last operation like,
labeling or device delete or add... etc.

This patch adds --kernel option to the 'filesystem show'
subcli, which will read from the kernel instead of
the disks directly.

This btrfs-progs patch depends on the kernel patch
 btrfs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl

v3->v4:
	dropped the dependence of used_bytes from the ioctl
	kernel, Instead used the get_df to calculate the
	used space.
	dropped the function device_list_add_from_kernel
	to update the original device_list_add instead
	I have my own print and device filters, this way I
	can add the group profile information in the show
	output.
v2->v3:
	Do the stuffs without adding new ioctl
	new dependencies: this patch also depends on
	path 9/13 to 12/13 also sent here.
v1->v2:
	code optimized to remove redundancy

Signed-off-by: Anand Jain <anand.jain@oracle.com>

merg

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 159 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5f8c258..a028e1d 100644
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
@@ -256,8 +259,129 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
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
+	char *sz1;
+	char *sz2;
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
+	sz1 = pretty_sizes(cal_used_bytes(si_n));
+	printf("\tTotal devices %llu FS bytes used %s\n",
+				fi->num_devices, sz1);
+	free(sz1);
+
+	for (i = 0; i < fi->num_devices; i++) {
+		di = (struct btrfs_ioctl_dev_info_args *)&di_n[i];
+		sz1 = pretty_sizes(di->total_bytes);
+		sz2 = pretty_sizes(di->bytes_used);
+		printf("\tdevid    %llu size %s used %s path %s\n",
+			di->devid, sz1, sz2, di->path);
+		free(sz1);
+		free(sz2);
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
-	"btrfs filesystem show [--all-devices|--mapper|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -269,9 +393,10 @@ static int cmd_show(int argc, char **argv)
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
 	char *search = 0;
-	int ret;
+	int ret = 0;
 	int where = BTRFS_SCAN_PROC;
 	int searchstart = 1;
+	u8 processed[PATH_MAX];
 
 	if (argc > 1 && !strcmp(argv[1],"--all-devices")) {
 		where = BTRFS_SCAN_DEV;
@@ -279,15 +404,42 @@ static int cmd_show(int argc, char **argv)
 	} else if (argc > 1 && !strcmp(argv[1],"--mapper")) {
 		where = BTRFS_SCAN_MAPPER;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1],"--kernel")) {
+		where = 0;
+		searchstart += 1;
 	}
 
-	if (check_argc_max(argc, searchstart + 1))
-		usage(cmd_show_usage);
+	if (!where) {
+		if (! (searchstart < argc))
+			ret = btrfs_scan_kernel(NULL, 0);
 
-	ret = scan_for_btrfs(where, 0);
+		while (searchstart < argc) {
+			ret = check_arg_type(argv[searchstart], processed);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR at the input %s\n",
+							argv[searchstart]);
+				return 1;
+			}
+			if (!ret) {
+				fprintf(stderr, "ERROR unknown %s\n",
+					argv[searchstart]);
+				return 1;
+			}
 
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+			ret = btrfs_scan_kernel(processed, ret);
+			if (ret)
+				break;
+			searchstart++;
+		}
+		if (ret)
+			fprintf(stderr, "ERROR: failed to obtain one or more FS %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = scan_for_btrfs(where, 0);
+	if (ret) {
+		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 18;
 	}
 	
-- 
1.8.1.227.g44fe835

