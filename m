Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40192 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3IFJbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 05:31:08 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/2] btrfs-progs: use kernel for mounted and lblkid to scan disks
Date: Fri,  6 Sep 2013 17:37:53 +0800
Message-Id: <1378460273-20647-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-1-git-send-email-anand.jain@oracle.com>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user want to verify their last operation like,
labeling or device delete or add... etc. so this
patch will read from the kernel ioctl if it finds
that disk is mounted.

Further, to scan for the disks this patch will use
lblkid, so that we don't have to manually scan the
/dev or /dev/mapper which means we don't need the
all-devices options.

v2:
  rebase on the latest integration integration-20130903
  at present

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |   21 +-----
 cmds-filesystem.c |  188 +++++++++++++++++++++++++++++++++++++++--------------
 utils.c           |   55 +++++++++++++++-
 utils.h           |    7 ++-
 4 files changed, 200 insertions(+), 71 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 7524d08..f3d4b67 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -177,7 +177,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
+	"btrfs device scan [<device>...]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
@@ -185,28 +185,15 @@ static const char * const cmd_scan_dev_usage[] = {
 static int cmd_scan_dev(int argc, char **argv)
 {
 	int	i, fd, e;
-	int	where = BTRFS_SCAN_PROC;
 	int	devstart = 1;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		if (check_argc_max(argc, 2))
-			usage(cmd_scan_dev_usage);
-
-		where = BTRFS_SCAN_DEV;
-		devstart += 1;
-	}
-
-	if(argc<=devstart){
-		int ret;
+	if (argc <= devstart) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, 1);
-		if (ret){
-			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-			return 18;
-		}
+		scan_for_btrfs_v2(BTRFS_UPDATE_KERNEL);
 		return 0;
 	}
 
+	/* there are specific device/file to scan*/
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 61b30d3..21f2096 100644
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
@@ -173,27 +176,6 @@ static int cmd_df(int argc, char **argv)
 	return ret;
 }
 
