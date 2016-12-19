Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42029 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751979AbcLSG47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:56:59 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id CA5B841B4BDA
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/6] btrfs-progs: convert: Introduce function to record relocated ranges
Date: Mon, 19 Dec 2016 14:56:39 +0800
Message-Id: <20161219065642.25078-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, record_reloc_data(), to read out any data that
is a subset of reserved btrfs ranges.

This function is mainly a compatible function for old convert behavior.
As old convert behavior only reloc super blocks (4K size), while the new
convert behavior will reloc 64K block.

So this function will truncate and map the file extents of the converted
image, and read out corresponding data for later rollback usage.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index db6d371..87c52c1 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -2723,6 +2723,64 @@ static int is_range_intersection_of_reserved_ranges(u64 start, u64 len,
 	return 1;
 }
 
+/*
+ * Read out data in reserved_ranges and write them into @reloc_ranges
+ *
+ * This is mainly for old convert behavior.
+ * Which only relocs the super block (4K), while we now reloc 64K.
+ *
+ * So there is some range in reserved range but still mapped 1:1.
+ * We use this function to read them into @reloc_ranges
+ */
+static int record_reloc_data(struct btrfs_fs_info *fs_info,
+			     u64 old_offset, u64 disk_bytenr, u64 ram_len,
+			     char *reloc_ranges[3])
+{
+	/* Which reloc range we interests with, physical bytenr */
+	u64 reloc_start;
+	u64 reloc_len;
+
+	/*
+	 * File offset, which get truncated to above range,
+	 * Offset in image file
+	 */
+	u64 file_start;
+	u64 file_len;
+
+	/* Btrfs logical address, used for final reading*/
+	u64 logical_start;
+	u64 logical_len;
+	char *dest;
+	int nr;
+	int ret;
+
+	/* Check if the range intersects */
+	if (!is_range_intersection_of_reserved_ranges(old_offset, ram_len,
+						      &nr))
+		return 0;
+	reloc_start = reserved_range_starts[nr];
+	reloc_len = reserved_range_lens[nr];
+
+	/* Truncate the range to reserved ranges */
+	file_start = max(old_offset, reloc_start);
+	file_len = min(old_offset + ram_len, reloc_start + reloc_len) -
+			file_start;
+
+	/* Get btrfs logical address */
+	logical_start = file_start - old_offset + disk_bytenr;
+	logical_len = file_len;
+
+	dest = reloc_ranges[nr] + file_start - reloc_start;
+	ret = read_extent_data(fs_info->tree_root, dest, logical_start,
+				&logical_len, 0);
+	if (ret < 0)
+		return ret;
+	/* Short read, something went wrong */
+	if (logical_len != file_len)
+		return -EIO;
+	return 0;
+}
+
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
-- 
2.10.2



