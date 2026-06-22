Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDFB395ADC
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127172; cv=none; b=Aw3xC5OKrMMq6QAJUrtMPmW83L+JDDP/WrSVE9Ta8erpSrsmfSua5htTKmJ3jV/N1vvCrUPlqRlowYMC0XK2CHJACiRmYouxnFcsp1SzDSneNQYgU0qR6PcnMWgjhB+AyaNTemUYiP6bvP0WBAGB8dugeMOwUdFqMTuSfLQ0ro8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127172; c=relaxed/simple;
	bh=epqQ1HClciHV671Fo7aC8an1Z8UBkUiqrIbD7x2PnDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W4X7DICrPwZHDIVTg2ikpD6I75UBtPQQBD4wpJHt1Rsa5JSufN7y/6/d0LgAY3t9KzlAFu6Cd+XdJ0rPZoByFoXBNDixGyPksiE0kfysqkZa32qUwu6V09CauK5LnjmTGvWXhexUhxGfHryH/NXl7KEtgGx+2doQAMezfUZv1GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUeSAZ2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUeSAZ2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FC81F00A3D
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127171;
	bh=fFU0tiA9fVgazVGrND7wIoASfHC4BIWGD1KF0Vnq9nE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VUeSAZ2ZTQ8SJcYkO0lkf8fvETMIBg04+gLvLO4uBhQVm0bFQ6kknYthD/gT6kclX
	 QLjSRXgpPpTuxOfzlPnSPsFk4mQW16hLEiA5mnbK6/Vup7MftoIt0EjHReDjco3PyM
	 yoA5ScXr4R2qnJYnqv61XzGUwAsgxyi4CPS/jvFFBQ3dLnlCVK8xP/Aup0GaKr/SAN
	 vOvQ3pYCp6Hg1dSSDI+Fap79NBxM98/fdIMQHjlwBC1lUZuvyvvevpsS0bbRfbh6ZM
	 KL3R7guH45m85KYn/QEmH40vYZvfOYsifIhdZZucHvIcLwTycTlBUqO7SY/TWylRsF
	 7etGvY73Pk6Eg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c074142cf6dso643169366b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 04:19:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YygO3edE5hp3v2MQKhZ9hnGJ+CkHos9c/OshuGUvE662p90be4H
	oJQYvI05i/+Nio4nYOEWkqhU9LE0oYSTBzaiIIsj8MLUtaXmEGth4tP8a9fxqcZrtt5S5sb3sP4
	9kaqP4GdS+conF+2uXNVKW6ps/ZU2qHw=
X-Received: by 2002:a17:907:940e:b0:c08:580e:899a with SMTP id
 a640c23a62f3a-c09b7b99854mr633294766b.10.1782127170393; Mon, 22 Jun 2026
 04:19:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622082224.559980-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260622082224.559980-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 22 Jun 2026 12:18:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7Xfo+=E1D=uxNX=7NsZoeBMKxVdvwd_qwi6-R2McMNzQ@mail.gmail.com>
X-Gm-Features: AVVi8Cd1h36-61byx6tbD0VpZNIjQbehYVGXTuyklf5HJnxbKsZfNSe4NXKJPlw
Message-ID: <CAL3q7H7Xfo+=E1D=uxNX=7NsZoeBMKxVdvwd_qwi6-R2McMNzQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: decentralize transaction aborts in create_reloc_root
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 9:27=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> Decentralize transaction aborts in create_reloc_root(), so that it is
> obvious which call failed and what caused the transaction abort.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  Changes to v1:
>  - don't assign ret in case btrfs_read_tree_root() fails
>
>  fs/btrfs/relocation.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 8cac49fa6f6f..73d9948b5382 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -720,21 +720,19 @@ static struct btrfs_root *create_reloc_root(struct =
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
> -               ret =3D PTR_ERR(reloc_root);
> -               goto abort;
> +               btrfs_abort_transaction(trans, PTR_ERR(reloc_root));
> +               return ERR_CAST(reloc_root);
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
