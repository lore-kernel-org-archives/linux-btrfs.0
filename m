Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13989 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751258AbdCPDSr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 23:18:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: convert: Make btrfs_reserved_ranges const
Date: Thu, 16 Mar 2017 11:18:31 +0800
Message-ID: <20170316031831.28006-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
References: <20170316031831.28006-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_reserved_ranges array is just used to store btrfs reserved
ranges, no one will nor should modify them at run time, make them static
and const will be better.

This also eliminates the use of immediate number 3.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c      | 16 ++++++++--------
 convert/source-fs.c |  6 ------
 convert/source-fs.h |  8 ++++++--
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index 73c9d889..96358c62 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -218,7 +218,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	 * migrate block will fail as there is already a file extent.
 	 */
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *reserved = &btrfs_reserved_ranges[i];
+		const struct simple_range *reserved = &btrfs_reserved_ranges[i];
 
 		/*
 		 * |-- reserved --|
@@ -320,7 +320,7 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct cache_tree *used,
 				      struct btrfs_inode_item *inode, int fd,
-				      u64 ino, struct simple_range *range,
+				      u64 ino, const struct simple_range *range,
 				      u32 convert_flags)
 {
 	u64 cur_off = range->start;
@@ -423,7 +423,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range->start > total_bytes)
 			return ret;
@@ -609,7 +609,7 @@ static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		ret = wipe_one_reserved_range(tree, range->start, range->len,
 					      min_stripe_size, ensure_size);
@@ -1370,7 +1370,7 @@ static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
 	int ret = 0;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range->start + range->len >= total_bytes)
 			break;
@@ -1395,7 +1395,7 @@ static bool is_subset_of_reserved_ranges(u64 start, u64 len)
 	bool ret = false;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (start >= range->start && start + len <= range_end(range)) {
 			ret = true;
@@ -1620,7 +1620,7 @@ static int do_rollback(const char *devname)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		reserved_ranges[i] = calloc(1, range->len);
 		if (!reserved_ranges[i]) {
@@ -1730,7 +1730,7 @@ close_fs:
 
 	for (i = ARRAY_SIZE(btrfs_reserved_ranges) - 1; i >= 0; i--) {
 		u64 real_size;
-		struct simple_range *range = &btrfs_reserved_ranges[i];
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
 
 		if (range_end(range) >= fsize)
 			continue;
diff --git a/convert/source-fs.c b/convert/source-fs.c
index 7cf515b0..8217c893 100644
--- a/convert/source-fs.c
+++ b/convert/source-fs.c
@@ -22,12 +22,6 @@
 #include "convert/common.h"
 #include "convert/source-fs.h"
 
-struct simple_range btrfs_reserved_ranges[3] = {
-	{ 0,			     SZ_1M },
-	{ BTRFS_SB_MIRROR_OFFSET(1), SZ_64K },
-	{ BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
-};
-
 static int intersect_with_sb(u64 bytenr, u64 num_bytes)
 {
 	int i;
diff --git a/convert/source-fs.h b/convert/source-fs.h
index 9f611150..7aabe96b 100644
--- a/convert/source-fs.h
+++ b/convert/source-fs.h
@@ -32,7 +32,11 @@ struct simple_range {
 	u64 len;
 };
 
-extern struct simple_range btrfs_reserved_ranges[3];
+static const struct simple_range btrfs_reserved_ranges[] = {
+	{ 0,			     SZ_1M },
+	{ BTRFS_SB_MIRROR_OFFSET(1), SZ_64K },
+	{ BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
+};
 
 struct task_info;
 
@@ -107,7 +111,7 @@ int record_file_blocks(struct blk_iterate_data *data,
  *
  * Get range end (exclusive)
  */
-static inline u64 range_end(struct simple_range *range)
+static inline u64 range_end(const struct simple_range *range)
 {
 	return (range->start + range->len);
 }
-- 
2.12.0



