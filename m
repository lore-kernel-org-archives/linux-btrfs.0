From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Find RAID level, Change RAID level.
Date: Sat, 29 Oct 2011 15:34:10 +0100
Message-ID: <20111029143410.GO29548@carfax.org.uk>
References: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
 <20111029141303.GN29548@carfax.org.uk>
 <CACCfv7rRw6NsxAbosbdTVXpcWvc1XO=goSTQoQ5txQPnX=eSyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K4LMwn8CgX2KMboP"
Cc: linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7rRw6NsxAbosbdTVXpcWvc1XO=goSTQoQ5txQPnX=eSyw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--K4LMwn8CgX2KMboP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 30, 2011 at 12:55:33AM +1030, Jordan Windsor wrote:
> On Sun, Oct 30, 2011 at 12:43 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Oct 30, 2011 at 12:28:39AM +1030, Jordan Windsor wrote:
> >> Hello,
> >> I was wondering is it possible to find the RAID level currently in use
> >> by a btrfs volume, also can I change the data & metadata (or either)
> >> RAID levels after creation.
> >
> > =A0 To see the RAID levels, use
> >
> > btrfs fi df /path/to/filesystem
> >
> > =A0 To change RAID levels, you will need Ilya Dryomov's restriper
> > patches, which were posted to this list back in August.
>=20
> Thanks, so If it mentions "DUP" on the metadata & system line I'm using R=
AID1?

   No, DUP is two copies of the data (or metadata), but kept on the
same block device.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Ceci est un travail pour l'Australien. ---             =20

--K4LMwn8CgX2KMboP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrA7iIKyzvlFcI40RAhxBAJ9ORfYMI5JOTvTvBEajvILnrhKNPQCfVMK8
cQDnTjoWv6/d2lrlrXL/A0o=
=Ok1w
-----END PGP SIGNATURE-----

--K4LMwn8CgX2KMboP--
