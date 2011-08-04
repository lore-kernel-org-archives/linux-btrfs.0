From: Hugo Mills <hugo@carfax.org.uk>
Subject: [GIT PULL] btrfs-progs
Date: Fri, 5 Aug 2011 00:00:04 +0100
Message-ID: <20110804230004.GE8970@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Chris,

   I've finally reworked the integration branch, and integrated what
should be a good version of the scrub userspace. You can pull it from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ for-chris

   Hugo.

Andreas Philipp (10):
      Added support for an additional ioctl.
      Add support for read-only subvolumes.
      Support the new parameters in do_clone(int argc, char** argv).
      Test the additional ioctl.
      Updated manpage for btrfs subvolume snapshot.
      add all targets to clean target
      some style/layout changes
      print parent ID in btrfs suvolume list
      update manpage entries for btrfs subvolume list
      remove unused include "version.h"

Anton Blanchard (1):
      btrfs-progs: cast u64 to long long to avoid printf warnings

Arne Jansen (3):
      btrfs-map-logical: usage update
      btrfs progs: fix extra metadata chunk allocation in --mixed case
      btrfs-map-logical: segfaults when no output file is given

Chris Ball (1):
      Fix unused-but-set errors in gcc-4.6

Fajar A. Nugraha (1):
      make "btrfs filesystem label" command actually work

Hubert Kario (3):
      add advanced use of --help to help message
      add detailed help messages to btrfs command
      remove unused variables

Hugo Mills (4):
      btrfs-progs: Fix over-sized limit on buffer
      mkfs.btrfs: Fix compilation errors with gcc 4.6
      gcc 4.6: fix potentially unused variable
      fix incorrect argument checking for "btrfs sub snap -r"

Jan Schmidt (6):
      mkfs should initialize unused fields properly
      btrfs-progs: commands added
      btrfs-progs: scrub ioctls
      btrfs-progs: added check_mounted_where
      btrfs-progs: scrub userland implementation
      btrfs-progs: scrub added to manpage

Kamble, Nitin A (1):
      make btrfs cross compilation friendly

Sergei Trofimovich (8):
      btrfs-convert: fix typo: 'all inode' -> 'all inodes'
      mkfs.btrfs: fail on scandir error (-r mode)
      mkfs.btrfs: return some defined value instead of garbage when lookup checksum
      mkfs.btrfs: fix symlink names writing
      mkfs.btrfs: write zeroes instead on uninitialized data.
      mkfs.btrfs: free buffers allocated by pretty_sizes
      mkfs.btrfs: fix memory leak caused by 'scandir()' calls
      mkfs.btrfs: fix error text in '-r' mode

Stephane Chazelas (1):
      incorrect argument checking for "btrfs sub snap -r"

Tsutomu Itoh (1):
      btrfs-progs: setting of time to the root directory

cwillu (1):
      Btrfs-progs: Correct path munging in bcp

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       --- Strive for apathy! ---                        

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOyR0IKyzvlFcI40RAn9hAJ0fb9c2xaQNOFVQUhh2AVbWRZ5zNACeJ0IW
DTR6DheLSM8R+IbK0hTUZ/Y=
=guz/
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
