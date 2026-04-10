Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78E22D77E9
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 23:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775862383; cv=none; b=g/TPdj8jDKZ6ZLlBIAt/Nxk/iZlCdpoR8o4VKy7q607bjO5K0zYK7mKI6ASqCh9dG8VjTVZ7VYy5WzCx6r8EPpe5GIyfcQk3BML3PCVFHm9MKtBDlj6NZlq+mhSfQ6pLAadr0Tvq2nMrLiy5UJZRL1DJJl0bFOVcpB6XllKdjbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775862383; c=relaxed/simple;
	bh=b1lYL87Kef2L/GcmvJxp2HVW+nDoWv5mnCO14bB2gho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndG1cohTg3FIrqxPyHsOUt01ODwjLLeYCYduiPGs0X7vfaG+8QD451Rh979tdVW4gDnEyf2lyiYPinwvl8/cTBrJge/G10KBTDNOWSM1QyDCyvCf4folwGv8xRRADiV4ukz1pA6tWBH+GxiLNIOpRkpzPS+J6IOGQiZqF4jzNqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=syDNk3ZC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XNTtGrbX; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="syDNk3ZC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XNTtGrbX"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0EF417A0133;
	Fri, 10 Apr 2026 19:06:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 10 Apr 2026 19:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775862379;
	 x=1775948779; bh=CnUCa+ikwFHvH0K/IE//0a+QJrSKNk9ByVvh+cQIR08=; b=
	syDNk3ZCrxu4seXKE41GFOOoOnZECH73kTyib+JCK5Ani8JxYFGhGdol1wqetzcX
	OmHyxGxB+NZ6cSnq6HXJiRaFEx7t7SO0rnh02c0P3S6i4qk1Hg3O3TNheQK9cV4M
	ZQJq5Ji2TLykxyXUXTCcMPrA0lR2UKiyL3OdCDevCSVaxvMGgX/42q4ipSmTzc9O
	mLlVq+oPZpeWCeqsr/Q8wcuiWC5LBH+Ci7EyzCR7WcmPu5cCiUgQfmTVYG29taMW
	WD5CpeRrnkheHI3wR0pYDp1IO5g8jJe8qqomXD52Dms+FTrGRQvfFs9++9bNDSxb
	3lUXB2GEkbkmmoUDFir4dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775862379; x=
	1775948779; bh=CnUCa+ikwFHvH0K/IE//0a+QJrSKNk9ByVvh+cQIR08=; b=X
	NTtGrbX92U4JYAe7tAA0TWrwYgpgKdRNrgo0oiqE8IdSRH/Zg1dlUvTJdKQmRuIP
	VLVc+J2+NoP3xlGsNxkPmB3kCzeiqaAJNt3XwnCe70NypO1Ab4VwfClUOfIdbig2
	LVRTobYbhWD8gfMfTk0IQB8sCwUft/+anHv7NkJ9w5IQ52w2LOTalouS0ZVp559e
	FC7tnHTLfGylRx5NM74qadtppTWlMcoFT/ZapqwLk/mZc2HYKUSdUejhr5z/E42j
	LRwFxqtxzIkB6sklELHU0HaytJpUayCEsxE6mJ7n5sLLhsO3pUGekk56ERRPdui+
	V9llC3HpJ3NLfOx22Gj+w==
X-ME-Sender: <xms:a4LZaeljd1IdgspGCIN9LXBDcZn6n5d1-86rS7Du2O5mAfIOCm5XhA>
    <xme:a4LZadTXNjtFOP9uOQUU7rx2yk4AqMUgDcL54CU1lAxSNTTSJuSZnk5xuHFefaaP2
    _fmGXeJa6eGM5a-jmrU4lAzyjbaVQnOQvAwq8Z1-tlLQHOuZXg7oRM>
