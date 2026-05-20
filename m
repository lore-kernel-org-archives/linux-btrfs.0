Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39472349AFF;
	Wed, 20 May 2026 17:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299276; cv=none; b=bj+ucid19a1l8umLMlNIIfmxEYZ74EcR6xIDpupxiKV5MIJU44TzWNrvmwG0kMFEvfJmV87ITH/0u4pYX/doQNUy4Qx3n3etfdyx4xQ8GRxFDNw0E6fULBOR6cL++fZ91lb8dVpvVboRxRUj78XY6Ge5T3YZHo0QNzKX0K6o20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299276; c=relaxed/simple;
	bh=2yKnyAZN488LlRyCnRHOL+10+I5ClDvBj3lXa9LWLoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWbd02Lq5J50TNN3AigdfyKBeq5ZeFjkgIJhpfHlskx1sftCCbSRvNnNC+buah9g3kVWzj9S0oxEQk86hMN+ZyhVjzrvaq6m0QyomMmCkhcxt+bhGT3HSW2m3kcFlYtoiard5dr8J+bniB93KA7FJcCe2JUP4klw1FhjGtYLEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=P7p4DOzN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WKqoVTHe; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="P7p4DOzN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WKqoVTHe"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 988241D00058;
	Wed, 20 May 2026 13:47:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 20 May 2026 13:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1779299272;
	 x=1779385672; bh=+I0u7hS0wY60ISgRabGOXhhEPYzNqBSobQ/51ospf94=; b=
	P7p4DOzNQLFY6fuyKSohODfdw7Q6NzBl3hbXXlk9X8q1X1rxOzwRb2h7FWEHUKs8
	8K8Pb0i7s1pQZE/tPhIkwYHesRq1iA4kpXuCxVGsqK2BfGJQvQYtWJdHGAzTgEF0
	+xEzU8yMnfiX2eb8YyUN52o6/UyXijduONu+JR1hgkK4YnedHA+YU4RQIyb5VZuD
	w/YwHrroskMuTYm9V9o0oXM5KmOuOcB0sdMv9OdI52g3P+9TAynGtXt4Z+I/d9uw
	/3oWQBsdjuES1frZ+omnkxyBRsA0fVLuNa8BnWPTVekbk+7tov0MrsvpiLLT9nWf
	6N/fSuKJ3iPXTMFegEWUtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779299272; x=
	1779385672; bh=+I0u7hS0wY60ISgRabGOXhhEPYzNqBSobQ/51ospf94=; b=W
	KqoVTHeIwIoP5hY9AvNB/HmDcUCXjn/blWh42lQTidLMvNDlSzTzPAamFMqoEKkF
	/rsGSLgKL3jnB0zkFcxRb4o7/v+81+9SGUr1pyVIwvKLNfr/VWMydHSDc08kRISX
	ROoa/vHMLq0oR3GQ1gASf77FY8XKT5eOX7WvqROlxTbkX49A6vQdwGj49nMeF/ve
	ze6qpk0m3z62LSB/ZJRmo6RJqS9p4QD519YjivHLW4g1y3xQYtdDlJ+A34XkqNlr
	305HpsegmWjZMQ/+t7YcF7sxf8MJVpFSb1/emRnPkvTBdmFtHaqln/As/tjujnmb
	boXlj65EX3Rjpljo/uo8g==
X-ME-Sender: <xms:x_MNaunAVmDJ_rJV5DPQuLur0I3J_R7I9b8TwXo2PsQw_UDCah0-6w>
    <xme:x_MNagOOQmJEId2rtBYJXImjy6KkScQ4kZz_dSs4AEx_9KY6SJ31ScTZdVLw9TVAq
    z--C2qt0LMvXD01yqd7zFHSGHF2LaUCGdNl_d2aSucxPpad-_ucMv8>
