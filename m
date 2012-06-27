Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62579 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2F0MLh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 08:11:37 -0400
Received: by werb10 with SMTP id b10so215182wer.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 05:11:36 -0700 (PDT)
Message-ID: <4FEAF872.10507@grimmer.com>
Date: Wed, 27 Jun 2012 14:11:30 +0200
From: Lenz Grimmer <lenz@grimmer.com>
MIME-Version: 1.0
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Error compiling btrfs-tools from git (undefined reference to `pthread_create')
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAAC75723E1BE2E7402694CD3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAAC75723E1BE2E7402694CD3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Ubuntu 11.10 "Oneiric" with gcc 4.6.1, compiling the btrfs tools from =
git
fails for me with the following error:

[lenz@metis btrfs-progs]% make
bash version.sh
gcc -lpthread -g -Werror -Os -o btrfs btrfs.o btrfs_cmds.o scrub.o \
		ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o  -=
luuid
scrub.o: In function `scrub_start':
/space/tmp/btrfs-progs/scrub.c:1342: undefined reference to `pthread_crea=
te'
/space/tmp/btrfs-progs/scrub.c:1360: undefined reference to `pthread_crea=
te'
/space/tmp/btrfs-progs/scrub.c:1374: undefined reference to `pthread_join=
'
/space/tmp/btrfs-progs/scrub.c:1430: undefined reference to `pthread_canc=
el'
/space/tmp/btrfs-progs/scrub.c:1432: undefined reference to `pthread_join=
'
collect2: ld returned 1 exit status
make: *** [btrfs] Error 1

The following change fixed this for me, not sure if it's the appropriate =
approach:

diff --git a/Makefile b/Makefile
index edee1a0..9e3a06f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 CC =3D gcc
 AM_CFLAGS =3D -Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
-CFLAGS =3D -g -Werror -Os
+CFLAGS =3D -g -Werror -Os -pthread
 objects =3D ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
          root-tree.o dir-item.o file-item.o inode-item.o \
          inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \


--=20
  Lenz Grimmer <lenz@grimmer.com> - http://www.lenzg.net/


--------------enigAAC75723E1BE2E7402694CD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk/q+HIACgkQSVDhKrJykfK9mQCeOS1B094gk26D+PbQfZlVrqa0
2f4An1KiQTGFhJLCfR6RaOVf4mwmx84x
=yfBv
-----END PGP SIGNATURE-----

--------------enigAAC75723E1BE2E7402694CD3--
