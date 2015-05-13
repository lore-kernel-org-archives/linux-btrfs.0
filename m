Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932707AbbEMJSU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 05:18:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH 2/4] btrfs-progs: Read the whole superblock instead of struct btrfs_super_block.
Date: Wed, 13 May 2015 17:15:34 +0800
Message-ID: <1431508536-7275-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the patch, btrfs-progs will only read
sizeof(struct btrfs_super_block) and restore it into super_copy.

This makes checksum check for superblock impossible.
Change it to read the whole superblock.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index c1cf146..e6ac3e9 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1264,7 +1264,8 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
-	struct btrfs_super_block buf;
+	char tmp[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *buf = (struct btrfs_super_block *)tmp;
 	int i;
 	int ret;
 	int max_super = super_recover ? BTRFS_SUPER_MIRROR_MAX : 1;
@@ -1272,15 +1273,15 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	u64 bytenr;
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
-		if (ret < sizeof(buf))
+		ret = pread64(fd, buf, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
+		if (ret < BTRFS_SUPER_INFO_SIZE)
 			return -1;
 
-		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
-		    btrfs_super_magic(&buf) != BTRFS_MAGIC)
+		if (btrfs_super_bytenr(buf) != sb_bytenr ||
+		    btrfs_super_magic(buf) != BTRFS_MAGIC)
 			return -1;
 
-		memcpy(sb, &buf, sizeof(*sb));
+		memcpy(sb, &buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
 	}
 
@@ -1293,22 +1294,22 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 
 	for (i = 0; i < max_super; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = pread64(fd, &buf, sizeof(buf), bytenr);
-		if (ret < sizeof(buf))
+		ret = pread64(fd, buf, BTRFS_SUPER_INFO_SIZE, bytenr);
+		if (ret < BTRFS_SUPER_INFO_SIZE)
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr )
+		if (btrfs_super_bytenr(buf) != bytenr )
 			continue;
 		/* if magic is NULL, the device was removed */
-		if (btrfs_super_magic(&buf) == 0 && i == 0)
+		if (btrfs_super_magic(buf) == 0 && i == 0)
 			return -1;
-		if (btrfs_super_magic(&buf) != BTRFS_MAGIC)
+		if (btrfs_super_magic(buf) != BTRFS_MAGIC)
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
@@ -1317,9 +1318,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			continue;
 		}
 
-		if (btrfs_super_generation(&buf) > transid) {
-			memcpy(sb, &buf, sizeof(*sb));
-			transid = btrfs_super_generation(&buf);
+		if (btrfs_super_generation(buf) > transid) {
+			memcpy(sb, buf, BTRFS_SUPER_INFO_SIZE);
+			transid = btrfs_super_generation(buf);
 		}
 	}
 
-- 
2.4.0

