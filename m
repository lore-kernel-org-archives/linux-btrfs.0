Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25870 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161470Ab3DEFx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:58 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rsbZ032460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:55 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rr8N005448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:53 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rrFL021550
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:53 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs-progs: cmd replace should check target-dev fully
Date: Fri,  5 Apr 2013 13:55:01 +0800
Message-Id: <1365141303-10571-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as of now in replace command target dev is being checked
for mounted and for existing fs, however there is newly
introduced __test_dev_for_mkfs in mkfs.c which is suitable
for this job, and further it also checks if dev can be
opened for with O_EXCL. Its better to use __test_dev_for_mkfs

So for this purpose __test_dev_for_mkfs is moved to
utils.c and renamed to test_dev_for_mkfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c |  24 ++----------
 mkfs.c         | 122 +--------------------------------------------------------
 utils.c        | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |   1 +
 4 files changed, 126 insertions(+), 142 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index ab34388..abf6307 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -137,8 +137,6 @@ static int cmd_start_replace(int argc, char **argv)
 	char *dstdev;
 	int avoid_reading_from_srcdev = 0;
 	int force_using_targetdev = 0;
-	u64 total_devs = 1;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct stat st;
 	u64 dstdev_block_count;
 	int do_not_background = 0;
@@ -263,30 +261,14 @@ static int cmd_start_replace(int argc, char **argv)
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
-		goto leave_with_error;
-	}
+	/* this below func will exit if there is any error */
+	test_dev_for_mkfs(dstdev, force_using_targetdev);
+
 	fddstdev = open(dstdev, O_RDWR);
 	if (fddstdev < 0) {
 		fprintf(stderr, "Unable to open %s\n", dstdev);
 		goto leave_with_error;
 	}
-	ret = btrfs_scan_one_device(fddstdev, dstdev, &fs_devices_mnt,
-				    &total_devs, BTRFS_SUPER_INFO_OFFSET, 0ull);
-	if (ret >= 0 && !force_using_targetdev) {
-		fprintf(stderr,
-			"Error, target device %s contains filesystem, use '-f' to force overwriting.\n",
-			dstdev);
-		goto leave_with_error;
-	}
 	ret = fstat(fddstdev, &st);
 	if (ret) {
 		fprintf(stderr, "Error: Unable to stat '%s'\n", dstdev);
diff --git a/mkfs.c b/mkfs.c
index de83cc8..315b6e3 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1261,126 +1261,6 @@ static int is_ssd(const char *file)
 	return !atoi((const char *)&rotational);
 }
 
-/*
- * Check for existing filesystem or partition table on device.
- * Returns:
- *	 1 for existing fs or partition
- *	 0 for nothing found
- *	-1 for internal error
- */
-static int
-check_overwrite(
-	char		*device)
-{
-	const char	*type;
-	blkid_probe	pr = NULL;
-	int		ret;
-	blkid_loff_t	size;
-
-	if (!device || !*device)
-		return 0;
-
-	ret = -1; /* will reset on success of all setup calls */
-
-	pr = blkid_new_probe_from_filename(device);
-	if (!pr)
-		goto out;
-
-	size = blkid_probe_get_size(pr);
-	if (size < 0)
-		goto out;
-
-	/* nothing to overwrite on a 0-length device */
-	if (size == 0) {
-		ret = 0;
-		goto out;
-	}
-
-	ret = blkid_probe_enable_partitions(pr, 1);
-	if (ret < 0)
-		goto out;
-
-	ret = blkid_do_fullprobe(pr);
-	if (ret < 0)
-		goto out;
-
-	/*
-	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
-	 * but we want the exact opposite, so reverse the return value here.
-	 *
-	 * In addition print some useful diagnostics about what actually is
-	 * on the device.
-	 */
-	if (ret) {
-		ret = 0;
-		goto out;
-	}
-
-	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
-		fprintf(stderr,
-			"%s appears to contain an existing "
-			"filesystem (%s).\n", device, type);
-	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
-		fprintf(stderr,
-			"%s appears to contain a partition "
-			"table (%s).\n", device, type);
-	} else {
-		fprintf(stderr,
-			"%s appears to contain something weird "
-			"according to blkid\n", device);
-	}
-	ret = 1;
-
-out:
-	if (pr)
-		blkid_free_probe(pr);
-	if (ret == -1)
-		fprintf(stderr,
-			"probe of %s failed, cannot detect "
-			  "existing filesystem.\n", device);
-	return ret;
-}
-
-void __test_dev_for_mkfs(char *file, int force_overwrite)
-{
-	int ret, fd;
-
-	ret = is_swap_device(file);
-	if (ret < 0) {
-		fprintf(stderr, "error checking %s status: %s\n", file,
-			strerror(-ret));
-		exit(1);
-	}
-	if (ret == 1) {
-		fprintf(stderr, "%s is a swap device\n", file);
-		exit(1);
-	}
-	if (!force_overwrite) {
-		if (check_overwrite(file)) {
-			fprintf(stderr, "Use the -f option to force overwrite.\n");
-			exit(1);
-		}
-	}
-	ret = check_mounted(file);
-	if (ret < 0) {
-		fprintf(stderr, "error checking %s mount status\n",
-			file);
-		exit(1);
-	}
-	if (ret == 1) {
-		fprintf(stderr, "%s is mounted\n", file);
-		exit(1);
-	}
-	/* check if the device is busy */
-	fd = open(file, O_RDWR|O_EXCL);
-	if (fd < 0) {
-		fprintf(stderr, "unable to open %s: %s\n", file,
-			strerror(errno));
-		exit(1);
-	}
-	close(fd);
-}
-
 int main(int ac, char **av)
 {
 	char *file;
@@ -1499,7 +1379,7 @@ int main(int ac, char **av)
 		file = av[optind++];
 		/* following func would exit on error */
 		if (is_block_device(file))
-			__test_dev_for_mkfs(file, force_overwrite);
+			test_dev_for_mkfs(file, force_overwrite);
 	}
 
 	/* if we are here that means all devs are good to btrfsify*/
