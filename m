Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3D3BB112
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 06:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996811; cv=none; b=cbSZysmKGfoMxgUscDMYVE6l41F8YqOJ3yq/yQjgU/aOmGtzhAfBLwY1zfYPu3Kb+BA+MPu5i6EKkQScmQ9gvEbb6P75efigxvpcR7arJfhWBXm5HnxWj/fqp4hQsZr7/aHm3+WDIqL8fBH7G2+/AQhqR4jKYzeiIR3Jqe7jhOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996811; c=relaxed/simple;
	bh=OH68G2jEHV0BKQ2a3MW4yt8AgYCAbIvyze0u/5skXLY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tTpU3yz1ONUlQ6u70Dgi3g4pUa4ozjEincDsqgYz1rDuZirrZVMGhHq1d3ZlD6znCU3cU0LovLbBcAO9ycMsI22X+3whrzJ1a67x4GJdY4Eh0UCDNaNrfwfNG7yDUWsE1ACo7ny486KOt/isAhWwScpQqAzIGk0mDwwJIR14hew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Vcwsl1ty; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Se0UzrWQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Vcwsl1ty";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Se0UzrWQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C0E57FEC1
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 06:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785996795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KBWCpbvxMFgufKwSXUVk4D0Uel8ChGk29AFUPQ0g90I=;
	b=Vcwsl1ty1xBhdBdorWRGRRZnIjHPovPsOhgbd6VObgGrp7jiF+3kS8pADbSZ5cFc/W9EJg
	cwGgc9i+tLX4kLzS6ZCPXtwccJKKscqJK0cgLwreDwwvnLXoACIW/vuuN0EDW4EPWVqOSz
	pNczJVIMqWkV2T17OGfkzsTXoCXLgss=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785996791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KBWCpbvxMFgufKwSXUVk4D0Uel8ChGk29AFUPQ0g90I=;
	b=Se0UzrWQGFaYWQ/pV13Xr3rADOflZ55jUeQnssTEAmbwRWMXZZ8cfz+qgB/5QaIl/yxM4n
	NtkY1NaJtHmp1oZor9o/bf9WC0m/tA6z/Kb/TOxs04my9kTC9YB8XJ/TFgRBT9j3E1Mgyk
	aDou2IsSzAqKOuvDSsszE9WyBRslIWM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9116779B6
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 06:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bvBxJvYldGqLZgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 06:13:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: use ordered extent to grab the logical address for submission
Date: Thu,  6 Aug 2026 15:42:45 +0930
Message-ID: <6576913842ae66ca1aa4f24cb60c544abe3ca43e.1785996696.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

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

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Extract a helper to determine if the @filepos is in the bbio OE range
  Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
  in_range() to make is easier to read.
---
 fs/btrfs/extent_io.c | 63 +++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d7600e5fa3d9..50cee1b13b6d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1808,6 +1808,18 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	return 0;
 }
 
+static bool block_in_bbio_oe_range(const struct btrfs_bio_ctrl *bio_ctrl,
+				   u64 filepos)
+{
+	struct btrfs_ordered_extent *oe;
+
+	if (!bio_ctrl->bbio || !bio_ctrl->bbio->ordered)
+		return false;
+
+	oe = bio_ctrl->bbio->ordered;
+	return in_range(filepos, oe->file_offset, oe->num_bytes);
+}
+
 /*
  * Return 0 if we have submitted or queued the sector for submission.
  * Return <0 for critical errors, and the involved sector will be cleaned up.
@@ -1820,11 +1832,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
 
@@ -1833,8 +1844,14 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	/* @filepos >= i_size case should be handled by the caller. */
 	ASSERT(filepos < i_size);
 
-	em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
-	if (IS_ERR(em)) {
+	/* Try to reuse the existing OE from bbio first. */
+	if (block_in_bbio_oe_range(bio_ctrl, filepos)) {
+		oe = bio_ctrl->bbio->ordered;
+		refcount_inc(&oe->refs);
+	} else {
+		oe = btrfs_lookup_ordered_extent(inode, filepos);
+	}
+	if (unlikely(!oe)) {
 		/*
 		 * bio_ctrl may contain a bio crossing several folios.
 		 * Submit it immediately so that the bio has a chance
@@ -1857,31 +1874,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
@@ -1898,6 +1909,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
2.54.0

