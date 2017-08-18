Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65458 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750977AbdHRIdB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 04:33:01 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 1344447243A3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 16:32:54 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: add necessary close(fd) in mkfs
Date: Fri, 18 Aug 2017 01:32:45 -0700
Message-ID: <1503045166-18612-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add some close(fd) when error occures in mkfs.
And add close(fd) when end use it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 mkfs/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 2b109a5..ec82565 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1694,6 +1694,7 @@ int main(int argc, char **argv)
 					file,
 					(unsigned long long)block_count,
 					(unsigned long long)dev_block_count);
+			close(fd);
 			exit(1);
 		}
 	} else {
@@ -1711,6 +1712,7 @@ int main(int argc, char **argv)
 		ret = zero_output_file(fd, block_count);
 		if (ret) {
 			error("unable to zero the output file");
+			close(fd);
 			exit(1);
 		}
 		/* our "device" is the new image file */
@@ -1721,6 +1723,7 @@ int main(int argc, char **argv)
 	if (dev_block_count < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
 		error("device is too small to make filesystem, must be at least %llu",
 				(unsigned long long)BTRFS_MKFS_SYSTEM_GROUP_SIZE);
+		close(fd);
 		exit(1);
 	}
 
@@ -1740,6 +1743,7 @@ int main(int argc, char **argv)
 	ret = make_btrfs(fd, &mkfs_cfg);
 	if (ret) {
 		error("error during mkfs: %s", strerror(-ret));
+		close(fd);
 		exit(1);
 	}
 
@@ -1750,6 +1754,7 @@ int main(int argc, char **argv)
 		close(fd);
 		exit(1);
 	}
+	close(fd);
 	root = fs_info->fs_root;
 	fs_info->alloc_start = alloc_start;
 
@@ -1827,6 +1832,7 @@ int main(int argc, char **argv)
 					sectorsize, sectorsize, sectorsize);
 		if (ret) {
 			error("unable to add %s to filesystem: %d", file, ret);
+			close(fd);
 			goto out;
 		}
 		if (verbose >= 2) {
-- 
1.9.1



