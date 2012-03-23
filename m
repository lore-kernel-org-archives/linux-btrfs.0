From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 3/3] Btrfs: change scrub to support big blocks
Date: Fri, 23 Mar 2012 15:59:10 +0100
Message-ID: <516c018a14d9b1fb9063ce2bc36b9d11f1cc76bd.1332513438.git.sbehrens@giantdisaster.de>
References: <cover.1332513438.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Scrub used to be coded for nodesize == leafsize == sectorsize == PAGE_SIZE.
This is now changed to support sizes for nodesize and leafsize which are
N * PAGE_SIZE.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 1353 ++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 1013 insertions(+), 340 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e68bab4..5221e07 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -40,16 +40,26 @@
  *  - add a mode to also read unallocated space
  */
 
+struct scrub_block;
 struct scrub_dev;
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
 #define SCRUB_BIOS_PER_DEV	16	/* 1 MB per device in flight */
+#define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
 struct scrub_page {
+	struct scrub_block	*sblock;
+	struct page		*page;
+	struct block_device	*bdev;
 	u64			flags;  /* extent flags */
 	u64			generation;
-	int			mirror_num;
-	int			have_csum;
+	u64			logical;
+	u64			physical;
+	struct {
+		unsigned int	mirror_num:8;
+		unsigned int	have_csum:1;
+		unsigned int	io_error:1;
+	};
 	u8			csum[BTRFS_CSUM_SIZE];
 };
 
@@ -60,12 +70,25 @@ struct scrub_bio {
 	int			err;
 	u64			logical;
 	u64			physical;
-	struct scrub_page	spag[SCRUB_PAGES_PER_BIO];
-	u64			count;
+	struct scrub_page	*pagev[SCRUB_PAGES_PER_BIO];
+	int			page_count;
 	int			next_free;
 	struct btrfs_work	work;
 };
 
+struct scrub_block {
+	struct scrub_page	pagev[SCRUB_MAX_PAGES_PER_BLOCK];
+	int			page_count;
+	atomic_t		outstanding_pages;
+	atomic_t		ref_count; /* free mem on transition to zero */
+	struct scrub_dev	*sdev;
+	struct {
+		unsigned int	header_error:1;
+		unsigned int	checksum_error:1;
+		unsigned int	no_io_error_seen:1;
+	};
+};
+
 struct scrub_dev {
 	struct scrub_bio	*bios[SCRUB_BIOS_PER_DEV];
 	struct btrfs_device	*dev;
@@ -79,6 +102,10 @@ struct scrub_dev {
 	struct list_head	csum_list;
 	atomic_t		cancel_req;
 	int			readonly;
+	int			pages_per_bio; /* <= SCRUB_PAGES_PER_BIO */
+	u32			sectorsize;
+	u32			nodesize;
+	u32			leafsize;
 	/*
 	 * statistics
 	 */
@@ -107,19 +134,41 @@ struct scrub_warning {
 	int			scratch_bufsize;
 };
 
+
+static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
+static int scrub_setup_recheck_block(struct scrub_dev *sdev,
+				     struct btrfs_mapping_tree *map_tree,
+				     u64 length, u64 logical,
+				     struct scrub_block *sblock);
+static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
+			       struct scrub_block *sblock, int is_metadata,
+			       int have_csum, u8 *csum, u64 generation,
+			       u16 csum_size);
+static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
+					 struct scrub_block *sblock,
+					 int is_metadata, int have_csum,
+					 const u8 *csum, u64 generation,
+					 u16 csum_size);
+static void scrub_complete_bio_end_io(struct bio *bio, int err);
+static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
+					     struct scrub_block *sblock_good,
+					     int force_write);
+static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
+					    struct scrub_block *sblock_good,
+					    int page_num, int force_write);
+static int scrub_checksum_data(struct scrub_block *sblock);
+static int scrub_checksum_tree_block(struct scrub_block *sblock);
+static int scrub_checksum_super(struct scrub_block *sblock);
+static void scrub_block_get(struct scrub_block *sblock);
+static void scrub_block_put(struct scrub_block *sblock);
+static int scrub_add_page_to_bio(struct scrub_dev *sdev,
+				 struct scrub_page *spage);
+static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
+		       u64 physical, u64 flags, u64 gen, int mirror_num,
+		       u8 *csum, int force);
 static void scrub_bio_end_io(struct bio *bio, int err);
-static void scrub_checksum(struct btrfs_work *work);
-static int scrub_checksum_data(struct scrub_dev *sdev,
-			       struct scrub_page *spag, void *buffer);
-static int scrub_checksum_tree_block(struct scrub_dev *sdev,
-				     struct scrub_page *spag, u64 logical,
-				     void *buffer);
-static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
-static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
-static void scrub_fixup_end_io(struct bio *bio, int err);
-static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
-			  struct page *page);
-static void scrub_fixup(struct scrub_bio *sbio, int ix);
+static void scrub_bio_end_io_worker(struct btrfs_work *work);
+static void scrub_block_complete(struct scrub_block *sblock);
 
 
 static void scrub_free_csums(struct scrub_dev *sdev)
@@ -133,23 +182,6 @@ static void scrub_free_csums(struct scrub_dev *sdev)
 	}
 }
 
-static void scrub_free_bio(struct bio *bio)
-{
-	int i;
-	struct page *last_page = NULL;
-
-	if (!bio)
-		return;
-
-	for (i = 0; i < bio->bi_vcnt; ++i) {
-		if (bio->bi_io_vec[i].bv_page == last_page)
-			continue;
-		last_page = bio->bi_io_vec[i].bv_page;
-		__free_page(last_page);
-	}
-	bio_put(bio);
-}
-
 static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
 {
 	int i;
@@ -157,13 +189,23 @@ static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
 	if (!sdev)
 		return;
 
+	/* this can happen when scrub is cancelled */
+	if (sdev->curr != -1) {
+		struct scrub_bio *sbio = sdev->bios[sdev->curr];
+
+		for (i = 0; i < sbio->page_count; i++) {
+			BUG_ON(!sbio->pagev[i]);
+			BUG_ON(!sbio->pagev[i]->page);
+			scrub_block_put(sbio->pagev[i]->sblock);
+		}
+		bio_put(sbio->bio);
+	}
+
 	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
 		struct scrub_bio *sbio = sdev->bios[i];
 
 		if (!sbio)
 			break;
-
-		scrub_free_bio(sbio->bio);
 		kfree(sbio);
 	}
 
@@ -177,11 +219,16 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 	struct scrub_dev *sdev;
 	int		i;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
+	int pages_per_bio;
 
+	pages_per_bio = min_t(int, SCRUB_PAGES_PER_BIO,
+			      bio_get_nr_vecs(dev->bdev));
 	sdev = kzalloc(sizeof(*sdev), GFP_NOFS);
 	if (!sdev)
 		goto nomem;
 	sdev->dev = dev;
+	sdev->pages_per_bio = pages_per_bio;
+	sdev->curr = -1;
 	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
 		struct scrub_bio *sbio;
 
@@ -192,8 +239,8 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 
 		sbio->index = i;
 		sbio->sdev = sdev;
-		sbio->count = 0;
-		sbio->work.func = scrub_checksum;
+		sbio->page_count = 0;
+		sbio->work.func = scrub_bio_end_io_worker;
 
 		if (i != SCRUB_BIOS_PER_DEV-1)
 			sdev->bios[i]->next_free = i + 1;
@@ -201,7 +248,9 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 			sdev->bios[i]->next_free = -1;
 	}
 	sdev->first_free = 0;