X-ME-Received: <xmr:a4LZaaBlMIABJwHe1XuFoBA1vtmkUhY31bLqDsqNQ-PUzUvpngwvNH_00MvvRwiamuV-iPPsGDU5YxXlb-OQccMcr30>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeftdejtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpedule
    fhtdfhteduvdethfeftdeitdethedvtdekvdeltddvveegtdeuuddtiedtieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfhgumhgrnhgrnhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    gsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghl
    qdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:a4LZacSIM2jq0EwwAtDDIG0skPVqG3f8xeY1bORUF3Vi2Ah2EnpcVA>
    <xmx:a4LZaQrP4iECDIS1gY-2t8QtLIhylRQxTZMjQT3cXEJlz4T_UqtvhA>
    <xmx:a4LZaWykXse9HW5-NcEEzWhz3YCMN3B7-iVQJm6tM_Vn57zZG3eVxw>
    <xmx:a4LZadITaJSr51Uu2CPqqU1wHuV8f-uCC9yUPZPGrt08zotaBSUeew>
    <xmx:a4LZaUyg1_eg4l9JQd0_ueOZ-DZLT9fnbwXjBJkIN_Bz8q4-_xb-uRyQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 19:06:19 -0400 (EDT)
Date: Fri, 10 Apr 2026 16:06:04 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
Message-ID: <20260410230528.GA1449614@zen.localdomain>
References: <cover.1775589916.git.boris@bur.io>
 <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
 <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>
 <20260408173425.GA2076825@zen.localdomain>
 <CAL3q7H5O47v2BW2pckyF9qgaLdLHefD5Bwh3VS+xgkBAUyYwPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5O47v2BW2pckyF9qgaLdLHefD5Bwh3VS+xgkBAUyYwPg@mail.gmail.com>

