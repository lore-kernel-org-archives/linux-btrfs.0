Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1835D23183F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 04:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783399999; cv=none; b=XQXMv5eZgUWF3u5QsYPF8f21l8ZsJsuL49y/plO22SYBysVFgHo5oXtYUGYwnCyd7paVZ6zhBrtL1eRyw7w30La2DOLPvsjJbxoW7HQwY/9KgO3zZpjccWbu8hsj/VM0zxrJTi6U+Ky6cuPxIoRP8zr0ooj+TFANt4EMiJwqa3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783399999; c=relaxed/simple;
	bh=Ls3cyqrhiPeT843c5oJf0kIeVffCN/maOl6emgOgu48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABKqmeM4k1wseNiIv1ROoKEUF/iQXqFit/KQXrnF/GXSE6AH96IhuoUR5rGM7ZfIiYpbkduJzIkso52VVP+5wDQqyiYF0e5pA6uQXQp1daSxyINNmmj7f5pQ03T6f4DYfxYmuVom6ffbHrv45r4RMVRpYAYT3BTOaljDQFK6tzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=hAbzmxh/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=fIBQiuzi; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="hAbzmxh/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="fIBQiuzi"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 39CE61400045;
	Tue,  7 Jul 2026 00:53:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 07 Jul 2026 00:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1783399997; x=1783486397; bh=jx7LFzo3eX
	xOFGb7e6mQ1kdak8t0Gr8NFj1HhI7Oa84=; b=hAbzmxh/59TUQ+kONfbe9VVwZY
	Qqy8zn2eZcifYGA9ztgzXjkHeXwqv48XCN1Q2z2WBIr4fLSmXgX/OIOIqXlLRVR8
	08wID9R9gLYGMV9/XDViAMiMbOS6AWPABkIRcGY/mSpcG9zmXCfpzSUbKiy+YDB3
	1AgtsNMXzMiD7V2T2+4OmERnrn0BU9v1UEs2i8P6RBGVa/bK1joV1inGwMfIbT8/
	1GlfS3YGfk81aT+BRuhKgZbTJvpdreFzgKg7L3q+emaeHcWpXTUJRpswFn53A/T2
	RJoPC+N+E5iFqL9uzKzjVxK2cjgqMipUXOBt3A7zeRUVjIBSmFCluhl7uRog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783399997; x=1783486397; bh=jx7LFzo3eXxOFGb7e6mQ1kdak8t0Gr8NFj1
	HhI7Oa84=; b=fIBQiuziKZ8K4gJdXcNkzaRkOWlM9PB2w8ofehkQ9JzjYV9Zujz
	oKLTeh2Gkj4baJjqHQkprbXQeBcX9tJ+4Qg0Cy2EDf412k0t43vJBt93yJvDtcYP
	u80zmE46QB4JT72sAD0arJ3khwW5x63ocQvRRwUaV2Ybaa6JGmpk/FwRhZ3mpcw7
	CV5bCZMJkPYN+KJjB50U0+CyChUCOF0CksNHzoSyUBooIZcOFfybN4whN1BEFXPg
	8CmwJC1ac5ATKolxX0ZF9GNpXXfDLSOf9nrIXl+oepdkTNdJ1ccNImExfrwj4Juo
	KFpeYvF33cwMGEZEeMCNn1pYHuznAiLd2eg==
X-ME-Sender: <xms:PIZMasz5svC47aRA2zTG4zICUrKrybfVj1FnWOlP8ePOfgLAdGEs_w>
    <xme:PIZMamRDRVHsZ0eHcAPgWbdWMmgsBQb-DsumlMgkzw84qpiPw91bd_Yz6sryRRRDA
    5dU0FsbnPJvdNP5Eq-tKp5_hhj4INJoi9W8Sx4ySielHhQycKbla8k>
