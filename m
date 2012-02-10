From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: fix scrub statistics report
Date: Fri, 10 Feb 2012 15:18:33 +0100
Message-ID: <1328883513-32679-1-git-send-email-sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fixed that errors had been counted multiple times.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.h |   30 ++++++++------
 fs/btrfs/scrub.c |  115 ++++++++++++++++++++++++++++++++----------------------
 2 files changed, 85 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 4f69028..48b926c 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -49,17 +49,20 @@ struct btrfs_ioctl_vol_args_v2 {
  * result of a finished scrub, a canceled scrub or a progress inquiry
  */
 struct btrfs_scrub_progress {
-	__u64 data_extents_scrubbed;	/* # of data extents scrubbed */
-	__u64 tree_extents_scrubbed;	/* # of tree extents scrubbed */
+	__u64 data_extents_scrubbed;	/* # of 4k data data extents scrubbed */
+	__u64 tree_extents_scrubbed;	/* # of 4k data tree extents scrubbed */
 	__u64 data_bytes_scrubbed;	/* # of data bytes scrubbed */
 	__u64 tree_bytes_scrubbed;	/* # of tree bytes scrubbed */
-	__u64 read_errors;		/* # of read errors encountered (EIO) */
-	__u64 csum_errors;		/* # of failed csum checks */
-	__u64 verify_errors;		/* # of occurences, where the metadata
-					 * of a tree block did not match the
-					 * expected values, like generation or
-					 * logical */
-	__u64 no_csum;			/* # of 4k data block for which no csum
+	__u64 read_errors;		/* # of 4k data blocks which encountered
+					 * read errors (EIO) */
+	__u64 csum_errors;		/* # of 4k data blocks which failed csum
+					 * checks */
+	__u64 verify_errors;		/* # of 4k data blocks, where the
+					 * metadata of a tree block did not
+					 * match the expected values, like
+					 * generation or logical and the
+					 * checksum was not incorrect */
+	__u64 no_csum;			/* # of 4k data blocks for which no csum
 					 * is present, probably the result of
 					 * data written with nodatasum */
 	__u64 csum_discards;		/* # of csum for which no data was found
@@ -68,10 +71,11 @@ struct btrfs_scrub_progress {
 	__u64 malloc_errors;		/* # of internal kmalloc errors. These
 					 * will likely cause an incomplete
 					 * scrub */
-	__u64 uncorrectable_errors;	/* # of errors where either no intact
-					 * copy was found or the writeback
-					 * failed */
-	__u64 corrected_errors;		/* # of errors corrected */
+	__u64 uncorrectable_errors;	/* # of 4k data blocks with errors where
+					 * either no intact copy was found or
+					 * the writeback failed */
+	__u64 corrected_errors;		/* # of 4k data blocks with corrected
+					 * errors */
 	__u64 last_physical;		/* last physical address scrubbed. In
 					 * case a scrub was aborted, this can
 					 * be used to restart the scrub */
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9770cc5..21ea2ab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -48,10 +48,11 @@ struct scrub_dev;
 static void scrub_bio_end_io(struct bio *bio, int err);
 static void scrub_checksum(struct btrfs_work *work);
 static int scrub_checksum_data(struct scrub_dev *sdev,
-			       struct scrub_page *spag, void *buffer);
+			       struct scrub_page *spag, void *buffer,
+			       int modify_stats);
 static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 				     struct scrub_page *spag, u64 logical,
-				     void *buffer);
+				     void *buffer, int modify_stats);
 static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
 static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
 static void scrub_fixup_end_io(struct bio *bio, int err);
@@ -555,7 +556,8 @@ out:
  * recheck_error gets called for every page in the bio, even though only
  * one may be bad
  */
-static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
+static int scrub_recheck_error(struct scrub_bio *sbio, int ix,
+			       int modify_stats)
 {
 	struct scrub_dev *sdev = sbio->sdev;
 	u64 sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
@@ -575,9 +577,11 @@ static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
 			scrub_print_warning("checksum error", sbio, ix);
 	}
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.read_errors;
-	spin_unlock(&sdev->stat_lock);
+	if (modify_stats) {
+		spin_lock(&sdev->stat_lock);
+		++sdev->stat.read_errors;
+		spin_unlock(&sdev->stat_lock);
+	}
 
 	scrub_fixup(sbio, ix);
 	return 1;
@@ -594,12 +598,12 @@ static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
 	buffer = kmap_atomic(page, KM_USER0);
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
 		ret = scrub_checksum_data(sbio->sdev,
-					  sbio->spag + ix, buffer);
+					  sbio->spag + ix, buffer, 0);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		ret = scrub_checksum_tree_block(sbio->sdev,
 						sbio->spag + ix,
 						sbio->logical + ix * PAGE_SIZE,
-						buffer);
+						buffer, 0);
 	} else {
 		WARN_ON(1);
 	}
@@ -700,15 +704,15 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 			/* I/O-error, writeback failed, give up */
 			goto uncorrectable;
 		}
+
+		spin_lock(&sdev->stat_lock);
+		++sdev->stat.corrected_errors;
+		spin_unlock(&sdev->stat_lock);
+		printk_ratelimited(KERN_ERR "btrfs: fixed up error at logical "
+				   "%llu\n", (unsigned long long)logical);
 	}
 
 	kfree(bbio);
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.corrected_errors;
-	spin_unlock(&sdev->stat_lock);
-
-	printk_ratelimited(KERN_ERR "btrfs: fixed up error at logical %llu\n",
-			       (unsigned long long)logical);
 	return;
 
 uncorrectable:
