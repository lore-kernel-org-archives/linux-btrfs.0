From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-raid10 <-> btrfs-raid1 confusion
Date: Sun, 6 May 2012 16:23:43 +0100
Message-ID: <20120506152343.GL9860@carfax.org.uk>
References: <4FA68F50.60505@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iAzLNm1y1mIRgolD"
Cc: linux-btrfs@vger.kernel.org
To: Alexander Koch <lynix47@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA68F50.60505@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--iAzLNm1y1mIRgolD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 06, 2012 at 04:48:48PM +0200, Alexander Koch wrote:
> Greetings,
> 
> until yesterday I was running a btrfs filesystem across two 2.0 TiB
> disks in RAID1 mode for both metadata and data without any problems.
> 
> As space was getting short I wanted to extend the filesystem by two
> additional drives lying around, which both are 1.0 TiB in size.
> 
> Knowing little about the btrfs RAID implementation I thought I had to
> switch to RAID10 mode, which I was told is currently not possible (and
> later found out that it is indeed).
> Then I read this [1] mailing list post basically saying that, in the
> special case of four disks, btrfs-raid1 behaves exactly like RAID10.
> 
> So I added the two new disks to my existing filesystem
> 
>     $ btrfs device add /dev/sde1 /dev/sdf1 /mnt/archive
> 
> and as the capacity reported by 'btrfs filesystem df' did not increase,

   It won't -- "btrfs fi df" reports what's been allocated out of the
raw pool. To check that the disks have been added, you need "btrfs fi
show" (no parameters).

> I started a balancing run:
> 
>     $ btrfs filesystem balance start /mnt/archive
> 
> Waiting for the balancing run to finish (which will take much longer
> than I thought; still running) I found out that as of kernel 3.3
> changing the RAID level (aka restriping) is now possible: [2].

   It is indeed.

> I got two questions now:
> 
> 1.) Is there really no difference between btrfs-raid1 and btrfs-raid10
>     in my case (2 x 2TiB, 2 x 1TiB disks)? Same degree of fault
>     tolerance?

   There's the same degree of fault tolerance -- you're guaranteed to
be able to lose one disk from the array and still have all your data.

   The data will be laid out in a different way on the disks, though.
In your case, with four unevenly-sized disks, you will get the best
usage out of the filesystem with RAID-1. With only 4 disks, RAID-10
will run out of space when the smallest disk is full. (So, in your
configuration, you'd still have only 2TB of space usable, rather
defeating the point of having the new disks in the first place).

> 2.) Summing up the capacities reported by 'btrfs filesystem df' I only
>     get ~2.25 TiB for my filesystem, is that a realistic net size for
>     3 TiB gross?

   You're not comparing the right numbers here. "btrfs fi show" shows
the raw available unallocated space that the filesystem has to play
with. "btrfs fi df" shows only what it's allocated so far, and how
much of the atllocation it has used -- in this case, because you've
added new disks, there's quite a bit of free space unallocated still,
so the numbers below won't add up to anything like 3TB.

>     $ btrfs filesystem df /mnt/archive
>     Data, RAID1: total=2.10TB, used=1.68TB
>     Data: total=8.00MB, used=0.00
>     System, RAID1: total=40.00MB, used=324.00KB
>     System: total=4.00MB, used=0.00
>     Metadata, RAID1: total=112.50GB, used=3.21GB
>     Metadata: total=8.00MB, used=0.00

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, ---  
                and a natural deficiency in moral fibre.                 

--iAzLNm1y1mIRgolD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPppd/IKyzvlFcI40RAqLLAJ9hyq5Uc2QhmtgELfk+T8ZZ8IZtJwCfWKXk
GJ2pClrefqma668qFwt7vmI=
=jMhL
-----END PGP SIGNATURE-----

--iAzLNm1y1mIRgolD--