X-ME-Received: <xmr:PIZMar9_guEoLQSvP3jrFlf_YgDQSznamS0F9Q8AYuRCAJy3nA1CpbdzCIXehq-8ELHYI-YG4k-PXqkfBk89J9EOFl0>
X-ME-Proxy-Cause: dmFkZTF8iqfzct5nO9KVMsM4/BX9cgZKzryHqtk3+U2eppFbn/P1J7tMdTkR0UtEvlOzH0
    29gqL5xMyuhDHFq4dA4PnKa9U4nhfy+wPPROxbHPVYHDJGnsHzsmQX4oBztxOl0pwQfsJx
    CvIn35rHuv/FSAPiQGaQyDoIA42a88lVLku4vcqR9ZrnGPME+PTu593gEzPEwHrJXaYL1u
    UyFxhfKO8EmLoXOVt6l4USmawAgXZ2zd+qLURiDxMDFDrHGehG+ppAgN5/9DWdvMxrJi7B
    caTEKMY5kcftqC+6GWe8orO82gn+nI5xF0pwuDS7dgv6B/3hwwt9QwzqjqkFu5P6NSykUg
    YNd5zWY4mJ1ahcEEKY7z8Gq6EyLlLy+RfOaJM1MZ8MXNkVJ7QCbcU/w8qRflS2KimByeKz
    8mX6WOlKkQAg4EXq+P7LAzr4EbYCMTLIEKaOAKRy9lkKAzDEC7h6JpB9T/kMVDzWls7UxY
    KFENrTZgfZ4iYNopS7l4PrvE7aahdji2s7FNLaPoS2w1SRndwUmCUS74OTaTPxbue7IzA9
    +n05N5yH0bImx8NNMwQeghn+/+iN3ipeN4UBcpe+eioIU0B75MSYNpXVYqjzd4bz2nhwJn
    GKpz1vcxzhkhqI+zMdeAQpU2XrXWBpsEIB6FCkKWSUCMtOYfVZLsc1Y+5Jiw
X-ME-Proxy: <xmx:PIZMalpHRNFSgfLcxEpii-dUtKkb6RZNrJCEjuxoJeMK--CGtBhVHw>
    <xmx:PIZMagm76y50sCn_HPvkEiBPgLbsFbytLbZlmWzWI0aaq6dqj7iWQg>
    <xmx:PIZMakKkTJyD9du03OAGdSIwdMDH5CTUP_mU0F8NsYZYxD9HVwKmQA>
    <xmx:PIZMatzuoewmJb4Gj2ie0pTYfOoPFa2H35i3v3pPU-ZmIbJ9TSOuFA>
    <xmx:PYZMas-oAmINgMLJZnhxDV6DVrYCwIVBjdmy4bjq4i6SPX-s3z06Ow8O>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 00:53:16 -0400 (EDT)
Date: Mon, 6 Jul 2026 21:51:51 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707045151.GA247134@zen.localdomain>
References: <02e6596cdba776b63528ead37324076dd664a11e.1783392018.git.wqu@suse.com>
 <20260707041451.GA153025@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707041451.GA153025@zen.localdomain>

