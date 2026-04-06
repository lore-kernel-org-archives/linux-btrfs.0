Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3428E38F935
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775496827; cv=none; b=tIfYb2OYpZpBxqonz2g0y/X3+SzO73bJtJGxbjs6uL1ylp9bRYYq6+nh7se1Vf7xQkaJ+iBBXiMZt2A1IsYyGN8OE+zh3S1lWoItH6SHdYPurrdANIvpHMjN0a5GZOGeDOPd2n/s0cJtg7KyejAAtg1QrdqQWj3VBR/Sm51PFaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775496827; c=relaxed/simple;
	bh=wHLdEnRTws0gUNwTzctbGoUql6GJc4GnbGUszW5QEvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=isY6jiTbnpDevR6INCNd4oyb17RQsvn38Plgd13EDRTj9NvTygeo4oz8dyD08Ib4IwmLvzodhxzm2MEdv+S1uaGfmrkF6jCHi4O+E21801kPR/GlVVYsjEBlO18qgoNGuCPxVaURTqz2dJPmyxqqqiI30SNU9qfR3Yf0vz6VG9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7l0V3u9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7l0V3u9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ABCC4CEF7
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775496826;
	bh=wHLdEnRTws0gUNwTzctbGoUql6GJc4GnbGUszW5QEvk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=f7l0V3u9TrpZHX9dtU7yJUYlGH2A1ygJA8W8p6y2mlvF9/S7ds2+Ae3QKA4kQIvnf
	 g76Z/rmGCnGKsvJHQ1JcGo+zb4bvHc7fkqug2DQnTnlk0rNhwF8Hy5zgl5uM7H2fn8
	 zCjSbShZ9JDqFoyiEEQukTICufQAO4l6G5/Bb3jEJSMEgdaoCI381urDjpdU9Z+eOc
	 sq8zJMfCpxanbrqiibgrl43D3AG7GKvN78LnSQgbkNeiKJlca5vrNpYbMEVuiDPhcC
	 4PMrA74H+br6s7IHcv7G0L61C9LRkBpa5YrOjVsUHiIgmIh6IHa+SQ/O36vVbPGGEU
	 SFF30FAx85qdg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b97f9587e6eso553692166b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 10:33:46 -0700 (PDT)
X-Gm-Message-State: AOJu0YwnI0PeW7r1LSLgKmTETtE8uGEsC5ZM6ayDvpRKZZ8WfRWKKjLK
	QQOdomUtbdT6nWVM4TdBQqXLsq912dqpqlvujPeBwQ++3Ha9RamQXZUFu/6tt56ZCbCJGFlkagK
	OvPwa23UciwuQoSvyUqoHKhQgi+zlH5w=
X-Received: by 2002:a17:907:a44:b0:b9b:308f:d9ad with SMTP id
 a640c23a62f3a-b9c6768c97bmr610269066b.19.1775496825151; Mon, 06 Apr 2026
 10:33:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775255085.git.boris@bur.io> <c419f42eff7561e0a015bc6f5c7b6cc7c683ab0b.1775255085.git.boris@bur.io>
In-Reply-To: <c419f42eff7561e0a015bc6f5c7b6cc7c683ab0b.1775255085.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Apr 2026 18:33:08 +0100
X-Gmail-Original-Message-ID: <CAL3q7H53Bd_UW7LO5VLd2-ZcA4tRWyBPs9DyS6VeUP182Yip+g@mail.gmail.com>
X-Gm-Features: AQROBzCK3vOZPx6r2zy71jlgx66dH8i1hpgCKDmNNbyXpdgi7NnBKI2I-gLF25c
Message-ID: <CAL3q7H53Bd_UW7LO5VLd2-ZcA4tRWyBPs9DyS6VeUP182Yip+g@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] btrfs: account for csum delayed_refs in delalloc
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 3, 2026 at 11:29=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> As ordered_extents complete, they not only produce direct delayed refs,
> they also add csums via add_pending_csums. This produces some number of
> metadata delayed_refs as the csum tree is cow-ed. These refs are counted
> against the trans_handle delayed_rsv, thanks to trans->adding_csums.
>
> As a result, just like we account for the extent tree and free space
> tree when reserving delayed_refs for delalloc, we must also reserve for
> the csum tree. This is mirrored by the non-delayed-ref metadata
> reservation already accounting for csums.
>
> This serves to ensure we have a proper worst case estimate for
> delayed_rsv from delalloc.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/delalloc-space.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index a087be55409f..c2e5c7758ed5 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -252,12 +252,19 @@ static void btrfs_inode_rsv_release(struct btrfs_in=
ode *inode, bool qgroup_free)
>
>  /*
>   * Each delalloc extent could become an ordered_extent and end up insert=
ing a
> - * new extent into the extent and free space trees. So we must reserve
> - * delayed ref space up front for that.
> + * new extent into the extent and free space trees. It also may end up w=
riting
> + * csums, so we must reserve delayed ref space up front for all of that.

Ok, this patch addresses my comment in the previous patch regarding
the missing accounting for csum tree updates.

But it lacks accounting for new delayed refs when COWing blocks from:

1) A subvolume tree (insert a new file extent item, or modify an
existing one in case of prealloc writes).

2) Raid stripe tree.


>   */
>  static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs=
_info, u64 nr_extents)
>  {
> -       return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents);
> +       /*
> +        * btrfs_calc_delayed_ref_bytes() does not assume csums as it is
> +        * also called from metadata writing contexts. So the extra
> +        * metadata insertion reservation represents the possibility of
> +        * delayed refs during csum tree writes.
> +        */
> +       return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents) +
> +               btrfs_calc_insert_metadata_size(fs_info, nr_extents);

We can also skip the reservation for the csum tree if we are writing
into a nocow/nosum inode.
Check the rest of delalloc-space.c: there's an optimization I did
years ago to reduce space reservations in case the inode has the
BTRFS_INODE_NODATASUM flag set.

Thanks.

>  }
>
>  static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *f=
s_info,
> --
> 2.53.0
>
>
