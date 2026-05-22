Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561133E351
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779473660; cv=none; b=TQzNbVsgSfFU4T9QFQo79BUCvyHumCmj5PFt3DRxuPAkwMtXDo8jggtsIChed6+ziKZ/QTTnIEp9U4cZgCxK9SHFgLzrxRYug6/J1upLHiVylPOOFE2rETGXWQgA2oornEBbP7++oc2DvEpzrSXi/YPzcuf3WT1eqRM6ShdorSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779473660; c=relaxed/simple;
	bh=FlCqrdWKZ+IZ0HWDe5qrhpKH5cbdzZQQvqcz4QbQ9/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRZjEWy4k9l371BTHedLVm/dvx9UlexW4xK3lVTdrfanQQ2LjoRW5LmE/Mt/soSqtNKicp15HsJQ80I4xbf36hpXsGKkksvh2Gq9YqceQNv4mQ95ItRU5HSL5eoSYeold4E0RhzBk1XdKupu4JEROAvLuYO7dkipt9svSVqwQbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cVOCGNUK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cVOCGNUK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oa/91rneWvLKme8hXIT14NiyU9NjROoKA8H3J1mTu1o=; b=cVOCGNUKL3OIMHi/1FMUMNqUBx
	ZKtdSU/SSekaTAbuj9Ru8p04Hxpeoa3sfBBr7NYzvZVitbojGlU1w/9bGrLFAaBPHWBA8d1Af6YkH
	zZAMwHXq9QBuE17XfLZQaH3tHLAFGY7nxvSjJAdBzvVUsSSCB7LaO5pKsNETNhjfm2/CAPOsx4oYY
	fEMpZ+jRfWp/O8eAuj0SwAx3f878zUzOTR+zAQUZULZlIIE3E9l6ECxGexbF8cIEGEHRbnYhbGgkk
	vNhBu08RqFXrG+NatpTjzjbM+zJrW0DL2nZTD7DTsbfc89QR1IPYEs1jPbAbDLJU5iWKtOZJU21Ya
	Wnpe+Tcw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUNw-0000000ARAx-44KU;
	Fri, 22 May 2026 18:14:13 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Chris Mason <clm@fb.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 1/3] Revert "btrfs: fix the file offset calculation inside btrfs_decompress_buf2page()"
Date: Fri, 22 May 2026 19:14:07 +0100
Message-ID: <20260522181411.2487732-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems that af566bdaff54 was tested against a tree which did not
contain commit 12851bd921d4 ("fs: Turn page_offset() into a wrapper
around folio_pos()).  Unfortunately it has a bug of its own; on 32-bit
systems, shifting by PAGE_SHIFT will overflow on files larger than 4GiB.
Since page_offset() is now fixed, just revert af566bdaff54.

Fixes: af566bdaff54 (btrfs: fix the file offset calculation inside btrfs_decompress_buf2page())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/compression.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index a02b62e0a8f3..2ceb5661e071 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1191,22 +1191,6 @@ void __cold btrfs_exit_compress(void)
 	bioset_exit(&btrfs_compressed_bioset);
 }
 
-/*
- * The bvec is a single page bvec from a bio that contains folios from a filemap.
- *
- * Since the folio may be a large one, and if the bv_page is not a head page of
- * a large folio, then page->index is unreliable.
- *
- * Thus we need this helper to grab the proper file offset.
- */
-static u64 file_offset_from_bvec(const struct bio_vec *bvec)
-{
-	const struct page *page = bvec->bv_page;
-	const struct folio *folio = page_folio(page);
-
-	return (page_pgoff(folio, page) << PAGE_SHIFT) + bvec->bv_offset;
-}
-
 /*
  * Copy decompressed data from working buffer to pages.
  *
@@ -1259,7 +1243,7 @@ int btrfs_decompress_buf2page(const char *buf, u32 buf_len,
 		 * cb->start may underflow, but subtracting that value can still
 		 * give us correct offset inside the full decompressed extent.
 		 */
-		bvec_offset = file_offset_from_bvec(&bvec) - cb->start;
+		bvec_offset = page_offset(bvec.bv_page) + bvec.bv_offset - cb->start;
 
 		/* Haven't reached the bvec range, exit */
 		if (decompressed + buf_len <= bvec_offset)
-- 
2.47.3

