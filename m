Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17025B0B0
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782752792; cv=none; b=OtW4C7ytifthR7QuF3LsIH1RXT12ynnPD3aMrvgI/Nf5HoK5ICNrsX2qMKYcaVuY9ebYusZU/yPyAhRl+AzKrm9vwrlNHV397Q5w4yi4A+RQXssiB/BK7oTVrA8l3eWuQ48kg+mpblfnU49eKkmTTtVKb7VAiXFlWY8SVcolnCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782752792; c=relaxed/simple;
	bh=Al/NND7cCjivilp0IX2LvK1bCDn9xWf19f8i+SGEXCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aC0guUBqgdLSyuw3nkpdDzh9r3TgNCdWCiSX/hNCeXj6N6vWTdE3TLh1mWm4X+P3GhtZWGnXEbVHacDCntaeQedxRJ0b29RdzyUIyU6YAmpseVL6dUKT7Om8IEzKejPOZTiiDmyjoBurLIRhn2yvESChaiES2snJxfnBgxJ1+i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLRU6XjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLRU6XjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177911F00A3E
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782752791;
	bh=56CFrCIiPdn47z2X3rviJHyHR1U8k94eo5nTSKE/KPM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KLRU6XjE7owSkvybevcscys48drt2ICz64kTKWMUNgUwGT6EJy2TOiybtIH3j3AzB
	 lBwSf/KnFZYvH921txoo6eRe3MfDcP6f6ZM3TcSM9m63jr9Juf6cjqtwBVryduGGbt
	 f9CaaRn4p6E2Kqh4dg3uX7l1p067m8oNvA5VuENlDnNOmT3JO5ZNpa/Zu1PfYybHfb
	 l5C9lIsZkq9THYhSJNykoTaYyeg03oqY2jgNIch1/x4cc3tZy5P4kHBs+iuzNBtnm1
	 dFGZr8OYpNiH5Lbau4yNUQdJnD/EK9+t00kMxhG/+eOctBoMhH9O07dRhX9lzQPEw/
	 COw2HASGw4KJw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c126fe7d0f3so121001966b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 10:06:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YyFFWsUCy3Ry34mn11djNDnm930rNUqBGYl6FYtQYTqelhftrNJ
	45cOra5MGwsBj0UtLg/+DFXqu5lxFLlREV10wN+XZwtXC4HnNGDI5PbC8CVvUmrdkNAptm6KI1k
	j4HFz/0XSzZBSCL/3NBNTK+VeA0Ib0k4=
X-Received: by 2002:a17:907:bb42:b0:c12:4055:6c1a with SMTP id
 a640c23a62f3a-c128731fc4amr5062266b.56.1782752789728; Mon, 29 Jun 2026
 10:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629142056.309300-1-mssola@mssola.com>
In-Reply-To: <20260629142056.309300-1-mssola@mssola.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 18:05:52 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5jh+e80OM_wKfT6f98j6oCOuYpctf846d0KT98vio48A@mail.gmail.com>
X-Gm-Features: AVVi8Ce1vhymVLw7ROhSKGncDkCXM090KOPFPSjWeuU3w75Mp8hy7aSIIe85ZRk
Message-ID: <CAL3q7H5jh+e80OM_wKfT6f98j6oCOuYpctf846d0KT98vio48A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: don't pass tree_id in btrfs_search_path_in_tree()
To: =?UTF-8?B?TWlxdWVsIFNhYmF0w6kgU29sw6A=?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 5:29=E2=80=AFPM Miquel Sabat=C3=A9 Sol=C3=A0 <mssol=
a@mssola.com> wrote:
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
> ---
>  fs/btrfs/ioctl.c | 54 ++++++++++++++++++++++--------------------------
>  1 file changed, 25 insertions(+), 29 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1ed16ff4007b..00897a66187c 100644
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
> @@ -1682,7 +1680,7 @@ static noinline int btrfs_search_path_in_tree(struc=
t btrfs_fs_info *info,
>         BTRFS_PATH_AUTO_FREE(path);
>
>         if (dirid =3D=3D BTRFS_FIRST_FREE_OBJECTID) {
> -               name[0]=3D'\0';
> +               name[0] =3D '\0';

Please don't make changes like this. We don't fix indentation/spacing
on lines we don't change.

>                 return 0;
>         }
>
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

If any of the 'if' statements below execute a 'goto out' before
btrfs_get_fs_root() is called, then under 'out' we call
btrfs_put_root() when we shouldn't...
>
>         if (args->objectid =3D=3D BTRFS_FIRST_FREE_OBJECTID) {
>                 args->name[0] =3D 0;
> @@ -1908,13 +1896,21 @@ static noinline int btrfs_ioctl_ino_lookup(struct=
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
> +               if (IS_ERR(root)) {
> +                       ret =3D PTR_ERR(root);
> +                       new_root =3D false;
> +                       goto out;
> +               }
> +       }
> +       ret =3D btrfs_search_path_in_tree(root, args->objectid, args->nam=
e);
>
>  out:
>         if (ret =3D=3D 0 && copy_to_user(argp, args, sizeof(*args)))
>                 return -EFAULT;

If we return -EFAUT we leak the root when new_root is true.

Thanks.

> +       if (new_root)
> +               btrfs_put_root(root);
>
>         return ret;
>  }
> --
> 2.54.0
>
>
