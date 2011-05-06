From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 22:32:50 +0100
Message-ID: <20110506213250.GA12500@carfax.org.uk>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105061009.29756.CACook@quantum-sci.com>
 <20110506205137.29666.qmail@stuge.se>
 <201105061420.49077.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105061420.49077.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 06, 2011 at 02:20:48PM -0700, CACook@quantum-sci.com wrote:
> I'm tearing out BTRFS and using another filesystem.

   I think this is probably a good conclusion for you. I would
strongly suggest you pick something reliable (like ext3 or ext4) for
your future needs. Picking an experimental filesystem for your primary
usage on a mission-critical system is an idiosyncratic choice, to say
the least.

   I would also suggest keeping regular and tested backups, because if
you can't cope with losing all your data for the time it takes to
recreate it all, you _will_ need your backups at some point.

>  And rest assured, I'm warning others too.

   I'm sorry you feel the need to do this.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I hate housework. You make the beds, you wash the dishes, and ---  
           six months later you have to start all over again.            

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNxGkCIKyzvlFcI40RAhAzAKC2EMv24Q+PDhaCq5QTmWYqLLNApgCeJdD9
pobapoGiV/mLEhJ91op2pxI=
=MOwq
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
