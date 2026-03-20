Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AEB2F1FD7
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 07:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773992110; cv=none; b=tNB2gxpcJnHoyJpYX60X6s5N94p2M34YpOPhkBvqdrPfdWmJn2E1VYFcT3Knse2HdGgcLFq+5I39eVcCb7BSOCV3x/RZJeAQ+wcRhBT3yQoqQ1BmyylqK4aIoMX+6ad2iYYYoBBsTrizFxW0mxk+sHL8uDbpjQwhscXhbs3obGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773992110; c=relaxed/simple;
	bh=thDjnjdNu+5iWF09SOGTMsMKkRjvBwmTq8SxD+ziDLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gitjGYOTW0UDFGfqShANG5T0KJ2C6jhfxAUY6Qtwl61v9t2XrGj3zNbw5z+4SAcF48l3d29QKatH/Ev6b501yz9kM5T+/EZZ5OPQBJrxoMpF8mMbUhhd9QvVWBg8pZw0TboWUJJ+KWaPhFry0qb6NBociEEsV9BvD/8L5SvAVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WH/i4bP9; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WH/i4bP9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773992107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5NcMX3U97+2T5jAjKi8wy9L7gl1/+Vawrd83aF+XYo=;
	b=WH/i4bP9oSPcXZSzRJfVSF0ytqXTQ/VeTK8LGZ0DObLZDVRMuUsAlVofdj5Tng5lyKoykM
	fmFlUxsvGzHRPg6OaQePucCnUue7/zqIUx2WhVeLZpMaLNH7elEjx/Enenmg4TpXKBSFG2
	9PP+3JjIw7+plHJ789HAHo1R9cS3QsY=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: boris@bur.io,
	mark@harmstone.com,
	clm@fb.com,
	wqu@suse.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-team@meta.com
Subject: [PATCH 2/2] btrfs: prevent direct reclaim during compressed readahead
Date: Fri, 20 Mar 2026 00:34:45 -0700
Message-ID: <20260320073445.80218-3-jp.kobryn@linux.dev>
In-Reply-To: <20260320073445.80218-1-jp.kobryn@linux.dev>
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prevent direct reclaim during compressed readahead. This is achieved by
passing specific GFP flags whenever the bio is marked for readahead. The
flags are similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM. Also,
__GFP_NOWARN is added since these allocations are allowed to fail. Demand
reads still use full GFP_NOFS and will enter reclaim if needed.

btrfs_submit_compressed_read() now makes use of the new gfp_t API for
allocations within. Since non-readahead code may call this function, the
bio flags are inspected to determine whether direct reclaim should be
restricted or not.

add_ra_bio_pages() gains a bool parameter which allows callers to specify
if they want to allow direct reclaim or not. In either case, the NOWARN
flag was added unconditionally since the allocations are speculative.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
 fs/btrfs/compression.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ae9cb5b7676c..f32cfc933bee 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -372,7 +372,8 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
 static noinline int add_ra_bio_pages(struct inode *inode,
 				     u64 compressed_end,
 				     struct compressed_bio *cb,
-				     int *memstall, unsigned long *pflags)
+				     int *memstall, unsigned long *pflags,
+				     bool direct_reclaim)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	pgoff_t end_index;
@@ -380,6 +381,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	u64 cur = cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
 	u64 isize = i_size_read(inode);
 	int ret;
+	gfp_t constraint_gfp, cache_gfp;
 	struct folio *folio;
 	struct extent_map *em;
 	struct address_space *mapping = inode->i_mapping;
@@ -409,6 +411,14 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 	end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
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
@@ -438,12 +448,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
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
@@ -536,6 +547,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	unsigned int compressed_len;
 	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
 	u64 file_offset = bbio->file_offset;
+	gfp_t gfp;
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
@@ -543,6 +555,17 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
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
@@ -573,7 +596,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 		struct folio *folio;
 		u32 cur_len = min(compressed_len - i * min_folio_size, min_folio_size);
 
-		folio = btrfs_alloc_compr_folio(fs_info);
+		folio = btrfs_alloc_compr_folio_gfp(fs_info, gfp);
 		if (!folio) {
 			ret = -ENOMEM;
 			goto out_free_bio;
@@ -589,7 +612,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
 
 	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
-			 &pflags);
+			 &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
 
 	cb->len = bbio->bio.bi_iter.bi_size;
 	cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;
-- 
2.52.0

