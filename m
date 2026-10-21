Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554021;
	b=swCvpBnl5KQJglZBSO/Cedc0umJVH9YF/WzBNzUINkHqXR9h3mJowj4tsGh9S6a9aRx6
	 YqXmJujzXFbmaHghfchO4/nX0mxcYFkGkMYREwOCv9OjtkHeg3QTaoxseYJbNAXMqm5zl
	 Eqsbh5ONHGmFF6AomIHxGuxZd9e1d3cF3qE/v0+91QgGDjfPbZGIpMPQoD4BTetJrCCKf
	 ZIEyMOh3jOefY6eqrA4yCFiuPDQCYx1sT6IdVEVcVlF9cPB5XbpRjO0MvKFR7oFBstVME
	 gIjgHJjqg81S78yvXgVegGcQc57mZqbFHWOvWwMRqj48VAKJdEEheNXjVS6f25quCMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554021;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=6XVpAMdl7hHKiy99M0dQOWxAJ/KVIO8m+0pCoPnI1tM=;
	b=qN3OgpV+oNrRgmaPKR1RhXOy+S+bh8J1fJE0nGlsHgy2ijKRu9Pfes4e7D/0n7gt6Q/3
	 9zGux4zEpos/JMyYhVQtqAFLqQIQQPl7+IYqQj9x9v/ZoNlJoEX/syrF6GWlHf24QIYG2
	 z7+Q1PbatjCCScbd7E9yqG/CxVxR8fFUs0+79G0M89u6ro6CN7XFyEOSxGwqyDkCHAWip
	 I8UPwZJsx4LRDpkXAgHpziEDfyh1UCMJxdE7eUZl3z3fH1vLxyeaFQbJfT9ssld45DpGJ
	 1Evrq2LSTmKl5cfSftERLTnbx5h02DOPfimxYSjK12rPXNi/TBONjWfcZIYGfM6RoCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S8xFfCDz;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S8xFfCDz;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5C2606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B5C2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S8xFfCDz;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=S8xFfCDz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7935821E3B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XVpAMdl7hHKiy99M0dQOWxAJ/KVIO8m+0pCoPnI1tM=;
	b=S8xFfCDzjPzHaMG8c697iDXtN6Z0GaQ1jWOLSZD4ewi9oLREvkF6dDDfYeiXrMxQDcauNZ
	oWs5/szEFvSI6rSwd/97T5aLL1xNkcWhII1CR6+vYN9a+4AqGKVtaAsJKI5YEVsOcJ+hGQ
	hopD3HE6AVILnQzmItLK1Is8WmkoaeM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XVpAMdl7hHKiy99M0dQOWxAJ/KVIO8m+0pCoPnI1tM=;
	b=S8xFfCDzjPzHaMG8c697iDXtN6Z0GaQ1jWOLSZD4ewi9oLREvkF6dDDfYeiXrMxQDcauNZ
	oWs5/szEFvSI6rSwd/97T5aLL1xNkcWhII1CR6+vYN9a+4AqGKVtaAsJKI5YEVsOcJ+hGQ
	hopD3HE6AVILnQzmItLK1Is8WmkoaeM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63928134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T8
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 7/9] btrfs: convert raid56.c to use rbio->bioc->stripe_len
Date: Wed, 21 Oct 2026 14:09:41 +1030
Message-ID: <2a2d16946dacfde963cf6c2d58e8af03ca7006f1.1792553748.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
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
 fs/btrfs/raid56.c | 57 +++++++++++++++++++++++++++++++----------------
 fs/btrfs/raid56.h |  7 +-----
 2 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5ec31299f1c3..080be467c6fc 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -395,8 +395,9 @@ static bool is_data_stripe_page(struct btrfs_raid_bio *rbio, int page_nr)
 	const int sector_nr = page_nr_to_sector_nr(rbio, page_nr);
 
 	/*
-	 * We have ensured PAGE_SIZE is aligned with sectorsize, thus
-	 * we won't have a page which is half data half parity.
+	 * The caller has ensured stripe_len >= PAGE_SIZE, and PAGE_SIZE is
+	 * aligned with sectorsize, thus we won't have a page which is half
+	 * data half parity.
 	 *
 	 * Thus if the first sector of the page belongs to data stripes, then
 	 * the full page belongs to data stripes.
@@ -417,6 +418,9 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 
 	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
 		return;
+	/* Data and P/Q can be mixed into a page, skip stealing. */
+	if (src->bioc->stripe_len < PAGE_SIZE)
+		return;
 
 	for (i = 0; i < dest->nr_pages; i++) {
 		struct page *p = src->stripe_pages[i];
@@ -624,12 +628,13 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
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
@@ -1041,11 +1046,12 @@ static phys_addr_t sector_paddr_in_rbio(struct btrfs_raid_bio *rbio,
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
@@ -1105,7 +1111,6 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->nr_pages = num_pages;
 	rbio->nr_sectors = num_sectors;
 	rbio->real_stripes = real_stripes;
-	rbio->stripe_npages = stripe_npages;
 	rbio->stripe_nsectors = stripe_nsectors;
 	rbio->sector_nsteps = sector_nsteps;
 	refcount_set(&rbio->refs, 1);
@@ -1134,9 +1139,17 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio)
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
@@ -1274,7 +1287,7 @@ static int rbio_add_io_paddrs(struct btrfs_raid_bio *rbio, struct bio_list *bio_
 
 	/* put a new bio on the list */
 	bio = bio_alloc(stripe->dev->bdev,
-			max(BTRFS_STRIPE_LEN >> PAGE_SHIFT, 1),
+			max(rbio->bioc->stripe_len >> PAGE_SHIFT, 1),
 			op, GFP_NOFS);
 	bio->bi_iter.bi_sector = disk_start >> SECTOR_SHIFT;
 	bio->bi_private = rbio;
@@ -1715,9 +1728,13 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 
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
@@ -1804,7 +1821,7 @@ static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
 
 	ASSERT_RBIO_LOGICAL(orig_logical >= full_stripe_start &&
 			    orig_logical + orig_len <= full_stripe_start +
-			    rbio->nr_data * BTRFS_STRIPE_LEN,
+			    rbio->nr_data * rbio->bioc->stripe_len,
 			    rbio, orig_logical);
 
 	bio_list_add(&rbio->bio_list, orig_bio);
@@ -3012,6 +3029,7 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
 	const u64 offset_in_full_stripe = data_logical -
 					  rbio->bioc->full_stripe_logical;
+	const u32 stripe_len = rbio->bioc->stripe_len;
 	int ret;
 
 	/*
@@ -3027,19 +3045,20 @@ void raid56_parity_cache_data_folios(struct btrfs_raid_bio *rbio,
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

