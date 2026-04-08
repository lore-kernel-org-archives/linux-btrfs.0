Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391F5351C0B
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775669680; cv=none; b=cXTe2hKtEBfJtQ50lXJxFsQJi16HAYT9Qpj9PlQwKyJ9F6kZqIvWDJtWoM/FVrdURNsCiG1AQyaWazSca5Rh+sqS3REpZxpxjNf629XXIVAgw31ydiXwxAcJCTRcK1Ulu0Yby5KAG6ui7Pk41Pa28lOtOu/dPaFoDGAjehDC+oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775669680; c=relaxed/simple;
	bh=MDm7Ze4ILpWf6j7d9aF3jgyowj2ZrbiCjhLqt8BUYQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDx0l5L8iZv8PZFHYspkPJIIYM4TcGBAWy+7Hp6qHqYEIYmJhRmYB/Csqnxqo4OxjXlPKqI3Z4QaL1xIpliyAwJqm35vxNN4EcEayPm6Pq2pRhcU+VRGb546exEVzyyeESXrJL7B9kmSDrOpZ1SubxIiQPutOXtbRoG1/6w9Otk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=BL9XzkBV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AFNqKvSu; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="BL9XzkBV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AFNqKvSu"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 54EF57A018F;
	Wed,  8 Apr 2026 13:34:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 08 Apr 2026 13:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775669677;
	 x=1775756077; bh=y+/0nS44R+FouCdz+zhBEVeu9hwjKrdnhmcYLWTeH00=; b=
	BL9XzkBVUXwZGvKAi4TP6Z13CnKYUru64m+qxh8x4FaBThkq4EPxlHwWV3V/Lgom
	Bp5XfSwkehg53WQbLDUXM3Z9hGtAvx7irIn6YTX7NMBTvIj+KuP+u8XVvEH1Ua+c
	/BQDOn/z60tlnqd/WAH3OxkTBHVq4yKaaD74K7c0QFIgd+bcoU95a+A3vKvmslC5
	Qx7kbK+tG5bcFQAPcZwEKz4DXKNnChzVTmLYm1TsE4uyXPcf/DBZf3NWlQj48U8/
	dJ1VkYZSW8doX9e5ez3mH9XpbYxXDBh6S23Q/GgVhPz/FvzpOhOVERB1ILP2LaAB
	7HyfvzAyb1y6nsASlqE3HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775669677; x=
	1775756077; bh=y+/0nS44R+FouCdz+zhBEVeu9hwjKrdnhmcYLWTeH00=; b=A
	FNqKvSuLKT/g+kjTe/VZhPKnZYNPRjjauRsA6iauEh6vxQPoH2HcX4b4XogfVRMd
	Tki0NN5A/GJGyIIAolzOWR12ogzcRg8VgZKvUt/eO6fiK7pc6yuXdeHUEj1ARN3t
	Ce3gMOYVK+CwxPppt0JS/FzCdo3lh4ZgI7nCQ9+2Yv9Ry7ynM9IZ4O+RQZx0UllM
	SHJLE4aYneFTQ0anYE+RszCfKYEP3hTiRffRkCOwapVr/pi1gt0LJ7F6B6bnilsv
	W62+EKF5U/fgUewx5HKTcHvlpA7oC5TgNo3T6n/a12aoaOxl/46RjvqVh7E0h4Kv
	JlXkWen8ORSAaITnxm2tA==
X-ME-Sender: <xms:rJHWafb6Wniccgg_EGQOEKDx40kN2dT_-9Ct31fVNk6xrnnGcJR4DA>
    <xme:rJHWaV3Wz1zaEbGByMJY-xikhzQ-EHYaKeFWSY0RktC3Zu8TGvJY6poqmTYAx2qEm
    ol0wj2z4XBxRWvgGKP4NS87-fkQRBpxolm6AWjD5A9Ivro0fa1rlYQ>
X-ME-Received: <xmr:rJHWafXbT7d3i5_hUeUZDlt3DtPRuadQj4yPOAObZl7bXURonpiObjvyaB0YWg_uPf3VHxc0_D9j7z-32OLlUNCG8os>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvgedukecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:rJHWafVIRfF5e64twqah0O5DsZ2YlUeE3VPrzKX6xB1MQBOq0uDGrw>
    <xmx:rJHWaeepSRyNdncPYaBIGjnMFmwA19z6kfOeN8O2_5LVX60UiTYvSg>
    <xmx:rJHWaYViiDeFjVNUMpCFmCsi18YN43_X8uQKZG0dqsveCrd21w2vUQ>
    <xmx:rJHWaXd6BMRTan0wN4MCFioqcGKgRWsBBraoANZSPdAyOVSx8Nt_Uw>
    <xmx:rZHWaU35YZoIIi3V3qr4fTexCMV3DVlBjps3_Rj8T7Jeq6MTmF3zk5aI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Apr 2026 13:34:36 -0400 (EDT)
