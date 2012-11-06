Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:56034 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 30.22 OK)
	with ESMTP id g03dbeoA6AsjWs for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 19/26] Btrfs: add code to scrub to copy read data to another disk
Date: Tue,  6 Nov 2012 17:38:37 +0100
Message-Id: <cef5c0f66f73ef151157fa524dede94eb29ae882.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

The device replace procedure makes use of the scrub code. The scrub
code is the most efficient code to read the allocated data of a disk,
i.e. it reads sequentially in order to avoid disk head movements, it
skips unallocated blocks, it uses read ahead mechanisms, and it
contains all the code to detect and repair defects.
This commit adds code to scrub to allow the scrub code to copy read
data to another disk.
One goal is to be able to perform as fast as possible. Therefore the
write requests are collected until huge bios are build, and the
write process is decoupled from the read process with some kind of
flow control, of course, in order to limit the allocated memory.
The best performance on spinning disks could by reached when the
head movements are avoided as much as possible. Therefore a single
worker is used to interface the read process with the write process.
The regular scrub operation works as fast as before, it is not
negatively influenced and actually it is more or less unchanged.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h |   2 +
 fs/btrfs/reada.c |  10 +-
 fs/btrfs/scrub.c | 881 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/super.c |   3 +-
 4 files changed, 823 insertions(+), 73 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 83904b5..e17f211 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1483,6 +1483,8 @@ struct btrfs_fs_info {
 	struct rw_semaphore scrub_super_lock;
 	int scrub_workers_refcnt;
 	struct btrfs_workers scrub_workers;
+	struct btrfs_workers scrub_wr_completion_workers;
+	struct btrfs_workers scrub_nocow_workers;
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	u32 check_integrity_print_mask;
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 0ddc565..9f363e1 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -418,12 +418,17 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			 */
 			continue;
 		}
