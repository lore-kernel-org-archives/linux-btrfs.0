Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53EB36215B
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 20:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785010395; cv=none; b=OtcTg4HymyNdNwtmXyZKNbmxrDVPWR00bjvhofPwr7TCE1XLsuD4VdPlixWdbyKIiEI+UcJYC1K4n1QMiuImLexLsrAK9K5fUqb0Hq0TqUfaLAcGBY8Y7mdbNS5nlUgotwcvW/gqj04mbn/1ElsvZtp5onTybDBxy60+nX92LCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785010395; c=relaxed/simple;
	bh=RklfMEIjq/eIYHUMigL/QuXtZRnrbvMdVT0tfKL/u8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NiFRKlO7gBuaQouS4cuGLulxPsh1LCT2vERvp80aydHm4QdZquq6WeIQ0pjZovSuFO+lYtTOpvv9W57eMCl0IcMkIvSCxS4lmriCViiAjZUtPtTVTNvjj6Zd5im6RIXgNz8KyAFufIrwnCi75uGpehUd3ldlXDPawJEwb7sTKao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ZueLy4Fb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=j6ust9c8; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ZueLy4Fb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="j6ust9c8"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A19217A026C;
	Sat, 25 Jul 2026 16:13:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sat, 25 Jul 2026 16:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1785010391;
	 x=1785096791; bh=OdtXCotRBEsElPxjcKtOARrBz3SbTh2x+bRJsI1GJp0=; b=
	ZueLy4FbDvloeWPgKZ9Ku32RdtOnVFFBRAnlohlrLXDMy8aWeK/QrUcs9ZRzSk3J
	ejUjXR0a0+c5XsVKKGy5HzkaWpCdDkYyjf5BTfgl5vf9DrZcoBXwHdM/I+WvtzSS
	ulABwdERoGWaLJA19acUJUHghryaT5/Rzh8XCfVdy7EpIzj1tP7KfkFcPGvZhCKV
	MahXiv/DOCDTyVYDdyUvXQSqOLno6knVvRAZMIKG7g7IEXftOLGvFYCvXBf+9pnq
	7s/9rLK8dBumKe++Uls+GPlYcxWtoI5nG0yzwvF4fyN1gK8hVhiKGsM8MWfU0p1K
	IqeTimd15Qv9zbTOvwGzvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785010391; x=
	1785096791; bh=OdtXCotRBEsElPxjcKtOARrBz3SbTh2x+bRJsI1GJp0=; b=j
	6ust9c8z2Ze/b2qWAzgU/ssNs0tOXkRClD90XBt2K8UTS3wI387ALfn9sOmDYIjp
	vzAYJ14QsxyGsJPPCxlg4S3DdC5tBBHiXXboy1PeBHlBdHjM0ONs8G8w9YLHt7hx
	woUnIH/r1oXEaQjqX78y2vmB3nlyneCYb0lkrkOZoLidWBYoC+h67JzTMS1mPvKn
	eTqgFfUYRJTyDMd8SyHc5CyGF2pwILseJyS0zUpGpx/cHUKGBPTpzl7FBzCwxjzq
	/gmB3mCsy4mPAshiJCkQOq6rhMGQggmnnkASf0PmACdLep62oS9+hR2V6f7qNFm/
	aJY27V5XxfSokSy5kxXKA==
X-ME-Sender: <xms:1xhlaglnPphE6r3jMbS3HF3RbVzLTm64EzWFAwvsbdU6xk9kL_L0MA>
    <xme:1xhlanTsQV-6bKWuP1CK2O1nCMb-JGZb7TB4PUzBUM1NiaPB4aP7M-5BYNQpI3eKs
    ucSa64Svf8N7AKHCl619i69heG6bj66pkKQ1JqoBm3fSYlHSL_GLPro>
