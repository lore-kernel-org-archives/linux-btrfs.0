Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1303F407CF9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781542369; cv=none; b=SikirdVdJlHfdG5j2oSWegc88osyU22MXP7ez5tsxBcHUn3m+1PjXPz7mrG8+AWrtraYrP0zzCN9MzNf5U+H3/Lz9cpcz/4maj5xk8lbqJu04DrkBd2NZWDg8Ti3SZfR96bGzYufaY8axqBLVgfHaJF2SVJz08N2F8YTZC8vCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781542369; c=relaxed/simple;
	bh=R8lW3iKwqEYSoN2BWSBhV2K+MnvR8iSY44JHOOZcTEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzlCTWvZzYp27M49SSzL7fG5Ubrvm7VUtG5BUhSCopGLIqvNeqUQsHuQImFgU3ZXuOVasXvxp36EzI9+WoDt9IK9bsLQiNiADhLS/eM0ljySmFm7XjzgeCysQJjpPgJsZBT8f7t6fl7YXUtmm25cvKBuDoUE95euDRh90oJVmus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=sGAq887v; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Pwqli85L; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="sGAq887v";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Pwqli85L"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 546F0EC0184;
	Mon, 15 Jun 2026 12:52:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 15 Jun 2026 12:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1781542367;
	 x=1781628767; bh=X0BGhxwxyyAXgSIhbPZj1Wf84l7ob16hco+B/020LuI=; b=
	sGAq887vLVEhCkLeYdEM6l96nRu3aGYyqjhSKIQc4Brs988GrRdhgkzgWO3geLI4
	oaOs12+Qun4cjlqOB8BoXG4yWiIovWgrS24si0LUNcpt7mpZxbuzwhX9BqO3HYrB
	zVnDLqFu7kDp5qnVb2cbbCFVcuysxZ0WLWWK3ULE6CZhPvjXTvxWxSxvTz/4/ein
	bn52axZFnN9QgL4eUpgo3C7DPpIrrlWAotAzXMOghumYF8jxedBuGVaWH0kmg2yX
	M9w4wMHYoYs3nyXTdIGwl42p1gf86aTekh+kh5tCDZGEp8tJwQ+GEpJaNKP89nq2
	8dc9fCRCsFF7AtAKdooyvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781542367; x=
	1781628767; bh=X0BGhxwxyyAXgSIhbPZj1Wf84l7ob16hco+B/020LuI=; b=P
	wqli85LxePighb2mMNS5LA0T9E0V1hq1m/f8JgCfjqEtYpn4a5BbWOa+k6pb7pj2
	nqDlGm71qjQVCI9qQfn/Yp+iU4vinsoT0/7wqVOEaXGHJuRBO1rupI5/fA5Db8ye
	4lDSLkkJmi3CiIMJqmj4q+e/dhf1PDfBJ8hdodZ6dryJNjGUk+IP6qQ3oKRlOI7f
	GEFyLlo6CshiXIhSRi3As4g2oebP4rGZunIjQkFEJSbRw65l/J7g2PkTNhlqUzfT
	Vmrb+SQg5lAIxgMgi+p4ySO63F571vos1RwWi3x7HAU2T6SQ00HUmTTJQnalZJrU
	Un58wkfcagWHOw6i8YxKQ==
X-ME-Sender: <xms:3y0waoW2DVI31aZe13ve6fgoj4vzfHG-O9bvaaAjQyUNGHrEQMs49Q>
    <xme:3y0wakAsQIz-AbuXMD5FhFex6PwucgFdNhCwIUJZIC8rrFOME6pfXxOojMfPzf5CX
    bBnXkDkpc3SsnyIPLN8IiKnaAhIpiZjcJG8G5tvsmQxcwGy9N_im08>
