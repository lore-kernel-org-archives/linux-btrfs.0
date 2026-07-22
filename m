Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80761FBEA6
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746953; cv=none; b=lQe2HfLD/s6BDBaKhJr5+eYfPCFYbh80R22+mYFq8tdQx+Ye3hpBlnKI+VeVZJOqcMsPODnPYf2omJH4fcofO9yNYUulvUgDSxb0yIuQZDY9iA7DVkLajJ6D/H6nbIJZONUrBDm62LoakMyPLqXDUjtseDcftAw2+4+fzLjMLQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746953; c=relaxed/simple;
	bh=gMopYG/OSdzIoLaMECT7b8vCEeRfaYt507I+a7HDflA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5pgwhXfkZXpqaLOyVo+am7fIo8pUUWELn20p6d2KP8Y3Elo1dwA3V2O9oIrvw3GBauSr0+C9FoSXB5IqfFtaKGHXXpXBxGbA/LfpFVW3CFkoF+n97rqUsr2uDXb32fvTt2UoyOwalaziyZoBtOEdkNClgq5v0tibEhK1O6sTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=oGx91o08; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UN5TowG0; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="oGx91o08";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UN5TowG0"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D8F9C7A00EC;
	Wed, 22 Jul 2026 15:01:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 22 Jul 2026 15:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784746908; x=1784833308; bh=1Wie/lDfl7
	0MfZg33tPrpskVaOfCeTL554/Raz67qiw=; b=oGx91o08XpoLplOsMOVGnOLEXj
	tBm7w25cts6Wj9e4d9S+yj7F2oNZ5pXGJQkS6JQJgXJfsKnIVdMfPb7BdTp+XlRR
	DvqLSusgR7iSD8DoRfElNmK/FF5zXwR/CZl66pFQCvOkJTo0WDg4CEKDZinQp/CH
	2YBobLBrlI2UiJLJimzJMZw45wlpWIvLuTyJESFrO6nzzfoMc9tnPK+BuzkLgxBa
	F4kHKHW5Sj2oE/UuHZxUUFS3C5vC94JsrxRTbmtzDGtxPPFBdHGp+STaJnBJ6PYJ
	WBnECdBFpyjfpY65WxgAA+E3HOnqKYSO3L6gAzxGWj7cp4AJFn5XMI4HGJAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784746908; x=1784833308; bh=1Wie/lDfl70MfZg33tPrpskVaOfCeTL554/
	Raz67qiw=; b=UN5TowG0yl0rxyESPngbrmUqlhvGHEeZg/gLmYVa1YTjfvPL2C2
	8Yj5zBA0gIWPMMOJGFkthgc9F4EI22oi7MYBtT0WJBpI6jXF45ir+xKVGCDkgM0Y
	E3LXnkf6DkubDkTCsMBjUJZBpZbKm3w9R8HZtKlf7M+YI7caWX3awQiRYvX6hXWK
	btfDgMA4ZN8p7Iljft6HxHc7lHb9gibCNgZDn0HOSVk1372hO3GLECqjVv2nGsdz
	eCgbLsdp0Yy/o41Li0vw+sJ3a3of9NxWyp0BN6DKt970u9KXbAndePQlO4RsA4Hc
	v5j58bP9lQEqcSysNhk8Z4JfNfAaacFGXQA==
X-ME-Sender: <xms:nBNhapCiJz7En2pPqO3ojNJpw7jk7vBSqT2D7oge46njSdpGbR28Tg>
    <xme:nBNhauZ92uoj0_C6NwbW2ulV_URTwFkcRafGOwUAeLkd2orOJPUIsxrD5kXmVfDdd
    7pEQ9DkdVfq38V9WT30LsMdisxfODPSJxuTNj1Pz279CB5jj3g8rQ0>
