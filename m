Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57397 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752299AbeEOHiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:38:24 -0400
Subject: Re: [PATCH v2 2/3] btrfs-progs: lowmem: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
 <20180515013324.18838-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <72f90dd2-5a17-12c2-b87d-53acd0d3e78f@gmx.com>
Date: Tue, 15 May 2018 15:38:04 +0800
MIME-Version: 1.0
In-Reply-To: <20180515013324.18838-3-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9sjZ1K81UYTukIJXXyTBoFjJk5J6r05UK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9sjZ1K81UYTukIJXXyTBoFjJk5J6r05UK
Content-Type: multipart/mixed; boundary="6NQ6bo7NBZBc68rIjMh4rtDwQeKtI22pT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <72f90dd2-5a17-12c2-b87d-53acd0d3e78f@gmx.com>
Subject: Re: [PATCH v2 2/3] btrfs-progs: lowmem: check symlinks with
 append/immutable flags
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
 <20180515013324.18838-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180515013324.18838-3-suy.fnst@cn.fujitsu.com>

--6NQ6bo7NBZBc68rIjMh4rtDwQeKtI22pT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8815=E6=97=A5 09:33, Su Yue wrote:
> Define new error bit INODE_FLAGS_ERROR to represents invalid inode
> flags error.
>=20
> Symlinks should never have append/immutable flags set.
> While checking inodes, if found a symlink with append/immutable
> flags, report and record the inode flags error.
>=20
> This is for lowmem mode.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 10 ++++++++++
>  check/mode-lowmem.h |  1 +
>  2 files changed, 11 insertions(+)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 9890180d1d3c..f598bc364de4 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2274,6 +2274,7 @@ static int check_inode_item(struct btrfs_root *ro=
ot, struct btrfs_path *path)
>  	struct btrfs_key last_key;
>  	u64 inode_id;
>  	u32 mode;
> +	u64 flags;
>  	u64 nlink;
>  	u64 nbytes;
>  	u64 isize;
> @@ -2307,10 +2308,19 @@ static int check_inode_item(struct btrfs_root *=
root, struct btrfs_path *path)
>  	isize =3D btrfs_inode_size(node, ii);
>  	nbytes =3D btrfs_inode_nbytes(node, ii);
>  	mode =3D btrfs_inode_mode(node, ii);
> +	flags =3D btrfs_inode_flags(node, ii);
>  	dir =3D imode_to_type(mode) =3D=3D BTRFS_FT_DIR;
>  	nlink =3D btrfs_inode_nlink(node, ii);
>  	nodatasum =3D btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
> =20
> +	if (mode & BTRFS_FT_SYMLINK &&
> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND)) {
> +		err |=3D INODE_FLAGS_ERROR;
> +		error(
> +"symlinks must never have immutable/append flags set, root %llu inode =
item %llu flags %llu may be corrupted",
> +		      root->objectid, inode_id, flags);
> +	}
> +
>  	while (1) {
>  		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
>  		ret =3D btrfs_next_item(root, path);
> diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
> index e7ba62e2413e..91f7b6b1db53 100644
> --- a/check/mode-lowmem.h
> +++ b/check/mode-lowmem.h
> @@ -44,6 +44,7 @@
>  #define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalcu=
lated */
>  #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting erro=
r */
>  #define FATAL_ERROR             (1<<22) /* Fatal bit for errno */
> +#define INODE_FLAGS_ERROR	(1<<23) /* Invalid inode flags */
> =20
>  /*
>   * Error bit for low memory mode check.
>=20


--6NQ6bo7NBZBc68rIjMh4rtDwQeKtI22pT--

--9sjZ1K81UYTukIJXXyTBoFjJk5J6r05UK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr6jlwACgkQwj2R86El
/qgAlAf8CqMaIZhq8OYaQ017uDefX4BsZAGSt7sV5s+66IjCJK8Nv6iVXn8OHb8W
Eg1YqECB+/41CG1q2ehzo/oRBNBmM3B1H3XafMiK3GdS54BEggxJxTCPUcPxMhgT
cgU+2haPbvQZ/ekeSygQd/Bc4LT+KbN1nWAZDQWFUQFbSFTRyxi7M2QiUKVJXaIH
R4QE/XT6n83k5GQgB4+LWc8L1OYUCkrdUeYHbj8RRe+c4U4GkuIej/xUQQO9x9kg
mAw9H629KJC2fjQoXzJGI9jAtycSp4FsdXPozjhwA9pCgo7CfHcE8X0tm+x8UPSu
hxWOUKREJLjvxRtPgc25Rf7ojJXcHA==
=doY/
-----END PGP SIGNATURE-----

--9sjZ1K81UYTukIJXXyTBoFjJk5J6r05UK--
