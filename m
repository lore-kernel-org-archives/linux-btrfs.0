Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DFB3CCFBA
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774453021; cv=none; b=KhFBo6PKbdrTQnKgt3AblWvqIuwYp4qnEkHM5cLAlCum7YBe5uSrIITSDNIOO8q0EdAyX2yHDShMcpjTwmmidOkUOdfYn4u2HgOFSoxMylMOHYY3KgpZtsiBjHxk0ZxRIJHQoZGtIBoA8NhGkIGXfgAEtNQLmYCKGHFiWjLHerg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774453021; c=relaxed/simple;
	bh=QHvkJ0WeZ98OgpBvsDiw8RfA2o1APEvankX0VNY0xJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHy1oxVbsBwWbMGDFTo810iko8o3cqeaUDGUWMg4JscahoqQz6Wd9z3sAi1ymGmEW1g4VPN93n59khQn1UWS1VaJAJ9ZgUQnBSmHreL9laf7Bh/aRtO4P1DJTWzK7RvcBdb5K4N14kVWmlpodNVrYbDNGLZnD9DBmGJzqu8IP/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9zrjYHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9zrjYHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B2CC116C6
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774453020;
	bh=QHvkJ0WeZ98OgpBvsDiw8RfA2o1APEvankX0VNY0xJU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i9zrjYHvM1r4Nr/57fPPk3k278PuDBqJPxbjCBSRUx6+Y82HnAugGwyN4ucoOM0w2
	 J/VZtSxXfAheb48nbtrZVk+hRb3qvWN3KobR/picCk9bf5J/29itOwtiQXszVI/tI1
	 zrHpDD3Q6PFOaUSi6/XmerEfton5wI9WR4Igncu3ow1MPs6/dMn55Pg71jR6Ygy8dK
	 D3DvfUNJ/eG9AXoo8zCtbIjwXr0k8J+kL9CP8nRhJAQxHb7ckGqnNw2mt1fYmvDKsL
	 4WrMMkkuFSBM9jiRAngKnM17WMx+V9lwjJAl+boxaRnzSuqHPAobtzAwHBw+KExkaw
	 Gvc9do8qy/eTw==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-667de793310so4736563a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 08:37:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YyrBIeG0qB/VMoSnfgnhHpylZvaWu43e7UwshePXNCv/zgb9wOI
	hY3lLn0lstPK8G8RH0rzQHZdc4Z4c/FD/6MjGWidQD2r9AED0Gy1RpVMf7zNiD+QuLJvu844dlY
	hkrtFLYc9mpaiH1UQguGNSgsbZWAc5lo=
X-Received: by 2002:a17:907:6d18:b0:b97:bc3e:6143 with SMTP id
 a640c23a62f3a-b9a3f148f61mr282971666b.6.1774453018836; Wed, 25 Mar 2026
 08:36:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1774398665.git.boris@bur.io> <4828515e28d350985e7b7b9d3a58a5990b74362d.1774398665.git.boris@bur.io>
