Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35040 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdJPIX7 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 16 Oct 2017 04:23:59 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/3] btrfs-progs: Refactor test_minimum_size to use calculated minimal device size
Date: Mon, 16 Oct 2017 16:22:56 +0800
Message-Id: <20171016082258.27815-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

test_minimum_size() function is only called to check if provided device
is large enough.

However the minimal device size only needs to be calculated once, and
can be reused everywhere.

Refactor that function to make later modification easier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  New patch, cleanup suggested by Lu Fengqi.
---
 mkfs/common.c |  4 ++--
 mkfs/common.h |  2 +-
 mkfs/main.c   | 10 ++++++----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index c9ce10d46a9d..71318b10fa51 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -698,7 +698,7 @@ int is_vol_small(const char *file)
 	}
 }
 
-int test_minimum_size(const char *file, u32 nodesize)
+int test_minimum_size(const char *file, u64 min_dev_size)
 {
 	int fd;
 	struct stat statbuf;
@@ -710,7 +710,7 @@ int test_minimum_size(const char *file, u32 nodesize)
 		close(fd);
 		return -errno;
 	}
-	if (btrfs_device_size(fd, &statbuf) < btrfs_min_dev_size(nodesize)) {
+	if (btrfs_device_size(fd, &statbuf) < min_dev_size) {
 		close(fd);
 		return 1;
 	}
diff --git a/mkfs/common.h b/mkfs/common.h
index dee0ea9740e0..3757e9e7fd0a 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -68,7 +68,7 @@ struct btrfs_mkfs_config {
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
 u64 btrfs_min_dev_size(u32 nodesize);
 u64 btrfs_min_global_blk_rsv_size(u32 nodesize);
-int test_minimum_size(const char *file, u32 nodesize);
+int test_minimum_size(const char *file, u64 min_dev_size);
 int is_vol_small(const char *file);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, int ssd);
diff --git a/mkfs/main.c b/mkfs/main.c
index 1b4cabc1ef90..97c2d133f3c5 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1436,6 +1436,7 @@ int main(int argc, char **argv)
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
+	u64 min_dev_size;
 	int dev_cnt = 0;
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
@@ -1646,19 +1647,20 @@ int main(int argc, char **argv)
 		goto error;
 	}
 
+	min_dev_size = btrfs_min_dev_size(nodesize);
 	/* Check device/block_count after the nodesize is determined */
-	if (block_count && block_count < btrfs_min_dev_size(nodesize)) {
+	if (block_count && block_count < min_dev_size) {
 		error("size %llu is too small to make a usable filesystem",
 			block_count);
 		error("minimum size for btrfs filesystem is %llu",
-			btrfs_min_dev_size(nodesize));
+			min_dev_size);
 		goto error;
 	}
 	for (i = saved_optind; i < saved_optind + dev_cnt; i++) {
 		char *path;
 
 		path = argv[i];
-		ret = test_minimum_size(path, nodesize);
+		ret = test_minimum_size(path, min_dev_size);
 		if (ret < 0) {
 			error("failed to check size for %s: %s",
 				path, strerror(-ret));
@@ -1668,7 +1670,7 @@ int main(int argc, char **argv)
 			error("'%s' is too small to make a usable filesystem",
 				path);
 			error("minimum size for each btrfs device is %llu",
-				btrfs_min_dev_size(nodesize));
+				min_dev_size);
 			goto error;
 		}
 	}
-- 
2.14.2

