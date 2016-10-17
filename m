Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55698 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932287AbcJQB2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:19 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 53BE940142D3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:47 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 02/14] btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
Date: Mon, 17 Oct 2016 09:27:31 +0800
Message-Id: <20161017012743.9692-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For READ, caller normally hopes to get what they request, other than
full stripe map.

In this case, we should remove unrelated stripe map, just like the
following case:
               32K               96K
               |<-request range->|
         0              64k           128K
RAID0:   |    Data 1    |   Data 2    |
              disk1         disk2
Before this patch, we return the full stripe:
Stripe 0: Logical 0, Physical X, Len 64K, Dev disk1
Stripe 1: Logical 64k, Physical Y, Len 64K, Dev disk2

After this patch, we limit the stripe result to the request range:
Stripe 0: Logical 32K, Physical X+32K, Len 32K, Dev disk1
Stripe 1: Logical 64k, Physical Y, Len 32K, Dev disk2

And if it's a RAID5/6 stripe, we just handle it like RAID0, ignoring
parities.

This should make caller easier to use.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 94f3e42..ba16d19 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1682,6 +1682,107 @@ static int fill_full_map_block(struct map_lookup *map, u64 start, u64 length,
 	return 0;
 }
 
+static void del_one_stripe(struct btrfs_map_block *map_block, int i)
+{
+	int cur_nr = map_block->num_stripes;
+	int size_left = (cur_nr - 1 - i) * sizeof(struct btrfs_map_stripe);
+
+	memmove(&map_block->stripes[i], &map_block->stripes[i + 1], size_left);
+	map_block->num_stripes--;
+}
+
+static void remove_unrelated_stripes(struct map_lookup *map,
+				     int rw, u64 start, u64 length,
+				     struct btrfs_map_block *map_block)
+{
+	int i = 0;
+	/*
+	 * RAID5/6 write must use full stripe.
+	 * No need to do anything.
+	 */
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6) &&
+	    rw == WRITE)
+		return;
+
+	/*
+	 * For RAID0/1/10/DUP, whatever read/write, we can remove unrelated
+	 * stripes without causing anything wrong.
+	 * RAID5/6 READ is just like RAID0, we don't care parity unless we need
+	 * to recovery.
+	 * For recovery, rw should be set to WRITE.
+	 */
+	while (i < map_block->num_stripes) {
+		struct btrfs_map_stripe *stripe;
+		u64 orig_logical; /* Original stripe logical start */
+		u64 orig_end; /* Original stripe logical end */
+
+		stripe = &map_block->stripes[i];
+
+		/*
+		 * For READ, we don't really care parity
+		 */
+		if (stripe->logical == BTRFS_RAID5_P_STRIPE ||
+		    stripe->logical == BTRFS_RAID6_Q_STRIPE) {
+			del_one_stripe(map_block, i);
+			continue;
+		}
+		/* Completely unrelated stripe */
+		if (stripe->logical >= start + length ||
+		    stripe->logical + stripe->length <= start) {
+			del_one_stripe(map_block, i);
+			continue;
+		}
+		/* Covered stripe, modify its logical and physical */
+		orig_logical = stripe->logical;
+		orig_end = stripe->logical + stripe->length;
+		if (start + length <= orig_end) {
+			/*
+			 * |<--range-->|
+			 *   |  stripe   |
+			 * Or
+			 *     |<range>|
+			 *   |  stripe   |
+			 */
+			stripe->logical = max(orig_logical, start);
+			stripe->length = start + length;
+			stripe->physical += stripe->logical - orig_logical;
+		} else if (start >= orig_logical) {
+			/*
+			 *     |<-range--->|
+			 * |  stripe     |
+			 * Or
+			 *     |<range>|
+			 * |  stripe     |
+			 */
+			stripe->logical = start;
+			stripe->length = min(orig_end, start + length);
+			stripe->physical += stripe->logical - orig_logical;
+		}
+		/*
+		 * Remaining case:
+		 * |<----range----->|
+		 *   | stripe |
+		 * No need to do any modification
+		 */
+		i++;
+	}
+
+	/* Recaculate map_block size */
+	map_block->start = 0;
+	map_block->length = 0;
+	for (i = 0; i < map_block->num_stripes; i++) {
+		struct btrfs_map_stripe *stripe;
+
+		stripe = &map_block->stripes[i];
+		if (stripe->logical > map_block->start)
+			map_block->start = stripe->logical;
+		if (stripe->logical + stripe->length >
+		    map_block->start + map_block->length)
+			map_block->length = stripe->logical + stripe->length -
+					    map_block->start;
+	}
+}
+
 int __btrfs_map_block_v2(struct btrfs_fs_info *fs_info, int rw, u64 logical,
 			 u64 length, struct btrfs_map_block **map_ret)
 {
@@ -1717,7 +1818,7 @@ int __btrfs_map_block_v2(struct btrfs_fs_info *fs_info, int rw, u64 logical,
 		free(map_block);
 		return ret;
 	}
-	/* TODO: Remove unrelated map_stripes for READ operation */
+	remove_unrelated_stripes(map, rw, logical, length, map_block);
 
 	*map_ret = map_block;
 	return 0;
-- 
2.10.0



