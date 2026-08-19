Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CEE298CC4
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 01:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787101626; cv=none; b=t1xeDPnXDpUFyGVwA0yXeZFGqd9bgr1q/oJD2kbX8Li+nlW9SBlreGFqFOWN/jQkPMx1cRoUgRn3CZ43ZTKIiMp16yYi8S5H57U9prr7dtadAxDbNOm3GUWMVJ02hzrkOwkYQLxBF1p7yt8zchxnxAfEZHHbTAuLmJbs2s+UUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787101626; c=relaxed/simple;
	bh=psHj3XDpLyzdALlOFDnSOIMFciw3pj1ckFxoM+P8QFA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUmfnfqbvq9ke26is1SYo/fRWRMGU/7ujp9HufwJbPnTxl73yf36j74Aubyg9xV0ZFyeerw0VnOmvhWV0jcwizxxH4HehnNAs2qdEXITribmkA9Nybr21cUFJcluCnHg2MdsJoItv6sl7bEDSlQFyh6o/qnS9hCOJYhgeE/kbns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q2PzSZ39; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UsY409bQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q2PzSZ39";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UsY409bQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DC5143EA6
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 01:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787101619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CRHuskyZZQfDvBUZwpRpFI+Lngn+ADEIb6Bjnss6Q2I=;
	b=Q2PzSZ39KL/nIKu7+C5Sw4p3slA3+ZWuUrP7eA/Nt4rJROoyDU3VoC+/FqQ1IBPuiUb8hq
	r8RcfCicZg+aVDyGWOkxg+F718Mg5EDjD/p511PHHPSqS09wm2YDN1o76h52hdaNOokgmi
	y+APcRBQI1X4K3cBnrlLX4Xo8qzkPuc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UsY409bQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787101614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CRHuskyZZQfDvBUZwpRpFI+Lngn+ADEIb6Bjnss6Q2I=;
	b=UsY409bQsjBh+YFHmbdLpeDufTUrbMKUkqcpUcRBf1l1pLwG9egyFjMprKf+OuaAqYvuiE
	fBfOt4Cimuwj+U8qj5ruT49dk9wnDD8uu9/wqGVXUqVS1bK9KNp2dZt8QpVMowJ7I/qD3H
	4ZraLdSFcDrE+pRkWWWlYjgeo6yAtqM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD6BE367B
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 01:06:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uGDEGK0BhWruVgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 01:06:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 RESEND 4/4] btrfs: remove on-stack paddrs[] array usage
Date: Wed, 19 Aug 2026 10:36:19 +0930
Message-ID: <123d92a668593165efdcf2f498854d51aa2f29a7.1787101260.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1787101260.git.wqu@suse.com>
References: <cover.1787101260.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: DC5143EA6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Since the bs > ps support, we have to handle cases where a data block is
inside several uncontig pages.

Thus we need a local paddrs[] array to assemble a data block for bs > ps
cases.

However to handle all possible bs/ps combinations, we have to declare
such array using the max block size vs page size, no matter the current
block size and page size.

This adds 128 bytes on-stack memory usage for several call sites, and
also introduced several duplicated helpers to calculate checksum for a
data block:

- btrfs_calculate_block_csum_folio()
- btrfs_calculate_block_csum_pages()
- btrfs_check_block_csum()

The differences are mostly in how the data is passed.
The first one accepts a contiguous paddr range.
The second one accepts an array of paddrs[].
The last one is just a simple wrapper of the first one.

However the most common interface to iterate a data block is through
bio, and we have already converted most callers to use the bio based
interface, e.g. btrfs_bio_data_csum_ok() and btrfs_csum_one_bio_block().

Convert the remaining two call sites to address the remaining paddrs[]
usage:

- btrfs_calculate_block_csum_pages() inside verify_bio_data_sectors()
  This can be switched to btrfs_csum_one_bio_block().

  This removes the 128 bytes on-stack memory usage.

- btrfs_calculate_block_csum_pages() inside verify_one_sector()
  This call site doesn't use on-stack memory for paddrs[], but reuses
  the existing btrfs_raid_bio::bio_paddrs[] or
  btrfs_raid_bio::stripe_paddrs[].

  So implement a local version called calculate_block_csum_paddrs().

