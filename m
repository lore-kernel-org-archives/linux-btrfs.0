Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913AbaLSGPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:17 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6Ensb027643
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] btrfs-progs: Fix a clang dead-judgement warning in disk-io.c.
Date: Fri, 19 Dec 2014 14:13:09 +0800
Message-ID: <1418969592-21278-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When compiled with clang, the following warning is outputted.

disk-io.c:1017:15: warning: comparison of unsigned expression < 0 is
always false [-Wtautological-compare]
        if (dev_size < 0)
            ~~~~~~~~ ^ ~
1 warning generated.

This is because dev_size is defined as unsigned type, but lseek() will
return singed valued.
So the judgement will always to false.

Use temporary off_t return value to solve it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 03edf8e..2bf8586 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1009,13 +1009,16 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 {
 	u64 total_devs;
 	u64 dev_size;
+	off_t seek_ret;
 	int ret;
 	if (!sb_bytenr)
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
-	dev_size = lseek(fd, 0, SEEK_END);
-	if (dev_size < 0)
-		return (int)(dev_size);
+	seek_ret = lseek(fd, 0, SEEK_END);
+	if (seek_ret < 0)
+		return -errno;
+
+	dev_size = seek_ret;
 	lseek(fd, 0, SEEK_SET);
 	if (sb_bytenr > dev_size) {
 		fprintf(stderr, "Superblock bytenr is larger than device size\n");
-- 
2.1.3

