Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189D2480DF2
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328105; cv=none; b=RUrSC3jY6jr4NlbyL4OY2Bz2Q2B/s0C6uz0e58wy7ZeRGu4VXylhMOAVrkEV9vbfXIml7xZuFJoChWW+6+Zh+PBVSjtzrfYutTqj/hacti1XoH6+EkZIoucm/evF+OacChhDTUoARgjHkB1e06ZdeHYk6CqrD8sY3/eSW4I48Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328105; c=relaxed/simple;
	bh=Eybbxs3eKMw+SxzgQDYQmCCL1Lh0Y8/JJn08ZLs2XDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hyoKuxUGCTk8PuIpkFNjx8VJERRbG9+kiT52YMbNhvxbIVbpALITqmiaGbJP6gHdd2Mupz0xSH81r9HZmH1k3nBrf3eSz9VKTMATJxAyxhYUaZAhId43tRin8q8w5O34qetRf7QlrxzUUn02pPZRC78WQHIy0b6x7Jsy4e+KV8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fy7aV8gK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fy7aV8gK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101A01F00A3E
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328091;
	bh=pmPxRrS/QA+zmp1bynwWPipvBGiePHDmI63VAHDuYSs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fy7aV8gKwpdMjP4By2U4bQdFQ3XlyZplYfKx4lorFPdvxU4iI7cKFY3EIsT2hBMKM
	 hJqtGVlS2tUG3joWwBEpa4vbnJNNvJ1/ZHVYLO4VYNn0BHQ3W4jSzUgIAqpKx8uPNQ
	 0cJfB+GViunwZ6MacDF+AuiMIcvL+h5Z7+mtZH6UcWnQYKPq6svY0yLjpSmPiOO4xS
	 qCHjWtuRo1XuP+E0o9Ou/GjOYO+QeH8hkgCEUi10piQO5sXNZZmR404KuVjn9+e5/L
	 K7g/HGSe4MrCoLaUeAv0QLAl7gWFb01K08IpCqgYoMaZupSr7VRQsX0dW9466w/rQ5
	 BoBDm52TI8Rhg==
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-75637679fc7so91650137.0
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 05:28:11 -0700 (PDT)
X-Gm-Message-State: AOJu0YwUKVPhphz+tO8SQ2y2J/1zHK4Uu2yB8+KL+SGGcKdmX/dsOJnO
	Yd7hJ8ZoT3e8y6qX/6AN9otPcPQCq0GBeU6Esh0Q+OU8Gb61O8bHYuzPPv8qPnMa519dj/GKFko
	LeSM4uu5fhQy2nQgMj3x0WDluqbGHCKE=
X-Received: by 2002:a05:6102:3ed0:b0:738:472f:2cb1 with SMTP id
 ada2fe7eead31-7549ff677d2mr2442669137.8.1785328090226; Wed, 29 Jul 2026
 05:28:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <96ff0c2dd662dc6247d4400d10e6179f0d3b5565.1785206364.git.wqu@suse.com>
In-Reply-To: <96ff0c2dd662dc6247d4400d10e6179f0d3b5565.1785206364.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 29 Jul 2026 13:27:33 +0100
X-Gmail-Original-Message-ID: <CAL3q7H43GFWphbXtW=HJfT+ix2Lh9p8umf1nGNu0OG363WGt3A@mail.gmail.com>
X-Gm-Features: AUfX_mxlF_tBTsxI-jv75q44jRnQKqoOExXn3mxl6zkLO-wUM3be5WKZetaIQV4
Message-ID: <CAL3q7H43GFWphbXtW=HJfT+ix2Lh9p8umf1nGNu0OG363WGt3A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 3:40=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> In that function, we round down the start position and round up the
> ending position.
>
> But during the calculation of @len, we use "round_up(start + len,
> sectorsize)", which is the rounded up end position, not the rounded up
> length.
>
> Which results a much larger length, and later we are still using "start
> + len", which is completely incorrect.
>
> Fix it by declaring a local @algined_start and @aligned_len and use them

typo: algined_start -> aligned_start

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> instead.
>
> Fixes: bc42bda22345 ("btrfs: qgroup: Fix qgroup reserved space underflow =
by only freeing reserved ranges")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 210af4d7d4b5..f68b696b4bf7 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4339,12 +4339,13 @@ static int qgroup_free_reserved_data(struct btrfs=
_inode *inode,
>         struct ulist_node *unode;
>         struct ulist_iterator uiter;
>         struct extent_changeset changeset;
> +       const u32 sectorsize =3D root->fs_info->sectorsize;
> +       const u64 aligned_start =3D round_down(start, sectorsize);
> +       const u64 aligned_len =3D round_up(start + len, sectorsize) - ali=
gned_start;
>         u64 freed =3D 0;
>         int ret;
>
>         extent_changeset_init_bytes_only(&changeset);
> -       len =3D round_up(start + len, root->fs_info->sectorsize);
> -       start =3D round_down(start, root->fs_info->sectorsize);
>
>         ULIST_ITER_INIT(&uiter);
>         while ((unode =3D ulist_next(&reserved->range_changed, &uiter))) =
{
> @@ -4356,12 +4357,15 @@ static int qgroup_free_reserved_data(struct btrfs=
_inode *inode,
>
>                 extent_changeset_release(&changeset);
>
> -               /* Only free range in range [start, start + len) */
> -               if (range_start >=3D start + len ||
> -                   range_start + range_len <=3D start)
> +               /*
> +                * Only free the range within
> +                * [aligned_start, aligned_start + aligned_len).
> +                */
> +               if (range_start >=3D aligned_start + aligned_len ||
> +                   range_start + range_len <=3D aligned_start)
>                         continue;
> -               free_start =3D max(range_start, start);
> -               free_len =3D min(start + len, range_start + range_len) -
> +               free_start =3D max(range_start, aligned_start);
> +               free_len =3D min(aligned_start + aligned_len, range_start=
 + range_len) -
>                            free_start;
>                 /*
>                  * TODO: To also modify reserved->ranges_reserved to refl=
ect
> --
> 2.54.0
>
>
