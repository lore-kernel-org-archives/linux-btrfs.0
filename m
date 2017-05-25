Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1165154AbdEYGWn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 11/20] btrfs-progs: scrub: Introduce functions to scrub mirror based data blocks
Date: Thu, 25 May 2017 14:21:56 +0800
Message-ID: <20170525062205.11660-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, check/recover_data_mirror(), to check and recover
mirror based data blocks.

Unlike tree block, data blocks must be recovered sector by sector, so we
introduced corrupted_bitmap for check and recover.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 scrub.c | 212 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 212 insertions(+)

diff --git a/scrub.c b/scrub.c
index f5a5c205..e473d168 100644
--- a/scrub.c
+++ b/scrub.c
@@ -25,6 +25,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "utils.h"
+#include "kernel-lib/bitops.h"
 
 /*
  * For parity based profile(RAID56)
@@ -269,3 +270,214 @@ out:
 	free(buf);
 	return ret;
 }
+
+/*
+ * Check one data mirror given by @start @len and @mirror, or @data
+ * If @data is not given, try to read it from disk.
+ * This function will try to read out all the data then check sum.
+ *
+ * If @data is given, just use the data.
+ * This behavior is useful for RAID5/6 recovery code to verify recovered data.
+ *
+ * If @corrupt_bitmap is given, restore corrupted sector to that bitmap.
+ * This is useful for mirror based profiles to recover its data.
+ *
+ * Return 0 if everything is OK.
+ * Return <0 if something goes wrong, and @scrub_ctx accounting will be updated
+ * if it's a data corruption.
+ */
+static int check_data_mirror(struct btrfs_fs_info *fs_info,
+			     struct btrfs_scrub_progress *scrub_ctx,
+			     char *data, u64 start, u64 len, int mirror,
+			     unsigned long *corrupt_bitmap)
+{
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	u32 data_csum;
+	u32 *csums = NULL;
+	char *buf = NULL;
+	int ret = 0;
+	int err = 0;
+	int i;
+	unsigned long *csum_bitmap = NULL;
+
+	if (!data) {
+		buf = malloc(len);
+		if (!buf)
+			return -ENOMEM;
+		ret = read_extent_data_loop(fs_info, scrub_ctx, buf, start,
+					     len, mirror);
+		if (ret < 0)
+			goto out;
+		scrub_ctx->data_bytes_scrubbed += len;
+	} else {
+		buf = data;
+	}
+
+	/* Alloc and Check csums */
+	csums = malloc(len / sectorsize * sizeof(data_csum));
+	if (!csums) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	csum_bitmap = malloc(calculate_bitmap_len(len / sectorsize));
+	if (!csum_bitmap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (corrupt_bitmap)
+		memset(corrupt_bitmap, 0,
+			calculate_bitmap_len(len / sectorsize));
+	ret = btrfs_read_data_csums(fs_info, start, len, csums, csum_bitmap);
+	if (ret < 0)
+		goto out;
+
+	for (i = 0; i < len / sectorsize; i++) {
+		if (!test_bit(i, csum_bitmap)) {
+			scrub_ctx->csum_discards++;
+			continue;
+		}
+
+		data_csum = ~(u32)0;
+		data_csum = btrfs_csum_data(buf + i * sectorsize, data_csum,
+					    sectorsize);
+		btrfs_csum_final(data_csum, (u8 *)&data_csum);
+
+		if (memcmp(&data_csum, (char *)csums + i * sizeof(data_csum),
+				   sizeof(data_csum))) {
+			error("data at bytenr %llu mirror %d csum mismatch, have 0x%08x expect 0x%08x",
+			      start + i * sectorsize, mirror, data_csum,
+			      *(u32 *)((char *)csums + i * sizeof(data_csum)));
+			err = 1;
+			scrub_ctx->csum_errors++;
+			if (corrupt_bitmap)
+				set_bit(i, corrupt_bitmap);
+			continue;
+		}
+		scrub_ctx->data_bytes_scrubbed += sectorsize;
+	}
+out:
+	if (!data)
+		free(buf);
+	free(csums);
+	free(csum_bitmap);
+
+	if (!ret && err)
+		return -EIO;
+	return ret;
+}
+
+/* Helper to check all mirrors for a good copy */
+static int has_good_mirror(unsigned long *corrupt_bitmaps[], int num_copies,
+			   int bit, int *good_mirror)
+{
+	int found_good = 0;
+	int i;
+
+	for (i = 0; i < num_copies; i++) {
+		if (!test_bit(bit, corrupt_bitmaps[i])) {
+			found_good = 1;
+			if (good_mirror)
+				*good_mirror = i + 1;
+			break;
+		}
+	}
+	return found_good;
+}
+
+/*
+ * Helper function to check @corrupt_bitmaps, to verify if it's recoverable
+ * for mirror based data extent.
+ *
+ * Return 1 for recoverable, and 0 for not recoverable
+ */
+static int check_data_mirror_recoverable(struct btrfs_fs_info *fs_info,
+					 u64 start, u64 len, u32 sectorsize,
+					 unsigned long *corrupt_bitmaps[])
+{
+	int i;
+	int corrupted = 0;
+	int bit;
+	int num_copies = btrfs_num_copies(&fs_info->mapping_tree, start, len);
+
+	for (i = 0; i < num_copies; i++) {
+		for_each_set_bit(bit, corrupt_bitmaps[i], len / sectorsize) {
+			if (!has_good_mirror(corrupt_bitmaps, num_copies,
+					     bit, NULL)) {
+				corrupted = 1;
+				goto out;
+			}
+		}
+	}
+out:
+	return !corrupted;
+}
+
+/*
+ * Try to recover all corrupted sectors specified by @corrupt_bitmaps,
+ * by reading out good sector in other mirror.
+ */
+static int recover_data_mirror(struct btrfs_fs_info *fs_info,
+			       struct btrfs_scrub_progress *scrub_ctx,
+			       u64 start, u64 len,
+			       unsigned long *corrupt_bitmaps[])
+{
+	char *buf;
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	int ret = 0;
+	int bit;
+	int i;
+	int bad_mirror;
+	int num_copies;
+
+	/* Don't bother to recover unrecoverable extents */
+	if (!check_data_mirror_recoverable(fs_info, start, len,
+					   sectorsize, corrupt_bitmaps))
+		return -EIO;
+
+	buf = malloc(sectorsize);
+	if (!buf)
+		return -ENOMEM;
+
+	num_copies = btrfs_num_copies(&fs_info->mapping_tree, start, len);
+	for (i = 0; i < num_copies; i++) {
+		for_each_set_bit(bit, corrupt_bitmaps[i], BITS_PER_LONG) {
+			u64 cur = start + bit * sectorsize;
+			int good;
+
+			/* Find good mirror */
+			ret = has_good_mirror(corrupt_bitmaps, num_copies, bit,
+					      &good);
+			if (!ret) {
+				error("failed to find good mirror for bytenr %llu",
+					cur);
+				ret = -EIO;
+				goto out;
+			}
+			/* Read out good mirror */
+			ret = read_data_from_disk(fs_info, buf, cur,
+						  sectorsize, good);
+			if (ret < 0) {
+				error("failed to read good mirror from bytenr %llu mirror %d",
+					cur, good);
+				goto out;
+			}
+			/* Write back to all other mirrors */
+			for (bad_mirror = 1; bad_mirror <= num_copies;
+			     bad_mirror++) {
+				if (bad_mirror == good)
+					continue;
+				ret = write_data_to_disk(fs_info, buf, cur,
+						sectorsize, bad_mirror);
+				if (ret < 0) {
+					error("failed to recover mirror for bytenr %llu mirror %d",
+						cur, bad_mirror);
+					goto out;
+				}
+			}
+		}
+	}
+out:
+	free(buf);
+	return ret;
+}
-- 
2.13.0