In-Reply-To: <4828515e28d350985e7b7b9d3a58a5990b74362d.1774398665.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 25 Mar 2026 15:36:21 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6nx=Jm_pVRpyBA=dh7WkHo_zvW66SLt6k3Tiw4KWCDtg@mail.gmail.com>
X-Gm-Features: AQROBzCdtssLtMjFs_7jq2RcJhjJ_tr1pdLHLwSuf_IIyFgtaBf4ee-3tn_m0wQ
Message-ID: <CAL3q7H6nx=Jm_pVRpyBA=dh7WkHo_zvW66SLt6k3Tiw4KWCDtg@mail.gmail.com>
Subject: Re: [PATCH 1/5] btrfs: reserve space for delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 12:45=E2=80=AFAM Boris Burkov <boris@bur.io> wrote:
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
> This patch introduces the mechanism of a per-inode delayed_refs rsv
> which is modeled closely after the same in trans_handle. The delalloc
> reservation also reserves delayed refs and then finish_one_ordered
> transfers the inode delayed_refs rsv into the trans_handle one, just
> like inode->block_rsv.
>
> This is not a perfect fix for the most pathological cases, but is the
> infrastructure needed to keep working on the problem.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h    |  3 +++
>  fs/btrfs/delalloc-space.c | 34 ++++++++++++++++++++++++++++++----
>  fs/btrfs/delayed-ref.c    |  2 +-
>  fs/btrfs/inode.c          |  9 ++++++++-
>  fs/btrfs/transaction.c    |  7 ++++---
>  fs/btrfs/transaction.h    |  3 ++-
>  6 files changed, 48 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 55c272fe5d92..dca4f6df7e95 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -328,6 +328,9 @@ struct btrfs_inode {
>
>         struct btrfs_block_rsv block_rsv;
>
> +       /* Reserve for delayed refs generated by ordered extent completio=
n. */
> +       struct btrfs_block_rsv delayed_rsv;

Not that long ago we had an effort to decrease the btrfs_inode
structure size down to less than 1024 bytes, so that we could have 4
inodes per 4K page instead of 3, and this change now makes the
structure larger than 1024 bytes again.

Instead of adding another block reserve to the inode we could:

1) Add the reservations for delayed refs in the existing block reserve
(inode->block_rsv);

2) When finishing the ordered extent, after joining the transaction
and setting trans->block to inode->block_rsv, we could migrate the
space reserved for delayed refs from the inode->block_rsv into
trans->delayed_rsv.

This would not require increasing the btrfs_inode structure and
neither add a _local_delayed_rsv field to the transaction handle (and
btw, we don't use the _ prefix for any structure fields anywhere in
btrfs).

Thanks.


> +
>         struct btrfs_delayed_node *delayed_node;
>
>         /* File creation time. */
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0aa4..e2944ff4fe47 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -3,6 +3,7 @@
>  #include "messages.h"
>  #include "ctree.h"
>  #include "delalloc-space.h"
> +#include "delayed-ref.h"
>  #include "block-rsv.h"
>  #include "btrfs_inode.h"
>  #include "space-info.h"
> @@ -240,6 +241,13 @@ static void btrfs_inode_rsv_release(struct btrfs_ino=
de *inode, bool qgroup_free)
>         if (released > 0)
>                 trace_btrfs_space_reservation(fs_info, "delalloc",
>                                               btrfs_ino(inode), released,=
 0);
> +
> +       released =3D btrfs_block_rsv_release(fs_info, &inode->delayed_rsv=
,
> +                                          0, NULL);
> +       if (released > 0)
> +               trace_btrfs_space_reservation(fs_info, "delalloc_delayed_=
refs",
> +                                             btrfs_ino(inode), released,=
 0);
