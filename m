Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26066 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3C0KH1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 06:07:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com, dsterba@suse.cz
Subject: [PATCH 1/5 v5] btrfs-progs: make btrfs dev scan multi path aware
Date: Wed, 27 Mar 2013 18:07:32 +0800
Message-Id: <1364378856-21053-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
References: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
 <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
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
index a4f7b06..3a0d444 100644
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

