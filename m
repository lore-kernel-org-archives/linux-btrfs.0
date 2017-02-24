Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53312 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750873AbdBXFyb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 00:54:31 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH v2 5/9] btrfs-progs: convert: Use reserved ranges array to cleanup open code
Date: Fri, 24 Feb 2017 13:52:28 +0800
Message-ID: <20170224055232.4140-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have reserved ranges array now, we can use them to skip all
these open codes.

And add some comment and asciidoc art for related part.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 139 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 64 insertions(+), 75 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index ba088cc3..08df0111 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -529,47 +529,40 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	len = min_t(u64, len, BTRFS_MAX_EXTENT_SIZE);
 
 	/*
-	 * Skip sb ranges first
-	 * [0, 1M), [sb_offset(1), +64K), [sb_offset(2), +64K].
+	 * Skip reserved ranges first
 	 *
 	 * Or we will insert a hole into current image file, and later
 	 * migrate block will fail as there is already a file extent.
 	 */
-	if (bytenr < 1024 * 1024) {
-		*ret_len = 1024 * 1024 - bytenr;
-		return 0;
-	}
-	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		u64 cur = btrfs_sb_offset(i);
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		struct simple_range *reserved = &btrfs_reserved_ranges[i];
 
-		if (bytenr >= cur && bytenr < cur + BTRFS_STRIPE_LEN) {
-			*ret_len = cur + BTRFS_STRIPE_LEN - bytenr;
+		/*
+		 * |-- reserved --|
+		 *         |--range---|
+		 * or
+		 * |---- reserved ----|
+		 *    |-- range --|
+		 * Skip to reserved range end
+		 */
+		if (bytenr >= reserved->start && bytenr < range_end(reserved)) {
+			*ret_len = range_end(reserved) - bytenr;
 			return 0;
 		}
-	}
-	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		u64 cur = btrfs_sb_offset(i);
 
 		/*
-		 *      |--reserved--|
+		 *      |---reserved---|
 		 * |----range-------|
-		 * May still need to go through file extent inserts
+		 * Leading part may still create a file extent
 		 */
-		if (bytenr < cur && bytenr + len >= cur) {
-			len = min_t(u64, len, cur - bytenr);
+		if (bytenr < reserved->start &&
+		    bytenr + len >= range_end(reserved)) {
+			len = min_t(u64, len, reserved->start - bytenr);
 			break;
 		}
-		/*
-		 * |--reserved--|
-		 *      |---range---|
-		 * Drop out, no need to insert anything
-		 */
-		if (bytenr >= cur && bytenr < cur + BTRFS_STRIPE_LEN) {
-			*ret_len = cur + BTRFS_STRIPE_LEN - bytenr;
-			return 0;
-		}
 	}
 
