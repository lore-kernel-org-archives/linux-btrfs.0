Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1A11A3160
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 00:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220898; cv=none; b=CL6bUmBFgHJQdCLt2mleSUE1XsERfKLS7Xe72f71Azm2gKhYXfUIATzcsdSbeviBlNkKY2K14pPvjb0fj9rRX2jTPn5EdfoZduq9IG2/VJm9zOM06wRDnAtz1B4zubeue1MUy6mqS2RJVNW8OdKpJP6P6IWzUz+iNL3JUwpOB7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220898; c=relaxed/simple;
	bh=3VUs/m7lhuovoBnrvQsrT9NTtZYQpPfZHejQ39tBQ7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=efGWd6Y/KCcElrQFr6j5RaJHDZe/glmLkqxGnvfCrHtppNjqCoVX/+vMTGz8CJVxw1cx/EpSvRjGthdmpWtbavPKCul4RdjQHncJnxjn30iU5GZ3wuiwm8jzZd9Xj4PQ1UEnH1mJ3eqcWPwOfGiDbWAVFLBVenAH5OUDGz4vrzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GqFpnd0p; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FvDnwp4+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GqFpnd0p";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FvDnwp4+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA95021CE2;
	Tue,  1 Sep 2026 00:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788220890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Aq3iXMI1dxUTxl6xzbxnCZXWBdwf2ZQeq8eOW/fqW+c=;
	b=GqFpnd0p+ngcoh+YBrDz+xK/F3WQZ2jshyBd72f52aEBpHGqohS10Mb1OIJDgKGbUh8Kju
	56p17U9yTPLkzAeBxEdUg5FHEH7ARLQieuGWnsxCztIpvbdjyPdeoodL4i7hwgVUWl+I6j
	HMkrBHjMcmyD8zM1WXFSIUt1d6CfdFY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FvDnwp4+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788220885; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Aq3iXMI1dxUTxl6xzbxnCZXWBdwf2ZQeq8eOW/fqW+c=;
	b=FvDnwp4+v2/1IE03fU/nYJRLlv0i2tU2W8S2UFqnohEAmpNO9iadWZQvLLvcrJKa17cDfb
	24AsHDZVzDYnhqDEXFbzAagWxeHU0LUxVCKc2VYTkxMOIRfRDcLy2fDaDT0BAKZdUjiibh
	ycx49PpTX836iei2a6oKVDZSFi1OG9w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D8E81342D;
	Tue,  1 Sep 2026 00:01:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yKr0CtQVlmqJIQAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 01 Sep 2026 00:01:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>
Subject: [PATCH v3] btrfs: use ordered extent to grab the logical address for submission
Date: Tue,  1 Sep 2026 09:31:01 +0930
Message-ID: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: EA95021CE2
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bur.io:email,suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

In submit_one_sector() we call btrfs_get_extent() to grab the IO extent
map so that we know where the logical location to submit the block.

However there is no guarantee that there is an IO extent map for the
block, and if there is no IO extent map nor ordered extent,
btrfs_get_extent() can grab the file extent from on-disk metadata.

That's why we have ASSERT()s to reject holes and compressed file
extents.

On the other hand, for the write range we should have both an IO extent
map and an ordered extent, so there is no reason not to grab the ordered
extent instead.

There is some minor advantages:

- No hole ordered extent
  So no need to rely on ASSERT()s to reject hole extents.

  And the ASSERT()s are depending on the kernel config, without
  CONFIG_BTRFS_ASSERT those ASSERT()s won't even trigger.

- No IO errors
  Unlike btrfs_get_extent() which can return IO error when doing the
  metadata tree search, btrfs_lookup_ordered_extent() will either return
  an OE or not found.

- Cached OE in bio_ctrl->bbio
  At bbio allocation we have already did an OE lookup, and we have a
  high chance that the current block also belongs to that OE.
  Use that cached OE can reduce the frequency to do an rb-tree search.

- Smaller rb-tree
  Unlike extent-map-tree, which can contain cached extent maps, the life
  span of ordered extents are much shorter, they get removed from the
  ordered tree after the file extent item is inserted into the subvolume
  tree.

  So doing ordered extent tree search can be a tiny faster.

And since we're here, also address some minor points:

