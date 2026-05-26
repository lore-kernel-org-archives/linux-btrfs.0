Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FB983A14;
	Tue, 26 May 2026 22:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779835100; cv=none; b=jkThqZSB+Lfyl3gnvnqeonMf4sG++9EbhrrQT2ErO82COawUZZcQi5No+Ue/N4IbPaNu1+5s+0bVO/ug4gWIuVmT1DWoaQO64hxQLLea2NBaTA3753wguhisoJcMB3efLsYTqsNHZQWnLzOQT6aL0Xbch9iLDPzv84WRTT8dVEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779835100; c=relaxed/simple;
	bh=RuUubhEqZiPxmOYT0zJ7gBpEgU2HVWDFaoDLcrBkPR4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=XIvnuAEp2yAJka+EnurLhDjpzMbhT8qId6Gi+eOpw5PrCfFBVuOaADLA0ZkJ8PUU0qmQCuhRBOJlIGYWAP8U1YHwohGLNJK/jJAmbrdeVaLGXZ5PWBUuLMkeCM/BxqxIX0FSsfNIK1mTZybofTitaokzJOIVDNYUOWEVeMJ9iDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=abBhKs0V; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="abBhKs0V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uWmi03TB0GBEII3plN7oGGBixiuBlNSlIQ+upsHcypE=; b=abBhKs0VXMI99JtTCuaGsoaiVt
	9XGvaSZmYdJ5fi8QwEKVIYGhfb2WFx33xwqMaLg0DRQYNPg2w0nBeEERCKVYL9xEUEfEWxPvAVG6y
	V+QEOxmMdOQVsE8yNFkCd6EdIk295bilzjVGWuow+7bZ4+hlhxTZQH02mZxYRp1fvIFoZmqNJsfrW
	AImM3e2DNWEDlz7SzxOum7me2wLpEj5yk5WZYbIlK08I3ZThec4rxFfL0dG6CSXpcQoiGyRsxl+Yu
	KGlL7iql15HzigZ3lvXJzbjh8To6gFYDTwX9VgyGjJX2pctJnccWO8ehoqPOTQZACYbJDoEY4JPfo
	5/U9zytw==;
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wS0P6-000000004kP-02V7;
	Tue, 26 May 2026 18:37:40 -0400
Date: Tue, 26 May 2026 18:37:39 -0400
From: Rik van Riel <riel@surriel.com>
To: David Sterba <dsterba@suse.cz>
Cc: Boris Burkov <boris@bur.io>, Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>,
 hannes@cmpxchg.org, usama.arif@linux.dev, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: allocate eb-attached btree pages as movable
Message-ID: <20260526183739.270a5387@fangorn>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Extent buffer pages allocated by alloc_extent_buffer() are attached to
btree_inode->i_mapping (the buffer_tree path), reach the LRU, and are
served by the btree_migrate_folio aops in fs/btrfs/disk-io.c. They are
migratable in practice once their owning extent buffer hits refs == 1,
which happens naturally. The buddy allocator classifies them by GFP, 
however, and bare GFP_NOFS lands them in MIGRATE_UNMOVABLE pageblocks. 
The result: every btree_inode page we read in pins an unmovable pageblock 
from the page-superblock allocator's perspective, even though the page 
itself can be moved.

Have each caller of btrfs_alloc_page_array, btrfs_alloc_folio_array,
and alloc_eb_folio_array pass in the full GFP mask directly, instead
of having the functions calculate it from boolean flags.

The alloc_extent_buffer call site passes GFP_NOFS | __GFP_NOFAIL |
__GFP_MOVABLE. All other call sites pass plain GFP_NOFS.