+		if (!dev->bdev) {
+			/* cannot read ahead on missing device */
+			continue;
+		}
 		prev_dev = dev;
 		ret = radix_tree_insert(&dev->reada_extents, index, re);
 		if (ret) {
 			while (--i >= 0) {
 				dev = bbio->stripes[i].dev;
 				BUG_ON(dev == NULL);
+				/* ignore whether the entry was inserted */
 				radix_tree_delete(&dev->reada_extents, index);
 			}
 			BUG_ON(fs_info == NULL);
@@ -914,7 +919,10 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	generation = btrfs_header_generation(node);
 	free_extent_buffer(node);
 
-	reada_add_block(rc, start, &max_key, level, generation);
+	if (reada_add_block(rc, start, &max_key, level, generation)) {
+		kfree(rc);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	reada_start_machine(root->fs_info);
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 460e30b..59c69e0 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -25,6 +25,7 @@
 #include "transaction.h"
 #include "backref.h"
 #include "extent_io.h"
+#include "dev-replace.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
 
@@ -44,8 +45,15 @@
 struct scrub_block;
 struct scrub_ctx;
 
-#define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
-#define SCRUB_BIOS_PER_CTX	16	/* 1 MB per device in flight */
+/*
+ * the following three values only influence the performance.
+ * The last one configures the number of parallel and outstanding I/O
+ * operations. The first two values configure an upper limit for the number
+ * of (dynamically allocated) pages that are added to a bio.
+ */
+#define SCRUB_PAGES_PER_RD_BIO	32	/* 128k per bio */
+#define SCRUB_PAGES_PER_WR_BIO	32	/* 128k per bio */
+#define SCRUB_BIOS_PER_SCTX	64	/* 8MB per device in flight */
 
 /*
  * the following value times PAGE_SIZE needs to be large enough to match the
@@ -62,6 +70,7 @@ struct scrub_page {
 	u64			generation;
 	u64			logical;
 	u64			physical;
+	u64			physical_for_dev_replace;
 	atomic_t		ref_count;
 	struct {
 		unsigned int	mirror_num:8;
@@ -79,7 +88,11 @@ struct scrub_bio {
 	int			err;
 	u64			logical;
 	u64			physical;
-	struct scrub_page	*pagev[SCRUB_PAGES_PER_BIO];
+#if SCRUB_PAGES_PER_WR_BIO >= SCRUB_PAGES_PER_RD_BIO
+	struct scrub_page	*pagev[SCRUB_PAGES_PER_WR_BIO];
+#else
+	struct scrub_page	*pagev[SCRUB_PAGES_PER_RD_BIO];
+#endif
 	int			page_count;
 	int			next_free;
 	struct btrfs_work	work;
@@ -99,8 +112,16 @@ struct scrub_block {
 	};
 };
 
+struct scrub_wr_ctx {
+	struct scrub_bio *wr_curr_bio;
+	struct btrfs_device *tgtdev;
+	int pages_per_wr_bio; /* <= SCRUB_PAGES_PER_WR_BIO */
+	atomic_t flush_all_writes;
+	struct mutex wr_lock;
+};
+
 struct scrub_ctx {
-	struct scrub_bio	*bios[SCRUB_BIOS_PER_CTX];
+	struct scrub_bio	*bios[SCRUB_BIOS_PER_SCTX];
 	struct btrfs_root	*dev_root;
 	int			first_free;
 	int			curr;
@@ -112,12 +133,13 @@ struct scrub_ctx {
 	struct list_head	csum_list;
 	atomic_t		cancel_req;
 	int			readonly;
-	int			pages_per_bio; /* <= SCRUB_PAGES_PER_BIO */
+	int			pages_per_rd_bio;
 	u32			sectorsize;
 	u32			nodesize;
 	u32			leafsize;
 
 	int			is_dev_replace;
+	struct scrub_wr_ctx	wr_ctx;
 
 	/*
 	 * statistics
@@ -135,6 +157,15 @@ struct scrub_fixup_nodatasum {
 	int			mirror_num;
 };
 
+struct scrub_copy_nocow_ctx {
+	struct scrub_ctx	*sctx;
+	u64			logical;
+	u64			len;
+	int			mirror_num;
+	u64			physical_for_dev_replace;
+	struct btrfs_work	work;
+};
+
 struct scrub_warning {
 	struct btrfs_path	*path;
 	u64			extent_item_size;
@@ -156,8 +187,9 @@ static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx);
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
 static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_fs_info *fs_info,
+				     struct scrub_block *original_sblock,
 				     u64 length, u64 logical,
-				     struct scrub_block *sblock);
+				     struct scrub_block *sblocks_for_recheck);
 static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 				struct scrub_block *sblock, int is_metadata,
 				int have_csum, u8 *csum, u64 generation,
@@ -174,6 +206,9 @@ static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 					    struct scrub_block *sblock_good,
 					    int page_num, int force_write);
+static void scrub_write_block_to_dev_replace(struct scrub_block *sblock);
+static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
+					   int page_num);
 static int scrub_checksum_data(struct scrub_block *sblock);
 static int scrub_checksum_tree_block(struct scrub_block *sblock);
 static int scrub_checksum_super(struct scrub_block *sblock);
@@ -181,14 +216,38 @@ static void scrub_block_get(struct scrub_block *sblock);
 static void scrub_block_put(struct scrub_block *sblock);
 static void scrub_page_get(struct scrub_page *spage);
 static void scrub_page_put(struct scrub_page *spage);
-static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
-				 struct scrub_page *spage);
+static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
+				    struct scrub_page *spage);
 static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, struct btrfs_device *dev, u64 flags,
-		       u64 gen, int mirror_num, u8 *csum, int force);
+		       u64 gen, int mirror_num, u8 *csum, int force,
+		       u64 physical_for_dev_replace);
 static void scrub_bio_end_io(struct bio *bio, int err);
 static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
+static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
+			       u64 extent_logical, u64 extent_len,
+			       u64 *extent_physical,
+			       struct btrfs_device **extent_dev,
+			       int *extent_mirror_num);
+static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
+			      struct scrub_wr_ctx *wr_ctx,
+			      struct btrfs_fs_info *fs_info,
+			      struct btrfs_device *dev,
+			      int is_dev_replace);
+static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
+static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
+				    struct scrub_page *spage);
+static void scrub_wr_submit(struct scrub_ctx *sctx);
+static void scrub_wr_bio_end_io(struct bio *bio, int err);
+static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
+static int write_page_nocow(struct scrub_ctx *sctx,
+			    u64 physical_for_dev_replace, struct page *page);
+static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
+				      void *ctx);
+static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
+			    int mirror_num, u64 physical_for_dev_replace);
+static void copy_nocow_pages_worker(struct btrfs_work *work);
 
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
@@ -262,19 +321,20 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 	if (!sctx)
 		return;
 
+	scrub_free_wr_ctx(&sctx->wr_ctx);
+
 	/* this can happen when scrub is cancelled */
 	if (sctx->curr != -1) {
 		struct scrub_bio *sbio = sctx->bios[sctx->curr];
 
 		for (i = 0; i < sbio->page_count; i++) {
-			BUG_ON(!sbio->pagev[i]);
-			BUG_ON(!sbio->pagev[i]->page);
+			WARN_ON(!sbio->pagev[i]->page);
 			scrub_block_put(sbio->pagev[i]->sblock);
 		}
 		bio_put(sbio->bio);
 	}
 
-	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
+	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio = sctx->bios[i];
 
 		if (!sbio)
@@ -292,18 +352,29 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	struct scrub_ctx *sctx;
 	int		i;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
-	int pages_per_bio;
+	int pages_per_rd_bio;
+	int ret;
 
-	pages_per_bio = min_t(int, SCRUB_PAGES_PER_BIO,
-			      bio_get_nr_vecs(dev->bdev));
+	/*
+	 * the setting of pages_per_rd_bio is correct for scrub but might
+	 * be wrong for the dev_replace code where we might read from
+	 * different devices in the initial huge bios. However, that
+	 * code is able to correctly handle the case when adding a page
+	 * to a bio fails.
+	 */
+	if (dev->bdev)
+		pages_per_rd_bio = min_t(int, SCRUB_PAGES_PER_RD_BIO,
+					 bio_get_nr_vecs(dev->bdev));
+	else
+		pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx = kzalloc(sizeof(*sctx), GFP_NOFS);
 	if (!sctx)
 		goto nomem;
 	sctx->is_dev_replace = is_dev_replace;
-	sctx->pages_per_bio = pages_per_bio;
+	sctx->pages_per_rd_bio = pages_per_rd_bio;
 	sctx->curr = -1;
 	sctx->dev_root = dev->dev_root;
-	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
+	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
 		sbio = kzalloc(sizeof(*sbio), GFP_NOFS);
@@ -316,7 +387,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 		sbio->page_count = 0;
 		sbio->work.func = scrub_bio_end_io_worker;
 
-		if (i != SCRUB_BIOS_PER_CTX - 1)
+		if (i != SCRUB_BIOS_PER_SCTX - 1)
 			sctx->bios[i]->next_free = i + 1;
 		else
 			sctx->bios[i]->next_free = -1;
@@ -334,6 +405,13 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);
 	init_waitqueue_head(&sctx->list_wait);
+
+	ret = scrub_setup_wr_ctx(sctx, &sctx->wr_ctx, fs_info,
+				 fs_info->dev_replace.tgtdev, is_dev_replace);
+	if (ret) {
+		scrub_free_ctx(sctx);
+		return ERR_PTR(ret);
+	}
 	return sctx;
 
 nomem:
@@ -341,7 +419,8 @@ nomem:
 	return ERR_PTR(-ENOMEM);
 }
 
-static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
+static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
+				     void *warn_ctx)
 {
 	u64 isize;
 	u32 nlink;
@@ -349,7 +428,7 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root, void *ctx)
 	int i;
 	struct extent_buffer *eb;
 	struct btrfs_inode_item *inode_item;
-	struct scrub_warning *swarn = ctx;
+	struct scrub_warning *swarn = warn_ctx;
 	struct btrfs_fs_info *fs_info = swarn->dev->dev_root->fs_info;
 	struct inode_fs_paths *ipath = NULL;
 	struct btrfs_root *local_root;
@@ -492,11 +571,11 @@ out:
 	kfree(swarn.msg_buf);
 }
 
