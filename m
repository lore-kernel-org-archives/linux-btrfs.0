Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C130B517
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783617474; cv=none; b=kvWxQxd5gggf4SDzGLSUljNuboxezuCasTpwd5L7GZymv55JMCEbiNFzbHwoRVIYu58QS9nJYnpyELHKMODRvxA6zQvIcWNX+C1nNiPKX93FWFqAM5xajTcEMlgBubB/As+7kjp4ziT+vLNd0zpXyaplN9aUbxN/G8pn1qMa0lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783617474; c=relaxed/simple;
	bh=1yWQjIPHFzYookFsY1fI4SwDNSOtvK8IgS9UYYL2VIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYhrW2vHrFMeF7zKLkUCk0HpBFv3yWwIT5LOZBDzgDjLFhMNO3jsv2h+4NIUGP4AdFksQE+/56PHezM7juykcAsti7TGC2BxM4RlZxhRNBdnW9d014QsWegOJVF+ng0jI6HnHigJeKjuBd+1PxzRQ1tnbpyc8OMkAg/FQjsD8+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=bkm5cOZ0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jIyLmld1; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="bkm5cOZ0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jIyLmld1"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id A087BEC0076;
	Thu,  9 Jul 2026 13:17:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 09 Jul 2026 13:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783617471;
	 x=1783703871; bh=hi3e+WFse5+V0iVkDOtOwTvrlm5AJMXiQWwfbo2C+iE=; b=
	bkm5cOZ0c1QGghmMQetdfmKEpJ9oAzmZtThtoctMVB6PYRI0m0HwVajAteiXPSZZ
	QomGTcerEB6eMHRILvFO2ymffyXfphravCntYAxRt5EI9WPBZ+XQwFBnZ3pQWbdX
	FLjNH4oouWRNw49binGt8SLIhaxZkJGbqNyirsB9UkJVrV+VGpB7VuhyDVFfClAD
	MWqj+j7ZHQKoy5BB+nb0r6VNJyMqx/jtiUZLcoVFipmKl+wFDq3C1KeZaw5ssl3M
	9VRlXFO2qwwKEKnTNZe3t6g72rUzXcevoyYu6SGmhx41uyxrd3NU6orW+Du9ioSR
	JWp67zHB87t580DL04UVjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783617471; x=
	1783703871; bh=hi3e+WFse5+V0iVkDOtOwTvrlm5AJMXiQWwfbo2C+iE=; b=j
	IyLmld11M0W2bqvrXfBkqSmpof7tZmJOBjTLJ8Gy0h2nJ45rtd/qKL4bVM/AiYFM
	+DyKZBefBoNB/fC/rSvDMnHUnmrf1voiz4qwR7pdjfpKr3syc4SMW/PrZMdDClO4
	3A1CedCtghgQ70DHcM1mNRNe617DdPjkAGbj0lle8KLhYfKLxnrDngG8wL6VENDx
	U2F4ahyVom/iudTFRKkCSqqQzNW7Q4hjBMoTZgO0GpcicrwIW7tudgE4rGPNmWV5
	HTrp7gFB8qySxOsNeRBkmKaKe8Vp+NX5v1bYzC5oX7u4Rii33or+DTreDrAsOxXA
	R+ccl6w6OH2tfJYb38Cyw==
X-ME-Sender: <xms:v9dPagrhOxArkevLgm7Q1pj-p9JqquVYGOBZfXUxtKacZFUNdS_OhA>
    <xme:v9dPatqNFDrWNssubJ9yhqfui0_p4CcnPs3CF6fo0rI9koeLEWEyZoMTh8bm1dEjt
    mLhASAxi1HDR2hJA-sRitE7E-1Gg4tkumVBMePHdaKimXqoV7y8Fg>
X-ME-Received: <xmr:v9dPaqNPFHGpcyMG0-6nYwAU2oQY-B1rHKSqNwNNt9NZn4bZgQTh6Jx85sHu37U26HGwm6Vifvw8HaHONYaw0hpk9tU>
X-ME-Proxy-Cause: dmFkZTEQLB1VKDCpiz05a5e8sz0EakXFroEl3jiBljGSiihXzjMVWyWh1W2tii618j6B7E
    SFinO/0dpav62R0rnedBbnJynOsXrPeJ3JlJtmhUiVeir1Gu6Pl+2hefKz+Kwl8KyTpBie
    TY85WpUZ/TZNAnCfyEaYNtZlaBfiAnAoO+n/Dd4/svIogt53/x9f0/Y3myTTUALqjk5uC2
    4PrFQF5o1eMh5+DnkYmPtTpqvo7c8N6RFMDNqrmYtkLor2nuSyQcx8a5jkH8pwRVrd876S
    WMMLMUyZmqva6BVAXSpmYqkBKnQVARNDYBclD5+n/fBqYquRMGP2/K5rwhD9n8BhraPmnT
    U4D2Add2YNHqz+6KPrP5v3O93dJ6VkJBv72ybCvyEoEtA22W193XvuBqkofgL+HnweydGu
    RtKP4BUURO74Ovh5nYl/Vgf00TzG1yRUIzIWC8IZKIFCZVKhwhgTkhdT184Wv8+ZrAgKOm
    xo0bh05RuBhLKLdOF2HkMEhGdUT3B4Q+ODBfTQw9YXDBAulemQGiiWVSnRkEYL4ULOWaz0
    XPgPUUILV+D6DOrbCIYFwfAWzx5rdXf8aMqDXR7+G2yB4rE2kJxcrfsKjEKIIXJn0K/wJk
    MGvUEKGhoe+xgeAddgBDqMHHbxdDtfbPHW52oD2vSh6mLhz1cLQ4IWiL8iOg