X-ME-Received: <xmr:3y0wapxfkt6SSj8U2EYRihh3Iwi1OG4tbVMwgWt8N2PP1ExNbafVZt18hGJon-lc6iXwR0n8CNKUL87vFUBOs7FRGUw>
X-ME-Proxy-Cause: dmFkZTFc7uYXI+/+dFssUQ0t4SoXLqpbAqTUMBxdUvhJyJncBRGsgF78951WD3h90hPzY2
    Q4kfzrRsfba9SdWAfb0safxNQ3JfJkJ3cwItmO4TdzDpABbhOXG/GB5TbjCmIrkEneJLEl
    TECE+mRLtUSzlPFM3bKktV092hbhMlZyLbc1rLJO9THDjFFVk7YofS/UTnO9PJhDy8fj4t
    KOlW5hx2i3hkbJXKetFZgk02IV76PvUq1QPgcIKltB+VvHwKLrG3Y0bMbyRO3ktQWakttS
    91kvQpqSHBm17IXRXob8xNpwOZTP3uShwJ+AjEtf2ZDoWGm7vjcAYl4mIxkR2a03jATFE4
    RulLHbk8dly6p+nfMBM771MD10hBS5aiC5hvyDMV1DCd2TAC9DUS/cIOEvS5EI3PRE9ai8
    iI+pZ1rcq6R3Kh+MexJWQbe3R16mEtJpfxEmtzilNxKtUBh1yiBJrrXRMgUEENBdbLob9k
    QfX4FMfSLmAbW4B1xmyqAZ60SqPQMZ2NgpUoraCTp9Jqvjp3vJqft4brfF/RZN20N6z/Ig
    Qa7kQ2lCzo0N0VXREh8XYkzauVCthLX3uTv0ecqeoG4+kEyMPeb/k2a1kVamta6YG7SPIF
    heQZOehC9OUCz04nXAnF30ozTWd/nAAD+uML+gpDUKBKw/tGNKyOcBEhqeMA
X-ME-Proxy: <xmx:3y0wahBh05o2Hn2S5-mEwhezt_lEOT0o5h-9J-acz3IsgIaUYUJw2g>
    <xmx:3y0wamYvVpqbZIfj_vSCwAfUGqNsbV99CAH8VtWpguW_W_6CMshQTg>
    <xmx:3y0waphT4VV2wJeu83P2hVTCwqmR6FUhxVAnofu_fXHX9BPmy2mueA>
    <xmx:3y0wao4x_k_G5P7TW8xQK-tsPipapypfh5rnEraJqllxrVd7M-Tiyg>
    <xmx:3y0waliCQhEEN0jmKFwzDVmgognbiqTblDuDWJKz5ro8z8reNSFiJ1T2>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Jun 2026 12:52:46 -0400 (EDT)
Date: Mon, 15 Jun 2026 09:51:59 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs: release extent lock per folio in readahead
Message-ID: <20260615165159.GA1594826@zen.localdomain>
References: <1ebca8b7936fb1191b03071f81faae0424d9ee93.1781540038.git.boris@bur.io>
 <CAL3q7H4R6M9GAJYEWVBiu-ZQxCgj22QdDeRJNA1Dt6j6EiCnaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H4R6M9GAJYEWVBiu-ZQxCgj22QdDeRJNA1Dt6j6EiCnaA@mail.gmail.com>

On Mon, Jun 15, 2026 at 05:32:26PM +0100, Filipe Manana wrote:
> On Mon, Jun 15, 2026 at 5:26 PM Boris Burkov <boris@bur.io> wrote:
> >
> > In Meta production, we have observed a large number of hosts running
> > kernels newer than 6.13 which hit hung tasks on
> > btrfs_read_folio()->lock_extents_for_read().
> 
> You mean a deadlock?
> 
> > Looking through the history
> > in this codepath reveals an interesting history.
> >
> > in 6.12, we merged
> > commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire read")
> > which holds the extent lock very narrowly while looking up the
> > extent_map. However, this proved to introduce a serious race with DIO
> > writes which was fixed in 6.14 with
> > commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between readahead and direct IO write")
> >
> > That latter fix subtly changed the extent unlock point from the pre-6.12
> > regime. In 6.11, each read endio unlocked the extent it finished
> > reading, but in 6.14, the extent is locked/unlocked as a unit around the
> > entire readahead loop, while the individual folios are still unlocked as
> > the endios finish. This is mostly the same behavior, as all successful
> > reads will populate the page cache, so subsequent reads won't enter
> > btrfs and hit the extent lock. But in the case where the readahead
> > fails, perhaps because of a memory allocation failure doing compressed
> > reads, the page will not be brought up to date and a later read of an
> > overlapping range *will* block on the extent lock.
> 
> Ok, but is it blocking indefinitely, a deadlock?
> 
> What is the problem exactly? The entire locked range is unlocked later.
> Can you explain this more clearly?
> 
> Thanks.
> 

