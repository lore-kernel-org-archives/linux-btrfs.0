Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:28975 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 30.22 OK)
	with ESMTP id 603df3oA6AsqHw for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/26] Btrfs: rename the scrub context structure
Date: Tue,  6 Nov 2012 17:38:19 +0100
Message-Id: <1d3041eb0f86a5f644be95da274949fbb6bdf06c.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

The device replace procedure makes use of the scrub code. The scrub
code is the most efficient code to read the allocated data of a disk,
i.e. it reads sequentially in order to avoid disk head movements, it
skips unallocated blocks, it uses read ahead mechanisms, and it
contains all the code to detect and repair defects.
This commit is a first preparation step to adapt the scrub code to
be shareable for the device replace procedure.
The block device will be removed from the scrub context state
structure in a later step. It used to be the source block device.
The scrub code as it is used for the device replace procedure reads
the source data from whereever it is optimal. The source device might
even be gone (disconnected, for instance due to a hardware failure).
Or the drive can be so faulty so that the device replace procedure
tries to avoid access to the faulty source drive as much as possible,
and only if all other mirrors are damaged, as a last resort, the
source disk is accessed.
The modified scrub code operates as if it would handle the source
drive and thereby generates an exact copy of the source disk on the
target disk, even if the source disk is not present at all. Therefore
the block device pointer to the source disk is removed in a later
patch, and therefore the context structure is renamed (this is the
goal of the current patch) to reflect that no source block device
scope is there anymore.

Summary:
This first preparation step consists of a textual substitution of the
term "dev" to the term "ctx" whereever the scrub context is used.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c   | 504 ++++++++++++++++++++++++++---------------------------
 fs/btrfs/volumes.h |   2 +-
 2 files changed, 253 insertions(+), 253 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 27892f6..29c8aac 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -42,10 +42,10 @@
  */
 
 struct scrub_block;
