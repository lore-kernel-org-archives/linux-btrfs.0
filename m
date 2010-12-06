From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Mon, 6 Dec 2010 11:43:09 +0000
Message-ID: <20101206114309.GB4273@carfax.org.uk>
References: <BbJQ3vED1uB@helmut.hullen.de>
 <BbNQohPi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbNQohPi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 06, 2010 at 08:43:00AM +0100, Helmut Hullen wrote:
> Hallo,
>=20
> I wrote am 05.12.10:
>=20
> >>>>>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
> >>>>>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2
>=20
> >>> Here devid 2 is at 100%, and hence you are getting the no more
> >>> space left errors. So, the 300 TB is on the bigger disk, and not
> >>> usable for you right now.
>=20
> >>    I _think_ that a balance is all that's needed at this point. It
> >> can't hurt, anyway (other than taking quite a long time).
>=20
> > After running "balance" it looks better:
>=20
> > Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
> > 	Total devices 2 FS bytes used 2.39TB
> > 	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
> > 	devid    1 size 1.81TB used 1.20TB path /dev/sdf2
>=20
> And now:
>=20
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdc3            3400799848 2569770888 831028960  76% /srv/MM
>=20
> But after copying about 300 MByte (part of a 1.5-GByte *.mpg) I got "no =
=20
> space left on device". Looks like balancing has stolen about 300 GByte.

   This sounds exactly like a problem I've had. What output do you get
=66rom "btrfs fi df /srv/MM"?

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- We believe in free will because we have no choice. ---       =20

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/MxNIKyzvlFcI40RAi1gAJ0UVS20hvKCGbYimlU22L61FqmEhQCbBkY1
ruI2QAdnxeEa8HUz7WUF/UE=
=Hyh2
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
