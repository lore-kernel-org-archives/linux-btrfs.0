Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E322F6560
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 23:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783466282; cv=none; b=WwuwpkCxJJy/IqYvKzRaRTtn/cSG5wOjjXr0AatpwXEMJrHempy2nq/IeC++IlzxBgNFPRLXEW2nBNBlgcJtZ7pqBP42AXulbfMaxe/157XacDgoCodfMqopvqMAWSxOLR0a/gkkAJHgjBqertQt4Ge3DLAnKxQ2Ac9t8nAdhrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783466282; c=relaxed/simple;
	bh=uGjlcHcPf3UmzfAqISkZmJGJOuxKAuZBlkYP0RA/6I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lg3n3eSR5GgwF67V1qKI3iH6V4YIVlH1iI32DzDBVnAy6/w54uKeoVYgdHz2sLOPf/xlvSy2mWPCS6mZqMQBUQVanQyWHL1mBM0VSFcTlaIDPQs/0ntjcIw8bBSpyl/hhi+uDy9d6p4mob9aNenIN0Kno7gCgHwurxq0NYzH2Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=nSjzRvc/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WiLYzxKJ; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="nSjzRvc/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WiLYzxKJ"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9C6977A00F9;
	Tue,  7 Jul 2026 19:17:59 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 07 Jul 2026 19:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783466279;
	 x=1783552679; bh=dm15xTfSLvYOwiRzOszLovFrkDgu7yyTvq+G0Pj+WbY=; b=
	nSjzRvc/vVxQ+uZF7cEYuH+IDbnMXOKK2S1CuIwxpFOnHLQFInmYOOlmRVHKLuS5
	PzHI5Ittp57MUoK0XmLJIiFcseQQDaBNPcHvjyGM6BG7ZvXUFPKVezrB8JHJWtR3
	7qw5cP8ohVrFYIodGgQBh8tsMPhbOJak5aLhZmqBQGMaFRt/EOjiZL2R5Z1jZKUB
	b9iuDgP/sEyaAstkdRnpKVylojlsV7P5Bb9ghMNexxJYQ2zbrhO/r69RooZmBuyC
	FAXfXD7kw4lhIECxoV7C+1qb9bCbMxEC0RYVQCam5HM70NGqxR9q8AhCXov/OExr
	k0SzUkl2RuFxrNZABZ8S0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783466279; x=
	1783552679; bh=dm15xTfSLvYOwiRzOszLovFrkDgu7yyTvq+G0Pj+WbY=; b=W
	iLYzxKJjKiXM8DHGDnoeeI/pVL471s8O1sWeduu2RYGKCDiLcI0iX9GiH71U1Lbn
	6VBcVs8flqrytwqeJO75VQQrmwZaAwKudbhbVmRbMSu0uNovCKeUhFKJcfsSkd9u
	fS0KJ+6VVGwlPKWdSGa9Xwh+d0GYAa57m0qKf/1oMW1wjPxGcL1yfR8hRHNBaAsj
	DJfZaXpHYyjVFcru0FlsOuLiA+YU72h8MqFVwKaShdABMBpinRVlNcelmhDNAvQb
	rqUrp7t0/7e3HfStDTKnR06UXsqhXE2QvRL7NXmDEeyE5LJVywPs5y5EU758h9dE
	d01IMKf2h7ctUrUJuM+MQ==
X-ME-Sender: <xms:J4lNagzvpRIXlm6wsBpPD81HDvgbGpVOHPLmrgyx2G2rmHUQ8t_WWQ>
    <xme:J4lNaruHTX7MEdBl1ulwI00QJn5PQDzK4xv_cGqsclq4kZpZhrO7MxmvcewO6Ilft
    bleDnWFfHbRDIo6iQuIqu6k7AjNldNKteqVIqQQWglZ5JoiAvloyJM>
