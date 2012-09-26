Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2IZHwS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 03:52:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1482808pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 00:52:17 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 2/2] btrfs-progs: limit the min value of total_bytes
Date: Wed, 26 Sep 2012 15:52:08 +0800
Message-Id: <1348645928-3432-2-git-send-email-robin.k.dong@gmail.com>
In-Reply-To: <1348645928-3432-1-git-send-email-robin.k.dong@gmail.com>
References: <1348645928-3432-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Using mkfs.btrfs like:
	
	mkfs.btrfs -b 1048576 /dev/sda

will report error:

	mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed.
	Aborted

because the length of dev_extent is 4MB.

But if we use mkfs.btrfs with 8MB total bytes, the newly mounted btrfs filesystem
would not contain even one empty file. So 12MB will be good min value for block_count.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 mkfs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index bb01f64..23bde2d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1330,7 +1330,11 @@ int main(int ac, char **av)
 				&dev_block_count, &mixed, nodiscard);
 		if (block_count == 0)
 			block_count = dev_block_count;
-		else if (block_count > dev_block_count) {
+		else if (block_count < 3 * BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
+			fprintf(stderr, "Illegal total number of bytes %u\n",
+					block_count);
+			exit(1);
+		} else if (block_count > dev_block_count) {
 			fprintf(stderr, "%s is smaller than requested size\n", file);
 			exit(1);
 		}
-- 
1.7.3.2

