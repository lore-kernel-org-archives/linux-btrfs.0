Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55134 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750783AbdK3ICe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:02:34 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: fi usage: cleanup unneccessary
 permission error check
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <9be13116-09f2-6f24-7e81-d215f5b215cc@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1fdabf5d-1f9a-5667-0132-c07938819f19@gmx.com>
Date: Thu, 30 Nov 2017 16:02:25 +0800
MIME-Version: 1.0
In-Reply-To: <9be13116-09f2-6f24-7e81-d215f5b215cc@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jEJvRfReB2QhR9uD23N67pRUgo184EQjA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jEJvRfReB2QhR9uD23N67pRUgo184EQjA
Content-Type: multipart/mixed; boundary="66Q4pqPSAWwWETj4dF4tQeLtuIabHuV6j";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1fdabf5d-1f9a-5667-0132-c07938819f19@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: fi usage: cleanup unneccessary
 permission error check
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <9be13116-09f2-6f24-7e81-d215f5b215cc@jp.fujitsu.com>
In-Reply-To: <9be13116-09f2-6f24-7e81-d215f5b215cc@jp.fujitsu.com>

--66Q4pqPSAWwWETj4dF4tQeLtuIabHuV6j
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8830=E6=97=A5 15:53, Misono, Tomohiro wrote:
> Since BTRFS_IOC_FS_INFO does not require root privilege, there is no
> need to check EPERM error.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  cmds-fi-usage.c | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 7bbc9896..b0721560 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -522,8 +522,6 @@ static int load_device_info(int fd, struct device_i=
nfo **device_info_ptr,
> =20
>  	ret =3D ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
>  	if (ret < 0) {
> -		if (errno =3D=3D EPERM)
> -			return -errno;
>  		error("cannot get filesystem info: %s",
>  				strerror(errno));
>  		return 1;
> @@ -597,11 +595,6 @@ int load_chunk_and_device_info(int fd, struct chun=
k_info **chunkinfo,
>  	}
> =20
>  	ret =3D load_device_info(fd, devinfo, devcount);
> -	if (ret =3D=3D -EPERM) {
> -		warning(
> -		"cannot get filesystem info from ioctl(FS_INFO), run as root");
> -		ret =3D 0;
> -	}
> =20
>  	return ret;
>  }
>=20


--66Q4pqPSAWwWETj4dF4tQeLtuIabHuV6j--

--jEJvRfReB2QhR9uD23N67pRUgo184EQjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofuxEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhrgQf7B2+6XOZZZSapYbLoEFbg4FMd
KYrKS5BTYEeD8bCl1ixALjfWsL8peHxEFoqqRY6PUSuRbphuNDI6B+THCOaWh9Os
g9gJ+vvr8jj49NlUroNbEMQIZN2wG9N8CwCNZSwuRq3E15maGmo0+PfafM194kim
LxqN9phQPa5rmiwRS8yCUfwR+8wkE3mOaKP0PXnd+H4SrNUadun3Fb7dbnpBl39t
8DcqnJfGnOY8XMgcOq4eekN6q2jsCGppk2r55zQzlBIE/tT7x5sxHO5ooa6SSZdS
DsA3WW38e70+bD1wTxuSF+Qv++H+4QcQ33xDA/MbG9rSs6+PmduvM3qlte8Geg==
=98ym
-----END PGP SIGNATURE-----

--jEJvRfReB2QhR9uD23N67pRUgo184EQjA--
