From: Chris Samuel <chris@csamuel.org>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 22:11:17 +1100
Message-ID: <201112172211.25456.chris@csamuel.org>
References: <201112161851.52011.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1760776.CyB2Cg3BKM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112161851.52011.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1760776.CyB2Cg3BKM
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Dec 2011 04:51:51 AM Martin Steigerwald wrote:

> Currently I have:
>=20
> deepdance:~> cat /proc/version
> Linux version 3.0.0-2-686-pae (Debian 3.0.0-6)

You are using a fairly old kernel btrfs-wise, I believe there's been=20
work done in the 3.2 rc's to improve performance so I'd suggest it's=20
well worth testing with 3.2-rc6 to see whether that helps.

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1760776.CyB2Cg3BKM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATux41o1yjaOTJg85AQKZtQgAls804+8bWzW5iSSa3cGpFdGnm1FXP5dr
M3kpq5o7FQM3isPzCfmfhXM7Bmk5KCq86iimO2b7V7NkP4HBb+Q8GNEq1jFrB1vZ
qEOpQIa2ztB8Hxj2KI0g7ayf3cEAg74sPrgJyB3Eosqm3RELtoaklZ2BbCnMy79k
OCDvUw+uLSR9YTBNdpfeevvirluOBxdzZzkNKWt7eqgCqhGNO8LczmHCdm5InsFG
bQSmiAjYAhzfaIWJ5qpNPl5+HOI+w2n5h6XIIvMXjwNz9ZiXZeT6VU/0kl0QDZnK
DgjDxiZ+adSTx3GCrBl2qwHj5o/5Mn3FqfAnsMyyeZkkdFrWdRFwng==
=WXAZ
-----END PGP SIGNATURE-----

--nextPart1760776.CyB2Cg3BKM--
