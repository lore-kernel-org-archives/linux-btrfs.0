Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760EA4BEE52
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298996; cv=none; b=PAW/ZAy7jfCQAqr+4b4CKz6pX+A2Z4XBWeHO/qD4REBtefWXz8iPcFBwwa4ZRiIFEKkBkDXnP9QjOrY9FI+qFfoRsv2irDyJLCAUn1sYXqRUijVcgsmIwwMIItAALAa5goN1JlC8oKaW8DDsRWj5J7FZRgh4iIyYaNxvy6BFafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298996; c=relaxed/simple;
	bh=BW+lqmCc22p6FtN/PmJ/uEExXXZuZv0OfJIG0gmdLA0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CzkFDeaEiIHQXn2sPqtZnq9+o5XddiyDKn6B+CQisPihGlQRhvdJ8shEKhJUe3kHXq3ULEWdFVs9f3ZoL8BbVeTgGRGyrTbWSM09KUfqA8J0ojzQhOa3eGk5lukHHtIz5DRyoMpo30Qqo42qfRyKxt3oRFFF244+bmrORY3w8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mOgGEHBT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Dg1NOV47; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mOgGEHBT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Dg1NOV47"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 034F11F7B9
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789298983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzWipwJPefJ8nVrvpxe8Mu15V+Vb5lUFeWaObv8GDiI=;
	b=mOgGEHBT7WRmcQuR/RXUFQQXXijD8HxZIjl+uHr2UDVBmxDm3auq8sGW0PpDYOjwlHZsTA
	NBY7dClA1fAemNgI7+z28nj5tqVrs6cuclRUEXDJjMdK5A9IIlDbUGMyD7pUtXq7eKXoIo
	uMKfQfAifleR+5a7aATuuHivXLQc7MU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Dg1NOV47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789298979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzWipwJPefJ8nVrvpxe8Mu15V+Vb5lUFeWaObv8GDiI=;
	b=Dg1NOV470fQCSKZRSGOgY5N0lrhOwUIrj6yQ5FQywlsMT7gHXf1+FmaWEsCuE7AWKPVKmB
	z2Wnd9dPIQkMG9HMCon7C6r7alVX9AdLovK7jxI3tdG4eThjxoDMd/bc1mbyaZxa6JO8fS
	+j/9JMYRFbfrCrs83JkQN4Gs8XrCrKw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B88A713675
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 11:29:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B3lSGSGJpmqANQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 11:29:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: cleanup submit_extent_folio()
Date: Sun, 13 Sep 2026 20:59:15 +0930
Message-ID: <ce764b1e763090b6d8983a06bb57ef08f74b1206.1789298944.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 034F11F7B9
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

Cleanup submit_extent_folio() by:

- Remove @size parameter
  Since commit b2e743927fdd ("btrfs: make btrfs_do_readpage() to do
  block-by-block read"), all callers are passing sectorsize as @size,
  so there is no need for such parameter.

  Furthermore since we only write one block at a time, there is no need
  for a while() loop, nor the advance of various local variables.

- Update the comments on the parameter list
  * @disk_bytenr is shared for both read and write
  * rename @page to @folio

- Update the return value to return 0 or error
  Since we won't queue multiple blocks anyway, there is no point in
  returning the queued bytes.
  It makes more sense to return an error code, although the only error
  code will be -EUCLEAN for writes.

- Rename submit_extent_folio() to submit_one_block()

- Rename submit_one_sector() to submit_write_sector()

- Update the error message to utilize the new returned error code inside
  submit_write_sector()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 190 +++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 106 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a221b63bdb20..eb62568ddece 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -110,14 +110,14 @@ struct btrfs_bio_ctrl {
 	 * make the decision when submitting the bio.
 	 *
 	 * The pattern between do_readpage(), submit_one_bio() and
-	 * submit_extent_folio() is quite subtle, so tracking this is tricky.
+	 * submit_one_block() is quite subtle, so tracking this is tricky.
 	 *
 	 * As we process extent E, we might submit a bio with existing built up
 	 * extents before adding E to a new bio, or we might just add E to the
 	 * bio. As a result, E's generation could apply to the current bio or
 	 * to the next one, so we need to be careful to update the bio_ctrl's
 	 * generation with E's only when we are sure E is added to bio_ctrl->bbio
-	 * in submit_extent_folio().
+	 * in submit_one_block().
 	 *
 	 * See the comment in btrfs_lookup_bio_sums() for more detail on the
 	 * need for this optimization.
@@ -797,118 +797,97 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 }
 
 /*
- * @disk_bytenr: logical bytenr where the write will be
- * @page:	page to add to the bio
- * @size:	portion of page that we want to write to
- * @pg_offset:	offset of the new bio or to check whether we are adding
- *              a contiguous page to the previous one
+ * @disk_bytenr: logical bytenr where the read/write will be
+ * @folio:	the folio that the block belongs to
+ * @pg_offset:	the offset inside the folio
  * @read_em_generation: generation of the extent_map we are submitting
  *			(only used for read)
  *
- * The will either add the page into the existing @bio_ctrl->bbio, or allocate a
+ * This will either add the block into the existing @bio_ctrl->bbio, or allocate a
  * new one in @bio_ctrl->bbio.
  * The mirror number for this IO should already be initialized in
  * @bio_ctrl->mirror_num.
  *
- * Return the number of bytes that are queued into a bio.
- * If the returned bytes is smaller than @size, it means we hit a critical error
- * for data write, where there is no ordered extent for the range.
+ * Return 0 if the block is queued or submitted.
+ * Return <0 for error.
  */
-static unsigned int submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
-					u64 disk_bytenr, struct folio *folio,
-					size_t size, unsigned long pg_offset,
-					u64 read_em_generation)
+static int submit_one_block(struct btrfs_bio_ctrl *bio_ctrl,
+			    u64 disk_bytenr, struct folio *folio,
+			    unsigned long pg_offset, u64 read_em_generation)
 {
 	struct btrfs_inode *inode = folio_to_inode(folio);
+	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u32 blocksize = fs_info->sectorsize;
 	loff_t file_offset = folio_pos(folio) + pg_offset;
-	unsigned int queued = 0;
 
-	ASSERT(pg_offset + size <= folio_size(folio));
+	ASSERT(pg_offset + blocksize <= folio_size(folio));
 	ASSERT(bio_ctrl->end_io_func);
 
 	if (bio_ctrl->bbio &&
 	    !btrfs_bio_is_contig(bio_ctrl, disk_bytenr, file_offset))
 		submit_one_bio(bio_ctrl);
 
-	do {
-		u32 len = size;
+again:
+	/* Allocate new bio if needed */
+	if (!bio_ctrl->bbio) {
+		int ret;
 
-		/* Allocate new bio if needed */
-		if (!bio_ctrl->bbio) {
-			int ret;
+		ret = alloc_new_bio(inode, bio_ctrl, disk_bytenr, file_offset);
+		if (ret < 0)
+			return ret;
+	}
 
-			ret = alloc_new_bio(inode, bio_ctrl, disk_bytenr, file_offset);
-			if (ret < 0)
-				break;
-		}
+	if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, blocksize, pg_offset)) {
+		/* bio full: move on to a new one */
+		submit_one_bio(bio_ctrl);
+		goto again;
+	}
 