X-ME-Proxy: <xmx:v9dPamxolgIu1wy3T8v7om2JXjx5Tk4BARummlrzqulFv7mjJDB16g>
    <xmx:v9dParuzrNSDz4ealqotAeFin6EtiPvG6TlzQsBqoGOlNNc0V83l9g>
    <xmx:v9dPan7W_N8n5yvzdPeXWsJ4hfxoX1t3Jt_Mnp9mb8AKc4rkv2Kggg>
    <xmx:v9dPaiSbbw9wnPF-bQkyvjNhZshvyfAJRJK3ZRJA9k8bRoTY6rU-Kg>
    <xmx:v9dPatj14KSBNnsuEMQbFNH8AdlPDxY3zyrzMi6ldwCdnmc3_JglXRlb>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 13:17:50 -0400 (EDT)
Date: Thu, 9 Jul 2026 10:18:04 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, willy@infradead.org
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
Message-ID: <20260709171804.GB1552049@zen.localdomain>
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>

On Thu, Jul 09, 2026 at 06:16:55PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/9 14:01, Boris Burkov 写道:
> > Commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> > the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
> > plain folio_test_dirty() check. Besides clearing the dirty flag,
> > folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
> > the shared mmap PTEs mapping the folio.
> > 
> > Without the write-protection, a process with the file mmap'd can modify
> > a sector while it is being used by writeback in a way that expects a
> > stable folio (checksumming, compressing, copying, etc...) which
> > manifests as a handful of concrete bugs.
> > 
> > For large folios or subpage sectorsize, this will result in an invalid
> > checksum and later corruption reports on read (if sectorsize ==
> > folio_size() then we will always be in the case where we call
> > folio_mkclean() when we clear the dirty on the sector, which is the
> > whole folio).
> 
> Just want to make the cause more clear, and also explain under what exact
> situation the problem can happen.
> 
> Firstly, we still call folio_clear_dirty_for_io(), but at a much later
> timing, now it's only called when the last dirty block got its dirty flag
> cleared, instead of just before extent_writepage().
> 
> This means, if there is only a single contig dirty range inside a folio, and
> we can submit that contig range in one go, then the problem will not happen.
> 
> E.g. a 32K folio with 4K block size, and inside the folio the dirty range
> looks like this:
> 
>     0     8K     16K     24K    32K
>     |     |//////////////|      |
> 
> Then during writeback, we clear the block dirty and mark writeback, queue
> that block into a bbio (but not yet submitted).
> 
> Finally at the last block [20K, 24K), we cleared the last dirty block, thus
> will call folio_clear_dirty_for_io() for the whole folio, then submit the
> bio for range [8K, 24K), and everything is still safe.
> 
> But another commit, "btrfs: limit size of bios submitted from writeback", is
> making the situation worse, as if we get a very large folio, e.g. 128KiB
> one, even if the whole range is dirty, it will still be submitted as two 64K
> bios, in that case, the first half will be submitted without folio_mkclean()
> called, thus causing the problems you're describing.
> 
> 
> With all these said, this may help you to craft a more reliable reproducer,
> by:
> 
> 1. Allocate a large folio (e.g, 64KiB on 4K ps systems)
>    By doing a 64KiB sized buffered write at file offset 0.
> 
> 2. Mmap range [4K, 8K) and [16K, 20K)
> 
> 3. Trigger writeback with mmaped range being modified
> 
> 
> 

Well said, thanks. I'll make the relevance of the "bio doesn't cover folio"
aspect more clear in the commit description.

