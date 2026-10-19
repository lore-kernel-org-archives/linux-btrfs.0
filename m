Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA28F3DAACE
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392037; cv=none; b=HyOiFFvxdW9stI1FH3s+KzHDltBUq5/AqqjPhf/RJsfGhfXaqpHTv/ub66ZnTHuXCmC8MB5omeABW3rbLfOmJZMKhQjXuTd0n6u3+1EeFQDHuOd0HHyIDdup3hsQ4X3yYPic3D2CVWTVntL+v3i2fS78s6itghfh836gDL82aq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392037; c=relaxed/simple;
	bh=ZhzW84T6xpiKPEF9rCtWgC/6sl+wH+Sscmh2G0obKU4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFENs+7xbZdsZXtx+cA9b4MZ4oFO4MChL0mu01lXfDZO2nZH+V4mo6LUIYoWLuFwILdyf6G19s+K5ZQ+TYjrrO6q675soLXQX86KBT/7rKksQHnRWqrm/85zF6KRAGSMl876raeZX6+E5vkYH0tVmejD4LEd7be2xpBe+uLTmaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oVwboo7x; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oVwboo7x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oVwboo7x";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oVwboo7x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44DE82202E
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0oWRTsp906fKPQHzg3gjDjWgxwTky4c98YRKNvAZWg=;
	b=oVwboo7xBgIAmFIze9bSqy/uTOQy6pbhjTBYjFN5/FLTxq2Q9oj189n63x0QPBSK3Fes6+
	SHXP8qvqME0QmD0MDaXEyBlCbgaYgWZxpgPhY6aiiojGkltq8omDWU3kzkL2ZeYpwgew78
	islv8XvwazDzlRdk3qdqLqWBExv2Tck=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H0oWRTsp906fKPQHzg3gjDjWgxwTky4c98YRKNvAZWg=;
	b=oVwboo7xBgIAmFIze9bSqy/uTOQy6pbhjTBYjFN5/FLTxq2Q9oj189n63x0QPBSK3Fes6+
	SHXP8qvqME0QmD0MDaXEyBlCbgaYgWZxpgPhY6aiiojGkltq8omDWU3kzkL2ZeYpwgew78
	islv8XvwazDzlRdk3qdqLqWBExv2Tck=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC7531375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/9] btrfs: change scrub to use stripe_len
Date: Mon, 19 Oct 2026 17:10:00 +1030
Message-ID: <5413079aa6e5031a98157e33ec23a5962d2cb590.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
References: <cover.1792391732.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

One exception to note, we pre-initialize scrub_ctx::stripes[] at the
very beginning, so init_scrub_stripe() still uses BTRFS_STRIPE_LEN.

That's fine initially, as later we will call update_scrub_stripe_len()
before scrubing a new chunk, which updates scrub_stripe::nr_sectors and
stripe_len.

This has one hidden assumption that, every chunk's stripe_len is no
larger than BTRFS_STRIPE_LEN.
That will be kept for the future of variable stripe_len.