Now there is no fixed on-stack paddrs[] usage anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h |  6 ----
 fs/btrfs/inode.c       | 75 ------------------------------------------
 fs/btrfs/raid56.c      | 47 +++++++++++++++-----------
 3 files changed, 28 insertions(+), 100 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6d02964da8ed..ad6c0c276887 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -507,12 +507,6 @@ static inline void btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
 				      inode->root->fs_info->block_max_order);
 }
 
-void btrfs_calculate_block_csum_folio(struct btrfs_fs_info *fs_info,
-				      const phys_addr_t paddr, u8 *dest);
-void btrfs_calculate_block_csum_pages(struct btrfs_fs_info *fs_info,
-				      const phys_addr_t paddrs[], u8 *dest);
-int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8 *csum,
-			   const u8 * const csum_expected);
 bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
 			    struct btrfs_device *dev);
 void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15c80f3f53d7..8cbaea5bfe14 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3456,81 +3456,6 @@ int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered)
 	return btrfs_finish_one_ordered(ordered);
 }
 
-/*
- * Calculate the checksum of an fs block at physical memory address @paddr,
- * and save the result to @dest.
- *
- * The folio containing @paddr must be large enough to contain a full fs block.
- */
-void btrfs_calculate_block_csum_folio(struct btrfs_fs_info *fs_info,
-				      const phys_addr_t paddr, u8 *dest)
-{
-	struct folio *folio = page_folio(phys_to_page(paddr));
-	const u32 blocksize = fs_info->sectorsize;
-	const u32 step = min(blocksize, PAGE_SIZE);
-	const u32 nr_steps = blocksize / step;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-
-	/* The full block must be inside the folio. */
-	ASSERT(offset_in_folio(folio, paddr) + blocksize <= folio_size(folio));
-
-	for (int i = 0; i < nr_steps; i++) {
-		u32 pindex = offset_in_folio(folio, paddr + i * step) >> PAGE_SHIFT;
-
-		/*
-		 * For bs <= ps cases, we will only run the loop once, so the offset
-		 * inside the page will only added to paddrs[0].
-		 *
-		 * For bs > ps cases, the block must be page aligned, thus offset
-		 * inside the page will always be 0.
-		 */
-		paddrs[i] = page_to_phys(folio_page(folio, pindex)) + offset_in_page(paddr);
-	}
-	return btrfs_calculate_block_csum_pages(fs_info, paddrs, dest);
-}
-
-/*
- * Calculate the checksum of a fs block backed by multiple noncontiguous pages
- * at @paddrs[] and save the result to @dest.
- *
- * The folio containing @paddr must be large enough to contain a full fs block.
- */
-void btrfs_calculate_block_csum_pages(struct btrfs_fs_info *fs_info,
-				      const phys_addr_t paddrs[], u8 *dest)
-{
-	const u32 blocksize = fs_info->sectorsize;
-	const u32 step = min(blocksize, PAGE_SIZE);
-	const u32 nr_steps = blocksize / step;
-	struct btrfs_csum_ctx csum;
-
-	btrfs_csum_init(&csum, fs_info->csum_type);
-	for (int i = 0; i < nr_steps; i++) {
-		const phys_addr_t paddr = paddrs[i];
-		void *kaddr;
-
-		ASSERT(offset_in_page(paddr) + step <= PAGE_SIZE);
-		kaddr = kmap_local_page(phys_to_page(paddr)) + offset_in_page(paddr);
-		btrfs_csum_update(&csum, kaddr, step);
-		kunmap_local(kaddr);
-	}
-	btrfs_csum_final(&csum, dest);
-}
-
-/*
- * Verify the checksum for a single sector without any extra action that depend
- * on the type of I/O.
- *
- * @kaddr must be a properly kmapped address.
- */
-int btrfs_check_block_csum(struct btrfs_fs_info *fs_info, phys_addr_t paddr, u8 *csum,
-			   const u8 * const csum_expected)
-{
-	btrfs_calculate_block_csum_folio(fs_info, paddr, csum);
-	if (unlikely(memcmp(csum, csum_expected, fs_info->csum_size) != 0))
-		return -EIO;
-	return 0;
-}
-
 /* Generate data checksum for a single fs block, pointed by @orig_iter. */
 void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
 			      const struct bvec_iter *orig_iter, u8 *csum)
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1ee52a9dcee3..208839f06d3d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1652,12 +1652,7 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 				    struct bio *bio)
 {
 	struct btrfs_fs_info *fs_info = rbio->bioc->fs_info;
-	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u32 nr_steps = rbio->sector_nsteps;
 	int total_sector_nr = get_bio_sector_nr(rbio, bio);
-	u32 offset = 0;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
-	phys_addr_t paddr;
 
 	/* No data csum for the whole stripe, no need to verify. */
 	if (!rbio->csum_bitmap || !rbio->csum_buf)
@@ -1667,28 +1662,20 @@ static void verify_bio_data_sectors(struct btrfs_raid_bio *rbio,
 	if (total_sector_nr >= rbio->nr_data * rbio->stripe_nsectors)
 		return;
 
-	btrfs_bio_for_each_block_all(paddr, bio, step) {
+	for (struct bvec_iter iter = init_bvec_iter_for_bio(bio);
+	     iter.bi_size; bio_advance_iter(bio, &iter, fs_info->sectorsize),
+	     total_sector_nr++) {
 		u8 csum_buf[BTRFS_CSUM_SIZE];
 		u8 *expected_csum;
 
-		paddrs[(offset / step) % nr_steps] = paddr;
-		offset += step;
-
-		/* Not yet covering the full fs block, continue to the next step. */
-		if (!IS_ALIGNED(offset, fs_info->sectorsize))
-			continue;
-
 		/* No csum for this sector, skip to the next sector. */
-		if (!test_bit(total_sector_nr, rbio->csum_bitmap)) {
-			total_sector_nr++;
+		if (!test_bit(total_sector_nr, rbio->csum_bitmap))
 			continue;
-		}
 
 		expected_csum = rbio->csum_buf + total_sector_nr * fs_info->csum_size;
-		btrfs_calculate_block_csum_pages(fs_info, paddrs, csum_buf);
+		btrfs_csum_one_bio_block(fs_info, bio, &iter, csum_buf);
 		if (unlikely(memcmp(csum_buf, expected_csum, fs_info->csum_size) != 0))
 			set_bit(total_sector_nr, rbio->error_bitmap);
-		total_sector_nr++;
 	}
 }
 
@@ -1879,6 +1866,28 @@ void raid56_parity_write(struct bio *bio, struct btrfs_io_context *bioc)
 	start_async_work(rbio, rmw_rbio_work);
 }
 
+static void calculate_block_csum_paddrs(struct btrfs_fs_info *fs_info,
+					const phys_addr_t paddrs[],
+					u8 *dest)
+{
+	const u32 blocksize = fs_info->sectorsize;
+	const u32 step = min(blocksize, PAGE_SIZE);
+	const u32 nr_steps = blocksize / step;
+	struct btrfs_csum_ctx csum;
+
+	btrfs_csum_init(&csum, fs_info->csum_type);
+	for (int i = 0; i < nr_steps; i++) {
+		const phys_addr_t paddr = paddrs[i];
+		void *kaddr;
+
+		ASSERT(offset_in_page(paddr) + step <= PAGE_SIZE);
+		kaddr = kmap_local_page(phys_to_page(paddr)) + offset_in_page(paddr);
+		btrfs_csum_update(&csum, kaddr, step);
+		kunmap_local(kaddr);
+	}
+	btrfs_csum_final(&csum, dest);
+}
+
 static int verify_one_sector(struct btrfs_raid_bio *rbio,
 			     int stripe_nr, int sector_nr)
 {
@@ -1906,7 +1915,7 @@ static int verify_one_sector(struct btrfs_raid_bio *rbio,
 	csum_expected = rbio->csum_buf +
 			(stripe_nr * rbio->stripe_nsectors + sector_nr) *
 			fs_info->csum_size;
-	btrfs_calculate_block_csum_pages(fs_info, paddrs, csum_buf);
+	calculate_block_csum_paddrs(fs_info, paddrs, csum_buf);
 	if (unlikely(memcmp(csum_buf, csum_expected, fs_info->csum_size) != 0))
 		return -EIO;
 	return 0;
-- 
2.54.0