> > 
> > For zoned submissions which are done in batch separate from the main
> > extent_writepage() loop, we also risk csum violations for those
> > submissions.
> > 
> > For inline extents this will subtly risk losing writes that happen
> > after/while we copy the inline extent but before we clear dirty on
> > the folio.
> 
> Inline is indeed affected, as we only rely on the final
> extent_clear_unlock_delalloc() -> process_one_folio() ->
> btrfs_folio_clamp_clear_dirty() to clear the block dirty, which is too late.
> 
> As the data is already copied into metadata without folio_mkclean().
> 
> 
> > 
> > For folios spanning EOF, mmap could tamper with the zeroed bytes past
> > EOF and cause them to be persisted where future faults would impoperly
> > see them instead of zeros.
> > 
> > Finally, for compressed extents, we risk modifying the folios while we
> > work on compressing them which will result in corrupted compressed data.
> > This particular gap was introduced by a second patch in the same series:
> > Commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
> 
> Yes, compression corruption is still true, but only for the last/first
> folio.
> 
> Firstly compression range is always contig, only the first and last folio
> can have other dirty ranges out of the compression range.
> 
> So the middle folios will always have their folio dirty flags cleared by
> extent_range_clear_dirty_for_io() -> btrfs_folio_clamp_clear_dirty().
> 
> > 
> > We cannot simply restore the call to folio_clear_dirty_for_io() because
> > that also drops the dirty flag off the folio which violates invariants
> > introduced for large folios by
> > commit 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> > and results in failing to invalidate clean folios past i_size, resulting
> > in deadlocks.
> > 
> > Therefore, to fix it, leave the existing semantics w.r.t. the folio's
> > dirty flag (to preserve the correct invalidate behavior) but ensure that
> > the other aspect of folio_clear_dirty_for_io(), folio_mkclean(), is run
> > on the folio when we lock it for writeback.
> > 
> > Finally, to help prevent similar regressions in the future, add a debug
> > warning that triggers at the known corruption sites if we have failed to
> > write protect the folio.
> > 
> > Assisted-by: LLM (debug, reproduce, research fix, review patch)
> > Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> > Fixes: a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >   fs/btrfs/extent_io.c | 31 +++++++++++++++++++++++++++++++
> >   fs/btrfs/extent_io.h |  5 +++++
> >   fs/btrfs/inode.c     | 23 +++++++++++++++++------
> >   3 files changed, 53 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 8fbb798767ca..647b109ef61b 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -6,6 +6,7 @@
> >   #include <linux/mm.h>
> >   #include <linux/pagemap.h>
> >   #include <linux/page-flags.h>
> > +#include <linux/rmap.h>
> >   #include <linux/sched/mm.h>
> >   #include <linux/spinlock.h>
> >   #include <linux/blkdev.h>
> > @@ -299,6 +300,25 @@ static noinline void unlock_delalloc_folio(const struct inode *inode,
> >   				PAGE_UNLOCK);
> >   }
> > +#ifdef CONFIG_BTRFS_DEBUG
> > +/*
> > + * Writeback must write-protect a folio when locking it for IO, before
> > + * anything consumes its data (zeroing, inline copy, compression,
> > + * checksumming). If this fails, then an mmap writer would be able to
> > + * modify the data concurrently while we need it to be stable.
> > + */
> > +void btrfs_check_folio_write_protected(struct folio *folio)
> > +{
> > +	if (folio_mkclean(folio)) {
> > +		const struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
> > +
> > +		DEBUG_WARN("writable mmap PTEs, root %llu ino %llu pos %llu order %u",
> > +			   btrfs_root_id(inode->root), btrfs_ino(inode), folio_pos(folio),
> > +			   folio_order(folio));
> > +	}
> > +}
> > +#endif
> > +
> >   static noinline int lock_delalloc_folios(struct inode *inode,
> >   					 struct folio *locked_folio,
> >   					 u64 start, u64 end)
> > @@ -332,6 +352,8 @@ static noinline int lock_delalloc_folios(struct inode *inode,
> >   				folio_unlock(folio);
> >   				goto out;
> >   			}
> > +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> > +			folio_mkclean(folio);
> 
> I believe this is mostly for compression.
> 
> As inline folio is already cleaned by folio_mkclean() before
> extent_writepage().
> The same for regular COW/NOCOW writes.
> 
> In that case, as I mentioned in another thread, I'd prefer not to call
> folio_mkclean() too early.
> 
> I'd prefer to call folio_mkclean() inside extent_range_clear_dirty_for_io()
> instead.

The idea is the zoned folios submitted by run_delalloc_range with
pages_dirty=true. Only the one main folio will be cleaned in
extent_writepage but several get submitted in this loop while locked
(which is asserted by the pages_dirty check).

So assuming we want to clean those folios (which I think we do)
then we need:
extent_writepage (main one covers usual large folios and inline)
extent_range_clear_dirty_for_io (covers compression stability)
extent_write_locked_range pages_dirty = true (zoned batch)

