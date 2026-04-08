Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B261D335063
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775660213; cv=none; b=iGLCABJvp8m/wdJ+8+aLeZpmhUZYmcIibAMI43TArxAmfNeonS/rLizsdJEJVQNkwhXGXV995IyGUBscY2TF93aP/ylrKlL6cSLJ0Z4btBvwdt9/Kn05oq0JwmI9svONWs4LWzNYXlyoFV7lIk8yRauXHhjK02cd6m2oPeOFxe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775660213; c=relaxed/simple;
	bh=iziEONPT5iwLXNxflkcp8IeY3u1ZKd2L0QBpNLS1Y5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okaP1pQStf+uiXm477YVf6klabUz6Fw1VEhK1Xr5I50xwDo3BpOApCQfPeNiUSC4YB0uQS6+OgRvoKbfWYIwAy3GbN0A58QHgsYYWM7Xw8CXZjq0kObCyiBs6620LQX67MP4vXEsWHlmzqKLToxHdv/ZNYttbMzvcm/jIsCHhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=paYckxSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="paYckxSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E4FC19421
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775660213;
	bh=iziEONPT5iwLXNxflkcp8IeY3u1ZKd2L0QBpNLS1Y5c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=paYckxSWVqBDGZC8u1sxkQ40cZZ/cPJHomE9+iw9bfoH/Au7Af9FBgICO0gnJ8jXx
	 hJdfa8WRvzHdPdLMnUb9Br90JrzFNK3Ry3UddxdCNmrB2n4DxKGxRIqUXTS/Yz4eNo
	 qI5a5CJ6u2Q4liF9n1c1/Q7CjrE3wSmxCcziTCF4Aqhf144KRSC8+sVB/ZiQAFEb2M
	 s566h7iI0YEUWN9sAX59Fia7xyMrCVLZYTASftk2rTNvxvDXgZtcyXuzyeVy9aMwYy
	 boruypHVRx1VO399ENNHO9c9pJ4XWlLi2geDUwUv7FWqdgFhzvPb8FTjt0MYo8U9d7
	 NvUP/0JuuoVOQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so805416266b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 07:56:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YywHumsZTBcw4RO+/Dm3MzOf0bkWTfkBCl+UvpGAwX4srHMeveF
	4wSlgIF/MvNqg4/v9zP758+Od25QGvcXtrCl4gMYp4CF1YIXFaniGPmFo8MysETwPabgi9tWype
	bWeWDk6BCnB/UDPyOdBsNINcLmV2uaf0=
X-Received: by 2002:a17:907:7207:b0:b97:89b5:d7a0 with SMTP id
 a640c23a62f3a-b9c67bb806fmr1070077466b.48.1775660211839; Wed, 08 Apr 2026
 07:56:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775589916.git.boris@bur.io> <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
