From: Hugo Mills <hugo@carfax.org.uk>
Subject: btrfs-progs: integration branch for 2011-07-03 now out
Date: Sun, 3 Jul 2011 21:21:59 +0100
Message-ID: <20110703202159.GD4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

   I've just updated the integration branch with additional patches
=66rom Andreas Philipp and the patch from Hubert Kario that I forgot to
include last time.

   Available from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110=
703

   Hugo.

Andreas Philipp (5):
      add all targets to clean target
      some style/layout changes
      print parent ID in btrfs suvolume list
      update manpage entries for btrfs subvolume list
      remove unused include "version.h"

Goffredo Baroncelli (1):
      Scan the devices listed in /proc/partitions

Hubert Kario (1):
      remove unused variables

Hugo Mills (9):
      Balance progress monitoring.
      Add --monitor option to btrfs balance progress.
      User-space tool for cancelling balance operations.
      Run userspace tool in background for balances.
      Initial implementation of userspace interface for filtered balancing.
      Balance filter by device ID
      Balance filter for virtual address range
      Interface for device range balance filter
      Fix variable-set-but-not-used warnings in chunk recovery tool

Jan Schmidt (5):
      commands added
      scrub ioctls
      added check_mounted_where
      scrub userland implementation
      scrub added to manpage

Li Zefan (1):
      Fix missing entries in listing of subvolumes

WuBo (1):
      Btrfs-progs: Add chunk tree recover tool

Zhong, Xin (1):
      btrfs-progs: Improvement for making btrfs image from source directory.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Doughnut furs ache me, Omar Dorlin. ---              =20

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOEM9nIKyzvlFcI40RAuzNAKDFtvpX9ecFBiZ0A24n4DexGuNPvwCgwpdO
0ygvZuLonMFLu+W34y8wYJA=
=UgFv
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
