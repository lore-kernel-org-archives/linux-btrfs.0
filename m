From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Sat, 17 Mar 2012 14:43:38 +0000
Message-ID: <20120317144337.GJ3172@carfax.org.uk>
References: <20120317140057.GF3172@carfax.org.uk>
 <C52qXqKD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C52qXqKD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 17, 2012 at 03:24:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 17.03.12:
> 
> >> What's the 'solution' though to Hugo's situation?
> >> By 'solution' I mean the highest-utility way of dealing with unequal
> >> devices problem in a two or more -up setting.
> 
> >    Use mkfs.btrfs -d single, as I said in another part of this
> > thread.
> 
> Does "single" allow adding new (bigger) disks and removing old (smaller)  
> disks?

   Yes. "single" is effectively "RAID linear" -- just adding the disks
together, effectively linearly(*). It's called "single" because it's
single (i.e. no) redundancy.

   Hugo.

(*) actually the allocator will kind of "stripe" the data in 1GiB-wide
stripes, but that's incidental really.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- A diverse working environment:  Di longer you vork here, di ---   
                             verse it gets.                              

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZKMZIKyzvlFcI40RAkd7AKDQH8yrH5f8n1MYSzL9l66WY/fDBwCfU3/f
rStzIeExjVuyrDFVszkNLKI=
=NLvP
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
