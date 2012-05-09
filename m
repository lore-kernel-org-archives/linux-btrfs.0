From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: failed disk (was: kernel 3.3.4 damages filesystem (?))
Date: Wed, 9 May 2012 14:19:58 +0100
Message-ID: <20120509131958.GP8938@carfax.org.uk>
References: <20120507184448.GH8938@carfax.org.uk>
 <C8XIEzzeCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDy5+/kaQUC2a3Gw"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8XIEzzeCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--KDy5+/kaQUC2a3Gw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 03:04:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 07.05.12:
> 
> >>>    mkfs.btrfs -m raid1 -d single should give you that.
> 
> >> What's the difference to
> >>
> >>      mkfs.btrfs -m raid1 -d raid0
> 
> >  - RAID-0 stripes each piece of data across all the disks.
> >  - single puts data on one disk at a time.
> 
> [...]
> 
> 
> >    In fact, this is probably a good argument for having the option to
> > put back the old allocator algorithm, which would have ensured that
> > the first disk would fill up completely first before it touched the
> > next one...
> 
> The actual version seems to oscillate from disk to disk:

   Yes, specifically, when it's asked for n chunks to make up a block
group, the current allocator will pick the n disks with the most free
space on them. The original allocator would pick the disks with the
smallest devid (which is probably optimal for your use case -- hence
my comment above).

> Watching the amount showed that both disks are filled nearly  
> simultaneously.
> 
> That would be more difficult to restore ...

   If your files are small compared to the block group size (1GiB in
this case), then the odds of a file spanning block groups are small.
With files similar in size to, or larger than, a chunk, you will be
far more likely to lose some part of the file when a disk goes away.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--KDy5+/kaQUC2a3Gw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqm79IKyzvlFcI40RAmGoAKC+lPVwpwD/Mw1frkh/rkVSdwrrvACfWGoi
HeRn+hdZs/0q6ek1I7y7dLU=
=+YzK
-----END PGP SIGNATURE-----

--KDy5+/kaQUC2a3Gw--
