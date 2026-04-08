Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174C63B0AD4
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775660343; cv=none; b=rkDImyuknECEvuv244LidUHvJIYkcOMbbSAJoSHxE9iidGeWITu94bKkHodo1qb571imaSHLpJoCSByxrAGVw5BpHMf1qv0Ajmtq6OZNT6PX0uEfBlF5iuJGM+jwOQBTADpPh2DkFLs7Pb4+hmZ2CnY8VTFEIeNVanOAPDNFiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775660343; c=relaxed/simple;
	bh=lAzhy1cEKJm1obouUT8VjxoHxu3l9iOeDI5b+RnLLZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TCNC1GgYKM5O7GgkP1657csCEjSda20wKhRlJ8R2kIERsQz5yx16a7v1z2auea2oMTFBMxtKjhgmrSEHLBpCEbKOoaKGx3Vlns3uFjgtw2bw6pw/Ah8+KC9mbbzmFZZ7FJsCV/CcZdE+WyBjS/X/DOxd9Zb8AN0G673oXqXrsFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e62Jz9uo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e62Jz9uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE510C2BC9E
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775660343;
	bh=lAzhy1cEKJm1obouUT8VjxoHxu3l9iOeDI5b+RnLLZU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=e62Jz9uov1Sem0HiOE5YcYUWz6JD2Kh02Qz0XhDqPnlEgwo2DUJllN3jv6kUxZrnK
	 gAAM3WB2C5JtvbcjecbiSDDtlm12p5j4iZfBrOxmcNx1wA60nBOdWvT5V79Em4+zA4
	 dtgnjNY4d4zwa2f6Di9jndOekXAxmGm14WjYW8RDJ8KzN+j1Q7aUCSB6mqA5x9h6d9
	 j8fYv857Ssx3QGZtivAsYlm2VPdGuagqRLhPg3hyyDUBTlPKXiiNc3jfZeSFc+An/c
	 /E403aq2RFY7Qqv0t+eHhluALqAOD/y5lOBNAcyKV9TyHQLIwJ3wrGz4nxM2T48N9P
	 o0ipmn4jwNuBw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b982b0889d8so827158566b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 07:59:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YxxbNMuVJ0hid9S7DESZ4meUVJaprEovMbLQ6P40PmrIk2Q/iYP
	7+rcUdBwAitD89wqkuEDusLihhHdb4kBi+sWmyHmm9qTf69ZnoPM4yzbyN/790PMYNVc2r3m0dz
	WvLg3jnuYcZP9Z76Ydo2DYgoWveDoLJY=
X-Received: by 2002:a17:907:a0cf:b0:b98:36cd:7e14 with SMTP id
 a640c23a62f3a-b9c6793df4bmr1138686266b.42.1775660341269; Wed, 08 Apr 2026
 07:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775589916.git.boris@bur.io> <493ab19a3b664dd63c99ac413d6c6dce555ff43f.1775589916.git.boris@bur.io>
