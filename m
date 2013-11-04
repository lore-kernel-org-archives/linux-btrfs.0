Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37179 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3KDXgo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:44 -0500
Received: by mail-pb0-f45.google.com with SMTP id ma3so7780230pbc.32
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:43 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 5/9] block: Gut bio_add_page(), kill bio_add_pc_page()
Date: Mon,  4 Nov 2013 15:36:23 -0800
Message-Id: <1383608187-27368-6-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since generic_make_request() can now handle arbitrary size bios, all we
have to do is make sure the bvec array doesn't overflow.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/scsi/osd/osd_initiator.c   |   5 +-
 drivers/target/target_core_pscsi.c |   5 +-
 fs/bio.c                           | 158 +++++++------------------------------
 fs/exofs/ore.c                     |   8 +-
 fs/exofs/ore_raid.c                |   8 +-
 include/linux/bio.h                |   2 -
 6 files changed, 37 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index bac04c2..e52b30d 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1043,7 +1043,6 @@ EXPORT_SYMBOL(osd_req_read_sg);
 static struct bio *_create_sg_bios(struct osd_request *or,
 	void **buff, const struct osd_sg_entry *sglist, unsigned numentries)
 {
-	struct request_queue *q = osd_request_queue(or->osd_dev);
 	struct bio *bio;
 	unsigned i;
 
@@ -1060,9 +1059,9 @@ static struct bio *_create_sg_bios(struct osd_request *or,
 		unsigned added_len;
 
 		BUG_ON(offset + len > PAGE_SIZE);
-		added_len = bio_add_pc_page(q, bio, page, len, offset);
+		added_len = bio_add_page(bio, page, len, offset);
 		if (unlikely(len != added_len)) {
-			OSD_DEBUG("bio_add_pc_page len(%d) != added_len(%d)\n",
+			OSD_DEBUG("bio_add_page len(%d) != added_len(%d)\n",
 				  len, added_len);
 			bio_put(bio);
 			return ERR_PTR(-ENOMEM);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 551c96c..d65d512 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -922,12 +922,11 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					tbio = tbio->bi_next = bio;
 			}
 
-			pr_debug("PSCSI: Calling bio_add_pc_page() i: %d"
+			pr_debug("PSCSI: Calling bio_add_page() i: %d"
 				" bio: %p page: %p len: %d off: %d\n", i, bio,
 				page, len, off);
 
-			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
-					bio, page, bytes, off);
+			rc = bio_add_page(bio, page, bytes, off);
 			if (rc != bytes)
 				goto fail;
 
diff --git a/fs/bio.c b/fs/bio.c
index 7d538a1..c60bfcb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -665,12 +665,22 @@ int bio_get_nr_vecs(struct block_device *bdev)
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 
-static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset,
-			  unsigned short max_sectors)
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
 {
-	int retried_segments = 0;
-	struct bio_vec *bvec;
+	struct bio_vec *bv;
 
 	/*
 	 * cloned bio must not modify vec list
@@ -678,41 +688,17 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
-		return 0;
-
 	/*
 	 * For filesystems with a blocksize smaller than the pagesize
 	 * we will often be called with the same page as last time and
 	 * a consecutive offset.  Optimize this special case.
 	 */
 	if (bio->bi_vcnt > 0) {
-		struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == prev->bv_page &&
-		    offset == prev->bv_offset + prev->bv_len) {
-			unsigned int prev_bv_len = prev->bv_len;
-			prev->bv_len += len;
-
-			if (q->merge_bvec_fn) {
-				struct bvec_merge_data bvm = {
-					/* prev_bvec is already charged in
-					   bi_size, discharge it in order to
-					   simulate merging updated prev_bvec
-					   as new bvec. */
-					.bi_bdev = bio->bi_bdev,
-					.bi_sector = bio->bi_iter.bi_sector,
-					.bi_size = bio->bi_iter.bi_size -
-						prev_bv_len,
-					.bi_rw = bio->bi_rw,
-				};
-
-				if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
-					prev->bv_len -= len;
-					return 0;
-				}
-			}
+		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
+		if (page == bv->bv_page &&
+		    offset == bv->bv_offset + bv->bv_len) {
+			bv->bv_len += len;
 			goto done;
 		}
 	}
@@ -720,106 +706,16 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
-	 */
-
-	while (bio->bi_phys_segments >= queue_max_segments(q)) {
-
-		if (retried_segments)
-			return 0;
-
-		retried_segments = 1;
-		blk_recount_segments(q, bio);
-	}
-
-	/*
-	 * setup the new entry, we might clear it again later if we
-	 * cannot add the page
-	 */
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
-
-	/*
-	 * if queue has other restrictions (eg varying max sector size
-	 * depending on offset), it can specify a merge_bvec_fn in the
-	 * queue to get further control
-	 */
-	if (q->merge_bvec_fn) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev = bio->bi_bdev,
-			.bi_sector = bio->bi_iter.bi_sector,
-			.bi_size = bio->bi_iter.bi_size,
-			.bi_rw = bio->bi_rw,
-		};
-
-		/*
-		 * merge_bvec_fn() returns number of bytes it can accept
-		 * at this offset
-		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
-	}
-
-	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
-		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+	bv		= &bio->bi_io_vec[bio->bi_vcnt];
+	bv->bv_page	= page;
+	bv->bv_len	= len;
+	bv->bv_offset	= offset;
 
 	bio->bi_vcnt++;
-	bio->bi_phys_segments++;
- done:
+done:
 	bio->bi_iter.bi_size += len;
 	return len;
 }
-
-/**
- *	bio_add_pc_page	-	attempt to add page to bio
- *	@q: the target queue
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
- *
- *	This should only be used by REQ_PC bios.
- */
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
-		    unsigned int len, unsigned int offset)
-{
-	return __bio_add_page(q, bio, page, len, offset,
-			      queue_max_hw_sectors(q));
-}
-EXPORT_SYMBOL(bio_add_pc_page);
-
-/**
- *	bio_add_page	-	attempt to add page to bio
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
- */
-int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
-		 unsigned int offset)
-{
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	return __bio_add_page(q, bio, page, len, offset, queue_max_sectors(q));
-}
 EXPORT_SYMBOL(bio_add_page);
 
 struct submit_bio_ret {
@@ -1169,7 +1065,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			}
 		}
 
