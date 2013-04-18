Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28766 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967171Ab3DRQy5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 12:54:57 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3IGst4t018445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:54:56 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3IGssDE018592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:54:55 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3IGssOr001282
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 16:54:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: improve the loop of scrub_stripe
Date: Fri, 19 Apr 2013 00:54:55 +0800
Message-Id: <1366304095-3206-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) Right now scrub_stripe() is looping in some unnecessary cases:
* when the found extent item's objectid has been out of the dev extent's range
  but we haven't finish scanning all the range within the dev extent
* when all the items has been processed but we haven't finish scanning all the
  range within the dev extent

In both cases, we can just finish the loop to save costs.

2) Besides, when the found extent item's length is larger than the stripe len(64k),
we don't have to release the path and search again as it'll get at the same key
used in the last loop, we can instead increase the logical cursor in place till
all space of the extent is scanned.

3) And we use 0 as the key's offset to search btree, then get to previous item
to find a smaller item, and again have to move to the next one to get the right
item.  Setting offset=-1 and previous_item() is the correct way.

4) As we won't find any checksum at offset unless this 'offset' is in a data
extent, we can just find checksum when we're really going to scrub an extent.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c |   79 +++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 85e072b..091b57b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2236,12 +2236,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	u64 flags;
 	int ret;
 	int slot;
-	int i;
 	u64 nstripes;
 	struct extent_buffer *l;
 	struct btrfs_key key;
 	u64 physical;
 	u64 logical;
+	u64 logic_end;
 	u64 generation;
 	int mirror_num;
 	struct reada_control *reada1;
@@ -2255,6 +2255,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	u64 extent_len;
 	struct btrfs_device *extent_dev;
 	int extent_mirror_num;
+	int stop_loop;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6)) {
@@ -2354,8 +2355,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	 */
 	logical = base + offset;
 	physical = map->stripes[num].physical;
+	logic_end = logical + increment * nstripes;
 	ret = 0;
-	for (i = 0; i < nstripes; ++i) {
+	while (logical < logic_end) {
 		/*
 		 * canceled?
 		 */
@@ -2391,15 +2393,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			wake_up(&fs_info->scrub_pause_wait);
 		}
 
-		ret = btrfs_lookup_csums_range(csum_root, logical,
-					       logical + map->stripe_len - 1,
-					       &sctx->csum_list, 1);
-		if (ret)
-			goto out;
-
 		key.objectid = logical;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
-		key.offset = (u64)0;
+		key.offset = (u64)-1;
 
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
@@ -2420,6 +2416,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			}
 		}
 
+		stop_loop = 0;
 		while (1) {
 			l = path->nodes[0];
 			slot = path->slots[0];
@@ -2430,18 +2427,21 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				if (ret < 0)
 					goto out;
 
+				stop_loop = 1;
 				break;
 			}
 			btrfs_item_key_to_cpu(l, &key, slot);
 
-			if (key.objectid + key.offset <= logical)
+			if (key.objectid + key.offset <= logical ||
+			    btrfs_key_type(&key) != BTRFS_EXTENT_ITEM_KEY)
 				goto next;
 
-			if (key.objectid >= logical + map->stripe_len)
+			if (key.objectid >= logical + map->stripe_len) {
+				/* out of this device extent */
+				if (key.objectid >= logic_end)
+					stop_loop = 1;
 				break;
-
-			if (btrfs_key_type(&key) != BTRFS_EXTENT_ITEM_KEY)
-				goto next;
+			}
 
 			extent = btrfs_item_ptr(l, slot,
 						struct btrfs_extent_item);
@@ -2458,22 +2458,23 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto next;
 			}
 
+again:
+			extent_logical = key.objectid;
+			extent_len = key.offset;
 			/*
 			 * trim extent to this stripe
 			 */
-			if (key.objectid < logical) {
-				key.offset -= logical - key.objectid;
-				key.objectid = logical;
+			if (extent_logical < logical) {
+				extent_len -= logical - extent_logical;
+				extent_logical = logical;
 			}
-			if (key.objectid + key.offset >
+			if (extent_logical + extent_len >
 			    logical + map->stripe_len) {
-				key.offset = logical + map->stripe_len -
-					     key.objectid;
+				extent_len = logical + map->stripe_len -
+					     extent_logical;
 			}
 
-			extent_logical = key.objectid;
-			extent_physical = key.objectid - logical + physical;
-			extent_len = key.offset;
+			extent_physical = extent_logical - logical + physical;
 			extent_dev = scrub_dev;
 			extent_mirror_num = mirror_num;
 			if (is_dev_replace)
@@ -2481,13 +2482,35 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 						   extent_len, &extent_physical,
 						   &extent_dev,
 						   &extent_mirror_num);
+
+			ret = btrfs_lookup_csums_range(csum_root, logical,
+						logical + map->stripe_len - 1,
+						&sctx->csum_list, 1);
+			if (ret)
+				goto out;
+
 			ret = scrub_extent(sctx, extent_logical, extent_len,
 					   extent_physical, extent_dev, flags,
 					   generation, extent_mirror_num,
-					   key.objectid - logical + physical);
+					   extent_physical);
 			if (ret)
 				goto out;
 
+			if (extent_logical + extent_len <
+			    key.objectid + key.offset) {
+				logical += increment;
+				physical += map->stripe_len;
+
+				if (logical < key.objectid + key.offset) {
+					cond_resched();
+					goto again;
+				}
+
+				if (logical >= logic_end) {
+					stop_loop = 1;
+					break;
+				}
+			}
 next:
 			path->slots[0]++;
 		}
@@ -2495,8 +2518,14 @@ next:
 		logical += increment;
 		physical += map->stripe_len;
 		spin_lock(&sctx->stat_lock);
-		sctx->stat.last_physical = physical;
+		if (stop_loop)
+			sctx->stat.last_physical = map->stripes[num].physical +
+						   length;
+		else
+			sctx->stat.last_physical = physical;
 		spin_unlock(&sctx->stat_lock);
+		if (stop_loop)
+			break;
 	}
 out:
 	/* push queued extents */
-- 
1.7.7

