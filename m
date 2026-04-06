Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9A9391E45
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775496078; cv=none; b=MbP3DzHYH/enS8ogJ73tJgz+f/6W2sOay9Gqs9RGLjThvvsT++1rddfQfBWxIeMtclojPGv9eb+SyMG7lKOD53eB6Lo7veV5Yv5l9kQ2FGOwh1TtJKirXT8oMlgjQ9kk0FXqlyasswga/TFLs2a6vkCipeviqKDAay66ptjwIGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775496078; c=relaxed/simple;
	bh=fn9+5YRhWZus2swoHi42Yrr2JDWfVD09fJRmJk8iOC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlO4Lqfl3NN1521zpK9BWsnbp0xgW97HfVjxJthg7DbRYE9/a5AvclvMUMl3coozp1tBPTW3xGt8BLM1pu98MlqnxyKFk/dPI8BAGDbZEmdBVsnTU57+Lq7QRJ1/7raxNTmy8LeGzHvWUHoL6NWEGGrnDv/GBmQtDGCn3pUD0o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCF6fgFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCF6fgFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A6C4AF09
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775496077;
	bh=fn9+5YRhWZus2swoHi42Yrr2JDWfVD09fJRmJk8iOC8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cCF6fgFdnL7aSj7S2/Pt7nA7rvZ6uNchV07dB3nO8sNn5DxOfOkV+q03chvT7Tg5O
	 zNE794Q/gAnA6cNvRVO9DnGtws20MBYCTaW+PyrltG97kL458cEfnioHqTc5p7YDc1
	 UvquIWkvTFFhDfp4cBqSl7XbIXFYr0nwLwnS4Tnr/zzJmP0s7OTVd87SJ9+fsSRuW1
	 frOZhgAQ2XpOuDbioSbDvldFR6P4DGvh0TCYALCt8LcrRIqbMYBH+LbHsCWsr95CWJ
	 qx9Ea+OngNQWzzmPvRUDMuV8/yItcMjlq7EOq7/YVd5OUyVcPu7TOp5UhG8Gyp5ACk
	 Zn1sgWJewvO5Q==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66bf6aa4858so7666219a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 10:21:17 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywu4TfafigBL4bcloY5kiB5PSiju7TjDva1zy/fZatOaWiqLgdj
	NQVnyYmlLRjqskIVGMBsUFJgH+FkKmLloidgf8Z31PxRzqo/lNCbesdTVDYovP4iHUr/8CV073K
	5JCDJSGgALLwDhQ6CAwpigEy2y7YrUyI=
X-Received: by 2002:a17:907:3f90:b0:b90:4b42:a982 with SMTP id
 a640c23a62f3a-b9c679f341bmr534736766b.41.1775496076077; Mon, 06 Apr 2026
 10:21:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775255085.git.boris@bur.io> <0f736c6cf8027adb16d7c6c29443afb03ceaf24b.1775255085.git.boris@bur.io>
In-Reply-To: <0f736c6cf8027adb16d7c6c29443afb03ceaf24b.1775255085.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Apr 2026 18:20:39 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6ru-f8GG-idhx5JySeRkr1i_WUvw3aixi+ws2sCDD=Zw@mail.gmail.com>
X-Gm-Features: AQROBzCNEdYFrXSJ2VFNb_geeUjauYW2v3hvEn-19cSC63iO08b4X9z_Tgawk0I
Message-ID: <CAL3q7H6ru-f8GG-idhx5JySeRkr1i_WUvw3aixi+ws2sCDD=Zw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 11:29=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
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
> btrfs_update_delayed_refs_rsv()
>
> This is not a perfect fix for the most pathological cases, but is the
> infrastructure needed to keep working on the problem.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/delalloc-space.c | 43 ++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/delalloc-space.h |  3 +++
>  fs/btrfs/inode.c          |  5 ++++-
>  fs/btrfs/transaction.c    | 36 ++++++++++++++------------------
>  4 files changed, 62 insertions(+), 25 deletions(-)
>
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..a087be55409f 100644
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
> @@ -240,6 +242,7 @@ static void btrfs_inode_rsv_release(struct btrfs_inod=
e *inode, bool qgroup_free)
>         if (released > 0)
>                 trace_btrfs_space_reservation(fs_info, "delalloc",
>                                               btrfs_ino(inode), released,=
 0);
> +

Stray new line change. No other surrounding code changed.