X-ME-Received: <xmr:nBNhas7RPnOKwfhkzLj4cQH3IKBtRRGt45SGDTtFWf4PzoFrO2iMSTlpQhQIWIB_BSNGilDburN-7_qp80u-yVtLri0>
X-ME-Proxy-Cause: dmFkZTErB0mXE1ys7uVSIbwZTE0VEWhN36dGtzT1z9+bTK7EuxVs4PPyiBDEXnTtlXXhBc
    QWxfnx3L+cTrfiW1Y6CmMOdVuo5N+jxVufJBFtNSahNcyHw0YU1+qVrJasPXIZt3gGoWSM
    WXx3kOLI+QYZeL9oePU9eSMiMyrmMced23vu9FjG0Zhkd8RmsZOdelwpXACL3LqdE/tq9/
    pY/z2We4U/cuFBnY/BgLxIa9ASpy6Y7PbMqR5k8ylxZShBUHjKHEu+Ohlb+GPFk2StTvXS
    ZPLPJlOHEcT0HphijiPuukKQe9YARRimNyBTEsR4PhEmJUXEa0v2S0l8YIkpFfP5AufNPH
    EH26npntqVGTceGu4vE1CUGUuo5O1a5b8doRuPWesCIM7itWWgc6UQUSlLNL9qy4OtBsml
    z4hIYk0ANeCLdUcbP55RoE18A3nby0PWeQWS9YrFYLgnhOnYiyeqEpJ+Ti/5VWUacd4jD4
    /intaQV6gC+PAaaCS3WDiMBTxF4DUjQDwNBv8fITBBhBH392hmsT54dM3fcQBdAaI48Jy8
    YOP/Q1Vk7GwRqezDldQLMuj1yDtqB5N/8kV+RZYyZ8i1c09OTJyO6DIDR/MWrr3kgLvJAA
    EoUAexu2tD5bQHwwA7R/8kRKHdIoHfaPm3OkvWCaOrKe9Lo+tHHN7E3k8UPg
X-ME-Proxy: <xmx:nBNhavaSxxXkNswnYnICCjtWJQ4s5WNSOpIy3BOxwJHQ7mkJZusOxQ>
    <xmx:nBNharhT4JdyEvjxBsa4mmnPOvP3UNvZ4hw0bEcRPJG6kBRk5jEmrQ>
    <xmx:nBNhag9PV_dhPDN-xFzEqHWhodD8y0eYoen3GVivSkZi0OzI93Xyhg>
    <xmx:nBNhamprQftRC2D2n3cgfl-3phL9bYJ1hdtITJH0zCjUeZ4yk40Zbw>
    <xmx:nBNhahel5jKQWPbjCnuu-MtEjb-mOarPqaO0ukO4Ouszk5bQeAKcjNju>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 15:01:48 -0400 (EDT)
Date: Wed, 22 Jul 2026 12:01:38 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/4] btrfs: zoned: flush active metadata block group at
 btree_writepages() start
Message-ID: <20260722190138.GA107842@zen.localdomain>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
 <20260722113016.1896990-2-johannes.thumshirn@wdc.com>
 <20260722170835.GB26033@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722170835.GB26033@zen.localdomain>

