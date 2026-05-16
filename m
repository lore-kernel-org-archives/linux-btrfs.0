Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD360C8EB
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778903149; cv=none; b=ivSbqV1Qgja/rAJVWWrDqoux5gPAVdu4ZIhsO3uGSqiuYDgYLTrV4+X5qdNwgmxeCs9ZA1iVe0IN2znk7PkSCjk1EhtOQk6Zz8Ki5wkSigTIa5s0p02tYKjzemR6aqCYQx+TcdGjpKLXPqvMsJjbEUyVF5yAGlCmGnCH3IcjSwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778903149; c=relaxed/simple;
	bh=XEkmJNeGU08DqMc+pLmWyUI4vQ/d2YVWRxB5NEf72Bg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFypvK7RUwWbEGdCiAhRVydquzQlKopQf4OWmCsO/yPB8F/v2hzWDSy+yk3jyWm+jgml5RtJUa7eBhWeC0rWfzUDP3wxlOyqYgWtDKUKDo9x47UryrJua9+y9mQweqUeVPsymrWPFSLyTAIQLL57i6AMUe5/oL2bYeQX5HhwCZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M/5SmcSO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M/5SmcSO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M/5SmcSO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M/5SmcSO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E6D166D65
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHadJTZiMuGZIKzttGeLjaUMkImVHPwDWhqPGM471x8=;
	b=M/5SmcSOwDbS9EQqg76qE6TYZpCXZjyNcaZ7TlZz33M7vj54Af3g8aQu4ed3LTBs34beli
	jRpzLKJZoKQC3/Hy6eEPtpxsdbSSO8OMNBqU4HBeta3EXQS6Jhz5In3y3ngZHThq6lGUyx
	inJDpVQRH555uLhI6fF0L4EQXyWw6uM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="M/5SmcSO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHadJTZiMuGZIKzttGeLjaUMkImVHPwDWhqPGM471x8=;
	b=M/5SmcSOwDbS9EQqg76qE6TYZpCXZjyNcaZ7TlZz33M7vj54Af3g8aQu4ed3LTBs34beli
	jRpzLKJZoKQC3/Hy6eEPtpxsdbSSO8OMNBqU4HBeta3EXQS6Jhz5In3y3ngZHThq6lGUyx
	inJDpVQRH555uLhI6fF0L4EQXyWw6uM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC82C593A8
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OH1GJ2LoB2qdMQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/6] btrfs: add skeleton for delayed btrfs bio
Date: Sat, 16 May 2026 13:15:14 +0930
Message-ID: <d8b91a2081c898c548545c8b7c0aff6f463766c4.1778902677.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778902677.git.wqu@suse.com>
References: <cover.1778902677.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9E6D166D65
X-Spam-Level: 

The objective of such new delayed btrfs bio infrastructure is to allow
compressed write to go the regular extent_writepage_io() path, without
going through the async submission path.

This will make it easier to align our write path to iomap.

The core ideas of delayed btrfs bio are:

- A placeholder ordered extent created at delalloc time
  No space is reserved at that time, and is not implemented in this
  patch.

- A delayed extent map created at delalloc time
  It will have a special disk_bytenr (-4) to indicate the range is
  delayed.
  And a new EXTENT_FLAG_DELAYED flag.

- Delayed btrfs bios will be limited to BTRFS_MAX_COMPRESSED size
  As only compression will go through delayed btrfs bio.

- Delayed btrfs bios will have @is_delayed flag set
  And such bio will have 0 as bi_sector, but will never be submitted
  directly through btrfs_submit_bio().

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
 fs/btrfs/bio.h         |  3 +++
 fs/btrfs/btrfs_inode.h |  3 +++
 fs/btrfs/extent_io.c   | 29 ++++++++++++++++++++++++----
 fs/btrfs/extent_map.h  |  9 ++++++++-
 fs/btrfs/inode.c       | 43 +++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048ba..1d418226ded9 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -908,6 +908,7 @@ void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num)
 {
 	/* If bbio->inode is not populated, its file_offset must be 0. */
 	ASSERT(bbio->inode || bbio->file_offset == 0);
+	ASSERT(!bbio->is_delayed);
 
 	assert_bbio_alignment(bbio);
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 303ed6c7103d..49ebdc7ce6e6 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -99,6 +99,9 @@ struct btrfs_bio {
 	/* Whether the bio is written using zone append. */
 	bool can_use_append:1;
 
+	/* If the bio is delayed (aka, no backing OE). */
+	bool is_delayed:1;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d5d81f9546c3..49ac6164f122 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -636,5 +636,8 @@ u64 btrfs_get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
 struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
 				      const struct btrfs_file_extent *file_extent,
 				      int type);
+struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
+					   u64 start, u32 length);
+void btrfs_submit_delayed_write(struct btrfs_bio *bbio);
 
 #endif
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8cf1e4c5105f..7adf8e80ba36 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -181,12 +181,16 @@ static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
 
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
 
@@ -709,6 +713,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
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
@@ -734,7 +746,13 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 
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
@@ -761,7 +779,7 @@ static int alloc_new_bio(struct btrfs_inode *inode,
 		}
 		bio_ctrl->len_to_oe_boundary = min_t(u32, U32_MAX,
 				ordered->file_offset +
-				ordered->disk_num_bytes - file_offset);
+				ordered->num_bytes - file_offset);
 		bbio->ordered = ordered;
 
 		/*
@@ -1722,7 +1740,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	ASSERT(IS_ALIGNED(em->len, sectorsize));
 
 	block_start = btrfs_extent_map_block_start(em);
-	disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
+	if (block_start == EXTENT_MAP_DELAYED)
+		disk_bytenr = block_start;
+	else
+		disk_bytenr = block_start + extent_offset;
 
 	ASSERT(!btrfs_extent_map_is_compressed(em));
 	ASSERT(block_start != EXTENT_MAP_HOLE);
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6f685f3c9327..2342f2a9a333 100644
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
+	 * This real on-disk extent allocation is delayed until bio submission.
+	 * For now it's only a placeholder with EXTENT_MAP_DELAYED as
+	 * its disk_bytenr.
+	 */
+	ENUM_BIT(EXTENT_FLAG_DELAYED),
 };
 
 /*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 973a89301baa..4b85ba6ddf48 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7406,10 +7406,51 @@ struct extent_map *btrfs_create_io_em(struct btrfs_inode *inode, u64 start,
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
2.54.0

