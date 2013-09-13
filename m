Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22124 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3IMLZZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 07:25:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: use kernel for mounted and lblkid to scan disks
Date: Fri, 13 Sep 2013 19:32:23 +0800
Message-Id: <1379071943-27543-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>

As of now btrfs filesystem show reads directly from
disks. So sometimes output can be stale, mainly when
user wants to cross verify their operation like,
label or device delete or add... etc. so this
patch will read from the kernel ioctl if it finds
that disk is mounted.

Further, to scan for the disks this patch will use
lblkid which would replace the our own scan of
/proc/partitions

Further, this patch adds new parameters mounted and
group profile info in the filesystem show output
---------------
btrfs fi show
Label: none  uuid: a2446ecf-68c5-4815-8b63-099d10fc373c mounted: /btrfs
	Group profile: metadata: single  metadata: DUP  data: single
	Total devices 1 FS bytes used 32.00KiB
	devid    1 size 1.98GiB used 238.25MiB path /dev/mapper/mpatha

Label: none  uuid: aea4f4a7-39f2-43dc-bee1-03533551c1a0 (unmounted)
	Total devices 1 FS bytes used 28.00KiB
	devid    1 size 2.00GiB used 240.75MiB path /dev/mapper/mpathb
------------

v2:
  accepts David suggested

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |  19 ++++--
 cmds-filesystem.c | 171 +++++++++++++++++++++++++++++++++++++++++++++++-------
 man/btrfs.8.in    |  17 +++---
 utils.c           |  55 +++++++++++++++++-
 utils.h           |   5 ++
 5 files changed, 230 insertions(+), 37 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 800a050..94ba2f2 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -179,7 +179,7 @@ static const char * const cmd_scan_dev_usage[] = {
 static int cmd_scan_dev(int argc, char **argv)
 {
 	int	i, fd, e;
-	int	where = BTRFS_SCAN_PROC;
+	int	where = 0;
 	int	devstart = 1;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
@@ -193,14 +193,21 @@ static int cmd_scan_dev(int argc, char **argv)
 	if(argc<=devstart){
 		int ret;
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, 1);
-		if (ret){
-			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-			return 1;
-		}
+		if (where == BTRFS_SCAN_DEV) {
+			ret = scan_for_btrfs(BTRFS_SCAN_DEV,
+						BTRFS_UPDATE_KERNEL);
+			if (ret) {
+				fprintf(stderr,
+					"ERROR: %d while scanning\n", ret);
+				return 1;
+			}
+		} else
+			scan_for_btrfs_v2(BTRFS_UPDATE_KERNEL);
+
 		return 0;
 	}
 
+	/* if its here that means scan the specificed device/file */
 	fd = open("/dev/btrfs-control", O_RDWR);
 	if (fd < 0) {
 		perror("failed to open /dev/btrfs-control");
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index e1db9e7..80b6de1 100644
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
@@ -212,8 +215,9 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 
 
 	total = device->total_devs;
-	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
-	       (unsigned long long)total,
+
+	printf(" uuid: %s (unmounted)\n\tTotal devices %llu FS bytes used %s\n",
+		uuidbuf, (unsigned long long)total,
 	       pretty_size(device->super_bytes_used));
 
 	list_for_each(cur, &fs_devices->devices) {
@@ -232,10 +236,98 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
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
+			pretty_size(calc_used_bytes(si_n)));
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
+static int btrfs_scan_kernel()
+{
+	int ret = 0, fd;
+	FILE *f;
+	struct mntent *mnt;
+	struct btrfs_ioctl_fs_info_args fs_info_arg;
+	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
+	struct btrfs_ioctl_space_args *space_info_arg;
+	char label[BTRFS_LABEL_SIZE];
+
+	f = setmntent("/proc/self/mounts", "r");
+	if (f == NULL)
+		return 1;
+
+	while ((mnt = getmntent(f)) != NULL) {
+		if (strcmp(mnt->mnt_type, "btrfs"))
+			continue;
+		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
+				&dev_info_arg);
+		if (ret)
+			return ret;
+
+		fd = open(mnt->mnt_dir, O_RDONLY);
+		if (fd > 0 && !get_df(fd, &space_info_arg)) {
+			get_label_mounted(mnt->mnt_dir, label);
+			print_one_fs(&fs_info_arg, dev_info_arg,
+				space_info_arg, label, mnt->mnt_dir);
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
-	"Show the structure of a filesystem",
+	"btrfs filesystem show [--mounted|--all-devices [<uuid>]]",
+	"Show the structure of btrfs filesystem(s)",
 	"If no argument is given, structure of all present filesystems is shown.",
+	"--mounted  show only the mounted btrfs filesystem",
 	NULL
 };
 
@@ -246,34 +338,73 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
-	int where = BTRFS_SCAN_PROC;
+	int where = 0;
 	int searchstart = 1;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
 		where = BTRFS_SCAN_DEV;
 		searchstart += 1;
+	} else if (argc > 1 && !strcmp(argv[1], "--mounted")) {
+		where = BTRFS_SCAN_MOUNTED;
+		searchstart += 1;
 	}
 
-	if (check_argc_max(argc, searchstart + 1))
-		usage(cmd_show_usage);
-
-	ret = scan_for_btrfs(where, 0);
-
-	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
-		return 1;
+	if (where == BTRFS_SCAN_DEV) {
+		if (check_argc_max(argc, searchstart + 1))
+			usage(cmd_show_usage);
+	} else if (where == BTRFS_SCAN_MOUNTED) {
+		if (check_argc_max(argc, searchstart))
+			usage(cmd_show_usage);
+	} else {
+		if (check_argc_max(argc, searchstart))
+			usage(cmd_show_usage);
 	}
-	
+
 	if(searchstart < argc)
 		search = argv[searchstart];
 
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
+	switch (where) {
+	case 0:
+		/* no option : show both mounted and unmounted
+		 */
+		/* mounted */
+		ret = btrfs_scan_kernel();
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
+	case BTRFS_SCAN_DEV:
+		ret = scan_for_btrfs(BTRFS_SCAN_DEV, !BTRFS_UPDATE_KERNEL);
+		if (ret) {
+			fprintf(stderr, "ERROR: %d while scanning\n", ret);
+			return 1;
+		}
+		all_uuids = btrfs_scanned_uuids();
+		list_for_each(cur_uuid, all_uuids) {
+			fs_devices = list_entry(cur_uuid,
+					struct btrfs_fs_devices,
+					list);
+			if (search && uuid_search(fs_devices, search) == 0)
+				continue;
+			print_one_uuid(fs_devices);
+		}
+		break;
+	case BTRFS_SCAN_MOUNTED:
+		ret = btrfs_scan_kernel();
+		if (ret)
+			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
+				ret);
+		break;
 	}
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 61ffe8d..6a4f5bc 100644
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
@@ -259,11 +259,12 @@ Show information of a given subvolume in the \fI<path>\fR.
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
-otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
 \fBfilesystem sync\fR\fI <path> \fR
@@ -396,8 +397,8 @@ Remove device(s) from a filesystem identified by \fI<path>\fR.
 
 \fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
-If no devices are passed, \fBbtrfs\fR scans all the block devices listed
-in the /proc/partitions file.
+If no devices are passed, \fBbtrfs\fR uses block devices containing btrfs
+filesystem as listed by blkid.
 Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
 scanned.
 .TP
diff --git a/utils.c b/utils.c
index 134bf80..02a2658 100644
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
@@ -1144,6 +1143,56 @@ fail:
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
index 6c2553a..616bae1 100644
--- a/utils.h
+++ b/utils.h
@@ -27,6 +27,9 @@
 
 #define BTRFS_SCAN_PROC	1
 #define BTRFS_SCAN_DEV		2
+#define BTRFS_SCAN_MOUNTED	3
+
+#define BTRFS_UPDATE_KERNEL	1
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -74,10 +77,12 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+void scan_for_btrfs_v2(int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
 int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 #endif
-- 
1.8.4.rc4.1.g0d8beaa

