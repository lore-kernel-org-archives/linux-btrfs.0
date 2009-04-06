From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Problem with renaming devices
Date: Mon, 6 Apr 2009 18:41:35 +0100
Message-ID: <20090406174135.GC27111@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   There seems to be some issue over changing the names of the device
that a btrfs filesystem lives on:

# lvcreate scratch -n fstest -L 2G
  Logical volume "fstest" created
# mkfs -t btrfs /dev/scratch/fstest

WARNING! - Btrfs v0.18-ge3b0f66 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/scratch/fs1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs v0.18-ge3b0f66

# mount /dev/scratch/fstest /mnt
# umount /mnt

# lvrename scratch fstest derek
  Renamed "fstest" to "derek" in volume group "scratch"
# mount /dev/scratch/derek /mnt
mount: /dev/mapper/scratch-derek: can't read superblock

# lvrename scratch derek fstest
  Renamed "derek" to "fstest" in volume group "scratch"
# mount /dev/scratch/fstest /mnt
[success]

   The rename works properly on a completely virgin filesystem, but
not on one that's been mounted and unmounted (as above).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Happiness is mandatory.  Are you happy? ---             

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJ2j7PIKyzvlFcI40RAtiGAJ9hoAhKsmaBQjLP0ER+owJGptUj6QCgyQ4m
8M4BqtockkQ8qcXeCDjX7dg=
=UvHl
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
