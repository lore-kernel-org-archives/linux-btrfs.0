From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: How to get the default subvolume?
Date: Fri, 8 Jul 2011 10:58:02 +0100
Message-ID: <20110708095802.GA19280@carfax.org.uk>
References: <20110708095802.GA11513@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Cc: linux-btrfs@vger.kernel.org
To: Yi Yang <yi.y.yang@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110708095802.GA11513@yangyi-dev.bj.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 08, 2011 at 05:58:02PM +0800, Yi Yang wrote:
> I know I can set the default subvolume for a btrfs fs using
> 
> sudo btrfs subvolume set-default 256 /btrfs/mnt
> 
> But after that, how can get the default subvolume name? In my opinion,
> btrfs-progs should provide "btrfs subvolume get-default /btrfs/mnm" to get
> the default subvolume id and name, I think it is very easy to do this in
> btrfs-progs and btrfs kernel space.

   I don't think the current btrfs-progs will do it. As you pointed
out though, it's pretty easy to write the code to get the information
(I implemented it for btrfs-gui without any additional kernel code,
for example). We just need someone to implement it. :)

   I'd do it myself, but there's about a dozen things higher up my
priority list right now.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOFtSqIKyzvlFcI40RAr/wAKCypDXMYM9QqOyvL14GsMMRfogvgwCdG+wX
0pM7dYMQ6vRCjvge42Fnvys=
=uIxq
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
