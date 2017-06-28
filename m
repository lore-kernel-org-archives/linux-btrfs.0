Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51026 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751515AbdF1GdW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 02:33:22 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B2C2647E64CC
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 14:33:14 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs: Add some check for sectorsize and nodesize
Date: Wed, 28 Jun 2017 14:32:39 +0800
Message-ID: <20170628063239.8399-2-gujx@cn.fujitsu.com>
In-Reply-To: <20170628063239.8399-1-gujx@cn.fujitsu.com>
References: <20170628063239.8399-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add some check for sectorsize and nodesize, make it
consistent with kernel.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 convert/main.c |  6 +-----
 fsfeatures.h   |  2 +-
 mkfs/main.c    |  8 +-------
 utils.c        | 21 +++++++++++++++++++--
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 4f65765..bcadcfa 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1221,11 +1221,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
 
 	blocksize = cctx.blocksize;
 	total_bytes = (u64)blocksize * (u64)cctx.block_count;
-	if (blocksize < 4096) {
-		error("block size is too small: %u < 4096", blocksize);
-		goto fail;
-	}
-	if (btrfs_check_nodesize(nodesize, blocksize, features))
+	if (btrfs_check_sizes(nodesize, blocksize, features))
 		goto fail;
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
diff --git a/fsfeatures.h b/fsfeatures.h
index 513ed1e..fa8fb14 100644
--- a/fsfeatures.h
+++ b/fsfeatures.h
@@ -45,6 +45,6 @@ void btrfs_process_fs_features(u64 flags);
 void btrfs_parse_features_to_string(char *buf, u64 flags);
 void print_kernel_version(FILE *stream, u32 version);
 u32 get_running_kernel_version(void);
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features);
+int btrfs_check_sizes(u32 nodesize, u32 sectorsize, u64 features);
 
 #endif
diff --git a/mkfs/main.c b/mkfs/main.c
index 2b109a5..7a25f01 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1626,16 +1626,10 @@ int main(int argc, char **argv)
 		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
-	if (btrfs_check_nodesize(nodesize, sectorsize,
+	if (btrfs_check_sizes(nodesize, sectorsize,
 				 features))
 		exit(1);
 
-	if (sectorsize < sizeof(struct btrfs_super_block)) {
-		error("sectorsize smaller than superblock: %u < %zu",
-				sectorsize, sizeof(struct btrfs_super_block));
-		exit(1);
-	}
-
 	/* Check device/block_count after the nodesize is determined */
 	if (block_count && block_count < btrfs_min_dev_size(nodesize)) {
 		error("size %llu is too small to make a usable filesystem",
diff --git a/utils.c b/utils.c
index 243ee1e..c276b58 100644
--- a/utils.c
+++ b/utils.c
@@ -2120,9 +2120,26 @@ int btrfs_tree_search2_ioctl_supported(int fd)
 	return ret;
 }
 
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
+int btrfs_check_sizes(u32 nodesize, u32 sectorsize, u64 features)
 {
-	if (nodesize < sectorsize) {
+	/* check sectorsize */
+	if (!is_power_of_2(sectorsize)) {
+		error("illegal sectorsize %u (not power of 2)", sectorsize);
+		return -1;
+	} else if (sectorsize < SZ_4K) {
+		error("illegal sectorsize %u (smaller than %u)",
+				sectorsize, SZ_4K);
+		return -1;
+	} else if (sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		error("illegal sectorsize %u (larger than %u)",
+				sectorsize, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	}
+	/* check nodesize */
+	if (!is_power_of_2(nodesize)) {
+		error("illegal nodesize %u (not power of 2)", nodesize);
+		return -1;
+	} else if (nodesize < sectorsize) {
 		error("illegal nodesize %u (smaller than %u)",
 				nodesize, sectorsize);
 		return -1;
-- 
2.9.4



