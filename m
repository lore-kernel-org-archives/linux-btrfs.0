Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C16409128
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 17:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781545435; cv=none; b=CXOGWTk//LRIEzXTW4ELP8Zmo0+oUQ6ntZEasfJqk91gOHQz+aCOqp2CAODDdIZQARHAfYI+B+st/pOjIDmMGl/kp13O7rNZ4l8NNsJH/bW9TxAorTHJF2nt5vQeQpuY3dW87rGr+W1O2C3A9SkQ98iuT8f5Sj/zcJh0HU8Q9Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781545435; c=relaxed/simple;
	bh=nOS+jWM6G2jqXglgLoaXq4HBaq4OoF8GvmhfrRvFwsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BF+CK+f58PUN9lkOTRohc0yaJB/PmDiLmRrXMmFNWL7s/bj5oBnUWKsMFbt7MOOnGFqBozT2wz7XW68JSFnqRhuFrAAap8jyeRsV3BRr+jQtonBglMtnraZ3Z3azVioKF6dW2k65VmtBxB7zd0oBBzn+ZJ8tuHTnqvTE7Elq1nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5z3cYWP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5z3cYWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFD01F00A3D
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781545434;
	bh=tgX3Q5fj7FS/i2RFyKH5nN4cNdZjH3UnwoiMth6Vb9E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B5z3cYWP8G+PKiEziucDWDiN0lPPhpHE6SByRbkWdIrrtWydS9DJIvwBBwS7secK9
	 by92h2juY+X77qhYA8NXfjwM/iNM3y1rkWf1+VGLuO+tnRwza0gjNKM6VHkhY+zgp4
	 2N0iyD61mJLWbOBlMLcATVB5R/en8CX6uHshy+w2/J3Dunt5dFlUOf8xisvTu8pbey
	 IPi5K4v3bMeBI4o/X9n8TASI7QNnpAM5O84bFgmxUfZw4x/NumrVXNahRE2ChIEhKh
	 WQKChj1PAHCJmx+Hg4Th16YdMPVdObiZwxjnQYaEXCvWBnxRmWnbBYT9ZtEDr2N1m9
	 V8toTXMlundCA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6924a68e3f3so5849610a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 10:43:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YwTjchEuSArzA1ynGy4rYB+doB6Z7BGkHzTj+rAuHNm6uUEb1bW
	iUYXZagw5AbqVgCgqFA1B7lYndEuzzZDjYbd48KK0LrfXq/P0qcNwsVPxn4DVvCqvSbvk2QY8TN
	6RttQXlyCjhDgXkItY039veYKwmMzF/M=
X-Received: by 2002:a17:907:2d21:b0:beb:2de3:1ba3 with SMTP id
 a640c23a62f3a-bfe27e0b395mr783593166b.2.1781545433373; Mon, 15 Jun 2026
 10:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1cdab9f1329c31c69b3d9ef6ec19977004d1bc57.1781545249.git.boris@bur.io>
In-Reply-To: <1cdab9f1329c31c69b3d9ef6ec19977004d1bc57.1781545249.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 15 Jun 2026 18:43:16 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5Y8VR0HJHY-e=LEhKxuLtz+ds5Dz0dfkFw-mumJNT2Lw@mail.gmail.com>
X-Gm-Features: AVVi8CdB8-IHSxsm2dFnWgV984xkq_17c4RCg1T4x2KNtCl7U-uVx4rbqMUn-A8
Message-ID: <CAL3q7H5Y8VR0HJHY-e=LEhKxuLtz+ds5Dz0dfkFw-mumJNT2Lw@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: release extent lock per folio in readahead
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 6:41=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> In Meta production, we have observed a large number of hosts running
> kernels newer than 6.13 which hit hung tasks on
> btrfs_read_folio()->lock_extents_for_read(). Looking through the history
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
>
> Why is this a problem?
>
> On sufficiently large loaded systems, I have observed that direct
> reclaim can run for minutes. Given that, consider two tasks on such a
> system reading an overlapping range of a compressed file:
>
>   Task 1 locks the whole range and starts to read. Some allocation for
>   the compressed read for folio F fails and we carry on while holding the
>   extent lock for the full range.
>
>   Task 2 wants to read F, which is not uptodate and in page cache, so it
>   blocks on the extent lock held by Task 1.
>
>   Task 1 keeps getting stuck in direct reclaim (likely, we already
>   supposed an allocation failure above)
>
>   Task 2 stays blocked on the extent lock the whole time.
>
> If you consider the effects of readahead_expand and imagine a file with
> a 128k compressed extent followed by many smaller compressed extents,
> you can imagine that the expanded window will result in subsequent reads
> hitting many extents (128k/4k =3D 32) per lock window in the worst case.
>
> The system likeley wouldn't be all that healthy anyway, so this is
> likely not a critical improvement, but it does alleviate this one source
> of stress and one thread's slowdown escalating to others.
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

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
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