X-ME-Received: <xmr:1xhlasDt75BD7cJa265oZzxqg383yKK0B4JAQFPXY08LlZt1t_zsH1qTKmnWWkqCEIRb7pSu3lt-qCMXrf1IpezQ6F0>
X-ME-Proxy-Cause: dmFkZTFeNXZUtHrlUTVHFGwdcb8ZQVhtr2yzGfQo9m4HwbSjwG7OceSRULai550Wk4A9dD
    Cg+FJStWhurKS8naoAO3my6I4DrrKJ29A6soamY5NkaC91IHIu0awcJXC+JZRKN64gkwdP
    lgsWlllCJzH3y6EGg3Mx0qgXza9dtpkhtGNpPweP0sGQzpxoZp6SAyUaFRWmNbttTzvFal
    OngzcSO0vdyyVrXajr4glXlcoAAnw4KUpTVVv9GvsiNszu09v6Laoze4o2klKj2wt6H4vp
    eJ690PDIqxSA1kRUhrUWzFx6aQmplRGCeaoermLR5RfVHnC1pBvOivFD55z+y/tlO0E2E4
    FFO8tNqkHet0oywkfvzPHF7wDmFmmKTExkJwBeQ7vZfYtCjzX+puQJZVvy85xQI9jJKmkB
    +kXPfqaH4NQdI4GRTtMDGcfOF1pzJSh8xXQU9JSR5o00VZQLAS0oSRYA/fQDxAr7EFIC3a
    +iixSmpYD1Gf9NFhWQx2ZTQ1TiLH7mFCLk6ozexQoXrO5ym1OYlHsDEks4RFw/z/WNIl9F
    dD5iEhlC/6QdYVN9tEYIxhbEvvVziFRuBOfywvWnHWnFEbk8bSn95XabL3Zbx/ztInyTtF
    Z434q6UM5Ax+a7ossraJb0IvTUSRlQ0jV9NVvvFOzqKJ9FnRzipM9NGcG1Lw
X-ME-Proxy: <xmx:1xhlamQ-jdtYYPpc0bh8P7NkW_uFt-TRde6o7XJbfZYkLvYYy0LI_w>
    <xmx:1xhlairkwgfFwOwEnfQt_6wL9VFoOsFB8ysHbFq1eMumEUZBus1lFw>
    <xmx:1xhlagxjQjR8G1J2C2BGBncq8SkyO18w1Bnx7nrqCE6tj9ljxngGBw>
    <xmx:1xhlavL9Iwr7CobBKJNSMICVPUNYSc8V1SG2QRgjjE1zMDijcW7TVg>
    <xmx:1xhlah3jdAYSSgiusTZB7RAXH0oNzTpI1nvoYbncwUwngZ6qnjpByziE>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 25 Jul 2026 16:13:10 -0400 (EDT)
Date: Sat, 25 Jul 2026 13:12:56 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
Message-ID: <20260725201256.GA3089100@zen.localdomain>
References: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
 <dbb0e4ec-cdce-4852-9c1c-21634cc6fa4e@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbb0e4ec-cdce-4852-9c1c-21634cc6fa4e@gmx.com>

On Sat, Jul 25, 2026 at 07:34:46PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/25 15:54, Boris Burkov 写道:
> [...]>
> > Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > Assisted-by: LLM
> 
> Without LLM it's very hard to come up with such huge change in such a short
> time, especially considering this fix is a little urgent due to both large
> folio and removal of cow fixup are in the same release.
> 
> So I'm totally fine with the involvement of LLM, just we will spend quite
> some time reworking/removing a lot of comments/commit message.
> 
> Not because they are not not grammarly sound (unlike my replies), but a lot
> of time they are too lengthy but brings not too much value compared to the
> number of lines.

100% agreed, I tried to trim them down and rewrite them in human but
missed a bunch in the rush.

> 
> But still, very impressed to see a working RFC this soon.
> 

Thank you for the rapid, helpful review.