On Wed, Jul 22, 2026 at 10:08:35AM -0700, Boris Burkov wrote:
> On Wed, Jul 22, 2026 at 01:30:13PM +0200, Johannes Thumshirn wrote:
> > On a zoned filesystem btree_writepages() writes metadata in ascending
> 
> wording nit: isn't this true on non-zoned too? Maybe something like:
> btree_writepages() writes metadata in ascending logical order. On a
> zoned filsystem, which keeps a single .... <something terrible happens>
> 
> > logical address order and keeps a single active metadata/system block group,
> > pivoting it via btrfs_check_meta_write_pointer() -> check_bg_is_active() as
> > writeback moves between block groups.
> > 
> > If the active block group is at a higher address than another block group
> > that also has dirty metadata, the walk reaches the lower one first and the
> > pivot must finish the active block group. It cannot finish one that still has
> > unsent IO, and refuses to wait for it during WB_SYNC_ALL commit writeback, so
> 
> Can you add some more detail on why it refuses? Or why the pivot can't
> be the one to do these submissions? I think that would help fully
> motivate this change.
> 
> > btrfs_check_meta_write_pointer() returns -EAGAIN and the transaction is
> > aborted, forcing the filesystem read-only. This happens intermittently under
> > metadata-heavy relocation (e.g. fstests btrfs/187).
> > 
> > Flush the active metadata and system block groups at the start of
> > btree_writepages(), under the fs_info->zoned_meta_io_lock it already holds, so
> > they have no unsent IO and the later pivot can finish them.
> > 
> > Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
> > Assisted-by: LLM (debugging, commit message)
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  fs/btrfs/extent_io.c | 62 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 97bd18d515af..bac3edabe7c9 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2383,6 +2383,52 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
> >  	}
> >  }
> >  
> > +/* Write out the dirty metadata extent buffers of a single block group. */
> 
> This comment is quite generic, and not zoned specific, but the function
> name is much more zoned focused (and we assert zoned)
> 
> I am also not a huge fan of this code mostly duplicating the loop in
> btree_writepages while just leaving that spot open coded. Is that an
> intentional decision because of important distinctions between the two?
> Is there a variant we could lift to "write a range" and make
> flush_active_meta_bg() and btree_writepages share it? (like the while
> loop basically? or maybe the per-eb bit?)
> 
> note the missing call to btrfs_schedule_zone_finish_bg() I noted inline
> as a concrete reason it's helpful to not duplicate.
> 
> > +static void flush_active_meta_bg(struct address_space *mapping,
> > +				 struct writeback_control *wbc,
> > +				 struct btrfs_eb_write_context *ctx,
> > +				 struct btrfs_block_group *bg)
> > +{
> > +	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
> > +	unsigned long index = bg->start >> fs_info->nodesize_bits;
> > +	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
> > +	struct eb_batch batch;
> > +	unsigned int nr_ebs;
> > +
> > +	ASSERT(btrfs_is_zoned(fs_info));
> > +	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
> > +
> > +	eb_batch_init(&batch);
> > +	while (index <= end &&
> > +	       (nr_ebs = buffer_tree_get_ebs_tag(fs_info, &index, end,
> > +						 PAGECACHE_TAG_DIRTY, &batch))) {
> > +		struct extent_buffer *eb;
> > +
> > +		while ((eb = eb_batch_next(&batch)) != NULL) {
> > +			ctx->eb = eb;
> > +
> > +			/*
> > +			 * Best effort: if the eb is not writable at the write
> > +			 * pointer (e.g. a hole), stop flushing this bg and let
> > +			 * the main walk deal with it.
> > +			 */
> > +			if (btrfs_check_meta_write_pointer(eb->fs_info, ctx)) {
> > +				eb_batch_release(&batch);
> > +				return;
> > +			}
> > +
> > +			if (!lock_extent_buffer_for_io(eb, wbc))
> > +				continue;
> > +
> > +			if (ctx->zoned_bg)
> 
> the btree_writepages code also calls btrfs_schedule_zone_finish_bg()
> here, is that intentionally omitted?
> 
> > +				ctx->zoned_bg->meta_write_pointer += eb->len;
> > +			write_one_eb(eb, wbc);
> > +		}
> > +		eb_batch_release(&batch);
> > +		cond_resched();
> > +	}
> > +}
> > +
> >  int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
> >  {
> >  	struct btrfs_eb_write_context ctx = { .wbc = wbc };
> > @@ -2418,6 +2464,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
> >  	else
> >  		tag = PAGECACHE_TAG_DIRTY;
> >  	btrfs_zoned_meta_io_lock(fs_info);
> > +
> > +	/*
> > +	 * On a zoned filesystem, flush the currently active metadata/system
> > +	 * block group(s) first, under this same lock, so the ascending-address
> > +	 * walk below can pivot the active block group instead of aborting the
> > +	 * commit with -EAGAIN.
> > +	 */
> > +	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
> > +	    !wbc->for_sync) {
> > +		if (fs_info->active_meta_bg)
> > +			flush_active_meta_bg(mapping, wbc, &ctx,
> > +					     fs_info->active_meta_bg);
> > +		if (fs_info->active_system_bg)
> > +			flush_active_meta_bg(mapping, wbc, &ctx,
> > +					     fs_info->active_system_bg);
> > +	}
> 
> I think this placement makes sense, but I also wouldn't mind just having
> a more generic "eb ordering" concept that zoned could use to plug the
> active ebs to the front of the list then fallback to the normal order,
> or something. Not a deal breaker for me, just food for thought.
> 

Furthermore, I feel like this is actually quite redundant with the whole
EBUSY pivot logic.

So for random reclaim writeback, we walk the ebs in index order and skip
any not in the active bg if the active bg has dirty ebs. Then we reach
the active bg and flush it, submitting everything. Subsequent tries to
writeback the non-active will now wait on that submitted IO and
ultimately win and get to become active, and do more submission.

But we could save the bother and make things more direct and simple if
we just had btree_writepages() always write out the active bg first then
the rest. I don't know if we could fully delete the EBUSY, though, maybe
there is some racy case where it would still happen a bit, even if
mostly it didn't?

> I think fewer "tricks" for zoned writeback and more "it falls out
> correctly from a generic form" would make it easier to maintain in the
> long run. Obviously there are real, important differences so this kind
> of thing is never free...
> 
> Thanks,
> Boris
> 
> >  retry:
> >  	if (wbc->sync_mode == WB_SYNC_ALL)
> >  		buffer_tree_tag_for_writeback(fs_info, index, end);
> > -- 
> > 2.54.0
> > 