-	sdev->curr = -1;
+	sdev->nodesize = dev->dev_root->nodesize;
+	sdev->leafsize = dev->dev_root->leafsize;
+	sdev->sectorsize = dev->dev_root->sectorsize;
 	atomic_set(&sdev->in_flight, 0);
 	atomic_set(&sdev->fixup_cnt, 0);
 	atomic_set(&sdev->cancel_req, 0);
@@ -292,10 +341,9 @@ err:
 	return 0;
 }
 
-static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
-				int ix)
+static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 {
-	struct btrfs_device *dev = sbio->sdev->dev;
+	struct btrfs_device *dev = sblock->sdev->dev;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_key found_key;
@@ -314,8 +362,9 @@ static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
 
 	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
 	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
-	swarn.sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
-	swarn.logical = sbio->logical + ix * PAGE_SIZE;
+	BUG_ON(sblock->page_count < 1);
+	swarn.sector = (sblock->pagev[0].physical) >> 9;
+	swarn.logical = sblock->pagev[0].logical;
 	swarn.errstr = errstr;
 	swarn.dev = dev;
 	swarn.msg_bufsize = bufsize;
@@ -530,9 +579,9 @@ out:
 		spin_lock(&sdev->stat_lock);
 		++sdev->stat.uncorrectable_errors;
 		spin_unlock(&sdev->stat_lock);
-		printk_ratelimited(KERN_ERR "btrfs: unable to fixup "
-					"(nodatasum) error at logical %llu\n",
-					fixup->logical);
+		printk_ratelimited(KERN_ERR
+			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
+			(unsigned long long)fixup->logical, sdev->dev->name);
 	}
 
 	btrfs_free_path(path);
@@ -549,91 +598,168 @@ out:
 }
 
 /*
- * scrub_recheck_error gets called when either verification of the page
- * failed or the bio failed to read, e.g. with EIO. In the latter case,
- * recheck_error gets called for every page in the bio, even though only
- * one may be bad
+ * scrub_handle_errored_block gets called when either verification of the
+ * pages failed or the bio failed to read, e.g. with EIO. In the latter
+ * case, this function handles all pages in the bio, even though only one
+ * may be bad.
+ * The goal of this function is to repair the errored block by using the
+ * contents of one of the mirrors.
  */
-static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
+static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 {
-	struct scrub_dev *sdev = sbio->sdev;
-	u64 sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
+	struct scrub_dev *sdev = sblock_to_check->sdev;
+	struct btrfs_fs_info *fs_info;
+	u64 length;
+	u64 logical;
+	u64 generation;
+	unsigned int failed_mirror_index;
+	unsigned int is_metadata;
+	unsigned int have_csum;
+	u8 *csum;
+	struct scrub_block *sblocks_for_recheck; /* holds one for each mirror */
+	struct scrub_block *sblock_bad;
+	int ret;
+	int mirror_index;
+	int page_num;
+	int success;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
-					DEFAULT_RATELIMIT_BURST);
+				      DEFAULT_RATELIMIT_BURST);
+
+	BUG_ON(sblock_to_check->page_count < 1);
+	fs_info = sdev->dev->dev_root->fs_info;
+	length = sblock_to_check->page_count * PAGE_SIZE;
+	logical = sblock_to_check->pagev[0].logical;
+	generation = sblock_to_check->pagev[0].generation;
+	BUG_ON(sblock_to_check->pagev[0].mirror_num < 1);
+	failed_mirror_index = sblock_to_check->pagev[0].mirror_num - 1;
+	is_metadata = !(sblock_to_check->pagev[0].flags &
+			BTRFS_EXTENT_FLAG_DATA);
+	have_csum = sblock_to_check->pagev[0].have_csum;
+	csum = sblock_to_check->pagev[0].csum;
 
-	if (sbio->err) {
-		if (scrub_fixup_io(READ, sbio->sdev->dev->bdev, sector,
-				   sbio->bio->bi_io_vec[ix].bv_page) == 0) {
-			if (scrub_fixup_check(sbio, ix) == 0)
-				return 0;
-		}
-		if (__ratelimit(&_rs))
-			scrub_print_warning("i/o error", sbio, ix);
-	} else {
-		if (__ratelimit(&_rs))
-			scrub_print_warning("checksum error", sbio, ix);
+	/*
+	 * read all mirrors one after the other. This includes to
+	 * re-read the extent or metadata block that failed (that was
+	 * the cause that this fixup code is called) another time,
+	 * page by page this time in order to know which pages
+	 * caused I/O errors and which ones are good (for all mirrors).
+	 * It is the goal to handle the situation when more than one
+	 * mirror contains I/O errors, but the errors do not
+	 * overlap, i.e. the data can be repaired by selecting the
+	 * pages from those mirrors without I/O error on the
+	 * particular pages. One example (with blocks >= 2 * PAGE_SIZE)
+	 * would be that mirror #1 has an I/O error on the first page,
+	 * the second page is good, and mirror #2 has an I/O error on
+	 * the second page, but the first page is good.
+	 * Then the first page of the first mirror can be repaired by
+	 * taking the first page of the second mirror, and the
+	 * second page of the second mirror can be repaired by
+	 * copying the contents of the 2nd page of the 1st mirror.
+	 * One more note: if the pages of one mirror contain I/O
+	 * errors, the checksum cannot be verified. In order to get
+	 * the best data for repairing, the first attempt is to find
+	 * a mirror without I/O errors and with a validated checksum.
+	 * Only if this is not possible, the pages are picked from
+	 * mirrors with I/O errors without considering the checksum.
+	 * If the latter is the case, at the end, the checksum of the
+	 * repaired area is verified in order to correctly maintain
+	 * the statistics.
+	 */
+
+	sblocks_for_recheck = kzalloc(BTRFS_MAX_MIRRORS *
+				     sizeof(*sblocks_for_recheck),
+				     GFP_NOFS);
+	if (!sblocks_for_recheck) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.malloc_errors++;
+		sdev->stat.read_errors++;
+		sdev->stat.uncorrectable_errors++;
+		spin_unlock(&sdev->stat_lock);
+		goto out;
 	}
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.read_errors;
-	spin_unlock(&sdev->stat_lock);
+	/* setup the context, map the logical blocks and alloc the pages */
+	ret = scrub_setup_recheck_block(sdev, &fs_info->mapping_tree, length,
+					logical, sblocks_for_recheck);
+	if (ret) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.read_errors++;
+		sdev->stat.uncorrectable_errors++;
+		spin_unlock(&sdev->stat_lock);
+		goto out;
+	}
+	BUG_ON(failed_mirror_index >= BTRFS_MAX_MIRRORS);
+	sblock_bad = sblocks_for_recheck + failed_mirror_index;
 
-	scrub_fixup(sbio, ix);
-	return 1;
-}
+	/* build and submit the bios for the failed mirror, check checksums */
+	ret = scrub_recheck_block(fs_info, sblock_bad, is_metadata, have_csum,
+				  csum, generation, sdev->csum_size);
+	if (ret) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.read_errors++;
+		sdev->stat.uncorrectable_errors++;
+		spin_unlock(&sdev->stat_lock);
+		goto out;
+	}
 
