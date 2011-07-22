From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [RFC PATCH 1/4] btrfs: btrfs_multi_bio replaced with btrfs_bio
Date: Fri, 22 Jul 2011 16:58:05 +0200
Message-ID: <70f41bb2f34daf5aab8f429170168154c9a89527.1311344751.git.list.btrfs@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1311344751.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_bio is a bio abstraction able to split and not complete after the last
bio has returned (like the old btrfs_multi_bio). Additionally, btrfs_bio
tracks the mirror_num used to read data which can be used for error
correction purposes.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent-tree.c |   10 ++--
 fs/btrfs/scrub.c       |   20 ++++----
 fs/btrfs/volumes.c     |  128 +++++++++++++++++++++++++----------------------
 fs/btrfs/volumes.h     |   10 +++-
 4 files changed, 90 insertions(+), 78 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 71cd456..351efb3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1772,18 +1772,18 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 {
 	int ret;
 	u64 discarded_bytes = 0;
-	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_bio *bbio = NULL;
 
 
 	/* Tell the block device(s) that the sectors can be discarded */
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, REQ_DISCARD,
-			      bytenr, &num_bytes, &multi, 0);
+			      bytenr, &num_bytes, &bbio, 0);
 	if (!ret) {
-		struct btrfs_bio_stripe *stripe = multi->stripes;
+		struct btrfs_bio_stripe *stripe = bbio->stripes;
 		int i;
 
 
-		for (i = 0; i < multi->num_stripes; i++, stripe++) {
+		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length);
@@ -1792,7 +1792,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 			else if (ret != -EOPNOTSUPP)
 				break;
 		}
-		kfree(multi);
+		kfree(bbio);
 	}
 	if (discarded_bytes && ret == -EOPNOTSUPP)
 		ret = 0;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a8d03d5..c04775e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -250,7 +250,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 	struct scrub_dev *sdev = sbio->sdev;
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
-	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_bio *bbio = NULL;
 	u64 logical = sbio->logical + ix * PAGE_SIZE;
 	u64 length;
 	int i;
@@ -269,8 +269,8 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 
 	length = PAGE_SIZE;
 	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
-			      &multi, 0);
-	if (ret || !multi || length < PAGE_SIZE) {
+			      &bbio, 0);
+	if (ret || !bbio || length < PAGE_SIZE) {
 		printk(KERN_ERR
 		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
 		       (unsigned long long)logical);
@@ -278,19 +278,19 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		return;
 	}
 
-	if (multi->num_stripes == 1)
+	if (bbio->num_stripes == 1)
 		/* there aren't any replicas */
 		goto uncorrectable;
 
 	/*
 	 * first find a good copy
 	 */
