From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP
 bug?
Date: Sun, 13 Feb 2011 16:31:42 +0000
Message-ID: <20110213163142.GA5484@carfax.org.uk>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Cc: btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 13, 2011 at 05:49:42PM +0200, Marti Raudsepp wrote:
> Hi list!
> 
> It seems I have found a serious regression in compressed btrfs in
> kernel 2.6.37. When creating a small file (less than the block size)
> and then cp/mv it to *another* file system, an appropriate number of
> zeroes gets written to the destination file. Case in point:

[snip]

> I'm currently running on 2.6.37, x86_64 using Arch Linux -testing with
> coreutils 8.10. Filesystem is mounted from LVM2 to /usr/src with -o
> noatime,compress
> 
> This only seems to occur with compressed file systems (either zlib or
> LZO). A person on IRC also reproduced the same problem in 2.6.28-rc.
> I'm pretty sure this used to work correctly around 2.6.35 or 2.6.36.

   This would seem to be the same effect that we've had reported on
IRC by at least two Gentoo users, of files full of zeroes in their
build system. We'll follow up with them over there and see if it's the
same bug.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I must be musical:  I've got *loads* of CDs ---           

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNWAdtIKyzvlFcI40RAh4EAKCFpHiqBlqrI9ypiD+H4c3PqN3HcwCgyKeV
vvKGo7n+pm2T6RIZcmzf17A=
=24mt
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