X-ME-Received: <xmr:x_MNaizJd9PF9gnqVdPOxpGmMslpQz5pjhXEu29WJ0aIwPtzFrSoURMoKP2DcKPJCe85vl56oFbk1-bM1AyGU6QaxOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeehvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    elhfdthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprhhivghlsehsuhhrrhhivghlrdgtohhmpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghl
    qdhtvggrmhesmhgvthgrrdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtg
    hkrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhmpdhrtghpthhtohephhgrnhhnvghssegtmhhpgigthhhgrdho
    rhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:x_MNattTtWBx2Q49dMijQFU63q35L-iuEMeiN2rwCCZf57c2l31jrA>
    <xmx:x_MNalZ7muIE8tUQ10H3qpkM9OkRgeyukSrKa5ZrGO3eVY-CVZc16g>
    <xmx:x_MNas06iMHElWg-rtvkHBT_c0mYqw473d6Dlpd4UxZ_x1TrN2Uvbg>
    <xmx:x_MNanuntCcj0LzjTMsT2M2NntcAVFcb7IJluhAYKq9cRtag_F4DQQ>
    <xmx:yPMNamvtAHbksNeqU8lU99qInmX1cbKIKqTG0KJ_o3KygmcIGf0CBogn>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 May 2026 13:47:50 -0400 (EDT)
Date: Wed, 20 May 2026 10:47:49 -0700
From: Boris Burkov <boris@bur.io>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org,
	david@kernel.org, willy@infradead.org, surenb@google.com,
	hannes@cmpxchg.org, ljs@kernel.org, ziy@nvidia.com,
	usama.arif@linux.dev, fvdl@google.com, Chris Mason <clm@meta.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <20260520174749.GA1458531@zen.localdomain>
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520150018.2491267-35-riel@surriel.com>

On Wed, May 20, 2026 at 10:59:40AM -0400, Rik van Riel wrote:
> Extent buffer pages allocated by alloc_extent_buffer() are attached to
> btree_inode->i_mapping (the buffer_tree path), reach the LRU, and are
> served by the btree_migrate_folio aops in fs/btrfs/disk-io.c. They are
> migratable in practice once their owning extent buffer hits refs == 1,
> which happens naturally as tree roots rotate. The buddy allocator

Small correction to a generally correct story:

every extent_buffer we have used (it is newly cowed or we have read it
for some reason) will settle into a state where extent_buffer->refs == 1
and it is eligible for release_folio(). If a block gets cowed, then its
extent_buffer should be fully released/freed right away, with a tricky
EXTENT_BUFFER_STALE bit dance to prevent accidental reuse during this
process.

So I don't think cow or trees moving around is all that relevant here.

The folios you are after are the ones which are sitting around with
extent_buffer->refs == 1 and which will return 0 to release_folio(),
which is any valid, non-stale extent_buffer no btrfs operation is
currently using (typically referred to from a btrfs_path). These are
already available to be reclaimed by memory pressure based reclaim,
drop_caches, etc.

