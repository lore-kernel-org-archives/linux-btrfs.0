Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8937B03F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 08:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252260; cv=none; b=Yc4LrLuURJ79lBPn5fwSyTeqzcE7SqhODdFoV2DvjDNGTtz2liELtGovZ8+5NNvxa0XnKJwkCnh6JJaYockBdPgLDNMMrKDDjTUDL99QYvanaUIN39HLr6nSzMqoTtCG0qZKM9C9GcPLMwtNYc+m3/swCIfq0PPAxw3CHGTuriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252260; c=relaxed/simple;
	bh=VcYu/0+J27xSGpSFZZ6QnP1cU9lWEe4N+AM5EWRSkEo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FjaBLy+JGTfdvfwRyOfp6dMP5R5hw0SpAe0P5d7pcIisjpDDr4LOpHbLzuN1e+miN6+a2hG+dLWM7aOttOId5D30ykjMwZXd7rlXq0lN5Yo+N6bJSINpOjoFv2/Ymb/jyOGeZCjxwoj5dz//k2vowERrFiYo3gd7vShwsEMX9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Np/BsC3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Np/BsC3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F961F000E9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781252259;
	bh=62bxiVTdY9ZwGwYEWhYvIDS5AK68c7jlQVAOvrzEiLE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Np/BsC3ZVsxURRu00beN/yLhVq0jrCt482JU6LI0AFT+LDb0HN5jzmtUF57885oyF
	 5jEu528oxucVYcK72HX2EbIeLloNHRfpRhlsPoE4fKZA//SBvNNkD4fB5lTmhltPyn
	 afpsGBkS3v+/Ek6V0gcRIik4mLCp0ip7492ijX+s8QWj+mz04oP5mzxzJRoBV12clr
	 /j3vbTc63y4l+LUREHx4k4Vp6q+gm7yqdVMW3t97h94nBL8iJ6+iFgPaSbNA5aRZy5
	 c/yKSgtr9XKU5TKQh4V8qxEFcZv1+r8tDChbJ+IGyaTji6qVyDWbdHyuHX4LcQaFQf
	 rF6ANfKK6WUVQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bec449d0af2so86018566b.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 01:17:39 -0700 (PDT)
X-Gm-Message-State: AOJu0YxNKMQJiekUhWLjRP5DzktsE6iyX3HLz+iqzI5MzEgJ8OhJsrIY
	WgFADDW2m0uMH5zSReQGzGYB8NrZlES8JqtE5aeoEiCyGObQWDjXtEwzEBu6BbTUDQ2NRr+2vCv
	IbWVTlP3T9fkZ9FinFIYY5Q57VtpVaro=
X-Received: by 2002:a17:907:7b9a:b0:be9:54dc:af58 with SMTP id
 a640c23a62f3a-bfe2b0fcfd5mr86665566b.49.1781252258167; Fri, 12 Jun 2026
 01:17:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e0b2579b1ae150d02550823b837ae3e6a14af644.1781215153.git.boris@bur.io>
In-Reply-To: <e0b2579b1ae150d02550823b837ae3e6a14af644.1781215153.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 12 Jun 2026 09:17:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7o4aO1XG3Fip5Sw1BiA=TFvCix-vaX50y7DgVmkz6cVg@mail.gmail.com>
X-Gm-Features: AVVi8CczqtxRQlnU90fxWkwKMLEKe6b-ngSqsMqkzNHT3zq8yRMd2Dd2PDctCFc
Message-ID: <CAL3q7H7o4aO1XG3Fip5Sw1BiA=TFvCix-vaX50y7DgVmkz6cVg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fallback to transaction csum tree on a commit root
 csum miss
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 11:04=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> We have been running with commit root csums enabled for some time and
> have noticed a slight uptick in zero csum errors. Investigating those
> revealed that they were same transaction reads of extents that were just
> relocated, but the extent map generation was long ago.
>
> It turns out that relocation intentionally does not update the extent
> generation (replace_file_extents(), but must write a new csum since the

There's a missing closing parenthesis here.

> data has moved, so we must account for this with commit root csum reading=
.
>
> Luckily this is a short lived condition: after the relocation transaction
> the commit root will once again have the csum. So we can add a generic
> fallback to the lookup to try again with the transaction csum root.
>
> Fixes: f07b855c56b1 ("btrfs: try to search for data csums in commit root"=
)
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/file-item.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 9f6454e9db818..cf50fd623f41a 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -358,6 +358,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
>         const unsigned int nblocks =3D orig_len >> fs_info->sectorsize_bi=
ts;
>         int ret =3D 0;
>         u32 bio_offset =3D 0;
> +       bool using_commit_root =3D false;
>
>         if ((inode->flags & BTRFS_INODE_NODATASUM) ||
>             test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
> @@ -431,6 +432,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
>          * from across transactions.
>          */
>         if (bbio->csum_search_commit_root) {
> +               using_commit_root =3D true;
>                 path->search_commit_root =3D true;
>                 path->skip_locking =3D true;
>                 down_read(&fs_info->commit_root_sem);
> @@ -463,6 +465,28 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
>                  * assume this is the case.
>                  */
>                 if (count =3D=3D 0) {
> +                       /*
> +                        * If an extent is relocated in the current trans=
action
> +                        * then relocation writes a new csum without upda=
ting
> +                        * the extent map generation. Until the next comm=
it, we
> +                        * will see a hole in that case, so we need to fa=
llback
> +                        * to searching the transaction csum root.
> +                        *
> +                        * Note that a commit root lookup of a referenced=
 extent can
> +                        * only miss, not return a stale csum. A freed ex=
tent's csum
> +                        * is deleted in the same transaction and its byt=
enr is not
> +                        * reusable until that transaction has committed =
and the
> +                        * extent is unpinned.
> +                        */
> +                       if (using_commit_root) {
> +                               up_read(&fs_info->commit_root_sem);
> +                               using_commit_root =3D false;
> +                               path->search_commit_root =3D false;
> +                               path->skip_locking =3D false;
> +                               btrfs_release_path(path);
> +                               continue;
> +                       }
> +
>                         memset(csum_dst, 0, csum_size);
>                         count =3D 1;
>
> @@ -481,7 +505,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
>                 bio_offset +=3D count * sectorsize;
>         }
>
> -       if (bbio->csum_search_commit_root)
> +       if (using_commit_root)
>                 up_read(&fs_info->commit_root_sem);
>         return ret;
>  }
> --
> 2.52.0
>
>
