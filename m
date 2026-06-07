Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C12229B8CF
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780822148; cv=none; b=soJ0gXLmmKB/BdSK85Zf3BUMm2ZL+Gdf9a08W16X/3mUDF5dN7y0cyw5GVIQqqfp4giQzj9johZy1qYqn0JaIh4iNfHcsngGVvonJWDonq7ZGv6uO4GRrulxCVxMgmZIH3M+fpDaQyDiv2alvEluca/mjPj1foIrKA565FoOtoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780822148; c=relaxed/simple;
	bh=+SGY3v0UZ3G8RnYaLx613JJUPWG/3XZZMKoKozsfptk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qicIpbpICb/w80LLpH++4hbuS0qFF0+wS5Q10f10C8VL3kkxEJMKCJ2q+dtr7nShCbMFDZNxAnu0eh+OYeYYvXpi4PTw2BOX+m12XQt9cpmqmxs3cOjcSThzW6jcUPeQc0Vje0XSs0pvA8BZO12avPjoWlI8fAyFxzA0Jzj5Gqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5CQEiuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5CQEiuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001051F00899
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 08:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780822146;
	bh=/qZ8vp+PAXmJWUDXQnWf/ge5RVwCxXqwq1hM3K6nX0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O5CQEiuIp2XySOBdLndlm0PvZJvyo5tFbFEMpSRARMGb4wRPdB5jtf+zIJVvGF8QT
	 ntCoLYaODD+7x8IajrWFbwWXQhSbYy3JWCmAHwIUk7S2xWs7s/tWo1f1jzWjWKxYcX
	 2sp0vD4sjunmb0BBaThNgD2YImHaI/COr+EXMIMyVq1oxTLpJSyBMiGoSmL490q5h9
	 2tMhMjPCgVn2pYM1m3N9YwizApC3fq8pdSiUx/LeEQullNNZAtMWp3SBD7lTNbvXVX
	 DYaMBP9wfe768AEWSBLI8meY6DvZRVr7Kn2eo0kufgS9bHuC+/UXgSP+iIU9+T2p/c
	 8ALL9fEoj34gw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec429c2bb1so474373566b.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2026 01:49:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/fE0PqqUSXJ7PT03xJTaT+Lz5VqNarX66YKwgaSJ0/1ejWXZGETAJNJFFH6qzywfdoKGN+6al9k1JbCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDbMc/wEtOVFtbe0TyK43u56/S7ySYFed/cyGkcjRDnze7nhdy
	O265FVNIUpCwUz6r14G8WhffDarGo6uq0jbXRfedovnP+DnkeQ5m1Be2v3O9WWOocEVgGecRq0v
	TEzq9Q7lF4LVTHuS89NLVOffR1ia3WL0=
X-Received: by 2002:a17:907:1c16:b0:bed:e0b:5b0d with SMTP id
 a640c23a62f3a-bf370867ed0mr466927366b.13.1780822144568; Sun, 07 Jun 2026
 01:49:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260607053441.1629853-1-yun.zhou@windriver.com>
In-Reply-To: <20260607053441.1629853-1-yun.zhou@windriver.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sun, 7 Jun 2026 09:48:27 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6m1yUdnHoUNCoUt3jHQ9yy=ZEzpShnSUQHM1cexfFD2g@mail.gmail.com>
X-Gm-Features: AVVi8CcQs8frB-ApIDCp5qkgbxGhMF3U5CxxbxHGuXZDtensbcJpogc77w2yUj0
Message-ID: <CAL3q7H6m1yUdnHoUNCoUt3jHQ9yy=ZEzpShnSUQHM1cexfFD2g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix use-after-free of reloc_control in btrfs_reloc_cow_block
To: Yun Zhou <yun.zhou@windriver.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 7, 2026 at 6:36=E2=80=AFAM Yun Zhou <yun.zhou@windriver.com> wr=
ote:
>
> btrfs_reloc_cow_block() reads fs_info->reloc_ctl without holding any
> lock and then uses the obtained rc pointer throughout the function
> (including replace_file_extents which may sleep). Meanwhile, the
> balance error path can concurrently call unset_reloc_control() followed
> by free_reloc_control(), freeing rc while btrfs_reloc_cow_block() is
> still using it.
>
> The race window exists because btrfs_commit_current_transaction() in
> relocate_block_group() may return immediately when the filesystem is in
> error state (no running transaction to wait for), allowing
> free_reloc_control() to execute while other threads still hold
> references to rc obtained before unset_reloc_control().
>
> Fix this by adding a btrfs_commit_current_transaction() call in
> btrfs_relocate_block_group() right before free_reloc_control(). This
> ensures that any concurrent thread that obtained rc via reloc_ctl
> (which requires being in a transaction context) has completed its
> transaction before rc is freed.
>
> Reported-by: syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D0eea49bba18051dea35e
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>  fs/btrfs/relocation.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 3ebaf5880125..a01262d0b2ab 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5443,6 +5443,14 @@ int btrfs_relocate_block_group(struct btrfs_fs_inf=
o *fs_info, u64 group_start,
>         reloc_chunk_end(fs_info);
>  out_put_bg:
>         btrfs_put_block_group(bg);
> +       /*
> +        * Ensure no concurrent btrfs_reloc_cow_block() is still using rc=
.
> +        * After unset_reloc_control() new callers will see reloc_ctl =3D=
=3D NULL
> +        * and return immediately. But callers that read reloc_ctl before=
 unset
> +        * are still in a transaction. Wait for the current transaction t=
o
> +        * complete so all such callers have finished using rc.
> +        */
> +       btrfs_commit_current_transaction(fs_info->tree_root);

This does not work at all:

btrfs_commit_current_transaction() can not join the current
transaction if the fs is in error state.
start_transaction() will return immediately with -EROFS if a
transaction abort happened before.

Second, the rc structure points to the block group for which the put
was done just above, so there's a potential for another use-after-free
here.

Finally, always calling btrfs_commit_current_transaction() creates
unnecessary overhead when no errors occur (the expected case).
This is due not only to the IO involved, but also because it results
in an unnecessary rotation of the backup roots in the super block.

Finally there's a similar race in btrfs_init_reloc_root() too.

And there's already a proper way to fix this in progress:

https://lore.kernel.org/linux-btrfs/3d57517e6e8ace7f1294277b0f03baa1150be55=
c.1780677297.git.fdmanana@suse.com/

Thanks.


>         free_reloc_control(rc);
>         return ret;
>  }
> --
> 2.43.0
>
>
