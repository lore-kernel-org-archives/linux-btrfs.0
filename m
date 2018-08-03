Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:35103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbeHCGL5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 02:11:57 -0400
Subject: Re: [PATCH] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e2d0d7fc-8603-7c47-4168-266be4d72edc@gmx.com>
Date: Fri, 3 Aug 2018 12:17:26 +0800
MIME-Version: 1.0
In-Reply-To: <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xTIh192dQcnHesHwnplnbJGrSm6Lb0Zsd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xTIh192dQcnHesHwnplnbJGrSm6Lb0Zsd
Content-Type: multipart/mixed; boundary="AzzegqF0RwQNqBpy4f2e3z80DN0LtpIsA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e2d0d7fc-8603-7c47-4168-266be4d72edc@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
 <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
In-Reply-To: <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>

--AzzegqF0RwQNqBpy4f2e3z80DN0LtpIsA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8803=E6=97=A5 12:08, Misono Tomohiro wrote:
> When qgroup is on, subvolume deletion does not remove qgroup items
> of the subvolume (qgroup info, limits, relation) from quota tree and
> they need to get removed manually by "btrfs qgroup destroy".
>=20
> Since level 0 qgroup cannot be used/inherited by any other subvolume,
> let's remove them automatically when subvolume is deleted.
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
>=20
> I don't see any reason to keep these items after subvolume deletion,
> but is there something I'm missing?
>=20
>  fs/btrfs/inode.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3f51ddc18f98..4ec60a1b53a3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4372,6 +4372,10 @@ int btrfs_delete_subvolume(struct inode *dir, st=
ruct dentry *dentry)
>  		}
>  	}
> =20
> +	ret =3D btrfs_remove_qgroup(trans, dest->root_key.objectid);

According to the caller, it only unlinks the subvolume without really
delete the whole subvolume.

I'm wondering if we should call btrfs_remove_qgroup() only after we have
deleted the whole subvolume, e.g inside btrfs_drop_snapshot().

Thanks,
Qu

> +	if (ret =3D=3D -EINVAL || ret =3D=3D -ENOENT)
> +		ret =3D 0;
> +
>  out_end_trans:
>  	trans->block_rsv =3D NULL;
>  	trans->bytes_reserved =3D 0;
>=20


--AzzegqF0RwQNqBpy4f2e3z80DN0LtpIsA--

--xTIh192dQcnHesHwnplnbJGrSm6Lb0Zsd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltj11YACgkQwj2R86El
/qg1pgf/a7hzQyr1HCPCY6Ouv2FHl3J1UmJ2/JdDs5wa1eE+wcIl9ehNbwL8K84Q
C2jMxekltn4PHD1f7MkhU0cNot14rVhDYQQxq+ZeEaaET/iqJNBIKlLNGKJykZ8F
wk+pMwHgle8TOiwwVHrFYEa3gvMMyZkiuR//Hy80VZEcQvith4AbD/GhuTALqq96
4ilNBlpz15FrJpt5bFRw9ntRkmY1Yep/2+0aUutrVjgl5g9D3nO8fPQIEWzkU259
hza7VdlTkaxsoRkSga0x0WAUX/DeEVIxEaxxQWFSiA8roiI0q5NcpXn3ipOlqr6Y
SKo6nv9EZFrI7K1Iutd/yZa2h6C3cg==
=rwgB
-----END PGP SIGNATURE-----

--xTIh192dQcnHesHwnplnbJGrSm6Lb0Zsd--
