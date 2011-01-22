From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Bug in mkfs.btrfs?!
Date: Sat, 22 Jan 2011 15:11:24 +0000
Message-ID: <20110122151124.GC29985@carfax.org.uk>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Cc: linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110122145222.GB2539@scooter>
List-ID: <linux-btrfs.vger.kernel.org>


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 22, 2011 at 03:52:22PM +0100, Felix Blanke wrote:
> I was able to create the fs with the --force options. But that bug should be fixed,
> too :)
> 
> Is that link maybe too long? It is created by udev, and there was never a problem
> using that link.

   Yes, it certainly looks like it. There's 63 characters in the name
in your strace report, so it looks like it's being truncated somewhere.

   What was the exact command line you used to get the error?

   Hugo.

> Regards,
> Felix
> 
> On 22. January 2011 - 15:45, Felix Blanke wrote:
> > Date: Sat, 22 Jan 2011 15:45:13 +0100
> > From: Felix Blanke <felixblanke@gmail.com>
> > To: linux-btrfs@vger.kernel.org
> > Subject: Bug in mkfs.btrfs?!
> > 
> > Hi,
> > 
> > I wanted to create a new btrfs fs for my backups.
> > When trying to mkfs.btrfs for that  device, I'm getting
> > 
> > "error checking /dev/loop2 mount status"
> > 
> > 
> > With strace I see where the problem is:
> > 
> > lstat("/dev/disk/by-id/ata-INTEL_SSDSA2M160G2GC_CVPO939201JX160AGN-par",
> > 0x7fffa30b3cf0) = -1 ENOENT (No such file or directory)
> > 
> > 
> > 
> > The problem is there is something missing at the end of the link, should be
> > something like "-part1", "-part2" etc.
> > 
> > 
> > I'll try the patch with the --foce option.
> > 
> > Regards,
> > Felix
> > 
> ---end quoted text---

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no. 9: Standard Deviation ---     

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOvOcIKyzvlFcI40RAvlQAJ9XapeMWZmVi/Hwb4odRtztG8dm8gCfTmay
j0+oRYPtyUuPDF7MaevPdXI=
=mFQm
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
