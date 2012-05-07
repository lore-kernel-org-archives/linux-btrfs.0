From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 19:00:47 +0100
Message-ID: <20120507180047.GG8938@carfax.org.uk>
References: <4FA802C2.6010909@gmail.com>
 <C8PD2qZuCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+xroYBkGM9OatJL"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PD2qZuCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--Y+xroYBkGM9OatJL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 07:52:00PM +0200, Helmut Hullen wrote:
> Hallo, Felix,
>=20
> Du meintest am 07.05.12:
>=20
> >> I'm just going back to ext4 - then one broken disk doesn't disturb
> >> the contents of the other disks.
>=20
> > ?! If you use raid0 one broken disk will always disturb the contents
> > of the other disks, that is what raid0 does, no matter what
> > filesystem you use.
>=20
> Yes - I know. But btrfs promises that I can add bigger disks and delete =
=20
> smaller disks "on the fly". For something like a video collection which =
=20
> will grow on and on an interesting feature. And such a (big) collection =
=20
> does need a "gradfather-father-son" backup, that's no critical data.
>=20
> With a file system like ext2/3/4 I can work with several directories =20
> which are mounted together, but (as said before) one broken disk doesn't =
=20
> disturb the others.

   mkfs.btrfs -m raid1 -d single should give you that.

   There may be a kernel patch you need to stop it doing the silly
single =E2=86=92 raid0 "upgrade" automatically, as well.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       ---   __(_'>  Squeak!   ---                      =20

--Y+xroYBkGM9OatJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqA3PIKyzvlFcI40RAnQQAKCXuli5bWXl+ahXxg/7lKKb8rlQ4ACcD4m8
b+97eusYRYCfNHgpCpWLCp0=
=OLlT
-----END PGP SIGNATURE-----

--Y+xroYBkGM9OatJL--