> > ---
> >   fs/btrfs/btrfs_inode.h       |   1 +
> >   fs/btrfs/defrag.c            |   1 +
> >   fs/btrfs/disk-io.c           |   6 +-
> >   fs/btrfs/extent_io.c         | 127 +++++++++++++++++
> >   fs/btrfs/file.c              |   2 +
> >   fs/btrfs/fs.h                |  20 +++
> >   fs/btrfs/inode.c             | 262 ++++++++++++++++++++++++++++++++++-
> >   fs/btrfs/reflink.c           |   1 +
> >   fs/btrfs/relocation.c        |   1 +
> >   fs/btrfs/subpage.c           |  93 +++++++++++++
> >   fs/btrfs/subpage.h           |  43 +++++-
> >   include/trace/events/btrfs.h |  35 +++++
> >   12 files changed, 585 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 7fdc6c3fd066..037445586b31 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -600,6 +600,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
> >   				    loff_t actual_len, u64 *alloc_hint);
> >   int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_folio,
> >   			     u64 start, u64 end, struct writeback_control *wbc);
> > +int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio);
> >   int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
> >   					     int compress_type);
> >   int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
> > diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> > index 6ec5dd760d42..7de5febee9d1 100644
> > --- a/fs/btrfs/defrag.c
> > +++ b/fs/btrfs/defrag.c
> > @@ -1158,6 +1158,7 @@ static void defrag_one_locked_target(struct btrfs_inode *inode,
> >   		    start + len <= folio_pos(folio))
> >   			continue;
> >   		btrfs_folio_clamp_set_dirty(fs_info, folio, start, len);
> > +		btrfs_folio_cancel_fixup(fs_info, folio, start, len);
> 
> This call is very frequent, and to be honest, it's redundant.
> 
> We can merge the cancel into btrfs_folio*_set_dirty(), as the
> btrfs_folio_*set_dirty() is the "proper dirty" entrance, so we know if we're
> going through that interface, we are ensured to cancel the fixup.
> 
> > +
> > +	if (!folio_test_fixup_pending(folio))
> 
> if (likely())
> 
> > +		return 0;
> > +
> > +	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
> > +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> > +
> > +		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
> > +						start + sectorsize - 1,
> > +						EXTENT_DELALLOC))
> 
> Can we simplify the check to just check if the fixup bit is not set?
> 
> To me, without fixup bit it means it went through the regular write
> preparation, thus should have EXTENT_DELALLOC.
> And checking a bit is way faster than check an extent range.
> 

the delalloc lookup is essential for bs == folio_size, to tell apart
the case where you are submitting a folio that got redirtied behind you
(don't skip) and the case where it is a true fixup.

Thinking about it more, though, that re-dirty shouldn't really be
possible at least in typical cases, so maybe I can figure out how to
remove this.

I think for subpage it probably doesn't matter, because those should not
have fixup in their bitmaps.

> > +			continue;
> > +		if (btrfs_is_subpage(fs_info, folio) &&
> > +		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize)) {
> 
> Again, we prefer not to use btrfs_is_subpage() and btrfs_subpage_*() out of
> subpage.c when possible.
> 
> So just some helper, like btrfs_folio_test_fixup() would make it more
> readable.
> 
> > +			struct btrfs_ordered_extent *ordered;
> > +
> > +			/*
> > +			 * Not a suspect: the only legal explanation for a
> > +			 * dirty, unfunded block is that it is pending its own
> > +			 * submission into a covering ordered extent - punting
> > +			 * it would starve that ordered extent forever, and
> > +			 * the worker could not see it anyway (its work list
> > +			 * is the fixup bits). Verify the ordered extent
> > +			 * exists; if not, the invariant is broken - leave the
> > +			 * block in the bitmap so submission fails loudly
> > +			 * (EUCLEAN) instead of silently repairing.
> > +			 */
> 
> The block can be dirtied properly before, then ->dirty_folio() callback is
> triggered.
> 
> In that case, we may have not run delalloc for the folio, thus there may be
> no OE created yet.
> 
> It looks like the assumption is not correct to me, and may cause false
> alerts.
> 
> But on the other hand, it's already very hard to hit a case where we have
> some proper dirty blocks, and ->dirty_folio() is called.
> E.g. for the direct IO case, ->dirty_folio() is only called when the folio
> is clean.
> 
> Thus this false alerts case is not easy to test.
> 
> > +			ordered = btrfs_lookup_ordered_range(inode, start,
> > +							     sectorsize);
> 
> Doing this is a little overkilled.
> 
> As the recent patch "btrfs: use ordered extent to grab the logical address
> for submission" will do it at submission time, with better cached OE usage.
> 
> I'd prefer skip the OE lookup completely, and let the final submission path
> to grab the OE (which can reuse bbio->ordered when possible).

Agreed. This is vestigial from a long period where ordered was really
important before I tightened the logic and left it as an assertion, but
that is a big overkill for not DEBUG at least. I'll either remove it or
hide it behind CONFIG_BTRFS_DEBUG.

> > +			if (unlikely(!ordered))
> > +				DEBUG_WARN();
> > +			else
> > +				btrfs_put_ordered_extent(ordered);
> > +			continue;
> > +		}
> > +		/*
> > +		 * Block re-dirtied via dirty_folio(), requires async fixup.
> > +		 * All other blocks in the folio should proceed as normal so
> > +		 * that their OEs can make progress and complete.
> > +		 */
> > +		bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
> > +		punt = true;
> 
> The variable naming choice is definitely very LLM.
> 
> Non-native speaker like me may need to google the word first...
> 