-static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
-{
-	int ret = 1;
-	struct page *page;
-	void *buffer;
-	u64 flags = sbio->spag[ix].flags;
+	if (!sblock_bad->header_error && !sblock_bad->checksum_error &&
+	    sblock_bad->no_io_error_seen) {
+		/*
+		 * the error disappeared after reading page by page, or
+		 * the area was part of a huge bio and other parts of the
+		 * bio caused I/O errors, or the block layer merged several
+		 * read requests into one and the error is caused by a
+		 * different bio (usually one of the two latter cases is
+		 * the cause)
+		 */
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.unverified_errors++;
+		spin_unlock(&sdev->stat_lock);
 
-	page = sbio->bio->bi_io_vec[ix].bv_page;
-	buffer = kmap_atomic(page, KM_USER0);
-	if (flags & BTRFS_EXTENT_FLAG_DATA) {
-		ret = scrub_checksum_data(sbio->sdev,
-					  sbio->spag + ix, buffer);
-	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		ret = scrub_checksum_tree_block(sbio->sdev,
-						sbio->spag + ix,
-						sbio->logical + ix * PAGE_SIZE,
-						buffer);
-	} else {
-		WARN_ON(1);
+		goto out;
 	}
-	kunmap_atomic(buffer, KM_USER0);
 
-	return ret;
-}
+	if (!sblock_bad->no_io_error_seen) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.read_errors++;
+		spin_unlock(&sdev->stat_lock);
+		if (__ratelimit(&_rs))
+			scrub_print_warning("i/o error", sblock_to_check);
+	} else if (sblock_bad->checksum_error) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.csum_errors++;
+		spin_unlock(&sdev->stat_lock);
+		if (__ratelimit(&_rs))
+			scrub_print_warning("checksum error", sblock_to_check);
+	} else if (sblock_bad->header_error) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.verify_errors++;
+		spin_unlock(&sdev->stat_lock);
+		if (__ratelimit(&_rs))
+			scrub_print_warning("checksum/header error",
+					    sblock_to_check);
+	}
 
