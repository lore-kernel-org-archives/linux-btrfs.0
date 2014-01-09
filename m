Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39950 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaAIKmu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jan 2014 05:42:50 -0500
Date: Thu, 9 Jan 2014 10:42:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140109104247.GH15634@carfax.org.uk>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5GLnnZ8mDMEwH4V"
In-Reply-To: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--e5GLnnZ8mDMEwH4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 11:26:26AM +0100, Clemens Eisserer wrote:
> Hi,
> 
> I am running write-intensive (well sort of, one write every 10s)
> workloads on cheap flash media which proved to be horribly unreliable.
> A 32GB microSDHC card reported bad blocks after 4 days, while a usb
> pen drive returns bogus data without any warning at all.
> 
> So I wonder, how would btrfs behave in raid1 on two such devices?
> Would it simply mark bad blocks as "bad" and continue to be
> operational, or will it bail out when some block can not be
> read/written anymore on one of the two devices?

   If a block is read and fails its checksum, then the other copy (in
RAID-1) is checked and used if it's good. The bad copy is rewritten to
use the good data.

   If the block is bad such that writing to it won't fix it, then
there's probably two cases: the device returns an IO error, in which
case I suspect (but can't be sure) that the FS will go read-only. Or
the device silently fails the write and claims success, in which case
you're back to the situation above of the block failing its checksum.

   There's no marking of bad blocks right now, and I don't know of
anyone working on the feature, so the FS will probably keep going back
to the bad blocks as it makes CoW copies for modification.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Trouble rather the tiger in his lair than the sage amongst ---    
        his books for to you kingdoms and their armies are mighty        
        and enduring,  but to him they are but toys of the moment        
              to be overturned by the flicking of a finger.              

--e5GLnnZ8mDMEwH4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUs59J1heFHXiqx3kAQLuJBAAoJ9g5oqyE2qrq+kvLDJSH2jtJyKAx2He
5wF2ktDhHvq81d1tVT5OLnWH4G58qFGFk2zAx+9JvExJJ4ov/otQYjiNCRWHuU6u
wLkAWZHtybM+cDzjDTfzklzKX3MYtJN5VT5GjxltEi1UcXYcAs3M6UUtMjoJ9Bah
KCN9m/X1GwgEo2zQISb92M9ByUw2IPLGx0AJ9jvmlPv8AQfcthAhNYSnspwo+xWt
0rNRd1MDzzKaCJl0ymKoFnFUboPijyRm5vgOFfF81hCoXD32je88O1vsEj9boBKu
l2c8E6srv7jY40yu9LnP5GZVeHPSNTEBcBBDbELc1Sqh2hJqXsoX7OQepDWAHjJs
Cbn52M32mMAuk2fa/RxA7/kxtRtMBODfMx69CP8tUPag+jqZJHLyS6nu9Pf0lHMH
uFmjWiOFdmCvOv5iTmUUrORyzqYzz8jK3AlMl6AReERS7uXWAyYg4lG5riGqbf3u
GoV251nSUGOBNJ66bwPuexZ3ZqfFLTRAEb2Lvon1GJZBI12BglZ6Obuxif/+6TbM
1pU1lXaOEu4WedHnoNNiSwDDeu+I+tVdwSLHXiYOzGltrsX/gSmrovwkbgpLB8jn
9zPD+NgIZ/338BlRmzzp36uQG7rswwVE/b3TX3Bl/+MziapnotJY48K4LfrGaKZA
uBzOE3I1yvw=
=1onn
-----END PGP SIGNATURE-----

--e5GLnnZ8mDMEwH4V--