In-Reply-To: <493ab19a3b664dd63c99ac413d6c6dce555ff43f.1775589916.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 8 Apr 2026 15:58:24 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4fFVEjzwJj42ksK-nFwC=SfYS++pkCMwoN6i4ncHQ9og@mail.gmail.com>
X-Gm-Features: AQROBzCfDWYkVZtPCMWU6zjqgRN0iStNIH48mtd6Bv7kib6C841Ln0_VONR9tM0
Message-ID: <CAL3q7H4fFVEjzwJj42ksK-nFwC=SfYS++pkCMwoN6i4ncHQ9og@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] btrfs: account for compression in delalloc extent reservation
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 8:31=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> The btrfs maximum uncompressed extent size is 128MiB. The maximum
> compressed extent size in file extent space is 128KiB. Therefore, the
> estimate for outstanding_extents is off by 3 orders of magnitude when
> COMPRESS_FORCE is set or the inode is set to always compress.
>
> Because we use re-calculation when necessary, rather than super detailed
> extent tracking, we don't grow this reservation as the true number of
> extents is revealed. We don't want to be too clever with it, however, as
> we don't want the calculation to change for a given inode between
> reservation and release, so we only rely on the forcing type flags.
>
> With this change, we no longer under-reserve delayed refs reservations
> for delalloc writes, even with compress-force.
>
> Because this would turn count_max_extents() into a named shim for
> div_u64(size + max_extent_size - 1, max_extent_size);
> we can just get rid of it.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h    |  2 +
>  fs/btrfs/delalloc-space.c | 13 ++++---
>  fs/btrfs/fs.h             | 13 -------
>  fs/btrfs/inode.c          | 78 ++++++++++++++++++++++++++++++++-------
>  4 files changed, 73 insertions(+), 33 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 55c272fe5d92..5368ef87b41a 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -510,6 +510,8 @@ static inline bool btrfs_inode_can_compress(const str=
uct btrfs_inode *inode)
>         return true;
>  }
>
> +u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size);
> +
>  static inline void btrfs_assert_inode_locked(struct btrfs_inode *inode)
>  {
>         /* Immediately trigger a crash if the inode is not locked. */
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index c99f516ce8af..9ff02a7da05b 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -7,6 +7,7 @@
>  #include "delayed-ref.h"
>  #include "block-rsv.h"
>  #include "btrfs_inode.h"
> +#include "compression.h"

No need for this include. We're not using anything from compression.{h,c}.

With that removed:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

>  #include "space-info.h"
>  #include "qgroup.h"
>  #include "fs.h"
> @@ -66,7 +67,7 @@
>   *     This is the number of file extent items we'll need to handle all =
of the
>   *     outstanding DELALLOC space we have in this inode.  We limit the m=
aximum
>   *     size of an extent, so a large contiguous dirty area may require m=
ore than
> - *     one outstanding_extent, which is why count_max_extents() is used =
to
> + *     one outstanding_extent, which is why we use the max extent size t=
o
>   *     determine how many outstanding_extents get added.
>   *
>   *   ->csum_bytes
> @@ -328,7 +329,7 @@ static void calc_inode_reservations(struct btrfs_inod=
e *inode,
>                                     u64 *meta_reserve, u64 *qgroup_reserv=
e)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       u64 nr_extents =3D count_max_extents(fs_info, num_bytes);
> +       u64 nr_extents =3D btrfs_inode_max_extents(inode, num_bytes);
>         u64 csum_leaves;
>         u64 inode_update =3D btrfs_calc_metadata_size(fs_info, 1);
>
> @@ -427,7 +428,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>          * racing with an ordered completion or some such that would thin=
k it
>          * needs to free the reservation we just made.
>          */
> -       nr_extents =3D count_max_extents(fs_info, num_bytes);
> +       nr_extents =3D btrfs_inode_max_extents(inode, num_bytes);
>         spin_lock(&inode->lock);
>         btrfs_mod_outstanding_extents(inode, nr_extents);
>         if (!(inode->flags & BTRFS_INODE_NODATASUM))
> @@ -494,7 +495,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inod=
e *inode, u64 num_bytes)
>         unsigned num_extents;
>
>         spin_lock(&inode->lock);
> -       num_extents =3D count_max_extents(fs_info, num_bytes);
> +       num_extents =3D btrfs_inode_max_extents(inode, num_bytes);
>         btrfs_mod_outstanding_extents(inode, -num_extents);
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>         spin_unlock(&inode->lock);
> @@ -509,8 +510,8 @@ void btrfs_delalloc_release_extents(struct btrfs_inod=
e *inode, u64 num_bytes)
>  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserv=
ed_len, u64 new_len)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       const u32 reserved_num_extents =3D count_max_extents(fs_info, res=
erved_len);
> -       const u32 new_num_extents =3D count_max_extents(fs_info, new_len)=
;
> +       const u32 reserved_num_extents =3D btrfs_inode_max_extents(inode,=
 reserved_len);
> +       const u32 new_num_extents =3D btrfs_inode_max_extents(inode, new_=
len);
>         const int diff_num_extents =3D new_num_extents - reserved_num_ext=
ents;
>
>         ASSERT(new_len <=3D reserved_len);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index a4758d94b32e..2c1626155645 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -1051,19 +1051,6 @@ static inline bool btrfs_is_zoned(const struct btr=
fs_fs_info *fs_info)
>         return IS_ENABLED(CONFIG_BLK_DEV_ZONED) && fs_info->zone_size > 0=
;
>  }
>
> -/*
> - * Count how many fs_info->max_extent_size cover the @size
> - */
> -static inline u32 count_max_extents(const struct btrfs_fs_info *fs_info,=
 u64 size)
