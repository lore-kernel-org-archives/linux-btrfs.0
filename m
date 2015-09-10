Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45126 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754358AbbIJCgY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 22:36:24 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 2/5] btrfs-progs: utils: Check nodesize against features
Date: Thu, 10 Sep 2015 10:34:15 +0800
Message-ID: <1441852458-10289-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check nodesize against features, not only sectorsize.
In fact, one of the btrfs-convert and mkfs differs in the nodesize
check.

This patch also provides the basis for later btrfs-convert fix.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c |  2 +-
 mkfs.c          | 16 +++++-----------
 utils.c         |  8 +++++++-
 utils.h         |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index f4fc650..459b89a 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2314,7 +2314,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "filetype feature is missing\n");
 		goto fail;
 	}
-	if (btrfs_check_nodesize(nodesize, blocksize))
+	if (btrfs_check_nodesize(nodesize, blocksize, features))
 		goto fail;
 	blocks_per_node = nodesize / blocksize;
 	ret = -blocks_per_node;
diff --git a/mkfs.c b/mkfs.c
index 14e7eb4..b8879fc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1466,9 +1466,8 @@ int main(int ac, char **av)
 				print_usage(c != GETOPT_VAL_HELP);
 		}
 	}
+
 	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
-	if (btrfs_check_nodesize(nodesize, sectorsize))
-		exit(1);
 	saved_optind = optind;
 	dev_cnt = ac - optind;
 	if (dev_cnt == 0)
@@ -1542,17 +1541,12 @@ int main(int ac, char **av)
 			}
 		}
 
-		if (!nodesize_forced) {
+		if (!nodesize_forced)
 			nodesize = best_nodesize;
-			if (btrfs_check_nodesize(nodesize, sectorsize))
-				exit(1);
-		}
-		if (nodesize != sectorsize) {
-			fprintf(stderr, "Error: mixed metadata/data block groups "
-				"require metadata blocksizes equal to the sectorsize\n");
-			exit(1);
-		}
 	}
+	if (btrfs_check_nodesize(nodesize, sectorsize,
+				 features))
+		exit(1);
 
 	/* Check device/block_count after the nodesize is determined */
 	if (block_count && block_count < btrfs_min_dev_size(nodesize)) {
diff --git a/utils.c b/utils.c
index 52791b5..c0d1afa 100644
--- a/utils.c
+++ b/utils.c
@@ -2928,7 +2928,7 @@ int btrfs_tree_search2_ioctl_supported(int fd)
 	return v2_supported;
 }
 
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize)
+int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features)
 {
 	if (nodesize < sectorsize) {
 		fprintf(stderr,
@@ -2945,6 +2945,12 @@ int btrfs_check_nodesize(u32 nodesize, u32 sectorsize)
 			"ERROR: Illegal nodesize %u (not aligned to %u)\n",
 			nodesize, sectorsize);
 		return -1;
+	} else if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS &&
+		   nodesize != sectorsize) {
+		fprintf(stderr,
+			"ERROR: Illegal nodesize %u (not equal to %u for mixed block group)\n",
+			nodesize, sectorsize);
+		return -1;
 	}
 	return 0;
 }
diff --git a/utils.h b/utils.h
index dce0a47..0eadaf1 100644
--- a/utils.h
+++ b/utils.h
@@ -241,7 +241,7 @@ static inline u64 div_factor(u64 num, int factor)
 }
 
 int btrfs_tree_search2_ioctl_supported(int fd);
-int btrfs_check_nodesize(u32 nodesize, u32 sectorsize);
+int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features);
 
 const char *get_argv0_buf(void);
 
-- 
2.5.1

