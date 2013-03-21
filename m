Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51187 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3CULz4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 07:55:56 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2LBttOL028214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 11:55:56 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2LBttZJ011081
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 11:55:55 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2LBttq8032753
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 06:55:55 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: make btrfs dev scan multi path aware
Date: Thu, 21 Mar 2013 19:56:44 +0800
Message-Id: <1363867004-22912-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 We should avoid using non multi-path (mp) path for mp disks
 As of now there is no good way (like api) to check that.
 A workaround way is to check if the O_EXCL open is unsuccessful.
 This is safe since otherwise the BTRFS_IOC_SCAN_DEV ioctl would
 fail if the disk-path can not be opened with the flag O_EXCL set.

 This patch also includes some (error) print format changes related
 to the btrfs dev scan..

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c | 53 +++++++++++++++++++++++++++++++++++++++--------------
 utils.c       | 31 ++++++++++++++++++++++++-------
 2 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 41e79d3..b8d05fd 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -185,7 +185,7 @@ static const char * const cmd_scan_dev_usage[] = {
 
 static int cmd_scan_dev(int argc, char **argv)
 {
-	int	i, fd, e;
+	int	i, fd, e, ret = 0;
 	int	checklist = 1;
 	int	devstart = 1;
 
@@ -197,6 +197,21 @@ static int cmd_scan_dev(int argc, char **argv)
 		devstart += 1;
 	}
 
+	fd = open("/dev/btrfs-control", O_RDWR);
+	e = errno;
+	if (fd < 0) {
+		FILE *mfd = popen("lsmod | grep btrfs", "r");
+		char buf[16];
+
+		if (fread (buf, 1, sizeof (buf), mfd) > 0)
+			fprintf(stderr, "ERROR: failed to open "\
+				"/dev/btrfs-control - %s\n", strerror(e));
+		else
+			fprintf(stderr, "ERROR: btrfs kernel module "\
+				"is not loaded\n");
+		return 10;
+	}
+
 	if(argc<=devstart){
 
 		int ret;
@@ -210,20 +225,30 @@ static int cmd_scan_dev(int argc, char **argv)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 			return 18;
 		}
+		printf("done\n");
 		return 0;
 	}
 
-	fd = open("/dev/btrfs-control", O_RDWR);
-	if (fd < 0) {
-		perror("failed to open /dev/btrfs-control");
-		return 10;
-	}
-
+	printf("Scanning for Btrfs in\n");
 	for( i = devstart ; i < argc ; i++ ){
+		int fdt;
 		struct btrfs_ioctl_vol_args args;
-		int ret;
+		printf("  %s ", argv[i]);
+		fflush(stdout);
 
-		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
+		/*
+		 * If for a multipath (mp) disk user provides the
+		 * non-mp path then open with flag O_EXCL will fail,
+		 * (also ioctl opens with O_EXCL), So test it before
+		 * calling ioctl.
+		 */
+		fdt = open(argv[i], O_RDONLY|O_EXCL);
+		if (fdt < 0) {
+			perror("ERROR");
+			ret = -1;
+			continue;
+		}
+		close(fdt);
 
 		strncpy_null(args.name, argv[i]);
 		/*
@@ -235,15 +260,15 @@ static int cmd_scan_dev(int argc, char **argv)
 		e = errno;
 
 		if( ret < 0 ){
-			close(fd);
-			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
-				argv[i], strerror(e));
-			return 11;
+			fprintf(stderr, "ERROR: unable to scan - %s\n",
+				strerror(e));
+			ret = -1;
 		}
+		printf("found\n");
 	}
 
 	close(fd);
-	return 0;
+	return ret;
 }
 
 static const char * const cmd_ready_dev_usage[] = {
diff --git a/utils.c b/utils.c
index 7b028a7..2fc6c32 100644
--- a/utils.c
+++ b/utils.c
@@ -1105,25 +1105,32 @@ again:
 		if (!S_ISBLK(st.st_mode)) {
 			continue;
 		}
-		fd = open(fullpath, O_RDONLY);
+		fd = open(fullpath, O_RDONLY|O_EXCL);
 		if (fd < 0) {
 			/* ignore the following errors:
 				ENXIO (device don't exists) 
 				ENOMEDIUM (No medium found -> 
 					like a cd tray empty)
+				EBUSY (when mp disk is opened
+					using non-mp path).
 			*/
-			if(errno != ENXIO && errno != ENOMEDIUM) 
+			if(errno != ENXIO && errno != ENOMEDIUM &&
+				errno != EBUSY) 
 				fprintf(stderr, "failed to read %s: %s\n", 
 					fullpath, strerror(errno));
 			continue;
 		}
+		close(fd);
+
+		fd = open(fullpath, O_RDONLY);
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
+		close(fd);
+
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
 	}
 	if (!list_empty(&pending_list)) {
 		free(pending);
@@ -1442,19 +1449,29 @@ scan_again:
 			continue;
 		}
 
-		fd = open(fullpath, O_RDONLY);
+		/* This will fail for the multi path devices
+		* when non multipath path is used. So we avoid
+		* sending it to the kernel which eventually will
+		* fail.
+		*/
+		fd = open(fullpath, O_RDONLY|O_EXCL);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s: %s\n",
-				fullpath, strerror(errno));
+			if (errno != EBUSY) {
+				fprintf(stderr, "failed to open %s: %s\n",
+					fullpath, strerror(errno));
+			}
 			continue;
 		}
+		close(fd);
+
+		fd = open(fullpath, O_RDONLY);
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
+		close(fd);
 		if (ret == 0 && run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
 	}
 
 	fclose(proc_partitions);
-- 
1.8.1.227.g44fe835

