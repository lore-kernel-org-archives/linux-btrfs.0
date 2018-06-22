Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55853 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750931AbeFVGMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 02:12:14 -0400
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <20180622025816.29239-1-cgxu519@gmx.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
Date: Fri, 22 Jun 2018 13:59:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180622025816.29239-1-cgxu519@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9iT8Hxj13Yu0Gap5f2QRRsZyZM0p2uwvX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9iT8Hxj13Yu0Gap5f2QRRsZyZM0p2uwvX
Content-Type: multipart/mixed; boundary="qfZDsA7IVHdez2FslmuYoNWIpCojBhlTU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
 dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <88554c7b-f495-0295-574f-094a5181d9f1@gmx.com>
Subject: Re: [PATCH] btrfs: treat -ERANGE as an error case in btrfs_get_acl()
References: <20180622025816.29239-1-cgxu519@gmx.com>
In-Reply-To: <20180622025816.29239-1-cgxu519@gmx.com>

--qfZDsA7IVHdez2FslmuYoNWIpCojBhlTU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8822=E6=97=A5 10:58, Chengguang Xu wrote:
> Currently, when encoutering -ERANGE in btrfs_get_acl(),
> just set acl to NULL so that we cannot get proper
> acl information but the operation looks successful.
>=20
> This patch treats -ERANGE as an error case and meanwhile
> print real errno before translating errno to -EIO.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/btrfs/acl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 15e1dfef56a5..7b3a83dd917c 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -42,9 +42,10 @@ struct posix_acl *btrfs_get_acl(struct inode *inode,=
 int type)
>  	}
>  	if (size > 0) {
>  		acl =3D posix_acl_from_xattr(&init_user_ns, value, size);
> -	} else if (size =3D=3D -ERANGE || size =3D=3D -ENODATA || size =3D=3D=
 0) {
> +	} else if (size =3D=3D -ENODATA || size =3D=3D 0) {
>  		acl =3D NULL;
>  	} else {
> +		pr_err_ratelimited("BTRFS: get acl failed, err=3D%d\n", size);

Is there any special reason to output this message even it's rate limited=
?
This looks much like a debug output, no to mention we have
btrfs_err/warn/info() wrapper to output with proper fs UUID.

>  		acl =3D ERR_PTR(-EIO);

in fact we should let @acl to contain the correct error code from
btrfs_getxattr(), other than overriding it with -EIO.

Thanks,
Qu

>  	}
>  	kfree(value);
>=20


--qfZDsA7IVHdez2FslmuYoNWIpCojBhlTU--

--9iT8Hxj13Yu0Gap5f2QRRsZyZM0p2uwvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsskFsACgkQwj2R86El
/qh8aAf+P9aIKeIfADhxmzrrjbYH7faBKWdPua543JYtOpNBVwZ7dST8BZVXIIIN
VPKkdLpsNFerAVNHHaIqNGb8XEvDKPEnY62z4stfoeKnhzDFk0flwQ30fOgkMsw2
mQl2P3vGI9clLBNq3L8JuRi1KbpymNpM4iSmYG3sROiJnIT4jAujC9o12w5fGx/m
iQTCouJ/qLZs2Y+o1CvFX2yljlUfEOsUeD4CT9eU5Kywz8hqSf/QJOo6zCuILjjM
fHtqWp1YINF4VWnAQlgrKfRE0kdmQZk3mDFpgWclXVL4Szx8Tkrmj9mmGnH0aQJS
so/OkeiFSnKrl3jilNuYsnT43+A/bQ==
=7CkE
-----END PGP SIGNATURE-----

--9iT8Hxj13Yu0Gap5f2QRRsZyZM0p2uwvX--
