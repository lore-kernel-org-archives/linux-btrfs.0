Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524834B1A1
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774464988; cv=none; b=LEDHQo0WCCbMEBcCHUUgdUtyf934dLHqjYM40WHFe2+0YdUTgLFXw175/yR3SDcL8sW5xzBeeONIR2IK5YckvSmKe/DiBlWAU+LnNLbB/PmDJzM/ZcB5IPzENfMbJEhDG+EBxe9EKJwCJw2r+/mLIWxBubDSB7Xh6EMEpITJz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774464988; c=relaxed/simple;
	bh=yR8Xp+d8Cy1VsKfla+HKRX/SoBYUJ+KN/Sw51Ku3ImQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pNSy4pbbFzLdAzZ4kOSpxNZf+k+CdC+lrZ6/+GUIHZLrLzeztv+6whlK/lvtnQB4dTVvzTo9Lf5AnA1B12Ht6ocIenmvuantHCgZTOJ+OM2AVOewdVigM9eAT+V8Nv0JzxS1DWzRo2gKlMdNSgVMnnR5oMGfdqfQKNiMWv4PyRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O7V85tDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O7V85tDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27A6C19423
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 18:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464987;
	bh=yR8Xp+d8Cy1VsKfla+HKRX/SoBYUJ+KN/Sw51Ku3ImQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=O7V85tDROhk1cDx5esL1mzFSlOpHi/Nc+iagXyJ5CtOBkH66yvhgVnq18hUHmOSLV
	 5QMMOaOqmbzMBQZ+yPuO7WFG14MFgKegKp4ZjksNZVuSyH7Xe1Cv6YX8bxvAoPY3sj
	 TdrWGk2fUD//FGq/NtCsBvZF8VVL8dEetjrdGVDTsibavqyC9+GHk6VdAR1BKp+K+4
	 UGzKUO0VF9rP7zEy45IZvKXmRAN/ffM8D/e3PLq0rEDuFyaH7+fzkmSfpbhTZJtJTs
	 Epk/qJZZil1W8VhXnIdM5+TK0BmMD8/8wYWlOcYmBaFGrHmCrrWcF92Kp+GsXgG8wN
	 EZ7eJ0VRoe0bA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b97e6e48b24so28088766b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 11:56:27 -0700 (PDT)
X-Gm-Message-State: AOJu0YxFlR0EZ6xo/5vp17QKo/b7mOI1Vd3XOJN37PtAE8Asvj80gcNR
	GzIVNe7368rLEl0uhUec9No/FazA8cjSwWrV7cKDs+E3KXvK3ex7Tl04efUvjQPYKPWGrtut4Ne
	GhcYDXtsDe38UZd5VWeqNl2+kXQxxdyQ=
X-Received: by 2002:a17:907:e118:b0:b98:f9c:8a2e with SMTP id
 a640c23a62f3a-b9a3f19dfe1mr207893966b.23.1774464986157; Wed, 25 Mar 2026
 11:56:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1774398665.git.boris@bur.io> <4828515e28d350985e7b7b9d3a58a5990b74362d.1774398665.git.boris@bur.io>
 <CAL3q7H6nx=Jm_pVRpyBA=dh7WkHo_zvW66SLt6k3Tiw4KWCDtg@mail.gmail.com> <20260325183916.GB2908386@zen.localdomain>
