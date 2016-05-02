Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42359 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbcEBSS4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 14:18:56 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: vegard.nossum@oracle.com, sterba@suse.com
Subject: [PATCH 2/3] Btrfs-progs: add three more valid checks for superblock
Date: Mon,  2 May 2016 11:18:54 -0700
Message-Id: <1462213135-29678-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
References: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds valid checks for super_total_bytes, super_bytes_used and
super_stripesize.

Since these checks are made after superblock finishes checksum
 checking, this also adds a notice of "superblock checksum match but..".

This also replaces different kinds of printf with helper error() and
warning().

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 disk-io.c | 95 +++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 4302e80..6fcca42 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1397,14 +1397,13 @@ static int check_super(struct btrfs_super_block *sb)
 	int csum_size;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
-		fprintf(stderr, "ERROR: superblock magic doesn't match\n");
+		error("superblock magic doesn't match");
 		return -EIO;
 	}
 
 	csum_type = btrfs_super_csum_type(sb);
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		fprintf(stderr, "ERROR: unsupported checksum algorithm %u\n",
-			csum_type);
+		error("unsupported checksum algorithm %u\n", csum_type);
 		return -EIO;
 	}
 	csum_size = btrfs_csum_sizes[csum_type];
@@ -1415,59 +1414,68 @@ static int check_super(struct btrfs_super_block *sb)
 	btrfs_csum_final(crc, result);
 
 	if (memcmp(result, sb->csum, csum_size)) {
-		fprintf(stderr, "ERROR: superblock checksum mismatch\n");
+		error("superblock checksum mismatch");
 		return -EIO;
 	}
 	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		fprintf(stderr, "ERROR: tree_root level too big: %d >= %d\n",
+		error("tree_root level too big: %d >= %d",
 			btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
-		return -EIO;
+		goto error_out;
 	}
 	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		fprintf(stderr, "ERROR: chunk_root level too big: %d >= %d\n",
+		error("chunk_root level too big: %d >= %d",
 			btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
-		return -EIO;
+		goto error_out;
 	}
 	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
-		fprintf(stderr, "ERROR: log_root level too big: %d >= %d\n",
+		error("log_root level too big: %d >= %d",
 			btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
-		return -EIO;
+		goto error_out;
 	}
 
 	if (!IS_ALIGNED(btrfs_super_root(sb), 4096)) {
-		fprintf(stderr, "ERROR: tree_root block unaligned: %llu\n",
-			btrfs_super_root(sb));
-		return -EIO;
+		error("tree_root block unaligned: %llu", btrfs_super_root(sb));
+		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096)) {
-		fprintf(stderr, "ERROR: chunk_root block unaligned: %llu\n",
+		error("chunk_root block unaligned: %llu",
 			btrfs_super_chunk_root(sb));
-		return -EIO;
+		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096)) {
-		fprintf(stderr, "ERROR: log_root block unaligned: %llu\n",
+		error("log_root block unaligned: %llu",
 			btrfs_super_log_root(sb));
-		return -EIO;
+		goto error_out;
 	}
 	if (btrfs_super_nodesize(sb) < 4096) {
-		fprintf(stderr, "ERROR: nodesize too small: %u < 4096\n",
+		error("nodesize too small: %u < 4096",
 			btrfs_super_nodesize(sb));
-		return -EIO;
+		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_nodesize(sb), 4096)) {
-		fprintf(stderr, "ERROR: nodesize unaligned: %u\n",
-			btrfs_super_nodesize(sb));
-		return -EIO;
+		error("nodesize unaligned: %u", btrfs_super_nodesize(sb));
+		goto error_out;
 	}
 	if (btrfs_super_sectorsize(sb) < 4096) {
-		fprintf(stderr, "ERROR: sectorsize too small: %u < 4096\n",
+		error("sectorsize too small: %u < 4096",
 			btrfs_super_sectorsize(sb));
-		return -EIO;
+		goto error_out;
 	}
 	if (!IS_ALIGNED(btrfs_super_sectorsize(sb), 4096)) {
-		fprintf(stderr, "ERROR: sectorsize unaligned: %u\n",
-			btrfs_super_sectorsize(sb));
-		return -EIO;
+		error("sectorsize unaligned: %u", btrfs_super_sectorsize(sb));
+		goto error_out;
+	}
+	if (btrfs_super_total_bytes(sb) == 0) {
+		error("invalid total_bytes 0");
+		goto error_out;
+	}
+	if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
+		error("invalid bytes_used %llu", btrfs_super_bytes_used(sb));
+		goto error_out;
+	}
+	if (btrfs_super_stripesize(sb) != 4096) {
+		error("invalid stripesize %u", btrfs_super_stripesize(sb));
+		goto error_out;
 	}
 
 	if (memcmp(sb->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
@@ -1476,23 +1484,22 @@ static int check_super(struct btrfs_super_block *sb)
 
 		uuid_unparse(sb->fsid, fsid);
 		uuid_unparse(sb->dev_item.fsid, dev_fsid);
-		printk(KERN_ERR
-			"ERROR: dev_item UUID does not match fsid: %s != %s\n",
+		error("dev_item UUID does not match fsid: %s != %s",
 			dev_fsid, fsid);
-		return -EIO;
+		goto error_out;
 	}
 
 	/*
 	 * Hint to catch really bogus numbers, bitflips or so
 	 */
 	if (btrfs_super_num_devices(sb) > (1UL << 31)) {
-		fprintf(stderr, "WARNING: suspicious number of devices: %llu\n",
+		warning("suspicious number of devices: %llu",
 			btrfs_super_num_devices(sb));
 	}
 
 	if (btrfs_super_num_devices(sb) == 0) {
-		fprintf(stderr, "ERROR: number of devices is 0\n");
-		return -EIO;
+		error("number of devices is 0");
+		goto error_out;
 	}
 
 	/*
@@ -1500,21 +1507,25 @@ static int check_super(struct btrfs_super_block *sb)
 	 * and one chunk
 	 */
 	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
-		fprintf(stderr, "BTRFS: system chunk array too big %u > %u\n",
-			btrfs_super_sys_array_size(sb),
-			BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
-		return -EIO;
+		error("system chunk array too big %u > %u",
+		      btrfs_super_sys_array_size(sb),
+		      BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		goto error_out;
 	}
 	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
 			+ sizeof(struct btrfs_chunk)) {
-		fprintf(stderr, "BTRFS: system chunk array too small %u < %lu\n",
-			btrfs_super_sys_array_size(sb),
-			sizeof(struct btrfs_disk_key) +
-			sizeof(struct btrfs_chunk));
-		return -EIO;
+		error("system chunk array too small %u < %lu",
+		      btrfs_super_sys_array_size(sb),
+		      sizeof(struct btrfs_disk_key) +
+		      sizeof(struct btrfs_chunk));
+		goto error_out;
 	}
 
 	return 0;
+
+error_out:
+	error("Superblock checksum match but it has invalid members, try btrfsck --repair -s <superblock> ie, 0,1,2");
+	return -EIO;
 }
 
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
-- 
2.5.0

