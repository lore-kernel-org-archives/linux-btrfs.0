Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26117 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751361AbeAELR0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:26 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 02/16] btrfs-progs: Allow __btrfs_map_block_v2 to remove unrelated stripes
Date: Fri, 5 Jan 2018 19:01:10 +0800
Message-ID: <1515150084-17231-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

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
index 2d23712a..72399cde 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1760,6 +1760,107 @@ static int fill_full_map_block(struct map_lookup *map, u64 start, u64 length,
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
@@ -1795,7 +1896,7 @@ int __btrfs_map_block_v2(struct btrfs_fs_info *fs_info, int rw, u64 logical,
 		free(map_block);
 		return ret;
 	}
-	/* TODO: Remove unrelated map_stripes for READ operation */
+	remove_unrelated_stripes(map, rw, logical, length, map_block);
 
 	*map_ret = map_block;
 	return 0;
-- 
2.14.3



