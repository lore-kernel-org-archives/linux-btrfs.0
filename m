Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64702 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdK3INj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:13:39 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: fi usage: change to output more info
 without root privilege
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <dbdf04aa-3969-8249-a507-d7d16f3d1e5d@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a7c8374e-68b2-6cc3-b877-f988ec4a423b@gmx.com>
Date: Thu, 30 Nov 2017 16:13:29 +0800
MIME-Version: 1.0
In-Reply-To: <dbdf04aa-3969-8249-a507-d7d16f3d1e5d@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tF9Wr527a5xmhdnbG716G79CQ7iektOlE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tF9Wr527a5xmhdnbG716G79CQ7iektOlE
Content-Type: multipart/mixed; boundary="oKgHv8VdE6cIOkqghOtgKLkHtGuEJuUe7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a7c8374e-68b2-6cc3-b877-f988ec4a423b@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: fi usage: change to output more info
 without root privilege
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <dbdf04aa-3969-8249-a507-d7d16f3d1e5d@jp.fujitsu.com>
In-Reply-To: <dbdf04aa-3969-8249-a507-d7d16f3d1e5d@jp.fujitsu.com>

--oKgHv8VdE6cIOkqghOtgKLkHtGuEJuUe7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8830=E6=97=A5 15:52, Misono, Tomohiro wrote:
> Although per device usage cannot be shown without root privilege,
> per profile usage can be shown.
>=20
> To achieve this, we just basically need to remove the check of nullness=

> of chunkinfo in print_filesystem_usage_by_chunk(), because other
> functions except print_unused() properly handles chunkinfo by
> chunkcount, which is 0 if chunkinfo is null.
>=20
> As a result, "fi usage" always includes the infomation of "fi df".
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-fi-usage.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 299c2dae..7bbc9896 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -885,9 +885,11 @@ static void _cmd_filesystem_usage_linear(unsigned =
unit_mode,
>  		printf("\n");
>  	}
> =20
> -	printf("Unallocated:\n");
> -	print_unused(info_ptr, info_count, device_info_ptr, device_info_count=
,
> -			unit_mode | UNITS_NEGATIVE);
> +	if (info_count) {
> +		printf("Unallocated:\n");
> +		print_unused(info_ptr, info_count, device_info_ptr,
> +				device_info_count, unit_mode | UNITS_NEGATIVE);
> +	}
>  }
> =20
>  static int print_filesystem_usage_by_chunk(int fd,
> @@ -898,9 +900,6 @@ static int print_filesystem_usage_by_chunk(int fd,
>  	struct btrfs_ioctl_space_args *sargs;
>  	int ret =3D 0;
> =20
> -	if (!chunkinfo)
> -		return 0;
> -
>  	sargs =3D load_space_info(fd, path);
>  	if (!sargs) {
>  		ret =3D 1;
>=20


--oKgHv8VdE6cIOkqghOtgKLkHtGuEJuUe7--

--tF9Wr527a5xmhdnbG716G79CQ7iektOlE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofvakXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgczAf+Kx0XHTOalpZ3jeqWg73KWw21
00B/4DnX+FRFlPKEUbWQsvqNGD+McCvnQuKo+LM0yILV9CTLI7TpwCRGpSPLCMAF
snrz3suGNqUeL8Jqrdwq8C/GUzbKvj+XJzdSNEjOYi0qUIan5Kk7+5H5I7b5cjwo
v4oi2CGrtgARQPvKBKPNq4v540ZDgN0p22K8jb5JsIwTLH+/KtLlM/LMOdtcw3Fr
NsneRn2IO8SL0ohsmSHJRAoz8Zg1xmRBAncYS4V2VHIp6WF7WQC6T+xEYoUblDOC
lkqQyQWuLmNoUIPaX3FIRc3JjzNlCxLW/NK/OIhhQ8Uvd/Skk3dy3dKluimI+g==
=bAKq
-----END PGP SIGNATURE-----

--tF9Wr527a5xmhdnbG716G79CQ7iektOlE--
