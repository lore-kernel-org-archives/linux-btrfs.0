From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-convert options
Date: Mon, 27 Feb 2012 10:13:01 +0000
Message-ID: <20120227101301.GF18898@carfax.org.uk>
References: <C3f2V78D1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3f2V78D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2012 at 08:52:00AM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> I want to change some TByte disks (at least one) from ext4 to btrfs. And  
> I want "-d raid0 -m raid1". Is it possible to tell btrfs-convert  
> especially these options for data and metadata?
> 
> Or have I to use "mkfs.btrfs" (and then copy the backup) when I want  
> these options?

   The other alternative is to get hold of 3.3-rcX and the latest
userspace tools (currently in the "dangerdonteveruse branch, but
should be in "master" very soon), and use the restriper after you've
converted.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                  --- Be pure. Be vigilant. Behave. ---                  

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPS1ctIKyzvlFcI40RAqj4AJ9MrhkmogN+fiZHkjlZYzBEu9vcCACfez3j
jwv+qUgkFyw/eYsy/Ln4e/w=
=uq3H
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
