Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10642 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751979AbcLSG5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 01:57:06 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 9990841B4BD9
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Dec 2016 14:56:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/6] btrfs-progs: utils: Introduce basic set operations for range
Date: Mon, 19 Dec 2016 14:56:38 +0800
Message-Id: <20161219065642.25078-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce basic set operations: is_subset() and is_intersection().

This is quite useful to check if a range [start, start + len) subset or
intersection of another range.
So we don't need to use open code to do it, which I sometimes do it
wrong.

Also use these new facilities in btrfs-convert, to check if a range is a
subset or intersects with btrfs convert reserved ranges.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 disk-io.h      |  9 +++++++--
 utils.h        | 19 +++++++++++++++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 15f14af..db6d371 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -61,6 +61,15 @@
 
 #define CONV_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
 
+/*
+ * Btrfs reserved ranges.
+ * In these ranges, btrfs record superblocks, so old fs data in these
+ * range can be relocated to other physical location
+ */
+static u64 reserved_range_starts[3] = { 0, BTRFS_SB_MIRROR_OFFSET(1),
+					BTRFS_SB_MIRROR_OFFSET(2) };
+static u64 reserved_range_lens[3] = { 1024 * 1024, 64 * 1024, 64 * 1024 };
+
 struct task_ctx {
 	uint32_t max_copy_inodes;
 	uint32_t cur_copy_inodes;
@@ -2672,6 +2681,48 @@ fail:
 	return -1;
 }
 
+/*
+ * Check if [start, start + len) is a subset of btrfs reserved ranges
+ */
+static int is_range_subset_of_reserved_ranges(u64 start, u64 len)
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(reserved_range_starts); i++) {
+		if (is_range_subset(start, len, reserved_range_starts[i],
+				    reserved_range_lens[i])) {
+			ret = 1;
+			break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * Check if [start, start + len) intersects with btrfs reserved ranges
+ * if intersects, record the first range it intersects with to @ret_index
+ */
+static int is_range_intersection_of_reserved_ranges(u64 start, u64 len,
+						    int *ret_index)
+{
+	int nr = -1;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(reserved_range_starts); i++) {
+		if (is_range_intersect(start, len, reserved_range_starts[i],
+				       reserved_range_lens[i])) {
+			nr = i;
+			break;
+		}
+	}
+	if (nr == -1)
+		return 0;
+	if (ret_index)
+		*ret_index = nr;
+	return 1;
+}
+
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
diff --git a/disk-io.h b/disk-io.h
index 1c8387e..af6fcfd 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -97,11 +97,16 @@ enum btrfs_read_sb_flags {
 	SBREAD_PARTIAL		= (1 << 1),
 };
 
+/*
+ * Use macro to define mirror super block position
+ * So we can use it in static array initializtion
+ */
+#define BTRFS_SB_MIRROR_OFFSET(mirror)	((u64)(16 * 1024) << \
+					 (BTRFS_SUPER_MIRROR_SHIFT * (mirror)))
 static inline u64 btrfs_sb_offset(int mirror)
 {
-	u64 start = 16 * 1024;
 	if (mirror)
-		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
+		return BTRFS_SB_MIRROR_OFFSET(mirror);
 	return BTRFS_SUPER_INFO_OFFSET;
 }
 
diff --git a/utils.h b/utils.h
index 366ca29..39ca970 100644
--- a/utils.h
+++ b/utils.h
@@ -457,4 +457,23 @@ unsigned int rand_range(unsigned int upper);
 /* Also allow setting the seed manually */
 void init_rand_seed(u64 seed);
 
+/*
+ * Basic set operations
+ * Mainly used for ranges subset/intersect
+ */
+/* Check if [start1, start1 + len1) is subset of [start2, start2 + len2) */
+static inline int is_range_subset(u64 start1, u64 len1, u64 start2, u64 len2)
+{
+	if (start1 >= start2 && start1 + len1 <= start2 + len2)
+		return 1;
+	return 0;
+}
+
+/* Check if [start1, start1 + len1) intersects with [start2, start2 + len2) */
+static inline int is_range_intersect(u64 start1, u64 len1, u64 start2, u64 len2)
+{
+	if (start1 >= start2 + len2 || start1 + len1 <= start2)
+		return 0;
+	return 1;
+}
 #endif
-- 
2.10.2



