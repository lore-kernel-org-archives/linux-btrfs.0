Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45751 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBGKUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 05:20:36 -0500
Date: Fri, 7 Feb 2014 10:20:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140207102010.GE6490@carfax.org.uk>
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
 <20140206194935.GT1364@twin.jikos.cz>
 <52F3EC15.1000508@libero.it>
 <20140206220535.GV1364@suse.cz>
 <52F4B0B8.2080804@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
In-Reply-To: <52F4B0B8.2080804@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 06:08:56PM +0800, Anand Jain wrote:
> 
> 
>  Thanks for the comments.
> 
>  mainly here sysfs way defeats the purpose - debug as
>  mentioned. Sysfs would/should show only mounted disks,

   So let's find a way of showing the "known-about" data structure
separately from the "mounted" data structure. Just thinking aloud
here, how about something like this:

For unmounted, but known filesystems:
/sys/fs/btrfs/devmap/<UUID>/<symlink to device>   (for each device known)
/sys/fs/btrfs/devmap/<UUID>/label
/sys/fs/btrfs/devmap/<UUID>/complete      (0 if missing devices, 1 otherwise)
/sys/fs/btrfs/devmap/<UUID>/<other properties>

And then for mounted filesystems, we can populate the <other
properties> with more details as appropriate (and remove them when
unmounted again). We can also add a symlink to the <UUID> directory
for the filesystem to e.g.:

/sys/fs/btrfs/mounted/<symlink to UUID>

   If truly the *only* reason to do this is debug, then simply dump
the info in debugfs and have done with it. However, there are good
reasons to want to have this information in an ordinary running
system, too. So stick with sysfs, IMO.

>  the ioctl way doesn't have such a limitation (of course
>  as I commented memory dump way would have been best choice
>  but I got stuck with that approach if anybody wants to give
>  a try with that approach you are most welcome).
> 
>  IMO no harm to have both sysfs way and ioctl way let user
>  or developer use which were is suitable in their context.

   Extra maintenance overhead; divergence of the APIs. "You can find
out the label of the filesystem using sysfs, but not the ioctl. You
can find out the size of the filesystem using the ioctl, but not using
sysfs." That way lies quite a bit of pain for the user of the
interfaces.

   Hugo.

> Thanks, Anand
> 
> 
> On 02/07/2014 06:05 AM, David Sterba wrote:
> >On Thu, Feb 06, 2014 at 09:09:57PM +0100, Goffredo Baroncelli wrote:
> >>>With 3.14 the sysfs interface is available, but the devices under
> >>>  /sys/fs/btrfs/<fs-uuid>/devices/...
> >>>are symlinks to the sysfs devices, so this btrfs-specific device
> >>>information has to be located in a separate directory.
> >>
> >>yes please; it would scale better than the ioctl()s; anyway I suggest 1
> >>file per property, and not "...one file that holds all the stats
> >>  about the device"
> >
> >Well, we can do both, I don't have a preference and both make sense.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 4: Future Perfect ---       

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvSzWVheFHXiqx3kAQKRJw/+Ix81hF4PG2aF7R1P0D0WlMrGQOz5Oka0
hqBM1eLTvNXWJYiQ6SMq4uIMB7h0qpnwL6dw1eBdl5tBJzUmYYGwLiIShMFVvg1T
fZ8tgfJA7HTp3ELSewUhrxr9cd5tLB+ta2bn7NpP/r+O5eO+jdN32TdTCgdWfw0c
VlMVkbhe5T3fsZLBMllDQdjR0spq7MqXG+lpU/1qklzYRc35FES+L/aDnmr86tCw
HnVOehcrEI7F5P9OxPBS+V1c2Xyr9Q5BAj4RSgOKtUnVyVChEPh0+B6miIbY6n5O
KJ1O2pAUJJ7y3Pktqg3fgWGOEIMHYA80MXwpJdSxO5LUp22MHk10FOyolWV1UfPT
t16xAWG1JeLCoErRGqSOo8PgrgNYk9SRYiG3ErmGe23MOFez1X+WvzUbldUPzvFe
y+A3ihYX75aSGGU6y8z6hourWoYMBJ2L6y6y7JIWWbtpdRDKVBLwDGJsHVmyV02C
Wgt9zLZw6c9t/9tf5pyIYAQLwyv5yIYjBC0tibnx+zzi4rzlWsJKw6obB7kB/JVM
Fmxxmb0ghCIBuFXK+bWD98+OrWCr6eVYQWOiZsggDgDwOt/rh9OA5pZ5aOCTlY/E
bboccFr5g6YeLvjpCKxFz1j07Vc6N+o/uDsySKTYYMw7agUowfAqwWb7JysQgW5y
6+lL2iDcPIw=
=Udd3
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
