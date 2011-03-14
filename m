From: Chris Samuel <chris@csamuel.org>
Subject: cppcheck and btrfs
Date: Tue, 15 Mar 2011 07:32:13 +1100
Message-ID: <201103150732.18300.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2632214.YcrLF05GLM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2632214.YcrLF05GLM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Chris, et. al,

I've recently come across cppcheck (static analyser for C code)
and ran it on the current btrfs directory from Linus's repo and
it's reported the following potential issues:

linux-2.6$ cppcheck -q fs/btrfs/
[fs/btrfs/compression.c:343]: (error) Data is allocated but not initialized=
:=20
cb
[fs/btrfs/compression.c:583]: (error) Data is allocated but not initialized=
:=20
cb
[fs/btrfs/delayed-ref.c:649]: (error) Data is allocated but not initialized=
:=20
ref
[fs/btrfs/delayed-ref.c:694]: (error) Data is allocated but not initialized=
:=20
ref
[fs/btrfs/extent-tree.c:5766]: (error) Data is allocated but not initialize=
d:=20
extent_op
[fs/btrfs/extent-tree.c:5768]: (error) Data is allocated but not initialize=
d:=20
extent_op
[fs/btrfs/transaction.c:1161]: (error) Data is allocated but not initialize=
d:=20
ac
[fs/btrfs/volumes.c:1387]: (error) Possible null pointer dereference:=20
fs_devices
[fs/btrfs/volumes.c:3636]: (error) Memory leak: device

Now I'm not really a programmer (much less a kernel one) but I
do see people using it discover issues in kernel code.

Are these issues real or bugs in cppcheck ?

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2632214.YcrLF05GLM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATX57To1yjaOTJg85AQJ7rgf9EbzDuPoKHKONP8wczzfpYIpXPkCyAy0S
F+kNOfEs2iVviuxZaVxHGp7hzeLx5TcInM4xze3rlUUxUetYaFupjfLFtQJSzero
5r2sUL3i1DLaOB+9cYhqDiZpSPViQTOvO8xuqx64kTp70lEUc1hYiPt7N/a9za35
I/MkfBikgeb3TZ8J1nC4e6zRzIB1qjxIQkLVDXQsPDrgWTId2fIMXU1G+QbTG8z+
XVgRcYo5HMcbnw/O8I1ROzEeuWjo7MkWLhTJhKmRhYtTbCeLkx01xZH1pHb2LjOb
ZvmsJITFkPRea1ZFTD1LFL6LKOGFBtM82WqkmXsAQIUA4lT81SehtQ==
=9KVg
-----END PGP SIGNATURE-----

--nextPart2632214.YcrLF05GLM--
