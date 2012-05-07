From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 7 May 2012 19:44:48 +0100
Message-ID: <20120507184448.GH8938@carfax.org.uk>
References: <20120507180047.GG8938@carfax.org.uk>
 <C8PDD0cPCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8sldprk+5E/pDEv"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PDD0cPCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--a8sldprk+5E/pDEv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 08:25:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
>=20
> Du meintest am 07.05.12:
>=20
> >> With a file system like ext2/3/4 I can work with several directories
> >> which are mounted together, but (as said before) one broken disk
> >> doesn't disturb the others.
>=20
> >    mkfs.btrfs -m raid1 -d single should give you that.
>=20
> What's the difference to
>=20
>      mkfs.btrfs -m raid1 -d raid0

 - RAID-0 stripes each piece of data across all the disks.
 - single puts data on one disk at a time.

   So, on three disks (each disk running horizontally), the FS will
allocate block groups this way for RAID-0:

Disk 1:   | A1 | B1 | C1 |...
Disk 2:   | A2 | B2 | C2 |...
Disk 3:   | A3 | B3 | C3 |...

where each chunk, e.g. A2, is 1G in size. Then data is striped across
all of the An chunks (a single block group of size 3G) in 64k
sub-stripes, until block group A is filled up, and then it'll move on
to another block group.

   For "single" allocation on the same disks, you will instead get:

Disk 1:  | A  | D  | G  |...
Disk 2:  | B  | E  | H  |...
Disk 3:  | C  | F  | I  |...

where, again, each chunk is 1G in size. Data written to the FS will
live in one of the chunks, overflowing to some other chunk when
there's no more space.

   With large files, you've still got a chance that (some of) the data
=66rom the file will be on more than one disk, but it's a much much
better situation than you'd have with RAID-0.

   Of course, you still need RAID-1 metadata, so that when a disk does
go bang, you still have all the filesystem structures you need to read
the remaining data. :)

   In fact, this is probably a good argument for having the option to
put back the old allocator algorithm, which would have ensured that
the first disk would fill up completely first before it touched the
next one...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---         =20
                         darkness bind(2) them.                         =20

--a8sldprk+5E/pDEv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqBggIKyzvlFcI40RAtS4AJ4l5jeztUoq9XdCVDID0vUSKbHUMQCfamQ6
P21dcOiLbgHUa8DZ9KXgrPc=
=RSvf
-----END PGP SIGNATURE-----

--a8sldprk+5E/pDEv--
