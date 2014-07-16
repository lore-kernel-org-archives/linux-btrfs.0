Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39716 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaGPVCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 17:02:42 -0400
Received: from lenny.home.zabbo.net (lenny.home.zabbo.net [192.168.242.10])
	by tetsuo.zabbo.net (Postfix) with ESMTP id 77CEC7200219
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 14:02:41 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: mkfs: don't zero extend small files
Date: Wed, 16 Jul 2014 14:02:37 -0700
Message-Id: <1405544557-26550-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs can try to write outside of small devices.  The zeroing code
doesn't test the device size and runs before mkfs tests for small
devices and exits.

Testers experienced this as small regular files being extended as mkfs
failed:

 $ truncate -s 1m /tmp/some-file
 $ strace -epwrite ./mkfs.btrfs /tmp/some-file
 SMALL VOLUME: forcing mixed metadata/data groups

 WARNING! - Btrfs v3.14.2 IS EXPERIMENTAL
 WARNING! - see http://btrfs.wiki.kernel.org before using

 pwrite(3, ..., 2097152, 0) = 2097152
 pwrite(3, ..., 4096, 65536) = 4096
 pwrite(3 ..., 2097152, 18446744073708503040) = -1 EINVAL (Invalid argument)
 ERROR: failed to zero device '/tmp/some-file' - Input/output error

 $ ls -lh /tmp/some-file
 -rw-rw-r--. 1 zab zab 2.0M Jul 16 13:49 /tmp/some-file

This simple fix adds a helper that clamps a region to be zeroed to the
size of the device.  It doesn't address the larger questions of whether
to modify the device before the size test or whether or zero regions
that have been trimmed.

Finally, the error handling mess after the zeroing calls is cleaned up.
zero_blocks() and its callers only return -errno.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 utils.c | 58 ++++++++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/utils.c b/utils.c
index e130849..6c32b51 100644
--- a/utils.c
+++ b/utils.c
@@ -497,25 +497,23 @@ static int zero_blocks(int fd, off_t start, size_t len)
 	return ret;
 }
 
-static int zero_dev_start(int fd)
+#define ZERO_DEV_BYTES (2 * 1024 * 1024)
+
+/* don't write outside the device by clamping the region to the device size */
+static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
 {
-	off_t start = 0;
-	size_t len = 2 * 1024 * 1024;
+	off_t end = max(start, start + len);
 
 #ifdef __sparc__
-	/* don't overwrite the disk labels on sparc */
-	start = 1024;
-	len -= 1024;
+	/* and don't overwrite the disk labels on sparc */
+	start = max(start, 1024);
+	end = max(end, 1024);
 #endif
-	return zero_blocks(fd, start, len);
-}
 
-static int zero_dev_end(int fd, u64 dev_size)
-{
-	size_t len = 2 * 1024 * 1024;
-	off_t start = dev_size - len;
+	start = min_t(u64, start, dev_size);
+	end = min_t(u64, end, dev_size);
 
-	return zero_blocks(fd, start, len);
+	return zero_blocks(fd, start, end - start);
 }
 
 int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
@@ -596,7 +594,6 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 			   u64 max_block_count, int *mixed, int discard)
 {
 	u64 block_count;
-	u64 bytenr;
 	struct stat st;
 	int i, ret;
 
@@ -632,36 +629,21 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 		}
 	}
 
-	ret = zero_dev_start(fd);
-	if (ret)
-		goto zero_dev_error;
-
-	for (i = 0 ; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		if (bytenr >= block_count)
-			break;
-		ret = zero_blocks(fd, bytenr, BTRFS_SUPER_INFO_SIZE);
-		if (ret)
-			goto zero_dev_error;
-	}
+	ret = zero_dev_clamped(fd, 0, ZERO_DEV_BYTES, block_count);
+	for (i = 0 ; !ret && i < BTRFS_SUPER_MIRROR_MAX; i++)
+		ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
+				       BTRFS_SUPER_INFO_SIZE, block_count);
+	if (!ret && zero_end)
+		ret = zero_dev_clamped(fd, block_count - ZERO_DEV_BYTES,
+				       ZERO_DEV_BYTES, block_count);
 
-	if (zero_end) {
-		ret = zero_dev_end(fd, block_count);
-		if (ret)
-			goto zero_dev_error;
-	}
-	*block_count_ret = block_count;
-
-zero_dev_error:
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: failed to zero device '%s' - %s\n",
 			file, strerror(-ret));
 		return 1;
-	} else if (ret > 0) {
-		fprintf(stderr, "ERROR: failed to zero device '%s' - %d\n",
-			file, ret);
-		return 1;
 	}
+
+	*block_count_ret = block_count;
 	return 0;
 }
 
-- 
1.9.3

