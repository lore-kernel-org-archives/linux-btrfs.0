Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9D63DA5DD
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 15:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834887; cv=none; b=tcqTyKrQy9tf1/Slhuap9NX7ssG4R6Pl/N3bqP+afOLxGYqFLhl8E88jVZlVYN00f8tuaOTDVprMjXoXnULAJ9NoPT2uEGDoBtJeire83PDEAahbfRdJIW3jUlBx5IL5QecEZ3w72Yyh8hx+TxBKas/eXIyHREIV5T6855IdjIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834887; c=relaxed/simple;
	bh=prsE1dlwwL14wjeGlC0dSjdwh3smlFyvwcgxqvkBN8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TC1f5buGfYO6voFFVfexOydOy9gG1u1aCmTlwu1ySawXD7T2L1sQ+mlKDCte05baQ3jDvRCkMs4gDrgeRg96ike/NQCr1EoQft7xGyYgiwcXeuD5K5+7usZcnl96NY52EoqajdWRkXjijfNU7o4DIi9IZJ5ga244YqrKZO67hPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYWbYLZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYWbYLZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A196DC2BC9E
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775834886;
	bh=prsE1dlwwL14wjeGlC0dSjdwh3smlFyvwcgxqvkBN8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tYWbYLZ/eOxY1Lri0F6sOP7qbCd5Ck6QySIseTKsojxr1e2vw4rJf0pFIp6nKxJMI
	 SsKkRH06UyDQGmyI14LKEJyCr4opnHZJbrv9bWXdSNB43VLMCegwYBtBdT9a3pu1VU
	 pB6CWhK5dZnps7UihtEYTMx5/LgJsdlscMnZ4wWjU7k947SNw+kVAIB5pcMuUt8P+E
	 pSiNu8OAYuNjGswg1KgWW7t9QEi53LLkszDmFXTJIJlxYDoDzUTPEFqPcaZrTbDBtJ
	 v63KY1mcb36s5hKA7xW1noLxugsM2rB9KaqYUYdVv8HUGo6sKf0C0RrA/WSS3/JZCV
	 yAgrarGXzJINA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b932fe2e1a7so292097466b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 08:28:06 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz+KTxxvSFSiJBZ7oYUDJfXxqR6ep3Yju+SRDKYf9GxhgMkfCsX
	zyqPbCI644iQyesitsEHAh05ibYpqXT0x/2afKKpQopCX82LuQfW0ZdxPn9Ahv0IbjYuusCBpkg
	l0y58iX8qxHSR2C9+jpe6P6bG1DKmsrE=
X-Received: by 2002:a17:907:160f:b0:b9c:578c:50a8 with SMTP id
 a640c23a62f3a-b9d72796b33mr225161566b.51.1775834884999; Fri, 10 Apr 2026
 08:28:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775589916.git.boris@bur.io> <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
 <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com> <20260408173425.GA2076825@zen.localdomain>
In-Reply-To: <20260408173425.GA2076825@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 10 Apr 2026 16:27:28 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5O47v2BW2pckyF9qgaLdLHefD5Bwh3VS+xgkBAUyYwPg@mail.gmail.com>
X-Gm-Features: AQROBzC34_SaSCsK8_mo76rnDcUp8DpFeT9RSL-fUs1D5IlK1tl_4cL0VMOwIIg
Message-ID: <CAL3q7H5O47v2BW2pckyF9qgaLdLHefD5Bwh3VS+xgkBAUyYwPg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 8, 2026 at 6:34=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Wed, Apr 08, 2026 at 03:56:14PM +0100, Filipe Manana wrote:
> > On Tue, Apr 7, 2026 at 8:31=E2=80=AFPM Boris Burkov <boris@bur.io> wrot=
e:
> > >
> > > delalloc uses a per-inode block_rsv to perform metadata reservations =
for
> > > the cow operations it anticipates based on the number of outstanding
> > > extents. This calculation is done based on inode->outstanding_extents=
 in
> > > btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> > > meticulously tracked as each ordered_extent is actually created in
> > > writeback, but rather delalloc attempts to over-estimate and the
> > > writeback and ordered_extent finish portions are responsible to relea=
se
> > > all the reservation.
> > >
> > > However, there is a notable gap in this reservation, it reserves no
> > > space for the resulting delayed_refs. If you compare to how
> > > btrfs_start_transaction() reservations work, this is a noteable
> > > difference.
> > >
> > > As writeback actually occurs, and we trigger btrfs_finish_one_ordered=
(),
> > > that function will start generating delayed refs, which will draw fro=
m
> > > the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv=
():
> > >
> > > For example, we can trace the primary data delayed ref:
> > >
> > > btrfs_finish_one_ordered()
> > >   insert_ordered_extent_file_extent()
> > >     insert_reserved_file_extent()
> > >       btrfs_alloc_reserved_file_extent()
> > >         btrfs_add_delayed_data_ref()
> > >           add_delayed_ref()
> > >             btrfs_update_delayed_refs_rsv();
> > >
> > > This trans_handle was created in finish_one_ordered() with
> > > btrfs_join_transaction() which calls start_transaction with
> > > num_items=3D0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_han=
dle
> > > has no reserved in h->delayed_rsv, as neither the num_items reservati=
on
> > > nor the btrfs_delayed_refs_rsv_refill() reservation is run.
> > >
> > > Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 =
and
> > > fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserv=
ed.
> > >
> > > If a large amount of writeback happens all at once (perhaps due to
> > > dirty_ratio being tuned too high), this results in, among other thing=
s,
> > > erroneous assessments of the amount of delayed_refs reserved in the
> > > metadata space reclaim logic, like need_preemptive_reclaim() which
> > > relies on fs_info->delayed_rsv->reserved and even worse, poor decisio=
n
> > > making in btrfs_preempt_reclaim_metadata_space() which counts
> > > delalloc_bytes like so:
> > >
> > >   block_rsv_size =3D global_rsv_size +
> > >           btrfs_block_rsv_reserved(delayed_block_rsv) +
> > >           btrfs_block_rsv_reserved(delayed_refs_rsv) +
> > >           btrfs_block_rsv_reserved(trans_rsv);
> > >   delalloc_size =3D bytes_may_use - block_rsv_size;
> > >
> > > So all that lost delayed refs usage gets accounted as delalloc_size a=
nd
> > > leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, whi=
ch
> > > further exacerbates the problem.
> > >
> > > With enough writeback around, we can run enough delalloc that we get
> > > into async reclaim which starts blocking start_transaction() and
> > > eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which poin=
t
> > > the filesystem gets heavily blocked on metadata space in reserve_spac=
e(),
> > > blocking all new transaction work until all the ordered_extents finis=
h.
> > >
> > > If we had an accurate view of the reservation for delayed refs, then =
we
> > > could mostly break this feedback loop in preemptive reclaim, and
> > > generally would be able to make more accurate decisions with regards =
to
> > > metadata space reclamation.
> > >
> > > This patch adds extra metadata reservation to the inode's block_rsv t=
o
> > > account for the delayed refs. When the ordered_extent finishes and we
> > > are about to do work in the transaction that uses delayed refs, we
> > > migrate enough for 1 extent. Since this is not necessarily perfect, w=
e
> > > have to be careful and do a "soft" migrate which succeeds even if the=
re
> > > is not enough reservation. This is strictly better than what we have =
and
> > > also matches how the delayed ref rsv gets used in the transaction at
> > > btrfs_update_delayed_refs_rsv().
> > >
> > > Aside from this data delayed_ref, there are also some metadata
> > > delayed_refs to consider. These are:
> > > - subvolume tree for the file extent item
> > > - csum tree for data csums
> > > - raid stripe tree if enabled
> > > - free space tree if enabled
> > >
> > > So account for those delayed_refs in the reservation as well. This
> > > greatly increases the size of the reservation as each metadata cow
> > > results in two delayed refs: one add for the new block in
> > > btrfs_alloc_tree_block() and one drop for the old in
> > > btrfs_free_tree_block(). As a result, to be completely conservative,
> > > we need to reserve 2 delayed refs worth of space for each cow.
> > >
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > >  fs/btrfs/delalloc-space.c | 56 +++++++++++++++++++++++++++++++++++++=
++
> > >  fs/btrfs/delalloc-space.h |  3 +++
> > >  fs/btrfs/inode.c          |  2 ++
> > >  fs/btrfs/transaction.c    | 36 +++++++++++--------------
> > >  4 files changed, 76 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > > index 0970799d0aa4..c99f516ce8af 100644
> > > --- a/fs/btrfs/delalloc-space.c
> > > +++ b/fs/btrfs/delalloc-space.c
> > > @@ -1,13 +1,16 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > >
> > > +#include "linux/btrfs_tree.h"
> >
> > Not needed.
> >
> > >  #include "messages.h"
> > >  #include "ctree.h"
> > >  #include "delalloc-space.h"
> > > +#include "delayed-ref.h"
> > >  #include "block-rsv.h"
> > >  #include "btrfs_inode.h"
> > >  #include "space-info.h"
> > >  #include "qgroup.h"
> > >  #include "fs.h"
> > > +#include "transaction.h"
> > >
> > >  /*
> > >   * HOW DOES THIS WORK
> > > @@ -247,6 +250,38 @@ static void btrfs_inode_rsv_release(struct btrfs=
_inode *inode, bool qgroup_free)
> > >                                                    qgroup_to_release)=
;
> > >  }
> > >
> > > +/*
> > > + * Each delalloc extent could become an ordered_extent and end up in=
serting a
> > > + * new data extent and modify a number of btrees. Each of those is a=
ssociated with
> > > + * adding delayed refs which need a corresponding delayed refs reser=
vation.
> > > + *
> > > + * Each metadata cow operation results in an add and a drop delayed =
ref, both of
> > > + * which call add_delayed_ref() and ultimately btrfs_update_delayed_=
refs_rsv(),
> > > + * so each must account for 2 delayed refs.
> > > + */
> > > +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_inode *=
inode, u64 nr_extents)
> > > +{
> > > +       const struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> > > +
> > > +       /*
> > > +        * Factor for how many delayed refs updates we will generate =
per extent.
> > > +        * Non-optional:
> > > +        * extent tree: 1 data delayed ref.
> >
> > Running the delayed data ref to insert the extent item in the extent
> > tree requires COWing an extent tree leaf, which creates a delayed tree
> > ref for deletion too.
> > So, 2.
> >
> > Otherwise it looks good, thanks.
> >
>
> I think I might be getting confused now :)
>
> I'll try to work it out "out loud" and hopefully I can reach a good
> conclusion.
>
> I have been trying to reserve for the calls to add_delayed_ref in the
> transaction handle context. And tracing each cow in that context yields
> 2 delayed refs each while tracing the data extent insertion only creates
> one. The reason I care particularly about this context is the
> trans_handle delayed_refs rsv accounting in
> btrfs_update_delayed_refs_rsv(), as described in the patch. Ultimately,
> all the reservations get sunk into the global reserve from
> trans->delayed_rsv at btrfs_end_transaction(). Does this all sound right
> to you so far?

Yes.

>
> Cows that we clearly do from finish_one_ordered() are the ones to:
> raid stripe tree, subvol tree, and csum tree. Notably, the free space
> tree *does not* happen in this context, it happens when we run the
> delayed ref, so I think I was not consistent to include that. In that
> context we cow the extent and free space tree for the data extent.

Yes.

But the issue is that if we get a lot of delalloc and run it, we may
generate many delayed refs - those directly created by ordered extent
completion operations as you mention.

Then when we run them, either during the early phase of a transaction
commit or from the space flushing code, we will generate more delayed
refs to update the extent and free space trees (for COWing).
During that time we are running them, we will try to use space from
the global (fs_info->delayed_refs_rsv) delayed refs reserve and if
that fails, we try the global reserve.

Our calculations are pessimistic so even if we don't account for all
delayed refs, it's ok most of the time since the calculations assume
we have trees with a height of 8 and that we get node splits at every
level of a tree.
So that ends up compensating unless we have a really large amount of
delayed refs.

Sure that once we COW a leaf from the extent or free space tree, we
will not need to COW it again for every subsequent modification.
However, memory pressure or a call to btrfs_btree_balance_dirty() from
some other task can flush every COWed leaf/node, requiring another COW
operation.

So, in extreme cases, we could eventually run out of space. We
sporadically see reports of transaction aborts with -ENOSPC when
running delayed refs, both upstream and downstream. This isn't new;
it's been like this forever.

>
> But the point of reserving for a delayed ref is to account for the cows
> that it will ultimately cause and reserve ahead for them. So I think it
> does make sense to reserve for the fst and extent tree. On the other
> hand, I think we actively *don't* want to account for the potential
> infinite regress where each metadata delayed_ref run "unluckily" results
> in cow-ing the extent tree again and again since it doesn't actually
> happen in practice (especially with Leo's writeback inhibition and
> hopefully eb overwriting soon). That series diverges so it would require
> an infinite reservation anyway.

The writeback inhibition thing doesn't prevent what I mentioned
before, it only applies when a tree modification must restart.
I'm talking about subsequent tree modifications that require COWing
the same nodes/leaves because writeback was triggered for the btree
inode in between.

>
> In conclusion, I think I am agreeing and proposing that I shift the goal
> from "count add_delayed_ref calls under the trans handle" to "predict
> metadata reservation due to delayed refs" and in that world, it should
> be 2 for the data extent in the extent tree.
>
> The other principled option is to count 1 for the data delayed ref now
> and not account for the fst or the extent tree cows that happen at
> delayed_refs time, but I think that makes less sense.

And how would you do that?
Because running delayed refs happens normally at transaction commit
time, both before and after the critical section, or when flushing
space.
Those are places where I don't see how we can reserve space.

>
> Sorry if that was a lot of text to just agree with you, but I want to be
> careful since it's easy to go astray and "get away with it" cause of the
> reservations being conservative and getting sloshed into the global
> reserves.

No worries.

>
> One final note / question:
> the "normal" start_transaction() reservation which computes the space
> for the cow itself and then the delayed_refs cows does *not* seem to
> count 2 per cow for delayed refs in btrfs_calc_delayed_ref_bytes().
> But in theory the same reasoning applies that we will touch two metadata
> items for each cow.  I assume this is OK in practice because the depth
> is generally not 8 anyway, but do you think that is something I should
> clean up as well?

Yes, we have a lot of places where we don't account for everything.
Either because someone forgot about it or because we don't know in
advance how much we will need.

For example, assuming an entire delalloc range up to 128M results in a
single extent is very optimistic.
We assume this, but we don't know until we actually run writeback and
try to reserve space - a 32M write might only be satisfied by
allocating 8192 4K extents due to fragmentation - yet we reserve space
accounting for a single extent.

I've seen cases where this resulted in a transaction abort, with
-ENOSPC, during ordered extent completion.

One thing to pay special attention to, is that if we start reserving a
lot more space, some tests that currently pass may start failing with
-ENOSPC or they may take significantly longer due to more space
flushing.
It's a very tricky area. I've experienced this pain several times in the pa=
st.

So it's probably better if this patch accounts only for delayed refs
generated during extent completion.
I noticed you already sent a new patch version before I could reply, I
will look at it now.

Thanks.

>
> Thanks again,
> Boris
>
> > > +        * subvolume tree: 1 cow =3D> 2 metadata delayed refs.
> > > +        */
> > > +       int factor =3D 3;
> > > +
> > > +       /* The remaining trees are only written to conditionally. */
> > > +       if (!(inode->flags & BTRFS_INODE_NODATASUM))
> > > +               factor +=3D 2;
> > > +       if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
> > > +               factor +=3D 2;
> > > +       if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> > > +               factor +=3D 2;
> > > +
> > > +       return btrfs_calc_insert_metadata_size(fs_info, nr_extents) *=
 factor;
> > > +}
> > > +
> > >  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_inf=
o *fs_info,
> > >                                                  struct btrfs_inode *=
inode)
> > >  {
> > > @@ -266,6 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(=
struct btrfs_fs_info *fs_info,
> > >                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_i=
nfo,
> > >                                                 outstanding_extents);
> > >                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1=
);
> > > +               reserve_size +=3D delalloc_calc_delayed_refs_rsv(inod=
e, outstanding_extents);
> > >         }
> > >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> > >                 u64 csum_leaves;
> > > @@ -309,9 +345,29 @@ static void calc_inode_reservations(struct btrfs=
_inode *inode,
> > >          * for an inode update.
> > >          */
> > >         *meta_reserve +=3D inode_update;
> > > +
> > > +       *meta_reserve +=3D delalloc_calc_delayed_refs_rsv(inode, nr_e=
xtents);
> > > +
> > >         *qgroup_reserve =3D nr_extents * fs_info->nodesize;
> > >  }
> > >
> > > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_hand=
le *trans,
> > > +                                            struct btrfs_inode *inod=
e)
> > > +{
> > > +       struct btrfs_block_rsv *inode_rsv =3D &inode->block_rsv;
> > > +       struct btrfs_block_rsv *trans_rsv =3D &trans->delayed_rsv;
> > > +       u64 num_bytes =3D delalloc_calc_delayed_refs_rsv(inode, 1);
> > > +
> > > +       spin_lock(&inode_rsv->lock);
> > > +       num_bytes =3D min(num_bytes, inode_rsv->reserved);
> > > +       inode_rsv->reserved -=3D num_bytes;
> > > +       inode_rsv->full =3D (inode_rsv->reserved >=3D inode_rsv->size=
);
> > > +       spin_unlock(&inode_rsv->lock);
> > > +
> > > +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> > > +       trans->delayed_refs_bytes_reserved +=3D num_bytes;
> > > +}
> > > +
> > >  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 n=
um_bytes,
> > >                                     u64 disk_num_bytes, bool noflush)
> > >  {
> > > diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> > > index 6119c0d3f883..bd7041166987 100644
> > > --- a/fs/btrfs/delalloc-space.h
> > > +++ b/fs/btrfs/delalloc-space.h
> > > @@ -8,6 +8,7 @@
> > >  struct extent_changeset;
> > >  struct btrfs_inode;
> > >  struct btrfs_fs_info;
> > > +struct btrfs_trans_handle;
> > >
> > >  int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode,=
 u64 bytes);
