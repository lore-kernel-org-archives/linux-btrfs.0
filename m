From: David Woodhouse <dwmw2@infradead.org>
Subject: RAID[56] recovery...
Date: Tue, 14 Jul 2009 10:56:32 +0100
Message-ID: <1247565392.19180.1005.camel@macbook.infradead.org>
References: <1247323186.17045.15.camel@macbook.infradead.org>
	 <1247477428.19180.28.camel@macbook.infradead.org>
	 <1247479513.19180.41.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247479513.19180.41.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-07-13 at 11:05 +0100, David Woodhouse wrote:
> 
> This hack serves two purposes:
>  - It does actually write parity (and RAID6 syndrome) blocks so that I
>    can implement and test the recovery.

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1f509ab..a23510b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3792,14 +3792,193 @@ static int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	return 0;
 }
 
+static void raid_recover_end_io(struct bio *bio, int err)
+{
+	struct btrfs_raid_multi_bio *rmult = bio->bi_private;
+	int nr_pages = rmult->multi->orig_bio->bi_size >> PAGE_SHIFT;
+	int i, j, k;
+	void **pointers;
+	void *q_ptr = NULL, *p_ptr;
+	int faila = -1, failb = -1;
+
+	if (err)
+		atomic_inc(&rmult->multi->error);
+
+	if (!atomic_dec_and_test(&rmult->multi->stripes_pending))
+		return;
+
+	/* OK, we have read all the stripes we need to. */
+	if (atomic_read(&rmult->multi->error) > rmult->multi->max_errors - 1) {
+		bio_endio(rmult->multi->orig_bio, -EIO);
+		goto cleanup;
+	}
+
+	pointers = kmalloc(rmult->multi->num_stripes * sizeof(void *), GFP_ATOMIC);
+	if (!pointers) {
+		bio_endio(rmult->multi->orig_bio, -EIO);
+		goto cleanup;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		p_ptr = q_ptr = NULL;
+		k = 0;
+		for (j = 0; j < rmult->multi->num_stripes; j++) {
+			struct bio *bio = rmult->bio[j];
+			if (!bio) {
+				if (rmult->raid_map[j] == RAID6_Q_STRIPE)
+					continue;
+				bio = rmult->multi->orig_bio;
+				faila = j;
+   		        } else if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+				/* We counted the errors. There can be only one */
+				BUG_ON(failb != -1);
+				if (rmult->raid_map[j] == RAID6_Q_STRIPE) {
+					/* Eep. Can't recover from this. Theoretically if the only
+					   failure is the Q stripe and the original data we're trying
+					   to read, then parity should have recovered it. But we'd
+					   only get here if that was broken _too_ */
+					bio_endio(rmult->multi->orig_bio, -EIO);
+					kfree(pointers);
+					goto cleanup;
+				} else if (rmult->raid_map[j] == RAID5_P_STRIPE) {
+					failb = -2;
+				} else {
+					failb = j;
+				}
+			}
+
+			/* Is this always a valid assumption? */
+			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_SIZE);
+			BUG_ON(bio->bi_io_vec[i].bv_offset);
+			
+			/* FIXME: Would be nice to kmap here so that we can allow highmem
+			   pages, but since we're in end_io context it would need to be
+			   kmap_atomic, and there are an arbitrary number of pages... */
+			if (rmult->raid_map[j] == RAID5_P_STRIPE)
+				p_ptr = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+			else if (rmult->raid_map[j] == RAID6_Q_STRIPE)
+				q_ptr = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+			else
+				pointers[k++] = phys_to_virt(page_to_phys(bio->bi_io_vec[i].bv_page));
+		}
+		pointers[k++] = p_ptr;
+
+		if (q_ptr) {
+			pointers[k++] = q_ptr;
+			BUG_ON(k != j);
+
+			if (failb == -1) {
+				/*
+				 * Eep. We don't _have_ a second failure, so parity really 
+				 * _should_ have worked. One of the stripes must be _corrupted_
+				 * rather than unreadable, which is a problem for us -- we have
+				 * no way of knowing which one. Theoretically, we could increase
+				 * the value of btrfs_num_copies() to let the upper layers try
+				 * _all_ possible combinations until it finds one that looks OK?
+				 */
+				failb = -2;
+			}
+			if (failb == -2) {
+				raid6_datap_recov(rmult->multi->num_stripes, PAGE_SIZE, faila, pointers);
+			} else {
+				if (faila > failb) {
+					int tmp = failb;
+					failb = faila;
+					faila = tmp;
+				}
+				raid6_2data_recov(rmult->multi->num_stripes, PAGE_SIZE, faila, failb, pointers);
+			}
+		} else {
+			memcpy(pointers[faila], p_ptr, PAGE_SIZE);
+			for (k = 0; pointers[k] != p_ptr; k++) {
+				if (k == faila)
+					continue;
+				for (j = 0; j < PAGE_SIZE; j += sizeof(unsigned long)) {
+					*(unsigned long *)(pointers[faila] + j) ^=
+						*(unsigned long *)(pointers[k] + j);
+				}
+			}
+		}
+		/* kunmap pages here */
+	}
+	kfree(pointers);
+
+	rmult->multi->orig_bio->bi_size = 0;
+	bio_endio(rmult->multi->orig_bio, 0);
+	return;
+
+ cleanup:
+	for (i = 0; i < rmult->multi->num_stripes; i++) {
+		if (!rmult->bio[i])
+			continue;
+		for (j = 0; j < nr_pages; j++) {
+			__free_page(rmult->bio[i]->bi_io_vec[j].bv_page);
+		}
+		bio_put(rmult->bio[i]);
+	}
+	kfree(rmult->raid_map);
+	kfree(rmult->multi);
+	kfree(rmult);
+}
+
 static int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 				 int async, struct btrfs_multi_bio *multi,
 				 u64 *raid_map, u64 stripe_len, int mirror_num)
 {
-	WARN_ON(1);
-	kfree(multi);
-	kfree(raid_map);
-	bio_endio(bio, -EIO);
+	int i;
+	int start_ofs, end_ofs;
+	int stripes_to_read = 0;
+	u64 logical = (u64)bio->bi_sector << 9;
+	struct btrfs_raid_multi_bio *rmult;
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
+	/* What subrange of the stripe are we reading? */
+	start_ofs = do_div(logical, stripe_len);
+	end_ofs = start_ofs + bio->bi_size;
+	BUG_ON(end_ofs > stripe_len);
+
+	/* Allocate bios for reading all the other stripes */
+	logical = (u64)bio->bi_sector << 9;
+	for (i = 0; i < multi->num_stripes; i++) {
+		if (start_ofs) {
+			if (!is_parity_stripe(raid_map[i]))
+				raid_map[i] += start_ofs;
+			multi->stripes[i].physical += start_ofs;
+		}
+		/* Don't read the original data block, of course. And
+		   don't read the Q stripe if we're asked for mirror #2
+		   (which means recreate from parity) */
+		if (raid_map[i] != logical &&
+		    (raid_map[i] != RAID6_Q_STRIPE || mirror_num == 3)) {
+			rmult->bio[i] = alloc_raid_stripe_bio(&multi->stripes[i],
+							      bio->bi_size);
+			BUG_ON(!rmult->bio[i]); /* FIXME */
+			rmult->bio[i]->bi_private = rmult;
+			rmult->bio[i]->bi_end_io = raid_recover_end_io;
+			stripes_to_read++;
+		}
+	}
+
+	atomic_set(&multi->stripes_pending, stripes_to_read);
+	for (i = 0; i < multi->num_stripes; i++) {
+
+		if (rmult->bio[i]) {
+			if (async)
+				schedule_bio(root, multi->stripes[i].dev, READ, rmult->bio[i]);
+			else
+				submit_bio(READ, rmult->bio[i]);
+		}
+	}
 	return 0;
 }
 
-- 
1.6.2.5


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