On Mon, Jul 06, 2026 at 09:14:51PM -0700, Boris Burkov wrote:
> On Tue, Jul 07, 2026 at 12:10:25PM +0930, Qu Wenruo wrote:
> > [BUG]
> > The following script (already submitted as generic/798) will report
> > incorrect dirty page numbers, with 64K page size systems and 4K fs block
> > size:
> > 
> >  # mkfs.btrfs -s 4k -f $dev
> >  # mount $dev $mnt
> >  # xfs_io -f -c "pwrite 0 64K" -c fsync -c "cachestat 0 64K" $mnt/foobar
> >  Cached: 1, Dirty: 1, Writeback: 0, Evicted: 0, Recently Evicted: 0
> > 
> > Note that the dirtied page number is still 1.
> > 
> > [CAUSE]
> > The cachestat() go through the XArray of the page cache, but
> > instead of checking each folio's flag, it uses the
> > PAGECACHE_TAG_DIRTY tag to report dirty pages
> > 
> > Since commit 095be159f3eb ("btrfs: unify folio dirty flag clearing"),
> > btrfs replaced a folio_clear_dirty_for_io() call inside
> > extent_write_cache_pages() with folio_test_dirty().
> 
> This is an interesting coincidence. I have been debugging this exact
> change from a different, scarier perspective as well. Because we stopped
> calling folio_clear_dirty_for_io() we stopped calling folio_mkclean()
> which meant the folio remained writeable via mmap during writeback. We
> observed a significant uptick of csum errors with large folios, as a
> result. However, just this fix I think is not sufficient, and has two
> serious bugs of its own.
> 
> First of all, now that your patch does clear dirty here, the keep_write
> check in btrfs_subpage_start_writeback() is not correct anymore, which will
> result in clearing TOWRITE on a non-sync writeback and losing it for
> other pages in the folio on a sync writeback. So if we do clear dirty,
> we need to also add a check for the subpage dirty bits for keep_write
> like we did for extent_buffers before moving to the eb xarray.
> Incidentally since that means not using __folio_start_writeback, it does
> fix this exact bug too.
> 
> Second, and worse, it results in a deadlock which should show on btrfs/062
> and btrfs/070, I believe. The problem is that clearing dirty at this point
> results in a truncate being allowed to clean pages past the end of the
> new file size without calling btrfs_mark_ordered_io_finished() so we
> leak that OE unfinished and get stuck. This is caused by the other
> patches which removed the Ordered bitmap tracking to reduce the bitmap
> size, I believe, as we now use dirty to track the existence of OEs.
> 
> Can you confirm whether btrfs/062 and btrfs/070 finish for you every
> time under this patch? If not, something about my test setup and yours
> is different, or something is different on the branch I was working on.
> I will try to re-test with your patches and my patches on for-next as
> well.
> 

I re-tested by applying your patch to my for-next and I do believe b/062
hangs indefinitely, while it passes in ~45s for me normally.