X-ME-Received: <xmr:J4lNavvU1u13tGkFhh93kqSSJmURA0MvUb70o41fh4-9SMSq7Q2JdNGmA4mdtP62V2CYpplbYFVm9HZo9ZzOO-ikBRo>
X-ME-Proxy-Cause: dmFkZTEggzVCK/Rde8ocDwk+kEOJdMX852RXC/GAUdEv7KNT8G+URpuqUaqiwmxi5qbjl4
    +lsQiFiXrkyoIkPjVDkSJqSmiINjRwFF9h58/QPWjql8vwJa/PeDvba7X5sGO7K0kbUH5K
    gA8pO0B32ovp1EZT+U35FdG0l6gPLtBxXmBSar2r/IYyEVVDVHY29fT2W7JXydvqHYiuv4
    P2L6+D1Q4NeqUpcd5QqIo520CP+i7RlCCuSSu8Z0onIK5uN6z0cdhIQ24pb/IO7wH3WPjr
    rud0UZXjYJKExiVwhhljH0BHwynjRnOC6n/RABytafgG/+qtXngNoNswMnSSlJn/wG6AWh
    c///+2XgOkVW2Xr6t+GNqjkrgugXOh6PWDUOzAWtMgRlqx+uoSBtWZZWH+zYc91YHpMXCN
    U7bmp7Tbc835cm/hOBSrTNgNNvx6BIgfqfi20OIp/TmnHao4vBHiEIECHhofrEHOvMSy4x
    TEWo+pZE7LuYoBfNdRpxlmG1PRtGqG2mXKMnWi4dUIoFtsJiCCNoixAFYq5CxSDKWh7K2/
    8ZFtRJoQoZiLX0+06yErZW4bT2grJkjBXeM5dzzMSpkKsK4F26SFLJn9MoFBrKx1ZHxjwE
    aUg4gsWBZwD+wp6wdvPYNAqyw/+GhZggPvz6YJODiMNOu6Dxe2yQXDwWitXA
X-ME-Proxy: <xmx:J4lNaoO0ADIs7iSRQMK0SZap7SRNjqaZio_bASzqlyVbbJWUyievQQ>
    <xmx:J4lNal0JoFkora5V6javaQN64MBYOLvkiovxsQme9xEddJKB-aSuew>
    <xmx:J4lNasML20Ng4K2nV-ZSau3WOfHCfXpPLmirAslOyrfpfHrtRmloyg>
    <xmx:J4lNat09bBB9OLTv3kqane5EJNqZ2y5kDtnhQGeCCqkj-eSVPYDvlA>
    <xmx:J4lNah7_yFoTKiZtYQ8vbAbv6iYYDqR7Em4gfiU6Epko-W_fm-v4JBQT>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jul 2026 19:17:58 -0400 (EDT)
Date: Tue, 7 Jul 2026 16:16:32 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a regression where PAGECACHE_TAG_DIRTY is
 never cleared
Message-ID: <20260707231632.GA690447@zen.localdomain>
References: <20260707191208.GA516053@zen.localdomain>
 <58a76be5-12b2-469e-a9a0-146bfeb55773@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58a76be5-12b2-469e-a9a0-146bfeb55773@gmx.com>

On Wed, Jul 08, 2026 at 08:06:26AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/8 04:42, Boris Burkov 写道:
> > On Tue, Jul 07, 2026 at 03:10:20PM +0930, Qu Wenruo wrote:
> [...]
> > > 
> > > > 
> > > > Second, and worse, it results in a deadlock which should show on btrfs/062
> > > > and btrfs/070, I believe. The problem is that clearing dirty at this point
> > > > results in a truncate being allowed to clean pages past the end of the
> > > > new file size without calling btrfs_mark_ordered_io_finished() so we
> > > > leak that OE unfinished and get stuck.
> > > 
> > > Mind to explain exactly where the missing btrfs_mark_ordered_io_finished()
> > > is?
> > > 
> > > The point here is, we always have the folio locked already, the difference
> > > is just in the timing where the folio dirty flag is cleared.
> > > 
> > > I didn't see a problem that the changed timing can cause problem related to
> > > btrfs_mark_ordered_io_finished().
> > 
> > Sorry, my explanation last night was rushed and clumsy, let me try to be
> > much more clear and specific!
> > 
> > The key change is your recent one, that went together with the removal
> > of folio_clear_dirty_for_io():
> > 
> > 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> > 
> > and specifically the lines:
> > 
> >    /*
> >    * If the range is not dirty, the range has been submitted and
> >    * since we have waited for the writeback, endio has been
> >    * executed, thus we must skip the range to avoid double
> >    * accounting for the ordered extent.
> >    */
> >    if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
> >      goto next;
> > 
> > 
> > and quoting from the changelog:
> > 
> >    If the OE range is dirty, it means we have allocated an ordered extent but
> >    have not yet submitted the range. And that's exactly the case where we need
> >    to truncate the ordered extent.
> > 
> > But with this new fix, which returns folio_clear_dirty_for_io before
> > submission, the comment, skip, and changelog argument are no longer
> > true.
> > 
> > Suppose we dirty folios [F,F+K] at the end of a file and start writeback
> > on them, creating a single OE for [F, F+K]. extent_writepage will keep
> > looping through the folios submitting them.
> > 
> > Now suppose a truncate races in and shrinks i_size (taking i_rwsem but
> > no folio locks or blocking on OEs) via:
> > btrfs_setsize
> >    truncate_setsize
> >      i_size_write // shrinks i_size to M <= F
> >        truncate_pagecache
> >          folio_wait_writeback (not yet marked writeback)
> >          folio_invalidate
> >            btrfs_invalidate_folio (folio clean, skipped, this is the bug)
> 
> Just a small nitpick, the problem is not from the truncate_setsize() call
> site, as truncate_pagecache() is grabbing the folio with FGP_LOCK, so it can
> not grab the folio locked by writeback.
> 