Three categories of caller stay on bare GFP_NOFS, deliberately:

  - alloc_dummy_extent_buffer / btrfs_clone_extent_buffer: the
    resulting eb is EXTENT_BUFFER_UNMAPPED, folio->mapping stays NULL,
    the folios never enter LRU, never get migrate_folio aops. Tagging
    them __GFP_MOVABLE would violate the page allocator's migrability
    contract and they would defeat compaction in MOVABLE pageblocks
    where isolate_migratepages_block skips non-LRU non-movable_ops
    pages outright.

  - btrfs_alloc_page_array callers in fs/btrfs/raid56.c (stripe
    pages), fs/btrfs/inode.c (encoded reads), fs/btrfs/ioctl.c (uring
    encoded reads), fs/btrfs/relocation.c (relocation buffers): same
    contract violation. raid56 stripe_pages additionally persist in
    the stripe cache (RBIO_CACHE_SIZE=1024) well beyond a single I/O,
    so they are not transient enough to hand-wave the contract.

  - btrfs_alloc_folio_array caller in fs/btrfs/scrub.c (stripe
    folios): same -- stripe->folios[] are private buffers freed via
    folio_put in release_scrub_stripe.

This change targets the dominant fragmentation source observed on the
page-superblock series: ~28 GB of btree_inode pages parked across
many tainted superpageblocks on a 250 GB test system with btrfs root,
preventing 1 GiB hugepage allocation from those regions. With the
movable hint, those pages now land in MOVABLE pageblocks where the
existing background defragger drains them through the standard
PB_has_movable gate, no LRU-sample fallback needed.

Cc: Chris Mason <clm@meta.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4-6
---
v2: pass the gfp mask directly to each function from the callers (thanks Boris)

 fs/btrfs/extent_io.c  | 43 +++++++++++++++++++++++--------------------
 fs/btrfs/extent_io.h  |  4 ++--
 fs/btrfs/inode.c      |  2 +-
 fs/btrfs/ioctl.c      |  2 +-
 fs/btrfs/raid56.c     |  6 +++---
 fs/btrfs/relocation.c |  2 +-
 fs/btrfs/scrub.c      |  3 ++-
 7 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2275189b7860..ccc2d174b919 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -620,24 +620,24 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 }
 
 /*
- * Populate every free slot in a provided array with folios using GFP_NOFS.
+ * Populate every free slot in a provided array with folios.
  *
- * @nr_folios:   number of folios to allocate
- * @order:	 the order of the folios to be allocated
- * @folio_array: the array to fill with folios; any existing non-NULL entries in
- *		 the array will be skipped
+ * @nr_folios:    number of folios to allocate
+ * @order:	  folio order
+ * @folio_array:  array to fill with folios; non-NULL entries are skipped
+ * @gfp:          GFP flags for the allocation
  *
  * Return: 0        if all folios were able to be allocated;
  *         -ENOMEM  otherwise, the partially allocated folios would be freed and
  *                  the array slots zeroed
  */
 int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
-			    struct folio **folio_array)
+			    struct folio **folio_array, gfp_t gfp)
 {
 	for (int i = 0; i < nr_folios; i++) {
 		if (folio_array[i])
 			continue;
-		folio_array[i] = folio_alloc(GFP_NOFS, order);
+		folio_array[i] = folio_alloc(gfp, order);
 		if (!folio_array[i])
 			goto error;
 	}
@@ -652,21 +652,19 @@ int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
 }
 
 /*
- * Populate every free slot in a provided array with pages, using GFP_NOFS.
+ * Populate every free slot in a provided array with pages.
  *
- * @nr_pages:   number of pages to allocate
- * @page_array: the array to fill with pages; any existing non-null entries in
- *		the array will be skipped
- * @nofail:	whether using __GFP_NOFAIL flag
+ * @nr_pages:    number of pages to allocate
+ * @page_array:  array to fill; non-NULL entries are skipped
+ * @gfp:         GFP flags for the allocation
  *
  * Return: 0        if all pages were able to be allocated;
  *         -ENOMEM  otherwise, the partially allocated pages would be freed and
  *                  the array slots zeroed
  */
 int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
