From: Chris Samuel <chris@csamuel.org>
Subject: Blog: "BTRFS is effectively stable"
Date: Sat, 30 Oct 2010 10:38:23 +1100
Message-ID: <201010301038.28038.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4526144.uEWeuosrAD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4526144.uEWeuosrAD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

A friend of mine who builds storage systems designed for HPC
use has been keeping an eye on btrfs and has just done some
testing of it with 2.6.36 and seems to like what he sees in
terms of stability.

http://scalability.org/?p=3D2711

# But it passed our stability test. 100 iterations (3.2TB
# written/read in all and compared to checksums) of the
# following fio test case.
[...]
# This is our baseline test. Failing RAIDs, failing drives,
# failing SSDs tend not to pass this test. Borked file systems
# tend not to pass this test. When something passes this test,
# again and again (3rd time we=E2=80=99ve run it), and does so without
# fail, we call it safe.

He has concerns about performance, but he's more interested
in reliability in these tests.

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart4526144.uEWeuosrAD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATMta741yjaOTJg85AQJrRAf+KkfbEwUV09r8kTwxmJrgw2mvzjo+THJE
r4kP2WsEGpU6pXXps31kXL+jmVYcT0L6+HmC1UEkOTLMT0pgEBU/K/xCO2WgItQm
v6c9LL0jcdl7u7zkpvZSqHoScEsVWcDanw60JxPa5YtrrDKYVUPunNMkHIHFfKZH
rgvsTkoHvNn+asJkiWsr6OBEadoTQeaZkok9vxbKQox3fKKOd5yJUrKJaV+jC5BK
L6gT8om+NSkedF16ztMejY4HbXfIw2SXRcKYqUzI2NEZ8yu4ElGBN/O5L1YHGmaG
Y8MiIetqxv0fEr4qNGG2XuWPlrTampW+IhY8rEaManSVtbURsSoy4A==
=HfaR
-----END PGP SIGNATURE-----

--nextPart4526144.uEWeuosrAD--