-		/* Cap to the current ordered extent boundary if there is one. */
-		if (len > bio_ctrl->len_to_oe_boundary) {
-			ASSERT(bio_ctrl->compress_type == BTRFS_COMPRESS_NONE);
-			ASSERT(is_data_inode(inode));
-			len = bio_ctrl->len_to_oe_boundary;
-		}
+	/*
+	 * Now that the folio is definitely added to the bio, include its
+	 * generation in the max generation calculation.
+	 */
+	bio_ctrl->generation = max(bio_ctrl->generation, read_em_generation);
+	bio_ctrl->next_file_offset += blocksize;
 
-		if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, len, pg_offset)) {
-			/* bio full: move on to a new one */
-			submit_one_bio(bio_ctrl);
-			continue;
-		}
-		/*
-		 * Now that the folio is definitely added to the bio, include its
-		 * generation in the max generation calculation.
-		 */
-		bio_ctrl->generation = max(bio_ctrl->generation, read_em_generation);
-		bio_ctrl->next_file_offset += len;
+	if (bio_ctrl->wbc)
+		wbc_account_cgroup_owner(bio_ctrl->wbc, folio, blocksize);
 
-		if (bio_ctrl->wbc)
-			wbc_account_cgroup_owner(bio_ctrl->wbc, folio, len);
+	/*
+	 * len_to_oe_boundary defaults to U32_MAX, which isn't folio or
+	 * sector aligned.  alloc_new_bio() then sets it to the end of
+	 * our ordered extent for writes into zoned devices.
+	 *
+	 * When len_to_oe_boundary is tracking an ordered extent, the
+	 * len_to_oe_boundary should follow that OE and never go beyond
+	 * the max extent size (128MiB).
+	 *
+	 * When len_to_oe_boundary is U32_MAX, decreasing the length by
+	 * blocksize will never make it reach 0, thus skipping the later
+	 * submit_one_bio() call.
+	 * So if len_to_oe_boundary() is not tracking an OE, do not
+	 * decrease it.
+	 *
+	 * It's pretty hard to make a bio sized U32_MAX, but it can
+	 * happen when the page cache is able to feed us contiguous
+	 * folios for large extents.
+	 */
+	if (bio_ctrl->len_to_oe_boundary != U32_MAX)
+		bio_ctrl->len_to_oe_boundary -= blocksize;
 
