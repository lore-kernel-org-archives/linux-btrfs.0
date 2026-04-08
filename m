Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC053D525F
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775660700; cv=none; b=WVIuHiKRLMVRe/eBZGoxjT6BR0jEE+Nwq0cR9HT3p7mAL9/1q1/J8K+qrZnVyF6djSWnEtTKrLmD4XFdg4e8FPuyUFreDZWrsb0ZabBbzNvvm7/QuRhRfKntNgX1rE+uAu3pndrHWUFeKam/b21/+FpvDuUucocAD+ik+VN0n0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775660700; c=relaxed/simple;
	bh=RY2lrVtYoRPuwgz5QBMlQCv6t7d1G8DysMbUQezDoJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vdr57ypcWmRibA12Xk1tD/ZfcDimU8vJC95ZXkXEom2W/J45V0qFXjvG/SgNV7K3Oc2VzNFTTKNLVcROKXt+9FLeQKi+Rw8+ujfzb9sSWXwy3O5clwKWcaJGzBtzw8x6GahzrCgirkKXTrOO9DRtl3F+9903NBmLN30ZKeyLF5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIDqiFTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIDqiFTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A26C19424
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775660699;
	bh=RY2lrVtYoRPuwgz5QBMlQCv6t7d1G8DysMbUQezDoJE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dIDqiFTFvySaaj2xLOPB+0WxNJ7wB1zqh6yoPuC5KaANaELUyn7VIjt4biBNv23n2
	 8l/YH/5ExFDVLEtuQKoG4437X9muNiO5l7wGE8lfLcMYWbJ5ykirVopYQc8bYWfI7y
	 NgQSM/+EgOU13g54RIcU7IrjVfU5JG/Luw9fzkmeesnYYwGqs82R92L2A/GmeGkWGT
	 Hi0s1KF7R2TlrDqXVf37C1MXSxsOBSvJksrVMpIetdroDFkhyBAdWTA0TBoimimH/h
	 txcafFgBc3sPmeHLnY5onyrWqsu9HC+a76SThGksFgEhq5YHM+Gu0c5JgrgbhfE/sR
	 5OS2wWZ3kKkBg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so1012344766b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 08:04:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YwWB36fw79VoN+Sh8M6ePRIVOPLCvUIMYxTkPNJDEJvYP/sIkR6
	SIBcM6D3WPPbPvURpshqDxP+PF9eIks+O9CwBhWn4WpvdM+yE1XeuwIc87lJqnn9f6pSH/j1TCQ
	xWMrKmwYg/ybLZBsM9J8TJDTjZZbe+E0=
X-Received: by 2002:a17:907:c92a:b0:b9b:207c:f7ba with SMTP id
 a640c23a62f3a-b9c67431325mr766702366b.4.1775660698014; Wed, 08 Apr 2026
 08:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775589916.git.boris@bur.io> <8df7bdc59dfd2b9d7af31708a5d6e93251581d20.1775589916.git.boris@bur.io>
