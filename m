Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A27414A38
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337093; cv=none; b=t1O8c8YaCCjx0UtFOoMKjf4vb/+4+C/IkcaU9cjmdlbL4v6E255sD6BKO8OxaZ9BqNjOQXOWoMkmnGDdIco8urhh4BoP/wokOGT+sz5BFMu/TFn+ajgizYtyfDQbKGfctplO9tHbKF9rpydBXDRz87s+WCgEdr2j9CIc4Q+oEH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337093; c=relaxed/simple;
	bh=VN64XrkozeduO5JdP2TA5jqS51ZDA8Tu6RJMWzMlQ0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fy0Ld/8nxg5MzttdLB8vplP0DqdeGV9z2AZMW8bSe58OpoU9QlXh4SYbD2JZfm+MIoZsmcNP++nmL//dmbgqKZjC/pErvotNQxt3m1b7Ddg3QRD7yQxUVP+3wI09vDTbsvpVrFYtQ3wM1b4kYjPlJKkn7gUIwl9vnzUdtgOldAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoqpDxCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoqpDxCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307B51F00ACA
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jul 2026 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783337089;
	bh=jPLDYOKFkvXy2BBkBzYJ2/R/fRfON+A+ox1E0KysDk4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QoqpDxCJrgwnu5mQvgbMr5auep+HIC0JkGEJwctBc/z5FI5yApxARkSDEtAnlFNYI
	 /xjuLGBFjFaAcubtT+O6FSFy1mkqbvWXSm5mZlmG9vdhdX6vSTpvMmUnPN/6c3ljg8
	 4NqDz90NyKkp68bYFptZrX1hFE1M0gF56IsMfPuUy1CTIW4UwCYtuaku+1jvz6ckKu
	 GF4/HML8i0PfWpP0ztxHJSoTScN4EVCHp0f5LEzCyrF/uUTjy8T4R8M51uaFHaFnDj
	 n39w3GMGxJ9H88HxTfqSwotjjxdG4iz3HKIEyHw6tXv62oRCLTczPL33/yQgl1muPg
	 MApp+LXiGqQBQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c127a694ccbso373321266b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2026 04:24:49 -0700 (PDT)
X-Gm-Message-State: AOJu0YxWQ1CUDYitSdPpVgpb7BH/rz6eMMTarNJPIIC2EUK/CZb7FQHg
	00IDNOG9CI5PDOkRLcWj2v4y9y8kT1Lrc2XKdW5JL1s7wHgU322L9LW3gjTn4PDcweg6/PpJjrt
	e/WvfJXaf9O1H4HSv1p6hcHWujQuoIVs=
X-Received: by 2002:a17:907:3f02:b0:c12:6c2e:ae9 with SMTP id
 a640c23a62f3a-c15a6854790mr4960466b.22.1783337087801; Mon, 06 Jul 2026
 04:24:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260705054637.80584-1-shuangpeng.kernel@gmail.com>
In-Reply-To: <20260705054637.80584-1-shuangpeng.kernel@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 6 Jul 2026 12:24:09 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5ddufnZO5soRWHV0MDwJ+Ak4zr7H8iFcoBB_n5zoDcog@mail.gmail.com>
X-Gm-Features: AVVi8Cc2303h-SpwDH0-rMIdG6X2vRKKChI4K3iVx_f1QnwHweGmAjHq5GcDm-Y
Message-ID: <CAL3q7H5ddufnZO5soRWHV0MDwJ+Ak4zr7H8iFcoBB_n5zoDcog@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix extent map leak in NOCOW direct I/O write
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com, 
	dsterba@suse.com, fdmanana@suse.com, jbacik@fb.com, wqu@suse.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 5, 2026 at 6:47=E2=80=AFAM Shuangpeng Bai
<shuangpeng.kernel@gmail.com> wrote:
>
> btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
> extent map reference that must be dropped on all exit paths.
>
> For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
> keeps using that extent map and asks btrfs_create_dio_extent() to
> allocate the ordered extent. If that fails, for example because
> btrfs_alloc_ordered_extent() fails, the function returns the error
> without dropping the input extent map. The PREALLOC path avoided this by
> dropping the input extent map before replacing it with the newly
> created one.
>
> Check the error from btrfs_create_dio_extent() before replacing the
> map and drop the input extent map on failure.
>
> Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO write=
s with fsync")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Adding it to the for-next branch, thanks.

> ---
> Changes since v1:
> - Add a comment explaining the returned @em2 pointer.
> - Use @em2 to decide whether to replace the old extent map and assert
>   that this only happens for PREALLOC writes.
>
>  fs/btrfs/direct-io.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..19a1259b3b2f 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -281,17 +281,24 @@ static int btrfs_get_blocks_direct_write(struct ext=
ent_map **map,
>                 em2 =3D btrfs_create_dio_extent(BTRFS_I(inode), dio_data,=
 start,
>                                               &file_extent, type);
>                 btrfs_dec_nocow_writers(bg);
> -               if (type =3D=3D BTRFS_ORDERED_PREALLOC) {
> -                       btrfs_free_extent_map(em);
> -                       *map =3D em2;
> -                       em =3D em2;
> -               }
> -
>                 if (IS_ERR(em2)) {
>                         ret =3D PTR_ERR(em2);
> +                       btrfs_free_extent_map(em);
> +                       *map =3D NULL;
>                         goto out;
>                 }
>
> +               /*
> +                * True NOCOW writes don't need to create a new extent ma=
p,
> +                * while PREALLOC writes must replace the existing one.
> +                */
> +               if (em2) {
> +                       ASSERT(type =3D=3D BTRFS_ORDERED_PREALLOC);
> +                       btrfs_free_extent_map(em);
> +                       *map =3D em2;
> +                       em =3D em2;
> +               }
> +
>                 dio_data->nocow_done =3D true;
>         } else {
>                 /* Our caller expects us to free the input extent map. */
> --
> 2.43.0
>
