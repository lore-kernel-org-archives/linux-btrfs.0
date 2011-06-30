From: Hugo Mills <hugo@carfax.org.uk>
Subject: [GIT PULL] btrfs-progs: first slice of integration branch
Date: Thu, 30 Jun 2011 21:22:45 +0100
Message-ID: <20110630202245.GA4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
To: Chris Mason <chris.mason@oracle.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

   Hi, Chris,

   I've done a more detailed examination of the patches in my
integration branch of btrfs-progs, and this is the set of small and
generally inoffensive/uncontroversial patches from that stack. I've
reviewed them all, and didn't see anything horribly wrong in there.

   Since I was looking for the low-hanging fruit in getting this first
lot out, I've omitted the scrub, balance management, and chunk tree
recovery features in this round -- they'll be along when I've had a
chance to review the longer additions in more detail.

   The series is based on the tmp branch, and can be pulled from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ for-chris

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

Hugo Mills (2):
      btrfs-progs: Fix over-sized limit on buffer
      mkfs.btrfs: Fix compilation errors with gcc 4.6

Jan Schmidt (1):
      mkfs should initialize unused fields properly

Kamble, Nitin A (1):
      make btrfs cross compilation friendly

Sergei Trofimovich (8):
      btrfs-convert: fix typo: 'all inode' -> 'all inodes'
      mkfs.btrfs: fail on scandir error (-r mode)
      mkfs.btrfs: return some defined value instead of garbage when lookup =
checksum
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

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- What's a Nazg=FBl like you doing in a place like this? ---     =
=20

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODNsVIKyzvlFcI40RAretAJ4uBScVyZw3euOqFtBNFFtJKzZenACggzYj
2qPpeFeLOK+OTDPZHisNMNg=
=WZIY
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
