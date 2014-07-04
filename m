Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbaGDH2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 03:28:16 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH v4] btrfs-progs: Add minimum device size check
Date: Fri, 4 Jul 2014 15:29:17 +0800
Message-ID: <1404458957-23621-1-git-send-email-quwenruo@cn.fujitsu.com>
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
and global block rsv = leafsize << 10

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
[minor wording tweaks in messages]
Signed-off-by: David Sterba <dsterba@suse.cz>
---
changelog:
v2: Use leafsize to get consistent with kernel global_block_rsv
calculation.
v3: Change words in error string.
    Use separate inline function to calculate global block rsv size.
    Rename the minimum device size calculation function.
v4: Fix a variant reuse bug which causes mkfs.btrfs use wrong first device.
---
 mkfs.c  | 29 +++++++++++++++++++++++++++++
 utils.c | 20 ++++++++++++++++++++
 utils.h | 22 ++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 7695c01..e2cc9d2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1451,6 +1451,35 @@ int main(int ac, char **av)
 		}
 	}
 
+	/* Check device/block_count after the leafsize is determined */
+	if (block_count && block_count < btrfs_min_dev_size(leafsize)) {
+		fprintf(stderr,
+			"Size '%llu' is too small to make a usable filesystem\n",
+			block_count);
+		fprintf(stderr,
+			"Minimum size for btrfs filesystem is %llu\n",
+			btrfs_min_dev_size(leafsize));
+		exit(1);
+	}
+	for (i = saved_optind; i < saved_optind + dev_cnt; i++) {
+		char *path;
+		path = av[i];
+		ret = test_minimum_size(path, leafsize);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to check size for '%s': %s\n",
+				path, strerror(-ret));
+			exit (1);
+		}
+		if (ret > 0) {
+			fprintf(stderr,
+				"'%s' is too small to make a usable filesystem\n",
+				path);
+			fprintf(stderr,
+				"Minimum size for each btrfs device is %llu.\n",
+				btrfs_min_dev_size(leafsize));
+			exit(1);
+		}
+	}
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
 			dev_cnt, mixed, estr);
 	if (ret) {
diff --git a/utils.c b/utils.c
index 46c3a43..c139eb2 100644
--- a/utils.c
+++ b/utils.c
@@ -2344,3 +2344,23 @@ int find_mount_root(const char *path, char **mount_root)
 	free(longest_match);
 	return ret;
 }
+
+int test_minimum_size(const char *file, u32 leafsize)
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
+	if (btrfs_device_size(fd, &statbuf) < btrfs_min_dev_size(leafsize)) {
+		close(fd);
+		return 1;
+	}
+	close(fd);
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 37fe1ba..6599ee4 100644
--- a/utils.h
+++ b/utils.h
@@ -105,4 +105,26 @@ int get_device_info(int fd, u64 devid,
 		struct btrfs_ioctl_dev_info_args *di_args);
 int test_uuid_unique(char *fs_uuid);
 
+int test_minimum_size(const char *file, u32 leafsize);
+
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
+static inline u64 btrfs_min_global_blk_rsv_size(u32 leafsize)
+{
+	return leafsize << 10;
+}
+static inline u64 btrfs_min_dev_size(u32 leafsize)
+{
+	return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
+		    btrfs_min_global_blk_rsv_size(leafsize));
+}
+
 #endif
-- 
2.0.1

