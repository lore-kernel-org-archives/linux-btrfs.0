From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sat, 9 Apr 2011 21:38:23 +0100
Message-ID: <20110409203823.GF5301@carfax.org.uk>
References: <1302370000.23240.10.camel@nayuki>
 <BjX0wGIi1uB@helmut.hullen.de>
 <20110409193549.1809.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409193549.1809.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 09, 2011 at 09:35:49PM +0200, Peter Stuge wrote:
> But for such filesystems, Linux can't do what Helmut would like.

   Indeed. In the general case, there's no single number that "gets it
right". That said, if data and metadata are the same replication type
for the whole filesystem, you *can* get it pretty much exactly
right(*); if data is the same type for the whole filesystem, you can
get it *nearly* right (since metadata is typically a small fraction of
the data size).

(*) Ignoring the space required for reservations to actually do
anything with the filesystem when it's very close to full...

> Maybe it would be possible to optimize the reported numbers, to be
> what the user actually wants as often as possible. Ie. if there is
> only one type of backing storage (sorry, don't know the terms) then

   RAID level or replication strategy. Although "RAID" gives a
slightly misleading impression of what actually happens in btrfs...

> the calculation would be easier to get right, following the simple
> formula that was just given. This is all eye candy however,
> completely irrelevant IMO as long as the filesystem oopses, or eats
> root nodes. :)
> 
> 
> //Peter

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Great oxymorons of the world, no.  3: Military Intelligence ---   

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNoMO/IKyzvlFcI40RAokzAKCiNNMUNOPlBmYXmBoMqknEG6hFZwCeIcB0
uk7K4DbAGT//8AhryZFTGCY=
=tt0w
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
