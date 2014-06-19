Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51486 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbaFSDYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 23:24:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J3OWjS026497
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 11:24:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Add minimum device size check.
Date: Thu, 19 Jun 2014 11:25:38 +0800
Message-ID: <1403148338-6584-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has global block reservation, so even mkfs.btrfs can execute
without problem, there is still a possibility that the filesystem can't
be mounted.
For example when mkfs.btrfs on a 8M file on x86_64 platform, kernel will
refuse to mount due to ENOSPC, since system block group takes 4M and
mixed block group takes 4M, and global block reservation will takes all
the 4M from mixed block group, which makes btrfs unable to create uuid
tree.

This patch will add minimum device size check before actually mkfs.
The minimum size calculation uses a simplified one:
minimum_size_for_each_dev = 2 * (system block group + global block rsv)

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 mkfs.c  | 24 ++++++++++++++++++++++++
 utils.c | 30 ++++++++++++++++++++++++++++++
 utils.h | 13 +++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 16e9222..58c751c 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1337,6 +1337,15 @@ int main(int ac, char **av)
 					       "metadata/data groups\n");
 					mixed = 1;
 				}
+				if (block_count < BTRFS_MIN_SIZE_EACH) {
+					fprintf(stderr,
+						"Size '%llu' is too small to make a usable btrfs\n",
+						block_count);
+					fprintf(stderr,
+						"Recommended size for each device is %llu\n",
+						BTRFS_MIN_SIZE_EACH);
+					exit(1);
+				}
 				zero_end = 0;
 				break;
 			case 'V':
@@ -1370,6 +1379,21 @@ int main(int ac, char **av)
 	}
 	while (dev_cnt-- > 0) {
 		file = av[optind++];
+		ret = test_minimum_size(file);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to check size for '%s': %s\n",
+				file, strerror(-ret));
+			exit(1);
+		}
+		if (ret > 0) {
+			fprintf(stderr,
+				"'%s' is too small to make a usable btrfs\n",
+				file);
+			fprintf(stderr,
+				"Recommended size for each device is %llu\n",
+				BTRFS_MIN_SIZE_EACH);
+			exit(1);
+		}
 		if (is_block_device(file))
 			if (test_dev_for_mkfs(file, force_overwrite, estr)) {
 				fprintf(stderr, "Error: %s", estr);
diff --git a/utils.c b/utils.c
index e130849..6f47acc 100644
--- a/utils.c
+++ b/utils.c
@@ -719,6 +719,16 @@ int is_block_device(const char *path)
 	return S_ISBLK(statbuf.st_mode);
 }
 
+int is_regular_file(const char *path)
+{
+	struct stat statbuf;
+
+	if (stat(path, &statbuf) < 0)
+		return -errno;
+
+	return S_ISREG(statbuf.st_mode);
+}
+
 /*
  * check if given path is a mount point
  * return 1 if yes. 0 if no. -1 for error
@@ -2206,3 +2216,23 @@ int find_mount_root(const char *path, char **mount_root)
 	free(longest_match);
 	return ret;
 }
+
+int test_minimum_size(const char *file)
+{
+	int fd;
+	struct stat statbuf;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+	if (stat(file, &statbuf) < 0) {
+		close(fd);
+		return -errno;
+	}
+	if (btrfs_device_size(fd, &statbuf) < BTRFS_MIN_SIZE_EACH) {
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index db8d63c..7f30d12 100644
--- a/utils.h
+++ b/utils.h
@@ -101,5 +101,18 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int find_mount_root(const char *path, char **mount_root);
 int get_device_info(int fd, u64 devid,
 		struct btrfs_ioctl_dev_info_args *di_args);
+int test_minimum_size(const char *file);
 
+/*
+ * Btrfs minimum size calculation is complicated, it should include at least:
+ * 1. system group size
+ * 2. minimum global block reserve
+ * 3. metadata used at mkfs
+ * 4. space reservation to create uuid for first mount.
+ * Also, raid factor should also be taken into consideration.
+ * To avoid the overkill calculation, (system group + global block rsv) * 2
+ * for *EACH* device should be good enough.
+ */
+#define BTRFS_MIN_SIZE_EACH	(2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE + \
+				      ((u64)sysconf(_SC_PAGESIZE) << 10)))
 #endif
-- 
2.0.0

