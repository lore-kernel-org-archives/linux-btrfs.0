From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: failed disk (was: kernel 3.3.4 damages filesystem (?))
Date: Wed, 9 May 2012 15:37:35 +0100
Message-ID: <20120509143735.GQ8938@carfax.org.uk>
References: <20120507180047.GG8938@carfax.org.uk>
 <C8XIuHi9CXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JPKYlvo4+BwO1+FT"
Cc: linux-btrfs@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8XIuHi9CXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--JPKYlvo4+BwO1+FT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 04:25:00PM +0200, Helmut Hullen wrote:
> Du meintest am 07.05.12:
> 
> [...]
> 
> >> With a file system like ext2/3/4 I can work with several directories
> >> which are mounted together, but (as said before) one broken disk
> >> doesn't disturb the others.
> 
> >    mkfs.btrfs -m raid1 -d single should give you that.
> 
> Just a small bug, perhaps:
> 
> created a system with
> 
>         mkfs.btrfs -m raid1 -d single /dev/sdl1
>         mount /dev/sdl1 /mnt/Scsi
>         btrfs device add /dev/sdk1 /mnt/Scsi
>         btrfs device add /dev/sdm1 /mnt/Scsi
>         (filling with data)
> 
> and
> 
>         btrfs fi df /mnt/Scsi
> 
> now tells
> 
> Data, RAID0: total=183.18GB, used=76.60GB
> Data: total=80.01GB, used=79.83GB
> System, DUP: total=8.00MB, used=32.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=192.74MB
> Metadata: total=8.00MB, used=0.00
> 
> --------------------------------------
> 
> "Data, RAID0" confuses me (not very much ...), and the system for  
> metadata (RAID1) is not told.

   DUP is two copies of each block, but it allows the two copies to
live on the same device. It's done this because you started with a
single device, and you can't do RAID-1 on one device. The first bit of
metadata you write to it should automatically upgrade the DUP chunk to
RAID-1.

   As to the spurious "upgrade" of single to RAID-0, I thought Ilya
had stopped it doing that. What kernel version are you running?

   Out of interest, why did you do the device adds separately, instead
of just this?

# mkfs.btrfs -m raid1 -d single /dev/sdl1 /dev/sdk1 /dev/sdm1

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Comic Sans goes into a bar,  and the barman says, "We don't ---   
                         serve your type here."                          

--JPKYlvo4+BwO1+FT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqoEvIKyzvlFcI40RAk8DAJ9vp8p8stFSnjFdEZ8pBAQxSnrVdQCgnbka
kTaSQtCK5uGGmvQeQQ3Tfi0=
=md6d
-----END PGP SIGNATURE-----

--JPKYlvo4+BwO1+FT--
