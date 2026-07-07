Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2F319B5B1
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 04:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783397787; cv=none; b=YLwLjdrsZ3kSFrQEhjUONTjFqtju4KxJnKbL8B4tB+rQ/iCNKiAUq6cypGYBlJbx7QUUfKTo1Wk/PV8dTVPm73JXqj/dLeKjnA7g8Uqj/m1zjXALM8tsSq6Xu5gbIO27ZD4VGxypIOfeZz/9hUiEoUa0FPnoUdvmH9Rg+nXpiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783397787; c=relaxed/simple;
	bh=VJ9VFkujmehc38ktxnrOv+07gUs71B7ctCDkhqmaMfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eufOtJWiqQd+V/cL1akfv5C+QlIcxk0pNMEpWI24/0YZteLFs3ycJCn8aQC3zgEH4bnevOBzeeHz4I4TCnTR16zVysdNioQ+qsWO8Jk/TvrbtLXS5pEne3Ub2EiP6y9sDSW8BtE2RBBu0BZqfA5fOGHAhvlAq2+DjYSfbaMZzb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=U7qQZC1P; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qU3F8icI; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="U7qQZC1P";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qU3F8icI"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A634314000F5;
	Tue,  7 Jul 2026 00:16:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 07 Jul 2026 00:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1783397784; x=1783484184; bh=/E1/8v+kog
	a7D4FGyiBkv4cn7tFMz+RS4FYjYS0Cx7I=; b=U7qQZC1P2TDDnuDS6jQXA7JBp5
	vm0vUUsVg5itDZ16Uj204ArQ5WK24W7V8Wg1Mmsfo/5FaKf6XKzvrAyt55fayvZO
	eLKacBDVw1UGI4wDU9UVCVeHTzu1lmenRPkYGFKu02CtcWyhIioKg/ioKGl0Yg3N
	Ybss1Dk7lBOCcUxga4eG16Itp6Pbo8PLhzS1Ad28kERqGxk9myTp7WN1wX/gPSDM
	D9iVswDL2MrQgtsYw1HZRb5kzAC/MqZGS2v+z5zi2VAXxmKwRaPAy2TvRFrvo500
	0gTqgaiskYg+V5zUzCusbZ5zItaylRF1dmHOJ6owiAc4BOj5S1xRe+02tpXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783397784; x=1783484184; bh=/E1/8v+koga7D4FGyiBkv4cn7tFMz+RS4FY
	jYS0Cx7I=; b=qU3F8icIVHMM8gb8lmHIVCQENN5+R+sQyOJFwGunTffoBbLg/yq
	PqshGr7ljLKFHRjQQekfxuUlBPyiAwVpsU0sReZH3sd0JZdJj7N23/6kldUUmDfE
	KvbV0J/k/lrXzCggJwlhSkIw4K8+4j/RH3Cwxog8IWjjTL8lXsKILXSd+2uLQviU
	rt1YyO0vERYI4MiOFoeWktUCdEwNWR4fS7nNp3exzz5c8WMY/H/7hc5UVpr0o4ox
	JSzKc02hDIsvBbPfFzBJ15Q3QNgNduiDTaCpxYwWJcoA9kFkLv463ee2HHoEZ6bH
	DMAYY8ZkPJWqLo1xZ7SYVKlmbFzxEj/ultA==
X-ME-Sender: <xms:mH1Maq6T9657pt7Z63PoGC1nTpIj9R_aRvpzeyXSdt8YlkTreu7TFw>
    <xme:mH1Map7UE89TZwrw9DyNtGWPqPXRH1MWFdUbPU0pUuS4c7_lguD5PdLq0gpphIqPS
    PtiCJVnnGRyUYO2tsZNtbtUOTh48I6qlCABK5_fgXkWTXungMxwrLY>
X-ME-Received: <xmr:mH1ManFxaDa8m_MWDF1SsW_Kk2tGZsW9vulD0YMPDPUXZZ06tFZqiFoziWuc2I8oQ26x_uKaBhls9oBBaxktcF0WD6c>
X-ME-Proxy-Cause: dmFkZTEFXEOLCIs4rWMwAd+NwS5th85M4EH2nTn+g6FKolDn9fHqMLRpp3FUYxomD/nDUe
    pCwps2onLvxDLZsvlslIoegp4IkPkU/Iik/0BGCcfMNRjDp4sCpLE4MmG0NtCHB5N5OmVl
    K+u1Sng/9+uSLItgjxiZ1Gk80gWmLpft4jCnnlpRr2Xm650RiF1ucjHr4qMA1i1AMws70Y
    NclLBDlHBWdkgLVoSE7rTKT7KF7UDGKcNJ5s96WcXTdWK82H68B6q6PNIkcZk1nXIYG5kz
    +ZGa/II/As1Vk2a/1vb1DBXKUPdpgHmuAklEKHilm/k/h+mxP5d5S/7zXsd9krkr6FtzNI
    SeLJ3NdCQuBaqPjxHqd2hRjgM/A0IXYfq3zqlnijiRYXX8OZDMHuRwdEjDFX5QgxOmCm7g
    cXw6KhQApLjem0WAFPCjFkzcNPHQURxGCYtzofo5Au8IUtJN5LeVm3lXzxZuXaM7sIwVZj
    Qo39VjmG8FEwgdGdafM8nANjczgmjwzUL/p8b/0wAkc8xzoBiPjBkKV9zYvrOeWykYA7rC
    2hTkU1BX0U5dfOSEiiGL9tUxaBBHzgLPNOb1wRZR0Iy8GxJtvRDw8hLMcAfHHujHy6hX1A
    xc4m0apnzCKQzPnygUe6sMGu4d7x0000tXABXYTXSiBLwRbyPAnegivpASuA