-static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *ctx)
+static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 {
 	struct page *page = NULL;
 	unsigned long index;
-	struct scrub_fixup_nodatasum *fixup = ctx;
+	struct scrub_fixup_nodatasum *fixup = fixup_ctx;
 	int ret;
 	int corrected = 0;
 	struct btrfs_key key;
@@ -660,7 +739,9 @@ out:
 		spin_lock(&sctx->stat_lock);
 		++sctx->stat.uncorrectable_errors;
 		spin_unlock(&sctx->stat_lock);
-
+		btrfs_dev_replace_stats_inc(
+			&sctx->dev_root->fs_info->dev_replace.
+			num_uncorrectable_read_errors);
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
 			(unsigned long long)fixup->logical,
@@ -715,6 +796,11 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	csum = sblock_to_check->pagev[0]->csum;
 	dev = sblock_to_check->pagev[0]->dev;
 
+	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
+		sblocks_for_recheck = NULL;
+		goto nodatasum_case;
+	}
+
 	/*
 	 * read all mirrors one after the other. This includes to
 	 * re-read the extent or metadata block that failed (that was
@@ -758,7 +844,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	}
 
 	/* setup the context, map the logical blocks and alloc the pages */
-	ret = scrub_setup_recheck_block(sctx, fs_info, length,
+	ret = scrub_setup_recheck_block(sctx, fs_info, sblock_to_check, length,
 					logical, sblocks_for_recheck);
 	if (ret) {
 		spin_lock(&sctx->stat_lock);
@@ -789,6 +875,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		sctx->stat.unverified_errors++;
 		spin_unlock(&sctx->stat_lock);
 
+		if (sctx->is_dev_replace)
+			scrub_write_block_to_dev_replace(sblock_bad);
 		goto out;
 	}
 
@@ -822,12 +910,15 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	}
 
-	if (sctx->readonly)
+	if (sctx->readonly && !sctx->is_dev_replace)
 		goto did_not_correct_error;
 
 	if (!is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
+nodatasum_case:
+		WARN_ON(sctx->is_dev_replace);
+
 		/*
 		 * !is_metadata and !have_csum, this means that the data
 		 * might not be COW'ed, that it might be modified
@@ -883,18 +974,79 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		if (!sblock_other->header_error &&
 		    !sblock_other->checksum_error &&
 		    sblock_other->no_io_error_seen) {
-			int force_write = is_metadata || have_csum;
-
-			ret = scrub_repair_block_from_good_copy(sblock_bad,
-								sblock_other,
-								force_write);
+			if (sctx->is_dev_replace) {
+				scrub_write_block_to_dev_replace(sblock_other);
+			} else {
+				int force_write = is_metadata || have_csum;
+
+				ret = scrub_repair_block_from_good_copy(
+						sblock_bad, sblock_other,
+						force_write);
+			}
 			if (0 == ret)
 				goto corrected_error;
 		}
 	}
 
 	/*
-	 * in case of I/O errors in the area that is supposed to be
+	 * for dev_replace, pick good pages and write to the target device.
+	 */
+	if (sctx->is_dev_replace) {
+		success = 1;
+		for (page_num = 0; page_num < sblock_bad->page_count;
+		     page_num++) {
+			int sub_success;
+
+			sub_success = 0;
+			for (mirror_index = 0;
+			     mirror_index < BTRFS_MAX_MIRRORS &&
+			     sblocks_for_recheck[mirror_index].page_count > 0;
+			     mirror_index++) {
+				struct scrub_block *sblock_other =
+					sblocks_for_recheck + mirror_index;
+				struct scrub_page *page_other =
+					sblock_other->pagev[page_num];
+
+				if (!page_other->io_error) {
+					ret = scrub_write_page_to_dev_replace(
+							sblock_other, page_num);
+					if (ret == 0) {
+						/* succeeded for this page */
+						sub_success = 1;
+						break;
+					} else {
+						btrfs_dev_replace_stats_inc(
+							&sctx->dev_root->
+							fs_info->dev_replace.
+							num_write_errors);
+					}
+				}
+			}
+
+			if (!sub_success) {
+				/*
+				 * did not find a mirror to fetch the page
+				 * from. scrub_write_page_to_dev_replace()
+				 * handles this case (page->io_error), by
+				 * filling the block with zeros before
+				 * submitting the write request
+				 */
+				success = 0;
+				ret = scrub_write_page_to_dev_replace(
+						sblock_bad, page_num);
+				if (ret)
+					btrfs_dev_replace_stats_inc(
+						&sctx->dev_root->fs_info->
+						dev_replace.num_write_errors);
+			}
+		}
+
+		goto out;
+	}
+
+	/*
+	 * for regular scrub, repair those pages that are errored.
+	 * In case of I/O errors in the area that is supposed to be
 	 * repaired, continue by picking good copies of those pages.
 	 * Select the good pages from mirrors to rewrite bad pages from
 	 * the area to fix. Afterwards verify the checksum of the block
@@ -1017,6 +1169,7 @@ out:
 
 static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_fs_info *fs_info,
+				     struct scrub_block *original_sblock,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblocks_for_recheck)
 {
@@ -1047,7 +1200,7 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 			return -EIO;
 		}
 
-		BUG_ON(page_index >= SCRUB_PAGES_PER_BIO);
+		BUG_ON(page_index >= SCRUB_PAGES_PER_RD_BIO);
 		for (mirror_index = 0; mirror_index < (int)bbio->num_stripes;
 		     mirror_index++) {
 			struct scrub_block *sblock;
@@ -1071,6 +1224,10 @@ leave_nomem:
 			sblock->pagev[page_index] = page;
 			page->logical = logical;
 			page->physical = bbio->stripes[mirror_index].physical;
+			BUG_ON(page_index >= original_sblock->page_count);
+			page->physical_for_dev_replace =
+				original_sblock->pagev[page_index]->
+				physical_for_dev_replace;
 			/* for missing devices, dev->bdev is NULL */
 			page->dev = bbio->stripes[mirror_index].dev;
 			page->mirror_num = mirror_index + 1;
@@ -1249,6 +1406,12 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		int ret;
 		DECLARE_COMPLETION_ONSTACK(complete);
 
+		if (!page_bad->dev->bdev) {
+			printk_ratelimited(KERN_WARNING
+				"btrfs: scrub_repair_page_from_good_copy(bdev == NULL) is unexpected!\n");
+			return -EIO;
+		}
+
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
@@ -1269,6 +1432,9 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		if (!bio_flagged(bio, BIO_UPTODATE)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
+			btrfs_dev_replace_stats_inc(
+				&sblock_bad->sctx->dev_root->fs_info->
+				dev_replace.num_write_errors);
 			bio_put(bio);
 			return -EIO;
 		}
@@ -1278,7 +1444,166 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 	return 0;
 }
 
