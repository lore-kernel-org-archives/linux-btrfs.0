Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E783377550
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785224188; cv=none; b=ahX5X0XmkYYrfyFLlvUB/PB3kY7KGtcXq4eumgB1ZhkSrAEos22smXrzx7BZ8B6E18N28mJ7sE0/X8eA3VmkxaXy76MKazN+XNMjTtbFeN6/NkSl+f+WSa467DS68DB7F0ZRW4hBHL8TE56K0tD2UVmBcd3mXPGIUHLpE5nSSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785224188; c=relaxed/simple;
	bh=C+QM69xvxF141JXniQQhtkP7JAlW1v5te95htzx7f6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GJQjQ47cTOe6aWQYmuCWdQYi6rBXIqS3RCEdyi72ddlqLo+fHBRLYHiP6j3rGTQ8AAEBwj/ZqgX9gb9yFrKwu9hzvlvCUEG90do/paUVOjAlGfKSOPjWKMYJ984ck1cG2OVWIi5R0njV9TeTS/kLeeQzxgMIJPT3PGfcSAe2QbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XygUWc/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XygUWc/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082BF1F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 07:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785224187;
	bh=pwr4HVCjelx95RjpjcvLGbh4EKRZdyGc06OGJ5mHoq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XygUWc/m3uyY/yl/tCzwzS8tIqKJDSk7g7ttsqe8vv29SNk7ECMmSEu6KhqcK7wJP
	 5qAyxW1Km4mRKMu/JSy6joGsOICRS1Oi3ocSJB8d12QH1p4TnRDV4jTwEwTPm8v0o/
	 h4fqIo7Ecaeqyms8vOIklx/uEu7B7EGQ3AcuHlexAgckw6X/S7h1oxDfQ076kk4tI2
	 /uwu6rRXdU27efaZVrcpZm116z5at2qwc5XIGGKn0CvBKR9jzOEFKXBC3XIixMnrq+
	 0zJKrPVn4wze3vNdEHKNvBABGy8FACdx/8Kp+zzSMxvzmrIl1HawVFEDgFcqTOaReo
	 uf2BNeix2CGZA==
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-74dceb46291so1261603137.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 00:36:26 -0700 (PDT)
X-Gm-Message-State: AOJu0YwMit4YzfIJJ1/HYLnIksW0GOGi+01N1EYRi11kUivF1qZ38tRJ
	5XHntzrIbJUDD9RW+0VJcc0G8H/7rlwMfW5zDceF9USWz4juRRUO6/gOU+oBeySVL/RPVLkn3Bx
	zLr3uZpYsoxVRypUG6UFukbAAwR26yMs=
X-Received: by 2002:a05:6102:2906:b0:737:4cac:52f7 with SMTP id
 ada2fe7eead31-754a1cad77dmr530643137.19.1785224186229; Tue, 28 Jul 2026
 00:36:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785220613.git.wqu@suse.com> <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
In-Reply-To: <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 28 Jul 2026 08:35:48 +0100
X-Gmail-Original-Message-ID: <CAL3q7H53Vy4aGRui9L_GTkzuKJfHJXRSP0dtybGRJhJRdFLSqw@mail.gmail.com>
X-Gm-Features: AUfX_mwQn6B_jTtm9EzGZXSy-d9zyZk7xAf3AxnWT2nSMVsEATEUKAqstaeUPJA
Message-ID: <CAL3q7H53Vy4aGRui9L_GTkzuKJfHJXRSP0dtybGRJhJRdFLSqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 7:47=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> The @end parameter for all extent io tree helpers is inclusive, but
> the call site in extent_fiemap() is passing exclusive end.
>
> Fix it to follow the common pattern.
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

Here it was an exclusive end.

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

Here we guaranteed hole_end is not exclusive, by subtracting 1 from
the result of min(), and both arguments passed to min() are exclusive.

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

And here range_end was exclusive, we subtracted 1 to make it inclusive.

>                 if (ret < 0)
>                         goto out_unlock;
> -               prev_extent_end =3D range_end;
> +               prev_extent_end =3D range_end + 1;

Here range_end was exclusive so there was no need to sum 1.

In other words, this change doesn't fix anything; it's just rewriting
the calculations in a different way to reach the same results.

Where exactly do you think you saw a wrong end offset being used?

Thanks.

>         }
>
>         if (cache.cached && cache.offset + cache.len >=3D last_extent_end=
) {
> --
> 2.54.0
>
>
