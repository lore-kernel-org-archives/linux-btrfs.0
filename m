From: Chris Samuel <chris@csamuel.org>
Subject: Bonnie++ run with RAID-1 on a single SSD (2.6.29-rc4-224-g4b6136c)
Date: Fri, 13 Feb 2009 23:31:09 +1100
Message-ID: <200902132331.12928.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2840924.bofnbdQ3vC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2840924.bofnbdQ3vC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi folks,

=46or people who might be interested, here is how btrfs performs
with two partitions on a single SSD drive in a RAID-1 mirror.

This is on a Dell E4200 with Core 2 Duo U9300 (1.2GHz), 2GB RAM
and a Samsung SSD (128GB Thin uSATA SSD).

Version 1.03c       ------Sequential Output------ --Sequential Input- --Ran=
dom-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --See=
ks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec=
 %CP
sys26            2G           28299  17 18633  12           85702  29  3094=
  18
                    ------Sequential Create------ --------Random Create----=
=2D---
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Dele=
te--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP
                 16  7513  99 +++++ +++  5140  98  3964  67 +++++ +++  5652=
  99
sys26,2G,,,28299,17,18633,12,,,85702,29,3093.9,18,16,7513,99,+++++,+++,5140=
,98,3964,67,+++++,+++,5652,99

real    3m51.883s
user    0m0.360s
sys     0m46.099s

I'd previously blogged a test with 2.6.29-rc2 and there's no
real difference between the two runs.

http://www.csamuel.org/2009/01/04/btrfs-raid1-benchmark-on-dell-e4200-with-=
128gb-ssd

=46or a comparison, here is XFS on a single partition:

Version 1.03c       ------Sequential Output------ --Sequential Input- --Ran=
dom-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --See=
ks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec=
 %CP
sys26            2G           62075  19 36634  16           92023  26  1432=
  12
                    ------Sequential Create------ --------Random Create----=
=2D---
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Dele=
te--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP
                 16   585  13 +++++ +++   578   5   538  11 +++++ +++   417=
   5
sys26,2G,,,62075,19,36634,16,,,92023,26,1431.8,12,16,585,13,+++++,+++,578,5=
,538,11,+++++,+++,417,5

real    4m10.987s
user    0m0.404s
sys     0m33.602s

Block I/O is faster, but btrfs hammers it for metadata operations, an
order of magnitude faster!

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart2840924.bofnbdQ3vC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASZVoEI1yjaOTJg85AQIwOQf9G+ma6ESysJlkYRMFouIt/TUsHunJ4u8g
my5dwHkogGrfvrlKu7UMIF5DLSrMvcyEgaHu1gH/MFIL+Dv8DVgzb0Qpt3/MygI6
AE1kx+gqP5d7xHRA1+0BOja4BaKvFV/3vpLmdc7H30/ZLhpcdosryRrspP716Gxz
A7FKawII2Mt679g7F16fCx2gh1CmQ3jgN7/IGGHuW0Fvvz2pqtbzsnLmOohZ7mpk
4VuVM4jkQfOnvXMG1IH8kgRXqEQhXlpInVwaIzG0RIfRnHtM3hNh1SysIPkuxCyQ
IHDJKKcA+FAnJSO6vEpMQzBeMwhoNPUZ3kDRpQBRshXbw6VtXW4f4g==
=F8ei
-----END PGP SIGNATURE-----

--nextPart2840924.bofnbdQ3vC--
