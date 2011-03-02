From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs wishlist
Date: Wed, 2 Mar 2011 10:43:19 +0000
Message-ID: <20110302104319.GB22845@carfax.org.uk>
References: <28499638.308.1299004542529.JavaMail.root@zimbra>
 <1299004651-sup-1713@think>
 <4D6E0858.6030603@nsc.liu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Cc: Chris Mason <chris.mason@oracle.com>,
	Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Bellman <bellman@nsc.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6E0858.6030603@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 02, 2011 at 10:05:28AM +0100, Thomas Bellman wrote:
> On 2011-03-01 19:39, Chris Mason wrote:
> 
> > We'll have raid56, but it won't be variable stripe size.  There will be
> > one stripe size for data and one for metadata but that's it.
> 
> Will the stripe *width* be configurable?  If I have something like a
> Sun Thor with 48 drives, I would probably not be entirely comfortable
> having 46 drives data and 2 drives parity; too little redundancy for
> my tastes.  2 drives parity per 10 drives data is more like what I
> would run, but that would of course be an individual choice.

   It's something that's been asked for, but isn't supported by the
current (proposed) RAID-5/6 code, as far as I'm aware.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---      

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNbh9GIKyzvlFcI40RAsmzAKC49FWIpb7MvSsz5xbO6cdz0SYllgCg1f4C
RI8tiZ/syZNsOvP/69V2XJw=
=97SA
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