Good point, but I think the issue is as soon as you do i_size_write(),
so the rest is just my explanation being a little misleading, I think.

> > 
> > extent_writepage hits the code
> > 
> >    if (folio->index > end_index ||
> >      (folio->index == end_index && !pg_offset)) {
> >        folio_invalidate(folio, 0, folio_size(folio));
> >        folio_unlock(folio);
> >        return 0;
> >    }
> > 
> > which calls btrfs_folio_invalidate() which needs to mark the OE past
> > isize finished but skips it because the folio is clean (same issue as in
> > truncate above)
> 
> Thanks a lot! Now I understand how things are going wrong now.
> 
> But I still have a question, I thought we should have some kind of inode
> lock or something else to prevent i_size_read() from getting stale results.
> 
> And digging deeper, for the btrfs_setsize(), the inode is already locked.
> E.g. inside notify_change() there is a WARN_ON_ONCE() if the inode is not
> locked.
> 
> Would the root cause of the problem is that we did not lock the inode for
> writeback?

yes, I think this path to the hang definitely requires the fact that
writeback does not hold i_rwsem while reading i_size.

> 
> And if we do not have proper inode lock for writeback, then I think write
> back should never bother the isize check, and always do the writeback no
> matter isize.
> 

Don't we risk weird truncate vs writeback races where they undo each
other, then? I assume taking the lock in writeback will be "correct" but
it might be slow or introduce some other locking order problem...

