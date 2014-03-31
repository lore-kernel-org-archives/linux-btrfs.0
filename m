Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57038 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaCaKg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 06:36:28 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2VAaPIE031727
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 18:36:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] Btrfs: scrub raid56 stripes in the right way
Date: Mon, 31 Mar 2014 18:34:03 +0800
Message-Id: <1396262043-10304-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda[8-11] -m raid5 -d raid5
 # mount /dev/sda8 /mnt
 # btrfs scrub start -BR /mnt
 # echo $? <--unverified errors make return value be 3

This is because we don't setup right mapping between physical
and logical address for raid56, which makes checksum mismatch.
But we will find everthing is fine later when rechecking using
btrfs_map_block().

This patch fixed the problem by settuping right mappings and
we only verify data stripes' checksums.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	on the right way to fix the problem.
---
 fs/btrfs/scrub.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index db21a13..ebe4c5e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2235,6 +2235,43 @@ behind_scrub_pages:
 	return 0;
 }
 
+/*
+ * Given a physical address, this will calculate it's
+ * logical offset. if this is a parity stripe, it will return
+ * the most left data stripe's logical offset.
+ *
+ * return 0 if it is a data stripe, 1 means parity stripe.
+ */
+static int get_raid56_logic_offset(u64 physical, int num,
+				 struct map_lookup *map, u64 *offset)
+{
+	int i;
+	int j = 0;
+	u64 stripe_nr;
+	u64 tmp;
+	u64 last_offset;
+	int stripe_index;
+
+	last_offset = (physical - map->stripes[num].physical) *
+		      nr_data_stripes(map);
+	*offset = last_offset;
+	for (i = 0; i < nr_data_stripes(map); i++) {
+		*offset += i * map->stripe_len;
+		stripe_nr = *offset;
+		do_div(stripe_nr, map->stripe_len);
+
+		stripe_index = do_div(stripe_nr, nr_data_stripes(map));
+		tmp = stripe_nr + stripe_index;
+		stripe_index = do_div(tmp, map->num_stripes);
+		if (stripe_index == num)
+			return 0;
+		if (stripe_index < num)
+			j++;
+	}
+	*offset = last_offset + j * map->stripe_len;
+	return 1;
+}
+
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
@@ -2269,16 +2306,10 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	u64 extent_len;
 	struct btrfs_device *extent_dev;
 	int extent_mirror_num;
-	int stop_loop;
-
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			 BTRFS_BLOCK_GROUP_RAID6)) {
-		if (num >= nr_data_stripes(map)) {
-			return 0;
-		}
-	}
+	int stop_loop = 0;
 
 	nstripes = length;
+	physical = map->stripes[num].physical;
 	offset = 0;
 	do_div(nstripes, map->stripe_len);
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
@@ -2296,6 +2327,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
 		increment = map->stripe_len;
 		mirror_num = num % map->num_stripes + 1;
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+		get_raid56_logic_offset(physical, num, map, &offset);
+		increment = map->stripe_len * nr_data_stripes(map);
+		mirror_num = 1;
 	} else {
 		increment = map->stripe_len;
 		mirror_num = 1;
@@ -2357,10 +2393,18 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	 * now find all extents for each stripe and scrub them
 	 */
 	logical = base + offset;
-	physical = map->stripes[num].physical;
 	logic_end = logical + increment * nstripes;
 	ret = 0;
 	while (logical < logic_end) {
+		/* for raid56, we skip parity stripe */
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+			ret = get_raid56_logic_offset(physical, num,
+					map, &logical);
+			logical += base;
+			if (ret)
+				goto skip;
+		}
 		/*
 		 * canceled?
 		 */
@@ -2504,9 +2548,23 @@ again:
 			scrub_free_csums(sctx);
 			if (extent_logical + extent_len <
 			    key.objectid + bytes) {
-				logical += increment;
-				physical += map->stripe_len;
-
+				if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+					BTRFS_BLOCK_GROUP_RAID6)) {
+					/*
+					 * loop until we find next data stripe
+					 * or we have finished all stripes.
+					 */
+					do {
+						physical += map->stripe_len;
+						ret = get_raid56_logic_offset(
+								physical, num,
+								map, &logical);
+						logical += base;
+					} while (logical < logic_end && ret);
+				} else {
+					physical += map->stripe_len;
+					logical += increment;
+				}
 				if (logical < key.objectid + bytes) {
 					cond_resched();
 					goto again;
@@ -2521,6 +2579,7 @@ next:
 			path->slots[0]++;
 		}
 		btrfs_release_path(path);
+skip:
 		logical += increment;
 		physical += map->stripe_len;
 		spin_lock(&sctx->stat_lock);
-- 
1.9.0

