Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7DA484891
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392043; cv=none; b=vEVC0D/3nlD2wQys8/86fonALqIogmXQyxDvdsseV/cFQzX7MyqclqpvICh0HO4YMgFfpumuIfg6LepEyhzzjYY5OAr3GzOLQqha2sIJNOS17G+Lu2ivzZr2kXJY7i0eaFGRt8BKFG9riAQN4v0ww2/dSqFfrS9wvOuHxFHm1g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392043; c=relaxed/simple;
	bh=oxaDnoyQuQlbacAKKkHN1BOWZjwvcpPPcVZ5zipahis=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd18v+SAAAztZEIlqyninHGdU22joDIOwz9sWfYJfWkIdrY5GiKmeDPI8mcnFHVDNwVOtxXFgsxAOwQnG7tmb/K2RqzG7LqOzBjUh9lAdXoPz9OmC77oOmizfY9yDqbv4Z3UvLa6zZkNS2C0Nyk9mAW4MF1MVFX/UN5V1qrmx1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jQWxYXrK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jQWxYXrK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jQWxYXrK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jQWxYXrK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BEC4F2202E
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOVu2FYOUpXSzCrs+Bla305E4E7C9gpAkQu6iKyk1Bw=;
	b=jQWxYXrK9R4dwGelK++1klQ79zd5wZds7rjCjQA1k957f0k6ezGnPAV2KTcfF2CMHiV3Z5
	rPVODRkVAy8FNuZUBgsb3CGoTZ7HkKZuMCNMpM8zAfZypE+FgtmtHTKll+APADZ1TrV5tH
	eS+DYYS0W3jW+BuPgBP1JsQ0fkf53x0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOVu2FYOUpXSzCrs+Bla305E4E7C9gpAkQu6iKyk1Bw=;
	b=jQWxYXrK9R4dwGelK++1klQ79zd5wZds7rjCjQA1k957f0k6ezGnPAV2KTcfF2CMHiV3Z5
	rPVODRkVAy8FNuZUBgsb3CGoTZ7HkKZuMCNMpM8zAfZypE+FgtmtHTKll+APADZ1TrV5tH
	eS+DYYS0W3jW+BuPgBP1JsQ0fkf53x0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B8711375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T8
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs: convert raid56.c to use rbio->bioc->stripe_len
Date: Mon, 19 Oct 2026 17:10:03 +1030
Message-ID: <69877cde96d6602509177c1518f97e850e6d85a5.1792391732.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

So that raid56 can support stripe length other than BTRFS_STRIPE_LEN.

There are several extra things to note:

- btrfs_raid_bio::stripe_npages is removed
  With stripe_len < BTRFS_STRIPE_LEN, there is no guarantee that a page
  won't cross multiple stripes.

  E.g. with 4K stripe_len and sectorsize, 2 data stripes, with 64K page
  size, one page will cover the full stripe.

  So stripe_npages no longer makes sense, just remove it.

- alloc_rbio_data_pages()/alloc_rbio_parity_pages() fallback
  For the same above reason, a page can contain both data and parity
  blocks.
  In that case we can no longer only allocate pages for data/parity.

  Add a fallback that if stripe_len is smaller than page size, always
  allocate all the pages.

  This is not the best solution, but should be good enough for now until
  the variable stripe_len is properly tested.

- steal_rbio() fallback
  If stripe_len is smaller than PAGE_SIZE, it's hard to only steal the
  data pages.

  Again skip the stealing if stripe_len is smaller than PAGE_SIZE.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 52 +++++++++++++++++++++++++++++++----------------
 fs/btrfs/raid56.h |  7 +------
 2 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5ec31299f1c3..ed415a247117 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -417,6 +417,9 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 
 	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
 		return;
