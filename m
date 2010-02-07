From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: does btrfs have RAID I/O throughput (un)limiting sysctls, similar to md?
Date: Sun, 7 Feb 2010 12:48:20 +0100
Message-ID: <201002071248.20721.Martin@lichtvoll.de>
References: <c67eed301002051637p1288e120tb37c649ac44d40c@mail.gmail.com> <6278d2221002060510i947059bx12697ba0a4f5e4c@mail.gmail.com> <c67eed301002060648p436a7347w3c7189e385ed79bc@mail.gmail.com> (sfid-20100206_162038_531041_018BACCE)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2651970.tAQqSdKXby";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301002060648p436a7347w3c7189e385ed79bc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2651970.tAQqSdKXby
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 06 Februar 2010 schrieben Sie:
> On Sat, Feb 6, 2010 at 5:10 AM, Daniel J Blueman
>=20
> <daniel.blueman@gmail.com> wrote:
> > These proc entries affect just array reconstruction, not general I/O
> > performance/throughput, so affect just an edge-case of applications
> > requiring maximum latency/minimum throughout guarantees.
>=20
> although i'd 1st seen the perf hit at the (re)construction stage, i
> didn't recognize that the sysctls were limited to that case.

Limiting rebuild throughput helps to have productively running=20
applications getting their share of I/O during RAID rebuilds.
=20
> so, iiuc, btrfs has no such issues?

Issues? I would call that a feature, not an issue.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2651970.tAQqSdKXby
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAktuqIQACgkQmRvqrKWZhMeFwACfboJJ/qssvhjV7PdJp18wRl4A
aWsAoKjnwSb3c601kEef0T1zJoIJfZnX
=IDns
-----END PGP SIGNATURE-----

--nextPart2651970.tAQqSdKXby--