Date: Wed, 8 Apr 2026 10:34:25 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
Message-ID: <20260408173425.GA2076825@zen.localdomain>
References: <cover.1775589916.git.boris@bur.io>
 <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
 <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>

On Wed, Apr 08, 2026 at 03:56:14PM +0100, Filipe Manana wrote:
> On Tue, Apr 7, 2026 at 8:31 PM Boris Burkov <boris@bur.io> wrote:
> >
> > delalloc uses a per-inode block_rsv to perform metadata reservations for
> > the cow operations it anticipates based on the number of outstanding
> > extents. This calculation is done based on inode->outstanding_extents in
> > btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> > meticulously tracked as each ordered_extent is actually created in
> > writeback, but rather delalloc attempts to over-estimate and the
> > writeback and ordered_extent finish portions are responsible to release
> > all the reservation.
> >
> > However, there is a notable gap in this reservation, it reserves no
> > space for the resulting delayed_refs. If you compare to how
> > btrfs_start_transaction() reservations work, this is a noteable
> > difference.
> >
> > As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
> > that function will start generating delayed refs, which will draw from
> > the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():
> >
> > For example, we can trace the primary data delayed ref:
> >
> > btrfs_finish_one_ordered()
> >   insert_ordered_extent_file_extent()
> >     insert_reserved_file_extent()
> >       btrfs_alloc_reserved_file_extent()
> >         btrfs_add_delayed_data_ref()
> >           add_delayed_ref()
> >             btrfs_update_delayed_refs_rsv();
> >
> > This trans_handle was created in finish_one_ordered() with
> > btrfs_join_transaction() which calls start_transaction with
> > num_items=0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
> > has no reserved in h->delayed_rsv, as neither the num_items reservation
> > nor the btrfs_delayed_refs_rsv_refill() reservation is run.
> >
> > Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
> > fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.
> >
> > If a large amount of writeback happens all at once (perhaps due to
> > dirty_ratio being tuned too high), this results in, among other things,
> > erroneous assessments of the amount of delayed_refs reserved in the
> > metadata space reclaim logic, like need_preemptive_reclaim() which
> > relies on fs_info->delayed_rsv->reserved and even worse, poor decision
> > making in btrfs_preempt_reclaim_metadata_space() which counts
> > delalloc_bytes like so:
> >
> >   block_rsv_size = global_rsv_size +
> >           btrfs_block_rsv_reserved(delayed_block_rsv) +
> >           btrfs_block_rsv_reserved(delayed_refs_rsv) +
> >           btrfs_block_rsv_reserved(trans_rsv);
> >   delalloc_size = bytes_may_use - block_rsv_size;
> >
> > So all that lost delayed refs usage gets accounted as delalloc_size and
> > leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
> > further exacerbates the problem.
> >
> > With enough writeback around, we can run enough delalloc that we get
> > into async reclaim which starts blocking start_transaction() and
> > eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
> > the filesystem gets heavily blocked on metadata space in reserve_space(),
> > blocking all new transaction work until all the ordered_extents finish.
> >
> > If we had an accurate view of the reservation for delayed refs, then we
> > could mostly break this feedback loop in preemptive reclaim, and
> > generally would be able to make more accurate decisions with regards to
> > metadata space reclamation.
> >
> > This patch adds extra metadata reservation to the inode's block_rsv to
> > account for the delayed refs. When the ordered_extent finishes and we
> > are about to do work in the transaction that uses delayed refs, we
> > migrate enough for 1 extent. Since this is not necessarily perfect, we
> > have to be careful and do a "soft" migrate which succeeds even if there
> > is not enough reservation. This is strictly better than what we have and
> > also matches how the delayed ref rsv gets used in the transaction at
> > btrfs_update_delayed_refs_rsv().
> >
> > Aside from this data delayed_ref, there are also some metadata
> > delayed_refs to consider. These are:
> > - subvolume tree for the file extent item
> > - csum tree for data csums
> > - raid stripe tree if enabled
> > - free space tree if enabled
> >
> > So account for those delayed_refs in the reservation as well. This
> > greatly increases the size of the reservation as each metadata cow
> > results in two delayed refs: one add for the new block in
> > btrfs_alloc_tree_block() and one drop for the old in
> > btrfs_free_tree_block(). As a result, to be completely conservative,
> > we need to reserve 2 delayed refs worth of space for each cow.
> >
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/delalloc-space.c | 56 +++++++++++++++++++++++++++++++++++++++
> >  fs/btrfs/delalloc-space.h |  3 +++
> >  fs/btrfs/inode.c          |  2 ++
> >  fs/btrfs/transaction.c    | 36 +++++++++++--------------
> >  4 files changed, 76 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > index 0970799d0aa4..c99f516ce8af 100644
> > --- a/fs/btrfs/delalloc-space.c
> > +++ b/fs/btrfs/delalloc-space.c
> > @@ -1,13 +1,16 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >
> > +#include "linux/btrfs_tree.h"
> 
> Not needed.
> 
> >  #include "messages.h"
> >  #include "ctree.h"
> >  #include "delalloc-space.h"
> > +#include "delayed-ref.h"
> >  #include "block-rsv.h"
> >  #include "btrfs_inode.h"
> >  #include "space-info.h"
> >  #include "qgroup.h"
> >  #include "fs.h"
> > +#include "transaction.h"
> >
> >  /*
> >   * HOW DOES THIS WORK
> > @@ -247,6 +250,38 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
> >                                                    qgroup_to_release);
> >  }
> >
> > +/*
> > + * Each delalloc extent could become an ordered_extent and end up inserting a
> > + * new data extent and modify a number of btrees. Each of those is associated with
> > + * adding delayed refs which need a corresponding delayed refs reservation.
> > + *
> > + * Each metadata cow operation results in an add and a drop delayed ref, both of
> > + * which call add_delayed_ref() and ultimately btrfs_update_delayed_refs_rsv(),
> > + * so each must account for 2 delayed refs.
> > + */
> > +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_inode *inode, u64 nr_extents)
> > +{
> > +       const struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +
> > +       /*
> > +        * Factor for how many delayed refs updates we will generate per extent.
> > +        * Non-optional:
> > +        * extent tree: 1 data delayed ref.
> 
> Running the delayed data ref to insert the extent item in the extent
> tree requires COWing an extent tree leaf, which creates a delayed tree
> ref for deletion too.
> So, 2.
> 
> Otherwise it looks good, thanks.
> 

I think I might be getting confused now :)

I'll try to work it out "out loud" and hopefully I can reach a good
conclusion.

I have been trying to reserve for the calls to add_delayed_ref in the
transaction handle context. And tracing each cow in that context yields
2 delayed refs each while tracing the data extent insertion only creates
one. The reason I care particularly about this context is the
trans_handle delayed_refs rsv accounting in
btrfs_update_delayed_refs_rsv(), as described in the patch. Ultimately,
all the reservations get sunk into the global reserve from
trans->delayed_rsv at btrfs_end_transaction(). Does this all sound right
to you so far?

Cows that we clearly do from finish_one_ordered() are the ones to:
raid stripe tree, subvol tree, and csum tree. Notably, the free space
tree *does not* happen in this context, it happens when we run the
delayed ref, so I think I was not consistent to include that. In that
context we cow the extent and free space tree for the data extent.

But the point of reserving for a delayed ref is to account for the cows
that it will ultimately cause and reserve ahead for them. So I think it
does make sense to reserve for the fst and extent tree. On the other
hand, I think we actively *don't* want to account for the potential
infinite regress where each metadata delayed_ref run "unluckily" results
in cow-ing the extent tree again and again since it doesn't actually
happen in practice (especially with Leo's writeback inhibition and
hopefully eb overwriting soon). That series diverges so it would require
an infinite reservation anyway.

In conclusion, I think I am agreeing and proposing that I shift the goal
from "count add_delayed_ref calls under the trans handle" to "predict
metadata reservation due to delayed refs" and in that world, it should
be 2 for the data extent in the extent tree.

The other principled option is to count 1 for the data delayed ref now
and not account for the fst or the extent tree cows that happen at
delayed_refs time, but I think that makes less sense.

Sorry if that was a lot of text to just agree with you, but I want to be
careful since it's easy to go astray and "get away with it" cause of the
reservations being conservative and getting sloshed into the global
reserves.

One final note / question:
the "normal" start_transaction() reservation which computes the space
for the cow itself and then the delayed_refs cows does *not* seem to
count 2 per cow for delayed refs in btrfs_calc_delayed_ref_bytes().
But in theory the same reasoning applies that we will touch two metadata
items for each cow.  I assume this is OK in practice because the depth
is generally not 8 anyway, but do you think that is something I should
clean up as well?

Thanks again,
Boris

> > +        * subvolume tree: 1 cow => 2 metadata delayed refs.
> > +        */
> > +       int factor = 3;
> > +
> > +       /* The remaining trees are only written to conditionally. */
> > +       if (!(inode->flags & BTRFS_INODE_NODATASUM))
> > +               factor += 2;
> > +       if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
> > +               factor += 2;
> > +       if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> > +               factor += 2;
> > +
> > +       return btrfs_calc_insert_metadata_size(fs_info, nr_extents) * factor;
> > +}
> > +
> >  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> >                                                  struct btrfs_inode *inode)
> >  {
> > @@ -266,6 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
> >                 reserve_size = btrfs_calc_insert_metadata_size(fs_info,
> >                                                 outstanding_extents);
> >                 reserve_size += btrfs_calc_metadata_size(fs_info, 1);
> > +               reserve_size += delalloc_calc_delayed_refs_rsv(inode, outstanding_extents);
> >         }
> >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> >                 u64 csum_leaves;
> > @@ -309,9 +345,29 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
> >          * for an inode update.
> >          */
> >         *meta_reserve += inode_update;
> > +
> > +       *meta_reserve += delalloc_calc_delayed_refs_rsv(inode, nr_extents);
> > +
> >         *qgroup_reserve = nr_extents * fs_info->nodesize;
> >  }
> >
> > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > +                                            struct btrfs_inode *inode)
> > +{
> > +       struct btrfs_block_rsv *inode_rsv = &inode->block_rsv;
> > +       struct btrfs_block_rsv *trans_rsv = &trans->delayed_rsv;
> > +       u64 num_bytes = delalloc_calc_delayed_refs_rsv(inode, 1);
> > +
> > +       spin_lock(&inode_rsv->lock);
> > +       num_bytes = min(num_bytes, inode_rsv->reserved);
> > +       inode_rsv->reserved -= num_bytes;
> > +       inode_rsv->full = (inode_rsv->reserved >= inode_rsv->size);
> > +       spin_unlock(&inode_rsv->lock);
> > +
> > +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> > +       trans->delayed_refs_bytes_reserved += num_bytes;
> > +}
> > +
> >  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> >                                     u64 disk_num_bytes, bool noflush)
> >  {
> > diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> > index 6119c0d3f883..bd7041166987 100644
> > --- a/fs/btrfs/delalloc-space.h
> > +++ b/fs/btrfs/delalloc-space.h
> > @@ -8,6 +8,7 @@
> >  struct extent_changeset;
> >  struct btrfs_inode;
> >  struct btrfs_fs_info;
> > +struct btrfs_trans_handle;
> >
> >  int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes);
> >  int btrfs_check_data_free_space(struct btrfs_inode *inode,
> > @@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
> >                                     u64 disk_num_bytes, bool noflush);
> >  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
> >  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len);
> > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
> > +                                            struct btrfs_inode *inode);
> >
> >  #endif /* BTRFS_DELALLOC_SPACE_H */
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 40474014c03f..15945744a304 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
> >                 goto out;
> >         }
> >         trans->block_rsv = &inode->block_rsv;
> > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> >
> >         drop_args.path = path;
> >         drop_args.start = 0;
> > @@ -3259,6 +3260,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
> >         }
> >
> >         trans->block_rsv = &inode->block_rsv;
> > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> >
> >         ret = btrfs_insert_raid_extent(trans, ordered_extent);
> >         if (unlikely(ret)) {
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 248adb785051..55791bb100a2 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
> >                 return;
> >         }
> >
> > -       if (!trans->bytes_reserved) {
> > -               ASSERT(trans->delayed_refs_bytes_reserved == 0,
> > -                      "trans->delayed_refs_bytes_reserved=%llu",
> > -                      trans->delayed_refs_bytes_reserved);
> > -               return;
> > +       if (trans->bytes_reserved) {
> > +               ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > +               trace_btrfs_space_reservation(fs_info, "transaction",
> > +                                       trans->transid, trans->bytes_reserved, 0);
> > +               btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > +                                       trans->bytes_reserved, NULL);
> > +               trans->bytes_reserved = 0;
> >         }
> >
> > -       ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
> > -       trace_btrfs_space_reservation(fs_info, "transaction",
> > -                                     trans->transid, trans->bytes_reserved, 0);
> > -       btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > -                               trans->bytes_reserved, NULL);
> > -       trans->bytes_reserved = 0;
> > -
> > -       if (!trans->delayed_refs_bytes_reserved)
> > -               return;
> > -
> > -       trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > -                                     trans->transid,
> > -                                     trans->delayed_refs_bytes_reserved, 0);
> > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > -                               trans->delayed_refs_bytes_reserved, NULL);
> > -       trans->delayed_refs_bytes_reserved = 0;
> > +       if (trans->delayed_refs_bytes_reserved) {
> > +               trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> > +                                       trans->transid,
> > +                                       trans->delayed_refs_bytes_reserved, 0);
> > +               btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > +                                       trans->delayed_refs_bytes_reserved, NULL);
> > +               trans->delayed_refs_bytes_reserved = 0;
> > +       }
> >  }
> >
> >  static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
> > --
> > 2.53.0
> >
> >
