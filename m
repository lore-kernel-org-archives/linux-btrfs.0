Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44504C81
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 23:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783468037; cv=none; b=QCHGgVUTnD2/ytV17AVoomgK2dn4fmjAoude8VHuKczl/LyNlDz6/mjvVc7gynRI1nd6iMjgUNcubQG0WHiavMSI0G/H6HalOG9S2y/4E3b/MgV8zsFhL7psT+vnwHTCb997OJ7Eskzu4vXjFIV1Lwohm4XdOEVL+Y4EsW1iBMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783468037; c=relaxed/simple;
	bh=MJsbUn2+KOygXFIqH5CGQYgCGX/rloql00rknTvsXXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLG1kLfUV/9zW45TYulk9gkINphrIVcVfbnU7eeYYihJt8Y9XOdByJEGa19UcUGlGB0cj1N/OhF0+J/b+CkotO3BkHFpH0jdVkKWwvfMHlub80+HPO4szw/KJrHHp+ELarXf3wWIw4SgPc+aVgc9wJ5APugD9O0hkJMmrBsHyeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fN9YowCE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HdA8EkyG; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fN9YowCE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HdA8EkyG"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0B5CC7A00E1;
	Tue,  7 Jul 2026 19:47:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 07 Jul 2026 19:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783468034;
	 x=1783554434; bh=5xAsyp6xfllKNeXdQ2SS43qR69Tg8AYDSY3z0RyJ5E0=; b=
	fN9YowCEZ9iT7CUfDAHtd8OQnJbOu21PPle22mQBiSrprIHlVQVcCMN4qb1LLAjC
	HT6xRHthaBN+aJHe07DRZ3wMFtd4iYwYHJYQ1fSml86AGZbWvVfwecCBTypNGyHp
	XvDXToKAtHfXN9kur5sc0y16xObF8wp1mFX9jtIElewwv1tseXIfvSYcf33z1qK2
	h3sodRIeC8gdcW+6R6PWQJCSWchpndJuJilBhn3tBbCTzDzHKImkJLZzExBUJqW2
	Nig2AMTlIkTSilRDa8CAJdKMNkIvbA7fBtv2Sqy3uD6EkseorDCNrPmwJbv6EaOw
	Z+RLvDeNBpsiXZkT0caBXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783468034; x=
	1783554434; bh=5xAsyp6xfllKNeXdQ2SS43qR69Tg8AYDSY3z0RyJ5E0=; b=H
	dA8EkyG63DUXmHJdQvLGf4igXNutDZVjBUI7CwvOm24jLTokxpZ2wUxb/Xf1J/fl
	J1PmGmu+QayAdyo+76PbTlt9KnWWS0XLoQVUaQ11JzxQVbYnflkDB8Cnxyhivtp+
	cOxvDzOdRs60UHjyzTLTMM/RJDLz8+TC37jf9s9yATD3JjsWRpREjqU5IJv+QTlW
	Su510A0AC7UzDhXWILO+1v/DeNS6QdIRhA7ewJlgGpQ1cW+zXtNd7WVTbunrAkd5
	5yvWdr9aWMCkJ1aSns7TKfKbatI7reKKSiQoI0Ac7vHCk1n/eBLyu6UL1ClQmYJZ
	TJVw6yeEKtaoOQ0ax54IQ==
X-ME-Sender: <xms:ApBNahzgbGQEUlGUuzzvOKiqU0h1CUHV_ElEzlhIk0NGqFBKOIk2tw>
    <xme:ApBNanQzGE4FxoKV-gpC0AeJAtiJpHCYP7Fd4HadqczmYhPxPP7_S-nkZyxSdf9y4
    f9daWiOt11o81-NCFBs2bxh-fBli-RtDFVf2xtTTwMw198YJQowSlM>
