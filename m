Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:29743 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp4) (RZmta 30.22 OK)
	with ESMTP id 603df3oA6AsqHx for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/26] Btrfs: make the scrub page array dynamically allocated
Date: Tue,  6 Nov 2012 17:38:21 +0100
Message-Id: <f8b8771d4f5da58e78e69a9ee63845763f0f0151.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

With the modified design (in order to support the devive replace
procedure) it is necessary to alloc the page array dynamically.
The reason is that pages are reused. At first a page is used for
the bio to read the data from the filesystem, then the same page
is reused for the bio that writes the data to the target disk.
Since the read process and the write process are completely
decoupled, this requires a new concept of refcounts and get/put
functions for pages, and it requires to use newly created pages
for each read bio which are freed after the write operation
is finished.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 195 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 121 insertions(+), 74 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 822c08a..15ac82a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -46,6 +46,12 @@ struct scrub_ctx;
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
 #define SCRUB_BIOS_PER_CTX	16	/* 1 MB per device in flight */
+
+/*
+ * the following value times PAGE_SIZE needs to be large enough to match the
+ * largest node/leaf/sector size that shall be supported.
+ * Values larger than BTRFS_STRIPE_LEN are not supported.
+ */
 #define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
 struct scrub_page {
@@ -56,6 +62,7 @@ struct scrub_page {
 	u64			generation;
 	u64			logical;
 	u64			physical;
+	atomic_t		ref_count;
 	struct {
 		unsigned int	mirror_num:8;
 		unsigned int	have_csum:1;
@@ -79,7 +86,7 @@ struct scrub_bio {
 };
 
 struct scrub_block {
-	struct scrub_page	pagev[SCRUB_MAX_PAGES_PER_BLOCK];
+	struct scrub_page	*pagev[SCRUB_MAX_PAGES_PER_BLOCK];
 	int			page_count;
 	atomic_t		outstanding_pages;
 	atomic_t		ref_count; /* free mem on transition to zero */
@@ -165,6 +172,8 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock);
 static int scrub_checksum_super(struct scrub_block *sblock);
 static void scrub_block_get(struct scrub_block *sblock);
 static void scrub_block_put(struct scrub_block *sblock);
+static void scrub_page_get(struct scrub_page *spage);
+static void scrub_page_put(struct scrub_page *spage);
 static int scrub_add_page_to_bio(struct scrub_ctx *sctx,
 				 struct scrub_page *spage);
 static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
@@ -364,15 +373,15 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	int ret;
 
 	WARN_ON(sblock->page_count < 1);
-	dev = sblock->pagev[0].dev;
+	dev = sblock->pagev[0]->dev;
 	fs_info = sblock->sctx->dev_root->fs_info;
 
 	path = btrfs_alloc_path();
 
 	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
 	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
-	swarn.sector = (sblock->pagev[0].physical) >> 9;
-	swarn.logical = sblock->pagev[0].logical;
+	swarn.sector = (sblock->pagev[0]->physical) >> 9;
+	swarn.logical = sblock->pagev[0]->logical;
 	swarn.errstr = errstr;
 	swarn.dev = NULL;
 	swarn.msg_bufsize = bufsize;
@@ -642,15 +651,15 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	BUG_ON(sblock_to_check->page_count < 1);
 	fs_info = sctx->dev_root->fs_info;
 	length = sblock_to_check->page_count * PAGE_SIZE;
-	logical = sblock_to_check->pagev[0].logical;
-	generation = sblock_to_check->pagev[0].generation;
-	BUG_ON(sblock_to_check->pagev[0].mirror_num < 1);
-	failed_mirror_index = sblock_to_check->pagev[0].mirror_num - 1;
-	is_metadata = !(sblock_to_check->pagev[0].flags &
+	logical = sblock_to_check->pagev[0]->logical;
+	generation = sblock_to_check->pagev[0]->generation;
+	BUG_ON(sblock_to_check->pagev[0]->mirror_num < 1);
+	failed_mirror_index = sblock_to_check->pagev[0]->mirror_num - 1;
+	is_metadata = !(sblock_to_check->pagev[0]->flags &
 			BTRFS_EXTENT_FLAG_DATA);
-	have_csum = sblock_to_check->pagev[0].have_csum;
-	csum = sblock_to_check->pagev[0].csum;
-	dev = sblock_to_check->pagev[0].dev;
+	have_csum = sblock_to_check->pagev[0]->have_csum;
+	csum = sblock_to_check->pagev[0]->csum;
+	dev = sblock_to_check->pagev[0]->dev;
 
 	/*
 	 * read all mirrors one after the other. This includes to
@@ -892,7 +901,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 
 	success = 1;
 	for (page_num = 0; page_num < sblock_bad->page_count; page_num++) {
-		struct scrub_page *page_bad = sblock_bad->pagev + page_num;
+		struct scrub_page *page_bad = sblock_bad->pagev[page_num];
 
 		if (!page_bad->io_error)
 			continue;
@@ -903,8 +912,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		     mirror_index++) {
 			struct scrub_block *sblock_other = sblocks_for_recheck +
 							   mirror_index;
-			struct scrub_page *page_other = sblock_other->pagev +
-							page_num;
+			struct scrub_page *page_other = sblock_other->pagev[
+							page_num];
 
 			if (!page_other->io_error) {
 				ret = scrub_repair_page_from_good_copy(
@@ -971,11 +980,11 @@ out:
 						     mirror_index;
 			int page_index;
 
-			for (page_index = 0; page_index < SCRUB_PAGES_PER_BIO;
-			     page_index++)
-				if (sblock->pagev[page_index].page)
-					__free_page(
-						sblock->pagev[page_index].page);
+			for (page_index = 0; page_index < sblock->page_count;
+			     page_index++) {
+				sblock->pagev[page_index]->sblock = NULL;
+				scrub_page_put(sblock->pagev[page_index]);
+			}
 		}
 		kfree(sblocks_for_recheck);
 	}
@@ -993,7 +1002,7 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 	int ret;
 
 	/*
-	 * note: the three members sctx, ref_count and outstanding_pages
+	 * note: the two members ref_count and outstanding_pages
 	 * are not used (and not set) in the blocks that are used for
 	 * the recheck procedure
 	 */
@@ -1025,21 +1034,27 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 				continue;
 
 			sblock = sblocks_for_recheck + mirror_index;
-			page = sblock->pagev + page_index;
-			page->logical = logical;
-			page->physical = bbio->stripes[mirror_index].physical;
-			/* for missing devices, dev->bdev is NULL */
-			page->dev = bbio->stripes[mirror_index].dev;
-			page->mirror_num = mirror_index + 1;
-			page->page = alloc_page(GFP_NOFS);
-			if (!page->page) {
+			sblock->sctx = sctx;
+			page = kzalloc(sizeof(*page), GFP_NOFS);
+			if (!page) {
+leave_nomem:
 				spin_lock(&sctx->stat_lock);
 				sctx->stat.malloc_errors++;
 				spin_unlock(&sctx->stat_lock);
 				kfree(bbio);
 				return -ENOMEM;
 			}
+			scrub_page_get(page);
+			sblock->pagev[page_index] = page;
+			page->logical = logical;
+			page->physical = bbio->stripes[mirror_index].physical;
+			/* for missing devices, dev->bdev is NULL */
+			page->dev = bbio->stripes[mirror_index].dev;
+			page->mirror_num = mirror_index + 1;
 			sblock->page_count++;
+			page->page = alloc_page(GFP_NOFS);
+			if (!page->page)
+				goto leave_nomem;
 		}
 		kfree(bbio);
 		length -= sublen;
@@ -1071,7 +1086,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 	for (page_num = 0; page_num < sblock->page_count; page_num++) {
 		struct bio *bio;
 		int ret;
-		struct scrub_page *page = sblock->pagev + page_num;
+		struct scrub_page *page = sblock->pagev[page_num];
 		DECLARE_COMPLETION_ONSTACK(complete);
 
 		if (page->dev->bdev == NULL) {
@@ -1080,7 +1095,7 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 			continue;
 		}
 
-		BUG_ON(!page->page);
+		WARN_ON(!page->page);
 		bio = bio_alloc(GFP_NOFS, 1);
 		if (!bio)
 			return -EIO;
@@ -1125,14 +1140,14 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root = fs_info->extent_root;
 	void *mapped_buffer;
 
-	BUG_ON(!sblock->pagev[0].page);
+	WARN_ON(!sblock->pagev[0]->page);
 	if (is_metadata) {
 		struct btrfs_header *h;
 
-		mapped_buffer = kmap_atomic(sblock->pagev[0].page);
+		mapped_buffer = kmap_atomic(sblock->pagev[0]->page);
 		h = (struct btrfs_header *)mapped_buffer;
 
-		if (sblock->pagev[0].logical != le64_to_cpu(h->bytenr) ||
+		if (sblock->pagev[0]->logical != le64_to_cpu(h->bytenr) ||
 		    memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE) ||
 		    memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
 			   BTRFS_UUID_SIZE)) {
@@ -1146,7 +1161,7 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		if (!have_csum)
 			return;
 
-		mapped_buffer = kmap_atomic(sblock->pagev[0].page);
+		mapped_buffer = kmap_atomic(sblock->pagev[0]->page);
 	}
 
 	for (page_num = 0;;) {
@@ -1162,9 +1177,9 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		page_num++;
 		if (page_num >= sblock->page_count)
 			break;
-		BUG_ON(!sblock->pagev[page_num].page);
+		WARN_ON(!sblock->pagev[page_num]->page);
 
-		mapped_buffer = kmap_atomic(sblock->pagev[page_num].page);
+		mapped_buffer = kmap_atomic(sblock->pagev[page_num]->page);
 	}
 
 	btrfs_csum_final(crc, calculated_csum);
@@ -1202,11 +1217,11 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 					    struct scrub_block *sblock_good,
 					    int page_num, int force_write)
 {
-	struct scrub_page *page_bad = sblock_bad->pagev + page_num;
-	struct scrub_page *page_good = sblock_good->pagev + page_num;
+	struct scrub_page *page_bad = sblock_bad->pagev[page_num];
+	struct scrub_page *page_good = sblock_good->pagev[page_num];
 
-	BUG_ON(sblock_bad->pagev[page_num].page == NULL);
-	BUG_ON(sblock_good->pagev[page_num].page == NULL);
+	BUG_ON(page_bad->page == NULL);
+	BUG_ON(page_good->page == NULL);
 	if (force_write || sblock_bad->header_error ||
 	    sblock_bad->checksum_error || page_bad->io_error) {
 		struct bio *bio;
@@ -1247,8 +1262,8 @@ static void scrub_checksum(struct scrub_block *sblock)
 	u64 flags;
 	int ret;
 
-	BUG_ON(sblock->page_count < 1);
-	flags = sblock->pagev[0].flags;
+	WARN_ON(sblock->page_count < 1);
+	flags = sblock->pagev[0]->flags;
 	ret = 0;
 	if (flags & BTRFS_EXTENT_FLAG_DATA)
 		ret = scrub_checksum_data(sblock);
@@ -1276,11 +1291,11 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	int index;
 
 	BUG_ON(sblock->page_count < 1);
-	if (!sblock->pagev[0].have_csum)
+	if (!sblock->pagev[0]->have_csum)
 		return 0;
 
-	on_disk_csum = sblock->pagev[0].csum;
-	page = sblock->pagev[0].page;
+	on_disk_csum = sblock->pagev[0]->csum;
+	page = sblock->pagev[0]->page;
 	buffer = kmap_atomic(page);
 
 	len = sctx->sectorsize;
@@ -1295,8 +1310,8 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 			break;
 		index++;
 		BUG_ON(index >= sblock->page_count);
-		BUG_ON(!sblock->pagev[index].page);
-		page = sblock->pagev[index].page;
+		BUG_ON(!sblock->pagev[index]->page);
+		page = sblock->pagev[index]->page;
 		buffer = kmap_atomic(page);
 	}
 
@@ -1326,7 +1341,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	int index;
 
 	BUG_ON(sblock->page_count < 1);
-	page = sblock->pagev[0].page;
+	page = sblock->pagev[0]->page;
 	mapped_buffer = kmap_atomic(page);
 	h = (struct btrfs_header *)mapped_buffer;
 	memcpy(on_disk_csum, h->csum, sctx->csum_size);
@@ -1337,10 +1352,10 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	 * b) the page is already kmapped
 	 */
 
-	if (sblock->pagev[0].logical != le64_to_cpu(h->bytenr))
+	if (sblock->pagev[0]->logical != le64_to_cpu(h->bytenr))
 		++fail;
 
-	if (sblock->pagev[0].generation != le64_to_cpu(h->generation))
+	if (sblock->pagev[0]->generation != le64_to_cpu(h->generation))
 		++fail;
 
 	if (memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
@@ -1365,8 +1380,8 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 			break;
 		index++;
 		BUG_ON(index >= sblock->page_count);
-		BUG_ON(!sblock->pagev[index].page);
-		page = sblock->pagev[index].page;
+		BUG_ON(!sblock->pagev[index]->page);
+		page = sblock->pagev[index]->page;
 		mapped_buffer = kmap_atomic(page);
 		mapped_size = PAGE_SIZE;
 		p = mapped_buffer;
@@ -1398,15 +1413,15 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	int index;
 
 	BUG_ON(sblock->page_count < 1);
-	page = sblock->pagev[0].page;
+	page = sblock->pagev[0]->page;
 	mapped_buffer = kmap_atomic(page);
 	s = (struct btrfs_super_block *)mapped_buffer;
 	memcpy(on_disk_csum, s->csum, sctx->csum_size);
 
-	if (sblock->pagev[0].logical != le64_to_cpu(s->bytenr))
+	if (sblock->pagev[0]->logical != le64_to_cpu(s->bytenr))
 		++fail_cor;
 
-	if (sblock->pagev[0].generation != le64_to_cpu(s->generation))
+	if (sblock->pagev[0]->generation != le64_to_cpu(s->generation))
 		++fail_gen;
 
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
@@ -1426,8 +1441,8 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 			break;
 		index++;
 		BUG_ON(index >= sblock->page_count);
-		BUG_ON(!sblock->pagev[index].page);
-		page = sblock->pagev[index].page;
+		BUG_ON(!sblock->pagev[index]->page);
+		page = sblock->pagev[index]->page;
 		mapped_buffer = kmap_atomic(page);
 		mapped_size = PAGE_SIZE;
 		p = mapped_buffer;
@@ -1447,10 +1462,10 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 		++sctx->stat.super_errors;
 		spin_unlock(&sctx->stat_lock);
 		if (fail_cor)
-			btrfs_dev_stat_inc_and_print(sblock->pagev[0].dev,
+			btrfs_dev_stat_inc_and_print(sblock->pagev[0]->dev,
 				BTRFS_DEV_STAT_CORRUPTION_ERRS);
 		else
-			btrfs_dev_stat_inc_and_print(sblock->pagev[0].dev,
+			btrfs_dev_stat_inc_and_print(sblock->pagev[0]->dev,
 				BTRFS_DEV_STAT_GENERATION_ERRS);
 	}
 
@@ -1468,12 +1483,25 @@ static void scrub_block_put(struct scrub_block *sblock)
 		int i;
 
 		for (i = 0; i < sblock->page_count; i++)
-			if (sblock->pagev[i].page)
-				__free_page(sblock->pagev[i].page);
+			scrub_page_put(sblock->pagev[i]);
 		kfree(sblock);
 	}
 }
 
+static void scrub_page_get(struct scrub_page *spage)
+{
+	atomic_inc(&spage->ref_count);
+}
+
+static void scrub_page_put(struct scrub_page *spage)
+{
+	if (atomic_dec_and_test(&spage->ref_count)) {
+		if (spage->page)
+			__free_page(spage->page);
+		kfree(spage);
+	}
+}
+
 static void scrub_submit(struct scrub_ctx *sctx)
 {
 	struct scrub_bio *sbio;
@@ -1577,28 +1605,28 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		return -ENOMEM;
 	}
 
-	/* one ref inside this function, plus one for each page later on */
+	/* one ref inside this function, plus one for each page added to
+	 * a bio later on */
 	atomic_set(&sblock->ref_count, 1);
 	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 
 	for (index = 0; len > 0; index++) {
-		struct scrub_page *spage = sblock->pagev + index;
+		struct scrub_page *spage;
 		u64 l = min_t(u64, len, PAGE_SIZE);
 
-		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
-		spage->page = alloc_page(GFP_NOFS);
-		if (!spage->page) {
+		spage = kzalloc(sizeof(*spage), GFP_NOFS);
+		if (!spage) {
+leave_nomem:
 			spin_lock(&sctx->stat_lock);
 			sctx->stat.malloc_errors++;
 			spin_unlock(&sctx->stat_lock);
-			while (index > 0) {
-				index--;
-				__free_page(sblock->pagev[index].page);
-			}
-			kfree(sblock);
+			scrub_block_put(sblock);
 			return -ENOMEM;
 		}
+		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
+		scrub_page_get(spage);
+		sblock->pagev[index] = spage;
 		spage->sblock = sblock;
 		spage->dev = dev;
 		spage->flags = flags;
@@ -1613,14 +1641,17 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			spage->have_csum = 0;
 		}
 		sblock->page_count++;
+		spage->page = alloc_page(GFP_NOFS);
+		if (!spage->page)
+			goto leave_nomem;
 		len -= l;
 		logical += l;
 		physical += l;
 	}
 
-	BUG_ON(sblock->page_count == 0);
+	WARN_ON(sblock->page_count == 0);
 	for (index = 0; index < sblock->page_count; index++) {
-		struct scrub_page *spage = sblock->pagev + index;
+		struct scrub_page *spage = sblock->pagev[index];
 		int ret;
 
 		ret = scrub_add_page_to_bio(sctx, spage);
@@ -2289,6 +2320,22 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		return -EINVAL;
 	}
 
+	if (fs_info->chunk_root->nodesize >
+	    PAGE_SIZE * SCRUB_MAX_PAGES_PER_BLOCK ||
+	    fs_info->chunk_root->sectorsize >
+	    PAGE_SIZE * SCRUB_MAX_PAGES_PER_BLOCK) {
+		/*
+		 * would exhaust the array bounds of pagev member in
+		 * struct scrub_block
+		 */
+		pr_err("btrfs_scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
+		       fs_info->chunk_root->nodesize,
+		       SCRUB_MAX_PAGES_PER_BLOCK,
+		       fs_info->chunk_root->sectorsize,
+		       SCRUB_MAX_PAGES_PER_BLOCK);
+		return -EINVAL;
+	}
+
 	ret = scrub_workers_get(root);
 	if (ret)
 		return ret;
-- 
1.8.0