-		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
+		if (bio_add_page(bio, page, bytes, offset) < bytes)
 			break;
 
 		len -= bytes;
@@ -1462,8 +1358,8 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 		if (bytes > len)
 			bytes = len;
 
-		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
-				    offset) < bytes)
+		if (bio_add_page(bio, virt_to_page(data), bytes,
+				 offset) < bytes)
 			break;
 
 		data += bytes;
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index b744228..c694d6d 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -577,8 +577,6 @@ int _ore_add_stripe_unit(struct ore_io_state *ios,  unsigned *cur_pg,
 			 struct ore_per_dev_state *per_dev, int cur_len)
 {
 	unsigned pg = *cur_pg;
-	struct request_queue *q =
-			osd_request_queue(_ios_od(ios, per_dev->dev));
 	unsigned len = cur_len;
 	int ret;
 
@@ -606,10 +604,10 @@ int _ore_add_stripe_unit(struct ore_io_state *ios,  unsigned *cur_pg,
 
 		cur_len -= pglen;
 
-		added_len = bio_add_pc_page(q, per_dev->bio, pages[pg],
-					    pglen, pgbase);
+		added_len = bio_add_page(per_dev->bio, pages[pg],
+					 pglen, pgbase);
 		if (unlikely(pglen != added_len)) {
-			ORE_DBGMSG("Failed bio_add_pc_page bi_vcnt=%u\n",
+			ORE_DBGMSG("Failed bio_add_page bi_vcnt=%u\n",
 				   per_dev->bio->bi_vcnt);
 			ret = -ENOMEM;
 			goto out;
diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 7682b97..bbd627f 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -331,7 +331,6 @@ static int _alloc_read_4_write(struct ore_io_state *ios)
 static int _add_to_r4w(struct ore_io_state *ios, struct ore_striping_info *si,
 		       struct page *page, unsigned pg_len)
 {
-	struct request_queue *q;
 	struct ore_per_dev_state *per_dev;
 	struct ore_io_state *read_ios;
 	unsigned first_dev = si->dev - (si->dev %
@@ -365,11 +364,10 @@ static int _add_to_r4w(struct ore_io_state *ios, struct ore_striping_info *si,
 
 		_ore_add_sg_seg(per_dev, gap, true);
 	}
-	q = osd_request_queue(ore_comp_dev(read_ios->oc, per_dev->dev));
-	added_len = bio_add_pc_page(q, per_dev->bio, page, pg_len,
-				    si->obj_offset % PAGE_SIZE);
+	added_len = bio_add_page(per_dev->bio, page, pg_len,
+				 si->obj_offset % PAGE_SIZE);
 	if (unlikely(added_len != pg_len)) {
-		ORE_DBGMSG("Failed to bio_add_pc_page bi_vcnt=%d\n",
+		ORE_DBGMSG("Failed to bio_add_page bi_vcnt=%d\n",
 			      per_dev->bio->bi_vcnt);
 		return -ENOMEM;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 204489e..a293b78 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -367,8 +367,6 @@ extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
-extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
-			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
-- 
1.8.4.rc3

