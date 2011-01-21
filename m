From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Shrinking virtual disk with btrfs on it
Date: Fri, 21 Jan 2011 17:34:19 +0000
Message-ID: <20110121173419.GA5268@carfax.org.uk>
References: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Rodney Beede <mailinglist@rodneybeede.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimVGfP0UFgkTEtrqrc8RoPPoqgwu=x--KHa3Y9j@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 21, 2011 at 10:20:34AM -0700, Rodney Beede wrote:
> Any tools to go about zeroing about the free space on a btrfs file
> system so I can shrink the VMware vmdk virtual disk?
> 
> I ran the VMware command, but the dynamic disk is still really big.  I
> presume it is due to free space that isn't zeroed out.

   One solution I've used before is to write a single very large file
full of zeroes, filling the filesystem, then delete it.

$ dd if=/dev/zero of=/mountpoint/foo.dat && rm /mountpoint/foo.dat

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOcObIKyzvlFcI40RAodJAJ0VyXnvxNH2MxTZ08uT8WaywsA+0gCfQkV6
7MRCSpCsPWGiXeS73ItqnWA=
=ngld
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
