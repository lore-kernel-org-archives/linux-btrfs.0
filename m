From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs defra
Date: Mon, 13 Jun 2011 16:54:20 +0100
Message-ID: <20110613155420.GA14384@carfax.org.uk>
References: <1307976637.2285.15.camel@andromeda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Cc: linux-btrfs@vger.kernel.org
To: Bernhard Duebi <bernhard@due.bi>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307976637.2285.15.camel@andromeda>
List-ID: <linux-btrfs.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 13, 2011 at 04:50:37PM +0200, Bernhard Duebi wrote:
> I'm no developer, just a simple user. I use btrfs as the root filesystem
> on my laptop. I use VirtualBox. Every VB disk lives in a separat btrfs
> subvolume. I use btrfs snapshots for backup and to clone VB VMs.
> 
> I wonder what happens when I defrag a file that is part of multiple
> snapshots? Will all instances of this file be defragmented, or will the
> file get its own fresh copy?

   The file gets its own copy.

> If it is important, my system is a 64bit ubuntu 10.10 and the filesystem
> is mounted with the option compress. If it helps, I would consider to
> upgrade to 11.04.
> 
> BTW: what is the difference between defrag and balance ?

   Defrag works on individual files, and tries to find a contiguous
sequence of bytes to write the file's data to. In the process, the
current implementation will break any CoW duplication -- either within
single files (copies with cp --reflink=always) or files copied via
snapshotting.

   Balance works at a much higher level, rewriting all (or large
quantities) of the filesystem data and metadata. Balance was
originally designed to re-allocate all of the space the FS needs, thus
enabling you to add more disks to a filesystem and ensure that they
get used. (It's also useful for re-building spare copies of data if a
disk's been removed as a result of failure). Balance will maintain all
existing file semantics as it runs -- CoW copies are preserved, and no
additional space will be used.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN9jKsIKyzvlFcI40RAgcfAJ9vI8YnryOm/smagAVNgZ1LRhI2+wCfTAvA
iZHK3bEilXWUmg1M1o8hd1g=
=29Wp
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
