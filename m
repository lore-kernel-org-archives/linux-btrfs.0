Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554017;
	b=mOntFa1Q38Xf6xCSUfGbKiY6FKiLEAz/9RmYTNpzeyN64a8dvLXrcayIS4P6XBycwt8s
	 gTwYwHLCR7scmgGazAWEY5xpHw+kIz7bNbB7SZN5TnoRvYhqXDURmgm8lniOuSdVEN9OL
	 eTWhUjLKVI/xvS1om2Y5OCaMmKA8Ow8DKkKumm9bs4i78o/NAEatJ2oxHGSKQr/EQZpAI
	 o5YEdlpq/FDCFgSaEm/r1o2yaEDtHJ43etGtySElDlU55Tq8HlBP4uWW4fJ3POow/xVp7
	 94WHduTozkmQt13xzyJBNR92li2eBgpOV2ic5H7J5EEyphOr/7aEKXRgwbV2OQGn58A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554017;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Action:
	 X-Spam-Score:X-Spam-Flag:X-Spamd-Result:X-Spam-Level:
	 X-Rspamd-Queue-Id:X-Rspamd-Server;
	bh=aYb8LNrabZr6y1pHx7w5BFqAqqfOF0H3wJ77IffTMYo=;
	b=lcWn6DlU4REZaxcNKaICCKmFMOtTIDAijVvq6kSycu9kNnpgHkrWF838SO6pnONaTZ/2
	 E5/x40zj2K/cfPH9wYXGySgpuCyOoWmuZnD2IPvSVkJMgkgATwCBTxmcQ6ZpNt4XpgSex
	 96/he7HsctOZqDt4hxn0DxvnabRQ1mTgFmNUZS8txToWNH6QzCojMIlP+q8sHVjqSkEZg
	 Jry6dQu9XhWxL7l6X3IX5cekcRUxNn7P9zwxM71N4OitgSSjvdEVbyRyifDedysx8Eo3A
	 cb9vL6haLqXyce2nr6G9QC3xEuar1PrSkQBFQLJh4yq/r+uDezDKIKb2zNrFVpqgs/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYX8OUaF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYX8OUaF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0FB606A32D
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D0FB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYX8OUaF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MYX8OUaF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8ADF21E0F
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYb8LNrabZr6y1pHx7w5BFqAqqfOF0H3wJ77IffTMYo=;
	b=MYX8OUaFOfPJL0kx7S5FMKNUZPfB8v1rZiCXszgjxZNzLaf61Yebc5B1D3WAyIIfxMW4iH
	wFY7wnZtlMOiY72SUZlHw0T13zhZW5tmiPMiH2lxtJafMGCI9k35916pvJ/dcu8IcYtQ5x
	moR3TgRcnbX6muwAOQ0FjJKWMJwV63Y=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MYX8OUaF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYb8LNrabZr6y1pHx7w5BFqAqqfOF0H3wJ77IffTMYo=;
	b=MYX8OUaFOfPJL0kx7S5FMKNUZPfB8v1rZiCXszgjxZNzLaf61Yebc5B1D3WAyIIfxMW4iH
	wFY7wnZtlMOiY72SUZlHw0T13zhZW5tmiPMiH2lxtJafMGCI9k35916pvJ/dcu8IcYtQ5x
	moR3TgRcnbX6muwAOQ0FjJKWMJwV63Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97995134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/9] btrfs: change scrub to use stripe_len
Date: Wed, 21 Oct 2026 14:09:38 +1030
Message-ID: <9b53b66f9954c7d68ce6ae549f392d25fc7f792b.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792553748.git.wqu@suse.com>
References: <cover.1792553748.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: A8ADF21E0F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

Several points to note:

- scrub_ctx::stripes[] stripe_len updates
  We always pre-initialize scrub_ctx::stripes[] at the very beginning of
  scrub, without holding any btrfs_chunk_map.

  So init_scrub_stripe() still uses BTRFS_STRIPE_LEN, and all allocated
  memory are based on that stripe length.

  But before scrubbing each chunk, update_scrub_stripe_len() will be
  called to update the scrub_stripe::stripe_len.

