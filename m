Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49791 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2LCMJy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 07:09:54 -0500
Date: Mon, 3 Dec 2012 12:09:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Example of BTRFS uglyssima performance : Bitcoin
Message-ID: <20121203120952.GE7289@carfax.org.uk>
References: <50BC92F6.6050404@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
In-Reply-To: <50BC92F6.6050404@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03, 2012 at 12:54:30PM +0100, Sw=E2mi Petaramesh wrote:
> Hi folks,
>=20
> My laptop is a Core i3-2310M with 4 GB RAM, running BTRFS on a 1 TB HD.
>=20
> I run Ubuntu 12.10 Quantal, kernel 3.5.0-19-generic 64-bit.

   Try 3.7. That's had some significant performance improvements. 3.5
is over 6 months old, which is a long time in btrfs development.

> I wanted to give a shot at bitcoin so I installed it from the Ubuntu
> PPA, and started getting the database from the Internet. (it's now 4.5
> GB big on disk). I assume it an SQL DB (SQlite or so ?)

   Try marking the SQLite database file(s) as nocow, with chattr +C.
That also only works on 3.7, but should deal with your database
problems.

> My system currently has been crushing its data for more that 5 days now
> (5x24 hours) with the HD busy to the point that the system is completely
> unusable and I had to take another laptop to be able to surf the web and
> process my email. Disk LED is steadily lit, trying to switch between 2
> open windows takes 5 minutes or so...
>=20
> Entering new blocks into the DB has now slowed down to the point that I
> assume that the last 6% that I miss (I'm now at 94.something %) may well
> take another couple weeks or so...
>=20
> Friends running ext4 told me that the initial loading of the DB took
> them a couple hours... With BTRFS it's been 5x24 hours and counting... :-(
>=20
> This filesystem is pure crap as soon as it comes to database processing :=
-(

   3.5 was. 3.7 shouldn't be -- particularly with the use of +C on the
database files.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---  =20

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBULyWkL9z9OVl50rAAQLOVQ/8COvuLRjJde3E6Qe8jtzv4TlqLYP8qjoA
T840Z07Leu6vSKQFPIL3cBcHmmkwAMXLGqyVZBZaAJxnjGH5WCtOSNg3E7CCwGQH
vy/0LZpYliPv/f0HU1QgmH/s9NBNFMvdQuGmfHELdbPCTvIi9tsynMjOHGcRoV8S
mF3JaVWbIjf9YkSX7+bRwSyabk5+1UutaXoWBO9LLdccU2/suhMBl2AC/D0W5Q9n
Oe28CUGGy/2TnIgBm8W4e4NZH1slgglXiq2Leb5jA6wDlHxSWflCWFFpHSOxZ6tR
RcVbzTW+cTm8dhNu93oPS/Aoq0srGwgYBFlYt894E9sdtjfbc18InuFX+oxWNAbb
BJ3saDZ/6xh98wpIiMWLgcrJaBNOpbV/uZOg54L/r5ijKVaVuwqV0UV/Mkp/3xcB
Cq2cB4zH4fCvMl75ReSvsQQYTJsEjSrq6KhXJk3UQyp1rARPDIPbi8V1A/uzM0jZ
PR7e63rOMAzt592W173XRfvePywxrm1KIi3TyW7N1SDnkyargJGGJuqBsMxIdlRX
yBEoBit5lHaOeOUJz1nq+5qCUYoh0fD+hrPyZBOnAoSbo8CDQY/W3y8bR93WaGEd
Oi562UUvG4/u2fN6knTRA0eWeqrmk4mCrJQBDiqLOt9SYQoYHO9cnOA9Ia+b9vG5
dICNvMiUXNo=
=nUNk
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
