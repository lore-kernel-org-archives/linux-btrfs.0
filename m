Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27135 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJOIoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:44:06 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/1] btrfs-progs: code optimize cmd_scan_dev() use btrfs_register_one_device()
Date: Wed, 15 Oct 2014 08:50:38 +0800
Message-Id: <1413334238-25729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cmd_scan_dev() has it own code to register device (calling ioctl BTRFS_IOC_SCAN_DEV),
apparently it could use btrfs_register_one_device().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 33 ++++++---------------------------
 utils.c       |  8 +++++---
 utils.h       |  2 +-
 3 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index a728f21..57ad0b2 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -206,7 +206,7 @@ static const char * const cmd_scan_dev_usage[] = {
 
 static int cmd_scan_dev(int argc, char **argv)
 {
-	int i, fd, e;
+	int i;
 	int devstart = 1;
 	int all = 0;
 	int ret = 0;
@@ -242,22 +242,14 @@ static int cmd_scan_dev(int argc, char **argv)
 		goto out;
 	}
 
-	fd = open("/dev/btrfs-control", O_RDWR);
-	if (fd < 0) {
-		perror("failed to open /dev/btrfs-control");
-		ret = 1;
-		goto out;
-	}
-
 	for( i = devstart ; i < argc ; i++ ){
-		struct btrfs_ioctl_vol_args args;
 		char *path;
 
 		if (!is_block_device(argv[i])) {
 			fprintf(stderr,
 				"ERROR: %s is not a block device\n", argv[i]);
 			ret = 1;
-			goto close_out;
+			goto out;
 		}
 		path = canonicalize_path(argv[i]);
 		if (!path) {
@@ -265,30 +257,17 @@ static int cmd_scan_dev(int argc, char **argv)
 				"ERROR: Could not canonicalize path '%s': %s\n",
 				argv[i], strerror(errno));
 			ret = 1;
-			goto close_out;
+			goto out;
 		}
 		printf("Scanning for Btrfs filesystems in '%s'\n", path);
-
-		strncpy_null(args.name, path);
-		/*
-		 * FIXME: which are the error code returned by this ioctl ?
-		 * it seems that is impossible to understand if there no is
-		 * a btrfs filesystem from an I/O error !!!
-		 */
-		ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
-		e = errno;
-
-		if( ret < 0 ){
-			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
-				path, strerror(e));
+		if (btrfs_register_one_device(path) != 0) {
+			ret = 1;
 			free(path);
-			goto close_out;
+			goto out;
 		}
 		free(path);
 	}
 
-close_out:
-	close(fd);
 out:
 	return !!ret;
 }
diff --git a/utils.c b/utils.c
index 78cb93f..017c513 100644
--- a/utils.c
+++ b/utils.c
@@ -1236,7 +1236,7 @@ struct pending_dir {
 	char name[PATH_MAX];
 };
 
-void btrfs_register_one_device(char *fname)
+int btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
 	int fd;
@@ -1248,17 +1248,19 @@ void btrfs_register_one_device(char *fname)
 		fprintf(stderr, "failed to open /dev/btrfs-control "
 			"skipping device registration: %s\n",
 			strerror(errno));
-		return;
+		return -errno;
 	}
 	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
 	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	e = errno;
-	if(ret<0){
+	if (ret < 0) {
 		fprintf(stderr, "ERROR: device scan failed '%s' - %s\n",
 			fname, strerror(e));
+		ret = -e;
 	}
 	close(fd);
+	return ret;
 }
 
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
diff --git a/utils.h b/utils.h
index 1e13b9d..3f7b388 100644
--- a/utils.h
+++ b/utils.h
@@ -81,7 +81,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
 int btrfs_scan_for_fsid(int run_ioctls);
-void btrfs_register_one_device(char *fname);
+int btrfs_register_one_device(char *fname);
 char *canonicalize_dm_name(const char *ptname);
 char *canonicalize_path(const char *path);
 int check_mounted(const char *devicename);
-- 
2.0.0.153.g79dcccc

