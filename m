Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:45666 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.1 OK) with ESMTP id X01bb6oA6DKwMz
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/26] Btrfs: pass fs_info to btrfs_map_block() instead of mapping_tree
Date: Tue,  6 Nov 2012 17:38:27 +0100
Message-Id: <e9b808caa8e51bd7285d71e1eff5217d556e4b44.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This is required for the device replace procedure in a later step.
Two calling functions also had to be changed to have the fs_info
pointer: repair_io_failure() and scrub_setup_recheck_block().

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/extent_io.c       | 19 +++++++++----------
 fs/btrfs/extent_io.h       |  4 ++--
 fs/btrfs/inode.c           | 12 +++++-------
 fs/btrfs/reada.c           |  3 +--
 fs/btrfs/scrub.c           | 14 +++++++-------
 fs/btrfs/volumes.c         | 11 +++++------
 fs/btrfs/volumes.h         |  2 +-
 9 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 58dfac1..8f9abed 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1582,7 +1582,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	struct btrfs_device *device;
 
 	length = len;
-	ret = btrfs_map_block(&state->root->fs_info->mapping_tree, READ,
+	ret = btrfs_map_block(state->root->fs_info, READ,
 			      bytenr, &length, &multi, mirror_num);
 
 	device = multi->stripes[0].dev;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b495cb4..4c94183 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1818,7 +1818,7 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, REQ_DISCARD,
+	ret = btrfs_map_block(root->fs_info, REQ_DISCARD,
 			      bytenr, &num_bytes, &bbio, 0);
 	/* Error condition is -ENOMEM */
 	if (!ret) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a18f5c9..82fab08 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1919,12 +1919,12 @@ static void repair_io_failure_callback(struct bio *bio, int err)
  * the standard behavior is to write all copies in a raid setup. here we only
  * want to write the one bad copy. so we do the mapping for ourselves and issue
  * submit_bio directly.
- * to avoid any synchonization issues, wait for the data after writing, which
+ * to avoid any synchronization issues, wait for the data after writing, which
  * actually prevents the read that triggered the error from finishing.
  * currently, there can be no more than two copies of every data bit. thus,
  * exactly one rewrite is required.
  */
-int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 			u64 length, u64 logical, struct page *page,
 			int mirror_num)
 {
@@ -1946,7 +1946,7 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 	bio->bi_size = 0;
 	map_length = length;
 
-	ret = btrfs_map_block(map_tree, WRITE, logical,
+	ret = btrfs_map_block(fs_info, WRITE, logical,
 			      &map_length, &bbio, mirror_num);
 	if (ret) {
 		bio_put(bio);
@@ -1984,14 +1984,13 @@ int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num)
 {
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
 	u64 start = eb->start;
 	unsigned long i, num_pages = num_extent_pages(eb->start, eb->len);
 	int ret = 0;
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
-		ret = repair_io_failure(map_tree, start, PAGE_CACHE_SIZE,
+		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
 					start, p, mirror_num);
 		if (ret)
 			break;
@@ -2010,7 +2009,7 @@ static int clean_io_failure(u64 start, struct page *page)
 	u64 private;
 	u64 private_failure;
 	struct io_failure_record *failrec;
-	struct btrfs_mapping_tree *map_tree;
+	struct btrfs_fs_info *fs_info;
 	struct extent_state *state;
 	int num_copies;
 	int did_repair = 0;
@@ -2046,11 +2045,11 @@ static int clean_io_failure(u64 start, struct page *page)
 	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
 
 	if (state && state->start == failrec->start) {
-		num_copies = btrfs_num_copies(BTRFS_I(inode)->root->fs_info,
-					      failrec->logical, failrec->len);
+		fs_info = BTRFS_I(inode)->root->fs_info;
+		num_copies = btrfs_num_copies(fs_info, failrec->logical,
+					      failrec->len);
 		if (num_copies > 1)  {
-			map_tree = &BTRFS_I(inode)->root->fs_info->mapping_tree;
-			ret = repair_io_failure(map_tree, start, failrec->len,
+			ret = repair_io_failure(fs_info, start, failrec->len,
 						failrec->logical, page,
 						failrec->failed_mirror);
 			did_repair = !ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 711d12b..2eacfab 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -337,9 +337,9 @@ struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
 
-struct btrfs_mapping_tree;
+struct btrfs_fs_info;
 
-int repair_io_failure(struct btrfs_mapping_tree *map_tree, u64 start,
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 			u64 length, u64 logical, struct page *page,
 			int mirror_num);
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3978bcb..5172a62 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1533,7 +1533,6 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-	struct btrfs_mapping_tree *map_tree;
 	u64 logical = (u64)bio->bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
@@ -1543,11 +1542,10 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 		return 0;
 
 	length = bio->bi_size;
-	map_tree = &root->fs_info->mapping_tree;
 	map_length = length;
-	ret = btrfs_map_block(map_tree, READ, logical,
+	ret = btrfs_map_block(root->fs_info, READ, logical,
 			      &map_length, NULL, 0);
-	/* Will always return 0 or 1 with map_multi == NULL */
+	/* Will always return 0 with map_multi == NULL */
 	BUG_ON(ret < 0);
 	if (map_length < length + size)
 		return 1;
@@ -6977,7 +6975,6 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 {
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
 	struct bio_vec *bvec = orig_bio->bi_io_vec;
@@ -6990,7 +6987,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int async_submit = 0;
 
 	map_length = orig_bio->bi_size;
-	ret = btrfs_map_block(map_tree, READ, start_sector << 9,
+	ret = btrfs_map_block(root->fs_info, READ, start_sector << 9,
 			      &map_length, NULL, 0);
 	if (ret) {
 		bio_put(orig_bio);
@@ -7044,7 +7041,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			bio->bi_end_io = btrfs_end_dio_bio;
 
 			map_length = orig_bio->bi_size;
-			ret = btrfs_map_block(map_tree, READ, start_sector << 9,
+			ret = btrfs_map_block(root->fs_info, READ,
+					      start_sector << 9,
 					      &map_length, NULL, 0);
 			if (ret) {
 				bio_put(bio);
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index a955669..0ddc565 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -323,7 +323,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	struct reada_extent *re = NULL;
 	struct reada_extent *re_exist = NULL;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_bio *bbio = NULL;
 	struct btrfs_device *dev;
 	struct btrfs_device *prev_dev;
@@ -358,7 +357,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	 * map block
 	 */
 	length = blocksize;
-	ret = btrfs_map_block(map_tree, REQ_WRITE, logical, &length, &bbio, 0);
+	ret = btrfs_map_block(fs_info, REQ_WRITE, logical, &length, &bbio, 0);
 	if (ret || !bbio || length < blocksize)
 		goto error;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a67b1a1..894bb27 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -152,7 +152,7 @@ static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx);
 static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx);
 static int scrub_handle_errored_block(struct scrub_block *sblock_to_check);
 static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
-				     struct btrfs_mapping_tree *map_tree,
+				     struct btrfs_fs_info *fs_info,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblock);
 static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
@@ -523,7 +523,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *ctx)
 	}
 
 	if (PageUptodate(page)) {
-		struct btrfs_mapping_tree *map_tree;
+		struct btrfs_fs_info *fs_info;
 		if (PageDirty(page)) {
 			/*
 			 * we need to write the data to the defect sector. the
@@ -544,8 +544,8 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *ctx)
 			ret = -EIO;
 			goto out;
 		}
-		map_tree = &BTRFS_I(inode)->root->fs_info->mapping_tree;
-		ret = repair_io_failure(map_tree, offset, PAGE_SIZE,
+		fs_info = BTRFS_I(inode)->root->fs_info;
+		ret = repair_io_failure(fs_info, offset, PAGE_SIZE,
 					fixup->logical, page,
 					fixup->mirror_num);
 		unlock_page(page);
@@ -754,7 +754,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	}
 
 	/* setup the context, map the logical blocks and alloc the pages */
-	ret = scrub_setup_recheck_block(sctx, &fs_info->mapping_tree, length,
+	ret = scrub_setup_recheck_block(sctx, fs_info, length,
 					logical, sblocks_for_recheck);
 	if (ret) {
 		spin_lock(&sctx->stat_lock);
@@ -1012,7 +1012,7 @@ out:
 }
 
 static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
-				     struct btrfs_mapping_tree *map_tree,
+				     struct btrfs_fs_info *fs_info,
 				     u64 length, u64 logical,
 				     struct scrub_block *sblocks_for_recheck)
 {
@@ -1036,7 +1036,7 @@ static int scrub_setup_recheck_block(struct scrub_ctx *sctx,
 		 * with a length of PAGE_SIZE, each returned stripe
 		 * represents one mirror
 		 */
-		ret = btrfs_map_block(map_tree, WRITE, logical, &mapped_length,
+		ret = btrfs_map_block(fs_info, WRITE, logical, &mapped_length,
 				      &bbio, 0);
 		if (ret || !bbio || mapped_length < sublen) {
 			kfree(bbio);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 133582b..c79f8db 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3831,13 +3831,14 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 	return optimal;
 }
 
-static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			     u64 logical, u64 *length,
 			     struct btrfs_bio **bbio_ret,
 			     int mirror_num)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct extent_map_tree *em_tree = &map_tree->map_tree;
 	u64 offset;
 	u64 stripe_offset;
@@ -4066,11 +4067,11 @@ out:
 	return ret;
 }
 
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		      u64 logical, u64 *length,
 		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
-	return __btrfs_map_block(map_tree, rw, logical, length, bbio_ret,
+	return __btrfs_map_block(fs_info, rw, logical, length, bbio_ret,
 				 mirror_num);
 }
 
@@ -4399,7 +4400,6 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		  int mirror_num, int async_submit)
 {
-	struct btrfs_mapping_tree *map_tree;
 	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
 	u64 logical = (u64)bio->bi_sector << 9;
@@ -4411,10 +4411,9 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	struct btrfs_bio *bbio = NULL;
 
 	length = bio->bi_size;
-	map_tree = &root->fs_info->mapping_tree;
 	map_length = length;
 
-	ret = btrfs_map_block(map_tree, rw, logical, &map_length, &bbio,
+	ret = btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
 			      mirror_num);
 	if (ret) /* -ENOMEM */
 		return ret;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 35ea442..ad5566d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -248,7 +248,7 @@ int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
 			   u64 chunk_offset, u64 start, u64 num_bytes);
-int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
 		    struct btrfs_bio **bbio_ret, int mirror_num);
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
-- 
1.8.0

