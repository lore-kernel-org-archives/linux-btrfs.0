Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58744 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750783AbdK3H7z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:59:55 -0500
Subject: Re: [PATCH 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a8427cb0-c579-f34c-f39e-01a740a9af27@gmx.com>
Date: Thu, 30 Nov 2017 15:59:45 +0800
MIME-Version: 1.0
In-Reply-To: <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oM9KPMbmBo66vQBgf3gWeQESaArQTR4RP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oM9KPMbmBo66vQBgf3gWeQESaArQTR4RP
Content-Type: multipart/mixed; boundary="8FcshX6iQ4a2RGmkDsmAlgEqQu8vvc2oH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a8427cb0-c579-f34c-f39e-01a740a9af27@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
In-Reply-To: <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>

--8FcshX6iQ4a2RGmkDsmAlgEqQu8vvc2oH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8830=E6=97=A5 15:52, Misono, Tomohiro wrote:
> "fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
> runnning without root privilege even if raid5/6 is not used.  What
> happens is it cannot get the per device profile usage info, so change
> the message more appropriately.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  cmds-fi-usage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 6c846c15..299c2dae 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -590,7 +590,8 @@ int load_chunk_and_device_info(int fd, struct chunk=
_info **chunkinfo,
>  	ret =3D load_chunk_info(fd, chunkinfo, chunkcount);
>  	if (ret =3D=3D -EPERM) {
>  		warning(
> -"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, r=
un as root");
> +		"cannot read detailed chunk info. " \
> +		"per device profile usage will not be shown, run as root");

IIRC it's allowed for long string to cross 80 chars limit.
This will make later grep easier.

And there is no need to indent the long string.

Thanks,
Qu
>  	} else if (ret) {
>  		return ret;
>  	}
>=20


--8FcshX6iQ4a2RGmkDsmAlgEqQu8vvc2oH--

--oM9KPMbmBo66vQBgf3gWeQESaArQTR4RP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofunEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qirkAf8CTPdyO4ZIh2axbueGMah/vqC
1wIZs5V0NY2n0goqg0uBrLKtKLC0bMW+fdTvXPOKkhvoaOI+I7KkvKWrpr4TH3C3
f3DGtJvGtcGInDstYt+N23WiUnzayoQBwS5AL+gkVXOQ/hNa0UIISj1epj26NHGr
vYOYjA5Ig/7cGcH+cf6AEey18KuxePW5lKzB236AQ8L5BbgAzigNKB0uY4MgICLu
YUNTY9kxvHfYg8LjKDqagdVcxAaJQZ6HtRWnDKqhqTPanPF56aGV9rN1/J+Vn4ft
TmTc+5+9UbXjP9MoFrrdrQjyNOGQKRrzfzMU7BB6Bk/rOYhdmdaxY76g9UbDKw==
=Pgnc
-----END PGP SIGNATURE-----

--oM9KPMbmBo66vQBgf3gWeQESaArQTR4RP--
