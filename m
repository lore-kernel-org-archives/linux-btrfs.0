Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6A54ED1A8
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790625854; cv=none; b=WlqYZFKhgkQ9TxcD593ID2HUtlPZqNAje4gunqjhqoJNgh3t6Fh8PXKzfkLNg1bI6JCxOlCaFEekA4UFK2bxLrpxE27V3jaJh46WycOj4fk2S3xWy5nD0452g1PY5i1XsWHU8MUBD1Uijymk9qbdR4KLN00YM/bShUre//kj5ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790625854; c=relaxed/simple;
	bh=uJRGzr6F3r+bdwR7XLAi4qoMNqpI5zhjDZpBsyIXRz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/ueSjZSzchll7iM7OjItizSoomcjsf9IMkApYPjSgfF2gY1zSgi+b2yMLJ7qeYZC+TpK6GkGF17b0p9WKRFu26TqfbYk2NNNNfuCVeI1xo8zUvFhVaNYEa3Oiee0CVze7NTdh9DZ9tw5XxVw6IwwnqODUmp8AX1SQyazTY2Olc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ozVzIbFH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SGRrPmDn; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ozVzIbFH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SGRrPmDn"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id DC4C8EC00A4;
	Mon, 28 Sep 2026 16:04:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 28 Sep 2026 16:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1790625850;
	 x=1790712250; bh=w+SPbA60KHsIF2JLXBYdUeAoz3yreevbEjMw/+t6F1M=; b=
	ozVzIbFH3EdSqQOFFyKqQxeCf2OrQhLqVuc4WFIKV9IUHXv3dLT3uEpUqXIHaJhe
	9sjODTzaLsK8mqSlsvY9m7SkoxrCpZ4o1lpiaqCWiqtBPNtfSYGMlDJSmlTEkFjI
	30uRepCj37zOvj9e1sd188Yd9mtleW2ZFJ/JNjgE265f5LttX+MnD1R0i3Y/SX66
	Fvs+5/8S6piT8uwPNVkRibaUp1ORVRv+nY9nXt+37xsYOGdFwaprKnl4+Q8ZajiA
	xaiFyZdqwKH5JKFmgknthpKqQpOWX0KMaAJsRjjCw6CD6iZSSJWL/jj2gjeOIeYF
	qyUb+I3eJ+7xODiWXintzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790625850; x=
	1790712250; bh=w+SPbA60KHsIF2JLXBYdUeAoz3yreevbEjMw/+t6F1M=; b=S
	GRrPmDnnBi1VieW1d8BhwyQ3hLBUeu/zV1g4lgSVy9DehQvaRx9mLoml3UOH6vOA
	7FhNs0WZQSSy5BZg7tVeTNjhM1ZKy+uqWG5DNgSfBu1huvMGruiBNwBVQSqMo0qt
	QE3Ts77ma+xBIZz52wd4DNYH3CfDdEnDBIJPub67Jehffq9WSjbm1ZA7bwCbgFhq
	cK0LI4BNay2xoW0cIYKrbUepnJMvFEx8X+fUrvW9/sGIAKn+FLPs47yWXXdTjxi6
	VioRF4ebxH/h7Talzbo7e/tEsy5lE4yZpra0B9u1sHfN9vF6IMb6uKj9ztKPseKv
	i518EJEFZBQ1kECWjRZzw==
X-ME-Sender: <xms:Osi6albStsNvT8PINU4i1_A0dTXdkCwfleIIgcJy6jYhUuJtbC_n2g>
    <xme:Osi6aj3K6sJ5kZxoPIbVOsxhc92JazYZexNw31EuPupd9WInzanJOTdMjN2PsHO9M
    GIsWfTnzC_HDYaa1uttbWKxdPwvZzMtgbg7mssbeWtz3qrj7My8bpE>
