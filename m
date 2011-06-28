From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Snapshot reconciliation
Date: Tue, 28 Jun 2011 12:39:53 +0100
Message-ID: <9577A2A8-5786-4491-A676-2CBD10DBAC1B@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1-241511975"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1-241511975
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

Hello.

Can anyone think of a simple way to copy a set of pages from a given =
file (which may or may not be scattered throughout multiple extents) =
from a snapshot to correct pages within another file on another =
snapshot?

This might sound silly, but the whole purpose is to create some sort of =
reconciliation method between divergent snapshots taken from the same =
original subvolume.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-1-241511975
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJOCb2PAAoJEJ9vvxhHfCblMJ0H/RmReIkzv3nUI2bAMCq4ly9X
ufP5hF8zBNOF2dgTuitDFRI5SqyRCff4INinlT2+xn7GI0Ha9Bc46mRuPq1RNSyR
tOZQ42BRVKyRrJ6dRj5xskkFEyC6tTTXN275xfIKMZxAlqbbj3POTARLknsKRMik
7S5jjv3zJ6cSals979XhUfCoOVtQ6OcziZJ+BZbPfegR+dCP8fkw6oD18Warm0cZ
z71lOoynwJ99XUdv540bI8muddCODRLg+KV8v26/XCkaw8X3cDiuNoBXiUOccvOB
97I+xPrGwsZEVUuGPDIytMYXFWifzE580//WkmG52VcDFOxQUKSrnyeNRwnuFsA=
=vLHV
-----END PGP SIGNATURE-----

--Apple-Mail-1-241511975--
