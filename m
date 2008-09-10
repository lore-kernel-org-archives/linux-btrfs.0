From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: parity data
Date: Tue, 09 Sep 2008 19:32:06 -0600
Message-ID: <1221010326.14596.9.camel@telesto>
References: <1220766185.20018.7.camel@telesto>
	 <1220885271.8537.31.camel@think.oraclecorp.com>
	 <1220921206.7953.32.camel@telesto>
	 <1220957012.29741.38.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lNmUDY1lG1k3oKz0RUv5"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220957012.29741.38.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-lNmUDY1lG1k3oKz0RUv5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > Let's say I have 4 100GB drives (2 fast ones and 2 slow ones). I've
> > restricted a performance critical directory to the two fastest drives,
> > currently totaling 100GB of performance critical data. The rest of the
> > data on the system is striped.
> >=20
> > How much free space do I have on the filesystem? 100GB (the amount of
> > data I can store in the performance critical directory)? 200GB (the
> > amount of data I can store outside the performance critical directory i=
f
> > the striping is guaranteed)? 300GB (the amount of data I can store
> > outside the performance critical directory if the striping is best
> > effort)?
> >=20
>=20
> People already create these configurations, they just do it with
> multiple filesystems.  And, when they want to resize the performance
> critical section, it is a difficult (and often slow) operation.

I think I'm starting to get it. btrfs would have drive groups, and no
file would have data on more than one drive group at once. That would
make it possible to make meaningful statements about how much free disk
space there is (per drive group). This is almost the same as having
multiple filesystems, except files cannot be assigned to filesystems on
an individual basis. So in a way, btrfs would be replacing some
functionality of the VFS (mapping files to filesystems).

Is that right?

Cheers,
Eric


--=-lNmUDY1lG1k3oKz0RUv5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIxyOWe2L37HVup3ARAr5zAKDPM8QrqKL80AVjrOTrPKWzpHSVpQCgtNJQ
ZSh7FTYc55cgm8T9grz0ntM=
=kHUf
-----END PGP SIGNATURE-----

--=-lNmUDY1lG1k3oKz0RUv5--

