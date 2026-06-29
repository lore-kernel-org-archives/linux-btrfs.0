Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5550D4192FE
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782742799; cv=none; b=Ohua6Kp0Hr5D/4Ty4Um9aUzmSjaa1lPu4E6U86tDjdVySHyVNhGExLuDRqgJSFi3DRGjqQe4nUYkiRJ3Zz3Tj4+xRiBWI5B7F66fcfvQtmnSmORO0Na+52KJg/Pp8HwlaCjw1+t/sZMzOtBN8xUPtY6V0OVhYuLsd4vk90Oxams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782742799; c=relaxed/simple;
	bh=ChW7zvfnH1kGoycmSKXky7heRmxDaakA+Y20kPDqUs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vtqft4xizrNaH55hZhq94+E83ckll13NpSPFWH/v3Z5nqg6dpcZERCAok0vACZu1Z3J7hekkgA+GvBwMlCCDrU9vm3cwZMmdjG0yad0/xVOq+gDtMTy4VISDvyar4qWfWEE9vAlsPhu+Q+GgFe0Zy+B27MfNcyrR4lrpyFnsY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3uS+Y/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3uS+Y/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219C01F00AC4
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 14:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782742798;
	bh=uZh2oCbL5aIfUEAhUjSll2Celd8vPyrENikVImHIm8w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m3uS+Y/GO3nFAQVvt4nWWd3+pFGy4SkrAJJJWI2PnMUsIRx1w6bYay9vu/KXf5ZtE
	 rg35FwFxkpB6k5o+kaEH/I39DzEbgy8MZeM3jQld4ACa7k1iUuqfd2D88BGufJTKUd
	 iqMSZMTSeQc0aDyQJogTsHse6mZexOYzaLjUT1md7Lr9QzlJe4hBLc6AXGsI+VnIkI
	 VIg+TbNES4wxtYShPpFwVLbGi2D1iFr7MB4/9RKn1ydOGkcPRXqdKeJn7rYiYKgCXg
	 xp6VZlnG5UiipgTrPLnkIaDspfQY2q1UOYNAQ21UvqSv+dW9dDPNq9uy5LpVlh+vc1
	 KXOBD1OybcddA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-698587a1335so1726175a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 07:19:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roe8G8N+wUkqWLIDDsACV3YwGHM8yZ39wczZT7rFyNmcI1lPxdzYt69PhImxdMy3XYwHnj9X24VqbUYtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxT/JK8fYifC6O10o/9f6SoMS9hCJ2EhuOJJowvpea02ts61gC
	Am/BVlQcqeTogGPNAffIAx+ezy6DSsIvpibEkgQkv2N3670CQl1CS5dX7Sd/Ak5m/sIofC7ssHY
	tt6jZOJu1qGGHPgIgcoUFrmmQm9XPRQI=
X-Received: by 2002:a17:907:3e9e:b0:c12:5bf1:ee4d with SMTP id
 a640c23a62f3a-c125bf1f384mr237940166b.63.1782742796746; Mon, 29 Jun 2026
 07:19:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
In-Reply-To: <20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 15:19:19 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
X-Gm-Features: AVVi8CcoZpVWYeuQi9v82o9hiLi6aBU90Kvx5ecpazG3Drk3tMNzcMOWPP4C4TM
Message-ID: <CAL3q7H5o6vKOcQ0G4shQw6q7vCpfZYo8KO6Rg6VdChDoMB+C=g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't let shrinker touch extent_maps that are
 being logged
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 2:41=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> The extent map shrinker can free an extent map that is still owned by an
> in-flight fsync and still linked on the inode's modified_extents list,
> corrupting that list and eventually causing an RCU stall.
>
> btrfs_scan_inode() currently skips EXTENT_FLAG_PINNED maps, then calls
> btrfs_remove_extent_mapping() followed by btrfs_free_extent_map():
>
>         if (em->flags & EXTENT_FLAG_PINNED)
>                 goto next;
>         ...
>         btrfs_remove_extent_mapping(inode, em);
>         btrfs_free_extent_map(em);
>
> But btrfs_remove_extent_mapping() deliberately does NOT unlink a map that
> has EXTENT_FLAG_LOGGING set:
>
>         if (!(em->flags & EXTENT_FLAG_LOGGING))
>                 list_del_init(&em->list);
>         remove_em(inode, em);
>
> This sets up a UAF situation where a later fsync() can trip over the
> now-freed extent_map still on the modified_extents() list.

I don't see how that can happen, because fsync always takes the
inode's i_mmap_lock (in write/exclusive mode), and btrfs_scan_inode()
takes the same lock too (in shared/read mode).
EXTENT_FLAG_LOGGING is only set and cleared during fsync, so how can
the shrinker race with fsync?

Also, there should be no () after modified_extents (it's not a function nam=
e).

Thanks.

>
> Fix it by having the shrinker skip maps that are being logged, the same
> way it skips pinned maps. Such a map is owned by the in-flight fsync and
> will become reclaimable again once logging clears the flag.
>
> Fixes: 956a17d9d050 ("btrfs: add a shrinker for extent maps")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> We've started hitting a number of these problems in our fleet. It
> seems to mostly happen on ARM64 architecture, but there have been some
> WARN_ONs that popped on x86_64 too.
> ---
>  fs/btrfs/extent_map.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index fce9c5cc0122..128f7800e101 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -1166,7 +1166,13 @@ static long btrfs_scan_inode(struct btrfs_inode *i=
node, struct btrfs_em_shrink_c
>                 em =3D rb_entry(node, struct extent_map, rb_node);
>                 ctx->scanned++;
>
> -               if (em->flags & EXTENT_FLAG_PINNED)
> +               /*
> +                * Skip extent maps that are pinned or are being logged. =
The
> +                * i_mmap_lock should prevent this from seeing LOGGING on=
 extent_maps
> +                * directly associated with inode, but em may be associat=
ed with
> +                * other, dependent inodes and their locks are not held.
> +                */
> +               if (em->flags & (EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING=
))
>                         goto next;
>
>                 /*
>
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260629-btrfs-skip-logging-3e31701d9647
>
> Best regards,
> --
> Jeff Layton <jlayton@kernel.org>
>
>