> classifies them by GFP, however, and bare GFP_NOFS lands them in
> MIGRATE_UNMOVABLE pageblocks. The result: every btree_inode page we
> read in pins an unmovable pageblock from the page-superblock allocator's
> perspective, even though the page itself can be moved.
> 
> Add __GFP_MOVABLE to that one allocation site (alloc_extent_buffer's
> call to alloc_eb_folio_array). Plumb the flag through
> alloc_eb_folio_array → btrfs_alloc_page_array as a `gfp_t extra_gfp`
> parameter. All other call sites pass 0.
> 
> Three categories of caller stay on bare GFP_NOFS, deliberately:
> 
>   - alloc_dummy_extent_buffer / btrfs_clone_extent_buffer: the
>     resulting eb is EXTENT_BUFFER_UNMAPPED, folio->mapping stays NULL,
>     the folios never enter LRU, never get migrate_folio aops. Tagging
>     them __GFP_MOVABLE would violate the page allocator's migrability
>     contract and they would defeat compaction in MOVABLE pageblocks
>     where isolate_migratepages_block skips non-LRU non-movable_ops
>     pages outright.
> 
>   - btrfs_alloc_page_array callers in fs/btrfs/raid56.c (stripe
>     pages), fs/btrfs/inode.c (encoded reads), fs/btrfs/ioctl.c (uring
>     encoded reads), fs/btrfs/relocation.c (relocation buffers): same
>     contract violation. raid56 stripe_pages additionally persist in
>     the stripe cache (RBIO_CACHE_SIZE=1024) well beyond a single I/O,
>     so they are not transient enough to hand-wave the contract.
> 
>   - btrfs_alloc_folio_array caller in fs/btrfs/scrub.c (stripe
>     folios): same -- stripe->folios[] are private buffers freed via
>     folio_put in release_scrub_stripe.
> 
> This change targets the dominant fragmentation source observed on the
> page-superblock series: ~28 GB of btree_inode pages parked across
> many tainted superpageblocks on a 250 GB test system with btrfs root,
> preventing 1 GiB hugepage allocation from those regions. With the
> movable hint, those pages now land in MOVABLE pageblocks where the
> existing background defragger drains them through the standard
> PB_has_movable gate, no LRU-sample fallback needed.
> 

I left a small code nit inline, but whether you take that suggestion or
leave it, you can add:

Reviewed-by: Boris Burkov <boris@bur.io>

Thanks for the patch,
Boris