This also means, for the future of stripe_len < BTRFS_STRIPE_LEN cases,
stripe_len >> PAGE_SHIFT may be zero, so for alloc_scrub_bbio(), the
btrfs_bio_alloc() call needs to ensure we always allocate at least one
slot.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 88 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7c2cb75b685c..b7ac9a417666 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -124,7 +124,7 @@ enum {
 };
 
 /*
- * Represent one contiguous range with a length of BTRFS_STRIPE_LEN.
+ * Represent one contiguous range with a length of stripe_len.
  */
 struct scrub_stripe {
 	struct scrub_ctx *sctx;
@@ -139,7 +139,7 @@ struct scrub_stripe {
 
 	u16 mirror_num;
 
-	/* Should be BTRFS_STRIPE_LEN / sectorsize. */
+	/* Should be stripe_len / sectorsize. */
 	u16 nr_sectors;
 
 	/*
@@ -150,6 +150,8 @@ struct scrub_stripe {
 	u16 nr_meta_extents;
 
 	atomic_t pending_io;
+	/* From btrfs_chunk_map::stripe_len. Should not exceed BTRFS_STRIPE_LEN. */
+	u32 stripe_len;
 	wait_queue_head_t io_wait;
 	wait_queue_head_t repair_wait;
 
@@ -348,7 +350,13 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 {
 	memset(stripe, 0, sizeof(*stripe));
 
+	/*
+	 * Use the max stripe_len for now.
+	 *
+	 * This will be updated for every chunk using its stripe_len.
+	 */
 	stripe->nr_sectors = BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits;
+	stripe->stripe_len = BTRFS_STRIPE_LEN;
 	stripe->state = 0;
 
 	init_waitqueue_head(&stripe->io_wait);
@@ -903,7 +911,7 @@ static void scrub_bio_add_sector(struct btrfs_bio *bbio, struct scrub_stripe *st
 	const u32 offset = sector_nr << fs_info->sectorsize_bits;
 	int ret;
 
-	ASSERT(offset + fs_info->sectorsize <= BTRFS_STRIPE_LEN);
+	ASSERT(offset + fs_info->sectorsize <= stripe->stripe_len);
 
 	if (is_vmalloc_addr(stripe->buffer)) {
 		ret = bio_add_vmalloc(&bbio->bio, stripe->buffer + offset, fs_info->sectorsize);
@@ -917,7 +925,7 @@ static void scrub_bio_add_sector(struct btrfs_bio *bbio, struct scrub_stripe *st
 
 static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
 					  blk_opf_t opf,
-					  u64 logical,
+					  u64 logical, u32 stripe_len,
 					  btrfs_bio_end_io_t end_io, void *private)
 {
 	struct btrfs_bio *bbio;
@@ -927,7 +935,7 @@ static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
 	 * different physical addresses, we have to ensure the bbio is large
 	 * enough to contain the full stripe.
 	 */
-	bbio = btrfs_bio_alloc(BTRFS_STRIPE_LEN >> PAGE_SHIFT, opf,
+	bbio = btrfs_bio_alloc(max(stripe_len >> PAGE_SHIFT, 1), opf,
 			       BTRFS_I(fs_info->btree_inode),
 			       logical, end_io, private);
 	bbio->is_scrub = true;
@@ -962,6 +970,7 @@ static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 		if (!bbio)
 			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
 						stripe->logical + (i << fs_info->sectorsize_bits),
+						stripe->stripe_len,
 						scrub_repair_read_endio, stripe);
 
 		scrub_bio_add_sector(bbio, stripe, i);
@@ -1178,7 +1187,7 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 		const unsigned long old_error_bitmap = scrub_bitmap_read_error(stripe);
 
 		scrub_stripe_submit_repair_read(stripe, mirror,
-						BTRFS_STRIPE_LEN, false);
+						stripe->stripe_len, false);
 		wait_scrub_stripe_io(stripe);
 		scrub_verify_one_stripe(stripe, old_error_bitmap);
 		if (scrub_bitmap_empty_error(stripe))
@@ -1328,7 +1337,8 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 		if (!bbio)
 			bbio = alloc_scrub_bbio(fs_info, REQ_OP_WRITE,
 					stripe->logical + (sector_nr << fs_info->sectorsize_bits),
-					scrub_write_endio, stripe);
+					stripe->stripe_len, scrub_write_endio,
+					stripe);
 		scrub_bio_add_sector(bbio, stripe, sector_nr);
 	}
 	if (bbio)
@@ -1418,7 +1428,7 @@ static int get_raid56_logic_offset(u64 physical, int num,
 
 		*offset = last_offset + btrfs_stripe_nr_to_offset(i);
 
-		stripe_nr = (u32)(*offset >> BTRFS_STRIPE_LEN_SHIFT) / data_stripes;
+		stripe_nr = (u32)(*offset >> map->stripe_shift) / data_stripes;
 
 		/* Work out the disk rotation on this stripe-set */
 		rot = stripe_nr % map->num_stripes;
@@ -1593,7 +1603,7 @@ static void fill_one_extent_info(struct btrfs_fs_info *fs_info,
 				 u64 extent_flags, u64 extent_gen)
 {
 	for (u64 cur_logical = max(stripe->logical, extent_start);
-	     cur_logical < min(stripe->logical + BTRFS_STRIPE_LEN,
+	     cur_logical < min(stripe->logical + stripe->stripe_len,
 			       extent_start + extent_len);
 	     cur_logical += fs_info->sectorsize) {
 		const int nr_sector = (cur_logical - stripe->logical) >>
@@ -1672,15 +1682,15 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
 	 * Round down to stripe boundary.
 	 *
 	 * The extra calculation against bg->start is to handle block groups
-	 * whose logical bytenr is not BTRFS_STRIPE_LEN aligned.
+	 * whose logical bytenr is not stripe_len aligned.
 	 */
-	stripe->logical = round_down(cur_logical - bg->start, BTRFS_STRIPE_LEN) +
+	stripe->logical = round_down(cur_logical - bg->start, stripe->stripe_len) +
 			  bg->start;
 	stripe->physical = physical + stripe->logical - logical_start;
 	stripe->dev = dev;
 	stripe->bg = bg;
 	stripe->mirror_num = mirror_num;
-	stripe_end = stripe->logical + BTRFS_STRIPE_LEN - 1;
+	stripe_end = stripe->logical + stripe->stripe_len - 1;
 
 	/* Fill the first extent info into stripe->sectors[] array. */
 	fill_one_extent_info(fs_info, stripe, extent_start, extent_len,
@@ -1720,7 +1730,8 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
 		 * Our csum bitmap should be large enough, as BTRFS_STRIPE_LEN
 		 * should contain at most 16 sectors.
 		 */
-		ASSERT(BITS_PER_LONG >= BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits);
+		ASSERT(BITS_PER_LONG >= (stripe->stripe_len >>
+					 fs_info->sectorsize_bits));
 
 		ret = btrfs_lookup_csums_bitmap(csum_root, csum_path,
 						stripe->logical, stripe_end,
@@ -1758,7 +1769,7 @@ static u32 stripe_length(const struct scrub_stripe *stripe)
 {
 	ASSERT(stripe->bg);
 
-	return min(BTRFS_STRIPE_LEN,
+	return min(stripe->stripe_len,
 		   stripe->bg->start + stripe->bg->length - stripe->logical);
 }
 
@@ -1768,7 +1779,7 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 	struct btrfs_bio *bbio = NULL;
 	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	const unsigned long has_extent = scrub_bitmap_read_has_extent(stripe);
-	u64 stripe_len = BTRFS_STRIPE_LEN;
+	u64 stripe_len = stripe->stripe_len;
 	int mirror = stripe->mirror_num;
 	int i;
 
@@ -1822,7 +1833,8 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 			}
 
 			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
-						logical, scrub_read_endio, stripe);
+						logical, stripe->stripe_len,
+						scrub_read_endio, stripe);
 		}
 
 		scrub_bio_add_sector(bbio, stripe, i);
@@ -1859,7 +1871,8 @@ static void scrub_submit_initial_read(struct scrub_ctx *sctx,
 	}
 
 	bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
-				stripe->logical, scrub_read_endio, stripe);
+				stripe->logical, stripe->stripe_len,
+				scrub_read_endio, stripe);
 	/* Read the whole range inside the chunk boundary. */
 	for (unsigned int cur = 0; cur < nr_sectors; cur++)
 		scrub_bio_add_sector(bbio, stripe, cur);
@@ -2104,7 +2117,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 	/* For RAID56 write there must be an @bioc allocated. */
 	ASSERT(bioc);
 	rbio = raid56_parity_alloc_scrub_rbio(&bio, bioc, scrub_dev, extent_bitmap,
-				BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits);
+				map->stripe_len >> fs_info->sectorsize_bits);
 	btrfs_put_bioc(bioc);
 	if (!rbio) {
 		ret = -ENOMEM;
@@ -2115,7 +2128,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 		struct scrub_stripe *stripe = &sctx->raid56_data_stripes[i];
 
 		raid56_parity_cache_data_folios(rbio, stripe->buffer,
-				full_stripe_start + (i << BTRFS_STRIPE_LEN_SHIFT));
+				full_stripe_start + (i << map->stripe_shift));
 	}
 	raid56_parity_submit_scrub_rbio(rbio);
 	wait_for_completion_io(&io_done);
@@ -2174,7 +2187,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 
 		stripe = &sctx->raid56_data_stripes[i];
 		rot = div_u64(full_stripe_start - bg->start,
-			      data_stripes) >> BTRFS_STRIPE_LEN_SHIFT;
+			      data_stripes) >> map->stripe_shift;
 		stripe_index = (i + rot) % map->num_stripes;
 		physical = map->stripes[stripe_index].physical +
 			   btrfs_stripe_nr_to_offset(rot);
@@ -2184,7 +2197,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 		ret = scrub_find_fill_first_stripe(bg, &extent_path, &csum_path,
 				map->stripes[stripe_index].dev, physical, 1,
 				full_stripe_start + btrfs_stripe_nr_to_offset(i),
-				BTRFS_STRIPE_LEN, stripe);
+				map->stripe_len, stripe);
 		if (ret < 0)
 			return ret;
 		/*
@@ -2272,6 +2285,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 static int scrub_simple_mirror(struct scrub_ctx *sctx,
 			       struct btrfs_block_group *bg,
 			       u64 logical_start, u64 logical_length,
+			       u32 stripe_len,
 			       struct btrfs_device *device,
 			       u64 physical, int mirror_num)
 {
@@ -2319,7 +2333,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 
 		/* queue_scrub_stripe() returned 0, @found_logical must be updated. */
 		ASSERT(found_logical != U64_MAX);
