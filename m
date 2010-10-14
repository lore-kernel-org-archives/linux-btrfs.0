From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Metadata size
Date: Thu, 14 Oct 2010 12:32:39 +0100
Message-ID: <20101014113239.GB2315@selene>
References: <20101014112058.GA2315@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101014112058.GA2315@selene>
List-ID: <linux-btrfs.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 14, 2010 at 12:20:58PM +0100, Hugo Mills wrote:
>    By my calculations, that's something on the order of 17.5K per
> filesystem object. This is mostly media files, plus some small
> metadata files. 17.5K on average seems very large to me. I have quite
> a bit of space on this system, so I'm not too concerned, but I wasn't
> sure if this kind of figure was representative or not.

   cwillu on IRC just answered this for me: it's mostly checksums.

   Also, it seems that this isn't representative. It's considerably
lower than normal. :)

   Question answered, all makes sense again.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Trouble rather the tiger in his lair than the sage amongst ---    
        his books for to you kingdoms and their armies are mighty        
        and enduring,  but to him they are but toys of the moment        
              to be overturned by the flicking of a finger.              

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMtupXIKyzvlFcI40RAgdkAJ0Xpkpg64art4l+4IxaJIVTgl2VCwCdEHnk
46FjHEmi3OgmHZpATGUPqyk=
=us4z
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
