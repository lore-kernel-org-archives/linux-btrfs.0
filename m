Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50160 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3DZRLL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 13:11:11 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH v2] Btrfs: improve the loop of scrub_stripe
Date: Sat, 27 Apr 2013 01:11:18 +0800
Message-Id: <1366996278-32210-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: root <root@liubo.(none)>

1) Right now scrub_stripe() is looping in some unnecessary cases:
* when the found extent item's objectid has been out of the dev extent's range
  but we haven't finish scanning all the range within the dev extent
* when all the items has been processed but we haven't finish scanning all the
  range within the dev extent

In both cases, we can just finish the loop to save costs.

2) Besides, when the found extent item's length is larger than the stripe
len(64k), we don't have to release the path and search again as it'll get at the
same key used in the last loop, we can instead increase the logical cursor in
place till all space of the extent is scanned.

3) And we use 0 as the key's offset to search btree, then get to previous item
to find a smaller item, and again have to move to the next one to get the right
item.  Setting offset=-1 and previous_item() is the correct way.

4) As we won't find any checksum at offset unless this 'offset' is in a data
extent, we can just find checksum when we're really going to scrub an extent.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: rebase onto btrfs-next

 fs/btrfs/scrub.c |   83 +++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 28db5dc..738c3f6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2233,12 +2233,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
@@ -2252,6 +2252,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	u64 extent_len;
 	struct btrfs_device *extent_dev;
 	int extent_mirror_num;
+	int stop_loop;
 
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6)) {
@@ -2351,8 +2352,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
@@ -2388,15 +2390,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
@@ -2418,6 +2414,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			}
 		}
 
+		stop_loop = 0;
 		while (1) {
 			u64 bytes;
 
@@ -2430,14 +2427,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				if (ret < 0)
 					goto out;
 
+				stop_loop = 1;
 				break;
 			}
 			btrfs_item_key_to_cpu(l, &key, slot);
 
-			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
-			    key.type != BTRFS_METADATA_ITEM_KEY)
-				goto next;
-
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				bytes = root->leafsize;
 			else
@@ -2446,9 +2440,16 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			if (key.objectid + bytes <= logical)
 				goto next;
 
-			if (key.objectid >= logical + map->stripe_len)
-				break;
+			if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+			    key.type != BTRFS_METADATA_ITEM_KEY)
+				goto next;
 
+			if (key.objectid >= logical + map->stripe_len) {
+				/* out of this device extent */
+				if (key.objectid >= logic_end)
+					stop_loop = 1;
+				break;
+			}
 
 			extent = btrfs_item_ptr(l, slot,
 						struct btrfs_extent_item);
@@ -2465,22 +2466,24 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto next;
 			}
 
+again:
+			extent_logical = key.objectid;
+			extent_len = bytes;
+
 			/*
 			 * trim extent to this stripe
 			 */
-			if (key.objectid < logical) {
-				bytes -= logical - key.objectid;
-				key.objectid = logical;
+			if (extent_logical < logical) {
+				extent_len -= logical - extent_logical;
+				extent_logical = logical;
 			}
-			if (key.objectid + bytes >
+			if (extent_logical + extent_len >
 			    logical + map->stripe_len) {
-				bytes = logical + map->stripe_len -
-					key.objectid;
+				extent_len = logical + map->stripe_len -
+					     extent_logical;
 			}
 
-			extent_logical = key.objectid;
-			extent_physical = key.objectid - logical + physical;
-			extent_len = bytes;
+			extent_physical = extent_logical - logical + physical;
 			extent_dev = scrub_dev;
 			extent_mirror_num = mirror_num;
 			if (is_dev_replace)
@@ -2488,13 +2491,35 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
+			    key.objectid + bytes) {
+				logical += increment;
+				physical += map->stripe_len;
+
+				if (logical < key.objectid + bytes) {
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
@@ -2502,8 +2527,14 @@ next:
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
1.7.7.6

