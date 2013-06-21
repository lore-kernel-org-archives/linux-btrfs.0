Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423180Ab3FUHyH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:07 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7lmwr023638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:47:49 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s524004348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:05 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s5bt020812
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:05 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/13 v3] btrfs-progs: introduce btrfs filesystem show --kernel
Date: Fri, 21 Jun 2013 15:58:05 +0800
Message-Id: <1371801485-14571-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their last operation like,
labeling or device delete or add... etc.

This patch adds --kernel option to the 'filesystem show'
subcli, which will read from the kernel instead of
the disks directly.

This btrfs-progs patch depends on the kernel patch
 btrfs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl

v2->v3:
	Do the stuffs without adding new ioctl
	new dependencies: this patch also depends on
	path 9/13 to 12/13 also sent here.
v1->v2:
	code optimized to remove redundancy

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 volumes.c         | 28 ++++++++++++++++++++++++++++
 volumes.h         |  2 ++
 3 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5f8c258..10fdf41 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -22,6 +22,8 @@
 #include <errno.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
+#include <mntent.h>
+#include <fcntl.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -256,8 +258,35 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	printf("\n");
 }
 
+int btrfs_scan_kernel()
+{
+	int ret = 0;
+	FILE *f;
+	struct mntent *mnt;
+
+	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+		return -errno;
+	while ((mnt = getmntent (f)) != NULL)  {
+		if (!strcmp(mnt->mnt_type, "btrfs")) {
+			struct btrfs_ioctl_fs_info_args fi;
+			struct btrfs_ioctl_dev_info_args *di = NULL;
+			char label[BTRFS_LABEL_SIZE];
+
+			get_label_mounted(mnt->mnt_dir, label);
+			ret = get_fs_info(mnt->mnt_dir, &fi, &di);
+			if (!ret) {
+				device_list_fini(fi.fsid);
+				device_list_add_from_kernel(&fi, di, label);
+				free(di);
+			}
+		}
+	}
+	return ret;
+}
+
+
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|--mapper|<uuid>]",
+	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -279,15 +308,22 @@ static int cmd_show(int argc, char **argv)
 	} else if (argc > 1 && !strcmp(argv[1],"--mapper")) {
 		where = BTRFS_SCAN_MAPPER;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1],"--kernel")) {
+		where = 0;
+		searchstart += 1;
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
 		usage(cmd_show_usage);
 
-	ret = scan_for_btrfs(where, 0);
+	if (where)
+		ret = scan_for_btrfs(where, 0);
+	else {
+		ret = btrfs_scan_kernel();
+	}
 
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+	if (ret) {
+		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 18;
 	}
 	
diff --git a/volumes.c b/volumes.c
index 81904c6..01247bf 100644
--- a/volumes.c
+++ b/volumes.c
@@ -172,6 +172,34 @@ void device_list_fini(u8 *fsid)
 	}
 }
 
+int device_list_add_from_kernel(struct btrfs_ioctl_fs_info_args *fi,
+			struct btrfs_ioctl_dev_info_args *di_n, char *label)
+{
+	int ret = 0, i;
+	struct btrfs_super_block ds;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_ioctl_dev_info_args *di;
+
+	memcpy(ds.fsid, fi->fsid, BTRFS_FSID_SIZE);
+	memcpy(ds.label, label, BTRFS_LABEL_SIZE);
+	ds.num_devices = fi->num_devices; /*Todo Fix this */
+	ds.generation = 0;
+	ds.bytes_used = fi->used_bytes;
+
+	di = di_n;
+	for (i = 0; i < fi->num_devices; i++) {
+		memcpy(ds.dev_item.uuid, di->uuid, BTRFS_UUID_SIZE);
+		ds.dev_item.total_bytes = di->total_bytes;
+		ds.dev_item.bytes_used = di->bytes_used;
+
+		ret = device_list_add((char *)di->path, &ds, di->devid, &fs_devices);
+		if (ret)
+			break;
+		di++;
+	}
+	return ret;
+}
+
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_fs_devices *seed_devices;
diff --git a/volumes.h b/volumes.h
index 6286d83..a64c8dd 100644
--- a/volumes.h
+++ b/volumes.h
@@ -193,4 +193,6 @@ struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
 int device_list_add(const char *path, struct btrfs_super_block *disk_super,
 			   u64 devid, struct btrfs_fs_devices **fs_devices_ret);
 void device_list_fini(u8 *fsid);
+int device_list_add_from_kernel(struct btrfs_ioctl_fs_info_args *fi,
+			struct btrfs_ioctl_dev_info_args *di, char *label);
 #endif
-- 
1.8.1.227.g44fe835

