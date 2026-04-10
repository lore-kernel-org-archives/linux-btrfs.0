Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324393A75B9
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775837289; cv=none; b=bnmh8xTu/w86qUswjHPwYrNgPrZxShcjBqLKGFe5JpsnrsoYGThkY2f8lya4pos089165sU6x2cLaLqn19Fzt/Xe/lO1cZFQXk876eEygWhX6vzYQjN9KkIZIXfMvMW0LAtjK9tYkUeDEhzxs+/c3cWjYZjU9ynKZ81ybHR4dCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775837289; c=relaxed/simple;
	bh=L93G6HvusytUizzLMx3NG06aIwjE7rc2Uv4z20TTIVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DXjRt6qdC7vDPZbci7KHQl5wGaNGwErJBkpa+3TmAX++9nhPf60foPzP+3BltHplf1B4nHQYm5AsRJoVOWD0FEPjjji1H29/RsmsQRzk5PVpQgAgw6Opv2Z0CuCGdxi3vdviQw9PctcgXHtPWHE2an6UohvqxS6e85Wmpa42sy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVJ8ubPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVJ8ubPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46CEC2BCAF
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775837288;
	bh=L93G6HvusytUizzLMx3NG06aIwjE7rc2Uv4z20TTIVc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FVJ8ubPojnsMYnlGdGIPcoqiIY5zmPPHs4eOqqLurAlpNW+zYve4tqiANY8NEpmSZ
	 Hu8g4+2obA7tEA08kIoHiYsTSyg03+UpxTspc4Nk+efR5IKfFs0i7KnkPp4nMwaFoO
	 rMp7sgK5I3EHg6wsuMw2l/aSdQUck9YwIsN+9uwm8va7yS2zsFpQWv7es2ij99IW6b
	 kFptMyR040F7aBUvIOXE37+0/VUFFzPAH4/wK8pgmV7gE2ypA+mS/62FTvCuyFOnqd
	 wAxeTJbVCjlGHpSB1VeFo7jDPBWiKqU9h3VhjFbgFJt2WtIOU8ADBOCldFbjd8q8w1
	 RCYC2lDJ0/t3Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9c603ec2dfso316491366b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 09:08:08 -0700 (PDT)
X-Gm-Message-State: AOJu0YwYpghFwbUDPOcM/8LpyrcHGuP6pNkryRR4CwJftfLxT5eCF+CX
	W1Q9tM4Y+4FGBFghWoDqkQWv3QZ2gd9F0wKr7WAgZZgTJC/Ac1xkErigIK+oUkJHOI79D86FI7p
	vHfofvmbOEr27SMcrZReqJbZ9P2CawYA=
X-Received: by 2002:a17:907:1b08:b0:b9c:77b3:a15c with SMTP id
 a640c23a62f3a-b9d7267a864mr216809266b.11.1775837287207; Fri, 10 Apr 2026
 09:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775756789.git.boris@bur.io> <05bde74e587402f5d77897f0507a292ab9522355.1775756789.git.boris@bur.io>
In-Reply-To: <05bde74e587402f5d77897f0507a292ab9522355.1775756789.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 10 Apr 2026 17:07:30 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4ANvgrs6B6J6gcLLCsrdLpYhD5gc3k2EuxAMfifEFBMg@mail.gmail.com>
X-Gm-Features: AQROBzChhoypURxGVfawC8LSlhLf52BewJNWz2N2sXERgyIZFHL5QyqzptlOpnw
Message-ID: <CAL3q7H4ANvgrs6B6J6gcLLCsrdLpYhD5gc3k2EuxAMfifEFBMg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 6:49=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
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

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/delalloc-space.c | 52 +++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/delalloc-space.h |  3 +++
>  fs/btrfs/inode.c          |  2 ++
>  fs/btrfs/transaction.c    | 36 +++++++++++----------------
>  4 files changed, 72 insertions(+), 21 deletions(-)
>
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..63e174cc9393 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -3,11 +3,13 @@
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
> @@ -247,6 +249,35 @@ static void btrfs_inode_rsv_release(struct btrfs_ino=
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
> +       /*
> +        * Factor for how many delayed refs updates we will generate per =
extent.
> +        * Non-optional: extent tree, subvolume tree
> +        */
> +       int factor =3D 4;
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
> @@ -266,6 +297,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_info,
>                                                 outstanding_extents);
>                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1);
> +               reserve_size +=3D delalloc_calc_delayed_refs_rsv(inode, o=
utstanding_extents);
>         }
>         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
>                 u64 csum_leaves;
> @@ -309,9 +341,29 @@ static void calc_inode_reservations(struct btrfs_ino=
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
