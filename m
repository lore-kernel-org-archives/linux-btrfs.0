From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Balance RAID10 with odd device count
Date: Wed, 22 Feb 2012 11:09:32 +0000
Message-ID: <20120222110932.GC21261@carfax.org.uk>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
 <20120221075422.GG5350@carfax.org.uk>
 <20120222085627.GS30450@jeru.org>
 <1591210.klPCAKoV0g@bursa22>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Cc: nicollet@jeru.org, tom@drdabbles.us,
	Gareth Pye <gareth@cerberos.id.au>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1591210.klPCAKoV0g@bursa22>
List-ID: <linux-btrfs.vger.kernel.org>


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 22, 2012 at 11:22:08AM +0100, Hubert Kario wrote:
> On Wednesday 22 of February 2012 09:56:27 Xavier Nicollet wrote:
> > Le 21 February 2012 ? 07:54, Hugo Mills a =E9crit:
> > >    Some time ago, I proposed the following scheme:
> > > <n>C<m>S<p>P
> > >=20
> > >    where n is the number of copies (suffixed by C), m is the number of
> > >=20
> > > stripes for that data (suffixed by S), and p is the number of parity
> > > blocks (suffixed by P). Values of zero are omitted.
> > >=20
> > >    So btrfs's RAID-1 would be 2C, RAID-0 would be 1CnS, RAID-5 would
> > >=20
> > > be 1CnS1P, and RAID-6 would be 1CnS2P. DUP would need a special
> > > indicator to show that it wasn't redundant in the face of a whole-disk
> > > failure: 2CN
> >=20
> > Seems clear. However, is the S really relevant ?
> > It would be simpler without it, wouldn't it ?
>=20
> It depends how striping will be implemented. Generally it provides=20
> information on how much spindles is the data using. With static=20
> configuration it will be useless, but when you start changing number of=
=20
> drives in set then it's necessary to know if you're not under- or over-
> utilising the disks.

   Indeed. If the implementation always uses the largest number of
devices possible, then we'll always have nS. If it allows you to set a
fixed number of devices for a stripe, then the n will be a fixed
number, and it becomes useful.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Happiness is mandatory.  Are you happy? ---            =20

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPRMzsIKyzvlFcI40RAn93AJ9aTTgcMyBNt3WRkRWPq3LPH2PCJACdHPsC
k9yYLzJdKnTB9EPEnr2R4RI=
=ID9G
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
