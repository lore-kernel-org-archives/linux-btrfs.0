Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934395AbeEJAfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 20:35:09 -0400
Subject: Re: [PATCH] btrfs: return original error code when failing from
 option parsing
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>
Date: Thu, 10 May 2018 08:34:52 +0800
MIME-Version: 1.0
In-Reply-To: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CN3jjalmrB7cTM9Ie3cWaysnqFtgpukPf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CN3jjalmrB7cTM9Ie3cWaysnqFtgpukPf
Content-Type: multipart/mixed; boundary="V09rORYOrQg7wvgTFTH3Mom6xJfB37PEd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chengguang Xu <cgxu519@gmx.com>, clm@fb.com, jbacik@fb.com,
 dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5f5d8691-d7d4-e224-dc4b-e7808ae75a45@gmx.com>
Subject: Re: [PATCH] btrfs: return original error code when failing from
 option parsing
References: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1525871303-87198-1-git-send-email-cgxu519@gmx.com>

--V09rORYOrQg7wvgTFTH3Mom6xJfB37PEd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8809=E6=97=A5 21:08, Chengguang Xu wrote:
> It's no good to overwrite -ENOMEM using -EINVAL when failing
> from mount option parsing, so just return original error code.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/super.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 0628092..ae6447d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1783,7 +1783,6 @@ static int btrfs_remount(struct super_block *sb, =
int *flags, char *data)
> =20
>  	ret =3D btrfs_parse_options(fs_info, data, *flags);
>  	if (ret) {
> -		ret =3D -EINVAL;
>  		goto restore;
>  	}
> =20
>=20


--V09rORYOrQg7wvgTFTH3Mom6xJfB37PEd--

--CN3jjalmrB7cTM9Ie3cWaysnqFtgpukPf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrzk6wACgkQwj2R86El
/qiQeQgAnMC4hY86f/Fd8xf0u1y4s60VCaHu8j6UO5ofNwI2hqlEteTPp6DO5shJ
wBJ5WRI+IEzdNGxDszFXCdYt8ai/twr6SYRECnnB0Lo3Oya8gSnuV0J1axSY9WGz
WN5a72W3e9kysUvOt8QeTFEg9UhaN7Sh5Of4l583szHXccJI1H/vJXEKovby33pj
7/9jr3Q3ULhfEW90gLAdTwpk3v97dGoW5KDDOL48vGuMpA8EGKQnky4Cfy3NGmE9
nAFiZja/XyUH3W93suBH2dfCPnkTkPQvu1cbBLcXuv8je24xROEeLuczGSa9m0NZ
r6AjuMCJmVJYpSosM0CozNtpFKxssA==
=e8qm
-----END PGP SIGNATURE-----

--CN3jjalmrB7cTM9Ie3cWaysnqFtgpukPf--
