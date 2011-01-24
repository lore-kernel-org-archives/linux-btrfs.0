From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 14:34:48 +0000
Message-ID: <20110124143448.GC3403@carfax.org.uk>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
 <20110124131341.GA3403@carfax.org.uk>
 <20110124135305.GB7354@scooter>
 <20110124142936.GB3403@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Felix Blanke <felixblanke@gmail.com>, kreijack@inwind.it,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124142936.GB3403@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 24, 2011 at 02:29:36PM +0000, Hugo Mills wrote:
>    If, instead, the initial losetup call tracked the symlinks back to
> the original device node (i.e. something like "/dev/sdb3", or
> "/dev/mapper/ruthven-btest" in my example), then the name that's
> stored in the kernel would be shorter, and we'd be less likely to see
> the truncation. This is what my copy of losetup seems to be doing. I
> can't see any distribution-specific patches in the source for
> util-linux that would do this, though.

   Hmm... Just had a thought: is
/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-part3 on
your system a symlink or a device node? What does ls -l say?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNPY4HIKyzvlFcI40RAoIAAKCH3UobxPA9PLCLP5ghXpUsWXyspwCdHcyk
ohMSpB4XM/qNJpKveEZmjew=
=+f+E
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