-	for (i = 0; i < multi->num_stripes; ++i) {
+	for (i = 0; i < bbio->num_stripes; ++i) {
 		if (i == sbio->spag[ix].mirror_num)
 			continue;
 
-		if (scrub_fixup_io(READ, multi->stripes[i].dev->bdev,
-				   multi->stripes[i].physical >> 9,
+		if (scrub_fixup_io(READ, bbio->stripes[i].dev->bdev,
+				   bbio->stripes[i].physical >> 9,
 				   sbio->bio->bi_io_vec[ix].bv_page)) {
 			/* I/O-error, this is not a good copy */
 			continue;
@@ -299,7 +299,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		if (scrub_fixup_check(sbio, ix) == 0)
 			break;
 	}
-	if (i == multi->num_stripes)
+	if (i == bbio->num_stripes)
 		goto uncorrectable;
 
 	if (!sdev->readonly) {
@@ -314,7 +314,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		}
 	}
 
-	kfree(multi);
+	kfree(bbio);
 	spin_lock(&sdev->stat_lock);
 	++sdev->stat.corrected_errors;
 	spin_unlock(&sdev->stat_lock);
@@ -325,7 +325,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 	return;
 
 uncorrectable:
-	kfree(multi);
+	kfree(bbio);
 	spin_lock(&sdev->stat_lock);
 	++sdev->stat.uncorrectable_errors;
 	spin_unlock(&sdev->stat_lock);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19450bc..e839b72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2801,7 +2801,7 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 
 static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 			     u64 logical, u64 *length,
-			     struct btrfs_multi_bio **multi_ret,
+			     struct btrfs_bio **bbio_ret,
 			     int mirror_num)
 {
 	struct extent_map *em;
@@ -2819,18 +2819,18 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	int i;
 	int num_stripes;
 	int max_errors = 0;
-	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_bio *bbio = NULL;
 
-	if (multi_ret && !(rw & (REQ_WRITE | REQ_DISCARD)))
+	if (bbio_ret && !(rw & (REQ_WRITE | REQ_DISCARD)))
 		stripes_allocated = 1;
 again:
-	if (multi_ret) {
-		multi = kzalloc(btrfs_multi_bio_size(stripes_allocated),
+	if (bbio_ret) {
+		bbio = kzalloc(btrfs_bio_size(stripes_allocated),
 				GFP_NOFS);
-		if (!multi)
+		if (!bbio)
 			return -ENOMEM;
 
-		atomic_set(&multi->error, 0);
+		atomic_set(&bbio->error, 0);
 	}
 
 	read_lock(&em_tree->lock);
@@ -2851,7 +2851,7 @@ again:
 	if (mirror_num > map->num_stripes)
 		mirror_num = 0;
 
-	/* if our multi bio struct is too small, back off and try again */
+	/* if our btrfs_bio struct is too small, back off and try again */
 	if (rw & REQ_WRITE) {
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 				 BTRFS_BLOCK_GROUP_DUP)) {
@@ -2870,11 +2870,11 @@ again:
 			stripes_required = map->num_stripes;
 		}
 	}
-	if (multi_ret && (rw & (REQ_WRITE | REQ_DISCARD)) &&
+	if (bbio_ret && (rw & (REQ_WRITE | REQ_DISCARD)) &&
 	    stripes_allocated < stripes_required) {
 		stripes_allocated = map->num_stripes;
 		free_extent_map(em);
-		kfree(multi);
+		kfree(bbio);
 		goto again;
 	}
 	stripe_nr = offset;
@@ -2903,7 +2903,7 @@ again:
 		*length = em->len - offset;
 	}
 
-	if (!multi_ret)
+	if (!bbio_ret)
 		goto out;
 
 	num_stripes = 1;
@@ -2928,13 +2928,17 @@ again:
 			stripe_index = find_live_mirror(map, 0,
 					    map->num_stripes,
 					    current->pid % map->num_stripes);
+			mirror_num = stripe_index + 1;
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (rw & (REQ_WRITE | REQ_DISCARD))
+		if (rw & (REQ_WRITE | REQ_DISCARD)) {
 			num_stripes = map->num_stripes;
-		else if (mirror_num)
+		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
+		} else {
+			mirror_num = 1;
+		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 		int factor = map->num_stripes / map->sub_stripes;
@@ -2954,6 +2958,7 @@ again:
 			stripe_index = find_live_mirror(map, stripe_index,
 					      map->sub_stripes, stripe_index +
 					      current->pid % map->sub_stripes);
+			mirror_num = stripe_index + 1;
 		}
 	} else {
 		/*
@@ -2962,15 +2967,16 @@ again:
 		 * stripe_index is the number of our device in the stripe array
 		 */
 		stripe_index = do_div(stripe_nr, map->num_stripes);
+		mirror_num = stripe_index + 1;
 	}
 	BUG_ON(stripe_index >= map->num_stripes);
 
 	if (rw & REQ_DISCARD) {
 		for (i = 0; i < num_stripes; i++) {
-			multi->stripes[i].physical =
+			bbio->stripes[i].physical =
 				map->stripes[stripe_index].physical +
 				stripe_offset + stripe_nr * map->stripe_len;
-			multi->stripes[i].dev = map->stripes[stripe_index].dev;
+			bbio->stripes[i].dev = map->stripes[stripe_index].dev;
 
 			if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
 				u64 stripes;
@@ -2991,16 +2997,16 @@ again:
 				}
 				stripes = stripe_nr_end - 1 - j;
 				do_div(stripes, map->num_stripes);
-				multi->stripes[i].length = map->stripe_len *
+				bbio->stripes[i].length = map->stripe_len *
 					(stripes - stripe_nr + 1);
 
 				if (i == 0) {
-					multi->stripes[i].length -=
+					bbio->stripes[i].length -=
 						stripe_offset;
 					stripe_offset = 0;
 				}
 				if (stripe_index == last_stripe)
-					multi->stripes[i].length -=
+					bbio->stripes[i].length -=
 						stripe_end_offset;
 			} else if (map->type & BTRFS_BLOCK_GROUP_RAID10) {
 				u64 stripes;
@@ -3025,11 +3031,11 @@ again:
 				}
 				stripes = stripe_nr_end - 1 - j;
 				do_div(stripes, factor);
-				multi->stripes[i].length = map->stripe_len *
+				bbio->stripes[i].length = map->stripe_len *
 					(stripes - stripe_nr + 1);
 
 				if (i < map->sub_stripes) {
-					multi->stripes[i].length -=
+					bbio->stripes[i].length -=
 						stripe_offset;
 					if (i == map->sub_stripes - 1)
 						stripe_offset = 0;
@@ -3037,11 +3043,11 @@ again:
 				if (stripe_index >= last_stripe &&
 				    stripe_index <= (last_stripe +
 						     map->sub_stripes - 1)) {
-					multi->stripes[i].length -=
+					bbio->stripes[i].length -=
 						stripe_end_offset;
 				}
 			} else
-				multi->stripes[i].length = *length;
+				bbio->stripes[i].length = *length;
 
 			stripe_index++;
 			if (stripe_index == map->num_stripes) {
@@ -3052,19 +3058,20 @@ again:
 		}
 	} else {
 		for (i = 0; i < num_stripes; i++) {
-			multi->stripes[i].physical =
+			bbio->stripes[i].physical =
 				map->stripes[stripe_index].physical +
 				stripe_offset +
 				stripe_nr * map->stripe_len;
-			multi->stripes[i].dev =
+			bbio->stripes[i].dev =
 				map->stripes[stripe_index].dev;
 			stripe_index++;
 		}
 	}
-	if (multi_ret) {
-		*multi_ret = multi;
-		multi->num_stripes = num_stripes;
-		multi->max_errors = max_errors;
+	if (bbio_ret) {
+		*bbio_ret = bbio;
+		bbio->num_stripes = num_stripes;
+		bbio->max_errors = max_errors;
+		bbio->mirror_num = mirror_num;
 	}
 out:
 	free_extent_map(em);
@@ -3073,9 +3080,9 @@ out:
 
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      u64 logical, u64 *length,
-		      struct btrfs_multi_bio **multi_ret, int mirror_num)
+		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
-	return __btrfs_map_block(map_tree, rw, logical, length, multi_ret,
+	return __btrfs_map_block(map_tree, rw, logical, length, bbio_ret,
 				 mirror_num);
 }
 
@@ -3144,28 +3151,28 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
-static void end_bio_multi_stripe(struct bio *bio, int err)
+static void btrfs_end_bio(struct bio *bio, int err)
 {
-	struct btrfs_multi_bio *multi = bio->bi_private;
+	struct btrfs_bio *bbio = bio->bi_private;
 	int is_orig_bio = 0;
 
 	if (err)
-		atomic_inc(&multi->error);
+		atomic_inc(&bbio->error);
 
-	if (bio == multi->orig_bio)
+	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
 
-	if (atomic_dec_and_test(&multi->stripes_pending)) {
+	if (atomic_dec_and_test(&bbio->stripes_pending)) {
 		if (!is_orig_bio) {
 			bio_put(bio);
-			bio = multi->orig_bio;
+			bio = bbio->orig_bio;
 		}
-		bio->bi_private = multi->private;
-		bio->bi_end_io = multi->end_io;
+		bio->bi_private = bbio->private;
+		bio->bi_end_io = bbio->end_io;
 		/* only send an error to the higher layers if it is
 		 * beyond the tolerance of the multi-bio
 		 */
-		if (atomic_read(&multi->error) > multi->max_errors) {
+		if (atomic_read(&bbio->error) > bbio->max_errors) {
 			err = -EIO;
 		} else if (err) {
 			/*
@@ -3175,7 +3182,7 @@ static void end_bio_multi_stripe(struct bio *bio, int err)
 			set_bit(BIO_UPTODATE, &bio->bi_flags);
 			err = 0;
 		}
-		kfree(multi);
+		kfree(bbio);
 
 		bio_endio(bio, err);
 	} else if (!is_orig_bio) {
@@ -3255,20 +3262,20 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	u64 logical = (u64)bio->bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
-	struct btrfs_multi_bio *multi = NULL;
 	int ret;
 	int dev_nr = 0;
 	int total_devs = 1;
+	struct btrfs_bio *bbio = NULL;
 
 	length = bio->bi_size;
 	map_tree = &root->fs_info->mapping_tree;
 	map_length = length;
 
-	ret = btrfs_map_block(map_tree, rw, logical, &map_length, &multi,
+	ret = btrfs_map_block(map_tree, rw, logical, &map_length, &bbio,
 			      mirror_num);
 	BUG_ON(ret);
 
-	total_devs = multi->num_stripes;
+	total_devs = bbio->num_stripes;
 	if (map_length < length) {
 		printk(KERN_CRIT "mapping failed logical %llu bio len %llu "
 		       "len %llu\n", (unsigned long long)logical,
@@ -3276,25 +3283,28 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		       (unsigned long long)map_length);
 		BUG();
 	}
-	multi->end_io = first_bio->bi_end_io;
-	multi->private = first_bio->bi_private;
-	multi->orig_bio = first_bio;
-	atomic_set(&multi->stripes_pending, multi->num_stripes);
+
+	bbio->orig_bio = first_bio;
+	bbio->private = first_bio->bi_private;
+	bbio->end_io = first_bio->bi_end_io;
+	atomic_set(&bbio->stripes_pending, bbio->num_stripes);
 
 	while (dev_nr < total_devs) {
-		if (total_devs > 1) {
-			if (dev_nr < total_devs - 1) {
-				bio = bio_clone(first_bio, GFP_NOFS);
-				BUG_ON(!bio);
-			} else {
-				bio = first_bio;
-			}
-			bio->bi_private = multi;
-			bio->bi_end_io = end_bio_multi_stripe;
+		if (dev_nr < total_devs - 1) {
+			bio = bio_clone(first_bio, GFP_NOFS);
+			BUG_ON(!bio);
+		} else {
+			bio = first_bio;
 		}
-		bio->bi_sector = multi->stripes[dev_nr].physical >> 9;
-		dev = multi->stripes[dev_nr].dev;
+		bio->bi_private = bbio;
+		bio->bi_end_io = btrfs_end_bio;
+		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
+		dev = bbio->stripes[dev_nr].dev;
 		if (dev && dev->bdev && (rw != WRITE || dev->writeable)) {
+			pr_debug("btrfs_map_bio: rw %d, secor=%llu, dev=%lu "
+				 "(%s id %llu), size=%u\n", rw,
+				 (u64)bio->bi_sector, (u_long)dev->bdev->bd_dev,
+				 dev->name, dev->devid, bio->bi_size);
 			bio->bi_bdev = dev->bdev;
 			if (async_submit)
 				schedule_bio(root, dev, rw, bio);
@@ -3307,8 +3317,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		}
 		dev_nr++;
 	}
-	if (total_devs == 1)
-		kfree(multi);
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 7c12d61..f5ce92b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -134,7 +134,10 @@ struct btrfs_bio_stripe {
 	u64 length; /* only used for discard mappings */
 };
 
-struct btrfs_multi_bio {
+struct btrfs_bio;
+typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
+
+struct btrfs_bio {
 	atomic_t stripes_pending;
 	bio_end_io_t *end_io;
 	struct bio *orig_bio;
@@ -142,6 +145,7 @@ struct btrfs_multi_bio {
 	atomic_t error;
 	int max_errors;
 	int num_stripes;
+	int mirror_num;
 	struct btrfs_bio_stripe stripes[];
 };
 
@@ -169,7 +173,7 @@ struct map_lookup {
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
-#define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
+#define btrfs_bio_size(n) (sizeof(struct btrfs_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
@@ -178,7 +182,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   u64 chunk_offset, u64 start, u64 num_bytes);
 int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		    u64 logical, u64 *length,
-		    struct btrfs_multi_bio **multi_ret, int mirror_num);
+		    struct btrfs_bio **bbio_ret, int mirror_num);
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
-- 
1.7.3.4

