From: Chris Samuel <chris@csamuel.org>
Subject: [PATCH] Fix "set-dafault" typo in cmds-subvolume.c
Date: Fri, 11 May 2012 22:55:17 +1000
Message-ID: <201205112255.18613.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3281700.vcf6AFqhEa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3281700.vcf6AFqhEa
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Andrei Popa reported that there were two typos of default as dafault,
this patch fixes those two typos up.

Signed-off-by: Chris Samuel <chris@csamuel.org>
=2D--
 cmds-subvolume.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..23c72b4 100644
=2D-- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -394,7 +394,7 @@ static int cmd_snapshot(int argc, char **argv)
 }
=20
 static const char * const cmd_subvol_get_default_usage[] =3D {
=2D       "btrfs subvolume get-dafault <path>",
+       "btrfs subvolume get-default <path>",
        "Get the default subvolume of a filesystem",
        NULL
 };
@@ -432,7 +432,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 }
=20
 static const char * const cmd_subvol_set_default_usage[] =3D {
=2D       "btrfs subvolume set-dafault <subvolid> <path>",
+       "btrfs subvolume set-default <subvolid> <path>",
        "Set the default subvolume of a filesystem",
        NULL
 };
=2D-=20
1.7.4.1

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3281700.vcf6AFqhEa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT60MNo1yjaOTJg85AQKvywf9H/uc2SQ+ksWG6O+o44H5/QLGuGE4c37A
Z8m8xwgKUl5xrXWBVoLNDpShzNWwtuNt7/RABN6jyzNUfTQqoE1QXEuqWqZSJyqq
E24+P1a+mftXuuZ44PJ6hRyS12mHO7cHgMkDlA2m5IuFH6cPh9BNV4VpU5zhoDwH
LIBvG3AAcx0Oi/TedM7EIAVRxC9sdcGLeD+2weLzwppmCvEA0jQqdRX6hfjYwsWu
MjYVNoJygcnBj8wjRt55tf1t0GYoYgJ1zXwmh5EuOFh47XHnM6XMhXqMhTOXgcsl
JbFTzrOk6d1ZTqZXYaXj17NMxiQ7+ftnMDUVZuP2TVyUL8et9dVKEg==
=KsGo
-----END PGP SIGNATURE-----

--nextPart3281700.vcf6AFqhEa--
