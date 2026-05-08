Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EEB3FB7C0
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778255087; cv=none; b=ChWGtKjuZvP9siKeJZa5BKwShGHBBYYoFxLg/yzDeHbh2ufUnd/3qw703fJpt2KFMARYtWBtdXCgie5zpwMAGUumylIIDoXcF9emQwwWPvuYPsIRG/DFQGub73QE074HKOqrf5ko7IJvzNTryf12KuoPd7aMI41PBiMjfLK65d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778255087; c=relaxed/simple;
	bh=7gBphw59/X4FtODaaFm79Rjv/NbCG+4eRw9EuXPv9gs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jp6YwvYMSHLd4S7rwTXdutQhE6KKIfZU1MIsE7FKgRUUiAJPZx0tcONilTSnReqjO7FXms1uU3300TW7IcwEARHlzJRVXE3tyCUBPc/3Uxq0yQ7lytbgg6V5s+S21ywctTsrRCP5F/h9+B4idE8TOTkKRBbo0qCR6CBojNChjeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCKq/oSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCKq/oSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BE7C2BCC9
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255086;
	bh=7gBphw59/X4FtODaaFm79Rjv/NbCG+4eRw9EuXPv9gs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YCKq/oSc2yOKGQn2P9k9q3+idp9Jl9TaO9TbFeYW5+nFmOnIHqWlxOyIBHSyaqXcy
	 NnSue3hprMGsNOp+d620tdu8NSCLA1ovFgu+CLB8/yQe0DGZ2IhyuRBuxEYJJfTmfv
	 zPEkDrmXJXE9qdhzrCI/XeTPzFYd0sC0efwQf3j18Y/3EaRbzwewbJLQ+MtN/I4mx0
	 N8E00pEcwlreg3jKGKhBE7iojGjbQkPqsb694gUjiQBBYxUckuZ5wV/ZJ2C8JUiHu4
	 RxiTJIKaTvC/xrPG2AEgsJl3WH6qxUS6RsagJmXhhpHqzxY3NMbwxGOxZEFfLIzXES
	 HNCwesFDHqyMg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bca0ff2f8dfso226844266b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2026 08:44:46 -0700 (PDT)
X-Gm-Message-State: AOJu0YzmeR+Y/mFSJijme6dkRETwC2yjiy4DXO62M+TrArdFAnS235xW
	EnjM/yymz+CPtKvkINtKlOCfKha9CtvCjrO5Z0BEa6EVfctodSZI7fqfRG1w+WisK4nDNorUfSO
	/i4pTxqbBEwI8YbJNq0+sUpcd7LS3Q6U=
X-Received: by 2002:a17:906:5187:10b0:bc4:9acf:f53 with SMTP id
 a640c23a62f3a-bc56c62c6d8mr700679866b.20.1778255085432; Fri, 08 May 2026
 08:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508134215.1716255-1-robbieko@synology.com>
In-Reply-To: <20260508134215.1716255-1-robbieko@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 8 May 2026 16:44:07 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4SOdJD=6CWrkpdWwm+FZRDiONTG6HtVgBjDXM8nuGCRA@mail.gmail.com>
X-Gm-Features: AVHnY4JkAPXb0fE9DMEAPXrqT1vp6tFrSDcuijpjO5syLbUSsB9WThfmb8Tn6bc
Message-ID: <CAL3q7H4SOdJD=6CWrkpdWwm+FZRDiONTG6HtVgBjDXM8nuGCRA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: mark file extent range dirty after converting
 prealloc extents
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 2:50=E2=80=AFPM robbieko <robbieko@synology.com> wro=
te:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When writing into a preallocated extent, ordered extent completion calls
> btrfs_mark_extent_written() to convert the file extent item from
> BTRFS_FILE_EXTENT_PREALLOC to BTRFS_FILE_EXTENT_REG.
>
> If the preallocated extent was created beyond i_size with fallocate
> keep-size, and the inode is evicted and loaded again before the write,
> the inode's file_extent_tree is initialized only up to i_size.
>
> The out-of-i_size prealloc extent is therefore not tracked there.
>
> After a write into that extent extends i_size, btrfs_mark_extent_written(=
)
> updates the file extent item, but the corresponding range is not marked
> dirty in the inode's file_extent_tree.
>
> This can leave disk_i_size stale when the filesystem does not use the
> no-holes feature, so after remount the file size can go back to the old
> value.
>
> The following reproducer triggers the problem:
>
>   mkfs.btrfs -f -O ^no-holes $DEV
>   mount $DEV $MNT
>   touch $MNT/file
>   fallocate -n -l 2M $MNT/file
>   umount $MNT
>   mount $DEV $MNT
>   dd if=3D/dev/zero of=3D$MNT/file bs=3D1M count=3D1 conv=3Dnotrunc
>   ls -l $MNT/file
>   umount $MNT
>   mount $DEV $MNT
>   ls -l $MNT/file
>   umount $MNT
>
> Running the reproducer gives the following result:
>
> -rw------- 1 root root 1048576 May  8 21:20 /mnt/file
> -rw------- 1 root root 0 May  8 21:20 /mnt/file
>
> Fix this by marking the written range dirty in file_extent_tree after
> successfully converting the prealloc extent to a regular extent.
>
> Fixes: 9ddc959e802b ("btrfs: use the file extent tree infrastructure")
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

As stated before, don't leave a blank line between the Fixes and SOB tags.

> ---

Following the ---, please describe the changes between v2 and v1 in the fut=
ure.

I've added the patch to the for-next branch on github, with minor
changes to the change log.
Thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>


>  fs/btrfs/file.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index cf1cb5c4db75..8c171ed07008 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -633,7 +633,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_hand=
le *trans,
>                                                          trans->transid);
>                         btrfs_set_file_extent_num_bytes(leaf, fi,
>                                                         end - other_start=
);
> -                       return 0;
> +                       goto mark_dirty;
>                 }
>         }
>
> @@ -661,7 +661,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_hand=
le *trans,
>                                                         other_end - start=
);
>                         btrfs_set_file_extent_offset(leaf, fi,
>                                                      start - orig_offset)=
;
> -                       return 0;
> +                       goto mark_dirty;
>                 }
>         }
>
> @@ -788,7 +788,12 @@ int btrfs_mark_extent_written(struct btrfs_trans_han=
dle *trans,
>                 }
>         }
>
> -       return 0;
> +mark_dirty:
> +       ret =3D btrfs_inode_set_file_extent_range(inode, start, end - sta=
rt);
> +       if (ret)
> +               btrfs_abort_transaction(trans, ret);
> +
> +       return ret;
>  }
>
>  /*
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
