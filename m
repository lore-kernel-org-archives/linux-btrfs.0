Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51714 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdK3Iis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 03:38:48 -0500
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
 <1a534c1e-4223-f5fd-89a3-dd97ed79a0da@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c7418d56-26ca-a48d-0613-ac17db1a4e36@gmx.com>
Date: Thu, 30 Nov 2017 16:38:39 +0800
MIME-Version: 1.0
In-Reply-To: <1a534c1e-4223-f5fd-89a3-dd97ed79a0da@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XCF3fj4u6WHrUvbi24pOxK31O9kSDtG70"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XCF3fj4u6WHrUvbi24pOxK31O9kSDtG70
Content-Type: multipart/mixed; boundary="KVnUkUXcIqWWgx77tfjlAAGMEGli4Wilp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c7418d56-26ca-a48d-0613-ac17db1a4e36@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi usage: change warning message more
 appropriately
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
 <e7316023-a809-4f88-b36a-749ffd9dac01@jp.fujitsu.com>
 <1a534c1e-4223-f5fd-89a3-dd97ed79a0da@jp.fujitsu.com>
In-Reply-To: <1a534c1e-4223-f5fd-89a3-dd97ed79a0da@jp.fujitsu.com>

--KVnUkUXcIqWWgx77tfjlAAGMEGli4Wilp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8830=E6=97=A5 16:29, Misono, Tomohiro wrote:
> "fi usage" shows the warning "RAID5/6 numbers will be incorrect" when
> runnning without root privilege even if raid5/6 is not used.  What
> happens is it cannot get the per device profile usage info, so change
> the message more appropriately.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
> v1 -> v2: fix not to split message line
>=20
>  cmds-fi-usage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 6c846c15..2f3d57e3 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -590,7 +590,7 @@ int load_chunk_and_device_info(int fd, struct chunk=
_info **chunkinfo,
>  	ret =3D load_chunk_info(fd, chunkinfo, chunkcount);
>  	if (ret =3D=3D -EPERM) {
>  		warning(
> -"cannot read detailed chunk info, RAID5/6 numbers will be incorrect, r=
un as root");
> +"cannot read detailed chunk info. per device usage will not be shown, =
run as root");
>  	} else if (ret) {
>  		return ret;
>  	}
>=20


--KVnUkUXcIqWWgx77tfjlAAGMEGli4Wilp--

--XCF3fj4u6WHrUvbi24pOxK31O9kSDtG70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlofw48XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjioAf+OLt+9egB59dC9Cb81r6NotTd
fGJT6V69LU9sLsB2fDgXmc1WGMLQdRHHraiMxfE9gUAUC21mp7pjVCCYm19YLadn
/kR23fu+Djhib8jG5jtq7eEDFWN8KzLf2adiGnpkp3rN+oDSEBCoq5ygnhXBc/hY
GMjJ2sx+4rkFUcs6zoZ5RNYOfE59b2mCjQbosmvO3Q9Td22zshi5tH92UOPYw6wF
nNmW628SF+BdK6YYl3IUnZ3lgJ3/jFKOytbqQygb69a/zqHzFl4Ni4KKNqxS6sXy
anLpPidr+GSrtkfZdZf9+r7tUUt7BMd+cgVOT0XpwqDJtUbrTtbK3IzsAHGhdA==
=C0pd
-----END PGP SIGNATURE-----

--XCF3fj4u6WHrUvbi24pOxK31O9kSDtG70--
