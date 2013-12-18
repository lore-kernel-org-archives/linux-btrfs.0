Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18094 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3LRD7k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 22:59:40 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBI3xc5g009283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 03:59:39 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBI3xc13025625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 03:59:38 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBI3xc42002537
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 03:59:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 3/3] btrfs-progs: handle error in the btrfs_prepare_device
Date: Wed, 18 Dec 2013 12:07:55 +0800
Message-Id: <1387339675-29543-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1387279007-10388-3-git-send-email-anand.jain@oracle.com>
References: <1387279007-10388-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

this patch will handle the strerror reporting of the error instead of
printing errno,  and also replaced the BUG_ON with the error handling

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v4: replaced ? statement with proper if statement
 v3: fix per Stefan review, update error message
 v2: commit update

 cmds-device.c  |    7 +++----
 cmds-replace.c |    9 ++++-----
 mkfs.c         |    9 ++++++++-
 utils.c        |   31 ++++++++++++++++++++-----------
 4 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index bc4a8dc..ada0bcd 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -111,13 +111,11 @@ static int cmd_add_dev(int argc, char **argv)
 
 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
 					   0, &mixed, discard);
+		close(devfd);
 		if (res) {
-			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
-			close(devfd);
 			ret++;
-			continue;
+			goto error_out;
 		}
-		close(devfd);
 
 		strncpy_null(ioctl_args.name, argv[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
@@ -130,6 +128,7 @@ static int cmd_add_dev(int argc, char **argv)
 
 	}
 
+error_out:
 	close_file_or_dir(fdmnt, dirstream);
 	return !!ret;
 }
diff --git a/cmds-replace.c b/cmds-replace.c
index d9b0940..c683d6c 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -276,12 +276,11 @@ static int cmd_start_replace(int argc, char **argv)
 	}
 	strncpy((char *)start_args.start.tgtdev_name, dstdev,
 		BTRFS_DEVICE_PATH_NAME_MAX);
-	if (btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
-				 &mixed, 0)) {
-		fprintf(stderr, "Error: Failed to prepare device '%s'\n",
-			dstdev);
+	ret = btrfs_prepare_device(fddstdev, dstdev, 1, &dstdev_block_count, 0,
+				 &mixed, 0);
+	if (ret)
 		goto leave_with_error;
-	}
+
 	close(fddstdev);
 	fddstdev = -1;
 
diff --git a/mkfs.c b/mkfs.c
index 33369f9..18df087 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1446,6 +1446,10 @@ int main(int ac, char **av)
 		first_file = file;
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
+		if (ret) {
+			close(fd);
+			exit(1);
+		}
 		if (block_count && block_count > dev_block_count) {
 			fprintf(stderr, "%s is smaller than requested size\n", file);
 			exit(1);
@@ -1553,8 +1557,11 @@ int main(int ac, char **av)
 		}
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
+		if (ret) {
+			close(fd);
+			exit(1);
+		}
 		mixed = old_mixed;
-		BUG_ON(ret);
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
 					sectorsize, sectorsize, sectorsize);
diff --git a/utils.c b/utils.c
index f499023..f37083a 100644
--- a/utils.c
+++ b/utils.c
@@ -581,13 +581,13 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	ret = fstat(fd, &st);
 	if (ret < 0) {
 		fprintf(stderr, "unable to stat %s\n", file);
-		exit(1);
+		return 1;
 	}
 
 	block_count = btrfs_device_size(fd, &st);
 	if (block_count == 0) {
 		fprintf(stderr, "unable to find %s size\n", file);
-		exit(1);
+		return 1;
 	}
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
@@ -612,26 +612,35 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 
 	ret = zero_dev_start(fd);
-	if (ret) {
-		fprintf(stderr, "failed to zero device start %d\n", ret);
-		exit(1);
-	}
+	if (ret)
+		goto zero_dev_error;
 
 	for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr >= block_count)
 			break;
-		zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
+		ret = zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
+		if (ret)
+			goto zero_dev_error;
 	}
 
 	if (zero_end) {
 		ret = zero_dev_end(fd, block_count);
-		if (ret) {
-			fprintf(stderr, "failed to zero device end %d\n", ret);
-			exit(1);
-		}
+		if (ret)
+			goto zero_dev_error;
 	}
 	*block_count_ret = block_count;
+
+zero_dev_error:
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: failed to zero device '%s' - %s\n",
+			file, strerror(-ret));
+		return 1;
+	} else if (ret > 0) {
+		fprintf(stderr, "ERROR: failed to zero device '%s' - %d\n",
+			file, ret);
+		return 1;
+	}
 	return 0;
 }
 
-- 
1.7.1

