Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3CC314A86
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774734411; cv=none; b=OCstz7H+50AjtSRjqQslc7I4yB6BxJAIKtHDEYBexB7t5TsyLAE/pcHluN6Y3m0O2vnUHT9xv/orrpUkIUzJH3/1A+aSRiu7d2F2L42mbXCH2ueVVnWLEprx21HTBcEKQYN3vGpTzqq83D+AZ7SO/v0ZWwpQwYO9o1LVUaRaaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774734411; c=relaxed/simple;
	bh=RT6QV6fWJDa3Sj1M7b3c4lv+SBuO/hqs792c9v2flTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lW42helsZhVXrElFG9/v44gjO7mViHk2fc5TiJPSiqbPytrD3sXlDUmcrRdvysbcfZon1ziVdcoBSN+VkdTWzMElahpkTUK7iGoVWQ5R01p8Vo5qd0Cq6Yxr0V/NGTZ7lAew0Myki/atJmOKF5P0MoRDwy9FUjlhGxIR7IhOytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tFxrO+vH; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tFxrO+vH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774734397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CkEUN9AatbQu3T+a5tdpHck772+m/Kd+inu80apty1k=;
	b=tFxrO+vHXKNTvnVocjpXgPCTaSr2lVVW2oRRnDgxOs7uacUikiecQcBz5lY9DRyQnQDNhD
	v76NjtfwKt+BhJXTaawDe9yvcwTCoq3OTA0C4mLTjcnBf8X1xjFsgaokJ3Bixya0h4PR3u
	BRL5kpN72gw9xvDpsg5tDgv1EEzjAYs=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: mark@harmstone.com,
	boris@bur.io,
	wqu@suse.com,
	dsterba@suse.com,
	clm@fb.com,
	linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-team@meta.com
Subject: [RESEND PATCH v2] btrfs: prevent direct reclaim during compressed readahead
Date: Sat, 28 Mar 2026 14:46:19 -0700
Message-ID: <20260328214619.114790-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Under memory pressure, direct reclaim can kick in during compressed
readahead. This puts the associated task into D-state. Then shrink_lruvec()
disables interrupts when acquiring the LRU lock. Under heavy pressure,
we've observed reclaim can run long enough that the CPU becomes prone to
CSD lock stalls since it cannot service incoming IPIs. Although the CSD
lock stalls are the worst case scenario, we have found many more subtle
occurrences of this latency on the order of seconds, over a minute in some
cases.

Prevent direct reclaim during compressed readahead. This is achieved by
using different GFP flags at key points when the bio is marked for
readahead.

There are two functions that allocate during compressed readahead:
btrfs_alloc_compr_folio() and add_ra_bio_pages(). Both currently use
GFP_NOFS which includes __GFP_DIRECT_RECLAIM.

For the internal API call btrfs_alloc_compr_folio(), the signature changes
to accept an additional gfp_t parameter. At the readahead call site, it
gets flags similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.
__GFP_NOWARN is added since these allocations are allowed to fail. Demand
reads still use full GFP_NOFS and will enter reclaim if needed. All other
existing call sites of btrfs_alloc_compr_folio() now explicitly pass
GFP_NOFS to retain their current behavior.

add_ra_bio_pages() gains a bool parameter which allows callers to specify
if they want to allow direct reclaim or not. In either case, the
__GFP_NOWARN flag was added unconditionally since the allocations are
speculative.

There has been some previous work done on calling add_ra_bio_pages() [0].
This patch is complementary: where that patch reduces call frequency, this
patch reduces the latency associated with those calls.

[0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a8eadba64.1751492111.git.boris@bur.io/

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Mark Harmstone <mark@harmstone.com>
---
v2:
 - dropped patch 1/2, squashed into single patch based on David's feedback
 - changed btrfs_alloc_compr_folio() signature instead of new _gfp variant
 - update other existing callers to pass GFP_NOFS explicitly

v1: https://lore.kernel.org/linux-btrfs/20260320073445.80218-1-jp.kobryn@linux.dev/

 fs/btrfs/compression.c | 42 +++++++++++++++++++++++++++++++++++-------
 fs/btrfs/compression.h |  2 +-
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/lzo.c         |  6 +++---
 fs/btrfs/zlib.c        |  6 +++---
 fs/btrfs/zstd.c        |  6 +++---
 6 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e897342bece1f..8f33ef48b501e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -180,7 +180,7 @@ static unsigned long btrfs_compr_pool_scan(struct shrinker *sh, struct shrink_co
 /*
  * Common wrappers for page allocation from compression wrappers
  */
-struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
+struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp)
 {
 	struct folio *folio = NULL;
 
@@ -200,7 +200,7 @@ struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
 		return folio;
 
 alloc:
-	return folio_alloc(GFP_NOFS, fs_info->block_min_order);
+	return folio_alloc(gfp, fs_info->block_min_order);
 }
 
 void btrfs_free_compr_folio(struct folio *folio)
@@ -368,7 +368,8 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
 static noinline int add_ra_bio_pages(struct inode *inode,
 				     u64 compressed_end,
 				     struct compressed_bio *cb,
-				     int *memstall, unsigned long *pflags)
+				     int *memstall, unsigned long *pflags,
+				     bool direct_reclaim)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	pgoff_t end_index;
@@ -376,6 +377,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	u64 cur = cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
 	u64 isize = i_size_read(inode);
 	int ret;
+	gfp_t constraint_gfp, cache_gfp;
 	struct folio *folio;
 	struct extent_map *em;
 	struct address_space *mapping = inode->i_mapping;