-		size -= len;
-		pg_offset += len;
-		disk_bytenr += len;
-		file_offset += len;
-		queued += len;
-
-		/*
-		 * len_to_oe_boundary defaults to U32_MAX, which isn't folio or
-		 * sector aligned.  alloc_new_bio() then sets it to the end of
-		 * our ordered extent for writes into zoned devices.
-		 *
-		 * When len_to_oe_boundary is tracking an ordered extent, we
-		 * trust the ordered extent code to align things properly, and
-		 * the check above to cap our write to the ordered extent
-		 * boundary is correct.
-		 *
-		 * When len_to_oe_boundary is U32_MAX, the cap above would
-		 * result in a 4095 byte IO for the last folio right before
-		 * we hit the bio limit of UINT_MAX.  bio_add_folio() has all
-		 * the checks required to make sure we don't overflow the bio,
-		 * and we should just ignore len_to_oe_boundary completely
-		 * unless we're using it to track an ordered extent.
-		 *
-		 * It's pretty hard to make a bio sized U32_MAX, but it can
-		 * happen when the page cache is able to feed us contiguous
-		 * folios for large extents.
-		 */
-		if (bio_ctrl->len_to_oe_boundary != U32_MAX)
-			bio_ctrl->len_to_oe_boundary -= len;
-
-		/* Ordered extent boundary: move on to a new bio. */
-		if (bio_ctrl->len_to_oe_boundary == 0)
-			submit_one_bio(bio_ctrl);
-		/*
-		 * If we have accumulated decent amount of IO, send it to the
-		 * block layer so that IO can run while we are accumulating
-		 * more folios to write.
-		 */
-		else if (bio_ctrl->wbc &&
-			 bio_ctrl->bbio->bio.bi_iter.bi_size >=
-			    inode->root->fs_info->writeback_bio_size)
-			submit_one_bio(bio_ctrl);
-
-	} while (size);
-	return queued;
+	/* Ordered extent boundary: move on to a new bio. */
+	if (bio_ctrl->len_to_oe_boundary == 0)
+		submit_one_bio(bio_ctrl);
+	/*
+	 * If we have accumulated decent amount of IO, send it to the
+	 * block layer so that IO can run while we are accumulating
+	 * more folios to write.
+	 */
+	else if (bio_ctrl->wbc &&
+		 bio_ctrl->bbio->bio.bi_iter.bi_size >=
+		 fs_info->writeback_bio_size)
+		submit_one_bio(bio_ctrl);
+	return 0;
 }
 
 static int attach_extent_buffer_folio(struct extent_buffer *eb,
@@ -1092,7 +1071,6 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		u64 disk_bytenr;
 		u64 block_start;
 		u64 em_gen;
-		unsigned int queued;
 
 		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
 		if (cur >= last_byte) {
@@ -1206,10 +1184,10 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 
 		if (force_bio_submit)
 			submit_one_bio(bio_ctrl);
-		queued = submit_extent_folio(bio_ctrl, disk_bytenr, folio, blocksize,
-					     pg_offset, em_gen);
+		ret = submit_one_block(bio_ctrl, disk_bytenr, folio,
+				       pg_offset, em_gen);
 		/* Read submission should not fail. */
-		ASSERT(queued == blocksize);
+		ASSERT(ret == 0);
 	}
 	return 0;
 }
@@ -1830,10 +1808,10 @@ static struct btrfs_ordered_extent *get_oe_from_bbio(const struct btrfs_bio *bbi
  *
  * Caller should make sure filepos < i_size and handle filepos >= i_size case.
  */
-static int submit_one_sector(struct btrfs_inode *inode,
-			     struct folio *folio,
-			     u64 filepos, struct btrfs_bio_ctrl *bio_ctrl,
-			     loff_t i_size)
+static int submit_write_sector(struct btrfs_inode *inode,
+			       struct folio *folio,
+			       u64 filepos, struct btrfs_bio_ctrl *bio_ctrl,
+			       loff_t i_size)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_ordered_extent *oe;
@@ -1841,7 +1819,7 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	u64 disk_bytenr;
 	u64 extent_offset;
 	const u32 sectorsize = fs_info->sectorsize;
-	unsigned int queued;
+	int ret;
 
 	ASSERT(IS_ALIGNED(filepos, sectorsize));
 
@@ -1904,17 +1882,17 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	 */
 	ASSERT(folio_test_writeback(folio));
 
-	queued = submit_extent_folio(bio_ctrl, disk_bytenr, folio,
-				     sectorsize, filepos - folio_pos(folio), 0);
-	if (unlikely(queued < sectorsize)) {
+	ret = submit_one_block(bio_ctrl, disk_bytenr, folio,
+			       offset_in_folio(folio, filepos), 0);
+	if (unlikely(ret < 0)) {
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
 					       false);
 		btrfs_err_rl(fs_info,
-		"failed to queue sector for root %lld ino %llu filepos %llu",
+		"failed to queue sector for root %lld ino %llu filepos %llu: %pe",
 			     btrfs_root_id(inode->root),
-			     btrfs_ino(inode), filepos);
-		return -EUCLEAN;
+			     btrfs_ino(inode), filepos, ERR_PTR(ret));
+		return ret;
 	}
 	return 0;
 }
@@ -1999,7 +1977,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			btrfs_folio_clear_dirty(fs_info, folio, cur, fs_info->sectorsize);
 			continue;
 		}
-		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);
+		ret = submit_write_sector(inode, folio, cur, bio_ctrl, i_size);
 		if (unlikely(ret < 0)) {
 			if (!found_error)
 				found_error = ret;
-- 
2.55.0

