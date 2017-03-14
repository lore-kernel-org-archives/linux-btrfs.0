Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24061 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbdCNUfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 16:35:14 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 2/7] Btrfs: separate DISCARD from __btrfs_map_block
Date: Tue, 14 Mar 2017 13:33:56 -0700
Message-Id: <1489523641-10345-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since DISCARD is not as important as an operation like write, we don't
copy it to target device during replace, and it makes __btrfs_map_block
less complex.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
- use the helper get_chunk_map to simplify code
- use round_up instead of ALIGN.

 fs/btrfs/volumes.c | 289 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 175 insertions(+), 114 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 758a485..f94a45e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5292,6 +5292,158 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
 		kfree(bbio);
 }
 
+/* can REQ_OP_DISCARD be sent with other REQ like REQ_OP_WRITE? */
+/*
+ * Please note that, discard won't be sent to target device of device
+ * replace.
+ */
+static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
+					 u64 logical, u64 length,
+					 struct btrfs_bio **bbio_ret)
+{
+	struct extent_map *em;
+	struct map_lookup *map;
+	struct btrfs_bio *bbio;
+	u64 offset;
+	u64 stripe_nr;
+	u64 stripe_nr_end;
+	u64 stripe_end_offset;
+	u64 stripe_cnt;
+	u64 stripe_len;
+	u64 stripe_offset;
+	u64 num_stripes;
+	u32 stripe_index;
+	u32 factor = 0;
+	u32 sub_stripes = 0;
+	u64 stripes_per_dev = 0;
+	u32 remaining_stripes = 0;
+	u32 last_stripe = 0;
+	int ret = 0;
+	int i;
+
+	/* discard always return a bbio */
+	ASSERT(bbio_ret);
+
+	em = get_chunk_map(fs_info, logical, length);
+	if (IS_ERR(em))
+		return PTR_ERR(em);
+
+	map = em->map_lookup;
+	/* we don't discard raid56 yet */
+	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	offset = logical - em->start;
+	length = min_t(u64, em->len - offset, length);
+
+	stripe_len = map->stripe_len;
+	/*
+	 * stripe_nr counts the total number of stripes we have to stride
+	 * to get to this block
+	 */
+	stripe_nr = div64_u64(offset, stripe_len);
+
+	/* stripe_offset is the offset of this block in its stripe */
+	stripe_offset = offset - stripe_nr * stripe_len;
+
+	stripe_nr_end = round_up(offset + length, map->stripe_len);
+	stripe_nr_end = div_u64(stripe_nr_end, map->stripe_len);
+	stripe_cnt = stripe_nr_end - stripe_nr;
+	stripe_end_offset = stripe_nr_end * map->stripe_len -
+			    (offset + length);
+	/*
+	 * after this, stripe_nr is the number of stripes on this
+	 * device we have to walk to find the data, and stripe_index is
+	 * the number of our device in the stripe array
+	 */
+	num_stripes = 1;
+	stripe_index = 0;
+	if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+			 BTRFS_BLOCK_GROUP_RAID10)) {
+		if (map->type & BTRFS_BLOCK_GROUP_RAID0)
+			sub_stripes = 1;
+		else
+			sub_stripes = map->sub_stripes;
+
+		factor = map->num_stripes / sub_stripes;
+		num_stripes = min_t(u64, map->num_stripes,
+				    sub_stripes * stripe_cnt);
+		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
+		stripe_index *= sub_stripes;
+		stripes_per_dev = div_u64_rem(stripe_cnt, factor,
+					      &remaining_stripes);
+		div_u64_rem(stripe_nr_end - 1, factor, &last_stripe);
+		last_stripe *= sub_stripes;
+	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
+				BTRFS_BLOCK_GROUP_DUP)) {
+		num_stripes = map->num_stripes;
+	} else {
+		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
+					&stripe_index);
+	}
+
+	bbio = alloc_btrfs_bio(num_stripes, 0);
+	if (!bbio) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < num_stripes; i++) {
+		bbio->stripes[i].physical =
+			map->stripes[stripe_index].physical +
+			stripe_offset + stripe_nr * map->stripe_len;
+		bbio->stripes[i].dev = map->stripes[stripe_index].dev;
+
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
+				 BTRFS_BLOCK_GROUP_RAID10)) {
+			bbio->stripes[i].length = stripes_per_dev *
+				map->stripe_len;
+
+			if (i / sub_stripes < remaining_stripes)
+				bbio->stripes[i].length +=
+					map->stripe_len;
+
+			/*
+			 * Special for the first stripe and
+			 * the last stripe:
+			 *
+			 * |-------|...|-------|
+			 *     |----------|
+			 *    off     end_off
+			 */
+			if (i < sub_stripes)
+				bbio->stripes[i].length -=
+					stripe_offset;
+
+			if (stripe_index >= last_stripe &&
+			    stripe_index <= (last_stripe +
+					     sub_stripes - 1))
+				bbio->stripes[i].length -=
+					stripe_end_offset;
+
+			if (i == sub_stripes - 1)
+				stripe_offset = 0;
+		} else {
+			bbio->stripes[i].length = length;
+		}
+
+		stripe_index++;
+		if (stripe_index == map->num_stripes) {
+			stripe_index = 0;
+			stripe_nr++;
+		}
+	}
+
+	*bbio_ret = bbio;
+	bbio->map_type = map->type;
+	bbio->num_stripes = num_stripes;
+out:
+	free_extent_map(em);
+	return ret;
+}
+
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
@@ -5302,10 +5454,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	struct map_lookup *map;
 	u64 offset;
 	u64 stripe_offset;
