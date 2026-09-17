Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205874B4864
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789688411; cv=none; b=ccPbGqrn0fB6/EvYsOrg1zI27Z+fIxBaw1jTJze4SB7ZjeK2Gl8caZ5GpmpNm1jTAXB5Oyvo95Rw2ht/vj9gW34KkFLMmFKxZpHs4vHI1SIs/EU+BN7exsqPYJO1xDobCixkYD9fnQdYnvtDC/pVbo2cVqE3HEBLucwMzJnxQDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789688411; c=relaxed/simple;
	bh=hcJpq2HnjN7M4m99m6Vq/jT++1qHVasdLWUhRWgTsgA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIn7Vis5ySjjfw3byVs7NH3kXk40HBc7F57xEhybvo64pIjsWUwD4R1E7zNVynY1iYvSKLAioZknLFibiaTZeoHpk10QA0MteBqwcCcygYJS8Ryig2Qesg3ggYZ7w5vp3xL2144rqdjRIyJOg9WHX/quUI9tjZBSELxWBm8aiV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LLUdk5sV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m/wNpzoO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LLUdk5sV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m/wNpzoO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E3DA121DFE
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 23:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789687863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGsn5X2mF2aTXI7VNhN2DqyUTXsUNhwA6cYVfZWavzM=;
	b=LLUdk5sVc02rHRG5qBE26x3aQjIOCJTj2/QWx3yBrbQcDYuWUgyilkvcqxRIJB9UZGk1Ic
	eyWOqBfV2p2JMGy0+7s4iLDWHBBYYLHRLuC7rDw54w1dGrNvIYj5S4/w94Wz8vgVexRjt7
	lrw+B9AQb1raxXRJbvbrQWGX3Ph9HPw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="m/wNpzoO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789687858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGsn5X2mF2aTXI7VNhN2DqyUTXsUNhwA6cYVfZWavzM=;
	b=m/wNpzoOArqkhRpoQq4E/2HUrO9MrJU7tSke474dC/q17rCLhSScagBFedVVaY5Npv3nbP
	Wy6AE2+UhpF+ctcf9ygqkSmwyySRkFTWW/u/99CQihKOFKt8vabj3rSkD2XdCfVQzPaxuC
	hvva7TLXtKmidrd6ZQxAm7F4vM3q3PA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AF43139A8
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 23:30:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QKUmJC14rGroRAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 23:30:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/6] btrfs: add skeleton for delayed btrfs bio
Date: Fri, 18 Sep 2026 09:00:27 +0930
Message-ID: <96051c4e46d67e8b0a1e006b115e7e882931d094.1789687750.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789687750.git.wqu@suse.com>
References: <cover.1789687750.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: E3DA121DFE
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid];
	RCPT_COUNT_ONE(0.00)[1];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

The objective of such new delayed btrfs bio infrastructure is to allow
compressed write to go through the regular extent_writepage_io() path,
instead of the async submission path.

This will make it easier to align our write path to iomap.

The core ideas of delayed btrfs bio are:

- A placeholder ordered extent created at delalloc time
  No space is reserved at that time.

- A delayed extent map created at delalloc time
  It will have a special disk_bytenr (-4) to indicate the range is
  delayed.
  And a new EXTENT_FLAG_DELAYED flag.

- Delayed btrfs bios will be limited to BTRFS_MAX_COMPRESSED size
  As only compression will go through delayed btrfs bio.

- Delayed btrfs bios will have @is_delayed flag set
  And such bio will have 0 as bi_sector, but will never be submitted
  directly through btrfs_submit_bbio().

  Currently the submission of a delayed btrfs bio is not here yet, and
  will be implemented by later patches.

- Btrfs bio assembly mostly follows the regular path
  There are several small exceptions:
  * btrfs_bio_is_contig() needs to handle delayed disk_bytenr/bbio
  * New bbio needs to have its is_delayed flag set if disk_bytenr
    is EXTENT_MAP_DELAYED

- Real ordered extents will be created at bbio submission time
  This part is not implemented in this patch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c         |  1 +
 fs/btrfs/bio.h         |  7 +++++++
 fs/btrfs/btrfs_inode.h |  3 +++
 fs/btrfs/extent_io.c   | 31 ++++++++++++++++++++++++------
 fs/btrfs/extent_map.h  |  9 ++++++++-
 fs/btrfs/inode.c       | 43 +++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f..b17b6f13e067 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -872,6 +872,7 @@ void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num)
 {
 	/* If bbio->inode is not populated, its file_offset must be 0. */
 	ASSERT(bbio->inode || bbio->file_offset == 0);
+	ASSERT(!bbio->is_delayed);
 
 	assert_bbio_alignment(bbio);
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index bbf362b8668b..54c2ca46b6e3 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -95,6 +95,13 @@ struct btrfs_bio {
 	/* Whether the bio is written using zone append. */
 	bool can_use_append:1;
 
+	/*
+	 * If the bio is delayed.
+	 *
+	 * A delayed bbio will not be directly submitted.
+	 */
+	bool is_delayed:1;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 46c62f980c24..d344e248e640 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -637,5 +637,8 @@ u64 btrfs_get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
 struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
 				      const struct btrfs_file_extent *file_extent,
 				      int type);
+struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
+					   u64 start, u32 length);
+void btrfs_submit_delayed_write(struct btrfs_bio *bbio);
 
 #endif
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eb62568ddece..0c9df1d67978 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -183,12 +183,16 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 
 	/* Caller should ensure the bio has at least some range added */
 	ASSERT(bbio->bio.bi_iter.bi_size);