>         if (qgroup_free)
>                 btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_re=
lease);
>         else
> @@ -247,6 +250,16 @@ static void btrfs_inode_rsv_release(struct btrfs_ino=
de *inode, bool qgroup_free)
>                                                    qgroup_to_release);
>  }
>
> +/*
> + * Each delalloc extent could become an ordered_extent and end up insert=
ing a
> + * new extent into the extent and free space trees. So we must reserve
> + * delayed ref space up front for that.

Ok, so that's 2 delayed refs, one to modify the extent tree and
another to modify the free space tree.
So below, techically we should account for nr_extents * 2.

And we actually need to modify more trees: the csum tree if we have
csums to insert and the new raid stripe tree.

> + */
> +static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs=
_info, u64 nr_extents)
> +{
> +       return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents);
> +}
> +
>  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *f=
s_info,
>                                                  struct btrfs_inode *inod=
e)
>  {
> @@ -266,6 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_info,
>                                                 outstanding_extents);
>                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1);
> +               reserve_size +=3D delalloc_calc_delayed_refs_rsv(fs_info,=
 outstanding_extents);
>         }
>         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
>                 u64 csum_leaves;
> @@ -289,7 +303,8 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>
>  static void calc_inode_reservations(struct btrfs_inode *inode,
>                                     u64 num_bytes, u64 disk_num_bytes,
> -                                   u64 *meta_reserve, u64 *qgroup_reserv=
e)
> +                                   u64 *meta_reserve,
> +                                   u64 *qgroup_reserve)

Another style change only, without any functional changes.

>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 nr_extents =3D count_max_extents(fs_info, num_bytes);
> @@ -309,9 +324,31 @@ static void calc_inode_reservations(struct btrfs_ino=
de *inode,
>          * for an inode update.
>          */
>         *meta_reserve +=3D inode_update;
> +
> +       *meta_reserve +=3D delalloc_calc_delayed_refs_rsv(fs_info, nr_ext=
ents);
> +
>         *qgroup_reserve =3D nr_extents * fs_info->nodesize;
>  }
>
> +u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *t=
rans,
> +                                           struct btrfs_inode *inode)
> +{
> +       struct btrfs_block_rsv *inode_rsv =3D &inode->block_rsv;
> +       struct btrfs_block_rsv *trans_rsv =3D &trans->delayed_rsv;
> +       u64 num_bytes =3D delalloc_calc_delayed_refs_rsv(trans->fs_info, =
1);
> +
> +       spin_lock(&inode_rsv->lock);
> +       num_bytes =3D min(num_bytes, inode_rsv->reserved);
> +       inode_rsv->reserved -=3D num_bytes;
> +       inode_rsv->full =3D (inode_rsv->reserved >=3D inode_rsv->size);
> +       spin_unlock(&inode_rsv->lock);
> +
> +       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
> +       trans->delayed_refs_bytes_reserved +=3D num_bytes;
> +
> +       return num_bytes;

Why return the number of bytes?
None of the callers cares about the return value, it can be just void.

> +}
> +
>  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_b=
ytes,
>                                     u64 disk_num_bytes, bool noflush)
>  {
> @@ -358,8 +395,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>                                                  noflush);
>         if (ret)
>                 return ret;
> -       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info, meta_=
reserve,
> -                                          flush);
> +       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info,
> +                                          meta_reserve, flush);

Yet another style change, without any surrounding functional changes.

>         if (ret) {
>                 btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
>                 return ret;
> diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> index 6119c0d3f883..b058e884879b 100644
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
> +u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *t=
rans,
> +                                           struct btrfs_inode *inode);
>
>  #endif /* BTRFS_DELALLOC_SPACE_H */
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 808e52aa6ef2..c57473030814 100644
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
> @@ -3297,6 +3298,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>                 }
>         } else {
>                 BUG_ON(root =3D=3D fs_info->tree_root);
> +               btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);

So for the other case, writing into a prealloc extent, we should also
migrate space space because we will update the fs tree to modify a
file extent item (the call to btrfs_mark_extent_written()) and that
can generate delayed refs if we need to COW blocks from the fs tree
for that.

>                 ret =3D insert_ordered_extent_file_extent(trans, ordered_=
extent);
>                 if (unlikely(ret < 0)) {
>                         btrfs_abort_transaction(trans, ret);
> @@ -8074,9 +8076,10 @@ struct inode *btrfs_alloc_inode(struct super_block=
 *sb)
>
>         spin_lock_init(&ei->lock);
>         ei->outstanding_extents =3D 0;
> -       if (sb->s_magic !=3D BTRFS_TEST_MAGIC)
> +       if (sb->s_magic !=3D BTRFS_TEST_MAGIC) {
>                 btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
>                                               BTRFS_BLOCK_RSV_DELALLOC);
> +       }

Another style change and this one goes against our style preference -
no { } for single statement if.

This is just a quick pass over the change, I'll look into the
following patches soon.

>         ei->runtime_flags =3D 0;
>         ei->prop_compress =3D BTRFS_COMPRESS_NONE;
>         ei->defrag_compress =3D BTRFS_COMPRESS_NONE;
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
