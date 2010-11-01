From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [patch 1/2] Balance progress monitoring (updated)
Date: Mon, 1 Nov 2010 12:55:10 +0000
Message-ID: <20101101125510.GA4709@vlad.carfax.org.uk>
References: <20101030000726.286517546@carfax.org.uk>
 <20101030000741.689283553@carfax.org.uk>
 <20101030133934.GD9369@selene>
 <4CCE751D.6030204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CCE751D.6030204@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 01, 2010 at 04:06:53PM +0800, liubo wrote:
> On 10/30/2010 09:39 PM, Hugo Mills wrote:
> > This patch introduces a basic form of progress monitoring for balance
> > operations, by counting the number of block groups remaining. The
> > information is exposed to userspace by an ioctl.
> > 
> 
> IMO, tracking the information of blocks which are balancing also makes sense. 
> For example, the block information's blocknr. 
> It can help us monitor better.

   I don't see how that will help. The block group IDs (which is all
that we get at this level) are effectively arbitrary 64-bit numbers,
and are what appear in the kernel logs. How could that information be
used to improve monitoring?

   I'm not ruling out the idea completely -- I just can't see at the
moment how it would be used.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- Is a diversity twice as good as a university? ---          

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMzriuIKyzvlFcI40RAuG7AJ9zjLbVR30Y7cSoIEsuU8zT4krzCACfbiwW
SolvJa3vBGHWJTXxByQI15g=
=h4ti
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
