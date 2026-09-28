Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4561449EC59
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 10:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790593120; cv=none; b=V+9ayBtXmSd0UUKLTv9aB4+I7lo3LmOxshp/Be/oJ8r8FbIIZnzu+fZRvZr9Qxu6T2wdFnwnnJDAGBa9Tc8GZJkUxhP9ezD5yP3YrxCwljLRVNLkw1In5r8Mdm9GOvH33vUmQS1LB/43yZiPEYBXz1qx3aNZErqv4fixCpSlhgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790593120; c=relaxed/simple;
	bh=BthTW5KQIjLMPHao1dH/zmTu5LDG0oFW0pguXxiI0iE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j8BNafL8+++66to3qZvQ8RLneGoGQ2iLmHVacF39DWeReED40223oMfZn3zAk9ErpdsSc7OZp8O3VCDdd2pjXCXiLEF43P0HHFnvhCCISY+lhYvEc+0p247pzo4O9ewaHPxCyCU2YrYj64eDixCA8DopTbCSfsYbv3oRBdCm8s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rjz48du8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rjz48du8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664CD1F00893
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 10:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790593117;
	bh=ZgsGffqHFoF/JJNE6HZhXGK4N6Y3CzUEAKM2IYgCnu8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Rjz48du84nMbIkJG8jd3Ns6kmjU0ORkQi06yXKATXbApRZhlf42k29bySyU81u5x/
	 69vCsa0Ut4Chyezj9LKt5xC11CB/h5xsnFieO1cJYB5EwQ09Wz31Iap6B9dUXmRiwm
	 IUC+6bGxwmhlKO9eOBt5ik97TvlOodWX7ErV5vxwcs3wbwlj03dtw5/M8T4X4Lq8Xi
	 fFKaBFfj1tmx9XRgQ4Xz3o+elfr6j4UGHAx+FGVBMq4mvyajYEu+RxhLUpGXljniC3
	 dt8Xblh3MyBhoMo2UjLyv/OlHAjyIphtEjcP7gPVue9czU7nOr+mxoNwzIDyU8aynA
	 k9kXMWGGF0WIA==
Received: by mail-ua2-f43.google.com with SMTP id a1e0cc1a2514c-98531196e20so1679313241.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 03:58:37 -0700 (PDT)
X-Gm-Message-State: AFq9FYK6MssDCAVAx5m247EJliWG7Nm+rR9XuFqvoFLWR1LBgEOetILY
	1a86pltvINoM9tc+h2lQY3PITriwSPD8EMTUxy1Vr7Kwr74lK1+s6YNDrbUDwGG2aJFzh56jH/4
	v7HKjg4uv6wEFTaxk2scvmXeaVOR2i/g=
X-Received: by 2002:a05:6102:4412:b0:7a7:198a:c2b7 with SMTP id
 ada2fe7eead31-7af1dddf3b3mr4818059137.31.1790593116626; Mon, 28 Sep 2026
 03:58:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790095812.git.boris@bur.io> <c68f903b219f964552a86fe969011cf819ef470d.1790095812.git.boris@bur.io>
