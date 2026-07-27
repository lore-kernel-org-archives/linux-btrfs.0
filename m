Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDA418A6CF
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 03:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785124643; cv=none; b=UvxynI0uWJ+6N6O8bQvF41qAp8OzLPMmv3lb+4AKVH8f8ErejrQKZlQf7HtSUf3hHNUmrCtZ5XQ48QyBiHgc1Mfu4VuUc09ZO9dje0FhXGPjqvp8RzKXGKBjNtvL+ZFEdpPgVQvbiKyMxwUL1N/3gLVgQlUSbYovLMbznzZuzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785124643; c=relaxed/simple;
	bh=IYzeGl1v/2aYfPHSKdfO1NKBpzElEtgj8yTZlnz9p1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKlnkeTw3yPUhpD8dRHjbOmrFRt7Kk2xfIAMSpQE/hKhK21O5yJwJ272kU3cfe1OEO0P464Q0OPTvga2NglE6+16rd5CDGayItITDkoknBzan6lysARwqC3Kx+7Mb7Au0SqsANOxfXCue+8uiRk1UDGzBiQ8woOHwZbiUfr4pcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Nyf24nG4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lcK0lwP9; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Nyf24nG4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lcK0lwP9"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 37D1EEC024C;
	Sun, 26 Jul 2026 23:57:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Sun, 26 Jul 2026 23:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1785124640;
	 x=1785211040; bh=M7hurA9/rwGOLwQwH1K8GJW2nhJSZ5CV1fA/CcS/0aQ=; b=
	Nyf24nG4o762ieiz21Dt0wLO3Gb4EjUjJZUrZaHz/EM5ur9VrcjN+M1qrsQhz4Lv
	4tU/gVuIbHqKow0qCqS/4L3Yh7VKqLwopBrOr0Oc6nmohL8EhWc25QUHNAp6KFB5
	HnGLiQebE0S/w8mO7DR6ZpvGkWk8MYZuaMEUNUeaphwDyF9bv+q4U6niuOhfw8cL
	6Cbk4GmgIZ1mJksn/sciL45ijn4iyIyHKowG2wpG1HJJa9wK/Mc2ZVBdgxmS8m4v
	MfnXypmHwfSeajpm1qsdc8U0ALT5Of2ZzSw/f+pCaudWNOpxLJuW1yxjcOrhXf6y
	NbCl0EFDqOGnQdoo0u+3/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785124640; x=
	1785211040; bh=M7hurA9/rwGOLwQwH1K8GJW2nhJSZ5CV1fA/CcS/0aQ=; b=l
	cK0lwP93y6rKAnVqpu8EFQ5aJEIpa8V18BiJYOYbiazgFIzh8UnCfpuSm2HRk1MJ
	eULIrems7pErpzXvP0z+/EcOx2+wtFD1dMIIsBb1xqOy9GSdIR3g7qQXwBQPoizN
	7FKRkIWUFdtWxR30IXCx+lPZC0M9PDBEP6I2oQEAwtSLmZ870+LSyI6G7YUHk9qZ
	sOjmBj4fNVLCf2G7tHNwB/2E8TxyfqVTqpGwtcopaDlQjcAgP80CA3uNClUOh/VT
	Gn7RUPWr5F76McEv0YFOGdtVZNGzupI2lwXQvb+fJhNCiGH0FnaXt8tfYea4yDTl
	sZ1c+dDNyFZfR+73Pu+Tw==
X-ME-Sender: <xms:H9dmajqxf3fwc-p1kAuf3tG6qLcnMHRPOt4J1YhePpBAJnjRTNehgA>
    <xme:H9dmalGJ4vkBsvpCxjvLo7rPjUL4rTQMpKzgAhpzqIpys_VgJ3sZnfshTDJ7uUSSP
    W7exoiS26HpsGWxVARv3dSKLcvXPxw60HA4CQbsMel4AahxBmWW0Cc>
X-ME-Received: <xmr:H9dmatlF_fVpFwi-GYKdOgGxI_I4VY4IIrRNyWK-6Y6GnX4yOddD5lW4KpfUhq28DpdeBIqChjfRygsURyMs-2LD5x4>
X-ME-Proxy-Cause: dmFkZTFH3wTVrB3fv/FRIc50l0Nlfi3usDsOL6obZE8bbhoLYzE700AMnGbrr1tvxIstEk
    MJeMhZsV/6Ff7YM6iXLwIDvnQP/B3W3Az682YdRBkX9XQbOocVEjIgMXt0IxO78QvhfrZT
    sbrXM+I0H2R79mUAcED11K9BeGGjMZbcYvVn8sjFaShKzdqnEFEnkjKgkqRckP2n/VMcls
    DcJCP5VCzuCgXrBiJB+VhumZD0zMSdPP+9MZlNZ2LFnDVbkgzKQUpSqJ2C7jDzeo+ypFJy
    b+oPvL6xNMNY2uq20mdFxcNAKvAtBxHlAb2TjeeBOZzZbk2NG3gNhQ6AxdEn0DJFccfst6
    RuJ5PYouNQXhGlfB6h8+aYmDwjdIaeHJTJnB1uE0Si2gNsjAsCFzb+oK1Z3nre+9WLXrg7
    pFiVQyi8ItinR0bt8mo0u5x/Mr2beIy/GDECqT3bacrb5mK+tn/RdL1UrveRa7QUiEeIP8
    +i4yqnLi+G4PLuvybYewfI1N+6R/HN/uMwbuk0K3etPpoEFvmOgUpfs1O/KNFSsdWHN6jB
    yb0PW14orPOeEGPMfaOo9wM1yj7J1NxBgAfr6RsNoNHbG/KWBnQZXhesbHcm82aJ4xAX5C
    6DIMNQCN3AKpdIvYvrIEgY9kP2KXWmsOWmwjUW6UGI3FWrQ0CN6k1xUnvI6A
X-ME-Proxy: <xmx:H9dmagk3bsSk3XGB_f0rq-so4I6IWzWQaNwHer3J9OYB744fwdpigg>
    <xmx:H9dmamsADZ2fM9r9uH6-rTGVFZqZ-gqZMdMRJ5ZGZyfFd8Y7boEsvw>
    <xmx:H9dmarnQHsTIOmsxVMmSFhMGrUCiIP2lLR8BgevnVEizRC7NS0EbbQ>
    <xmx:H9dmapseBHdqLM-bxI6VuIY7o2NxXH-A1BmwQycqlK9mNKm3ExdxCA>
    <xmx:INdmarrDVPPDGn1jUHojlwUx9YsmkDrMBzyKJrMSp5iD2qwystGhK9_K>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Jul 2026 23:57:19 -0400 (EDT)
Date: Sun, 26 Jul 2026 20:57:02 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
Message-ID: <20260727035702.GA302657@zen.localdomain>
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
> 
> But still, very impressed to see a working RFC this soon.
> 
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

This was just inherited from the original fixup which had similar
conditions of dirtiness. I think it is probably vestigial. I am leaving
it in v2 for now since that is what I have tested the most, but I think
it is likely very possible to remove.

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

I think just being cute cause it's a local variable. I'll use set_bit to
not make it stick out as if it's an important choice.

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
> > +void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
> > +			      struct folio *folio, u64 start, u32 len)
> 
> Why not let IMPLEMNT_BTRFS_PAGE_OPS() to implement all the fixup helpers?
> 

I think the level 0 answer is it doesn't apply to metadata and the llm
also went nuts messing with the macros when it tried to use them.

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