X-ME-Received: <xmr:Osi6alXyZHqx2ZHiGqSa-YubOauMJBxQSapBpHHW09GWDzxj5g4B12I>
X-ME-Proxy-Cause: dmFkZTFwiaZCNZ8Jo06syCzqcqaCOT088sO2+Q/83dBXSZBTGd7GnuqJmjo7lvdhzj9qhI
    GEX/oEDGoo/COU20rr073LWOUcP8p4urbWelyaRovwyY7cN6x0Pb1DnXIKx04zPY8dd6Gu
    1zqdwqVwv0C/uMHs+Md5r6YRhc7lAHjBbU593AyQE2WHsWQFVInirToX9OyA2/RmcGOZA/
    pa9ec+UU04S8XRTx0ah6EqgWh8VXyaeciG4hwRZp2wBIe9bnP360kNYlhA3Ok+QjG3HmXb
    GsR4/uc+HMvQErZLPBFpsezGP8PHzIBm0vbyFKi2yk8MYAsZZeSGIOHy0ayo4VPTqarDjI
    JwBcqop1wJMJUoTb6WZWiaDclHnOZcRfSm7yNd/RtpdvVYt168iJTSVYZXxhqZx1UWSxtx
    MK7ZVRaCgyTJQx7LC40i43PTcwGIfd9/2BbkK5+L8qE/BbiAggTO2Tsz2o14N26oFby4Jd
    RqdcMBMQXK7CmxUaRylPnzdAQKRKn8NOMN6R4urnxJLl8X3KTXNR/kQ3dU+pOPNLv3xnGe
    3R3vtO34to8ReAAPRxFp78NI8l7SPjSwsUJv8X9gDNHbPpVHXV3Pole3HYD7rfD+5SSh9L
    TC+F9AEMX+hjLcuMH+h8IwH0XWWew1vsfC6O3HCeqrp3oKxTDrDDLjH29Ztw
X-ME-Proxy: <xmx:Osi6atUP2tMtIpN3K3ob_rTAFJKEbacuQLZxkXAI0F8HlTkJRY9wWQ>
    <xmx:Osi6akeXz9YH6m3FEUktiQjNiTeI3pa9ut8z0gZpDItbQl2w4tPl9w>
    <xmx:Osi6amW0UgoQy3jFDTqZH5yTy5cE3LiDHqd1hkVsJsmIDYDZ5mVTyA>
    <xmx:Osi6ateWOAS9mx2Z_bi-Sj-iZvHlEhjTl8yhszTP_WGgZKP2OfXo4Q>
    <xmx:Osi6amVoxz9l_AsTgA3zo3fr7T__8gCwzKIEh1o0ENPD4MlbsSK42lUT>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 16:04:10 -0400 (EDT)
Date: Mon, 28 Sep 2026 13:04:05 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: allocate additional SYSTEM space earlier
Message-ID: <20260928200405.GA1853679@zen.localdomain>
References: <cover.1790095812.git.boris@bur.io>
 <c68f903b219f964552a86fe969011cf819ef470d.1790095812.git.boris@bur.io>
 <CAL3q7H6rt2HxM59bAGM1ao2tOUYcEWCTdxAT9_MWBXfJEyrf-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6rt2HxM59bAGM1ao2tOUYcEWCTdxAT9_MWBXfJEyrf-g@mail.gmail.com>

