Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9051B40488C
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902942; cv=none; b=V7/VdRFSlsGutdyBmceR99c2CrUZq8qr+hV3P7UUZkpicugjZWLzo0n8Tk0W8Uz7AnqO6j888dndRwIc5BisEFuyzrZMugTH4hf0fAm5Hx0WK/LrGtI8zW710aG1eqPt+cl+cnLxwVIT6JI6FgCkbP9tczjBJkb+EUchnkBs2vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902942; c=relaxed/simple;
	bh=Mj0tmDz9S6t0DEYjxO3AGYN3KAYC46oKoHQCy6upQeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBIdu413JuwQV04n7HdivS0Ltx5wAbP05BlcFN4rn0ksJivyVP90HRjS5MhyfnT3HylJD9N9YI+j0cUcJfNPVgO27ptZvEE0S0hzfRRL2g308hnNKddxV8U5GRlP4hvi5OUwdaVQ6k8TCqJPnv5LFUn9k/hu1G6mHRAlPHQyCi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9e4dcBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9e4dcBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A651F00A3D
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782902941;
	bh=wKxkQGD/Dq2MLr8ztRlUaAm/vXPjbRs1g0XTPI0q/Ko=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P9e4dcBz+f9unvX4Nq/N7Y12htTwXAVsXexmIGouCjgeJQmNbkd4yy1AOaZLSIOiH
	 wyAHL4ZG0mA6fsA39Pf1xVsvi3kvKaPKJlIxtU7qpDbBAOB9nWLRYGnv9GAhlBkhcv
	 rvy9UeYm5pHzgk8mlQ4ImsQs3O788ZOuwB7hJZf+Kb1Wk8ntGuPfYTWb3FMjaD7IyS
	 ZYJ41a0p9cWuri25eH4DJLA+lLpxmIB6hzUChqZ7/E+ApQkCAnnCukqM9GY1IUEx/d
	 brtD14Ym2DNWpLFi/hInOct8VqPLHbvnuA4mgVf3TKhH6zHApIiY9/Q2KpNvk8DNZC
	 y9R8e30sB8pVg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c12788a75abso103504466b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 03:49:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YxXRh3d8KPqSmz2xbuddZkAYvRDSDJj+Au/ezO9C5M0lZVOifK8
	rJyOnzr2Ie+De55TGU1tDYdmqLlXplDlroWILoB9cc3vjBShgCoAYLHaY7mw46efTHw29Tv642o
	2gX3PMiuCBMl1JrCOgUXzT26HHCML3kY=
X-Received: by 2002:a17:906:2491:b0:c12:5625:2529 with SMTP id
 a640c23a62f3a-c12ae7679b7mr9419466b.58.1782902939706; Wed, 01 Jul 2026
 03:48:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <77d71e99f792c80c4841b33ed07530543dca897a.1782849374.git.loemra.dev@gmail.com>
In-Reply-To: <77d71e99f792c80c4841b33ed07530543dca897a.1782849374.git.loemra.dev@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 1 Jul 2026 11:48:22 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7TpSKG+YRG5eq-iZuuy_kz6L=_PQ1d0VZFrmUreN_9zQ@mail.gmail.com>
X-Gm-Features: AVVi8CczynFkmjgFKQgF8OGg2kOizSytDks9xeJe1JFrG7qg75Gzg5ALOtiGQHc
Message-ID: <CAL3q7H7TpSKG+YRG5eq-iZuuy_kz6L=_PQ1d0VZFrmUreN_9zQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't propagate EXTENT_FLAG_LOGGING to split
 extent maps
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, 
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>, Jeff Layton <jlayton@kernel.org>, 
	Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 8:58=E2=80=AFPM Leo Martins <loemra.dev@gmail.com> =
wrote:
>
> When btrfs_drop_extent_map_range() splits an extent map, the new split
> maps inherit the original map's flags through a local 'flags' variable.
> Commit f86f7a75e2fb ("btrfs: use the flags of an extent map to identify
> the compression type") changed the EXTENT_FLAG_LOGGING clearing to
> operate on em->flags instead of that local 'flags' copy, so a split of
> an extent map that is currently being logged wrongly inherits
> EXTENT_FLAG_LOGGING.
>
> The flag is then never cleared on the split, and when it is freed while
> still on the inode's modified_extents list (for example by the extent
> map shrinker) it trips the WARN_ON(!list_empty(&em->list)) in
> btrfs_free_extent_map() and leads to a use-after-free.
>
> Clear EXTENT_FLAG_LOGGING from the local 'flags' copy used for the
> splits and only clear EXTENT_FLAG_PINNED from em->flags, restoring the
> behaviour prior to f86f7a75e2fb.
>
> Fixes: f86f7a75e2fb ("btrfs: use the flags of an extent map to identify t=
he compression type")
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Boris Burkov <boris@bur.io>
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Adding it to for-next, thanks.

> ---
>  fs/btrfs/extent_map.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index fce9c5cc0122..6ad7b39ae358 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -866,13 +866,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode=
 *inode, u64 start, u64 end,
>                         goto next;
>                 }
>
> -               flags =3D em->flags;
>                 /*
>                  * In case we split the extent map, we want to preserve t=
he
>                  * EXTENT_FLAG_LOGGING flag on our extent map, but we don=
't want
>                  * it on the new extent maps.
>                  */
> -               em->flags &=3D ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING=
);
> +               flags =3D em->flags & ~EXTENT_FLAG_LOGGING;
> +               em->flags &=3D ~EXTENT_FLAG_PINNED;
>                 modified =3D !list_empty(&em->list);
>
>                 /*
> --
> 2.53.0-Meta
>
>
