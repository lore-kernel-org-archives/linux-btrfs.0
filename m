Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58305 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdLIRnt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Dec 2017 12:43:49 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1eNjAC-0006xs-OC
        for linux-btrfs@vger.kernel.org; Sat, 09 Dec 2017 17:43:48 +0000
Date: Sat, 9 Dec 2017 17:43:48 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Odd behaviour of replace -- unknown resulting state
Message-ID: <20171209174348.GA26606@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   This is on 4.10, so there may have been fixes made to this since
then. If so, apologies for the noise.

   I had a filesystem on 6 devices with a badly failing drive in it
(/dev/sdi). I replaced the drive with a new one:

# btrfs replace start /dev/sdi /dev/sdj /media/video

   Once it had finished(*), I resized the device from 6 TB to 8 TB:

# btrfs fi resize 2:max /media/video

   I also removed another, smaller, device:

# btrfs dev del 7 /media/video

   Following this, btrfs fi show was reporting the correct device
size, but still the same device node in the filesystem:

Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
       Total devices 5 FS bytes used 9.15TiB
       devid    2 size 7.28TiB used 6.44TiB path /dev/sdi2
       devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
       devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
       devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
       devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2

   Note that device 2 definitely isn't /dev/sdi2, because /dev/sdi2
was on a 6 TB device, not an 8 TB device.

   Finally, I physically removed the two deleted devices from the
machine. The second device came out fine, but the first (/dev/sdi) has
now resulted in this from btrfs fi show:

Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
       Total devices 5 FS bytes used 9.15TiB
       devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
       devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
       devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
       devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2
       *** Some devices missing

   So, what's the *actual* current state of this filesystem? It's not
throwing write errors in the kernel logs from having a missing device,
so it seems like it's probably OK. However, the FS's idea of which
devices it's got seems to be confused.

   I suspect that if I reboot, it'll all be fine, but I'd be happier
if it hadn't got into this state in the first place.

   Is this bug fixed in later versions of the kernel? Can anyone think
of any issues I might have if I leave it in this state for a while?
Likewise, any issues I might have from a reboot? (Probably into 4.14)

   Hugo.

(*) as an aside, it was reporting over 300% complete when it finally
    completed. Not sure if that's been fixed since 4.10, either.
 
-- 
Hugo Mills             | Biphocles: Plato's optician
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaLCDUAAoJEFheFHXiqx3k9qkP/0RnIUAdu3FyTgkjSkY39qyV
8Y2YnQleF85DkS1BMzbQqSwIJodXU1JfkF/Wzoduk9mMtsTy+1cYH0daPzWGQ+7z
ZgFDk5N6+FiUQpW96lJSYLnF+eVgi9Mti9Rg+OVcxjPY7ImAKqcrzLkfw3ZojOis
zXMx1cK3A3ARgKCcEUNLHUZZysDKxFhwOQQoI0V3PVwG7kb+SGtlIf15L4baezxd
x0eO/Nn1qlpqKGDaGej5or7BN9jhj6TMzVihve/XYkySkc/rjd3phYtubGE2AjnR
CcwgF2vrt8PNcm+UeN+2JkueXLRgjmBWJnEDzV1XOPunVj95dncd8KVrHVevyMEo
YX5x3zipE9S+UPo/U9fekDWwGDeriVqu3CMig/jwZHYP8vdGh3BEMYxp8dIeKYGH
TXB8lIp3a2Ch6UyY8Pu8Wkm4Jo9JUdQ6M1YR59ptWtIM5yTUft0Pix5gAxTIXV+V
nIkQGmrX/TfQmloTPB4dAt1QK+oOtqGMadhNeErxOWwaKlRHUPz7xQG7tgV3DJz1
QO0ebvy52d9gZGEY+j3tAU+K98SF6F1sYsL6/QGP+x+22jQpENY/Isdez3CjE+BZ
eVdF7Ad17tOjYEh+9WcuFBLAYlHqOPK2Y8KQgoDJqMVO3BMXJ5tSiF2aWlY5fbem
HN4QFB3/zt46d6txlYi+
=koPd
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