X-ME-Received: <xmr:ApBNao8WwTm0vetntAIX7bkEAp0VoHrwI5Zjidof5XXCzzkbfdXwmgCaTfZNI4KFozLgOti5WlE1IU7tJlMj1ELER7s>
X-ME-Proxy-Cause: dmFkZTGtLZAi/rw6dYdyw3nseEjI3brKGH/97HDKjJYt2RUYE/E3CrCawXc3KAK5HP/DG0
    URsdd0KX4nLkHK5rEtEzEVN+0za26HwcYLu6pax75ykKS5wJSbUjn7FdLzVtOn69BQaPUd
    oQk8fvEeSaFeQ8JQSPEnCqCdKovkNpw7Fgd2eFIAx53fNndfC+gUafAU5Jh21XOVheO4cD
    adBvOuE4BznljWWTYx5pgg9VxY+U960a0aiYupn2WRLn8vlctST2/+qWor40g6yjSIkDP0
    MF9EIKtzrNuZiwjfFisbYTlQ3T4yDGs+EuQoEtEiN6pd/HjNXidv/rNoZLPXaPi9xC4FOn
    j8Z6XUJ2kAnVBxHtiHLE3TlhJGO/NbzlleAHt9ZJNjZg+q/1eCXVNGniqzZ9R8BFNcGzKG
    NeikrXm3KJgHZxU6pc4IWYALRVahzM6Qz111Sq1ONXQWmpiP/zJnGbbDF6iLdg5HIcWI4C
    BO4vGHDXwu/hS0oI2II/wEtCtXo5jEw9SEQPWoDVyED9VcIWLm96eriMvNjnMnKcSgIoIA
    n8hmlv1MzL/2gGS/JHRR82rMByCFfcHlteUMhRz+bvkZ0+gJq1WdVmNp7rxqRDwzOyLsgr
    KdNuJGIfQphHukVj7AHyzxeSIGkW+ltuXNIpAz1Kq5luHQwahANGwXARkRnQ
X-ME-Proxy: <xmx:ApBNaupdKQcbgclaprr2mj6XbqYBFQifa4ZwN6pQjW7YPiMx-8jlDA>
    <xmx:ApBNalm2e6Bu4h6uE1zcndGZI03qw39iF7HAazQM29T_GDkB9G6xhg>
    <xmx:ApBNalKFJGCCJjt_Eicz6GO4VVluvAAl8Gy3w5KwJ0c6DWxBKnj5Kw>
    <xmx:ApBNaqwigZ4DCqJKDErQl9nSk2pryhBABxR76wzmsbIabmBGL0u_MA>
    <xmx:ApBNap8deQh1u0pRNfAb56LverzKw_OKwc1h9__0feoDMhf9GLpUwsiZ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 19:47:14 -0400 (EDT)
Date: Tue, 7 Jul 2026 16:47:31 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707234731.GA83688@zen.localdomain>
References: <d47af8cae38e32462d61cb62139c2732e4e8fdbe.1783407237.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d47af8cae38e32462d61cb62139c2732e4e8fdbe.1783407237.git.wqu@suse.com>

On Tue, Jul 07, 2026 at 04:24:30PM +0930, Qu Wenruo wrote:
> [BUG]
> The following script (already submitted as generic/798) will report
> incorrect dirty page numbers, with 64K page size systems and 4K fs block
> size:
> 
>  # mkfs.btrfs -s 4k -f $dev
>  # mount $dev $mnt
>  # xfs_io -f -c "pwrite 0 64K" -c fsync -c "cachestat 0 64K" $mnt/foobar
>  Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
> 
> Note that the dirtied page number is still 1.
> 
> [CAUSE]
> The cachestat() goes through the XArray of the page cache, but
> instead of checking each folio's flag, it uses the
> PAGECACHE_TAG_DIRTY tag to report dirty pages.
> 
> Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
> btrfs replaced a folio_clear_dirty_for_io() call inside
> extent_write_cache_pages() with folio_test_dirty().
> 
> This will cause the following call sequence for the folio at file offset
> 0:
> 
>  extent_write_cache_pages()
>  |- folio_test_dirty()
>  |  The folio is still dirty, continue to writeback.
>  |
>  |- extent_writepage()
>     |- extent_writepage_io()
>        |- submit_one_sector() for range [0, 4K)
>        |  |- btrfs_folio_clear_dirty()
>        |  |- btrfs_folio_set_writeback()
>        |     |- folio_start_writeback()
>        |        It's the first writeback block, we set the writeback
>        |	flag for the folio.
>        |	But the folio is still dirty, PAGECACHE_TAG_DIRTY is
>        |	kept
>        |
>        |- submit_one_sector() for range [4K, 8K)
>        |  |- btrfs_folio_clear_dirty()
>        |  |- btrfs_folio_set_writeback()
>        |     The folio already has writeback flag, no need to call
>        |     folio_start_writeback()
>        |
>        | ...
>        |- submit_one_sector() for range [60K, 64K)
> 	  |- btrfs_folio_clear_dirty()
> 	  |- btrfs_folio_set_writeback()
>              The folio already has writeback flag, no need to call
>              folio_start_writeback()
> 
> So the PAGECACHE_TAG_DIRTY is never cleared.
> 
> Meanwhile for the old code, before that commit, the sequence looks
> like:
> 
>  extent_write_cache_pages()
>  |- folio_clear_dirty_for_io()
>  |  The folio is still dirty, so continue to writeback.
>  |  But the folio dirty flag is cleared now.
>  |
>  |- extent_writepage()
>     |- extent_writepage_io()
>        |- submit_one_sector() for range [0, 4K)
>        |  |- btrfs_folio_clear_dirty()
>        |  |- btrfs_folio_set_writeback()
>        |     |- folio_start_writeback()
>        |        |- xas_clear(PAGECACHE_TAG)
>        |
>        |        It's the first writeback block, we set the writeback
>        |	flag for the folio.
>        |	And the folio is not dirty, PAGECACHE_TAG_DIRTY is
>        |        cleared
>        |
>        |- submit_one_sector() for range [4K, 8K)
>        |  |- btrfs_folio_clear_dirty()
>        |  |- btrfs_folio_set_writeback()
>        |     The folio already has writeback flag, no need to call
>        |     folio_start_writeback()
>        |
>        | ...
>        |- submit_one_sector() for range [60K, 64K)
> 	  |- btrfs_folio_clear_dirty()
> 	  |- btrfs_folio_set_writeback()
>              The folio already has writeback flag, no need to call
>              folio_start_writeback()
> 
> Unlike the new code, old code will clear PAGECACHE_TAG_DIRTY for the
> first writeback block.
> 
> There is a deeper problem, dirty and writeback folio flags are updated
> at very different timing.
> The dirty flag is only cleared when the last sub-folio block has dirty
> flag cleared.
> But the writeback flag is set when the first block starts writeback, and
> later blocks that go through writeback will not call
> folio_start_writeback() again.
> 
> If we rely on folio_start_writeback() to update the
> PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE, it will always be
> incorrect in one way or another.
> 
> [FIX]
> Do not let folio_start_writeback() do any PAGECACHE_TAG_TOWRITE
> handling.
> 
> Instead, manually clear both PAGECACHE_TAG_TOWRITE and
> PAGECACHE_TAG_DIRTY flags when the folio is no longer dirty during
> btrfs_subpage_set_writeback().
> 
> However this is only a hot-fix, for the long term solution we will
> follow iomap, by calling folio_start_writeback() immediately for the
> whole folio, and folio_end_writeback() after all writeback finished
> for the folio.
> 

