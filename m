Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40124 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030625AbaGCJfF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 05:35:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s639Z1pc009498
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 17:35:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/4] btrfs-progs: Check superblock's checsum when read dev super
Date: Thu, 3 Jul 2014 17:36:00 +0800
Message-ID: <1404380164-25325-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404380164-25325-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404380164-25325-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-progs will read the superblock without checking the checksum.
When all superblocks are corrupted, continuing will cause disaster.

So this patch will add checksum check for btrfs-progs when reading
superblocks.

Also fix a bug that btrfs_read_dev_super() only reads sizeof(struct
btrfs_super_block), corrent size should be BTRFS_SUPER_INFO_SIZE.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Use corrent memcmp src.
  Read the whole supblock size(sectorsize) other than
  sizeof(btrfs_super_block).
---
 disk-io.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 8db0335..e447af8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1186,22 +1186,25 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
-	struct btrfs_super_block buf;
+	u8 data[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *buf = (struct btrfs_super_block *) data;
 	int i;
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
+	u32 crc;
+	char crc_result[BTRFS_CSUM_SIZE];
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
-		if (ret < sizeof(buf))
+		ret = pread64(fd, data, sizeof(data), sb_bytenr);
+		if (ret < sizeof(data))
 			return -1;
 
-		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
-		    btrfs_super_magic(&buf) != BTRFS_MAGIC)
+		if (btrfs_super_bytenr(buf) != sb_bytenr ||
+		    btrfs_super_magic(buf) != BTRFS_MAGIC)
 			return -1;
 
-		memcpy(sb, &buf, sizeof(*sb));
+		memcpy(sb, data, sizeof(data));
 		return 0;
 	}
 
@@ -1214,22 +1217,31 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 
 	for (i = 0; i < 1; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = pread64(fd, &buf, sizeof(buf), bytenr);
-		if (ret < sizeof(buf))
+		ret = pread64(fd, data, sizeof(data), bytenr);
+		if (ret < sizeof(data))
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr )
+		if (btrfs_super_bytenr(buf) != bytenr)
 			continue;
-		/* if magic is NULL, the device was removed */
-		if (btrfs_super_magic(&buf) == 0 && i == 0)
+		/* if first super block is not btrfs, the device was removed */
+		if (btrfs_super_magic(buf) != BTRFS_MAGIC && i == 0)
 			return -1;
-		if (btrfs_super_magic(&buf) != BTRFS_MAGIC)
+		if (btrfs_super_magic(buf) != BTRFS_MAGIC)
+			continue;
+
+		/* check if the superblock is damaged */
+		crc = ~(u32)0;
+		crc = btrfs_csum_data(NULL, (char *)buf + BTRFS_CSUM_SIZE,
+				      crc, BTRFS_SUPER_INFO_SIZE -
+				      BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, crc_result);
+		if (memcmp(crc_result, buf, btrfs_super_csum_size(buf)))
 			continue;
 
 		if (!fsid_is_initialized) {
-			memcpy(fsid, buf.fsid, sizeof(fsid));
+			memcpy(fsid, buf->fsid, sizeof(fsid));
 			fsid_is_initialized = 1;
-		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+		} else if (memcmp(fsid, buf->fsid, sizeof(fsid))) {
 			/*
 			 * the superblocks (the original one and
 			 * its backups) contain data of different
@@ -1238,9 +1250,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 			continue;
 		}
 
-		if (btrfs_super_generation(&buf) > transid) {
-			memcpy(sb, &buf, sizeof(*sb));
-			transid = btrfs_super_generation(&buf);
+		if (btrfs_super_generation(buf) > transid) {
+			memcpy(sb, data, sizeof(data));
+			transid = btrfs_super_generation(buf);
 		}
 	}
 
-- 
2.0.1

