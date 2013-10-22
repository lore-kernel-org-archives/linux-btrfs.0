Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JVFpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 01:45:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris.mason@fusionio.com, jbacik@fusionio.com
Subject: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted disk should work
Date: Tue, 22 Oct 2013 13:53:22 +0800
Message-Id: <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, thinking was user will use mount point if the disk
is mounted. But thats not really true, actually user don't
(or shouldn't) care to check if disk mounted, so whether disk
is mounted/unmounted when disk path is specified it should work.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |   34 +++++++++++++++++++++++++++-------
 utils.c           |   27 ++++++++++++++++++++++++++-
 utils.h           |    4 +++-
 3 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b737ec9..e539b01 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -321,8 +321,15 @@ static int check_arg_type(char *input)
 	if (!input)
 		return BTRFS_ARG_UNKNOWN;
 
-	if (realpath(input, path))
-		return BTRFS_ARG_PATH;
+	if (realpath(input, path)) {
+		if (is_block_device(input) == 1)
+			return BTRFS_ARG_BLKDEV;
+
+		if (is_mount_point(input) == 1)
+			return BTRFS_ARG_MNTPOINT;
+
+		return BTRFS_ARG_UNKNOWN;
+	}
 
 	if (!uuid_parse(input, out))
 		return BTRFS_ARG_UUID;
@@ -346,6 +353,8 @@ static int btrfs_scan_kernel(void *search)
 		return 1;
 
 	type = check_arg_type(search);
+	if (type == BTRFS_ARG_BLKDEV)
+		return 1;
 
 	while ((mnt = getmntent(f)) != NULL) {
 		if (strcmp(mnt->mnt_type, "btrfs"))
@@ -363,11 +372,11 @@ static int btrfs_scan_kernel(void *search)
 			if (uuid_compare(fs_info_arg.fsid, uuid))
 				continue;
 			break;
-		case BTRFS_ARG_PATH:
+		case BTRFS_ARG_MNTPOINT:
 			if (strcmp(search, mnt->mnt_dir))
 				continue;
 			break;
-		default:
+		case BTRFS_ARG_UNKNOWN:
 			break;
 		}
 
@@ -386,7 +395,7 @@ static int btrfs_scan_kernel(void *search)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [options] [<path>|<uuid>]",
+	"btrfs filesystem show [options|<path>|<uuid>]",
 	"Show the structure of a filesystem",
 	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
 	"-m|--mounted       show only mounted btrfs",
@@ -403,6 +412,7 @@ static int cmd_show(int argc, char **argv)
 	int ret;
 	int where = BTRFS_SCAN_LBLKID;
 	int type = 0;
+	char mp[BTRFS_PATH_NAME_MAX + 1];
 
 	while (1) {
 		int long_index;
@@ -427,8 +437,13 @@ static int cmd_show(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_max(argc, optind + 1))
-		usage(cmd_show_usage);
+	if (where == BTRFS_SCAN_LBLKID) {
+		if (check_argc_max(argc, optind + 1))
+			usage(cmd_show_usage);
+	} else {
+		if (check_argc_max(argc, optind))
+			usage(cmd_show_usage);
+	}
 	if (argc > optind) {
 		search = argv[optind];
 		type = check_arg_type(search);
@@ -436,6 +451,11 @@ static int cmd_show(int argc, char **argv)
 			fprintf(stderr, "ERROR: arg type unknown\n");
 			usage(cmd_show_usage);
 		}
+		if (type == BTRFS_ARG_BLKDEV) {
+			ret = get_btrfs_mount(search, mp, sizeof(mp));
+			if (ret == 0)
+				search = mp;
+		}
 	}
 
 	if (where == BTRFS_SCAN_DEV)
diff --git a/utils.c b/utils.c
index cb69b2b..d241044 100644
--- a/utils.c
+++ b/utils.c
@@ -677,7 +677,8 @@ error:
  * Returns negative errno on failure, otherwise
  * returns 1 for blockdev, 0 for not-blockdev
  */
-int is_block_device(const char *path) {
+int is_block_device(const char *path)
+{
 	struct stat statbuf;
 
 	if (stat(path, &statbuf) < 0)
@@ -687,6 +688,30 @@ int is_block_device(const char *path) {
 }
 
 /*
+ * check if given path is a mount point
+ * return 1 if yes. 0 if no. -1 for error
+ */
+int is_mount_point(const char *path)
+{
+	FILE *f;
+	struct mntent *mnt;
+	int ret = 0;
+
+	f = setmntent("/proc/self/mounts", "r");
+	if (f == NULL)
+		return -1;
+
+	while ((mnt = getmntent(f)) != NULL) {
+		if (strcmp(mnt->mnt_dir, path))
+			continue;
+		ret = 1;
+		break;
+	}
+	endmntent(f);
+	return ret;
+}
+
+/*
  * Find the mount point for a mounted device.
  * On success, returns 0 with mountpoint in *mp.
  * On failure, returns -errno (not mounted yields -EINVAL)
diff --git a/utils.h b/utils.h
index 8370686..4d0db1d 100644
--- a/utils.h
+++ b/utils.h
@@ -33,8 +33,9 @@
 #define BTRFS_UPDATE_KERNEL	1
 
 #define BTRFS_ARG_UNKNOWN	0
-#define BTRFS_ARG_PATH		1
+#define BTRFS_ARG_MNTPOINT	1
 #define BTRFS_ARG_UUID		2
+#define BTRFS_ARG_BLKDEV	3
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
@@ -76,6 +77,7 @@ int set_label(const char *btrfs_dev, const char *label);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
+int is_mount_point(const char *file);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
-- 
1.7.1

