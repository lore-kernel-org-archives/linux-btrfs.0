Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D1D4B515E
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825871; cv=none; b=NZikFNR7ICzYNB/gZ8zrDzT1LrbiiCznWs8c4W5jthV+xN7HqwOwQZr/VjEWgUKu1HRMV+7jMMh6PtL9Bgo48+HbVEOjvezbk6+DWXudUIlyICzGnfOZtMR753PHyNflp9sp5RatXTm65bI+ZlwarOmjzUbZUb9LPLUulL5t0TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825871; c=relaxed/simple;
	bh=6uUyarvi1KS2+TjGc2Yz34oQ3d1m/I4L3PLmnADsSeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjKp385OuSb9CsxRPahFx8aKU+ynGFykyRhA3NDol3q21OLpQwYbeBdVaivDwvPM3Be/tk8ZiQQeJg+Nw0o/q/oyA6CnhZS8qOHLiwlj3Y+/X6pCoIhMU/Er2RH09Mavft49NUYi01KYOeTcNmczZCp9SBFETGDCDhrQqurNGFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmsdSCFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmsdSCFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B65B1F008A1
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791825870;
	bh=Is5cPS2yKzxfEYfxVgeAAlgAXAXS0M93VqGi3blDDT0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UmsdSCFJQfZCi4BAYNMS9Qz3G2Z/X1czFvvnml1y44PE6Vl5RVannOR6XNhkz7ofK
	 JozaOluDTy0fdG9tdbtUlGXLUH9hzTqGruryNZHusoBRXPpwIDp+of5J0k/Vz9nWef
	 lhQURn+qdy6nJ83g/MheJzifMYYyBYHLXrf1IrDwep4emBlG9AO5gMlEK/x8JLbFEw
	 s7hGq7cQg1g2PjvZo1rBXveFmE5QBH8sH0gTcTO6XG3OqqB1wKn+T0jDoOS69387B4
	 +4vixheTjqVnbrDbItxrGbfN5MiwMZk0mAVKP1ptLrvrnMU8TG4EL7RCEAIbCI4tFp
	 Hk0t7QaiztUgg==
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-98c67e94e53so5075916241.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 10:24:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwWQP7sQYYyxfZiPrqb2kso4SQQ1naw0rUbucX4E3EW9rGBW2l7hvslm/VhU29E3DtfTdknXDV7pojF2w==@vger.kernel.org
X-Gm-Message-State: AFq9FYJE3EspUcxUjxAm2ppqOsda4ojF0b6MPMMq+7CLZyLJ5Vy4XbHY
	d0cy5/ZSA+oMdr8DtrmLXTGJqQhXwENnFlV8ZNORRQtubHJAW3Q5OH6WWTuVKG398u627UheYM1
	LGqGCDloa3A+e7EAUAXQaOFxJkxIpgNk=
X-Received: by 2002:a05:6102:61c1:b0:7c2:e5bb:d20c with SMTP id
 ada2fe7eead31-7cb3a0bfa9emr1601031137.34.1791825869540; Mon, 12 Oct 2026
 10:24:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011155815.1563812-1-hengyul@cs.unc.edu>
In-Reply-To: <20261011155815.1563812-1-hengyul@cs.unc.edu>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 12 Oct 2026 18:23:52 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5UxcZpzBU0S0oyQZBV3pNO7joA7eqz35zHFV25xLHHyw@mail.gmail.com>
X-Gm-Features: AclHuK_fpopgt0MdFZwKdSAYVCBO8z-d-IgdViLTsaNBsfdq5oCQdSJ1EtM9TbM
Message-ID: <CAL3q7H5UxcZpzBU0S0oyQZBV3pNO7joA7eqz35zHFV25xLHHyw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix chattr failing on nodatasum files that have
 the compress flag
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 4:58=E2=80=AFPM Hengyu Liang <hengyul@cs.unc.edu> w=
rote:
>
> Commit cf1afec09e9f ("btrfs: validate properties before setting them")
> made btrfs_set_prop() validate a property before setting it. For the
> compression property, the validation fails with -EINVAL when the inode
> has NODATASUM.
>
> However, chattr writes back all the flags it read from the file, and
> btrfs_fileattr_set() sets the compression property whenever the new
> flags include FS_COMPR_FL, even when the compression flags do not
> change. A file created on a filesystem mounted with nodatasum has
> NODATASUM and still inherits the compress flag from its directory. As
> of now, chattr fails on such a file when it changes any other flag.
>
> The issue can be reproduced with:
>
>     mkfs.btrfs -f /dev/sdb
>     mount -o nodatasum /dev/sdb /mnt
>     mkdir /mnt/dir
>     chattr +c /mnt/dir
>     touch /mnt/dir/file
>     chattr +A /mnt/dir/file
>
> Before commit cf1afec09e9f ("btrfs: validate properties before setting
> them"), the last command succeeds.
>
> After that commit, it fails with EINVAL.
>
> This patch will make btrfs_fileattr_set() leave the compression flags
> and the compression property alone when the call changes neither
> FS_COMPR_FL nor FS_NOCOMP_FL.
>
> Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
> Cc: stable@vger.kernel.org # 7.2+
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Assisted-by: LLM
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Pushed to the for-next github branch, thanks.

> ---
> Changelog
> v2:
> - Do not test whether the inode can be compressed. Leave the compression
>   flags and the property alone when the call does not change them, as
>   suggested by Qu Wenruo. Setting the compress flag on a NODATASUM inode
>   still fails with -EINVAL.
>
> - In the failing call FS_COMPR_FL is set, because chattr writes back the
>   flags it read. A test for "neither FS_NOCOMP_FL nor FS_COMPR_FL is
>   set" does not catch it and would stop chattr -c from removing the
>   flag, so the check compares the old and the new flags.
>
> - Explain why the call fails.
>
> v1:
> https://lore.kernel.org/linux-btrfs/20261010105425.165104-1-hengyul@cs.un=
c.edu/
>
>  fs/btrfs/ioctl.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 52aab510aea0..43a945345cbe 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -375,6 +375,19 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>                 }
>         }
>
> +       /*
> +        * Callers write back the whole flag set, so only touch the compr=
ession
> +        * flags and the compression property if FS_COMPR_FL or FS_NOCOMP=
_FL
> +        * changes.
> +        */
> +       if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
> +               /* 1 item for the inode */
> +               trans =3D btrfs_start_transaction(root, 1);
> +               if (IS_ERR(trans))
> +                       return PTR_ERR(trans);
> +               goto update_flags;
> +       }
> +
>         /*
>          * The COMPRESS flag can only be changed by users, while the NOCO=
MPRESS
>          * flag may be changed automatically if compression code won't ma=
ke
> --
> 2.53.0
>
>
