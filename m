Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48195 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbaDILlL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 07:41:11 -0400
Date: Wed, 9 Apr 2014 12:41:07 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using noCow with snapshots ?
Message-ID: <20140409114107.GZ7442@carfax.org.uk>
References: <1541415.olHfkWYf4R@zafu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1olvqv+k0f6DP9aD"
In-Reply-To: <1541415.olHfkWYf4R@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1olvqv+k0f6DP9aD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 01:15:24PM +0200, Sw=E2mi Petaramesh wrote:
> Hi,
>=20
> In the quest for BTRFS and performance, and having received the advice to=
=20
> "chattr +C" my akonadi DB directory to make it noCow, I would like to be =
sure=20
> about what will happen when I take a snapshot of the concerned BTRFS=20
> subvolume.
>=20
> 1/ Being noCow, will the database be modified in the snapshot as well,=20
> efectively defeating the snapshot ?

   No (see below)

> 2/ Being snapshotted, will the database be COWed even though it's
> supposed to be noCow ?

   Yes -- once.

   When you make a snapshot of a nodatacow file, the data is shared
between the snapshot and the original as normal. The extents are
reference counted, so the original data now has two references to it.

   When one of these copies is written to, the writes are placed
somewhere else on the disk, still marked as nodatacow, and the
reference count is reduced to 1 for each copy again. (Note that this
is done on a per-block basis, although the 30-second transaction
commit will tend to coalesce adjacent blocks to reduce fragmentation;
autodefrag helps here, too).

   Basically, a snapshot of a nodatacow file will increase the
reference count for its blocks. A write to a block with a reference
count of more than one will *always* write a new block elsewhere. A
write to a block with a reference count of exactly one will not do so
if the file is marked nodatacow. I hope that's clear.

> 3/ Are both options mutually incompatible in some more osbcure ways ?

   Only as noted above.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- There are three mistaikes in this sentance. ---          =20

--1olvqv+k0f6DP9aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0Ux01heFHXiqx3kAQIo8w//SgMWwzjCPp5dgzqKGY6JatAxjFZ6bGW4
jmS6MqZs4VnYYII0Z/MSSZnRygPVeeTIUCDQjSEK7zv+M6Won+U4YYbEU5bUBdxn
9KuIvaRcOyrldehrNbV00A/ib6Yy+UqknGXdtZgfeK6g5jZyJhygwYDqin3scnh+
0wcfmZTXDs/ON68NAwI686jb2A0+zArkotWzE25H5Elp6t6CcvAWUnqOJYDP9KAd
fjcGIyDiq1BPbCBAB8vcrn/m1RXefxdIYBC+f6wSlmgDcNzvhFHAr/Lp6YtbNbU6
as+IaugrHm2owCh0c0b67j8FSWqmR6oijQe66xeq2+qq+TKkivQ7rRuh1MkkheAT
gy6dpiH6ivzQp9u+USFttJOI84q3U4Aos5jtOYn+r/wPDZq1JTRrGHtNWjFoiS1n
SQYAEYSPC95v7N7oEu1OVf04y9wnzUlPEVNMPVnU5Gm1TJ2xtzpGd6YAL7PserMZ
RczGLXLetsI4laL2Rrxs/USJmFN91o8gXtlonWshFuzgcvc09lsLm4z3QKvbEl6q
MnkHmwSHYEnItvGCnn9SwiE4Rb+ru6KZ5g6BfTS7wsKOOgD8jFOZKfPSH5X5m4XU
DrbjsUi7UBwvlSGBRnkDfEU4QygXRTcUx8RJlfEHLMMmSbAY4ypk2KVGmrpuzTxD
YTxgSbhpKJ4=
=an5P
-----END PGP SIGNATURE-----

--1olvqv+k0f6DP9aD--
