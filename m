Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58285 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKBKtx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Nov 2014 05:49:53 -0500
Date: Sun, 2 Nov 2014 10:49:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel 3.17.2 and RO snapshots
Message-ID: <20141102104952.GN907@carfax.org.uk>
References: <1798985.8i0FJtRps5@zafu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95CBLwa+io9O2zXc"
In-Reply-To: <1798985.8i0FJtRps5@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--95CBLwa+io9O2zXc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 02, 2014 at 11:42:58AM +0100, Sw=E2mi Petaramesh wrote:
> Hi there,
>=20
> I'm a little lost with latest kernel issues, and would like to know if th=
e=20
> "data corruption" with RO snapshots is fixed in 3.17.2, or not yet ?

   Yes, it is.

> Also about this issuse, I'd like to know if :
>=20
> - Data corruption occurs when creating RO snapshots,

   Yes.

> - Or if it can occur with just using a FS that already has RO snapshots ?

   No.

> - Or if it can occur when deleting existing RO snapshots with 3.17 ?

   Not that I'm aware of.

> Which means : If I have mistakenty upgraded to 3.17.2 a system containing=
 RO=20
> snapshots and cannot downgrade (big distro and drivers mess...), what is =
the=20
> safest way to go ?

   Leave it as it is. :)

> And if data corruption occurs, should I expect it to affect snapshots onl=
y, or=20
> the whole system ?

   I _think_ it only affects the snapshots, but could bring the system
down if you access the broken data. But you're safe with 3.17.2, so
it's a moot point for you right now.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---     =20
                              in New York?                              =20

--95CBLwa+io9O2zXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUVgxPAAoJEFheFHXiqx3kpuEP/ikqGmNaq3C/IOMN5WzLeXrQ
lixisjQHe0ZLnD55hqNEljqLr3z05J+ENj2TeVGUmL2WhOeIARcKyTb2Weo+RRqb
3MwbMxUDU2uQHyZzq0hbreP8/pkSwcEOd3boCoI57sXMAa+d+e9o9OifnxaVtL1i
2yl4HwKwghlEk/Ysenl6BLz1ftVcmoi/1+YVJQJnHHbHrNhKmD+n2cRVLX9kql1+
mbgBAOB0VxdWTslrOfEhEHNHD2ciHDyOFaAMb+z4gLr92jDLBY9M/ApOCyNWHdpN
qOG/QMfqgiOvYkLEvAS9rFgGZEzOgl9fUPv5cduEhqnglAkEv8n/hTWZDy6kQEcg
O10/kAjGXMCkrruTST8v1oR8k5/KcTE/GzdWFdoLIQbc25LI/ae9Z9vasi/yZ+nb
AqRkCgK1W8W5b+RxkUQCTUBxkjuqMI+xJHlFQX3hljqeSjrZ2YBUkzklFXy1jEgq
6oYBx9mFw5BvPjM4XtA+Z0C7+uluCL8ZrIzWcFSL6drvT5m4N1Af4O+JAWezN/uy
DsRcL0CcCDB3l8EXFirngjw2XVpnaCbIgf3/LHd5Pv+i5jfILXksqDcE3RpwK/dg
cS6utUlqK98A2S/odXP2yBJ7mP+0/1UvOc7qwByFsyWR9a5MdHa5wEiY5DU4ohgy
t09KLuYN8HrUj2QJXzm7
=wPP7
-----END PGP SIGNATURE-----

--95CBLwa+io9O2zXc--
