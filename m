From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 08:59:38 +0000
Message-ID: <20120126085938.GC5531@carfax.org.uk>
References: <4F208FFD.4020508@online.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Cc: linux-btrfs@vger.kernel.org
To: Waxhead <waxhead@online.no>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F208FFD.4020508@online.no>
List-ID: <linux-btrfs.vger.kernel.org>


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2012 at 12:27:57AM +0100, Waxhead wrote:
> Hi,
> 
> From what I have read BTRFS does replace a bad copy of data with a
> known good copy (if it has one).

   Correct.

> Will BTRFS try to repair the corrupt data or will it simply silently
> restore the data without the user knowing that a file has been
> "fixed"?

   No, it'll just return the good copy and report the failure in the
system logs. If you want to fix the corrupt data, you need to use
scrub, which will check everything and fix blocks with failed
checksums.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPIRX5IKyzvlFcI40RAkw0AJ96hLgKARuBWtoRQQBOqbrj9TMLuwCeKOYU
RtxyuI1SX8QI3eopQbPINNY=
=FLoU
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
