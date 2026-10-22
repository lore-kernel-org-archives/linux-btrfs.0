Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662000;
	b=UwVT562gz+6pFL8fIEpmIQKyMbtJZOmWuwh7Yi8XwmWVCP3ZeJhN1k8Xi+D9Yt09JtWS
	 okedx8ApGSUrLqwcJQAt1WRbk4RutnqnFRRsxQaWkpBIfXzwrAFTew9SXmdPyyST7WC2m
	 KQuUNQ80Ije3cbGJ6u2tSRgWtXA+k7m+rikkb4u9OxtqLbGhtSi8LGB7Yo9DtGRAvwssh
	 kn2eV6fxhYZxyvyF6bZGtE67r40BozDtHJ/yrnlwVQz5ZljZ8R+q36rieDzjp7RQEuquM
	 ynq5z11M7mMCdML1kcKJrBbm8fllnP0EOW6UQ1zF5Qchh51lHZt/EVsAEL3ID1K5iLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662000;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=5eORaZpdBI5CqgGQJXUqg6aUkveqon8OMXxHVdW2Gf0=;
	b=Iu/2Pnk7ow2CYJfwUINMymtY4H+yQHWsBv6oFd01PPoK6jmY1kRvOwX2Tw8AxnhnQXaf
	 8Td4gAADEWI6Lm5Tj2E4LaUvjDFdbITS3ZSfhbCcO4ZVen/+l8COmg+392biivgGS7UFv
	 BjUBgINNX1I5moEK9Jqs2D03AkGqv3k8PWHNIcDLzYC8SO7svb9isqbHfr3/f8IDe9T0N
	 SjQkwPasvRlyKKv+b3NFA//y+sA8CsrIOh13VN7GM5xuAloaAHNY/atAQ1C9oqq0evefN
	 7QFk45JzLo21UudK2SzKn75ZvkY49A4yLhds0ksEhQv3Eq7+d6omNhxcgLBsBDSbslw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MH2a+Dde;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=P7PW18oA;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA9606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CBA9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MH2a+Dde;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=P7PW18oA
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACEC61FCD6
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eORaZpdBI5CqgGQJXUqg6aUkveqon8OMXxHVdW2Gf0=;
	b=MH2a+DdezDwSbQbC7QYYUHhA+NgU7VVIJYSd79Dsxj3dWFsmLQwMbD8V100ErOxtuGUSZp
	Y+l7pET8cTPaw73DJynX7cweOFDVlVZWRIdD8MmydnIjQ7PsPlgS4d3Lz2m9vlVFD4L7U3
	ZrVE5G7VPtPOt1MD4h2KXOuUZMrupuY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=P7PW18oA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eORaZpdBI5CqgGQJXUqg6aUkveqon8OMXxHVdW2Gf0=;
	b=P7PW18oAYGfP+vvzUVrj6VKb1O+48k3Op41aI+nuvvGTy80EATvMVrFpOUQFU1Z5wlJkRL
	MePJ5wEiPK1xIU5y/enJaA/3SFvRcIWQhijCJZ4vqAlMASmjQNJFi6sI3ccf68DoJwrqKv
	jeJ6z5lp9yi4i7h6zbxPe0gprWn2yX0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93583133F3
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sUAVLufZ2Wp7dQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: add stripe_len < PAGE_SIZE support for steal_rbio()
Date: Thu, 22 Oct 2026 20:09:28 +1030
Message-ID: <b4ad468160a26d3d885895c9fbe58e081587fd20.1792661955.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792661955.git.wqu@suse.com>
References: <cover.1792661955.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: ACEC61FCD6

The function steal_rbio() is utilized to use the pages that belongs to
uptodate data blocks, without doing a page copy.

That is done by just updating the dest->stripe_pages[] pointer to use
the point inside @src directly.

That function previously will reject stripe_len < PAGE_SIZE cases, as a
page can contain both data and P/Q blocks.

But that shouldn't be a big deal, as long as the corresponding P/Q
blocks are not marked uptodate, we can still steal the page that also
contains P/Q blocks.