Since I was planning to include exactly this as part of fixing the other
issue I found and this doesn't regress anything on its own, I agree we
should just get it in as is.

Reviewed-by: Boris Burkov <boris@bur.io>

> Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Completely decouple the PAGECACHE_TAG_* handling from
>   folio_start_writeback()
>   Since folio dirty and writeback flags are only updated once, but at
>   very different timings (the last dirty block cleared vs the first
>   writeback block started), we have to manually handle the
>   PAGECACHE_TAG_* update by ourselves.
> 
> - Add a mention about the proper fix using the same solution
>   as iomap
> ---
>  fs/btrfs/subpage.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
> index 56060acac2e9..2a9397be8116 100644
> --- a/fs/btrfs/subpage.c
> +++ b/fs/btrfs/subpage.c
> @@ -359,6 +359,23 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
>  	folio_mark_dirty(folio);
>  }
>  
> +static void folio_clear_tags(struct folio *folio)
> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +	XA_STATE(xas, &mapping->i_pages, folio->index);
> +	unsigned long flags;
> +
> +	ASSERT(folio_test_locked(folio));
> +	ASSERT(mapping);
> +	ASSERT(mapping_use_writeback_tags(mapping));
> +
> +	xas_lock_irqsave(&xas, flags);
> +	xas_load(&xas);
> +	xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
> +	xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
> +	xas_unlock_irqrestore(&xas, flags);
> +}
> +
>  /*
>   * Extra clear_and_test function for subpage dirty bitmap.
>   *
> @@ -403,7 +420,6 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
>  	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
>  							writeback, start, len);
>  	unsigned long flags;
> -	bool keep_write;
>  
>  	spin_lock_irqsave(&bfs->lock, flags);
>  	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> @@ -413,10 +429,14 @@ void btrfs_subpage_set_writeback(const struct btrfs_fs_info *fs_info,
>  	 * folio. Doing so can cause WB_SYNC_ALL writepages() to overlook it,
>  	 * assume writeback is complete, and exit too early — violating sync
>  	 * ordering guarantees.
> +	 *
> +	 * Instead we manually clear the DIRTY and TOWRITE tags after the folio
> +	 * is no longer dirty.
>  	 */
> -	keep_write = folio_test_dirty(folio);
>  	if (!folio_test_writeback(folio))
> -		__folio_start_writeback(folio, keep_write);
> +		__folio_start_writeback(folio, true);
> +	if (!folio_test_dirty(folio))
> +		folio_clear_tags(folio);
>  	spin_unlock_irqrestore(&bfs->lock, flags);
>  }
>  
> -- 
> 2.54.0
> 
