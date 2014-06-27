Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58189 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406AbaF0Cdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 22:33:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5R2XnSv021571
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 10:33:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Check superblock's checksum in btrfs-progs.
Date: Fri, 27 Jun 2014 10:34:54 +0800
Message-ID: <1403836494-26904-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-progs will read the superblock without checking the checksum.
When all superblocks are corrupted, continuing will cause disaster.

So this patch will add checksum check for btrfs-progs when reading
superblocks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 8db0335..3524834 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -990,7 +990,8 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	ret = btrfs_scan_one_device(fd, path, fs_devices,
 				    &total_devs, sb_bytenr);
 	if (ret) {
-		fprintf(stderr, "No valid Btrfs found on %s\n", path);
+		fprintf(stderr, "No valid Btrfs found or all superblock are corrupted on %s\n",
+			path);
 		return ret;
 	}
 
@@ -1100,7 +1101,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	else
 		ret = btrfs_read_dev_super(fp, disk_super, sb_bytenr);
 	if (ret) {
-		printk("No valid btrfs found\n");
+		fprintf(stderr, "No valid btrfs found or all super blocks are corrupted\n");
 		goto out_devices;
 	}
 
@@ -1191,6 +1192,8 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
+	u32 crc;
+	char crc_result[BTRFS_CSUM_SIZE];
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
@@ -1226,6 +1229,14 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 		if (btrfs_super_magic(&buf) != BTRFS_MAGIC)
 			continue;
 
+		/* check if the superblock is damaged */
+		crc = ~(u32)0;
+		crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
+				      crc, BTRFS_SUPER_INFO_SIZE -
+				      BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, crc_result);
+		if (memcmp(crc_result, sb->csum, BTRFS_CSUM_SIZE))
+			continue;
 		if (!fsid_is_initialized) {
 			memcpy(fsid, buf.fsid, sizeof(fsid));
 			fsid_is_initialized = 1;
-- 
2.0.0

