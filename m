From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: combining 2 RAID 10 pools to one filesystem
Date: Wed, 16 Feb 2011 22:33:49 +0000
Message-ID: <20110216223349.GE5484@carfax.org.uk>
References: <4D5C38B1.70202@torus.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Gal Buki <buki@torus.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5C38B1.70202@torus.ch>
List-ID: <linux-btrfs.vger.kernel.org>


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 16, 2011 at 10:50:57PM +0200, Gal Buki wrote:
> I have RAID 10 using 4 times 500GB drives (1TB of storage).
> Is it possible to create another RAID 10 with 4 times 250GB drives
> (500GB of storage) and then combine those two RAIDs to one file
> system so that I would be able to get 1.5TB?
> 
> If I create one RAID 10 with all 8 drives I would only be able to
> use 8 times 250GB /2 = 1TB, right?

   No, just add the new drives to the existing btrfs pool, and run a
balance, and you should get a btrfs filesystem with 1.5TB of
mirrored/striped storage.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Anyone who claims their cryptographic protocol is secure is ---   
         either a genius or a fool.  Given the genius/fool ratio         
                 for our species,  the odds aren't good.                 

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNXFDNIKyzvlFcI40RAoS7AJ4o9L3RAX2tBxBr/JW0HCJAt19CUwCgpA3X
EzQtQkY8PbhnIEE/p8+4fW8=
=1W0v
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