-		cur_logical = found_logical + BTRFS_STRIPE_LEN;
+		cur_logical = found_logical + stripe_len;
 
 		/* Don't hold CPU for too long time */
 		cond_resched();
@@ -2374,6 +2388,7 @@ static int scrub_simple_stripe(struct scrub_ctx *sctx,
 	const u64 orig_logical = simple_stripe_get_logical(map, bg, stripe_index);
 	const u64 orig_physical = map->stripes[stripe_index].physical;
 	const u64 end = btrfs_block_group_end(bg);
+	const u32 stripe_len = map->stripe_len;
 	const int mirror_num = simple_stripe_mirror_num(map, stripe_index);
 	u64 cur_logical = orig_logical;
 	u64 cur_physical = orig_physical;
@@ -2386,18 +2401,27 @@ static int scrub_simple_stripe(struct scrub_ctx *sctx,
 		 * this stripe.
 		 */
 		ret = scrub_simple_mirror(sctx, bg, cur_logical,
-					  BTRFS_STRIPE_LEN, device, cur_physical,
+					  stripe_len, stripe_len,
+					  device, cur_physical,
 					  mirror_num);
 		if (ret)
 			return ret;
 		/* Skip to next stripe which belongs to the target device */
 		cur_logical += logical_increment;
 		/* For physical offset, we just go to next stripe */
-		cur_physical += BTRFS_STRIPE_LEN;
+		cur_physical += stripe_len;
 	}
 	return ret;
 }
 
