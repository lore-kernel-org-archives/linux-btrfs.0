From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: unexpected raid1 behavior?
Date: Fri, 27 Nov 2009 21:04:42 +0000
Message-ID: <20091127210442.GA18273@vlad.carfax.org.uk>
References: <200911271541.17451.jean.philippe.robichaud@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: linux-btrfs@vger.kernel.org
To: Jean-Philippe Robichaud <jean.philippe.robichaud@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911271541.17451.jean.philippe.robichaud@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

yOn Fri, Nov 27, 2009 at 03:41:17PM -0500, Jean-Philippe Robichaud wrote:
> Now I have 2 partitions (on 2 different sata disks) that are free for me to 
> play with, each about 375 gb in size.  I wanted to create a "raid1" volume 
> using these two partitions, so I did:
>  
> # mkfs.btrfs -d raid1 /dev/sda5 /dev/sdb5
> # mount /dev/sda5 /btrfs
> 
> and everything seems fine.
> 
> Now what I find strange is that everything looks like a raid0 was created, not 
> a raid1:
> 
> $ df -h /btrfs/
>  Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda5             684G   72G  612G  11% /btrfs
> 
> What am I doing (or understanding) wrong?

   It's effectively showing you the number of unallocated blocks, so
(with a RAID-1, single-redundancy filesystem), files will appear to
take twice as much of your free space as you think they should: write
a 2GiB file to that filesystem, and free space will drop by 4GiB.

   I think that the reasoning behind this is that if you're using
per-object mirroring/striping, it's impossible to give a precise count
of the free space remaining on the volume in any meaningful way: write
a 1GiB striped file, and you'll take 1GiB of space; write the same
file mirrored, and you'll take 2GiB of space.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- There are three mistaiks in this sentance. ---            

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFLED7pIKyzvlFcI40RAnewAJ97gubvRm+KJmExXtlnY1zLJi8o1QCdGr/I
caKXs/bY7dPsEdD7mr6QO2U=
=qkuI
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