Sorry for being insufficiently clear. I don't think that there is a
deadlock here. I think it is just a (hopefully) unnecessary degree of
contention on the extent lock that is showing in the tails of memory
pressure delays.

If you allow that on a sufficiently large, loaded system that direct
reclaim can run for minutes, and consider two tasks on such a system
reading an overlapping range of a compressed file:

Task 1 locks the whole range and starts to read. Some allocation for
the compressed read for folio F fails and we carry on while holding the
extent lock for the full range.

Task 2 wants to read F, which is not uptodate and in page cache, so it
blocks on the extent lock held by Task 1.

Task 1 is attempting to do compressed reads and keeps getting stuck in
direct reclaim.

The system wouldn't be all that healthy anyway, so this is not a
critical improvement, but it does alleviate just a bit of stress and one
thread's slowdown escalating to others.

There could be other delays/interactions from Task 1 besides getting
stuck in reclaim  after it passes a folio without bringing it uptodate
that I haven't thought of or reproduced yet, I just figured this was
sufficient to demonstrate something worth improving.

Unfortunately, I don't have rigorously collected holder data from the
prod instances. I am inferring some of the details from circumstantial
evidence and what I was able to reproduce (and delays I have observed in
the fleet generally). If you would like, I can attempt to gather more
prod evidence about the lock holder directly, but it's not trivial since
I can't predict when and where this sort of slowdown will happen.

Thanks,
Boris

> >
> > To bring this behavior back to the old model, we should unlock the
> > extent at each loop of the readahead loop rather than in one shot at the
> > end. This allows such overlapping reads to proceed as they should.
> > Writes are fine because either the page has already been read and has an
> > appropriate state in the page cache to be invalidated (or not uptodate)
> > or it is still-to-be-read and the extent lock is still held protecting
> > it.
> >
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> > Changelog:
> > v2:
> > - fixed the bug of unlocking readahead expansion extents that we did not
> >   ourselves lock.
> >
> >  fs/btrfs/extent_io.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index ce9aa0f6bc35..e0d24e69441a 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2745,12 +2745,23 @@ void btrfs_readahead(struct readahead_control *rac)
> >         struct fsverity_info *vi = NULL;
> >
> >         lock_extents_for_read(inode, start, end, &cached_state);
> > +       /* We don't use cached state for a bulk unlock, just free it. */
> > +       btrfs_free_extent_state(cached_state);
> >         if (start < i_size_read(vfs_inode))
> >                 vi = fsverity_get_info(vfs_inode);
> > -       while ((folio = readahead_folio(rac)) != NULL)
> > -               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> > +       while ((folio = readahead_folio(rac)) != NULL) {
> > +               /*
> > +                * Read start and end before btrfs_do_readpage(). It unlocks the
> > +                * folio, so our reference might not be valid after.
> > +                */
> > +               const u64 folio_start = folio_pos(folio);
> > +               const u64 folio_end = folio_start + folio_size(folio) - 1;
> >
> > -       btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
> > +               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> > +               /* Only unlock the range we locked, even if readahead expands. */
> > +               if (folio_start >= start && folio_end <= end)
> > +                       btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, NULL);
> > +       }
> >
> >         if (em_cached)
> >                 btrfs_free_extent_map(em_cached);
> > --
> > 2.54.0
> >
> >