In-Reply-To: <8df7bdc59dfd2b9d7af31708a5d6e93251581d20.1775589916.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 8 Apr 2026 16:04:20 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6pMX7gzKbBfk89fG3hL40KrabmNsXnosS7Zia3M_3xbg@mail.gmail.com>
X-Gm-Features: AQROBzAEI11IZb3NYh0FRm4FMbxlwoQLpgpdn_AnYt7JAJ7iaby8EgAG12nBt8g
Message-ID: <CAL3q7H6pMX7gzKbBfk89fG3hL40KrabmNsXnosS7Zia3M_3xbg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] btrfs: make inode->outstanding_extents a u64
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 8:31=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> The maximum file size is MAX_LFS_FILESIZE =3D (loff_t)LLONG_MAX
>
> As a result, the max extent size computation in btrfs has always been
> bounded above by LLONG_MAX / 128MiB, which is ~ 2^63 / 2^27. This has
> never fit in a u32. With the recent changes to also divide by 128KiB in
> compressed cases, that bound is even higher. Whether or not it is likely
> to happen, I think it is nice to try to capture the intent in the types,
> so change outstanding_extents to u64, and make mod_outstanding_extents
> try to capture some expectations around the size of its inputs.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/btrfs_inode.h       | 18 ++++++++++++++----
>  fs/btrfs/delalloc-space.c    | 19 +++++++++----------
>  fs/btrfs/inode.c             | 14 +++++++-------
>  fs/btrfs/ordered-data.c      |  4 ++--
>  fs/btrfs/tests/inode-tests.c | 18 +++++++++---------
>  include/trace/events/btrfs.h |  8 ++++----
>  6 files changed, 45 insertions(+), 36 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 5368ef87b41a..04825b28f384 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -180,7 +180,7 @@ struct btrfs_inode {
>          * items we think we'll end up using, and reserved_extents is the=
 number
>          * of extent items we've reserved metadata for. Protected by 'loc=
k'.
>          */
> -       unsigned outstanding_extents;
> +       u64 outstanding_extents;
>
>         /* used to order data wrt metadata */
>         spinlock_t ordered_tree_lock;
> @@ -429,14 +429,24 @@ static inline bool is_data_inode(const struct btrfs=
_inode *inode)
>  }
>
>  static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *ino=
de,
> -                                                int mod)
> +                                                int mod, u64 nr_extents)
>  {
> +       s64 delta =3D mod * (s64)nr_extents;
> +
>         lockdep_assert_held(&inode->lock);
> -       inode->outstanding_extents +=3D mod;
> +       ASSERT(mod =3D=3D 1 || mod =3D=3D -1, "mod=3D%d", mod);
> +       ASSERT(nr_extents <=3D S64_MAX, "nr_extents=3D%llu", nr_extents);
> +       ASSERT(mod =3D=3D -1 || inode->outstanding_extents <=3D U64_MAX -=
 nr_extents,
> +              "nr_extents=3D%llu, inode->outstanding_extents=3D%llu",
> +              nr_extents, inode->outstanding_extents);
> +       ASSERT(mod =3D=3D 1 || inode->outstanding_extents >=3D nr_extents=
,
> +              "mod=3D%d, nr_extents=3D%llu, inode->outstanding_extents=
=3D%llu",

I don't think there is a need to print mod here, if the assertion
failed, we know it must be -1.
In the previous assertion, we don't print mod, which makes sense since
it must be 1 if it fails.

With that change:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +              mod, nr_extents, inode->outstanding_extents);
> +       inode->outstanding_extents +=3D delta;
>         if (btrfs_is_free_space_inode(inode))
>                 return;
>         trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(=
inode),
> -                                                 mod, inode->outstanding=
_extents);
> +                                                 delta, inode->outstandi=
ng_extents);
>  }
>
>  /*
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 9ff02a7da05b..d50081c8089a 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -289,7 +289,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>         u64 reserve_size =3D 0;
>         u64 qgroup_rsv_size =3D 0;
> -       unsigned outstanding_extents;
> +       u64 outstanding_extents;
>
>         lockdep_assert_held(&inode->lock);
>         outstanding_extents =3D inode->outstanding_extents;
> @@ -316,7 +316,7 @@ static void btrfs_calculate_inode_block_rsv_size(stru=
ct btrfs_fs_info *fs_info,
>          *
>          * This is overestimating in most cases.
>          */
> -       qgroup_rsv_size =3D (u64)outstanding_extents * fs_info->nodesize;
> +       qgroup_rsv_size =3D outstanding_extents * fs_info->nodesize;
>
>         spin_lock(&block_rsv->lock);
>         block_rsv->size =3D reserve_size;
> @@ -376,7 +376,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         struct btrfs_block_rsv *block_rsv =3D &inode->block_rsv;
>         u64 meta_reserve, qgroup_reserve;
> -       unsigned nr_extents;
> +       u64 nr_extents;
>         enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_ALL;
>         int ret =3D 0;
>
> @@ -430,7 +430,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inod=
e *inode, u64 num_bytes,
>          */
>         nr_extents =3D btrfs_inode_max_extents(inode, num_bytes);
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, nr_extents);
> +       btrfs_mod_outstanding_extents(inode, 1, nr_extents);
>         if (!(inode->flags & BTRFS_INODE_NODATASUM))
>                 inode->csum_bytes +=3D disk_num_bytes;
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
> @@ -492,11 +492,11 @@ void btrfs_delalloc_release_metadata(struct btrfs_i=
node *inode, u64 num_bytes,
>  void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_b=
ytes)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       unsigned num_extents;
> +       u64 num_extents;
>
>         spin_lock(&inode->lock);
>         num_extents =3D btrfs_inode_max_extents(inode, num_bytes);
> -       btrfs_mod_outstanding_extents(inode, -num_extents);
> +       btrfs_mod_outstanding_extents(inode, -1, num_extents);
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>         spin_unlock(&inode->lock);
>
> @@ -510,16 +510,15 @@ void btrfs_delalloc_release_extents(struct btrfs_in=
ode *inode, u64 num_bytes)
>  void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserv=
ed_len, u64 new_len)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> -       const u32 reserved_num_extents =3D btrfs_inode_max_extents(inode,=
 reserved_len);
