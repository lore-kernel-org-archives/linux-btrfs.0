From: David Woodhouse <dwmw2@infradead.org>
Subject: Updating RAID[56] support
Date: Thu, 29 Apr 2010 19:06:06 +0100
Message-ID: <1272564366.3367.4143.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been looking again at the RAID5/RAID6 support, and updated the tree
at git://git.infradead.org/users/dwmw2/btrfs-raid56.git#merged

At the moment, we limit writes to a single disk's worth at a time, which
means we _always_ do the read-calculateparity-write cycle and suffer the
traditional RAID 'write hole' problem.

We need to fix the upper layers so that it'll _always_ write a full
stripe, which Chris has promised to do. When that's done, we can rip out
the whole raid56_parity_write_partial() and raid_read_end_io() and
raid_hack_mutex crap.

But first I needed to actually make the RAID code _cope_ with a full
stripe at a time, which for some reason I hadn't already done. That's
what this patch attempts to do.

(It also sets the stripe size to 4KiB/disk so that we can use it on a
4-disk RAID6 and be sure we'll only ever be asked to write either
precisely one disk's worth as before, or the whole stripe -- I've not
attempted to make it cope with anything in-between. That's a simple hack
for short-term testing purposes, which needs to be done in mkfs.btrfs
too.)

It seems to work, and recovery is successful when I mount the file
system with -oro,degraded. But in read-write mode it'll oops (even
without the below patch) because it's trying to _write_ to the degraded
RAID6. Last time I was testing this, it wouldn't continue to write to
that block group; it would allocate a new one which didn't include the
missing disk. What changed?

The thing I really don't like about this patch is the handling of the
returned map_length from __btrfs_map_block(), for full-stripe writes.
Suggestions on a postcard to...

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 32eabf1..70dc314 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2226,7 +2226,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	int looped = 0;
 	int ret;
 	int index;
-	int stripe_len = 64 * 1024;
+	int stripe_len = 4 * 1024;
 
 	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
 	    (type & BTRFS_BLOCK_GROUP_DUP)) {
@@ -2735,6 +2735,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	u64 offset;
 	u64 stripe_offset;
 	u64 stripe_nr;
+	u64 stripe_len;
 	u64 *raid_map = NULL;
 	int stripes_allocated = 8;
 	int stripes_required = 1;
@@ -2816,13 +2817,24 @@ again:
 		goto again;
 	}
 	stripe_nr = offset;
+
+	stripe_len = map->stripe_len;
+	if (!multi_ret && !unplug_page && (rw & (1 << BIO_RW)) &&
+	    map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		/*
+		 * For the merge_bio_hook() we allow _writes_ (but not reads)
+		 * to cover a full stripe-set. 
+		 */
+		stripe_len *= nr_data_stripes(map);
+		printk("Stripe_len becomes %llx\n", stripe_len);
+	}
 	/*
 	 * stripe_nr counts the total number of stripes we have to stride
 	 * to get to this block
 	 */
-	do_div(stripe_nr, map->stripe_len);
+	do_div(stripe_nr, stripe_len);
 
-	stripe_offset = stripe_nr * map->stripe_len;
+	stripe_offset = stripe_nr * stripe_len;
 	BUG_ON(offset < stripe_offset);
 
 	/* stripe_offset is the offset of this block in its stripe*/
@@ -2833,8 +2845,21 @@ again:
 			 BTRFS_BLOCK_GROUP_RAID10 |
 			 BTRFS_BLOCK_GROUP_DUP)) {
 		/* we limit the length of each bio to what fits in a stripe */
-		*length = min_t(u64, em->len - offset,
-			      map->stripe_len - stripe_offset);
+		/* For writes to RAID[56], allow a full stripe, not just a single
+		   disk's worth */
+		if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6) &&
+		    !stripe_offset && multi_ret && raid_map_ret && (rw & (1 << BIO_RW))) {
+			*length = min_t(u64, em->len - offset,
+					stripe_len * nr_data_stripes(map));
+			printk("len becomes %Lx for RAID[56] write (min(%Lx,%Lx))\n", *length, 
+			       em->len - offset, stripe_len * nr_data_stripes(map));
+		} else {
+			*length = min_t(u64, em->len - offset,
+					stripe_len - stripe_offset);
+			printk("len becomes %Lx (min(%Lx,%Lx))\n", *length, 
+			       em->len - offset, stripe_len - stripe_offset);
+		}
+					
 	} else {
 		*length = em->len - offset;
 	}
