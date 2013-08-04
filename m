Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53162 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3HDSrE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 14:47:04 -0400
Date: Sun, 4 Aug 2013 19:46:57 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: building btrfs corrupt block
Message-ID: <20130804184657.GB22967@carfax.org.uk>
References: <45469DAE-A90B-4E66-A03B-F35EBF92FDB8@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
In-Reply-To: <45469DAE-A90B-4E66-A03B-F35EBF92FDB8@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 04, 2013 at 12:39:28PM -0600, Chris Murphy wrote:
> I must be doing something wrong, but I can't figure out what. I have btrf=
s-progs source installed from here:
> http://koji.fedoraproject.org/koji/buildinfo?buildID=3D441375
>=20
> make produces no errors. Yet btrfs-corrupt-block.c isn't built. Suggestio=
ns?

$ make btrfs-corrupt-block

   Some of the more outr=E9 commands aren't built by default and have to
be built individually.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- For months now, we have been making triumphant retreats ---    =20
               before a demoralised enemy who is advancing              =20
                           in utter disorder.                           =20

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUf6hoVheFHXiqx3kAQJ9ZRAAqnnNEQak/zCn5XZm83e/33dnKlTI4PFG
xnp5Px0rYmNlvu7E7RXA8tn2ezfOOdKq//1TYhKI+aUynSJPFxJGhwojmr3x4/ty
Ou/l1QHL/5LDG9eseRFzhqoeucZg74DvR5Kk83qsuguQ49HknucE6Ta2ZTkfMKcc
+P8zvXXXiBWDUcx1xQJMuB0uQVjalJxVX/UubSFTXm0pqq181jlGBDv0AlvDrDbb
mdg+twhEtvMBkeW50605ay2NITVNq4+P2zVi4k0ZTV8bDngwW73UW1NeMTRm0ieX
vPVnBAltCYPXG5aNcPbUENgJiXKNUl/OGmhbryRInoja6vnpxngIov+k/XIWUuyt
QaWZWgeSj6a4Cg0mId+tpTb/DuALwGJ3yMMGDrP7JIj1SknTxdDsJ0mCN7996w/Y
55pvVI+2tmu1oThImR/cBboDV2RxNq2zm2ajUcih4VAORHqAXevav7prgTZ1NVLE
UM04fom2aPpMKhwFe2bCNR+0TVrSbyv6C0t/B3Mp6BmWYBeriju0M2naXTRpwBsB
7x7/akw+pJl5gZkc7hA6HWU5mFRrz/bAOWkA3bv70q1jMn272tsWQsfvTqYwP5UN
BOMF9xsvWcn+p0fTDyeABeYUjroZuudsz7uWsJyg2hsZtcdYVuQ8tg9t95yLwCSZ
jdc+1l9Gyd0=
=b1NW
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