> +
>         if (qgroup_free)
>                 btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_re=
lease);
>         else
> @@ -251,7 +259,9 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>                                                  struct btrfs_inode *inod=
e)
>  {
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
> +       struct btrfs_block_rsv *delayed_rsv =3D &inode->delayed_rsv;
>         u64 reserve_size =3D 0;
> +       u64 delayed_refs_size =3D 0;
>         u64 qgroup_rsv_size =3D 0;
>         unsigned outstanding_extents;
>
> @@ -266,6 +276,8 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>                 reserve_size =3D btrfs_calc_insert_metadata_size(fs_info,
>                                                 outstanding_extents);
>                 reserve_size +=3D btrfs_calc_metadata_size(fs_info, 1);
> +               delayed_refs_size +=3D btrfs_calc_delayed_ref_bytes(fs_in=
fo,
> +                                               outstanding_extents);
>         }
>         if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
>                 u64 csum_leaves;
> @@ -285,11 +297,17 @@ static void btrfs_calculate_inode_block_rsv_size(st=
ruct btrfs_fs_info *fs_info,
>         block_rsv->size =3D reserve_size;
>         block_rsv->qgroup_rsv_size =3D qgroup_rsv_size;
>         spin_unlock(&block_rsv->lock);
> +
> +       spin_lock(&delayed_rsv->lock);
> +       delayed_rsv->size =3D delayed_refs_size;
> +       spin_unlock(&delayed_rsv->lock);
>  }
>
>  static void calc_inode_reservations(struct btrfs_inode *inode,
>                                     u64 num_bytes, u64 disk_num_bytes,
> -                                   u64 *meta_reserve, u64 *qgroup_reserv=
e)
> +                                   u64 *meta_reserve,
> +                                   u64 *delayed_refs_reserve,
> +                                   u64 *qgroup_reserve)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 nr_extents =3D count_max_extents(fs_info, num_bytes);
> @@ -309,6 +327,10 @@ static void calc_inode_reservations(struct btrfs_ino=
de *inode,
>          * for an inode update.
>          */
>         *meta_reserve +=3D inode_update;
> +
> +       *delayed_refs_reserve =3D btrfs_calc_delayed_ref_bytes(fs_info,
> +                                                            nr_extents);
> +
>         *qgroup_reserve =3D nr_extents * fs_info->nodesize;
>  }
>
> @@ -318,7 +340,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>         struct btrfs_root *root =3D inode->root;
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
> -       u64 meta_reserve, qgroup_reserve;
> +       u64 meta_reserve, delayed_refs_reserve, qgroup_reserve;
>         unsigned nr_extents;
>         enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_ALL;
>         int ret =3D 0;
> @@ -353,12 +375,14 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_in=
ode *inode, u64 num_bytes,
>          * over-reserve slightly, and clean up the mess when we are done.
>          */
>         calc_inode_reservations(inode, num_bytes, disk_num_bytes,
> -                               &meta_reserve, &qgroup_reserve);
> +                               &meta_reserve, &delayed_refs_reserve,
> +                               &qgroup_reserve);
>         ret =3D btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserve, =
true,
>                                                  noflush);
>         if (ret)
>                 return ret;
> -       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info, meta_=
reserve,
> +       ret =3D btrfs_reserve_metadata_bytes(block_rsv->space_info,
> +                                          meta_reserve + delayed_refs_re=
serve,
>                                            flush);
>         if (ret) {
>                 btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
> @@ -383,6 +407,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>         btrfs_block_rsv_add_bytes(block_rsv, meta_reserve, false);
>         trace_btrfs_space_reservation(root->fs_info, "delalloc",
>                                       btrfs_ino(inode), meta_reserve, 1);
> +       btrfs_block_rsv_add_bytes(&inode->delayed_rsv, delayed_refs_reser=
ve,
> +                                 false);
>
>         spin_lock(&block_rsv->lock);
>         block_rsv->qgroup_rsv_reserved +=3D qgroup_reserve;
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 605858c2d9a9..9fe9cec1bef3 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -89,7 +89,7 @@ void btrfs_update_delayed_refs_rsv(struct btrfs_trans_h=
andle *trans)
>  {
>         struct btrfs_fs_info *fs_info =3D trans->fs_info;
>         struct btrfs_block_rsv *delayed_rsv =3D &fs_info->delayed_refs_rs=
v;
> -       struct btrfs_block_rsv *local_rsv =3D &trans->delayed_rsv;
> +       struct btrfs_block_rsv *local_rsv =3D trans->delayed_rsv;
>         u64 num_bytes;
>         u64 reserved_bytes;
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1a4e6a9239ae..1f0f3282e4b8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct bt=
rfs_inode *inode,
>                 goto out;
>         }
>         trans->block_rsv =3D &inode->block_rsv;
> +       trans->delayed_rsv =3D &inode->delayed_rsv;
>
>         drop_args.path =3D path;
>         drop_args.start =3D 0;
> @@ -3256,6 +3257,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_e=
xtent *ordered_extent)
>         }
>
>         trans->block_rsv =3D &inode->block_rsv;
> +       trans->delayed_rsv =3D &inode->delayed_rsv;
>
>         ret =3D btrfs_insert_raid_extent(trans, ordered_extent);
>         if (unlikely(ret)) {
> @@ -8074,9 +8076,12 @@ struct inode *btrfs_alloc_inode(struct super_block=
 *sb)
>
>         spin_lock_init(&ei->lock);
>         ei->outstanding_extents =3D 0;
> -       if (sb->s_magic !=3D BTRFS_TEST_MAGIC)
> +       if (sb->s_magic !=3D BTRFS_TEST_MAGIC) {
>                 btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
>                                               BTRFS_BLOCK_RSV_DELALLOC);
> +               btrfs_init_metadata_block_rsv(fs_info, &ei->delayed_rsv,
> +                                             BTRFS_BLOCK_RSV_DELREFS);
> +       }
>         ei->runtime_flags =3D 0;
>         ei->prop_compress =3D BTRFS_COMPRESS_NONE;
>         ei->defrag_compress =3D BTRFS_COMPRESS_NONE;
> @@ -8132,6 +8137,8 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
>         WARN_ON(vfs_inode->i_data.nrpages);
>         WARN_ON(inode->block_rsv.reserved);
>         WARN_ON(inode->block_rsv.size);
> +       WARN_ON(inode->delayed_rsv.reserved);
> +       WARN_ON(inode->delayed_rsv.size);
>         WARN_ON(inode->outstanding_extents);
>         if (!S_ISDIR(vfs_inode->i_mode)) {
>                 WARN_ON(inode->delalloc_bytes);
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 4358f4b63057..a55f8996cd59 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -737,7 +737,8 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>
>         h->type =3D type;
>         INIT_LIST_HEAD(&h->new_bgs);
> -       btrfs_init_metadata_block_rsv(fs_info, &h->delayed_rsv, BTRFS_BLO=
CK_RSV_DELREFS);
> +       h->delayed_rsv =3D &h->_local_delayed_rsv;
> +       btrfs_init_metadata_block_rsv(fs_info, h->delayed_rsv, BTRFS_BLOC=
K_RSV_DELREFS);
>
>         smp_mb();
>         if (cur_trans->state >=3D TRANS_STATE_COMMIT_START &&
> @@ -758,7 +759,7 @@ start_transaction(struct btrfs_root *root, unsigned i=
nt num_items,
>                                                       h->transid,
>                                                       delayed_refs_bytes,=
 1);
>                         h->delayed_refs_bytes_reserved =3D delayed_refs_b=
ytes;
> -                       btrfs_block_rsv_add_bytes(&h->delayed_rsv, delaye=
d_refs_bytes, true);
> +                       btrfs_block_rsv_add_bytes(h->delayed_rsv, delayed=
_refs_bytes, true);
>                         delayed_refs_bytes =3D 0;
>                 }
>                 h->reloc_reserved =3D reloc_reserved;
> @@ -1067,7 +1068,7 @@ static void btrfs_trans_release_metadata(struct btr=
fs_trans_handle *trans)
>         trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
>                                       trans->transid,
>                                       trans->delayed_refs_bytes_reserved,=
 0);
> -       btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
> +       btrfs_block_rsv_release(fs_info, trans->delayed_rsv,
>                                 trans->delayed_refs_bytes_reserved, NULL)=
;
>         trans->delayed_refs_bytes_reserved =3D 0;
>  }
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..268a415c4f32 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -162,7 +162,8 @@ struct btrfs_trans_handle {
>         bool in_fsync;
>         struct btrfs_fs_info *fs_info;
>         struct list_head new_bgs;
> -       struct btrfs_block_rsv delayed_rsv;
> +       struct btrfs_block_rsv *delayed_rsv;
> +       struct btrfs_block_rsv _local_delayed_rsv;
>         /* Extent buffers with writeback inhibited by this handle. */
>         struct xarray writeback_inhibited_ebs;
>  };
> --
> 2.53.0
>
>
