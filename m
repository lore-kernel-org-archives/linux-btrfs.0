Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44364 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3DOGhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 03/11 v2] btrfs-progs: mkfs should first check all disks before writing to a disk
Date: Mon, 15 Apr 2013 14:38:09 +0800
Message-Id: <1366007897-26567-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the cases where one of the disk is not suitable for
btrfs, then we would fail the mkfs, however we determine
that after we have written btrfs to the preceding disks.
At this time if user changes mind for not to use btrfs
will left with no choice.

So this patch will check if all the provided disks are
suitable for the btrfs at once before proceeding to
create btrfs on a disk.

Further this patch also removed duplicate code to check
device suitability for the btrfs.

Next, there is an existing bug about the -r mkfs option,
which this patch would carry forward most of it.
Ref:
[PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option

Signed-off-by: Anand Jain <anand.jain@oracle.com>

to merg prev

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c  | 192 +++++++++++-----------------------------------------------------
 utils.c | 128 +++++++++++++++++++++++++++++++++++++++++++
 utils.h |   1 +
 3 files changed, 161 insertions(+), 160 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c8cb395..a58b313 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1261,86 +1261,6 @@ static int is_ssd(const char *file)
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
 int main(int ac, char **av)
 {
 	char *file;
@@ -1378,6 +1298,9 @@ int main(int ac, char **av)
 	char *pretty_buf;
 	struct btrfs_super_block *super;
 	u64 flags;
+	int dev_cnt = 0;
+	int saved_optind;
+	char estr[100];
 
 	while(1) {
 		int c;
@@ -1442,51 +1365,38 @@ int main(int ac, char **av)
 		exit(1);
 	if (check_leaf_or_node_size(nodesize, sectorsize))
 		exit(1);
-	ac = ac - optind;
-	if (ac == 0)
+	saved_optind = optind;
+	dev_cnt = ac - optind;
+	if (dev_cnt == 0)
 		print_usage();
 
-	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
-	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
-
-	if (source_dir == 0) {
+	if (source_dir_set && dev_cnt > 1) {
+		fprintf(stderr,
+			"The -r option is limited to a single device\n");
+		exit(1);
+	}
+	while (dev_cnt-- > 0) {
 		file = av[optind++];
-		ret = is_swap_device(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s status: %s\n", file,
-				strerror(-ret));
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is a swap device\n", file);
-			exit(1);
-		}
-		if (!force_overwrite) {
-			if (check_overwrite(file)) {
-				fprintf(stderr, "Use the -f option to force overwrite.\n");
+		if (is_block_device(file))
+			if (test_dev_for_mkfs(file, force_overwrite, estr)) {
+				fprintf(stderr, "Error: %s", estr);
 				exit(1);
 			}
-		}
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n", file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
-		}
-		ac--;
-		/* check if the device is busy */
-		fd = open(file, O_RDWR|O_EXCL);
-		if (fd < 0) {
-			fprintf(stderr, "unable to open %s: %s\n", file,
-				strerror(errno));
-			exit(1);
-		}
-		close(fd);
+	}
+
+	/* if we are here that means all devs are good to btrfsify*/
+	optind = saved_optind;
+	dev_cnt = ac - optind;
+
+	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
+	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
+
+	file = av[optind++];
+	dev_cnt--;
+
+	if (!source_dir_set) {
 		/*
-		 * open again without O_EXCL so that the problem should not
+		 * open without O_EXCL so that the problem should not
 		 * occur by the following processing.
 		 * (btrfs_register_one_device() fails if O_EXCL is on)
 		 */
@@ -1504,8 +1414,6 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	} else {
-		ac = 0;
-		file = av[optind++];
 		fd = open_target(file);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open the %s\n", file);
@@ -1566,53 +1474,19 @@ int main(int ac, char **av)
 
 	trans = btrfs_start_transaction(root, 1);
 
-	if (ac == 0)
+	if (dev_cnt == 0)
 		goto raid_groups;
 
 	btrfs_register_one_device(file);
 
 	zero_end = 1;
-	while(ac-- > 0) {
+	while(dev_cnt-- > 0) {
 		int old_mixed = mixed;
 
 		file = av[optind++];
-		if (!force_overwrite) {
-			if (check_overwrite(file)) {
-				fprintf(stderr, "Use the -f option to force overwrite.\n");
-				exit(1);
-			}
-		}
 
-		ret = is_swap_device(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s status: %s\n", file,
-				strerror(-ret));
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is a swap device\n", file);
-			exit(1);
-		}
-		ret = check_mounted(file);
-		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
-				file);
-			exit(1);
-		}
-		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
-			exit(1);
-		}
-		/* check if the device is busy */
-		fd = open(file, O_RDWR|O_EXCL);
-		if (fd < 0) {
-			fprintf(stderr, "unable to open %s: %s\n", file,
-				strerror(errno));
-			exit(1);
-		}
-		close(fd);
 		/*
-		 * open again without O_EXCL so that the problem should not
+		 * open without O_EXCL so that the problem should not
 		 * occur by the following processing.
 		 * (btrfs_register_one_device() fails if O_EXCL is on)
 		 */
@@ -1693,8 +1567,6 @@ raid_groups:
 
 	ret = close_ctree(root);
 	BUG_ON(ret);
-
 	free(label);
 	return 0;
 }
-
diff --git a/utils.c b/utils.c
index 27574a0..53ee919 100644
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
@@ -1719,3 +1720,130 @@ out:
 
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
+/* Check if disk is suitable for btrfs
+ * returns:
+ *  1: something is wrong, estr provides the error
+ *  0: all is fine
+ */
+int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
+{
+	int ret, fd;
+	size_t sz = 100;
+
+	ret = is_swap_device(file);
+	if (ret < 0) {
+		snprintf(estr, sz, "error checking %s status: %s\n", file,
+			strerror(-ret));
+		return 1;
+	}
+	if (ret == 1) {
+		snprintf(estr, sz, "%s is a swap device\n", file);
+		return 1;
+	}
+	if (!force_overwrite) {
+		if (check_overwrite(file)) {
+			snprintf(estr, sz, "Use the -f option to force overwrite.\n");
+			return 1;
+		}
+	}
+	ret = check_mounted(file);
+	if (ret < 0) {
+		snprintf(estr, sz, "error checking %s mount status\n",
+			file);
+		return 1;
+	}
+	if (ret == 1) {
+		snprintf(estr, sz, "%s is mounted\n", file);
+		return 1;
+	}
+	/* check if the device is busy */
+	fd = open(file, O_RDWR|O_EXCL);
+	if (fd < 0) {
+		snprintf(estr, sz, "unable to open %s: %s\n", file,
+			strerror(errno));
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index ab22b02..989c4e5 100644
--- a/utils.h
+++ b/utils.h
@@ -66,5 +66,6 @@ int is_swap_device(const char *file);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
+int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 
 #endif
-- 
1.8.1.227.g44fe835

