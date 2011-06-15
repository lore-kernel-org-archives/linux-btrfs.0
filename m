From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2] btrfs: Remove all sysfs entries
Date: Wed, 15 Jun 2011 11:34:31 +0100
Message-ID: <20110615103431.GA15127@carfax.org.uk>
References: <4DF86FFF.5000406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF86FFF.5000406@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote:
> Seems that currently none of the sysfs are created any more, so just
> remove sysfs support entirely.
>=20
> Fixes compiling warnings in 3.0rc3

   I would actually like to retain sysfs support -- the current
entries may not be used (or useful, or in the right place, or even
visible these days), but there's plenty of things that could and
should go in sysfs from btrfs.

   So, please do remove the unwanted/unused file entries, but could
you leave the sysfs file itself, and the (limited) bits that create
the btrfs subdir? Otherwise, I'm going to be putting it all back in
this weekend when I get the time to revisit Goffredo's old sysfs
patch...

   Thanks,
   Hugo.

> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>=20
> --

   (I think this should be three - signs, not two: my signature-
cropping script removed the whole patch)

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- What's a Nazg=FBl like you doing in a place like this? ---     =
=20

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN+Iq3IKyzvlFcI40RAhGnAJ9Egsnp1XI8TiFC4jiWnakefORnGQCeL+XW
/FxmTMu8x9AMKiMg7vrRF9E=
=B5df
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