- Add error message for every EUCLEAN error

- Remove a dead comment on btrfs_folio_clear_dirty()
  We no longer call folio_clear_dirty_for_io() since commit 095be159f3eb
  ("btrfs: unify folio dirty flag clearing"), so the folio flag is
  still dirty, and the folio dirty flag will be cleared by the last dirty
  block.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>

---
Changelog:
v3:
- Refactor the helper to grab the OE and increase its refs in one go

v2:
- Extract a helper to determine if the @filepos is in the bbio OE range
  Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
  in_range() to make is easier to read.
---
 fs/btrfs/extent_io.c | 64 +++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d7600e5fa3d9..a221b63bdb20 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1808,6 +1808,22 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	return 0;
 }
 
+static struct btrfs_ordered_extent *get_oe_from_bbio(const struct btrfs_bio *bbio,
+						     u64 filepos)
+{
+	struct btrfs_ordered_extent *oe;
+
+	if (!bbio || !bbio->ordered)
+		return NULL;
+
+	oe = bbio->ordered;
+	if (!in_range(filepos, oe->file_offset, oe->num_bytes))
+		return NULL;
+
+	refcount_inc(&oe->refs);
+	return oe;
+}
+
 /*
  * Return 0 if we have submitted or queued the sector for submission.
  * Return <0 for critical errors, and the involved sector will be cleaned up.
@@ -1820,11 +1836,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
 			     loff_t i_size)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct extent_map *em;
+	struct btrfs_ordered_extent *oe;
 	u64 block_start;
 	u64 disk_bytenr;
 	u64 extent_offset;
-	u64 em_end;
 	const u32 sectorsize = fs_info->sectorsize;
 	unsigned int queued;
 
@@ -1833,8 +1848,11 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	/* @filepos >= i_size case should be handled by the caller. */
 	ASSERT(filepos < i_size);
 
-	em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
-	if (IS_ERR(em)) {
+	/* Try to reuse the existing OE from bbio first. */
+	oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
+	if (!oe)
+		oe = btrfs_lookup_ordered_extent(inode, filepos);
+	if (unlikely(!oe)) {
 		/*
 		 * bio_ctrl may contain a bio crossing several folios.
 		 * Submit it immediately so that the bio has a chance
@@ -1857,31 +1875,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
 		 */
 		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
 					       false);
-		return PTR_ERR(em);
+		btrfs_err_rl(fs_info,
+		"no ordered extent for root %lld ino %llu filepos %llu",
+			     btrfs_root_id(inode->root), btrfs_ino(inode),
+			     filepos);
+		return -EUCLEAN;
 	}
 
-	extent_offset = filepos - em->start;
-	em_end = btrfs_extent_map_end(em);
-	ASSERT(filepos <= em_end);
-	ASSERT(IS_ALIGNED(em->start, sectorsize));
-	ASSERT(IS_ALIGNED(em->len, sectorsize));
+	extent_offset = filepos - oe->file_offset;
+	ASSERT(filepos < oe->file_offset + oe->num_bytes);
+	ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
+	ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
+	ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
+	ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
 
-	block_start = btrfs_extent_map_block_start(em);
-	disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
+	block_start = oe->disk_bytenr + oe->offset;
+	disk_bytenr = block_start + extent_offset;
 
-	ASSERT(!btrfs_extent_map_is_compressed(em));
-	ASSERT(block_start != EXTENT_MAP_HOLE);
-	ASSERT(block_start != EXTENT_MAP_INLINE);
+	btrfs_put_ordered_extent(oe);
 
-	btrfs_free_extent_map(em);
-	em = NULL;
-
-	/*
-	 * Although the PageDirty bit is cleared before entering this
-	 * function, subpage dirty bit is not cleared.
-	 * So clear subpage dirty bit here so next time we won't submit
-	 * a folio for a range already written to disk.
-	 */
 	btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
 	btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
 	/*
@@ -1898,6 +1910,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
 					       false);
+		btrfs_err_rl(fs_info,
+		"failed to queue sector for root %lld ino %llu filepos %llu",
+			     btrfs_root_id(inode->root),
+			     btrfs_ino(inode), filepos);
 		return -EUCLEAN;
 	}
 	return 0;
-- 
2.55.0

