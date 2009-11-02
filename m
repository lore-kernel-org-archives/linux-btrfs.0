From: Chris Samuel <chris@csamuel.org>
Subject: Re: announcement of deduplication in Sun ZFS
Date: Tue, 3 Nov 2009 10:04:37 +1100
Message-ID: <200911031004.57592.chris@csamuel.org>
References: <934f64a20911021225o12acdb81u7a8a55afbf49963b@mail.gmail.com> <5f8586d40911021251n75161177s1230f44c1a4b9917@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2719942.cmeovHRjtu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5f8586d40911021251n75161177s1230f44c1a4b9917@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2719942.cmeovHRjtu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Nov 2009 07:51:52 am Alex Dedul wrote:

> In any way thats a nice and interesting feature, thanks! :)

My concern would be that it increases the impact of a corruption of the blo=
ck=20
that has been de-dup'd - in other words if the block that now represents th=
e=20
same data in lots of files gets trashed then all those files have corrupt=20
data. This implies that you would want to keep around at least one other co=
py=20
of that data to be resilient in the face of corruption (checksums will let =
you=20
detect it, but not necessarily recover from it without duplicate copies).

Given that ZFS prides itself on detecting errors it would be strange if the=
y=20
hadn't considered this in the implementation but I couldn't see any mention=
 of=20
it. =20

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2719942.cmeovHRjtu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUASu9lhY1yjaOTJg85AQKo8Qf/TbNtkRFrmC4ritkiCfdt/vn+7c9jBG3q
QQIjZg9jJVea6OFVjpz65iAFy9Kc3/BiVHuKbzJj6kyF8X5Dpf3I89QFat5JHv+v
YP42AT4W8SlUU8wBDB0LX8yUzP+laYj8Mgpbuinr9mfgOA0AwIxDS6wBuV95dh90
UBHAth0R3bevUaBpQWbMH2SjkhDW5wk6M3HwDS/lhhnG196106ZghGX5erHaQ3Y+
UdVed88PFZ4MKNBvnhbEVanPLNc07elBfWeXLWMplNHPlBYgDYOgnP8La+zjt9I1
K85IbjYKZj8wy4B+S1cieHNIJB6l/FPnR/kb02HptrDTHIpzlogDPg==
=i8IX
-----END PGP SIGNATURE-----

--nextPart2719942.cmeovHRjtu--