@@ -766,16 +770,15 @@ static void scrub_checksum(struct btrfs_work *work)
 	u64 flags;
 	u64 logical;
 	int ret;
+	int recheck_succeeded_at_least_once = 0;
+	int recheck_failed_at_least_once = 0;
 
 	if (sbio->err) {
-		ret = 0;
 		for (i = 0; i < sbio->count; ++i)
-			ret |= scrub_recheck_error(sbio, i);
-		if (!ret) {
-			spin_lock(&sdev->stat_lock);
-			++sdev->stat.unverified_errors;
-			spin_unlock(&sdev->stat_lock);
-		}
+			if (scrub_recheck_error(sbio, i, 1))
+				recheck_failed_at_least_once = 1;
+			else
+				recheck_succeeded_at_least_once = 1;
 
 		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
@@ -797,10 +800,11 @@ static void scrub_checksum(struct btrfs_work *work)
 		logical = sbio->logical + i * PAGE_SIZE;
 		ret = 0;
 		if (flags & BTRFS_EXTENT_FLAG_DATA) {
-			ret = scrub_checksum_data(sdev, sbio->spag + i, buffer);
+			ret = scrub_checksum_data(sdev, sbio->spag + i, buffer,
+						  1);
 		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 			ret = scrub_checksum_tree_block(sdev, sbio->spag + i,
-							logical, buffer);
+							logical, buffer, 1);
 		} else if (flags & BTRFS_EXTENT_FLAG_SUPER) {
 			BUG_ON(i);
 			(void)scrub_checksum_super(sbio, buffer);
@@ -809,16 +813,19 @@ static void scrub_checksum(struct btrfs_work *work)
 		}
 		kunmap_atomic(buffer, KM_USER0);
 		if (ret) {
-			ret = scrub_recheck_error(sbio, i);
-			if (!ret) {
-				spin_lock(&sdev->stat_lock);
-				++sdev->stat.unverified_errors;
-				spin_unlock(&sdev->stat_lock);
-			}
+			if (scrub_recheck_error(sbio, i, 0))
+				recheck_failed_at_least_once = 1;
+			else
+				recheck_succeeded_at_least_once = 1;
 		}
 	}
 
 out:
+	if (recheck_succeeded_at_least_once && !recheck_failed_at_least_once) {
+		spin_lock(&sdev->stat_lock);
+		++sdev->stat.unverified_errors;
+		spin_unlock(&sdev->stat_lock);
+	}
 	scrub_free_bio(sbio->bio);
 	sbio->bio = NULL;
 	spin_lock(&sdev->list_lock);
@@ -830,7 +837,8 @@ out:
 }
 
 static int scrub_checksum_data(struct scrub_dev *sdev,
-			       struct scrub_page *spag, void *buffer)
+			       struct scrub_page *spag, void *buffer,
+			       int modify_stats)
 {
 	u8 csum[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
@@ -842,22 +850,21 @@ static int scrub_checksum_data(struct scrub_dev *sdev,
 
 	crc = btrfs_csum_data(root, buffer, crc, PAGE_SIZE);
 	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, spag->csum, sdev->csum_size))
+	if (memcmp(csum, spag->csum, sdev->csum_size)) {
 		fail = 1;
-
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.data_extents_scrubbed;
-	sdev->stat.data_bytes_scrubbed += PAGE_SIZE;
-	if (fail)
-		++sdev->stat.csum_errors;
-	spin_unlock(&sdev->stat_lock);
+		if (modify_stats) {
+			spin_lock(&sdev->stat_lock);
+			++sdev->stat.csum_errors;
+			spin_unlock(&sdev->stat_lock);
+		}
+	}
 
 	return fail;
 }
 
 static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 				     struct scrub_page *spag, u64 logical,
-				     void *buffer)
+				     void *buffer, int modify_stats)
 {
 	struct btrfs_header *h;
 	struct btrfs_root *root = sdev->dev->dev_root;
@@ -893,14 +900,17 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 	if (memcmp(csum, h->csum, sdev->csum_size))
 		++crc_fail;
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.tree_extents_scrubbed;
-	sdev->stat.tree_bytes_scrubbed += PAGE_SIZE;
-	if (crc_fail)
-		++sdev->stat.csum_errors;
-	if (fail)
-		++sdev->stat.verify_errors;
-	spin_unlock(&sdev->stat_lock);
+	if (modify_stats) {
+		if (crc_fail) {
+			spin_lock(&sdev->stat_lock);
+			++sdev->stat.csum_errors;
+			spin_unlock(&sdev->stat_lock);
+		} else if (fail) {
+			spin_lock(&sdev->stat_lock);
+			++sdev->stat.verify_errors;
+			spin_unlock(&sdev->stat_lock);
+		}
+	}
 
 	return fail || crc_fail;
 }
@@ -1106,6 +1116,17 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 		}
 		ret = scrub_page(sdev, logical, l, physical, flags, gen,
 				 mirror_num, have_csum ? csum : NULL, 0);
+		spin_lock(&sdev->stat_lock);
+		if (flags & BTRFS_EXTENT_FLAG_DATA) {
+			++sdev->stat.data_extents_scrubbed;
+			sdev->stat.data_bytes_scrubbed += l;
+		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+			++sdev->stat.tree_extents_scrubbed;
+			sdev->stat.tree_bytes_scrubbed += l;
+		} else {
+			WARN_ON(1);
+		}
+		spin_unlock(&sdev->stat_lock);
 		if (ret)
 			return ret;
 		len -= l;
-- 
1.7.3.4

