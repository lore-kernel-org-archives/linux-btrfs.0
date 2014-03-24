Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaCXKAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 06:00:35 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2OA0PVd026163
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 18:00:26 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: scrub raid56 stripes in the right way
Date: Mon, 24 Mar 2014 17:58:11 +0800
Message-Id: <1395655091-5318-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395655091-5318-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 fs/btrfs/scrub.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index db21a13..4182b44a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2267,16 +2267,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	u64 extent_logical;
 	u64 extent_physical;
 	u64 extent_len;
+	u64 stripe_nr;
+	u64 tmp;
+	int stripe_index;
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
 	offset = 0;
@@ -2296,6 +2292,14 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
 		increment = map->stripe_len;
 		mirror_num = num % map->num_stripes + 1;
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+		if (num < nr_data_stripes(map))
+			offset = num * map->stripe_len;
+		else
+			offset = (nr_data_stripes(map) - 1) * map->stripe_len;
+		increment = map->stripe_len * nr_data_stripes(map);
+		mirror_num = 1;
 	} else {
 		increment = map->stripe_len;
 		mirror_num = 1;
@@ -2361,6 +2365,18 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	logic_end = logical + increment * nstripes;
 	ret = 0;
 	while (logical < logic_end) {
+		/* skip parity */
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
+				BTRFS_BLOCK_GROUP_RAID6)) {
+			stripe_nr = logical - base;
+			do_div(stripe_nr, map->stripe_len);
+
+			stripe_index = do_div(stripe_nr, nr_data_stripes(map));
+			tmp = stripe_nr + stripe_index;
+			stripe_index = do_div(tmp, map->num_stripes);
+			if (stripe_index != num)
+				goto skip;
+		}
 		/*
 		 * canceled?
 		 */
@@ -2521,6 +2537,7 @@ next:
 			path->slots[0]++;
 		}
 		btrfs_release_path(path);
+skip:
 		logical += increment;
 		physical += map->stripe_len;
 		spin_lock(&sctx->stat_lock);
-- 
1.9.0

