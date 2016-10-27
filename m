Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59826 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbcJ0H1l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 03:27:41 -0400
Received: from 213162068061.public.t-mobile.at ([213.162.68.61] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bzf6B-0001xQ-OJ
        for linux-btrfs@vger.kernel.org; Thu, 27 Oct 2016 07:27:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: don't abuse REQ_OP_* flags for btrfs_map_block
Date: Thu, 27 Oct 2016 09:27:36 +0200
Message-Id: <1477553256-25937-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_map_block supports different types of mappings, which to a large
extent resemble block layer operations.  But they don't always do, and
currently btrfs dangerously overlays it's own flag over the block layer
flags.  This is just asking for a conflict, so introduce a different
map flags enum inside of btrfs instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/ctree.h           |  3 ---
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/extent_io.c       |  2 +-
 fs/btrfs/inode.c           |  6 ++---
 fs/btrfs/reada.c           |  4 ++--
 fs/btrfs/scrub.c           | 17 +++++++-------
 fs/btrfs/volumes.c         | 58 ++++++++++++++++++++++++----------------------
 fs/btrfs/volumes.h         | 25 ++++++++++++++++++--
 9 files changed, 70 insertions(+), 49 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 8e99251..a6f657f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1539,7 +1539,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	struct btrfs_device *device;
 
 	length = len;
-	ret = btrfs_map_block(state->root->fs_info, READ,
+	ret = btrfs_map_block(state->root->fs_info, BTRFS_MAP_READ,
 			      bytenr, &length, &multi, mirror_num);
 
 	if (ret) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0b8ce2b..e4e01a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -90,9 +90,6 @@ static const int btrfs_csum_sizes[] = { 4 };
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
 
-/* specific to btrfs_map_block(), therefore not in include/linux/blk_types.h */
-#define REQ_GET_READ_MIRRORS	(1 << 30)
-
 /* ioprio of readahead is set to idle */
 #define BTRFS_IOPRIO_READA (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0))
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 210c94a..705cc38 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2036,7 +2036,7 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 	 */
 	btrfs_bio_counter_inc_blocked(root->fs_info);
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(root->fs_info, REQ_OP_DISCARD,
+	ret = btrfs_map_block(root->fs_info, BTRFS_MAP_DISCARD,
 			      bytenr, &num_bytes, &bbio, 0);
 	/* Error condition is -ENOMEM */
 	if (!ret) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 66a7551..be65fc6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2029,7 +2029,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	 * read repair operation.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
-	ret = btrfs_map_block(fs_info, WRITE, logical,
+	ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
 			      &map_length, &bbio, mirror_num);
 	if (ret) {
 		btrfs_bio_counter_dec(fs_info);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a37707..c681b19 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1864,7 +1864,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 
 	length = bio->bi_iter.bi_size;
 	map_length = length;
-	ret = btrfs_map_block(root->fs_info, bio_op(bio), logical,
+	ret = btrfs_map_block(root->fs_info, btrfs_op(bio), logical,
 			      &map_length, NULL, 0);
 	if (ret < 0)
 		return ret;
@@ -8406,7 +8406,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 	int i;
 
 	map_length = orig_bio->bi_iter.bi_size;
-	ret = btrfs_map_block(root->fs_info, bio_op(orig_bio),
+	ret = btrfs_map_block(root->fs_info, btrfs_op(orig_bio),
 			      start_sector << 9, &map_length, NULL, 0);
 	if (ret)
 		return -EIO;
@@ -8471,7 +8471,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 			btrfs_io_bio(bio)->logical = file_offset;
 
 			map_length = orig_bio->bi_iter.bi_size;
-			ret = btrfs_map_block(root->fs_info, bio_op(orig_bio),
+			ret = btrfs_map_block(root->fs_info, btrfs_op(orig_bio),
 					      start_sector << 9,
 					      &map_length, NULL, 0);
 			if (ret) {
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 75bab76..f7dd892 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -354,8 +354,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	 * map block
 	 */
 	length = blocksize;
-	ret = btrfs_map_block(fs_info, REQ_GET_READ_MIRRORS, logical, &length,
-			      &bbio, 0);
+	ret = btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
+			&length, &bbio, 0);
 	if (ret || !bbio || length < blocksize)
 		goto error;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index fffb9ab..589d792 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1334,8 +1334,8 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 		 * with a length of PAGE_SIZE, each returned stripe
 		 * represents one mirror
 		 */
-		ret = btrfs_map_sblock(fs_info, REQ_GET_READ_MIRRORS, logical,
-				       &mapped_length, &bbio, 0, 1);
+		ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
+				logical, &mapped_length, &bbio, 0, 1);
 		if (ret || !bbio || mapped_length < sublen) {
 			btrfs_put_bbio(bbio);
 			return -EIO;
@@ -2191,8 +2191,8 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	int ret;
 	int i;
 
-	ret = btrfs_map_sblock(fs_info, REQ_GET_READ_MIRRORS, logical, &length,
-			       &bbio, 0, 1);
+	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
+			&length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
 		goto bbio_out;
 
@@ -2778,7 +2778,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto out;
 
 	length = sparity->logic_end - sparity->logic_start;
-	ret = btrfs_map_sblock(sctx->dev_root->fs_info, WRITE,
+	ret = btrfs_map_sblock(sctx->dev_root->fs_info, BTRFS_MAP_WRITE,
 			       sparity->logic_start,
 			       &length, &bbio, 0, 1);
 	if (ret || !bbio || !bbio->raid_map)
@@ -2988,8 +2988,9 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 
 			mapped_length = extent_len;
 			bbio = NULL;
-			ret = btrfs_map_block(fs_info, READ, extent_logical,
-					      &mapped_length, &bbio, 0);
+			ret = btrfs_map_block(fs_info, BTRFS_MAP_READ,
+					extent_logical, &mapped_length, &bbio,
+					0);
 			if (!ret) {
 				if (!bbio || mapped_length < extent_len)
 					ret = -EIO;
@@ -4076,7 +4077,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	mapped_length = extent_len;
-	ret = btrfs_map_block(fs_info, READ, extent_logical,
+	ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, extent_logical,
 			      &mapped_length, &bbio, 0);
 	if (ret || !bbio || mapped_length < extent_len ||
 	    !bbio->stripes[0].dev->bdev) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 71a60cc..23df14c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5329,7 +5329,8 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
 		kfree(bbio);
 }
 
-static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
+static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
+			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
 			     struct btrfs_bio **bbio_ret,
 			     int mirror_num, int need_raid_map)
@@ -5414,7 +5415,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		raid56_full_stripe_start *= full_stripe_len;
 	}
 
-	if (op == REQ_OP_DISCARD) {
+	if (op == BTRFS_MAP_DISCARD) {
 		/* we don't discard raid56 yet */
 		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 			ret = -EOPNOTSUPP;
@@ -5427,7 +5428,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		   For other RAID types and for RAID[56] reads, just allow a single
 		   stripe (on a single disk). */
 		if ((map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
-		    (op == REQ_OP_WRITE)) {
+		    (op == BTRFS_MAP_WRITE)) {
 			max_len = stripe_len * nr_data_stripes(map) -
 				(offset - raid56_full_stripe_start);
 		} else {
@@ -5452,8 +5453,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
-	    op != REQ_GET_READ_MIRRORS && dev_replace->tgtdev != NULL) {
+	    op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
+	    op != BTRFS_MAP_GET_READ_MIRRORS && dev_replace->tgtdev != NULL) {
 		/*
 		 * in dev-replace case, for repair case (that's the only
 		 * case where the mirror is selected explicitly when
@@ -5474,7 +5475,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		int found = 0;
 		u64 physical_of_found = 0;
 
-		ret = __btrfs_map_block(fs_info, REQ_GET_READ_MIRRORS,
+		ret = __btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
 			     logical, &tmp_length, &tmp_bbio, 0, 0);
 		if (ret) {
 			WARN_ON(tmp_bbio != NULL);
@@ -5484,7 +5485,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		tmp_num_stripes = tmp_bbio->num_stripes;
 		if (mirror_num > tmp_num_stripes) {
 			/*
-			 * REQ_GET_READ_MIRRORS does not contain this
+			 * BTRFS_MAP_GET_READ_MIRRORS does not contain this
 			 * mirror, that means that the requested area
 			 * is not left of the left cursor
 			 */
@@ -5540,17 +5541,17 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 			    (offset + *length);
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
-		if (op == REQ_OP_DISCARD)
+		if (op == BTRFS_MAP_DISCARD)
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
 				&stripe_index);
-		if (op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
-		    op != REQ_GET_READ_MIRRORS)
+		if (op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
+		    op != BTRFS_MAP_GET_READ_MIRRORS)
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
-		    op == REQ_GET_READ_MIRRORS)
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD ||
+		    op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -5563,8 +5564,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
-		    op == REQ_GET_READ_MIRRORS) {
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD ||
+		    op == BTRFS_MAP_GET_READ_MIRRORS) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -5578,9 +5579,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
 
-		if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_stripes = map->sub_stripes;
-		else if (op == REQ_OP_DISCARD)
+		else if (op == BTRFS_MAP_DISCARD)
 			num_stripes = min_t(u64, map->sub_stripes *
 					    (stripe_nr_end - stripe_nr_orig),
 					    map->num_stripes);
@@ -5598,7 +5599,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		if (need_raid_map &&
-		    (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS ||
+		    (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS ||
 		     mirror_num > 1)) {
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = div_u64(raid56_full_stripe_start,
@@ -5626,8 +5627,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 			/* We distribute the parity blocks across stripes */
 			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
 					&stripe_index);
-			if ((op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
-			    op != REQ_GET_READ_MIRRORS) && mirror_num <= 1)
+			if ((op != BTRFS_MAP_WRITE && op != BTRFS_MAP_DISCARD &&
+			    op != BTRFS_MAP_GET_READ_MIRRORS) && mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
@@ -5650,9 +5651,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 
 	num_alloc_stripes = num_stripes;
 	if (dev_replace_is_ongoing) {
-		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD)
+		if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD)
 			num_alloc_stripes <<= 1;
-		if (op == REQ_GET_READ_MIRRORS)
+		if (op == BTRFS_MAP_GET_READ_MIRRORS)
 			num_alloc_stripes++;
 		tgtdev_indexes = num_stripes;
 	}
@@ -5668,7 +5669,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 	/* build raid_map */
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
 	    need_raid_map &&
-	    ((op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS) ||
+	    ((op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS) ||
 	    mirror_num > 1)) {
 		u64 tmp;
 		unsigned rot;
@@ -5693,7 +5694,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 				RAID6_Q_STRIPE;
 	}
 
-	if (op == REQ_OP_DISCARD) {
+	if (op == BTRFS_MAP_DISCARD) {
 		u32 factor = 0;
 		u32 sub_stripes = 0;
 		u64 stripes_per_dev = 0;
@@ -5773,7 +5774,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		}
 	}
 
-	if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
+	if (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_GET_READ_MIRRORS)
 		max_errors = btrfs_chunk_max_errors(map);
 
 	if (bbio->raid_map)
@@ -5781,7 +5782,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 
 	tgtdev_indexes = 0;
 	if (dev_replace_is_ongoing &&
-	   (op == REQ_OP_WRITE || op == REQ_OP_DISCARD) &&
+	   (op == BTRFS_MAP_WRITE || op == BTRFS_MAP_DISCARD) &&
 	    dev_replace->tgtdev != NULL) {
 		int index_where_to_add;
 		u64 srcdev_devid = dev_replace->srcdev->devid;
@@ -5816,7 +5817,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 			}
 		}
 		num_stripes = index_where_to_add;
-	} else if (dev_replace_is_ongoing && (op == REQ_GET_READ_MIRRORS) &&
+	} else if (dev_replace_is_ongoing &&
+		   op == BTRFS_MAP_GET_READ_MIRRORS &&
 		   dev_replace->tgtdev != NULL) {
 		u64 srcdev_devid = dev_replace->srcdev->devid;
 		int index_srcdev = 0;
@@ -5888,7 +5890,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 	return ret;
 }
 
-int btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		      u64 logical, u64 *length,
 		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
@@ -5897,7 +5899,7 @@ int btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 }
 
 /* For Scrub/replace */
-int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int op,
+int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
 		     struct btrfs_bio **bbio_ret, int mirror_num,
 		     int need_raid_map)
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 09ed29c..9029a31 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -371,14 +371,35 @@ struct btrfs_balance_control {
 	struct btrfs_balance_progress stat;
 };
 
+enum btrfs_map_op {
+	BTRFS_MAP_READ,
+	BTRFS_MAP_WRITE,
+	BTRFS_MAP_DISCARD,
+	BTRFS_MAP_GET_READ_MIRRORS,
+};
+
+static inline enum btrfs_map_op btrfs_op(struct bio *bio)
+{
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+		return BTRFS_MAP_DISCARD;
+	case REQ_OP_WRITE:
+		return BTRFS_MAP_WRITE;
+	default:
+		WARN_ON_ONCE(1);
+	case REQ_OP_READ:
+		return BTRFS_MAP_READ;
+	}
+}
+
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 void btrfs_get_bbio(struct btrfs_bio *bbio);
 void btrfs_put_bbio(struct btrfs_bio *bbio);
-int btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		    u64 logical, u64 *length,
 		    struct btrfs_bio **bbio_ret, int mirror_num);
-int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int op,
+int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
 		     struct btrfs_bio **bbio_ret, int mirror_num,
 		     int need_raid_map);
-- 
2.1.4

