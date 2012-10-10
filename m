Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34307 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2JJBwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 21:52:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so130032pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 18:52:47 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH v3 2/2] btrfs-progs: limit the min value of total_bytes
Date: Wed, 10 Oct 2012 09:52:28 +0800
Message-Id: <1349833948-11465-2-git-send-email-robin.k.dong@gmail.com>
In-Reply-To: <1349833948-11465-1-git-send-email-robin.k.dong@gmail.com>
References: <1349833948-11465-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Using mkfs.btrfs like:

	mkfs.btrfs -b 1048576 /dev/sda

will report error:

	mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed.
	Aborted

because the length of dev_extent is 4MB.

For the single/single case it's 5MB but
for the dup/dup it's 156MB. It's due to the known bug in the blockgroup
creation with multiple devices (applies on dup as well here) that leads to:

# btrfs fi df .
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Data+Metadata, DUP: total=64.00MB, used=24.00KB
Data+Metadata: total=8.00MB, used=0.00

8*2 + 4 + 64*2 + 8 = 156

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
v3 <- v2:
 - change the max value of total_bytes to 156MB.

 mkfs.c  |    7 ++++++-
 utils.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 93672b9..982a113 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1345,7 +1345,12 @@ int main(int ac, char **av)
 				&dev_block_count, &mixed, nodiscard);
 		if (block_count == 0)
 			block_count = dev_block_count;
-		else if (block_count > dev_block_count) {
+		else if (block_count < BTRFS_MKFS_SYSTEM_MAX_SIZE) {
+			fprintf(stderr, "Illegal total number of bytes %u "
+				"(smaller than %u)\n",
+				block_count, BTRFS_MKFS_SYSTEM_MAX_SIZE);
+			exit(1);
+		} else if (block_count > dev_block_count) {
 			fprintf(stderr, "%s is smaller than requested size\n", file);
 			exit(1);
 		}
diff --git a/utils.h b/utils.h
index c147c12..b63f69a 100644
--- a/utils.h
+++ b/utils.h
@@ -20,6 +20,7 @@
 #define __UTILS__
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define BTRFS_MKFS_SYSTEM_MAX_SIZE   (156 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-- 
1.7.3.2