So rework steal_rbio() to support stripe_len < PAGE_SIZE by:

- Calculate the last page index correctly
  Instead of iterating all pages but skip P/Q pages, calculate the last
  page index properly.

  The last page may contain both data and P/Q blocks, but we can still
  steal the page.

- Update the bitmap in one go
  Instead of updating the stripe_uptodate_bitmap for every page, we can
  do the update in just one go, out of the main loop.

  And that update should not touch the P/Q blocks.

- Remove unused helpers
  * page_nr_to_sector_nr()
  * page_nr_to_num_sectors()
  * steal_rbio_page()
  * is_data_stripe_page()

  * full_page_sectors_uptodate()
    This one is very annoying, because of its __maybe_unused
    attribution.

  They are based on the old BTRFS_STRIPE_LEN >= PAGE_SIZE assumption,
  and no longer utilized.

- Make index_stripe_sectors() update the stripe_paddrs[] without a page
  This doesn't cause any functional change for now, as there is no one
  accessing the source stripe_paddrs[] after a steal.

  But this should still make the function a little more robust.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 127 +++++++++-------------------------------------
 1 file changed, 23 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0c792d85f520..c81f7a0297e4 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -307,55 +307,8 @@ static int rbio_bucket(struct btrfs_raid_bio *rbio)
 	return hash_64(num >> 16, BTRFS_STRIPE_HASH_TABLE_BITS);
 }
 
-/* Get the sector number of the first sector covered by @page_nr. */
-static u32 page_nr_to_sector_nr(struct btrfs_raid_bio *rbio, unsigned int page_nr)
-{
-	u32 sector_nr;
-
-	ASSERT(page_nr < rbio->nr_pages);
-
-	sector_nr = (page_nr << PAGE_SHIFT) >> rbio->bioc->fs_info->sectorsize_bits;
-	ASSERT(sector_nr < rbio->nr_sectors);
-	return sector_nr;
-}
-
 /*
- * Get the number of sectors covered by @page_nr.
- *
- * For bs > ps cases, the result will always be 1.
- * For bs <= ps cases, the result will be ps / bs.
- */
-static u32 page_nr_to_num_sectors(struct btrfs_raid_bio *rbio, unsigned int page_nr)
-{
-	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
-	u32 nr_sectors;
-
-	ASSERT(page_nr < rbio->nr_pages);
-
-	nr_sectors = round_up(PAGE_SIZE, fs_info->sectorsize) >> fs_info->sectorsize_bits;
-	ASSERT(nr_sectors > 0);
-	return nr_sectors;
-}
-
-static __maybe_unused bool full_page_sectors_uptodate(struct btrfs_raid_bio *rbio,
-						      unsigned int page_nr)
-{
-	const u32 sector_nr = page_nr_to_sector_nr(rbio, page_nr);
-	const u32 nr_bits = page_nr_to_num_sectors(rbio, page_nr);
-	int i;
-
-	ASSERT(page_nr < rbio->nr_pages);
-	ASSERT(sector_nr + nr_bits < rbio->nr_sectors);
-
-	for (i = sector_nr; i < sector_nr + nr_bits; i++) {
-		if (!test_bit(i, rbio->stripe_uptodate_bitmap))
-			return false;
-	}
-	return true;
-}
-
-/*
- * Update the stripe_sectors[] array to use correct page and pgoff
+ * Update the stripe_paddrs[] array to use correct paddr.
  *
  * Should be called every time any page pointer in stripes_pages[] got modified.
  */
@@ -370,82 +323,48 @@ static void index_stripe_sectors(struct btrfs_raid_bio *rbio)
 		int page_index = offset >> PAGE_SHIFT;
 
 		ASSERT(page_index < rbio->nr_pages);
-		if (!rbio->stripe_pages[page_index])
+		if (!rbio->stripe_pages[page_index]) {
+			rbio->stripe_paddrs[i] = INVALID_PADDR;
 			continue;
+		}
 
 		rbio->stripe_paddrs[i] = page_to_phys(rbio->stripe_pages[page_index]) +
 					 offset_in_page(offset);
 	}
 }
 
