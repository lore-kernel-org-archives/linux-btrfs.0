From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH v2] btrfs scrub - make fixups sync, don't reuse fixup bios
Date: Sat, 9 Apr 2011 14:27:01 +0300
Message-ID: <20110409112701.GA29836@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fixups are already sync for csum failures, this patch makes them sync
for EIO case as well.

Fixups are now sharing pages with the parent sbio - instead of
allocating a separate page to do a fixup we grab the page from the sbio
buffer.

Fixup bios are no longer reused.

struct fixup is no longer needed, instead pass [sbio pointer, index].

Originally this was added to look at the possibility of sharing the code
between drive swap and scrub, but it actually fixes a serious bug in
scrub code where errors that could be corrected were ignored and
reported as uncorrectable.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/scrub.c |  241 +++++++++++++++---------------------------------------
 1 files changed, 67 insertions(+), 174 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7c5eb21..e862167 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -60,7 +60,6 @@ typedef struct work_struct scrub_work_t;
 struct scrub_bio;
 struct scrub_page;
 struct scrub_dev;
-struct scrub_fixup;
 static void scrub_bio_end_io(struct bio *bio, int err);
 static void scrub_checksum(scrub_work_t *work);
 static int scrub_checksum_data(struct scrub_dev *sdev,
@@ -69,9 +68,11 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
                                      struct scrub_page *spag, u64 logical,
                                      void *buffer);
 static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
-static void scrub_recheck_end_io(struct bio *bio, int err);
-static void scrub_fixup_worker(scrub_work_t *work);
-static void scrub_fixup(struct scrub_fixup *fixup);
+static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
+static void scrub_fixup_end_io(struct bio *bio, int err);
+static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+                         struct page *page);
+static void scrub_fixup(struct scrub_bio *sbio, int ix);
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
 #define SCRUB_BIOS_PER_DEV	16	/* 1 MB per device in flight */
@@ -115,17 +116,6 @@ struct scrub_dev {
 	spinlock_t		stat_lock;
 };
 