+static void update_scrub_stripe_len(const struct btrfs_fs_info *fs_info,
+				    const struct btrfs_chunk_map *map,
+				    struct scrub_stripe *stripe)
+{
+	stripe->stripe_len = map->stripe_len;
+	stripe->nr_sectors = map->stripe_len >> fs_info->sectorsize_bits;
+}
+
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct btrfs_block_group *bg,
 					   struct btrfs_chunk_map *map,
@@ -2407,6 +2431,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	const u64 profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	const u64 chunk_logical = bg->start;
+	const u32 stripe_len = map->stripe_len;
 	int ret;
 	int ret2;
 	u64 physical = map->stripes[stripe_index].physical;
@@ -2449,6 +2474,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto out;
 			sctx->raid56_data_stripes[i].bg = bg;
 			sctx->raid56_data_stripes[i].sctx = sctx;
+			update_scrub_stripe_len(fs_info, map, &sctx->raid56_data_stripes[i]);
 		}
 	}
 	/*
@@ -2469,7 +2495,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 * @stripe_index.
 		 */
 		ret = scrub_simple_mirror(sctx, bg, bg->start, bg->length,
-				scrub_dev, map->stripes[stripe_index].physical,
+				stripe_len, scrub_dev,
+				map->stripes[stripe_index].physical,
 				stripe_index + 1);
 		offset = 0;
 		goto out;
@@ -2507,7 +2534,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			ret = scrub_raid56_parity_stripe(sctx, scrub_dev, bg,
 							 map, stripe_logical);
 			spin_lock(&sctx->stat_lock);
-			sctx->stat.last_physical = min(physical + BTRFS_STRIPE_LEN,
+			sctx->stat.last_physical = min(physical + stripe_len,
 						       physical_end);
 			spin_unlock(&sctx->stat_lock);
 			if (ret)
@@ -2523,13 +2550,13 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 * We can reuse scrub_simple_mirror() here, as the repair part
 		 * is still based on @mirror_num.
 		 */
-		ret = scrub_simple_mirror(sctx, bg, logical, BTRFS_STRIPE_LEN,
-					  scrub_dev, physical, 1);
+		ret = scrub_simple_mirror(sctx, bg, logical, stripe_len,
+					  stripe_len, scrub_dev, physical, 1);
 		if (ret < 0)
 			goto out;
 next:
 		logical += increment;
-		physical += BTRFS_STRIPE_LEN;
+		physical += stripe_len;
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.last_physical = physical;
 		spin_unlock(&sctx->stat_lock);
@@ -2589,6 +2616,9 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 	if (map->chunk_len < dev_extent_len)
 		goto out;
 
+	for (i = 0; i < SCRUB_TOTAL_STRIPES; i++)
+		update_scrub_stripe_len(fs_info, map, &sctx->stripes[i]);
+
 	for (i = 0; i < map->num_stripes; ++i) {
 		if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
 		    map->stripes[i].physical == dev_offset) {
-- 
2.56.0