@@ -405,6 +407,19 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 	end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
+	/*
+	 * Avoid direct reclaim when the caller does not allow it.
+	 * Since add_ra_bio_pages is always speculative, suppress
+	 * allocation warnings in either case.
+	 */
+	if (!direct_reclaim) {
+		constraint_gfp = ~(__GFP_FS | __GFP_DIRECT_RECLAIM);
+		cache_gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
+	} else {
+		constraint_gfp = ~__GFP_FS;
+		cache_gfp = GFP_NOFS | __GFP_NOWARN;
+	}
+
 	while (cur < compressed_end) {
 		pgoff_t page_end;
 		pgoff_t pg_index = cur >> PAGE_SHIFT;
@@ -434,12 +449,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			continue;
 		}
 
-		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, ~__GFP_FS),
+		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
+					    constraint_gfp) | __GFP_NOWARN,
 					    0, NULL);
 		if (!folio)
 			break;
 
-		if (filemap_add_folio(mapping, folio, pg_index, GFP_NOFS)) {
+		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
 			/* There is already a page, skip to page end */
 			cur += folio_size(folio);
 			folio_put(folio);
@@ -532,6 +548,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	unsigned int compressed_len;
 	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
 	u64 file_offset = bbio->file_offset;
+	gfp_t gfp;
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
@@ -539,6 +556,17 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	int memstall = 0;
 	int ret;
 
+	/*
+	 * If this is a readahead bio, prevent direct reclaim. This is done to
+	 * avoid stalling on speculative allocations when memory pressure is
+	 * high. The demand fault will retry with GFP_NOFS and enter direct
+	 * reclaim if needed.
+	 */
+	if (bbio->bio.bi_opf & REQ_RAHEAD)
+		gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
+	else
+		gfp = GFP_NOFS;
+
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
 	em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
@@ -569,7 +597,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 		struct folio *folio;
 		u32 cur_len = min(compressed_len - i * min_folio_size, min_folio_size);
 
-		folio = btrfs_alloc_compr_folio(fs_info);
+		folio = btrfs_alloc_compr_folio(fs_info, gfp);
 		if (!folio) {
 			ret = -ENOMEM;
 			goto out_free_bio;
@@ -585,7 +613,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
 
 	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
-			 &pflags);
+			 &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
 
 	cb->len = bbio->bio.bi_iter.bi_size;
 	cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 973530e9ce6c2..1022dc53ec51e 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -98,7 +98,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio);
 
 int btrfs_compress_str2level(unsigned int type, const char *str, int *level_ret);
 
-struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info);
+struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gfp_t gfp);
 void btrfs_free_compr_folio(struct folio *folio);
 
 struct workspace_manager {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8d97a8ad3858b..2d2fce77aec21 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9980,7 +9980,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		size_t bytes = min(min_folio_size, iov_iter_count(from));
 		char *kaddr;
 
-		folio = btrfs_alloc_compr_folio(fs_info);
+		folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 		if (!folio) {
 			ret = -ENOMEM;
 			goto out_cb;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0c90937707395..4662c5c06eae9 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -218,7 +218,7 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 	ASSERT((old_size >> sectorsize_bits) == (old_size + LZO_LEN - 1) >> sectorsize_bits);
 
 	if (!*out_folio) {
-		*out_folio = btrfs_alloc_compr_folio(fs_info);
+		*out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 		if (!*out_folio)
 			return -ENOMEM;
 	}
@@ -245,7 +245,7 @@ static int copy_compressed_data_to_bio(struct btrfs_fs_info *fs_info,
 			return -E2BIG;
 
 		if (!*out_folio) {
-			*out_folio = btrfs_alloc_compr_folio(fs_info);
+			*out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 			if (!*out_folio)
 				return -ENOMEM;
 		}
@@ -296,7 +296,7 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	ASSERT(bio->bi_iter.bi_size == 0);
 	ASSERT(len);
 
-	folio_out = btrfs_alloc_compr_folio(fs_info);
+	folio_out = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 	if (!folio_out)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 147c92a4dd04c..145ead5be1c06 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -175,7 +175,7 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	workspace->strm.total_in = 0;
 	workspace->strm.total_out = 0;
 
-	out_folio = btrfs_alloc_compr_folio(fs_info);
+	out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 	if (out_folio == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -258,7 +258,7 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 				goto out;
 			}
 
-			out_folio = btrfs_alloc_compr_folio(fs_info);
+			out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 			if (out_folio == NULL) {
 				ret = -ENOMEM;
 				goto out;
@@ -296,7 +296,7 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 				goto out;
 			}
 			/* Get another folio for the stream end. */
-			out_folio = btrfs_alloc_compr_folio(fs_info);
+			out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 			if (out_folio == NULL) {
 				ret = -ENOMEM;
 				goto out;
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 41547ff187f65..080b29fe515c6 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -439,7 +439,7 @@ int zstd_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 	workspace->in_buf.size = btrfs_calc_input_length(in_folio, end, start);
 
 	/* Allocate and map in the output buffer. */
-	out_folio = btrfs_alloc_compr_folio(fs_info);
+	out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 	if (out_folio == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -482,7 +482,7 @@ int zstd_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 				goto out;
 			}
 
-			out_folio = btrfs_alloc_compr_folio(fs_info);
+			out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 			if (out_folio == NULL) {
 				ret = -ENOMEM;
 				goto out;
@@ -555,7 +555,7 @@ int zstd_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 			ret = -E2BIG;
 			goto out;
 		}
-		out_folio = btrfs_alloc_compr_folio(fs_info);
+		out_folio = btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
 		if (out_folio == NULL) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.52.0