Yes, I hate when they do that. This one was just natural enough to me
that I let it go, but it is totally pointless jargon. I'll fix it.

> > +	}
> > +	if (punt) {
> > +		btrfs_queue_writepage_fixup(inode, folio);
> > +		/*
> > +		 * Keep the folio dirty for the punted blocks.  If nothing
> > +		 * is left to submit this pass, the folio is done and we own
> > +		 * the unlock, matching the async-submission contract.
> > +		 */
> > +		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
> 
> We haven't yet cleared any bit nor folio dirty in the first place.
> So not sure if this is really needed, nor the comment.
> 
> > +		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> > +			folio_unlock(folio);
> > +			return 1;
> > +		}
> > +		return 0;
> > +	}
> > +	/* Every dirty block is now covered; the folio is ordinary again. */
> > +	if (btrfs_is_subpage(fs_info, folio))
> > +		btrfs_subpage_clear_fixup(fs_info, folio, page_start,
> > +					  folio_size(folio));
> 
> Again, a btrfs_folio_clear_fixup() is more helpful.
> 
> [...]
> > +/*
> > + * The folio has (or, for single-block folios, is) dirty blocks that were
> > + * dirtied without notifying the filesystem (e.g. set_page_dirty_lock() on a
> > + * GUP pin) and carry no reservation.  Set by btrfs_data_dirty_folio(), which
> > + * records the affected blocks in the subpage fixup bitmap; cleared when the
> > + * writepage fixup has covered every dirty block, or by a reserving write
> > + * that covers the whole folio.  Reuses the PG_owner_2 bit that the folio
> > + * ordered flag occupied before it was removed.
> 
> Again, very LLM comments. That's why always delete all comments from LLM by
> default.

yup, haha missed this one. You would have loved the ones that got
deleted :D

it was like scrolls full of word salad at every if(...)

> 
> The older, removed comment is very simple for folio_ordered:
> 
>  * We use folio flag owner_2 to indicate there is an ordered extent with
>  * unfinished IO.
> 
> 
> [...]
> > +static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
> > +{
> > +	struct btrfs_writepage_fixup *fixup =
> > +		container_of(work, struct btrfs_writepage_fixup, work);
> > +	struct extent_state *cached_state = NULL;
> > +	struct extent_changeset *data_reserved = NULL;
> > +	unsigned long funded[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
> > +	struct folio *folio = fixup->folio;
> > +	struct btrfs_inode *inode = fixup->inode;
> > +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
> > +	const u32 sectorsize = fs_info->sectorsize;
> > +	const u64 page_start = folio_pos(folio);
> > +	const u64 page_end = folio_next_pos(folio) - 1;
> > +	unsigned int start_bit;
> > +	unsigned int end_bit;
> > +	unsigned int bit;
> > +	bool reserved;
> > +	int ret;
> > +
> > +	/*
> > +	 * Reserve for the whole folio before taking the folio lock, like
> > +	 * page_mkwrite: the reservation may flush, and flushing writeback
> > +	 * takes folio locks.  Which blocks actually need funding is only
> > +	 * knowable under the lock, so reserve the worst case and release
> > +	 * the unused ranges once the funded set is known.
> > +	 */
> > +	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
> > +					   folio_size(folio));
> 
> You fall into the same pitfall I'm worried about, but unfortunately or
> fortunately, it's very hard to hit.
> 
> The problem here is, we can over-reserve, e.g. some range is already
> properly dirtied, thus they have already space reserved.
> 
> And you can not release the reserved space for them, because release will
> also clear the qgroup reserved extent flag.
> 
> This is the biggest problem that I have no way to fix.
> As there is no way to ensure the space we reserved is really needed before
> holding the folio lock.