-static void scrub_checksum(struct scrub_block *sblock)
+static void scrub_write_block_to_dev_replace(struct scrub_block *sblock)
+{
+	int page_num;
+
+	for (page_num = 0; page_num < sblock->page_count; page_num++) {
+		int ret;
+
+		ret = scrub_write_page_to_dev_replace(sblock, page_num);
+		if (ret)
+			btrfs_dev_replace_stats_inc(
+				&sblock->sctx->dev_root->fs_info->dev_replace.
+				num_write_errors);
+	}
+}
+
+static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
+					   int page_num)
+{
+	struct scrub_page *spage = sblock->pagev[page_num];
+
+	BUG_ON(spage->page == NULL);
+	if (spage->io_error) {
+		void *mapped_buffer = kmap_atomic(spage->page);
+
+		memset(mapped_buffer, 0, PAGE_CACHE_SIZE);
+		flush_dcache_page(spage->page);
+		kunmap_atomic(mapped_buffer);
+	}
+	return scrub_add_page_to_wr_bio(sblock->sctx, spage);
+}
+
+static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
+				    struct scrub_page *spage)
+{
+	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
+	struct scrub_bio *sbio;
+	int ret;
+
+	mutex_lock(&wr_ctx->wr_lock);
+again:
+	if (!wr_ctx->wr_curr_bio) {
+		wr_ctx->wr_curr_bio = kzalloc(sizeof(*wr_ctx->wr_curr_bio),
+					      GFP_NOFS);
+		if (!wr_ctx->wr_curr_bio)
+			return -ENOMEM;
+		wr_ctx->wr_curr_bio->sctx = sctx;
+		wr_ctx->wr_curr_bio->page_count = 0;
+	}
+	sbio = wr_ctx->wr_curr_bio;
+	if (sbio->page_count == 0) {
+		struct bio *bio;
+
+		sbio->physical = spage->physical_for_dev_replace;
+		sbio->logical = spage->logical;
+		sbio->dev = wr_ctx->tgtdev;
+		bio = sbio->bio;
+		if (!bio) {
+			bio = bio_alloc(GFP_NOFS, wr_ctx->pages_per_wr_bio);
+			if (!bio) {
+				mutex_unlock(&wr_ctx->wr_lock);
+				return -ENOMEM;
+			}
+			sbio->bio = bio;
+		}
+
+		bio->bi_private = sbio;
+		bio->bi_end_io = scrub_wr_bio_end_io;
+		bio->bi_bdev = sbio->dev->bdev;
+		bio->bi_sector = sbio->physical >> 9;
+		sbio->err = 0;
+	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
+		   spage->physical_for_dev_replace ||
+		   sbio->logical + sbio->page_count * PAGE_SIZE !=
+		   spage->logical) {
+		scrub_wr_submit(sctx);
+		goto again;
+	}
+
+	ret = bio_add_page(sbio->bio, spage->page, PAGE_SIZE, 0);
+	if (ret != PAGE_SIZE) {
+		if (sbio->page_count < 1) {
+			bio_put(sbio->bio);
+			sbio->bio = NULL;
+			mutex_unlock(&wr_ctx->wr_lock);
+			return -EIO;
+		}
+		scrub_wr_submit(sctx);
+		goto again;
+	}
+
+	sbio->pagev[sbio->page_count] = spage;
+	scrub_page_get(spage);
+	sbio->page_count++;
+	if (sbio->page_count == wr_ctx->pages_per_wr_bio)
+		scrub_wr_submit(sctx);
+	mutex_unlock(&wr_ctx->wr_lock);
+
+	return 0;
+}
+
+static void scrub_wr_submit(struct scrub_ctx *sctx)
+{
+	struct scrub_wr_ctx *wr_ctx = &sctx->wr_ctx;
+	struct scrub_bio *sbio;
+
+	if (!wr_ctx->wr_curr_bio)
+		return;
+
+	sbio = wr_ctx->wr_curr_bio;
+	wr_ctx->wr_curr_bio = NULL;
+	WARN_ON(!sbio->bio->bi_bdev);
+	scrub_pending_bio_inc(sctx);
+	/* process all writes in a single worker thread. Then the block layer
+	 * orders the requests before sending them to the driver which
+	 * doubled the write performance on spinning disks when measured
+	 * with Linux 3.5 */
+	btrfsic_submit_bio(WRITE, sbio->bio);
+}
+
+static void scrub_wr_bio_end_io(struct bio *bio, int err)
+{
+	struct scrub_bio *sbio = bio->bi_private;
+	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
+
+	sbio->err = err;
+	sbio->bio = bio;
+
+	sbio->work.func = scrub_wr_bio_end_io_worker;
+	btrfs_queue_worker(&fs_info->scrub_wr_completion_workers, &sbio->work);
+}
+
+static void scrub_wr_bio_end_io_worker(struct btrfs_work *work)
+{
+	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
+	struct scrub_ctx *sctx = sbio->sctx;
+	int i;
+
+	WARN_ON(sbio->page_count > SCRUB_PAGES_PER_WR_BIO);
+	if (sbio->err) {
+		struct btrfs_dev_replace *dev_replace =
+			&sbio->sctx->dev_root->fs_info->dev_replace;
+
+		for (i = 0; i < sbio->page_count; i++) {
+			struct scrub_page *spage = sbio->pagev[i];
+
+			spage->io_error = 1;
+			btrfs_dev_replace_stats_inc(&dev_replace->
+						    num_write_errors);
+		}
+	}
+
+	for (i = 0; i < sbio->page_count; i++)
+		scrub_page_put(sbio->pagev[i]);
+
+	bio_put(sbio->bio);
+	kfree(sbio);
+	scrub_pending_bio_dec(sctx);
+}
+
+static int scrub_checksum(struct scrub_block *sblock)
 {
 	u64 flags;
 	int ret;
@@ -1296,6 +1621,8 @@ static void scrub_checksum(struct scrub_block *sblock)
 		WARN_ON(1);
 	if (ret)
 		scrub_handle_errored_block(sblock);
+
+	return ret;
 }
 
 static int scrub_checksum_data(struct scrub_block *sblock)
@@ -1386,7 +1713,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		   BTRFS_UUID_SIZE))
 		++fail;
 
