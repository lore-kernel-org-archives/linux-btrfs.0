From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Filesystem not mountable after reset, bad tree block
Date: Sat, 7 Jan 2012 16:01:40 +0000
Message-ID: <20120107160140.GD12629@carfax.org.uk>
References: <201201052359.47932.harv@ruin.nu>
 <k0plt8-ljc.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Cc: linux-btrfs@vger.kernel.org
To: Kai Krakow <hurikhan77+btrfs@gmail.com>,
	Michael Andreen <harv@ruin.nu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <k0plt8-ljc.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 07, 2012 at 01:05:08PM +0100, Kai Krakow wrote:
> Hi!
> 
> Michael Andreen <harv@ruin.nu> schrieb:
> > The find-root program seems to think there is a root (and poentially some
> > older roots?), but not sure how to use that information.
> [...]
> > Anything else I can do to debug this or potentially recover a few bits
> > before reformatting?
> 
> You could try the recovery programs from Josefs btrfs-progs tree[1].

   You'll find what little documentation we have on the restore
program here:

   http://btrfs.ipv5.de/index.php?title=Restore

   With luck, you'll just need to run restore, but there's also a
little bit on how to read and use the output of find-root.

   Hugo.

> You 
> could also try using kernel 3.2 which allows mounting in recovery mode. This 
> mode tries to find an older tree root. But I think your kernel did not keep 
> tree root backups for this purpose as it is AFAIR a feature of later 
> kernels.
> 
> Better use a newer kernel - best use 3.2. There are bunch of fixes which 
> improve the situation with lost file systems after unexpected reboots or 
> power outages.
> 
> HTH
> Kai
> 
> [1] https://github.com/josefbacik/btrfs-progs
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPCGxjIKyzvlFcI40RAjZYAJ95er14gHHY0Vc/BqmsLcoewqx6qQCeKM6l
XHtqvyznL8MByw2aLvtKmZA=
=+uMb
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