lock_delalloc_folios() covers the last two in a single more
principled way, IMO.

I am still making sure all of this reproduces exactly as I understand
it, though, to be as convincing as possible :)

> >   			range_start = max_t(u64, folio_pos(folio), start);
> >   			range_len = min_t(u64, folio_next_pos(folio), end + 1) - range_start;
> >   			btrfs_folio_set_lock(fs_info, folio, range_start, range_len);
> > @@ -1780,6 +1802,13 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
> >   	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
> >   	       start, len, folio_start, folio_size(folio));
> > +	/*
> > +	 * We are about to checksum and write out the data, so it must not be
> > +	 * mmap writeable, or we could corrupt the data and end up with invalid
> > +	 * checksums.
> > +	 */
> > +	btrfs_check_folio_write_protected(folio);
> > +
> >   	/* Truncate the submit bitmap to the current range. */
> >   	if (start > folio_start)
> >   		bitmap_clear(bio_ctrl->submit_bitmap, 0,
> > @@ -2590,6 +2619,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
> >   				continue;
> >   			}
> > +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> > +			folio_mkclean(folio);
> >   			ret = extent_writepage(folio, bio_ctrl);
> >   			if (ret < 0) {
> >   				done = true;
> > diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> > index 9896e15ddc40..869925337699 100644
> > --- a/fs/btrfs/extent_io.h
> > +++ b/fs/btrfs/extent_io.h
> > @@ -255,6 +255,11 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask);
> >   int try_release_extent_buffer(struct folio *folio);
> >   int btrfs_read_folio(struct file *file, struct folio *folio);
> > +#ifdef CONFIG_BTRFS_DEBUG
> > +void btrfs_check_folio_write_protected(struct folio *folio);
> > +#else
> > +static inline void btrfs_check_folio_write_protected(struct folio *folio) { }
> > +#endif
> >   void extent_write_locked_range(struct inode *inode, const struct folio *locked_folio,
> >   			       u64 start, u64 end, struct writeback_control *wbc,
> >   			       bool pages_dirty);
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index b47e2aa5071d..636196705fa3 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -775,19 +775,28 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
> >   static int extent_range_clear_dirty_for_io(struct btrfs_inode *inode, u64 start, u64 end)
> >   {
> > +	pgoff_t index = start >> PAGE_SHIFT;
> >   	const pgoff_t end_index = end >> PAGE_SHIFT;
> >   	struct folio *folio;
> >   	int ret = 0;
> > -	for (pgoff_t index = start >> PAGE_SHIFT; index <= end_index; index++) {
> > +	while (index <= end_index) {
> >   		folio = filemap_get_folio(inode->vfs_inode.i_mapping, index);
> >   		if (IS_ERR(folio)) {
> >   			if (!ret)
> >   				ret = PTR_ERR(folio);
> > +			index++;
> >   			continue;
> >   		}
> > +		/*
> > +		 * We are about to compress the folio, so it must not be mmap
> > +		 * writeable or we could corrupt the data as we attempt to
> > +		 * compress it.
> > +		 */
> > +		btrfs_check_folio_write_protected(folio);
> >   		btrfs_folio_clamp_clear_dirty(inode->root->fs_info, folio, start,
> >   					      end + 1 - start);
> > +		index = folio_next_index(folio);
> >   		folio_put(folio);
> >   	}
> >   	return ret;
> > @@ -877,11 +886,6 @@ static void compress_file_range(struct btrfs_work *work)
> >   	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
> > -	/*
> > -	 * We need to call clear_page_dirty_for_io on each page in the range.
> > -	 * Otherwise applications with the file mmap'd can wander in and change
> > -	 * the page contents while we are compressing them.
> > -	 */
> 
> And I'm a total idiot not noticing this existing comment...
> 
> Otherwise it looks good to me.
> 
> Thanks a lot of pinning down a bug that I'm completely unfamiliar with.
> Didn't notice folio_mkclean() has such an important role related to mmaped
> writes.
> 
> Thanks,
> Qu
> 
> >   	ret = extent_range_clear_dirty_for_io(inode, start, end);
> >   	/*
> > @@ -2317,6 +2321,13 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
> >   	int ret;
> >   	ASSERT(folio_pos(locked_folio) == 0);
> > +	/*
> > +	 * If an mmap writer could modify the folio while we copy it into an
> > +	 * inline extent we might see only part of their modification then
> > +	 * wrongly mark it clean again after copying, losing that write. So the
> > +	 * folio must be write protected here.
> > +	 */
> > +	btrfs_check_folio_write_protected(locked_folio);
> >   	if (btrfs_inode_can_compress(inode) &&
> >   	    inode_need_compress(inode, 0, blocksize, true)) {
> 
