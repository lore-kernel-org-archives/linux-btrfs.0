From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 1/6] Btrfs: fix indents and checkpatch issues in
 dio.c.
Date: Wed, 03 Mar 2010 13:54:49 -0500
Message-ID: <4B8EB079.1050200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |  247 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 142 insertions(+), 105 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 3315cc9..84277a9 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -74,7 +74,7 @@ struct btrfs_dio_extcb {
 	struct btrfs_diocb *diocb;
 
 	struct extent_map *em;		/* chunk stripe map for this extent */
-	/* active_umc points at diocb.umc in submit and extcb.umc in completion */
+	/* active_umc is diocb.umc in submit and extcb.umc in completion */
 	struct btrfs_dio_user_mem_control *active_umc;
 	struct btrfs_dio_user_mem_control umc;
 	struct extent_buffer *leaf;
@@ -106,7 +106,7 @@ struct btrfs_dio_extcb {
 
 	int bo_used;			/* order[] bio entries in use */
 	int bo_now;			/* order[bo_now] being completed */
-	int bo_bvn;			/* order[bo_now] bi_io_vec being completed */
+	int bo_bvn;			/* order[bo_now] bi_io_vec */
 	int bo_frag;			/* bv_len unfinished on error */
 
 	struct page *csum_pg1;		/* temp read area for unaligned I/O */
@@ -120,6 +120,7 @@ struct btrfs_dio_extcb {
 
 /* single master control for user's directIO request */
 struct btrfs_diocb {
+	/* coordinate all submit, I/O interrupt, reaping, completion threads */
 	spinlock_t diolock;
 	struct kiocb *kiocb;
 	struct inode *inode;
@@ -128,7 +129,7 @@ struct btrfs_diocb {
 	u64 lockstart;
 	u64 lockend;
 	u64 begin;			/* original beginning file position */
-	u64 terminate;			/* fpos after failed submit/completion */ 
+	u64 terminate;			/* fpos after submit/completion */
 
 	struct btrfs_dio_user_mem_control umc;
 	struct workspace *workspace;
@@ -160,8 +161,9 @@ static void btrfs_dio_bi_end_io(struct bio *bio, int error);
 static void btrfs_dio_write(struct btrfs_diocb *diocb);
 static void btrfs_dio_read(struct btrfs_diocb *diocb);
 static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
-				struct btrfs_diocb *diocb, struct extent_map *em);
-static void btrfs_dio_eof_tail(u32 *filetail, int eof, struct btrfs_diocb *diocb);
+			struct btrfs_diocb *diocb, struct extent_map *em);
+static void btrfs_dio_eof_tail(u32 *filetail, int eof,
+				struct btrfs_diocb *diocb);
 static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
 				struct extent_map *lem, u64 data_len);
 static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
@@ -184,7 +186,8 @@ static int btrfs_dio_not_aligned(unsigned long iomask, u32 testlen,
 				struct btrfs_dio_user_mem_control *umc);
 static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
 				struct btrfs_dio_user_mem_control *umc);
-static void btrfs_dio_release_unused_pages(struct btrfs_dio_user_mem_control *umc);
+static void btrfs_dio_release_unused_pages(
+				struct btrfs_dio_user_mem_control *umc);
 static void btrfs_dio_skip_user_mem(struct btrfs_dio_user_mem_control *umc,
 				u32 skip_len);
 static int btrfs_dio_get_next_out(struct bio_vec *ovec,
@@ -200,8 +203,10 @@ static int btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb);
 static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb);
 static int btrfs_dio_new_bio(struct btrfs_dio_extcb *extcb, int dvn);
 static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn);
-static int btrfs_dio_add_user_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb, int dvn);
-static int btrfs_dio_add_temp_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb, int dvn);
+static int btrfs_dio_add_user_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn);
+static int btrfs_dio_add_temp_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn);
 static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len);
 static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len);
 static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb);