> Cc: Chris Mason <clm@meta.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Boris Burkov <boris@bur.io>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4.7 syzkaller
> ---
>  fs/btrfs/extent_io.c  | 69 ++++++++++++++++++++++++++++++-------------
>  fs/btrfs/extent_io.h  |  4 +--
>  fs/btrfs/inode.c      |  2 +-
>  fs/btrfs/ioctl.c      |  2 +-
>  fs/btrfs/raid56.c     |  6 ++--
>  fs/btrfs/relocation.c |  2 +-
>  fs/btrfs/scrub.c      |  3 +-
>  7 files changed, 59 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 2275189b7860..563c4a7eaa36 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -620,24 +620,33 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
>  }
>  
>  /*
> - * Populate every free slot in a provided array with folios using GFP_NOFS.
> + * Populate every free slot in a provided array with folios using
> + * GFP_NOFS plus optional caller-supplied flags.
>   *
> - * @nr_folios:   number of folios to allocate
> - * @order:	 the order of the folios to be allocated
> - * @folio_array: the array to fill with folios; any existing non-NULL entries in
> - *		 the array will be skipped
> + * @nr_folios:    number of folios to allocate
> + * @order:	  folio order
> + * @folio_array:  array to fill with folios; non-NULL entries are skipped
> + * @extra_gfp:    extra GFP flags OR'd into GFP_NOFS. The only value used
> + *                today is __GFP_MOVABLE, which the extent-buffer real-mapping
> + *                path (alloc_extent_buffer) passes when the resulting folios
> + *                will be attached to btree_inode->i_mapping (added to LRU,
> + *                served by the btree_migrate_folio aops). Pass 0 for
> + *                everything else; folios allocated by other callers stay in
> + *                driver-owned arrays, never reach LRU and never register
> + *                movable_ops, so they cannot satisfy the __GFP_MOVABLE
> + *                migrability contract.
>   *
>   * Return: 0        if all folios were able to be allocated;
>   *         -ENOMEM  otherwise, the partially allocated folios would be freed and
>   *                  the array slots zeroed
>   */
>  int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
> -			    struct folio **folio_array)
> +			    struct folio **folio_array, gfp_t extra_gfp)
>  {
>  	for (int i = 0; i < nr_folios; i++) {
>  		if (folio_array[i])
>  			continue;
> -		folio_array[i] = folio_alloc(GFP_NOFS, order);
> +		folio_array[i] = folio_alloc(GFP_NOFS | extra_gfp, order);
>  		if (!folio_array[i])
>  			goto error;
>  	}
> @@ -652,21 +661,27 @@ int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
>  }
>  
>  /*
> - * Populate every free slot in a provided array with pages, using GFP_NOFS.
> + * Populate every free slot in a provided array with pages, using GFP_NOFS
> + * plus optional caller-supplied flags.
>   *
> - * @nr_pages:   number of pages to allocate
> - * @page_array: the array to fill with pages; any existing non-null entries in
> - *		the array will be skipped
> - * @nofail:	whether using __GFP_NOFAIL flag
> + * @nr_pages:    number of pages to allocate
> + * @page_array:  array to fill; non-NULL entries are skipped
> + * @nofail:      whether to use __GFP_NOFAIL
> + * @extra_gfp:   extra GFP flags OR'd into the base mask. The only value used
> + *               today is __GFP_MOVABLE, which the extent-buffer real-mapping
> + *               path passes when the resulting pages will be attached to
> + *               btree_inode->i_mapping. See btrfs_alloc_folio_array() for
> + *               the full migrability rationale.
>   *
>   * Return: 0        if all pages were able to be allocated;
>   *         -ENOMEM  otherwise, the partially allocated pages would be freed and
>   *                  the array slots zeroed
>   */
>  int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
> -			   bool nofail)
> +			   bool nofail, gfp_t extra_gfp)
>  {
> -	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
> +	const gfp_t gfp = (nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS) |
> +			  extra_gfp;
>  	unsigned int allocated;
>  
>  	for (allocated = 0; allocated < nr_pages;) {
> @@ -689,14 +704,23 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>   * Populate needed folios for the extent buffer.
>   *
>   * For now, the folios populated are always in order 0 (aka, single page).
> + *
> + * @movable: pass true only when the resulting pages will be attached to
> + *           btree_inode->i_mapping (the alloc_extent_buffer real path).
> + *           Cloned/dummy extent buffers (EXTENT_BUFFER_UNMAPPED) leave
> + *           folio->mapping NULL, never enter the LRU, and never get the
> + *           btree_migrate_folio aops, so __GFP_MOVABLE would violate the
> + *           page-allocator's migrability contract for them.
>   */

My gut says it is nicer to just transparently pass along a gfp flag
rather than a carefully documented movable boolean and let the callers
do the right thing. Just a nit, I don't care strongly about it.

> -static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail)
> +static int alloc_eb_folio_array(struct extent_buffer *eb, bool nofail,
> +				bool movable)
>  {
>  	struct page *page_array[INLINE_EXTENT_BUFFER_PAGES] = { 0 };
>  	int num_pages = num_extent_pages(eb);
>  	int ret;
>  
> -	ret = btrfs_alloc_page_array(num_pages, page_array, nofail);
> +	ret = btrfs_alloc_page_array(num_pages, page_array, nofail,
> +				     movable ? __GFP_MOVABLE : 0);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3097,7 +3121,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src)
>  	 */
>  	set_bit(EXTENT_BUFFER_UNMAPPED, &new->bflags);
>  
> -	ret = alloc_eb_folio_array(new, false);
> +	ret = alloc_eb_folio_array(new, false, false);
>  	if (ret)
>  		goto release_eb;
>  
> @@ -3138,7 +3162,7 @@ struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
>  	if (!eb)
>  		return NULL;
>  
> -	ret = alloc_eb_folio_array(eb, false);
> +	ret = alloc_eb_folio_array(eb, false, false);
>  	if (ret)
>  		goto release_eb;
>  
> @@ -3491,8 +3515,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>  	}
>  
>  reallocate:
> -	/* Allocate all pages first. */
> -	ret = alloc_eb_folio_array(eb, true);
> +	/*
> +	 * Allocate all pages first. These will be attached to
> +	 * btree_inode->i_mapping below (added to LRU, served by
> +	 * btree_migrate_folio), so request __GFP_MOVABLE so the
> +	 * page allocator places them in MOVABLE pageblocks.
> +	 */

