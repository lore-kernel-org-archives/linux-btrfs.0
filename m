From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Mon, 6 Dec 2010 18:29:17 +0000
Message-ID: <20101206182917.GF4273@carfax.org.uk>
References: <20101206151804.GE4273@carfax.org.uk>
 <BbNS4yay1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbNS4yay1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 06, 2010 at 06:13:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 06.12.10:
> 
> >> How can I see that changing the kernel makes things better? It's
> >> more and more difficult to externalize (?) btrfs directories to
> >> other disks ...
> 
> >    Updating the kernel won't fix the problem I'm thinking of (sorry).
> > It will, however, fix the bug that stops the btrfs tool from
> > reporting what RAID levels you've got.
> 
> >    The problem I suspect you may have (because your symptoms seem to
> > be the same as mine) is that there are some circumstances where the
> > filesystem can change RAID levels pretty much arbitrarily. Running
> > "btrfs fi df" with a kernel that reports RAID levels will show
> > whether that's the case, as you'll have more than one RAID level
> > listed.

> Kernel 2.6.37-rc4:
> 
> # btrfs filesystem df /srv/MM
> Data, RAID0: total=2.39TB, used=2.37TB
> System, RAID1: total=8.00MB, used=188.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=4.25GB, used=3.51GB
> Metadata, DUP: total=1.00GB, used=2.33MB
> 
> Hope it helps!

   Yup. You've got what I've got(*). You have two different RAID types
for metadata, which shouldn't happen (but does, due to a bug).

   Hugo.

(*) My .sig fairy is clearly working overtime for appropriate
quotations. :)

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Charting the inexorable advance of Western syphilisation... ---   

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/St9IKyzvlFcI40RAqM7AKCWrekHEEmMFeidJMyoN99r2XgOagCgzakK
Abb+ipImO2BL2010AM+VFz4=
=ohMF
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
