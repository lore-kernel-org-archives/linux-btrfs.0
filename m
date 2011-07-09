From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Raid root filesystem?
Date: Sat, 9 Jul 2011 09:45:35 +0100
Message-ID: <20110709084535.GG4325@carfax.org.uk>
References: <CAER78vQwkSv1-bgKSRN2_ULRN7fG5mJDf6ZNkBKxYyO_jjuNAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xoW37o/FfUZJwQG"
Cc: linux-btrfs@vger.kernel.org
To: Evert Vorster <evorster@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAER78vQwkSv1-bgKSRN2_ULRN7fG5mJDf6ZNkBKxYyO_jjuNAw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3xoW37o/FfUZJwQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 08, 2011 at 09:45:05PM -0700, Evert Vorster wrote:
> A year ago a btrfs raid needs to be scanned before it can be mounted.
> Is this still the case?
> 
> I would like to have a btrfs raid as root, but so far this was not
> possible due to the scanning thing, and thus I still need a /boot
> filesystem.

   It's perfectly possible, as far as I know. There's two solutions:
use an initrd that does the scan for you, or specify all of the
devices in the filesystem in the mount command (-o device=...). In
either case, you will need a boot manager that understands btrfs --
grub2 does, and (I think) syslinux.

> It would be awesome to be able to just boot a btrfs raid without the
> need for pesky partitions, as this would allow a system to be "grown"
> later when space gets scarce...

   You still need a partition for swap, of course.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       ---   __(_'>  Squeak!   ---                       

--3xoW37o/FfUZJwQG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOGBUvIKyzvlFcI40RAhMUAJ9gbbiu4pVGqXn6+x0uFtNXeFnS7gCcC7u6
Pl5yqWfYApzT4AMBsA+54+4=
=ZtIW
-----END PGP SIGNATURE-----

--3xoW37o/FfUZJwQG--
