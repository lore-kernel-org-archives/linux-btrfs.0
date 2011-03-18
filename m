From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] btrfs scrub: make fixups sync, don't reuse fixup bios
Date: Fri, 18 Mar 2011 18:21:50 +0200
Message-ID: <20110318162150.GA31882@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[CC'ing the list to make development public, the patch is againt Arne's
tree at kernel.org]

Hello Arne,

Below is a quite long diff the primary purpose of which is to make
fixups totally sync.  They are already sync for checksum failures, this
patch makes them sync for EIO case as well.  This is required for
integrating drive swap, since the idea is that I have to fixup up
everyithing first and then write the correct data to a new device.
Obviously to do that fixups have to be sync.  The EIO is supposed to
happen quite rare, so the performance loose from making EIO sync should
be minimal.

The other significant change is that fixups are now sharing the buffer
with the parent sbio.  So instead of allocating a page to do a fixup, we
just grab the page from the sbio buffer.  This is also required for
drive swap, since when all the fixups are done, sbio buffer will contain
the right data which I can write to a new device using a single bio.  It
doesn't affect scrub at all.

The third change is that fixup bios are no longer reused.  This is a
change that I think should be added even if you don't like the rest.
You were right at the first place, bios cannot be reused that simply,
and since it's just a one page bio, it's better to allocate it each time
we need it.

Since fixups are now sync, I don't embed spage into a fixup structure.
Instead a pointer is used.

This is a preliminary version, it's meant to get us on the same page.
But if you can give this code some quick testing on real hardware with
your test cases I'd appreciate that.

I also plan to fix EIO handling in scrub_checksum, but that will happen
only next week.  My disk should arrive Monday-Tuesday + a couple days to
play with it.

I may have forgotten something, so ping me on IRC any time.  Also
disregard my debugging output at the end.

Thanks,

		Ilya

---

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 85a4d4b..f3fe5a5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -69,9 +69,6 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
                                      struct scrub_page *spag, u64 logical,
                                      void *buffer);
 static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
-static void scrub_recheck_end_io(struct bio *bio, int err);
-static void scrub_fixup_worker(scrub_work_t *work);
-static void scrub_fixup(struct scrub_fixup *fixup);
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
 #define SCRUB_BIOS_PER_DEV	16	/* 1 MB per device in flight */
@@ -117,13 +114,10 @@ struct scrub_dev {
 
 struct scrub_fixup {
 	struct scrub_dev	*sdev;
-	struct bio		*bio;
 	u64			logical;
 	u64			physical;
-	struct scrub_page	spag;
-	scrub_work_t		work;
-	int			err;
-	int			recheck;
+	struct page		*page;
+	struct scrub_page	*spag;
 };
 
 static void scrub_free_csums(struct scrub_dev *sdev)
@@ -230,115 +224,19 @@ nomem:
 	return ERR_PTR(-ENOMEM);
 }
 
-/*
- * scrub_recheck_error gets called when either verification of the page
- * failed or the bio failed to read, e.g. with EIO. In the latter case,
- * recheck_error gets called for every page in the bio, even though only
- * one may be bad
- */
-static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
-{
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
-	}
-
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
-}
-
 static int scrub_fixup_check(struct scrub_fixup *fixup)
 {
 	int ret = 1;
-	struct page *page;
 	void *buffer;
-	u64 flags = fixup->spag.flags;
+	u64 flags = fixup->spag->flags;
 
-	page = fixup->bio->bi_io_vec[0].bv_page;
-	buffer = kmap_atomic(page, KM_USER0);
+	buffer = kmap_atomic(fixup->page, KM_USER0);
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
 		ret = scrub_checksum_data(fixup->sdev,
-					  &fixup->spag, buffer);
+					  fixup->spag, buffer);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		ret = scrub_checksum_tree_block(fixup->sdev,
-						&fixup->spag,
+						fixup->spag,
 						fixup->logical,
 						buffer);
 	} else {
@@ -349,35 +247,34 @@ static int scrub_fixup_check(struct scrub_fixup *fixup)
 	return ret;
 }
 
-static void scrub_fixup_worker(scrub_work_t *work)
+static void scrub_fixup_end_io(struct bio *bio, int err)
 {
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
+	complete((struct completion *)bio->bi_private);
+}
 
-	if (ret || fixup->err)
-		scrub_fixup(fixup);
+static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+			 struct page *page)
+{
+	struct bio *bio = NULL;
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(complete);
 
-	__free_page(fixup->bio->bi_io_vec[0].bv_page);
-	bio_put(fixup->bio);
+	/* we are going to wait on this IO */
+	rw |= REQ_SYNC | REQ_UNPLUG;
 
-	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
+	bio = bio_alloc(GFP_NOFS, 1);
+	bio->bi_bdev = bdev;
+	bio->bi_sector = sector;
+	bio_add_page(bio, page, PAGE_SIZE, 0);
+	bio->bi_end_io = scrub_fixup_end_io;
+	bio->bi_private = &complete;
+	submit_bio(rw, bio);
 
-	kfree(fixup);
-}
+	wait_for_completion(&complete);
 
-static void scrub_fixup_end_io(struct bio *bio, int err)
-{
-	complete((struct completion *)bio->bi_private);
+	ret = !test_bit(BIO_UPTODATE, &bio->bi_flags);
+	bio_put(bio);
+	return ret;
 }
 
 static void scrub_fixup(struct scrub_fixup *fixup)
@@ -386,14 +283,13 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_multi_bio *multi = NULL;
-	struct bio *bio = fixup->bio;
 	u64 length;
 	int i;
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(complete);
 
