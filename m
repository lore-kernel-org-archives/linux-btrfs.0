From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache
 off?
Date: Wed, 15 Feb 2012 16:59:18 +0000
Message-ID: <20120215165918.GA17761@carfax.org.uk>
References: <20120202124241.GW16796@shiny>
 <20120202152722.GI12429@merlins.org>
 <20120130003754.GD4380@merlins.org>
 <20120201175624.GE16796@shiny>
 <20120202032345.GB31903@merlins.org>
 <20120212223242.GA31989@merlins.org>
 <4F384FAA.5060506@redhat.com>
 <20120213001400.GD31989@merlins.org>
 <1329320563.1897.6.camel@ayu>
 <20120215165540.GC4763@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, jeff@deserettechnology.com
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120215165540.GC4763@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 15, 2012 at 08:55:40AM -0800, Marc MERLIN wrote:
> https://btrfs.wiki.kernel.org/articles/g/o/t/Gotchas.html
> still states 'btrfs volumes on top of dm-crypt block devices (and possibly
> LVM) require write-caching to be turned off on the underlying HDD. Failing
> to do so, in the event of a power failure, may result in corruption not yet
> handled by btrfs code. (2.6.33) '
> 
> I'm happy to fix both pages, but the login link of course doesn't work and
> I'm not sure where the canonical copy to edit actually is or if I can get
> access.

   btrfs.ipv5.de

   It's a "temporary" location (6 months and counting) while
kernel.org is static-pages-only.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- The English language has the mot juste for every occasion. ---    

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPO+RmIKyzvlFcI40RAjp7AJwKi4TDs/DCX2D3mPl8BAFsMUM8qQCeOhuv
LidxNqWG5qRXzh1IvyF07vo=
=qlhP
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