> > 
> > Now a bunch of processes, including a later call in the truncate itself,
> > will hang waiting on the OE which never finishes because these latter
> > folios never get submitted, nor does an invalidate truncate and finish
> > the lost OE.
> > 
> > Here are some trace printks showing the buggy sequence:
> > # btrfs_alloc_ordered_extent
> > 91.901347  OE-CREATE      ino=306 oe_off=3637248 num_bytes=73728 isize=4587672
> > # btrfs_setsize the file, changing memory isize to newsize < oe_off
> > 91.901392  TRUNCATE       ino=306 oldsize=4587672 newsize=2573711
> > # extent_writepage calls folio_invalidate for being past i_size (905 * 4096 = 3706880 > 2473711)
> > 91.901528  WB-INVALIDATE  ino=306 folio_idx=905 isize=2573711 dirty=0 writeback=0
> > # btrfs_invalidate_folio does goto next and skips calling btrfs_mark_ordered_extent_truncated()
> > 91.901531  SKIP-OE-FINISH ino=306 oe_off=3637248 bytes_left=73728 isize=2573711 writeback=0
> > 
> > I hope this is enough to figure out which one of us is missing
> > something! Sorry again for being so unclear earlier.
> > 
> > > > This is caused by the other
> > > > patches which removed the Ordered bitmap tracking to reduce the bitmap
> > > > size, I believe, as we now use dirty to track the existence of OEs.
> > > > 
> > > > Can you confirm whether btrfs/062 and btrfs/070 finish for you every
> > > > time under this patch? If not, something about my test setup and yours
> > > > is different, or something is different on the branch I was working on.
> > > > I will try to re-test with your patches and my patches on for-next as
> > > > well.
> > > 
> > > I have not yet experienced btrfs/062 nor btrfs/070 hang.
> > > 
> > 
> > I have reproduced it on two systems with your patch (x86 4k pages for both)
> > and also while working on my own version which was basically your patch with
> > a hack to clean up the TOWRITE bit only in btrfs_subpage_set_writeback().
> > 
> > While working on the details of my explanation for this email, I was
> > adding lots of printks and it did go away in one build, so I guess the
> > race between truncate and writeback is finicky enough that you are
> > getting unlucky? I played with some delays but haven't yet found a
> > perfect place to make it 100% reliable.
> > 
> > > [...]
> > > > >    			if (folio_test_writeback(folio) ||
> > > > > -			    !folio_test_dirty(folio)) {
> > > > > +			    !folio_clear_dirty_for_io(folio)) {
> > > > 
> > > > 
> > > > So far, the best solution I have come up with is to call a raw
> > > > "folio_mkclean" here, as opposed to folio_clear_dirty_for_io().
> > > 
> > > I believe the root cause is that we can not rely on folio_*_writeback()
> > > calls to do the sub-folio level handling correctly.
> > > 
> > > I think the long term solution would be the iomap solution by tracking how
> > > many write bytes are still pending, and only call folio_end_writeback()
> > > once.
> > 
> > I was not aware of this design, I'll look into it, thanks for the tip.
> 
> That has a lot of extra requirements, and may have also change the timing of
> a lot of beyond-isize handling.
> 
> And the biggest requirement is to get rid of the cursed async-submission
> from compression.
> 
> So we're still quite away from that.
> 
> > 
> > > 
> > > But for now, I think a quicker fix is, to de-couple the
> > > PAGECACHE_TAG_DIRTY/TOWRITE from folio_*_writeback().
> > > 
> > > The idea is, we clear PAGECACHE_TAG_DIRTY when the last subblock dirty flag
> > > is cleared.
> > > 
> > > Then do the same for PAGECACHE_TAG_TOWRITE, this time do not rely on
> > > __folio_end_writeback(), but manually do it inside
> > > btrfs_subpage_set_writeback().
> > 
> > I have been testing something hacky like this in
> > btrfs_subpage_set_writeback(), and I believe it is correct for TOWRITE
> > but still convincing myself about DIRTY.
> 
> Don't be too worry about that. Dirty tag can be cleared multiple times.
> 
> > Just putting code out to be
> > more concrete. I think it's clearly hacky, but it's something we have
> > thrown around before so it was easy to start with:
> > 
> >   	keep_write = folio_test_dirty(folio);
> >   	if (!folio_test_writeback(folio))
> >   		__folio_start_writeback(folio, keep_write);
> > +	if (!keep_write) {
> > +		struct address_space *mapping = folio_mapping(folio);
> > +		unsigned long xas_flags;
> > +		XA_STATE(xas, &mapping->i_pages, folio->index);
> > +
> > +		xas_lock_irqsave(&xas, xas_flags);
> > +		xas_load(&xas);
> > +		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
> > +		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
> > +		xas_unlock_irqrestore(&xas, xas_flags);
> > +	}
> 
> That's the version I have submitted as v2.
> 

Sounds good.

> >   	spin_unlock_irqrestore(&bfs->lock, flags);
> > 
> > > 
> > > 
> > > I think this would be much smaller, and completely free us from the special
> > > handling of folio_*_writeback().
> > 
> > Under your proposal would we still be calling folio_clear_dirty_for_io()
> > as in this current incomplete fix?
> 
> No, no folio_clear_dirty_for_io() call anymore, all changes are inside
> subpage.c now, just the extra PAGECACHE_TAG_* clearing during
> btrfs_subpage_set_writeback().
> 
> > You haven't commented yet either way
> > on your view of the importance of getting to a folio_mkclean() *somehow*
> > to write protect the folio, so I just wanted to make sure we were synced
> > on that, as that is what got me debugging this in the first place, not
> > the messed up PAGECACHE_TAG_DIRTY, which we obviously need to fix as
> > well!
> 
> Mind to explain why folio_mkclean() is required? Is it for the same OE hang
> or something else?
> 

No it's a csum corruption with mmap being allowed to write to folios
that are under writeback (and thus computing csums)

Since we got rid of folio_clear_dirty_for_io() (and thus
folio_mkclean()), then if we mmap a large folio, then start writeback on
it, we never write protect the folios while they are under writeback so
the mmap user can trigger write faults and mess up the csums. We have
observed this in practice in our early testing of btrfs large folios in
production and we also have a racy reproducer that enables large folios,
mmaps a file and has a bunch of threads racing between touching each
sector with some new random data and fsyncing the file. We do that a bunch
of times, then drop caches and read everything. Do that whole thing in a
loop a few times and eventually you hit it. I can share the exact LLM
reproducer slop code if you would like, but that is the rough shape, to
explain the point.

I can send my holistic fix proposal with your v2 included in a series?

> Thanks,
> Qu
> 
> > 
> > Thanks,
> > Boris
> > 
> > > 
> > > Thanks,
> > > Qu
> > > 