-static void scrub_fixup_end_io(struct bio *bio, int err)
-{
-	complete((struct completion *)bio->bi_private);
-}
+	if (sdev->readonly)
+		goto did_not_correct_error;
+
+	if (!is_metadata && !have_csum) {
+		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
-static void scrub_fixup(struct scrub_bio *sbio, int ix)
-{
-	struct scrub_dev *sdev = sbio->sdev;
-	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
-	struct btrfs_bio *bbio = NULL;
-	struct scrub_fixup_nodatasum *fixup;
-	u64 logical = sbio->logical + ix * PAGE_SIZE;
-	u64 length;
-	int i;
-	int ret;
-	DECLARE_COMPLETION_ONSTACK(complete);
-
-	if ((sbio->spag[ix].flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    (sbio->spag[ix].have_csum == 0)) {
-		fixup = kzalloc(sizeof(*fixup), GFP_NOFS);
-		if (!fixup)
-			goto uncorrectable;
-		fixup->sdev = sdev;
-		fixup->logical = logical;
-		fixup->root = fs_info->extent_root;
-		fixup->mirror_num = sbio->spag[ix].mirror_num;
+		/*
+		 * !is_metadata and !have_csum, this means that the data
+		 * might not be COW'ed, that it might be modified
+		 * concurrently. The general strategy to work on the
+		 * commit root does not help in the case when COW is not
+		 * used.
+		 */
+		fixup_nodatasum = kzalloc(sizeof(*fixup_nodatasum), GFP_NOFS);
+		if (!fixup_nodatasum)
+			goto did_not_correct_error;
+		fixup_nodatasum->sdev = sdev;
+		fixup_nodatasum->logical = logical;
+		fixup_nodatasum->root = fs_info->extent_root;
+		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
 		/*
 		 * increment scrubs_running to prevent cancel requests from
 		 * completing as long as a fixup worker is running. we must also
@@ -648,235 +774,529 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 		atomic_inc(&fs_info->scrubs_paused);
 		mutex_unlock(&fs_info->scrub_lock);
 		atomic_inc(&sdev->fixup_cnt);
-		fixup->work.func = scrub_fixup_nodatasum;
-		btrfs_queue_worker(&fs_info->scrub_workers, &fixup->work);
-		return;
+		fixup_nodatasum->work.func = scrub_fixup_nodatasum;
+		btrfs_queue_worker(&fs_info->scrub_workers,
+				   &fixup_nodatasum->work);
+		goto out;
 	}
 
-	length = PAGE_SIZE;
-	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length,
-			      &bbio, 0);
-	if (ret || !bbio || length < PAGE_SIZE) {
-		printk(KERN_ERR
-		       "scrub_fixup: btrfs_map_block failed us for %llu\n",
-		       (unsigned long long)logical);
-		WARN_ON(1);
-		kfree(bbio);
-		return;
+	/*
+	 * now build and submit the bios for the other mirrors, check
+	 * checksums
+	 */
+	for (mirror_index = 0;
+	     mirror_index < BTRFS_MAX_MIRRORS &&
+	     sblocks_for_recheck[mirror_index].page_count > 0;
+	     mirror_index++) {
+		if (mirror_index == failed_mirror_index)
+			continue;
+
+		/* build and submit the bios, check checksums */
+		ret = scrub_recheck_block(fs_info,
+					  sblocks_for_recheck + mirror_index,
+					  is_metadata, have_csum, csum,
+					  generation, sdev->csum_size);
+		if (ret)
+			goto did_not_correct_error;
 	}
 
-	if (bbio->num_stripes == 1)
-		/* there aren't any replicas */
-		goto uncorrectable;
+	/*
+	 * first try to pick the mirror which is completely without I/O
+	 * errors and also does not have a checksum error.
+	 * If one is found, and if a checksum is present, the full block
+	 * that is known to contain an error is rewritten. Afterwards
+	 * the block is known to be corrected.
+	 * If a mirror is found which is completely correct, and no
+	 * checksum is present, only those pages are rewritten that had
+	 * an I/O error in the block to be repaired, since it cannot be
+	 * determined, which copy of the other pages is better (and it
+	 * could happen otherwise that a correct page would be
+	 * overwritten by a bad one).
+	 */
+	for (mirror_index = 0;
+	     mirror_index < BTRFS_MAX_MIRRORS &&
+	     sblocks_for_recheck[mirror_index].page_count > 0;
+	     mirror_index++) {
+		struct scrub_block *sblock_other = sblocks_for_recheck +
+						   mirror_index;
+
+		if (!sblock_other->header_error &&
+		    !sblock_other->checksum_error &&
+		    sblock_other->no_io_error_seen) {
+			int force_write = is_metadata || have_csum;
+
+			ret = scrub_repair_block_from_good_copy(sblock_bad,
+								sblock_other,
+								force_write);
+			if (0 == ret)
+				goto corrected_error;
+		}
+	}
 
 	/*
-	 * first find a good copy
+	 * in case of I/O errors in the area that is supposed to be
+	 * repaired, continue by picking good copies of those pages.
+	 * Select the good pages from mirrors to rewrite bad pages from
+	 * the area to fix. Afterwards verify the checksum of the block
+	 * that is supposed to be repaired. This verification step is
+	 * only done for the purpose of statistic counting and for the
+	 * final scrub report, whether errors remain.
+	 * A perfect algorithm could make use of the checksum and try
+	 * all possible combinations of pages from the different mirrors
+	 * until the checksum verification succeeds. For example, when
+	 * the 2nd page of mirror #1 faces I/O errors, and the 2nd page
+	 * of mirror #2 is readable but the final checksum test fails,
+	 * then the 2nd page of mirror #3 could be tried, whether now
+	 * the final checksum succeedes. But this would be a rare
+	 * exception and is therefore not implemented. At least it is
+	 * avoided that the good copy is overwritten.
+	 * A more useful improvement would be to pick the sectors
+	 * without I/O error based on sector sizes (512 bytes on legacy
+	 * disks) instead of on PAGE_SIZE. Then maybe 512 byte of one
+	 * mirror could be repaired by taking 512 byte of a different
+	 * mirror, even if other 512 byte sectors in the same PAGE_SIZE
+	 * area are unreadable.
 	 */
-	for (i = 0; i < bbio->num_stripes; ++i) {
-		if (i + 1 == sbio->spag[ix].mirror_num)
-			continue;
 
-		if (scrub_fixup_io(READ, bbio->stripes[i].dev->bdev,
-				   bbio->stripes[i].physical >> 9,
-				   sbio->bio->bi_io_vec[ix].bv_page)) {
-			/* I/O-error, this is not a good copy */
+	/* can only fix I/O errors from here on */
+	if (sblock_bad->no_io_error_seen)
+		goto did_not_correct_error;
+
+	success = 1;
+	for (page_num = 0; page_num < sblock_bad->page_count; page_num++) {
+		struct scrub_page *page_bad = sblock_bad->pagev + page_num;
+
+		if (!page_bad->io_error)
 			continue;
+
+		for (mirror_index = 0;
+		     mirror_index < BTRFS_MAX_MIRRORS &&
+		     sblocks_for_recheck[mirror_index].page_count > 0;
+		     mirror_index++) {
+			struct scrub_block *sblock_other = sblocks_for_recheck +
+							   mirror_index;
+			struct scrub_page *page_other = sblock_other->pagev +
+							page_num;
+
+			if (!page_other->io_error) {
+				ret = scrub_repair_page_from_good_copy(
+					sblock_bad, sblock_other, page_num, 0);
+				if (0 == ret) {
+					page_bad->io_error = 0;
+					break; /* succeeded for this page */
+				}
+			}
 		}
 
-		if (scrub_fixup_check(sbio, ix) == 0)
-			break;
+		if (page_bad->io_error) {
+			/* did not find a mirror to copy the page from */
+			success = 0;
+		}
 	}
-	if (i == bbio->num_stripes)
-		goto uncorrectable;
 
-	if (!sdev->readonly) {
-		/*
-		 * bi_io_vec[ix].bv_page now contains good data, write it back
-		 */
-		if (scrub_fixup_io(WRITE, sdev->dev->bdev,
-				   (sbio->physical + ix * PAGE_SIZE) >> 9,
-				   sbio->bio->bi_io_vec[ix].bv_page)) {
-			/* I/O-error, writeback failed, give up */
-			goto uncorrectable;
+	if (success) {
+		if (is_metadata || have_csum) {
+			/*
+			 * need to verify the checksum now that all
+			 * sectors on disk are repaired (the write
+			 * request for data to be repaired is on its way).
+			 * Just be lazy and use scrub_recheck_block()
+			 * which re-reads the data before the checksum
+			 * is verified, but most likely the data comes out
+			 * of the page cache.
+			 */
+			ret = scrub_recheck_block(fs_info, sblock_bad,
+						  is_metadata, have_csum, csum,
+						  generation, sdev->csum_size);
+			if (!ret && !sblock_bad->header_error &&
+			    !sblock_bad->checksum_error &&
+			    sblock_bad->no_io_error_seen)
+				goto corrected_error;
+			else
+				goto did_not_correct_error;
+		} else {
+corrected_error:
+			spin_lock(&sdev->stat_lock);
+			sdev->stat.corrected_errors++;
+			spin_unlock(&sdev->stat_lock);
+			printk_ratelimited(KERN_ERR
+				"btrfs: fixed up error at logical %llu on dev %s\n",
+				(unsigned long long)logical, sdev->dev->name);
 		}
+	} else {
+did_not_correct_error:
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.uncorrectable_errors++;
+		spin_unlock(&sdev->stat_lock);
+		printk_ratelimited(KERN_ERR
+			"btrfs: unable to fixup (regular) error at logical %llu on dev %s\n",
+			(unsigned long long)logical, sdev->dev->name);
 	}
 
-	kfree(bbio);
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.corrected_errors;
-	spin_unlock(&sdev->stat_lock);
+out:
+	if (sblocks_for_recheck) {
+		for (mirror_index = 0; mirror_index < BTRFS_MAX_MIRRORS;
+		     mirror_index++) {
+			struct scrub_block *sblock = sblocks_for_recheck +
+						     mirror_index;
+			int page_index;
+
+			for (page_index = 0; page_index < SCRUB_PAGES_PER_BIO;
+			     page_index++)
+				if (sblock->pagev[page_index].page)
+					__free_page(
+						sblock->pagev[page_index].page);
+		}
+		kfree(sblocks_for_recheck);
+	}
 
-	printk_ratelimited(KERN_ERR "btrfs: fixed up error at logical %llu\n",
-			       (unsigned long long)logical);
-	return;
+	return 0;
+}
 
-uncorrectable:
-	kfree(bbio);
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.uncorrectable_errors;
-	spin_unlock(&sdev->stat_lock);
+static int scrub_setup_recheck_block(struct scrub_dev *sdev,
+				     struct btrfs_mapping_tree *map_tree,
+				     u64 length, u64 logical,
+				     struct scrub_block *sblocks_for_recheck)
+{
+	int page_index;
+	int mirror_index;
+	int ret;
+
+	/*
+	 * note: the three members sdev, ref_count and outstanding_pages
+	 * are not used (and not set) in the blocks that are used for
+	 * the recheck procedure
+	 */
+
+	page_index = 0;
+	while (length > 0) {
+		u64 sublen = min_t(u64, length, PAGE_SIZE);
+		u64 mapped_length = sublen;
+		struct btrfs_bio *bbio = NULL;
 
-	printk_ratelimited(KERN_ERR "btrfs: unable to fixup (regular) error at "
-				"logical %llu\n", (unsigned long long)logical);
+		/*
+		 * with a length of PAGE_SIZE, each returned stripe
+		 * represents one mirror
+		 */
+		ret = btrfs_map_block(map_tree, WRITE, logical, &mapped_length,
+				      &bbio, 0);
+		if (ret || !bbio || mapped_length < sublen) {
+			kfree(bbio);
+			return -EIO;
+		}
+
+		BUG_ON(page_index >= SCRUB_PAGES_PER_BIO);
+		for (mirror_index = 0; mirror_index < (int)bbio->num_stripes;
+		     mirror_index++) {
+			struct scrub_block *sblock;
+			struct scrub_page *page;
+
+			if (mirror_index >= BTRFS_MAX_MIRRORS)
+				continue;
+
+			sblock = sblocks_for_recheck + mirror_index;
+			page = sblock->pagev + page_index;
+			page->logical = logical;
+			page->physical = bbio->stripes[mirror_index].physical;
+			page->bdev = bbio->stripes[mirror_index].dev->bdev;
+			page->mirror_num = mirror_index + 1;
+			page->page = alloc_page(GFP_NOFS);
+			if (!page->page) {
+				spin_lock(&sdev->stat_lock);
+				sdev->stat.malloc_errors++;
+				spin_unlock(&sdev->stat_lock);
+				return -ENOMEM;
+			}
+			sblock->page_count++;
+		}
+		kfree(bbio);
+		length -= sublen;
+		logical += sublen;
+		page_index++;
+	}
+
+	return 0;
 }
 
-static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
-			 struct page *page)
+/*
+ * this function will check the on disk data for checksum errors, header
+ * errors and read I/O errors. If any I/O errors happen, the exact pages
+ * which are errored are marked as being bad. The goal is to enable scrub
+ * to take those pages that are not errored from all the mirrors so that
+ * the pages that are errored in the just handled mirror can be repaired.
+ */
+static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
+			       struct scrub_block *sblock, int is_metadata,
+			       int have_csum, u8 *csum, u64 generation,
+			       u16 csum_size)
 {
-	struct bio *bio = NULL;
-	int ret;
-	DECLARE_COMPLETION_ONSTACK(complete);
+	int page_num;
 
-	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_bdev = bdev;
-	bio->bi_sector = sector;
-	bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio->bi_end_io = scrub_fixup_end_io;
-	bio->bi_private = &complete;
-	btrfsic_submit_bio(rw, bio);
+	sblock->no_io_error_seen = 1;
+	sblock->header_error = 0;
+	sblock->checksum_error = 0;
 
-	/* this will also unplug the queue */
-	wait_for_completion(&complete);
+	for (page_num = 0; page_num < sblock->page_count; page_num++) {
+		struct bio *bio;
+		int ret;
+		struct scrub_page *page = sblock->pagev + page_num;
+		DECLARE_COMPLETION_ONSTACK(complete);
+
+		BUG_ON(!page->page);
+		bio = bio_alloc(GFP_NOFS, 1);
+		bio->bi_bdev = page->bdev;
+		bio->bi_sector = page->physical >> 9;
+		bio->bi_end_io = scrub_complete_bio_end_io;
+		bio->bi_private = &complete;
+
+		ret = bio_add_page(bio, page->page, PAGE_SIZE, 0);
+		if (PAGE_SIZE != ret) {
+			bio_put(bio);
+			return -EIO;
+		}
+		btrfsic_submit_bio(READ, bio);
 
-	ret = !test_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio_put(bio);
-	return ret;
+		/* this will also unplug the queue */
+		wait_for_completion(&complete);
+
+		page->io_error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+			sblock->no_io_error_seen = 0;
+		bio_put(bio);
+	}
+
+	if (sblock->no_io_error_seen)
+		scrub_recheck_block_checksum(fs_info, sblock, is_metadata,
+					     have_csum, csum, generation,
+					     csum_size);
+
+	return 0;
 }
 
-static void scrub_bio_end_io(struct bio *bio, int err)
+static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
+					 struct scrub_block *sblock,
+					 int is_metadata, int have_csum,
+					 const u8 *csum, u64 generation,
+					 u16 csum_size)
 {
-	struct scrub_bio *sbio = bio->bi_private;
-	struct scrub_dev *sdev = sbio->sdev;
-	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
+	int page_num;
+	u8 calculated_csum[BTRFS_CSUM_SIZE];
+	u32 crc = ~(u32)0;
+	struct btrfs_root *root = fs_info->extent_root;
+	void *mapped_buffer;
+
+	BUG_ON(!sblock->pagev[0].page);
+	if (is_metadata) {
+		struct btrfs_header *h;
+
+		mapped_buffer = kmap_atomic(sblock->pagev[0].page, KM_USER0);
+		h = (struct btrfs_header *)mapped_buffer;
+
+		if (sblock->pagev[0].logical != le64_to_cpu(h->bytenr) ||
+		    generation != le64_to_cpu(h->generation) ||
+		    memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE) ||
+		    memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
+			   BTRFS_UUID_SIZE))
+			sblock->header_error = 1;
+		csum = h->csum;
+	} else {
+		if (!have_csum)
+			return;
 
-	sbio->err = err;
-	sbio->bio = bio;
+		mapped_buffer = kmap_atomic(sblock->pagev[0].page, KM_USER0);
+	}
 
-	btrfs_queue_worker(&fs_info->scrub_workers, &sbio->work);
+	for (page_num = 0;;) {
+		if (page_num == 0 && is_metadata)
+			crc = btrfs_csum_data(root,
+				((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE,
+				crc, PAGE_SIZE - BTRFS_CSUM_SIZE);
+		else
+			crc = btrfs_csum_data(root, mapped_buffer, crc,
+					      PAGE_SIZE);
+
+		kunmap_atomic(mapped_buffer, KM_USER0);
+		page_num++;
+		if (page_num >= sblock->page_count)
+			break;
+		BUG_ON(!sblock->pagev[page_num].page);
+
+		mapped_buffer = kmap_atomic(sblock->pagev[page_num].page,
+					    KM_USER0);
+	}
+
+	btrfs_csum_final(crc, calculated_csum);
+	if (memcmp(calculated_csum, csum, csum_size))
+		sblock->checksum_error = 1;
 }
 
-static void scrub_checksum(struct btrfs_work *work)
+static void scrub_complete_bio_end_io(struct bio *bio, int err)
 {
-	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
-	struct scrub_dev *sdev = sbio->sdev;
-	struct page *page;
-	void *buffer;
-	int i;
-	u64 flags;
-	u64 logical;
-	int ret;
+	complete((struct completion *)bio->bi_private);
+}
 
-	if (sbio->err) {
-		ret = 0;
-		for (i = 0; i < sbio->count; ++i)
-			ret |= scrub_recheck_error(sbio, i);
-		if (!ret) {
-			spin_lock(&sdev->stat_lock);
-			++sdev->stat.unverified_errors;
-			spin_unlock(&sdev->stat_lock);
-		}
+static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
+					     struct scrub_block *sblock_good,
+					     int force_write)
+{
+	int page_num;
+	int ret = 0;
 
-		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
-		sbio->bio->bi_phys_segments = 0;
-		sbio->bio->bi_idx = 0;
+	for (page_num = 0; page_num < sblock_bad->page_count; page_num++) {
+		int ret_sub;
 
-		for (i = 0; i < sbio->count; i++) {
-			struct bio_vec *bi;
-			bi = &sbio->bio->bi_io_vec[i];
-			bi->bv_offset = 0;
-			bi->bv_len = PAGE_SIZE;
-		}
-		goto out;
+		ret_sub = scrub_repair_page_from_good_copy(sblock_bad,
+							   sblock_good,
+							   page_num,
+							   force_write);
+		if (ret_sub)
+			ret = ret_sub;
 	}
-	for (i = 0; i < sbio->count; ++i) {
-		page = sbio->bio->bi_io_vec[i].bv_page;
-		buffer = kmap_atomic(page, KM_USER0);
-		flags = sbio->spag[i].flags;
-		logical = sbio->logical + i * PAGE_SIZE;
-		ret = 0;
-		if (flags & BTRFS_EXTENT_FLAG_DATA) {
-			ret = scrub_checksum_data(sdev, sbio->spag + i, buffer);
-		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-			ret = scrub_checksum_tree_block(sdev, sbio->spag + i,
-							logical, buffer);
-		} else if (flags & BTRFS_EXTENT_FLAG_SUPER) {
-			BUG_ON(i);
-			(void)scrub_checksum_super(sbio, buffer);
-		} else {
-			WARN_ON(1);
-		}
-		kunmap_atomic(buffer, KM_USER0);
-		if (ret) {
-			ret = scrub_recheck_error(sbio, i);
-			if (!ret) {
-				spin_lock(&sdev->stat_lock);
-				++sdev->stat.unverified_errors;
-				spin_unlock(&sdev->stat_lock);
-			}
+
+	return ret;
+}
+
+static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
+					    struct scrub_block *sblock_good,
+					    int page_num, int force_write)
+{
+	struct scrub_page *page_bad = sblock_bad->pagev + page_num;
+	struct scrub_page *page_good = sblock_good->pagev + page_num;
+
+	BUG_ON(sblock_bad->pagev[page_num].page == NULL);
+	BUG_ON(sblock_good->pagev[page_num].page == NULL);
+	if (force_write || sblock_bad->header_error ||
+	    sblock_bad->checksum_error || page_bad->io_error) {
+		struct bio *bio;
+		int ret;
+		DECLARE_COMPLETION_ONSTACK(complete);
+
+		bio = bio_alloc(GFP_NOFS, 1);
+		bio->bi_bdev = page_bad->bdev;
+		bio->bi_sector = page_bad->physical >> 9;
+		bio->bi_end_io = scrub_complete_bio_end_io;
+		bio->bi_private = &complete;
+
+		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
+		if (PAGE_SIZE != ret) {
+			bio_put(bio);
+			return -EIO;
 		}
+		btrfsic_submit_bio(WRITE, bio);
+
+		/* this will also unplug the queue */
+		wait_for_completion(&complete);
+		bio_put(bio);
 	}
 
-out:
-	scrub_free_bio(sbio->bio);
-	sbio->bio = NULL;
-	spin_lock(&sdev->list_lock);
-	sbio->next_free = sdev->first_free;
-	sdev->first_free = sbio->index;
-	spin_unlock(&sdev->list_lock);
-	atomic_dec(&sdev->in_flight);
-	wake_up(&sdev->list_wait);
+	return 0;
+}
+
+static void scrub_checksum(struct scrub_block *sblock)
+{
+	u64 flags;
+	int ret;
+
+	BUG_ON(sblock->page_count < 1);
+	flags = sblock->pagev[0].flags;
+	ret = 0;
+	if (flags & BTRFS_EXTENT_FLAG_DATA)
+		ret = scrub_checksum_data(sblock);
+	else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+		ret = scrub_checksum_tree_block(sblock);
+	else if (flags & BTRFS_EXTENT_FLAG_SUPER)
+		(void)scrub_checksum_super(sblock);
+	else
+		WARN_ON(1);
+	if (ret)
+		scrub_handle_errored_block(sblock);
 }
 
-static int scrub_checksum_data(struct scrub_dev *sdev,
-			       struct scrub_page *spag, void *buffer)
+static int scrub_checksum_data(struct scrub_block *sblock)
 {
+	struct scrub_dev *sdev = sblock->sdev;
 	u8 csum[BTRFS_CSUM_SIZE];
+	u8 *on_disk_csum;
+	struct page *page;
+	void *buffer;
 	u32 crc = ~(u32)0;
 	int fail = 0;
 	struct btrfs_root *root = sdev->dev->dev_root;
+	u64 len;
+	int index;
 
-	if (!spag->have_csum)
+	BUG_ON(sblock->page_count < 1);
+	if (!sblock->pagev[0].have_csum)
 		return 0;
 
-	crc = btrfs_csum_data(root, buffer, crc, PAGE_SIZE);
+	on_disk_csum = sblock->pagev[0].csum;
+	page = sblock->pagev[0].page;
+	buffer = kmap_atomic(page, KM_USER0);
+
+	len = sdev->sectorsize;
+	index = 0;
+	for (;;) {
+		u64 l = min_t(u64, len, PAGE_SIZE);
+
+		crc = btrfs_csum_data(root, buffer, crc, l);
+		kunmap_atomic(buffer, KM_USER0);
+		len -= l;
+		if (len == 0)
+			break;
+		index++;
+		BUG_ON(index >= sblock->page_count);
+		BUG_ON(!sblock->pagev[index].page);
+		page = sblock->pagev[index].page;
+		buffer = kmap_atomic(page, KM_USER0);
+	}
+
 	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, spag->csum, sdev->csum_size))
+	if (memcmp(csum, on_disk_csum, sdev->csum_size))
 		fail = 1;
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.data_extents_scrubbed;
-	sdev->stat.data_bytes_scrubbed += PAGE_SIZE;
-	if (fail)
+	if (fail) {
+		spin_lock(&sdev->stat_lock);
 		++sdev->stat.csum_errors;
-	spin_unlock(&sdev->stat_lock);
+		spin_unlock(&sdev->stat_lock);
+	}
 
 	return fail;
 }
 
-static int scrub_checksum_tree_block(struct scrub_dev *sdev,
-				     struct scrub_page *spag, u64 logical,
-				     void *buffer)
+static int scrub_checksum_tree_block(struct scrub_block *sblock)
 {
+	struct scrub_dev *sdev = sblock->sdev;
 	struct btrfs_header *h;
 	struct btrfs_root *root = sdev->dev->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	u8 csum[BTRFS_CSUM_SIZE];
+	u8 calculated_csum[BTRFS_CSUM_SIZE];
+	u8 on_disk_csum[BTRFS_CSUM_SIZE];
+	struct page *page;
+	void *mapped_buffer;
+	u64 mapped_size;
+	void *p;
 	u32 crc = ~(u32)0;
 	int fail = 0;
 	int crc_fail = 0;
+	u64 len;
+	int index;
+
+	BUG_ON(sblock->page_count < 1);
+	page = sblock->pagev[0].page;
+	mapped_buffer = kmap_atomic(page, KM_USER0);
+	h = (struct btrfs_header *)mapped_buffer;
+	memcpy(on_disk_csum, h->csum, sdev->csum_size);
 
 	/*
 	 * we don't use the getter functions here, as we
 	 * a) don't have an extent buffer and
 	 * b) the page is already kmapped
 	 */
-	h = (struct btrfs_header *)buffer;
 
-	if (logical != le64_to_cpu(h->bytenr))
+	if (sblock->pagev[0].logical != le64_to_cpu(h->bytenr))
 		++fail;
 
-	if (spag->generation != le64_to_cpu(h->generation))
+	if (sblock->pagev[0].generation != le64_to_cpu(h->generation))
 		++fail;
 
 	if (memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
@@ -886,51 +1306,99 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 		   BTRFS_UUID_SIZE))
 		++fail;
 
-	crc = btrfs_csum_data(root, buffer + BTRFS_CSUM_SIZE, crc,
-			      PAGE_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, h->csum, sdev->csum_size))
+	BUG_ON(sdev->nodesize != sdev->leafsize);
+	len = sdev->nodesize - BTRFS_CSUM_SIZE;
+	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
+	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
+	index = 0;
+	for (;;) {
+		u64 l = min_t(u64, len, mapped_size);
+
+		crc = btrfs_csum_data(root, p, crc, l);
+		kunmap_atomic(mapped_buffer, KM_USER0);
+		len -= l;
+		if (len == 0)
+			break;
+		index++;
+		BUG_ON(index >= sblock->page_count);
+		BUG_ON(!sblock->pagev[index].page);
+		page = sblock->pagev[index].page;
+		mapped_buffer = kmap_atomic(page, KM_USER0);
+		mapped_size = PAGE_SIZE;
+		p = mapped_buffer;
+	}
+
+	btrfs_csum_final(crc, calculated_csum);
+	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
 		++crc_fail;
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.tree_extents_scrubbed;
-	sdev->stat.tree_bytes_scrubbed += PAGE_SIZE;
-	if (crc_fail)
-		++sdev->stat.csum_errors;
-	if (fail)
-		++sdev->stat.verify_errors;
-	spin_unlock(&sdev->stat_lock);
+	if (crc_fail || fail) {
+		spin_lock(&sdev->stat_lock);
+		if (crc_fail)
+			++sdev->stat.csum_errors;
+		if (fail)
+			++sdev->stat.verify_errors;
+		spin_unlock(&sdev->stat_lock);
+	}
 
 	return fail || crc_fail;
 }
 
-static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
+static int scrub_checksum_super(struct scrub_block *sblock)
 {
 	struct btrfs_super_block *s;
-	u64 logical;
-	struct scrub_dev *sdev = sbio->sdev;
+	struct scrub_dev *sdev = sblock->sdev;
 	struct btrfs_root *root = sdev->dev->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	u8 csum[BTRFS_CSUM_SIZE];
+	u8 calculated_csum[BTRFS_CSUM_SIZE];
+	u8 on_disk_csum[BTRFS_CSUM_SIZE];
+	struct page *page;
+	void *mapped_buffer;
+	u64 mapped_size;
+	void *p;
 	u32 crc = ~(u32)0;
 	int fail = 0;
+	u64 len;
+	int index;
 
-	s = (struct btrfs_super_block *)buffer;
-	logical = sbio->logical;
+	BUG_ON(sblock->page_count < 1);
+	page = sblock->pagev[0].page;
+	mapped_buffer = kmap_atomic(page, KM_USER0);
+	s = (struct btrfs_super_block *)mapped_buffer;
+	memcpy(on_disk_csum, s->csum, sdev->csum_size);
 
-	if (logical != le64_to_cpu(s->bytenr))
+	if (sblock->pagev[0].logical != le64_to_cpu(s->bytenr))
 		++fail;
 
-	if (sbio->spag[0].generation != le64_to_cpu(s->generation))
+	if (sblock->pagev[0].generation != le64_to_cpu(s->generation))
 		++fail;
 
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
 		++fail;
 
-	crc = btrfs_csum_data(root, buffer + BTRFS_CSUM_SIZE, crc,
-			      PAGE_SIZE - BTRFS_CSUM_SIZE);
-	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, s->csum, sbio->sdev->csum_size))
+	len = BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE;
+	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
+	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
+	index = 0;
+	for (;;) {
+		u64 l = min_t(u64, len, mapped_size);
+
+		crc = btrfs_csum_data(root, p, crc, l);
+		kunmap_atomic(mapped_buffer, KM_USER0);
+		len -= l;
+		if (len == 0)
+			break;
+		index++;
+		BUG_ON(index >= sblock->page_count);
+		BUG_ON(!sblock->pagev[index].page);
+		page = sblock->pagev[index].page;
+		mapped_buffer = kmap_atomic(page, KM_USER0);
+		mapped_size = PAGE_SIZE;
+		p = mapped_buffer;
+	}
+
+	btrfs_csum_final(crc, calculated_csum);
+	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
 		++fail;
 
 	if (fail) {
@@ -947,6 +1415,23 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 	return fail;
 }
 