> > >  int btrfs_check_data_free_space(struct btrfs_inode *inode,
> > > @@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_in=
ode *inode, u64 num_bytes,
> > >                                     u64 disk_num_bytes, bool noflush)=
;
> > >  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 n=
um_bytes);
> > >  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 re=
served_len, u64 new_len);
> > > +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_hand=
le *trans,
> > > +                                            struct btrfs_inode *inod=
e);
> > >
> > >  #endif /* BTRFS_DELALLOC_SPACE_H */
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 40474014c03f..15945744a304 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struc=
t btrfs_inode *inode,
> > >                 goto out;
> > >         }
> > >         trans->block_rsv =3D &inode->block_rsv;
> > > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> > >
> > >         drop_args.path =3D path;
> > >         drop_args.start =3D 0;
> > > @@ -3259,6 +3260,7 @@ int btrfs_finish_one_ordered(struct btrfs_order=
ed_extent *ordered_extent)
> > >         }
> > >
> > >         trans->block_rsv =3D &inode->block_rsv;
> > > +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
> > >
> > >         ret =3D btrfs_insert_raid_extent(trans, ordered_extent);
> > >         if (unlikely(ret)) {
> > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > index 248adb785051..55791bb100a2 100644
> > > --- a/fs/btrfs/transaction.c
> > > +++ b/fs/btrfs/transaction.c
> > > @@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(stru=
ct btrfs_trans_handle *trans)
> > >                 return;
> > >         }
> > >
> > > -       if (!trans->bytes_reserved) {
> > > -               ASSERT(trans->delayed_refs_bytes_reserved =3D=3D 0,
> > > -                      "trans->delayed_refs_bytes_reserved=3D%llu",
> > > -                      trans->delayed_refs_bytes_reserved);
> > > -               return;
> > > +       if (trans->bytes_reserved) {
> > > +               ASSERT(trans->block_rsv =3D=3D &fs_info->trans_block_=
rsv);
> > > +               trace_btrfs_space_reservation(fs_info, "transaction",
> > > +                                       trans->transid, trans->bytes_=
reserved, 0);
> > > +               btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > > +                                       trans->bytes_reserved, NULL);
> > > +               trans->bytes_reserved =3D 0;
> > >         }
> > >
> > > -       ASSERT(trans->block_rsv =3D=3D &fs_info->trans_block_rsv);
> > > -       trace_btrfs_space_reservation(fs_info, "transaction",
> > > -                                     trans->transid, trans->bytes_re=
served, 0);
> > > -       btrfs_block_rsv_release(fs_info, trans->block_rsv,
> > > -                               trans->bytes_reserved, NULL);
> > > -       trans->bytes_reserved =3D 0;
> > > -
> > > -       if (!trans->delayed_refs_bytes_reserved)
> > > -               return;
> > > -
> > > -       trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rs=
v",
> > > -                                     trans->transid,
> > > -                                     trans->delayed_refs_bytes_reser=
ved, 0);
> > > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > -                               trans->delayed_refs_bytes_reserved, N=
ULL);
> > > -       trans->delayed_refs_bytes_reserved =3D 0;
> > > +       if (trans->delayed_refs_bytes_reserved) {
> > > +               trace_btrfs_space_reservation(fs_info, "local_delayed=
_refs_rsv",
> > > +                                       trans->transid,
> > > +                                       trans->delayed_refs_bytes_res=
erved, 0);
> > > +               btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > +                                       trans->delayed_refs_bytes_res=
erved, NULL);
> > > +               trans->delayed_refs_bytes_reserved =3D 0;
> > > +       }
> > >  }
> > >
> > >  static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
> > > --
> > > 2.53.0
> > >
> > >