diff --git a/utils.c b/utils.c
index 9c5dbf4..f4cac96 100644
--- a/utils.c
+++ b/utils.c
@@ -40,6 +40,7 @@
 #include <linux/major.h>
 #include <linux/kdev_t.h>
 #include <limits.h>
+#include <blkid/blkid.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -1706,3 +1707,123 @@ out:
 
 	return ret;
 }
+
+/*
+ * Check for existing filesystem or partition table on device.
+ * Returns:
+ *	 1 for existing fs or partition
+ *	 0 for nothing found
+ *	-1 for internal error
+ */
+static int
+check_overwrite(
+	char		*device)
+{
+	const char	*type;
+	blkid_probe	pr = NULL;
+	int		ret;
+	blkid_loff_t	size;
+
+	if (!device || !*device)
+		return 0;
+
+	ret = -1; /* will reset on success of all setup calls */
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		goto out;
+
+	size = blkid_probe_get_size(pr);
+	if (size < 0)
+		goto out;
+
+	/* nothing to overwrite on a 0-length device */
+	if (size == 0) {
+		ret = 0;
+		goto out;
+	}
+
+	ret = blkid_probe_enable_partitions(pr, 1);
+	if (ret < 0)
+		goto out;
+
+	ret = blkid_do_fullprobe(pr);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
+	 * but we want the exact opposite, so reverse the return value here.
+	 *
+	 * In addition print some useful diagnostics about what actually is
+	 * on the device.
+	 */
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
+		fprintf(stderr,
+			"%s appears to contain an existing "
+			"filesystem (%s).\n", device, type);
+	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
+		fprintf(stderr,
+			"%s appears to contain a partition "
+			"table (%s).\n", device, type);
+	} else {
+		fprintf(stderr,
+			"%s appears to contain something weird "
+			"according to blkid\n", device);
+	}
+	ret = 1;
+
+out:
+	if (pr)
+		blkid_free_probe(pr);
+	if (ret == -1)
+		fprintf(stderr,
+			"probe of %s failed, cannot detect "
+			  "existing filesystem.\n", device);
+	return ret;
+}
+
+void test_dev_for_mkfs(char *file, int force_overwrite)
+{
+	int ret, fd;
+
+	ret = is_swap_device(file);
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s status: %s\n", file,
+			strerror(-ret));
+		exit(1);
+	}
+	if (ret == 1) {
+		fprintf(stderr, "%s is a swap device\n", file);
+		exit(1);
+	}
+	if (!force_overwrite) {
+		if (check_overwrite(file)) {
+			fprintf(stderr, "Use the -f option to force overwrite.\n");
+			exit(1);
+		}
+	}
+	ret = check_mounted(file);
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s mount status\n",
+			file);
+		exit(1);
+	}
+	if (ret == 1) {
+		fprintf(stderr, "%s is mounted\n", file);
+		exit(1);
+	}
+	/* check if the device is busy */
+	fd = open(file, O_RDWR|O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "unable to open %s: %s\n", file,
+			strerror(errno));
+		exit(1);
+	}
+	close(fd);
+}
diff --git a/utils.h b/utils.h
index 50957b7..1e051b5 100644
--- a/utils.h
+++ b/utils.h
@@ -67,5 +67,6 @@ u64 btrfs_device_size(int fd, struct stat *st);
 int is_btrfs_kernel_loaded();
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
+void test_dev_for_mkfs(char *file, int force_overwrite);
 
 #endif
-- 
1.8.1.227.g44fe835

