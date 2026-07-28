Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDE33446C5
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231565; cv=none; b=aqF6SNvcOIHNYVv6HUZyrxudhQ67ND0iX3VvVrsJ5uXRrUlDcAikUFmjAe9rc0VHBKZ7oqwajJl8dLBEc2n2QYr1dIapecdHc1lZrXibLWn1XHtkbEIQX1ALFjrdMcK0rWtHCTMPHGLP4pkvcjj1Fk7dUXYdwEOJDjMlCwRtB14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231565; c=relaxed/simple;
	bh=WeqHX5lvDMmFy/nZNdrUbv6DXMeu/xSvAqd2NdTt+8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D8TXcKjkaS7AcWjo4tbdc9U2HTDOHpWFsOp4S+Hwtq5qmMcliDqZVsVrLgG0d+Y4d8XG3EVJ2tH8XyKlCLjCcIzTnE1MH+IhUaPc8ISSb3GG3DRewjUa0Y/OBLiIL1aeL5eywH6NclwdG1I34MPgXGdbQDsn5Uw4CUHabeFqof4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVSY2F+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVSY2F+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D18F1F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785231564;
	bh=6HzHSjnAwe4g/+5iw991xpTocf49FxQCiF1QVu4YQuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IVSY2F+IRTn7pSbtmZtXLXcRb1MZK1hsUS1g5L/ALRmZhj/e9N7/LhI+wP4d2Q3DP
	 MaTStAUkiwVuoNXojXwBU0iJS+l4c3I8f9z/L1yG4IC0QfYrztdPOvAhHs/c7mGDKY
	 V9uO6txBcblh6JH8+tP1VAaWXso8UATxouVgsyYPfCwzY54C0fxC9NoPGaPca+r8hs
	 hkqtIUhQx2G6ZDC1Q6gvvuKj1xudJZKtbn1aqT+SKsZJRj8sTgdN2Qd9bY1MXwsPM0
	 DQgSXetYoFR2zJDbN8Q+BD8qPHOK20swG+vrSkCf/UttpYys4r9OzqQf7Uz1WqB9Ue
	 PaGq+YBrMqpoA==
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-976ea28c65fso1973372241.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:39:24 -0700 (PDT)
X-Gm-Message-State: AOJu0YyajMobbhScmjcxKzwF8CfsXe9PHkirDhc6R/WT+4rJXvjbKwnF
	WZ51HRe1VZJ2C2qBcr8GpBHUl9T4gBl6ZRnUrGiuq9jtV2uJTougMRFko2nKIZ+gHVBcu4N2lFB
	CKpzSjwJbxKBQHtywYOERT4KUnxT3Y+4=
X-Received: by 2002:a05:6102:942:b0:728:aa5f:dc5f with SMTP id
 ada2fe7eead31-754a2cd713bmr661664137.25.1785231563239; Tue, 28 Jul 2026
 02:39:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785229591.git.wqu@suse.com> <f5f77acc88e5ca314e4b41733a3c60e691fb6aaf.1785229591.git.wqu@suse.com>
In-Reply-To: <f5f77acc88e5ca314e4b41733a3c60e691fb6aaf.1785229591.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 28 Jul 2026 10:38:47 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4Tqtt2pDmRWrLbmHeW7oPJfqNoJz28x6aAy4uAHX-FSQ@mail.gmail.com>
X-Gm-Features: AUfX_mxZ0eSagb3MiB9E3O4tbRLXCNAL1-baIP_iRg2P7MJ7YFvkirh3EkJqJGA
Message-ID: <CAL3q7H4Tqtt2pDmRWrLbmHeW7oPJfqNoJz28x6aAy4uAHX-FSQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: use aligned range for locking in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 10:23=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The @end parameter for all extent io tree helpers is inclusive, but
> the call site in extent_fiemap() is passing an exclusive end into
> btrfs_lock_extent(), which will step into the next block unexpectedly.
>
> Fix @range_end to be inclusive, so that btrfs_lock_extent() and
> btrfs_unlock_extent() will lock/unlock the correct aligned range.
>
> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate repo=
rting extent sharedness")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/fiemap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index ba6a360074c0..2f2ae0b76799 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>
>  restart:
>         range_start =3D round_down(start, sectorsize);
> -       range_end =3D round_up(start + len, sectorsize);
> +       range_end =3D round_up(start + len, sectorsize) - 1;
>         prev_extent_end =3D range_start;
>
>         btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cache=
d_state);
> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>
>                 /* We have in implicit hole (NO_HOLES feature enabled). *=
/
>                 if (prev_extent_end < key.offset) {
> -                       const u64 hole_end =3D min(key.offset, range_end)=
 - 1;
> +                       const u64 hole_end =3D min(key.offset - 1, range_=
end);
>
>                         ret =3D fiemap_process_hole(inode, fieinfo, &cach=
e,
>                                                   &delalloc_cached_state,
> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
>         if (!stopped && prev_extent_end < range_end) {
>                 ret =3D fiemap_process_hole(inode, fieinfo, &cache,
>                                           &delalloc_cached_state, backref=
_ctx,
> -                                         0, 0, 0, prev_extent_end, range=
_end - 1);
> +                                         0, 0, 0, prev_extent_end, range=
_end);
>                 if (ret < 0)
>                         goto out_unlock;
> -               prev_extent_end =3D range_end;
> +               prev_extent_end =3D range_end + 1;

If the problem is passing an exclusive end to btrfs_lock_extent(),
then rather than doing all these changes to this variables, which is
error prone since they are used in several places and generally we use
exclusive ends everywhere, I'd prefer to simply change the call to
btrfs_lock_extent() and btrfs_unlock_extent() to receive 'range_end -
1'. That also makes the fix much clearer.

Thanks.

>         }
>
>         if (cache.cached && cache.offset + cache.len >=3D last_extent_end=
) {
> --
> 2.54.0
>
>