+	/* Check if we are going to insert regular file extent, or hole */
 	cache = search_cache_extent(used, bytenr);
 	if (cache) {
 		if (cache->start <= bytenr) {
@@ -577,6 +570,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 			 * |///////Used///////|
 			 *	|<--insert--->|
 			 *	bytenr
+			 * Insert one real file extent
 			 */
 			len = min_t(u64, len, cache->start + cache->size -
 				    bytenr);
@@ -586,6 +580,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 			 *		|//Used//|
 			 *  |<-insert-->|
 			 *  bytenr
+			 *  Insert one hole
 			 */
 			len = min(len, cache->start - bytenr);
 			disk_bytenr = 0;
@@ -596,6 +591,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 		 * |//Used//|		|EOF
 		 *	    |<-insert-->|
 		 *	    bytenr
+		 * Insert one hole
 		 */
 		disk_bytenr = 0;
 		datacsum = 0;
@@ -641,23 +637,31 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct cache_tree *used,
 				      struct btrfs_inode_item *inode, int fd,
-				      u64 ino, u64 start, u64 len, int datacsum)
+				      u64 ino, struct simple_range *range,
+				      int datacsum)
 {
-	u64 cur_off = start;
-	u64 cur_len = len;
-	u64 hole_start = start;
+	u64 cur_off = range->start;
+	u64 cur_len = range->len;
+	u64 hole_start = range->start;
 	u64 hole_len;
 	struct cache_extent *cache;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
 	int ret = 0;
 
-	while (cur_off < start + len) {
+	/*
+	 * It's possible that there are holes in reserved range:
+	 * |<---------------- Reserved range ---------------------->|
+	 *      |<- Old fs data ->|   |<- Old fs data ->|
+	 * So here we need to iterate through old fs used space and only
+	 * migrate ranges that covered by old fs data.
+	 */
+	while (cur_off < range_end(range)) {
 		cache = lookup_cache_extent(used, cur_off, cur_len);
 		if (!cache)
 			break;
 		cur_off = max(cache->start, cur_off);
-		cur_len = min(cache->start + cache->size, start + len) -
+		cur_len = min(cache->start + cache->size, range_end(range)) -
 			  cur_off;
 		BUG_ON(cur_len < root->sectorsize);
 
@@ -709,20 +713,22 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 
 		cur_off += key.offset;
 		hole_start = cur_off;
-		cur_len = start + len - cur_off;
+		cur_len = range_end(range) - cur_off;
 	}
-	/* Last hole */
-	if (start + len - hole_start > 0)
+	/*
+	 * Last hole
+	 * |<---- reserved -------->|
+	 * |<- Old fs data ->|      |
+	 *                   | Hole |
+	 */
+	if (range_end(range) - hole_start > 0)
 		ret = btrfs_record_file_extent(trans, root, ino, inode,
-				hole_start, 0, start + len - hole_start);
+				hole_start, 0, range_end(range) - hole_start);
 	return ret;
 }
 
 /*
  * Relocate the used ext2 data in reserved ranges
- * [0,1M)
- * [btrfs_sb_offset(1), +BTRFS_STRIPE_LEN)
- * [btrfs_sb_offset(2), +BTRFS_STRIPE_LEN)
  */
 static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
@@ -730,35 +736,19 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode_item *inode, int fd,
 				   u64 ino, u64 total_bytes, int datacsum)
 {
-	u64 cur_off;
-	u64 cur_len;
+	int i;
 	int ret = 0;
 
-	/* 0 ~ 1M */
-	cur_off = 0;
-	cur_len = 1024 * 1024;
-	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
-					 cur_off, cur_len, datacsum);
-	if (ret < 0)
-		return ret;
-
-	/* second sb(fisrt sb is included in 0~1M) */
-	cur_off = btrfs_sb_offset(1);
-	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
-	if (cur_off > total_bytes)
-		return ret;
-	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
-					 cur_off, cur_len, datacsum);
-	if (ret < 0)
-		return ret;
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		struct simple_range *range = &btrfs_reserved_ranges[i];
 
-	/* Last sb */
-	cur_off = btrfs_sb_offset(2);
-	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
-	if (cur_off > total_bytes)
-		return ret;
-	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
-					 cur_off, cur_len, datacsum);
+		if (range->start > total_bytes)
+			return ret;
+		ret = migrate_one_reserved_range(trans, root, used, inode, fd,
+						 ino, range, datacsum);
+		if (ret < 0)
+			return ret;
+	}
 	return ret;
 }
 
@@ -931,18 +921,17 @@ static int wipe_one_reserved_range(struct cache_tree *tree,
 static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
 				int ensure_size)
 {
+	int i;
 	int ret;
 
-	ret = wipe_one_reserved_range(tree, 0, 1024 * 1024, min_stripe_size,
-				      ensure_size);
-	if (ret < 0)
-		return ret;
-	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(1),
-			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
-	if (ret < 0)
-		return ret;
-	ret = wipe_one_reserved_range(tree, btrfs_sb_offset(2),
-			BTRFS_STRIPE_LEN, min_stripe_size, ensure_size);
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		struct simple_range *range = &btrfs_reserved_ranges[i];
+
+		ret = wipe_one_reserved_range(tree, range->start, range->len,
+					      min_stripe_size, ensure_size);
+		if (ret < 0)
+			return ret;
+	}
 	return ret;
 }
 
-- 
2.11.1