-			   bool nofail)
+			   gfp_t gfp)
 {
-	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
 	unsigned int allocated;
 
 	for (allocated = 0; allocated < nr_pages;) {
@@ -690,13 +688,13 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
  *
  * For now, the folios populated are always in order 0 (aka, single page).
  */
-static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
+static int alloc_eb_folio_array(struct extent_buffer *eb, gfp_t gfp)
 {
 	struct page *page_array[INLINE_EXTENT_BUFFER_PAGES] = { 0 };
 	int num_pages = num_extent_pages(eb);
 	int ret;
 
-	ret = btrfs_alloc_page_array(num_pages, page_array, nofail);
+	ret = btrfs_alloc_page_array(num_pages, page_array, gfp);
 	if (ret < 0)
 		return ret;
 
@@ -3097,7 +3095,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src)
 	 */
 	set_bit(EXTENT_BUFFER_UNMAPPED, &new->bflags);
 
-	ret = alloc_eb_folio_array(new, false);
+	ret = alloc_eb_folio_array(new, GFP_NOFS);
 	if (ret)
 		goto release_eb;
 
@@ -3138,7 +3136,7 @@ struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (!eb)
 		return NULL;
 
-	ret = alloc_eb_folio_array(eb, false);
+	ret = alloc_eb_folio_array(eb, GFP_NOFS);
 	if (ret)
 		goto release_eb;
 
@@ -3491,8 +3489,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	}
 
 reallocate:
-	/* Allocate all pages first. */
-	ret = alloc_eb_folio_array(eb, true);
+	/*
+	 * Allocate all pages first. These will be attached to
+	 * btree_inode->i_mapping below (added to LRU, served by
+	 * btree_migrate_folio), so request __GFP_MOVABLE so the
+	 * page allocator places them in MOVABLE pageblocks.
+	 */
+	ret = alloc_eb_folio_array(eb, GFP_NOFS | __GFP_NOFAIL | __GFP_MOVABLE);
 	if (ret < 0) {
 		btrfs_free_folio_state(prealloc);
 		goto out;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b310a5145cf6..c53e7f8f3c86 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -387,9 +387,9 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
 
 int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
-			   bool nofail);
+			   gfp_t gfp);
 int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
-			    struct folio **folio_array);
+			    struct folio **folio_array, gfp_t gfp);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 bool find_lock_delalloc_range(struct inode *inode,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 906d5c21ebc4..e55c416f048d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9659,7 +9659,7 @@ ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *iter,
 	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
 	if (!pages)
 		return -ENOMEM;
-	ret = btrfs_alloc_page_array(nr_pages, pages, false);
+	ret = btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
 	if (ret) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a39460bf68a7..c4ec6109952a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4621,7 +4621,7 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
 	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
 	if (!pages)
 		return -ENOMEM;
-	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
+	ret = btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
 	if (ret) {
 		ret = -ENOMEM;
 		goto out_fail;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 08ee8f316d96..fae457712218 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1123,7 +1123,7 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio)
 {
 	int ret;
 
-	ret = btrfs_alloc_page_array(rbio->nr_pages, rbio->stripe_pages, false);
+	ret = btrfs_alloc_page_array(rbio->nr_pages, rbio->stripe_pages, GFP_NOFS);
 	if (ret < 0)
 		return ret;
 	/* Mapping all sectors */
@@ -1138,7 +1138,7 @@ static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
 	int ret;
 
 	ret = btrfs_alloc_page_array(rbio->nr_pages - data_pages,
-				     rbio->stripe_pages + data_pages, false);
+				     rbio->stripe_pages + data_pages, GFP_NOFS);
 	if (ret < 0)
 		return ret;
 
@@ -1732,7 +1732,7 @@ static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
 	const int data_pages = rbio->nr_data * rbio->stripe_npages;
 	int ret;
 
-	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, false);
+	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, GFP_NOFS);
 	if (ret < 0)
 		return ret;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3ebaf5880125..5d090bdcf1fd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4038,7 +4038,7 @@ static int copy_remapped_data(struct btrfs_fs_info *fs_info, u64 old_addr,
 	if (!pages)
 		return -ENOMEM;
 
-	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
+	ret = btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
 	if (ret) {
 		ret = -ENOMEM;
 		goto end;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1ac609239cbe..d2f7ac5b6e96 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -369,7 +369,8 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
 
 	ASSERT(BTRFS_STRIPE_LEN >> min_folio_shift <= SCRUB_STRIPE_MAX_FOLIOS);
 	ret = btrfs_alloc_folio_array(BTRFS_STRIPE_LEN >> min_folio_shift,
-				      fs_info->block_min_order, stripe->folios);
+				      fs_info->block_min_order, stripe->folios,
+				      GFP_NOFS);
 	if (ret < 0)
 		goto error;
 
-- 
2.53.0-Meta

