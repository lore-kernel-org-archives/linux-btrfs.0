Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdLEIan (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:30:43 -0500
Subject: Re: [PATCH] btrfs/124: add balance --full-balance option
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <20171205082628.1676-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
Date: Tue, 5 Dec 2017 16:30:33 +0800
MIME-Version: 1.0
In-Reply-To: <20171205082628.1676-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GACfqBhj4xmo5fpxXFFRuKvB7dErjUpeG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GACfqBhj4xmo5fpxXFFRuKvB7dErjUpeG
Content-Type: multipart/mixed; boundary="Dv3rMDqt00lTPx3B6Ehf6AJ98ovi94pC9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Message-ID: <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
Subject: Re: [PATCH] btrfs/124: add balance --full-balance option
References: <20171205082628.1676-1-anand.jain@oracle.com>
In-Reply-To: <20171205082628.1676-1-anand.jain@oracle.com>

--Dv3rMDqt00lTPx3B6Ehf6AJ98ovi94pC9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:26, Anand Jain wrote:
> btrfs balance needs --full-balance option since 4.6, so check the
> version and then use it.
>=20
> As this may be useful for other btrfs tests as well, so this patch
> adds _btrfs_full_balance_option() to the common/btrfs file.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  common/btrfs    | 13 +++++++++++++
>  tests/btrfs/124 |  3 ++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/common/btrfs b/common/btrfs
> index c09206c6f292..8ca6486b26dc 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -356,3 +356,16 @@ _btrfs_compression_algos()
>  		echo "${feature#/sys/fs/btrfs/features/compress_}"
>  	done
>  }
> +
> +#btrfs-progs adds required --full-balance option since v4.6 so check f=
or
> +#that and then return the required option.
> +_btrfs_full_balance_option()
> +{
> +	ver=3D$($BTRFS_UTIL_PROG --version|awk '{print $2}'|cut -d"-" -f1 | c=
ut -d"v" -f2)

I'm never a fan of version check.
Backporting or modified package version can easily screw this up.

Why not directly checking the help message of "btrfs balance start"?

Thanks,
Qu

> +	tup1=3D$(echo $ver| cut -d"." -f1)
> +	tup2=3D$(echo $ver| cut -d"." -f2)
> +
> +	RET=3D""
> +	(("$tup1" > "4")) && RET=3D"--full-balance"
> +	(("$tup1" =3D=3D "4")) && (("tup2" >=3D "6")) && RET=3D"--full-balanc=
e"
> +}
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> index a6486270a972..ec1d24b5ef42 100755
> --- a/tests/btrfs/124
> +++ b/tests/btrfs/124
> @@ -129,7 +129,8 @@ _run_btrfs_util_prog device scan
>  _scratch_mount >> $seqres.full 2>&1
>  _run_btrfs_util_prog filesystem show
>  echo >> $seqres.full
> -_run_btrfs_util_prog balance start ${SCRATCH_MNT}
> +_btrfs_full_balance_option
> +_run_btrfs_util_prog balance start $RET ${SCRATCH_MNT}
> =20
>  checkpoint2=3D`md5sum $SCRATCH_MNT/tf2`
>  echo $checkpoint2 >> $seqres.full 2>&1
>=20


--Dv3rMDqt00lTPx3B6Ehf6AJ98ovi94pC9--

--GACfqBhj4xmo5fpxXFFRuKvB7dErjUpeG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomWSkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhuJwgAsQiMgv9AUlWKYJr455yXvvpv
/1yQWnEP3mHEeBLuyvUJJuCzctESi4vTEqxut9vpHJ5wkoUIabrZlYLXVxVKrDBk
nHkmJ/V9AKsJJq9MTvyjg/ntZLodDtiK213v1nXf1xNRChM+W6COd+306wQY+Vvr
4ofNd+mF+nTfdCl0vBiN850pNi4n2KCYBqMN1XyC6J4K4NXIwNNJMC2TKNOMdgIL
CkW9WuEG5P6MPQ4qXIra6i36HuptBmZCPhyGYe8Mbz/HfPiFGNLIBiGFWQ9d4P54
C+qfgHwQ+aO7Xy9az1bViJbcZfnsKcEPvfJ7kIJA5a7tn9eV7NkUhtBhmx+O4Q==
=RTlc
-----END PGP SIGNATURE-----

--GACfqBhj4xmo5fpxXFFRuKvB7dErjUpeG--