-static void steal_rbio_page(struct btrfs_raid_bio *src,
-			    struct btrfs_raid_bio *dest, int page_nr)
-{
-	const u32 sector_nr = page_nr_to_sector_nr(src, page_nr);
-	const u32 nr_bits = page_nr_to_num_sectors(src, page_nr);
-
-	ASSERT(page_nr < src->nr_pages);
-	ASSERT(sector_nr + nr_bits < src->nr_sectors);
-
-	if (dest->stripe_pages[page_nr])
-		__free_page(dest->stripe_pages[page_nr]);
-	dest->stripe_pages[page_nr] = src->stripe_pages[page_nr];
-	src->stripe_pages[page_nr] = NULL;
-
-	/* Also update the stripe_uptodate_bitmap bits. */
-	bitmap_set(dest->stripe_uptodate_bitmap, sector_nr, nr_bits);
-}
-
-static bool is_data_stripe_page(struct btrfs_raid_bio *rbio, int page_nr)
-{
-	const int sector_nr = page_nr_to_sector_nr(rbio, page_nr);
-
-	/*
-	 * The caller has ensured stripe_len >= PAGE_SIZE, and PAGE_SIZE is
-	 * aligned with sectorsize, thus we won't have a page which is half
-	 * data half parity.
-	 *
-	 * Thus if the first sector of the page belongs to data stripes, then
-	 * the full page belongs to data stripes.
-	 */
-	return (sector_nr < rbio_nr_data_sectors(rbio));
-}
-
 /*
- * Stealing an rbio means taking all the uptodate pages from the stripe array
- * in the source rbio and putting them into the destination rbio.
+ * Stealing an rbio means taking all pages containing data blocks from the
+ * stripe array in the source rbio and putting them into the destination rbio.
  *
- * This will also update the involved stripe_sectors[] which are referring to
+ * This will also update the involved stripe_paddrs[] which are referring to
  * the old pages.
  */
 static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 {
-	int i;
+	const u32 nr_data_blocks = rbio_nr_data_sectors(src);
+	const u32 last_data_pos = nr_data_blocks << src->bioc->fs_info->sectorsize_bits;
+	const u32 last_pindex = round_up(last_data_pos, PAGE_SIZE) >> PAGE_SHIFT;
 
 	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
 		return;
-	/* Data and P/Q can be mixed into a page, skip stealing. */
-	if (src->bioc->stripe_len < PAGE_SIZE)
-		return;
 
-	for (i = 0; i < dest->nr_pages; i++) {
-		struct page *p = src->stripe_pages[i];
+	/* All data blocks in the src should be uptodate. */
+	ASSERT(bitmap_full(src->stripe_uptodate_bitmap, nr_data_blocks));
 
-		/*
-		 * We don't need to steal P/Q pages as they will always be
-		 * regenerated for RMW or full write anyway.
-		 */
-		if (!is_data_stripe_page(src, i))
-			continue;
+	/* Steal all pages that contains any data block. */
+	for (int i = 0; i < last_pindex; i++) {
+		ASSERT(src->stripe_pages[i]);
 
-		/*
-		 * If @src already has RBIO_CACHE_READY_BIT, it should have
-		 * all data stripe pages present and uptodate.
-		 */
-		ASSERT(p);
-		ASSERT(full_page_sectors_uptodate(src, i));
-		steal_rbio_page(src, dest, i);
+		if (dest->stripe_pages[i])
+			__free_page(dest->stripe_pages[i]);
+		dest->stripe_pages[i] = src->stripe_pages[i];
+		src->stripe_pages[i] = NULL;
 	}
+
+	/* Only data blocks should be set uptodate. */
+	bitmap_set(dest->stripe_uptodate_bitmap, 0, nr_data_blocks);
+
 	index_stripe_sectors(dest);
 	index_stripe_sectors(src);
 }
-- 
2.56.0

