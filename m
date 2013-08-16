Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3HPMmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 08:42:22 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7GCgKTb019223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:21 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgKLK004029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:20 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgKgd004009
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: use lblkid to scan and filesystem show improvements
Date: Fri, 16 Aug 2013 20:48:23 +0800
Message-Id: <1376657303-14931-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>

create helper functions to use lblkid to scan for the
btrfs disks

When we are using the lblkid for scanning for btrfs disks,
we don't have to worry about the manually scanning the
/dev or /dev/mapper which means we don't need the
--all-devices (and proposed --mapper) options.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c     |   21 ++-------
 cmds-filesystem.c |  126 +++++++++++++---------------------------------------
 utils.c           |   54 +++++++++++++++++++++-
 utils.h           |    7 +++-
 4 files changed, 93 insertions(+), 115 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index be2aaff..833ad30 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -186,7 +186,7 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [<--all-devices>|<device> [<device>...]]",
+	"btrfs device scan [<device>...]",
 	"Scan devices for a btrfs filesystem",
 	NULL
 };
@@ -194,28 +194,15 @@ static const char * const cmd_scan_dev_usage[] = {
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
index 508ba90..9a325ba 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -195,27 +195,6 @@ static int cmd_df(int argc, char **argv)
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
@@ -232,10 +211,10 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
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
@@ -305,23 +284,6 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fi,
 	return 0;
 }
 
-/* This function checks if the given input parameter is
- * an uuid or a path
- * return -1: some error in the given input
- * return 0: unknow input
- * return 1: given input is uuid
- * return 2: given input is path
- */
-static int check_arg_type(char *input, u8 *processed)
-{
-	int ret = 0;
-	if (!uuid_parse(input, processed))
-		ret = 1;
-	else if (realpath(input, (char *)processed))
-		ret = 2;
-	return ret;
-}
-
 static int btrfs_scan_kernel(void *input, int type)
 {
 	int ret = 0, fd;
@@ -371,7 +333,7 @@ static int btrfs_scan_kernel(void *input, int type)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices|--mapper|--kernel|<uuid>]",
+	"btrfs filesystem show [--mounted]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -382,65 +344,41 @@ static int cmd_show(int argc, char **argv)
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
-	char *search = 0;
 	int ret = 0;
-	int where = BTRFS_SCAN_PROC;
-	int searchstart = 1;
-	u8 processed[PATH_MAX];
-
-	if( argc > 1 && !strcmp(argv[1], "--all-devices")){
-		where = BTRFS_SCAN_DEV;
-		searchstart += 1;
-	} else if (argc > 1 && !strcmp(argv[1], "--kernel")) {
-		where = 0;
-		searchstart += 1;
-	}
+	int where = 0;
 
-	if (!where) {
-		/* option --kernel*/
-		if (! (searchstart < argc))
-			ret = btrfs_scan_kernel(NULL, 0);
-
-		while (searchstart < argc) {
-			ret = check_arg_type(argv[searchstart], processed);
-			if (ret < 0) {
-				fprintf(stderr, "ERROR at input %s\n",
-							argv[searchstart]);
-				return 1;
-			}
-			if (!ret) {
-				fprintf(stderr, "ERROR unknown %s\n",
-					argv[searchstart]);
-				return 1;
-			}
+	if (check_argc_max(argc, 2))
+		usage(cmd_show_usage);
 
-			ret = btrfs_scan_kernel(processed, ret);
-			if (ret)
-				break;
-			searchstart++;
-		}
+	/* show only mounted btrfs disks */
+	if (argc > 1 && !strcmp(argv[1], "--mounted"))
+		where = BTRFS_SCAN_MOUNTED;
+
+	switch (where) {
+	case 0:
+		/* no option : show both mounted and unmounted
+		 */
+		/* mounted */
+		ret = btrfs_scan_kernel(NULL, 0);
 		if (ret)
 			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
 				ret);
-		return ret;
-	}
 
-	ret = scan_for_btrfs(where, 0);
-	if (ret) {
-		fprintf(stderr, "ERROR: %d while scanning\n", ret);
-		return 1;
-	}
-	
-	if(searchstart < argc)
-		search = argv[searchstart];
-
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
+		/* unmounted */
+		scan_for_btrfs_v2(!BTRFS_UPDATE_KERNEL);
+		all_uuids = btrfs_scanned_uuids();
+		list_for_each(cur_uuid, all_uuids) {
+			fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
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
index 86ee948..c26193e 100644
--- a/utils.c
+++ b/utils.c
@@ -680,9 +680,8 @@ int is_block_device(const char *path) {
  * Find the mount point for a mounted device.
  * On success, returns 0 with mountpoint in *mp.
  * On failure, returns -errno (not mounted yields -EINVAL)
- * Is noisy on failures, expects to be given a mounted device.
  */
-static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 	int ret;
 	int fd = -1;
 
@@ -707,7 +706,6 @@ static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 
 	ret = check_mounted_where(fd, dev, mp, mp_size, NULL);
 	if (!ret) {
-		fprintf(stderr, "%s is not a mounted btrfs device\n", dev);
 		ret = -EINVAL;
 	} else { /* mounted, all good */
 		ret = 0;
@@ -1133,6 +1131,56 @@ fail:
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
index ec06a82..4b449b8 100644
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
@@ -74,7 +77,9 @@ u64 btrfs_device_size(int fd, struct stat *st);
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int scan_for_btrfs(int where, int update_kernel);
+void scan_for_btrfs_v2(int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
+int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 #endif
-- 
1.7.1

