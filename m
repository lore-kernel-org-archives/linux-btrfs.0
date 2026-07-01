Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7929E43E488
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903544; cv=none; b=aAJYGIeQek6wgB6T2USYmgZbxsu+bWJuRUMrUr9DQayB9sHaFewO83Fceyz3O4RxCEYDRYTrVl8AAV/WAwmk4KFoGb03fiU/iLEU57SsJOPiWXkO6j6B3wP2Ka3zHR/Dyt8het2570JR1SIxl7q564qr40RPBC/tILuFMbxn9BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903544; c=relaxed/simple;
	bh=nAdpL+yuQ7Vr0Nhy/RkNgt6pTzPHZVNTdSrKDnAiPzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y/YuuUmR80JYMfALndSfm62AHmAH4wCD8TO+9LqYUHpVHtAPV1aQqHcb8em9/fGhFWBn5qyXjZOSkHldJ5XwIB+fbeXU+K7Fg9idE6iBojt4d17uhcp/c+dQFENIWCqT8Q73xGMe6+5q0NMYrt/wiWAM3i0iJsHbhzdtxQHdemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YL9T9zn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YL9T9zn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443411F00A3E
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 10:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782903543;
	bh=3kELJSNuxsGmB1ieWjCm6YHVDsZpygA6XAt8LruWdTw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YL9T9zn82XG8DaS1SzkDJME3mJKRb7Fvp+ARMV90keTdEWjgmnqib5rXeu9gfI3KE
	 +FFplqNf4p7FIU42YHgKCuqEyJbcLM6emg+3C1TwZ9DzERAqQpFg5viNYFwpfko8oe
	 I9UdkLGY3Fz0zdTSUnHO8uCUJA7OTAQeuA2zJrkJ0YeE8beost+cwZVE7zXpu17hFe
	 ZLcmS4GY2T9CeY/+/WCgNtJXqTrCMO/dUH4wdvaCXKnut/PhdliLktrfFI99HmKHYM
	 fsRThBJXmI5A73l4OmJUKQWp/nu2WkExMe5WrLso5aCChzByjtMuR6TAC6JMqi6l3m
	 7mdOyHr2vjaYQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c125bce2294so66453066b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 03:59:03 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw9/YixgplOxGozr7hmrwZgsOn8qIws5gJSuslfO/u4KZh1thnH
	SM1mFRb6lZNomxshH/eWbNmhpzpCNI7u5sfboSbaQLNSMEJaVl3lsC4Q+CIzR6OsQL/EdVMb6dV
	AJYI/IuracPkggNqUq7TEVh9hOzDeONY=
X-Received: by 2002:a17:906:46cc:b0:c12:93ed:47dc with SMTP id
 a640c23a62f3a-c12ae7bb5efmr9493466b.40.1782903541963; Wed, 01 Jul 2026
 03:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAL3q7H5jh+e80OM_wKfT6f98j6oCOuYpctf846d0KT98vio48A@mail.gmail.com>
 <20260629210142.457352-1-mssola@mssola.com>
In-Reply-To: <20260629210142.457352-1-mssola@mssola.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 1 Jul 2026 11:58:25 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4nBTXCMZh3ZvO8+LUDDKcs8ZS3jXj6PggV9Px+kYTbKw@mail.gmail.com>
X-Gm-Features: AVVi8CfalnHoRTlzCBVttF80dunflcX2OO1-PUGAu03Q8VLXwXExKO9aRDeprEM
Message-ID: <CAL3q7H4nBTXCMZh3ZvO8+LUDDKcs8ZS3jXj6PggV9Px+kYTbKw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: don't pass tree_id in btrfs_search_path_in_tree()
To: =?UTF-8?B?TWlxdWVsIFNhYmF0w6kgU29sw6A=?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 10:02=E2=80=AFPM Miquel Sabat=C3=A9 Sol=C3=A0 <msso=
la@mssola.com> wrote:
>
> The 'tree_id' parameter in btrfs_search_path_in_tree() was only being
> used in order to fetch the root tree to be considered for the
> search. For this same reason this function was also requiring a 'struct
> btrfs_fs_info' parameter. This commit replaces these two parameters with
> a single 'struct btrfs_root' one, which identifies from which root tree
> the search should happen.
>
> This function only has one caller, the inode lookup ioctl, which knows
> how to provide the root tree for each case. In fact, if args->treeid =3D=
=3D
> 0, then we don't even have to allocate a new root tree object, and we
> can reuse the one provided by the ioctl system call, thus avoiding an
> extra allocation.
>
> Signed-off-by: Miquel Sabat=C3=A9 Sol=C3=A0 <mssola@mssola.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Adding it to for-next, thanks.

