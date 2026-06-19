Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3234C3655C2
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 11:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781868978; cv=none; b=Wtp1QVNUoYmR8W4OHitGjnYhvkEbyyF3cpUQsE/ftNwh8h0VhUFBWNCuM2/WgIWLuG13mT9qCQYC54K+N+pveZ9wS93bOkgD2dgoNzZc78Zcs3xPInwFigDzbb/P5sgyhjZwu7PXqscoirRNhPSEePEVc6TOltcirWZCPD0L31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781868978; c=relaxed/simple;
	bh=TRHAC3NE+bMblL7QybYeINSsfjbuIn1Y0P3s84ZIfb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBYVpKtjq2naHR0lTtr6qRFzWjLQE5CswttSSNQUJdh1MOyodHTGgeKQwlUV0NEe6+m+i07TNJJwNIqaOYh5fYYpwH2vuKM4dRCRGERV3mBw0xRLdAIVrmWhYRVHluFtAA1w20PWnboGCc33N6eQ0j02SWYKq8u+fkCA4dY6T/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCToYOKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCToYOKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCD41F00A3A
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 11:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781868976;
	bh=BN7Rr2DaGKmicKm9x1BTBQ/VO++bHLGR7Tl7Xp3lBl0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MCToYOKPF8VbXBKO+JHRx6U4j+AFz9qCqKpDn0AlfYfdTLgxI3jsygOOsmtuOI9e5
	 lj/DSMA+P8lfDfpqskm26339R9Sa8lUg8EqYZPWhnmCN7fjyfHCpoWblNwIrFx1TDA
	 xLRiUloBifdnD/JtbWoncWvnqlVfBFIfWEyLCvGRIz7ZozJWQXKmYMaGDzLUsN8YTr
	 p2isdbANtDVRJqPxLLI73BwGDxBLd/s2Kj9+xI/FLq5R2w1RurvZ7vR4GVMPfpVq6Z
	 Y9Kepm4h75QQa/Be/xB4+pakszrlAWNQmkY61Yk+H69+4DEy8FpImslNv5KoYE+ldq
	 DwpIj9OVrwPiA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec423a5265so357694066b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 04:36:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YyHdAuiOrGe6RWZA/PH61B6IuhAJBQ6rYlaf6W8nY2o77m3MR7g
	cOtd2tQ1BQ1LPHgM0LRFp0p7fpiL4F/GGRRgaJ0lcHlyvpXLcZO+Espf3ogRqc9EVYLy3d27fqW
	NIEYnVdt/FN99YQ3G95RUwVg8XMFS82k=
X-Received: by 2002:a17:907:3e9b:b0:c07:5319:4c39 with SMTP id
 a640c23a62f3a-c097adfe5d3mr193915266b.6.1781868975606; Fri, 19 Jun 2026
 04:36:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619062928.447838-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260619062928.447838-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 19 Jun 2026 12:35:38 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6SwQZTtY9GfXEWZ-vTn=TA_OchvjAs0=zWHHSJ1eTc7A@mail.gmail.com>
X-Gm-Features: AVVi8CfembY1u8eRr43gH149AgXQo_LGo-_j4k2eWvDO9f9gp31CC4_1vgCjjj0
Message-ID: <CAL3q7H6SwQZTtY9GfXEWZ-vTn=TA_OchvjAs0=zWHHSJ1eTc7A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: decentralize transaction aborts in create_reloc_root
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 7:30=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Decentralize transaction aborts in create_reloc_root(), so that it is
> obvious which call failed and what caused the transaction abort.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/relocation.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 8cac49fa6f6f..62268c8145c5 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -720,21 +720,20 @@ static struct btrfs_root *create_reloc_root(struct =
btrfs_trans_handle *trans,
>
>         ret =3D btrfs_insert_root(trans, fs_info->tree_root,
>                                 &root_key, root_item);
> -       if (ret)
> -               goto abort;
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
> +               return ERR_PTR(ret);
> +       }
>
>         reloc_root =3D btrfs_read_tree_root(fs_info->tree_root, &root_key=
);
>         if (IS_ERR(reloc_root)) {
>                 ret =3D PTR_ERR(reloc_root);
> -               goto abort;
> +               btrfs_abort_transaction(trans, ret);
> +               return ERR_PTR(ret);

In this case, we can:

return ERR_CAST(root);

And get rid of setting ret to PTR_ERR(reloc_root).

Thanks.
>         }
>         set_bit(BTRFS_ROOT_SHAREABLE, &reloc_root->state);
>         btrfs_set_root_last_trans(reloc_root, trans->transid);
>         return reloc_root;
> -
> -abort:
> -       btrfs_abort_transaction(trans, ret);
> -       return ERR_PTR(ret);
>  }
>
>  /*
> --
> 2.54.0
>
>