In-Reply-To: <20260325183916.GB2908386@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Mar 2026 18:55:49 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7h6U4RC+6GS7Utk=ruGQKE9kCNFmTxC68Jd_KnCu2P8Q@mail.gmail.com>
X-Gm-Features: AQROBzDCpURRgsobSjYjldgJETepqWmIiO9BbNu4k4n4tJp_8eHp1Hfr5XG6D3M
Message-ID: <CAL3q7H7h6U4RC+6GS7Utk=ruGQKE9kCNFmTxC68Jd_KnCu2P8Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 6:39=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Wed, Mar 25, 2026 at 03:36:21PM +0000, Filipe Manana wrote:
> > On Wed, Mar 25, 2026 at 12:45=E2=80=AFAM Boris Burkov <boris@bur.io> wr=
ote:
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
> > > This patch introduces the mechanism of a per-inode delayed_refs rsv
> > > which is modeled closely after the same in trans_handle. The delalloc
> > > reservation also reserves delayed refs and then finish_one_ordered
> > > transfers the inode delayed_refs rsv into the trans_handle one, just
> > > like inode->block_rsv.
> > >
> > > This is not a perfect fix for the most pathological cases, but is the
> > > infrastructure needed to keep working on the problem.
> > >
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > >  fs/btrfs/btrfs_inode.h    |  3 +++
> > >  fs/btrfs/delalloc-space.c | 34 ++++++++++++++++++++++++++++++----
> > >  fs/btrfs/delayed-ref.c    |  2 +-
> > >  fs/btrfs/inode.c          |  9 ++++++++-
> > >  fs/btrfs/transaction.c    |  7 ++++---
> > >  fs/btrfs/transaction.h    |  3 ++-
> > >  6 files changed, 48 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > > index 55c272fe5d92..dca4f6df7e95 100644
> > > --- a/fs/btrfs/btrfs_inode.h
> > > +++ b/fs/btrfs/btrfs_inode.h
> > > @@ -328,6 +328,9 @@ struct btrfs_inode {
> > >
> > >         struct btrfs_block_rsv block_rsv;
> > >
> > > +       /* Reserve for delayed refs generated by ordered extent compl=
etion. */
> > > +       struct btrfs_block_rsv delayed_rsv;
> >
> > Not that long ago we had an effort to decrease the btrfs_inode
> > structure size down to less than 1024 bytes, so that we could have 4
> > inodes per 4K page instead of 3, and this change now makes the
> > structure larger than 1024 bytes again.
>
> Good catch, thanks. And sorry for missing it.
>
> >
> > Instead of adding another block reserve to the inode we could:
> >
> > 1) Add the reservations for delayed refs in the existing block reserve
> > (inode->block_rsv);
> >
> > 2) When finishing the ordered extent, after joining the transaction
> > and setting trans->block to inode->block_rsv, we could migrate the
> > space reserved for delayed refs from the inode->block_rsv into
> > trans->delayed_rsv.
>
> At first blush, without trying very hard yet, I don't love this because I
> think it means tracking or re-computing the delayed_refs portion of
> inode->block_rsv for the migration.

Re-computing (calling btrfs_calc_delayed_ref_bytes()) is not
expensive, and it's done in workqueue for finishing ordered extents.
I wouldn't worry about that. But tracking it somewhere, implies
increasing the structure size - if it stays under or at 1024 bytes,
it's fine.

> However, I'm sure I can make it work
> and it's certainly worth doing to not regress the size of struct
> btrfs_inode.
>
> What do you think of just allocating inode->delayed_rsv indirectly with
> btrfs_alloc_block_rsv? We can save another ~100 bytes on struct
> btrfs_inode.

Adding an allocation adds potential for -ENOMEM failures.
And for 4K pages we will still be able to allocate 4 inodes per page,
so no gains here.
For a 64K page we can get a few more inodes (7 or 8).

>  And we could do it for inode->block_rsv to save yet more
> space. Do you know if we have experience that it's really important for
> inode->block_rsv to be embedded in struct btrfs_inode?

The reason we have it embedded it's because it saves a memory
allocation, and it may also be faster and maybe better cache line
spatial locality.
In the end we won't get any benefit unless the page size is > 4K so
that we can get more inodes per page.

