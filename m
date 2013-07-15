Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43443 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3GOF0V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 11/11] btrfs-progs: introduce btrfs filesystem show --kernel
Date: Mon, 15 Jul 2013 13:30:57 +0800
Message-Id: <1373866257-10519-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their last operation like,
labeling or device delete or add... etc.

This patch adds --kernel option to the 'filesystem show'
subcli, which will read from the kernel instead of
the disks directly.

also this path adds the group profile info to the
output

eg:
-----------------
btrfs fi show --kernel
Label: none  uuid: 39f55f14-e5ca-4a01-899d-915fd35bde05 mounted: /btrfs
	Group profile: metadata: RAID1  data: RAID1
	Total devices 2 FS bytes used 7.40GB
	devid    1 size 48.23GB used 11.04GB path /dev/dm-5
	devid    2 size 44.99GB used 11.03GB path /dev/mapper/mpathe

Label: none  uuid: a0beeb78-0019-4bdf-8002-0900a123ee07 mounted: /btrfs1
	Group profile: mixed: single
	Total devices 1 FS bytes used 7.40GB
	devid    1 size 15.00GB used 9.01GB path /dev/mapper/mpathbp1

btrfs fi show --kernel /btrfs2
Label: none  uuid: 9d6a347e-e8a0-44fe-9d2a-d28ee45ef33f mounted: /btrfs2
	Group profile: metadata: DUP  data: single
	Total devices 1 FS bytes used 2.22MB
	devid    1 size 15.00GB used 1.32GB path /dev/mapper/mpathcp1

btrfs fi show --kernel 9d6a347e-e8a0-44fe-9d2a-d28ee45ef33f
Label: none  uuid: 9d6a347e-e8a0-44fe-9d2a-d28ee45ef33f mounted: /btrfs2
	Group profile: metadata: DUP  data: single
	Total devices 1 FS bytes used 2.22MB
	devid    1 size 15.00GB used 1.32GB path /dev/mapper/mpathcp1
------------

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
---
 cmds-filesystem.c |  162 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 155 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5225db0..148192a 100644
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
@@ -251,8 +254,125 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
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
@@ -264,9 +384,10 @@ static int cmd_show(int argc, char **argv)
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
@@ -274,15 +395,42 @@ static int cmd_show(int argc, char **argv)
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
1.7.7.6