-	if ((fixup->spag.flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    (fixup->spag.have_csum == 0)) {
+	if ((fixup->spag->flags & BTRFS_EXTENT_FLAG_DATA) &&
+	    (fixup->spag->have_csum == 0)) {
 		/*
 		 * nodatasum, don't try to fix anything
 		 * FIXME: we can do better, open the inode and trigger a
@@ -413,61 +309,38 @@ static void scrub_fixup(struct scrub_fixup *fixup)
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
+		if (i == fixup->spag->mirror_num)
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
+				   fixup->page)) {
 			/* I/O-error, this is not a good copy */
 			continue;
+		}
 
-		ret = scrub_fixup_check(fixup);
-		if (ret == 0)
+		if (scrub_fixup_check(fixup) == 0)
 			break;
 	}
 	if (i == multi->num_stripes)
 		goto uncorrectable;
 
 	/*
-	 * the bio now contains good data, write it back
+	 * fixup->page now contains good data, write it back
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
+			   fixup->physical >> 9, fixup->page)) {
 		/* I/O-error, writeback failed, give up */
 		goto uncorrectable;
+	}
 
 	kfree(multi);
 	spin_lock(&sdev->stat_lock);
@@ -490,6 +363,60 @@ uncorrectable:
 			 (unsigned long long)fixup->logical);
 }
 
+/*
+ * scrub_recheck_error gets called when either verification of the page
+ * failed or the bio failed to read, e.g. with EIO. In the latter case,
+ * recheck_error gets called for every page in the bio, even though only
+ * one may be bad
+ */
+static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
+{
+	struct scrub_dev *sdev = sbio->sdev;
+	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
+	struct scrub_fixup *fixup = NULL;
+
+	/*
+	 * while we're in here we do not want the transaction to commit.
+	 * To prevent it, we increment scrubs_running. scrub_pause will
+	 * have to wait until we're finished
+	 * we can safely increment scrubs_running here, because we're
+	 * in the context of the original bio which is still marked in_flight
+	 */
+	atomic_inc(&fs_info->scrubs_running);
+
+	fixup = kzalloc(sizeof(*fixup), GFP_NOFS);
+	if (!fixup) {
+		spin_lock(&sdev->stat_lock);
+		++sdev->stat.malloc_errors;
+		/* XXX - ++sdev->stat.uncorrectable_errors ? */
+		spin_unlock(&sdev->stat_lock);
+		goto out;
+	}
+
+	fixup->logical = sbio->logical + ix * PAGE_SIZE;
+	fixup->physical = sbio->physical + ix * PAGE_SIZE;
+	fixup->page = sbio->bio->bi_io_vec[ix].bv_page;
+	fixup->spag = sbio->spag + ix;
+	fixup->sdev = sdev;
+
+	if (sbio->err) {
+		if (scrub_fixup_io(READ, sdev->dev->bdev,
+				   fixup->physical >> 9,
+				   fixup->page) == 0) {
+			if (scrub_fixup_check(fixup) == 0)
+				goto done;
+		}
+	}
+
+	scrub_fixup(fixup);
+
+done:
+	kfree(fixup);
+out:
+	atomic_dec(&fs_info->scrubs_running);
+	wake_up(&fs_info->scrub_pause_wait);
+}
+
 static void scrub_bio_end_io(struct bio *bio, int err)
 {
 	struct scrub_bio *sbio = bio->bi_private;
@@ -1296,6 +1223,23 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_root *root)
 	mutex_unlock(&fs_info->scrub_lock);
 }
 
+static void print_scrub_full(struct btrfs_scrub_progress *sp)
+{
+	printk(KERN_INFO "\tdata_extents_scrubbed: %lld\n", sp->data_extents_scrubbed);
+	printk(KERN_INFO "\ttree_extents_scrubbed: %lld\n", sp->tree_extents_scrubbed);
+	printk(KERN_INFO "\tdata_bytes_scrubbed: %lld\n", sp->data_bytes_scrubbed);
+	printk(KERN_INFO "\ttree_bytes_scrubbed: %lld\n", sp->tree_bytes_scrubbed);
+	printk(KERN_INFO "\tread_errors: %lld\n", sp->read_errors);
+	printk(KERN_INFO "\tcsum_errors: %lld\n", sp->csum_errors);
+	printk(KERN_INFO "\tverify_errors: %lld\n", sp->verify_errors);
+	printk(KERN_INFO "\tno_csum: %lld\n", sp->no_csum);
+	printk(KERN_INFO "\tcsum_discards: %lld\n", sp->csum_discards);
+	printk(KERN_INFO "\tsuper_errors: %lld\n", sp->super_errors);
+	printk(KERN_INFO "\tmalloc_errors: %lld\n", sp->malloc_errors);
+	printk(KERN_INFO "\tuncorrectable_errors: %lld\n", sp->uncorrectable_errors);
+	printk(KERN_INFO "\tcorrected_errors: %lld\n", sp->corrected_errors);
+	printk(KERN_INFO "\tlast_physical: %lld\n", sp->last_physical);
+}
 
 int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
                     struct btrfs_scrub_progress *progress)
@@ -1308,6 +1252,9 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	if (root->fs_info->closing)
 		return -EINVAL;
 
+	printk(KERN_INFO "btrfs_scrub_dev start=%llu, end=%llu\n",
+		start, end);
+
 	/*
 	 * check some assumptions
 	 */
@@ -1360,8 +1307,10 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	atomic_dec(&fs_info->scrubs_running);
 	wake_up(&fs_info->scrub_pause_wait);
 
-	if (progress)
+	if (progress) {
 		memcpy(progress, &sdev->stat, sizeof(*progress));
+		print_scrub_full(progress);
+	}
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_device = NULL;
