Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F18D3F9A16
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418191; cv=none; b=eR2CVcxycGZs1c1FBR+wPTqFwhp48E0cCl26jka5uh9dAnC5ddlToyWhSd7OsI+pQk03rQCWPj5t9xGtVHv35c019GOOKUQqkW13Kayf5/L5qqWYgm7/4Hr29fHzb1+2nymQM7RYSp4F/U4lx6xVFCxTlR+7rErL8hNYZ7W3BG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418191; c=relaxed/simple;
	bh=AcquYzK78YSrL/6Htkyamzqmi2eNqGR31CVgB0c8TFg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us0N0ZPSfLQYXt9uFJcJj6CF1Dh2hbmxH9YsY1ur5oQDU8BeykmZ+VXh0S6Etsjn0Qt+4yrjC0r9RQFtsUacal5uGxLzuWmX/c6FxvRsNBoL5VowpF/cdKnBdBQhw1dZqK8s+oudmzG+ckKW903xz6NW6t//LnhjYLpL21cxQxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PVorhpF8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ODfDifXK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PVorhpF8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ODfDifXK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 218FE21D51
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=caoMxS2IdH6Pj2vpNyiRI4j4Up453JYoJHo56IgkhZE=;
	b=PVorhpF8HZNdfXDkjLWfG8DzAji9wuP4v21ebcxtP6Cpjj8aI7RnTuONIAyC8HQ3pVgh/L
	T+YcO6aZQqmtOmCKFs63ybkmJuZcSWW/WnMvOyv8O4/PpzWikbhv20kj4CW6kEjspKPuq5
	QXoZFrk33yUp+v/UMR2Uz/zq7iwRRbA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=caoMxS2IdH6Pj2vpNyiRI4j4Up453JYoJHo56IgkhZE=;
	b=ODfDifXKg70Nq1WFqiOBla6QlEbsBTnjnx3iC8n0+5H56UvgZK66CsZt+B/3GmldE1VaMX
	5DklugSWvQs9UJu26mozTFG/Z0JWXp2S/YcUBsKte/4fhXRX9roLGM5uDHhutxSXBFdj3N
	siZsodQltd08vXbEBLkONps5j501t30=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F33413736
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4MvmOnwYmWosRAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 06:49:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: split sectorsize into datasize and sectorsize
Date: Thu,  3 Sep 2026 16:19:03 +0930
Message-ID: <9eb239fc2296eca51494c60a3cceb71423cbeb10.1788417288.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788417288.git.wqu@suse.com>
References: <cover.1788417288.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Currently btrfs uses sectorsize as its minimal data/metadata IO size,
it's also the unit where data checksum is calculated.

However for the incoming data_size feature, we want to

The incoming new DATA_IO_SIZE feature will separate minimal data IO size
from sector size.
This new change is mostly for the preparation of other incoming
features.

It means all things like buffered/direct IO will all be done using
btrfs_fs_info::data_size, but when data checksum is involved, everything
will still respect btrfs_fs_info::sectorsize.

The minimal data IO size is guaranteed by the fs_info::datasize and
datasize_bits, which forces btrfs to alloc folios no smaller than
datasize for page cache, and all existing data write paths will respect
datasize.

This introduces one special problem for subpage handling, now a data
folio can contain less blocks than a metadata folio.

However this is not hard to address, btrfs_blocks_per_folio() can be
updated to switch between different bits shift for data and metadata
folios.
The way to determine if a folio belongs to a data is that, a data folio
is always mapped, and the mapping owner inode is not btree inode.
Otherwise the folio belongs to metadata.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/bio.c                         |  16 +++-
 fs/btrfs/block-group.c                 |   2 +-
 fs/btrfs/btrfs_inode.h                 |  10 +++
 fs/btrfs/compression.c                 |  12 +--
 fs/btrfs/defrag.c                      |  14 +--
 fs/btrfs/delalloc-space.c              |  22 ++---
 fs/btrfs/direct-io.c                   |   6 +-
 fs/btrfs/disk-io.c                     |  20 +++--
 fs/btrfs/extent-io-tree.c              |   2 +-
 fs/btrfs/extent-tree.c                 |   4 +-
 fs/btrfs/extent_io.c                   |  62 +++++++-------
 fs/btrfs/extent_map.c                  |   2 +-
 fs/btrfs/fiemap.c                      |   2 +-
 fs/btrfs/file-item.c                   |  22 +++--
 fs/btrfs/file.c                        |  72 ++++++++--------
 fs/btrfs/fs.h                          |  24 ++++--
 fs/btrfs/inode-item.c                  |   6 +-
 fs/btrfs/inode.c                       | 113 +++++++++++++------------
 fs/btrfs/ioctl.c                       |  12 +--
 fs/btrfs/lzo.c                         |  14 +--
 fs/btrfs/reflink.c                     |  16 ++--
 fs/btrfs/relocation.c                  |  16 ++--
 fs/btrfs/send.c                        |   4 +-
 fs/btrfs/subpage.c                     |  96 +++++++++++++++------
 fs/btrfs/subpage.h                     |   2 +-
 fs/btrfs/super.c                       |   8 +-
 fs/btrfs/sysfs.c                       |   6 +-
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/free-space-tree-tests.c |   2 +-
 fs/btrfs/tree-checker.c                |   2 +-
 fs/btrfs/tree-log.c                    |   6 +-
 fs/btrfs/volumes.c                     |   2 +-
 fs/btrfs/zlib.c                        |   6 +-
 fs/btrfs/zoned.c                       |   4 +-
 fs/btrfs/zstd.c                        |   8 +-
 35 files changed, 355 insertions(+), 266 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 6efde8c5445d..3a438a2b8247 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -858,11 +858,23 @@ static void assert_bbio_alignment(struct btrfs_bio *bbio)
 	struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	const u32 blocksize = fs_info->sectorsize;
-	const u32 alignment = min(blocksize, PAGE_SIZE);
+	u32 blocksize;
+	u32 alignment;
 	const u64 logical = bbio->bio.bi_iter.bi_sector << SECTOR_SHIFT;
 	const u32 length = bbio->bio.bi_iter.bi_size;
 