-
+	/* Delayed bbio is only for write. */
+	if (bbio->is_delayed)
+		ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
 	bio_set_csum_search_commit_root(bio_ctrl);
 
 	if (btrfs_op(&bbio->bio) == BTRFS_MAP_READ &&
 	    bio_ctrl->compress_type != BTRFS_COMPRESS_NONE)
 		btrfs_submit_compressed_read(bbio);
+	else if (bbio->is_delayed)
+		btrfs_submit_delayed_write(bbio);
 	else
 		btrfs_submit_bbio(bbio, 0);
 
@@ -729,6 +733,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 	struct bio *bio = &bio_ctrl->bbio->bio;
 	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
 
+	/* One is delayed bbio and one is not, definitely not contig. */
+	if (bio_ctrl->bbio->is_delayed != (disk_bytenr == EXTENT_MAP_DELAYED))
+		return false;
+
+	/* For delayed bbio, only need to check if the file range is contig. */
+	if (bio_ctrl->bbio->is_delayed)
+		return bio_ctrl->next_file_offset == file_offset;
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -754,7 +766,13 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 
 	bbio = btrfs_bio_alloc(BIO_MAX_VECS, bio_ctrl->opf, inode,
 			       file_offset, bio_ctrl->end_io_func, NULL);
-	bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
+	if (disk_bytenr == EXTENT_MAP_DELAYED) {
+		bbio->is_delayed = true;
+		bbio->bio.bi_iter.bi_sector = 0;
+	} else {
+		bbio->is_delayed = false;
+		bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
+	}
 	bbio->bio.bi_write_hint = inode->vfs_inode.i_write_hint;
 	bio_ctrl->bbio = bbio;
 	bio_ctrl->len_to_oe_boundary = U32_MAX;
@@ -781,7 +799,7 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 		}
 		bio_ctrl->len_to_oe_boundary = min_t(u32, U32_MAX,
 				ordered->file_offset +
-				ordered->disk_num_bytes - file_offset);
+				ordered->num_bytes - file_offset);
 		bbio->ordered = ordered;
 
 		/*
@@ -1815,7 +1833,6 @@ static int submit_write_sector(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_ordered_extent *oe;
-	u64 block_start;
 	u64 disk_bytenr;
 	u64 extent_offset;
 	const u32 sectorsize = fs_info->sectorsize;
@@ -1867,8 +1884,10 @@ static int submit_write_sector(struct btrfs_inode *inode,
 	ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
 	ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
 
-	block_start = oe->disk_bytenr + oe->offset;
-	disk_bytenr = block_start + extent_offset;
+	if (test_bit(BTRFS_ORDERED_DELAYED, &oe->flags))
+		disk_bytenr = EXTENT_MAP_DELAYED;
+	else
+		disk_bytenr = oe->disk_bytenr + oe->offset + extent_offset;
 
 	btrfs_put_ordered_extent(oe);
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6f685f3c9327..aac77762948a 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -13,7 +13,8 @@
 struct btrfs_inode;
 struct btrfs_fs_info;
 
-#define EXTENT_MAP_LAST_BYTE ((u64)-4)
+#define EXTENT_MAP_LAST_BYTE ((u64)-5)
+#define EXTENT_MAP_DELAYED ((u64)-4)
 #define EXTENT_MAP_HOLE ((u64)-3)
 #define EXTENT_MAP_INLINE ((u64)-2)
 
@@ -30,6 +31,12 @@ enum {
 	ENUM_BIT(EXTENT_FLAG_LOGGING),
 	/* This em is merged from two or more physically adjacent ems */
 	ENUM_BIT(EXTENT_FLAG_MERGED),
+	/*
+	 * The real on-disk extent allocation is delayed until bio submission.
+	 * For now it's only a placeholder with EXTENT_MAP_DELAYED as
+	 * its disk_bytenr.
+	 */
+	ENUM_BIT(EXTENT_FLAG_DELAYED),
 };
 
 /*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2421fe49b43b..69e12cb2d7b5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7658,10 +7658,51 @@ struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
 		return ERR_PTR(ret);
 	}
 
-	/* em got 2 refs now, callers needs to do btrfs_free_extent_map once. */
+	/* em got 2 refs now, callers need to do btrfs_free_extent_map once. */
 	return em;
 }
 
+struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
+					   u64 start, u32 length)
+{
+	struct extent_map *em;
+	int ret;
+
+	em = btrfs_alloc_extent_map();
+	if (!em)
+		return ERR_PTR(-ENOMEM);
+
+	em->start = start;
+	em->len = length;
+	em->disk_bytenr = EXTENT_MAP_DELAYED;
+	em->disk_num_bytes = 0;
+	em->ram_bytes = 0;
+	em->generation = -1;
+	em->offset = 0;
+	em->flags = EXTENT_FLAG_DELAYED | EXTENT_FLAG_PINNED;
+
+	ret = btrfs_replace_extent_map_range(inode, em, true);
+	if (ret) {
+		btrfs_free_extent_map(em);
+		return ERR_PTR(ret);
+	}
+
+	/* em got 2 refs now, callers need to do btrfs_free_extent_map once. */
+	return em;
+}
+
+void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
+{
+	ASSERT(bbio->is_delayed);
+
+	/*
+	 * Not yet implemented, and should not hit this path as we have no
+	 * caller to create delayed extent map.
+	 */
+	ASSERT(0);
+	bio_put(&bbio->bio);
+}
+
 /*
  * For release_folio() and invalidate_folio() we have a race window where
  * folio_end_writeback() is called but the subpage spinlock is not yet released.
-- 
2.55.0

