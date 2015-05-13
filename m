Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932707AbbEMJSZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 05:18:25 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH 3/4] btrfs-progs: Introduce better superblock check.
Date: Wed, 13 May 2015 17:15:35 +0800
Message-ID: <1431508536-7275-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs-progs will have much more restrict superblock check based on
kernel superblock check.

This should at least provide some hostile crafted image to crash command
like btrfsck.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index e6ac3e9..bf796c6 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -38,6 +38,7 @@
 #define BTRFS_BAD_BYTENR		(-1)
 #define BTRFS_BAD_FSID			(-2)
 
+#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
 
@@ -1259,6 +1260,144 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 	return info->fs_root;
 }
 
+/* Just to save some space */
+#define pr_err(fmt, args...)	(fprintf(stderr, fmt, ##args))
+
+/*
+ * Check if the super is validate.
+ *
+ * Unlike kernel one, we don't have extra check, so it's quite restrict
+ * in btrfs-progs.
+ */
+static int check_super(struct btrfs_super_block *sb)
+{
+	char result[BTRFS_CSUM_SIZE];
+	u32 crc;
+	u16 csum_type;
+	int csum_size;
+
+	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
+		pr_err("ERROR: superblock magic doesn't match\n");
+		return -EIO;
+	}
+
+	csum_type = btrfs_super_csum_type(sb);
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		pr_err("ERROR: unsupported checksum algorithm %u\n",
+			csum_type);
+		return -EIO;
+	}
+	csum_size = btrfs_csum_sizes[csum_type];
+
+	crc = ~(u32)0;
+	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
+			      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, result);
+
+	if (memcmp(result, sb->csum, csum_size)) {
+		pr_err("ERROR: superblock checksum mismatch\n");
+		return -EIO;
+	}
+	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		pr_err("ERROR: tree_root level too big: %d>=%d\n",
+			btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
+		return -EIO;
+	}
+	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		pr_err("ERROR: chunk_root level too big: %d>=%d\n",
+			btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
+		return -EIO;
+	}
+	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		pr_err("ERROR: log_root level too big: %d>=%d\n",
+			btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
+		return -EIO;
+	}
+
+	if (!IS_ALIGNED(btrfs_super_root(sb), 4096)) {
+		pr_err("ERROR: tree_root block unaligned: %llu\n",
+			btrfs_super_root(sb));
+		return -EIO;
+	}
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096)) {
+		pr_err("ERROR: chunk_root block unaligned: %llu\n",
+			btrfs_super_chunk_root(sb));
+		return -EIO;
+	}
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096)) {
+		pr_err("ERROR: log_root block unaligned: %llu\n",
+			btrfs_super_log_root(sb));
+		return -EIO;
+	}
+	if (btrfs_super_nodesize(sb) < 4096) {
+		pr_err("ERROR: nodesize too small: %u < 4096\n",
+			btrfs_super_nodesize(sb));
+		return -EIO;
+	}
+	if (!IS_ALIGNED(btrfs_super_nodesize(sb), 4096)) {
+		pr_err("ERROR: nodesize unaligned: %u\n",
+			btrfs_super_nodesize(sb));
+		return -EIO;
+	}
+	if (btrfs_super_sectorsize(sb) < 4096) {
+		pr_err("ERROR: sectorsize too small: %u < 4096\n",
+			btrfs_super_sectorsize(sb));
+		return -EIO;
+	}
+	if (!IS_ALIGNED(btrfs_super_sectorsize(sb), 4096)) {
+		pr_err("ERROR: sectorsize unaligned: %u\n",
+			btrfs_super_sectorsize(sb));
+		return -EIO;
+	}
+
+	if (memcmp(sb->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
+		char fsid[BTRFS_UUID_UNPARSED_SIZE];
+		char dev_fsid[BTRFS_UUID_UNPARSED_SIZE];
+
+		uuid_unparse(sb->fsid, fsid);
+		uuid_unparse(sb->dev_item.fsid, dev_fsid);
+		printk(KERN_ERR
+			"ERROR: dev_item UUID does not match fsid: %s != %s\n",
+			dev_fsid, fsid);
+		return -EIO;
+	}
+
+	/*
+	 * Hint to catch really bogus numbers, bitflips or so
+	 */
+	if (btrfs_super_num_devices(sb) > (1UL << 31)) {
+		pr_err("ERROR: suspicious number of devices: %llu\n",
+			btrfs_super_num_devices(sb));
+		return -EIO;
+	}
+
+	if (btrfs_super_num_devices(sb) == 0) {
+		pr_err("ERROR: number of devices is 0\n");
+		return -EIO;
+	}
+
+	/*
+	 * Obvious sys_chunk_array corruptions, it must hold at least one key
+	 * and one chunk
+	 */
+	if (btrfs_super_sys_array_size(sb) > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
+		pr_err("BTRFS: system chunk array too big %u > %u\n",
+			btrfs_super_sys_array_size(sb),
+			BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
+		return -EIO;
+	}
+	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
+			+ sizeof(struct btrfs_chunk)) {
+		pr_err("BTRFS: system chunk array too small %u < %lu\n",
+			btrfs_super_sys_array_size(sb),
+			sizeof(struct btrfs_disk_key) +
+			sizeof(struct btrfs_chunk));
+		return -EIO;
+	}
+
+	return 0;
+}
+
 int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			 int super_recover)
 {
@@ -1277,10 +1416,11 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		if (ret < BTRFS_SUPER_INFO_SIZE)
 			return -1;
 
-		if (btrfs_super_bytenr(buf) != sb_bytenr ||
-		    btrfs_super_magic(buf) != BTRFS_MAGIC)
+		if (btrfs_super_bytenr(buf) != sb_bytenr)
 			return -1;
 
+		if (check_super(buf))
+			return -1;
 		memcpy(sb, &buf, BTRFS_SUPER_INFO_SIZE);
 		return 0;
 	}
@@ -1302,8 +1442,8 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			continue;
 		/* if magic is NULL, the device was removed */
 		if (btrfs_super_magic(buf) == 0 && i == 0)
-			return -1;
-		if (btrfs_super_magic(buf) != BTRFS_MAGIC)
+			break;
+		if (check_super(buf))
 			continue;
 
 		if (!fsid_is_initialized) {
-- 
2.4.0