>
> If that's a no-go, I will work on using just inode->block_rsv and doing
> the migration.
>
> >
> > This would not require increasing the btrfs_inode structure and
> > neither add a _local_delayed_rsv field to the transaction handle (and
> > btw, we don't use the _ prefix for any structure fields anywhere in
> > btrfs).
>
> Noted, thanks.
>
> >
> > Thanks.
> >
> >
> > > +
> > >         struct btrfs_delayed_node *delayed_node;
> > >
> > >         /* File creation time. */
> > > diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> > > index 0970799d0aa4..e2944ff4fe47 100644
> > > --- a/fs/btrfs/delalloc-space.c
> > > +++ b/fs/btrfs/delalloc-space.c
> > > @@ -3,6 +3,7 @@
> > >  #include "messages.h"
> > >  #include "ctree.h"
> > >  #include "delalloc-space.h"
> > > +#include "delayed-ref.h"
> > >  #include "block-rsv.h"
> > >  #include "btrfs_inode.h"
> > >  #include "space-info.h"
> > > @@ -240,6 +241,13 @@ static void btrfs_inode_rsv_release(struct btrfs=
_inode *inode, bool qgroup_free)
> > >         if (released > 0)
> > >                 trace_btrfs_space_reservation(fs_info, "delalloc",
> > >                                               btrfs_ino(inode), relea=
sed, 0);
> > > +
> > > +       released =3D btrfs_block_rsv_release(fs_info, &inode->delayed=
_rsv,
> > > +                                          0, NULL);
> > > +       if (released > 0)
> > > +               trace_btrfs_space_reservation(fs_info, "delalloc_dela=
yed_refs",
> > > +                                             btrfs_ino(inode), relea=
sed, 0);
> > > +
> > >         if (qgroup_free)
> > >                 btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_t=
o_release);
> > >         else
> > > @@ -251,7 +259,9 @@ static void btrfs_calculate_inode_block_rsv_size(=
struct btrfs_fs_info *fs_info,
> > >                                                  struct btrfs_inode *=
inode)
> > >  {
> > >         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
> > > +       struct btrfs_block_rsv *delayed_rsv =3D &inode->delayed_rsv;
> > >         u64 reserve_size =3D 0;
> > > +       u64 delayed_refs_size =3D 0;
> > >         u64 qgroup_rsv_size =3D 0;
> > >         unsigned outstanding_extents;
> > >
> > > @@ -266,6 +276,8 @@ static void btrfs_calculate_inode_block_rsv_size(=
struct btrfs_fs_info *fs_info,
> > >                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_i=
nfo,
> > >                                                 outstanding_extents);
> > >                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1=
);
> > > +               delayed_refs_size +=3D btrfs_calc_delayed_ref_bytes(f=
s_info,
> > > +                                               outstanding_extents);
> > >         }
> > >         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
> > >                 u64 csum_leaves;
> > > @@ -285,11 +297,17 @@ static void btrfs_calculate_inode_block_rsv_siz=
e(struct btrfs_fs_info *fs_info,
> > >         block_rsv->size =3D reserve_size;
> > >         block_rsv->qgroup_rsv_size =3D qgroup_rsv_size;
> > >         spin_unlock(&block_rsv->lock);
> > > +
> > > +       spin_lock(&delayed_rsv->lock);
> > > +       delayed_rsv->size =3D delayed_refs_size;
> > > +       spin_unlock(&delayed_rsv->lock);
> > >  }
> > >
> > >  static void calc_inode_reservations(struct btrfs_inode *inode,
> > >                                     u64 num_bytes, u64 disk_num_bytes=
,
> > > -                                   u64 *meta_reserve, u64 *qgroup_re=
serve)
> > > +                                   u64 *meta_reserve,
> > > +                                   u64 *delayed_refs_reserve,
> > > +                                   u64 *qgroup_reserve)
> > >  {
> > >         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> > >         u64 nr_extents =3D count_max_extents(fs_info, num_bytes);
> > > @@ -309,6 +327,10 @@ static void calc_inode_reservations(struct btrfs=
_inode *inode,
> > >          * for an inode update.
> > >          */
> > >         *meta_reserve +=3D inode_update;
> > > +
> > > +       *delayed_refs_reserve =3D btrfs_calc_delayed_ref_bytes(fs_inf=
o,
> > > +                                                            nr_exten=
ts);
> > > +
> > >         *qgroup_reserve =3D nr_extents * fs_info->nodesize;
> > >  }
> > >
> > > @@ -318,7 +340,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_=
inode *inode, u64 num_bytes,
> > >         struct btrfs_root *root =3D inode->root;
> > >         struct btrfs_fs_info *fs_info =3D root->fs_info;
> > >         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
> > > -       u64 meta_reserve, qgroup_reserve;
> > > +       u64 meta_reserve, delayed_refs_reserve, qgroup_reserve;
> > >         unsigned nr_extents;
> > >         enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_A=
LL;
> > >         int ret =3D 0;
> > > @@ -353,12 +375,14 @@ int btrfs_delalloc_reserve_metadata(struct btrf=
s_inode *inode, u64 num_bytes,
> > >          * over-reserve slightly, and clean up the mess when we are d=
one.
> > >          */
> > >         calc_inode_reservations(inode, num_bytes, disk_num_bytes,
> > > -                               &meta_reserve, &qgroup_reserve);
> > > +                               &meta_reserve, &delayed_refs_reserve,
> > > +                               &qgroup_reserve);
> > >         ret =3D btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reser=
ve, true,
> > >                                                  noflush);
> > >         if (ret)
> > >                 return ret;
> > > -       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info, m=
eta_reserve,
> > > +       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info,
> > > +                                          meta_reserve + delayed_ref=
s_reserve,
> > >                                            flush);
> > >         if (ret) {
> > >                 btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve)=
;
> > > @@ -383,6 +407,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_=
inode *inode, u64 num_bytes,
> > >         btrfs_block_rsv_add_bytes(block_rsv, meta_reserve, false);
> > >         trace_btrfs_space_reservation(root->fs_info, "delalloc",
> > >                                       btrfs_ino(inode), meta_reserve,=
 1);