-	BUG_ON(sctx->nodesize != sctx->leafsize);
+	WARN_ON(sctx->nodesize != sctx->leafsize);
 	len = sctx->nodesize - BTRFS_CSUM_SIZE;
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
@@ -1534,11 +1861,24 @@ static void scrub_submit(struct scrub_ctx *sctx)
 	sctx->curr = -1;
 	scrub_pending_bio_inc(sctx);
 
-	btrfsic_submit_bio(READ, sbio->bio);
+	if (!sbio->bio->bi_bdev) {
+		/*
+		 * this case should not happen. If btrfs_map_block() is
+		 * wrong, it could happen for dev-replace operations on
+		 * missing devices when no mirrors are available, but in
+		 * this case it should already fail the mount.
+		 * This case is handled correctly (but _very_ slowly).
+		 */
+		printk_ratelimited(KERN_WARNING
+			"btrfs: scrub_submit(bio bdev == NULL) is unexpected!\n");
+		bio_endio(sbio->bio, -EIO);
+	} else {
+		btrfsic_submit_bio(READ, sbio->bio);
+	}
 }
 
-static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
-				 struct scrub_page *spage)
+static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
+				    struct scrub_page *spage)
 {
 	struct scrub_block *sblock = spage->sblock;
 	struct scrub_bio *sbio;
@@ -1570,7 +1910,7 @@ again:
 		sbio->dev = spage->dev;
 		bio = sbio->bio;
 		if (!bio) {
-			bio = bio_alloc(GFP_NOFS, sctx->pages_per_bio);
+			bio = bio_alloc(GFP_NOFS, sctx->pages_per_rd_bio);
 			if (!bio)
 				return -ENOMEM;
 			sbio->bio = bio;
@@ -1602,10 +1942,10 @@ again:
 		goto again;
 	}
 
-	scrub_block_get(sblock); /* one for the added page */
+	scrub_block_get(sblock); /* one for the page added to the bio */
 	atomic_inc(&sblock->outstanding_pages);
 	sbio->page_count++;
-	if (sbio->page_count == sctx->pages_per_bio)
+	if (sbio->page_count == sctx->pages_per_rd_bio)
 		scrub_submit(sctx);
 
 	return 0;
@@ -1613,7 +1953,8 @@ again:
 
 static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, struct btrfs_device *dev, u64 flags,
-		       u64 gen, int mirror_num, u8 *csum, int force)
+		       u64 gen, int mirror_num, u8 *csum, int force,
+		       u64 physical_for_dev_replace)
 {
 	struct scrub_block *sblock;
 	int index;
@@ -1654,6 +1995,7 @@ leave_nomem:
 		spage->generation = gen;
 		spage->logical = logical;
 		spage->physical = physical;
+		spage->physical_for_dev_replace = physical_for_dev_replace;
 		spage->mirror_num = mirror_num;
 		if (csum) {
 			spage->have_csum = 1;
@@ -1668,6 +2010,7 @@ leave_nomem:
 		len -= l;
 		logical += l;
 		physical += l;
+		physical_for_dev_replace += l;
 	}
 
 	WARN_ON(sblock->page_count == 0);
@@ -1675,7 +2018,7 @@ leave_nomem:
 		struct scrub_page *spage = sblock->pagev[index];
 		int ret;
 
-		ret = scrub_add_page_to_bio(sctx, spage);
+		ret = scrub_add_page_to_rd_bio(sctx, spage);
 		if (ret) {
 			scrub_block_put(sblock);
 			return ret;
@@ -1707,7 +2050,7 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 	struct scrub_ctx *sctx = sbio->sctx;
 	int i;
 
-	BUG_ON(sbio->page_count > SCRUB_PAGES_PER_BIO);
+	BUG_ON(sbio->page_count > SCRUB_PAGES_PER_RD_BIO);
 	if (sbio->err) {
 		for (i = 0; i < sbio->page_count; i++) {
 			struct scrub_page *spage = sbio->pagev[i];
@@ -1733,15 +2076,30 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 	sbio->next_free = sctx->first_free;
 	sctx->first_free = sbio->index;
 	spin_unlock(&sctx->list_lock);
+
+	if (sctx->is_dev_replace &&
+	    atomic_read(&sctx->wr_ctx.flush_all_writes)) {
+		mutex_lock(&sctx->wr_ctx.wr_lock);
+		scrub_wr_submit(sctx);
+		mutex_unlock(&sctx->wr_ctx.wr_lock);
+	}
+
 	scrub_pending_bio_dec(sctx);
 }
 
 static void scrub_block_complete(struct scrub_block *sblock)
 {
-	if (!sblock->no_io_error_seen)
+	if (!sblock->no_io_error_seen) {
 		scrub_handle_errored_block(sblock);
-	else
-		scrub_checksum(sblock);
+	} else {
+		/*
+		 * if has checksum error, write via repair mechanism in
+		 * dev replace case, otherwise write here in dev replace
+		 * case.
+		 */
+		if (!scrub_checksum(sblock) && sblock->sctx->is_dev_replace)
+			scrub_write_block_to_dev_replace(sblock);
+	}
 }
 
 static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
@@ -1786,7 +2144,7 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 /* scrub extent tries to collect up to 64 kB for each bio */
 static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 			u64 physical, struct btrfs_device *dev, u64 flags,
-			u64 gen, int mirror_num)
+			u64 gen, int mirror_num, u64 physical_for_dev_replace)
 {
 	int ret;
 	u8 csum[BTRFS_CSUM_SIZE];
@@ -1799,7 +2157,7 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 		sctx->stat.data_bytes_scrubbed += len;
 		spin_unlock(&sctx->stat_lock);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		BUG_ON(sctx->nodesize != sctx->leafsize);
+		WARN_ON(sctx->nodesize != sctx->leafsize);
 		blocksize = sctx->nodesize;
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.tree_extents_scrubbed++;
@@ -1807,7 +2165,7 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 		spin_unlock(&sctx->stat_lock);
 	} else {
 		blocksize = sctx->sectorsize;
-		BUG_ON(1);
+		WARN_ON(1);
 	}
 
 	while (len) {
@@ -1819,14 +2177,23 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 			have_csum = scrub_find_csum(sctx, logical, l, csum);
 			if (have_csum == 0)
 				++sctx->stat.no_csum;
+			if (sctx->is_dev_replace && !have_csum) {
+				ret = copy_nocow_pages(sctx, logical, l,
+						       mirror_num,
+						      physical_for_dev_replace);
+				goto behind_scrub_pages;
+			}
 		}
 		ret = scrub_pages(sctx, logical, l, physical, dev, flags, gen,
-				  mirror_num, have_csum ? csum : NULL, 0);
+				  mirror_num, have_csum ? csum : NULL, 0,
+				  physical_for_dev_replace);
+behind_scrub_pages:
 		if (ret)
 			return ret;
 		len -= l;
 		logical += l;
 		physical += l;
