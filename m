Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26380 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752754AbcLZGa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:28 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id C6AA341B4BDD
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:43 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 06/19] btrfs-progs: Introduce new btrfs_map_block function which returns more unified result.
Date: Mon, 26 Dec 2016 14:29:26 +0800
Message-Id: <20161226062939.5841-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, __btrfs_map_block_v2().

Unlike old btrfs_map_block(), which needs different parameter to handle
different RAID profile, this new function uses unified btrfs_map_block
structure to handle all RAID profile in a more meaningful method:

Return physical address along with logical address for each stripe.

For RAID1/Single/DUP (none-stripped):
result would be like:
Map block: Logical 128M, Len 10M, Type RAID1, Stripe len 0, Nr_stripes 2
Stripe 0: Logical 128M, Physical X, Len: 10M Dev dev1
Stripe 1: Logical 128M, Physical Y, Len: 10M Dev dev2

Result will be as long as possible, since it's not stripped at all.

For RAID0/10 (stripped without parity):
Result will be aligned to full stripe size:
Map block: Logical 64K, Len 128K, Type RAID10, Stripe len 64K, Nr_stripes 4
Stripe 0: Logical 64K, Physical X, Len 64K Dev dev1
Stripe 1: Logical 64K, Physical Y, Len 64K Dev dev2
Stripe 2: Logical 128K, Physical Z, Len 64K Dev dev3
Stripe 3: Logical 128K, Physical W, Len 64K Dev dev4

For RAID5/6 (stripped with parity and dev-rotation)
Result will be aligned to full stripe size:
Map block: Logical 64K, Len 128K, Type RAID6, Stripe len 64K, Nr_stripes 4
Stripe 0: Logical 64K, Physical X, Len 64K Dev dev1
Stripe 1: Logical 128K, Physical Y, Len 64K Dev dev2
Stripe 2: Logical RAID5_P, Physical Z, Len 64K Dev dev3
Stripe 3: Logical RAID6_Q, Physical W, Len 64K Dev dev4

The new unified layout should be very flex and can even handle things
like N-way RAID1 (which old mirror_num basic one can't handle well).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 181 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 volumes.h |  49 +++++++++++++++++
 2 files changed, 230 insertions(+)

diff --git a/volumes.c b/volumes.c
index f17bdeed..11d1f0e8 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1593,6 +1593,187 @@ out:
 	return 0;
 }
 