+	/* Data and P/Q can be mixed into a page, skip stealing. */
+	if (src->bioc->stripe_len < PAGE_SIZE)
+		return;
 
 	for (i = 0; i < dest->nr_pages; i++) {
 		struct page *p = src->stripe_pages[i];
@@ -624,12 +627,13 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
 static int rbio_is_full(struct btrfs_raid_bio *rbio)
 {
 	unsigned long size = rbio->bio_list_bytes;
+	const u32 stripe_len = rbio->bioc->stripe_len;
 	int ret = 1;
 
 	spin_lock(&rbio->bio_list_lock);
-	if (size != rbio->nr_data * BTRFS_STRIPE_LEN)
+	if (size != rbio->nr_data * stripe_len)
 		ret = 0;
-	BUG_ON(size > rbio->nr_data * BTRFS_STRIPE_LEN);
+	BUG_ON(size > rbio->nr_data * stripe_len);
 	spin_unlock(&rbio->bio_list_lock);
 
 	return ret;
@@ -1041,11 +1045,12 @@ static phys_addr_t sector_paddr_in_rbio(struct btrfs_raid_bio *rbio,
 static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 					 struct btrfs_io_context *bioc)
 {
+	const u32 stripe_len = bioc->stripe_len;
 	const unsigned int real_stripes = bioc->num_stripes - bioc->replace_nr_stripes;
-	const unsigned int stripe_npages = BTRFS_STRIPE_LEN >> PAGE_SHIFT;
-	const unsigned int num_pages = stripe_npages * real_stripes;
+	const unsigned int num_pages = round_up(stripe_len * real_stripes, PAGE_SIZE) >>
+				       PAGE_SHIFT;
 	const unsigned int stripe_nsectors =
-		BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits;
+		stripe_len >> fs_info->sectorsize_bits;
 	const unsigned int num_sectors = stripe_nsectors * real_stripes;
 	const unsigned int step = min(fs_info->sectorsize, PAGE_SIZE);
 	const unsigned int sector_nsteps = fs_info->sectorsize / step;
@@ -1105,7 +1110,6 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->nr_pages = num_pages;
 	rbio->nr_sectors = num_sectors;
 	rbio->real_stripes = real_stripes;
-	rbio->stripe_npages = stripe_npages;
 	rbio->stripe_nsectors = stripe_nsectors;
 	rbio->sector_nsteps = sector_nsteps;
 	refcount_set(&rbio->refs, 1);
@@ -1134,9 +1138,17 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio)
 /* only allocate pages for p/q stripes */
 static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
 {
-	const int data_pages = rbio->nr_data * rbio->stripe_npages;
+	int data_pages;
 	int ret;
 
+	/*
+	 * Page size larger than stripe size, we can not only allocate
+	 * pages for P/Q stripes.
+	 */
+	if (rbio->bioc->stripe_len < PAGE_SIZE)
+		return alloc_rbio_pages(rbio);
+
+	data_pages = rbio->nr_data * (rbio->bioc->stripe_len >> PAGE_SHIFT);
 	ret = btrfs_alloc_page_array(rbio->nr_pages - data_pages,
 				     rbio->stripe_pages + data_pages, GFP_NOFS);
 	if (ret < 0)
@@ -1274,7 +1286,7 @@ static int rbio_add_io_paddrs(struct btrfs_raid_bio *rbio, struct bio_list *bio_
 
 	/* put a new bio on the list */
 	bio = bio_alloc(stripe->dev->bdev,
-			max(BTRFS_STRIPE_LEN >> PAGE_SHIFT, 1),
+			max(rbio->bioc->stripe_len >> PAGE_SHIFT, 1),
 			op, GFP_NOFS);
 	bio->bi_iter.bi_sector = disk_start >> SECTOR_SHIFT;
 	bio->bi_private = rbio;
@@ -1715,9 +1727,13 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 
 static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
 {
-	const int data_pages = rbio->nr_data * rbio->stripe_npages;
+	int data_pages;
 	int ret;
 
+	if (rbio->bioc->stripe_len < PAGE_SIZE)
+		return alloc_rbio_pages(rbio);
+
+	data_pages = rbio->nr_data * (rbio->bioc->stripe_len >> PAGE_SHIFT);
 	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, GFP_NOFS);
 	if (ret < 0)
 		return ret;
@@ -1804,7 +1820,7 @@ static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
 
 	ASSERT_RBIO_LOGICAL(orig_logical >= full_stripe_start &&
 			    orig_logical + orig_len <= full_stripe_start +
-			    rbio->nr_data * BTRFS_STRIPE_LEN,
+			    rbio->nr_data * rbio->bioc->stripe_len,
 			    rbio, orig_logical);
 
 	bio_list_add(&rbio->bio_list, orig_bio);
@@ -3012,6 +3028,7 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	const u64 offset_in_full_stripe = data_logical -
 					  rbio->bioc->full_stripe_logical;
+	const u32 stripe_len = rbio->bioc->stripe_len;
 	int ret;
 
 	/*
@@ -3027,19 +3044,20 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
 		return;
 
 	/* data_logical must be at stripe boundary and inside the full stripe. */
-	ASSERT(IS_ALIGNED(offset_in_full_stripe, BTRFS_STRIPE_LEN));
-	ASSERT(offset_in_full_stripe < (rbio->nr_data << BTRFS_STRIPE_LEN_SHIFT));
+	ASSERT(IS_ALIGNED(offset_in_full_stripe, stripe_len));
+	ASSERT(offset_in_full_stripe < (rbio->nr_data << ilog2(stripe_len)));
 
 	for (unsigned int cur_off = offset_in_full_stripe;
-	     cur_off < offset_in_full_stripe + BTRFS_STRIPE_LEN;
+	     cur_off < offset_in_full_stripe + stripe_len;
 	     cur_off += PAGE_SIZE) {
 		const unsigned int pindex = cur_off >> PAGE_SHIFT;
+		const u32 cur_len = min(stripe_len, PAGE_SIZE);
 
-		ASSERT(cur_off - offset_in_full_stripe + PAGE_SIZE <= BTRFS_STRIPE_LEN);
-		memcpy_to_page(rbio->stripe_pages[pindex], 0,
-			       vaddr + cur_off - offset_in_full_stripe, PAGE_SIZE);
+		ASSERT(cur_off - offset_in_full_stripe + cur_len <= stripe_len);
+		memcpy_to_page(rbio->stripe_pages[pindex], offset_in_page(cur_off),
+			       vaddr + cur_off - offset_in_full_stripe, cur_len);
 	}
 	bitmap_set(rbio->stripe_uptodate_bitmap,
 		   offset_in_full_stripe >> fs_info->sectorsize_bits,
-		   BTRFS_STRIPE_LEN >> fs_info->sectorsize_bits);
+		   stripe_len >> fs_info->sectorsize_bits);
 }
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 8542648199f1..8700910b8dc9 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -60,8 +60,6 @@ enum btrfs_rbio_ops {
  * stripe_pages[] array stores all the pages covering the full stripe, including
  * data and P/Q pages.
  * stripe_pages[0] is the first page of the first data stripe.
- * stripe_pages[BTRFS_STRIPE_LEN / PAGE_SIZE] is the first page of the second
- * data stripe.
  *
  * Some pointers inside stripe_pages[] can be NULL, e.g. for a full stripe write
  * (the bio covers all data stripes) there is no need to allocate pages for
@@ -81,7 +79,7 @@ enum btrfs_rbio_ops {
  *
  * - sector_nr
  *   Starts from 0 (representing the first sector of the stripe), ends
- *   at BTRFS_STRIPE_LEN / sectorsize - 1.
+ *   at stripe_len / sectorsize - 1.
  *
  * - step_nr
  *   A step is min(sector_size, PAGE_SIZE).
@@ -153,9 +151,6 @@ struct btrfs_raid_bio {
 	/* Number of all stripes (including P/Q) */
 	u8 real_stripes;
 
-	/* How many pages there are for each stripe */
-	u8 stripe_npages;
-
 	/* How many sectors there are for each stripe */
 	u8 stripe_nsectors;
 
-- 
2.56.0