I think this approach here seems correct to me, except for maybe a
really mean case which calls aops->dirty_folio() without locking the folio
(not the case for dio read at least).

Won't any real reservation will cancel the fixup bits under the lock, so
the way this implementation tries to handle it is to reserve the whole
range then free the parts that don't end up getting in the "funded"
bitmap (also a bad LLM name...). This is checking the fixup bitmap under
the lock, so should see correct cancellations. Do you see an obvious
problem with that strategy, besides that it is kind of ugly and annoying
to handle the 'out:' path. Which feels similarly painful to a lot of our
other delalloc/qgroup_rsv unwinding logic with data_reserveds on OE error
or whatnot.

I think the clearer option of "take the lock, observe the real set,
release, then reserve, then take the lock and do all the work" sounds
appealing but almost certainly fails to some simple TOCTOU race.

> 
> 
> But since it's really hard to get a dirty folio to be called with
> ->dirty_folio(), thus it may not be exposed through tests.
> 
> > +	reserved = (ret == 0);
> > +again:
> > +	folio_lock(folio);
> > +
> > +	/*
> > +	 * The queueing writeback pass took references on the folio and the
> > +	 * inode, but nothing else is stable: an in-band write may have funded
> > +	 * the blocks and cancelled the fixup state, or the folio may have
> > +	 * been invalidated.  Then there is nothing left to do - and a failed
> > +	 * reservation against a folio that no longer needs one is no error.
> > +	 */
> > +	if (!folio->mapping || !folio_test_dirty(folio) ||
> > +	    !folio_test_fixup_pending(folio)) {
> > +		ret = 0;
> > +		goto out;
> > +	}
> > +
> > +	/* The folio still needs funding we could not get. */
> > +	if (ret)
> > +		goto out_error;
> > +
> > +	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> > +
> > +	for (bit = 0; bit < blocks_per_folio; bit++) {
> > +		struct btrfs_ordered_extent *ordered;
> > +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> > +
> > +		if (test_bit(bit, funded))
> > +			continue;
> > +		if (btrfs_is_subpage(fs_info, folio) &&
> > +		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize))
> > +			continue;
> > +		/* An in-band write may have funded the block while we waited. */
> > +		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
> > +						start + sectorsize - 1,
> > +						EXTENT_DELALLOC))
> > +			continue;
> > +		ordered = btrfs_lookup_ordered_range(inode, start, sectorsize);
> > +		if (ordered) {
> > +			trace_btrfs_writepage_fixup_defer(inode, ordered);
> > +			btrfs_unlock_extent(&inode->io_tree, page_start,
> > +					    page_end, &cached_state);
> > +			folio_unlock(folio);
> > +			btrfs_start_ordered_extent(ordered);
> > +			btrfs_put_ordered_extent(ordered);
> > +			goto again;
> > +		}
> > +		ret = btrfs_set_extent_delalloc(inode, start,
> > +						start + sectorsize - 1, 0,
> > +						&cached_state);
> > +		if (ret) {
> > +			btrfs_unlock_extent(&inode->io_tree, page_start,
> > +					    page_end, &cached_state);
> > +			goto out_error;
> > +		}
> > +		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
> > +		if (btrfs_is_subpage(fs_info, folio))
> > +			btrfs_subpage_clear_fixup(fs_info, folio, start,
> > +						  sectorsize);
> > +		__set_bit(bit, funded);
> 
> Why __set_bit() not set_bit()?
> 
> > +	}
> > +
> > +	/* Every fixup block is funded; the folio is ordinary again. */
> > +	folio_clear_fixup_pending(folio);
> > +	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> > +	goto out;
> > +
> > +out_error:
> > +	/*
> > +	 * The remaining unnotified blocks cannot be funded.  There is no
> > +	 * syscall to return this through, so surface it the way a failed
> > +	 * writeback would - record the error on the mapping - and drop the
> > +	 * blocks, or writeback would find and requeue them forever.
> > +	 */
> > +	mapping_set_error(folio->mapping, ret);
> > +	if (btrfs_is_subpage(fs_info, folio)) {
> > +		bool last = false;
> > +
> > +		for (bit = 0; bit < blocks_per_folio; bit++) {
> 
> Again, a proper btrfs_folio_clear_fixup() and pass the folio range into it
> should handle the loop.
> 
> > +			const u64 start = page_start +
> > +					  (bit << fs_info->sectorsize_bits);
> > +
> > +			if (!btrfs_subpage_test_fixup(fs_info, folio, start,
> > +						      sectorsize))
> > +				continue;
> > +			last = btrfs_subpage_clear_and_test_dirty(fs_info,
> > +							folio, start,
> > +							sectorsize);
> > +		}
> > +		btrfs_folio_cancel_fixup(fs_info, folio, page_start,
> > +					 folio_size(folio));
> > +		if (last)
> > +			folio_clear_dirty_for_io(folio);
> 
> Again, the regular btrfs_folio_clear_dirty() is going to handle all these,
> and no need for a special subpage branch.
> 
> > +	} else {
> > +		folio_clear_dirty_for_io(folio);
> > +	}
> > +	folio_clear_fixup_pending(folio);
> > +out:
> > +	if (reserved) {
> > +		btrfs_delalloc_release_extents(inode, folio_size(folio));
> > +		for_each_clear_bitrange(start_bit, end_bit, funded,
> > +					blocks_per_folio)
> > +			btrfs_delalloc_release_space(inode, data_reserved,
> > +				page_start + (start_bit << fs_info->sectorsize_bits),
> > +				(end_bit - start_bit) << fs_info->sectorsize_bits,
> > +				true);
> > +	}
> > +	folio_unlock(folio);
> > +	folio_put(folio);
> > +	kfree(fixup);
> > +	extent_changeset_free(data_reserved);
> > +	/*
> > +	 * As a precaution, do a delayed iput in case it would be the last
> > +	 * iput that could need flushing space. Recursing back to the fixup
> > +	 * worker would deadlock.
> > +	 */
> > +	btrfs_add_delayed_iput(inode);
> > +}
> [...]
> > +static bool btrfs_data_dirty_folio(struct address_space *mapping,
> > +				   struct folio *folio)
> > +{
> > +	struct btrfs_inode *inode = BTRFS_I(mapping->host);
> > +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +	bool marked = false;
> > +
> > +	if (btrfs_is_subpage(fs_info, folio)) {
> > +		const struct btrfs_folio_state *bfs = folio_get_private(folio);
> > +		const u64 page_start = folio_pos(folio);
> > +		const u64 range_end = min_t(u64, page_start + folio_size(folio),
> > +					    round_up(i_size_read(&inode->vfs_inode),
> > +						     fs_info->sectorsize));
> > +
> > +		if (!READ_ONCE(bfs->reserving_dirty) &&
> > +		    folio_test_uptodate(folio) && range_end > page_start)
> > +			marked = btrfs_subpage_set_fixup_dirty(fs_info, folio,
> > +							       page_start,
> > +							       range_end - page_start);
> > +	} else if (!folio_test_dirty(folio) &&
> > +		   !btrfs_test_range_bit_exists(&inode->io_tree,
> > +						folio_pos(folio),
> > +						folio_next_pos(folio) - 1,
> > +						EXTENT_DELALLOC)) {
> 
> Again, the same question why the folio_test_dirty() check is not enough.
> 
> The subpage part has no such check.
> 
> > +		marked = true;
> > +	}
> > +	if (marked)
> > +		folio_set_fixup_pending(folio);
> > +	return filemap_dirty_folio(mapping, folio);
> > +}
> > +
> [..]
> > --- a/fs/btrfs/subpage.c
> > +++ b/fs/btrfs/subpage.c
> > @@ -356,7 +356,17 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
> >   	spin_lock_irqsave(&bfs->lock, flags);
> >   	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> >   	spin_unlock_irqrestore(&bfs->lock, flags);
> > +	/*
> > +	 * Every caller of this helper is a reserving write path dirtying
> > +	 * exactly the range it reserved; the dirty_folio callback must not
> > +	 * treat it as potentially unnotified and drag the folio's clean
> > +	 * sibling blocks into COW (that breaks reflink sharing of the
> > +	 * untouched blocks, among other things).  Unnotified dirtiers call
> > +	 * folio_mark_dirty() directly and never pass through here.
> > +	 */
> > +	WRITE_ONCE(bfs->reserving_dirty, true);
> >   	folio_mark_dirty(folio);
> 
> My solution in my initial patchset is to not call folio_mark_dirty() as it
> will call back to the ->dirty_folio() call back.
> 
> So I implemented an local version which call back to filemap_mark_dirty(),
> other than ->dirty_folio() which sets the fixup bits.
> 

