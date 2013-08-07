Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45724 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3HGMFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 08:05:41 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r77C5dKe010740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:40 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5dr2014778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:39 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5dtm014775
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: cmd_start_replace() to use test_dev_for_mkfs()
Date: Wed,  7 Aug 2013 20:11:24 +0800
Message-Id: <1375877485-12105-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>

test_dev_for_mkfs() is a common place where
we check if a device is fit for the btrfs use.
cmd_start_replace() should make use of test_dev_for_mkfs(),
and here the test_dev_for_mkfs() is further enhanced
to fit the cmd_start_replace() needs.

Thanks

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c |   32 ++++----------------------------
 utils.c        |   12 +++++++++++-
 utils.h        |    2 ++
 3 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 25e8c7f..eecea4b 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -137,13 +137,12 @@ static int cmd_start_replace(int argc, char **argv)
 	char *dstdev;
 	int avoid_reading_from_srcdev = 0;
 	int force_using_targetdev = 0;
-	u64 total_devs = 1;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct stat st;
 	u64 dstdev_block_count;
 	int do_not_background = 0;
 	int mixed = 0;
 	DIR *dirstream = NULL;
+	char estr[BTRFS_ERR_STR_LEN];
 
 	while ((c = getopt(argc, argv, "Brf")) != -1) {
 		switch (c) {
@@ -265,15 +264,9 @@ static int cmd_start_replace(int argc, char **argv)
 		start_args.start.srcdevid = 0;
 	}
 
-	ret = check_mounted(dstdev);
-	if (ret < 0) {
-		fprintf(stderr, "Error checking %s mount status\n", dstdev);
-		goto leave_with_error;
-	}
-	if (ret == 1) {
-		fprintf(stderr,
-			"Error, target device %s is in use and currently mounted!\n",
-			dstdev);
+	ret = test_dev_for_mkfs(dstdev, force_using_targetdev, estr);
+	if (ret) {
+		fprintf(stderr, "%s", estr);
 		goto leave_with_error;
 	}
 	fddstdev = open(dstdev, O_RDWR);
@@ -281,23 +274,6 @@ static int cmd_start_replace(int argc, char **argv)
 		fprintf(stderr, "Unable to open %s\n", dstdev);
 		goto leave_with_error;
 	}
-	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
-	if (ret >= 0 && !force_using_targetdev) {
-		fprintf(stderr,
-			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
-			dstdev);
-		goto leave_with_error;
-	}
-	ret = fstat(fddstdev, &st);
-	if (ret) {
-		fprintf(stderr, "Error: Unable to stat '%s'\n", dstdev);
-		goto leave_with_error;
-	}
-	if (!S_ISBLK(st.st_mode)) {
-		fprintf(stderr, "Error: '%s' is not a block device\n", dstdev);
-		goto leave_with_error;
-	}
 	strncpy((char *)start_args.start.tgtdev_name, dstdev,
 		BTRFS_DEVICE_PATH_NAME_MAX);
 	if (btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
diff --git a/utils.c b/utils.c
index 15b991f..e35529e 100644
--- a/utils.c
+++ b/utils.c
@@ -1806,7 +1806,8 @@ out:
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 {
 	int ret, fd;
-	size_t sz = 100;
+	size_t sz = BTRFS_ERR_STR_LEN;
+	struct stat st;
 
 	ret = is_swap_device(file);
 	if (ret < 0) {
@@ -1841,6 +1842,15 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 			strerror(errno));
 		return 1;
 	}
+	if (fstat(fd, &st)) {
+		snprintf(estr, sz, "unable to stat %s: %s\n", file,
+			strerror(errno));
+		return 1;
+	}
+	if (!S_ISBLK(st.st_mode)) {
+		fprintf(stderr, "'%s' is not a block device\n", file);
+		return 1;
+	}
 	close(fd);
 	return 0;
 }
diff --git a/utils.h b/utils.h
index 5b95f3b..1e5353b 100644
--- a/utils.h
+++ b/utils.h
@@ -28,6 +28,8 @@
 #define BTRFS_SCAN_PROC	1
 #define BTRFS_SCAN_DEV		2
 
+#define BTRFS_ERR_STR_LEN	100
+
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
-- 
1.7.1