@@ -3173,6 +3198,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	int ret;
 	int dev_nr = 0;
 	int total_devs = 1;
+	printk("%s %d %d %llx %x\n", __func__, rw, mirror_num, logical, bio->bi_size);
 
 	length = bio->bi_size;
 	map_tree = &root->fs_info->mapping_tree;
@@ -3187,6 +3213,13 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	multi->orig_bio = first_bio;
 	atomic_set(&multi->stripes_pending, multi->num_stripes);
 
+	if (map_length < length) {
+		printk(KERN_CRIT "mapping failed logical %llu bio len %llu "
+		       "len %llu\n", (unsigned long long)logical,
+		       (unsigned long long)length,
+		       (unsigned long long)map_length);
+	}
+
 	if (raid_map) {
 		if (rw == READ)
 			return raid56_parity_recover(root, bio, multi,
@@ -3629,6 +3662,7 @@ struct btrfs_raid_multi_bio {
 	struct btrfs_root *root;
 	struct btrfs_multi_bio *multi;
 	u64 *raid_map;
+	int partial;
 	struct bio *bio[0];
 };
 
@@ -3671,7 +3705,7 @@ static void raid_write_end_io(struct bio *bio, int err)
 
 	if (!atomic_dec_and_test(&rmult->multi->stripes_pending))
 		return;
-
+	printk("Ended final write IO\n");
 	/* OK, we have read all the stripes we need to. */
 	if (atomic_read(&rmult->multi->error)) {
 		bio_endio(rmult->multi->orig_bio, -EIO);
@@ -3683,7 +3717,8 @@ static void raid_write_end_io(struct bio *bio, int err)
 	bio_endio(rmult->multi->orig_bio, 0);
 
  cleanup:
-	mutex_unlock(&raid_hack_mutex);
+	if (rmult->partial)
+		mutex_unlock(&raid_hack_mutex);
 	free_raid_multi(rmult);
 }
 
@@ -3843,28 +3878,14 @@ static struct bio *alloc_raid_stripe_bio(struct btrfs_root *root,
 	return bio;
 }
 
-static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
-			       struct btrfs_multi_bio *multi, u64 *raid_map,
-			       u64 stripe_len)
+static int raid56_parity_write_partial(struct btrfs_raid_multi_bio *rmult,
+				       struct bio *bio, u64 stripe_len)
 {
 	int i;
 	int start_ofs, end_ofs;
 	int stripes_to_read = 0;
 	u64 logical = (u64)bio->bi_sector << 9;
 
-	struct btrfs_raid_multi_bio *rmult;
-
-	rmult = kzalloc(sizeof(*rmult) + multi->num_stripes * sizeof(void *),
-			GFP_NOFS);
-	if (!rmult) {
-		kfree(raid_map);
-		kfree(multi);
-		return -ENOMEM;
-	}
-	rmult->multi = multi;
-	rmult->raid_map = raid_map;
-	rmult->root = root;
-
 	/*
 	 * FIXME: the merge_bio_hook logic currently ensures that writes only
 	 * cover one stripe, meaning we _always_ have to read the other data
@@ -3880,6 +3901,7 @@ static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	 * And we can ditch this mutex too:
 	 */
 	mutex_lock(&raid_hack_mutex);
+	rmult->partial = 1;
 
 	/* What subrange of the stripe are we writing? */
 	start_ofs = do_div(logical, stripe_len);
@@ -3888,19 +3910,19 @@ static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 
 	/* Allocate bios for reading and for the parity and q-stripe writes */
 	logical = (u64)bio->bi_sector << 9;
-	for (i = 0; i < multi->num_stripes; i++) {
+	for (i = 0; i < rmult->multi->num_stripes; i++) {
 		if (start_ofs) {
-			if (!is_parity_stripe(raid_map[i]))
-				raid_map[i] += start_ofs;
-			multi->stripes[i].physical += start_ofs;
+			if (!is_parity_stripe(rmult->raid_map[i]))
+				rmult->raid_map[i] += start_ofs;
+			rmult->multi->stripes[i].physical += start_ofs;
 		}
-		if (raid_map[i] == logical) {
+		if (rmult->raid_map[i] == logical) {
 			/* Set the correct bdev for the original write bio */
-			bio->bi_bdev = multi->stripes[i].dev->bdev;
+			bio->bi_bdev = rmult->multi->stripes[i].dev->bdev;
 		} else {
-			rmult->bio[i] =
-				alloc_raid_stripe_bio(root, &multi->stripes[i],
-						      bio->bi_size);
+			rmult->bio[i] = alloc_raid_stripe_bio(rmult->root,
+							      &rmult->multi->stripes[i],
+							      bio->bi_size);
 			if (!rmult->bio[i]) {
 				free_raid_multi(rmult);
 				bio_endio(bio, -EIO);
@@ -3909,23 +3931,23 @@ static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 			}
 			rmult->bio[i]->bi_private = rmult;
 
-			if (!is_parity_stripe(raid_map[i]))
+			if (!is_parity_stripe(rmult->raid_map[i]))
 				stripes_to_read++;
 		}
 	}
 	if (!stripes_to_read) {
 		/* Nothing to read -- just calculate parity and write it all */
-		atomic_set(&multi->stripes_pending, 1);
+		atomic_set(&rmult->multi->stripes_pending, 1);
 		bio->bi_private = rmult;
 		raid_read_end_io(bio, 0);
 		return 0;
 	}
 
-	atomic_set(&multi->stripes_pending, stripes_to_read);
-	for (i = 0; stripes_to_read && i < multi->num_stripes; i++) {
-		if (rmult->bio[i] && !is_parity_stripe(raid_map[i])) {
+	atomic_set(&rmult->multi->stripes_pending, stripes_to_read);
+	for (i = 0; stripes_to_read && i < rmult->multi->num_stripes; i++) {
+		if (rmult->bio[i] && !is_parity_stripe(rmult->raid_map[i])) {
 			rmult->bio[i]->bi_end_io = raid_read_end_io;
-			btrfs_bio_wq_end_io(root->fs_info, rmult->bio[i], 1);
+			btrfs_bio_wq_end_io(rmult->root->fs_info, rmult->bio[i], 1);
 			submit_bio(READ, rmult->bio[i]);
 			stripes_to_read--;
 		}
@@ -3933,6 +3955,139 @@ static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	return 0;
 }
 
+static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
+			       struct btrfs_multi_bio *multi, u64 *raid_map,
+			       u64 stripe_len)
+{
+	struct btrfs_raid_multi_bio *rmult;
+	int i, j, k;
+	int nr_data = 0;
+	int p_stripe = -1, q_stripe = -1, orig_stripe = -1;
+	void *pointers[multi->num_stripes];
+	u64 logical = (u64)bio->bi_sector << 9;
+
+	rmult = kzalloc(sizeof(*rmult) + multi->num_stripes * sizeof(void *),
+			GFP_NOFS);
+	if (!rmult) {
+		kfree(raid_map);
+		kfree(multi);
+		return -ENOMEM;
+	}
+	rmult->multi = multi;
+	rmult->raid_map = raid_map;
+	rmult->root = root;
+
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (raid_map[i] == RAID5_P_STRIPE)
+			p_stripe = i;
+		else if (raid_map[i] == RAID6_Q_STRIPE)
+			q_stripe = i;
+		else
+			nr_data++;
+	}
+
+	if (bio->bi_size != stripe_len * nr_data) {
+		printk("partial\n");
+		return raid56_parity_write_partial(rmult, bio, stripe_len);
+	}
+
+	/* Yay, a full-stripe write! */
+
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (raid_map[i] == logical) {
+			orig_stripe = i;
+			continue;
+		}
+		rmult->bio[i] = alloc_raid_stripe_bio(root, &multi->stripes[i],
+						      is_parity_stripe(raid_map[i])?stripe_len:0);
+		BUG_ON(!rmult->bio[i]); /* FIXME */
+	}
+
+	for (i = 0; i < stripe_len >> PAGE_SHIFT; i++) {
+		for (j = 0; j < nr_data; j++) {
+			int pagenr = j * (stripe_len >> PAGE_SHIFT) + i;
+			pointers[j] = kmap(bio->bi_io_vec[pagenr].bv_page);
+		}
+		pointers[j++] = kmap(rmult->bio[p_stripe]->bi_io_vec[i].bv_page);
+		if (q_stripe != -1) {
+			pointers[j++] = kmap(rmult->bio[q_stripe]->bi_io_vec[i].bv_page);
+
+			raid6_call.gen_syndrome(multi->num_stripes, PAGE_SIZE,
+						pointers);
+			printk("D %lx P(%d) %lx Q(%d) %lx\n",
+			       *(unsigned long *)pointers[0],
+			       p_stripe,
+			       *(unsigned long *)pointers[p_stripe],
+			       q_stripe,
+			       *(unsigned long *)pointers[q_stripe]);
+			kunmap(rmult->bio[q_stripe]->bi_io_vec[i].bv_page);
+		} else {
+			memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
+			for (k = 1; k < nr_data; k++) {
+				for (j = 0; j < PAGE_SIZE; j += sizeof(unsigned long)) {
+					*(unsigned long *)(pointers[nr_data] + j) ^=
+						*(unsigned long *)(pointers[k] + j);
+				}
+			}
+		}
+		for (j = 0; j < nr_data; j++) {
+			int pagenr = j * (stripe_len >> PAGE_SHIFT) + i;
+			kunmap(bio->bi_io_vec[pagenr].bv_page);
+		}
+		kunmap(rmult->bio[p_stripe]->bi_io_vec[i].bv_page);
+	}
+
+	atomic_set(&multi->stripes_pending, multi->num_stripes);
+	multi->max_errors = 0;
+	printk("RAID full write, multi %p\n", multi);
+
+	/* Split original bio into chunks for different disks */
+	for (i = 0; i < multi->num_stripes; i++) {
+		struct bio *this_bio = rmult->bio[i];
+		if (!this_bio) {
+			/* Leave the original bio till last */
+			continue;
+		}
+
+		if (!is_parity_stripe(raid_map[i]) && raid_map[i] != logical) {
+			for (j = 0; j < stripe_len >> PAGE_SHIFT; j++) {
+				int pagenr = ((raid_map[i] - logical) >> PAGE_SHIFT) + j;
+				struct page *pg;
+				printk("Steal page %d for bio %d (%p), vec %p\n", pagenr, i, this_bio, bio->bi_io_vec);
+				pg = bio->bi_io_vec[pagenr].bv_page;
+				printk("Stolen page is %p\n", pg);
+				get_page(pg);
+				bio_add_page(this_bio, pg, PAGE_SIZE, 0);
+			}
+		}
+
+		this_bio->bi_private = rmult;
+		this_bio->bi_end_io = raid_write_end_io;
+		this_bio->bi_sector = multi->stripes[i].physical >> 9;
+		this_bio->bi_bdev = multi->stripes[i].dev->bdev;
+		printk("Submit %s bio #%d %p to %x:%llx\n", 
+		       (i == p_stripe)?"P":((i==q_stripe)?"Q":"D"),
+		       i, this_bio,
+		       this_bio->bi_bdev->bd_dev,
+		       (u64)this_bio->bi_sector << 9);
+		schedule_bio(root, multi->stripes[i].dev, WRITE, this_bio);
+	}
+
+	/* Write the original bio last to prevent various races */
+	BUG_ON(orig_stripe == -1);
+	bio->bi_private = rmult;
+	bio->bi_end_io = raid_write_end_io;
+	bio->bi_sector = multi->stripes[orig_stripe].physical >> 9;
+	bio->bi_bdev = multi->stripes[orig_stripe].dev->bdev;
+	printk("Submit original D bio #%d %p to %x:%llx\n", 
+	       orig_stripe, bio,
+	       bio->bi_bdev->bd_dev,
+	       (u64)bio->bi_sector << 9);
+	schedule_bio(root, multi->stripes[orig_stripe].dev, WRITE, bio);
+
+	return 0;
+}
+
 static void raid_recover_end_io(struct bio *bio, int err)
 {
 	struct btrfs_raid_multi_bio *rmult = bio->bi_private;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

