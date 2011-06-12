From: Hugo Mills <hugo@carfax.org.uk>
Subject: btrfs-progs -- all the patches in one place
Date: Sun, 12 Jun 2011 22:40:47 +0100
Message-ID: <20110612214047.GA832@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I've just spent the last few hours hoovering up all of the
uncommitted user-space patches I could find on the mailing list since
November, and applying them all into one git branch. It's on my git
repo[1], in the "integration-20110611" branch. I was pretty uncritical
about what I picked up, so there may be some lemons in there. It
passes a basic "make" smoketest, but I've not tested any further than
that yet.

   Highlights include:

 * support for scrub
 * support for read-only snapshots
 * support for balance management
 * fix for chunk allocation in mixed data/meta filesystems

   I've also integrated a bunch of fixes and tweaks from other people.
The full shortlog is below.

   I'll try to keep a branch updated with any userspace patches that
hit the list from now on.

   Hugo.

Andreas Philipp (5):
      Added support for an additional ioctl.
      Add support for read-only subvolumes.
      Support the new parameters in do_clone(int argc, char** argv).
      Test the additional ioctl.
      Updated manpage for btrfs subvolume snapshot.

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

Hubert Kario (2):
      add advanced use of --help to help message
      add detailed help messages to btrfs command

Hugo Mills (9):
      btrfs-progs: Fix over-sized limit on buffer
      Balance progress monitoring.
      Add --monitor option to btrfs balance progress.
      User-space tool for cancelling balance operations.
      Run userspace tool in background for balances.
      Initial implementation of userspace interface for filtered balancing.
      Balance filter by device ID
      Balance filter for virtual address range
      Interface for device range balance filter

Jan Schmidt (6):
      mkfs should initialize unused fields properly
      commands added
      scrub ioctls
      added check_mounted_where
      scrub userland implementation
      scrub added to manpage

Sergei Trofimovich (8):
      btrfs-convert: fix typo: 'all inode' -> 'all inodes'
      mkfs.btrfs: fail on scandir error (-r mode)
      mkfs.btrfs: return some defined value instead of garbage when lookup checksum
      mkfs.btrfs: fix symlink names writing
      mkfs.btrfs: write zeroes instead on uninitialized data.
      mkfs.btrfs: free buffers allocated by pretty_sizes
      mkfs.btrfs: fix memory leak caused by 'scandir()' calls
      mkfs.btrfs: fix error text in '-r' mode

Tsutomu Itoh (1):
      btrfs-progs: setting of time to the root directory


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, ---  
                and a natural deficiency in moral fibre.                 

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN9TJfIKyzvlFcI40RAgwdAKCxNPyp7LMxY+zKi8mxJKu6gEwpcgCfXL57
ZiiVQXwaPlRCNpEzV+2Co8c=
=aMKC
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