+		physical_for_dev_replace += l;
 	}
 	return 0;
 }
@@ -1834,7 +2201,8 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
-					   int num, u64 base, u64 length)
+					   int num, u64 base, u64 length,
+					   int is_dev_replace)
 {
 	struct btrfs_path *path;
 	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
@@ -1859,6 +2227,11 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	struct btrfs_key key_end;
 	u64 increment = map->stripe_len;
 	u64 offset;
+	u64 extent_logical;
+	u64 extent_physical;
+	u64 extent_len;
+	struct btrfs_device *extent_dev;
+	int extent_mirror_num;
 
 	nstripes = length;
 	offset = 0;
@@ -1966,9 +2339,14 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 */
 		if (atomic_read(&fs_info->scrub_pause_req)) {
 			/* push queued extents */
+			atomic_set(&sctx->wr_ctx.flush_all_writes, 1);
 			scrub_submit(sctx);
+			mutex_lock(&sctx->wr_ctx.wr_lock);
+			scrub_wr_submit(sctx);
+			mutex_unlock(&sctx->wr_ctx.wr_lock);
 			wait_event(sctx->list_wait,
 				   atomic_read(&sctx->bios_in_flight) == 0);
+			atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
 			atomic_inc(&fs_info->scrubs_paused);
 			wake_up(&fs_info->scrub_pause_wait);
 			mutex_lock(&fs_info->scrub_lock);
@@ -2063,10 +2441,20 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					     key.objectid;
 			}
 
-			ret = scrub_extent(sctx, key.objectid, key.offset,
-					   key.objectid - logical + physical,
-					   scrub_dev, flags, generation,
-					   mirror_num);
+			extent_logical = key.objectid;
+			extent_physical = key.objectid - logical + physical;
+			extent_len = key.offset;
+			extent_dev = scrub_dev;
+			extent_mirror_num = mirror_num;
+			if (is_dev_replace)
+				scrub_remap_extent(fs_info, extent_logical,
+						   extent_len, &extent_physical,
+						   &extent_dev,
+						   &extent_mirror_num);
+			ret = scrub_extent(sctx, extent_logical, extent_len,
+					   extent_physical, extent_dev, flags,
+					   generation, extent_mirror_num,
+					   key.objectid - logical + physical);
 			if (ret)
 				goto out;
 
@@ -2080,10 +2468,13 @@ next:
 		sctx->stat.last_physical = physical;
 		spin_unlock(&sctx->stat_lock);
 	}
+out:
 	/* push queued extents */
 	scrub_submit(sctx);
+	mutex_lock(&sctx->wr_ctx.wr_lock);
+	scrub_wr_submit(sctx);
+	mutex_unlock(&sctx->wr_ctx.wr_lock);
 
-out:
 	blk_finish_plug(&plug);
 	btrfs_free_path(path);
 	return ret < 0 ? ret : 0;
@@ -2093,14 +2484,14 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 					  struct btrfs_device *scrub_dev,
 					  u64 chunk_tree, u64 chunk_objectid,
 					  u64 chunk_offset, u64 length,
-					  u64 dev_offset)
+					  u64 dev_offset, int is_dev_replace)
 {
 	struct btrfs_mapping_tree *map_tree =
 		&sctx->dev_root->fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
-	int ret = -EINVAL;
+	int ret = 0;
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
@@ -2120,7 +2511,8 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 		if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
 		    map->stripes[i].physical == dev_offset) {
 			ret = scrub_stripe(sctx, map, scrub_dev, i,
-					   chunk_offset, length);
+					   chunk_offset, length,
+					   is_dev_replace);
 			if (ret)
 				goto out;
 		}
@@ -2133,7 +2525,8 @@ out:
 
 static noinline_for_stack
 int scrub_enumerate_chunks(struct scrub_ctx *sctx,
-			   struct btrfs_device *scrub_dev, u64 start, u64 end)
+			   struct btrfs_device *scrub_dev, u64 start, u64 end,
+			   int is_dev_replace)
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
@@ -2149,6 +2542,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_block_group_cache *cache;
+	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2214,11 +2608,61 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			ret = -ENOENT;
 			break;
 		}
+		dev_replace->cursor_right = found_key.offset + length;
+		dev_replace->cursor_left = found_key.offset;
+		dev_replace->item_needs_writeback = 1;
 		ret = scrub_chunk(sctx, scrub_dev, chunk_tree, chunk_objectid,
-				  chunk_offset, length, found_key.offset);
+				  chunk_offset, length, found_key.offset,
+				  is_dev_replace);
+
+		/*
+		 * flush, submit all pending read and write bios, afterwards
+		 * wait for them.
+		 * Note that in the dev replace case, a read request causes
+		 * write requests that are submitted in the read completion
+		 * worker. Therefore in the current situation, it is required
+		 * that all write requests are flushed, so that all read and
+		 * write requests are really completed when bios_in_flight
+		 * changes to 0.
+		 */
+		atomic_set(&sctx->wr_ctx.flush_all_writes, 1);
+		scrub_submit(sctx);
+		mutex_lock(&sctx->wr_ctx.wr_lock);
+		scrub_wr_submit(sctx);
+		mutex_unlock(&sctx->wr_ctx.wr_lock);
+
+		wait_event(sctx->list_wait,
+			   atomic_read(&sctx->bios_in_flight) == 0);
+		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+		atomic_inc(&fs_info->scrubs_paused);
+		wake_up(&fs_info->scrub_pause_wait);
+		wait_event(sctx->list_wait,
+			   atomic_read(&sctx->workers_pending) == 0);
+
+		mutex_lock(&fs_info->scrub_lock);
+		while (atomic_read(&fs_info->scrub_pause_req)) {
+			mutex_unlock(&fs_info->scrub_lock);
+			wait_event(fs_info->scrub_pause_wait,
+			   atomic_read(&fs_info->scrub_pause_req) == 0);
+			mutex_lock(&fs_info->scrub_lock);
+		}
+		atomic_dec(&fs_info->scrubs_paused);
+		mutex_unlock(&fs_info->scrub_lock);
+		wake_up(&fs_info->scrub_pause_wait);
+
+		dev_replace->cursor_left = dev_replace->cursor_right;
+		dev_replace->item_needs_writeback = 1;
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
+		if (atomic64_read(&dev_replace->num_write_errors) > 0) {
+			ret = -EIO;
+			break;
+		}
+		if (sctx->stat.malloc_errors > 0) {
+			ret = -ENOMEM;
+			break;
+		}
 
 		key.offset = found_key.offset + length;
 		btrfs_release_path(path);
