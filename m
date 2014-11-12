Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3863 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752909AbaKLFvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 00:51:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAC5pUu6008652
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 13:51:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] btrfs-progs: Check sb_bytenr with device size before scanning one device.
Date: Wed, 12 Nov 2014 13:52:11 +0800
Message-ID: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using btrfs check with -s option, if using '-s 2' on a small
device which doesn't have the third superblock, "No valid Btrfs found"
will be output, but it is not appropriate.

So check sb_bytenr against device size before scanning a device and
output proper error message.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 77fc610..d2599b5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1000,10 +1000,20 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 			  u64 sb_bytenr, int super_recover)
 {
 	u64 total_devs;
+	u64 dev_size;
 	int ret;
 	if (!sb_bytenr)
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
+	dev_size = lseek(fd, 0, SEEK_END);
+	if (dev_size < 0)
+		return (int)(dev_size);
+	lseek(fd, 0, SEEK_SET);
+	if (sb_bytenr > dev_size) {
+		fprintf(stderr, "Superblock bytenr is larger than device size\n");
+		return -EINVAL;
+	}
+
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
 				    &total_devs, sb_bytenr, super_recover);
 	if (ret) {
-- 
2.1.3