In-Reply-To: <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 8 Apr 2026 15:56:14 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>
X-Gm-Features: AQROBzCh7tWowNM6-bKiVOS2Wo5M5Srhl_1LLnInGSWefEU5zpfYQXhCp0eWiyw
Message-ID: <CAL3q7H7X6eFwrVXW6p21nuxawE8+O1dyXV-Yyg_uS4ipf1O5+w@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 8:31=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> delalloc uses a per-inode block_rsv to perform metadata reservations for
> the cow operations it anticipates based on the number of outstanding
> extents. This calculation is done based on inode->outstanding_extents in
> btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
> meticulously tracked as each ordered_extent is actually created in
> writeback, but rather delalloc attempts to over-estimate and the
> writeback and ordered_extent finish portions are responsible to release
> all the reservation.
>
> However, there is a notable gap in this reservation, it reserves no
> space for the resulting delayed_refs. If you compare to how
> btrfs_start_transaction() reservations work, this is a noteable
> difference.
>
> As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
> that function will start generating delayed refs, which will draw from
> the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():
>
> For example, we can trace the primary data delayed ref:
>
> btrfs_finish_one_ordered()
>   insert_ordered_extent_file_extent()
>     insert_reserved_file_extent()
>       btrfs_alloc_reserved_file_extent()
>         btrfs_add_delayed_data_ref()
>           add_delayed_ref()
>             btrfs_update_delayed_refs_rsv();
>
> This trans_handle was created in finish_one_ordered() with
> btrfs_join_transaction() which calls start_transaction with
> num_items=3D0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
> has no reserved in h->delayed_rsv, as neither the num_items reservation
> nor the btrfs_delayed_refs_rsv_refill() reservation is run.
>
> Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
> fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.
>
> If a large amount of writeback happens all at once (perhaps due to
> dirty_ratio being tuned too high), this results in, among other things,
> erroneous assessments of the amount of delayed_refs reserved in the
> metadata space reclaim logic, like need_preemptive_reclaim() which
> relies on fs_info->delayed_rsv->reserved and even worse, poor decision
> making in btrfs_preempt_reclaim_metadata_space() which counts
> delalloc_bytes like so:
>
>   block_rsv_size =3D global_rsv_size +
>           btrfs_block_rsv_reserved(delayed_block_rsv) +
>           btrfs_block_rsv_reserved(delayed_refs_rsv) +
>           btrfs_block_rsv_reserved(trans_rsv);
>   delalloc_size =3D bytes_may_use - block_rsv_size;
>
> So all that lost delayed refs usage gets accounted as delalloc_size and
> leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
> further exacerbates the problem.
>
> With enough writeback around, we can run enough delalloc that we get
> into async reclaim which starts blocking start_transaction() and
> eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
> the filesystem gets heavily blocked on metadata space in reserve_space(),
> blocking all new transaction work until all the ordered_extents finish.
>
> If we had an accurate view of the reservation for delayed refs, then we
> could mostly break this feedback loop in preemptive reclaim, and
> generally would be able to make more accurate decisions with regards to
> metadata space reclamation.
>
> This patch adds extra metadata reservation to the inode's block_rsv to
> account for the delayed refs. When the ordered_extent finishes and we
> are about to do work in the transaction that uses delayed refs, we
> migrate enough for 1 extent. Since this is not necessarily perfect, we
> have to be careful and do a "soft" migrate which succeeds even if there
> is not enough reservation. This is strictly better than what we have and
> also matches how the delayed ref rsv gets used in the transaction at
> btrfs_update_delayed_refs_rsv().
>
> Aside from this data delayed_ref, there are also some metadata
> delayed_refs to consider. These are:
> - subvolume tree for the file extent item
> - csum tree for data csums
> - raid stripe tree if enabled
> - free space tree if enabled
>
> So account for those delayed_refs in the reservation as well. This
> greatly increases the size of the reservation as each metadata cow
> results in two delayed refs: one add for the new block in
> btrfs_alloc_tree_block() and one drop for the old in
> btrfs_free_tree_block(). As a result, to be completely conservative,
> we need to reserve 2 delayed refs worth of space for each cow.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/delalloc-space.c | 56 +++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/delalloc-space.h |  3 +++
>  fs/btrfs/inode.c          |  2 ++
>  fs/btrfs/transaction.c    | 36 +++++++++++--------------
>  4 files changed, 76 insertions(+), 21 deletions(-)
>
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..c99f516ce8af 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -1,13 +1,16 @@
>  // SPDX-License-Identifier: GPL-2.0
>
> +#include "linux/btrfs_tree.h"

Not needed.

>  #include "messages.h"
>  #include "ctree.h"
>  #include "delalloc-space.h"
> +#include "delayed-ref.h"
>  #include "block-rsv.h"
>  #include "btrfs_inode.h"
>  #include "space-info.h"
>  #include "qgroup.h"
>  #include "fs.h"
> +#include "transaction.h"
>
>  /*
>   * HOW DOES THIS WORK
> @@ -247,6 +250,38 @@ static void btrfs_inode_rsv_release(struct btrfs_ino=
de *inode, bool qgroup_free)
>                                                    qgroup_to_release);
>  }
>
> +/*
> + * Each delalloc extent could become an ordered_extent and end up insert=
ing a
> + * new data extent and modify a number of btrees. Each of those is assoc=
iated with
> + * adding delayed refs which need a corresponding delayed refs reservati=
on.
> + *
> + * Each metadata cow operation results in an add and a drop delayed ref,=
 both of
> + * which call add_delayed_ref() and ultimately btrfs_update_delayed_refs=
_rsv(),
> + * so each must account for 2 delayed refs.
> + */
> +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_inode *inod=
e, u64 nr_extents)
> +{
> +       const struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +
> +       /*
> +        * Factor for how many delayed refs updates we will generate per =
extent.
> +        * Non-optional:
> +        * extent tree: 1 data delayed ref.

Running the delayed data ref to insert the extent item in the extent
tree requires COWing an extent tree leaf, which creates a delayed tree
ref for deletion too.
So, 2.

Otherwise it looks good, thanks.

> +        * subvolume tree: 1 cow =3D> 2 metadata delayed refs.
> +        */
> +       int factor =3D 3;
> +
> +       /* The remaining trees are only written to conditionally. */
> +       if (!(inode->flags & BTRFS_INODE_NODATASUM))
> +               factor +=3D 2;
> +       if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
> +               factor +=3D 2;
> +       if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
> +               factor +=3D 2;
> +
> +       return btrfs_calc_insert_metadata_size(fs_info, nr_extents) * fac=
tor;
> +}
> +
>  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *f=
s_info,
>                                                  struct btrfs_inode *inod=
e)
>  {
> @@ -266,6 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_info,
>                                                 outstanding_extents);
>                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1);
> +               reserve_size +=3D delalloc_calc_delayed_refs_rsv(inode, o=
utstanding_extents);
>         }
>         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
>                 u64 csum_leaves;
> @@ -309,9 +345,29 @@ static void calc_inode_reservations(struct btrfs_ino=
de *inode,
>          * for an inode update.
>          */
>         *meta_reserve +=3D inode_update;
> +
> +       *meta_reserve +=3D delalloc_calc_delayed_refs_rsv(inode, nr_exten=
ts);
> +
>         *qgroup_reserve =3D nr_extents * fs_info->nodesize;
>  }
>
> +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *=
trans,
> +                                            struct btrfs_inode *inode)
> +{
> +       struct btrfs_block_rsv *inode_rsv =3D &inode->block_rsv;
> +       struct btrfs_block_rsv *trans_rsv =3D &trans->delayed_rsv;
> +       u64 num_bytes =3D delalloc_calc_delayed_refs_rsv(inode, 1);
> +
> +       spin_lock(&inode_rsv->lock);
> +       num_bytes =3D min(num_bytes, inode_rsv->reserved);
> +       inode_rsv->reserved -=3D num_bytes;
> +       inode_rsv->full =3D (inode_rsv->reserved >=3D inode_rsv->size);
> +       spin_unlock(&inode_rsv->lock);
> +
> +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> +       trans->delayed_refs_bytes_reserved +=3D num_bytes;
> +}
> +
>  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_b=
ytes,
>                                     u64 disk_num_bytes, bool noflush)
>  {
> diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> index 6119c0d3f883..bd7041166987 100644
> --- a/fs/btrfs/delalloc-space.h
> +++ b/fs/btrfs/delalloc-space.h
> @@ -8,6 +8,7 @@
>  struct extent_changeset;
>  struct btrfs_inode;
>  struct btrfs_fs_info;
> +struct btrfs_trans_handle;
>
>  int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64=
 bytes);