-static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
-{
-	char uuidbuf[37];
-	struct list_head *cur;
-	struct btrfs_device *device;
-	int search_len = strlen(search);
-
-	search_len = min(search_len, 37);
-	uuid_unparse(fs_devices->fsid, uuidbuf);
-	if (!strncmp(uuidbuf, search, search_len))
-		return 1;
-
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
-		if ((device->label && strcmp(device->label, search) == 0) ||
-		    strcmp(device->name, search) == 0)
-			return 1;
-	}
-	return 0;
-}
-
 static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 {
 	char uuidbuf[37];
@@ -210,10 +192,10 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	else
 		printf("Label: none ");
 
-
 	total = device->total_devs;
-	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
-	       (unsigned long long)total,
+
+	printf(" uuid: %s (unmounted)\n\tTotal devices %llu FS bytes used %s\n",
+		uuidbuf, (unsigned long long)total,
 	       pretty_size(device->super_bytes_used));
 
 	list_for_each(cur, &fs_devices->devices) {
@@ -232,8 +214,108 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
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
+		strlen(label) ? label : "none", uuidbuf, path);
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
+	f = setmntent("/proc/mounts", "r");
+	if (f == NULL)
+		return -errno;
+
+	while ((mnt = getmntent(f)) != NULL) {
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
+	"btrfs filesystem show [--mounted]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -244,36 +326,42 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
-	char *search = NULL;
-	int ret;
-	int where = BTRFS_SCAN_PROC;
-	int searchstart = 1;
-
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		where = BTRFS_SCAN_DEV;
-		searchstart += 1;
-	}
+	int ret = 0;
+	int where = 0;
 
-	if (check_argc_max(argc, searchstart + 1))
+	if (check_argc_max(argc, 2))
 		usage(cmd_show_usage);
 
-	ret = scan_for_btrfs(where, 0);
-
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-		return 18;
-	}
-	
-	if(searchstart < argc)
-		search = argv[searchstart];
+	/* show only mounted btrfs disks */
+	if (argc > 1 && !strcmp(argv[1], "--mounted"))
+		where = BTRFS_SCAN_MOUNTED;
 
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
+	switch (where) {
+	case 0:
+		/* no option : show both mounted and unmounted
+		 */
+		/* mounted */
+		ret = btrfs_scan_kernel(NULL, 0);
+		if (ret)
+			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
+				ret);
+
+		/* unmounted */
+		scan_for_btrfs_v2(!BTRFS_UPDATE_KERNEL);
+		all_uuids = btrfs_scanned_uuids();
+		list_for_each(cur_uuid, all_uuids) {
+			fs_devices = list_entry(cur_uuid,
+					struct btrfs_fs_devices,
 					list);
-		if (search && uuid_search(fs_devices, search) == 0)
-			continue;
-		print_one_uuid(fs_devices);
+			print_one_uuid(fs_devices);
+		}
+		break;
+	case BTRFS_SCAN_MOUNTED:
+		ret = btrfs_scan_kernel(NULL, 0);
+		if (ret)
+			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
+				ret);
+		break;
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
diff --git a/utils.c b/utils.c
index d022d58..82672a7 100644
--- a/utils.c
+++ b/utils.c
@@ -685,9 +685,9 @@ int is_block_device(const char *path) {
  * Find the mount point for a mounted device.
  * On success, returns 0 with mountpoint in *mp.
  * On failure, returns -errno (not mounted yields -EINVAL)
- * Is noisy on failures, expects to be given a mounted device.
  */
-static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size)
+{
 	int ret;
 	int fd = -1;
 
@@ -712,7 +712,6 @@ static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 
 	ret = check_mounted_where(fd, dev, mp, mp_size, NULL);
 	if (!ret) {
-		fprintf(stderr, "%s is not a mounted btrfs device\n", dev);
 		ret = -EINVAL;
 	} else { /* mounted, all good */
 		ret = 0;
@@ -1138,6 +1137,56 @@ fail:
 	return ret;
 }
 
+int test_skip_this_disk(char *path)
+{
+	int fd;
+	/* this will eliminate disks which are mounted (btrfs)
+	 * and non-dm disk path when dm is enabled
+	 */
+	fd = open(path, O_RDWR|O_EXCL);
+	if (fd < 0)
+		return 1;
+	close(fd);
+	return 0;
+}
+
+void scan_for_btrfs_v2(int update_kernel)
+{
+	int fd = -1;
+	u64 num_devices;
+	struct btrfs_fs_devices *tmp_devices;
+	blkid_dev_iterate iter = NULL;
+	blkid_dev dev = NULL;
+	blkid_cache cache = NULL;
+	char path[PATH_MAX];
+
+	if (blkid_get_cache(&cache, 0) < 0) {
+		printf("ERROR: lblkid cache get failed\n");
+		return;
+	}
+	blkid_probe_all(cache);
+	iter = blkid_dev_iterate_begin(cache);
+	blkid_dev_set_search(iter, "TYPE", "btrfs");
+	while (blkid_dev_next(iter, &dev) == 0) {
+		dev = blkid_verify(cache, dev);
+		if (!dev)
+			continue;
+		/* if we are here its definitly a btrfs disk*/
+		strcpy(path, blkid_dev_devname(dev));
+		if (test_skip_this_disk(path))
+			continue;
+
+		fd = open(path, O_RDONLY);
+		btrfs_scan_one_device(fd, path, &tmp_devices,
+				&num_devices, BTRFS_SUPER_INFO_OFFSET);
+		close(fd);
+		fd = -1;
+		if (update_kernel)
+			btrfs_register_one_device(path);
+	}
+	blkid_dev_iterate_end(iter);
+}
+
 int btrfs_scan_for_fsid(int run_ioctls)
 {
 	int ret;
diff --git a/utils.h b/utils.h
index dc795f4..6446e0a 100644
--- a/utils.h
+++ b/utils.h
@@ -25,8 +25,11 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
-#define BTRFS_SCAN_PROC	1
+#define BTRFS_SCAN_PROC		1
 #define BTRFS_SCAN_DEV		2
+#define BTRFS_SCAN_MOUNTED	3
+
+#define BTRFS_UPDATE_KERNEL	1
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -74,8 +77,10 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+void scan_for_btrfs_v2(int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
 int is_vol_small(char *file);
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 #endif
-- 
1.7.1

