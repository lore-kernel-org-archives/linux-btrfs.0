Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeEUFDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 01:03:09 -0400
Subject: Re: [PATCH] btrfs: Fix to use original error code of
 btrfs_read_fs_root_no_name()
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1526878216.git.misono.tomohiro@jp.fujitsu.com>
 <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <240e2665-d9d0-0b6a-ae66-357108d9d8bb@gmx.com>
Date: Mon, 21 May 2018 13:02:58 +0800
MIME-Version: 1.0
In-Reply-To: <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XexCliw4s4a1OjMc3MPbXc4zOCJT333Bj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XexCliw4s4a1OjMc3MPbXc4zOCJT333Bj
Content-Type: multipart/mixed; boundary="6UqQDQd021Cd5zwIHud27WxFPxd9fGBoL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <240e2665-d9d0-0b6a-ae66-357108d9d8bb@gmx.com>
Subject: Re: [PATCH] btrfs: Fix to use original error code of
 btrfs_read_fs_root_no_name()
References: <cover.1526878216.git.misono.tomohiro@jp.fujitsu.com>
 <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
In-Reply-To: <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>

--6UqQDQd021Cd5zwIHud27WxFPxd9fGBoL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8821=E6=97=A5 12:57, Misono Tomohiro wrote:
> btrfs_read_fs_root_no_name() may return ERR_PTR(-ENOENT) or
> ERR_PTR(-ENOMEM) and therefore search_ioctl() and
> btrfs_search_path_in_tree() should use PTR_ERR() instead of -ENOENT,
> which all other callers of btrfs_read_fs_root_no_name() does.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8f7c1b9a2db7..0f90e68ca512 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2155,7 +2155,7 @@ static noinline int search_ioctl(struct inode *in=
ode,
>  		root =3D btrfs_read_fs_root_no_name(info, &key);
>  		if (IS_ERR(root)) {
>  			btrfs_free_path(path);
> -			return -ENOENT;
> +			return PTR_ERR(root);
>  		}
>  	}
> =20
> @@ -2290,7 +2290,7 @@ static noinline int btrfs_search_path_in_tree(str=
uct btrfs_fs_info *info,
>  	root =3D btrfs_read_fs_root_no_name(info, &key);
>  	if (IS_ERR(root)) {
>  		btrfs_err(info, "could not find root %llu", tree_id);
> -		ret =3D -ENOENT;
> +		ret =3D PTR_ERR(root);
>  		goto out;
>  	}
> =20
>=20


--6UqQDQd021Cd5zwIHud27WxFPxd9fGBoL--

--XexCliw4s4a1OjMc3MPbXc4zOCJT333Bj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsCUwIACgkQwj2R86El
/qgX+gf/dnKjbzQMBeCIZ5CmteULkap92wjPQgQ7sdrvteihaubXCuqvRYj34SPE
DgkQuuWFzW6cqJCEX//zQ662BsbmwqcZ+iD8Jvcpp1pCku8fq1h9pEB5p9X+b0EG
UI8yjoZ2V2hrCIlZg7lRBcdyue90iQ69yS2xiplpFA1b9rSPk3+BHh0l+YcyovO7
UwWF56gxvYSjJ3mrzqlGGG/D8iZ+iQDI+ldL44qj86AtIPJxMHeVwHIiicvEQT8c
Nr419ZrQesHZ1vgp3a3Chi/Lvxh2dazH0+Xv1T5ZpEYMrhHkapis2Z8Zv7Km6LIA
ZJKhg06CDGR45NBN6csafVUsX5l6PA==
=3++r
-----END PGP SIGNATURE-----

--XexCliw4s4a1OjMc3MPbXc4zOCJT333Bj--
