Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6D540BCB4
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541187; cv=none; b=UMcBX7k2GhzzPQqBdeqlqlDixpsqR/4sPZ6aM1HijHSzuMMMRirnv4LXRLKhDrZqB49yu9JRJ19CP9XtjzzF5C67cF4F2JikEO7z+UILJeuYC80Q9hzE6UgBw16cpmlxDfHVsBYyLseKKsAqzK0ECFjUxNUYKqxVuRqWYr9vfzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541187; c=relaxed/simple;
	bh=Osw2gmWctPhBYhYchs5uFkBlWNT3FDtYi6yWlzaSuJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5uoVXrKQlatW4fssfSBcAv2DETdJIf9kdtDFO2bOBD0lFG235iNmyTMCyy6ZQti//d8f18F23EiYzztFM4IDQQ5FMs9wIJyCllzVvoRYum4HKodFaqAsch6PDQRqilAWQq8qwuw43sNLHBm2Jswbq6isClwfd49E2WVIxEfv8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoVlFXrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoVlFXrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5371F00A3A
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781541185;
	bh=/Sefn6tjLYtpk6ORVSdmGE49XZRfYuwQh8i/C16X/gY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VoVlFXrxWoGjJ8wSZLVpMshNiw2dRvu9bPknXGfX1YAa4ML9PiSUCSA4ZEZftRALh
	 WmIAgRGaaWxvflP3zWjwC1uagH+69W4pfknZc7PO8LqvAOa982p0KWwY3DRLvpaneI
	 DTwsv+mVjSN+7/hfwwtwbRpu3cFEc0Vinwc2y4nm9hoV+tSWzhfN1cXScHIa/AMySF
	 9svC7w1IgCwNZ/8UfDbDOaOOz0yRRpUjIzsN6jnqboflIbHCQmpfFSZQquklGwqr7R
	 AHklv9c2XzF7KTvRHXfhdTPjWW7iJy8ktkGdVOraIH91FIk2mFKKAEG6nZXjOWjy6p
	 Wg7xaCZUMvuIw==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69170548d0eso5197681a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 09:33:05 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzek9HkU77FK1tXw+zLocnyFffEH5LcF3RMpTqXXaQwxqxTU9c9
	qOjmzL6FYLH21qVXr9VEthNbi41rRrrLTgy/xfJT+uGMnlkELVCLjMrOeyqf/Po+NEGhN1L0amW
	WWnVNMqaBZEqEs9aPMSZ+RS4TMz+BUWE=
X-Received: by 2002:a17:906:c149:b0:bfe:ed06:5a16 with SMTP id
 a640c23a62f3a-bff4cddc4c2mr560054366b.52.1781541184422; Mon, 15 Jun 2026
 09:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ebca8b7936fb1191b03071f81faae0424d9ee93.1781540038.git.boris@bur.io>
In-Reply-To: <1ebca8b7936fb1191b03071f81faae0424d9ee93.1781540038.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 15 Jun 2026 17:32:26 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4R6M9GAJYEWVBiu-ZQxCgj22QdDeRJNA1Dt6j6EiCnaA@mail.gmail.com>
X-Gm-Features: AVVi8CcpmeVycZR17CTiIQASRQT5pIcfpxxphS8C3ch4pI5MkmFLjiDN5hk6iRE
Message-ID: <CAL3q7H4R6M9GAJYEWVBiu-ZQxCgj22QdDeRJNA1Dt6j6EiCnaA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: release extent lock per folio in readahead
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 5:26=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> In Meta production, we have observed a large number of hosts running
> kernels newer than 6.13 which hit hung tasks on
> btrfs_read_folio()->lock_extents_for_read().

You mean a deadlock?

> Looking through the history
> in this codepath reveals an interesting history.
>
> in 6.12, we merged
> commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire read"=
)
> which holds the extent lock very narrowly while looking up the
> extent_map. However, this proved to introduce a serious race with DIO
> writes which was fixed in 6.14 with
> commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between rea=
dahead and direct IO write")
>
> That latter fix subtly changed the extent unlock point from the pre-6.12
> regime. In 6.11, each read endio unlocked the extent it finished
> reading, but in 6.14, the extent is locked/unlocked as a unit around the
> entire readahead loop, while the individual folios are still unlocked as
> the endios finish. This is mostly the same behavior, as all successful
> reads will populate the page cache, so subsequent reads won't enter
> btrfs and hit the extent lock. But in the case where the readahead
> fails, perhaps because of a memory allocation failure doing compressed
> reads, the page will not be brought up to date and a later read of an
> overlapping range *will* block on the extent lock.

Ok, but is it blocking indefinitely, a deadlock?

What is the problem exactly? The entire locked range is unlocked later.
Can you explain this more clearly?

Thanks.

>
> To bring this behavior back to the old model, we should unlock the
> extent at each loop of the readahead loop rather than in one shot at the
> end. This allows such overlapping reads to proceed as they should.
> Writes are fine because either the page has already been read and has an
> appropriate state in the page cache to be invalidated (or not uptodate)
> or it is still-to-be-read and the extent lock is still held protecting
> it.
>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
> Changelog:
> v2:
> - fixed the bug of unlocking readahead expansion extents that we did not
>   ourselves lock.
>
>  fs/btrfs/extent_io.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index ce9aa0f6bc35..e0d24e69441a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2745,12 +2745,23 @@ void btrfs_readahead(struct readahead_control *ra=
c)
>         struct fsverity_info *vi =3D NULL;
>
>         lock_extents_for_read(inode, start, end, &cached_state);
> +       /* We don't use cached state for a bulk unlock, just free it. */
> +       btrfs_free_extent_state(cached_state);
>         if (start < i_size_read(vfs_inode))
>                 vi =3D fsverity_get_info(vfs_inode);
> -       while ((folio =3D readahead_folio(rac)) !=3D NULL)
> -               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> +       while ((folio =3D readahead_folio(rac)) !=3D NULL) {
> +               /*
> +                * Read start and end before btrfs_do_readpage(). It unlo=
cks the
> +                * folio, so our reference might not be valid after.
> +                */
> +               const u64 folio_start =3D folio_pos(folio);
> +               const u64 folio_end =3D folio_start + folio_size(folio) -=
 1;
>
> -       btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
> +               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> +               /* Only unlock the range we locked, even if readahead exp=
ands. */
> +               if (folio_start >=3D start && folio_end <=3D end)
> +                       btrfs_unlock_extent(&inode->io_tree, folio_start,=
 folio_end, NULL);
> +       }
>
>         if (em_cached)
>                 btrfs_free_extent_map(em_cached);
> --
> 2.54.0
>
>