+static void scrub_block_get(struct scrub_block *sblock)
+{
+	atomic_inc(&sblock->ref_count);
+}
+
+static void scrub_block_put(struct scrub_block *sblock)
+{
+	if (atomic_dec_and_test(&sblock->ref_count)) {
+		int i;
+
+		for (i = 0; i < sblock->page_count; i++)
+			if (sblock->pagev[i].page)
+				__free_page(sblock->pagev[i].page);
+		kfree(sblock);
+	}
+}
+
 static void scrub_submit(struct scrub_dev *sdev)
 {
 	struct scrub_bio *sbio;
@@ -955,19 +1440,17 @@ static void scrub_submit(struct scrub_dev *sdev)
 		return;
 
 	sbio = sdev->bios[sdev->curr];
-	sbio->err = 0;
 	sdev->curr = -1;
 	atomic_inc(&sdev->in_flight);
 
 	btrfsic_submit_bio(READ, sbio->bio);
 }
 
-static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
-		      u64 physical, u64 flags, u64 gen, int mirror_num,
-		      u8 *csum, int force)
+static int scrub_add_page_to_bio(struct scrub_dev *sdev,
+				 struct scrub_page *spage)
 {
+	struct scrub_block *sblock = spage->sblock;
 	struct scrub_bio *sbio;
-	struct page *page;
 	int ret;
 
 again:
@@ -980,7 +1463,7 @@ again:
 		if (sdev->curr != -1) {
 			sdev->first_free = sdev->bios[sdev->curr]->next_free;
 			sdev->bios[sdev->curr]->next_free = -1;
-			sdev->bios[sdev->curr]->count = 0;
+			sdev->bios[sdev->curr]->page_count = 0;
 			spin_unlock(&sdev->list_lock);
 		} else {
 			spin_unlock(&sdev->list_lock);
@@ -988,53 +1471,200 @@ again:
 		}
 	}
 	sbio = sdev->bios[sdev->curr];