X-ME-Proxy: <xmx:mH1MaiQcarqXtexH7T13Vc__agL6pOvcj4DyEfT1rhFmFBtm3xbFzA>
    <xmx:mH1MagvRbMco9rXFpLjHOK64tNYWL_1NMBfr6QK4e3Lxmqk9VoGanQ>
    <xmx:mH1MahzP4IqhSVSAuupevJeEvWpMlC2tPXMUk1xiPOE0BBdKq4fJPg>
    <xmx:mH1Maq4JMC0klaoy-BNRBj4dvxpjnCrTGB5SYB3IFGo9ipQdmYvT3g>
    <xmx:mH1MakG_f6kJREdyrWhuZE2v-MqAmR7nPoUi0XZy2B9yXPr10a635Elz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 00:16:24 -0400 (EDT)
Date: Mon, 6 Jul 2026 21:14:51 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707041451.GA153025@zen.localdomain>
References: <02e6596cdba776b63528ead37324076dd664a11e.1783392018.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e6596cdba776b63528ead37324076dd664a11e.1783392018.git.wqu@suse.com>

On Tue, Jul 07, 2026 at 12:10:25PM +0930, Qu Wenruo wrote:
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
> The cachestat() go through the XArray of the page cache, but
> instead of checking each folio's flag, it uses the
> PAGECACHE_TAG_DIRTY tag to report dirty pages
> 
> Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
> btrfs replaced a folio_clear_dirty_for_io() call inside
> extent_write_cache_pages() with folio_test_dirty().

This is an interesting coincidence. I have been debugging this exact
change from a different, scarier perspective as well. Because we stopped
calling folio_clear_dirty_for_io() we stopped calling folio_mkclean()
which meant the folio remained writeable via mmap during writeback. We
observed a significant uptick of csum errors with large folios, as a
result. However, just this fix I think is not sufficient, and has two
serious bugs of its own.

First of all, now that your patch does clear dirty here, the keep_write
check in btrfs_subpage_start_writeback() is not correct anymore, which will
result in clearing TOWRITE on a non-sync writeback and losing it for
other pages in the folio on a sync writeback. So if we do clear dirty,
we need to also add a check for the subpage dirty bits for keep_write
like we did for extent_buffers before moving to the eb xarray.
Incidentally since that means not using __folio_start_writeback, it does
fix this exact bug too.

Second, and worse, it results in a deadlock which should show on btrfs/062
and btrfs/070, I believe. The problem is that clearing dirty at this point
results in a truncate being allowed to clean pages past the end of the
new file size without calling btrfs_mark_ordered_io_finished() so we
leak that OE unfinished and get stuck. This is caused by the other
patches which removed the Ordered bitmap tracking to reduce the bitmap
size, I believe, as we now use dirty to track the existence of OEs.

Can you confirm whether btrfs/062 and btrfs/070 finish for you every
time under this patch? If not, something about my test setup and yours
is different, or something is different on the branch I was working on.
I will try to re-test with your patches and my patches on for-next as
well.

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
> [FIX]
> Revert that folio_test_dirty() back to folio_clear_dirty_for_io(), and
> add a comment explaining why we need to use folio_clear_dirty_for_io().
> 
> Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8fbb798767ca..78bd4ec541f8 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2584,8 +2584,31 @@ static int extent_write_cache_pages(struct address_space *mapping,
>  				folio_wait_writeback(folio);
>  			}
>  
> +			/*
> +			 * For folios that are under writeback or no longer dirty,
> +			 * we can skip the folio.
> +			 *
> +			 * Here we have to call folio_clear_dirty_for_io() to clear
> +			 * the folio dirty flag.
> +			 *
> +			 * Without that call, btrfs_folio_set_writeback() will call
> +			 * folio_start_writeback() for the first block to be written back.
> +			 * But since the folio can still be dirty, e.g. other
> +			 * blocks inside the folio are still dirty,
> +			 * PAGECACHE_TAG_DIRTY will not be cleared.
> +			 *
> +			 * On the other hand, for btrfs_folio_set_writeback() of the
> +			 * last block, although the folio is no longer dirty,
> +			 * btrfs_folio_set_writeback() won't call folio_start_writeback()
> +			 * as the folio already has that flag.
> +			 *
> +			 * This means, if we only rely one btrfs_folio_*()
> +			 * helpers for both dirty and writeback flags,
> +			 * PAGECACHE_TAG_DIRTY will never be cleared for subpage cases.
> +			 * The only way to break out is to clear folio dirty here.
> +			 */
>  			if (folio_test_writeback(folio) ||
> -			    !folio_test_dirty(folio)) {
> +			    !folio_clear_dirty_for_io(folio)) {


So far, the best solution I have come up with is to call a raw
"folio_mkclean" here, as opposed to folio_clear_dirty_for_io().

a second place it is needed is in extent_range_clear_dirty_for_io()
which also used to call folio_clear_dirty_for_io() and needs stable
pages during the compression, for which we need to call folio_mkclean().

Sorry to derail your fix with a whole different problem.. But unless I
am missing something I think we will have to fix all of it to fix any of
it.
Either by fixing forward with folio_mkclean() or by reverting and/or
rethinking all of the patches in the series:
https://lore.kernel.org/linux-btrfs/cover.1778131118.git.wqu@suse.com/

specifically:
095be159f3eb ("btrfs: unify folio dirty flag clearing")
and
7d97bdca4bcb ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")

Thanks,
Boris

>  				folio_unlock(folio);
>  				continue;
>  			}
> -- 
> 2.54.0
> 