You mean to avoid the ugly bfs->reserving_dirty thing?
That does sound appealing...

> > +	WRITE_ONCE(bfs->reserving_dirty, false);
> >   }
> >   static void folio_clear_tags(struct folio *folio)
> > @@ -457,6 +467,88 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
> >   	spin_unlock_irqrestore(&bfs->lock, flags);
> >   }
> > +void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
> > +			       struct folio *folio, u64 start, u32 len)
> > +{
> > +	struct btrfs_folio_state *bfs = folio_get_private(folio);
> > +	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
> > +							fixup, start, len);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&bfs->lock, flags);
> > +	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
> > +	spin_unlock_irqrestore(&bfs->lock, flags);
> 
> Shouldn't we also check if we have cleared the last fixup bit and clear the
> folio fixup flag?
> [...]

yes, that seems like an obvious improvement. I think we get away with it
in a super stupid way that writepage_fixup will walk the bitmap and see
all clear and clear it there. Complete waste and adds risk for no
reason.

> > +void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
> > +			      struct folio *folio, u64 start, u32 len)
> 
> Why not let IMPLEMNT_BTRFS_PAGE_OPS() to implement all the fixup helpers?
> 
> [...]
> > @@ -50,6 +65,14 @@ enum {
> >   struct btrfs_folio_state {
> >   	/* Common members for both data and metadata pages */
> >   	spinlock_t lock;
> > +	/*
> > +	 * Set across the folio_mark_dirty() that a reserving write path
> > +	 * issues from btrfs_subpage_set_dirty(), so that the dirty_folio
> > +	 * callback does not treat the dirtying as potentially unnotified
> > +	 * and mark the folio's still-clean sibling blocks.  Written under
> > +	 * the folio lock, which every reserving path holds.
> > +	 */
> > +	bool reserving_dirty;
> 
> As I mentioned, this is only for dirty_folio() to skip setting fixup bit.
> 
> We can get rid of it, if the btrfs_folio_set_dirty() helper doesn't go
> through folio_mark_dirty().
> 
> Thanks,
> Qu