-	if (sbio->count == 0) {
+	if (sbio->page_count == 0) {
 		struct bio *bio;
 
-		sbio->physical = physical;
-		sbio->logical = logical;
-		bio = bio_alloc(GFP_NOFS, SCRUB_PAGES_PER_BIO);
-		if (!bio)
-			return -ENOMEM;
+		sbio->physical = spage->physical;
+		sbio->logical = spage->logical;
+		bio = sbio->bio;
+		if (!bio) {
+			bio = bio_alloc(GFP_NOFS, sdev->pages_per_bio);
+			if (!bio)
+				return -ENOMEM;
+			sbio->bio = bio;
+		}
 
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_bio_end_io;
 		bio->bi_bdev = sdev->dev->bdev;
-		bio->bi_sector = sbio->physical >> 9;
+		bio->bi_sector = spage->physical >> 9;
 		sbio->err = 0;
-		sbio->bio = bio;
-	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
-		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
+	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
+		   spage->physical ||
+		   sbio->logical + sbio->page_count * PAGE_SIZE !=
+		   spage->logical) {
 		scrub_submit(sdev);
 		goto again;
 	}
-	sbio->spag[sbio->count].flags = flags;
-	sbio->spag[sbio->count].generation = gen;
-	sbio->spag[sbio->count].have_csum = 0;
-	sbio->spag[sbio->count].mirror_num = mirror_num;
-
-	page = alloc_page(GFP_NOFS);
-	if (!page)
-		return -ENOMEM;
 
-	ret = bio_add_page(sbio->bio, page, PAGE_SIZE, 0);
-	if (!ret) {
-		__free_page(page);
+	sbio->pagev[sbio->page_count] = spage;
+	ret = bio_add_page(sbio->bio, spage->page, PAGE_SIZE, 0);
+	if (ret != PAGE_SIZE) {
+		if (sbio->page_count < 1) {
+			bio_put(sbio->bio);
+			sbio->bio = NULL;
+			return -EIO;
+		}
 		scrub_submit(sdev);
 		goto again;
 	}
 
-	if (csum) {
-		sbio->spag[sbio->count].have_csum = 1;
-		memcpy(sbio->spag[sbio->count].csum, csum, sdev->csum_size);
+	scrub_block_get(sblock); /* one for the added page */
+	atomic_inc(&sblock->outstanding_pages);
+	sbio->page_count++;
+	if (sbio->page_count == sdev->pages_per_bio)
+		scrub_submit(sdev);
+
+	return 0;
+}
+
+static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
+		       u64 physical, u64 flags, u64 gen, int mirror_num,
+		       u8 *csum, int force)
+{
+	struct scrub_block *sblock;
+	int index;
+
+	sblock = kzalloc(sizeof(*sblock), GFP_NOFS);
+	if (!sblock) {
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.malloc_errors++;
+		spin_unlock(&sdev->stat_lock);
+		return -ENOMEM;
+	}
+
+	/* one ref inside this function, plus one for each page later on */
+	atomic_set(&sblock->ref_count, 1);
+	sblock->sdev = sdev;
+	sblock->no_io_error_seen = 1;
+
+	for (index = 0; len > 0; index++) {
+		struct scrub_page *spage = sblock->pagev + index;
+		u64 l = min_t(u64, len, PAGE_SIZE);
+
+		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
+		spage->page = alloc_page(GFP_NOFS);
+		if (!spage->page) {
+			spin_lock(&sdev->stat_lock);
+			sdev->stat.malloc_errors++;
+			spin_unlock(&sdev->stat_lock);
+			while (index > 0) {
+				index--;
+				__free_page(sblock->pagev[index].page);
+			}
+			kfree(sblock);
+			return -ENOMEM;
+		}
+		spage->sblock = sblock;
+		spage->bdev = sdev->dev->bdev;
+		spage->flags = flags;
+		spage->generation = gen;
+		spage->logical = logical;
+		spage->physical = physical;
+		spage->mirror_num = mirror_num;
+		if (csum) {
+			spage->have_csum = 1;
+			memcpy(spage->csum, csum, sdev->csum_size);
+		} else {
+			spage->have_csum = 0;
+		}
+		sblock->page_count++;
+		len -= l;
+		logical += l;
+		physical += l;
+	}
+
+	BUG_ON(sblock->page_count == 0);
+	for (index = 0; index < sblock->page_count; index++) {
+		struct scrub_page *spage = sblock->pagev + index;
+		int ret;
+
+		ret = scrub_add_page_to_bio(sdev, spage);
+		if (ret) {
+			scrub_block_put(sblock);
+			return ret;
+		}
 	}
-	++sbio->count;
-	if (sbio->count == SCRUB_PAGES_PER_BIO || force)
+
+	if (force)
 		scrub_submit(sdev);
 
+	/* last one frees, either here or in bio completion for last page */
+	scrub_block_put(sblock);
 	return 0;
 }
 
+static void scrub_bio_end_io(struct bio *bio, int err)
+{
+	struct scrub_bio *sbio = bio->bi_private;
+	struct scrub_dev *sdev = sbio->sdev;
+	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
+
+	sbio->err = err;
+	sbio->bio = bio;
+
+	btrfs_queue_worker(&fs_info->scrub_workers, &sbio->work);
+}
+
+static void scrub_bio_end_io_worker(struct btrfs_work *work)
+{
+	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
+	struct scrub_dev *sdev = sbio->sdev;
+	int i;
+
+	BUG_ON(sbio->page_count > SCRUB_PAGES_PER_BIO);
+	if (sbio->err) {
+		for (i = 0; i < sbio->page_count; i++) {
+			struct scrub_page *spage = sbio->pagev[i];
+
+			spage->io_error = 1;
+			spage->sblock->no_io_error_seen = 0;
+		}
+	}
+
+	/* now complete the scrub_block items that have all pages completed */
+	for (i = 0; i < sbio->page_count; i++) {
+		struct scrub_page *spage = sbio->pagev[i];
+		struct scrub_block *sblock = spage->sblock;
+
+		if (atomic_dec_and_test(&sblock->outstanding_pages))
+			scrub_block_complete(sblock);
+		scrub_block_put(sblock);
+	}
+
+	if (sbio->err) {
+		/* what is this good for??? */
+		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
+		sbio->bio->bi_phys_segments = 0;
+		sbio->bio->bi_idx = 0;
+
+		for (i = 0; i < sbio->page_count; i++) {
+			struct bio_vec *bi;
+			bi = &sbio->bio->bi_io_vec[i];
+			bi->bv_offset = 0;
+			bi->bv_len = PAGE_SIZE;
+		}
+	}
+
+	bio_put(sbio->bio);
+	sbio->bio = NULL;
+	spin_lock(&sdev->list_lock);
+	sbio->next_free = sdev->first_free;
+	sdev->first_free = sbio->index;
+	spin_unlock(&sdev->list_lock);
+	atomic_dec(&sdev->in_flight);
+	wake_up(&sdev->list_wait);
+}
+
+static void scrub_block_complete(struct scrub_block *sblock)
+{
+	if (!sblock->no_io_error_seen)
+		scrub_handle_errored_block(sblock);
+	else
+		scrub_checksum(sblock);
+}
+
 static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 			   u8 *csum)
 {
@@ -1042,7 +1672,6 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 	int ret = 0;
 	unsigned long i;
 	unsigned long num_sectors;
-	u32 sectorsize = sdev->dev->dev_root->sectorsize;
 
 	while (!list_empty(&sdev->csum_list)) {
 		sum = list_first_entry(&sdev->csum_list,
@@ -1060,7 +1689,7 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 	if (!sum)
 		return 0;
 
-	num_sectors = sum->len / sectorsize;
+	num_sectors = sum->len / sdev->sectorsize;
 	for (i = 0; i < num_sectors; ++i) {
 		if (sum->sums[i].bytenr == logical) {
 			memcpy(csum, &sum->sums[i].sum, sdev->csum_size);
@@ -1081,9 +1710,28 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 {
 	int ret;
 	u8 csum[BTRFS_CSUM_SIZE];
+	u32 blocksize;
+
+	if (flags & BTRFS_EXTENT_FLAG_DATA) {
+		blocksize = sdev->sectorsize;
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.data_extents_scrubbed++;
+		sdev->stat.data_bytes_scrubbed += len;
+		spin_unlock(&sdev->stat_lock);
+	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+		BUG_ON(sdev->nodesize != sdev->leafsize);
+		blocksize = sdev->nodesize;
+		spin_lock(&sdev->stat_lock);
+		sdev->stat.tree_extents_scrubbed++;
+		sdev->stat.tree_bytes_scrubbed += len;
+		spin_unlock(&sdev->stat_lock);
+	} else {
+		blocksize = sdev->sectorsize;
+		BUG_ON(1);
+	}
 
 	while (len) {
-		u64 l = min_t(u64, len, PAGE_SIZE);
+		u64 l = min_t(u64, len, blocksize);
 		int have_csum = 0;
 
 		if (flags & BTRFS_EXTENT_FLAG_DATA) {
@@ -1092,8 +1740,8 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 			if (have_csum == 0)
 				++sdev->stat.no_csum;
 		}
-		ret = scrub_page(sdev, logical, l, physical, flags, gen,
-				 mirror_num, have_csum ? csum : NULL, 0);
+		ret = scrub_pages(sdev, logical, l, physical, flags, gen,
+				  mirror_num, have_csum ? csum : NULL, 0);
 		if (ret)
 			return ret;
 		len -= l;
@@ -1158,6 +1806,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	if (!path)
 		return -ENOMEM;
 
+	/*
+	 * work on commit root. The related disk blocks are static as
+	 * long as COW is applied. This means, it is save to rewrite
+	 * them to repair disk errors without any race conditions
+	 */
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
@@ -1511,8 +2164,8 @@ static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
 			break;
 
-		ret = scrub_page(sdev, bytenr, PAGE_SIZE, bytenr,
-				 BTRFS_EXTENT_FLAG_SUPER, gen, i, NULL, 1);
+		ret = scrub_pages(sdev, bytenr, BTRFS_SUPER_INFO_SIZE, bytenr,
+				     BTRFS_EXTENT_FLAG_SUPER, gen, i, NULL, 1);
 		if (ret)
 			return ret;
 	}
@@ -1571,10 +2224,30 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 	/*
 	 * check some assumptions
 	 */
-	if (root->sectorsize != PAGE_SIZE ||
-	    root->sectorsize != root->leafsize ||
-	    root->sectorsize != root->nodesize) {
-		printk(KERN_ERR "btrfs_scrub: size assumptions fail\n");
+	if (root->nodesize != root->leafsize) {
+		printk(KERN_ERR
+		       "btrfs_scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
+		       root->nodesize, root->leafsize);
+		return -EINVAL;
+	}
+
+	if (root->nodesize > BTRFS_STRIPE_LEN) {
+		/*
+		 * in this case scrub is unable to calculate the checksum
+		 * the way scrub is implemented. Do not handle this
+		 * situation at all because it won't ever happen.
+		 */
+		printk(KERN_ERR
+		       "btrfs_scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
+		       root->nodesize, BTRFS_STRIPE_LEN);
+		return -EINVAL;
+	}
+
+	if (root->sectorsize != PAGE_SIZE) {
+		/* not supported for data w/o checksums */
+		printk(KERN_ERR
+		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lld) fails\n",
+		       root->sectorsize, (unsigned long long)PAGE_SIZE);
 		return -EINVAL;
 	}
 
-- 
1.7.3.4