> > 
> > This will cause the following call sequence for the folio at file offset
> > 0:
> > 
> >  extent_write_cache_pages()
> >  |- folio_test_dirty()
> >  |  The folio is still dirty, continue to writeback.
> >  |
> >  |- extent_writepage()
> >     |- extent_writepage_io()
> >        |- submit_one_sector() for range [0, 4K)
> >        |  |- btrfs_folio_clear_dirty()
> >        |  |- btrfs_folio_set_writeback()
> >        |     |- folio_start_writeback()
> >        |        It's the first writeback block, we set the writeback
> >        |	flag for the folio.
> >        |	But the folio is still dirty, PAGECACHE_TAG_DIRTY is
> >        |	kept
> >        |
> >        |- submit_one_sector() for range [4K, 8K)
> >        |  |- btrfs_folio_clear_dirty()
> >        |  |- btrfs_folio_set_writeback()
> >        |     The folio already has writeback flag, no need to call
> >        |     folio_start_writeback()
> >        |
> >        | ...
> >        |- submit_one_sector() for range [60K, 64K)
> > 	  |- btrfs_folio_clear_dirty()
> > 	  |- btrfs_folio_set_writeback()
> >              The folio already has writeback flag, no need to call
> >              folio_start_writeback()
> > 
> > So the PAGECACHE_TAG_DIRTY is never cleared.
> > 
> > Meanwhile for the old code, before that commit, the sequence looks
> > like:
> > 
> >  extent_write_cache_pages()
> >  |- folio_clear_dirty_for_io()
> >  |  The folio is still dirty, so continue to writeback.
> >  |  But the folio dirty flag is cleared now.
> >  |
> >  |- extent_writepage()
> >     |- extent_writepage_io()
> >        |- submit_one_sector() for range [0, 4K)
> >        |  |- btrfs_folio_clear_dirty()
> >        |  |- btrfs_folio_set_writeback()
> >        |     |- folio_start_writeback()
> >        |        |- xas_clear(PAGECACHE_TAG)
> >        |
> >        |        It's the first writeback block, we set the writeback
> >        |	flag for the folio.
> >        |	And the folio is not dirty, PAGECACHE_TAG_DIRTY is
> >        |        cleared
> >        |
> >        |- submit_one_sector() for range [4K, 8K)
> >        |  |- btrfs_folio_clear_dirty()
> >        |  |- btrfs_folio_set_writeback()
> >        |     The folio already has writeback flag, no need to call
> >        |     folio_start_writeback()
> >        |
> >        | ...
> >        |- submit_one_sector() for range [60K, 64K)
> > 	  |- btrfs_folio_clear_dirty()
> > 	  |- btrfs_folio_set_writeback()
> >              The folio already has writeback flag, no need to call
> >              folio_start_writeback()
> > 
> > Unlike the new code, old code will clear PAGECACHE_TAG_DIRTY for the
> > first writeback block.
> > 
> > [FIX]
> > Revert that folio_test_dirty() back to folio_clear_dirty_for_io(), and
> > add a comment explaining why we need to use folio_clear_dirty_for_io().
> > 
> > Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >  fs/btrfs/extent_io.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 8fbb798767ca..78bd4ec541f8 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2584,8 +2584,31 @@ static int extent_write_cache_pages(struct address_space *mapping,
> >  				folio_wait_writeback(folio);
> >  			}
> >  
> > +			/*
> > +			 * For folios that are under writeback or no longer dirty,
> > +			 * we can skip the folio.
> > +			 *
> > +			 * Here we have to call folio_clear_dirty_for_io() to clear
> > +			 * the folio dirty flag.
> > +			 *
> > +			 * Without that call, btrfs_folio_set_writeback() will call
> > +			 * folio_start_writeback() for the first block to be written back.
> > +			 * But since the folio can still be dirty, e.g. other
> > +			 * blocks inside the folio are still dirty,
> > +			 * PAGECACHE_TAG_DIRTY will not be cleared.
> > +			 *
> > +			 * On the other hand, for btrfs_folio_set_writeback() of the
> > +			 * last block, although the folio is no longer dirty,
> > +			 * btrfs_folio_set_writeback() won't call folio_start_writeback()
> > +			 * as the folio already has that flag.
> > +			 *
> > +			 * This means, if we only rely one btrfs_folio_*()
> > +			 * helpers for both dirty and writeback flags,
> > +			 * PAGECACHE_TAG_DIRTY will never be cleared for subpage cases.
> > +			 * The only way to break out is to clear folio dirty here.
> > +			 */
> >  			if (folio_test_writeback(folio) ||
> > -			    !folio_test_dirty(folio)) {
> > +			    !folio_clear_dirty_for_io(folio)) {
> 
> 
> So far, the best solution I have come up with is to call a raw
> "folio_mkclean" here, as opposed to folio_clear_dirty_for_io().
> 
> a second place it is needed is in extent_range_clear_dirty_for_io()
> which also used to call folio_clear_dirty_for_io() and needs stable
> pages during the compression, for which we need to call folio_mkclean().
> 
> Sorry to derail your fix with a whole different problem.. But unless I
> am missing something I think we will have to fix all of it to fix any of
> it.
> Either by fixing forward with folio_mkclean() or by reverting and/or
> rethinking all of the patches in the series:
> https://lore.kernel.org/linux-btrfs/cover.1778131118.git.wqu@suse.com/
> 
> specifically:
> 095be159f3eb ("btrfs: unify folio dirty flag clearing")
> and
> 7d97bdca4bcb ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> 
> Thanks,
> Boris
> 
> >  				folio_unlock(folio);
> >  				continue;
> >  			}
> > -- 
> > 2.54.0
> > 
