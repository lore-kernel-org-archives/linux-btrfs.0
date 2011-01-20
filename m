From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Btrfs balance
Date: Thu, 20 Jan 2011 13:39:57 +0000
Message-ID: <20110120133957.GB1301@carfax.org.uk>
References: <4D38338B.3090903@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38338B.3090903@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 20, 2011 at 02:07:23PM +0100, Andreas Philipp wrote:
> Hi,
> 
> Maybe it is a very stupid question but I want to ask it anyway. In
> general, 'btrfs filesystem balance' takes very long to finish and
> produces lots of IO. So what are the classical usage scenarios, when
> it is (really) worth doing a balance?

   The primary use-cases for balancing are to even out the filesystem
after adding, removing or changing the size of one of the underlying
volumes.

   It will also be of use when we finally get around to allowing you
to change RAID settings on the whole volume, to implement the
requested changes to the RAID level.

   I'm in the process of implementing balance filters, so that some
other cases where balancing is useful (reclaiming unused block groups)
can be run more efficiently by only balancing the bits that need
doing.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Prisoner unknown:  Return to Zenda. ---               

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNODstIKyzvlFcI40RAsuNAJ9703z6QxVxQj0fA2NEJ1GZslTeXQCfUgDc
tQKlqrf7kgYwV7799ZawuPo=
=D8UL
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