On Fri, Apr 10, 2026 at 04:27:28PM +0100, Filipe Manana wrote:
> On Wed, Apr 8, 2026 at 6:34 PM Boris Burkov <boris@bur.io> wrote:
> >
> > On Wed, Apr 08, 2026 at 03:56:14PM +0100, Filipe Manana wrote:
> > > On Tue, Apr 7, 2026 at 8:31 PM Boris Burkov <boris@bur.io> wrote:
> > > >
> > > > delalloc uses a per-inode block_rsv to perform metadata reservations for
> > > > the cow operations it anticipates based on the number of outstanding
> > > > extents. This calculation is done based on inode->outstanding_extents in
> > > > btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> > > > meticulously tracked as each ordered_extent is actually created in
> > > > writeback, but rather delalloc attempts to over-estimate and the
> > > > writeback and ordered_extent finish portions are responsible to release
> > > > all the reservation.
> > > >
> > > > However, there is a notable gap in this reservation, it reserves no
> > > > space for the resulting delayed_refs. If you compare to how
> > > > btrfs_start_transaction() reservations work, this is a noteable
> > > > difference.
> > > >
> > > > As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
> > > > that function will start generating delayed refs, which will draw from
> > > > the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():
> > > >
> > > > For example, we can trace the primary data delayed ref:
> > > >
> > > > btrfs_finish_one_ordered()
> > > >   insert_ordered_extent_file_extent()
> > > >     insert_reserved_file_extent()
> > > >       btrfs_alloc_reserved_file_extent()
> > > >         btrfs_add_delayed_data_ref()
> > > >           add_delayed_ref()
> > > >             btrfs_update_delayed_refs_rsv();
> > > >
> > > > This trans_handle was created in finish_one_ordered() with
> > > > btrfs_join_transaction() which calls start_transaction with
> > > > num_items=0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
> > > > has no reserved in h->delayed_rsv, as neither the num_items reservation
> > > > nor the btrfs_delayed_refs_rsv_refill() reservation is run.
> > > >
> > > > Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
> > > > fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.
> > > >
> > > > If a large amount of writeback happens all at once (perhaps due to
> > > > dirty_ratio being tuned too high), this results in, among other things,
> > > > erroneous assessments of the amount of delayed_refs reserved in the
> > > > metadata space reclaim logic, like need_preemptive_reclaim() which
> > > > relies on fs_info->delayed_rsv->reserved and even worse, poor decision
> > > > making in btrfs_preempt_reclaim_metadata_space() which counts
> > > > delalloc_bytes like so:
> > > >
> > > >   block_rsv_size = global_rsv_size +
> > > >           btrfs_block_rsv_reserved(delayed_block_rsv) +
> > > >           btrfs_block_rsv_reserved(delayed_refs_rsv) +
> > > >           btrfs_block_rsv_reserved(trans_rsv);
> > > >   delalloc_size = bytes_may_use - block_rsv_size;
> > > >
> > > > So all that lost delayed refs usage gets accounted as delalloc_size and
> > > > leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
> > > > further exacerbates the problem.
> > > >
> > > > With enough writeback around, we can run enough delalloc that we get
> > > > into async reclaim which starts blocking start_transaction() and
> > > > eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
> > > > the filesystem gets heavily blocked on metadata space in reserve_space(),
> > > > blocking all new transaction work until all the ordered_extents finish.
> > > >
> > > > If we had an accurate view of the reservation for delayed refs, then we
> > > > could mostly break this feedback loop in preemptive reclaim, and
> > > > generally would be able to make more accurate decisions with regards to
> > > > metadata space reclamation.
> > > >
> > > > This patch adds extra metadata reservation to the inode's block_rsv to
> > > > account for the delayed refs. When the ordered_extent finishes and we
> > > > are about to do work in the transaction that uses delayed refs, we
> > > > migrate enough for 1 extent. Since this is not necessarily perfect, we
> > > > have to be careful and do a "soft" migrate which succeeds even if there
> > > > is not enough reservation. This is strictly better than what we have and
> > > > also matches how the delayed ref rsv gets used in the transaction at
> > > > btrfs_update_delayed_refs_rsv().
> > > >
> > > > Aside from this data delayed_ref, there are also some metadata
> > > > delayed_refs to consider. These are:
> > > > - subvolume tree for the file extent item
> > > > - csum tree for data csums
> > > > - raid stripe tree if enabled
> > > > - free space tree if enabled
> > > >
> > > > So account for those delayed_refs in the reservation as well. This
> > > > greatly increases the size of the reservation as each metadata cow
> > > > results in two delayed refs: one add for the new block in
> > > > btrfs_alloc_tree_block() and one drop for the old in
> > > > btrfs_free_tree_block(). As a result, to be completely conservative,
> > > > we need to reserve 2 delayed refs worth of space for each cow.
> > > >
> > > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > > ---
> > > >  fs/btrfs/delalloc-space.c | 56 +++++++++++++++++++++++++++++++++++++++
> > > >  fs/btrfs/delalloc-space.h |  3 +++
> > > >  fs/btrfs/inode.c          |  2 ++
> > > >  fs/btrfs/transaction.c    | 36 +++++++++++--------------
> > > >  4 files changed, 76 insertions(+), 21 deletions(-)
> > > >
> > > > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > > > index 0970799d0aa4..c99f516ce8af 100644
> > > > --- a/fs/btrfs/delalloc-space.c
> > > > +++ b/fs/btrfs/delalloc-space.c
> > > > @@ -1,13 +1,16 @@
> > > >  // SPDX-License-Identifier: GPL-2.0
> > > >
> > > > +#include "linux/btrfs_tree.h"
> > >
> > > Not needed.
> > >
> > > >  #include "messages.h"
> > > >  #include "ctree.h"
> > > >  #include "delalloc-space.h"
> > > > +#include "delayed-ref.h"
> > > >  #include "block-rsv.h"
> > > >  #include "btrfs_inode.h"
> > > >  #include "space-info.h"
> > > >  #include "qgroup.h"
> > > >  #include "fs.h"
> > > > +#include "transaction.h"
> > > >
> > > >  /*
> > > >   * HOW DOES THIS WORK
> > > > @@ -247,6 +250,38 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> > > >                                                    qgroup_to_release);
> > > >  }
> > > >
> > > > +/*
> > > > + * Each delalloc extent could become an ordered_extent and end up inserting a
> > > > + * new data extent and modify a number of btrees. Each of those is associated with
> > > > + * adding delayed refs which need a corresponding delayed refs reservation.
> > > > + *
> > > > + * Each metadata cow operation results in an add and a drop delayed ref, both of
> > > > + * which call add_delayed_ref() and ultimately btrfs_update_delayed_refs_rsv(),
> > > > + * so each must account for 2 delayed refs.
> > > > + */
> > > > +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_inode *inode, u64 nr_extents)
> > > > +{
> > > > +       const struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > > > +
> > > > +       /*
> > > > +        * Factor for how many delayed refs updates we will generate per extent.
> > > > +        * Non-optional:
> > > > +        * extent tree: 1 data delayed ref.
> > >
> > > Running the delayed data ref to insert the extent item in the extent
> > > tree requires COWing an extent tree leaf, which creates a delayed tree
> > > ref for deletion too.
> > > So, 2.
> > >
> > > Otherwise it looks good, thanks.
> > >
> >
> > I think I might be getting confused now :)
> >
> > I'll try to work it out "out loud" and hopefully I can reach a good
> > conclusion.
> >
> > I have been trying to reserve for the calls to add_delayed_ref in the
> > transaction handle context. And tracing each cow in that context yields
> > 2 delayed refs each while tracing the data extent insertion only creates
> > one. The reason I care particularly about this context is the
> > trans_handle delayed_refs rsv accounting in
> > btrfs_update_delayed_refs_rsv(), as described in the patch. Ultimately,
> > all the reservations get sunk into the global reserve from
> > trans->delayed_rsv at btrfs_end_transaction(). Does this all sound right
> > to you so far?
> 
> Yes.
> 
> >
> > Cows that we clearly do from finish_one_ordered() are the ones to:
> > raid stripe tree, subvol tree, and csum tree. Notably, the free space
> > tree *does not* happen in this context, it happens when we run the
> > delayed ref, so I think I was not consistent to include that. In that
> > context we cow the extent and free space tree for the data extent.
> 
> Yes.
> 
> But the issue is that if we get a lot of delalloc and run it, we may
> generate many delayed refs - those directly created by ordered extent
> completion operations as you mention.
> 
> Then when we run them, either during the early phase of a transaction
> commit or from the space flushing code, we will generate more delayed
> refs to update the extent and free space trees (for COWing).
> During that time we are running them, we will try to use space from
> the global (fs_info->delayed_refs_rsv) delayed refs reserve and if
> that fails, we try the global reserve.
> 
> Our calculations are pessimistic so even if we don't account for all
> delayed refs, it's ok most of the time since the calculations assume
> we have trees with a height of 8 and that we get node splits at every
> level of a tree.
> So that ends up compensating unless we have a really large amount of
> delayed refs.
> 
> Sure that once we COW a leaf from the extent or free space tree, we
> will not need to COW it again for every subsequent modification.
> However, memory pressure or a call to btrfs_btree_balance_dirty() from
> some other task can flush every COWed leaf/node, requiring another COW
> operation.
> 
> So, in extreme cases, we could eventually run out of space. We
> sporadically see reports of transaction aborts with -ENOSPC when
> running delayed refs, both upstream and downstream. This isn't new;
> it's been like this forever.
> 

All makes sense, and agreed.

> >
> > But the point of reserving for a delayed ref is to account for the cows
> > that it will ultimately cause and reserve ahead for them. So I think it
> > does make sense to reserve for the fst and extent tree. On the other
> > hand, I think we actively *don't* want to account for the potential
> > infinite regress where each metadata delayed_ref run "unluckily" results
> > in cow-ing the extent tree again and again since it doesn't actually
> > happen in practice (especially with Leo's writeback inhibition and
> > hopefully eb overwriting soon). That series diverges so it would require
> > an infinite reservation anyway.
> 
> The writeback inhibition thing doesn't prevent what I mentioned
> before, it only applies when a tree modification must restart.
> I'm talking about subsequent tree modifications that require COWing
> the same nodes/leaves because writeback was triggered for the btree
> inode in between.
> 

+1

> >
> > In conclusion, I think I am agreeing and proposing that I shift the goal
> > from "count add_delayed_ref calls under the trans handle" to "predict
> > metadata reservation due to delayed refs" and in that world, it should
> > be 2 for the data extent in the extent tree.
> >
> > The other principled option is to count 1 for the data delayed ref now
> > and not account for the fst or the extent tree cows that happen at
> > delayed_refs time, but I think that makes less sense.
> 
> And how would you do that?
> Because running delayed refs happens normally at transaction commit
> time, both before and after the critical section, or when flushing
> space.
> Those are places where I don't see how we can reserve space.
> 
> >
> > Sorry if that was a lot of text to just agree with you, but I want to be
> > careful since it's easy to go astray and "get away with it" cause of the
> > reservations being conservative and getting sloshed into the global
> > reserves.
> 
> No worries.
> 
> >
> > One final note / question:
> > the "normal" start_transaction() reservation which computes the space
> > for the cow itself and then the delayed_refs cows does *not* seem to
> > count 2 per cow for delayed refs in btrfs_calc_delayed_ref_bytes().
> > But in theory the same reasoning applies that we will touch two metadata
> > items for each cow.  I assume this is OK in practice because the depth
> > is generally not 8 anyway, but do you think that is something I should
> > clean up as well?
> 
> Yes, we have a lot of places where we don't account for everything.
> Either because someone forgot about it or because we don't know in
> advance how much we will need.
> 
> For example, assuming an entire delalloc range up to 128M results in a
> single extent is very optimistic.
> We assume this, but we don't know until we actually run writeback and
> try to reserve space - a 32M write might only be satisfied by
> allocating 8192 4K extents due to fragmentation - yet we reserve space
> accounting for a single extent.
> 
> I've seen cases where this resulted in a transaction abort, with
> -ENOSPC, during ordered extent completion.
> 
> One thing to pay special attention to, is that if we start reserving a
> lot more space, some tests that currently pass may start failing with
> -ENOSPC or they may take significantly longer due to more space
> flushing.
> It's a very tricky area. I've experienced this pain several times in the past.

Yes, I haven't concretely felt this ENOSPC or excessive flushing pain
enough yet, so I feel a bit guilty for just cranking the rsv up and up
and up without any consequence.. Like, why not make the depth guess
8->100 and be even better? (Obviously bad idea, just rhetorical). I also
wouldn't propose reserving space hyper pessimistically in every
dimension, like assuming min extents instead of max extents.

I feel we have an inherent tension between optimistic reservation (e.g.
assuming we delalloc large extents) and pessimistic reservation (e.g.
assuming we have depth 8 and cow every layer with a split).

What do you think about moving towards trying to make on-average
accurate reservations?

What I mean by that is something like:
do change the start_transaction delrefs to account for cow "correctly"
detect / track depth (per root? global max?)
track splitting "risk"
expose a better sense for the fragmentation to rsv (we have the size
indexed free space rbtrees already)
etc...

And instead of a mix of over-guessing and under-guessing we generally
try to right-size the guesses, and bake in some intentional
conservatism.

Put another way, it feels quite precarious as making an "improvement"
like not reserving all the impossible depth reservations actually just
enospc aborts everybody horribly because we relied on it getting to the
global reserves. Or perhaps this change of mine will cause horrible
flushing problems elsewhere despite helping this heavy writeback
workload.

Working on this would of course require investing in some more workloads
and/or reproducers to cover the various tradeoffs you brought up.

> 
> So it's probably better if this patch accounts only for delayed refs
> generated during extent completion.
> I noticed you already sent a new patch version before I could reply, I
> will look at it now.
> 
> Thanks.
> 

Thank you for the in-depth discussion, by the way, it was really helpful
for me.

Boris

> >
> > Thanks again,
> > Boris
> >
> > > > +        * subvolume tree: 1 cow => 2 metadata delayed refs.
> > > > +        */
> > > > +       int factor = 3;
> > > > +
> > > > +       /* The remaining trees are only written to conditionally. */
> > > > +       if (!(inode->flags & BTRFS_INODE_NODATASUM))
> > > > +               factor += 2;
> > > > +       if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
> > > > +               factor += 2;
> > > > +       if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> > > > +               factor += 2;
> > > > +
> > > > +       return btrfs_calc_insert_metadata_size(fs_info, nr_extents) * factor;
> > > > +}
> > > > +
> > > >  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> > > >                                                  struct btrfs_inode *inode)
> > > >  {
> > > > @@ -266,6 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> > > >                 reserve_size = btrfs_calc_insert_metadata_size(fs_info,
> > > >                                                 outstanding_extents);
> > > >                 reserve_size += btrfs_calc_metadata_size(fs_info, 1);
> > > > +               reserve_size += delalloc_calc_delayed_refs_rsv(inode, outstanding_extents);
> > > >         }
> > > >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> > > >                 u64 csum_leaves;
> > > > @@ -309,9 +345,29 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
> > > >          * for an inode update.
> > > >          */
> > > >         *meta_reserve += inode_update;
> > > > +
> > > > +       *meta_reserve += delalloc_calc_delayed_refs_rsv(inode, nr_extents);
> > > > +
> > > >         *qgroup_reserve = nr_extents * fs_info->nodesize;
> > > >  }
> > > >
> > > > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > > > +                                            struct btrfs_inode *inode)
> > > > +{
> > > > +       struct btrfs_block_rsv *inode_rsv = &inode->block_rsv;
> > > > +       struct btrfs_block_rsv *trans_rsv = &trans->delayed_rsv;
> > > > +       u64 num_bytes = delalloc_calc_delayed_refs_rsv(inode, 1);
> > > > +
> > > > +       spin_lock(&inode_rsv->lock);
> > > > +       num_bytes = min(num_bytes, inode_rsv->reserved);
> > > > +       inode_rsv->reserved -= num_bytes;
> > > > +       inode_rsv->full = (inode_rsv->reserved >= inode_rsv->size);
> > > > +       spin_unlock(&inode_rsv->lock);
> > > > +
> > > > +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> > > > +       trans->delayed_refs_bytes_reserved += num_bytes;
> > > > +}
> > > > +
> > > >  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> > > >                                     u64 disk_num_bytes, bool noflush)
> > > >  {
> > > > diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> > > > index 6119c0d3f883..bd7041166987 100644
> > > > --- a/fs/btrfs/delalloc-space.h
> > > > +++ b/fs/btrfs/delalloc-space.h
> > > > @@ -8,6 +8,7 @@
> > > >  struct extent_changeset;
> > > >  struct btrfs_inode;
> > > >  struct btrfs_fs_info;
> > > > +struct btrfs_trans_handle;
> > > >
> > > >  int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes);
> > > >  int btrfs_check_data_free_space(struct btrfs_inode *inode,
> > > > @@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> > > >                                     u64 disk_num_bytes, bool noflush);
> > > >  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
> > > >  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len);
> > > > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > > > +                                            struct btrfs_inode *inode);
> > > >
> > > >  #endif /* BTRFS_DELALLOC_SPACE_H */
> > > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > > index 40474014c03f..15945744a304 100644
> > > > --- a/fs/btrfs/inode.c
> > > > +++ b/fs/btrfs/inode.c
> > > > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
> > > >                 goto out;
> > > >         }
> > > >         trans->block_rsv = &inode->block_rsv;
> > > > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> > > >
> > > >         drop_args.path = path;
> > > >         drop_args.start = 0;
> > > > @@ -3259,6 +3260,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
> > > >         }
> > > >
> > > >         trans->block_rsv = &inode->block_rsv;
> > > > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> > > >
> > > >         ret = btrfs_insert_raid_extent(trans, ordered_extent);
> > > >         if (unlikely(ret)) {
> > > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > > index 248adb785051..55791bb100a2 100644
> > > > --- a/fs/btrfs/transaction.c
> > > > +++ b/fs/btrfs/transaction.c
> > > > @@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
> > > >                 return;
> > > >         }
> > > >
> > > > -       if (!trans->bytes_reserved) {
> > > > -               ASSERT(trans->delayed_refs_bytes_reserved == 0,
> > > > -                      "trans->delayed_refs_bytes_reserved=%llu",
> > > > -                      trans->delayed_refs_bytes_reserved);
> > > > -               return;
> > > > +       if (trans->bytes_reserved) {
> > > > +               ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > > > +               trace_btrfs_space_reservation(fs_info, "transaction",
> > > > +                                       trans->transid, trans->bytes_reserved, 0);
> > > > +               btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > > > +                                       trans->bytes_reserved, NULL);
> > > > +               trans->bytes_reserved = 0;
> > > >         }
> > > >
> > > > -       ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > > > -       trace_btrfs_space_reservation(fs_info, "transaction",
> > > > -                                     trans->transid, trans->bytes_reserved, 0);
> > > > -       btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > > > -                               trans->bytes_reserved, NULL);
> > > > -       trans->bytes_reserved = 0;
> > > > -
> > > > -       if (!trans->delayed_refs_bytes_reserved)
> > > > -               return;
> > > > -
> > > > -       trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > > > -                                     trans->transid,
> > > > -                                     trans->delayed_refs_bytes_reserved, 0);
> > > > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > > -                               trans->delayed_refs_bytes_reserved, NULL);
> > > > -       trans->delayed_refs_bytes_reserved = 0;
> > > > +       if (trans->delayed_refs_bytes_reserved) {
> > > > +               trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > > > +                                       trans->transid,
> > > > +                                       trans->delayed_refs_bytes_reserved, 0);
> > > > +               btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > > +                                       trans->delayed_refs_bytes_reserved, NULL);
> > > > +               trans->delayed_refs_bytes_reserved = 0;
> > > > +       }
> > > >  }
> > > >
> > > >  static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
> > > > --
> > > > 2.53.0
> > > >
> > > >