In-Reply-To: <c68f903b219f964552a86fe969011cf819ef470d.1790095812.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 28 Sep 2026 11:58:00 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6rt2HxM59bAGM1ao2tOUYcEWCTdxAT9_MWBXfJEyrf-g@mail.gmail.com>
X-Gm-Features: AclHuK9GaHJy1A9Q4DoLFBN-iPG7DP9Fy6cQeS09O5JqvzObYvxFOPOgqs38Spg
Message-ID: <CAL3q7H6rt2HxM59bAGM1ao2tOUYcEWCTdxAT9_MWBXfJEyrf-g@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: allocate additional SYSTEM space earlier
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 5:57=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> Currently, reserve_chunk_space() allocates a new system chunk when the
> space left is smaller than the reservation for a single chunk tree
> update.
>
> Therefore, a filesystem in single metadata mode on a very large block
> device can accumulate tens of thousands (TB) of chunks while never
> allocating more than the original 4MiB SYSTEM block group created by
> mkfs. If it then fills up (with large fallocates for example) and then
> that data is freed, en-masse, we end up trying to delete thousands of
> block groups in a single transaction in btrfs_delete_unused_bgs().
>
> This process touches most of the nodes and leaves of the chunk tree,
> essentially trying to allocate roughly double the current usage of the
> chunk tree for cow. When this runs into needing a fresh system chunk,
> the fs is full of the empty bgs and we abort with ENOSPC in
> btrfs_remove_chunk() like:
>
>   BTRFS error (device loop0 state A): Transaction 30733 aborted (-ENOSPC)
>   space_info SYSTEM (sub-group id 0) has 0 free, is not full
>   space_info total=3D4194304, used=3D3276800, pinned=3D0, reserved=3D9175=
04, may_use=3D0, readonly=3D0 zone_unusable=3D0
>   BTRFS: error (device loop0 state A) in btrfs_remove_chunk:3643: errno=
=3D-28 No space left
>
> This was seen on a 30TiB production filesystem with 10TiB of unused
> block groups and reproduces on a 30TiB sparse loop device: mkfs with
> -m single, fallocate 1GiB files until ENOSPC, delete two of every three
> adjacent files, sync.
>
> To fix this, we should allocate the (relatively tiny) system chunks a
> little bit more eagerly. If we do it when it is half full, we ensure we
> can delete all of the block groups in one go. To fill up half of a 4MiB
> system bg requires thousands of block_groups so this should only affect
> very large fileystems.
>
> Assisted-by: LLM
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/block-group.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 2eb09c9901c9..cf26dbeaabdb 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1574,6 +1574,19 @@ static bool btrfs_link_bg_list(struct btrfs_block_=
group *bg, struct list_head *l
>         return added;
>  }
>
> +/*
> + * Compute an upper bound on the bytes needed to modify every leaf in th=
e chunk
> + * tree. Normally, we could just allocate a new system chunk then, but t=
hat can
> + * fail if there is no free space for a new dev extent. This can happen =
when
> + * we fill up a large filesystem then rapidly delete a large portion of =
it.
> + */
> +static u64 system_space_needed(struct btrfs_space_info *sinfo)
> +{
> +       lockdep_assert_held(&sinfo->lock);
> +
> +       return btrfs_space_info_used(sinfo, true) + sinfo->bytes_used;
> +}
> +
>  /*
>   * Process the unused_bgs list and remove any that don't have any alloca=
ted
>   * space inside of them.
> @@ -1661,6 +1674,9 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *=
fs_info)
>                 if (btrfs_is_block_group_used(block_group) ||
>                     (block_group->ro && !(block_group->flags & BTRFS_BLOC=
K_GROUP_REMAPPED)) ||
>                     list_is_singular(&block_group->list) ||
> +                   ((block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
> +                    space_info->total_bytes - block_group->length <
> +                    system_space_needed(space_info)) ||
>                     test_bit(BLOCK_GROUP_FLAG_FULLY_REMAPPED, &block_grou=
p->runtime_flags)) {
>                         /*
>                          * We want to bail if we made new allocations or =
have
> @@ -1674,6 +1690,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info =
*fs_info)
>                          * next block group of this type would be created=
 with a
>                          * "single" profile (even if we're in a raid fs) =
because
>                          * fs_info->avail_*_alloc_bits would be 0.
> +                        *
> +                        * Also bail out if this is a system block group =
that
> +                        * system_space_needed() relies on to ensure head=
 room for
> +                        * mass deletion.
>                          */
>                         trace_btrfs_skip_unused_block_group(block_group);
>                         spin_unlock(&block_group->lock);
> @@ -4509,6 +4529,7 @@ static void reserve_chunk_space(struct btrfs_trans_=
handle *trans,
>         struct btrfs_fs_info *fs_info =3D trans->fs_info;
>         struct btrfs_space_info *info;
>         u64 left;
> +       bool low;
>         int ret =3D 0;
>
>         /*
> @@ -4520,6 +4541,7 @@ static void reserve_chunk_space(struct btrfs_trans_=
handle *trans,
>         info =3D btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM)=
;
>         spin_lock(&info->lock);
>         left =3D info->total_bytes - btrfs_space_info_used(info, true);
> +       low =3D left < bytes || info->total_bytes < system_space_needed(i=
nfo);
>         spin_unlock(&info->lock);
>
>         if (left < bytes && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
> @@ -4528,7 +4550,7 @@ static void reserve_chunk_space(struct btrfs_trans_=
handle *trans,
>                 btrfs_dump_space_info(info, 0, false);
>         }
>
> -       if (left < bytes) {
> +       if (low) {
>                 u64 flags =3D btrfs_system_alloc_profile(fs_info);
>                 struct btrfs_block_group *bg;
>                 struct btrfs_space_info *space_info;
> @@ -4572,7 +4594,7 @@ static void reserve_chunk_space(struct btrfs_trans_=
handle *trans,
>                 }
>         }
>
> -       if (!ret) {
> +       if (!ret || left >=3D bytes) {

So this hunk I have trouble understanding it, because if left >=3D bytes
should always be true at this point, as if if left < bytes we have
allocated a system chunk (if we haven't then ret has an error value).

Otherwise it looks good (as well as the second patch).

Thanks.

>                 ret =3D btrfs_block_rsv_add(fs_info,
>                                           &fs_info->chunk_block_rsv,
>                                           bytes, BTRFS_RESERVE_NO_FLUSH);
> --
> 2.55.0
>
>
