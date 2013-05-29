Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:47027 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965709Ab3E2MhU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 08:37:20 -0400
Received: by mail-we0-f172.google.com with SMTP id w62so6418794wes.17
        for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 05:37:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: Validate super block checksum
Date: Wed, 29 May 2013 13:36:51 +0100
Message-Id: <1369831011-11768-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After finding a super block in a device also validate its
checksum. This validation is done in the kernel but it was
missing in btrfs-progs.

The function btrfs_check_super_csum() is imported from the
file fs/btrfs/disk-io.c in the kernel source tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 disk-io.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 14 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 21b410d..bde58f2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1085,47 +1085,95 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	return info->fs_root;
 }
 
+static int btrfs_check_super_csum(char *raw_disk_sb)
+{
+	struct btrfs_super_block *disk_sb =
+		(struct btrfs_super_block *)raw_disk_sb;
+	u16 csum_type = btrfs_super_csum_type(disk_sb);
+	int ret = 0;
+
+	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
+		u32 crc = ~(u32)0;
+		const int csum_size = sizeof(crc);
+		char result[csum_size];
+
+		/*
+		 * The super_block structure does not span the whole
+		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
+		 * is filled with zeros and is included in the checkum.
+		 */
+		crc = btrfs_csum_data(NULL, raw_disk_sb + BTRFS_CSUM_SIZE,
+				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, result);
+
+		if (memcmp(raw_disk_sb, result, csum_size))
+			ret = 1;
+
+		if (ret && btrfs_super_generation(disk_sb) < 10) {
+			fprintf(stderr, "btrfs: super block crcs don't match, "
+				"older mkfs detected\n");
+			ret = 0;
+		}
+	}
+
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		fprintf(stderr, "btrfs: unsupported checksum algorithm %u\n",
+			csum_type);
+		ret = 1;
+	}
+
+	return ret;
+}
+
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
-	struct btrfs_super_block buf;
+	char buf[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *tmp_sb;
 	int i;
 	int ret;
 	u64 transid = 0;
 	u64 bytenr;
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
-		ret = pread64(fd, &buf, sizeof(buf), sb_bytenr);
+		ret = pread64(fd, buf, sizeof(buf), sb_bytenr);
 		if (ret < sizeof(buf))
 			return -1;
 
-		if (btrfs_super_bytenr(&buf) != sb_bytenr ||
-		    buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		tmp_sb = (struct btrfs_super_block *)buf;
+
+		if (btrfs_super_bytenr(tmp_sb) != sb_bytenr ||
+		    tmp_sb->magic != cpu_to_le64(BTRFS_MAGIC) ||
+		    btrfs_check_super_csum(buf))
 			return -1;
 
-		memcpy(sb, &buf, sizeof(*sb));
+		memcpy(sb, buf, sizeof(*sb));
 		return 0;
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		ret = pread64(fd, &buf, sizeof(buf), bytenr);
+		ret = pread64(fd, buf, sizeof(buf), bytenr);
 		if (ret < sizeof(buf))
 			break;
 
-		if (btrfs_super_bytenr(&buf) != bytenr )
+		tmp_sb = (struct btrfs_super_block *)buf;
+
+		if (btrfs_super_bytenr(tmp_sb) != bytenr )
 			continue;
 		/* if magic is NULL, the device was removed */
-		if (buf.magic == 0 && i == 0) 
+		if (tmp_sb->magic == 0 && i == 0)
 			return -1;
-		if (buf.magic != cpu_to_le64(BTRFS_MAGIC))
+		if (tmp_sb->magic != cpu_to_le64(BTRFS_MAGIC))
+			continue;
+		if (btrfs_check_super_csum(buf))
 			continue;
 
 		if (!fsid_is_initialized) {
-			memcpy(fsid, buf.fsid, sizeof(fsid));
+			memcpy(fsid, tmp_sb->fsid, sizeof(fsid));
 			fsid_is_initialized = 1;
-		} else if (memcmp(fsid, buf.fsid, sizeof(fsid))) {
+		} else if (memcmp(fsid, tmp_sb->fsid, sizeof(fsid))) {
 			/*
 			 * the superblocks (the original one and
 			 * its backups) contain data of different
@@ -1134,9 +1182,9 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
 			continue;
 		}
 
-		if (btrfs_super_generation(&buf) > transid) {
-			memcpy(sb, &buf, sizeof(*sb));
-			transid = btrfs_super_generation(&buf);
+		if (btrfs_super_generation(tmp_sb) > transid) {
+			memcpy(sb, buf, sizeof(*sb));
+			transid = btrfs_super_generation(tmp_sb);
 		}
 	}
 
-- 
1.7.9.5