@@ -2254,7 +2698,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 
 		ret = scrub_pages(sctx, bytenr, BTRFS_SUPER_INFO_SIZE, bytenr,
 				  scrub_dev, BTRFS_EXTENT_FLAG_SUPER, gen, i,
-				  NULL, 1);
+				  NULL, 1, bytenr);
 		if (ret)
 			return ret;
 	}
@@ -2266,18 +2710,38 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 /*
  * get a reference count on fs_info->scrub_workers. start worker if necessary
  */
-static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info)
+static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
+						int is_dev_replace)
 {
 	int ret = 0;
 
 	mutex_lock(&fs_info->scrub_lock);
 	if (fs_info->scrub_workers_refcnt == 0) {
-		btrfs_init_workers(&fs_info->scrub_workers, "scrub",
-			   fs_info->thread_pool_size, &fs_info->generic_worker);
+		if (is_dev_replace)
+			btrfs_init_workers(&fs_info->scrub_workers, "scrub", 1,
+					&fs_info->generic_worker);
+		else
+			btrfs_init_workers(&fs_info->scrub_workers, "scrub",
+					fs_info->thread_pool_size,
+					&fs_info->generic_worker);
 		fs_info->scrub_workers.idle_thresh = 4;
 		ret = btrfs_start_workers(&fs_info->scrub_workers);
 		if (ret)
 			goto out;
+		btrfs_init_workers(&fs_info->scrub_wr_completion_workers,
+				   "scrubwrc",
+				   fs_info->thread_pool_size,
+				   &fs_info->generic_worker);
+		fs_info->scrub_wr_completion_workers.idle_thresh = 2;
+		ret = btrfs_start_workers(
+				&fs_info->scrub_wr_completion_workers);
+		if (ret)
+			goto out;
+		btrfs_init_workers(&fs_info->scrub_nocow_workers, "scrubnc", 1,
+				   &fs_info->generic_worker);
+		ret = btrfs_start_workers(&fs_info->scrub_nocow_workers);
+		if (ret)
+			goto out;
 	}
 	++fs_info->scrub_workers_refcnt;
 out:
@@ -2289,8 +2753,11 @@ out:
 static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
 {
 	mutex_lock(&fs_info->scrub_lock);
-	if (--fs_info->scrub_workers_refcnt == 0)
+	if (--fs_info->scrub_workers_refcnt == 0) {
 		btrfs_stop_workers(&fs_info->scrub_workers);
+		btrfs_stop_workers(&fs_info->scrub_wr_completion_workers);
+		btrfs_stop_workers(&fs_info->scrub_nocow_workers);
+	}
 	WARN_ON(fs_info->scrub_workers_refcnt < 0);
 	mutex_unlock(&fs_info->scrub_lock);
 }
@@ -2354,7 +2821,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EINVAL;
 	}
 
-	ret = scrub_workers_get(fs_info);
+	ret = scrub_workers_get(fs_info, is_dev_replace);
 	if (ret)
 		return ret;
 
@@ -2394,12 +2861,15 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	mutex_unlock(&fs_info->scrub_lock);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
-	down_read(&fs_info->scrub_super_lock);
-	ret = scrub_supers(sctx, dev);
-	up_read(&fs_info->scrub_super_lock);
+	if (!is_dev_replace) {
+		down_read(&fs_info->scrub_super_lock);
+		ret = scrub_supers(sctx, dev);
+		up_read(&fs_info->scrub_super_lock);
+	}
 
 	if (!ret)
-		ret = scrub_enumerate_chunks(sctx, dev, start, end);
+		ret = scrub_enumerate_chunks(sctx, dev, start, end,
+					     is_dev_replace);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
@@ -2537,3 +3007,272 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 
 	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
 }
