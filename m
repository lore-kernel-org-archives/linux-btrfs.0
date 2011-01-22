From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Bug in mkfs.btrfs?!
Date: Sat, 22 Jan 2011 15:45:03 +0000
Message-ID: <20110122154502.GD29985@carfax.org.uk>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Felix Blanke <felixblanke@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110122151124.GC29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 22, 2011 at 03:11:24PM +0000, Hugo Mills wrote:
> On Sat, Jan 22, 2011 at 03:52:22PM +0100, Felix Blanke wrote:
> > I was able to create the fs with the --force options. But that bug should be fixed,
> > too :)
> > 
> > Is that link maybe too long? It is created by udev, and there was never a problem
> > using that link.
> 
>    Yes, it certainly looks like it. There's 63 characters in the name
> in your strace report, so it looks like it's being truncated somewhere.
> 
>    What was the exact command line you used to get the error?

   Also, can you post the full strace output? (Just so I can get a
better idea of where it's getting to in the code).

   I've just tried it myself:

$ sudo mkfs.btrfs /dev/disk/by-id/dm-uuid-LVM-XRQLHQNa0xEeIZL4ofuBGIcfkr1Dhry8YHhkjaw4bvZA4meDFQfEMy5elIsVNeWl 

WARNING! - Btrfs v0.19-36-g70c6c10 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/disk/by-id/dm-uuid-LVM-XRQLHQNa0xEeIZL4ofuBGIcfkr1Dhry8YHhkjaw4bvZA4meDFQfEMy5elIsVNeWl
	nodesize 4096 leafsize 4096 sectorsize 4096 size 1.00GB
Btrfs v0.19-36-g70c6c10

   Seems perfectly happy with a 92-character device name...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no. 9: Standard Deviation ---     

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOvt+IKyzvlFcI40RAh9VAJ0T+dpg8cf2A0UR6+emrEzZfEMsXACgm7Xj
sL96hJy+wxOiSpu3jdwYHTo=
=rBFO
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
