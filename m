Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47102 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990AbbHIMr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 08:47:27 -0400
Date: Sun, 9 Aug 2015 12:47:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim MacBaine <jmacbaine@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid1 on uneven-sized disks
Message-ID: <20150809124725.GA5486@carfax.org.uk>
References: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 09, 2015 at 02:29:53PM +0200, Jim MacBaine wrote:
> Hi,
> 
> How does btrfs handle raid1 on a bunch of uneven sized disks? Can I
> just keep adding arbitrarily sized disks to an existing raid1 and
> expect the file system to continue to keep two copies of everything,
> so I could survive the loss of any single disk without data loss? Does
> btrfs work this way?

   Yes, exactly.

   You may find that http://carfax.org.uk/btrfs-usage/ is helpful.

   Hugo.

> For backing up several machines at home, I use an old Debian machine
> which is equipped with some spare disks I could get my hands on.
> Currently that would be 2 x 2TB, 1 x 1.5TB , 3 x 1TB disks.
> 
> Traditionally I'm using rsync to create hardlinked backups on ext3/4
> on md-raid1. This setup has been working reliably for many years now,
> including the survival of two disk failures. But it is quite
> cumbersome to reshape the structure of the raids when I get a new
> disk, an old one fails, or space requirements change. A single btrfs
> with snapshots would be much easier to handle. I'm not aiming for
> absolute reliability here -- all the really important stuff is backed
> up in a third place as well. But I would rather not like my file
> system to be the weakest link in the backup chain.
> 
> Regards,
> Jim

-- 
Hugo Mills             | Guards! Help! We're being rescued!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                       The Stainless Steel Rat Forever

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVx0vdAAoJEFheFHXiqx3kY+wP/jTRZsjuPhcAoXH8+e+d1nGR
7/Js3+LKZjYKhqEuu2P516IrF+iJXAd0t+ZWXqyfrCOvA6Wmw0+Zs1hmpniE5hal
6Ks1nLPkclDb5p5MSR3bBj0sLAjwinaeYrjxi2mOtW71nIzckK6fm3R4WvpXO14q
FJl5DkHhXYBgm5gd7iK440PMcEZsCXbnSOO24V8haIHtAdyteX6d+39sSkBYJtVP
OHCYBD8VUFaQjuDbrdKsF/gu0sItC5xmZYUO13aMk2UB4SHDEp79tqraTcAqpIvq
b4ENkFYxlbHUcTYipeRuFWRL6E3zmqniH2PuT8kRG9WRSdn6CW57/oRKNWMxtulS
lnMI/yr0gZw/GUH4srn5480wCM/NqRjmOJYhEiNwa8ChrZTIF/NxFMtvvh7i6xt6
qVf0/0gqfSbGCWiwhQi4oKvrdWV1LcWXglNAvKof4ZqOoonTmLhs/lqvcITEmdPY
2uLJKzlguabtAP8rZsm+lwaf0g2CB9LT+Ih319XUZgoWKUjdJN1LK3XkjIFo/tjr
uttDE35+b17zlXmil9CYacfSBmYH40Gmb6KOST6SmSGngq/DoQmEjxTWkF+uOxOm
2uOLMzCsGDBBBEgcNAsQLrJO+yu7k9sUpvSunJMC6XK3o23qcIfsvspnUeVlUX72
c+cktw+pPOTJ3bpaYljk
=8CVP
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
