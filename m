Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33691 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeHIUh2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:28 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 07/12] btrfs-progs: support discarding zoned device
Date: Fri, 10 Aug 2018 03:11:00 +0900
Message-Id: <20180809181105.12856-7-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All zones of zoned block devices should be reset before writing. Support
this by considering zone reset as a special case of block discard and block
zeroing. Of note is that only zones accepting random writes can be zeroed.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 utils.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 6 deletions(-)

diff --git a/utils.c b/utils.c
index a2172a82..79a45d92 100644
--- a/utils.c
+++ b/utils.c
@@ -123,6 +123,37 @@ static int discard_range(int fd, u64 start, u64 len)
 	return 0;
 }
 
+/*
+ * Discard blocks in the zones of a zoned block device.
+ * Process this with zone size granularity so that blocks in
+ * conventional zones are discarded using discard_range and
+ * blocks in sequential zones are discarded though a zone reset.
+ */
+static int discard_zones(int fd, struct btrfs_zone_info *zinfo)
+{
+#ifdef BTRFS_ZONED
+	unsigned int i;
+
+	/* Zone size granularity */
+	for (i = 0; i < zinfo->nr_zones; i++) {
+		if (zinfo->zones[i].type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			discard_range(fd, zinfo->zones[i].start << 9,
+				      zinfo->zone_size);
+		} else if (zinfo->zones[i].cond != BLK_ZONE_COND_EMPTY) {
+			struct blk_zone_range range = {
+				zinfo->zones[i].start,
+				zinfo->zone_size >> 9 };
+			if (ioctl(fd, BLKRESETZONE, &range) < 0)
+				return errno;
+		}
+	}
+
+	return 0;
+#else
+	return -EIO;
+#endif
+}
+
 /*
  * Discard blocks in the given range in 1G chunks, the process is interruptible
  */
@@ -205,8 +236,38 @@ static int zero_blocks(int fd, off_t start, size_t len)
 
 #define ZERO_DEV_BYTES SZ_2M
 
+static int zero_zone_blocks(int fd, struct btrfs_zone_info *zinfo,
+			    off_t start, size_t len)
+{
+	size_t zone_len = zinfo->zone_size;
+	off_t ofst = start;
+	size_t count;
+	int ret;
+
+	/* Make sure that zero_blocks does not write sequential zones */
+	while (len > 0) {
+
+		/* Limit zero_blocks to a single zone */
+		count = min_t(size_t, len, zone_len);
+		if (count > zone_len - (ofst & (zone_len - 1)))
+			count = zone_len - (ofst & (zone_len - 1));
+
+		if (zone_is_random_write(zinfo, ofst)) {
+			ret = zero_blocks(fd, ofst, count);
+			if (ret != 0)
+				return ret;
+		}
+
+		len -= count;
+		ofst += count;
+	}
+
+	return 0;
+}
+
 /* don't write outside the device by clamping the region to the device size */
-static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
+static int zero_dev_clamped(int fd, struct btrfs_zone_info *zinfo,
+			    off_t start, ssize_t len, u64 dev_size)
 {
 	off_t end = max(start, start + len);
 
@@ -219,6 +280,9 @@ static int zero_dev_clamped(int fd, off_t start, ssize_t len, u64 dev_size)
 	start = min_t(u64, start, dev_size);
 	end = min_t(u64, end, dev_size);
 
+	if (zinfo->model != ZONED_NONE)
+		return zero_zone_blocks(fd, zinfo, start, end - start);
+
 	return zero_blocks(fd, start, end - start);
 }
 
@@ -566,6 +630,7 @@ int btrfs_get_zone_info(int fd, const char *file, int hmzoned,
 int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 		u64 max_block_count, unsigned opflags)
 {
+	struct btrfs_zone_info zinfo;
 	u64 block_count;
 	struct stat st;
 	int i, ret;
@@ -584,13 +649,30 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
 
+	ret = btrfs_get_zone_info(fd, file, opflags & PREP_DEVICE_HMZONED,
+				  &zinfo);
+	if (ret < 0)
+		return 1;
+
 	if (opflags & PREP_DEVICE_DISCARD) {
 		/*
 		 * We intentionally ignore errors from the discard ioctl.  It
 		 * is not necessary for the mkfs functionality but just an
-		 * optimization.
+		 * optimization. However, we cannot ignore zone discard (reset)
+		 * errors for a zoned block device as this could result in the
+		 * inability to write to non-empty sequential zones of the
+		 * device.
 		 */
-		if (discard_range(fd, 0, 0) == 0) {
+		if (zinfo.model != ZONED_NONE) {
+			printf("Resetting device zones %s (%u zones) ...\n",
+				file, zinfo.nr_zones);
+			if (discard_zones(fd, &zinfo)) {
+				fprintf(stderr,
+					"ERROR: failed to reset device '%s' zones\n",
+					file);
+				return 1;
+			}
+		} else if (discard_range(fd, 0, 0) == 0) {
 			if (opflags & PREP_DEVICE_VERBOSE)
 				printf("Performing full device TRIM %s (%s) ...\n",
 						file, pretty_size(block_count));
@@ -598,12 +680,12 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
 		}
 	}
 
-	ret = zero_dev_clamped(fd, 0, ZERO_DEV_BYTES, block_count);
+	ret = zero_dev_clamped(fd, &zinfo, 0, ZERO_DEV_BYTES, block_count);
 	for (i = 0 ; !ret && i < BTRFS_SUPER_MIRROR_MAX; i++)
-		ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
+		ret = zero_dev_clamped(fd, &zinfo, btrfs_sb_offset(i),
 				       BTRFS_SUPER_INFO_SIZE, block_count);
 	if (!ret && (opflags & PREP_DEVICE_ZERO_END))
-		ret = zero_dev_clamped(fd, block_count - ZERO_DEV_BYTES,
+		ret = zero_dev_clamped(fd, &zinfo, block_count - ZERO_DEV_BYTES,
 				       ZERO_DEV_BYTES, block_count);
 
 	if (ret < 0) {
-- 
2.18.0

