From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v2 0/2] Balance management, kernel side
Date: Sun, 20 Mar 2011 11:37:51 +0000
Message-ID: <20110320113751.GF14946@carfax.org.uk>
References: <cover.1289522188.git.hugo@carfax.org.uk>
 <4D85C04A.2010907@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Cc: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D85C04A.2010907@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 20, 2011 at 09:52:26AM +0100, Andreas Philipp wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Since balancing takes a long time I liked the idea of having some
> progress counter and the ability to run this long lasting task in
> background with another option to cancel it if necessary. So I wanted
> to give it a try. Unfortunately, all the patches did not apply on top
> of kernel version 2.6.38. Is there a newer version of this patch or
> died this idea in the meantime? Of course, I will test any patches.

   Odd you should mention that, I'm just redoing my patch stack
against the latest btrfs-unstable...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- IMPROVE YOUR ORGANISMS!!  -- Subject line of spam email ---     

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNhecPIKyzvlFcI40RAnGrAJ4lY+QV3dWaFzU8hffrCA/ktUeAbwCgz2ZZ
OSqGpzPvCpvSAzXrLHvd9b0=
=mVtQ
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--
