From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 1/3] Btrfs: add device counters for detected IO and checksum errors
Date: Wed, 21 Dec 2011 17:05:08 +0100
Message-ID: <c0679c8e1b218c947b6f17fc1300bfd8c8cebcb4.1324480889.git.sbehrens@giantdisaster.de>
References: <4EE602E1.4020206@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE602E1.4020206@giantdisaster.de>
In-Reply-To: <cover.1324480889.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c   |   18 +++++++++++---
 fs/btrfs/extent_io.c |   27 ++++++++++++++++++++-
 fs/btrfs/scrub.c     |   52 +++++++++++++++++++++++++++++++++++-------
 fs/btrfs/volumes.c   |   61 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h   |   21 +++++++++++++++++
 5 files changed, 161 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3f9d555..905f1fa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2502,18 +2502,24 @@ recovery_tree_root:
 
 static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
+		struct btrfs_device *device = (struct btrfs_device *)
+			(((uintptr_t)bh->b_private) & ~((uintptr_t)1));
+		unsigned int with_flush = ((uintptr_t)bh->b_private) & 1;
+
 		printk_ratelimited(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
+				   "I/O error on %s\n", device->name);
 		/* note, we dont' set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
 		clear_buffer_uptodate(bh);
+		btrfs_device_stat_inc(&device->cnt_write_io_errs);
+		if (with_flush)
+			btrfs_device_stat_inc(&device->cnt_flush_io_errs);
+		device->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(device);
 	}
 	unlock_buffer(bh);
 	put_bh(bh);
@@ -2628,6 +2634,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			set_buffer_uptodate(bh);
 			lock_buffer(bh);
 			bh->b_end_io = btrfs_end_buffer_write_sync;
+			bh->b_private = device;
 		}
 
 		/*
@@ -2686,6 +2693,9 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 		}
 		if (!bio_flagged(bio, BIO_UPTODATE)) {
 			ret = -EIO;
+			btrfs_device_stat_inc(&device->cnt_flush_io_errs);
+			device->device_stats_dirty = 1;
+			btrfs_device_stat_print_on_error(device);
 		}
 
 		/* drop the reference from the wait == 0 run */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 49f3c9d..e6bf7ee 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1901,6 +1901,9 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
+		btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+		dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(dev);
 		return -EIO;
 	}
 