+static inline struct btrfs_map_block *alloc_map_block(int num_stripes)
+{
+	struct btrfs_map_block *ret;
+	int size;
+
+	size = sizeof(struct btrfs_map_stripe) * num_stripes +
+		sizeof(struct btrfs_map_block);
+	ret = malloc(size);
+	if (!ret)
+		return NULL;
+	memset(ret, 0, size);
+	return ret;
+}
+
+static int fill_full_map_block(struct map_lookup *map, u64 start, u64 length,
+			       struct btrfs_map_block *map_block)
+{
+	u64 profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	u64 bg_start = map->ce.start;
+	u64 bg_end = bg_start + map->ce.size;
+	u64 bg_offset = start - bg_start; /* offset inside the block group */
+	u64 fstripe_logical = 0;	/* Full stripe start logical bytenr */
+	u64 fstripe_size = 0;		/* Full stripe logical size */
+	u64 fstripe_phy_off = 0;	/* Full stripe offset in each dev */
+	u32 stripe_len = map->stripe_len;
+	int sub_stripes = map->sub_stripes;
+	int data_stripes = nr_data_stripes(map);
+	int dev_rotation;
+	int i;
+
+	map_block->num_stripes = map->num_stripes;
+	map_block->type = profile;
+
+	/*
+	 * Common full stripe data for stripe based profiles
+	 */
+	if (profile & (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID10 |
+		       BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		fstripe_size = stripe_len * data_stripes;
+		if (sub_stripes)
+			fstripe_size /= sub_stripes;
+		fstripe_logical = bg_offset / fstripe_size * fstripe_size +
+				    bg_start;
+		fstripe_phy_off = bg_offset / fstripe_size * stripe_len;
+	}
+
+	switch (profile) {
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case 0: /* SINGLE */
+		/*
+		 * None-stripe mode,(Single, DUP and RAID1)
+		 * Just use offset to fill map_block
+		 */
+		map_block->stripe_len = 0;
+		map_block->start = start;
+		map_block->length = min(bg_end, start + length) - start;
+		for (i = 0; i < map->num_stripes; i++) {
+			struct btrfs_map_stripe *stripe;
+
+			stripe = &map_block->stripes[i];
+
+			stripe->dev = map->stripes[i].dev;
+			stripe->logical = start;
+			stripe->physical = map->stripes[i].physical + bg_offset;
+			stripe->length = map_block->length;
+		}
+		break;
+	case BTRFS_BLOCK_GROUP_RAID10:
+	case BTRFS_BLOCK_GROUP_RAID0:
+		/*
+		 * Stripe modes without parity(0 and 10)
+		 * Return the whole full stripe
+		 */
+
+		map_block->start = fstripe_logical;
+		map_block->length = fstripe_size;
+		map_block->stripe_len = map->stripe_len;
+		for (i = 0; i < map->num_stripes; i++) {
+			struct btrfs_map_stripe *stripe;
+			u64 cur_offset;
+
+			/* Handle RAID10 sub stripes */
+			if (sub_stripes)
+				cur_offset = i / sub_stripes * stripe_len;
+			else
+				cur_offset = stripe_len * i;
+			stripe = &map_block->stripes[i];
+
+			stripe->dev = map->stripes[i].dev;
+			stripe->logical = fstripe_logical + cur_offset;
+			stripe->length = stripe_len;
+			stripe->physical = map->stripes[i].physical +
+					   fstripe_phy_off;
+		}
+		break;
+	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_RAID6:
+		/*
+		 * Stripe modes with parity and device rotation(5 and 6)
+		 *
+		 * Return the whole full stripe
+		 */
+
+		dev_rotation = (bg_offset / fstripe_size) % map->num_stripes;
+
+		map_block->start = fstripe_logical;
+		map_block->length = fstripe_size;
+		map_block->stripe_len = map->stripe_len;
+		for (i = 0; i < map->num_stripes; i++) {
+			struct btrfs_map_stripe *stripe;
+			int dest_index;
+			u64 cur_offset = stripe_len * i;
+
+			stripe = &map_block->stripes[i];
+
+			dest_index = (i + dev_rotation) % map->num_stripes;
+			stripe->dev = map->stripes[dest_index].dev;
+			stripe->length = stripe_len;
+			stripe->physical = map->stripes[dest_index].physical +
+					   fstripe_phy_off;
+			if (i < data_stripes) {
+				/* data stripe */
+				stripe->logical = fstripe_logical +
+						  cur_offset;
+			} else if (i == data_stripes) {
+				/* P */
+				stripe->logical = BTRFS_RAID5_P_STRIPE;
+			} else {
+				/* Q */
+				stripe->logical = BTRFS_RAID6_Q_STRIPE;
+			}
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int __btrfs_map_block_v2(struct btrfs_fs_info *fs_info, int rw, u64 logical,
+			 u64 length, struct btrfs_map_block **map_ret)
+{
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	struct btrfs_map_block *map_block;
+	int ret;
+
+	/* Eearly parameter check */
+	if (!length || !map_ret) {
+		error("wrong parameter for %s", __func__);
+		return -EINVAL;
+	}
+
+	ce = search_cache_extent(&fs_info->mapping_tree.cache_tree, logical);
+	if (!ce)
+		return -ENOENT;
+	if (ce->start > logical)
+		return -ENOENT;
+
+	map = container_of(ce, struct map_lookup, ce);
+	/*
+	 * Allocate a full map_block anyway
+	 *
+	 * For write, we need the full map_block anyway.
+	 * For read, it will be striped to the needed stripe before returning.
+	 */
+	map_block = alloc_map_block(map->num_stripes);
+	if (!map_block)
+		return -ENOMEM;
+	ret = fill_full_map_block(map, logical, length, map_block);
+	if (ret < 0) {
+		free(map_block);
+		return ret;
+	}
+	/* TODO: Remove unrelated map_stripes for READ operation */
+
+	*map_ret = map_block;
+	return 0;
+}
+
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 				       u8 *uuid, u8 *fsid)
 {
diff --git a/volumes.h b/volumes.h
index ee7d56ab..0a575557 100644
--- a/volumes.h
+++ b/volumes.h
@@ -108,6 +108,51 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct btrfs_map_stripe {
+	struct btrfs_device *dev;
+
+	/*
+	 * Logical address of the stripe start.
+	 * Caller should check if this logical is the desired map start.
+	 * It's possible that the logical is smaller or larger than desired
+	 * map range.
+	 *
+	 * For P/Q stipre, it will be BTRFS_RAID5_P_STRIPE
+	 * and BTRFS_RAID6_Q_STRIPE.
+	 */
+	u64 logical;
+
+	u64 physical;
+
+	/* The length of the stripe */
+	u64 length;
+};
+
+struct btrfs_map_block {
+	/*
+	 * The logical start of the whole map block.
+	 * For RAID5/6 it will be the bytenr of the full stripe start,
+	 * so it's possible that @start is smaller than desired map range
+	 * start.
+	 */
+	u64 start;
+
+	/*
+	 * The logical length of the map block.
+	 * For RAID5/6 it will be total data stripe size
+	 */
+	u64 length;
+
+	/* Block group type */
+	u64 type;
+
+	/* Stripe length, for non-stripped mode, it will be 0 */
+	u32 stripe_len;
+
+	int num_stripes;
+	struct btrfs_map_stripe stripes[];
+};
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 #define btrfs_map_lookup_size(n) (sizeof(struct map_lookup) + \
@@ -187,6 +232,10 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_multi_bio **multi_ret, int mirror_num,
 		    u64 **raid_map_ret);
+
+/* TODO: Use this map_block_v2 to replace __btrfs_map_block() */
+int __btrfs_map_block_v2(struct btrfs_fs_info *fs_info, int rw, u64 logical,
+			 u64 length, struct btrfs_map_block **map_ret);
 int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
 		     u64 *size, u64 type);
 static inline int btrfs_next_bg_metadata(struct btrfs_mapping_tree *map_tree,
-- 
2.11.0