i.e., just pass GFP_MOVABLE here with a comment explaining why

> +	ret = alloc_eb_folio_array(eb, true, true);
>  	if (ret < 0) {
>  		btrfs_free_folio_state(prealloc);
>  		goto out;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index b310a5145cf6..5e263f07b59d 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -387,9 +387,9 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>  			      struct extent_buffer *buf);
>  
>  int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
> -			   bool nofail);
> +			   bool nofail, gfp_t extra_gfp);
>  int btrfs_alloc_folio_array(unsigned int nr_folios, unsigned int order,
> -			    struct folio **folio_array);
> +			    struct folio **folio_array, gfp_t extra_gfp);
>  
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  bool find_lock_delalloc_range(struct inode *inode,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 906d5c21ebc4..85f56ab815f9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9659,7 +9659,7 @@ ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *iter,
>  	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
>  	if (!pages)
>  		return -ENOMEM;
> -	ret = btrfs_alloc_page_array(nr_pages, pages, false);
> +	ret = btrfs_alloc_page_array(nr_pages, pages, false, 0);
>  	if (ret) {
>  		ret = -ENOMEM;
>  		goto out;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a7..77091915cacc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4621,7 +4621,7 @@ static int btrfs_uring_read_extent(struct kiocb *iocb, struct iov_iter *iter,
>  	pages = kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
>  	if (!pages)
>  		return -ENOMEM;
> -	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
> +	ret = btrfs_alloc_page_array(nr_pages, pages, 0, 0);
>  	if (ret) {
>  		ret = -ENOMEM;
>  		goto out_fail;
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 08ee8f316d96..4135bac62be1 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1123,7 +1123,7 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio)
>  {
>  	int ret;
>  
> -	ret = btrfs_alloc_page_array(rbio->nr_pages, rbio->stripe_pages, false);
> +	ret = btrfs_alloc_page_array(rbio->nr_pages, rbio->stripe_pages, false, 0);
>  	if (ret < 0)
>  		return ret;
>  	/* Mapping all sectors */
> @@ -1138,7 +1138,7 @@ static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
>  	int ret;
>  
>  	ret = btrfs_alloc_page_array(rbio->nr_pages - data_pages,
> -				     rbio->stripe_pages + data_pages, false);
> +				     rbio->stripe_pages + data_pages, false, 0);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -1732,7 +1732,7 @@ static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
>  	const int data_pages = rbio->nr_data * rbio->stripe_npages;
>  	int ret;
>  
> -	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, false);
> +	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, false, 0);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 3ebaf5880125..6f6d25724fb8 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4038,7 +4038,7 @@ static int copy_remapped_data(struct btrfs_fs_info *fs_info, u64 old_addr,
>  	if (!pages)
>  		return -ENOMEM;
>  
> -	ret = btrfs_alloc_page_array(nr_pages, pages, 0);
> +	ret = btrfs_alloc_page_array(nr_pages, pages, 0, 0);
>  	if (ret) {
>  		ret = -ENOMEM;
>  		goto end;
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 1ac609239cbe..4089e80077cc 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -369,7 +369,8 @@ static int init_scrub_stripe(struct btrfs_fs_info *fs_info,
>  
>  	ASSERT(BTRFS_STRIPE_LEN >> min_folio_shift <= SCRUB_STRIPE_MAX_FOLIOS);
>  	ret = btrfs_alloc_folio_array(BTRFS_STRIPE_LEN >> min_folio_shift,
> -				      fs_info->block_min_order, stripe->folios);
> +				      fs_info->block_min_order, stripe->folios,
> +				      0);
>  	if (ret < 0)
>  		goto error;
>  
> -- 
> 2.54.0
> 