@@ -2287,10 +2290,30 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state);
-			if (ret)
+			if (ret) {
+				/* no IO indicated but software detected errors
+				 * in the block, either checksum errros or
+				 * issues with the contents */
+				int failed_mirror = (int)(uintptr_t)
+						    bio->bi_bdev;
+				struct btrfs_root *root =
+					BTRFS_I(page->mapping->host)->root;
+				struct btrfs_device *device;
+
 				uptodate = 0;
-			else
+				device = btrfs_find_device_for_logical(
+						root, start,
+						(int)failed_mirror);
+				if (device) {
+					btrfs_device_stat_inc(
+						&device->cnt_corruption_errs);
+					device->device_stats_dirty = 1;
+					btrfs_device_stat_print_on_error(
+						device);
+				}
+			} else {
 				clean_io_failure(start, page);
+			}
 		}
 		if (!uptodate) {
 			int failed_mirror;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ddf2c90..07fbbef 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -54,7 +54,7 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
 static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
 static void scrub_fixup_end_io(struct bio *bio, int err);
-static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+static int scrub_fixup_io(int rw, struct btrfs_device *dev, sector_t sector,
 			  struct page *page);
 static void scrub_fixup(struct scrub_bio *sbio, int ix);
 
@@ -561,7 +561,7 @@ static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
 					DEFAULT_RATELIMIT_BURST);
 
 	if (sbio->err) {
-		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev, sector,
+		if (scrub_fixup_io(READ, sbio->sdev->dev, sector,
 				   sbio->bio->bi_io_vec[ix].bv_page) == 0) {
 			if (scrub_fixup_check(sbio, ix) == 0)
 				return 0;
@@ -675,7 +675,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		if (i + 1 == sbio->spag[ix].mirror_num)
 			continue;
 
-		if (scrub_fixup_io(READ, bbio->stripes[i].dev->bdev,
+		if (scrub_fixup_io(READ, bbio->stripes[i].dev,
 				   bbio->stripes[i].physical >> 9,
 				   sbio->bio->bi_io_vec[ix].bv_page)) {
 			/* I/O-error, this is not a good copy */
@@ -692,7 +692,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		/*
 		 * bi_io_vec[ix].bv_page now contains good data, write it back
 		 */
-		if (scrub_fixup_io(WRITE, sdev->dev->bdev,
+		if (scrub_fixup_io(WRITE, sdev->dev,
 				   (sbio->physical + ix * PAGE_SIZE) >> 9,
 				   sbio->bio->bi_io_vec[ix].bv_page)) {
 			/* I/O-error, writeback failed, give up */
@@ -719,7 +719,7 @@ uncorrectable:
 				"logical %llu\n", (unsigned long long)logical);
 }
 
-static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+static int scrub_fixup_io(int rw, struct btrfs_device *dev, sector_t sector,
 			 struct page *page)
 {
 	struct bio *bio = NULL;
@@ -727,7 +727,7 @@ static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(complete);
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_bdev = bdev;
+	bio->bi_bdev = dev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio->bi_end_io = scrub_fixup_end_io;
@@ -738,6 +738,16 @@ static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
 	wait_for_completion(&complete);
 
 	ret = !test_bit(BIO_UPTODATE, &bio->bi_flags);
+	if (ret) {
+		if (bio->bi_rw & WRITE)
+			btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+		else
+			btrfs_device_stat_inc(&dev->cnt_read_io_errs);
+		if (WRITE_FLUSH == (bio->bi_rw & WRITE_FLUSH))
+			btrfs_device_stat_inc(&dev->cnt_flush_io_errs);
+		dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(dev);
+	}
 	bio_put(bio);
 	return ret;
 }
@@ -748,6 +758,18 @@ static void scrub_bio_end_io(struct bio *bio, int err)
 	struct scrub_dev *sdev = sbio->sdev;
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
 
+	if (-EIO == err || -EREMOTEIO == err) {
+		struct btrfs_device *dev = sdev->dev;
+
+		if (bio->bi_rw & WRITE)
+			btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+		else
+			btrfs_device_stat_inc(&dev->cnt_read_io_errs);
+		if (WRITE_FLUSH == (bio->bi_rw & WRITE_FLUSH))
+			btrfs_device_stat_inc(&dev->cnt_flush_io_errs);
+		dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(dev);
+	}
 	sbio->err = err;
 	sbio->bio = bio;
 
@@ -846,8 +868,12 @@ static int scrub_checksum_data(struct scrub_dev *sdev,
 	spin_lock(&sdev->stat_lock);
 	++sdev->stat.data_extents_scrubbed;
 	sdev->stat.data_bytes_scrubbed += PAGE_SIZE;
-	if (fail)
+	if (fail) {
 		++sdev->stat.csum_errors;
+		btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
+	}
 	spin_unlock(&sdev->stat_lock);
 
 	return fail;
@@ -894,8 +920,12 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 	spin_lock(&sdev->stat_lock);
 	++sdev->stat.tree_extents_scrubbed;
 	sdev->stat.tree_bytes_scrubbed += PAGE_SIZE;
-	if (crc_fail)
+	if (crc_fail) {
 		++sdev->stat.csum_errors;
+		btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
+	}
 	if (fail)
 		++sdev->stat.verify_errors;
 	spin_unlock(&sdev->stat_lock);
@@ -929,8 +959,12 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 	crc = btrfs_csum_data(root, buffer + BTRFS_CSUM_SIZE, crc,
 			      PAGE_SIZE - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, s->csum, sbio->sdev->csum_size))
+	if (memcmp(csum, s->csum, sdev->csum_size)) {
 		++fail;
+		btrfs_device_stat_inc(&sdev->dev->cnt_corruption_errs);
+		sdev->dev->device_stats_dirty = 1;
+		btrfs_device_stat_print_on_error(sdev->dev);
+	}
 
 	if (fail) {
 		/*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4b839f..7681477 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -23,6 +23,7 @@
 #include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
+#include <linux/ratelimit.h>
 #include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
@@ -3241,11 +3242,28 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 
 static void btrfs_end_bio(struct bio *bio, int err)
 {
-	struct btrfs_bio *bbio = bio->bi_private;
+	struct btrfs_bio *bbio = (struct btrfs_bio *)
+		(((uintptr_t)bio->bi_private) & ~((uintptr_t)3));
+	unsigned int dev_nr = ((uintptr_t)bio->bi_private) & 3;
 	int is_orig_bio = 0;
 
-	if (err)
+	if (err) {
 		atomic_inc(&bbio->error);
+		if (-EIO == err || -EREMOTEIO == err) {
+			struct btrfs_device *dev;
+
+			BUG_ON(dev_nr >= bbio->num_stripes);
+			dev = bbio->stripes[dev_nr].dev;
+			if (bio->bi_rw & WRITE)
+				btrfs_device_stat_inc(&dev->cnt_write_io_errs);
+			else
+				btrfs_device_stat_inc(&dev->cnt_read_io_errs);
+			if (WRITE_FLUSH == (bio->bi_rw & WRITE_FLUSH))
+				btrfs_device_stat_inc(&dev->cnt_flush_io_errs);
+			dev->device_stats_dirty = 1;
+			btrfs_device_stat_print_on_error(dev);
+		}
+	}
 
 	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
@@ -3386,7 +3404,9 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		} else {
 			bio = first_bio;
 		}
-		bio->bi_private = bbio;
+		BUG_ON(0 != (((uintptr_t)bbio) & 3));
+		BUG_ON(dev_nr > 3);
+		bio->bi_private = (void *)(((uintptr_t)bbio) | dev_nr);
 		bio->bi_end_io = btrfs_end_bio;
 		bio->bi_sector = bbio->stripes[dev_nr].physical >> 9;
 		dev = bbio->stripes[dev_nr].dev;
@@ -3734,6 +3754,28 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	return ret;
 }
 
+struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
+						   u64 logical, int mirror_num)
+{
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	int ret;
+	u64 map_length = 0;
+	struct btrfs_bio *bbio = NULL;
+	struct btrfs_device *device;
+
+	BUG_ON(0 == mirror_num);
+	ret = btrfs_map_block(map_tree, WRITE, logical, &map_length, &bbio,
+			      mirror_num);
+	if (ret) {
+		BUG_ON(NULL != bbio);
+		return NULL;
+	}
+	BUG_ON(mirror_num != bbio->mirror_num);
+	device = bbio->stripes[mirror_num - 1].dev;
+	kfree(bbio);
+	return device;
+}
+
 int btrfs_read_chunk_tree(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
@@ -3802,3 +3844,16 @@ error:
 	btrfs_free_path(path);
 	return ret;
 }
+
+void btrfs_device_stat_print_on_error(struct btrfs_device *device)
+{
+	printk_ratelimited(KERN_ERR "btrfs: bdev %s errs: wr %u, rd %u,"
+			   " flush %u, corrupt %u, gen %u\n",
+			   device->name,
+			   btrfs_device_stat_read(&device->cnt_write_io_errs),
+			   btrfs_device_stat_read(&device->cnt_read_io_errs),
+			   btrfs_device_stat_read(&device->cnt_flush_io_errs),
+			   btrfs_device_stat_read(&device->cnt_corruption_errs),
+			   btrfs_device_stat_read(
+				&device->cnt_generation_errs));
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 78f2d4d..51ad850 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -106,6 +106,14 @@ struct btrfs_device {
 	struct completion flush_wait;
 	int nobarriers;
 
+	/* disk I/O failure stats. For detailed description refer to
+	 * struct btrfs_device_stats_item in ctree.h */
+	int device_stats_dirty; /* counters need to be written to disk */
+	atomic_t cnt_write_io_errs;
+	atomic_t cnt_read_io_errs;
+	atomic_t cnt_flush_io_errs;
+	atomic_t cnt_corruption_errs;
+	atomic_t cnt_generation_errs;
 };
 
 struct btrfs_fs_devices {
@@ -233,4 +241,17 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
+						   u64 logical, int mirror_num);
+void btrfs_device_stat_print_on_error(struct btrfs_device *device);
+
+static inline void btrfs_device_stat_inc(atomic_t *cnt)
+{
+	atomic_inc(cnt);
+}
+
+static inline int btrfs_device_stat_read(atomic_t *cnt)
+{
+	return atomic_read(cnt);
+}
 #endif
-- 
1.7.3.4

