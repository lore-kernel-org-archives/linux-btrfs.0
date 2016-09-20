Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43954 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753240AbcITCTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 22:19:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: hawken@thehawken.org
Subject: [PATCH 2/2] btrfs-progs: super-recover: Reuse btrfs_read_dev_super function
Date: Tue, 20 Sep 2016 10:19:02 +0800
Message-Id: <20160920021902.818-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
References: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have enhanced super block validation check in disk_io.c, while
super-recover doesn't use that function and use a custom one.

That is duplicated, so reuse btrfs_read_dev_super to handle it, which
not only enhanced super check, but also reduce the code length.

Reported-by: hawken <hawken@thehawken.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 super-recover.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/super-recover.c b/super-recover.c
index ecd1215..5298d46 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -88,24 +88,6 @@ void free_recover_superblock(struct btrfs_recover_superblock *recover)
 	}
 }
 
-static int check_super(u64 bytenr, struct btrfs_super_block *sb)
-{
-	int csum_size = btrfs_super_csum_size(sb);
-	u8 result[csum_size];
-	u32 crc = ~(u32)0;
-
-	if (btrfs_super_bytenr(sb) != bytenr)
-		return 0;
-	if (sb->magic != cpu_to_le64(BTRFS_MAGIC))
-		return 0;
-
-	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
-			crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, result);
-
-	return !memcmp(sb, &result, csum_size);
-}
-
 static int add_superblock_record(struct btrfs_super_block *sb, char *fname,
 			u64 bytenr, struct list_head *head)
 {
@@ -133,24 +115,20 @@ read_dev_supers(char *filename, struct btrfs_recover_superblock *recover)
 	int i, ret, fd;
 	u8 buf[BTRFS_SUPER_INFO_SIZE];
 	u64 max_gen, bytenr;
+	struct btrfs_super_block *sb = (struct btrfs_super_block *)buf;
+
 	/* just ignore errno that were set in btrfs_scan_fs_devices() */
 	errno = 0;
 
-	struct btrfs_super_block *sb = (struct btrfs_super_block *)buf;
-
 	fd = open(filename, O_RDONLY);
 	if (fd < 0)
 		return -errno;
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = pread64(fd, buf, sizeof(buf), bytenr);
-		if (ret < sizeof(buf)) {
-			ret = -errno;
-			goto out;
-		}
-		ret = check_super(bytenr, sb);
-		if (ret) {
+
+		ret = btrfs_read_dev_super(fd, sb, bytenr, SBREAD_DEFAULT);
+		if (!ret) {
 			ret = add_superblock_record(sb, filename, bytenr,
 							&recover->good_supers);
 			if (ret)
@@ -158,13 +136,18 @@ read_dev_supers(char *filename, struct btrfs_recover_superblock *recover)
 			max_gen = btrfs_super_generation(sb);
 			if (max_gen > recover->max_generation)
 				recover->max_generation = max_gen;
-		} else {
+		} else if (ret == -EIO){
+			/*
+			 * Skip superblock which doesn't exist, only adds
+			 * really corrupted superblock
+			 */
 			ret = add_superblock_record(sb, filename, bytenr,
 						&recover->bad_supers);
 			if (ret)
 				goto out;
 		}
 	}
+	ret = 0;
 out:
 	close(fd);
 	return ret;
-- 
2.10.0



