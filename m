From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with
 degenerated profile
Date: Wed, 18 Jan 2012 12:41:57 +0000
Message-ID: <20120118124157.GF20139@carfax.org.uk>
References: <4F154738.8000709@cn.fujitsu.com>
 <20120117205815.GG3658@shiny>
 <4F169B04.3060200@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Cc: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F169B04.3060200@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18, 2012 at 11:12:20AM +0100, Jan Schmidt wrote:
> On 17.01.2012 21:58, Chris Mason wrote:
> > These two didn't make my first pull request just because I wanted to get
> > something out the door.  I'll definitely have them in the next pull.
>=20
> Please, don't do that! You can't just degenerate to DUP when RAID1 is
> out of space, that's entirely different.

   Agreed. This isn't a good idea.

> It's debatable whether degeneration from RAID0 to single is acceptable,
> but that again has different characteristics.

   RAID-0 to single and RAID-10 to RAID-1 are less controversial, I
think, although we need to be clear about what the performance
guarantees of the striping are (and how they would be affected by the
move to fewer disks). Given that we already degrade the striping of
RAID-0 down to "as many devices as we can fit right now", we're not
really providing much in the way of performance guarantees.

   (I'd definitely support some way of defining a fixed-width stripe,
but that's a whole separate question that we shouldn't get into now).

> ENOSPC is the best choice for both in my opinon.
>=20
> -Jan

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- What's a Nazg=FBl like you doing in a place like this? ---     =
=20

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPFr4VIKyzvlFcI40RAufQAJ9oWLGkxOsvUqyoXAIhH8+JptKlQwCaA8No
EZSWv+DetDFN6ePA//0i0LE=
=0BoK
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