> -       const u32 new_num_extents =3D btrfs_inode_max_extents(inode, new_=
len);
> -       const int diff_num_extents =3D new_num_extents - reserved_num_ext=
ents;
> +       const u64 reserved_num_extents =3D btrfs_inode_max_extents(inode,=
 reserved_len);
> +       const u64 new_num_extents =3D btrfs_inode_max_extents(inode, new_=
len);
>
>         ASSERT(new_len <=3D reserved_len);
>         if (new_num_extents =3D=3D reserved_num_extents)
>                 return;
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, diff_num_extents);
> +       btrfs_mod_outstanding_extents(inode, -1, reserved_num_extents - n=
ew_num_extents);
>         btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>         spin_unlock(&inode->lock);
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 55255f3794c6..b45a92cfe94e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2536,7 +2536,7 @@ void btrfs_split_delalloc_extent(struct btrfs_inode=
 *inode,
>         }
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, 1);
> +       btrfs_mod_outstanding_extents(inode, 1, 1);
>         spin_unlock(&inode->lock);
>  }
>
> @@ -2566,7 +2566,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state
>         /* we're not bigger than the max, unreserve the space and go */
>         if (new_size <=3D max_extent_size) {
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, -1);
> +               btrfs_mod_outstanding_extents(inode, -1, 1);
>                 spin_unlock(&inode->lock);
>                 return;
>         }
> @@ -2597,7 +2597,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state
>                 return;
>
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, -1);
> +       btrfs_mod_outstanding_extents(inode, -1, 1);
>         spin_unlock(&inode->lock);
>  }
>
> @@ -2666,10 +2666,10 @@ void btrfs_set_delalloc_extent(struct btrfs_inode=
 *inode, struct extent_state *s
>         if (!(state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)=
) {
>                 u64 len =3D state->end + 1 - state->start;
>                 u64 prev_delalloc_bytes;
> -               u32 num_extents =3D btrfs_inode_max_extents(inode, len);
> +               u64 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, num_extents);
> +               btrfs_mod_outstanding_extents(inode, 1, num_extents);
>                 spin_unlock(&inode->lock);
>
>                 /* For sanity tests */
> @@ -2712,7 +2712,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode=
 *inode,
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>         u64 len =3D state->end + 1 - state->start;
> -       u32 num_extents =3D btrfs_inode_max_extents(inode, len);
> +       u64 num_extents =3D btrfs_inode_max_extents(inode, len);
>
>         lockdep_assert_held(&inode->io_tree.lock);
>
> @@ -2732,7 +2732,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode=
 *inode,
>                 u64 new_delalloc_bytes;
>
>                 spin_lock(&inode->lock);
> -               btrfs_mod_outstanding_extents(inode, -num_extents);
> +               btrfs_mod_outstanding_extents(inode, -1, num_extents);
>                 spin_unlock(&inode->lock);
>
>                 /*
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index e5a24b3ff95e..96ee8ebfdb92 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -223,7 +223,7 @@ static struct btrfs_ordered_extent *alloc_ordered_ext=
ent(
>          * smallest the extent is going to get.
>          */
>         spin_lock(&inode->lock);
> -       btrfs_mod_outstanding_extents(inode, 1);
> +       btrfs_mod_outstanding_extents(inode, 1, 1);
>         spin_unlock(&inode->lock);
>
>  out:
> @@ -655,7 +655,7 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered=
_extent *entry)
>         btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
>         /* This is paired with alloc_ordered_extent(). */
>         spin_lock(&btrfs_inode->lock);
> -       btrfs_mod_outstanding_extents(btrfs_inode, -1);
> +       btrfs_mod_outstanding_extents(btrfs_inode, -1, 1);
>         spin_unlock(&btrfs_inode->lock);
>         if (root !=3D fs_info->tree_root) {
>                 u64 release;
> diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
> index b04fbcaf0a1d..e63afbb9be2b 100644
> --- a/fs/btrfs/tests/inode-tests.c
> +++ b/fs/btrfs/tests/inode-tests.c
> @@ -931,7 +931,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 1) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 1, got %u",
> +               test_err("miscount, wanted 1, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -946,7 +946,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -962,7 +962,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -978,7 +978,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 2) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 2, got %u",
> +               test_err("miscount, wanted 2, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -996,7 +996,7 @@ static int test_extent_accounting(u32 sectorsize, u32=
 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 4) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 4, got %u",
> +               test_err("miscount, wanted 4, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1013,7 +1013,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 3) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 3, got %u",
> +               test_err("miscount, wanted 3, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1029,7 +1029,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 4) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 4, got %u",
> +               test_err("miscount, wanted 4, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1047,7 +1047,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents !=3D 3) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 3, got %u",
> +               test_err("miscount, wanted 3, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> @@ -1061,7 +1061,7 @@ static int test_extent_accounting(u32 sectorsize, u=
32 nodesize)
>         }
>         if (BTRFS_I(inode)->outstanding_extents) {
>                 ret =3D -EINVAL;
> -               test_err("miscount, wanted 0, got %u",
> +               test_err("miscount, wanted 0, got %llu",
>                          BTRFS_I(inode)->outstanding_extents);
>                 goto out;
>         }
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 8ad7a2d76c1d..caabdc8d9eed 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -2003,15 +2003,15 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_=
insert,
>  );
>
>  TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
> -       TP_PROTO(const struct btrfs_root *root, u64 ino, int mod, unsigne=
d outstanding),
> +       TP_PROTO(const struct btrfs_root *root, u64 ino, s64 mod, u64 out=
standing),
>
>         TP_ARGS(root, ino, mod, outstanding),
>
>         TP_STRUCT__entry_btrfs(
>                 __field(        u64, root_objectid      )
>                 __field(        u64, ino                )
> -               __field(        int, mod                )
> -               __field(        unsigned, outstanding   )
> +               __field(        s64, mod                )
> +               __field(        u64, outstanding        )
>         ),
>
>         TP_fast_assign_btrfs(root->fs_info,
> @@ -2021,7 +2021,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
>                 __entry->outstanding    =3D outstanding;
>         ),
>
> -       TP_printk_btrfs("root=3D%llu(%s) ino=3D%llu mod=3D%d outstanding=
=3D%u",
> +       TP_printk_btrfs("root=3D%llu(%s) ino=3D%llu mod=3D%lld outstandin=
g=3D%llu",
>                         show_root_type(__entry->root_objectid),
>                         __entry->ino, __entry->mod, __entry->outstanding)
>  );
> --
> 2.53.0
>
>
