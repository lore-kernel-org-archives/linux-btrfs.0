Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52971 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdK3GiS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:38:18 -0500
Subject: Re: [PATCH v3 2/3] btrfs-progs: fi defrag: do not exit if defrag
 range ioctl is unsupported
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>
Date: Thu, 30 Nov 2017 14:37:31 +0800
MIME-Version: 1.0
In-Reply-To: <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="URSUUGm6M1wV3f31BDBIXBLQbWHJi5R1g"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--URSUUGm6M1wV3f31BDBIXBLQbWHJi5R1g
Content-Type: multipart/mixed; boundary="u9gDotrjgcSuORoKBLagBH5txwR4lxs2R";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Message-ID: <357c50d7-d69b-8bfa-fda3-4449466707ba@gmx.com>
Subject: Re: [PATCH v3 2/3] btrfs-progs: fi defrag: do not exit if defrag
 range ioctl is unsupported
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>

--u9gDotrjgcSuORoKBLagBH5txwR4lxs2R
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8829=E6=97=A5 10:12, Su Yue wrote:
> If ioctl of defrag range is unsupported, defrag will exit immediately.
>=20
> Since caller can handle the error, let cmd_filesystem_defrag()
> close file, break the loop and return error instead of calling exit(1).=

>=20
> Suggested-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changelog:
> v2:	Separate the patch from commit 6e991b9161fa ("btrfs-progs: fi
> 	defrag: clean up duplicate code if find errors").
> v3:	Call close_file_or_dir() before breaking the loop.
> ---
>  cmds-filesystem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 17d399d58adf..232d4e88e0c0 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -1049,8 +1049,10 @@ static int cmd_filesystem_defrag(int argc, char =
**argv)
>  		if (recursive && S_ISDIR(st.st_mode)) {
>  			ret =3D nftw(argv[i], defrag_callback, 10,
>  						FTW_MOUNT | FTW_PHYS);
> -			if (ret =3D=3D ENOTTY)
> -				exit(1);
> +			if (ret =3D=3D ENOTTY) {
> +				close_file_or_dir(fd, dirstream);
> +				break;
> +			}
>  			/* errors are handled in the callback */
>  			ret =3D 0;
>  		} else {
>=20


--u9gDotrjgcSuORoKBLagBH5txwR4lxs2R--

--URSUUGm6M1wV3f31BDBIXBLQbWHJi5R1g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofpywXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjGywf/ZooeLRe+3ayo8wj2IXJ6OzB4
rqr9r94/8oPToHyMCWvtf4n2fgw+/wyquiMUxKJ5KplOVWnVruw6KIjenvpBY+D9
Hda9eV/x5UGu5NeB5LfCmF/rXfp7fFMOlLzyTbXO6PcnywhSa6xvzP9myIk+axZb
nF2Zn4FLzWXEIIIb1EcF8nBskaMr1cZAGjbpQvsO8o63ISmsKvrIZSXVhd0u57uo
LoH3vvQ1W41OMpVYX9ew+gmBaQbDE1qAjevWH9XZCZgmA6QZ43OagyglWKWCcHIo
OOXpiaCcMyD00s8O0tI6y+lVxTt4khrdmGtjQmnKk+506y/ufe5osZt8EXyMog==
=v8QM
-----END PGP SIGNATURE-----

--URSUUGm6M1wV3f31BDBIXBLQbWHJi5R1g--
