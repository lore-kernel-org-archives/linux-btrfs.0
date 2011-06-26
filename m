From: Hugo Mills <hugo@carfax.org.uk>
Subject: Integration branch updated
Date: Sun, 26 Jun 2011 22:10:22 +0100
Message-ID: <20110626211022.GA24675@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I've just updated the btrfs-progs integration branch I've been
keeping. Not a huge amount new since last time:

Andreas Philipp (1):
      print parent ID in btrfs subvolume list

Goffredo Baroncelli (1):
      Scan the devices listed in /proc/partitions

Hugo Mills (1):
      mkfs.btrfs: Fix compilation errors with gcc 4.6

Zhong, Xin (1):
      btrfs-progs: Improvement for making btrfs image from source directory.

cwillu (1):
      Btrfs-progs: Correct path munging in bcp

   I've also re-worked my balance-management patches to deal with a
few oddities in the ordering of the help output, and the parameter
counts for the various balance commands.

   You can get the latest version from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110626

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOB6A+IKyzvlFcI40RAri7AJ9FOmthuapfjgruvcxCNS9eWUd07gCfdspJ
gdiRhdqH9b/smCqxhUZtM7c=
=eJOI
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