+	if (btrfs_ino(bbio->inode) == BTRFS_BTREE_INODE_OBJECTID ||
+	    bbio->bio.bi_pool == &btrfs_repair_bioset) {
+		/*
+		 * For metadata or repair bios, the alignment requreiment is
+		 * sectorsize.
+		 */
+		blocksize = fs_info->sectorsize;
+	} else {
+		blocksize = fs_info->datasize;
+	}
+	alignment = min(blocksize, PAGE_SIZE);
+
 	/* The logical and length should still be aligned to blocksize. */
 	ASSERT(IS_ALIGNED(logical, blocksize) && IS_ALIGNED(length, blocksize) &&
 	       length != 0, "root=%llu inode=%llu logical=%llu length=%u",
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 830460a40e86..7e84cf168710 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -528,7 +528,7 @@ static void fragment_free_space(struct btrfs_block_group *block_group)
 	u64 start = block_group->start;
 	u64 len = block_group->length;
 	u64 chunk = block_group->flags & BTRFS_BLOCK_GROUP_METADATA ?
-		fs_info->nodesize : fs_info->sectorsize;
+		fs_info->nodesize : fs_info->datasize;
 	u64 step = chunk << 1;
 
 	while (len > chunk) {
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 89e5e9c0c904..102088efe9df 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -397,6 +397,16 @@ static inline bool is_data_inode(const struct btrfs_inode *inode)
 	return btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID;
 }
 
+static inline unsigned int btrfs_blocks_per_folio(const struct btrfs_fs_info *fs_info,
+						  const struct folio *folio)
+{
+	struct address_space *mapping = folio_mapping(folio);
+
+	if (mapping && mapping->host && is_data_inode(BTRFS_I(mapping->host)))
+		return folio_size(folio) >> fs_info->datasize_bits;
+	return folio_size(folio) >> fs_info->sectorsize_bits;
+}
+
 static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 						 int mod)
 {
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..b6ec7af8e335 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -318,8 +318,8 @@ void btrfs_submit_compressed_write(struct btrfs_ordered_extent *ordered,
 	struct btrfs_inode *inode = ordered->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	ASSERT(IS_ALIGNED(ordered->file_offset, fs_info->sectorsize));
-	ASSERT(IS_ALIGNED(ordered->num_bytes, fs_info->sectorsize));
+	ASSERT(IS_ALIGNED(ordered->file_offset, fs_info->datasize));
+	ASSERT(IS_ALIGNED(ordered->num_bytes, fs_info->datasize));
 	/*
 	 * This flag determines if we should clear the writeback flag from the
 	 * page cache. But this function is only utilized by encoded writes, it
@@ -416,7 +416,7 @@ static noinline int add_ra_bio_folios(struct inode *inode, u64 compressed_end,
 
 			folio_put(folio);
 			sectors_missed += (folio_sz - offset) >>
-					  fs_info->sectorsize_bits;
+					  fs_info->datasize_bits;
 
 			/* Beyond threshold, no need to continue */
 			if (sectors_missed > 4)
@@ -472,7 +472,7 @@ static noinline int add_ra_bio_folios(struct inode *inode, u64 compressed_end,
 		 * to this compressed extent on disk.
 		 */
 		if (!em || cur < em->start ||
-		    (cur + fs_info->sectorsize > btrfs_extent_map_end(em)) ||
+		    (cur + fs_info->datasize > btrfs_extent_map_end(em)) ||
 		    (btrfs_extent_map_block_start(em) >> SECTOR_SHIFT) !=
 		    orig_bio->bi_iter.bi_sector) {
 			btrfs_free_extent_map(em);
@@ -549,7 +549,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
-	em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
+	em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->datasize);
 	read_unlock(&em_tree->lock);
 	if (!em) {
 		ret = -EIO;
@@ -1078,7 +1078,7 @@ int btrfs_decompress(int type, const u8 *data_in, struct folio *dest_folio,
 {
 	struct btrfs_fs_info *fs_info = folio_to_fs_info(dest_folio);
 	struct list_head *workspace;
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	int ret;
 
 	/*
diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 6ec5dd760d42..ea8fff470387 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -263,7 +263,7 @@ static int btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 	if (ret < 0)
 		goto cleanup;
 
-	cur = max(cur + fs_info->sectorsize, range.start);
+	cur = max(cur + fs_info->datasize, range.start);
 	goto again;
 
 cleanup:
@@ -737,7 +737,7 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map *em;
-	const u32 sectorsize = BTRFS_I(inode)->root->fs_info->sectorsize;
+	const u32 sectorsize = BTRFS_I(inode)->root->fs_info->datasize;
 
 	/*
 	 * Hopefully we have this extent in the tree already, try without the
@@ -1170,7 +1170,7 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	struct defrag_target_range *tmp;
 	LIST_HEAD(target_list);
 	struct folio AUTO_KFREE(*folios);
-	const u32 sectorsize = inode->root->fs_info->sectorsize;
+	const u32 sectorsize = inode->root->fs_info->datasize;
 	u64 cur = start;
 	const unsigned int nr_pages = ((start + len - 1) >> PAGE_SHIFT) -
 				      (start >> PAGE_SHIFT) + 1;
@@ -1266,7 +1266,7 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 			      unsigned long max_sectors,
 			      u64 *last_scanned_ret)
 {
-	const u32 sectorsize = inode->root->fs_info->sectorsize;
+	const u32 sectorsize = inode->root->fs_info->datasize;
 	struct defrag_target_range *entry;
 	struct defrag_target_range *tmp;
 	LIST_HEAD(target_list);
@@ -1316,7 +1316,7 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 		if (ret < 0)
 			break;
 		*sectors_defragged += range_len >>
-				      inode->root->fs_info->sectorsize_bits;
+				      inode->root->fs_info->datasize_bits;
 	}
 out:
 	list_for_each_entry_safe(entry, tmp, &target_list, list)
@@ -1400,8 +1400,8 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
 	}
 
 	/* Align the range */
-	cur = round_down(range->start, fs_info->sectorsize);
-	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
+	cur = round_down(range->start, fs_info->datasize);
+	last_byte = round_up(last_byte, fs_info->datasize) - 1;
 
 	/*
 	 * Make writeback start from the beginning of the range, so that the
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index d357ed7efd99..53735a75c09c 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -130,7 +130,7 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_DATA;
 
 	/* Make sure bytes are sectorsize aligned */
-	bytes = ALIGN(bytes, fs_info->sectorsize);
+	bytes = ALIGN(bytes, fs_info->datasize);
 
 	if (btrfs_is_free_space_inode(inode))
 		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
@@ -149,9 +149,9 @@ int btrfs_check_data_free_space(struct btrfs_inode *inode,
 	int ret;
 
 	/* align the range */
-	len = round_up(start + len, fs_info->sectorsize) -
-	      round_down(start, fs_info->sectorsize);
-	start = round_down(start, fs_info->sectorsize);
+	len = round_up(start + len, fs_info->datasize) -
+	      round_down(start, fs_info->datasize);
+	start = round_down(start, fs_info->datasize);
 
 	if (noflush)
 		flush = BTRFS_RESERVE_NO_FLUSH;
@@ -186,7 +186,7 @@ void btrfs_free_reserved_data_space_noquota(struct btrfs_inode *inode, u64 len)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	ASSERT(IS_ALIGNED(len, fs_info->sectorsize));
+	ASSERT(IS_ALIGNED(len, fs_info->datasize));
 
 	btrfs_space_info_free_bytes_may_use(data_sinfo_for_inode(inode), len);
 }
@@ -204,9 +204,9 @@ void btrfs_free_reserved_data_space(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
 	/* Make sure the range is aligned to sectorsize */
-	len = round_up(start + len, fs_info->sectorsize) -
-	      round_down(start, fs_info->sectorsize);
-	start = round_down(start, fs_info->sectorsize);
+	len = round_up(start + len, fs_info->datasize) -
+	      round_down(start, fs_info->datasize);
+	start = round_down(start, fs_info->datasize);
 
 	btrfs_free_reserved_data_space_noquota(inode, len);
 	btrfs_qgroup_free_data(inode, reserved, start, len, NULL);
@@ -341,8 +341,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 			flush = BTRFS_RESERVE_FLUSH_LIMIT;
 	}
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
-	disk_num_bytes = ALIGN(disk_num_bytes, fs_info->sectorsize);
+	num_bytes = ALIGN(num_bytes, fs_info->datasize);
+	disk_num_bytes = ALIGN(disk_num_bytes, fs_info->datasize);
 
 	/*
 	 * We always want to do it this way, every other way is wrong and ends
@@ -409,7 +409,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
+	num_bytes = ALIGN(num_bytes, fs_info->datasize);
 	spin_lock(&inode->lock);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
 		inode->csum_bytes -= num_bytes;
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 3075d7992713..18937303dc3a 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -185,7 +185,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 
 	alloc_hint = btrfs_get_extent_allocation_hint(inode, start, len);
 again:
-	ret = btrfs_reserve_extent(root, len, len, fs_info->sectorsize,
+	ret = btrfs_reserve_extent(root, len, len, fs_info->datasize,
 				   0, alloc_hint, &ins, true, true);
 	if (ret == -EAGAIN) {
 		ASSERT(btrfs_is_zoned(fs_info));
@@ -401,7 +401,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	 * to allocate a contiguous array for the checksums.
 	 */
 	if (!write)
-		len = min_t(u64, len, fs_info->sectorsize * BIO_MAX_VECS);
+		len = min_t(u64, len, fs_info->datasize * BIO_MAX_VECS);
 
 	lockstart = start;
 	lockend = start + len - 1;
@@ -865,7 +865,7 @@ static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *it
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
 			       const struct iov_iter *iter, loff_t offset)
 {
-	const u32 blocksize_mask = fs_info->sectorsize - 1;
+	const u32 blocksize_mask = fs_info->datasize - 1;
 
 	if (offset & blocksize_mask)
 		return -EINVAL;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dd00e8ced883..42e05e26c442 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2918,7 +2918,9 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
+	fs_info->datasize = 4096;
 	fs_info->sectorsize = 4096;
+	fs_info->datasize_bits = ilog2(4096);
 	fs_info->sectorsize_bits = ilog2(4096);
 
 	/* Default compress algorithm when user does -o compress */
@@ -3231,10 +3233,10 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 
 	/* Runtime limitation for mixed block groups. */
 	if ((incompat & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
-	    (fs_info->sectorsize != fs_info->nodesize)) {
+	    (fs_info->datasize != fs_info->nodesize)) {
 		btrfs_err(fs_info,
 "unequal nodesize/sectorsize (%u != %u) are not allowed for mixed block groups",
-			fs_info->nodesize, fs_info->sectorsize);
+			fs_info->nodesize, fs_info->datasize);
 		return -EINVAL;
 	}
 
@@ -3293,10 +3295,10 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	 * we're already defaulting to v2 cache, no need to bother v1 as it's
 	 * going to be deprecated anyway.
 	 */
-	if (fs_info->sectorsize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+	if (fs_info->datasize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
 		btrfs_warn(fs_info,
 	"v1 space cache is not supported for page size %lu with sectorsize %u",
-			   PAGE_SIZE, fs_info->sectorsize);
+			   PAGE_SIZE, fs_info->datasize);
 		return -EINVAL;
 	}
 
@@ -3495,7 +3497,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	fs_info->nodesize = nodesize;
 	fs_info->nodesize_bits = ilog2(nodesize);
+	fs_info->datasize = sectorsize;
 	fs_info->sectorsize = sectorsize;
+	fs_info->datasize_bits = ilog2(sectorsize);
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
 	/*
@@ -3506,14 +3510,14 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (IS_ENABLED(CONFIG_HIGHMEM))
 		fs_info->block_max_order = fs_info->block_min_order;
 	else
-		fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
+		fs_info->block_max_order = calc_block_max_order(fs_info->datasize_bits);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
 	fs_info->fs_devices->fs_info = fs_info;
 
-	if (fs_info->sectorsize > PAGE_SIZE)
+	if (fs_info->datasize > PAGE_SIZE)
 		btrfs_warn(fs_info,
 			   "support for block size %u with page size %lu is experimental, some features may be missing",
-			   fs_info->sectorsize, PAGE_SIZE);
+			   fs_info->datasize, PAGE_SIZE);
 	/*
 	 * Handle the space caching options appropriately now that we have the
 	 * super block loaded and validated.
@@ -3543,7 +3547,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * At this point our mount options are validated, if we set ->max_inline
 	 * to something non-standard make sure we truncate it to sectorsize.
 	 */
-	fs_info->max_inline = min_t(u64, fs_info->max_inline, fs_info->sectorsize);
+	fs_info->max_inline = min_t(u64, fs_info->max_inline, fs_info->datasize);
 
 	ret = btrfs_alloc_compress_wsm(fs_info);
 	if (ret)
diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d6df11f6088c..da0c72f0674f 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -342,7 +342,7 @@ static void validate_extent_state(const struct extent_io_tree *tree,
 	if (tree->owner != IO_TREE_INODE_IO)
 		return;
 
-	blocksize = btrfs_extent_io_tree_to_fs_info(tree)->sectorsize;
+	blocksize = btrfs_extent_io_tree_to_fs_info(tree)->datasize;
 	ASSERT(IS_ALIGNED(state->start, blocksize) &&
 	       IS_ALIGNED(state->end + 1, blocksize),
 	       "unaligned extent state, blocksize=%u start=%llu end=%llu state=0x%x",
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8977e9ad0d44..e63ae4d76b58 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4883,6 +4883,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	struct find_free_extent_ctl ffe_ctl = {};
 	bool final_tried = num_bytes == min_alloc_size;
 	u64 flags;
+	const u32 blocksize = is_data ? fs_info->datasize : fs_info->sectorsize;
 	int ret;
 	bool for_treelog = (btrfs_root_id(root) == BTRFS_TREE_LOG_OBJECTID);
 	bool for_data_reloc = (btrfs_is_data_reloc_root(root) && is_data);
@@ -4907,8 +4908,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	} else if (ret == -ENOSPC) {
 		if (!final_tried && ins->offset) {
 			num_bytes = min(num_bytes >> 1, ins->offset);
-			num_bytes = round_down(num_bytes,
-					       fs_info->sectorsize);
+			num_bytes = round_down(num_bytes, blocksize);
 			num_bytes = max(num_bytes, min_alloc_size);
 			ram_bytes = num_bytes;
 			if (num_bytes == min_alloc_size)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a221b63bdb20..8dc6d6ab952d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -419,7 +419,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 	 * If @max_bytes is smaller than a block, btrfs_find_delalloc_range() can
 	 * return early without handling any dirty ranges.
 	 */
-	ASSERT(max_bytes >= fs_info->sectorsize);
+	ASSERT(max_bytes >= fs_info->datasize);
 
 	found = btrfs_find_delalloc_range(tree, &delalloc_start, &delalloc_end,
 					  max_bytes, &cached_state);
@@ -458,7 +458,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 		btrfs_free_extent_state(cached_state);
 		cached_state = NULL;
 		if (!loops) {
-			max_bytes = fs_info->sectorsize;
+			max_bytes = fs_info->datasize;
 			loops = true;
 			goto again;
 		} else {
@@ -1063,7 +1063,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 	u64 last_byte = i_size_read(inode);
 	struct extent_map *em;
 	int ret = 0;
-	const size_t blocksize = fs_info->sectorsize;
+	const size_t blocksize = fs_info->datasize;
 
 	if (bio_ctrl->ractl)
 		locked_end = readahead_pos(bio_ctrl->ractl) + readahead_length(bio_ctrl->ractl) - 1;
@@ -1094,7 +1094,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		u64 em_gen;
 		unsigned int queued;
 
-		ASSERT(IS_ALIGNED(cur, fs_info->sectorsize));
+		ASSERT(IS_ALIGNED(cur, fs_info->datasize));
 		if (cur >= last_byte) {
 			folio_zero_range(folio, pg_offset, end - cur + 1);
 			end_folio_read(vi, folio, true, cur, end - cur + 1);
@@ -1234,7 +1234,7 @@ static bool can_skip_one_ordered_range(struct btrfs_inode *inode,
 {
 	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct folio *folio;
-	const u32 blocksize = fs_info->sectorsize;
+	const u32 blocksize = fs_info->datasize;
 	u64 cur = *fileoff;
 	bool ret;
 
@@ -1395,7 +1395,7 @@ static void lock_extents_for_read(struct btrfs_inode *inode, u64 start, u64 end,
 static void assert_folio_range(const struct btrfs_inode *inode,
 			       u64 start, u64 end)
 {
-	const u32 blocksize = inode->root->fs_info->sectorsize;
+	const u32 blocksize = inode->root->fs_info->datasize;
 
 	/*
 	 * For btrfs page cache, a folio always contains at least one block,
@@ -1449,8 +1449,8 @@ static void set_delalloc_bitmap(struct folio *folio, unsigned long *delalloc_bit
 	unsigned int nbits;
 
 	ASSERT(start >= folio_start && start + len <= folio_start + folio_size(folio));
-	start_bit = (start - folio_start) >> fs_info->sectorsize_bits;
-	nbits = len >> fs_info->sectorsize_bits;
+	start_bit = (start - folio_start) >> fs_info->datasize_bits;
+	nbits = len >> fs_info->datasize_bits;
 	ASSERT(bitmap_test_range_all_zero(delalloc_bitmap, start_bit, nbits));
 	bitmap_set(delalloc_bitmap, start_bit, nbits);
 }
@@ -1468,14 +1468,14 @@ static bool find_next_delalloc_bitmap(struct folio *folio,
 
 	ASSERT(start >= folio_start && start < folio_start + folio_size(folio));
 
-	start_bit = (start - folio_start) >> fs_info->sectorsize_bits;
+	start_bit = (start - folio_start) >> fs_info->datasize_bits;
 	first_set = find_next_bit(delalloc_bitmap, bitmap_size, start_bit);
 	if (first_set >= bitmap_size)
 		return false;
 
-	*found_start = folio_start + (first_set << fs_info->sectorsize_bits);
+	*found_start = folio_start + (first_set << fs_info->datasize_bits);
 	first_zero = find_next_zero_bit(delalloc_bitmap, bitmap_size, first_set);
-	*found_len = (first_zero - first_set) << fs_info->sectorsize_bits;
+	*found_len = (first_zero - first_set) << fs_info->datasize_bits;
 	return true;
 }
 
@@ -1536,7 +1536,7 @@ static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(&inode->vfs_inode);
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	const u64 page_start = folio_pos(folio);
 	bool found_fixup = false;
 	unsigned int bit;
@@ -1559,7 +1559,7 @@ static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode,
 		return 0;
 
 	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
-		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
+		const u64 start = page_start + (bit << fs_info->datasize_bits);
 		const bool needs_fixup = btrfs_folio_test_fixup(fs_info, folio,
 								start, sectorsize);
 
@@ -1646,8 +1646,8 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 
 	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
-		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
-		u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
+		u64 start = page_start + (start_bit << fs_info->datasize_bits);
+		u32 len = (end_bit - start_bit) << fs_info->datasize_bits;
 
 		btrfs_folio_set_lock(fs_info, folio, start, len);
 	}
@@ -1742,9 +1742,9 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		 */
 		if (ret > 0) {
 			unsigned int start_bit = (found_start - page_start) >>
-						 fs_info->sectorsize_bits;
+						 fs_info->datasize_bits;
 			unsigned int end_bit = (min(page_end + 1, found_start + found_len) -
-						page_start) >> fs_info->sectorsize_bits;
+						page_start) >> fs_info->datasize_bits;
 			bitmap_clear(bio_ctrl->submit_bitmap, start_bit, end_bit - start_bit);
 		}
 		/*
@@ -1763,13 +1763,13 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	if (unlikely(ret < 0)) {
 		unsigned int bitmap_size = min(
 				(last_finished_delalloc_end - page_start) >>
-				fs_info->sectorsize_bits,
+				fs_info->datasize_bits,
 				blocks_per_folio);
 
 		for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 				      bitmap_size) {
-			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
-			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
+			u64 start = page_start + (start_bit << fs_info->datasize_bits);
+			u32 len = (end_bit - start_bit) << fs_info->datasize_bits;
 
 			btrfs_mark_ordered_io_finished(inode, start, len, false);
 		}
@@ -1840,7 +1840,7 @@ static int submit_one_sector(struct btrfs_inode *inode,
 	u64 block_start;
 	u64 disk_bytenr;
 	u64 extent_offset;
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	unsigned int queued;
 
 	ASSERT(IS_ALIGNED(filepos, sectorsize));
@@ -1873,7 +1873,7 @@ static int submit_one_sector(struct btrfs_inode *inode,
 		 * Since there is no bio submitted to finish the ordered
 		 * extent, we have to manually finish this sector.
 		 */
-		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
+		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->datasize,
 					       false);
 		btrfs_err_rl(fs_info,
 		"no ordered extent for root %lld ino %llu filepos %llu",
@@ -1908,7 +1908,7 @@ static int submit_one_sector(struct btrfs_inode *inode,
 				     sectorsize, filepos - folio_pos(folio), 0);
 	if (unlikely(queued < sectorsize)) {
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
-		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
+		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->datasize,
 					       false);
 		btrfs_err_rl(fs_info,
 		"failed to queue sector for root %lld ino %llu filepos %llu",
@@ -1959,22 +1959,22 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	/* Truncate the submit bitmap to the current range. */
 	if (start > folio_start)
 		bitmap_clear(bio_ctrl->submit_bitmap, 0,
-			     (start - folio_start) >> fs_info->sectorsize_bits);
+			     (start - folio_start) >> fs_info->datasize_bits);
 	if (start + len < folio_end)
 		bitmap_clear(bio_ctrl->submit_bitmap,
-			     (end - folio_start) >> fs_info->sectorsize_bits,
-			     (folio_end - end) >> fs_info->sectorsize_bits);
+			     (end - folio_start) >> fs_info->datasize_bits,
+			     (folio_end - end) >> fs_info->datasize_bits);
 
 	bio_ctrl->end_io_func = end_bbio_data_write;
 
 	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
-		cur = folio_pos(folio) + (bit << fs_info->sectorsize_bits);
+		cur = folio_pos(folio) + (bit << fs_info->datasize_bits);
 
 		if (cur >= i_size) {
 			struct btrfs_ordered_extent *ordered;
 
 			ordered = btrfs_lookup_first_ordered_range(inode, cur,
-								   fs_info->sectorsize);
+								   fs_info->datasize);
 			/*
 			 * We have just run delalloc before getting here, so
 			 * there must be an ordered extent.
@@ -1987,7 +1987,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			spin_unlock(&inode->ordered_tree_lock);
 			btrfs_put_ordered_extent(ordered);
 
-			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, true);
+			btrfs_mark_ordered_io_finished(inode, cur, fs_info->datasize, true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
 			 * bother writing back.
@@ -1996,7 +1996,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			 * writeback the sectors with subpage dirty bits,
 			 * causing writeback without ordered extent.
 			 */
-			btrfs_folio_clear_dirty(fs_info, folio, cur, fs_info->sectorsize);
+			btrfs_folio_clear_dirty(fs_info, folio, cur, fs_info->datasize);
 			continue;
 		}
 		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);
@@ -2911,7 +2911,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 	int ret = 0;
 	struct address_space *mapping = inode->i_mapping;
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	loff_t i_size = i_size_read(inode);
 	u64 cur = start;
 	struct btrfs_bio_ctrl bio_ctrl = {
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 86d9c6f5ff4b..8eae7656bb88 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -319,7 +319,7 @@ static void dump_extent_map(struct btrfs_fs_info *fs_info, const char *prefix,
 /* Internal sanity checks for btrfs debug builds. */
 static void validate_extent_map(struct btrfs_fs_info *fs_info, struct extent_map *em)
 {
-	const u32 blocksize = fs_info->sectorsize;
+	const u32 blocksize = fs_info->datasize;
 
 	if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
 		return;
diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 7a2a97180099..988148bc35e6 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -641,7 +641,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	u64 prev_extent_end;
 	u64 range_start;
 	u64 range_end;
-	const u32 sectorsize = inode->root->fs_info->sectorsize;
+	const u32 sectorsize = inode->root->fs_info->datasize;
 	bool stopped = false;
 	int ret;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 72ebd7c9ef10..3ef1f3ed4ba1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -89,7 +89,7 @@ int btrfs_inode_set_file_extent_range(struct btrfs_inode *inode, u64 start,
 	if (len == 0)
 		return 0;
 
-	ASSERT(IS_ALIGNED(start + len, inode->root->fs_info->sectorsize));
+	ASSERT(IS_ALIGNED(start + len, inode->root->fs_info->datasize));
 
 	return btrfs_set_extent_bit(inode->file_extent_tree, start, start + len - 1,
 				    EXTENT_DIRTY, NULL);
@@ -118,7 +118,7 @@ int btrfs_inode_clear_file_extent_range(struct btrfs_inode *inode, u64 start,
 	if (len == 0)
 		return 0;
 
-	ASSERT(IS_ALIGNED(start + len, inode->root->fs_info->sectorsize) ||
+	ASSERT(IS_ALIGNED(start + len, inode->root->fs_info->datasize) ||
 	       len == (u64)-1);
 
 	return btrfs_clear_extent_bit(inode->file_extent_tree, start,
@@ -491,10 +491,16 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
 			count = 1;
 
 			if (btrfs_is_data_reloc_root(inode->root)) {
-				u64 file_offset = bbio->file_offset + bio_offset;
+				/*
+				 * For @datasize > @sectorsize case, we need to
+				 * keep the range to be @datasize aligned.
+				 * So expand the range to cover the full @datasize.
+				 */
+				u64 file_offset = round_down(bbio->file_offset + bio_offset,
+							     fs_info->datasize);
 
 				btrfs_set_extent_bit(&inode->io_tree, file_offset,
-						     file_offset + sectorsize - 1,
+						     file_offset + fs_info->datasize - 1,
 						     EXTENT_NODATASUM, NULL);
 			} else {
 				btrfs_warn_rl(fs_info,
@@ -680,8 +686,8 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
 	bool free_path = false;
 	int ret;
 
-	ASSERT(IS_ALIGNED(start, fs_info->sectorsize) &&
-	       IS_ALIGNED(end + 1, fs_info->sectorsize));
+	ASSERT(IS_ALIGNED(start, fs_info->datasize) &&
+	       IS_ALIGNED(end + 1, fs_info->datasize));
 
 	if (!path) {
 		path = btrfs_alloc_path();
@@ -1388,7 +1394,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 
 		em->disk_bytenr = EXTENT_MAP_INLINE;
 		em->start = 0;
-		em->len = fs_info->sectorsize;
+		em->len = fs_info->datasize;
 		em->offset = 0;
 		btrfs_extent_map_set_compression(em, compress_type);
 	} else {
@@ -1417,7 +1423,7 @@ u64 btrfs_file_extent_end(const struct btrfs_path *path)
 	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
-		end = leaf->fs_info->sectorsize;
+		end = leaf->fs_info->datasize;
 	else
 		end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20e15dc30bfb..6aa0b8d5a5f7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -45,8 +45,8 @@
 static void btrfs_drop_folio(struct btrfs_fs_info *fs_info, struct folio *folio,
 			     u64 pos, u64 copied)
 {
-	u64 block_start = round_down(pos, fs_info->sectorsize);
-	u64 block_len = round_up(pos + copied, fs_info->sectorsize) - block_start;
+	u64 block_start = round_down(pos, fs_info->datasize);
+	u64 block_len = round_up(pos + copied, fs_info->datasize) - block_start;
 
 	ASSERT(block_len <= U32_MAX);
 	folio_unlock(folio);
@@ -78,8 +78,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
 	if (noreserve)
 		extra_bits |= EXTENT_NORESERVE;
 
-	start_pos = round_down(pos, fs_info->sectorsize);
-	num_bytes = round_up(end_pos - start_pos, fs_info->sectorsize);
+	start_pos = round_down(pos, fs_info->datasize);
+	num_bytes = round_up(end_pos - start_pos, fs_info->datasize);
 	ASSERT(num_bytes <= U32_MAX);
 	ASSERT(folio_pos(folio) <= pos && folio_next_pos(folio) >= end_pos);
 
@@ -395,7 +395,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
 				args->bytes_found += extent_end - key.offset;
 				extent_end = ALIGN(extent_end,
-						   fs_info->sectorsize);
+						   fs_info->datasize);
 			} else if (update_refs && disk_bytenr > 0) {
 				struct btrfs_ref ref = {
 					.action = BTRFS_DROP_DELAYED_REF,
@@ -788,7 +788,7 @@ static int prepare_uptodate_folio(struct inode *inode, struct folio *folio, u64
 {
 	u64 clamp_start = max_t(u64, pos, folio_pos(folio));
 	u64 clamp_end = min_t(u64, pos + len, folio_next_pos(folio));
-	const u32 blocksize = inode_to_fs_info(inode)->sectorsize;
+	const u32 blocksize = inode_to_fs_info(inode)->datasize;
 	int ret = 0;
 
 	if (folio_test_uptodate(folio))
@@ -892,8 +892,8 @@ lock_and_cleanup_extent(struct btrfs_inode *inode, struct folio *folio,
 	u64 start_pos;
 	u64 last_pos;
 
-	start_pos = round_down(pos, fs_info->sectorsize);
-	last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
+	start_pos = round_down(pos, fs_info->datasize);
+	last_pos = round_up(pos + write_bytes, fs_info->datasize) - 1;
 
 	if (nowait) {
 		if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
@@ -972,9 +972,9 @@ int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
 	if (!btrfs_drew_try_write_lock(&root->snapshot_lock))
 		return -EAGAIN;
 
-	lockstart = round_down(pos, fs_info->sectorsize);
+	lockstart = round_down(pos, fs_info->datasize);
 	lockend = round_up(pos + *write_bytes,
-			   fs_info->sectorsize) - 1;
+			   fs_info->datasize) - 1;
 
 	if (nowait) {
 		if (!btrfs_try_lock_ordered_range(inode, lockstart, lockend,
@@ -1061,7 +1061,7 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
 	oldsize = i_size_read(inode);
 	if (pos > oldsize) {
 		/* Expand hole size to cover write data, preventing empty gap */
-		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
+		loff_t end_pos = round_up(pos + count, fs_info->datasize);
 
 		ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
 		if (ret)
@@ -1084,7 +1084,7 @@ static void release_space(struct btrfs_inode *inode, struct extent_changeset *da
 		const struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
 		btrfs_delalloc_release_space(inode, data_reserved,
-					     round_down(start, fs_info->sectorsize),
+					     round_down(start, fs_info->datasize),
 					     len, true);
 	}
 }
@@ -1101,7 +1101,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
 			     bool *only_release_metadata)
 {
 	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const unsigned int block_offset = (start & (fs_info->sectorsize - 1));
+	const unsigned int block_offset = (start & (fs_info->datasize - 1));
 	size_t reserve_bytes;
 	int ret;
 
@@ -1126,7 +1126,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
 		*only_release_metadata = true;
 	}
 
-	reserve_bytes = round_up(*len + block_offset, fs_info->sectorsize);
+	reserve_bytes = round_up(*len + block_offset, fs_info->datasize);
 	WARN_ON(reserve_bytes == 0);
 	ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes,
 					      reserve_bytes, nowait);
@@ -1186,7 +1186,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 	struct extent_state *cached_state = NULL;
 	size_t write_bytes = calc_write_bytes(inode, iter, start);
 	size_t copied;
-	const u64 reserved_start = round_down(start, fs_info->sectorsize);
+	const u64 reserved_start = round_down(start, fs_info->datasize);
 	u64 reserved_len;
 	struct folio *folio = NULL;
 	u64 lockstart;
@@ -1289,7 +1289,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 		}
 
 		/* Release the reserved space beyond the last block. */
-		last_block = round_up(start + copied, fs_info->sectorsize);
+		last_block = round_up(start + copied, fs_info->datasize);
 
 		shrink_reserved_space(inode, *data_reserved, reserved_start,
 				      reserved_len, last_block - reserved_start,
@@ -1912,7 +1912,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	}
 
 	if (folio_contains(folio, (size - 1) >> PAGE_SHIFT)) {
-		reserved_space = round_up(size - page_start, fs_info->sectorsize);
+		reserved_space = round_up(size - page_start, fs_info->datasize);
 		if (reserved_space < fsize) {
 			const u64 to_free = fsize - reserved_space;
 
@@ -2156,8 +2156,8 @@ static int find_first_non_hole(struct btrfs_inode *inode, u64 *start, u64 *len)
 	int ret = 0;
 
 	em = btrfs_get_extent(inode, NULL,
-			      round_down(*start, fs_info->sectorsize),
-			      round_up(*len, fs_info->sectorsize));
+			      round_down(*start, fs_info->datasize),
+			      round_up(*len, fs_info->datasize));
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -2370,7 +2370,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	const u64 min_size = btrfs_calc_insert_metadata_size(fs_info, 1);
-	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
+	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->datasize);
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_block_rsv rsv;
 	unsigned int rsv_count;
@@ -2641,7 +2641,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	if (ret)
 		goto out_only_mutex;
 
-	ino_size = round_up(inode->i_size, fs_info->sectorsize);
+	ino_size = round_up(inode->i_size, fs_info->datasize);
 	ret = find_first_non_hole(BTRFS_I(inode), &offset, &len);
 	if (ret < 0)
 		goto out_only_mutex;
@@ -2655,15 +2655,15 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	if (ret)
 		goto out_only_mutex;
 
-	lockstart = round_up(offset, fs_info->sectorsize);
-	lockend = round_down(offset + len, fs_info->sectorsize) - 1;
-	same_block = (offset >> fs_info->sectorsize_bits) ==
-		     ((offset + len - 1) >> fs_info->sectorsize_bits);
+	lockstart = round_up(offset, fs_info->datasize);
+	lockend = round_down(offset + len, fs_info->datasize) - 1;
+	same_block = (offset >> fs_info->datasize_bits) ==
+		     ((offset + len - 1) >> fs_info->datasize_bits);
 	/*
 	 * Only do this if we are in the same block and we aren't doing the
 	 * entire block.
 	 */
-	if (same_block && len < fs_info->sectorsize) {
+	if (same_block && len < fs_info->datasize) {
 		if (offset < ino_size) {
 			truncated_block = true;
 			ret = btrfs_truncate_block(BTRFS_I(inode), offset + len - 1,
@@ -2832,8 +2832,8 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
 	if (mode & FALLOC_FL_KEEP_SIZE || end <= i_size_read(inode))
 		return 0;
 
-	range_start = round_down(i_size_read(inode), root->fs_info->sectorsize);
-	range_end = round_up(end, root->fs_info->sectorsize);
+	range_start = round_down(i_size_read(inode), root->fs_info->datasize);
+	range_end = round_up(end, root->fs_info->datasize);
 
 	ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode), range_start,
 						range_end - range_start);
@@ -2862,7 +2862,7 @@ enum {
 static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
 						 u64 offset)
 {
-	const u32 sectorsize = inode->root->fs_info->sectorsize;
+	const u32 sectorsize = inode->root->fs_info->datasize;
 	struct extent_map *em;
 	int ret;
 
@@ -2892,7 +2892,7 @@ static int btrfs_zero_range(struct inode *inode,
 	struct extent_changeset *data_reserved = NULL;
 	int ret;
 	u64 alloc_hint = 0;
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	const u64 orig_start = offset;
 	const u64 orig_end = offset + len - 1;
 	u64 alloc_start = round_down(offset, sectorsize);
@@ -3039,7 +3039,7 @@ static int btrfs_zero_range(struct inode *inode,
 		}
 		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
 						alloc_end - alloc_start,
-						fs_info->sectorsize,
+						fs_info->datasize,
 						offset + len, &alloc_hint);
 		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				    &cached_state);
@@ -3079,7 +3079,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	u64 data_space_reserved = 0;
 	u64 qgroup_reserved = 0;
 	struct extent_map *em;
-	int blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
+	int blocksize = BTRFS_I(inode)->root->fs_info->datasize;
 	int ret;
 
 	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
@@ -3388,7 +3388,7 @@ bool btrfs_find_delalloc_in_range(struct btrfs_inode *inode, u64 start, u64 end,
 				  struct extent_state **cached_state,
 				  u64 *delalloc_start_ret, u64 *delalloc_end_ret)
 {
-	u64 cur_offset = round_down(start, inode->root->fs_info->sectorsize);
+	u64 cur_offset = round_down(start, inode->root->fs_info->datasize);
 	u64 prev_delalloc_end = 0;
 	bool search_io_tree = true;
 	bool ret = false;
@@ -3576,10 +3576,10 @@ static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
 	 */
 	start = max_t(loff_t, 0, offset);
 
-	lockstart = round_down(start, fs_info->sectorsize);
-	lockend = round_up(i_size, fs_info->sectorsize);
+	lockstart = round_down(start, fs_info->datasize);
+	lockend = round_up(i_size, fs_info->datasize);
 	if (lockend <= lockstart)
-		lockend = lockstart + fs_info->sectorsize;
+		lockend = lockstart + fs_info->datasize;
 	lockend--;
 
 	path = btrfs_alloc_path();
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3eba8438593c..a99aa3a7b4c7 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -886,9 +886,23 @@ struct btrfs_fs_info {
 	/* Cached block sizes */
 	u32 nodesize;
 	u32 nodesize_bits;
+
+	/*
+	 * The sectorsize from super block, also the unit of data checksum
+	 * calculation.
+	 */
 	u32 sectorsize;
-	/* ilog2 of sectorsize, use to avoid 64bit division */
-	u32 sectorsize_bits;
+
+	/*
+	 * The minimal data IO size, must equal to sectorsize or power-of-2
+	 * time of sectorsize.
+	 */
+	u32 datasize;
+
+	/* ilog2 of corresponding sizes, use to avoid 64bit division */
+	u16 datasize_bits;
+	u16 sectorsize_bits;
+
 	u32 block_min_order;
 	u32 block_max_order;
 	u32 writeback_bio_size;
@@ -1078,12 +1092,6 @@ static inline u32 count_max_extents(const struct btrfs_fs_info *fs_info, u64 siz
 	return div_u64(size + fs_info->max_extent_size - 1, fs_info->max_extent_size);
 }
 
-static inline unsigned int btrfs_blocks_per_folio(const struct btrfs_fs_info *fs_info,
-						  const struct folio *folio)
-{
-	return folio_size(folio) >> fs_info->sectorsize_bits;
-}
-
 bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize);
 bool btrfs_exclop_start(struct btrfs_fs_info *fs_info,
 			enum btrfs_exclusive_operation type);
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index a864f8c99729..703d762ad88f 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -565,8 +565,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					btrfs_file_extent_num_bytes(leaf, fi);
 				extent_num_bytes = ALIGN(new_size -
 						found_key.offset,
-						fs_info->sectorsize);
-				clear_start = ALIGN(new_size, fs_info->sectorsize);
+						fs_info->datasize);
+				clear_start = ALIGN(new_size, fs_info->datasize);
 
 				btrfs_set_file_extent_num_bytes(leaf, fi,
 							 extent_num_bytes);
@@ -612,7 +612,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				 * them as a full sector worth in the file
 				 * extent tree just for simplicity sake.
 				 */
-				clear_len = fs_info->sectorsize;
+				clear_len = fs_info->datasize;
 			}
 
 			control->sub_bytes += item_end + 1 - new_size;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b6ea1f713b7e..c19f776d19da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -190,7 +190,7 @@ static int data_reloc_print_warning_inode(u64 inum, u64 offset, u64 num_bytes,
 		btrfs_warn(fs_info,
 "checksum error at logical %llu mirror %u root %llu inode %llu offset %llu length %u links %u (path: %s)",
 			   warn->logical, warn->mirror_num, root, inum, offset,
-			   fs_info->sectorsize, nlink,
+			   fs_info->datasize, nlink,
 			   (char *)(unsigned long)ipath->fspath->val[i]);
 	}
 
@@ -441,7 +441,7 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf;
-	const u32 sectorsize = trans->fs_info->sectorsize;
+	const u32 sectorsize = trans->fs_info->datasize;
 	char *kaddr;
 	unsigned long ptr;
 	struct btrfs_file_extent_item *ei;
@@ -519,7 +519,7 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	 * sake.
 	 */
 	ret = btrfs_inode_set_file_extent_range(inode, 0,
-					ALIGN(size, root->fs_info->sectorsize));
+					ALIGN(size, root->fs_info->datasize));
 	if (ret)
 		return ret;
 
@@ -564,11 +564,11 @@ static bool can_cow_file_range_inline(struct btrfs_inode *inode,
 		return false;
 
 	/* Inline extents are limited to sectorsize. */
-	if (size > fs_info->sectorsize)
+	if (size > fs_info->datasize)
 		return false;
 
 	/* We do not allow a non-compressed extent to be as large as block size. */
-	if (data_len >= fs_info->sectorsize)
+	if (data_len >= fs_info->datasize)
 		return false;
 
 	/* We cannot exceed the maximum inline data size. */
@@ -632,7 +632,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 
 	drop_args.path = path;
 	drop_args.start = 0;
-	drop_args.end = fs_info->sectorsize;
+	drop_args.end = fs_info->datasize;
 	drop_args.drop_cache = true;
 	drop_args.replace_extent = true;
 	drop_args.extent_item_size = btrfs_file_extent_calc_inline_size(data_len);
@@ -675,7 +675,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 	 * to keep the data reservation.
 	 */
 	if (ret <= 0)
-		btrfs_qgroup_free_data(inode, NULL, 0, fs_info->sectorsize, NULL);
+		btrfs_qgroup_free_data(inode, NULL, 0, fs_info->datasize, NULL);
 	btrfs_free_path(path);
 	if (trans)
 		btrfs_end_transaction(trans);
@@ -741,7 +741,7 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 	 * do not even bother try compression, as there will be no space saving
 	 * and will always fallback to regular write later.
 	 */
-	if (end + 1 - start <= fs_info->sectorsize &&
+	if (end + 1 - start <= fs_info->datasize &&
 	    (!check_inline || (start > 0 || end + 1 < inode->disk_i_size)))
 		return 0;
 
@@ -869,7 +869,7 @@ static void compress_file_range(struct btrfs_work *work)
 	struct btrfs_inode *inode = async_chunk->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct compressed_bio *cb = NULL;
-	const u32 blocksize = fs_info->sectorsize;
+	const u32 blocksize = fs_info->datasize;
 	u64 start = async_chunk->start;
 	u64 end = async_chunk->end;
 	u64 actual_end;
@@ -968,7 +968,7 @@ static void compress_file_range(struct btrfs_work *work)
 	 * the page count read with the blocks on disk, compression must free at
 	 * least one sector.
 	 */
-	total_in = round_up(total_in, fs_info->sectorsize);
+	total_in = round_up(total_in, fs_info->datasize);
 	if (total_compressed + blocksize > total_in)
 		goto mark_incompressible;
 
@@ -1354,7 +1354,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	u64 orig_start = start;
 	u64 num_bytes;
 	u32 min_alloc_size;
-	u32 blocksize = fs_info->sectorsize;
+	u32 blocksize = fs_info->datasize;
 	u32 cur_alloc_size = 0;
 	struct btrfs_key ins;
 	unsigned clear_bits;
@@ -1402,7 +1402,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	if (btrfs_is_data_reloc_root(root))
 		min_alloc_size = num_bytes;
 	else
-		min_alloc_size = fs_info->sectorsize;
+		min_alloc_size = fs_info->datasize;
 
 	while (num_bytes > 0) {
 		ret = cow_one_range(inode, locked_folio, &ins, &cached, start,
@@ -2315,7 +2315,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 	struct compressed_bio *cb = NULL;
 	struct extent_state *cached = NULL;
 	const u64 i_size = i_size_read(&inode->vfs_inode);
-	const u32 blocksize = fs_info->sectorsize;
+	const u32 blocksize = fs_info->datasize;
 	int compress_type = fs_info->compress_type;
 	int compress_level = fs_info->compress_level;
 	u32 compressed_size = 0;
@@ -2412,7 +2412,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
 	ASSERT(!(end <= folio_pos(locked_folio) ||
 		 start >= folio_next_pos(locked_folio)));
 
-	if (start == 0 && end + 1 <= inode->root->fs_info->sectorsize &&
+	if (start == 0 && end + 1 <= inode->root->fs_info->datasize &&
 	    end + 1 >= inode->disk_i_size) {
 		int ret;
 
@@ -2795,7 +2795,7 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state)
 {
-	const u32 blocksize = inode->root->fs_info->sectorsize;
+	const u32 blocksize = inode->root->fs_info->datasize;
 
 	/* Basic alignment check. */
 	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu blocksize=%u",
@@ -2848,7 +2848,7 @@ static void btrfs_writepage_fixup_worker(struct work_struct *work)
 	struct btrfs_inode *inode = fixup->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	const u64 page_start = folio_pos(folio);
 	const u64 page_end = folio_next_pos(folio) - 1;
 	unsigned int start_bit;
@@ -2886,7 +2886,7 @@ static void btrfs_writepage_fixup_worker(struct work_struct *work)
 
 	for (bit = 0; bit < blocks_per_folio; bit++) {
 		struct btrfs_ordered_extent *ordered;
-		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
+		const u64 start = page_start + (bit << fs_info->datasize_bits);
 
 		if (test_bit(bit, delalloc_bitmap))
 			continue;
@@ -3006,7 +3006,7 @@ void btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
 int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				unsigned int extra_bits, struct extent_state **cached_state)
 {
-	const u32 blocksize = inode->root->fs_info->sectorsize;
+	const u32 blocksize = inode->root->fs_info->datasize;
 
 	/* The @extra_bits can only be EXTENT_NORESERVE for now. */
 	ASSERT(!(extra_bits & ~EXTENT_NORESERVE), "extra_bits=0x%x", extra_bits);
@@ -3051,7 +3051,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 qgroup_reserved)
 {
 	struct btrfs_root *root = inode->root;
-	const u32 sectorsize = root->fs_info->sectorsize;
+	const u32 sectorsize = root->fs_info->datasize;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key ins;
@@ -3472,6 +3472,7 @@ void btrfs_csum_one_bio_block(struct btrfs_fs_info *fs_info, struct bio *bio,
 		const u32 cur_len = min(bio_iter_len(bio, iter), blocksize - cur);
 		void *kaddr;
 
+		ASSERT(cur_len > 0);
 		kaddr = kmap_local_page(page) + pg_off;
 		btrfs_csum_update(&cctx, kaddr, cur_len);
 		kunmap_local(kaddr);
@@ -3518,9 +3519,17 @@ bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio,
 	if (btrfs_is_data_reloc_root(inode->root) &&
 	    btrfs_test_range_bit(&inode->io_tree, file_offset, end, EXTENT_NODATASUM,
 				 NULL)) {
-		/* Skip the range without csum for data reloc inode */
-		btrfs_clear_extent_bit(&inode->io_tree, file_offset, end,
-				       EXTENT_NODATASUM, NULL);
+		/*
+		 * Skip the range without csum for data reloc inode.
+		 *
+		 * For datasize > sectorsize case, we can have multiple
+		 * sectors inside a data block. Only clear the EXTENT_NODATASUM
+		 * flag for the last sector of the block.
+		 */
+		if (IS_ALIGNED(end + 1, fs_info->datasize))
+			btrfs_clear_extent_bit(&inode->io_tree,
+					       round_down(file_offset, fs_info->datasize),
+					       end, EXTENT_NODATASUM, NULL);
 		return true;
 	}
 
@@ -4192,7 +4201,7 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 	if (ret)
 		goto out;
 	btrfs_inode_set_file_extent_range(inode, 0,
-			  round_up(i_size_read(vfs_inode), fs_info->sectorsize));
+			  round_up(i_size_read(vfs_inode), fs_info->datasize));
 
 	if (!maybe_acls)
 		cache_no_acl(vfs_inode);
@@ -5031,7 +5040,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
 	bool only_release_metadata = false;
-	u32 blocksize = fs_info->sectorsize;
+	u32 blocksize = fs_info->datasize;
 	pgoff_t index = (offset >> PAGE_SHIFT);
 	struct folio *folio;
 	gfp_t mask = btrfs_alloc_write_mask(mapping);
@@ -5269,8 +5278,8 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
-	u64 hole_start = ALIGN(oldsize, fs_info->sectorsize);
-	u64 block_end = ALIGN(size, fs_info->sectorsize);
+	u64 hole_start = ALIGN(oldsize, fs_info->datasize);
+	u64 block_end = ALIGN(size, fs_info->datasize);
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
@@ -5299,7 +5308,7 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
 			break;
 		}
 		last_byte = min(btrfs_extent_map_end(em), block_end);
-		last_byte = ALIGN(last_byte, fs_info->sectorsize);
+		last_byte = ALIGN(last_byte, fs_info->datasize);
 		hole_size = last_byte - cur_offset;
 
 		if (!(em->flags & EXTENT_FLAG_PREALLOC)) {
@@ -5405,7 +5414,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 
 		if (btrfs_is_zoned(fs_info)) {
 			ret = btrfs_wait_ordered_range(BTRFS_I(inode),
-					ALIGN(newsize, fs_info->sectorsize),
+					ALIGN(newsize, fs_info->datasize),
 					(u64)-1);
 			if (ret)
 				return ret;
@@ -7100,7 +7109,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 {
 	int ret;
 	struct extent_buffer *leaf = path->nodes[0];
-	const u32 blocksize = leaf->fs_info->sectorsize;
+	const u32 blocksize = leaf->fs_info->datasize;
 	char *tmp;
 	size_t max_size;
 	unsigned long inline_size;
@@ -7137,7 +7146,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 
 static int read_inline_extent(struct btrfs_path *path, struct folio *folio)
 {
-	const u32 blocksize = path->nodes[0]->fs_info->sectorsize;
+	const u32 blocksize = path->nodes[0]->fs_info->datasize;
 	struct btrfs_file_extent_item *fi;
 	void *kaddr;
 	size_t copy_size;
@@ -7332,7 +7341,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		 * Other members are not utilized for inline extents.
 		 */
 		ASSERT(em->disk_bytenr == EXTENT_MAP_INLINE);
-		ASSERT(em->len == fs_info->sectorsize);
+		ASSERT(em->len == fs_info->datasize);
 
 		ret = read_inline_extent(path, folio);
 		if (ret < 0)
@@ -7475,7 +7484,7 @@ noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
 		u64 range_end;
 
 		range_end = round_up(offset + nocow_args.file_extent.num_bytes,
-				     root->fs_info->sectorsize) - 1;
+				     root->fs_info->datasize) - 1;
 		ret = btrfs_test_range_bit_exists(io_tree, offset, range_end,
 						  EXTENT_DELALLOC);
 		if (ret)
@@ -7811,8 +7820,8 @@ static int btrfs_truncate(struct btrfs_inode *inode, bool skip_writeback)
 	int ret;
 	struct btrfs_trans_handle *trans;
 	const u64 min_size = btrfs_calc_metadata_size(fs_info, 1);
-	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->sectorsize);
-	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
+	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->datasize);
+	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->datasize);
 
 	/* Our inode is locked and the i_size can't be changed concurrently. */
 	btrfs_assert_inode_locked(inode);
@@ -8196,7 +8205,7 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	u64 delalloc_bytes;
 	u64 inode_bytes;
 	struct inode *inode = d_inode(path->dentry);
-	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
+	u32 blocksize = btrfs_sb(inode->i_sb)->datasize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
 	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
@@ -9015,7 +9024,7 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	 * reach block size.
 	 */
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
-	    name_len >= fs_info->sectorsize)
+	    name_len >= fs_info->datasize)
 		return -ENAMETOOLONG;
 
 	inode = new_inode(dir->i_sb);
@@ -9282,8 +9291,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			 * to truncate disk_i_size to the start of the gap,
 			 * making the persisted size smaller than i_size.
 			 */
-			range_start = round_down(inode->i_size, fs_info->sectorsize);
-			range_end = round_up(i_size, fs_info->sectorsize);
+			range_start = round_down(inode->i_size, fs_info->datasize);
+			range_end = round_up(i_size, fs_info->datasize);
 			ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode),
 					range_start, range_end - range_start);
 			if (ret) {
@@ -9430,10 +9439,10 @@ int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
 		 * The LZO format depends on the sector size. 64K is the maximum
 		 * sector size that we support.
 		 */
-		if (fs_info->sectorsize < SZ_4K || fs_info->sectorsize > SZ_64K)
+		if (fs_info->datasize < SZ_4K || fs_info->datasize > SZ_64K)
 			return -EINVAL;
 		return BTRFS_ENCODED_IO_COMPRESSION_LZO_4K +
-		       (fs_info->sectorsize_bits - 12);
+		       (fs_info->datasize_bits - 12);
 	case BTRFS_COMPRESS_ZSTD:
 		return BTRFS_ENCODED_IO_COMPRESSION_ZSTD;
 	default:
@@ -9721,7 +9730,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 		return 0;
 	}
-	start = ALIGN_DOWN(iocb->ki_pos, fs_info->sectorsize);
+	start = ALIGN_DOWN(iocb->ki_pos, fs_info->datasize);
 	/*
 	 * We don't know how long the extent containing iocb->ki_pos is, but if
 	 * it's compressed we know that it won't be longer than this.
@@ -9834,7 +9843,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
 		count = start + *disk_io_size - iocb->ki_pos;
 		encoded->len = count;
 		encoded->unencoded_len = count;
-		*disk_io_size = ALIGN(*disk_io_size, fs_info->sectorsize);
+		*disk_io_size = ALIGN(*disk_io_size, fs_info->datasize);
 	}
 	btrfs_free_extent_map(em);
 	em = NULL;
@@ -9878,7 +9887,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	int compression;
 	size_t orig_count;
 	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
-	const u32 blocksize = fs_info->sectorsize;
+	const u32 blocksize = fs_info->datasize;
 	u64 start, end;
 	u64 num_bytes, ram_bytes, disk_num_bytes;
 	struct btrfs_key ins;
@@ -9901,7 +9910,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		/* The sector size must match for LZO. */
 		if (encoded->compression -
 		    BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12 !=
-		    fs_info->sectorsize_bits)
+		    fs_info->datasize_bits)
 			return -EINVAL;
 		compression = BTRFS_COMPRESS_LZO;
 		break;
@@ -9943,7 +9952,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 
 	/* The extent must start on a sector boundary. */
 	start = iocb->ki_pos;
-	if (!IS_ALIGNED(start, fs_info->sectorsize))
+	if (!IS_ALIGNED(start, fs_info->datasize))
 		return -EINVAL;
 
 	/*
@@ -9952,15 +9961,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	 * up the extent size and set i_size to the unaligned end.
 	 */
 	if (start + encoded->len < inode->vfs_inode.i_size &&
-	    !IS_ALIGNED(start + encoded->len, fs_info->sectorsize))
+	    !IS_ALIGNED(start + encoded->len, fs_info->datasize))
 		return -EINVAL;
 
 	/* Finally, the offset in the unencoded data must be sector-aligned. */
-	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->sectorsize))
+	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->datasize))
 		return -EINVAL;
 
-	num_bytes = ALIGN(encoded->len, fs_info->sectorsize);
-	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->sectorsize);
+	num_bytes = ALIGN(encoded->len, fs_info->datasize);
+	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->datasize);
 	end = start + num_bytes - 1;
 
 	/*
@@ -9968,7 +9977,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	 * sector-aligned. For convenience, we extend it with zeroes if it
 	 * isn't.
 	 */
-	disk_num_bytes = ALIGN(orig_count, fs_info->sectorsize);
+	disk_num_bytes = ALIGN(orig_count, fs_info->datasize);
 
 	cb = btrfs_alloc_compressed_write(inode, start, num_bytes);
 	for (int i = 0; i * min_folio_size < disk_num_bytes; i++) {
@@ -10381,7 +10390,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	atomic_inc(&root->nr_swapfiles);
 	spin_unlock(&root->root_item_lock);
 
-	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
+	isize = ALIGN_DOWN(inode->i_size, fs_info->datasize);
 
 	btrfs_lock_extent(io_tree, 0, isize - 1, &cached_state);
 	while (prev_extent_end < isize) {
@@ -10758,7 +10767,7 @@ static bool btrfs_data_dirty_folio(struct address_space *mapping,
 	const u64 page_start = folio_pos(folio);
 	const u64 range_end = min_t(u64, folio_next_pos(folio),
 				    round_up(i_size_read(&inode->vfs_inode),
-					     fs_info->sectorsize));
+					     fs_info->datasize));
 
 	if (range_end > page_start)
 		btrfs_folio_set_fixup_dirty(fs_info, folio, page_start,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 54960351fbd1..0359f71b16db 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2724,8 +2724,8 @@ static long btrfs_ioctl_fs_info(const struct btrfs_fs_info *fs_info,
 
 	memcpy(&fi_args->fsid, fs_devices->fsid, sizeof(fi_args->fsid));
 	fi_args->nodesize = fs_info->nodesize;
-	fi_args->sectorsize = fs_info->sectorsize;
-	fi_args->clone_alignment = fs_info->sectorsize;
+	fi_args->sectorsize = fs_info->datasize;
+	fi_args->clone_alignment = fs_info->datasize;
 
 	if (flags_in & BTRFS_FS_INFO_FLAG_CSUM_INFO) {
 		fi_args->csum_type = btrfs_super_csum_type(fs_info->super_copy);
@@ -4421,7 +4421,7 @@ static int btrfs_ioctl_encoded_read(struct file *file, void __user *argp,
 		bool unlocked = false;
 		u64 start, lockend, count;
 
-		start = ALIGN_DOWN(kiocb.ki_pos, fs_info->sectorsize);
+		start = ALIGN_DOWN(kiocb.ki_pos, fs_info->datasize);
 		lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
 
 		if (args.compression)
@@ -4831,7 +4831,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		kiocb.ki_flags |= IOCB_NOWAIT;
 
-	start = ALIGN_DOWN(pos, fs_info->sectorsize);
+	start = ALIGN_DOWN(pos, fs_info->datasize);
 	lockend = start + BTRFS_MAX_UNCOMPRESSED - 1;
 
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
@@ -5276,8 +5276,8 @@ static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
 
-	if (!IS_ALIGNED(args.offset, fs_info->sectorsize) ||
-	    !IS_ALIGNED(args.length, fs_info->sectorsize))
+	if (!IS_ALIGNED(args.offset, fs_info->datasize) ||
+	    !IS_ALIGNED(args.length, fs_info->datasize))
 		return -EINVAL;
 	if (args.length == 0)
 		return -EINVAL;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2f0996692da0..16b31345df45 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -67,11 +67,11 @@ struct workspace {
 
 static u32 workspace_buf_length(const struct btrfs_fs_info *fs_info)
 {
-	return lzo1x_worst_compress(fs_info->sectorsize);
+	return lzo1x_worst_compress(fs_info->datasize);
 }
 static u32 workspace_cbuf_length(const struct btrfs_fs_info *fs_info)
 {
-	return lzo1x_worst_compress(fs_info->sectorsize);
+	return lzo1x_worst_compress(fs_info->datasize);
 }
 
 void lzo_free_workspace(struct list_head *ws)
@@ -180,8 +180,8 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 				       struct folio **out_folio,
 				       u32 *total_out, u32 max_out)
 {
-	const u32 sectorsize = fs_info->sectorsize;
-	const u32 sectorsize_bits = fs_info->sectorsize_bits;
+	const u32 sectorsize = fs_info->datasize;
+	const u32 sectorsize_bits = fs_info->datasize_bits;
 	const u32 fsize = btrfs_min_folio_size(fs_info);
 	const u32 old_size = out_bio->bi_iter.bi_size;
 	u32 copy_start;
@@ -265,7 +265,7 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	struct bio *bio = &cb->bbio.bio;
 	const u64 start = cb->start;
 	const u32 len = cb->len;
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
 	struct address_space *mapping = inode->vfs_inode.i_mapping;
 	struct folio *folio_in = NULL;
@@ -414,7 +414,7 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	struct btrfs_fs_info *fs_info = cb->bbio.inode->root->fs_info;
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	const u32 compressed_len = bio_get_size(&cb->bbio.bio);
 	struct folio_iter fi;
 	char *kaddr;
@@ -546,7 +546,7 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	struct btrfs_fs_info *fs_info = folio_to_fs_info(dest_folio);
-	const u32 sectorsize = fs_info->sectorsize;
+	const u32 sectorsize = fs_info->datasize;
 	size_t in_len;
 	size_t out_len;
 	size_t max_segment_len = workspace_buf_length(fs_info);
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index d2a4101912bd..3a79a82aa3b9 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -61,7 +61,7 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 			       const u8 comp_type)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u32 block_size = fs_info->sectorsize;
+	const u32 block_size = fs_info->datasize;
 	const u64 range_end = file_offset + block_size - 1;
 	const size_t inline_size = size - btrfs_file_extent_calc_inline_size(0);
 	char *data_start = inline_data + btrfs_file_extent_calc_inline_size(0);
@@ -175,7 +175,7 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	const u64 aligned_end = ALIGN(new_key->offset + datal,
-				      fs_info->sectorsize);
+				      fs_info->datasize);
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_drop_extents_args drop_args = { 0 };
 	int ret;
@@ -573,10 +573,10 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
 			 * the i_size (which implies the whole inlined data).
 			 */
 			ASSERT(key.offset == 0);
-			ASSERT(datal <= fs_info->sectorsize);
+			ASSERT(datal <= fs_info->datasize);
 			if (WARN_ON(type != BTRFS_FILE_EXTENT_INLINE) ||
 			    WARN_ON(key.offset != 0) ||
-			    WARN_ON(datal > fs_info->sectorsize)) {
+			    WARN_ON(datal > fs_info->datasize)) {
 				ret = -EUCLEAN;
 				goto out;
 			}
@@ -609,7 +609,7 @@ static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
 		inode->last_reflink_trans = trans->transid;
 
 		last_dest_end = ALIGN(new_key.offset + datal,
-				      fs_info->sectorsize);
+				      fs_info->datasize);
 		ret = clone_finish_inode_update(trans, inode, last_dest_end,
 						destoff, olen, no_time_update);
 		if (ret)
@@ -689,7 +689,7 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
 {
 	struct extent_state *cached_state = NULL;
 	struct btrfs_fs_info *fs_info = src->root->fs_info;
-	const u32 bs = fs_info->sectorsize;
+	const u32 bs = fs_info->datasize;
 	const u64 end = round_up(dst_loff + len, bs) - 1;
 	int ret;
 
@@ -761,7 +761,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	const u64 inode_isize = inode->vfs_inode.i_size;
 	int ret;
 	u64 len = olen;
-	const u32 bs = fs_info->sectorsize;
+	const u32 bs = fs_info->datasize;
 	u64 end;
 
 	/*
@@ -839,7 +839,7 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 {
 	struct btrfs_inode *inode_in = BTRFS_I(file_inode(file_in));
 	struct btrfs_inode *inode_out = BTRFS_I(file_inode(file_out));
-	const u32 bs = inode_out->root->fs_info->sectorsize;
+	const u32 bs = inode_out->root->fs_info->datasize;
 	u64 wb_len;
 	int ret;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index da54db75e7a9..1fefe0470f68 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -996,8 +996,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				end = key.offset +
 				      btrfs_file_extent_num_bytes(leaf, fi);
 				WARN_ON(!IS_ALIGNED(key.offset,
-						    fs_info->sectorsize));
-				WARN_ON(!IS_ALIGNED(end, fs_info->sectorsize));
+						    fs_info->datasize));
+				WARN_ON(!IS_ALIGNED(end, fs_info->datasize));
 				end--;
 				/* Take mmap lock to serialize with reflinks. */
 				if (!down_read_trylock(&inode->i_mmap_lock))
@@ -1447,7 +1447,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 				start = 0;
 			else {
 				start = min_key->offset;
-				WARN_ON(!IS_ALIGNED(start, fs_info->sectorsize));
+				WARN_ON(!IS_ALIGNED(start, fs_info->datasize));
 			}
 		} else {
 			start = 0;
@@ -1462,7 +1462,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 				if (max_key->offset == 0)
 					continue;
 				end = max_key->offset;
-				WARN_ON(!IS_ALIGNED(end, fs_info->sectorsize));
+				WARN_ON(!IS_ALIGNED(end, fs_info->datasize));
 				end--;
 			}
 		} else {
@@ -3024,7 +3024,7 @@ static int relocate_one_folio(struct reloc_control *rc,
 			u64 boundary_start = cluster->boundary[*cluster_nr] -
 						offset;
 			u64 boundary_end = boundary_start +
-					   fs_info->sectorsize - 1;
+					   fs_info->datasize - 1;
 
 			btrfs_set_extent_bit(&BTRFS_I(inode)->io_tree,
 					     boundary_start, boundary_end,
@@ -4284,7 +4284,7 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 	spin_unlock(&sinfo->lock);
 
 	if (is_data)
-		min_size = fs_info->sectorsize;
+		min_size = fs_info->datasize;
 	else
 		min_size = fs_info->nodesize;
 
@@ -4637,7 +4637,7 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 
 				read_extent_buffer(leaf, bitmap, offset, data_size);
 
-				parse_bitmap(fs_info->sectorsize, bitmap,
+				parse_bitmap(fs_info->datasize, bitmap,
 					     data_size * BITS_PER_BYTE,
 					     found_key.objectid, space_runs,
 					     &num_space_runs);
@@ -5104,7 +5104,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	spin_unlock(&sinfo->lock);
 
 	if (is_data)
-		min_size = fs_info->sectorsize;
+		min_size = fs_info->datasize;
 	else
 		min_size = fs_info->nodesize;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5c59b9abedcd..63ca3e436480 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5783,7 +5783,7 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 	 * filesystem has.
 	 */
 	if (clone_root->offset == 0 &&
-	    len == sctx->send_root->fs_info->sectorsize)
+	    len == sctx->send_root->fs_info->datasize)
 		return send_extent_data(sctx, dst_path, offset, len);
 
 	path = alloc_path_for_send();
@@ -6032,7 +6032,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	int ret = 0;
 	u64 offset = key->offset;
 	u64 end;
-	const u32 bs = sctx->send_root->fs_info->sectorsize;
+	const u32 bs = sctx->send_root->fs_info->datasize;
 	struct btrfs_file_extent_item *ei;
 	u64 disk_byte;
 	u64 data_offset;
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index ebf18efe1ea3..8d34b7ec56fd 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -91,12 +91,18 @@ struct btrfs_folio_state *btrfs_alloc_folio_state(const struct btrfs_fs_info *fs
 {
 	struct btrfs_folio_state *ret;
 	unsigned int real_size;
+	unsigned int shift;
 
-	ASSERT(fs_info->sectorsize < fsize);
+	if (type == BTRFS_SUBPAGE_METADATA) {
+		ASSERT(fs_info->sectorsize < fsize);
+		shift = fs_info->sectorsize_bits;
+	} else {
+		ASSERT(fs_info->datasize < fsize);
+		shift = fs_info->datasize_bits;
+	}
 
 	real_size = struct_size(ret, bitmaps,
-			BITS_TO_LONGS(btrfs_bitmap_nr_max *
-				      (fsize >> fs_info->sectorsize_bits)));
+			BITS_TO_LONGS(btrfs_bitmap_nr_max * (fsize >> shift)));
 	ret = kzalloc(real_size, gfp);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
@@ -147,6 +153,16 @@ void btrfs_folio_dec_eb_refs(const struct btrfs_fs_info *fs_info, struct folio *
 	atomic_dec(&bfs->eb_refs);
 }
 
+static bool is_data_folio(const struct folio *folio)
+{
+	const struct address_space *mapping = folio_mapping(folio);
+
+	/* Only metadata can have an unmapped folio for dummy ebs. */
+	if (!mapping || !mapping->host)
+		return false;
+	return is_data_inode(BTRFS_I(mapping->host));
+}
+
 static void btrfs_subpage_assert(const struct btrfs_fs_info *fs_info,
 				 struct folio *folio, u64 start, u32 len)
 {
@@ -154,28 +170,42 @@ static void btrfs_subpage_assert(const struct btrfs_fs_info *fs_info,
 	ASSERT(folio_test_private(folio) && folio_get_private(folio));
 	ASSERT(IS_ALIGNED(start, fs_info->sectorsize) &&
 	       IS_ALIGNED(len, fs_info->sectorsize), "start=%llu len=%u", start, len);
-	/*
-	 * The range check only works for mapped page, we can still have
-	 * unmapped page like dummy extent buffer pages.
-	 */
-	if (folio->mapping)
+
+	if (is_data_folio(folio)) {
+		ASSERT(IS_ALIGNED(start, fs_info->datasize) &&
+		       IS_ALIGNED(len, fs_info->datasize), "start=%llu len=%u", start, len);
 		ASSERT(folio_pos(folio) <= start &&
 		       start + len <= folio_next_pos(folio),
 		       "start=%llu len=%u folio_pos=%llu folio_size=%zu",
 		       start, len, folio_pos(folio), folio_size(folio));
+	}
 }
 
 #define subpage_calc_start_bit(fs_info, folio, name, start, len)	\
 ({									\
 	unsigned int __start_bit;					\
 	const unsigned int __bpf = btrfs_blocks_per_folio(fs_info, folio); \
+	unsigned int shift;						\
+									\
+	if (is_data_folio(folio))					\
+		shift = fs_info->datasize_bits;				\
+	else								\
+		shift = fs_info->sectorsize_bits;			\
 									\
 	btrfs_subpage_assert(fs_info, folio, start, len);		\
-	__start_bit = offset_in_folio(folio, start) >> fs_info->sectorsize_bits; \
+	__start_bit = offset_in_folio(folio, start) >> shift;		\
 	__start_bit += __bpf * btrfs_bitmap_nr_##name;			\
 	__start_bit;							\
 })
 
+static unsigned int subpage_calc_nbits(const struct btrfs_fs_info *fs_info,
+				       const struct folio *folio, u32 len)
+{
+	if (is_data_folio(folio))
+		return len >> fs_info->datasize_bits;
+	return len >> fs_info->sectorsize_bits;
+}
+
 static void btrfs_subpage_clamp_range(struct folio *folio, u64 *start, u32 *len)
 {
 	u64 orig_start = *start;
@@ -197,7 +227,7 @@ static bool btrfs_subpage_end_and_test_lock(const struct btrfs_fs_info *fs_info,
 					    struct folio *folio, u64 start, u32 len)
 {
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
-	const int nbits = (len >> fs_info->sectorsize_bits);
+	const int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 	bool last;
 
@@ -323,10 +353,11 @@ void btrfs_subpage_set_uptodate(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							uptodate, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_set(bfs->bitmaps, start_bit, nbits);
 	if (subpage_test_bitmap_all_set(fs_info, folio, uptodate))
 		folio_mark_uptodate(folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
@@ -338,10 +369,11 @@ void btrfs_subpage_clear_uptodate(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							uptodate, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_clear(bfs->bitmaps, start_bit, nbits);
 	folio_clear_uptodate(folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
@@ -385,7 +417,7 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
 							dirty, start, len);
 	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
 							fixup, start, len);
-	const unsigned int nbits = len >> fs_info->sectorsize_bits;
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bfs->lock, flags);
@@ -432,11 +464,12 @@ bool btrfs_subpage_clear_and_test_dirty(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							dirty, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 	bool last = false;
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_clear(bfs->bitmaps, start_bit, nbits);
 	if (subpage_test_bitmap_all_zero(fs_info, folio, dirty))
 		last = true;
 	spin_unlock_irqrestore(&bfs->lock, flags);
@@ -459,10 +492,11 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							writeback, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_set(bfs->bitmaps, start_bit, nbits);
 
 	/*
 	 * Don't clear the TOWRITE tag when starting writeback on a still-dirty
@@ -486,10 +520,11 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							writeback, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_clear(bfs->bitmaps, start_bit, nbits);
 	if (subpage_test_bitmap_all_zero(fs_info, folio, writeback)) {
 		ASSERT(folio_test_writeback(folio));
 		folio_end_writeback(folio);
@@ -503,10 +538,12 @@ void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *bfs = folio_get_private(folio);
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
 							fixup, start, len);
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 
+	ASSERT(is_data_folio(folio));
 	spin_lock_irqsave(&bfs->lock, flags);
-	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	bitmap_clear(bfs->bitmaps, start_bit, nbits);
 	if (subpage_test_bitmap_all_zero(fs_info, folio, fixup))
 		folio_clear_fixup_pending(folio);
 	spin_unlock_irqrestore(&bfs->lock, flags);
@@ -530,10 +567,11 @@ static void btrfs_subpage_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
 							dirty, start, len);
 	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
 							fixup, start, len);
-	const unsigned int nbits = len >> fs_info->sectorsize_bits;
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 	bool marked = false;
 
+	ASSERT(is_data_folio(folio));
 	spin_lock_irqsave(&bfs->lock, flags);
 	for (unsigned int i = 0; i < nbits; i++) {
 		if (test_bit(dirty_bit + i, bfs->bitmaps))
@@ -586,10 +624,11 @@ static bool btrfs_subpage_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
 							dirty, start, len);
 	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
 							fixup, start, len);
-	const unsigned int nbits = len >> fs_info->sectorsize_bits;
+	const unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);
 	unsigned long flags;
 	bool last;
 
+	ASSERT(is_data_folio(folio));
 	spin_lock_irqsave(&bfs->lock, flags);
 	for (unsigned int i = 0; i < nbits; i++) {
 		if (!test_bit(fixup_bit + i, bfs->bitmaps))
@@ -624,6 +663,7 @@ void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
 	u64 aligned_start;
 	u64 aligned_end;
 
+	ASSERT(is_data_folio(folio));
 	/* The folio flag is set whenever any fixup bitmap bit is. */
 	if (!folio_test_fixup_pending(folio))
 		return;
@@ -636,8 +676,8 @@ void btrfs_folio_clear_fixup_dirty(const struct btrfs_fs_info *fs_info,
 		return;
 	}
 	btrfs_subpage_clamp_range(folio, &start, &len);
-	aligned_start = round_up(start, fs_info->sectorsize);
-	aligned_end = round_down(start + len, fs_info->sectorsize);
+	aligned_start = round_up(start, fs_info->datasize);
+	aligned_end = round_down(start + len, fs_info->datasize);
 	if (aligned_end <= aligned_start)
 		return;
 	if (btrfs_subpage_clear_fixup_dirty(fs_info, folio, aligned_start,
@@ -674,12 +714,12 @@ bool btrfs_subpage_test_##name(const struct btrfs_fs_info *fs_info,	\
 	struct btrfs_folio_state *bfs = folio_get_private(folio);	\
 	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,	\
 						name, start, len);	\
+	unsigned int nbits = subpage_calc_nbits(fs_info, folio, len);	\
 	unsigned long flags;						\
 	bool ret;							\
 									\
-	spin_lock_irqsave(&bfs->lock, flags);			\
-	ret = bitmap_test_range_all_set(bfs->bitmaps, start_bit,	\
-				len >> fs_info->sectorsize_bits);	\
+	spin_lock_irqsave(&bfs->lock, flags);				\
+	ret = bitmap_test_range_all_set(bfs->bitmaps, start_bit, nbits);\
 	spin_unlock_irqrestore(&bfs->lock, flags);			\
 	return ret;							\
 }
@@ -690,8 +730,8 @@ IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(fixup);
 
 /*
  * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
- * in.  We only test sectorsize == PAGE_SIZE cases so far, thus we can fall
- * back to regular sectorsize branch.
+ * in.  We only test datasize == PAGE_SIZE cases so far, thus we can fall
+ * back to regular datasize branch.
  */
 #define IMPLEMENT_BTRFS_PAGE_OPS(name, folio_set_func,			\
 				 folio_clear_func, folio_test_func)	\
@@ -854,7 +894,7 @@ void btrfs_folio_assert_not_dirty(const struct btrfs_fs_info *fs_info,
 	}
 
 	start_bit = subpage_calc_start_bit(fs_info, folio, dirty, start, len);
-	nbits = len >> fs_info->sectorsize_bits;
+	nbits = subpage_calc_nbits(fs_info, folio, len);
 	bfs = folio_get_private(folio);
 	ASSERT(bfs);
 	spin_lock_irqsave(&bfs->lock, flags);
@@ -886,7 +926,7 @@ void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 		return;
 
 	bfs = folio_get_private(folio);
-	nbits = len >> fs_info->sectorsize_bits;
+	nbits = subpage_calc_nbits(fs_info, folio, len);
 	spin_lock_irqsave(&bfs->lock, flags);
 	ret = atomic_add_return(nbits, &bfs->nr_locked);
 	ASSERT(ret <= btrfs_blocks_per_folio(fs_info, folio));
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 9b106a73d682..10c0d4b670f2 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -100,7 +100,7 @@ static inline bool btrfs_is_subpage(const struct btrfs_fs_info *fs_info,
 {
 	if (folio->mapping && folio->mapping->host)
 		ASSERT(is_data_inode(BTRFS_I(folio->mapping->host)));
-	return fs_info->sectorsize < folio_size(folio);
+	return fs_info->datasize < folio_size(folio);
 }
 
 int btrfs_attach_folio_state(const struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..5b5e0667c18b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -729,10 +729,10 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
  */
 void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 {
-	if (fs_info->sectorsize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+	if (fs_info->datasize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
 		btrfs_info(fs_info,
 			   "forcing free space tree for sector size %u with page size %lu",
-			   fs_info->sectorsize, PAGE_SIZE);
+			   fs_info->datasize, PAGE_SIZE);
 		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
 		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
 	}
@@ -1725,7 +1725,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_used = 0;
 	u64 total_free_data = 0;
 	u64 total_free_meta = 0;
-	u32 bits = fs_info->sectorsize_bits;
+	u32 bits = fs_info->datasize_bits;
 	__be32 *fsid;
 	unsigned factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
@@ -1811,7 +1811,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		buf->f_bavail = 0;
 
 	buf->f_type = BTRFS_SUPER_MAGIC;
-	buf->f_bsize = fs_info->sectorsize;
+	buf->f_bsize = fs_info->datasize;
 	buf->f_namelen = BTRFS_NAME_LEN;
 
 	/*
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index dbd99f8b6698..277d2f4cc12a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1022,7 +1022,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->datasize);
 }
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
@@ -1082,7 +1082,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
 
-	return sysfs_emit(buf, "%u\n", fs_info->sectorsize);
+	return sysfs_emit(buf, "%u\n", fs_info->datasize);
 }
 
 BTRFS_ATTR(, clone_alignment, btrfs_clone_alignment_show);
@@ -1329,7 +1329,7 @@ static ssize_t btrfs_read_policy_store(struct kobject *kobj,
 
 	if (index == BTRFS_READ_POLICY_RR) {
 		if (value != -1) {
-			const u32 sectorsize = fs_devices->fs_info->sectorsize;
+			const u32 sectorsize = fs_devices->fs_info->datasize;
 
 			if (!IS_ALIGNED(value, sectorsize)) {
 				u64 temp_value = round_up(value, sectorsize);
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 6287d940323d..d56f2cebfd6f 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -138,8 +138,8 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
 	btrfs_init_fs_info(fs_info);
 
 	fs_info->nodesize = nodesize;
-	fs_info->sectorsize = sectorsize;
-	fs_info->sectorsize_bits = ilog2(sectorsize);
+	fs_info->datasize = sectorsize;
+	fs_info->datasize_bits = ilog2(sectorsize);
 
 	/* CRC32C csum size. */
 	fs_info->csum_size = 4;
@@ -217,7 +217,7 @@ btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_info,
 
 	cache->start = 0;
 	cache->length = length;
-	cache->full_stripe_len = fs_info->sectorsize;
+	cache->full_stripe_len = fs_info->datasize;
 	cache->fs_info = fs_info;
 
 	INIT_LIST_HEAD(&cache->list);
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 8dee057f41fd..191444addf7d 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -68,7 +68,7 @@ static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 					i++;
 				}
 				prev_bit = bit;
-				offset += fs_info->sectorsize;
+				offset += fs_info->datasize;
 			}
 		}
 		if (prev_bit == 1) {
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7ca904f96621..49156a6f8ecf 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -126,7 +126,7 @@ static u64 file_extent_end(struct extent_buffer *leaf,
 
 	if (btrfs_file_extent_type(leaf, extent) == BTRFS_FILE_EXTENT_INLINE) {
 		len = btrfs_file_extent_ram_bytes(leaf, extent);
-		end = ALIGN(key->offset + len, leaf->fs_info->sectorsize);
+		end = ALIGN(key->offset + len, leaf->fs_info->datasize);
 	} else {
 		len = btrfs_file_extent_num_bytes(leaf, extent);
 		end = key->offset + len;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7ba7b6098aa5..62f90ccdeef1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -717,7 +717,7 @@ static noinline int replay_one_extent(struct walk_control *wc)
 			nbytes = btrfs_file_extent_num_bytes(wc->log_leaf, item);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		nbytes = btrfs_file_extent_ram_bytes(wc->log_leaf, item);
-		extent_end = ALIGN(start + nbytes, fs_info->sectorsize);
+		extent_end = ALIGN(start + nbytes, fs_info->datasize);
 	} else {
 		btrfs_abort_log_replay(wc, -EUCLEAN,
 		       "unexpected extent type=%d root=%llu inode=%llu offset=%llu",
@@ -2852,7 +2852,7 @@ static int replay_one_buffer(struct extent_buffer *eb,
 					break;
 				}
 				from = ALIGN(i_size_read(&inode->vfs_inode),
-					     root->fs_info->sectorsize);
+					     root->fs_info->datasize);
 				drop_args.start = from;
 				drop_args.end = (u64)-1;
 				drop_args.drop_cache = true;
@@ -5667,7 +5667,7 @@ static int btrfs_log_holes(struct btrfs_trans_handle *trans,
 		u64 hole_len;
 
 		btrfs_release_path(path);
-		hole_len = ALIGN(i_size - prev_extent_end, fs_info->sectorsize);
+		hole_len = ALIGN(i_size - prev_extent_end, fs_info->datasize);
 		ret = btrfs_insert_hole_extent(trans, root->log_root, ino,
 					       prev_extent_end, hole_len);
 		if (ret < 0)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 949e40baff33..540f81c810ea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8359,7 +8359,7 @@ int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
-	u32 writeback_bio_size = fs_info->sectorsize;
+	u32 writeback_bio_size = fs_info->datasize;
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	/*
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 486b52db583e..e1e077c64917 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -90,8 +90,8 @@ struct list_head *zlib_alloc_workspace(struct btrfs_fs_info *fs_info, unsigned i
 		workspace->buf_size = ZLIB_DFLTCC_BUF_SIZE;
 	}
 	if (!workspace->buf) {
-		workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
-		workspace->buf_size = fs_info->sectorsize;
+		workspace->buf = kmalloc(fs_info->datasize, GFP_KERNEL);
+		workspace->buf_size = fs_info->datasize;
 	}
 	if (!workspace->strm.workspace || !workspace->buf)
 		goto fail;
@@ -238,7 +238,7 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 		}
 
 		/* We're making it bigger, give up. */
-		if (workspace->strm.total_in > fs_info->sectorsize * 2 &&
+		if (workspace->strm.total_in > fs_info->datasize * 2 &&
 		    workspace->strm.total_in < workspace->strm.total_out) {
 			ret = -E2BIG;
 			goto out;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9d448cdd60c4..4569c818cbdf 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -780,7 +780,7 @@ int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info)
 		min3((u64)lim->max_zone_append_sectors << SECTOR_SHIFT,
 		     (u64)lim->max_sectors << SECTOR_SHIFT,
 		     (u64)lim->max_segments << PAGE_SHIFT),
-		fs_info->sectorsize);
+		fs_info->datasize);
 	fs_info->fs_devices->chunk_alloc_policy = BTRFS_CHUNK_ALLOC_ZONED;
 
 	fs_info->max_extent_size = min_not_zero(fs_info->max_extent_size,
@@ -2722,7 +2722,7 @@ int btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 leng
 
 	/* No MIXED_BG on zoned btrfs. */
 	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
-		min_alloc_bytes = fs_info->sectorsize;
+		min_alloc_bytes = fs_info->datasize;
 	else
 		min_alloc_bytes = fs_info->nodesize;
 
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index cb15cbd737c4..d23ac367a0a3 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -391,7 +391,7 @@ struct list_head *zstd_alloc_workspace(struct btrfs_fs_info *fs_info, int level)
 	workspace->req_level = level;
 	workspace->last_used = jiffies;
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL | __GFP_NOWARN);
-	workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
+	workspace->buf = kmalloc(fs_info->datasize, GFP_KERNEL);
 	if (!workspace->mem || !workspace->buf)
 		goto fail;
 
@@ -470,7 +470,7 @@ int zstd_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 		}
 
 		/* Check to see if we are making it bigger. */
-		if (tot_in + workspace->in_buf.pos > fs_info->sectorsize * 2 &&
+		if (tot_in + workspace->in_buf.pos > fs_info->datasize * 2 &&
 		    tot_in + workspace->in_buf.pos < tot_out + workspace->out_buf.pos) {
 			ret = -E2BIG;
 			goto out;
@@ -626,7 +626,7 @@ int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 
 	workspace->out_buf.dst = workspace->buf;
 	workspace->out_buf.pos = 0;
-	workspace->out_buf.size = fs_info->sectorsize;
+	workspace->out_buf.size = fs_info->datasize;
 
 	while (1) {
 		size_t ret2;
@@ -711,7 +711,7 @@ int zstd_decompress(struct list_head *ws, const u8 *data_in,
 
 	workspace->out_buf.dst = workspace->buf;
 	workspace->out_buf.pos = 0;
-	workspace->out_buf.size = fs_info->sectorsize;
+	workspace->out_buf.size = fs_info->datasize;
 
 	/*
 	 * Since both input and output buffers should not exceed one sector,
-- 
2.55.0

