Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39281 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751697AbcLHN4z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 08:56:55 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB8DrUBX019563
        for <linux-btrfs@vger.kernel.org>; Thu, 8 Dec 2016 08:56:54 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2776xfpvfw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 08:56:54 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 8 Dec 2016 06:56:51 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.com
Subject: [PATCH 2/2] btrfs-convert: Fix migrate_super_block() to work with 64k sectorsize
Date: Thu,  8 Dec 2016 19:26:20 +0530
In-Reply-To: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1481205380-22978-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1481205380-22978-2-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

migrate_super_block() uses sectorsize to refer to the size of the
superblock. Hence on 64k sectorsize filesystems, it ends up computing
checksum beyond the super block length (i.e.
BTRFS_SUPER_INFO_SIZE). This commit fixes the bug by using
BTRFS_SUPER_INFO_SIZE instead of sectorsize of the underlying
filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 convert/main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 1148a36..fd6f77b 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1360,7 +1360,7 @@ err:
 /*
  * Migrate super block to its default position and zero 0 ~ 16k
  */
-static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
+static int migrate_super_block(int fd, u64 old_bytenr)
 {
 	int ret;
 	struct extent_buffer *buf;
@@ -1368,13 +1368,13 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 	u32 len;
 	u32 bytenr;
 
-	buf = malloc(sizeof(*buf) + sectorsize);
+	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
 	if (!buf)
 		return -ENOMEM;
 
-	buf->len = sectorsize;
-	ret = pread(fd, buf->data, sectorsize, old_bytenr);
-	if (ret != sectorsize)
+	buf->len = BTRFS_SUPER_INFO_SIZE;
+	ret = pread(fd, buf->data, BTRFS_SUPER_INFO_SIZE, old_bytenr);
+	if (ret != BTRFS_SUPER_INFO_SIZE)
 		goto fail;
 
 	super = (struct btrfs_super_block *)buf->data;
@@ -1382,19 +1382,20 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
 
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
-	ret = pwrite(fd, buf->data, sectorsize, BTRFS_SUPER_INFO_OFFSET);
-	if (ret != sectorsize)
+	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
+		BTRFS_SUPER_INFO_OFFSET);
+	if (ret != BTRFS_SUPER_INFO_SIZE)
 		goto fail;
 
 	ret = fsync(fd);
 	if (ret)
 		goto fail;
 
-	memset(buf->data, 0, sectorsize);
+	memset(buf->data, 0, BTRFS_SUPER_INFO_SIZE);
 	for (bytenr = 0; bytenr < BTRFS_SUPER_INFO_OFFSET; ) {
 		len = BTRFS_SUPER_INFO_OFFSET - bytenr;
-		if (len > sectorsize)
-			len = sectorsize;
+		if (len > BTRFS_SUPER_INFO_SIZE)
+			len = BTRFS_SUPER_INFO_SIZE;
 		ret = pwrite(fd, buf->data, len, bytenr);
 		if (ret != len) {
 			fprintf(stderr, "unable to zero fill device\n");
@@ -2519,7 +2520,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 	 * If this step succeed, we get a mountable btrfs. Otherwise
 	 * the source fs is left unchanged.
 	 */
-	ret = migrate_super_block(fd, mkfs_cfg.super_bytenr, blocksize);
+	ret = migrate_super_block(fd, mkfs_cfg.super_bytenr);
 	if (ret) {
 		error("unable to migrate super block: %d", ret);
 		goto fail;
-- 
2.5.5

