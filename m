From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Synching a Backup Server
Date: Tue, 11 Jan 2011 22:41:33 +0000
Message-ID: <20110111224133.GE29572@carfax.org.uk>
References: <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
 <201101071720.08298.hka@qbs.com.pl>
 <4D29A033.7000803@chandlerfamily.org.uk>
 <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
 <4D29D508.6080006@chandlerfamily.org.uk>
 <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
 <20110109183030.GA29572@carfax.org.uk>
 <4D2A2128.2060508@chandlerfamily.org.uk>
 <20110109220101.GB29572@carfax.org.uk>
 <AANLkTi=AmNOhK9+WdwoRTHi7HrFhOmGT8wV9N77yVH+s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3O1VwFp74L81IIeR"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=AmNOhK9+WdwoRTHi7HrFhOmGT8wV9N77yVH+s@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3O1VwFp74L81IIeR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2011 at 09:22:49AM +0700, Fajar A. Nugraha wrote:
> On Mon, Jan 10, 2011 at 5:01 AM, Hugo Mills <hugo-lkml@carfax.org.uk> wro=
te:
> > =A0 There is a root subvolume namespace (subvolid=3D0), which may conta=
in
> > files, directories, and other subvolumes. This root subvolume is what
> > you see when you mount a newly-created btrfs filesystem.
>=20
> Is there a detailed explanation in the wiki about subvolid=3D0? What
> does "top level 5" in the output of "btrfs subvolume list" mean (I
> thought "5" was subvolid for root subvolume)?
>=20
> # btrfs subvolume list /
> ID 256 top level 5 path maverick-base
> ID 257 top level 5 path kernel-2.6.37
>=20
> > =A0 The default subvolume is simply what you get when you mount the
> > filesystem without a subvol or subvolid parameter to mount. Initially,
> > the default subvolume is set to be the root subvolume. If another
> > subvolume is set to be the default, then the root subvolume can only
> > be mounted with the subvolid=3D0 mount option.
>=20
> ... and mounting with either subvolid=3D5 and subvolid=3D0 gives the same
> result in my case.

   OK, having read through some of the code, it looks like the "5"
comes from it being the root FS tree object ID. So, it's probably
quite hard to change that number without making incompatible
filesystems.

   However, the _documented_ (and official) way to mount the root
subvolume is to use subvolid=3D0... :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to --- =20
         eat?  / If the Juju had meant us not to eat people / he        =20
                     wouldn't have made us of meat.                     =20

--3O1VwFp74L81IIeR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNLNydIKyzvlFcI40RAq++AKCDGkxAAJx8BR/YWPWRe4mDONmUKwCgoHyI
GJvATdl/AdQQNpbyiSgc6hU=
=mB2a
-----END PGP SIGNATURE-----

--3O1VwFp74L81IIeR--
