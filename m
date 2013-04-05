Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765525Ab3DEFxu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:50 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rnjm032420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:50 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rmn2005301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:48 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rm8A015102
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:48 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs-progs: mkfs should first check all disks before writing to a disk
Date: Fri,  5 Apr 2013 13:54:57 +0800
Message-Id: <1365141303-10571-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
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

merge with prev

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 149 ++++++++++++++++++++++++++++++-----------------------------------
 1 file changed, 69 insertions(+), 80 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c8cb395..7d23520 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1341,6 +1341,46 @@ out:
 	return ret;
 }
 
+void __test_dev_for_mkfs(char *file, int force_overwrite)
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
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1378,6 +1418,8 @@ int main(int ac, char **av)
 	char *pretty_buf;
 	struct btrfs_super_block *super;
 	u64 flags;
+	int dev_cnt=0;
+	int saved_optind;
 
 	while(1) {
 		int c;
@@ -1442,51 +1484,36 @@ int main(int ac, char **av)
 		exit(1);
 	if (check_leaf_or_node_size(nodesize, sectorsize))
 		exit(1);
-	ac = ac - optind;
-	if (ac == 0)
+	saved_optind = optind;
+	dev_cnt = ac - optind;
+	if (dev_cnt == 0)
 		print_usage();
 
+	if (source_dir_set && dev_cnt > 1) {
+		fprintf(stderr,
+			"The -r option is limited to a single device\n");
+		exit(1);
+	}
+	while (dev_cnt-- > 0) {
+		file = av[optind++];
+		/* following func would exit on error */
+		if (is_block_device(file))
+			__test_dev_for_mkfs(file, force_overwrite);
+	}
+
+	/* if we are here that means all devs are good to btrfsify*/
+	optind = saved_optind;
+	dev_cnt = ac - optind;
+
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
-	if (source_dir == 0) {
-		file = av[optind++];
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
-				exit(1);
-			}
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
@@ -1504,8 +1531,6 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	} else {
-		ac = 0;
-		file = av[optind++];
 		fd = open_target(file);
 		if (fd < 0) {
 			fprintf(stderr, "unable to open the %s\n", file);
@@ -1566,53 +1591,19 @@ int main(int ac, char **av)
 
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
@@ -1693,8 +1684,6 @@ raid_groups:
 
 	ret = close_ctree(root);
 	BUG_ON(ret);
-
 	free(label);
 	return 0;
 }
-
-- 
1.8.1.227.g44fe835

