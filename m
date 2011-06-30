From: Hugo Mills <hugo@carfax.org.uk>
Subject: btrfs-progs: integration branch updated
Date: Thu, 30 Jun 2011 22:19:02 +0100
Message-ID: <20110630211902.GC4352@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   After a reorganisation of patches, and sending a bunch of them to
Chris, I've also updated the integration branch to match that. It's
available from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110630

   The shortlog of 17 patches in this branch beyond the ones I've sent
to Chris is below.

   Hugo.


Andreas Philipp (1):
      print parent ID in btrfs subvolume list

Goffredo Baroncelli (1):
      Scan the devices listed in /proc/partitions

Hugo Mills (8):
      Balance progress monitoring.
      Add --monitor option to btrfs balance progress.
      User-space tool for cancelling balance operations.
      Run userspace tool in background for balances.
      Initial implementation of userspace interface for filtered balancing.
      Balance filter by device ID
      Balance filter for virtual address range
      Interface for device range balance filter

Jan Schmidt (5):
      commands added
      scrub ioctls
      added check_mounted_where
      scrub userland implementation
      scrub added to manpage

WuBo (1):
      Btrfs-progs: Add chunk tree recover tool

Zhong, Xin (1):
      btrfs-progs: Improvement for making btrfs image from source directory.


-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Nothing wrong with being written in Perl... Some of my best ---   
                      friends are written in Perl.                       

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFODOhGIKyzvlFcI40RAp4hAJ4zDyOcK1B4M/9wqwBWWOTILMtxTwCfSxYK
5Cv/bGNes1CzLrDxIp24lJ0=
=+a0s
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