- Stripe_len should not exceed BTRFS_STRIPE_LEN
  Since scrub_stripe's heap memory are all based on BTRFS_STRIPE_LEN,
  any stripe_len larger than BTRFS_STRIPE_LEN will cause
  access-beyond-boundary.

  Thankfully there is no plan to support such stripe_len >
  BTRFS_STRIPE_LEN any time soon.

- alloc_scrub_bbio() changes
  Previously we ensure BTRFS_STRIPE_LEN >= PAGE_SIZE, so
  BTRFS_STRIPE_LEN >> PAGE_SHIFT can never be zero.

  But now stripe_len can be smaller than PAGE_SIZE. E.g. stripe_len 4K,
  page size 64K.

  So we have to use "round_up(stripe_len, PAGE_SIZE) >> PAGE_SHIFT"
  instead.

  Finally alloc_scrub_bbio() is always called with a scrub_stripe
  pointer as the @private parameter, change the type from (void *) to
  (struct scrub_stripe *), so that we can grab the stripe_len without
  a new parameter.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 99 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bf91a6130e46..c3387e109779 100644
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
 
@@ -347,7 +349,13 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
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
@@ -901,7 +909,7 @@ static void scrub_bio_add_sector(struct btrfs_bio *bbio, struct scrub_stripe *st
 	const u32 offset = sector_nr << fs_info->sectorsize_bits;
 	int ret;
 
-	ASSERT(offset + fs_info->sectorsize <= BTRFS_STRIPE_LEN);
+	ASSERT(offset + fs_info->sectorsize <= stripe->stripe_len);
 
 	if (is_vmalloc_addr(stripe->buffer)) {
 		ret = bio_add_vmalloc(&bbio->bio, stripe->buffer + offset, fs_info->sectorsize);
@@ -914,9 +922,9 @@ static void scrub_bio_add_sector(struct btrfs_bio *bbio, struct scrub_stripe *st
 }
 
 static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
-					  blk_opf_t opf,
-					  u64 logical,
-					  btrfs_bio_end_io_t end_io, void *private)
+					  blk_opf_t opf, u64 logical,
+					  btrfs_bio_end_io_t end_io,
+					  struct scrub_stripe *stripe)
 {
 	struct btrfs_bio *bbio;
 
@@ -925,9 +933,10 @@ static struct btrfs_bio *alloc_scrub_bbio(struct btrfs_fs_info *fs_info,
 	 * different physical addresses, we have to ensure the bbio is large
 	 * enough to contain the full stripe.
 	 */
-	bbio = btrfs_bio_alloc(BTRFS_STRIPE_LEN >> PAGE_SHIFT, opf,
+	bbio = btrfs_bio_alloc(round_up(stripe->stripe_len, PAGE_SIZE) >>
+			       PAGE_SHIFT, opf,
 			       BTRFS_I(fs_info->btree_inode),
-			       logical, end_io, private);
+			       logical, end_io, stripe);
 	bbio->is_scrub = true;
 	bbio->bio.bi_iter.bi_sector = logical >> SECTOR_SHIFT;
 	return bbio;
@@ -959,7 +968,8 @@ static void scrub_stripe_submit_repair_read(struct scrub_stripe *stripe,
 
 		if (!bbio)
 			bbio = alloc_scrub_bbio(fs_info, REQ_OP_READ,
-						stripe->logical + (i << fs_info->sectorsize_bits),
+						stripe->logical +
+						(i << fs_info->sectorsize_bits),
 						scrub_repair_read_endio, stripe);
 
 		scrub_bio_add_sector(bbio, stripe, i);
@@ -1176,7 +1186,7 @@ static void scrub_stripe_read_repair_worker(struct work_struct *work)
 		const unsigned long old_error_bitmap = scrub_bitmap_read_error(stripe);
 
 		scrub_stripe_submit_repair_read(stripe, mirror,
-						BTRFS_STRIPE_LEN, false);
+						stripe->stripe_len, false);
 		wait_scrub_stripe_io(stripe);
 		scrub_verify_one_stripe(stripe, old_error_bitmap);
 		if (scrub_bitmap_empty_error(stripe))
@@ -1325,7 +1335,8 @@ static void scrub_write_sectors(struct scrub_ctx *sctx, struct scrub_stripe *str
 		}
 		if (!bbio)
 			bbio = alloc_scrub_bbio(fs_info, REQ_OP_WRITE,
-					stripe->logical + (sector_nr << fs_info->sectorsize_bits),
+					stripe->logical +
+					(sector_nr << fs_info->sectorsize_bits),
 					scrub_write_endio, stripe);
 		scrub_bio_add_sector(bbio, stripe, sector_nr);
 	}
@@ -1416,7 +1427,7 @@ static int get_raid56_logic_offset(u64 physical, int num,
 
 		*offset = last_offset + btrfs_stripe_nr_to_offset(i);
 
-		stripe_nr = (u32)(*offset >> BTRFS_STRIPE_LEN_SHIFT) / data_stripes;
+		stripe_nr = (u32)(*offset >> map->stripe_shift) / data_stripes;
 
 		/* Work out the disk rotation on this stripe-set */
 		rot = stripe_nr % map->num_stripes;
@@ -1591,7 +1602,7 @@ static void fill_one_extent_info(struct btrfs_fs_info *fs_info,
 				 u64 extent_flags, u64 extent_gen)
 {
 	for (u64 cur_logical = max(stripe->logical, extent_start);
-	     cur_logical < min(stripe->logical + BTRFS_STRIPE_LEN,
+	     cur_logical < min(stripe->logical + stripe->stripe_len,
 			       extent_start + extent_len);
 	     cur_logical += fs_info->sectorsize) {
 		const int nr_sector = (cur_logical - stripe->logical) >>
@@ -1670,15 +1681,15 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
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
@@ -1715,10 +1726,15 @@ static int scrub_find_fill_first_stripe(struct btrfs_block_group *bg,
 		ASSERT(stripe->csums);
 
 		/*
-		 * Our csum bitmap should be large enough, as BTRFS_STRIPE_LEN
-		 * should contain at most 16 sectors.
+		 * Our csum bitmap should be large enough, as stripe_len is no
+		 * larger than BTRFS_STRIPE_LEN, and BTRFS_STRIPE_LEN contains
+		 * at most 16 sectors (4K sector size).
+		 *
+		 * So (stripe_len >> sectorsize_bits) should be at most 16,
+		 * not reaching BITS_PER_LONG.
 		 */
-		ASSERT(BITS_PER_LONG >= BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits);
+		ASSERT(BITS_PER_LONG >= (stripe->stripe_len >>
+					 fs_info->sectorsize_bits));
 
 		ret = btrfs_lookup_csums_bitmap(csum_root, csum_path,
 						stripe->logical, stripe_end,
@@ -1756,7 +1772,7 @@ static u32 stripe_length(const struct scrub_stripe *stripe)
 {
 	ASSERT(stripe->bg);
 
-	return min(BTRFS_STRIPE_LEN,
+	return min(stripe->stripe_len,
 		   stripe->bg->start + stripe->bg->length - stripe->logical);
 }
 
@@ -1766,7 +1782,7 @@ static void scrub_submit_extent_sector_read(struct scrub_stripe *stripe)
 	struct btrfs_bio *bbio = NULL;
 	unsigned int nr_sectors = stripe_length(stripe) >> fs_info->sectorsize_bits;
 	const unsigned long has_extent = scrub_bitmap_read_has_extent(stripe);
-	u64 stripe_len = BTRFS_STRIPE_LEN;
+	u64 stripe_len = stripe->stripe_len;
 	int mirror = stripe->mirror_num;
 	int i;
 
@@ -2102,7 +2118,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 	/* For RAID56 write there must be an @bioc allocated. */
 	ASSERT(bioc);
 	rbio = raid56_parity_alloc_scrub_rbio(&bio, bioc, scrub_dev, extent_bitmap,
-				BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits);
+				map->stripe_len >> fs_info->sectorsize_bits);
 	btrfs_put_bioc(bioc);
 	if (!rbio) {
 		ret = -ENOMEM;
@@ -2113,7 +2129,7 @@ static int scrub_raid56_cached_parity(struct scrub_ctx *sctx,
 		struct scrub_stripe *stripe = &sctx->raid56_data_stripes[i];
 
 		raid56_parity_cache_data_folios(rbio, stripe->buffer,
-				full_stripe_start + (i << BTRFS_STRIPE_LEN_SHIFT));
+				full_stripe_start + (i << map->stripe_shift));
 	}
 	raid56_parity_submit_scrub_rbio(rbio);
 	wait_for_completion_io(&io_done);
@@ -2172,7 +2188,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 
 		stripe = &sctx->raid56_data_stripes[i];
 		rot = div_u64(full_stripe_start - bg->start,
-			      data_stripes) >> BTRFS_STRIPE_LEN_SHIFT;
+			      data_stripes) >> map->stripe_shift;
 		stripe_index = (i + rot) % map->num_stripes;
 		physical = map->stripes[stripe_index].physical +
 			   btrfs_stripe_nr_to_offset(rot);
@@ -2182,7 +2198,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 		ret = scrub_find_fill_first_stripe(bg, &extent_path, &csum_path,
 				map->stripes[stripe_index].dev, physical, 1,
 				full_stripe_start + btrfs_stripe_nr_to_offset(i),
-				BTRFS_STRIPE_LEN, stripe);
+				map->stripe_len, stripe);
 		if (ret < 0)
 			return ret;
 		/*
@@ -2270,6 +2286,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
 static int scrub_simple_mirror(struct scrub_ctx *sctx,
 			       struct btrfs_block_group *bg,
 			       u64 logical_start, u64 logical_length,
+			       u32 stripe_len,
 			       struct btrfs_device *device,
 			       u64 physical, int mirror_num)
 {
@@ -2317,7 +2334,7 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 
 		/* queue_scrub_stripe() returned 0, @found_logical must be updated. */
 		ASSERT(found_logical != U64_MAX);
-		cur_logical = found_logical + BTRFS_STRIPE_LEN;
+		cur_logical = found_logical + stripe_len;
 
 		/* Don't hold CPU for too long time */
 		cond_resched();
@@ -2372,6 +2389,7 @@ static int scrub_simple_stripe(struct scrub_ctx *sctx,
 	const u64 orig_logical = simple_stripe_get_logical(map, bg, stripe_index);
 	const u64 orig_physical = map->stripes[stripe_index].physical;
 	const u64 end = btrfs_block_group_end(bg);
+	const u32 stripe_len = map->stripe_len;
 	const int mirror_num = simple_stripe_mirror_num(map, stripe_index);
 	u64 cur_logical = orig_logical;
 	u64 cur_physical = orig_physical;
@@ -2384,18 +2402,27 @@ static int scrub_simple_stripe(struct scrub_ctx *sctx,
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
@@ -2405,6 +2432,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	const u64 profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
 	const u64 chunk_logical = bg->start;
+	const u32 stripe_len = map->stripe_len;
 	int ret;
 	int ret2;
 	u64 physical = map->stripes[stripe_index].physical;
@@ -2447,6 +2475,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				goto out;
 			sctx->raid56_data_stripes[i].bg = bg;
 			sctx->raid56_data_stripes[i].sctx = sctx;
+			update_scrub_stripe_len(fs_info, map, &sctx->raid56_data_stripes[i]);
 		}
 	}
 	/*
@@ -2467,7 +2496,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		 * @stripe_index.
 		 */
 		ret = scrub_simple_mirror(sctx, bg, bg->start, bg->length,
-				scrub_dev, map->stripes[stripe_index].physical,
+				stripe_len, scrub_dev,
+				map->stripes[stripe_index].physical,
 				stripe_index + 1);
 		offset = 0;
 		goto out;
@@ -2505,7 +2535,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			ret = scrub_raid56_parity_stripe(sctx, scrub_dev, bg,
 							 map, stripe_logical);
 			spin_lock(&sctx->stat_lock);
-			sctx->stat.last_physical = min(physical + BTRFS_STRIPE_LEN,
+			sctx->stat.last_physical = min(physical + stripe_len,
 						       physical_end);
 			spin_unlock(&sctx->stat_lock);
 			if (ret)
@@ -2521,13 +2551,13 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
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
@@ -2587,6 +2617,9 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
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

