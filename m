Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33790 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab2FFPki (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 11:40:38 -0400
Date: Wed, 6 Jun 2012 16:40:32 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: New btrfs-progs integration branch
Message-ID: <20120606154032.GO15986@carfax.org.uk>
References: <20120606131458.GN15986@carfax.org.uk>
 <CAMmKYEuCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WoqaC9TUMqqIOlla"
In-Reply-To: <CAMmKYEuCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WoqaC9TUMqqIOlla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 06, 2012 at 05:03:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
>=20
> Du meintest am 06.06.12:
>=20
> > However, the third line with the problem looks like something out of
> > date. Possibly a mis-merge?
>=20
> Where should I search?

   Well, the first thing would be to try a completely new clone of the
repo, then git co integration-20120605, and run make again. If that's
OK, then take a look with gitk in the broken repo and see what kind of
history you've got in there -- it should be a single unbroken sequence
=66rom "master" (1957076ab4fefa47b6efed3da541bc974c83eed7) to
"integration-20120605" (d4c539067d1cb2476c7fb6003625de26e84059af).

   Also have a look in the Makefile of the broken repo -- all of the
commands (listed near the top, assigned to the "progs" variable)
should start with "btrfs", and there should be no rule for "convert"
in there. Again, if that's not the case, you've managed to mis-merge
or check out the wrong branch.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---  =20
                              at the stars.                             =20

--WoqaC9TUMqqIOlla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz3nwIKyzvlFcI40RApXDAJ9PmVXv51M3ziBsd06wLaYvhp75zwCbBM7J
8pQ376VsJmc9XY5jhPvbZnY=
=2Xh/
-----END PGP SIGNATURE-----

--WoqaC9TUMqqIOlla--
