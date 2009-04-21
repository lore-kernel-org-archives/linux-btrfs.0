From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Btrfs development plans
Date: Mon, 20 Apr 2009 20:27:39 -0600
Message-ID: <1240280859.16733.13.camel@telesto>
References: <1240238253.16213.48.camel@think.oraclecorp.com>
	 <20090420153118.GB6195@mother.fordon.pl.eu.org>
	 <3da3b5b40904200910x63e4e26cqe058ce0e4bc7f8c8@mail.gmail.com>
	 <2a31deca0904200957v39badd2eu4b26844e78fdcde3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CwlPLtetey9YX+ilzNX0"
Cc: Ahmed Kamal <email.ahmedkamal@googlemail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0904200957v39badd2eu4b26844e78fdcde3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-CwlPLtetey9YX+ilzNX0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 20:57 +0400, Andrey Kuzmin wrote:
>=20
> Personally, I don't see any. Porting zfs to Linux will cost (quite)
> some time and effort, but this is peanuts compared to what's needed to
> get btrfs  (no offense meant) to maturity level/feature parity with
> zfs. The only thing that could prevent this is CDDL licensing issues
> and patent claims from NTAP over zfs snapshots  and other features;
> btrfs is free from both.
>=20

In case anyone is interested, ZFS already has been ported to Linux as a
FUSE module. A very talented GSoC participant did the port as his
project. It works pretty well, but AFAIK it's not quite suitable for a
root filesystem yet. Still, much of the hard work has been done.

Cheers,
Eric


--=-CwlPLtetey9YX+ilzNX0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAABAgAGBQJJ7S8PAAoJEAanbLzqVaVfgRUIAKv/f5uiwFrgNIYQjPaHSigy
AyJF7zJZwRPfl2KK9qRB283lO6vXfd+p/W4yxVbg2GjHS7pi9wNOrcwLjeyEdQfT
j0doN78oCYFaVEQIGwoIsYdISTfxqqjzSOR6MGZhIszA6ztPEyMIx9QNDaPGKlup
c1sNz88Mh5AAKlJOmuqt+quBWEjUR6B/8CG93m2u8ih7uZmiQdBTE3WiMz+htyfF
4kUnN30WzfVKP5WH2QqeK1xC0P9DunWcvXdE3zID10Sv+8MSCv6y81j9ngeqjc4H
wjWeNkgKgqSkQE/065lT5tcWK6mPr0hCQcuAKT48zh66CqDTL+EzcROIAJfQwXE=
=Own3
-----END PGP SIGNATURE-----

--=-CwlPLtetey9YX+ilzNX0--