> > > +       btrfs_block_rsv_add_bytes(&inode->delayed_rsv, delayed_refs_r=
eserve,
> > > +                                 false);
> > >
> > >         spin_lock(&block_rsv->lock);
> > >         block_rsv->qgroup_rsv_reserved +=3D qgroup_reserve;
> > > diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> > > index 605858c2d9a9..9fe9cec1bef3 100644
> > > --- a/fs/btrfs/delayed-ref.c
> > > +++ b/fs/btrfs/delayed-ref.c
> > > @@ -89,7 +89,7 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_tra=
ns_handle *trans)
> > >  {
> > >         struct btrfs_fs_info *fs_info =3D trans->fs_info;
> > >         struct btrfs_block_rsv *delayed_rsv =3D &fs_info->delayed_ref=
s_rsv;
> > > -       struct btrfs_block_rsv *local_rsv =3D &trans->delayed_rsv;
> > > +       struct btrfs_block_rsv *local_rsv =3D trans->delayed_rsv;
> > >         u64 num_bytes;
> > >         u64 reserved_bytes;
> > >
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 1a4e6a9239ae..1f0f3282e4b8 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struc=
t btrfs_inode *inode,
> > >                 goto out;
> > >         }
> > >         trans->block_rsv =3D &inode->block_rsv;
> > > +       trans->delayed_rsv =3D &inode->delayed_rsv;
> > >
> > >         drop_args.path =3D path;
> > >         drop_args.start =3D 0;
> > > @@ -3256,6 +3257,7 @@ int btrfs_finish_one_ordered(struct btrfs_order=
ed_extent *ordered_extent)
> > >         }
> > >
> > >         trans->block_rsv =3D &inode->block_rsv;
> > > +       trans->delayed_rsv =3D &inode->delayed_rsv;
> > >
> > >         ret =3D btrfs_insert_raid_extent(trans, ordered_extent);
> > >         if (unlikely(ret)) {
> > > @@ -8074,9 +8076,12 @@ struct inode *btrfs_alloc_inode(struct super_b=
lock *sb)
> > >
> > >         spin_lock_init(&ei->lock);
> > >         ei->outstanding_extents =3D 0;
> > > -       if (sb->s_magic !=3D BTRFS_TEST_MAGIC)
> > > +       if (sb->s_magic !=3D BTRFS_TEST_MAGIC) {
> > >                 btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv=
,
> > >                                               BTRFS_BLOCK_RSV_DELALLO=
C);
> > > +               btrfs_init_metadata_block_rsv(fs_info, &ei->delayed_r=
sv,
> > > +                                             BTRFS_BLOCK_RSV_DELREFS=
);
> > > +       }
> > >         ei->runtime_flags =3D 0;
> > >         ei->prop_compress =3D BTRFS_COMPRESS_NONE;
> > >         ei->defrag_compress =3D BTRFS_COMPRESS_NONE;
> > > @@ -8132,6 +8137,8 @@ void btrfs_destroy_inode(struct inode *vfs_inod=
e)
> > >         WARN_ON(vfs_inode->i_data.nrpages);
> > >         WARN_ON(inode->block_rsv.reserved);
> > >         WARN_ON(inode->block_rsv.size);
> > > +       WARN_ON(inode->delayed_rsv.reserved);
> > > +       WARN_ON(inode->delayed_rsv.size);
> > >         WARN_ON(inode->outstanding_extents);
> > >         if (!S_ISDIR(vfs_inode->i_mode)) {
> > >                 WARN_ON(inode->delalloc_bytes);
> > > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > > index 4358f4b63057..a55f8996cd59 100644
> > > --- a/fs/btrfs/transaction.c
> > > +++ b/fs/btrfs/transaction.c
> > > @@ -737,7 +737,8 @@ start_transaction(struct btrfs_root *root, unsign=
ed int num_items,
> > >
> > >         h->type =3D type;
> > >         INIT_LIST_HEAD(&h->new_bgs);
> > > -       btrfs_init_metadata_block_rsv(fs_info, &h->delayed_rsv, BTRFS=
_BLOCK_RSV_DELREFS);
> > > +       h->delayed_rsv =3D &h->_local_delayed_rsv;
> > > +       btrfs_init_metadata_block_rsv(fs_info, h->delayed_rsv, BTRFS_=
BLOCK_RSV_DELREFS);
> > >
> > >         smp_mb();
> > >         if (cur_trans->state >=3D TRANS_STATE_COMMIT_START &&
> > > @@ -758,7 +759,7 @@ start_transaction(struct btrfs_root *root, unsign=
ed int num_items,
> > >                                                       h->transid,
> > >                                                       delayed_refs_by=
tes, 1);
> > >                         h->delayed_refs_bytes_reserved =3D delayed_re=
fs_bytes;
> > > -                       btrfs_block_rsv_add_bytes(&h->delayed_rsv, de=
layed_refs_bytes, true);
> > > +                       btrfs_block_rsv_add_bytes(h->delayed_rsv, del=
ayed_refs_bytes, true);
> > >                         delayed_refs_bytes =3D 0;
> > >                 }
> > >                 h->reloc_reserved =3D reloc_reserved;
> > > @@ -1067,7 +1068,7 @@ static void btrfs_trans_release_metadata(struct=
 btrfs_trans_handle *trans)
> > >         trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rs=
v",
> > >                                       trans->transid,
> > >                                       trans->delayed_refs_bytes_reser=
ved, 0);
> > > -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> > > +       btrfs_block_rsv_release(fs_info, trans->delayed_rsv,
> > >                                 trans->delayed_refs_bytes_reserved, N=
ULL);
> > >         trans->delayed_refs_bytes_reserved =3D 0;
> > >  }
> > > diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> > > index 7d70fe486758..268a415c4f32 100644
> > > --- a/fs/btrfs/transaction.h
> > > +++ b/fs/btrfs/transaction.h
> > > @@ -162,7 +162,8 @@ struct btrfs_trans_handle {
> > >         bool in_fsync;
> > >         struct btrfs_fs_info *fs_info;
> > >         struct list_head new_bgs;
> > > -       struct btrfs_block_rsv delayed_rsv;
> > > +       struct btrfs_block_rsv *delayed_rsv;
> > > +       struct btrfs_block_rsv _local_delayed_rsv;
> > >         /* Extent buffers with writeback inhibited by this handle. */
> > >         struct xarray writeback_inhibited_ebs;
> > >  };
> > > --
> > > 2.53.0
> > >
> > >
