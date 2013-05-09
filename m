Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57675 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3EIKEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 06:04:30 -0400
Date: Thu, 9 May 2013 11:04:27 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: syslog message repeated 3x
Message-ID: <20130509100427.GB26072@carfax.org.uk>
References: <518B6BC1.8020504@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
In-Reply-To: <518B6BC1.8020504@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 09, 2013 at 11:26:25AM +0200, Toralf F=F6rster wrote:
> I'm just curious why the last of the following 3 commands :
>=20
> $> dd if=3D/dev/zero of=3D/mnt/ramdisk/disk1 bs=3D1M count=3D257
> $> yes | /sbin/mkfs.btrfs /mnt/ramdisk/disk1
> $> mount -o loop /mnt/ramdisk/disk1 /mnt/t
>=20
> gives 3x the same log message :
>=20
> 2013-05-09T11:23:00.230+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-=
a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
> 2013-05-09T11:23:00.581+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-=
a2a7-066e9384c901 devid 1 transid 4 /dev/loop1
> 2013-05-09T11:23:00.583+02:00 n22 kernel: device fsid 5b4be7c4-e662-459a-=
a2a7-066e9384c901 devid 1 transid 4 /dev/loop1

   At a guess, two of those are probably from btrfs dev scan triggered
by udev.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Well, sir, the floor is yours.  But remember, the ---       =20
                              roof is ours!                             =20

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUYt0q1heFHXiqx3kAQJpfA/8DsGDTvlG701528Vclp3gx3McCg/gcvBJ
Zlz4AQxS6GExTLDapaEpBETcsGOZSyJWmGe4OixD4sptp+niLs8i7WD5Aziqmcvl
5U9sncpTSyzk4EKdTiJG1KYgESBXFXUawv4di/63ePRj1SUsd59tiDhY22a8dw+/
2P4O8EXYpCEYFN+H3wszRZbJPUKdguRF2PHiDn3zsnfgpq5ho+SA40ag8xE6ixjR
QTJHOYiF22KV/nntvSLSutdOByCIS8NGsA3uc7gIR1dteAWIlz/LLeC9/diBx4DV
eWIdSymuhdvrPXRI9txJw3e8JM81kDlVw+IffvlXZ7Mm7NpphxkWCzpmkdnTDAgb
2Gnbe76bY2KYlFEZ1AHVAXKitZc0IEHT5dipLPbMHKYcYxIP2D71TfsY/3ZNi7KS
IFcswMkLAbIqJRHJZALfTPDWLWKqPfnM0wliXhvAbgwN1gdGMPkvMWflaEfxZ6ZZ
eejdSkHcRwVElb2/gokQNYyPvWzLRsL1V98qcx+0+1CdMXcjCH9OdQGb2gdaUmQG
pDVR9PyYnDypL4zoPBYVVtUzNQ+vSqCgwVwE8MVZPlussuZPtShAdzQyfSoRXcv4
siG0XHiFcSKLjvxmGAgWBmF0DG/cDS6yBsUqLGxu872P22YiXZuPUOms9BkJn9/N
wH7sNpwqsKc=
=331E
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