> -{
> -#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> -       if (!fs_info)
> -               return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MA=
X_EXTENT_SIZE);
> -#endif
> -
> -       return div_u64(size + fs_info->max_extent_size - 1, fs_info->max_=
extent_size);
> -}
> -
>  static inline unsigned int btrfs_blocks_per_folio(const struct btrfs_fs_=
info *fs_info,
>                                                   const struct folio *fol=
io)
>  {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 15945744a304..55255f3794c6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -747,6 +747,56 @@ static int add_async_extent(struct async_chunk *cow,=
 u64 start, u64 ram_size,
>         return 0;
>  }
>
> +/*
> + * Check if compression will definitely be attempted for this inode base=
d on
> + * mount options and inode properties.  Unlike inode_need_compress(), th=
is does
> + * NOT run the compression heuristic or check range-specific conditions,=
 so it
> + * is safe to call under locks (e.g. io_tree lock) and for reservation s=
izing.
> + *
> + * Only returns true for cases where BTRFS_INODE_NOCOMPRESS cannot be se=
t at
> + * runtime (FORCE_COMPRESS and prop_compress), ensuring that the effecti=
ve max
> + * extent size is stable across paired set/clear delalloc operations.
> + */
> +static inline bool inode_may_compress(const struct btrfs_inode *inode)
> +{
> +       if (!btrfs_inode_can_compress(inode))
> +               return false;
> +
> +       /* Force compress always attempts compression. */
> +       if (btrfs_test_opt(inode->root->fs_info, FORCE_COMPRESS))
> +               return true;
> +
> +       /* Per-inode property: NOCOMPRESS cannot override this. */
> +       if (inode->prop_compress)
> +               return true;
> +
> +       return false;
> +}
> +
> +/*
> + * Return the effective maximum extent size for reservation accounting.
> + *
> + * When compression is guaranteed to be attempted (FORCE_COMPRESS or
> + * prop_compress), the compression path splits ranges into
> + * BTRFS_MAX_UNCOMPRESSED chunks, each producing an independent ordered
> + * extent.  Use that as the divisor instead of fs_info->max_extent_size
> + * to avoid severely undercounting outstanding extents.
> + */
> +static u64 btrfs_inode_max_extent_size(const struct btrfs_inode *inode)
> +{
> +       if (inode_may_compress(inode))
> +               return BTRFS_MAX_UNCOMPRESSED;
> +
> +       return inode->root->fs_info->max_extent_size;
> +}
> +
> +u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size)
> +{
> +       u64 max_extent_size =3D btrfs_inode_max_extent_size(inode);
> +
> +       return div_u64(size + max_extent_size - 1, max_extent_size);
> +}
> +
>  /*
>   * Check if the inode needs to be submitted to compression, based on mou=
nt
>   * options, defragmentation, properties or heuristics.
> @@ -2459,8 +2509,8 @@ int btrfs_run_delalloc_range(struct btrfs_inode *in=
ode, struct folio *locked_fol
>  void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
>                                  struct extent_state *orig, u64 split)
>  {
> -       struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 size;
> +       u64 max_extent_size =3D btrfs_inode_max_extent_size(inode);
>
>         lockdep_assert_held(&inode->io_tree.lock);
>
> @@ -2469,8 +2519,8 @@ void btrfs_split_delalloc_extent(struct btrfs_inode=
 *inode,
>                 return;
>
>         size =3D orig->end - orig->start + 1;
> -       if (size > fs_info->max_extent_size) {
> -               u32 num_extents;
> +       if (size > max_extent_size) {
> +               u64 num_extents;
>                 u64 new_size;
>
>                 /*
> @@ -2478,10 +2528,10 @@ void btrfs_split_delalloc_extent(struct btrfs_ino=
de *inode,
>                  * applies here, just in reverse.
>                  */
>                 new_size =3D orig->end - split + 1;
> -               num_extents =3D count_max_extents(fs_info, new_size);
> +               num_extents =3D btrfs_inode_max_extents(inode, new_size);
>                 new_size =3D split - orig->start;
> -               num_extents +=3D count_max_extents(fs_info, new_size);
> -               if (count_max_extents(fs_info, size) >=3D num_extents)
> +               num_extents +=3D btrfs_inode_max_extents(inode, new_size)=
;
> +               if (btrfs_inode_max_extents(inode, size) >=3D num_extents=
)
>                         return;
>         }
>
> @@ -2498,9 +2548,9 @@ void btrfs_split_delalloc_extent(struct btrfs_inode=
 *inode,
>  void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct exten=
t_state *new,
>                                  struct extent_state *other)
>  {
> -       struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 new_size, old_size;
> -       u32 num_extents;
> +       u64 max_extent_size =3D btrfs_inode_max_extent_size(inode);
> +       u64 num_extents;
>
>         lockdep_assert_held(&inode->io_tree.lock);
>
> @@ -2514,7 +2564,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state
>                 new_size =3D other->end - new->start + 1;
>
>         /* we're not bigger than the max, unreserve the space and go */
> -       if (new_size <=3D fs_info->max_extent_size) {
> +       if (new_size <=3D max_extent_size) {
>                 spin_lock(&inode->lock);
>                 btrfs_mod_outstanding_extents(inode, -1);
>                 spin_unlock(&inode->lock);
> @@ -2540,10 +2590,10 @@ void btrfs_merge_delalloc_extent(struct btrfs_ino=
de *inode, struct extent_state
>          * this case.
>          */
>         old_size =3D other->end - other->start + 1;
> -       num_extents =3D count_max_extents(fs_info, old_size);
> +       num_extents =3D btrfs_inode_max_extents(inode, old_size);
>         old_size =3D new->end - new->start + 1;
> -       num_extents +=3D count_max_extents(fs_info, old_size);
> -       if (count_max_extents(fs_info, new_size) >=3D num_extents)
> +       num_extents +=3D btrfs_inode_max_extents(inode, old_size);
> +       if (btrfs_inode_max_extents(inode, new_size) >=3D num_extents)
>                 return;
>
>         spin_lock(&inode->lock);
> @@ -2616,7 +2666,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *=
inode, struct extent_state *s
>         if (!(state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)=
) {
>                 u64 len =3D state->end + 1 - state->start;
>                 u64 prev_delalloc_bytes;
> -               u32 num_extents =3D count_max_extents(fs_info, len);
> +               u32 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>                 spin_lock(&inode->lock);
>                 btrfs_mod_outstanding_extents(inode, num_extents);
> @@ -2662,7 +2712,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode=
 *inode,
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 len =3D state->end + 1 - state->start;
> -       u32 num_extents =3D count_max_extents(fs_info, len);
> +       u32 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>         lockdep_assert_held(&inode->io_tree.lock);
>
> --
> 2.53.0
>
>