On Mon, Sep 28, 2026 at 11:58:00AM +0100, Filipe Manana wrote:
> On Tue, Sep 22, 2026 at 5:57 PM Boris Burkov <boris@bur.io> wrote:
> >
> > Currently, reserve_chunk_space() allocates a new system chunk when the
> > space left is smaller than the reservation for a single chunk tree
> > update.
> >
> > Therefore, a filesystem in single metadata mode on a very large block
> > device can accumulate tens of thousands (TB) of chunks while never
> > allocating more than the original 4MiB SYSTEM block group created by
> > mkfs. If it then fills up (with large fallocates for example) and then
> > that data is freed, en-masse, we end up trying to delete thousands of
> > block groups in a single transaction in btrfs_delete_unused_bgs().
> >
> > This process touches most of the nodes and leaves of the chunk tree,
> > essentially trying to allocate roughly double the current usage of the
> > chunk tree for cow. When this runs into needing a fresh system chunk,
> > the fs is full of the empty bgs and we abort with ENOSPC in
> > btrfs_remove_chunk() like:
> >
> >   BTRFS error (device loop0 state A): Transaction 30733 aborted (-ENOSPC)
> >   space_info SYSTEM (sub-group id 0) has 0 free, is not full
> >   space_info total=4194304, used=3276800, pinned=0, reserved=917504, may_use=0, readonly=0 zone_unusable=0
> >   BTRFS: error (device loop0 state A) in btrfs_remove_chunk:3643: errno=-28 No space left
> >
> > This was seen on a 30TiB production filesystem with 10TiB of unused
> > block groups and reproduces on a 30TiB sparse loop device: mkfs with
> > -m single, fallocate 1GiB files until ENOSPC, delete two of every three
> > adjacent files, sync.
> >
> > To fix this, we should allocate the (relatively tiny) system chunks a
> > little bit more eagerly. If we do it when it is half full, we ensure we
> > can delete all of the block groups in one go. To fill up half of a 4MiB
> > system bg requires thousands of block_groups so this should only affect
> > very large fileystems.
> >
> > Assisted-by: LLM
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/block-group.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> > index 2eb09c9901c9..cf26dbeaabdb 100644
> > --- a/fs/btrfs/block-group.c
> > +++ b/fs/btrfs/block-group.c
> > @@ -1574,6 +1574,19 @@ static bool btrfs_link_bg_list(struct btrfs_block_group *bg, struct list_head *l
> >         return added;
> >  }
> >
> > +/*
> > + * Compute an upper bound on the bytes needed to modify every leaf in the chunk
> > + * tree. Normally, we could just allocate a new system chunk then, but that can
> > + * fail if there is no free space for a new dev extent. This can happen when
> > + * we fill up a large filesystem then rapidly delete a large portion of it.
> > + */
> > +static u64 system_space_needed(struct btrfs_space_info *sinfo)
> > +{
> > +       lockdep_assert_held(&sinfo->lock);
> > +
> > +       return btrfs_space_info_used(sinfo, true) + sinfo->bytes_used;
> > +}
> > +
> >  /*
> >   * Process the unused_bgs list and remove any that don't have any allocated
> >   * space inside of them.
> > @@ -1661,6 +1674,9 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >                 if (btrfs_is_block_group_used(block_group) ||
> >                     (block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) ||
> >                     list_is_singular(&block_group->list) ||
> > +                   ((block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
> > +                    space_info->total_bytes - block_group->length <
> > +                    system_space_needed(space_info)) ||
> >                     test_bit(BLOCK_GROUP_FLAG_FULLY_REMAPPED, &block_group->runtime_flags)) {
> >                         /*
> >                          * We want to bail if we made new allocations or have
> > @@ -1674,6 +1690,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
> >                          * next block group of this type would be created with a
> >                          * "single" profile (even if we're in a raid fs) because
> >                          * fs_info->avail_*_alloc_bits would be 0.
> > +                        *
> > +                        * Also bail out if this is a system block group that
> > +                        * system_space_needed() relies on to ensure head room for
> > +                        * mass deletion.
> >                          */
> >                         trace_btrfs_skip_unused_block_group(block_group);
> >                         spin_unlock(&block_group->lock);
> > @@ -4509,6 +4529,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
> >         struct btrfs_fs_info *fs_info = trans->fs_info;
> >         struct btrfs_space_info *info;
> >         u64 left;
> > +       bool low;
> >         int ret = 0;
> >
> >         /*
> > @@ -4520,6 +4541,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
> >         info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
> >         spin_lock(&info->lock);
> >         left = info->total_bytes - btrfs_space_info_used(info, true);
> > +       low = left < bytes || info->total_bytes < system_space_needed(info);
> >         spin_unlock(&info->lock);
> >
> >         if (left < bytes && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
> > @@ -4528,7 +4550,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
> >                 btrfs_dump_space_info(info, 0, false);
> >         }
> >
> > -       if (left < bytes) {
> > +       if (low) {
> >                 u64 flags = btrfs_system_alloc_profile(fs_info);
> >                 struct btrfs_block_group *bg;
> >                 struct btrfs_space_info *space_info;
> > @@ -4572,7 +4594,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
> >                 }
> >         }
> >
> > -       if (!ret) {
> > +       if (!ret || left >= bytes) {
> 
> So this hunk I have trouble understanding it, because if left >= bytes
> should always be true at this point, as if if left < bytes we have
> allocated a system chunk (if we haven't then ret has an error value).

It is a bit confusing and I am not sure how to make it as nice as
possible. So the condition is:

  low = left < bytes || info->total_bytes < system_space_needed(info)
  ...
  if (low) {
  ...
  }

So ret != 0 implies low is true, but not necessarily left < bytes.
Basically the idea is that if the chunk allocation designed to protect
the chunk space in the future fails but we still have enough for right
now (ret && left >= bytes) then we can still add bytes to the block_rsv.

Would it help if I tried to give separate names to the two conditions
and did something like:

needs_space = left < bytes
wants_space = total < system_space_target()
low = needs_space || wants_space

...

if (!ret || !needs_space) {
 ...
}

So rename system_space_needed() to system_space_target() or something
like that, and then differentiate the minimum to add to the block_rsv
more clearly from the desire to add a system chunk? The current
system_space_needed() is kinda misleaded cause with writeback re-cowing,
we might use more than that in a txn anyway so it is not a hard
guarantee.

Thanks for the review,
Boris

> 
> Otherwise it looks good (as well as the second patch).
> 
> Thanks.
> 
> >                 ret = btrfs_block_rsv_add(fs_info,
> >                                           &fs_info->chunk_block_rsv,
> >                                           bytes, BTRFS_RESERVE_NO_FLUSH);
> > --
> > 2.55.0
> >
> >
