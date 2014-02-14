Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49116 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaBNK6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 05:58:39 -0500
Date: Fri, 14 Feb 2014 10:58:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Axelle <aafortinet@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recovering from hard disk failure in a pool
Message-ID: <20140214105817.GA6490@carfax.org.uk>
References: <CANKzOHBR6oYRrfDKtS-qh3JZ_LZTmUFwDtaAb7+N+A4MOTe-cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMHZerOf5PT7gmN5"
In-Reply-To: <CANKzOHBR6oYRrfDKtS-qh3JZ_LZTmUFwDtaAb7+N+A4MOTe-cg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pMHZerOf5PT7gmN5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 11:35:56AM +0100, Axelle wrote:
> Hi,
> I've just encountered a hard disk crash in one of my btrfs pools.
> 
> sudo btrfs filesystem show
> failed to open /dev/sr0: No medium found
> Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
>         Total devices 3 FS bytes used 112.70GB
>         devid    1 size 100.61GB used 89.26GB path /dev/sdc6
>         devid    2 size 93.13GB used 84.00GB path /dev/sdc1
>         *** Some devices missing
> 
> The device which is missing is /dev/sdb. I have replaced it with a new
> hard disk. How do I add it back to the volume and fix the device
> missing?
> The pool is expected to mount to /samples (it is not mounted yet).
> 
> I tried this - which fails:
> sudo btrfs device add /dev/sdb /samples
> ERROR: error adding the device '/dev/sdb' - Inappropriate ioctl for device
> 
> Why isn't this working?

   Because it's not mounted. :)

> I also tried this:
> sudo mount -o recovery /dev/sdc1 /samples
> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> same with /dev/sdc6

   Close, but what you want here is: 

mount -o degraded /dev/sdc1 /samples

not "recovery". That will tell the FS that there's a missing disk, and
it should mount without complaining. If your data is not RAID-1 or
RAID-10, then you will almost certainly have lost some data.

   At that point, since you've removed the dead disk, you can do:

btrfs device delete missing /samples

which forcibly removes the record of the missing device.

   Then you can add the new device:

btrfs device add /dev/sdb /samples

   And finally balance to repair the RAID:

btrfs balance start /samples

   It's worth noting that even if you have RAID-1 data and metadata,
losing /dev/sdc in your current configuration is likely to cause
severe data loss -- probably making the whole FS unrecoverable. This
is because the FS sees /dev/sdc1 and /dev/sdc6 as independent devices,
and will happily put both copies of a piece of RAID-1 data (or
metadata) on /dev/sdc -- one on each of sdc1 and sdc6. I therefore
wouldn't recommend running like that for very long.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- All hope abandon,  Ye who press Enter here. ---           

--pMHZerOf5PT7gmN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv32yFheFHXiqx3kAQJcyhAArw9ger14yQir+2TdwChulRaH8JY4S2iU
cXROeR8Sk90MqALV7i9+2m9TT1mpy9DhF/h1LyeMwih2FLHPlgMW6cSIe4v5nQUL
mg5YW8GewI24UXdavxtQ1dIS2LuhJhHrFzpnF9DyDn1Zm9F57/uKeK3pBp88btiK
XVv1gUUDTjHVuPlMWw5r/aSYKrbM6+8OhsWRDwNCN7zuZnNysFZEB+XH6Wobadyi
uc293MFWfLfzjSmNmJzB5jdi4g3lCZx0g2t2NdVNVuRRZx1/NiRIlpRgPLKMVnzj
WXFuYVkT8cY+jZxqRj6ozYWjgjRFD4Op+L837XAu8MBiiPhQXxchEfGERvVp6Aaz
nTmC3Po1x6+WKPoJfIj7axXPFh10CpBkVr7T0ffIlqqnbJuVxhWa6/AyAjp0wqeN
bm4NYLgBp7pmFe0hXOsLT8WQuw63vHHpFyCte/t4FnuajgwRiasdOaioIT7Xjc/J
kCE9Z6aELAygZaePWDbB6layfcaxw/tYD53Bg8/CJiCXASBrX7Kdz448tv2H6CpD
KYJaGSCkX51/vTHS41LNp6TCuANXl5g1jZUplZm1NKCGXjgmGl+8CrG+CzLH8T0p
Pci1yJwgFLDzHeV92oiJ0AvKaSvRRpuH3PA+4bhmDJFLzGosRSeQhU5XRqxqXPiZ
uao6bhndNRA=
=Mg9o
-----END PGP SIGNATURE-----

--pMHZerOf5PT7gmN5--