-struct scrub_fixup {
-	struct scrub_dev	*sdev;
-	struct bio		*bio;
-	u64			logical;
-	u64			physical;
-	struct scrub_page	spag;
-	scrub_work_t		work;
-	int			err;
-	int			recheck;
-};
-
 static void scrub_free_csums(struct scrub_dev *sdev)
 {
 	while(!list_empty(&sdev->csum_list)) {
@@ -250,108 +240,34 @@ nomem:
  */
 static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
 {
-	struct scrub_dev *sdev = sbio->sdev;
-	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
-	struct bio *bio = NULL;
-	struct page *page = NULL;
-	struct scrub_fixup *fixup = NULL;
-	int ret;
-
-	/*
-	 * while we're in here we do not want the transaction to commit.
-	 * To prevent it, we increment scrubs_running. scrub_pause will
-	 * have to wait until we're finished
-	 * we can safely increment scrubs_running here, because we're
-	 * in the context of the original bio which is still marked in_flight
-	 */
-	atomic_inc(&fs_info->scrubs_running);
-
-	fixup = kzalloc(sizeof(*fixup), GFP_NOFS);
-	if (!fixup)
-		goto malloc_error;
-
-	fixup->logical = sbio->logical + ix * PAGE_SIZE;
-	fixup->physical = sbio->physical + ix * PAGE_SIZE;
-	fixup->spag = sbio->spag[ix];
-	fixup->sdev = sdev;
-
-	bio = bio_alloc(GFP_NOFS, 1);
-	if (!bio)
-		goto malloc_error;
-	bio->bi_private = fixup;
-	bio->bi_size = 0;
-	bio->bi_bdev = sdev->dev->bdev;
-	fixup->bio = bio;
-	fixup->recheck = 0;
-
-	page = alloc_page(GFP_NOFS);
-	if (!page)
-		goto malloc_error;
-
-	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
-	if (!ret)
-		goto malloc_error;
-
-	if (!sbio->err) {
-		/*
-		 * shorter path: just a checksum error, go ahead and correct it
-		 */
-		scrub_fixup_worker(&fixup->work);
-		return;
+	if (sbio->err) {
+		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev,
+				   (sbio->physical + ix * PAGE_SIZE) >> 9,
+				   sbio->bio->bi_io_vec[ix].bv_page) == 0) {
+			if (scrub_fixup_check(sbio, ix) == 0)
+				return;
+		}
 	}
 
-	/*
-	 * an I/O-error occured for one of the blocks in the bio, not
-	 * necessarily for this one, so first try to read it separately
-	 */
-	SCRUB_INIT_WORK(&fixup->work, scrub_fixup_worker);
-	fixup->recheck = 1;
-	bio->bi_end_io = scrub_recheck_end_io;
-	bio->bi_sector = fixup->physical >> 9;
-	bio->bi_bdev = sdev->dev->bdev;
-	submit_bio(0, bio);
-
-	return;
-
-malloc_error:
-	if (bio)
-		bio_put(bio);
-	if (page)
-		__free_page(page);
-	if (fixup)
-		kfree(fixup);
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.malloc_errors;
-	spin_unlock(&sdev->stat_lock);
-	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
-}
-
-static void scrub_recheck_end_io(struct bio *bio, int err)
-{
-	struct scrub_fixup *fixup = bio->bi_private;
-	struct btrfs_fs_info *fs_info = fixup->sdev->dev->dev_root->fs_info;
-
-	fixup->err = err;
-	SCRUB_QUEUE_WORK(fs_info->scrub_workers, &fixup->work);
+	scrub_fixup(sbio, ix);
 }
 
-static int scrub_fixup_check(struct scrub_fixup *fixup)
+static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
 {
 	int ret = 1;
 	struct page *page;
 	void *buffer;
-	u64 flags = fixup->spag.flags;
+	u64 flags = sbio->spag[ix].flags;
 
-	page = fixup->bio->bi_io_vec[0].bv_page;
+	page = sbio->bio->bi_io_vec[ix].bv_page;
 	buffer = kmap_atomic(page, KM_USER0);
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
-		ret = scrub_checksum_data(fixup->sdev,
-					  &fixup->spag, buffer);
+		ret = scrub_checksum_data(sbio->sdev,
+					  sbio->spag + ix, buffer);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		ret = scrub_checksum_tree_block(fixup->sdev,
-						&fixup->spag,
-						fixup->logical,
+		ret = scrub_checksum_tree_block(sbio->sdev,
+						sbio->spag + ix,
+						sbio->logical + ix * PAGE_SIZE,
 						buffer);
 	} else {
 		WARN_ON(1);
@@ -361,51 +277,25 @@ static int scrub_fixup_check(struct scrub_fixup *fixup)
 	return ret;
 }
 
-static void scrub_fixup_worker(scrub_work_t *work)
-{
-	struct scrub_fixup *fixup;
-	struct btrfs_fs_info *fs_info;
-	u64 flags;
-	int ret = 1;
-
-	fixup = container_of(work, struct scrub_fixup, work);
-	fs_info = fixup->sdev->dev->dev_root->fs_info;
-	flags = fixup->spag.flags;
-
-	if (fixup->recheck && fixup->err == 0)
-		ret = scrub_fixup_check(fixup);
-
-	if (ret || fixup->err)
-		scrub_fixup(fixup);
-
-	__free_page(fixup->bio->bi_io_vec[0].bv_page);
-	bio_put(fixup->bio);
-
-	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
-
-	kfree(fixup);
-}
-
 static void scrub_fixup_end_io(struct bio *bio, int err)
 {
 	complete((struct completion *)bio->bi_private);
 }
 
-static void scrub_fixup(struct scrub_fixup *fixup)
+static void scrub_fixup(struct scrub_bio *sbio, int ix)
 {
-	struct scrub_dev *sdev = fixup->sdev;
+	struct scrub_dev *sdev = sbio->sdev;
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_multi_bio *multi = NULL;
-	struct bio *bio = fixup->bio;
+	u64 logical = sbio->logical + ix * PAGE_SIZE;
 	u64 length;
 	int i;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(complete);
 
-	if ((fixup->spag.flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    (fixup->spag.have_csum == 0)) {
+	if ((sbio->spag[ix].flags & BTRFS_EXTENT_FLAG_DATA) &&
+	    (sbio->spag[ix].have_csum == 0)) {
 		/*
 		 * nodatasum, don't try to fix anything
 		 * FIXME: we can do better, open the inode and trigger a
@@ -415,71 +305,49 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 	}
 
 	length = PAGE_SIZE;
-	ret = btrfs_map_block(map_tree, REQ_WRITE, fixup->logical, &length,
+	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
 	                      &multi, 0);
 	if (ret || !multi || length < PAGE_SIZE) {
 		printk(KERN_ERR
 		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
-		       (unsigned long long)fixup->logical);
+		       (unsigned long long)logical);
 		WARN_ON(1);
 		return;
 	}
 
-	if (multi->num_stripes == 1) {
+	if (multi->num_stripes == 1)
 		/* there aren't any replicas */
 		goto uncorrectable;
-	}
 
 	/*
 	 * first find a good copy
 	 */
 	for (i = 0; i < multi->num_stripes; ++i) {
-		if (i == fixup->spag.mirror_num)
+		if (i == sbio->spag[ix].mirror_num)
 			continue;
 
-		bio->bi_sector = multi->stripes[i].physical >> 9;
-		bio->bi_bdev = multi->stripes[i].dev->bdev;
-		bio->bi_size = PAGE_SIZE;
-		bio->bi_next = NULL;
-		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_comp_cpu = -1;
-		bio->bi_end_io = scrub_fixup_end_io;
-		bio->bi_private = &complete;
-
-		submit_bio(0, bio);
-
-		wait_for_completion(&complete);
-
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		if (scrub_fixup_io(READ, multi->stripes[i].dev->bdev,
+				   multi->stripes[i].physical >> 9,
+				   sbio->bio->bi_io_vec[ix].bv_page)) {
 			/* I/O-error, this is not a good copy */
 			continue;
+		}
 
-		ret = scrub_fixup_check(fixup);
-		if (ret == 0)
+		if (scrub_fixup_check(sbio, ix) == 0)
 			break;
 	}
 	if (i == multi->num_stripes)
 		goto uncorrectable;
 
 	/*
-	 * the bio now contains good data, write it back
+	 * bi_io_vec[ix].bv_page now contains good data, write it back
 	 */
-	bio->bi_sector = fixup->physical >> 9;
-	bio->bi_bdev = sdev->dev->bdev;
-	bio->bi_size = PAGE_SIZE;
-	bio->bi_next = NULL;
-	bio->bi_flags |= 1 << BIO_UPTODATE;
-	bio->bi_comp_cpu = -1;
-	bio->bi_end_io = scrub_fixup_end_io;
-	bio->bi_private = &complete;
-
-	submit_bio(REQ_WRITE, bio);
-
-	wait_for_completion(&complete);
-
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (scrub_fixup_io(WRITE, sdev->dev->bdev,
+			   (sbio->physical + ix * PAGE_SIZE) >> 9,
+			   sbio->bio->bi_io_vec[ix].bv_page)) {
 		/* I/O-error, writeback failed, give up */
 		goto uncorrectable;
+	}
 
 	kfree(multi);
 	spin_lock(&sdev->stat_lock);
@@ -488,7 +356,7 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 
 	if (printk_ratelimit())
 		printk(KERN_ERR "btrfs: fixed up at %llu\n",
-		       (unsigned long long)fixup->logical);
+		       (unsigned long long)logical);
 	return;
 
 uncorrectable:
@@ -499,7 +367,32 @@ uncorrectable:
 
 	if (printk_ratelimit())
 		printk(KERN_ERR "btrfs: unable to fixup at %llu\n",
-			 (unsigned long long)fixup->logical);
+			 (unsigned long long)logical);
+}
+
+static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+			 struct page *page)
+{
+	struct bio *bio = NULL;
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(complete);
+
+	/* we are going to wait on this IO */
+	rw |= REQ_SYNC | REQ_UNPLUG;
+
+	bio = bio_alloc(GFP_NOFS, 1);
+	bio->bi_bdev = bdev;
+	bio->bi_sector = sector;
+	bio_add_page(bio, page, PAGE_SIZE, 0);
+	bio->bi_end_io = scrub_fixup_end_io;
+	bio->bi_private = &complete;
+	submit_bio(rw, bio);
+
+	wait_for_completion(&complete);
+
+	ret = !test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bio_put(bio);
+	return ret;
 }
 
 static void scrub_bio_end_io(struct bio *bio, int err)
-- 
1.7.2.5

