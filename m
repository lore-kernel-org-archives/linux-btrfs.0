Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:41495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbeHIIEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 04:04:37 -0400
Subject: Re: [PATCH] btrfs: qgroup: Always remove all qgroup relation in
 btrfs_remove_qgroup()
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533787467.git.misono.tomohiro@jp.fujitsu.com>
 <3efcb82a-5fcb-4d20-1ab9-5d03bbc6b999@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dae991e9-80b5-8e53-26f1-5bdb01e7e142@gmx.com>
Date: Thu, 9 Aug 2018 13:41:18 +0800
MIME-Version: 1.0
In-Reply-To: <3efcb82a-5fcb-4d20-1ab9-5d03bbc6b999@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eiX4MQTjbHlul72O0XA81ElJHxeK5sh0s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eiX4MQTjbHlul72O0XA81ElJHxeK5sh0s
Content-Type: multipart/mixed; boundary="W09cuT848Yh4p6Qfgr2QdDK1FYyCaoL11";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <dae991e9-80b5-8e53-26f1-5bdb01e7e142@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Always remove all qgroup relation in
 btrfs_remove_qgroup()
References: <cover.1533787467.git.misono.tomohiro@jp.fujitsu.com>
 <3efcb82a-5fcb-4d20-1ab9-5d03bbc6b999@jp.fujitsu.com>
In-Reply-To: <3efcb82a-5fcb-4d20-1ab9-5d03bbc6b999@jp.fujitsu.com>

--W09cuT848Yh4p6Qfgr2QdDK1FYyCaoL11
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/9/18 12:10 PM, Misono Tomohiro wrote:
> In btrfs_remove_qgroup(), each qgroup relation is removed by calling
> __del_qgroup_relation(). However, __del_qgroup_relation() returns 1
> if deletion of qgroup relation causes inconsistency and current code
> exits immediately  in that case.
>=20
> Therefore if there are several qgroup relations and removing first
> relation causes inconsistency, remaining items will not be removed.
>=20
> Fix this by continuing to remove items if return value of
> __del_qgroup_relation() is 1.
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Indeed we still need to remove all qgroup relationship even we will make
qgroup inconsistent.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/qgroup.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 2ba29f0609d9..f18284253e77 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1428,12 +1428,21 @@ int btrfs_remove_qgroup(struct btrfs_trans_hand=
le *trans, u64 qgroupid)
>  		goto out;
> =20
>  	while (!list_empty(&qgroup->groups)) {
> +		int ret2;
> +
>  		list =3D list_first_entry(&qgroup->groups,
>  					struct btrfs_qgroup_list, next_group);
> -		ret =3D __del_qgroup_relation(trans, qgroupid,
> +		ret2 =3D __del_qgroup_relation(trans, qgroupid,
>  					    list->group->qgroupid);
> -		if (ret)
> -			goto out;
> +		if (ret2) {
> +			ret =3D ret2;
> +			/*
> +			 * __del_qgroup_relation() returns 1 if qgroup becomes
> +			 * inconsistent. Continue to remove items in that case.
> +			 */
> +			if (ret !=3D 1)
> +				goto out;
> +		}
>  	}
> =20
>  	spin_lock(&fs_info->qgroup_lock);
>=20


--W09cuT848Yh4p6Qfgr2QdDK1FYyCaoL11--

--eiX4MQTjbHlul72O0XA81ElJHxeK5sh0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltr0/4ACgkQwj2R86El
/qjovAf8C2DuibN2hKJ4790oj2OU76xSj1Sdz3d+46YPSqEN/vyV0NBU9/SIkX4i
OdQNIY+tULk94U0KSi+pWZsCa8UKR/KaSkxQ3bukoptwdzbsifkQo7DrK8zZvOXy
VBcS/9lKB5lQjchv7aQVNsCTzVysB97tyDs/mpcgaPn9hbSoj1G+WcWBmf2A0jvb
przG+dQqbHsSM88J1MHNzYYEhndw9l2o7FdqL0ajqAx7yVWF35Nmej+lb9HOwWBa
BTG1TmWHIoz88n0ZJTEzSFmW974Q3/eeHpTNZFHXtFVrVU6RacJxjG2qbcR76EA6
Oz/Qdud6FhvYyHxY03E+ILqQe+rBrA==
=kb5B
-----END PGP SIGNATURE-----

--eiX4MQTjbHlul72O0XA81ElJHxeK5sh0s--