>  int btrfs_check_data_free_space(struct btrfs_inode *inode,
> @@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode =
*inode, u64 num_bytes,
>                                     u64 disk_num_bytes, bool noflush);
>  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_b=
ytes);
>  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserv=
ed_len, u64 new_len);
> +void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *=
trans,
> +                                            struct btrfs_inode *inode);
>
>  #endif /* BTRFS_DELALLOC_SPACE_H */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40474014c03f..15945744a304 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct bt=
rfs_inode *inode,
>                 goto out;
>         }
>         trans->block_rsv =3D &inode->block_rsv;
> +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
>
>         drop_args.path =3D path;
>         drop_args.start =3D 0;
> @@ -3259,6 +3260,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>         }
>
>         trans->block_rsv =3D &inode->block_rsv;
> +       btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
>
>         ret =3D btrfs_insert_raid_extent(trans, ordered_extent);
>         if (unlikely(ret)) {
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785051..55791bb100a2 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(struct b=
trfs_trans_handle *trans)
>                 return;
>         }
>
> -       if (!trans->bytes_reserved) {
> -               ASSERT(trans->delayed_refs_bytes_reserved =3D=3D 0,
> -                      "trans->delayed_refs_bytes_reserved=3D%llu",
> -                      trans->delayed_refs_bytes_reserved);
> -               return;
> +       if (trans->bytes_reserved) {
> +               ASSERT(trans->block_rsv =3D=3D &fs_info->trans_block_rsv)=
;
> +               trace_btrfs_space_reservation(fs_info, "transaction",
> +                                       trans->transid, trans->bytes_rese=
rved, 0);
> +               btrfs_block_rsv_release(fs_info, trans->block_rsv,
> +                                       trans->bytes_reserved, NULL);
> +               trans->bytes_reserved =3D 0;
>         }
>
> -       ASSERT(trans->block_rsv =3D=3D &fs_info->trans_block_rsv);
> -       trace_btrfs_space_reservation(fs_info, "transaction",
> -                                     trans->transid, trans->bytes_reserv=
ed, 0);
> -       btrfs_block_rsv_release(fs_info, trans->block_rsv,
> -                               trans->bytes_reserved, NULL);
> -       trans->bytes_reserved =3D 0;
> -
> -       if (!trans->delayed_refs_bytes_reserved)
> -               return;
> -
> -       trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
> -                                     trans->transid,
> -                                     trans->delayed_refs_bytes_reserved,=
 0);
> -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> -                               trans->delayed_refs_bytes_reserved, NULL)=
;
> -       trans->delayed_refs_bytes_reserved =3D 0;
> +       if (trans->delayed_refs_bytes_reserved) {
> +               trace_btrfs_space_reservation(fs_info, "local_delayed_ref=
s_rsv",
> +                                       trans->transid,
> +                                       trans->delayed_refs_bytes_reserve=
d, 0);
> +               btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> +                                       trans->delayed_refs_bytes_reserve=
d, NULL);
> +               trans->delayed_refs_bytes_reserved =3D 0;
> +       }
>  }
>
>  static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
> --
> 2.53.0
>
>