> ---
> Changes in v2:
> - Addressed comments by Filipe Manana
> - Link to v1: https://lore.kernel.org/all/20260629142056.309300-1-mssola@=
mssola.com/
>
>  fs/btrfs/ioctl.c | 49 +++++++++++++++++++++---------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1ed16ff4007b..d19867f7eb34 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1664,13 +1664,11 @@ static noinline int btrfs_ioctl_tree_search_v2(st=
ruct btrfs_root *root,
>  }
>
>  /*
> - * Search INODE_REFs to identify path name of 'dirid' directory
> - * in a 'tree_id' tree. and sets path name to 'name'.
> + * Search for an INODE_REF in a 'root' tree which identifies the path na=
me of
> + * 'dirid'. When found, it sets 'name' with the path name.
>   */
> -static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info=
,
> -                               u64 tree_id, u64 dirid, char *name)
> +static noinline int btrfs_search_path_in_tree(struct btrfs_root *root, u=
64 dirid, char *name)
>  {
> -       struct btrfs_root *root;
>         struct btrfs_key key;
>         char *ptr;
>         int ret =3D -1;
> @@ -1692,13 +1690,6 @@ static noinline int btrfs_search_path_in_tree(stru=
ct btrfs_fs_info *info,
>
>         ptr =3D &name[BTRFS_INO_LOOKUP_PATH_MAX - 1];
>
> -       root =3D btrfs_get_fs_root(info, tree_id, true);
> -       if (IS_ERR(root)) {
> -               ret =3D PTR_ERR(root);
> -               root =3D NULL;
> -               goto out;
> -       }
> -
>         key.objectid =3D dirid;
>         key.type =3D BTRFS_INODE_REF_KEY;
>         key.offset =3D (u64)-1;
> @@ -1706,11 +1697,9 @@ static noinline int btrfs_search_path_in_tree(stru=
ct btrfs_fs_info *info,
>         while (1) {
>                 ret =3D btrfs_search_backwards(root, &key, path);
>                 if (ret < 0)
> -                       goto out;
> -               else if (ret > 0) {
> -                       ret =3D -ENOENT;
> -                       goto out;
> -               }
> +                       return ret;
> +               else if (ret > 0)
> +                       return -ENOENT;
>
>                 l =3D path->nodes[0];
>                 slot =3D path->slots[0];
> @@ -1719,10 +1708,8 @@ static noinline int btrfs_search_path_in_tree(stru=
ct btrfs_fs_info *info,
>                 len =3D btrfs_inode_ref_name_len(l, iref);
>                 ptr -=3D len + 1;
>                 total_len +=3D len + 1;
> -               if (ptr < name) {
> -                       ret =3D -ENAMETOOLONG;
> -                       goto out;
> -               }
> +               if (ptr < name)
> +                       return -ENAMETOOLONG;
>
>                 *(ptr + len) =3D '/';
>                 read_extent_buffer(l, ptr, (unsigned long)(iref + 1), len=
);
> @@ -1737,10 +1724,8 @@ static noinline int btrfs_search_path_in_tree(stru=
ct btrfs_fs_info *info,
>         }
>         memmove(name, ptr, total_len);
>         name[total_len] =3D '\0';
> -       ret =3D 0;
> -out:
> -       btrfs_put_root(root);
> -       return ret;
> +
> +       return 0;
>  }
>
>  static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
> @@ -1884,6 +1869,7 @@ static int btrfs_search_path_in_tree_user(struct mn=
t_idmap *idmap,
>  static noinline int btrfs_ioctl_ino_lookup(struct btrfs_root *root,
>                                            void __user *argp)
>  {
> +       bool new_root =3D false;
>         struct btrfs_ioctl_ino_lookup_args AUTO_KFREE(args);
>         int ret =3D 0;
>
> @@ -1897,6 +1883,8 @@ static noinline int btrfs_ioctl_ino_lookup(struct b=
trfs_root *root,
>          */
>         if (args->treeid =3D=3D 0)
>                 args->treeid =3D btrfs_root_id(root);
> +       else
> +               new_root =3D true;
>
>         if (args->objectid =3D=3D BTRFS_FIRST_FREE_OBJECTID) {
>                 args->name[0] =3D 0;
> @@ -1908,9 +1896,14 @@ static noinline int btrfs_ioctl_ino_lookup(struct =
btrfs_root *root,
>                 goto out;
>         }
>
> -       ret =3D btrfs_search_path_in_tree(root->fs_info,
> -                                       args->treeid, args->objectid,
> -                                       args->name);
> +       if (new_root) {
> +               root =3D btrfs_get_fs_root(root->fs_info, args->treeid, t=
rue);
> +               if (IS_ERR(root))
> +                       return PTR_ERR(root);
> +       }
> +       ret =3D btrfs_search_path_in_tree(root, args->objectid, args->nam=
e);
> +       if (new_root)
> +               btrfs_put_root(root);
>
>  out:
>         if (ret =3D=3D 0 && copy_to_user(argp, args, sizeof(*args)))
> --
> 2.54.0
>