+
+static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
+			       u64 extent_logical, u64 extent_len,
+			       u64 *extent_physical,
+			       struct btrfs_device **extent_dev,
+			       int *extent_mirror_num)
+{
+	u64 mapped_length;
+	struct btrfs_bio *bbio = NULL;
+	int ret;
+
+	mapped_length = extent_len;
+	ret = btrfs_map_block(fs_info, READ, extent_logical,
+			      &mapped_length, &bbio, 0);
+	if (ret || !bbio || mapped_length < extent_len ||
+	    !bbio->stripes[0].dev->bdev) {
+		kfree(bbio);
+		return;
+	}
+
+	*extent_physical = bbio->stripes[0].physical;
+	*extent_mirror_num = bbio->mirror_num;
+	*extent_dev = bbio->stripes[0].dev;
+	kfree(bbio);
+}
+
+static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
+			      struct scrub_wr_ctx *wr_ctx,
+			      struct btrfs_fs_info *fs_info,
+			      struct btrfs_device *dev,
+			      int is_dev_replace)
+{
+	WARN_ON(wr_ctx->wr_curr_bio != NULL);
+
+	mutex_init(&wr_ctx->wr_lock);
+	wr_ctx->wr_curr_bio = NULL;
+	if (!is_dev_replace)
+		return 0;
+
+	WARN_ON(!dev->bdev);
+	wr_ctx->pages_per_wr_bio = min_t(int, SCRUB_PAGES_PER_WR_BIO,
+					 bio_get_nr_vecs(dev->bdev));
+	wr_ctx->tgtdev = dev;
+	atomic_set(&wr_ctx->flush_all_writes, 0);
+	return 0;
+}
+
+static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx)
+{
+	mutex_lock(&wr_ctx->wr_lock);
+	kfree(wr_ctx->wr_curr_bio);
+	wr_ctx->wr_curr_bio = NULL;
+	mutex_unlock(&wr_ctx->wr_lock);
+}
+
+static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
+			    int mirror_num, u64 physical_for_dev_replace)
+{
+	struct scrub_copy_nocow_ctx *nocow_ctx;
+	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
+
+	nocow_ctx = kzalloc(sizeof(*nocow_ctx), GFP_NOFS);
+	if (!nocow_ctx) {
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.malloc_errors++;
+		spin_unlock(&sctx->stat_lock);
+		return -ENOMEM;
+	}
+
+	scrub_pending_trans_workers_inc(sctx);
+
+	nocow_ctx->sctx = sctx;
+	nocow_ctx->logical = logical;
+	nocow_ctx->len = len;
+	nocow_ctx->mirror_num = mirror_num;
+	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
+	nocow_ctx->work.func = copy_nocow_pages_worker;
+	btrfs_queue_worker(&fs_info->scrub_nocow_workers,
+			   &nocow_ctx->work);
+
+	return 0;
+}
+
+static void copy_nocow_pages_worker(struct btrfs_work *work)
+{
+	struct scrub_copy_nocow_ctx *nocow_ctx =
+		container_of(work, struct scrub_copy_nocow_ctx, work);
+	struct scrub_ctx *sctx = nocow_ctx->sctx;
+	u64 logical = nocow_ctx->logical;
+	u64 len = nocow_ctx->len;
+	int mirror_num = nocow_ctx->mirror_num;
+	u64 physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
+	int ret;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+	int not_written = 0;
+
+	fs_info = sctx->dev_root->fs_info;
+	root = fs_info->extent_root;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.malloc_errors++;
+		spin_unlock(&sctx->stat_lock);
+		not_written = 1;
+		goto out;
+	}
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		not_written = 1;
+		goto out;
+	}
+
+	ret = iterate_inodes_from_logical(logical, fs_info, path,
+					  copy_nocow_pages_for_inode,
+					  nocow_ctx);
+	if (ret != 0 && ret != -ENOENT) {
+		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %llu, ret %d\n",
+			(unsigned long long)logical,
+			(unsigned long long)physical_for_dev_replace,
+			(unsigned long long)len,
+			(unsigned long long)mirror_num, ret);
+		not_written = 1;
+		goto out;
+	}
+
+out:
+	if (trans && !IS_ERR(trans))
+		btrfs_end_transaction(trans, root);
+	if (not_written)
+		btrfs_dev_replace_stats_inc(&fs_info->dev_replace.
+					    num_uncorrectable_read_errors);
+
+	btrfs_free_path(path);
+	kfree(nocow_ctx);
+
+	scrub_pending_trans_workers_dec(sctx);
+}
+
+static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	unsigned long index;
+	struct scrub_copy_nocow_ctx *nocow_ctx = ctx;
+	int ret = 0;
+	struct btrfs_key key;
+	struct inode *inode = NULL;
+	struct btrfs_root *local_root;
+	u64 physical_for_dev_replace;
+	u64 len;
+	struct btrfs_fs_info *fs_info = nocow_ctx->sctx->dev_root->fs_info;
+
+	key.objectid = root;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	local_root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(local_root))
+		return PTR_ERR(local_root);
+
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.objectid = inum;
+	key.offset = 0;
+	inode = btrfs_iget(fs_info->sb, &key, local_root, NULL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	physical_for_dev_replace = nocow_ctx->physical_for_dev_replace;
+	len = nocow_ctx->len;
+	while (len >= PAGE_CACHE_SIZE) {
+		struct page *page = NULL;
+		int ret_sub;
+
+		index = offset >> PAGE_CACHE_SHIFT;
+
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		if (!page) {
+			pr_err("find_or_create_page() failed\n");
+			ret = -ENOMEM;
+			goto next_page;
+		}
+
+		if (PageUptodate(page)) {
+			if (PageDirty(page))
+				goto next_page;
+		} else {
+			ClearPageError(page);
+			ret_sub = extent_read_full_page(&BTRFS_I(inode)->
+							 io_tree,
+							page, btrfs_get_extent,
+							nocow_ctx->mirror_num);
+			if (ret_sub) {
+				ret = ret_sub;
+				goto next_page;
+			}
+			wait_on_page_locked(page);
+			if (!PageUptodate(page)) {
+				ret = -EIO;
+				goto next_page;
+			}
+		}
+		ret_sub = write_page_nocow(nocow_ctx->sctx,
+					   physical_for_dev_replace, page);
+		if (ret_sub) {
+			ret = ret_sub;
+			goto next_page;
+		}
+
+next_page:
+		if (page) {
+			unlock_page(page);
+			put_page(page);
+		}
+		offset += PAGE_CACHE_SIZE;
+		physical_for_dev_replace += PAGE_CACHE_SIZE;
+		len -= PAGE_CACHE_SIZE;
+	}
+
+	if (inode)
+		iput(inode);
+	return ret;
+}
+
+static int write_page_nocow(struct scrub_ctx *sctx,
+			    u64 physical_for_dev_replace, struct page *page)
+{
+	struct bio *bio;
+	struct btrfs_device *dev;
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(compl);
+
+	dev = sctx->wr_ctx.tgtdev;
+	if (!dev)
+		return -EIO;
+	if (!dev->bdev) {
+		printk_ratelimited(KERN_WARNING
+			"btrfs: scrub write_page_nocow(bdev == NULL) is unexpected!\n");
+		return -EIO;
+	}
+	bio = bio_alloc(GFP_NOFS, 1);
+	if (!bio) {
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.malloc_errors++;
+		spin_unlock(&sctx->stat_lock);
+		return -ENOMEM;
+	}
+	bio->bi_private = &compl;
+	bio->bi_end_io = scrub_complete_bio_end_io;
+	bio->bi_size = 0;
+	bio->bi_sector = physical_for_dev_replace >> 9;
+	bio->bi_bdev = dev->bdev;
+	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
+	if (ret != PAGE_CACHE_SIZE) {
+leave_with_eio:
+		bio_put(bio);
+		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
+		return -EIO;
+	}
+	btrfsic_submit_bio(WRITE_SYNC, bio);
+	wait_for_completion(&compl);
+
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		goto leave_with_eio;
+
+	bio_put(bio);
+	return 0;
+}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 789c9b2..8ad5f15 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1203,7 +1203,8 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
 	btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
-	btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
+	btrfs_set_max_workers(&fs_info->scrub_wr_completion_workers,
+			      new_pool_size);
 }
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
-- 
1.8.0