@@ -222,7 +227,7 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 	/* traditional 512-byte device sector alignment is the
 	 * minimum required. if they have a larger sector disk
 	 * (possibly multiple sizes in the filesystem) and need
-	 * a larger alignment for this I/O, we just fail later. 
+	 * a larger alignment for this I/O, we just fail later.
 	 */
 	if (offset & 511)
 		return -EINVAL;
@@ -231,7 +236,8 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 	 * allow 0-length vectors which are questionable but seem legal.
 	 */
 	for (seg = 0; seg < nr_segs; seg++) {
-		if (iov[seg].iov_len && ((unsigned long)iov[seg].iov_base & 511))
+		if (iov[seg].iov_len &&
+		    ((unsigned long)iov[seg].iov_base & 511))
 			return -EINVAL;
 		if (iov[seg].iov_len & 511)
 			return -EINVAL;
@@ -251,7 +257,7 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 
 	diocb->rw = rw;
 	diocb->kiocb = kiocb;
- 	diocb->start = offset;
+	diocb->start = offset;
 	diocb->begin = offset;
 	diocb->terminate = offset + done;
 	diocb->inode = inode;
@@ -292,7 +298,7 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
  */
 static void btrfs_dio_reaper(struct btrfs_work *work)
 {
-	struct btrfs_diocb *diocb = 
+	struct btrfs_diocb *diocb =
 		container_of(work, struct btrfs_diocb, reaper);
 
 	use_mm(diocb->user_mm);
@@ -317,12 +323,12 @@ static void btrfs_dio_reaper(struct btrfs_work *work)
  */
 static void btrfs_dio_aio_submit(struct btrfs_work *work)
 {
-	struct btrfs_diocb *diocb = 
+	struct btrfs_diocb *diocb =
 		container_of(work, struct btrfs_diocb, submit);
 	ssize_t done;
 
 	use_mm(diocb->user_mm);
-		
+
 	if (diocb->rw == READ)
 		btrfs_dio_read(diocb);
 	else
@@ -378,7 +384,7 @@ static void btrfs_dio_free_diocb(struct btrfs_diocb *diocb)
 /* must be called with diocb->diolock held.
  * performs "all bios are done for extcb" processing
  * to prevent submit/reap thread race
- */ 
+ */
 static void btrfs_dio_extcb_biodone(struct btrfs_dio_extcb *extcb)
 {
 	struct btrfs_diocb *diocb = extcb->diocb;
@@ -431,18 +437,19 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 	int err = 0;
 	int loop = 0;
 
-	/* expand lock region to include what we read to validate checksum */ 
+	/* expand lock region to include what we read to validate checksum */
 	diocb->lockstart = diocb->start & ~(diocb->blocksize-1);
 	diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
 
 getlock:
 	mutex_lock(&diocb->inode->i_mutex);
-		
+
 	/* ensure writeout and btree update on everything
 	 * we might read for checksum or compressed extents
 	 */
 	data_len = diocb->lockend + 1 - diocb->lockstart;
-	err = btrfs_wait_ordered_range(diocb->inode, diocb->lockstart, data_len);
+	err = btrfs_wait_ordered_range(diocb->inode,
+					diocb->lockstart, data_len);
 	if (err) {
 		diocb->error = err;
 		mutex_unlock(&diocb->inode->i_mutex);
@@ -469,28 +476,31 @@ getlock:
 		struct extent_map *em;
 		u64 len = data_len;
 
-		em = btrfs_get_extent(diocb->inode, NULL, 0, diocb->start, len, 0);
+		em = btrfs_get_extent(diocb->inode, NULL, 0,
+					diocb->start, len, 0);
 		if (!em) {
 			err = -EIO;
 			goto fail;
 		}
 
-		/* must be problem flushing ordered data with btree not updated */
+		/* problem flushing ordered data with btree not updated */
 		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
-			printk(KERN_ERR "btrfs directIO extent map incomplete ino %lu "
+			printk(KERN_ERR
+				"btrfs directIO extent map incomplete ino %lu "
 				"extent start %llu len %llu\n",
 				diocb->inode->i_ino, diocb->start, len);
 			err = -EIO;
 			goto fail;
 		}
-		
+
 		if (em->block_start == EXTENT_MAP_INLINE) {
 			/* ugly stuff because inline can exist in a large file
 			 * with other extents if a hole immediately follows.
 			 * the inline might end short of the btrfs block with
 			 * an implied hole that we need to zero here.
 			 */
-			u64 expected = min(diocb->start + len, em->start + em->len);
+			u64 expected = min(diocb->start + len,
+						em->start + em->len);
 			err = btrfs_dio_inline_read(diocb, &len);
 			if (!err && expected > diocb->start) {
 				data_len -= len;
@@ -500,17 +510,18 @@ getlock:
 		} else {
 			len = min(len, em->len - (diocb->start - em->start));
 			if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
-					em->block_start == EXTENT_MAP_HOLE) {
+			    em->block_start == EXTENT_MAP_HOLE) {
 				err = btrfs_dio_hole_read(diocb, len);
-			} else if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
-				if (diocb->lockstart > em->start || diocb->lockend <
-						em->start + em->len - 1) {
-					/* lock everything we must read to inflate */
+			} else if (test_bit(EXTENT_FLAG_COMPRESSED,
+								&em->flags)) {
+				if (diocb->lockstart > em->start ||
+				    diocb->lockend < em->start + em->len - 1) {
+					/* lock everything we read to inflate */
 					unlock_extent(io_tree, diocb->lockstart,
 						diocb->lockend, GFP_NOFS);
 					diocb->lockstart = em->start;
 					diocb->lockend = max(diocb->lockend,
-							em->start + em->len - 1);
+						em->start + em->len - 1);
 					free_extent_map(em);
 					goto getlock;
 				}
@@ -536,18 +547,19 @@ fail:
 	 * need to unlock the unprocessed remainder
 	 */
 	if (diocb->lockstart <= diocb->lockend)
-		unlock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
+		unlock_extent(io_tree, diocb->lockstart,
+					diocb->lockend, GFP_NOFS);
 }
 
 static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
-				struct btrfs_diocb *diocb, struct extent_map *em)
+			struct btrfs_diocb *diocb, struct extent_map *em)
 {
 	int devices = btrfs_map_stripe_count(em);
 	struct btrfs_dio_extcb *extcb;
 
 	extcb = kzalloc(sizeof(*extcb) +
 			sizeof(struct btrfs_dio_dev) * devices, GFP_NOFS);
-	if (!extcb)	
+	if (!extcb)
 		return -ENOMEM;
 
 	extcb->em = em;
@@ -585,7 +597,7 @@ static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
 	int err;
 	struct btrfs_dio_extcb *extcb;
 
-	/* get single extent map with device raid layout for compressed data */ 
+	/* get single extent map with device raid layout for compressed data */
 	read_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, compressed_start, compressed_len);
 	read_unlock(&em_tree->lock);
@@ -617,14 +629,15 @@ static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
 	/* read entire compressed extent into temp pages,
 	 * it must all fit in one extcb for us to inflate
 	 */
-	err = btrfs_dio_read_stripes(extcb, &compressed_start, &compressed_len, 1);
+	err = btrfs_dio_read_stripes(extcb, &compressed_start,
+					&compressed_len, 1);
 	if (compressed_len && !err)
 		err = -EIO;
 	if (!err)
 		diocb->start += data_len;
 
 	/* adjust diocb->iov and diocb->iov_left to account
- 	 * for uncompressed size so we start the next extent
+	 * for uncompressed size so we start the next extent
 	 * at the proper point in user memory
 	 */
 	btrfs_dio_skip_user_mem(&diocb->umc, data_len);
@@ -647,12 +660,13 @@ static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
  * and memcpy to user on completion the part that does not match
  * the users I/O alignment (for now always 511)
  */
-static void btrfs_dio_eof_tail(u32 *filetail, int eof, struct btrfs_diocb *diocb)
+static void btrfs_dio_eof_tail(u32 *filetail, int eof,
+				struct btrfs_diocb *diocb)
 {
 	if (eof)
 		*filetail &= 511;
 	else
-		*filetail = 0; /* aligned direct to user memory */ 
+		*filetail = 0; /* aligned direct to user memory */
 }
 
 /* called with a hard-sector bounded file byte data start/len
@@ -691,7 +705,7 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 		struct btrfs_dio_extcb *extcb;
 		u64 filelen = 0;
 
-		/* get device extent map for next contiguous chunk */ 
+		/* get device extent map for next contiguous chunk */
 		read_lock(&em_tree->lock);
 		em = lookup_extent_mapping(em_tree, data_start, data_len);
 		read_unlock(&em_tree->lock);
@@ -729,14 +743,14 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 		 * but file tail can be 1-byte aligned.  since we need
 		 * to have a temp page for checksum, we put the tail in
 		 * that page and copy it to user memory on completion so
-		 * post-xfer-memory looks the same as compressed or inline 
+		 * post-xfer-memory looks the same as compressed or inline
 		 */
 		data_len -= csum_after + filetail;
 		filelen = data_len;
 		if (data_len) {
 			/* add_user_pages submits must be done using diocb */
 			extcb->active_umc = &diocb->umc;
- 			err = btrfs_dio_read_stripes(extcb,
+			err = btrfs_dio_read_stripes(extcb,
 				&data_start, &data_len, 0);
 			filelen -= data_len;
 			if (err)
@@ -767,11 +781,13 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 							(diocb->blocksize - 1);
 					data_len -= align_size;
 					if (csum && filetail)
-						csum_after = diocb->blocksize - filetail;
+						csum_after = diocb->blocksize -
+							filetail;
 					else
 						csum_after = 0;
 					if (filetail)
-						btrfs_dio_eof_tail(&filetail, eof, diocb);
+						btrfs_dio_eof_tail(&filetail,
+								eof, diocb);
 				}
 
 				extcb->csum_pg2 = extcb->csum_pg1;
@@ -783,8 +799,9 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 					extcb->filetail = 0;
 					goto fail;
 				}
-				/* must skip area we will copy into on completion */
-				btrfs_dio_skip_user_mem(&diocb->umc, extcb->filetail);
+				/* must skip area we copy into on completion */
+				btrfs_dio_skip_user_mem(&diocb->umc,
+							extcb->filetail);
 				extcb->beforetail = filelen;
 			}
 			data_len += csum_after + filetail;
@@ -838,7 +855,7 @@ static void btfrs_dio_unplug(struct btrfs_dio_extcb *extcb)
 			btrfs_dio_submit_bio(extcb, dvn);
 		if (extcb->diodev[dvn].unplug) {
 			struct backing_dev_info *bdi = blk_get_backing_dev_info(
-						btrfs_map_stripe_bdev(extcb->em, dvn));
+					btrfs_map_stripe_bdev(extcb->em, dvn));
 			if (bdi && bdi->unplug_io_fn)
 				bdi->unplug_io_fn(bdi, NULL);
 		}
@@ -864,7 +881,8 @@ retry:
 
 		dvn = stripe_info.stripe_index;
 		extcb->diodev[dvn].physical = stripe_info.phys_offset +
-			btrfs_map_stripe_physical(extcb->em, stripe_info.stripe_index);
+			btrfs_map_stripe_physical(extcb->em,
+						stripe_info.stripe_index);
 
 		/* device start and length may not be sector aligned or
 		 * user memory address/length vectors may not be aligned
@@ -872,11 +890,12 @@ retry:
 		 * we might have different size devices in the filesystem,
 		 * so retry all copies to see if any meet the alignment.
 		 */
-		iomask = bdev_logical_block_size(btrfs_map_stripe_bdev(extcb->em, dvn)) - 1;
-		if ((extcb->diodev[dvn].physical & iomask) || (dev_left & iomask) ||
-				(!temp_pages &&
-				btrfs_dio_not_aligned(iomask, (u32)dev_left,
-							&extcb->diocb->umc))) {
+		iomask = bdev_logical_block_size(
+				btrfs_map_stripe_bdev(extcb->em, dvn)) - 1;
+		if ((extcb->diodev[dvn].physical & iomask) ||
+		    (dev_left & iomask) || (!temp_pages &&
+		    btrfs_dio_not_aligned(iomask, (u32)dev_left,
+						&extcb->diocb->umc))) {
 			if (mirror < btrfs_map_num_copies(extcb->em)) {
 				mirror++;
 				goto retry;
@@ -955,10 +974,12 @@ static void btrfs_dio_put_next_in(struct bio_vec *vec,
 			extcb->bo_bvn--;
 		} else {
 			extcb->bo_now--;
-			extcb->bo_bvn = extcb->order[extcb->bo_now]->bi_vcnt - 1;
+			extcb->bo_bvn = extcb->order[extcb->bo_now]->
+					bi_vcnt - 1;
 		}
 
-		bv_len = extcb->order[extcb->bo_now]->bi_io_vec[extcb->bo_bvn].bv_len;
+		bv_len = extcb->order[extcb->bo_now]->
+				bi_io_vec[extcb->bo_bvn].bv_len;
 		if (vec->bv_len < bv_len) {
 			extcb->bo_frag = vec->bv_len;
 			vec->bv_len = 0;
@@ -977,14 +998,15 @@ static int btrfs_dio_inflate_next_in(struct bio_vec *ivec,
 	btrfs_dio_get_next_in(ivec, extcb);
 	return 0;
 }
-	
+
 static int btrfs_dio_inline_next_in(struct bio_vec *ivec,
 				struct btrfs_inflate *icb)
 {
 	struct btrfs_dio_extcb *extcb =
 		container_of(icb, struct btrfs_dio_extcb, icb);
 
-	access_extent_buffer_page(ivec, extcb->leaf, extcb->iostart, extcb->iolen);
+	access_extent_buffer_page(ivec, extcb->leaf,
+					extcb->iostart, extcb->iolen);
 	extcb->iostart += ivec->bv_len;
 	extcb->iolen -= ivec->bv_len;
 	return 0;
@@ -1031,7 +1053,7 @@ static int btrfs_dio_get_user_bvec(struct bio_vec *uv,
 	} else {
 		/* unaligned user vectors may have multiple page releasers so
 		 * we must increment ref count now to prevent premature release
-	 	 */
+		 */
 		get_page(uv->bv_page);
 	}
 
@@ -1081,7 +1103,7 @@ static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
 	umc->remaining += uv->bv_len;
 	umc->todo += uv->bv_len;
 	if (umc->work_iov.iov_len == uv->bv_len ||
-			uv->bv_offset + uv->bv_len == PAGE_SIZE) {
+	    uv->bv_offset + uv->bv_len == PAGE_SIZE) {
 		umc->next_user_page--;
 		umc->user_pages_left++;
 	} else {
@@ -1091,7 +1113,8 @@ static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
 }
 
 /* error processing only, release unused user pages */
-static void btrfs_dio_release_unused_pages(struct btrfs_dio_user_mem_control *umc)
+static void btrfs_dio_release_unused_pages(
+				struct btrfs_dio_user_mem_control *umc)
 {
 	while (umc->user_pages_left) {
 		page_cache_release(umc->pagelist[umc->next_user_page]);
@@ -1147,8 +1170,7 @@ static void btrfs_dio_release_bios(struct btrfs_dio_extcb *extcb, int dirty)
 		for (pn = 0; pn < bio->bi_vcnt; pn++) {
 			struct page *page = bvec[pn].bv_page;
 			if (dirty && !PageCompound(page) &&
-					page != extcb->csum_pg1 &&
-					page != extcb->csum_pg2)
+			    page != extcb->csum_pg1 && page != extcb->csum_pg2)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -1168,7 +1190,8 @@ static void btrfs_dio_read_done(struct btrfs_dio_extcb *extcb)
 			char *filetail;
 			char *out;
 
-			extcb->error = btrfs_dio_get_user_bvec(&uv, extcb->active_umc);
+			extcb->error = btrfs_dio_get_user_bvec(&uv,
+							extcb->active_umc);
 			if (extcb->error) {
 				extcb->filestart -= extcb->active_umc->todo;
 				goto fail;
@@ -1190,7 +1213,7 @@ fail:
  * all-or-nothing as partial result from zlib is likely garbage.
  * we don't retry if decompression fails, the assumption is
  * all mirrors are trash because we had valid checksums.
- */ 
+ */
 static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb)
 {
 	u32 len = extcb->icb.out_len;
@@ -1203,7 +1226,8 @@ static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb)
 			struct bio_vec uv;
 			char *out;
 
-			extcb->error = btrfs_dio_get_user_bvec(&uv, &extcb->umc);
+			extcb->error = btrfs_dio_get_user_bvec(&uv,
+								&extcb->umc);
 			if (extcb->error)
 				goto fail;
 			out = kmap_atomic(uv.bv_page, KM_USER0);
@@ -1311,8 +1335,8 @@ static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb)
 			if (!err2)
 				err2 = btrfs_dio_get_workbuf(extcb);
 
-			if (!err2 && !(BTRFS_I(diocb->inode)->flags
-					& BTRFS_INODE_NODATASUM)) {
+			if (!err2 && !(BTRFS_I(diocb->inode)->
+					flags & BTRFS_INODE_NODATASUM)) {
 				err2 = btrfs_dio_read_csum(extcb);
 				if (extcb->retry_bio) {
 					btrfs_dio_drop_workbuf(extcb);
@@ -1384,9 +1408,9 @@ static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn)
  * bio is full or device read/write length remaining is 0.
  * spans memory segments in multiple io vectors that can
  * begin and end on non-page (but sector-size aligned) boundaries.
- */   
-static int btrfs_dio_add_user_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb,
-				int dvn)
+ */
+static int btrfs_dio_add_user_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn)
 {
 	extcb->active_umc->todo = *dev_left;
 	while (extcb->diodev[dvn].vecs && *dev_left) {
@@ -1411,8 +1435,8 @@ static int btrfs_dio_add_user_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb
 }
 
 /* submit kernel temporary pages for compressed read */
-static int btrfs_dio_add_temp_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb,
-				int dvn)
+static int btrfs_dio_add_temp_pages(u64 *dev_left,
+				struct btrfs_dio_extcb *extcb, int dvn)
 {
 	while (extcb->diodev[dvn].vecs && *dev_left) {
 		unsigned int pglen = min_t(long, *dev_left, PAGE_SIZE);
@@ -1475,13 +1499,15 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 
 	path = btrfs_alloc_path();
 
-	err = btrfs_lookup_file_extent(NULL, root, path, objectid, diocb->start, 0);
+	err = btrfs_lookup_file_extent(NULL, root, path, objectid,
+					diocb->start, 0);
 	if (err) {
 		if (err < 0)
 			goto notfound;
-		err= -EDOM;
+		err = -EDOM;
 		if (path->slots[0] == 0) {
-		printk(KERN_ERR "btrfs directIO inline extent leaf not found ino %lu\n",
+			printk(KERN_ERR
+				"btrfs directIO inline not found ino %lu\n",
 				diocb->inode->i_ino);
 			goto fail;
 		}
@@ -1493,11 +1519,11 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 			      struct btrfs_file_extent_item);
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 	if (found_key.objectid != objectid ||
-		btrfs_key_type(&found_key) != BTRFS_EXTENT_DATA_KEY ||
-		btrfs_file_extent_type(leaf, item) != BTRFS_FILE_EXTENT_INLINE) {
-		printk(KERN_ERR "btrfs directIO inline extent leaf mismatch ino %lu\n",
-				diocb->inode->i_ino);
-		err= -EDOM;
+	    btrfs_key_type(&found_key) != BTRFS_EXTENT_DATA_KEY ||
+	    btrfs_file_extent_type(leaf, item) != BTRFS_FILE_EXTENT_INLINE) {
+		printk(KERN_ERR "btrfs directIO inline leaf mismatch ino %lu\n",
+			diocb->inode->i_ino);
+		err = -EDOM;
 		goto fail;
 	}
 
@@ -1505,10 +1531,10 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 	/* uncompressed size */
 	size = btrfs_file_extent_inline_len(leaf, item);
 	if (diocb->start < extent_start) {
-		printk(KERN_ERR "btrfs directIO inline extent range mismatch ino %lu"
+		printk(KERN_ERR "btrfs directIO inline range mismatch ino %lu"
 			" fpos %lld found start %lld size %ld\n",
-			diocb->inode->i_ino,diocb->start,extent_start,size);
-		err= -EDOM;
+			diocb->inode->i_ino, diocb->start, extent_start, size);
+		err = -EDOM;
 		goto fail;
 	}
 
@@ -1525,8 +1551,7 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 	size = min_t(u64, *data_len, size);
 	*data_len = size;
 
-	if (btrfs_file_extent_compression(leaf, item) ==
-						BTRFS_COMPRESS_ZLIB) {
+	if (btrfs_file_extent_compression(leaf, item) == BTRFS_COMPRESS_ZLIB) {
 		struct btrfs_dio_extcb *extcb;
 
 		extcb = kzalloc(sizeof(*extcb), GFP_NOFS);
@@ -1555,7 +1580,7 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 		extcb->icb.get_next_in = btrfs_dio_inline_next_in;
 		extcb->icb.get_next_out = btrfs_dio_get_next_out;
 		extcb->icb.done_with_out = btrfs_dio_done_with_out;
-		/* NULL icb.workspace so btrfs_zlib_inflate allocates workspace */
+		/* NULL icb.workspace so btrfs_zlib_inflate allocs workspace */
 
 		extcb->leaf = leaf;
 
@@ -1615,13 +1640,15 @@ notfound:
 static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 {
 	struct bio_vec ivec;
-	struct btrfs_root *root = BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
+	struct btrfs_root *root =
+			BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
 	u32 iolen_per_csum_buf = extcb->diocb->blocksize * (extcb->tmpbuf_size
 		/ btrfs_super_csum_size(&root->fs_info->super_copy));
 
 	if (extcb->iolen & (extcb->diocb->blocksize - 1)) {
-		printk(KERN_WARNING "btrfs directIO unaligned checksum for ino %lu\n",
-				extcb->diocb->inode->i_ino);
+		printk(KERN_WARNING
+			"btrfs directIO unaligned checksum for ino %lu\n",
+			extcb->diocb->inode->i_ino);
 		extcb->iolen &= ~(extcb->diocb->blocksize - 1);
 	}
 
@@ -1633,11 +1660,14 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 		u32 csum;
 		int err;
 
-		err = btrfs_lookup_csums_range(root, extcb->iostart, end, NULL, fs_csum);
+		err = btrfs_lookup_csums_range(root, extcb->iostart, end,
+						NULL, fs_csum);
 		if (err) {
-			printk(KERN_ERR "btrfs directIO csum lookup failed ino %lu "
+			printk(KERN_ERR
+				"btrfs directIO csum lookup failed ino %lu "
 				"extent start %llu end %llu\n",
-				extcb->diocb->inode->i_ino, extcb->iostart, end);
+				extcb->diocb->inode->i_ino,
+				extcb->iostart, end);
 			return err;
 		}
 
@@ -1647,7 +1677,7 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 			/* each checksum block is a filesystem block and on the
 			 * same device, but user memory can be 512 byte aligned
 			 * so we have to be able to span multiple pages here
-			 */ 
+			 */
 			csum = ~(u32)0;
 			while (csum_len) {
 				char *in;
@@ -1657,7 +1687,8 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 					btrfs_dio_get_next_in(&ivec, extcb);
 				cl = min_t(size_t, ivec.bv_len, csum_len);
 				in = kmap_atomic(ivec.bv_page, KM_USER0);
-				csum = btrfs_csum_data(root, in + ivec.bv_offset, csum, cl);
+				csum = btrfs_csum_data(root,
+						in + ivec.bv_offset, csum, cl);
 				kunmap_atomic(in, KM_USER0);
 				ivec.bv_offset += cl;
 				ivec.bv_len -= cl;
@@ -1666,7 +1697,8 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 
 			btrfs_csum_final(csum, (char *)&csum);
 			if (csum != *fs_csum) {
-				printk(KERN_WARNING "btrfs directIO csum failed ino %lu "
+				printk(KERN_WARNING
+					"btrfs directIO csum failed ino %lu "
 					"block %llu csum %u wanted %u\n",
 					extcb->diocb->inode->i_ino,
 					extcb->iostart, csum, *fs_csum);
@@ -1695,9 +1727,11 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 				if (!extcb->iolen && extcb->filetail) {
 					extcb->filestart += extcb->filetail;
 				} else {
-					extcb->filestart += extcb->diocb->blocksize;
+					extcb->filestart +=
+						extcb->diocb->blocksize;
 					/* 1st extent can start inside block */
-					extcb->filestart &= ~(extcb->diocb->blocksize -1);
+					extcb->filestart &=
+						~(extcb->diocb->blocksize - 1);
 				}
 			}
 			len -= extcb->diocb->blocksize;
@@ -1748,7 +1782,8 @@ static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb)
 		if (extcb->compressed || !good)
 			return -EIO;
 		/* no checksum, return partial success of i/o from device */
-		if (BTRFS_I(extcb->diocb->inode)->flags & BTRFS_INODE_NODATASUM) {
+		if (BTRFS_I(extcb->diocb->inode)->
+				flags &	BTRFS_INODE_NODATASUM) {
 			extcb->filestart += good;
 			return -EIO;
 		}
@@ -1850,14 +1885,14 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 	extcb->error = 0;
 
 	if (extcb->retry_csum) {
-		struct btrfs_root *root = BTRFS_I(extcb->diocb->inode)->
-					root->fs_info->csum_root;
+		struct btrfs_root *root =
+			BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
 		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
 		char *new;
 		u32 csum = ~0;
 		size_t csum_len = extcb->retry_len;
 
-		/* blocksize can exceed page size */ 
+		/* blocksize can exceed page size */
 		while (csum_len) {
 			size_t cl = min_t(size_t, retry->bv_len, csum_len);
 			new = kmap_atomic(retry->bv_page, KM_USER0);
@@ -1884,7 +1919,7 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 		offset = extcb->retry_start & (extcb->diocb->blocksize-1);
 		retry->bv_offset += offset;
 		retry->bv_len -= offset;
-			
+
 		bad.bv_len = 0;
 		while (bad_len) {
 			size_t cl;
@@ -1893,7 +1928,8 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 
 			if (bad.bv_len == 0)
 				btrfs_dio_get_next_in(&bad, extcb);
-			cl = min_t(size_t, bad_len, min(bad.bv_len, retry->bv_len));
+			cl = min_t(size_t, bad_len,
+					min(bad.bv_len, retry->bv_len));
 			new = kmap_atomic(retry->bv_page, KM_USER0);
 			out = kmap_atomic(bad.bv_page, KM_USER1);
 			memcpy(out + bad.bv_offset, new + retry->bv_offset, cl);
@@ -1909,7 +1945,7 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 			bad_len -= cl;
 		}
 
-		/* record unfinished part of unaligned user memory for next retry */
+		/* record unfinished part of user memory for next retry */
 		btrfs_dio_put_next_in(&bad, extcb);
 	}
 
@@ -1923,11 +1959,12 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 				extcb->filestart += extcb->filetail;
 			} else {
 				extcb->filestart += extcb->diocb->blocksize;
-				extcb->filestart &= ~(extcb->diocb->blocksize -1);
+				extcb->filestart &=
+					~(extcb->diocb->blocksize - 1);
 			}
 		}
 		return 0;
-	}	
+	}
 
 	/* we are still processing bad bios from I/O submit */
 	extcb->retry_start += extcb->diocb->blocksize;
@@ -1939,7 +1976,7 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 		return btrfs_dio_retry_block(extcb);
 
 	/* continue scan with next bio */
-	if (extcb->compressed) /* uncompressed copy already incremented bo_now */
+	if (extcb->compressed) /* uncompressed copy incremented bo_now */
 		extcb->bo_now++;
 	return btrfs_dio_bad_bio_scan(extcb);
 }
-- 
1.6.3.3