-	u64 stripe_end_offset;
 	u64 stripe_nr;
-	u64 stripe_nr_orig;
-	u64 stripe_nr_end;
 	u64 stripe_len;
 	u32 stripe_index;
 	int i;
@@ -5321,6 +5470,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	u64 physical_to_patch_in_first_stripe = 0;
 	u64 raid56_full_stripe_start = (u64)-1;
 
+	if (op == BTRFS_MAP_DISCARD)
+		return __btrfs_map_block_for_discard(fs_info, logical,
+						     *length, bbio_ret);
+
 	em = get_chunk_map(fs_info, logical, *length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
@@ -5362,14 +5515,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		raid56_full_stripe_start *= full_stripe_len;
 	}
 
-	if (op == BTRFS_MAP_DISCARD) {
-		/* we don't discard raid56 yet */
-		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
-		*length = min_t(u64, em->len - offset, *length);
-	} else if (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	if (map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
 		u64 max_len;
 		/* For writes to RAID[56], allow a full stripeset across all disks.
 		   For other RAID types and for RAID[56] reads, just allow a single
@@ -5400,8 +5546,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
-	    op != BTRFS_MAP_GET_READ_MIRRORS && dev_replace->tgtdev != NULL) {
+	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS &&
+	    dev_replace->tgtdev != NULL) {
 		/*
 		 * in dev-replace case, for repair case (that's the only
 		 * case where the mirror is selected explicitly when
@@ -5481,24 +5627,13 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	num_stripes = 1;
 	stripe_index = 0;
-	stripe_nr_orig = stripe_nr;
-	stripe_nr_end = ALIGN(offset + *length, map->stripe_len);
-	stripe_nr_end = div_u64(stripe_nr_end, map->stripe_len);
-	stripe_end_offset = stripe_nr_end * map->stripe_len -
-			    (offset + *length);
-
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
-		if (op == BTRFS_MAP_DISCARD)
-			num_stripes = min_t(u64, map->num_stripes,
-					    stripe_nr_end - stripe_nr_orig);
 		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
 				&stripe_index);
-		if (op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
-		    op != BTRFS_MAP_GET_READ_MIRRORS)
+		if (op != BTRFS_MAP_WRITE && op != BTRFS_MAP_GET_READ_MIRRORS)
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD ||
-		    op == BTRFS_MAP_GET_READ_MIRRORS)
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -5511,8 +5646,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD ||
-		    op == BTRFS_MAP_GET_READ_MIRRORS) {
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -5528,10 +5662,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_stripes = map->sub_stripes;
-		else if (op == BTRFS_MAP_DISCARD)
-			num_stripes = min_t(u64, map->sub_stripes *
-					    (stripe_nr_end - stripe_nr_orig),
-					    map->num_stripes);
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
 		else {
@@ -5574,8 +5704,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			/* We distribute the parity blocks across stripes */
 			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
 					&stripe_index);
-			if ((op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
-			    op != BTRFS_MAP_GET_READ_MIRRORS) && mirror_num <= 1)
+			if ((op != BTRFS_MAP_WRITE &&
+			     op != BTRFS_MAP_GET_READ_MIRRORS) &&
+			    mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
@@ -5598,7 +5729,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	num_alloc_stripes = num_stripes;
 	if (dev_replace_is_ongoing) {
-		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD)
+		if (op == BTRFS_MAP_WRITE)
 			num_alloc_stripes <<= 1;
 		if (op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_alloc_stripes++;
@@ -5641,84 +5772,15 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 				RAID6_Q_STRIPE;
 	}
 
-	if (op == BTRFS_MAP_DISCARD) {
-		u32 factor = 0;
-		u32 sub_stripes = 0;
-		u64 stripes_per_dev = 0;
-		u32 remaining_stripes = 0;
-		u32 last_stripe = 0;
-
-		if (map->type &
-		    (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID10)) {
-			if (map->type & BTRFS_BLOCK_GROUP_RAID0)
-				sub_stripes = 1;
-			else
-				sub_stripes = map->sub_stripes;
-
-			factor = map->num_stripes / sub_stripes;
-			stripes_per_dev = div_u64_rem(stripe_nr_end -
-						      stripe_nr_orig,
-						      factor,
-						      &remaining_stripes);
-			div_u64_rem(stripe_nr_end - 1, factor, &last_stripe);
-			last_stripe *= sub_stripes;
-		}
 
-		for (i = 0; i < num_stripes; i++) {
-			bbio->stripes[i].physical =
-				map->stripes[stripe_index].physical +
-				stripe_offset + stripe_nr * map->stripe_len;
-			bbio->stripes[i].dev = map->stripes[stripe_index].dev;
-
-			if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
-					 BTRFS_BLOCK_GROUP_RAID10)) {
-				bbio->stripes[i].length = stripes_per_dev *
-							  map->stripe_len;
-
-				if (i / sub_stripes < remaining_stripes)
-					bbio->stripes[i].length +=
-						map->stripe_len;
-
-				/*
-				 * Special for the first stripe and
-				 * the last stripe:
-				 *
-				 * |-------|...|-------|
-				 *     |----------|
-				 *    off     end_off
-				 */
-				if (i < sub_stripes)
-					bbio->stripes[i].length -=
-						stripe_offset;
-
-				if (stripe_index >= last_stripe &&
-				    stripe_index <= (last_stripe +
-						     sub_stripes - 1))
-					bbio->stripes[i].length -=
-						stripe_end_offset;
-
-				if (i == sub_stripes - 1)
-					stripe_offset = 0;
-			} else
-				bbio->stripes[i].length = *length;
-
-			stripe_index++;
-			if (stripe_index == map->num_stripes) {
-				/* This could only happen for RAID0/10 */
-				stripe_index = 0;
-				stripe_nr++;
-			}
-		}
-	} else {
-		for (i = 0; i < num_stripes; i++) {
-			bbio->stripes[i].physical =
-				map->stripes[stripe_index].physical +
-				stripe_offset +
-				stripe_nr * map->stripe_len;
-			bbio->stripes[i].dev =
-				map->stripes[stripe_index].dev;
-			stripe_index++;
-		}
+	for (i = 0; i < num_stripes; i++) {
+		bbio->stripes[i].physical =
+			map->stripes[stripe_index].physical +
+			stripe_offset +
+			stripe_nr * map->stripe_len;
+		bbio->stripes[i].dev =
+			map->stripes[stripe_index].dev;
+		stripe_index++;
 	}
 
 	if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
@@ -5728,8 +5790,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		sort_parity_stripes(bbio, num_stripes);
 
 	tgtdev_indexes = 0;
-	if (dev_replace_is_ongoing &&
-	   (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD) &&
+	if (dev_replace_is_ongoing && op == BTRFS_MAP_WRITE &&
 	    dev_replace->tgtdev != NULL) {
 		int index_where_to_add;
 		u64 srcdev_devid = dev_replace->srcdev->devid;
-- 
2.5.5