-struct scrub_dev;
+struct scrub_ctx;
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
-#define SCRUB_BIOS_PER_DEV	16	/* 1 MB per device in flight */
+#define SCRUB_BIOS_PER_CTX	16	/* 1 MB per device in flight */
 #define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
 struct scrub_page {
@@ -66,7 +66,7 @@ struct scrub_page {
 
 struct scrub_bio {
 	int			index;
-	struct scrub_dev	*sdev;
+	struct scrub_ctx	*sctx;
 	struct bio		*bio;
 	int			err;
 	u64			logical;
@@ -82,7 +82,7 @@ struct scrub_block {
 	int			page_count;
 	atomic_t		outstanding_pages;
 	atomic_t		ref_count; /* free mem on transition to zero */
-	struct scrub_dev	*sdev;
+	struct scrub_ctx	*sctx;
 	struct {
 		unsigned int	header_error:1;
 		unsigned int	checksum_error:1;
@@ -91,8 +91,8 @@ struct scrub_block {
 	};
 };
 
-struct scrub_dev {
-	struct scrub_bio	*bios[SCRUB_BIOS_PER_DEV];
+struct scrub_ctx {
+	struct scrub_bio	*bios[SCRUB_BIOS_PER_CTX];
 	struct btrfs_device	*dev;
 	int			first_free;
 	int			curr;
@@ -116,7 +116,7 @@ struct scrub_dev {
 };
 
 struct scrub_fixup_nodatasum {
-	struct scrub_dev	*sdev;
+	struct scrub_ctx	*sctx;
 	u64			logical;
 	struct btrfs_root	*root;
 	struct btrfs_work	work;
@@ -138,7 +138,7 @@ struct scrub_warning {
 
 
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
-static int scrub_setup_recheck_block(struct scrub_dev *sdev,
+static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_mapping_tree *map_tree,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblock);
@@ -163,9 +163,9 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock);
 static int scrub_checksum_super(struct scrub_block *sblock);
 static void scrub_block_get(struct scrub_block *sblock);
 static void scrub_block_put(struct scrub_block *sblock);
-static int scrub_add_page_to_bio(struct scrub_dev *sdev,
+static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
 				 struct scrub_page *spage);
-static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
+static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, u64 flags, u64 gen, int mirror_num,
 		       u8 *csum, int force);
 static void scrub_bio_end_io(struct bio *bio, int err);
@@ -173,27 +173,27 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 
 
-static void scrub_free_csums(struct scrub_dev *sdev)
+static void scrub_free_csums(struct scrub_ctx *sctx)
 {
-	while (!list_empty(&sdev->csum_list)) {
+	while (!list_empty(&sctx->csum_list)) {
 		struct btrfs_ordered_sum *sum;
-		sum = list_first_entry(&sdev->csum_list,
+		sum = list_first_entry(&sctx->csum_list,
 				       struct btrfs_ordered_sum, list);
 		list_del(&sum->list);
 		kfree(sum);
 	}
 }
 
-static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
+static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 {
 	int i;
 
-	if (!sdev)
+	if (!sctx)
 		return;
 
 	/* this can happen when scrub is cancelled */
-	if (sdev->curr != -1) {
-		struct scrub_bio *sbio = sdev->bios[sdev->curr];
+	if (sctx->curr != -1) {
+		struct scrub_bio *sbio = sctx->bios[sctx->curr];
 
 		for (i = 0; i < sbio->page_count; i++) {
 			BUG_ON(!sbio->pagev[i]);
@@ -203,69 +203,69 @@ static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
 		bio_put(sbio->bio);
 	}
 
-	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
-		struct scrub_bio *sbio = sdev->bios[i];
+	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
+		struct scrub_bio *sbio = sctx->bios[i];
 
 		if (!sbio)
 			break;
 		kfree(sbio);
 	}
 
-	scrub_free_csums(sdev);
-	kfree(sdev);
+	scrub_free_csums(sctx);
+	kfree(sctx);
 }
 
 static noinline_for_stack
-struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
+struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev)
 {
-	struct scrub_dev *sdev;
+	struct scrub_ctx *sctx;
 	int		i;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
 	int pages_per_bio;
 
 	pages_per_bio = min_t(int, SCRUB_PAGES_PER_BIO,
 			      bio_get_nr_vecs(dev->bdev));
-	sdev = kzalloc(sizeof(*sdev), GFP_NOFS);
-	if (!sdev)
+	sctx = kzalloc(sizeof(*sctx), GFP_NOFS);
+	if (!sctx)
 		goto nomem;
-	sdev->dev = dev;
-	sdev->pages_per_bio = pages_per_bio;
-	sdev->curr = -1;
-	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
+	sctx->dev = dev;
+	sctx->pages_per_bio = pages_per_bio;
+	sctx->curr = -1;
+	for (i = 0; i < SCRUB_BIOS_PER_CTX; ++i) {
 		struct scrub_bio *sbio;
 
 		sbio = kzalloc(sizeof(*sbio), GFP_NOFS);
 		if (!sbio)
 			goto nomem;
-		sdev->bios[i] = sbio;
+		sctx->bios[i] = sbio;
 
 		sbio->index = i;
-		sbio->sdev = sdev;
+		sbio->sctx = sctx;
 		sbio->page_count = 0;
 		sbio->work.func = scrub_bio_end_io_worker;
 
-		if (i != SCRUB_BIOS_PER_DEV-1)
-			sdev->bios[i]->next_free = i + 1;
+		if (i != SCRUB_BIOS_PER_CTX - 1)
+			sctx->bios[i]->next_free = i + 1;
 		else
-			sdev->bios[i]->next_free = -1;
-	}
-	sdev->first_free = 0;
-	sdev->nodesize = dev->dev_root->nodesize;
-	sdev->leafsize = dev->dev_root->leafsize;
-	sdev->sectorsize = dev->dev_root->sectorsize;
-	atomic_set(&sdev->in_flight, 0);
-	atomic_set(&sdev->fixup_cnt, 0);
-	atomic_set(&sdev->cancel_req, 0);
-	sdev->csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sdev->csum_list);
-
-	spin_lock_init(&sdev->list_lock);
-	spin_lock_init(&sdev->stat_lock);
-	init_waitqueue_head(&sdev->list_wait);
-	return sdev;
+			sctx->bios[i]->next_free = -1;
+	}
+	sctx->first_free = 0;
+	sctx->nodesize = dev->dev_root->nodesize;
+	sctx->leafsize = dev->dev_root->leafsize;
+	sctx->sectorsize = dev->dev_root->sectorsize;
+	atomic_set(&sctx->in_flight, 0);
+	atomic_set(&sctx->fixup_cnt, 0);
+	atomic_set(&sctx->cancel_req, 0);
+	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
+	INIT_LIST_HEAD(&sctx->csum_list);
+
+	spin_lock_init(&sctx->list_lock);
+	spin_lock_init(&sctx->stat_lock);
+	init_waitqueue_head(&sctx->list_wait);
+	return sctx;
 
 nomem:
-	scrub_free_dev(sdev);
+	scrub_free_ctx(sctx);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -345,7 +345,7 @@ err:
 
 static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 {
-	struct btrfs_device *dev = sblock->sdev->dev;
+	struct btrfs_device *dev = sblock->sctx->dev;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_key found_key;
@@ -530,21 +530,21 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 {
 	int ret;
 	struct scrub_fixup_nodatasum *fixup;
-	struct scrub_dev *sdev;
+	struct scrub_ctx *sctx;
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_path *path;
 	int uncorrectable = 0;
 
 	fixup = container_of(work, struct scrub_fixup_nodatasum, work);
-	sdev = fixup->sdev;
+	sctx = fixup->sctx;
 	fs_info = fixup->root->fs_info;
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		spin_lock(&sdev->stat_lock);
-		++sdev->stat.malloc_errors;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		++sctx->stat.malloc_errors;
+		spin_unlock(&sctx->stat_lock);
 		uncorrectable = 1;
 		goto out;
 	}
@@ -573,22 +573,22 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 	}
 	WARN_ON(ret != 1);
 
-	spin_lock(&sdev->stat_lock);
-	++sdev->stat.corrected_errors;
-	spin_unlock(&sdev->stat_lock);
+	spin_lock(&sctx->stat_lock);
+	++sctx->stat.corrected_errors;
+	spin_unlock(&sctx->stat_lock);
 
 out:
 	if (trans && !IS_ERR(trans))
 		btrfs_end_transaction(trans, fixup->root);
 	if (uncorrectable) {
-		spin_lock(&sdev->stat_lock);
-		++sdev->stat.uncorrectable_errors;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		++sctx->stat.uncorrectable_errors;
+		spin_unlock(&sctx->stat_lock);
 
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
 			(unsigned long long)fixup->logical,
-			rcu_str_deref(sdev->dev->name));
+			rcu_str_deref(sctx->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -599,9 +599,9 @@ out:
 	atomic_dec(&fs_info->scrubs_running);
 	atomic_dec(&fs_info->scrubs_paused);
 	mutex_unlock(&fs_info->scrub_lock);
-	atomic_dec(&sdev->fixup_cnt);
+	atomic_dec(&sctx->fixup_cnt);
 	wake_up(&fs_info->scrub_pause_wait);
-	wake_up(&sdev->list_wait);
+	wake_up(&sctx->list_wait);
 }
 
 /*
@@ -614,7 +614,7 @@ out:
  */
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 {
-	struct scrub_dev *sdev = sblock_to_check->sdev;
+	struct scrub_ctx *sctx = sblock_to_check->sctx;
 	struct btrfs_fs_info *fs_info;
 	u64 length;
 	u64 logical;
@@ -633,7 +633,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				      DEFAULT_RATELIMIT_BURST);
 
 	BUG_ON(sblock_to_check->page_count < 1);
-	fs_info = sdev->dev->dev_root->fs_info;
+	fs_info = sctx->dev->dev_root->fs_info;
 	length = sblock_to_check->page_count * PAGE_SIZE;
 	logical = sblock_to_check->pagev[0].logical;
 	generation = sblock_to_check->pagev[0].generation;
@@ -677,25 +677,25 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				     sizeof(*sblocks_for_recheck),
 				     GFP_NOFS);
 	if (!sblocks_for_recheck) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.malloc_errors++;
-		sdev->stat.read_errors++;
-		sdev->stat.uncorrectable_errors++;
-		spin_unlock(&sdev->stat_lock);
-		btrfs_dev_stat_inc_and_print(sdev->dev,
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.malloc_errors++;
+		sctx->stat.read_errors++;
+		sctx->stat.uncorrectable_errors++;
+		spin_unlock(&sctx->stat_lock);
+		btrfs_dev_stat_inc_and_print(sctx->dev,
 					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
 
 	/* setup the context, map the logical blocks and alloc the pages */
-	ret = scrub_setup_recheck_block(sdev, &fs_info->mapping_tree, length,
+	ret = scrub_setup_recheck_block(sctx, &fs_info->mapping_tree, length,
 					logical, sblocks_for_recheck);
 	if (ret) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.read_errors++;
-		sdev->stat.uncorrectable_errors++;
-		spin_unlock(&sdev->stat_lock);
-		btrfs_dev_stat_inc_and_print(sdev->dev,
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.read_errors++;
+		sctx->stat.uncorrectable_errors++;
+		spin_unlock(&sctx->stat_lock);
+		btrfs_dev_stat_inc_and_print(sctx->dev,
 					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
@@ -704,13 +704,13 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 
 	/* build and submit the bios for the failed mirror, check checksums */
 	ret = scrub_recheck_block(fs_info, sblock_bad, is_metadata, have_csum,
-				  csum, generation, sdev->csum_size);
+				  csum, generation, sctx->csum_size);
 	if (ret) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.read_errors++;
-		sdev->stat.uncorrectable_errors++;
-		spin_unlock(&sdev->stat_lock);
-		btrfs_dev_stat_inc_and_print(sdev->dev,
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.read_errors++;
+		sctx->stat.uncorrectable_errors++;
+		spin_unlock(&sctx->stat_lock);
+		btrfs_dev_stat_inc_and_print(sctx->dev,
 					     BTRFS_DEV_STAT_READ_ERRS);
 		goto out;
 	}
@@ -725,45 +725,45 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		 * different bio (usually one of the two latter cases is
 		 * the cause)
 		 */
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.unverified_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.unverified_errors++;
+		spin_unlock(&sctx->stat_lock);
 
 		goto out;
 	}
 
 	if (!sblock_bad->no_io_error_seen) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.read_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.read_errors++;
+		spin_unlock(&sctx->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("i/o error", sblock_to_check);
-		btrfs_dev_stat_inc_and_print(sdev->dev,
+		btrfs_dev_stat_inc_and_print(sctx->dev,
 					     BTRFS_DEV_STAT_READ_ERRS);
 	} else if (sblock_bad->checksum_error) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.csum_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.csum_errors++;
+		spin_unlock(&sctx->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum error", sblock_to_check);
-		btrfs_dev_stat_inc_and_print(sdev->dev,
+		btrfs_dev_stat_inc_and_print(sctx->dev,
 					     BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	} else if (sblock_bad->header_error) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.verify_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.verify_errors++;
+		spin_unlock(&sctx->stat_lock);
 		if (__ratelimit(&_rs))
 			scrub_print_warning("checksum/header error",
 					    sblock_to_check);
 		if (sblock_bad->generation_error)
-			btrfs_dev_stat_inc_and_print(sdev->dev,
+			btrfs_dev_stat_inc_and_print(sctx->dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sdev->dev,
+			btrfs_dev_stat_inc_and_print(sctx->dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 	}
 
-	if (sdev->readonly)
+	if (sctx->readonly)
 		goto did_not_correct_error;
 
 	if (!is_metadata && !have_csum) {
@@ -779,7 +779,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		fixup_nodatasum = kzalloc(sizeof(*fixup_nodatasum), GFP_NOFS);
 		if (!fixup_nodatasum)
 			goto did_not_correct_error;
-		fixup_nodatasum->sdev = sdev;
+		fixup_nodatasum->sctx = sctx;
 		fixup_nodatasum->logical = logical;
 		fixup_nodatasum->root = fs_info->extent_root;
 		fixup_nodatasum->mirror_num = failed_mirror_index + 1;
@@ -796,7 +796,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		atomic_inc(&fs_info->scrubs_running);
 		atomic_inc(&fs_info->scrubs_paused);
 		mutex_unlock(&fs_info->scrub_lock);
-		atomic_inc(&sdev->fixup_cnt);
+		atomic_inc(&sctx->fixup_cnt);
 		fixup_nodatasum->work.func = scrub_fixup_nodatasum;
 		btrfs_queue_worker(&fs_info->scrub_workers,
 				   &fixup_nodatasum->work);
@@ -818,7 +818,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		ret = scrub_recheck_block(fs_info,
 					  sblocks_for_recheck + mirror_index,
 					  is_metadata, have_csum, csum,
-					  generation, sdev->csum_size);
+					  generation, sctx->csum_size);
 		if (ret)
 			goto did_not_correct_error;
 	}
@@ -930,7 +930,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			 */
 			ret = scrub_recheck_block(fs_info, sblock_bad,
 						  is_metadata, have_csum, csum,
-						  generation, sdev->csum_size);
+						  generation, sctx->csum_size);
 			if (!ret && !sblock_bad->header_error &&
 			    !sblock_bad->checksum_error &&
 			    sblock_bad->no_io_error_seen)
@@ -939,23 +939,23 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 				goto did_not_correct_error;
 		} else {
 corrected_error:
-			spin_lock(&sdev->stat_lock);
-			sdev->stat.corrected_errors++;
-			spin_unlock(&sdev->stat_lock);
+			spin_lock(&sctx->stat_lock);
+			sctx->stat.corrected_errors++;
+			spin_unlock(&sctx->stat_lock);
 			printk_ratelimited_in_rcu(KERN_ERR
 				"btrfs: fixed up error at logical %llu on dev %s\n",
 				(unsigned long long)logical,
-				rcu_str_deref(sdev->dev->name));
+				rcu_str_deref(sctx->dev->name));
 		}
 	} else {
 did_not_correct_error:
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.uncorrectable_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.uncorrectable_errors++;
+		spin_unlock(&sctx->stat_lock);
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (regular) error at logical %llu on dev %s\n",
 			(unsigned long long)logical,
-			rcu_str_deref(sdev->dev->name));
+			rcu_str_deref(sctx->dev->name));
 	}
 
 out:
@@ -978,7 +978,7 @@ out:
 	return 0;
 }
 
-static int scrub_setup_recheck_block(struct scrub_dev *sdev,
+static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				     struct btrfs_mapping_tree *map_tree,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblocks_for_recheck)
@@ -988,7 +988,7 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
 	int ret;
 
 	/*
-	 * note: the three members sdev, ref_count and outstanding_pages
+	 * note: the three members sctx, ref_count and outstanding_pages
 	 * are not used (and not set) in the blocks that are used for
 	 * the recheck procedure
 	 */
@@ -1028,9 +1028,9 @@ static int scrub_setup_recheck_block(struct scrub_dev *sdev,
 			page->mirror_num = mirror_index + 1;
 			page->page = alloc_page(GFP_NOFS);
 			if (!page->page) {
-				spin_lock(&sdev->stat_lock);
-				sdev->stat.malloc_errors++;
-				spin_unlock(&sdev->stat_lock);
+				spin_lock(&sctx->stat_lock);
+				sctx->stat.malloc_errors++;
+				spin_unlock(&sctx->stat_lock);
 				kfree(bbio);
 				return -ENOMEM;
 			}
@@ -1259,14 +1259,14 @@ static void scrub_checksum(struct scrub_block *sblock)
 
 static int scrub_checksum_data(struct scrub_block *sblock)
 {
-	struct scrub_dev *sdev = sblock->sdev;
+	struct scrub_ctx *sctx = sblock->sctx;
 	u8 csum[BTRFS_CSUM_SIZE];
 	u8 *on_disk_csum;
 	struct page *page;
 	void *buffer;
 	u32 crc = ~(u32)0;
 	int fail = 0;
-	struct btrfs_root *root = sdev->dev->dev_root;
+	struct btrfs_root *root = sctx->dev->dev_root;
 	u64 len;
 	int index;
 
@@ -1278,7 +1278,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	page = sblock->pagev[0].page;
 	buffer = kmap_atomic(page);
 
-	len = sdev->sectorsize;
+	len = sctx->sectorsize;
 	index = 0;
 	for (;;) {
 		u64 l = min_t(u64, len, PAGE_SIZE);
@@ -1296,7 +1296,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	}
 
 	btrfs_csum_final(crc, csum);
-	if (memcmp(csum, on_disk_csum, sdev->csum_size))
+	if (memcmp(csum, on_disk_csum, sctx->csum_size))
 		fail = 1;
 
 	return fail;
@@ -1304,9 +1304,9 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 
 static int scrub_checksum_tree_block(struct scrub_block *sblock)
 {
-	struct scrub_dev *sdev = sblock->sdev;
+	struct scrub_ctx *sctx = sblock->sctx;
 	struct btrfs_header *h;
-	struct btrfs_root *root = sdev->dev->dev_root;
+	struct btrfs_root *root = sctx->dev->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
@@ -1324,7 +1324,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	page = sblock->pagev[0].page;
 	mapped_buffer = kmap_atomic(page);
 	h = (struct btrfs_header *)mapped_buffer;
-	memcpy(on_disk_csum, h->csum, sdev->csum_size);
+	memcpy(on_disk_csum, h->csum, sctx->csum_size);
 
 	/*
 	 * we don't use the getter functions here, as we
@@ -1345,8 +1345,8 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		   BTRFS_UUID_SIZE))
 		++fail;
 
-	BUG_ON(sdev->nodesize != sdev->leafsize);
-	len = sdev->nodesize - BTRFS_CSUM_SIZE;
+	BUG_ON(sctx->nodesize != sctx->leafsize);
+	len = sctx->nodesize - BTRFS_CSUM_SIZE;
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
 	index = 0;
@@ -1368,7 +1368,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	}
 
 	btrfs_csum_final(crc, calculated_csum);
-	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
+	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++crc_fail;
 
 	return fail || crc_fail;
@@ -1377,8 +1377,8 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 static int scrub_checksum_super(struct scrub_block *sblock)
 {
 	struct btrfs_super_block *s;
-	struct scrub_dev *sdev = sblock->sdev;
-	struct btrfs_root *root = sdev->dev->dev_root;
+	struct scrub_ctx *sctx = sblock->sctx;
+	struct btrfs_root *root = sctx->dev->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u8 calculated_csum[BTRFS_CSUM_SIZE];
 	u8 on_disk_csum[BTRFS_CSUM_SIZE];
@@ -1396,7 +1396,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	page = sblock->pagev[0].page;
 	mapped_buffer = kmap_atomic(page);
 	s = (struct btrfs_super_block *)mapped_buffer;
-	memcpy(on_disk_csum, s->csum, sdev->csum_size);
+	memcpy(on_disk_csum, s->csum, sctx->csum_size);
 
 	if (sblock->pagev[0].logical != le64_to_cpu(s->bytenr))
 		++fail_cor;
@@ -1429,7 +1429,7 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	}
 
 	btrfs_csum_final(crc, calculated_csum);
-	if (memcmp(calculated_csum, on_disk_csum, sdev->csum_size))
+	if (memcmp(calculated_csum, on_disk_csum, sctx->csum_size))
 		++fail_cor;
 
 	if (fail_cor + fail_gen) {
@@ -1438,14 +1438,14 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		 * They will get written with the next transaction commit
 		 * anyway
 		 */
-		spin_lock(&sdev->stat_lock);
-		++sdev->stat.super_errors;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		++sctx->stat.super_errors;
+		spin_unlock(&sctx->stat_lock);
 		if (fail_cor)
-			btrfs_dev_stat_inc_and_print(sdev->dev,
+			btrfs_dev_stat_inc_and_print(sctx->dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sdev->dev,
+			btrfs_dev_stat_inc_and_print(sctx->dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 	}
 
@@ -1469,21 +1469,21 @@ static void scrub_block_put(struct scrub_block *sblock)
 	}
 }
 
-static void scrub_submit(struct scrub_dev *sdev)
+static void scrub_submit(struct scrub_ctx *sctx)
 {
 	struct scrub_bio *sbio;
 
-	if (sdev->curr == -1)
+	if (sctx->curr == -1)
 		return;
 
-	sbio = sdev->bios[sdev->curr];
-	sdev->curr = -1;
-	atomic_inc(&sdev->in_flight);
+	sbio = sctx->bios[sctx->curr];
+	sctx->curr = -1;
+	atomic_inc(&sctx->in_flight);
 
 	btrfsic_submit_bio(READ, sbio->bio);
 }
 
-static int scrub_add_page_to_bio(struct scrub_dev *sdev,
+static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
 				 struct scrub_page *spage)
 {
 	struct scrub_block *sblock = spage->sblock;
@@ -1494,20 +1494,20 @@ again:
 	/*
 	 * grab a fresh bio or wait for one to become available
 	 */
-	while (sdev->curr == -1) {
-		spin_lock(&sdev->list_lock);
-		sdev->curr = sdev->first_free;
-		if (sdev->curr != -1) {
-			sdev->first_free = sdev->bios[sdev->curr]->next_free;
-			sdev->bios[sdev->curr]->next_free = -1;
-			sdev->bios[sdev->curr]->page_count = 0;
-			spin_unlock(&sdev->list_lock);
+	while (sctx->curr == -1) {
+		spin_lock(&sctx->list_lock);
+		sctx->curr = sctx->first_free;
+		if (sctx->curr != -1) {
+			sctx->first_free = sctx->bios[sctx->curr]->next_free;
+			sctx->bios[sctx->curr]->next_free = -1;
+			sctx->bios[sctx->curr]->page_count = 0;
+			spin_unlock(&sctx->list_lock);
 		} else {
-			spin_unlock(&sdev->list_lock);
-			wait_event(sdev->list_wait, sdev->first_free != -1);
+			spin_unlock(&sctx->list_lock);
+			wait_event(sctx->list_wait, sctx->first_free != -1);
 		}
 	}
-	sbio = sdev->bios[sdev->curr];
+	sbio = sctx->bios[sctx->curr];
 	if (sbio->page_count == 0) {
 		struct bio *bio;
 
@@ -1515,7 +1515,7 @@ again:
 		sbio->logical = spage->logical;
 		bio = sbio->bio;
 		if (!bio) {
-			bio = bio_alloc(GFP_NOFS, sdev->pages_per_bio);
+			bio = bio_alloc(GFP_NOFS, sctx->pages_per_bio);
 			if (!bio)
 				return -ENOMEM;
 			sbio->bio = bio;
@@ -1523,14 +1523,14 @@ again:
 
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_bio_end_io;
-		bio->bi_bdev = sdev->dev->bdev;
+		bio->bi_bdev = sctx->dev->bdev;
 		bio->bi_sector = spage->physical >> 9;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
 		   sbio->logical + sbio->page_count * PAGE_SIZE !=
 		   spage->logical) {
-		scrub_submit(sdev);
+		scrub_submit(sctx);
 		goto again;
 	}
 
@@ -1542,20 +1542,20 @@ again:
 			sbio->bio = NULL;
 			return -EIO;
 		}
-		scrub_submit(sdev);
+		scrub_submit(sctx);
 		goto again;
 	}
 
 	scrub_block_get(sblock); /* one for the added page */
 	atomic_inc(&sblock->outstanding_pages);
 	sbio->page_count++;
-	if (sbio->page_count == sdev->pages_per_bio)
-		scrub_submit(sdev);
+	if (sbio->page_count == sctx->pages_per_bio)
+		scrub_submit(sctx);
 
 	return 0;
 }
 
-static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
+static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, u64 flags, u64 gen, int mirror_num,
 		       u8 *csum, int force)
 {
@@ -1564,15 +1564,15 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 
 	sblock = kzalloc(sizeof(*sblock), GFP_NOFS);
 	if (!sblock) {
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.malloc_errors++;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.malloc_errors++;
+		spin_unlock(&sctx->stat_lock);
 		return -ENOMEM;
 	}
 
 	/* one ref inside this function, plus one for each page later on */
 	atomic_set(&sblock->ref_count, 1);
-	sblock->sdev = sdev;
+	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 
 	for (index = 0; len > 0; index++) {
@@ -1582,9 +1582,9 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
 		spage->page = alloc_page(GFP_NOFS);
 		if (!spage->page) {
-			spin_lock(&sdev->stat_lock);
-			sdev->stat.malloc_errors++;
-			spin_unlock(&sdev->stat_lock);
+			spin_lock(&sctx->stat_lock);
+			sctx->stat.malloc_errors++;
+			spin_unlock(&sctx->stat_lock);
 			while (index > 0) {
 				index--;
 				__free_page(sblock->pagev[index].page);
@@ -1593,7 +1593,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 			return -ENOMEM;
 		}
 		spage->sblock = sblock;
-		spage->dev = sdev->dev;
+		spage->dev = sctx->dev;
 		spage->flags = flags;
 		spage->generation = gen;
 		spage->logical = logical;
@@ -1601,7 +1601,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 		spage->mirror_num = mirror_num;
 		if (csum) {
 			spage->have_csum = 1;
-			memcpy(spage->csum, csum, sdev->csum_size);
+			memcpy(spage->csum, csum, sctx->csum_size);
 		} else {
 			spage->have_csum = 0;
 		}
@@ -1616,7 +1616,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 		struct scrub_page *spage = sblock->pagev + index;
 		int ret;
 
-		ret = scrub_add_page_to_bio(sdev, spage);
+		ret = scrub_add_page_to_bio(sctx, spage);
 		if (ret) {
 			scrub_block_put(sblock);
 			return ret;
@@ -1624,7 +1624,7 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 	}
 
 	if (force)
-		scrub_submit(sdev);
+		scrub_submit(sctx);
 
 	/* last one frees, either here or in bio completion for last page */
 	scrub_block_put(sblock);
@@ -1634,8 +1634,8 @@ static int scrub_pages(struct scrub_dev *sdev, u64 logical, u64 len,
 static void scrub_bio_end_io(struct bio *bio, int err)
 {
 	struct scrub_bio *sbio = bio->bi_private;
-	struct scrub_dev *sdev = sbio->sdev;
-	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
+	struct scrub_ctx *sctx = sbio->sctx;
+	struct btrfs_fs_info *fs_info = sctx->dev->dev_root->fs_info;
 
 	sbio->err = err;
 	sbio->bio = bio;
@@ -1646,7 +1646,7 @@ static void scrub_bio_end_io(struct bio *bio, int err)
 static void scrub_bio_end_io_worker(struct btrfs_work *work)
 {
 	struct scrub_bio *sbio = container_of(work, struct scrub_bio, work);
-	struct scrub_dev *sdev = sbio->sdev;
+	struct scrub_ctx *sctx = sbio->sctx;
 	int i;
 
 	BUG_ON(sbio->page_count > SCRUB_PAGES_PER_BIO);
@@ -1671,12 +1671,12 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work)
 
 	bio_put(sbio->bio);
 	sbio->bio = NULL;
-	spin_lock(&sdev->list_lock);
-	sbio->next_free = sdev->first_free;
-	sdev->first_free = sbio->index;
-	spin_unlock(&sdev->list_lock);
-	atomic_dec(&sdev->in_flight);
-	wake_up(&sdev->list_wait);
+	spin_lock(&sctx->list_lock);
+	sbio->next_free = sctx->first_free;
+	sctx->first_free = sbio->index;
+	spin_unlock(&sctx->list_lock);
+	atomic_dec(&sctx->in_flight);
+	wake_up(&sctx->list_wait);
 }
 
 static void scrub_block_complete(struct scrub_block *sblock)
@@ -1687,7 +1687,7 @@ static void scrub_block_complete(struct scrub_block *sblock)
 		scrub_checksum(sblock);
 }
 
-static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
+static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u64 len,
 			   u8 *csum)
 {
 	struct btrfs_ordered_sum *sum = NULL;
@@ -1695,15 +1695,15 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 	unsigned long i;
 	unsigned long num_sectors;
 
-	while (!list_empty(&sdev->csum_list)) {
-		sum = list_first_entry(&sdev->csum_list,
+	while (!list_empty(&sctx->csum_list)) {
+		sum = list_first_entry(&sctx->csum_list,
 				       struct btrfs_ordered_sum, list);
 		if (sum->bytenr > logical)
 			return 0;
 		if (sum->bytenr + sum->len > logical)
 			break;
 
-		++sdev->stat.csum_discards;
+		++sctx->stat.csum_discards;
 		list_del(&sum->list);
 		kfree(sum);
 		sum = NULL;
@@ -1711,10 +1711,10 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 	if (!sum)
 		return 0;
 
-	num_sectors = sum->len / sdev->sectorsize;
+	num_sectors = sum->len / sctx->sectorsize;
 	for (i = 0; i < num_sectors; ++i) {
 		if (sum->sums[i].bytenr == logical) {
-			memcpy(csum, &sum->sums[i].sum, sdev->csum_size);
+			memcpy(csum, &sum->sums[i].sum, sctx->csum_size);
 			ret = 1;
 			break;
 		}
@@ -1727,7 +1727,7 @@ static int scrub_find_csum(struct scrub_dev *sdev, u64 logical, u64 len,
 }
 
 /* scrub extent tries to collect up to 64 kB for each bio */
-static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
+static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 			u64 physical, u64 flags, u64 gen, int mirror_num)
 {
 	int ret;
@@ -1735,20 +1735,20 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 	u32 blocksize;
 
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
-		blocksize = sdev->sectorsize;
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.data_extents_scrubbed++;
-		sdev->stat.data_bytes_scrubbed += len;
-		spin_unlock(&sdev->stat_lock);
+		blocksize = sctx->sectorsize;
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.data_extents_scrubbed++;
+		sctx->stat.data_bytes_scrubbed += len;
+		spin_unlock(&sctx->stat_lock);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		BUG_ON(sdev->nodesize != sdev->leafsize);
-		blocksize = sdev->nodesize;
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.tree_extents_scrubbed++;
-		sdev->stat.tree_bytes_scrubbed += len;
-		spin_unlock(&sdev->stat_lock);
+		BUG_ON(sctx->nodesize != sctx->leafsize);
+		blocksize = sctx->nodesize;
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.tree_extents_scrubbed++;
+		sctx->stat.tree_bytes_scrubbed += len;
+		spin_unlock(&sctx->stat_lock);
 	} else {
-		blocksize = sdev->sectorsize;
+		blocksize = sctx->sectorsize;
 		BUG_ON(1);
 	}
 
@@ -1758,11 +1758,11 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 
 		if (flags & BTRFS_EXTENT_FLAG_DATA) {
 			/* push csums to sbio */
-			have_csum = scrub_find_csum(sdev, logical, l, csum);
+			have_csum = scrub_find_csum(sctx, logical, l, csum);
 			if (have_csum == 0)
-				++sdev->stat.no_csum;
+				++sctx->stat.no_csum;
 		}
-		ret = scrub_pages(sdev, logical, l, physical, flags, gen,
+		ret = scrub_pages(sctx, logical, l, physical, flags, gen,
 				  mirror_num, have_csum ? csum : NULL, 0);
 		if (ret)
 			return ret;
@@ -1773,11 +1773,11 @@ static int scrub_extent(struct scrub_dev *sdev, u64 logical, u64 len,
 	return 0;
 }
 
-static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
+static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	struct map_lookup *map, int num, u64 base, u64 length)
 {
 	struct btrfs_path *path;
-	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
+	struct btrfs_fs_info *fs_info = sctx->dev->dev_root->fs_info;
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
@@ -1843,8 +1843,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	 */
 	logical = base + offset;
 
-	wait_event(sdev->list_wait,
-		   atomic_read(&sdev->in_flight) == 0);
+	wait_event(sctx->list_wait,
+		   atomic_read(&sctx->in_flight) == 0);
 	atomic_inc(&fs_info->scrubs_paused);
 	wake_up(&fs_info->scrub_pause_wait);
 
@@ -1898,7 +1898,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 		 * canceled?
 		 */
 		if (atomic_read(&fs_info->scrub_cancel_req) ||
-		    atomic_read(&sdev->cancel_req)) {
+		    atomic_read(&sctx->cancel_req)) {
 			ret = -ECANCELED;
 			goto out;
 		}
@@ -1907,9 +1907,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 		 */
 		if (atomic_read(&fs_info->scrub_pause_req)) {
 			/* push queued extents */
-			scrub_submit(sdev);
-			wait_event(sdev->list_wait,
-				   atomic_read(&sdev->in_flight) == 0);
+			scrub_submit(sctx);
+			wait_event(sctx->list_wait,
+				   atomic_read(&sctx->in_flight) == 0);
 			atomic_inc(&fs_info->scrubs_paused);
 			wake_up(&fs_info->scrub_pause_wait);
 			mutex_lock(&fs_info->scrub_lock);
@@ -1926,7 +1926,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 
 		ret = btrfs_lookup_csums_range(csum_root, logical,
 					       logical + map->stripe_len - 1,
-					       &sdev->csum_list, 1);
+					       &sctx->csum_list, 1);
 		if (ret)
 			goto out;
 
@@ -2004,7 +2004,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 					     key.objectid;
 			}
 
-			ret = scrub_extent(sdev, key.objectid, key.offset,
+			ret = scrub_extent(sctx, key.objectid, key.offset,
 					   key.objectid - logical + physical,
 					   flags, generation, mirror_num);
 			if (ret)
@@ -2016,12 +2016,12 @@ next:
 		btrfs_release_path(path);
 		logical += increment;
 		physical += map->stripe_len;
-		spin_lock(&sdev->stat_lock);
-		sdev->stat.last_physical = physical;
-		spin_unlock(&sdev->stat_lock);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.last_physical = physical;
+		spin_unlock(&sctx->stat_lock);
 	}
 	/* push queued extents */
-	scrub_submit(sdev);
+	scrub_submit(sctx);
 
 out:
 	blk_finish_plug(&plug);
@@ -2029,12 +2029,12 @@ out:
 	return ret < 0 ? ret : 0;
 }
 
-static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
+static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length,
 	u64 dev_offset)
 {
 	struct btrfs_mapping_tree *map_tree =
-		&sdev->dev->dev_root->fs_info->mapping_tree;
+		&sctx->dev->dev_root->fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct extent_map *em;
 	int i;
@@ -2055,9 +2055,9 @@ static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 		goto out;
 
 	for (i = 0; i < map->num_stripes; ++i) {
-		if (map->stripes[i].dev == sdev->dev &&
+		if (map->stripes[i].dev == sctx->dev &&
 		    map->stripes[i].physical == dev_offset) {
-			ret = scrub_stripe(sdev, map, i, chunk_offset, length);
+			ret = scrub_stripe(sctx, map, i, chunk_offset, length);
 			if (ret)
 				goto out;
 		}
@@ -2069,11 +2069,11 @@ out:
 }
 
 static noinline_for_stack
-int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
+int scrub_enumerate_chunks(struct scrub_ctx *sctx, u64 start, u64 end)
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
-	struct btrfs_root *root = sdev->dev->dev_root;
+	struct btrfs_root *root = sctx->dev->dev_root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 length;
 	u64 chunk_tree;
@@ -2094,7 +2094,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
-	key.objectid = sdev->dev->devid;
+	key.objectid = sctx->dev->devid;
 	key.offset = 0ull;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 
@@ -2117,7 +2117,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 
 		btrfs_item_key_to_cpu(l, &found_key, slot);
 
-		if (found_key.objectid != sdev->dev->devid)
+		if (found_key.objectid != sctx->dev->devid)
 			break;
 
 		if (btrfs_key_type(&found_key) != BTRFS_DEV_EXTENT_KEY)
@@ -2151,7 +2151,7 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 			ret = -ENOENT;
 			break;
 		}
-		ret = scrub_chunk(sdev, chunk_tree, chunk_objectid,
+		ret = scrub_chunk(sctx, chunk_tree, chunk_objectid,
 				  chunk_offset, length, found_key.offset);
 		btrfs_put_block_group(cache);
 		if (ret)
@@ -2170,13 +2170,13 @@ int scrub_enumerate_chunks(struct scrub_dev *sdev, u64 start, u64 end)
 	return ret < 0 ? ret : 0;
 }
 
-static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
+static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx)
 {
 	int	i;
 	u64	bytenr;
 	u64	gen;
 	int	ret;
-	struct btrfs_device *device = sdev->dev;
+	struct btrfs_device *device = sctx->dev;
 	struct btrfs_root *root = device->dev_root;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
@@ -2189,12 +2189,12 @@ static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
 		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
 			break;
 
-		ret = scrub_pages(sdev, bytenr, BTRFS_SUPER_INFO_SIZE, bytenr,
+		ret = scrub_pages(sctx, bytenr, BTRFS_SUPER_INFO_SIZE, bytenr,
 				     BTRFS_EXTENT_FLAG_SUPER, gen, i, NULL, 1);
 		if (ret)
 			return ret;
 	}
-	wait_event(sdev->list_wait, atomic_read(&sdev->in_flight) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->in_flight) == 0);
 
 	return 0;
 }
@@ -2238,7 +2238,7 @@ static noinline_for_stack void scrub_workers_put(struct btrfs_root *root)
 int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		    struct btrfs_scrub_progress *progress, int readonly)
 {
-	struct scrub_dev *sdev;
+	struct scrub_ctx *sctx;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	struct btrfs_device *dev;
@@ -2302,41 +2302,41 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		scrub_workers_put(root);
 		return -EINPROGRESS;
 	}
-	sdev = scrub_setup_dev(dev);
-	if (IS_ERR(sdev)) {
+	sctx = scrub_setup_ctx(dev);
+	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 		scrub_workers_put(root);
-		return PTR_ERR(sdev);
+		return PTR_ERR(sctx);
 	}
-	sdev->readonly = readonly;
-	dev->scrub_device = sdev;
+	sctx->readonly = readonly;
+	dev->scrub_device = sctx;
 
 	atomic_inc(&fs_info->scrubs_running);
 	mutex_unlock(&fs_info->scrub_lock);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	down_read(&fs_info->scrub_super_lock);
-	ret = scrub_supers(sdev);
+	ret = scrub_supers(sctx);
 	up_read(&fs_info->scrub_super_lock);
 
 	if (!ret)
-		ret = scrub_enumerate_chunks(sdev, start, end);
+		ret = scrub_enumerate_chunks(sctx, start, end);
 
-	wait_event(sdev->list_wait, atomic_read(&sdev->in_flight) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
 	wake_up(&fs_info->scrub_pause_wait);
 
-	wait_event(sdev->list_wait, atomic_read(&sdev->fixup_cnt) == 0);
+	wait_event(sctx->list_wait, atomic_read(&sctx->fixup_cnt) == 0);
 
 	if (progress)
-		memcpy(progress, &sdev->stat, sizeof(*progress));
+		memcpy(progress, &sctx->stat, sizeof(*progress));
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_device = NULL;
 	mutex_unlock(&fs_info->scrub_lock);
 
-	scrub_free_dev(sdev);
+	scrub_free_ctx(sctx);
 	scrub_workers_put(root);
 
 	return ret;
@@ -2407,15 +2407,15 @@ int btrfs_scrub_cancel(struct btrfs_root *root)
 int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct scrub_dev *sdev;
+	struct scrub_ctx *sctx;
 
 	mutex_lock(&fs_info->scrub_lock);
-	sdev = dev->scrub_device;
-	if (!sdev) {
+	sctx = dev->scrub_device;
+	if (!sctx) {
 		mutex_unlock(&fs_info->scrub_lock);
 		return -ENOTCONN;
 	}
-	atomic_inc(&sdev->cancel_req);
+	atomic_inc(&sctx->cancel_req);
 	while (dev->scrub_device) {
 		mutex_unlock(&fs_info->scrub_lock);
 		wait_event(fs_info->scrub_pause_wait,
@@ -2453,15 +2453,15 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 			 struct btrfs_scrub_progress *progress)
 {
 	struct btrfs_device *dev;
-	struct scrub_dev *sdev = NULL;
+	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(root, devid, NULL, NULL);
 	if (dev)
-		sdev = dev->scrub_device;
-	if (sdev)
-		memcpy(progress, &sdev->stat, sizeof(*progress));
+		sctx = dev->scrub_device;
+	if (sctx)
+		memcpy(progress, &sctx->stat, sizeof(*progress));
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
-	return dev ? (sdev ? 0 : -ENOTCONN) : -ENODEV;
+	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
 }
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 53c06af..1789cda 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -88,7 +88,7 @@ struct btrfs_device {
 	u8 uuid[BTRFS_UUID_SIZE];
 
 	/* per-device scrub information */
-	struct scrub_dev *scrub_device;
+	struct scrub_ctx *scrub_device;
 
 	struct btrfs_work work;
 	struct rcu_head rcu;
-- 
1.8.0

